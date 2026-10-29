#!/usr/bin/env bash
# Write each portrait's campaign history from the expedition's iteration log.
#
#   scripts/portrait-history.sh <expedition-root>
#
# For every portrait folder in <expedition-root>/portraits/ (not html/), writes history.md: the log's
# rows whose "portrait" column names that portrait, in the log's order (newest first), with the rows'
# relative links adjusted to the portrait folder. The file is generated: rewrite it, never edit it.
# Rows from before the log had a portrait column match nothing.
set -euo pipefail

root="${1:-}"
if [[ -z "$root" || ! -f "$root/iteration-log.md" || ! -d "$root/portraits" ]]; then
  echo "usage: $0 <expedition-root>   (needs iteration-log.md and portraits/)" >&2
  exit 2
fi

log="$root/iteration-log.md"

# The log's table: its header row, and the index of its portrait column (0 when there is none).
header="$(grep -m1 -iE '^\| *date *\|' "$log" || true)"
portrait_column="$(awk -F'|' '{for (i = 2; i < NF; i++) { c = tolower($i); gsub(/ /, "", c); if (c == "portrait") { print i - 1; exit } }}' <<<"$header")"
portrait_column="${portrait_column:-0}"
column_count="$(awk -F'|' '{print NF - 2}' <<<"$header")"

# A log row's relative markdown links, re-pointed from the expedition root to portraits/<name>/.
from_portrait_folder() {
  sed -E 's#\]\(([^)#/:][^):]*)\)#](../../\1)#g'
}

# The log rows (after the header's separator) whose portrait column names this portrait.
rows_for() {
  awk -F'|' -v col="$portrait_column" -v name="$1" -v header="$header" '
    $0 == header { in_table = 1; next }
    in_table && /^\|[-| :]+\|$/ { next }
    in_table && /^\|/ {
      if (col == 0) next
      cell = tolower($(col + 1))
      n = split(cell, words, /[^a-z0-9-]+/)
      for (i = 1; i <= n; i++) if (words[i] == name) { print; next }
      next
    }
    in_table { in_table = 0 }
  ' "$log"
}

write_history() {
  local name="$1" dest="$root/portraits/$1/history.md" rows
  rows="$(rows_for "$name" | from_portrait_folder)"
  {
    echo "# $name: campaign history"
    echo
    echo "Generated from the [iteration log](../../iteration-log.md) by \`portrait-history.sh\`; rewritten at each"
    echo "exhibit, so don't edit it. Newest first."
    echo
    if [[ "$portrait_column" == 0 ]]; then
      echo "The log has no portrait column yet, so no campaign can be matched to this portrait."
    elif [[ -z "$rows" ]]; then
      echo "No campaign in the log names this portrait yet."
    else
      echo "$header"
      printf '|%s\n' "$(printf -- '---|%.0s' $(seq 1 "$column_count"))"
      echo "$rows"
    fi
  } >"$dest"
  echo "$dest"
}

for dir in "$root"/portraits/*/; do
  name="$(basename "$dir")"
  [[ "$name" == html ]] && continue
  write_history "$name"
done
