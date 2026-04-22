#!/usr/bin/env bash
# Sync shared reference files from toolkit/ into each skill's references/ directory.
# Run this after updating toolkit/principles.md, toolkit/docs-structure.md, or toolkit/patterns.md.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOOLKIT_DIR="$(dirname "$SCRIPT_DIR")"

SHARED_FILES=(
  "principles.md"
  "docs-structure.md"
)

# Files shared with specific skills only
PATTERNS_SKILLS=(
  "michi-debrief"
  "michi-session"
)

SKILLS=(
  "michi-bootstrap"
  "michi-debrief"
  "michi-docs-site"
  "michi-explore"
  "michi-planning"
  "michi-pr-prep"
  "michi-scenario-test-builder"
  "michi-session"
  "michi-sustainability"
  "michi-workshop"
)

for skill in "${SKILLS[@]}"; do
  refs_dir="$SCRIPT_DIR/$skill/references"
  mkdir -p "$refs_dir"

  for file in "${SHARED_FILES[@]}"; do
    src="$TOOLKIT_DIR/$file"
    dest="$refs_dir/$file"

    if [ -f "$src" ]; then
      cp "$src" "$dest"
      echo "  $skill/references/$file"
    else
      echo "  WARNING: $src not found, skipping"
    fi
  done
done

# Sync patterns.md to skills that reference it
for skill in "${PATTERNS_SKILLS[@]}"; do
  refs_dir="$SCRIPT_DIR/$skill/references"
  src="$TOOLKIT_DIR/patterns.md"
  dest="$refs_dir/patterns.md"

  if [ -f "$src" ]; then
    cp "$src" "$dest"
    echo "  $skill/references/patterns.md"
  fi
done

echo ""
echo "Done. Shared references synced to ${#SKILLS[@]} skills."
