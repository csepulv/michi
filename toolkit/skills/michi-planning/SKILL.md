---
name: michi-planning
description:
  Prepare a project milestone for michi execution — write the plan, define acceptance criteria, set up
  verification, and scope the work for autonomous agent implementation.
---

# Michi Planning

Prepare a milestone for michi execution. This happens before the implementation session — either in a separate
planning session or as the first phase of a combined session.

**Principles served:** Shared context as foundation (explore before planning). Surface assumptions (explicit assumption
identification). Verification governs autonomy (co-design scenarios that constrain what "done" means). See
`references/principles.md`.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there take priority over this skill's defaults.

**Multi-project repos:** If the repo has `multi-project: true` in CLAUDE.md, ask the user which project the plan
is for (the umbrella = ROOT, or a named sub-project). Plans/specs/scenarios live under that project's epics:

- **ROOT (umbrella):** `docs/ROOT/epics/<epic>/plans/`, `spec.md`, `verification/scenarios.md`.
- **Sub-project:** `docs/<name>/epics/<epic>/plans/`, `spec.md`, `verification/scenarios.md`.

## Inputs

Before starting:

- The project's overall spec or feature plan (what are we building?)
- The milestone scope (which slice of the work?)
- Access to the codebase (to explore patterns, understand existing code)
- Context reference package (optional, brownfield projects) — video recordings, HAR files, screenshots, workflow docs
  from a prior context-capture session. These show how users interact with the application, not just how the code is
  structured. When available, they produce better verification scenarios.

## First-Epic Guidance

The first Michi epic on a project is different. The accumulated Michi context (journals, learnings, scenarios, architecture
docs) that enriches later planning doesn't exist yet.

**Spec maturity:** The starting spec is a hypothesis, not a contract. It may reference tools that don't exist, make
assumptions about APIs that haven't been validated, or describe a scope that shifts once implementation begins. Treat it
accordingly:

- Validate all referenced dependencies, tools, and packages exist (e.g., `npm view <package>`)
- Surface assumptions about external formats and behaviors — don't assume the spec author verified them
- When the spec is wrong on facts, correct and log the deviation. Don't wait for permission to fix factual errors.

**Mode:** Paired mode is the default for first epics. The human and agent are building shared context about both the
project and the Michi process. Start with small steps and short turns. Earn speed as the session progresses — don't try to
instantly accelerate.

**Subsequent epics** benefit from accumulated context: prior journals, learnings, scenario catalogs, architecture docs.
The spec is better because the foundation is richer. This is the spiral at work.

## Non-Code Milestones

When the deliverable is not code (research, roadmap, design review, backlog generation):

- **Focus on deliverables and exit criteria.** Name every artifact the milestone produces ("a prioritized roadmap," "a
  harvest inventory," "a comparison with recommendation"). If you can't name the deliverables, the scope isn't clear
  enough.
- **Exit criteria replace verification scenarios.** Define how you'll know each deliverable is done — specific enough to
  assess pass/fail. See `references/target-non-code.md` (loaded during the session skill).
- **Exploration depth is bounded by the deliverable.** Read enough to form a best-guess plan, not everything. The goal
  is producing the named artifacts, not comprehensive understanding.
- **Do not use superpowers skills** (brainstorming, writing-plans, executing-plans) for non-code milestones. They assume
  code deliverables. Use Michi skills with the non-code target reference.

The rest of this process still applies — surface assumptions, ask clarifying questions, write the plan doc. The plan
template works for non-code; the `## Verification` section uses exit criteria instead of scenarios.

## Process

### 1. Explore the Relevant Codebase

Before writing anything, understand what exists. Verification quality is bounded by shared context — the better you
understand how the application works, the better the scenarios.

- Launch Explore subagent(s) to analyze the areas of code this milestone touches
- Map existing patterns: route patterns, test patterns, repository patterns, naming conventions
- Identify files that will serve as templates for new code
- If context capture artifacts exist (HAR files, workflow docs, screenshots), read them alongside the codebase — they
  show application behavior from the user's perspective
- **Verify you're on the correct branch** (`git branch`) before exploring any repo

Capture your findings — they inform every subsequent step.

### 2. Surface Assumptions and Ask Clarifying Questions

Before asking questions, explicitly identify what's being assumed. Unstated assumptions are the most common source of
escaped bugs — not coding errors, things nobody challenged.

**Surface assumptions about:**

- The system: what existing behavior are we relying on? What schemas, enums, or contracts must hold?
- The user: who is using this, and what do they expect? Single caller? Specific auth flow? Particular data shape?
- Integration boundaries: what services, packages, or systems does this touch? What are we assuming about their
  behavior?

List assumptions explicitly. Challenge each: is this actually true? Could it change? What breaks if it doesn't hold?

**Then ask clarifying questions about:**

- Design decisions affecting the public API or data model
- Integration points with other packages or services
- Anything where two reasonable approaches exist and the choice matters
- Assumptions you can't verify from the codebase

Keep questions focused. Don't ask about implementation details you can decide yourself — ask about _contracts_,
_constraints_, and _assumptions_.

### 3. Co-Design Verification Scenarios

Spec and verification are co-designed — defining "how will we verify this?" shapes the spec itself. Scenarios aren't
afterthoughts; they're design tools that surface gaps, ambiguities, and integration concerns.

**Start with existing verification artifacts.** Before writing new scenarios, review the project's scenario catalog and
verification docs from previous milestones:

- Which existing scenarios are relevant to this milestone? These become regression checks.
- Which might break due to this milestone's changes? Flag for review.
- What new scenarios are needed for the new functionality?

**Plan when to test.** Not all verification has the same cost. Decide during planning:

- Which scenarios run during the implementation cycle (fast feedback, like TDD)?
- Which run as post-milestone verification (comprehensive, slower)?
- Final verification should be comprehensive — all relevant scenarios, not just the new ones.

Work with the human to write 3-5 **new** scenarios for this milestone:

- Each scenario is a **story about a user getting a benefit** — not a feature checklist. "A user syncs their Claude Code
  chats and finds them searchable" rather than "POST /api/chat returns 200."
- Use Kaner's scenario testing criteria: motivating, credible, complex (multiple features/components), easy to evaluate.
- **Decompose each scenario into Given-When-Then steps.** The bridge from story to executable verification.
- **Categorize by verification level:**
  - **Level A:** Agent executes autonomously — API calls, data store queries, concrete assertions with binary pass/fail
  - **Level B:** Agent executes, but evaluation requires judgment — output quality, error message clarity
  - **Level C:** Human evaluates — UX feel, visual design, workflow naturalness

Level A scenarios become mandatory post-milestone verification steps. Level B/C are noted for debrief review.

If a scenario can't be made executable (Level A), that's a signal to rethink the design or scope — not to skip
verification.

### 4. Write the Milestone Plan

Create `docs/epics/<epic-name>/plans/<plan-file>.md` using the plan template (`references/plan-template.md`). Key
sections:

- **Context** — why this milestone exists
- **Scope** — what it delivers and what it explicitly does NOT include
- **Acceptance Criteria** — explicit conditions for "done"
- **Scenarios** — co-designed scenarios from step 3, with Given-When-Then (authored here, promoted to the epic's
  `verification/scenarios.md` catalog during debrief)
- **Steps** — numbered implementation steps with file paths
- **Files** — new files to create, existing files to modify
- **Decisions** — empty, agent fills during implementation
- **Notes** — empty, agent fills during implementation
- **Discussion** — empty, agent fills during implementation with items for human review
- **Verification** — Level A scenarios (mandatory), unit/integration tests, cross-package checks, scope check, Level B/C
  scenarios (debrief)

### Epic-Level Verification Artifacts

Create or update these during planning — not during debrief:

- **`verification/test-plan.md`** — auth strategy, environment prerequisites, tooling decisions, test organization,
  fixture strategy. The "how we verify" infrastructure doc.
- **`verification/scenarios.md`** (or `scenarios.md` at epic root) — the scenario catalog. Seed with the first
  milestone's scenarios. Future milestones add; debriefs curate.

These inform implementation. Deferring them to debrief means the first milestone runs without explicit verification
infrastructure decisions.

### 5. Review Against Existing Verification Scenarios

If the epic has a scenario catalog (e.g., `docs/epics/<epic>/scenarios.md`):

- Check that acceptance criteria align with verification scenarios
- Identify scenarios needing updates for this milestone
- Flag gaps — scenarios that should exist but don't

### 6. Assess Cross-Package Impact

This is where Round 1 bugs came from. Explicitly check:

- Does this milestone introduce new types, enum values, or service names?
- Does it add a new caller to an existing pipeline?
- Are there downstream schemas (Zod, JSON Schema) that need updating?
- Are there hardcoded assumptions about caller identity?

If yes to any: add specific verification steps to the plan and flag as high-priority.

### 7. Plan Self-Review

Before presenting to the human, review with fresh eyes:

1. **Placeholder scan:** Any "TBD", incomplete sections, vague acceptance criteria? Fix them.
2. **Internal consistency:** Do scenarios match acceptance criteria? Do steps produce what scenarios verify?
3. **Scope-verification alignment:** For each acceptance criterion, is there a verification step? For each scenario, a
   step that implements the behavior?
4. **Assumption audit:** Are assumptions from step 2 reflected in the plan? New assumptions introduced by implementation
   steps?
5. **Inputs-vs-outputs check:** Planning often reads substantial source material — spec, prior journals, scenario
   catalog, referenced docs, codebase areas. Verify each significant source is reflected in the plan (scope, steps,
   scenarios, or assumptions). A plan that feels thin after heavy reading has likely dropped material. Use the inputs
   as a checklist.

Fix issues inline. Don't re-review — fix and move on.

### Not Ready is a Valid Outcome

Planning can conclude "not ready to plan yet." Signals:

- The spec references dependencies that haven't been validated, and validation would change the scope
- Acceptance criteria can't be made specific without a decision the human hasn't made
- Verification scenarios can't be decomposed into Given-When-Then because the behavior isn't well-defined
- Cross-package impacts are too unknown to scope without a spike first

When this happens, don't force a plan. Name what's missing, flag what would unblock it (an exploration session, a
spike, a human decision), and stop. An honest "we need more investigation before planning makes sense" beats a plan
built on unresolved ambiguity.

### 8. Confirm Readiness

Before handing off to implementation, verify:

- [ ] Plan doc written with all sections
- [ ] Acceptance criteria are specific and verifiable
- [ ] Verification scenarios co-designed and decomposed into Given-When-Then
- [ ] Level A scenarios are concrete enough for the agent to execute
- [ ] Cross-package impacts identified
- [ ] Branch exists for this work
- [ ] Environment is ready (Docker, seed data, services)

Present the plan to the human for review. The plan is a contract — implementation executes against it.

### What's Next

When the plan is approved, the natural next step is `/michi-session` to execute it.
