---
name: michi-scenario-test-builder
description:
  Generate scenario-based test plans and test cases using Cem Kaner's scenario testing methodology. Use this skill when
  the user wants to discover what to test, create test scenarios, build test plans, define acceptance criteria, generate
  verification scenarios for autonomous agent work, or explore how a system might fail or be misused. Also use when the
  user mentions "scenario testing", "test plan", "acceptance criteria", "what should I test", "verification scenarios",
  "holdout tests", or asks how to validate that a feature works end-to-end. This is NOT for writing test code — it
  produces test plans, scenarios, and criteria that inform test implementation.
---

# Scenario Test Builder

Generate rich, narrative-driven test scenarios and structured test plans. Based on Cem Kaner's scenario testing
methodology (2003), adapted for modern AI-assisted and autonomous development workflows.

**Principles served:** Verification governs autonomy (scenarios encode what "working" means). Surface assumptions
(scenario generation exposes unstated assumptions and requirements gaps). Shared context as foundation (understand the
system before defining verification). See `references/principles.md`.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there take priority over this skill's defaults.

## When to Use

- **Discovering what to test** — before writing any test code, explore what scenarios matter
- **Building test plans** — structured documents listing scenarios, acceptance criteria, and priority
- **Defining verification scenarios** — for autonomous agent (michi) workflows where code is written by AI and
  validated against scenarios
- **Exploring how a system could fail** — creative, adversarial thinking about real-world usage
- **Surfacing requirements gaps** — finding disagreements, edge cases, and unstated assumptions

## What This Skill Produces

Output is always **markdown documents**, not test code:

1. **Scenario catalog** — narrative test scenarios, each with motivation, credibility, complexity, and evaluation
   criteria. In Michi projects, these live in `verification/scenarios.md`.
2. **Test plan** — prioritized, structured plan referencing the scenarios with coverage notes. Informs
   `verification/test-plan.md`.
3. **Acceptance criteria** — per-feature or per-task criteria suitable for agent consumption. In Michi projects, these go
   in the plan doc's `## Scenarios` section.

## Core Methodology: Kaner's Five Criteria

Every scenario is evaluated against five quality criteria. Read `references/kaner-methodology.md` for the full
framework.

A good scenario is:

1. **A story** — not a checklist. A person doing something for a reason, with context about why it matters.
2. **Motivating** — a stakeholder with influence would push to fix a program that failed this test.
3. **Credible** — stakeholders believe this will probably happen in the real world. Not a theoretical edge case.
4. **Complex** — involves multiple features, data flows, or system interactions. Single-feature tests belong elsewhere.
5. **Easy to evaluate** — despite complexity, it should be clear whether the system passed or failed.

## Workflow

### Phase 1: Understand the System

Before generating scenarios, gather context. Ask (don't assume):

- What does the system do? Who uses it?
- What are the key benefits it's supposed to deliver?
- What are the riskiest or most complex areas?
- Known problem areas, past failures, user complaints?
- What environment does it run in? External system interactions?
- Existing test suite? What does it cover and where are the gaps?

If the user provides a codebase, read key files (README, package.json, main entry points, existing tests) to understand
the system before generating scenarios.

### Phase 2: Generate Scenarios Using Kaner's Twelve Techniques

Apply relevant techniques from `references/kaner-techniques.md`. Not all twelve apply to every system — select the ones
that fit.

For each technique applied, generate 2-5 candidate scenarios. Each must include:

```markdown
### Scenario: [Short descriptive name]

**Technique**: [Which of Kaner's 12 techniques generated this]
**Story**: [2-4 sentences describing a real person trying to accomplish something real. Include motivation and context.]
**What could go wrong**: [What failure or unexpected behavior this scenario exposes]
**Complexity**: [Which features/components/data flows are involved]
**Verification Level**: A (agent executes autonomously) / B (agent executes, judgment needed) / C (human evaluates)
**Given-When-Then** (for Level A/B):
```
Given [precondition]
When [action]
Then [expected outcome]
```
**How to evaluate**: [For Level C, or additional evaluation notes beyond Given-When-Then]
**Priority**: [Critical / High / Medium / Low — likelihood × impact]
**Credibility notes**: [Why a stakeholder would believe this is realistic]
```

Scenarios bridge spec and test. The story communicates intent (spec side). The Given-When-Then steps can be executed
(test side). Both are needed — the story ensures the test captures user intent, the steps ensure it's runnable.

### Phase 3: Build the Test Plan

Organize scenarios into a test plan:

```markdown
# Test Plan: [System/Feature Name]

## Context

[What's being tested and why]

## Scope

[What's included and excluded]

## Scenarios by Priority

### Critical

[List critical scenarios with references]

### High

[List high-priority scenarios]

### Medium / Low

[List remaining scenarios]

## Coverage Notes

[What's well-covered, what gaps remain, what needs additional techniques]

## Risks and Limitations

[What this plan doesn't cover; where other approaches are needed]
```

### Phase 4: Generate Acceptance Criteria (Optional)

If the user needs acceptance criteria for agent consumption, convert selected scenarios into structured criteria:

```markdown
## Acceptance Criteria: [Task/Feature Name]

### Must Pass (blocking)

- [ ] [Concrete, verifiable criterion from a scenario]
- [ ] [Another criterion]

### Should Pass (expected)

- [ ] [Criterion]

### Edge Cases (verify if time permits)

- [ ] [Criterion from adversarial/disfavored-user scenarios]

### Evaluation Method

[How to verify each criterion — automated test, manual check, data comparison, etc.]
```

## Adapting for Michi / Autonomous Agent Verification

When building scenarios for autonomous agent verification:

- **Emphasize "easy to evaluate"** — if an agent checks results, pass/fail criteria must be unambiguous and automatable
- **Consider the agent as a "disfavored user"** (Kaner technique #3) — the agent might take shortcuts, write
  `return true`, or misunderstand intent. Design scenarios that catch these failure modes.
- **Separate scenarios by autonomy level** — some verify automatically (run test, check output); others require human
  judgment. Label each.
- **Version and store scenarios outside the implementing agent's context** — if using a holdout pattern, note which
  scenarios are holdout candidates

## What This Skill Does NOT Do

- **Write test code** — use TDD, BDD, or test-generation skills for that
- **Run tests** — this produces plans, not executions
- **Replace other test techniques** — scenario testing is one approach; combine with unit testing, domain testing,
  stress testing, etc. (Kaner: "Scenario testing isn't the only type of testing")

## References

Read these when needed:

- `references/kaner-methodology.md` — Kaner's five criteria and philosophy, with key quotes
- `references/kaner-techniques.md` — Twelve techniques for generating scenarios, with examples
- `references/michi-adaptation.md` — Patterns for using scenarios in autonomous agent verification
