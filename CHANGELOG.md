# Changelog

The Michi toolkit uses [CalVer](https://calver.org/) — versions are dated
`YYYY.MM.DD`, with `.N` suffix if multiple releases ship the same day. This
file follows [Keep a Changelog](https://keepachangelog.com/) conventions:
each release groups changes under Added / Changed / Removed / Fixed.

The public repo (`csepulv/michi`) tracks `main` only — there are no release
tags. Each public commit corresponds to one published release, with the
matching version recorded here.

## [2026.05.10] - 2026-05-10

This release adds a Complexity/Uncertainty axis for pacing decisions and a new
principle on avoiding premature conclusions. The planning and workshop skills
apply the framework.

### Added

- **Complexity/Uncertainty pacing axis** in *Two Modes of Practice*
  (`toolkit/principles.md`). Mode (Paired vs. Entrusted) and C/U are
  independent axes; C/U shapes pacing (Crawl → Walk → Run → Fly) within either
  mode.
- **New principle: *Avoid Premature Optimization*** in `toolkit/principles.md`.
  Names a broader Premature Conclusion trap (generalization, consolidation,
  systemization, speed) and a remedy: intervention proportional to evidence.
- **`michi-planning` C/U pre-flight.** Agent assesses where the milestone sits
  on Complexity/Uncertainty and records it in the plan doc before exploring.
- **`michi-workshop` *Mind the Complexity and Uncertainty* discipline.**
  Workshop's lighter ceremony doesn't lower work's risk; the new discipline
  adjusts pacing and pairing within workshop. Don't confuse *small* with
  *safe*.

### Changed

- **`michi-workshop` escalation framing.** Escalation triggers now reflect
  ceremony growth, not risk; risk is handled by the new C/U discipline.
- **`michi-sustainability` archive-sweep policy.** Agent runs `git mv` directly
  for archive renames; bulk sweeps (>5 files) require confirmation.

## [2026.05.02] - 2026-05-02

First versioned release of the Michi toolkit. Adds CalVer versioning, an
`agent-sync` install path, and a set of changes aimed at keeping project
documentation reliably up-to-date as agents work in a codebase.

### Added

- **Versioning.** `toolkit/VERSION` and `CHANGELOG.md` use CalVer
  (`YYYY.MM.DD`) and [Keep a Changelog](https://keepachangelog.com/) format.
- **Install via `agent-sync`.** The published
  `toolkit/skills-directory.yaml` now references each skill by its GitHub
  URL on `csepulv/michi`, so external users can install with
  [`agent-sync`](https://github.com/csepulv/save-the-tokens/tree/main/tools/agent-sync).
  `toolkit/getting-started.md` documents both the copy-based and
  `agent-sync`-based install paths.
- **`toolkit/ground-rules.md`** — guidance on how an agent should read
  the project's root documents (`STATUS.md`, `PROJECT.md`,
  `ARCHITECTURE.md`, `CLAUDE.md`, `journal.md`): what to trust, what to
  verify before acting, and how to interpret each doc's freshness stamp.
  Loaded by every Michi skill alongside `principles.md`.
- **End-of-session step in `michi-workshop`, `michi-session`,
  `michi-planning`, `michi-debrief`, `michi-sustainability`, and
  `michi-explore`:** re-read `STATUS.md` against current reality and update
  its `**Last updated:** YYYY-MM-DD` stamp. Closes the common gap where a
  session produces real changes but the project's "what's active right
  now" document silently drifts.
- **Two opt-in `michi-sustainability` sub-modes:**
  - *Doc Drift Audit* — scan long-lived reference docs for statements
    that no longer match the code (renamed functions, moved files,
    instructions that have rotted).
  - *Archive Candidates* — surface completed epics and superseded
    sidebars under `docs/` that should move to `docs/archive/`. Adopts a
    `-MMDDYY` date-suffix naming convention so archived items don't
    collide with new work that reuses the name.
- **Doc Currency section in `toolkit/docs-structure.md`.** Top-of-doc
  `**Last updated:** YYYY-MM-DD` is mandatory for `STATUS.md` and
  `journal.md`. Per-section `**last-verified:** YYYY-MM-DD` is recommended
  for `ARCHITECTURE.md` and files under `docs/reference/`. The stamp tells
  a reader how recently a doc was verified — recent means trust cheaply,
  old means verify before acting on it.
- **`michi-workshop` bug-fix mode.** New `/michi-workshop bugfix <description>`
  invocation produces a journal entry by default instead of scaffolding a
  `docs/workshop/<topic>.md` doc. The skill confirms with the user before
  producing more than the journal note.
- **"Workshop work" guidance in `toolkit/docs-structure.md`.** Documents
  that workshop output rolls up into existing tiers (journal entry, sidebar,
  or active epic) rather than getting its own `docs/workshop/` directory.
- **`publish/README.md` shows the current toolkit version.** A
  `**Current version:** v<version>` line links to `CHANGELOG.md`. Updated
  by the release-prep flow on each version bump.
### Changed

- **`michi-debrief` reorganized into three explicit passes:**
  1. *Assess* — what was delivered; capture decisions, learnings, bugs,
     and process observations.
  2. *Invalidate* — audit what previously-recorded knowledge
     (`STATUS.md`, `ARCHITECTURE.md`, `docs/reference/`, journal entries)
     was just made wrong by this session, and fix it.
  3. *Currency + Cleanup* — refresh `**Last updated:**` /
     `**last-verified:**` stamps on touched docs and prune obviously stale
     references.

  Includes a table at the top of the skill listing the typical reasons a
  session rationalizes skipping Pass 2 and Pass 3, with rebuttals.
- **`toolkit/skills/build.sh`** now copies `ground-rules.md` into every
  skill's `references/` directory alongside `principles.md` and
  `docs-structure.md`. If you've extended a Michi skill, re-run `build.sh`
  to pick up the new shared reference.
