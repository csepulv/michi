# Session: Non-Code Target

Guidelines for sessions where the deliverable is not code — research, design reviews, architecture exploration,
documentation, backlog generation, evaluations. Loaded by the session skill when the milestone produces artifacts,
recommendations, or decisions rather than working software.

## Deliverables and Exit Criteria

Non-code sessions succeed or fail based on whether named deliverables exist and meet their exit criteria. Before
starting the core loop, confirm:

- **Deliverables are explicitly named.** Each one is a concrete artifact: "a prioritized roadmap," "a harvest
  inventory," "a comparison of three libraries with a recommendation." If the plan says "explore X" without naming what
  the exploration produces, clarify before starting.
- **Exit criteria are defined for each deliverable.** How will you know it's done? What makes it substantive vs.
  surface-level? Specific enough to assess pass/fail.
- **If the plan lacks deliverables or exit criteria**, work with the human to define them. This is the planning exercise
  for non-code work — the equivalent of scope and acceptance criteria for code milestones.

## Core Loop

```
Explore → Synthesize → Checkpoint
```

- **Explore** — gather information, read sources, analyze options, investigate alternatives. Follow the plan's steps but
  expect discoveries that reshape your understanding.
- **Synthesize** — organize findings into the target artifact. Summarize, compare, recommend. Don't just collect —
  structure what you've learned into something the audience can act on.
- **Checkpoint** — after each synthesis step, assess: does this answer the question? Is the direction still right? New
  questions that change the scope?

Unlike code sessions, there's no mechanical "test after every change." The checkpoint is the analog — a deliberate pause
to assess progress against exit criteria.

### Exploration Depth

Non-code work tempts over-exploration. Read enough to form a best-guess plan, not everything. If the plan says "review
the codebase for harvest candidates," you don't need every file — enough to identify patterns and produce a concrete
list. Depth serves the deliverable, not completeness for its own sake.

### Questions: Prerequisites vs. Discoveries

Two kinds of questions arise:

- **Prerequisite questions** need answers before work can proceed — exit criteria, scope boundaries, audience. These
  block progress. Ask the human.
- **Discovery questions** emerge during exploration and belong in the output — "should templates be a first-class
  concern?" or "how would a new user bootstrap?" These demonstrate understanding gaps and shape future work. Document in
  `## Discussion`; don't treat as blockers.

When in doubt: if you can continue without the answer, it's a discovery. If you can't, it's a prerequisite.

## Self-Review

Before declaring complete:

- **Re-read exit criteria** from the plan doc. Does the deliverable meet each one?
- **Check for completeness** — questions the plan asked that you haven't addressed? Gaps you noticed but didn't flag?
- **Check the deliverables list** — does every named deliverable exist? Non-code agents tend to under-scope — producing
  fewer artifacts than requested. Explicitly verify.
- **Check for depth** — substantive or surface-level? Would the audience learn something they couldn't get from a quick
  search?
- **Check for bias** — did you fairly represent alternatives, or anchor on the first option? Tradeoffs explicit?
- **Check for intent** — did you synthesize structure and intent, or just structure? The deliverable should reflect why
  the work matters, not just what it contains.

## Verification: Exit Criteria

Non-code milestones use exit criteria instead of test suites, defined in the plan doc.

**Common exit criteria patterns:**

- **Research/evaluation:** "Identifies at least N options, compares on [specified dimensions], provides recommendation
  with rationale."
- **Architecture/design:** "Describes proposed approach, identifies tradeoffs, maps to existing patterns, flags
  migration concerns."
- **Exploration:** "Answers [the questions from the plan] with evidence. Unknown areas flagged, not glossed over."
- **Backlog generation:** "Produces actionable items with enough context to plan against. Each item has a clear scope
  statement."

Exit criteria should be specific enough to assess pass/fail. If you can't tell whether you've met a criterion, it's too
vague — flag as a discussion item.

**Verification checklist:**

- [ ] **Exit criteria met** — each criterion assessed individually
- [ ] **All named deliverables produced** — check plan's list against what exists
- [ ] **Scope check** — did work stay within plan's scope, or expand? Log deviations as decisions
- [ ] **Open questions surfaced** — unknowns and uncertainties flagged, not hidden
- [ ] **Artifacts in the right location** — files written to correct michi docs path

## Sustainability Check (pre-commit)

**Quality pass:**

- Well-structured? Can someone scan it and understand key points without reading every line?
- Claims supported by evidence (links, quotes, data) rather than assertion?
- Writing clear and concise, or padded with filler?

**Knowledge pass:**

- What emerged that should be discussed or explored further?
- Findings that affect other epics or project direction?
- Update `## Discussion` with items for human review.
