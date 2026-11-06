#!/usr/bin/env bash
#
# build-pdf.sh — build a PDF from a Starlight docs site using a recipe.
#
# Usage:
#   build-pdf.sh <site-dir> <size>
#   build-pdf.sh --pre-flight
#   build-pdf.sh <site-dir> <size> --pre-flight-only
#
# The recipe lives at <site-dir>/pdf-recipe.yaml. The michi-docs-site skill writes it, starting
# from its templates/pdf-recipe.yaml. The vendored assets live in pdf-assets/ next to this script.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ASSETS="$SCRIPT_DIR/pdf-assets"

# Pandoc searches multiple template paths. Locate eisvogel in whichever one has it.
find_eisvogel() {
  local candidates=(
    "$HOME/.local/share/pandoc/templates/eisvogel.latex"
    "$HOME/.pandoc/templates/eisvogel.latex"
  )
  for path in "${candidates[@]}"; do
    if [[ -f "$path" ]]; then
      echo "$path"
      return 0
    fi
  done
  return 1
}

# --------------------------------------------------------------------------
# Pre-flight
# --------------------------------------------------------------------------

check_tool() {
  local name="$1" hint="$2"
  if command -v "$name" >/dev/null 2>&1; then
    printf '  \033[32m✓\033[0m %s\n' "$name"
    return 0
  fi
  printf '  \033[31m✗\033[0m %s — %s\n' "$name" "$hint"
  return 1
}

check_file() {
  local path="$1" label="$2" hint="$3"
  if [[ -f "$path" ]]; then
    printf '  \033[32m✓\033[0m %s\n' "$label"
    return 0
  fi
  printf '  \033[31m✗\033[0m %s — %s\n' "$label" "$hint"
  return 1
}

# Validate the full LaTeX toolchain by compiling a minimal document through our
# real header.tex + eisvogel template. Catches missing LaTeX packages (framed,
# mdframed, etc.) up front, by name, instead of dying mid-build.
check_latex_compile() {
  local tmpdir
  tmpdir="$(mktemp -d)"
  local sample="$tmpdir/sample.md"
  cat > "$sample" <<'EOF'
---
title: pre-flight
---

# Smoke

Plain paragraph. No callouts — header.tex just needs to load cleanly.
EOF
  local log="$tmpdir/pandoc.log"
  if pandoc "$sample" \
      --from=markdown \
      --template eisvogel \
      --pdf-engine=xelatex \
      -V titlepage=false \
      -V classoption=oneside \
      --lua-filter="$ASSETS/callouts.lua" \
      --include-in-header="$ASSETS/header.tex" \
      -o "$tmpdir/sample.pdf" >"$log" 2>&1; then
    printf '  \033[32m✓\033[0m LaTeX compile (header.tex + eisvogel)\n'
    rm -rf "$tmpdir"
    return 0
  fi

  printf '  \033[31m✗\033[0m LaTeX compile — pandoc/xelatex errored\n'
  # Extract missing-package hints from the log
  local missing
  missing="$(grep -Eo "File \`[^']+\\.sty' not found" "$log" | sed -E "s/File \\\`(.+)\\.sty' not found/\\1/" | sort -u || true)"
  if [[ -n "$missing" ]]; then
    echo "    Missing LaTeX packages:" >&2
    while IFS= read -r pkg; do
      printf '      - %s\n' "$pkg" >&2
    done <<< "$missing"
    local pkgs
    pkgs="$(echo "$missing" | tr '\n' ' ')"
    printf '    Install: sudo tlmgr install %s\n' "$pkgs" >&2
    echo "    Or install the full collection: sudo tlmgr install collection-latexextra" >&2
  else
    echo "    (no missing-package hint found; see log below)" >&2
    tail -20 "$log" | sed 's/^/      /' >&2
  fi
  rm -rf "$tmpdir"
  return 1
}

pre_flight() {
  local failed=0
  echo "Pre-flight check:"

  check_tool pandoc  "install: brew install pandoc"            || failed=1
  check_tool xelatex "install: brew install --cask mactex"     || failed=1
  check_tool qpdf    "install: brew install qpdf"              || failed=1
  check_tool yq      "install: brew install yq"                || failed=1

  check_file "$ASSETS/callouts.lua"          "pdf-assets/callouts.lua"          "missing vendored asset" || failed=1
  check_file "$ASSETS/header.tex"            "pdf-assets/header.tex"            "missing vendored asset" || failed=1
  check_file "$ASSETS/before-body.tex.tmpl"  "pdf-assets/before-body.tex.tmpl"  "missing vendored asset" || failed=1

  if eisvogel_path="$(find_eisvogel)"; then
    printf '  \033[32m✓\033[0m eisvogel template (%s)\n' "$eisvogel_path"
  else
    printf '  \033[31m✗\033[0m eisvogel template — install: mkdir -p ~/.local/share/pandoc/templates && curl -L https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.latex -o ~/.local/share/pandoc/templates/eisvogel.latex\n'
    failed=1
  fi

  # Only run the LaTeX compile check if the prerequisites are in place.
  # Otherwise the compile check will just produce a confusing cascade.
  if [[ $failed -eq 0 ]]; then
    check_latex_compile || failed=1
  else
    printf '  \033[33m-\033[0m LaTeX compile (skipped — prerequisites missing)\n'
  fi

  if [[ $failed -eq 0 ]]; then
    echo "All pre-flight checks passed."
    return 0
  fi
  echo ""
  echo "Pre-flight failed. Install missing tools and re-run." >&2
  return 1
}

# --------------------------------------------------------------------------
# Recipe parsing helpers (via yq)
# --------------------------------------------------------------------------

recipe_get() {
  yq -r "$1" "$RECIPE"
}

recipe_sections_count() {
  yq -r ".sizes.${SIZE}.sections | length" "$RECIPE"
}

recipe_section_label() {
  yq -r ".sizes.${SIZE}.sections[$1].label" "$RECIPE"
}

recipe_section_pages() {
  yq -r ".sizes.${SIZE}.sections[$1].pages[]" "$RECIPE"
}

# --------------------------------------------------------------------------
# Markdown transforms
# --------------------------------------------------------------------------

# Strip YAML frontmatter and promote title to H1 (well, H2 since sections become H1).
# Then shift any existing markdown headings down one level. Respects fenced code blocks.
transform_page() {
  local file="$1"
  awk '
    BEGIN { in_front = 0; title = ""; printed_title = 0; in_code = 0 }
    NR == 1 && $0 == "---" { in_front = 1; next }
    in_front && $0 == "---" { in_front = 0; next }
    in_front {
      if (title == "" && $0 ~ /^title:[[:space:]]*/) {
        line = $0
        sub(/^title:[[:space:]]*/, "", line)
        # Strip surrounding single or double quotes
        if (line ~ /^".*"$/ || line ~ /^\x27.*\x27$/) {
          line = substr(line, 2, length(line) - 2)
        }
        title = line
      }
      next
    }
    {
      if (!printed_title && title != "") {
        print "## " title
        print ""
        printed_title = 1
      }
      if ($0 ~ /^```/) { in_code = 1 - in_code }
      if (!in_code && $0 ~ /^#/) { sub(/^#/, "##") }
      print
    }
  ' "$file"
}

# --------------------------------------------------------------------------
# Build
# --------------------------------------------------------------------------

build() {
  local site_dir="$1" size="$2"
  RECIPE="$site_dir/pdf-recipe.yaml"
  SIZE="$size"

  if [[ ! -f "$RECIPE" ]]; then
    echo "error: no recipe at $RECIPE" >&2
    echo "Run: /michi-docs-site pdf $site_dir   (to generate one)" >&2
    exit 1
  fi

  # Validate size exists in recipe
  if [[ "$(yq -r ".sizes.${SIZE} // \"\"" "$RECIPE")" == "" ]]; then
    echo "error: size '$SIZE' not defined in $RECIPE" >&2
    echo "Available sizes: $(yq -r '.sizes | keys | join(", ")' "$RECIPE")" >&2
    exit 1
  fi

  local title subtitle content_root output_dir output_name frontmatter_mode
  title="$(recipe_get '.title')"
  subtitle="$(recipe_get '.subtitle // ""')"
  content_root="$(recipe_get '.content_root')"
  output_dir="$(recipe_get '.output_dir')"
  output_name="$(recipe_get ".sizes.${SIZE}.output")"
  frontmatter_mode="$(recipe_get '.frontmatter // "strip-use-title-as-h1"')"

  local size_label
  size_label="$(recipe_get ".sizes.${SIZE}.label // \"${SIZE}\"")"

  local abs_content="$site_dir/$content_root"
  local abs_out_dir="$site_dir/$output_dir"
  local abs_out="$abs_out_dir/$output_name"
  mkdir -p "$abs_out_dir"

  # Build excluded slugs list
  local exclude_list
  exclude_list="$(yq -r '.exclude // [] | .[]' "$RECIPE" || true)"

  is_excluded() {
    local slug="$1"
    while IFS= read -r ex; do
      [[ -z "$ex" ]] && continue
      [[ "$slug" == "$ex" ]] && return 0
    done <<< "$exclude_list"
    return 1
  }

  # Assemble markdown
  local tmpdir
  tmpdir="$(mktemp -d)"
  trap '[[ -n "${tmpdir:-}" && -d "$tmpdir" ]] && rm -rf "$tmpdir"' EXIT
  local combined="$tmpdir/combined.md"
  : > "$combined"

  # Subtitle on the cover: "Size Label — Subtitle" so it's clear which variant this is.
  local cover_subtitle="$size_label"
  if [[ -n "$subtitle" ]]; then
    cover_subtitle="$cover_subtitle — $subtitle"
  fi

  # Before-body from template
  local before_body="$tmpdir/before-body.tex"
  sed -e "s|{{TITLE}}|$title|g" -e "s|{{SUBTITLE}}|$cover_subtitle|g" \
    "$ASSETS/before-body.tex.tmpl" > "$before_body"

  # Iterate sections
  local n_sections
  n_sections="$(recipe_sections_count)"
  local i=0
  local section_first=true
  local missing_pages=()

  while [[ $i -lt $n_sections ]]; do
    local section_label
    section_label="$(recipe_section_label "$i")"

    if [[ "$section_first" == "true" ]]; then
      section_first=false
    else
      printf '\n\\newpage\n\n' >> "$combined"
    fi
    printf '# %s\n\n' "$section_label" >> "$combined"

    local page_first=true
    while IFS= read -r slug; do
      [[ -z "$slug" ]] && continue
      if is_excluded "$slug"; then
        continue
      fi
      local page_path="$abs_content/${slug}.md"
      if [[ ! -f "$page_path" ]]; then
        # Try .mdx as a fallback — if it exists, still skip (we don't parse mdx) and warn
        if [[ -f "$abs_content/${slug}.mdx" ]]; then
          echo "warning: $slug is .mdx — skipping (add to exclude to silence)" >&2
        else
          missing_pages+=("$slug")
        fi
        continue
      fi

      if [[ "$page_first" == "true" ]]; then
        page_first=false
      else
        printf '\n\\newpage\n\n' >> "$combined"
      fi
      transform_page "$page_path" >> "$combined"
      printf '\n' >> "$combined"
    done < <(recipe_section_pages "$i")

    i=$((i + 1))
  done

  if [[ ${#missing_pages[@]} -gt 0 ]]; then
    echo "error: recipe references pages that don't exist:" >&2
    printf '  - %s\n' "${missing_pages[@]}" >&2
    echo "Run: /michi-docs-site pdf $site_dir   (to validate and fix)" >&2
    exit 1
  fi

  # Run pandoc
  echo "Building $abs_out (size: $SIZE)..."
  pandoc "$combined" \
    --from=markdown \
    --template eisvogel \
    --pdf-engine=xelatex \
    --toc \
    --toc-depth=3 \
    --syntax-highlighting=tango \
    -V titlepage=false \
    -V classoption=oneside \
    --lua-filter="$ASSETS/callouts.lua" \
    --include-in-header="$ASSETS/header.tex" \
    --include-before-body="$before_body" \
    -V colorlinks=true \
    -V linkcolor=NavyBlue \
    -V urlcolor=NavyBlue \
    -V hyperrefoptions=linktoc=all \
    -o "$abs_out"

  # Remove the blank first page that eisvogel generates
  qpdf "$abs_out" --pages . 2-z -- "$abs_out.stripped"
  mv "$abs_out.stripped" "$abs_out"

  echo "Built: $abs_out"
}

# --------------------------------------------------------------------------
# Arg parsing
# --------------------------------------------------------------------------

usage() {
  cat <<EOF
Usage:
  $(basename "$0") <site-dir> <size>           Build a PDF
  $(basename "$0") --pre-flight                Check toolchain only
  $(basename "$0") <site-dir> <size> --pre-flight-only
                                               Check toolchain and recipe, then exit

Examples:
  $(basename "$0") --pre-flight
  $(basename "$0") website S
  $(basename "$0") internal-site M

The recipe is read from <site-dir>/pdf-recipe.yaml.
EOF
}

main() {
  if [[ $# -eq 0 ]]; then
    usage >&2
    exit 1
  fi

  if [[ "$1" == "--pre-flight" ]]; then
    pre_flight
    exit $?
  fi

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
    exit 0
  fi

  if [[ $# -lt 2 ]]; then
    usage >&2
    exit 1
  fi

  local site_dir="$1"
  local size="$2"
  local pre_flight_only=false

  if [[ $# -ge 3 && "$3" == "--pre-flight-only" ]]; then
    pre_flight_only=true
  fi

  # Normalize relative site-dir against CWD, then verify it exists
  if [[ ! -d "$site_dir" ]]; then
    echo "error: site-dir not found: $site_dir" >&2
    exit 1
  fi
  site_dir="$(cd "$site_dir" && pwd)"

  # Always pre-flight first
  if ! pre_flight; then
    exit 1
  fi
  echo ""

  if [[ "$pre_flight_only" == "true" ]]; then
    exit 0
  fi

  build "$site_dir" "$size"
}

main "$@"
