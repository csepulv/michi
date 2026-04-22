# Getting Started

How to set up a project for Michi and run your first session.

---

## Prerequisites

- Claude Code installed and working
- A project with a git repository
- The Michi toolkit installed — copy the skills from `toolkit/skills/` to your project's `.claude/skills/`

## Installation

Copy the skill directories into your project's `.claude/skills/`:

```bash
cp -r <michi-path>/toolkit/skills/michi-* .claude/skills/
```

This installs all ten skills. Copy only specific skill directories if you want a narrower subset. Each skill is self-contained — its `references/` folder includes everything it needs.

## Skill Order

### First time: Bootstrap

Invoke `michi-bootstrap` to set up your project's documentation structure. It surveys your codebase, assesses what exists,
and walks you through creating what's missing.

**Greenfield projects** (new or near-empty): Bootstrap scaffolds the full Michi structure — CLAUDE.md, PROJECT.md,
STATUS.md, and the first epic directory. It drafts each document with you interactively.

**Brownfield projects** (existing code and docs): Bootstrap assesses the gap between what you have and the Michi
structure, then presents effort tiers (S/M/L/XL). You pick how much to set up now. Anything deferred goes to a roadmap.

### Each milestone: Plan → Execute → Debrief

Once bootstrapped, every milestone follows a three-skill loop:

1. **`michi-planning`** — Explore the relevant codebase, surface assumptions, co-design verification scenarios, and write
   the milestone plan doc. The plan is a contract — implementation executes against it.

2. **`michi-session`** — Execute the plan. This skill is **rigid** — follow every step. Test after every file change. Log
   decisions immediately. Run the full verification checklist before committing. The discipline is the point.

3. **`michi-debrief`** — Review what happened. Triage decisions and discussion items. Promote learnings to the journal,
   patterns to patterns.md, rules to CLAUDE.md. Curate verification scenarios (promote, update, or retire). Calibrate
   trust for the next session.

### Between milestones: Sustainability

Invoke `michi-sustainability` between milestones or epics for health checks. It scales to context:

- **Within a milestone** (10-15 min) — quick refactoring and test quality check
- **Between milestones** (30-60 min) — accumulated code quality, architectural alignment, knowledge gaps
- **Between epics** (1-2 hours) — overall direction, principles alignment, process retrospective

### During planning: Scenario Test Builder

Invoke `michi-scenario-test-builder` during planning to generate verification scenarios using Cem Kaner's methodology.
This feeds into the plan doc's Scenarios section.

### Other skills

Four additional skills cover work that doesn't fit the core lifecycle:

- **`michi-explore`** — Structured conversation for investigative work: orienting on a new area, researching options,
  brainstorming. Lighter than planning; no implementation required.
- **`michi-workshop`** — A lighter-weight alternative to the full planning → session → debrief cycle. For bug fixes,
  small features, and quick explorations where the ceremony of a full epic is overkill.
- **`michi-pr-prep`** — Prepares a companion PR review guide: what reviewers are looking at, why key decisions were
  made, and where to focus attention. Invoke before requesting PR review.
- **`michi-docs-site`** — Scaffolds an internal Astro + Starlight docs browser for browsing project docs, or generates
  a PDF build recipe for an existing Starlight site.

## Modes of Practice

**The first epic is always Paired.** The Michi context that makes wider autonomy viable — journals, learnings, scenario
catalogs, architecture docs — doesn't exist yet. The starting spec is a hypothesis: it may reference tools that don't
exist or make assumptions that haven't been validated. Paired mode is how the human and agent build shared context about
both the project and the Michi process. Start slow, earn speed within the session — don't try to instantly accelerate.

**Earn Entrusted mode.** As Michi context accumulates and verification quality improves, widen the loop. The agent takes
more initiative, you review at gates and exceptions. Decision logging and verification infrastructure see for you.
Earned through demonstrated mastery — of the tools, the codebase, and the verification discipline.

**Move back to Paired when needed.** New codebase, risky work, lost confidence — slow down. This isn't regression. It's
knowing when you need visibility.

## Key Documents

Bootstrap creates these, but knowing their purpose helps:

| Document                          | Purpose                                                               | Always loaded?               |
| --------------------------------- | --------------------------------------------------------------------- | ---------------------------- |
| `CLAUDE.md`                       | Agent rules, conventions, build/test commands, verification checklist | Yes                          |
| `PROJECT.md`                      | Goals, users, features, success criteria — the "why"                  | Yes                          |
| `STATUS.md`                       | Current state, active work, what's next                               | Yes                          |
| `ARCHITECTURE.md`                 | Design overview, component relationships, data flow                   | On demand                    |
| `docs/epics/<name>/plans/`        | Milestone plans — the implementation contract                         | Current milestone            |
| `docs/epics/<name>/verification/` | Scenarios and test strategy                                           | During planning/verification |
| `docs/epics/<name>/journal.md`    | Learnings, gotchas, open questions                                    | During debrief               |

## Further Reading

- [Principles](principles.md) — the north-star guidelines everything builds on
- [Overview](overview.md) — how the toolkit works, verification strategy, modes of practice
- [Document Structure](docs-structure.md) — how target projects organize documentation
- [Skills README](skills/README.md) — skill details, structure, and flow
