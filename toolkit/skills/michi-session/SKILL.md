---
name: michi-session
description:
  Execute a michi implementation session — implement a milestone with mandatory verification, decision logging,
  code review, and commit discipline. This is a rigid skill — follow exactly.
---

# Michi Session

Execute an implementation milestone. This skill is **rigid** — follow every step. The discipline is the point.

**Violating the letter of this process is violating its spirit.** "I'm following the intent, just adapting the steps" is
a rationalization. The steps ARE the intent.

**Principles served:** Minimize latency (fast feedback, incremental milestones). Sustain the system (sustainability
check before commit). Surface assumptions (decision logging, self-review). Verification governs autonomy (mandatory
verification). See `references/principles.md`.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there take
priority over this skill's defaults.

**Multi-project repos:** If the repo has `multi-project: true` in CLAUDE.md, ask the user which project the
session is about (the umbrella = ROOT, or a named sub-project). File locations differ:

- **ROOT (umbrella):** plan doc at `docs/ROOT/epics/<epic>/plans/mN-*.md`, journal at `docs/ROOT/journal.md`.
  Identity docs (CLAUDE.md, PROJECT.md, STATUS.md, ARCHITECTURE.md) stay at **repo root** — same as single-project
  Michi. Repo-root CLAUDE.md is auto-loaded (contains umbrella conventions + repo-wide layer).
- **Sub-project (e.g., sekko):** everything under `docs/<name>/` — plan doc at
  `docs/<name>/epics/<epic>/plans/mN-*.md`, journal at `docs/<name>/journal.md`, identity docs (CLAUDE.md,
  PROJECT.md, STATUS.md, ARCHITECTURE.md) at `docs/<name>/`. Read `docs/<name>/CLAUDE.md` explicitly (not
  auto-loaded) when the sub-project is the session's subject.

## The Iron Law

```
NO "DONE" WITHOUT RUNNING FULL VERIFICATION
```

If you haven't executed the verification checklist in this session, you cannot claim the milestone is complete. "I
believe it passes" is not verification. Run it.

## Target Deliverable

The milestone's deliverable determines which reference to load:

- **Code** — working software, tests, runnable code. Load `references/target-code.md` for the core loop (Implement →
  Test → Repeat), verification checklist, code review, and sustainability checks.
- **Non-code** — artifacts, recommendations, decisions, research, design docs. Load `references/target-non-code.md` for
  the core loop (Explore → Synthesize → Checkpoint), exit criteria, and quality checks.

The rest of this skill — pre-flight, decision logging, scope discipline, commit, post-milestone — applies regardless of
target.

## Pre-Flight

Before starting work:

1. **Read the milestone plan doc.** This is your contract. If it doesn't exist, stop and use the `michi-planning`
   skill first.
2. **Verify branch.** Run `git branch` — confirm you're on the correct feature branch.
3. **Verify environment.** Code targets: services running, seed data loaded, test suite passes from clean state.
   Non-code targets: source materials accessible, referenced docs loaded.
4. **Read CLAUDE.md and any referenced docs.** Load project conventions into context.
5. **Read `docs/memory.md` if it exists.** Collaboration context — how we work together, active threads, landmarks.
   Especially important in a new session or on a new machine.
6. **Look for opportunities to use open source.** Scan the plan's steps for general-purpose functionality — parsing,
   HTTP, dates, file I/O, validation, anything that isn't your domain logic. Especially for commodity and incidental
   needs. Check if the project already has a dependency that covers it; if not, identify candidate libraries. Note
   findings in the plan doc so the core loop doesn't stop for research. See `references/open-source-preference.md`.

## The Core Loop

Execute the steps in the plan using the core loop from the target reference:

- **Code:** Write failing test → Implement → Pass → Refactor → Repeat (TDD by default; see `references/target-code.md`)
- **Non-code:** Explore → Synthesize → Checkpoint (see `references/target-non-code.md`)

**Prefer existing libraries over custom code.** If you encounter commodity needs not caught in pre-flight, research
before implementing. See `references/open-source-preference.md`.

**Don't optimize without justification.** See `references/optimization-discipline.md` for the decision tree. The default
is the straightforward approach; optimization must be defended.

**The Rule of 3.** Three rounds is the sweet spot for iterating through a hard problem — both as a floor and a
ceiling. *Don't stop before three* for non-trivial thinking work (scenario authoring, design iteration, debugging
a real problem): do the whole pass, feed what you learned into the next round, refine. One-pass work on hard
problems is overconfidence. *Don't push past three* when rounds stop producing progress — same fix from a different
angle, same class of solution — that's a signal to stop and reframe, not to try a fourth time. See "When You're
Stuck" for the specific escalation pattern.

### Reactive Scope Changes

Sometimes implementation reveals a gap the plan didn't anticipate — a core assumption is wrong, a critical capability is
missing, or real-app testing exposes a problem that changes the milestone's shape.

**In Paired mode** (human present), reactive scope changes are legitimate when:

1. A spike confirms the change is feasible
2. The human agrees to the scope adjustment
3. The change is logged as a decision (classify as `design-choice` or `contract-change`)

This is distinct from scope creep — it's a deliberate response to discovered reality, not drift. The human's agreement
is the gate. If the change warrants its own plan doc, create one. If it's a natural extension of the current milestone's
theme, extend and log.

**In Entrusted mode** (human reviewing at gates), prefer creating a new milestone over extending the current one. The
plan doc is the contract — unilateral scope expansion undermines the verification framework.

### Evidence Before Claims

Throughout the core loop: if you state that something works, passes, or is complete, you must have run the verification
in the current context. "Should work" and "I believe it passes" are not evidence. Run the command, read the output, then
state the result.

This applies to:

- Test results during implementation
- API call results
- Scenario execution during verification
- Scope assertions during sustainability check

## Decision Logging

When you make a choice without human input:

**Log it immediately** in the plan doc's `## Decisions` section:

```markdown
## Decisions

### [Short title]

- **Decision:** [What you chose]
- **Alternatives:** [What else you considered]
- **Reasoning:** [Why this choice]
- **Impact:** [Does this affect the API contract? Other packages? Future milestones?]
- **Reversible:** [Yes/No — can this be easily changed later?]
```

**Decision classification:**

- `implementation-detail` — internal naming, file organization, algorithm choice. Log it, no notification needed.
- `design-choice` — interface shape, data format, library selection. Log it, human reviews during debrief.
- `contract-change` — public API modification, schema change, new service type. **Log it AND notify the human
  immediately** (Slack or whatever channel is established).

If you're unsure whether something is a contract-change: it is. Notify.

## Discussion Items

Separate from decisions (choices already made) and notes (observations). Discussion items are things where you don't
have enough context to decide alone, but you're not blocked. Log them in `## Discussion` as they arise.

Examples: "The mocking strategy feels inconsistent across packages — worth aligning?" or "This service is doing two
things, should we split it?" or "Naming convention drifts in the older code — intentional?"

These get reviewed during the debrief. They're a feedback mechanism for building shared understanding across sessions.

## Red Flags — STOP

If you catch yourself thinking any of these, stop and follow the process:

- "This decision is too minor to log" — Log it. Minor decisions compound. The debrief decides what matters.
- "Tests passed during implementation, verification is redundant" — Post-milestone verification catches what unit tests
  miss. Run everything.
- "I'll update STATUS.md / the plan doc later" — Do it now. Later means never.
- "This scope change is small enough to not need logging" — If it changes what gets delivered, it's a scope change. Log
  and classify.
- "The plan doc is close enough to what I built" — Check off steps explicitly. Note deviations.
- "I already know the branch is correct" — Run `git branch`. Every time.
- "I can skip pre-flight between milestones" — Pre-flight resets. Always re-verify.
- "Notification isn't needed for this decision" — If unsure whether it's a contract-change: it is. Notify.

## Common Rationalizations

| Excuse                                              | Reality                                                                                  |
|-----------------------------------------------------|------------------------------------------------------------------------------------------|
| "Verification is redundant — tests passed"          | Unit tests are one layer. Scenarios catch integration issues tests miss. Run everything. |
| "This decision doesn't need alternatives listed"    | Logging alternatives is how the debrief evaluates judgment. Write them down.             |
| "I believe it passes"                               | Belief is not evidence. Run the command, read the output, then state the result.         |
| "I can combine these steps"                         | Each step exists for a reason. Combining hides skipped verification.                     |
| "The human will catch it in the debrief"            | The debrief reviews decisions, not bugs. Verification is your job.                       |
| "I'm following the spirit, just adapting the steps" | The steps ARE the spirit. See the Iron Law.                                              |

## Post-Milestone Verification

After the plan's steps are complete, run the full verification from the target reference. **Every item is mandatory.**
Do not skip any. Do not declare "done" until all pass. Evidence, not assertions — run verification and report actual
results, not what you believe should work.

### Execute Final Verification

Run the verification checklist from the target reference:

- **Code:** self-review, scenario execution, verification checklist, code review (see `references/target-code.md`)
- **Non-code:** self-review against exit criteria, verification checklist (see `references/target-non-code.md`)

If any item fails, fix before proceeding.

### Sustainability Check

Run the sustainability check from the target reference:

- **Code:** refactoring pass, test evaluation (see `references/target-code.md`)
- **Non-code:** quality pass, knowledge pass (see `references/target-non-code.md`)

**For both targets:**

- What emerged from this work that should be discussed or explored?
- Update `## Discussion` with items for human review.

## Commit

After the sustainability check:

```bash
git add [specific files]
git commit -m "michi(mN): [description]

[Summary of what was built and key decisions]

Co-Authored-By: Claude <noreply@anthropic.com>"
```

**Commit conventions:**

- Prefix with `michi(mN):` to identify michi work in git log
- Add specific files by name — do not `git add -A`
- Do not push — the human controls what leaves the machine

## Post-Milestone

1. **Update the plan doc** — check off completed steps, note deviations
2. **Update STATUS.md** — reflect current state
3. **Notify** — Slack or established channel:
    - What was completed
    - Results (test count for code, exit criteria assessment for non-code)
    - Decisions needing human review (contract-change level)
    - Whether you're continuing to the next milestone or stopping

## Between Milestones

If continuing to the next milestone in the same session:

- Read the next milestone's plan doc
- Do NOT skip pre-flight — verify branch, check environment
- The core loop resets — fresh verification for the new milestone

## When You're Stuck

1. Re-read the relevant material (Read tool cache may have expired for code; re-read source material for non-code)
2. Check if the error message contains the fix (code) or if the question has been answered elsewhere (non-code)
3. If genuinely blocked: **document the blocker in the plan doc**, notify the human, and wait. Do not work around
   blockers silently.
4. **If you've attempted the same fix 3+ times** — stop. The approach may be wrong. Log the pattern in `## Discussion`,
   describe what you've tried and why it keeps failing, and escalate. Three failed fixes is a signal to question
   fundamentals, not try a fourth.

## Session End

When all planned milestones are complete, or the human ends the session:

- Verify all milestones are committed
- Confirm plan doc and STATUS.md are current
- **Memory check:** Review the session for memory-worthy content. Ask: "What from this session would be painful to lose
  in a new session?" Update `docs/memory.md` if warranted — collaboration patterns, corrections, confirmed approaches,
  new landmarks. Don't add implementation details (those belong in the plan doc or journal).
- The natural next step is `/michi-debrief` — either immediately or in a separate session
