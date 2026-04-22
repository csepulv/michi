# Michi

Methodology and tooling for running autonomous Claude Code agents against real codebases.

**Full documentation:** [michi.tools](https://michi.tools)

AI coding agents are powerful and unreliable at scale. They grade their own homework, drift without structure, and declare "done" prematurely. Michi provides the process, skills, and templates that make autonomous agent work repeatable and trustworthy — or make it clear when it isn't trustworthy yet.

Michi is for engineers using Claude Code for sustained, multi-milestone development — not one-off tasks. If you've tried agent coding and found it powerful but inconsistent, this is the structure that closes the gap.

## Skills

Ten Claude Code skills covering the full development lifecycle:

| Skill                         | When                  | What it does                                                                          |
| ----------------------------- | --------------------- | ------------------------------------------------------------------------------------- |
| `michi-bootstrap`             | Before first session  | Survey project, assess docs gaps, scaffold Michi structure interactively              |
| `michi-explore`               | Investigative work    | Structured conversation for research, orientation, and brainstorming                  |
| `michi-planning`              | Before implementation | Explore codebase, surface assumptions, co-design verification, write the plan doc     |
| `michi-session`               | During implementation | Rigid execution — implement, test after every change, log decisions, verify, commit   |
| `michi-workshop`              | Small work            | Lighter discipline for bug fixes, small features, and quick explorations              |
| `michi-debrief`               | After implementation  | Review decisions, promote learnings, curate scenarios, calibrate trust                |
| `michi-sustainability`        | At checkpoints        | Scaled health checks — within-milestone, between-milestone, between-epic              |
| `michi-scenario-test-builder` | During planning       | Generate verification scenarios using Cem Kaner's methodology                         |
| `michi-pr-prep`               | Before a PR           | Prepare a companion review guide — what reviewers are looking at and why              |
| `michi-docs-site`             | Docs infrastructure   | Scaffold an internal Astro + Starlight docs browser, or generate a PDF build recipe   |

The core loop is **bootstrap → planning → session → debrief**. Everything else is supplementary.

## Getting started

### Install

```bash
git clone https://github.com/csepulv/michi.git
cp -r michi/toolkit/skills/michi-* ~/.claude/skills/
```

Each skill is self-contained — its `references/` folder includes everything it needs.

### First run

Open Claude Code in a target project and invoke:

```
/michi-bootstrap
```

This surveys your project and walks you through creating Michi's documentation structure interactively.

## Repository

The toolkit lives under [`toolkit/`](toolkit/):

- [`overview.md`](toolkit/overview.md) — what Michi is and how the pieces fit together
- [`principles.md`](toolkit/principles.md) — the north-star principles
- [`getting-started.md`](toolkit/getting-started.md) — longer setup and workflow notes
- [`docs-structure.md`](toolkit/docs-structure.md) — how target projects organize documentation
- [`patterns.md`](toolkit/patterns.md) — cross-cutting patterns and anti-patterns
- [`skills/`](toolkit/skills/) — all Claude Code skills

## Status

Early and provisional. Names, interfaces, and organization may change. No versioning guarantees yet.

## License

MIT — see [LICENSE](LICENSE).
