---
name: michi-docs-site
description:
  Scaffold an internal Astro + Starlight docs browser for any project, or generate a PDF build recipe for an
  existing Starlight site. Workshop-style skill.
---

# Michi Docs Site

Two related modes:

1. **Scaffold** (default) — build a self-contained Astro + Starlight site that renders a project's markdown
   files as a searchable, navigable website.
2. **PDF recipe** (`pdf <target-site-dir>`) — generate, validate, or update a `pdf-recipe.yaml` for any
   existing Starlight site. The recipe drives `tools/build-pdf.sh`.

**Not limited to Michi-structured projects.** Discovery scans what actually exists — standard Michi docs layout,
scattered markdown, hand-built sites. The skill adapts to what it finds.

**Workshop-style skill.** Follows the same plan/do/wrapup discipline as `michi-workshop`: surface assumptions, plan
and agree, verify before claiming done, capture decisions.

**Principles served:** Shared context as foundation (makes docs accessible). Reuse over reinvention (Starlight does
the heavy lifting). See `references/principles.md`.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there take priority over this skill's defaults.

---

## Mode Selection

Read the arguments:

- **No args, or a target directory alone** — Scaffold mode. Jump to Phase 1: Discovery.
- **`pdf <target-site-dir>`** — PDF recipe mode. Jump to "PDF Recipe Mode" below.

---

## Phase 1: Discovery

Scan the project to understand its documentation landscape.

### What to scan

1. **Docs root** — check CLAUDE.md for `docs-root:` config. Fall back to `docs/` if present, then scan for
   any directory containing markdown.
2. **Root markdown files** — `*.md` at project root. Look for `STATUS.md`, `CLAUDE.md`, `README.md`,
   `ARCHITECTURE.md`, `PROJECT.md`, and any others.
3. **Directory structure** — map the top-level directories under docs root. Note depth, file counts per directory,
   whether subdirectories are nested (epics with plans/ and verification/ vs flat folders).
4. **Existing frontmatter** — sample files to check if they have `title:` frontmatter or start with `# headings`.
   This informs whether sync.sh will need to inject titles for most files.
5. **Total file count** — affects build time expectations.
6. **Logo file** — check for existing SVG/PNG logos in the project (`src/assets/`, `public/`, project root).

### Present findings

Show the user what was discovered:

```
Project: [name]
Docs root: [path]
Root .md files: STATUS.md, CLAUDE.md, README.md, [others]
Directories found:
  epics/          — 34 files, 5 subdirs
  sidebars/       — 8 files
  reference/      — 4 files
  [others]
Total markdown files: [count]
Frontmatter: [most have it / most don't / mixed]
Logo candidates: [files found, or none]
```

Wait for the user to review. This is a checkpoint.

## Phase 2: Confirmation

Ask the user about each decision point. Present defaults, let them override.

### Questions to ask

1. **Site directory name?** Default: `internal-site`. "Where should the site live? Default is `internal-site/`
   at project root."

2. **Logo or text title?**
   - If logo candidates were found: "Found [file] — want to use it? Or just a text title?"
   - If no logo: "No logo file found. What name should appear in the site header?" (e.g., "SEKKO INTERNAL",
     "JUNKDRAWER DOCS")
   - If they provide a logo path, note whether to use `replacesTitle: true` (logo only) or `false` (logo + text).

3. **Install dependencies now?** "Should I run `npm install` now? Dependencies will be added as devDependencies."

4. **Update CLAUDE.md?** "Should I add the docs site to CLAUDE.md with dev/build commands?"

5. **Sidebar structure** — present the proposed sidebar groups based on discovered directories:
   ```
   Proposed sidebar:
     Project       — root .md files (STATUS.md, CLAUDE.md, etc.)
     Epics         — docs/epics/
     Sidebars      — docs/sidebars/
     Reference     — docs/reference/
     [others discovered]
   
   Any directories to exclude? Any to rename?
   ```

6. **Exclusions** — "Any files or directories to skip? (e.g., large generated files, node_modules docs)"

Collect all answers before building. This is a checkpoint.

## Phase 3: Build

Generate the site. Use the templates in `templates/` as the base, customized with the user's choices.

### Step 1: Scaffold Astro + Starlight

```bash
mkdir -p <site-dir>
cd <site-dir>
npm create astro@latest -- --template starlight --no-git --no-install -y .
```

Then remove the scaffold's default content:

```bash
rm -rf src/content/docs/guides src/content/docs/reference src/content/docs/index.mdx
```

### Step 2: Copy and customize templates

Copy each template file from `templates/` to the target site, substituting placeholders.

**`package.json`** — copy as-is, then update the `name` field to `<site-dir>`. Fixed dependencies:
`astro`, `@astrojs/starlight`, `starlight-theme-rapide`, `@fontsource/michroma`, `sharp`. All as
devDependencies.

**`sync.sh`** — copy and edit the customization block:

```bash
# --- CUSTOMIZE THESE ---
DOCS_ROOT="<docs root from discovery, e.g., 'docs' or 'docs-michi'>"
ROOT_FILES="<space-separated list of root .md files found, e.g., 'STATUS.md CLAUDE.md README.md'>"
# --- END CUSTOMIZE ---
```

Then `chmod +x sync.sh`.

**`astro.config.mjs`** — substitute placeholder tokens:

| Token | Replacement |
| --- | --- |
| `{{TITLE}}` | The title from confirmation (e.g., `Michi INTERNAL`, `SEKKO INTERNAL`) |
| `{{LOGO_LINE}}` | Logo config block (see variants below) or empty string |
| `{{SIDEBAR_GROUPS}}` | Sidebar group objects (see examples below) |

**Logo line variants:**

- No logo (text title only):
  ```js
  // LOGO_LINE = empty — remove the {{LOGO_LINE}} line entirely
  ```

- Logo with text title beside it (most common):
  ```js
  logo: { src: './src/assets/<logo-filename>', replacesTitle: false },
  ```

- Logo replaces text title (logo has built-in text):
  ```js
  logo: { src: './src/assets/<logo-filename>', replacesTitle: true },
  ```

**Sidebar groups examples:**

```js
// Single directory
{ label: 'Project', autogenerate: { directory: 'project' } },

// Multiple directories
{ label: 'Project', autogenerate: { directory: 'project' } },
{ label: 'Epics', autogenerate: { directory: 'epics' } },
{ label: 'Sidebars', autogenerate: { directory: 'sidebars' } },
{ label: 'Reference', autogenerate: { directory: 'reference' } },
```

**`michroma-headings.css`** — copy to `<site-dir>/src/styles/michroma-headings.css` as-is.

**`gitignore`** — copy to `<site-dir>/.gitignore` (note: filename changes — `gitignore` → `.gitignore`
because npm/git don't include dotfiles in templates cleanly).

### Step 3: Additional files

**`<site-dir>/src/index.md`** — landing page, generated based on discovery. Structure:

```markdown
---
title: <Project> Internal
---

# <Project> — Internal Docs

Browse the project documentation.

- [STATUS.md](/project/status/)
- [CLAUDE.md](/project/claude/)
- [Roadmap](/roadmap/)
- [Memory](/memory/)

<Add links to whatever root files and top-level directories were discovered>
```

Note: URLs are lowercase even if filenames are uppercase — Starlight lowercases them for routing.

**Logo file** — if user provided a logo path during confirmation, copy it to
`<site-dir>/src/assets/<logo-filename>`.

### Step 4: Install and verify

```bash
cd <site-dir>
npm install        # if user approved npm install
npm run build      # runs sync.sh then astro build
```

Expected output: "X page(s) built in Ys" with no errors.

### Error recovery

If the build fails:

- **`title: Required` error** — a file reached Starlight without frontmatter injection. Check that
  `sync.sh` ran successfully and check the file mentioned in the error. May need to investigate how
  the file flowed through sync.
- **Cannot find module** errors — dependencies not installed. Run `npm install`.
- **`astro-expressive-code` warnings about unknown languages** — harmless, ignore. They appear for
  code blocks with uncommon language tags (e.g., `dot`).
- **Symlink-related errors** — check if any synced files are symlinks. `sync.sh` should dereference
  them; if not, update the script.
- **Generic build errors** — read the error message carefully, fix the specific issue, re-run.
  Don't retry blindly.

Report issues to the user if recovery isn't obvious.

## Phase 4: Wrap Up

### Verify

- Build succeeded with no errors
- Dev server starts and serves pages
- Sidebar reflects the agreed structure
- Search works (Pagefind indexes content)

### Capture

- If CLAUDE.md update was approved, add a section with dev/build commands
- Update STATUS.md if appropriate
- Note any issues encountered or future improvements

### Present to user

Show what was built:

```
Site: <site-dir>/
Pages: [count]
Build time: [time]
Commands:
  cd <site-dir> && npm run dev    # dev server
  cd <site-dir> && npm run build  # production build
  cd <site-dir> && npm run sync   # re-sync content without building
```

### Questions for the user

- "Anything to adjust in the sidebar grouping?"
- "Want to deploy this somewhere (GitHub Pages, etc.)?"
- "Any files that rendered poorly or need exclusion?"

### What's Next

The site is a tool, not a deliverable. No debrief needed unless the process surfaced something worth capturing.
If the user wants to customize further (theme, additional pages, deploy), that's a separate workshop.

---

# PDF Recipe Mode

Invoked as `/michi-docs-site pdf <target-site-dir>`. Produces, validates, or updates a `pdf-recipe.yaml` in the
target site directory. The recipe is consumed by `tools/build-pdf.sh` to build S/M/L/XL PDFs.

**Target is any Starlight site** — works on hand-built sites (e.g. michi's `website/`) and sites
scaffolded by this skill (`internal-site/`) alike. It does not require the site to have been created by the
scaffold mode.

**Behavior branches on whether the recipe already exists:**

| Case | Mode | What happens |
| --- | --- | --- |
| `pdf-recipe.yaml` missing | **Write** | Discover pages, propose S/M/L/XL groupings, confirm, write file |
| `pdf-recipe.yaml` present | **Validate** | Diff recipe vs filesystem, report drift, ask user how to resolve |
| User asks to tweak | **Update** | Walk through sizes, let user reorder/add/remove/exclude/relabel |

## Pre-flight

Before doing anything, check the environment so we don't surprise the user with missing tools later.

```bash
tools/build-pdf.sh --pre-flight
```

If anything is missing, relay the output and stop. The recipe is useful without the toolchain, but the user
should know up front that builds will fail until they install missing packages.

## Phase 1: Discover

Read the target site:

1. **`astro.config.mjs`** — may set `title`, may reference a `sidebar.config.mjs` or inline the sidebar.
2. **`sidebar.config.mjs`** (if present) — canonical section order. This is the closest thing to "what the
   site author considers the natural reading order."
3. **`src/content/docs/`** (or whatever the `content_root` is) — walk the directory tree for `.md` and `.mdx`
   files. Record slug (path without extension, relative to content root). Sample a few files to detect
   frontmatter presence.
4. **Existing `pdf-recipe.yaml`** — if present, load it. This switches the mode.

Present the discovery as a compact summary:

```
Site: website/
Title (from astro.config.mjs): Michi
Sidebar config: sidebar.config.mjs (5 top-level groups)
Content root: src/content/docs
Pages found: 33 .md + 1 .mdx
Sidebar order:
  Introduction        (3 pages)
  Getting Started     (3 pages)
  Core Concepts       (7 pages)
  The Story           (1 page — placeholder)
  Reference           (16 pages, 2 subgroups)
```

Wait for the user. This is a checkpoint.

## Phase 2: Plan the recipe (Write mode)

Propose S/M/L/XL groupings based on discovery. Good defaults:

- **S (Quick Start)** — the minimum a new reader needs to understand and install. Typically Introduction +
  Getting Started. 4–8 pages.
- **M (Understanding)** — enough to grasp how the thing works. S + Core Concepts. 10–15 pages.
- **L (Full Guide)** — the teaching path. M + narrative/story sections if they exist. 15–25 pages.
- **XL (Complete)** — everything except deliberate exclusions. M + everything else. 25+ pages.

**Exclusions to propose automatically:**

- `.mdx` files (the builder doesn't parse MDX)
- Placeholder pages (ask the user to confirm which ones)
- Auto-generated content that doesn't read well in a flat PDF

Show the proposed recipe structure as a table or bulleted list. Don't write the file yet. Confirm:

- Size labels (e.g., "Quick Start", "Understanding", "Full Guide", "Complete") — defaults are fine, but
  the user may prefer project-specific names.
- Page assignments per size — is anything missing, misplaced, or out of order?
- Output filenames — default is `<site-slug>-<variant>.pdf`.
- Exclusions.

Once confirmed, write the file to `<target>/pdf-recipe.yaml` using the template at
`templates/pdf-recipe.yaml` as a starting shape. Substitute placeholders with the discovered/agreed values.

## Phase 3: Validate (existing recipe)

If a recipe already exists, compute three sets:

1. **Missing** — slugs listed in the recipe but not present under `content_root`. Recipe is out of date,
   OR the page was moved/removed.
2. **Orphans** — pages on disk that aren't in any size's `sections` list and aren't in `exclude`. Could be
   new content that should be added, OR deliberately uncovered.
3. **Exclusion hits** — pages on disk that are covered by `exclude`. Just confirm these are still
   intended exclusions.

Present the drift as a report:

```
Recipe: website/pdf-recipe.yaml

Missing (in recipe but not on disk):
  - introduction/old-intro

Orphans (on disk but not in any size):
  - reference/new-patterns-page

Exclusions active:
  - the-story/index (placeholder)
```

For each category, ask what to do:

- Missing → remove from recipe? rename to match a renamed file?
- Orphans → add to which sizes? add to exclude?
- Exclusions → keep? remove now that the page is real?

Apply the agreed changes and rewrite the recipe. Re-validate to confirm clean.

## Phase 4: Update (user-driven tweaks)

Separate from validate — the user just wants to change things. Common requests:

- Reorder sections within a size
- Move a page from one size to another
- Rename a size label or output filename
- Add a new size (rare)

Show the current recipe for the affected size. Make the edit. Show the diff. Confirm.

## Phase 5: Test the build

Once the recipe is written or updated, offer to run a build as verification:

```bash
tools/build-pdf.sh <target-site-dir> S
```

Start with the smallest size — fastest feedback if something is broken. If that works, the user can build
the others on demand.

Expected outcomes to watch for:

- Pandoc errors about missing files → recipe drift; return to validate.
- Pandoc errors about unknown LaTeX commands → a page has raw LaTeX or weird content; add to exclude or fix the page.
- Warnings about `.mdx` → expected for slugs that resolve to mdx; add to exclude to silence.
- A built PDF that's structurally wrong (wrong headings, missing title) → report and debug the transform.

## Wrap Up

- Confirm the recipe is committed (or staged) if the user wants it in version control.
- Note any decisions — e.g., "excluded The Story because it's a placeholder, add back after M3."
- Update STATUS.md if this establishes a new capability.
- Short recap: recipe location, which sizes are defined, which builds verified.
