---
name: michi-bootstrap
description:
  Onboard a project to the Michi documentation structure — survey what exists, recommend what to build (S/M/L/XL effort
  tiers), and walk the user through setup interactively.
---

# Michi Bootstrap

Onboard a project to the michi documentation structure. This happens before the first `michi-planning` session —
for a brand-new project or an existing one being prepared for Michi work.

**Principles served:** Shared context as foundation (builds the context layer all other skills read). Progressive detail
(sets up the S/M/L/XL document hierarchy). Sustain the system (docs infrastructure makes future iterations productive).
See `references/principles.md`.

## When to Use

- Setting up a new project for michi work
- Onboarding an existing project that has never used Michi
- Re-running on a project with partial Michi structure to close remaining gaps

## Inputs

Before starting:

- Access to the target project codebase
- Michi toolkit installed (skills in `.claude/skills/` or accessible via the GitHub repo)
- User present and interactive — this is collaborative, not autonomous

## Phase 1: Survey

Produce a **project profile** — a structured snapshot that drives the recommendation phase.

### Codebase Heuristics

Get a quick size/shape read:

1. Check if `tokei` is installed (`which tokei`). If available, run `tokei` for language and size breakdown.
2. If `tokei` is not available, fall back to heuristics:
   - Count files by extension: `find . -type f -name '*.js' -o -name '*.ts' -o -name '*.py' | wc -l` (adapt to what's
     present)
   - Rough line count: `find . -type f -name '*.js' | xargs wc -l | tail -1` (adapt to primary language)
   - Directory depth and structure: `ls` top-level, note key directories
3. For large monorepos (thousands of files, multiple top-level packages): present the top-level structure and ask what's
   in scope. "Which parts of this repo should I focus on? Any directories to exclude?" Re-run heuristics on the scoped
   subset.

For small-to-medium repos, look at everything.

### Multi-Project Detection

Determine whether the repo holds multiple sub-projects with independent dev lifecycles. The trigger is a dev-process
question, not package-manager shape: *does a piece of the repo have its own epics, its own status, its own story
that should stay separate?*

**Heuristics suggesting multi-project:**

- Top-level `tools/`, `packages/`, `apps/`, `services/`, or similar directories with two or more subdirs that each
  carry their own README or package metadata
- Workspace file present: `pnpm-workspace.yaml`, `turbo.json`, `lerna.json`, `yarn.lock` with a top-level
  `workspaces` field in `package.json`
- Multiple top-level `package.json` / `pyproject.toml` / `Cargo.toml` under different top-level directories
- User says so directly ("this is a monorepo", "has sub-projects")

**Heuristics are suggestive, not definitive.** A `tools/` dir of internal scripts may not warrant sub-project doc
treatment; a repo without any workspace file may still have sub-projects with independent dev lifecycles. Always ask.

**The question to ask** (when heuristics suggest multi-project or the user indicates one):

> This looks like it might hold multiple sub-projects. Do any of them have their own dev lifecycle — their own epics,
> their own status, their own story — that should live separately from the rest of the repo? If yes, I'll set up the
> multi-project layout: `docs/ROOT/` for the umbrella project's work and `docs/<name>/` for each sub-project.

Record a `multi-project: yes/no` flag in the project profile. If yes, also record the candidate sub-projects list
(confirmed by the user).

**Brownfield detection for existing multi-project Michi setups:** if `docs/ROOT/` or `docs/<name>/CLAUDE.md` entries
already exist, recognize it as an established multi-project Michi repo. Focus on gaps in ROOT + per-sub-project dirs,
not re-litigating the structure.

See `references/docs-structure.md` (Multi-Project Directory Structure section) for the layout rules.

### Existing Docs Inventory

Scan for documentation:

- **Top-level docs:** README, CLAUDE.md, AGENTS.md, PROJECT.md, STATUS.md, ARCHITECTURE.md, CONTRIBUTING.md
- **Docs directories:** any `docs/` folder, its structure and contents
- **Michi-specific artifacts:** `docs/epics/`, verification files, plan docs, journal files, scenario catalogs
- **Other markdown:** any `.md` files with useful content (notes, TODOs, changelogs)

For each file found, note:

- Whether it exists
- Whether it's substantive or a stub (quick content assessment)
- Last modified date (for staleness)

### Docs Root Assessment

Check whether `docs/` already contains non-Michi content (product docs, API docs, customer-facing content, generated
docs). If so, the project needs a separate Michi docs directory.

- If `docs/` is empty or doesn't exist → Michi docs root is `docs/` (default)
- If `docs/` contains existing non-Michi content → ask: "Your `docs/` directory has existing content. Should Michi docs live
  in `docs-michi/`, a different subdirectory, or alongside what's here?"
- Record the decision as `docs-root: <path>` in CLAUDE.md's `## Michi` section

All subsequent Michi directory creation uses this root.

### Michi Gap Analysis

Compare what exists against the docs-structure standard (`references/docs-structure.md`):

- Categorize each expected artifact: **missing**, **stub**, **stale**, or **present-and-healthy**
- Note existing docs that don't map to Michi structure but could be reorganized (e.g., a `notes.md` that could seed
  `journal.md`, a `TODO.md` that could feed `STATUS.md`)
- Detect existing Michi artifacts from a prior bootstrap — focus on gaps, not re-litigating what's already set up

### Present the Project Profile

Present findings to the user. Adapt the format to what was found — the example below is illustrative:

```
Project: [name]
Size: [lines, languages, file count]
Monorepo: [yes/no, scope if yes]

Docs inventory:
  README.md          ✓ substantive
  CLAUDE.md          ✗ missing
  PROJECT.md         ✗ missing
  STATUS.md          ✓ stub (last modified 3 months ago)
  ARCHITECTURE.md    ✗ missing
  docs/              ✓ exists, flat structure (no epics)

Existing docs that could be reorganized:
  docs/notes.md      → could seed journal or STATUS.md
  TODO.md            → could seed STATUS.md or roadmap

Codebase patterns detected:
  Test runner: [detected from config files]
  Build tool: [detected from config files]
  Key patterns: [directories, conventions observed]
```

Wait for the user to review before proceeding. This is a checkpoint.

## Phase 2: Recommend

Based on the survey, present recommendations. The flow branches:

### Greenfield Path

If the survey finds no existing docs and minimal or no code: skip tier selection. Scaffold the full Michi structure.
Confirm with the user and proceed to Phase 3.

If ambiguous whether greenfield or brownfield, ask: "This looks like a fairly new project. Should I scaffold the full
Michi structure, or review what exists and pick what to set up?"

### Brownfield Path

Present effort tiers. Each tier is additive — M includes S, L includes M.

| Tier   | Name         | What it covers                                                                                                                                                                                                   |
| ------ | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **S**  | Essentials   | CLAUDE.md with build/test commands, key files, conventions. STATUS.md stub. Minimum viable Michi.                                                                                                                  |
| **M**  | Foundation   | S + PROJECT.md, first `docs/epics/<name>/` structure with empty verification/ and plans/ subdirs. Reorganize any existing docs that map cleanly.                                                                 |
| **L**  | Full setup   | M + ARCHITECTURE.md, substantive STATUS.md, reorganize remaining existing docs into epic structure, populate CLAUDE.md's Michi Instructions section from template.                                        |
| **XL** | Deep onboard | L + write verification test-plan.md for first epic, draft initial scenario catalog, document branching convention, populate journal with bootstrap findings. Create `docs/reference/` with `code-style.md` stub. |

For each tier, show:

- What gets created
- What gets reorganized (existing docs that move or merge)
- What gets deferred (with a note about why it matters)

The user picks a tier, says "somewhere between M and L," or cherry-picks across tiers. Adapt.

### Multi-Project Branch

When `multi-project: yes` (from Phase 1 detection), the tier recommendation covers the umbrella (`docs/ROOT/`) AND
each sub-project. This modifies both greenfield and brownfield paths — it's not a separate path, it's a multiplier.

**How it works:**

1. **ROOT gets its own tier.** Treated like a normal single-project recommendation — S/M/L/XL applied to the umbrella's
   needs (own product work, shared reference material, cross-tool epics).
2. **Each sub-project gets its own tier.** Present the tier table per sub-project. The user can pick different tiers
   per sub-project — sekko at L, agent-sync at single-file for now, session-export at M. Sub-projects that have nothing
   yet can be skipped (no `docs/<name>/` dir created).
3. **Repo-root CLAUDE.md is always in scope.** It's a single file holding both the umbrella's own
   conventions/build/test AND the repo-wide layer (cross-project rules, project index including ROOT, Michi marker
   with `multi-project: true`, pointer to per-sub-project CLAUDE.mds). No separate `docs/ROOT/CLAUDE.md` — the
   umbrella's identity docs (CLAUDE.md, PROJECT.md, STATUS.md, ARCHITECTURE.md, README.md) live at repo root.
   `docs/ROOT/` holds only the umbrella's *working* docs (`epics/`, `sidebars/`, `journal.md`, `memory.md`,
   `reference/`).

**Present recommendations as a table:**

```
Project          Tier recommendation   Notes
---------------- --------------------- --------------------------------------
ROOT             M                     umbrella site + cross-tool reference
sekko            L                     full dev history, epics active
session-export   M                     plans + journal, no epics yet
agent-sync       single-file           one plan file, don't overbuild
agent-isolation  skip                  no dev knowledge yet
```

Wait for the user to confirm per-project tiers before proceeding.

### Branching Convention

If no clear branch strategy is apparent from git history (no feature branches, only `main`), note this in the roadmap
with a suggestion to establish one before the first `michi-session`.

### Deferred Work

Anything not covered by the chosen tier goes to `docs/reference/docs-refactorings-roadmap.md`. The roadmap is always
produced for brownfield projects unless everything is addressed (XL with no remaining gaps).

Wait for the user to choose before proceeding. This is a checkpoint.

## Phase 3: Execute

**Core principles: draft with the user, don't generate and dump. Don't assume — ask.**

### Per-Artifact Flow

For each artifact in scope:

1. Draft content based on survey findings and the relevant template (`references/`)
2. Present the draft for review and edits
3. Write or update the file after approval
4. Move to the next artifact

### Greenfield Execution Order

1. **CLAUDE.md** — the foundation. Use `references/CLAUDE-MD-template.md`. Populate: build/test commands (from survey),
   conventions detected from initial code, key files (exemplar patterns found during survey), `@`-refs to the other docs
   about to be created.
2. **PROJECT.md** — use `references/PROJECT-template.md`. Purpose, users, features, constraints. Mostly user-provided —
   prompt for each section rather than guessing.
3. **STATUS.md** — current state stub. Brief — enough to orient the next session.
4. **First epic directory** — create `docs/epics/<name>/` with `verification/` and `plans/` subdirs. Ask the user what
   the first epic should be called.
5. **ARCHITECTURE.md** — only if the project has enough shape. If too early, note in the roadmap as "create after first
   milestone."
6. **`docs/reference/code-style.md`** — stub for applied coding principles. Create `docs/reference/` and seed with a
   minimal file. This grows through debriefs. Also create `.claude/rules/project-rules.md` with an `@` reference so it's
   auto-loaded.

### Brownfield Execution Order

Execute within the chosen tier:

1. **CLAUDE.md** — highest value artifact. If one exists, assess and fill gaps. If missing, create from template. Merge
   relevant content from existing docs (README conventions, contributing guides).
2. **Reorganize existing docs** — for docs identified in the survey as mapping to Michi artifacts, show the user what
   would move. "Your `notes.md` has status-like content — want to merge this into STATUS.md?" Don't delete originals
   until the user confirms.
3. **Create missing artifacts** — in tier order: STATUS.md, PROJECT.md, then ARCHITECTURE.md.
4. **First epic setup** — create `docs/epics/<name>/` if M tier or above. Ask the user what the first epic should be
   called.

### Multi-Project Execution

When `multi-project: yes`, the per-artifact draft-review-approve flow runs **per sub-project**. Order:

1. **Repo-root identity docs** — the umbrella's own CLAUDE.md, PROJECT.md, STATUS.md, ARCHITECTURE.md, README.md
   live at repo root (not under `docs/ROOT/`). CLAUDE.md is a single file: umbrella conventions/build/test PLUS
   the repo-wide layer (cross-project rules, project index including ROOT, Michi marker with `multi-project: true`,
   pointer convention for per-sub-project CLAUDE.mds). Do this first so umbrella + repo-wide framing is in place
   before per-project work starts.
2. **`docs/ROOT/`** — the umbrella's working docs. `epics/`, `sidebars/`, `journal.md`, `memory.md`, `reference/`
   scaled to the umbrella's tier. No CLAUDE.md/PROJECT.md/STATUS.md/ARCHITECTURE.md in this dir — those are at
   repo root.
3. **Each sub-project** — iterate in user-chosen order (or alphabetical if unspecified). Apply the greenfield or
   brownfield flow at the sub-project's chosen tier. Sub-projects DO get their identity docs under
   `docs/<name>/`: `docs/<name>/CLAUDE.md` (sub-project conventions), `docs/<name>/PROJECT.md`,
   `docs/<name>/STATUS.md`, `docs/<name>/ARCHITECTURE.md` — plus working docs (`epics/`, `sidebars/`,
   `journal.md`) per tier.

Sub-project CLAUDE.md files are NOT added as `@`-refs to repo-root CLAUDE.md — they're read explicitly when that
sub-project is the session's subject. The repo-root CLAUDE.md points at the convention in prose, not via auto-load.

Source/docs boundary: remind the user that source dirs (`tools/<name>/`, `packages/<name>/`) keep `README.md` + code
only. All internal dev knowledge for sub-projects (CLAUDE.md, epics, plans, journal) lives under `docs/<name>/`.
The umbrella's identity docs living at repo root is the deliberate asymmetry — the repo IS primarily about the
umbrella.

### Throughout Execution

- Don't silently reorganize. Each move or merge is a mini-decision the user approves.
- Don't assume what an existing document's purpose is. If unclear, ask.
- Track what was done and what was deferred.
- When something isn't clear — a doc's intent, where content should live, whether to keep or merge — ask rather than
  guessing.

## Output

When execution is complete, produce:

1. **Summary** — list of what was created, modified, or reorganized.
2. **Roadmap** — `docs/reference/docs-refactorings-roadmap.md` if anything was deferred. Includes:
   - Deferred documentation items with brief rationale
   - Branching convention note (if no branch strategy was detected)
   - Other observations from the survey that didn't result in action
3. **What's next** — The natural next step is `/michi-planning` to prepare the first milestone. If the project needs
   more exploration first, `/michi-explore`.

---

## Customize Mode

**Invocation:** `/michi-bootstrap customize`

Add project- or team-specific overrides to Michi skill behavior. Creates
`docs/reference/extensions.md` — a file that Michi skills check before
applying their defaults. Anything in that file takes priority.

### Steps

1. **Check for existing extensions file.** If `docs/reference/extensions.md`
   already exists, note it and ask whether to review/edit the existing file or
   stop here. Don't overwrite.

2. **Create the extensions file.** Copy `references/extensions-template.md`
   to `docs/reference/extensions.md`. The template includes a suggested
   heading structure and examples.

3. **Wire it into CLAUDE.md.** Add `@docs/reference/extensions.md` to
   CLAUDE.md alongside existing `@`-refs so it's loaded at every session start.
   If CLAUDE.md doesn't exist, note that it should be created (suggest running
   `/michi-bootstrap` first).

4. **On-ramp the user.** After creating the file, briefly explain what to do
   with it:
   - `## Common` is for instructions that apply to all Michi skills — team
     conventions, issue tracker, branch naming, deploy process
   - Per-skill sections (`## michi-session`, `## michi-planning`, etc.) override
     behavior for that skill only
   - Can also ask: "Do you have a coding standards file I should reference?
     I can add a pointer in `## Common` so all skills know about it." If yes,
     add a line like: `See [path] for project coding standards.`
   - The file is plain markdown — edit it directly at any time

5. **Leave the rest to the user.** Don't attempt a guided walkthrough of every
   section. The template's examples are the guide. The user populates it as
   needs emerge.

---

## Multi-Project Migration Mode

**Invocation:** `/michi-bootstrap multi-project`

Migrate a single-project Michi repo to multi-project layout. One-time, mechanical — preserves git history via
`git mv`.

### When to use

- The repo is adding its first sub-project with an independent dev lifecycle.
- The user says "this should be multi-project now" / "let's split this into sub-projects."
- Heuristics detect sub-projects during a regular `/michi-bootstrap` run in an existing single-project Michi repo.

### Steps

1. **Confirm the repo is currently single-project Michi.** Verify `docs/epics/`, `docs/sidebars/`, `docs/journal.md`
   live at the root of `docs/` (not under `docs/ROOT/` or `docs/<name>/` already). If the repo is already
   multi-project, stop and direct to regular `/michi-bootstrap`.

2. **Confirm `multi-project: true` intent.** Ask the user which sub-projects they're introducing, in addition to the
   umbrella's existing work. Record the sub-project list.

3. **Preview the migration.** Repo-root UPPERCASE files stay at repo root — they describe the umbrella, which IS
   the repo. Only `docs/*` contents move:

   ```
   docs/epics/         → docs/ROOT/epics/
   docs/sidebars/      → docs/ROOT/sidebars/
   docs/reference/     → docs/ROOT/reference/
   docs/journal.md     → docs/ROOT/journal.md
   docs/memory.md      → docs/ROOT/memory.md

   # Stay in place (do NOT move):
   CLAUDE.md           → stays at repo root; gets repo-wide additions in step 5
   PROJECT.md          → stays at repo root (describes the umbrella)
   STATUS.md           → stays at repo root (umbrella's status)
   ARCHITECTURE.md     → stays at repo root (umbrella's design)
   README.md           → stays at repo root (public-facing orientation)
   ```

   Wait for user approval.

4. **Execute via `git mv`.** Preserves history. Do each move individually so the user can pause if anything looks
   wrong.

5. **Augment repo-root CLAUDE.md.** The existing CLAUDE.md already holds the umbrella's conventions/build/test
   (that's correct — keep it). Add the repo-wide layer *in place* — don't split, don't move. The additions:
   - **Project index** — one line per project pointing to `docs/<name>/`, including `ROOT`.
   - **Michi marker update** — add `multi-project: true` to the `## Michi` section.
   - **Pointer convention** — "When working on a specific sub-project under `<source-parent>/<name>/`, read
     `docs/<name>/CLAUDE.md`. Not auto-loaded; read when the sub-project is the subject of work."
   - **Cross-project rules** (if any) — conventions that apply to every project in the repo (naming, git, shared
     coding standards, commit format). Often already present from single-project days; tag them as "repo-wide,
     applies to all sub-projects" if the distinction matters.

6. **Create per-sub-project stubs.** For each sub-project the user named, create `docs/<name>/` with at minimum a
   `CLAUDE.md` stub. Sub-projects get full mini-Michi inside their dir (CLAUDE.md, PROJECT.md, STATUS.md,
   ARCHITECTURE.md, epics/, sidebars/, journal.md) per their chosen tier — unlike the umbrella, sub-projects
   don't have a "repo root" to themselves, so all their identity docs live at `docs/<name>/`. Ask about tier per
   sub-project (single-file / S / M / L) and scaffold accordingly — same as Phase 2/3 Multi-Project Branch.

7. **Verify.** Ask the user to spot-check the resulting structure:
   - `ls` at repo root: CLAUDE.md / PROJECT.md / STATUS.md / ARCHITECTURE.md / README.md / `docs/` — same shape
     as a single-project Michi repo.
   - `ls docs/`: `ROOT/` first, then sub-projects.
   - `docs/ROOT/`: contains only `epics/`, `sidebars/`, `journal.md`, `memory.md`, `reference/` — no CLAUDE.md,
     no PROJECT.md, no STATUS.md, no ARCHITECTURE.md.
   - `docs/<sub-project>/`: has its own CLAUDE.md/PROJECT.md/STATUS.md/ARCHITECTURE.md/epics/.
   - Repo-root CLAUDE.md should read as umbrella conventions + repo-wide rules + project index + pointer.

8. **Update STATUS.md** (repo-root) with a note that the repo transitioned to multi-project on `<date>`.
