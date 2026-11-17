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
# optional <library>/library.conf adds the library's own documents (doc lines) and part labels (part
# lines), and an optional
# sidebar-links file adds other repo files. The folder is regenerated from scratch on every run, so
# never edit it.
# Needs pandoc 3.1.1 or later and git, and mmdc on PATH or Node 22.13+ for npx (the first npx run downloads a
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
# The search index is written with pandoc's Lua JSON module, which pandoc 3.1.1 added.
pandoc_version_at_least() {
  local have want i
  IFS=. read -r -a have <<<"$(pandoc --version | head -1 | sed 's/^pandoc //; s/[^0-9.].*//')"
  IFS=. read -r -a want <<<"$1"
  for i in 0 1 2; do
    [[ ${have[i]:-0} -gt ${want[i]:-0} ]] && return 0
    [[ ${have[i]:-0} -lt ${want[i]:-0} ]] && return 1
  done
  return 0
}
if ! pandoc_version_at_least 3.1.1; then
  echo "pandoc 3.1.1 or later is needed (found $(pandoc --version | head -1))." >&2
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
part_lines=()
intro="project intro"

# One part line: a folder and a label, each folder labeled once, and no label used for two folders.
add_part_label() {
  local file="$1" folder="$2" label="$3" line
  [[ -n "$folder" && "$label" == *[![:space:]]* ]] || { echo "$file: a part line is part|<folder>|<label>, not 'part|$folder|$label'" >&2; exit 2; }
  for line in ${part_lines[@]+"${part_lines[@]}"}; do
    [[ "${line%%|*}" == "$folder" ]] && { echo "$file: a second part line for '$folder'" >&2; exit 2; }
    [[ "${line#*|}" == "$label" ]] && { echo "$file: parts '${line%%|*}' and '$folder' have the same label, '$label'" >&2; exit 2; }
  done
  part_lines+=("$folder|$label")
}

# A library's own library.conf adds documents beyond the templates (doc lines, for the config's
# roles, listed after the config's own documents), gives parts display labels (part lines, checked
# against the library's subfolders once they are listed), and records the library's roles (one roles
# line, which the build only checks).
read_config() {
  local file="$1" docs_only="${2:-}" kind a b c d role roles
  while IFS='|' read -r kind a b c d; do
    case "$kind" in "" | \#*) continue ;; esac
    if [[ -n "$docs_only" ]]; then
      case "$kind" in
        doc) roles="$c" ;;
        roles) roles="$a" ;;
        part) roles="" ;;
        *) echo "$file: only doc, part, and roles lines belong here, not '$kind'" >&2; exit 2 ;;
      esac
      for role in ${roles//,/ }; do
        [[ " ${ROLES[*]} " == *" $role "* ]] || { echo "$file: unknown role '$role'" >&2; exit 2; }
      done
    fi
    case "$kind" in
      role) ROLES+=("$a"); role_lines+=("$a|$b|$c") ;;
      roles) ;;
      part) add_part_label "$file" "$a" "$b" ;;
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
carries=()
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
      carry)
        value="$(edition_value "$value")"
        [[ -n "${value%%|*}" ]] || { echo "$file: carry is carry|<path> or carry|<path>|<file to ship in its place>" >&2; exit 2; }
        carries+=("$value")
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

# A part's label from its part line, or its folder name.
part_label() {
  local line
  for line in ${part_lines[@]+"${part_lines[@]}"}; do
    [[ "${line%%|*}" == "$1" ]] && { printf '%s\n' "${line#*|}"; return; }
  done
  printf '%s\n' "$1"
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
# as it is, without building a page. flag "copy" marks a document's page for a later role it is listed
# under: built as <name>--<role>.html beside the first role's page, with that role's tab, sidebar, and
# Previous and Next. role_copies holds "role|source|copy html" for each, so that a page for that role
# links to its own copy.

pages=()
role_copies=()
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
      [[ "$2" != link && "${6:-}" != copy ]] && replaced_pages+="$src=$2,"
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
  add_repo_page "$path" "$label" "$role" "$part"
}

# A carried repo file's page: repo/<path>.html for the first role that lists it, and a copy,
# repo/<path>--<role>.html, for each other role, as for a library document listed for several roles.
# repo_page_roles holds "path|first role" for each file carried so far.
repo_page_roles=()
add_repo_page() {
  local path="$1" label="$2" role="$3" part="$4" entry first_role="" count=${#pages[@]} copy_html
  for entry in ${repo_page_roles[@]+"${repo_page_roles[@]}"}; do
    [[ "${entry%|*}" == "$path" ]] && first_role="${entry##*|}"
  done
  if [[ -z "$first_role" || "$first_role" == "$role" ]]; then
    add_page "$path" "repo/${path%.md}.html" "$label" "$role" "$part"
    [[ -z "$first_role" && ${#pages[@]} -gt $count ]] && repo_page_roles+=("$path|$role")
    return 0
  fi
  copy_html="repo/${path%.md}--$role.html"
  if [[ -f "$repo_root/${path%.md}--$role.md" ]]; then
    echo "$repo_root/${path%.md}--$role.md would be built over the $role copy of $path; rename it" >&2
    exit 2
  fi
  add_page "$path" "$copy_html" "$label" "$role" "$part" copy
  [[ ${#pages[@]} -gt $count ]] && role_copies+=("$role|$path|$copy_html")
  return 0
}

add_library_page() {
  add_page "$lib_rel/$1" "${3:-${1%.md}.html}" "$2" "$4" "${5:-}" "${6:-}"
}

# One role's page of a library document: the document's own page for the first role added
# ($first_added empty, set here once a page is added), a copy for each later one.
add_role_page() {
  local rel="$1" label="$2" role="$3" part="$4" count=${#pages[@]} copy_html
  if [[ -z "$first_added" ]]; then
    add_library_page "$rel" "$label" "" "$role" "$part"
    [[ ${#pages[@]} -gt $count ]] && first_added=yes
    return 0
  fi
  copy_html="${rel%.md}--$role.html"
  if [[ -f "$library/${rel%.md}--$role.md" ]]; then
    echo "$library/${rel%.md}--$role.md would be built over the $role copy of $rel; rename it" >&2
    exit 2
  fi
  add_library_page "$rel" "$label" "$copy_html" "$role" "$part" copy
  [[ ${#pages[@]} -gt $count ]] && role_copies+=("$role|$lib_rel/$rel|$copy_html")
  return 0
}

# A role's copies, as "source=copy html," for the link filter: a page for that role links to them.
role_pages_for() {
  local entry
  for entry in ${role_copies[@]+"${role_copies[@]}"}; do
    [[ "${entry%%|*}" == "$1" ]] && printf '%s,' "${entry#*|}" | sed 's/|/=/'
  done
  return 0
}

page_title() {
  local title
  title="$(grep -m1 '^# ' "$1" | sed 's/^# //')"
  echo "${title:-$(basename "${1%.md}")}"
}

# The config's documents in <dir> (empty for the library's top level, which also takes the config's
# links and pages), then any other markdown files as "More".
# A document listed under several roles keeps its name for the first role it is added for (in an
# edition, the first role the edition keeps); each later role gets a copy.
add_documents_in() {
  local dir="$1" prefix="${1:+$1/}" entry kind a b c d role rest rel first_added
  for entry in "${entries[@]}"; do
    IFS='|' read -r kind a b c d <<<"$entry"
    case "$kind" in
      doc)
        rest="$c,"
        first_added=""
        while [[ -n "$rest" ]]; do
          role="${rest%%,*}"
          rest="${rest#*,}"
          add_role_page "$prefix$a" "$b" "$role" "$dir"
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
all_parts=" "
while read -r part; do
  all_parts+="$part "
  part_in_edition "$part" || continue
  PARTS+=("$part")
  add_documents_in "$part"
done < <(cd "$library" && find . -mindepth 1 -maxdepth 1 -type d -not -name html -not -name editions | sed 's|^\./||' | sort)
add_sidebar_links

# A part line names one of the library's parts, whether or not an edition keeps it.
for line in ${part_lines[@]+"${part_lines[@]}"}; do
  [[ "$all_parts" == *" ${line%%|*} "* ]] || {
    echo "$library/library.conf: part '${line%%|*}' is not a part (a subfolder of the library)" >&2
    exit 2
  }
done

# An edition's parts line names part folders, not labels.
for part in $edition_parts; do
  [[ "$all_parts" == *" $part "* ]] || {
    echo "$library/editions/$edition.conf: parts names '$part', which is not a part folder of the library" >&2
    exit 2
  }
done

# A replace line that names no page would let the unredacted original ship under a typo.
for entry in ${replaces[@]+"${replaces[@]}"}; do
  [[ "$used_replaces" == *" ${entry%%|*} "* ]] || errors+=("replace|${entry%%|*} matches no page in the library")
done

# An edition's carry lines: repo files it ships as files (not pages), each under the bundle's assets/ at
# its repo path. With a second path, that file ships in the first one's place. A path is relative to the
# library, or to the repo root (with a leading "/", or when the library has no such file). Links and raw
# HTML pointing at a carried file reach the copy; a carried file isn't checked, so the build lists it.
carried_files=""
carried=()
# A carry path as a normalized repo-relative path, if it names a file inside the repo.
carry_path() {
  local base="$repo_root" path="$1" dir root
  if [[ "$path" == /* ]]; then
    path="${path#/}"
  elif [[ -f "$library/$path" ]]; then
    base="$library"
  fi
  [[ -f "$base/$path" ]] || return 0
  case "$(basename "$path")" in . | ..) return 0 ;; esac
  dir="$(cd "$base/$(dirname "$path")" && pwd -P)" || return 0
  root="$(cd "$repo_root" && pwd -P)"
  [[ "$dir" == "$root" || "$dir" == "$root"/* ]] || return 0
  dir="${dir#"$root"}"
  dir="${dir#/}"
  echo "${dir:+$dir/}$(basename "$path")"
}
for entry in ${carries[@]+"${carries[@]}"}; do
  original="$(carry_path "${entry%%|*}")"
  shipped_as="$original"
  [[ "$entry" == *"|"* ]] && shipped_as="$(carry_path "$(edition_value "${entry#*|}")")"
  if [[ -z "$original" || -z "$shipped_as" ]]; then
    errors+=("carry|$entry names no file in the repo")
    continue
  fi
  if [[ "$original" == *.md || "$shipped_as" == *.md ]]; then
    errors+=("carry|$entry names a markdown file; carry is for files that aren't pages")
    continue
  fi
  carried+=("$original|$shipped_as")
  is_bundled && carried_files+="$original=assets/$original,"
done

# page_map: the pages whose HTML name isn't their markdown name. edition_pages: in an edition,
# every page it builds, so that links to anything else can be told apart.
page_map=""
edition_pages=""
for entry in "${pages[@]}"; do
  IFS='|' read -r src html _ _ _ flag <<<"$entry"
  [[ "$html" == link || "$flag" == copy ]] && continue
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

# A page built under this entry: anything but a link (a role's copy is built too).
is_built() {
  [[ "$(field "$1" html)" != link ]]
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
      nav_section "$(part_label "$part")" "$role" "$part" "$current" "$up" "$root_up"
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
      if [[ -n "$part" ]]; then
        echo "      <h2>$(part_label "$part")</h2>"
      else
        echo "      <h2>$r</h2>"
      fi
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
    [[ -n "$first" ]] && printf '\n          <a href="%s%s">%s</a>' "$up" "$first" "$(part_label "$part")"
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
    echo "        <div class=\"end\"><p><strong>That's the last page for $(part_label "$part").</strong></p>"
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

# A page's copies for other roles, as "role=copy html," for its search entries.
copies_of_page() {
  local entry copy_role copy_html
  for entry in ${role_copies[@]+"${role_copies[@]}"}; do
    copy_role="${entry%%|*}"
    copy_html="${entry##*|}"
    [[ "$copy_html" == "${1%.html}--$copy_role.html" ]] && printf '%s=%s,' "$copy_role" "$copy_html"
  done
  return 0
}

# search-index.js: the entries the filter wrote, one per line, as window.LIBRARY_SEARCH; with MiniSearch, its
# license, and the box's script beside it.
write_search_index() {
  {
    echo "window.LIBRARY_SEARCH = ["
    [[ -s "$work/search.jsonl" ]] && sed '$!s/$/,/' "$work/search.jsonl"
    echo "];"
  } >"$out/search-index.js"
  cp "$SCRIPT_DIR/vendor/minisearch.js" "$SCRIPT_DIR/vendor/minisearch-LICENSE.txt" "$SCRIPT_DIR/search.js" "$out/"
}

build_page() {
  local index="$1" entry src html role up html_dir name
  local source_args=() shipped_args=() search_args=()
  entry="${pages[index]}"
  src="$(field "$entry" src)"; html="$(field "$entry" html)"; role="$(field "$entry" role)"
  up="$(up_from "$html")"
  html_dir="$(dirname "$html")"
  name="$(basename "${src%.md}")"
  # Outside a private edition, a page has no link to its markdown source: the reader has no repo.
  is_bundled || source_args=(-V "source=$(up_from "$out_rel/$html")$src" -V "source-name=$(basename "$src")")
  # An external edition's check reads the page as shipped, which the filter writes here: the plain page's,
  # since a copy's text differs only in its link targets.
  if [[ "$visibility" == external && "$(field "$entry" flag)" != copy ]]; then
    mkdir -p "$(dirname "$work/shipped/$src")"
    shipped_args=(--metadata "shipped_file=$work/shipped/$src")
  fi
  # Search indexes a document once, from its plain page, listing its copies.
  if [[ "$(field "$entry" flag)" != copy ]]; then
    search_args=(--metadata "search_file=$work/search.jsonl" --metadata "page_url=$html"
      --metadata "page_role=$role" --metadata "search_copies=$(copies_of_page "$html")")
  fi

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
    --metadata role_pages="$(role_pages_for "$role")" \
    --metadata edition="$edition" \
    --metadata visibility="$visibility" \
    --metadata edition_pages="$edition_pages" \
    --metadata excluded_links="$excluded_links" \
    --metadata carried_files="$carried_files" \
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
    ${shipped_args[@]+"${shipped_args[@]}"} \
    ${search_args[@]+"${search_args[@]}"} \
    -V root="$up" \
    -V role="$role" \
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
# A no-trace finding is allowed by a line whose term is the finding. An external finding is one word
# in a passage; it is allowed when the page's terms (words or phrases) that hold the word and appear in
# the passage, taken together, cover every use of the word there: "allow|<page>|<name> Me" lets the name
# through, but not "me" on its own, in that passage or elsewhere; two quoted phrases in one passage can
# each have their own line.
# Each line that allows something is recorded in $used_allows, to report the ones that never do.
used_allows=" "
is_allowed() {
  local page="${1#"$lib_rel"/}" term index allow_page allow_term word passage phrase covering=""
  term="$(lower "$2")"
  [[ $# -eq 3 ]] && { word=" $(words "$2") "; passage=" $(words "$3") "; }
  for index in ${allows[@]+"${!allows[@]}"}; do
    allow_page="${allows[index]%%|*}"
    allow_term="${allows[index]#*|}"
    [[ "$allow_page" == "$page" ]] || continue
    if [[ $# -eq 2 ]]; then
      [[ "$allow_term" == "$term" ]] && { used_allows+="$index "; return 0; }
      continue
    fi
    phrase=" $(words "$allow_term") "
    if [[ "$phrase" == *"$word"* && "$passage" == *"$phrase"* ]]; then
      covering+="$index "
      passage="${passage//"$phrase"/ }"
    fi
  done
  [[ -n "$covering" && "$passage" != *"$word"* ]] || return 1
  used_allows+="$covering"
  return 0
}

# Text as lowercase words separated by single spaces, for matching words and phrases.
words() {
  lower "$1" | tr -cs '[:alnum:]' ' ' | sed 's/^ //; s/ $//'
}

report_unused_allows() {
  local index
  for index in ${allows[@]+"${!allows[@]}"}; do
    [[ "$used_allows" == *" $index "* ]] || echo "allow|${allows[index]} silenced nothing; remove it if it is stale"
  done
  return 0
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

# An external edition runs check-external.sh on every page it builds, as the page ships: after the
# drops, as the filter wrote it. A finding names the page as an allow line does and the passage it is in
# (its first words), since the shipped text's lines aren't the source's. A finding in a library document
# stops the zip unless an allow line covers it; one in a repo file carried from the sidebar is reported,
# not fixed: it isn't the library's.
check_external() {
  local entry src shipped status page kind text passage line
  [[ "$visibility" == external ]] || return 0
  for entry in "${pages[@]}"; do
    is_built "$entry" || continue
    [[ "$(field "$entry" flag)" == copy ]] && continue
    src="$(field "$entry" src)"
    shipped="$work/shipped/$src"
    if [[ ! -f "$shipped" ]]; then
      errors+=("the external check found no shipped copy of $src")
      continue
    fi
    status=0
    "$BASH" "$SCRIPT_DIR/check-external.sh" --shipped "$repo_root" "$src" "$shipped" >"$work/external" || status=$?
    if [[ $status -gt 1 ]]; then
      errors+=("the external check itself failed on $src (exit $status)")
      continue
    fi
    while IFS=$'\t' read -r page kind text passage; do
      line="${page#"$lib_rel"/}: $kind \"$text\" in \"$(first_words "$passage")\""
      if [[ "$src" != "$lib_rel"/* ]]; then
        echo "external check, reported only (outside the library): $line"
      elif ! is_allowed "$src" "$text" "$passage"; then
        errors+=("external check: $line")
      fi
    done <"$work/external"
  done
}

# The first words of a passage, without markdown marks, to find it in the source.
first_words() {
  local text
  text="$(echo "$1" | sed -E 's/^(#+|[-*+]|[0-9]+\.|>|\|)[[:space:]]*//; s/[`*_]//g')"
  echo "$text" | awk '{ line = ""; for (i = 1; i <= NF && i <= 6; i++) line = line (i > 1 ? " " : "") $i; print line (NF > 6 ? "…" : "") }'
}

copy_carried() {
  local entry original shipped_as
  is_bundled || return 0
  for entry in ${carried[@]+"${carried[@]}"}; do
    original="${entry%%|*}"
    shipped_as="${entry#*|}"
    mkdir -p "$out/assets/$(dirname "$original")"
    cp "$repo_root/$shipped_as" "$out/assets/$original"
    if [[ "$shipped_as" == "$original" ]]; then
      echo "carried, not checked: $original"
    else
      echo "carried, not checked: $original (from $shipped_as)"
    fi
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
write_search_index

[[ -n "$edition" ]] || exit 0
report_edition
copy_carried
check_external
report_unused_allows
if [[ ${#errors[@]} -gt 0 ]]; then
  printf 'error: %s\n' "${errors[@]}" >&2
  echo "The edition $edition was built in $out for inspection, but not zipped." >&2
  exit 1
fi
is_bundled && zip_edition
exit 0
