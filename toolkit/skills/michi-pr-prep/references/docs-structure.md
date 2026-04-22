# Document Structure

Reference for how Michi projects organize documentation. Used by the planning, session, and debrief skills to
determine where information goes and when it's read.

---

## Principles

1. **Essentials first.** Organize by _what_ you're building (epics), not _how_ you organize (document type). The epic is
   the essential unit — plans, verification, and journals are incidental structure within it.
2. **Don't lose key information.** The goal is reducing re-discovery, not documentation perfection.
3. **Progressive detail.** Not every reader needs every detail at every moment. Principles → guidance → checklists. Size
   the document to its audience and moment. (See `toolkit/principles.md` — Progressive Detail.)
4. **Capture is continuous, curation is periodic.** The agent writes notes during implementation. The debrief curates
   them into the right places.
5. **One source of truth.** Decisions live in plan docs. Learnings live in journal files. Don't duplicate across tiers —
   promote by reference.

---

## Document Types

### Essential (the _what_ and _why_)

The reason the project exists.

| Document               | Purpose                                              | Size | Timeliness                                                |
| ---------------------- | ---------------------------------------------------- | ---- | --------------------------------------------------------- |
| `PROJECT.md`           | Goals, users, key features, success criteria         | M    | Long-lived, kept current                                  |
| Specs / requirements   | What to build — features, user stories, constraints  | M-L  | Lifecycle: current → on-deck → planned → ideas → archived |
| Verification scenarios | How to know it's delivered — the other side of specs | M-L  | Mirrors specs lifecycle                                   |

### Verification Artifacts (essential + incidental pair)

Verification is the umbrella. Under it, scenarios and test-plans form an essential/incidental pair — the same pattern as
specs and plans.

| Document                                                       | Category   | Purpose                                                                                                             | Size | Timeliness                                                                                                           |
| -------------------------------------------------------------- | ---------- | ------------------------------------------------------------------------------------------------------------------- | ---- | -------------------------------------------------------------------------------------------------------------------- |
| Scenario catalog (`verification/scenarios.md` or `scenarios/`) | Essential  | Living collection of verification scenarios — stories about users getting benefits, decomposed into Given-When-Then | M-L  | Long-lived, actively maintained. Grows via planning (co-design) and debrief (error analysis). Pruned during debrief. |
| Test plan (`verification/test-plan.md`)                        | Incidental | How to verify — tooling, auth strategy, environment prerequisites, which scenarios run when, infrastructure         | M    | Long-lived within an epic, updated as tooling and approach evolve.                                                   |
| Per-milestone scenarios (in plan docs `## Scenarios`)          | Essential  | Scenarios specific to a milestone, authored during planning                                                         | M    | Current during implementation. Promoted to the catalog during debrief if they have ongoing value.                    |

**Lifecycle:** Scenarios are created during planning (in the plan doc), executed during sessions, assessed during
debriefs. The debrief decides what gets promoted to the catalog (long-lived regression), updated (changed behavior), or
retired (no longer relevant). Maintenance between sessions — reorganizing, consolidating, updating for changed APIs —
can happen as a separate activity.

### Incidental (the _how_)

These serve the essential work — architecture, conventions, plans, process.

| Document                       | Purpose                                                                                              | Size | Timeliness                                                                      |
| ------------------------------ | ---------------------------------------------------------------------------------------------------- | ---- | ------------------------------------------------------------------------------- |
| `README.md`                    | Orientation — what exists, where to look, how to start                                               | S-M  | Long-lived, kept current                                                        |
| `CLAUDE.md` / `AGENTS.md`      | Agent rules, conventions, key references                                                             | M    | Long-lived, updated after debriefs                                              |
| `ARCHITECTURE.md`              | Design overview, component relationships, data flow                                                  | M-L  | Long-lived, updated when architecture changes                                   |
| `STATUS.md`                    | Current state — what's active, what's next                                                           | S    | Updated every session                                                           |
| Plans                          | Tactical implementation steps for a milestone                                                        | M-L  | Current during implementation, archived after                                   |
| Debriefs                       | Post-session assessments — full for epics, short summary in journal for smaller work                 | S-M  | Written after sessions that warrant it, accumulates over the epic               |
| Journal                        | Execution record — learnings, open questions, discussion items, gotchas                              | M    | Accumulated during implementation, curated during debriefs                      |
| Roadmap (optional)             | Ideas, potential epics, future directions — not yet committed to a plan                              | S-M  | Long-lived, updated as ideas emerge or are promoted to epics                    |
| Sidebars                       | Research, spikes, explorations, architecture discussions — work that informs epics but isn't an epic | S-M  | Variable — some ephemeral, some long-lived if the output feeds future decisions |
| Recipes / guides / skills      | How-to for human and/or agent                                                                        | M    | Long-lived reference                                                            |
| Code style / coding principles | Applied coding judgment — sharpened through debriefs                                                 | M    | Long-lived, grows incrementally                                                 |

---

## Progressive Detail

Not every reader needs every detail at every moment. Load the right depth at the right time.

### Project Docs (S / M / L / XL)

| Level  | Purpose                                    | Who reads                                      | When                   | Examples                                         |
| ------ | ------------------------------------------ | ---------------------------------------------- | ---------------------- | ------------------------------------------------ |
| **S**  | Orientation — what exists, where to look   | Everyone, every session                        | Always loaded          | `README.md`, `STATUS.md`                         |
| **M**  | Working context — enough to act            | Agent at session start, human reviewing        | Loaded on demand       | `CLAUDE.md`, `PROJECT.md`, current plan doc      |
| **L**  | Full detail — implementation depth         | Agent during implementation, human deep-diving | Referenced when needed | `ARCHITECTURE.md`, verification scenarios, specs |
| **XL** | Posterity — minimize loss, may rarely read | Future sessions, retrospectives                | Stored, not loaded     | Journals, archived plans, session transcripts    |

### Process Docs (Principles / Guidance / Checklists)

| Level          | Purpose                                            | When loaded               | Examples                                          |
| -------------- | -------------------------------------------------- | ------------------------- | ------------------------------------------------- |
| **Principles** | The "why" — always in context                      | Always (`@`-referenced)   | `toolkit/principles.md`, project-level principles |
| **Guidance**   | The "what and when" — loaded when entering a phase | On demand, at phase start | Skill preambles, reference docs                   |
| **Checklists** | The "how exactly" — referenced during execution    | During execution          | Skill bodies, templates, verification steps       |

The agent internalizes principles, loads guidance when entering a phase, references checklists when executing. Same way
a human engineer works: know the principles by heart, understand the guidance for the current phase, reference the
checklist when doing the work.

See `toolkit/principles.md` for full principle definitions.

### How This Maps to CLAUDE.md

The `@`-reference mechanism in CLAUDE.md controls what loads at session start:

```markdown
# CLAUDE.md
@./PROJECT.md          # M — always loaded
@./STATUS.md           # S — always loaded
@./ARCHITECTURE.md     # L — loaded but could be large

## Current Work
@./docs/epics/chat-plugin/plans/m7-cli-scanner.md    # M — current milestone plan
```

The "always" tier is `@`-referenced. The "for this work" tier is added/removed as milestones change. L and XL tiers are
findable but not auto-loaded.

---

## File Naming

| Convention     | Meaning                                           | Examples                                                               |
| -------------- | ------------------------------------------------- | ---------------------------------------------------------------------- |
| `UPPERCASE.md` | Top-level, always-read, project-wide              | `README.md`, `CLAUDE.md`, `PROJECT.md`, `STATUS.md`, `ARCHITECTURE.md` |
| `lowercase.md` | Working documents, scoped to an epic or milestone | `m7-cli-scanner.md`, `learnings.md`, `scenarios.md`                    |

Capitalization signals importance — the filesystem communicates priority without metadata.

---

## Docs Root

By default, Michi docs live in `docs/`. Projects with existing external-facing documentation (product docs, API docs,
customer content) may need a separate directory.

CLAUDE.md defines the docs root:

```markdown
## Michi
docs-root: docs           # default — most projects
docs-root: docs/michi     # project with external docs in docs/
```

Bootstrap sets this during onboarding. All Michi skills read the configured path. If `docs-root` is not defined in
CLAUDE.md, skills default to `docs/`.

## Single-Project Directory Structure

This is the default Michi layout. Multi-project repos extend it — see
[Multi-Project Directory Structure](#multi-project-directory-structure) below.

```
project/
  README.md                              # S  — orientation, roadmap
  CLAUDE.md                              # M  — agent rules, @-refs to other docs
  PROJECT.md                             # M  — goals, users, features
  ARCHITECTURE.md                        # L  — design overview
  STATUS.md                              # S  — current state, active work
  docs/                                  # docs-root (configurable in CLAUDE.md)
    roadmap.md (optional)                # S-M — ideas, potential epics, future directions
    epics/                               # Essential — organized by effort
      chat-plugin/
        spec.md (or specs/)              #   What to build (essential)
        verification/                    #   What "working" means + how to prove it
          scenarios.md (or scenarios/)   #     Essential: stories, intent, given-when-then
          test-plan.md                   #     Incidental: tooling, auth, strategy, infrastructure
        journal.md (or journal/)         #   Execution record: learnings, questions, discussion, gotchas
        debriefs/                        #   Post-session assessments (one per milestone debriefed)
          m1-debrief.md
          m2-debrief.md
        plans/                           #   How to build each milestone (incidental)
          m1-data-model.md
          m2-chat-services.md
      another-epic/
        spec.md
        verification/
          scenarios.md
          test-plan.md
        sidebars/                        #   Epic-scoped research and spikes
          state-lib-evaluation.md
        journal.md
        debriefs/
        plans/
          ...
    sidebars/                            # Project-scoped research, spikes, explorations
      service-split-exploration.md       #   Single-file sidebar
      auth-strategy/                     #   Multi-file sidebar (grows as needed)
        findings.md
        options.md
    reference/                           # Long-lived, cross-epic
      code-style.md                      #   Applied coding principles (grows via debriefs)
      key-decisions.md                   #   Decisions that span epics
      api-design-guide.md               #   Guides, cheatsheets
      ...
    archive/                             # Completed epics, moved whole
      some-old-epic/
        spec.md
        verification/
        journal.md
        debriefs/
        plans/
```

### Why Epics, Not Topic Folders

The previous structure used `docs/plans/`, `docs/verification/`, `docs/learnings/` — organized by document type. That
optimizes for cross-cutting views ("show me all plans") that are rarely needed.

The epic-based structure optimizes for the view you actually use: "show me everything about this effort." When you're
working on the chat plugin, everything you need is in `docs/epics/chat-plugin/`. Archiving is moving one directory.

Cross-epic concerns (project-wide decisions, guides, cheatsheets) live in `docs/reference/`.

### Applied Coding Principles (`docs/reference/code-style.md`)

Abstract coding principles (from CLAUDE.md or global rules) need calibration — concrete examples of when and how to
apply them. This calibration accumulates through debriefs: when the human corrects or refines the agent's code quality
approach, the applied example gets captured here.

**Example:** A rule says "separate what from how." The code-style doc adds: "An orchestrator that does parse → filter →
correlate → format should read as those four words. If you need a comment to explain what a block does, extract it — the
function name is the comment."

Referenced from `.claude/rules/` so it's auto-loaded:

```
.claude/rules/project-rules.md    →  @docs/reference/code-style.md
```

The content lives in `docs/` (version-controlled, reviewable, project-scoped). The rules file is a thin pointer. For
cross-project principles, the rules file can also reference global rules (`@~/.claude/rules/react-patterns.md`).

**Lifecycle:** Starts sparse during bootstrap. Grows incrementally through debriefs and sustainability checks. Each
entry is an applied example, not an abstract principle — the abstract version already lives in CLAUDE.md or global
rules.

### Sidebars (`docs/sidebars/`)

Work that informs epics but isn't an epic: library evaluations, architecture explorations, research spikes, scope
discussions, tool comparisons. The output is typically a decision, a recommendation, or a set of options — not code.

Sidebars follow the same "start with files, split to directories" convention as epics:

- **Small sidebar:** `docs/sidebars/state-lib-evaluation.md`
- **Growing sidebar:** `docs/sidebars/service-split-exploration/findings.md`, `options.md`

No prescribed internal structure — sidebars are flexible by nature. Directory-level sidebars can include `debriefs/`
when the work warrants post-session assessment. The key question: does the output have lasting value? If yes (a decision
affecting future epics, a recommendation worth referencing), it belongs here. If not (a quick spike confirming "yes this
works"), a plan doc note is sufficient.

**Scope determines location.** Sidebars can live at project scope or epic scope:

- **`docs/sidebars/`** — project-scoped: research spanning epics or not tied to one
- **`docs/epics/<epic>/sidebars/`** — epic-scoped: research that emerged during and primarily serves this epic

Put it where it emerged. Promote to project scope if it outgrows the epic — same as how plan doc decisions get promoted
to `docs/reference/` during debrief.

Sidebars may feed into epic planning — a library evaluation produces a recommendation that becomes a constraint in the
next epic's spec. Reference from plan docs when relevant.

### Scaling Within an Epic

Each sub-item (spec, verification, journal, plans) can be a single file or a directory depending on scope:

- **Small epic:** `spec.md`, `verification/scenarios.md`, `verification/test-plan.md`, `journal.md`, `debriefs/m1-debrief.md`, `plans/m1-thing.md`
- **Large epic:** `specs/feature-a.md`, `verification/scenarios/submit-flow.md`, `verification/scenarios/sync-flow.md`,
  `verification/test-plan.md`, `journal/service-gotchas.md`, `journal/extension-gotchas.md`, `debriefs/m3-debrief.md`

Start with files. Split to directories when a file gets unwieldy. The structure grows with the work.

---

## Multi-Project Directory Structure

For repos holding multiple sub-projects with independent dev lifecycles, the single-project structure above extends
with a per-sub-project namespace. Every directory under `docs/` is a named project, including the umbrella.

**Applies when** a piece of the repo has its own dev lifecycle — its own epics, its own status, its own story — that
should not mingle with the parent. This is a dev-process question, not a build-tooling one: a package-manager monorepo
(pnpm workspaces, turbo) may or may not need this pattern, and a repo without a shared build system may absolutely need
it. "Multi-project" is the Michi term; "monorepo" is a common synonym.

Single-project Michi repos are unchanged — keep the flat `docs/epics/`, `docs/sidebars/`, `docs/journal.md` layout.

### Layout

The umbrella's identity docs (CLAUDE.md, PROJECT.md, STATUS.md, ARCHITECTURE.md, README.md) stay at repo root — the
repo IS the umbrella. Only the umbrella's *working* docs move under `docs/ROOT/`. Sub-projects get their full
mini-Michi (identity + working) under `docs/<name>/`.

```
project/
  tools/                        # or packages/, apps/, services/ — source dirs
    <sub-project>/
      README.md                 # public-facing; source + README only
      src/  tests/  ...

  # Repo-root UPPERCASE files describe the umbrella — stay here:
  CLAUDE.md                     # umbrella conventions + repo-wide layer (one file)
  PROJECT.md                    # umbrella's project doc
  STATUS.md                     # umbrella's status
  ARCHITECTURE.md               # umbrella's design
  README.md                     # public-facing repo orientation

  docs/                         # docs-root
    ROOT/                       # umbrella's WORKING docs only — always created
      journal.md                # umbrella's journal
      memory.md                 # umbrella's memory
      reference/                # umbrella-scoped reference
      epics/                    # umbrella's epics
      sidebars/                 # umbrella's sidebars
    <sub-project>/              # full mini-Michi per sub-project, scaled to size
      CLAUDE.md  PROJECT.md  STATUS.md  ARCHITECTURE.md
      epics/  sidebars/  journal.md
    <another-sub-project>/
      single-plan.md            # minimal — just one file
```

### Repo-root CLAUDE.md (umbrella + repo-wide in one file)

Repo-root CLAUDE.md is one file holding both the umbrella's own CLAUDE content AND the repo-wide layer. No split. No
separate `docs/ROOT/CLAUDE.md`. Contents:

- **Umbrella's own conventions** — build/test commands, code style pointers, key files, gotchas specific to the
  umbrella project. Same content a single-project Michi repo's CLAUDE.md holds.
- **Cross-project rules** (new in multi-project) — conventions that apply to every project in the repo (naming, git,
  shared coding standards, commit format, PR process).
- **Project index** (new) — one line per project pointing to `docs/<name>/`, including `ROOT`.
- **Michi marker:**
  ```markdown
  ## Michi
  docs-root: docs
  multi-project: true
  ```
- **Pointer to per-sub-project CLAUDE.md** (new) — "when working on sub-project X, read `docs/X/CLAUDE.md`."
  Sub-project CLAUDE.mds are NOT auto-loaded; read explicitly when that sub-project is the session's subject.

### Rules

- **`ROOT/` is the universal umbrella name** — same in every multi-project Michi repo. All-caps matches the
  UPPERCASE-for-top-tier convention, sorts first in `ls`, works regardless of whether the umbrella owns substantive
  product work or just holds repo-wide conventions.
- **`ROOT/` is always created** for multi-project repos, even when minimal. The idiom is universal — no exceptions.
- **Umbrella identity docs stay at repo root.** CLAUDE.md, PROJECT.md, STATUS.md, ARCHITECTURE.md, README.md — the
  repo IS the umbrella; the identity sits at the top. `docs/ROOT/` holds only the umbrella's *working* docs.
- **Source/docs boundary.** Source dirs hold `README.md` + code only. For sub-projects, all internal dev knowledge
  (CLAUDE.md, epics, plans, sidebars, journal) lives under `docs/<name>/`. Source dirs stay publishable; docs stay
  private until deliberately exposed.
- **Capitalization rules apply within sub-project dirs.** UPPERCASE files (`CLAUDE.md`, `PROJECT.md`, `STATUS.md`,
  `ARCHITECTURE.md`) = always-read when working on that sub-project. lowercase = working documents.
- **Plans live in `epics/<epic>/plans/` inside sub-projects too.** Same progressive rule as single-project Michi.
- **Sub-projects scale progressively** — start with files, grow to directories as scope demands. ROOT is not
  really a "sub-project" for this purpose — it holds only working docs, no identity docs.
- **A sub-project gets a `docs/<name>/` dir only when it accumulates dev knowledge.** (ROOT excepted — always created.)

### Single → Multi-Project Migration

Transitioning from single-project to multi-project is a one-time migration — only `docs/*` contents move; repo-root
UPPERCASE files stay in place:

- `git mv docs/epics docs/ROOT/epics` (same for `sidebars/`, `reference/`)
- `git mv docs/journal.md docs/ROOT/journal.md` (same for `memory.md`)
- Repo-root CLAUDE.md, PROJECT.md, STATUS.md, ARCHITECTURE.md, README.md **stay at repo root**
- Repo-root CLAUDE.md is *augmented* in place with the repo-wide layer content (project index, `multi-project: true`,
  pointer convention). No split, no move.

Bootstrap provides a subcommand for this (`/michi-bootstrap multi-project`).

See `docs/sidebars/multi-project-doc-structure.md` for the full rationale and options considered.

---

## Information Flow

### During a Session (agent writes)

The agent writes to **one place**: the current milestone's plan doc (inside the epic).

| What                    | Where in plan doc            | When                                                        |
| ----------------------- | ---------------------------- | ----------------------------------------------------------- |
| Implementation progress | `## Steps` (check off items) | As steps complete                                           |
| Decisions               | `## Decisions` section       | Immediately when a choice is made                           |
| Surprises / gotchas     | `## Notes` section           | Immediately when encountered                                |
| Discussion items        | `## Discussion` section      | When the agent identifies something to raise with the human |
| Deviations from plan    | `## Steps` or `## Notes`     | When the deviation happens                                  |
| Verification results    | `## Verification` checklist  | Post-milestone                                              |

The agent doesn't need to think about which tier or which file. Write to the plan doc. The debrief sorts it later.

### Post-Milestone (agent writes)

| What             | Where                              |
| ---------------- | ---------------------------------- |
| Milestone status | `STATUS.md` — update current state |
| Commit           | Git — `michi(mN): description`       |

### During Debrief (agent + human curate)

The debrief skill reviews what was captured, writes the debrief artifact, and promotes findings:

**Primary artifact:** The debrief itself is written to `debriefs/mN-debrief.md` — a coherent assessment of the session
covering delivery, decisions, bugs, process observations, and trust calibration. This is the complete record; the
promotion table below extracts specific findings into their long-lived homes.

| Source                     | Destination                                               | Criteria for promotion                                                                     |
| -------------------------- | --------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Plan doc `## Decisions`    | `docs/reference/patterns.md`                              | Decision reveals a reusable pattern or anti-pattern                                        |
| Plan doc `## Decisions`    | `CLAUDE.md`                                               | Decision should be a permanent rule for this project                                       |
| Plan doc `## Notes`        | Epic's `journal.md`                                       | Domain-specific gotcha worth preserving                                                    |
| Plan doc `## Notes`        | `docs/reference/patterns.md` or epic's `journal.md`       | Process insight about methodology                                                          |
| Plan doc `## Discussion`   | Resolved, deferred, or promoted to project-level question | Triaged during debrief                                                                     |
| Plan doc `## Scenarios`    | Epic's `scenarios.md` (catalog)                           | Scenario has ongoing regression value                                                      |
| Bugs found                 | Epic's `scenarios.md` (catalog)                           | Error analysis: write the scenario that would have caught it                               |
| Cross-epic decisions       | `docs/reference/key-decisions.md`                         | Decision affects the whole project, not just this epic                                     |
| Human coding interventions | `docs/reference/code-style.md`                            | Human corrected or refined the agent's code quality approach — capture the applied example |
| Session observations       | `docs/reference/patterns.md`                              | New pattern with high confidence                                                           |

**Verification artifact lifecycle:** Scenarios are promoted, updated, or retired during debrief. Ongoing regression
value → epic catalog. Broken by intentional changes → updated. No longer relevant → retired. Maintenance (reorganizing,
consolidating) can happen between sessions as a separate activity.

**What gets discarded:** Implementation details now in the code, temporary debugging notes, one-off observations that
don't generalize.

### Between Sessions (human curates)

| Task                                         | When                        |
| -------------------------------------------- | --------------------------- |
| Update CLAUDE.md `@`-refs for next milestone | Before next session         |
| Move completed epics to `docs/archive/`      | When the epic is fully done |
| Review and prune CLAUDE.md                   | Every 3-5 sessions          |
| Review `STATUS.md` for staleness             | Before each session         |

---

## Notifications

Notify the human when their involvement would change the outcome. Four triggers:

| Trigger                  | Why                                                                  | Channel          |
| ------------------------ | -------------------------------------------------------------------- | ---------------- |
| Contract-change decision | Human may disagree with an API/schema change                         | Slack + plan doc |
| Verification failure     | Real API call failed — may indicate a design problem, not just a bug | Slack            |
| Blocker                  | Agent can't proceed without human input                              | Slack + plan doc |
| Milestone completion     | Checkpoint for async review                                          | Slack            |

Everything else is logged, not notified. The human reads it during the debrief.

---

## Timeliness States

Documents have a lifecycle. Not everything is "current."

| State        | Meaning                                       | Location                                      |
| ------------ | --------------------------------------------- | --------------------------------------------- |
| **Current**  | Active, being worked against now              | `docs/epics/<epic>/plans/`                    |
| **On-deck**  | Next up, may need refinement                  | `docs/epics/<epic>/plans/` (draft or outline) |
| **Planned**  | Eventually, shape is known but details aren't | `STATUS.md` or spec outline                   |
| **Ideas**    | Maybe, unvalidated                            | `STATUS.md` ideas section                     |
| **Archived** | Done or closed, kept for reference            | `docs/archive/<epic>/`                        |

Plans and specs move through this lifecycle. Top-level docs (`CLAUDE.md`, `PROJECT.md`, `ARCHITECTURE.md`) don't —
they're living documents that stay current.

---

## Pragmatic Application

This structure is a target, not a prerequisite. For Round 2:

1. **Add `PROJECT.md`** to the target project if it doesn't exist
2. **Capitalize the top-tier docs** — signal what's always-read
3. **Create `docs/epics/<epic>/`** for the current effort
4. **Use the plan doc template** with `## Decisions`, `## Notes`, `## Discussion`, `## Scenarios` sections
5. **Add `@`-refs in CLAUDE.md** for the current milestone's plan
6. **Create `docs/reference/`** when you have cross-epic content
7. **Create `docs/archive/`** when an epic completes

Start with files, split to directories as scope demands. Don't restructure everything at once — migrate docs as they're
touched.
