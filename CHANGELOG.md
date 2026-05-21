# Changelog

The Michi toolkit uses [CalVer](https://calver.org/) — versions are dated
`YYYY.MM.DD`, with `.N` suffix if multiple releases ship the same day. This
file follows [Keep a Changelog](https://keepachangelog.com/) conventions:
each release groups changes under Added / Changed / Removed / Fixed.

The public repo (`csepulv/michi`) tracks `main` only — there are no release
tags. Each public commit corresponds to one published release, with the
matching version recorded here.

## [2026.05.20] - 2026-05-20

This release simplifies the document structure (sidebar folds into epic) and reshapes how the toolkit
frames skill choice and scope discipline. Workshop, planning, and session are now distinguished by the
mental work they ask of you rather than by ceremony level; several skills are now explicit that when the
human has picked a skill or set scope, the agent executes — it doesn't re-debate the choice. Also adds a
pattern for splitting `STATUS.md` across epics when the project has multiple authors or many concurrent
efforts.

### Added

- **`## Trust the Human's Framing` — new top-level sections in `michi-planning` and `michi-session`.**
  When the human has picked a skill (workshop vs. planning vs. session) and set scope, the agent's job is
  to execute, not re-triage the choice. Specific concerns are still surfaced (an assumption that seems
  wrong, a verification gap, a contract change) — but the choice of skill or shape of scope isn't
  re-argued. Addresses a repeated failure mode where agents argued "is this actually a sidebar or an
  epic?" or "should this be workshop or session?" against the human's explicit choice.

- **`### Human-Initiated Scope Changes` — new subsection in `michi-session`** alongside the existing
  Reactive Scope Changes (now renamed *Reactive Scope Changes (Agent-Initiated)* for symmetry). Names the
  case where the human adds work mid-session: end-loaded growth (work that fits after current milestones)
  gets absorbed silently — spiral iteration discovers things, and conversation about adding the work has
  already happened. Only *disruption* (rearranging or invalidating planned milestones) gets surfaced and
  confirmed.

- **`## STATUS at Scale` — new section in `toolkit/docs-structure.md`.** A pattern for projects where
  multiple authors or many concurrent epics make a single root `STATUS.md` a merge or scannability
  burden: split status by epic. Each active epic carries its own `STATUS.md`; the root file becomes a
  thin index using `@`-references to per-epic files. Verified at three levels of `@`-ref transitivity.
  Merge conflicts localize to per-epic files; the root index changes only when epics start or close.

- **Bootstrap-generated CLAUDE.md template now includes a Tooling & Permissions section.** Imports
  `.claude/settings.json` (and optionally `.claude/settings.local.json`) so the agent picks up project
  permission rules at session start, with a one-line nudge to prefer granted tools over those that prompt.
  Optional — the template instructs to delete the section if the project has no `.claude/settings.json`.

### Changed

- **`michi-workshop` reframed around the mental work it asks of you, not its ceremony level.** Workshop
  is where you hold "what does done mean" and "how to build it" in one head. Planning + session is where
  you deliberately separate those modes — define requirements and verification first, then implement.
  Use workshop when that separation isn't earning its weight; escalate when it is. Size correlates
  (smaller work usually doesn't need the split) but isn't the criterion. The prior framing leaned on
  size and ceremony scaling, which read as a softer-version-of-the-full-process; the new framing names
  the specific cognitive split the planning/session pair exists to support.

- **`michi-workshop`'s "Know When to Escalate" rewritten as "Know When to Surface (the Human Decides)."**
  Signals that the planning/session split would help are listed — scope expanded beyond what the
  contract names, decisions landing that affect work outside this task, verification infrastructure
  calling for explicit design, the two modes getting tangled in one head — but the agent's job is to
  surface what it's seeing, not to triage unilaterally. Explicit: don't argue if the human says stay in
  workshop. The framework is for the human's use, not for the agent to apply against the human's choice.

- **Epic framing in `toolkit/docs-structure.md` rewritten as "About Epics."** Epic is now the universal
  unit of named work — anything substantive enough to track gets one, scaling from a single file
  (`docs/epics/<topic>.md`) to a subdirectory when the work accumulates multiple milestones, supporting
  docs, or multiple authors. Multiple concurrent epics is normal; "which one is main" is signaled by
  STATUS and README, not by a separate doc tier.

### Removed

- **Sidebar as a distinct document tier — folded into epic.** Research, spikes, library evaluations,
  scope discussions — work that previously went to `docs/sidebars/<topic>.md` — now goes to
  `docs/epics/<topic>.md`, typically as a flat-file epic that grows to a subdirectory only if the work
  deepens. The position signal sidebars provided ("this isn't the main thrust") was already eroded in
  multi-author contexts and imperfect solo; the main-thrust answer lives in STATUS and README. The
  *Sidebars* section is removed from `toolkit/docs-structure.md`; references across `michi-workshop`,
  `michi-explore`, `michi-debrief`, `michi-sustainability`, and `michi-bootstrap` are updated to point
  at epics. Existing `docs/sidebars/` directories in projects remain — they drain through normal
  archive and sustainability work; the `michi-sustainability` Archive Candidates sub-mode still
  surfaces them.

## [2026.05.13] - 2026-05-13

This release adds a public surface for sharing in-progress Michi work outside the regular toolkit, and reorganizes an
existing principle to name a third common pattern of unsurfaced assumption.

### Added

- **New `toolkit/experimental/` directory — work-in-progress, shared early to allow others to explore and experiment.**
  Items here aren't part of the regular toolkit, so install with eyes
  open. Plugins use the `experimental-` name prefix. See [
  `toolkit/experimental/README.md`](toolkit/experimental/README.md) for the full contract.

- **(experimental) `experimental-nudge` plugin** — a Claude Code plugin that fires a brief consideration prompt as a
  system reminder after every tool-call iteration. The agent reads it and may engage; no gating, no enforcement. The
  bullets in the prompt are drawn from the Michi principles. **This is experimental — directionally positive evidence,
  not validated as a stand-alone intervention.** Install at your discretion:

  ```bash
  git clone https://github.com/csepulv/michi.git
  claude plugin marketplace add ./michi/toolkit
  claude plugin install experimental-nudge@michi
  ```

  See [`toolkit/experimental/nudge/README.md`](toolkit/experimental/nudge/README.md) for the full documentation,
  caveats, and disable instructions.

### Changed

- **`toolkit/principles.md` — three named patterns that pull the agent away from local sources, now grouped together
  under *Clarify before Asserting* as a bulleted "Resist these pulls" section.** Two were already there: training-data
  conventions exerting authority pull (the "black hole of the internet"), and provisional internal artifacts — draft
  sidebar items marked "resolved" that haven't actually shipped. The third is new: **the impulse to help (without full
  context and understanding)** — the agent's helpfulness mandate as a directional pull toward
  anticipation-as-assumption. When a user asks for a quick orientation and the agent delivers a plan with options and
  recommendations, the agent has assumed scope; looks like service, but is scope inflation. Specific corrective: *match
  the depth of the answer to the depth of the question.* If anticipation feels valuable, surface it as a question rather
  than a conclusion. Also added: a cross-link from *Surface Assumptions* noting that assumptions can arrive dressed as
  helpfulness.

- **Four skills got one-line ties to the new pull** where it commonly surfaces: `michi-explore` (Peek Mode),
  `michi-workshop` (Surface Assumptions discipline), `michi-planning` (Step 2 Surface Assumptions), and
  `michi-bootstrap` (Phase 1 Present Profile). Each names the pull and points at the principle in
  `references/principles.md`.

## [2026.05.11] - 2026-05-11

### Added

- **`michi-sustainability doc-compress` — new optional sub-mode.** Closing-flow step for
  compressing an epic's docs before archive. When an epic ships, much of its working
  scaffolding (per-milestone plans, individual milestone debriefs, scratch sidebars,
  decision drafts already in the code) no longer earns its weight. The sub-mode walks
  through what survives — a revised `spec.md` capturing what was actually delivered, a
  revised `verification.md` pointing at the long-lived automated tests, plus any
  epic-local `memory.md` / `journal.md` / `STATUS.md` — and what to promote before
  cutting (patterns to project-level reference docs; landmarks and durable decisions
  to project memory or key-decisions). Pairs with the existing Archive Candidates
  sub-mode as a two-step closing flow: compress, then archive.

- **`/michi-pr-prep tldr` — new output mode.** Produces only the short, essential
  version of a PR review guide, for reviewers who need orientation and not a deep map.
  The default `/michi-pr-prep` now produces a TLDR section followed by a Details
  section. The TLDR composes three elements: a one-paragraph *What This PR Does*
  summary; a new *How the diff breaks down* table that categorizes changed files by
  area with file counts and line deltas (gives the reviewer a one-glance sense of
  shape and scale); and a new *What to look at first* — 2-4 bullets pointing at the
  highest-value or highest-risk parts of the diff. The Details section retains the
  existing File Map / Design Decisions / Things to Check / What Was Not Changed /
  Process Notes content. The pre-existing "Two Modes" heading (in-session vs.
  from-the-diff context) is renamed to "Context Modes" so the context-availability
  dimension reads cleanly alongside the new TLDR-vs-full output-shape dimension.

### Changed

- **`toolkit/principles.md` — *Clarify before Asserting* principle expanded.** The
  principle, introduced in v2026.05.10, now spells out a four-level priority order
  for grounding decisions: most recent user instructions → session docs the user
  pointed at → repo and project docs → outside training-data knowledge. Two new
  framings: *authority ≠ accuracy* (even highest-authority sources can be wrong; the
  agent should surface incongruities and ask rather than silently pick a side); and
  two failure types — *untraceable* (basis can't be located in proximal sources) vs.
  *untrustworthy* (basis found but doesn't hold up: typo, contradiction, staleness,
  or cross-source conflict). The "black hole of the internet" section is broadened:
  provisional internal artifacts (sidebar drafts, friction-inventory entries marked
  "resolved" that still read as provisional) exert the same authority pull as
  external training-data conventions.

## [2026.05.10] - 2026-05-10

This release adds a Complexity/Uncertainty axis for pacing decisions and two
new principles on epistemic discipline — avoiding premature conclusions and
clarifying before asserting. The planning and workshop skills apply the
framework.

### Added

- **Complexity/Uncertainty pacing axis** in *Two Modes of Practice*
  (`toolkit/principles.md`). Mode (Paired vs. Entrusted) and C/U are
  independent axes; C/U shapes pacing (Crawl → Walk → Run → Fly) within either
  mode.
- **New principle: *Avoid Premature Optimization*** in `toolkit/principles.md`.
  Names a broader Premature Conclusion trap (generalization, consolidation,
  systemization, speed) and a remedy: intervention proportional to evidence.
- **New principle: *Clarify before Asserting*** in `toolkit/principles.md`.
  Names three sibling failure modes (asserting without basis, assuming without
  checking, debating without understanding) and one corrective: clarify first.
  Notes external training data as the common source — what looks like authority
  may be imported convention.
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
