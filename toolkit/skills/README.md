# Michi Skills

Skills that guide the michi process. Each skill is a directory with a `SKILL.md` and a `references/` folder
containing the docs it depends on.

## Skills

| Skill                                                           | Type     | When to Use                                                                                                                              |
| --------------------------------------------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| [michi-bootstrap](michi-bootstrap/SKILL.md)                         | Flexible | Before first Michi session — onboard a project, assess gaps, scaffold docs                                                                 |
| [michi-explore](michi-explore/SKILL.md)                             | Flexible | Structured conversation for investigative work — cold starts, research, brainstorming, pre-planning                                       |
| [michi-planning](michi-planning/SKILL.md)                           | Flexible | Before implementation — prepare the milestone plan, explore codebase, surface assumptions, define acceptance criteria                    |
| [michi-session](michi-session/SKILL.md)                             | Rigid    | During implementation — execute the milestone with mandatory verification, decision logging, sustainability check, and commit discipline |
| [michi-debrief](michi-debrief/SKILL.md)                             | Flexible | After implementation — review decisions, capture learnings, update applied coding principles, calibrate trust                            |
| [michi-sustainability](michi-sustainability/SKILL.md)               | Flexible | Between milestones or epics — assess code quality, test quality, architectural alignment, knowledge gaps                                 |
| [michi-scenario-test-builder](michi-scenario-test-builder/SKILL.md) | Flexible | During planning — generate Kaner-style verification scenarios, build test plans, define acceptance criteria                              |
| [michi-workshop](michi-workshop/SKILL.md)                           | Flexible | Everyday work — bug fixes, small features, quick explorations with Michi discipline                                                        |
| [michi-expedition](michi-expedition/SKILL.md)                       | Flexible | Learning-mode work — open-ended, Entrusted, spiral exploration where the end isn't known                                                  |
| [michi-loop](michi-loop/SKILL.md)                                   | Rigid    | Autonomous loops — gate readiness, define the goal/verifier/stop contract, launch lights-off, review at halt                              |
| [michi-pr-prep](michi-pr-prep/SKILL.md)                             | Flexible | Before requesting PR review — prepare a companion review guide                                                                             |
| [michi-docs-site](michi-docs-site/SKILL.md)                         | Flexible | Docs infrastructure — scaffold an internal docs browser or generate a PDF build recipe                                                    |

## Structure

Every skill is a directory with a `SKILL.md` and a `references/` folder. References come in two kinds:

- **Shared references, synced by `build.sh`.** Three files go to every skill: `principles.md`, `docs-structure.md`,
  and `ground-rules.md`. A few are synced to specific skills only: `patterns.md` (session, debrief),
  `expedition-structure.md` (bootstrap, expedition), and the harness files `working-with-hermes.md` +
  `soul-template.md` (expedition). The canonical copies live in `toolkit/`; run `build.sh` after editing any of them.
- **Skill-local references**, authored in place — templates (bootstrap's CLAUDE.md/PROJECT.md templates, planning's
  plan template), the session skill's target references (`target-code.md`, `target-non-code.md`,
  `verification-strategy.md`, `open-source-preference.md`, `optimization-discipline.md`), the scenario builder's Kaner
  references, the expedition skill's templates and recipes, and the explore skill's `michi-skill-guide.md`.

Example shape:

```
skills/
  build.sh                        # Syncs shared references. Run after editing any canonical toolkit file.
  michi-session/
    SKILL.md
    references/
      principles.md               # Shared (synced)
      docs-structure.md           # Shared (synced)
      ground-rules.md             # Shared (synced)
      patterns.md                 # Shared with debrief (synced)
      target-code.md              # Skill-local
      target-non-code.md          # Skill-local
      verification-strategy.md    # Skill-local
      ...
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
  ├── Captures: findings in agreed location (default: docs/epics/<topic>.md)
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
  ├── Scales: from a few bullets in conversation to a journal entry or flat-file epic
  └── Produces: working code + journal entry or epic doc (no separate workshop tier)

michi-expedition
  ├── Reads: STATUS, expedition structure, active charter + portrait, campaign mandate
  ├── Modes: charter (mission) → campaign (mandate) → run (Entrusted spiral) → review (Paired) → exhibit
  ├── Maintains: care calibration, finding-verification before promotion, surfacing over parking
  └── Produces: reports, an accreting portrait, ruminations/backlog threads

michi-loop
  ├── Reads: the target work, prior Paired alignment, the environment's capabilities
  ├── Walks: gate → contract → verifier → stop conditions → readiness → launch → review
  ├── Maintains: verifier with teeth (not self-graded), human owns the runner choice + launch
  └── Produces: a launched lights-off loop + a reviewed result (verified done, or abort)

michi-pr-prep
  ├── Reads: plan doc decisions/notes, session context or the diff cold
  └── Produces: PR review guide (TLDR + Details, or TLDR only)

michi-docs-site
  ├── Reads: the project's docs landscape (or an existing Starlight site for PDF mode)
  └── Produces: internal Astro + Starlight docs browser, or a validated pdf-recipe.yaml
```

## Shared References

Shared reference files are maintained in `toolkit/` and copied to each skill's `references/` for
portability (see Structure above for which files go where). After editing any canonical file:

```bash
toolkit/skills/build.sh
```

When creating a new skill, add it to the `SKILLS` array in `build.sh` and to `toolkit/skills-directory.yaml`.

## Installation

Copy a skill directory to the target project's `.claude/skills/` or reference it from CLAUDE.md. The `references/`
folder travels with the skill — self-contained.
