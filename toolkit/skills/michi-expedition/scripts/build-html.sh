#!/usr/bin/env bash
# Build the HTML version of a library from its markdown.
#
#   scripts/build-html.sh [--config <file>] [--edition <name>] <library-dir> [project-name]
#
# Writes <library-dir>/html/: index.html (from tldr.md), one page per library markdown file
# (subfolders kept), one SVG per Mermaid diagram, and library.css. With --edition, it builds the
# edition described in <library-dir>/editions/<name>.conf into <library-dir>/editions/<name>/ instead
# (see "Editions" in references/project-templates.md), and, unless the edition is private, zips it.
# Navigation is by role: a tab per
# role across the top, and a sidebar with only the current role's pages, with a section for each part
# (subfolder). The roles, the documents, and the repo files the sidebar links to come from the config:
# project.conf (the default) for a project library, expedition.conf for an expedition's portraits. An
# optional <library>/library.conf adds the library's own documents (doc lines), and an optional
# sidebar-links file adds other repo files. The folder is regenerated from scratch on every run, so
# never edit it.
# Needs pandoc and git, and mmdc on PATH or Node 22.13+ for npx (the first npx run downloads a
# headless browser). project-name defaults to the repo folder's name.
set -euo pipefail

MERMAID_CLI="@mermaid-js/mermaid-cli@12.0.0"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  echo "usage: $0 [--config <file>] [--edition <name>] <library-dir> [project-name]" >&2
  exit 2
}

config="$SCRIPT_DIR/project.conf"
edition=""
while [[ "${1:-}" == --* ]]; do
  [[ $# -ge 2 ]] || usage
  case "$1" in
    --config) config="$2" ;;
    --edition) edition="$2" ;;
    *) usage ;;
  esac
  shift 2
done
library="${1:-}"
if [[ -z "$library" || ! -d "$library" || ! -f "$config" ]]; then
  usage
fi
# The name becomes a folder the build empties, so it may not be a path.
if [[ -n "$edition" && ! "$edition" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
  echo "An edition name is letters, digits, '.', '_' and '-', not '$edition'." >&2
  exit 2
fi
library="$(cd "$library" && pwd)"
repo_root="$(git -C "$library" rev-parse --show-toplevel)"
lib_rel="${library#"$repo_root"/}"
project="${2:-$(basename "$repo_root")}"
out_rel="$lib_rel/html"
[[ -n "$edition" ]] && out_rel="$lib_rel/editions/$edition"
out="$repo_root/$out_rel"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "pandoc not found on PATH." >&2
  exit 3
fi
if command -v mmdc >/dev/null 2>&1; then
  mmdc_cmd=(mmdc)
elif command -v npx >/dev/null 2>&1; then
  mmdc_cmd=(npx -y -p "$MERMAID_CLI" mmdc)
else
  echo "Neither mmdc nor npx found; diagrams can't be rendered. Install Node 22.13 or later." >&2
  exit 3
fi

work="$(mktemp -d)"
trap 'rm -r "$work"' EXIT

# --- The config (format in project.conf) ---

ROLES=()
role_lines=()
shared=()
entries=()
intro="project intro"

# A library's own library.conf adds documents beyond the templates (doc lines, for the config's
# roles, listed after the config's own documents) and records the library's roles (one roles line,
# which the build only checks).
read_config() {
  local file="$1" docs_only="${2:-}" kind a b c d role roles
  while IFS='|' read -r kind a b c d; do
    case "$kind" in "" | \#*) continue ;; esac
    if [[ -n "$docs_only" ]]; then
      case "$kind" in
        doc) roles="$c" ;;
        roles) roles="$a" ;;
        *) echo "$file: only doc and roles lines belong here, not '$kind'" >&2; exit 2 ;;
      esac
      for role in ${roles//,/ }; do
        [[ " ${ROLES[*]} " == *" $role "* ]] || { echo "$file: unknown role '$role'" >&2; exit 2; }
      done
    fi
    case "$kind" in
      role) ROLES+=("$a"); role_lines+=("$a|$b|$c") ;;
      roles) ;;
      intro) intro="$a" ;;
      shared) shared+=("$a|$b|$c") ;;
      doc | link | page) entries+=("$kind|$a|$b|$c|$d") ;;
      *) echo "$file: unknown entry '$kind'" >&2; exit 2 ;;
    esac
  done <"$file"
}

read_config "$config"
[[ -f "$library/library.conf" ]] && read_config "$library/library.conf" docs-only

# --- The edition (format in "Editions", references/project-templates.md) ---

visibility=private
edition_parts=""
edition_exclude=" "
allows=()
replaces=()
replaced_pages=""
errors=()

# A value from an edition file, without a trailing comment or surrounding spaces.
edition_value() {
  local value="${1%%#*}"
  value="${value#"${value%%[![:space:]]*}"}"
  echo "${value%"${value##*[![:space:]]}"}"
}

read_edition() {
  local file="$library/editions/$edition.conf" kind value roles=() role page term
  [[ -f "$file" ]] || { echo "No edition file: $file" >&2; exit 2; }
  while IFS='|' read -r kind value; do
    case "$kind" in "" | \#*) continue ;; esac
    case "$kind" in
      roles) value="$(edition_value "$value")"; read -ra roles <<<"${value//,/ }" ;;
      visibility) visibility="$(edition_value "$value")" ;;
      parts) value="$(edition_value "$value")"; edition_parts=" ${value//,/ } " ;;
      exclude) value="$(edition_value "$value")"; edition_exclude+="${value//,/ } " ;;
      allow)
        page="$(edition_value "${value%%|*}")"
        term="$(edition_value "${value#*|}")"
        [[ "$value" == *"|"* && -n "$page" && -n "$term" ]] || { echo "$file: allow is allow|<page>|<term>" >&2; exit 2; }
        allows+=("$page|$(lower "$term")")
        ;;
      replace)
        page="$(edition_value "${value%%|*}")"
        term="$(edition_value "${value#*|}")"
        [[ "$value" == *"|"* && -n "$page" && -n "$term" ]] || { echo "$file: replace is replace|<path>|<replacement>" >&2; exit 2; }
        replaces+=("$page|$term")
        ;;
      *) echo "$file: unknown entry '$kind'" >&2; exit 2 ;;
    esac
  done <"$file"
  [[ ${#roles[@]} -gt 0 ]] || { echo "$file: no roles line" >&2; exit 2; }
  for role in "${roles[@]}"; do
    [[ " ${ROLES[*]} " == *" $role "* ]] || { echo "$file: unknown role '$role'" >&2; exit 2; }
  done
  case "$visibility" in
    private | colleague | external) ;;
    *) echo "$file: visibility is private, colleague, or external, not '$visibility'" >&2; exit 2 ;;
  esac
  for role in "${ROLES[@]}"; do
    [[ " ${roles[*]} " == *" $role "* ]] || left_out_roles+="$role,"
  done
  all_roles="$(IFS=,; echo "${ROLES[*]}")"
  ROLES=("${roles[@]}")
}

lower() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

left_out_roles=""
all_roles=""
[[ -n "$edition" ]] && read_edition

# The titles of documents that belong only to left-out roles: naming one is a trace of the role.
# Separated by "|", which a title can't contain (it is the config's field separator).
left_out_titles() {
  local entry kind a b c d role kept
  [[ -n "$left_out_roles" ]] || return 0
  for entry in ${entries[@]+"${entries[@]}"}; do
    IFS='|' read -r kind a b c d <<<"$entry"
    [[ "$kind" == doc ]] || continue
    kept=""
    for role in ${c//,/ }; do
      [[ " ${ROLES[*]} " == *" $role "* ]] && kept=yes
    done
    [[ -z "$kept" ]] && printf '%s|' "$b"
  done
  return 0
}
left_out_titles="$(left_out_titles)"

is_bundled() {
  [[ -n "$edition" && "$visibility" != private ]]
}

part_in_edition() {
  [[ -z "$1" || -z "$edition_parts" || "$edition_parts" == *" $1 "* ]]
}

# A file the edition's exclude line names, by its library-relative or repo-relative path.
is_excluded() {
  [[ -n "$edition" && ( "$edition_exclude" == *" ${1#"$lib_rel"/} "* || "$edition_exclude" == *" $1 "* ) ]]
}

role_title() {
  local line
  for line in "${role_lines[@]}"; do
    [[ "${line%%|*}" == "$1" ]] && { cut -d'|' -f2 <<<"$line"; return; }
  done
  echo "$1"
}

role_blurb() {
  local line
  for line in "${role_lines[@]}"; do
    [[ "${line%%|*}" == "$1" ]] && { cut -d'|' -f3 <<<"$line"; return; }
  done
}

# A config path (relative to the library, or to the repo root with a leading "/") as a repo-relative path.
repo_path() {
  local dir rel
  if [[ "$1" == /* ]]; then
    echo "${1#/}"
    return
  fi
  dir="$(cd "$library/$(dirname "$1")" 2>/dev/null && pwd)" || return 0
  rel="${dir#"$repo_root"}"
  rel="${rel#/}"
  echo "${rel:+$rel/}$(basename "$1")"
}

# --- The page list: "source (repo-relative)|html (html-relative)|label|role|part|flag" ---
# role is one of the config's roles, shared (every role: the tl;dr and the glossary), or "More" for
# library files the config doesn't name. part is empty for the library-wide pages, or the subfolder
# name for a part's pages (library/<part>/). An html of "link" marks a repo file the sidebar links to
# as it is, without building a page. flag "alias" marks a page listed under a second role: it appears
# in that role's sidebar but is built, and paged, under its first role.

pages=()
known=" $(printf '%s\n' "${shared[@]}" | cut -d'|' -f1 | tr '\n' ' ') "
known+="$(printf '%s\n' "${entries[@]}" | awk -F'|' '$1 == "doc" {print $2}' | tr '\n' ' ')"

# The edition's replacement for a file (repo-relative), from its replace|<path>|<replacement> lines, in
# $replacement; each line that names a page the library has is recorded in $used_replaces.
used_replaces=" "
find_replacement() {
  local entry
  replacement=""
  for entry in ${replaces[@]+"${replaces[@]}"}; do
    if [[ "${entry%%|*}" == "$1" || "${entry%%|*}" == "${1#"$lib_rel"/}" ]]; then
      replacement="$lib_rel/${entry#*|}"
      used_replaces+="${entry%%|*} "
      return 0
    fi
  done
  return 0
}

# Adds a page unless its file is missing or, in an edition, its role, part, or file is left out. An
# edition's replacement is built in the file's place, under its name, and links to the file reach it.
add_page() {
  local src="$1" role="$4" part="${5:-}" replacement
  [[ -f "$repo_root/$src" ]] || return 0
  if [[ -n "$edition" ]]; then
    find_replacement "$src"
    [[ "$role" == shared || " ${ROLES[*]} " == *" $role "* ]] || return 0
    part_in_edition "$part" || return 0
    is_excluded "$src" && return 0
    if [[ -n "$replacement" ]]; then
      if [[ ! -f "$repo_root/$replacement" ]]; then
        errors+=("the replacement for $src, ${replacement#"$lib_rel"/}, doesn't exist")
        return 0
      fi
      [[ "$2" != link ]] && replaced_pages+="$src=$2,"
      src="$replacement"
    fi
  fi
  pages+=("$src|$2|$3|$role|$part|${6:-}")
  return 0
}

# A repo file the sidebar names: a link to the live file, or, in an edition without the repo, a page
# of its own under repo/ (markdown only). One listed for a role or part the edition leaves out is
# recorded in excluded_links: links to it are treated like links to a left-out library document.
excluded_links=""
add_repo_link() {
  local path="$1" label="$2" role="$3" part="${4:-}"
  if [[ -n "$edition" ]] && { ! [[ " ${ROLES[*]} " == *" $role "* ]] || ! part_in_edition "$part" || is_excluded "$path"; }; then
    find_replacement "$path"
    excluded_links+="$path,"
    return 0
  fi
  if ! is_bundled; then
    add_page "$path" link "$label" "$role" "$part"
    return 0
  fi
  if [[ "$path" != *.md ]]; then
    errors+=("$path is linked from the $role sidebar but isn't markdown, so the edition can't carry it")
    return 0
  fi
  add_page "$path" "repo/${path%.md}.html" "$label" "$role" "$part"
}

add_library_page() {
  add_page "$lib_rel/$1" "${3:-${1%.md}.html}" "$2" "$4" "${5:-}" "${6:-}"
}

page_title() {
  local title
  title="$(grep -m1 '^# ' "$1" | sed 's/^# //')"
  echo "${title:-$(basename "${1%.md}")}"
}

# The config's documents in <dir> (empty for the library's top level, which also takes the config's
# links and pages), then any other markdown files as "More".
# A document listed under several roles is built under the first role it is added for (in an
# edition, the first role the edition keeps); the others list it as an alias.
add_documents_in() {
  local dir="$1" prefix="${1:+$1/}" entry kind a b c d role rest flag rel count
  for entry in "${entries[@]}"; do
    IFS='|' read -r kind a b c d <<<"$entry"
    case "$kind" in
      doc)
        rest="$c,"
        flag=""
        while [[ -n "$rest" ]]; do
          role="${rest%%,*}"
          rest="${rest#*,}"
          count=${#pages[@]}
          add_library_page "$prefix$a" "$b" "" "$role" "$dir" "$flag"
          [[ ${#pages[@]} -gt $count ]] && flag=alias
        done
        ;;
      link)
        [[ -z "$dir" && ( -z "$d" || -f "$library/$d" ) ]] && add_repo_link "$(repo_path "$a")" "$b" "$c"
        ;;
      page)
        [[ -z "$dir" ]] && add_page "$(repo_path "$a")" "$b" "$c" "$d"
        ;;
    esac
  done
  while read -r rel; do
    [[ "$known" == *" $rel "* ]] && continue
    add_library_page "$prefix$rel" "$(page_title "$library/$prefix$rel")" "" "More" "$dir"
  done < <(cd "$library/$dir" && find . -maxdepth 1 -name '*.md' | sed 's|^\./||' | sort)
}

# Optional <library>/sidebar-links: "role|part|label|repo-relative path" per line, for repo files a
# role's sidebar links to as they are (a part's README as its reference, say).
add_sidebar_links() {
  local role part label path
  [[ -f "$library/sidebar-links" ]] || return 0
  while IFS='|' read -r role part label path; do
    [[ -z "$role" || "$role" == \#* ]] && continue
    if [[ ! -f "$repo_root/$path" ]]; then
      echo "sidebar-links: $path not found; skipped." >&2
      continue
    fi
    add_repo_link "$path" "$label" "$role" "$part"
  done <"$library/sidebar-links"
}

for entry in "${shared[@]}"; do
  IFS='|' read -r name label html <<<"$entry"
  add_library_page "$name" "$label" "$html" shared
done
add_documents_in ""
PARTS=()
while read -r part; do
  part_in_edition "$part" || continue
  PARTS+=("$part")
  add_documents_in "$part"
done < <(cd "$library" && find . -mindepth 1 -maxdepth 1 -type d -not -name html -not -name editions | sed 's|^\./||' | sort)
add_sidebar_links

# A replace line that names no page would let the unredacted original ship under a typo.
for entry in ${replaces[@]+"${replaces[@]}"}; do
  [[ "$used_replaces" == *" ${entry%%|*} "* ]] || errors+=("replace|${entry%%|*} matches no page in the library")
done

# page_map: the pages whose HTML name isn't their markdown name. edition_pages: in an edition,
# every page it builds, so that links to anything else can be told apart.
page_map=""
edition_pages=""
for entry in "${pages[@]}"; do
  IFS='|' read -r src html _ _ _ flag <<<"$entry"
  [[ "$html" == link || "$flag" == alias ]] && continue
  [[ "${src%.md}.html" != "$lib_rel/$html" ]] && page_map+="$src=$html,"
  edition_pages+="$src=$html,"
done
edition_pages+="$replaced_pages"
[[ -n "$edition" ]] || edition_pages=""

# --- Navigation ---

up_from() {
  local depth up=""
  depth="$(awk -F/ '{print NF-1}' <<<"$1")"
  for ((i = 0; i < depth; i++)); do up+="../"; done
  echo "$up"
}

field() {
  local f1 f2 f3 f4 f5 f6
  IFS='|' read -r f1 f2 f3 f4 f5 f6 <<<"$1"
  case "$2" in
    src) echo "$f1" ;; html) echo "$f2" ;; label) echo "$f3" ;; role) echo "$f4" ;; part) echo "$f5" ;; flag) echo "$f6" ;;
  esac
}

# A page built under this entry: not a link, not an alias.
is_built() {
  [[ "$(field "$1" html)" != link && "$(field "$1" flag)" != alias ]]
}

# The first built page of a role: its library-wide pages come first, then its parts in order.
first_page_of() {
  for entry in "${pages[@]}"; do
    if [[ "$(field "$entry" role)" == "$1" ]] && is_built "$entry"; then
      field "$entry" html
      return
    fi
  done
}

first_page_in() {
  local role="$1" part="$2"
  for entry in "${pages[@]}"; do
    if [[ "$(field "$entry" role)" == "$role" && "$(field "$entry" part)" == "$part" ]] && is_built "$entry"; then
      field "$entry" html
      return
    fi
  done
}

# One sidebar section: a heading and the role's pages in one part, or nothing if there are none.
# A part's section sits inside its role's: a smaller heading and indented pages.
nav_section() {
  local heading="$1" role="$2" part="$3" current="$4" up="$5" root_up="$6" entry links=""
  for entry in "${pages[@]}"; do
    [[ "$(field "$entry" role)" == "$role" && "$(field "$entry" part)" == "$part" ]] || continue
    links+="$(nav_link "$entry" "$current" "$up" "$root_up")"$'\n'
  done
  [[ -z "$links" ]] && return 0
  if [[ -n "$part" ]]; then
    echo "      <h3 class=\"part\">$heading</h3>"
    echo "      <ul class=\"part\">"
  else
    echo "      <h2>$heading</h2>"
    echo "      <ul>"
  fi
  printf '%s' "$links"
  echo "      </ul>"
}

nav_link() {
  local entry="$1" current="$2" up="$3" root_up="$4" src html label
  src="$(field "$entry" src)"; html="$(field "$entry" html)"; label="$(field "$entry" label)"
  if [[ "$html" == link ]]; then
    echo "        <li><a href=\"$root_up$src\">$label <small>($([[ "$src" == *.md ]] && echo markdown || echo file))</small></a></li>"
  elif [[ "$html" == "$current" ]]; then
    echo "        <li><a href=\"$up$html\" aria-current=\"page\">$label</a></li>"
  else
    echo "        <li><a href=\"$up$html\">$label</a></li>"
  fi
}

tabs_for() {
  local role="$1" up="$2" r first
  for r in "${ROLES[@]}"; do
    first="$(first_page_of "$r")"
    [[ -z "$first" ]] && continue
    if [[ "$r" == "$role" ]]; then
      echo "      <a class=\"tab\" href=\"$up$first\" aria-current=\"true\">$(role_title "$r")</a>"
    else
      echo "      <a class=\"tab\" href=\"$up$first\">$(role_title "$r")</a>"
    fi
  done
}

for_everyone() {
  local entry
  echo "      <h2>For everyone</h2>"
  echo "      <ul>"
  for entry in "${pages[@]}"; do
    [[ "$(field "$entry" role)" == shared ]] && nav_link "$entry" "$1" "$2" "$3"
  done
  echo "      </ul>"
}

# On each role's first page, a pointer to the intro for readers who came straight in through a tab.
callout_for() {
  local html="$1" up="$2" role="$3"
  [[ " ${ROLES[*]} " == *" $role "* && "$html" == "$(first_page_of "$role")" ]] || return 0
  echo "<aside class=\"first-time\"><strong>First time here?</strong> Take a look at the <a href=\"${up}index.html\">$intro</a>.</aside>"
}

# A role page's sidebar: that role's project-wide pages, a section per part, then the pages for
# everyone (the tl;dr and the glossary).
# A shared page's sidebar: the roles to choose from, then the pages for everyone, then any extra groups.
nav_for() {
  local current="$1" up="$2" role="$3" root_up entry r first part group=""
  root_up="$(up_from "$out_rel/$current")"
  if [[ " ${ROLES[*]} " == *" $role "* ]]; then
    nav_section "$(role_title "$role")" "$role" "" "$current" "$up" "$root_up"
    for part in ${PARTS[@]+"${PARTS[@]}"}; do
      nav_section "$part" "$role" "$part" "$current" "$up" "$root_up"
    done
    for_everyone "$current" "$up" "$root_up"
    return
  fi
  echo "      <h2>Choose your role</h2>"
  echo "      <ul class=\"roles\">"
  for r in "${ROLES[@]}"; do
    first="$(first_page_of "$r")"
    [[ -z "$first" ]] && continue
    echo "        <li><a href=\"$up$first\">$(role_title "$r")<small>$(role_blurb "$r")</small></a></li>"
  done
  echo "      </ul>"
  for_everyone "$current" "$up" "$root_up"
  for entry in "${pages[@]}"; do
    r="$(field "$entry" role)"
    [[ " ${ROLES[*]} " == *" $r "* || "$r" == shared ]] && continue
    part="$(field "$entry" part)"
    if [[ "$r/$part" != "$group" ]]; then
      [[ -n "$group" ]] && echo "      </ul>"
      echo "      <h2>${part:-$r}</h2>"
      echo "      <ul>"
      group="$r/$part"
    fi
    nav_link "$entry" "$current" "$up" "$root_up"
  done
  [[ -n "$group" ]] && echo "      </ul>"
}

is_in_section() {
  [[ "$(field "$1" role)" == "$2" && "$(field "$1" part)" == "$3" ]] && is_built "$1"
}

part_links_for() {
  local role="$1" up="$2" part first
  for part in ${PARTS[@]+"${PARTS[@]}"}; do
    first="$(first_page_in "$role" "$part")"
    [[ -n "$first" ]] && printf '\n          <a href="%s%s">%s</a>' "$up" "$first" "$part"
  done
  return 0
}

# Previous and Next stay within a role and a part. The last project-wide page of a role that has
# parts ends with links to each part; any other last page ends with a stop and the other roles.
pager_for() {
  local index="$1" up="$2" role="$3" part parts_links i entry r first
  [[ " ${ROLES[*]} " == *" $role "* ]] || return 0
  part="$(field "${pages[index]}" part)"
  for ((i = index - 1; i >= 0; i--)); do
    entry="${pages[i]}"
    is_in_section "$entry" "$role" "$part" || continue
    echo "        <a class=\"prev\" href=\"$up$(field "$entry" html)\"><small>Previous</small>$(field "$entry" label)</a>"
    break
  done
  for ((i = index + 1; i < ${#pages[@]}; i++)); do
    entry="${pages[i]}"
    is_in_section "$entry" "$role" "$part" || continue
    echo "        <a class=\"next\" href=\"$up$(field "$entry" html)\"><small>Next</small>$(field "$entry" label)</a>"
    return 0
  done
  if [[ -z "$part" ]] && parts_links="$(part_links_for "$role" "$up")" && [[ -n "$parts_links" ]]; then
    echo "        <div class=\"end\"><p><strong>Next, the pages for each part you use:</strong></p>"
    echo "        <p>$parts_links"
    echo "        </p></div>"
    return 0
  fi
  if [[ -n "$part" ]]; then
    echo "        <div class=\"end\"><p><strong>That's the last page for $part.</strong></p>"
  else
    echo "        <div class=\"end\"><p><strong>That's the last page $(role_title "$role" | tr 'A-Z' 'a-z').</strong></p>"
  fi
  echo "        <p>Other roles:"
  for r in "${ROLES[@]}"; do
    [[ "$r" == "$role" ]] && continue
    first="$(first_page_of "$r")"
    [[ -n "$first" ]] && echo "          <a href=\"$up$first\">$(role_title "$r")</a>"
  done
  echo "        </p></div>"
}

# --- Building one page ---

# Diagrams are rendered once, on a transparent background; library.css puts them on a light panel.
render_diagrams() {
  local src="$1" dest="$2"
  if grep -q '^```mermaid' "$src"; then
    "${mmdc_cmd[@]}" -q -i "$src" -o "$dest" -a "$(dirname "$dest")" -b transparent
  else
    cp "$src" "$dest"
  fi
}

build_page() {
  local index="$1" entry src html role up html_dir name
  local source_args=()
  entry="${pages[index]}"
  src="$(field "$entry" src)"; html="$(field "$entry" html)"; role="$(field "$entry" role)"
  up="$(up_from "$html")"
  html_dir="$(dirname "$html")"
  name="$(basename "${src%.md}")"
  # Outside a private edition, a page has no link to its markdown source: the reader has no repo.
  is_bundled || source_args=(-V "source=$(up_from "$out_rel/$html")$src" -V "source-name=$(basename "$src")")

  mkdir -p "$work/$html_dir" "$out/$html_dir"
  render_diagrams "$repo_root/$src" "$work/$html_dir/$name.md"
  # In an edition, a diagram is copied only if the page still shows it (below): one inside a dropped
  # section or passage stays out of the bundle.
  [[ -n "$edition" ]] || find "$work/$html_dir" -maxdepth 1 -name "$name-*.svg" -exec cp {} "$out/$html_dir/" \;

  pandoc "$work/$html_dir/$name.md" -f gfm -t html5 -s \
    --template "$SCRIPT_DIR/library-template.html" --toc --toc-depth=2 \
    --lua-filter "$SCRIPT_DIR/md-links.lua" \
    --metadata pagetitle="$(page_title "$repo_root/$src")" \
    --metadata page_repo_dir="$(dirname "$src")" \
    --metadata page_name="$name" \
    --metadata page_source="$src" \
    --metadata html_repo_dir="$out_rel/$html_dir" \
    --metadata library_dir="$lib_rel" \
    --metadata out_dir="$out_rel" \
    --metadata page_map="$page_map" \
    --metadata edition="$edition" \
    --metadata visibility="$visibility" \
    --metadata edition_pages="$edition_pages" \
    --metadata excluded_links="$excluded_links" \
    --metadata edition_roles="$(IFS=,; echo "${ROLES[*]}")" \
    --metadata left_out_roles="$left_out_roles" \
    --metadata left_out_titles="$left_out_titles" \
    --metadata all_roles="$all_roles" \
    --metadata tracked_file="$work/tracked" \
    --metadata diagram_dir="$work/$html_dir" \
    --metadata repo_names="$repo_names" \
    --metadata repo_root="$repo_root" \
    --metadata report_file="$work/report" \
    -V project="$project" \
    -V css="${up}library.css" \
    -V home="${up}index.html" \
    ${source_args[@]+"${source_args[@]}"} \
    -V tabs="$(tabs_for "$role" "$up")" \
    -V callout="$(callout_for "$html" "$up" "$role")" \
    -V nav="$(nav_for "$html" "$up" "$role")" \
    -V pager="$(pager_for "$index" "$up" "$role")" \
    -o "$out/$html"
  if [[ -n "$edition" ]]; then
    { grep -oE "$name-[0-9]+\.svg" "$out/$html" || true; } | sort -u | while read -r svg; do
      cp "$work/$html_dir/$svg" "$out/$html_dir/"
    done
  fi
  echo "$out/$html"
}

# --- An edition's report, images, and zip ---

# The filter's records, one per line: kind, the page's source, detail (tab-separated).
report_edition() {
  local kind source detail page
  [[ -f "$work/report" ]] || return 0
  while IFS=$'\t' read -r kind source detail; do
    # The page as an allow line names it: relative to the library, or the repo path of a carried file.
    page="${source#"$lib_rel"/}"
    case "$kind" in
      DROPPED) echo "dropped list item ($source): $detail" ;;
      DROPPED_ROW) echo "dropped table row ($source): $detail" ;;
      DROPPED_SECTION) echo "dropped section ($source): $detail" ;;
      DROPPED_PASSAGE) echo "dropped passage ($source): $detail" ;;
      OUTSIDE) errors+=("$source links $detail, which is outside the edition") ;;
      LEFT_OUT) errors+=("$page links $detail, a document the edition leaves out; drop it with a role heading or marker, or reword") ;;
      TRACE) is_allowed "$source" "$detail" || errors+=("no trace: $page names \"$detail\"") ;;
      MARKER) errors+=("$page: $detail") ;;
      ASSET) copy_asset "$detail" "$source" ;;
    esac
  done < <(sort -u "$work/report")
}

# An edition's allow|<page>|<term> lines; the page is library-relative, the term matched without case.
is_allowed() {
  local page="${1#"$lib_rel"/}" term allow
  term="$(lower "$2")"
  for allow in ${allows[@]+"${allows[@]}"}; do
    [[ "$allow" == "$page|$term" ]] && return 0
  done
  return 1
}

copy_asset() {
  local path="$1" source="$2"
  if [[ ! -f "$repo_root/$path" ]]; then
    errors+=("$source shows $path, which doesn't exist")
    return 0
  fi
  mkdir -p "$out/assets/$(dirname "$path")"
  cp "$repo_root/$path" "$out/assets/$path"
}

# An external edition runs check-external.sh on every page it builds. A finding in a library document
# stops the zip; one in a repo file carried from the sidebar is reported, not fixed: it isn't the library's.
check_external() {
  local entry src line status
  [[ "$visibility" == external ]] || return 0
  for entry in "${pages[@]}"; do
    is_built "$entry" || continue
    src="$(field "$entry" src)"
    status=0
    "$BASH" "$SCRIPT_DIR/check-external.sh" "$repo_root/$src" >"$work/external" || status=$?
    if [[ $status -gt 1 ]]; then
      errors+=("the external check itself failed on $src (exit $status)")
      continue
    fi
    while IFS= read -r line; do
      if [[ "$src" == "$lib_rel"/* ]]; then
        errors+=("external check: $line")
      else
        echo "external check, reported only (outside the library): $line"
      fi
    done <"$work/external"
  done
}

zip_edition() {
  local zip_name
  zip_name="$edition-$(date +%m%d%y).zip"
  (cd "$library/editions" && rm -f "$zip_name" && zip -qr "$zip_name" "$edition")
  echo "$library/editions/$zip_name"
}

mkdir -p "$out"
find "$out" -mindepth 1 -delete
# Today's zip is rebuilt or, if the build fails, gone: it must never outlive the sources it came from.
is_bundled && rm -f "$library/editions/$edition-$(date +%m%d%y).zip"
# The no-trace check counts as repo-only only what git tracks.
[[ -n "$edition" ]] && git -C "$repo_root" -c core.quotePath=off ls-files >"$work/tracked"
# The repo's names, for URLs into it: its folder, and its origin remote's name if it has one.
repo_names="$(basename "$repo_root")"
origin="$(git -C "$repo_root" remote get-url origin 2>/dev/null || true)"
[[ -n "$origin" ]] && repo_names+=",$(basename "${origin%.git}")"
cp "$SCRIPT_DIR/library.css" "$out/library.css"
for index in "${!pages[@]}"; do
  is_built "${pages[index]}" || continue
  build_page "$index"
done

[[ -n "$edition" ]] || exit 0
report_edition
check_external
if [[ ${#errors[@]} -gt 0 ]]; then
  printf 'error: %s\n' "${errors[@]}" >&2
  echo "The edition $edition was built in $out for inspection, but not zipped." >&2
  exit 1
fi
is_bundled && zip_edition
exit 0
