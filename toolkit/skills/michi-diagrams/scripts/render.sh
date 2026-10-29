#!/usr/bin/env bash
# Render a Mermaid file the way GitHub light and dark mode would show it.
#
#   scripts/render.sh diagram.mmd [outdir]
#
# Writes <outdir>/<name>.light.png and <outdir>/<name>.dark.png.
# Exits non-zero if either render fails, printing mmdc's error.
# Uses mmdc from PATH if present, otherwise runs @mermaid-js/mermaid-cli through npx
# (Node 22.13 or later; the first run downloads the package and a headless browser).
set -u

MERMAID_CLI="@mermaid-js/mermaid-cli@12.0.0"

in="${1:-}"
if [[ -z "$in" || ! -f "$in" ]]; then
  echo "usage: $0 diagram.mmd [outdir]" >&2
  exit 2
fi
outdir="${2:-$(dirname "$in")}"
mkdir -p "$outdir"
name="$(basename "${in%.*}")"

if command -v mmdc >/dev/null 2>&1; then
  mmdc_cmd=(mmdc)
elif command -v npx >/dev/null 2>&1; then
  mmdc_cmd=(npx -y -p "$MERMAID_CLI" mmdc)
else
  echo "Neither mmdc nor npx found. Install Node 22.13 or later, or say 'syntax reviewed' rather than 'rendered' in your report." >&2
  exit 3
fi

# Refuse the things the skill forbids, before rendering.
if grep -qE '%%\{ *init|^---$' "$in"; then
  echo "refusing: $in contains an %%{init}%% directive or config frontmatter (not portable to GitHub/IDE renderers)" >&2
  exit 4
fi
if grep -qiE 'elk' "$in"; then
  echo "refusing: $in references the ELK layout (GitHub does not ship it)" >&2
  exit 4
fi
if grep -E '^\s*classDef' "$in" | grep -vq 'color:'; then
  echo "warning: a classDef in $in has no color: — text will follow the host theme in dark mode" >&2
fi

tmpcfg="$(mktemp)"
printf '{"theme":"dark"}' > "$tmpcfg"
trap 'rm -f "$tmpcfg"' EXIT

status=0
if "${mmdc_cmd[@]}" -q -i "$in" -o "$outdir/$name.light.png" -b white -s 2 2>"$outdir/$name.light.err"; then
  rm -f "$outdir/$name.light.err"
  echo "$outdir/$name.light.png"
else
  echo "light render FAILED:" >&2; cat "$outdir/$name.light.err" >&2; status=1
fi
if "${mmdc_cmd[@]}" -q -i "$in" -o "$outdir/$name.dark.png" -b '#0d1117' -s 2 -c "$tmpcfg" 2>"$outdir/$name.dark.err"; then
  rm -f "$outdir/$name.dark.err"
  echo "$outdir/$name.dark.png"
else
  echo "dark render FAILED:" >&2; cat "$outdir/$name.dark.err" >&2; status=1
fi
exit $status
