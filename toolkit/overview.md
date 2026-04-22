# Michi

A toolkit for software development with AI assistance.

Here's the thing about AI coding agents: they're powerful and unreliable at scale. They grade their own homework —
writing tests that validate their own understanding. They drift without structure, declare "done" prematurely, and don't
know what they don't know. Michi provides the process, skills, and templates that make autonomous agent work
repeatable and trustworthy — or at least make it clear when it isn't trustworthy yet.

This toolkit is for engineers using Claude Code for sustained, multi-milestone development — not one-off tasks. If
you've tried agent coding and found it powerful but inconsistent, this is the structure that closes the gap.

---

## How the Toolkit Works

### The Iteration Cycle

Every piece of work follows the same cycle:

**Explore → Brainstorm → Plan → Execute → Verify → Document**

This applies at every scale — a single milestone, an entire epic, the process of building the toolkit itself. The cycle
minimizes latency (each iteration produces a validated outcome, not just output) and maintains sustainability (Document
captures knowledge, Verify catches degradation, Plan ensures each iteration builds on the last).

### North Stars

Four principles govern the toolkit, and they exist in tension:

**What Over How** — Understand the problem before designing the solution. An elegant solution to the wrong problem is
waste. Requirements and reasons come before implementation and tactics.

**Minimize Latency** — An engineering org exists to shrink the time from idea to validated outcome. Fast tests,
incremental milestones, tight feedback loops, decision speed — all serve this. A good decision now beats a perfect
decision later, as long as it's reversible and documented.

**Sustain the System** — Velocity without sustainability is a death spiral with good sprint metrics. Code health, test
health, design coherence, knowledge retention — first-class concerns, not afterthoughts. Each iteration should leave the
system where the next one is at least as productive.

**Navigating Complexity** — Use the S-M-L-XL scale to calibrate effort, risk, process rigor, and decision speed. An L
effort for S benefit is easy to decline; an S effort for L benefit is easy to accept. The hard cases — M effort for M
benefit — are where judgment lives.

Navigating these tensions well is the craft. The rest of the toolkit serves all four.

### Two Modes of Practice

**Paired** (lights on) — Human and agent work in a tight loop. The human is present, engaged, driving decisions. The
mode for learning the tools, new codebases, uncertain work, or any time you want shorter turns and more interaction.

**Entrusted** (running dark) — The agent has wider initiative within established scope. The human reviews at gates and
exceptions, not every step. The agent makes judgment calls and logs them. This mode is earned through demonstrated
mastery — of the tools, the codebase, and the verification discipline.

These aren't levels to graduate through. They're tools to select based on context. Moving from Entrusted back to Paired
isn't regression. It's knowing when to slow down.

### The Skills

Ten Claude Code skills covering the full development lifecycle:

| Skill                         | When                  | What it does                                                                            |
| ----------------------------- | --------------------- | --------------------------------------------------------------------------------------- |
| `michi-bootstrap`             | Before first session  | Survey project, assess docs gaps, scaffold Michi structure interactively                |
| `michi-explore`               | Investigative work    | Structured conversation for research, orientation, and brainstorming                    |
| `michi-planning`              | Before implementation | Explore codebase, surface assumptions, co-design verification, write the plan doc       |
| `michi-session`               | During implementation | Rigid execution — implement, test after every change, log decisions, verify, commit     |
| `michi-workshop`              | Small work            | Lighter discipline for bug fixes, small features, and quick explorations                |
| `michi-debrief`               | After implementation  | Review decisions, promote learnings, curate scenarios, calibrate trust                  |
| `michi-sustainability`        | At checkpoints        | Scaled health checks — within-milestone, between-milestone, between-epic                |
| `michi-scenario-test-builder` | During planning       | Generate verification scenarios using Cem Kaner's methodology                           |
| `michi-pr-prep`               | Before a PR           | Prepare a companion review guide — what reviewers are looking at and why                |
| `michi-docs-site`             | Docs infrastructure   | Scaffold an internal Astro + Starlight docs browser, or generate a PDF build recipe     |

The core loop is **Bootstrap → Planning → Session → Debrief**. Bootstrap is one-time setup (or re-run to close gaps).
Planning builds shared context before code is written. The session skill is deliberately rigid — the discipline is the
point. The debrief closes the loop by curating what was learned and evolving verification scenarios.

Sustainability runs alongside the core loop at scaled intervals — light checks within a milestone, deeper assessments
between milestones and epics. The scenario test builder feeds into planning, producing verification scenarios that are
co-designed, not afterthoughts.

Explore, workshop, pr-prep, and docs-site are supplementary — investigative work (explore), lighter-weight sessions for
small work (workshop), PR handoff (pr-prep), and docs-site scaffolding (docs-site).

### Progressive Detail

Three levels of documentation:

- **Principles** — Always loaded. The "why." Short enough to stay in context without cost.
- **Guidance** — Loaded per phase. The "what and when." Skill preambles connecting purpose to principles.
- **Checklists** — Referenced during execution. The "how exactly." Skill bodies with step-by-step procedures.

The agent internalizes principles, loads guidance when entering a phase, references checklists when doing the work.

---

## Verification

Verification is the toolkit's most important concern — and an unsolved problem.

### The Agent Grades Its Own Homework

The core finding from the first experiment: the agent writes code, then writes tests for that code. The tests validate
the agent's implementation against the agent's understanding of the schema. This is circular.

Concretely: 221 tests passed with 0 failures. Two bugs escaped to post-completion. Both were one-line fixes — a missing
Zod enum value, a hardcoded source field. Both passed unit tests and dry-runs. Both failed when a human ran the code for
real.

### The Five-Layer Strategy

Autonomous agent verification needs layers the agent doesn't control:

| Layer              | What                                        | Catches                               | Who Writes          |
| ------------------ | ------------------------------------------- | ------------------------------------- | ------------------- |
| Unit tests         | Fast, after every change                    | Logic errors, regressions             | Agent               |
| Integration tests  | Real-ish deps (e.g., mongodb-memory-server) | Operator conflicts, query bugs        | Agent               |
| Smoke tests        | Real API call, real data store              | Schema mismatches, validation gaps    | Human (pre-written) |
| Holdout tests      | Agent-invisible behavioral tests            | Assumption errors, cross-package gaps | Human (pre-written) |
| Human verification | Manual testing, exploratory                 | UX issues, visual bugs, workflow gaps | Human               |

Layers 1-2 are the agent's domain. Layer 5 is the human's. **Layers 3-4 are the gap** — verification that uses real
systems and that the agent can't game. A single real API call per milestone would have caught both escaped bugs
immediately.

### Verification Governs Autonomy

This is a progressive relationship: stronger verification enables more autonomy, which enables more ambitious work,
which demands stronger verification. You can only give the agent as much rope as your verification can catch. "All tests
pass" is necessary but not sufficient.
