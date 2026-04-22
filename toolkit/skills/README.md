# Michi Skills

Skills that guide the michi process. Each skill is a directory with a `SKILL.md` and a `references/` folder
containing the docs it depends on.

## Skills

| Skill                                                           | Type     | When to Use                                                                                                                              |
| --------------------------------------------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| [michi-bootstrap](michi-bootstrap/SKILL.md)                         | Flexible | Before first Michi session — onboard a project, assess gaps, scaffold docs                                                                 |
| [michi-explore](michi-explore/SKILL.md)                             | Flexible | Structured conversation for investigative work — cold starts, research, brainstorming, pre-planning, sidebars                            |
| [michi-planning](michi-planning/SKILL.md)                           | Flexible | Before implementation — prepare the milestone plan, explore codebase, surface assumptions, define acceptance criteria                    |
| [michi-session](michi-session/SKILL.md)                             | Rigid    | During implementation — execute the milestone with mandatory verification, decision logging, sustainability check, and commit discipline |
| [michi-debrief](michi-debrief/SKILL.md)                             | Flexible | After implementation — review decisions, capture learnings, update applied coding principles, calibrate trust                            |
| [michi-sustainability](michi-sustainability/SKILL.md)               | Flexible | Between milestones or epics — assess code quality, test quality, architectural alignment, knowledge gaps                                 |
| [michi-scenario-test-builder](michi-scenario-test-builder/SKILL.md) | Flexible | During planning — generate Kaner-style verification scenarios, build test plans, define acceptance criteria                              |
| [michi-workshop](michi-workshop/SKILL.md)                           | Flexible | Everyday work — bug fixes, small features, quick explorations with Michi discipline                                                        |

## Structure

```
skills/
  build.sh                        # Syncs shared references (principles.md, docs-structure.md)
                                   # to all skill references/ directories. Run after editing
                                   # toolkit/principles.md or toolkit/docs-structure.md.

  michi-bootstrap/
    SKILL.md
    references/
      principles.md               # Shared: north-star principles
      docs-structure.md            # Shared: target structure to assess against
      CLAUDE-MD-template.md        # Template for CLAUDE.md
      PROJECT-template.md          # Template for PROJECT.md

  michi-explore/
    SKILL.md
    references/
      principles.md               # Shared
      docs-structure.md            # Shared

  michi-planning/
    SKILL.md
    references/
      principles.md               # Shared
      docs-structure.md            # Shared
      plan-template.md             # Milestone plan template

  michi-session/
    SKILL.md
    references/
      principles.md               # Shared
      docs-structure.md            # Shared
      target-code.md               # Core loop and verification for code deliverables
      target-non-code.md           # Core loop and exit criteria for non-code deliverables
      patterns.md                  # Patterns and anti-patterns to check against
      verification-strategy.md     # The 5-layer verification approach

  michi-debrief/
    SKILL.md
    references/
      principles.md               # Shared
      docs-structure.md            # Shared
      patterns.md                  # Patterns to update during debrief

  michi-sustainability/
    SKILL.md
    references/
      principles.md               # Shared
      docs-structure.md            # Shared

  michi-scenario-test-builder/
    SKILL.md
    references/
      principles.md               # Shared
      docs-structure.md            # Shared
      kaner-methodology.md         # Kaner's five criteria and philosophy
      kaner-techniques.md          # Twelve techniques for generating scenarios
      michi-adaptation.md   # Patterns for autonomous agent verification

  michi-workshop/
    SKILL.md
    references/
      principles.md               # Shared
      docs-structure.md            # Shared
```

## Skill Flow

```
michi-bootstrap
  ├── Reads: target project codebase, existing docs
  ├── Surveys: codebase size/shape, docs inventory, Michi gap analysis, docs-root assessment
  ├── Recommends: effort tiers (S/M/L/XL) for brownfield, full scaffold for greenfield
  ├── Executes: creates/reorganizes docs interactively with user
  └── Produces: Michi-ready doc structure, docs-refactorings-roadmap.md (if deferred work)

michi-explore
  ├── Reads: codebase, existing docs, whatever the investigation requires
  ├── Maintains: Michi discipline (assumptions, decisions, drift awareness)
  ├── Captures: findings in agreed location (default: docs/sidebars/<topic>.md)
  └── Produces: artifact + mini-reflection (learnings, decisions, what's next)

michi-planning
  ├── First-epic guidance: validate deps, treat specs as hypotheses, default to Paired mode
  ├── Creates: epic-level verification artifacts (test-plan.md, scenarios.md) during planning
  └── Produces: milestone plan doc (with ## Decisions, ## Notes, ## Discussion, ## Verification)

michi-session
  ├── Reads: milestone plan doc, target reference (code or non-code)
  ├── Code target: Implement → Test → Repeat (references/target-code.md)
  ├── Non-code target: Explore → Synthesize → Checkpoint (references/target-non-code.md)
  ├── Writes: decisions, notes, discussion items, verification results (in plan doc)
  ├── Runs: sustainability check (pre-commit)
  └── Produces: committed milestone

michi-sustainability
  ├── Reads: recent code, tests, plan docs, journal
  ├── Assesses: code quality, test quality, architectural alignment, knowledge gaps
  ├── Checks: applied coding principles — patterns worth capturing in docs/reference/code-style.md
  └── Produces: findings, action items, discussion items (scale depends on context)

michi-debrief
  ├── Reads: plan docs (decisions, notes, discussion), git log, test results
  ├── Curates: learnings → journal.md, patterns → patterns.md, rules → CLAUDE.md
  ├── Captures: applied coding principles → docs/reference/code-style.md
  ├── Triages: discussion items (resolve, defer, promote)
  └── Produces: journal entry, updated patterns, trust assessment

michi-workshop
  ├── Reads: relevant code, context
  ├── Maintains: Michi discipline (assumptions, verification, decisions)
  ├── Scales: from a few bullets to a workshop doc
  └── Produces: working code + optional docs/workshop/<topic>.md
```

## Shared References

`principles.md` and `docs-structure.md` are maintained in `toolkit/` and copied to each skill's `references/` for
portability. After editing either canonical file:

```bash
toolkit/skills/build.sh
```

When creating a new skill, add it to the `SKILLS` array in `build.sh`.

## Installation

Copy a skill directory to the target project's `.claude/skills/` or reference it from CLAUDE.md. The `references/`
folder travels with the skill — self-contained.
