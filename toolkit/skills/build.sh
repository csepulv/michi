#!/usr/bin/env bash
# Sync shared reference files from toolkit/ into each skill's references/ directory.
# Run this after updating toolkit/principles.md, toolkit/docs-structure.md, toolkit/ground-rules.md,
# toolkit/writing-for-readability.md, toolkit/patterns.md, toolkit/health-checklists.md,
# tools/build-pdf.sh or tools/pdf-assets/, or michi-library's HTML build scripts.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOOLKIT_DIR="$(dirname "$SCRIPT_DIR")"

SHARED_FILES=(
  "principles.md"
  "docs-structure.md"
  "ground-rules.md"
  "writing-for-readability.md"
)

# Files shared with specific skills only
PATTERNS_SKILLS=(
  "michi-debrief"
  "michi-session"
)

SKILLS=(
  "michi-away"
  "michi-bootstrap"
  "michi-debrief"
  "michi-diagrams"
  "michi-library"
  "michi-docs-site"
  "michi-expedition"
  "michi-explore"
  "michi-loop"
  "michi-planning"
  "michi-portal"
  "michi-pr-prep"
  "michi-scenario-test-builder"
  "michi-second-look"
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

# Sync health-checklists.md to the skills that apply it
HEALTH_SKILLS=(
  "michi-sustainability"
  "michi-second-look"
)

for skill in "${HEALTH_SKILLS[@]}"; do
  cp "$TOOLKIT_DIR/health-checklists.md" "$SCRIPT_DIR/$skill/references/health-checklists.md"
  echo "  $skill/references/health-checklists.md"
done

# Sync checkpoint-doc-formats.md to the skills that offer it
CHECKPOINT_SKILLS=(
  "michi-debrief"
  "michi-sustainability"
)

for skill in "${CHECKPOINT_SKILLS[@]}"; do
  cp "$TOOLKIT_DIR/checkpoint-doc-formats.md" "$SCRIPT_DIR/$skill/references/checkpoint-doc-formats.md"
  echo "  $skill/references/checkpoint-doc-formats.md"
done

# Sync files one skill owns to another skill that uses them (the owning skill's copy is canonical)
cp "$SCRIPT_DIR/michi-session/references/target-non-code.md" "$SCRIPT_DIR/michi-planning/references/target-non-code.md"
echo "  michi-planning/references/target-non-code.md"
cp "$SCRIPT_DIR/michi-expedition/references/expedition-templates.md" "$SCRIPT_DIR/michi-bootstrap/references/expedition-templates.md"
echo "  michi-bootstrap/references/expedition-templates.md"

# Sync expedition-structure.md to skills that reference it
EXPEDITION_SKILLS=(
  "michi-bootstrap"
  "michi-expedition"
)

for skill in "${EXPEDITION_SKILLS[@]}"; do
  refs_dir="$SCRIPT_DIR/$skill/references"
  src="$TOOLKIT_DIR/expedition-structure.md"
  dest="$refs_dir/expedition-structure.md"

  if [ -f "$src" ]; then
    cp "$src" "$dest"
    echo "  $skill/references/expedition-structure.md"
  fi
done

# Sync Hermes/harness files to the expedition skill (the harness-relevant skill)
HARNESS_FILES=(
  "working-with-hermes.md"
  "soul-template.md"
)

for file in "${HARNESS_FILES[@]}"; do
  src="$TOOLKIT_DIR/$file"
  dest="$SCRIPT_DIR/michi-expedition/references/$file"

  if [ -f "$src" ]; then
    cp "$src" "$dest"
    echo "  michi-expedition/references/$file"
  fi
done

# Sync the library HTML build (michi-library is canonical) to the expedition skill, which builds the
# portrait library with expedition.conf
LIBRARY_BUILD_FILES=(
  "build-html.sh"
  "check-external.sh"
  "md-links.lua"
  "library-template.html"
  "library.css"
  "project.conf"
  "expedition.conf"
  "search.js"
  "vendor/minisearch.js"
  "vendor/minisearch-LICENSE.txt"
  "vendor/README.md"
)

for file in "${LIBRARY_BUILD_FILES[@]}"; do
  mkdir -p "$(dirname "$SCRIPT_DIR/michi-expedition/scripts/$file")"
  cp "$SCRIPT_DIR/michi-library/scripts/$file" "$SCRIPT_DIR/michi-expedition/scripts/$file"
  echo "  michi-expedition/scripts/$file"
done

# Sync the PDF builder (tools/ is canonical) to michi-docs-site, whose PDF recipe mode drives it
REPO_DIR="$(dirname "$TOOLKIT_DIR")"
PDF_ASSET_FILES=(
  "callouts.lua"
  "header.tex"
  "before-body.tex.tmpl"
)

mkdir -p "$SCRIPT_DIR/michi-docs-site/scripts/pdf-assets"
cp "$REPO_DIR/tools/build-pdf.sh" "$SCRIPT_DIR/michi-docs-site/scripts/build-pdf.sh"
echo "  michi-docs-site/scripts/build-pdf.sh"
for file in "${PDF_ASSET_FILES[@]}"; do
  cp "$REPO_DIR/tools/pdf-assets/$file" "$SCRIPT_DIR/michi-docs-site/scripts/pdf-assets/$file"
  echo "  michi-docs-site/scripts/pdf-assets/$file"
done

echo ""
echo "Done. Shared references synced to ${#SKILLS[@]} skills."
