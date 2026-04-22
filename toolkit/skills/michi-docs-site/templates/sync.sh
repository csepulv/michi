#!/bin/bash
# Syncs project markdown files into src/content/docs/ with injected title frontmatter.
# Run before dev or build. Source files are never modified.
#
# Customization points (set by michi-docs-site skill during scaffolding):
#   DOCS_ROOT — relative path from project root to docs directory (default: docs)
#   ROOT_FILES — space-separated list of root .md files to include
#   SITE_DIR_NAME — name of the site directory (for excluding self-references)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONTENT_DIR="$SCRIPT_DIR/src/content/docs"

# --- CUSTOMIZE THESE ---
DOCS_ROOT="docs"
ROOT_FILES="STATUS.md README.md CLAUDE.md ARCHITECTURE.md"
# --- END CUSTOMIZE ---

rm -rf "$CONTENT_DIR"
mkdir -p "$CONTENT_DIR/project"

inject_title() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  # Sidebar label = actual filename (how it looks in an IDE)
  local sidebar_label
  sidebar_label=$(basename "$src")

  # Determine title: first # heading, then filename fallback
  local title
  title=$(grep -m1 "^# " "$src" | sed 's/^# //')
  if [ -z "$title" ]; then
    title="$sidebar_label"
  fi

  # Escape quotes
  title=$(echo "$title" | sed 's/"/\\"/g')
  sidebar_label=$(echo "$sidebar_label" | sed 's/"/\\"/g')

  local sidebar_fm
  sidebar_fm=$(printf 'sidebar:\n  label: "%s"' "$sidebar_label")

  # Check if file already has frontmatter
  if head -1 "$src" | grep -q "^---"; then
    # Has frontmatter — check if title already exists
    local has_title
    has_title=$(awk 'NR==1 && /^---/{fm=1; next} fm && /^---/{exit} fm && /^title:/{print "yes"}' "$src")
    if [ "$has_title" = "yes" ]; then
      # Inject sidebar label after opening ---
      { echo "---"; printf '%s\n' "$sidebar_fm"; tail -n +2 "$src"; } > "$dest"
    else
      # Inject title and sidebar label after opening ---
      { echo "---"; printf 'title: "%s"\n%s\n' "$title" "$sidebar_fm"; tail -n +2 "$src"; } > "$dest"
    fi
  else
    # No frontmatter — prepend it
    { printf -- '---\ntitle: "%s"\n%s\n---\n' "$title" "$sidebar_fm"; cat "$src"; } > "$dest"
  fi
}

# Sync docs directory
if [ -d "$PROJECT_ROOT/$DOCS_ROOT" ]; then
  find "$PROJECT_ROOT/$DOCS_ROOT" -name "*.md" -type f | while read -r src; do
    rel="${src#$PROJECT_ROOT/$DOCS_ROOT/}"
    inject_title "$src" "$CONTENT_DIR/$rel"
  done
fi

# Sync root .md files into project/
for file in $ROOT_FILES; do
  if [ -f "$PROJECT_ROOT/$file" ]; then
    inject_title "$PROJECT_ROOT/$file" "$CONTENT_DIR/project/$file"
  fi
done

# Copy static pages (index, etc.) that live in the site, not in docs/
cp "$SCRIPT_DIR"/src/*.md "$CONTENT_DIR/" 2>/dev/null || true

echo "Synced $(find "$CONTENT_DIR" -name '*.md' | wc -l | tr -d ' ') files to $CONTENT_DIR"
