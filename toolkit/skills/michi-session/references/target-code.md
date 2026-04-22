# Session: Code Target

Guidelines for sessions where the deliverable is working code. Loaded by the session skill when the milestone produces
code, tests, and runnable software.

## Core Loop — TDD by default

```
Write failing test → Implement → Pass → Refactor → Repeat
```

Test comes first. The test names the behavior; the implementation satisfies it; the verification is already in
place by the time the code is done. That's cheaper than writing code and then back-filling tests against an
already-committed-to design.

- **Write the failing test before the implementation.** Red first, then green.
- **Run the full suite after every file change.** Not after every step — after every file. The fast feedback
  loop is the primary quality gate.
- **If tests fail (other than the one you just wrote), fix before moving on.** Do not accumulate broken tests.
- **Refactor only on green.** With the suite passing, refactor with confidence.

## Exceptions to TDD Default

TDD is the baseline for code sessions. Skip it only when the user explicitly says so for a given milestone.
Typical exception cases:

- **Spikes and throwaway explorations** — code meant to be read, discussed, and rewritten, not maintained.
- **Prototypes** — the design isn't settled yet; testing a moving target produces low-value tests.
- **Mechanical refactors** where behavior is already pinned by existing tests — the existing suite IS the
  safety net.

In all exception cases, the user will say "skip TDD for this one" (or equivalent). Don't assume the exception;
it's named, not inferred.

Non-code targets don't apply. TDD is a code-only default; research/design/planning milestones use the exit
criteria discipline from `target-non-code.md`.

## Self-Review

Before running verification, re-read your own diff:

```bash
git diff HEAD
```

Check against the plan's acceptance criteria. Look for:

- Hardcoded caller assumptions (grep for string literals identifying the caller)
- Missing schema/enum updates (if you introduced a new type or service name)
- Paths that concatenate URL fragments (the /v3 double-prefix class of bug)
- Unused imports or dead code from copy-paste

## Verification Checklist

- [ ] **New Level A scenarios pass** — Given-When-Then from plan doc
- [ ] **Regression scenarios pass** — existing scenarios from previous milestones
- [ ] **Unit tests pass** — `pnpm test` or equivalent
- [ ] **Integration tests pass** — `pnpm test:integration` or equivalent
- [ ] **Cross-package schemas updated** — if you introduced new types, enum values, or service names, verify they're in
      all downstream validation schemas
- [ ] **No hardcoded caller assumptions introduced** — grep for hardcoded source/service/caller strings in shared code
- [ ] **Scope check** — compare diff against the plan's scope. If implementation expanded beyond plan, log as a decision
      (classify as design-choice or contract-change)

## Code Review (subagent)

For milestones touching multiple packages, introducing new types/callers, or modifying schemas — launch a code-reviewer
subagent:

- Provide: the diff (`git diff` output), the plan doc, the acceptance criteria
- Do NOT provide: your implementation reasoning or decision context (the reviewer evaluates independently)
- The reviewer checks for: bugs, logic errors, security issues, missed edge cases, convention violations
- Address high-confidence issues before proceeding

For single-package, low-risk milestones: self-review is sufficient. Use judgment, but err toward reviewing.

## Sustainability Check (pre-commit)

After verification passes, before committing. Brief review scaled to the milestone.

**Refactoring pass:**

- Obvious duplication or unclear naming in the work just completed?
- Did copy-paste introduce code that should be extracted?
- Are function/component names revealing intent?

**Test evaluation:**

- Are mocks appropriate? (At I/O boundaries, not between internal modules.)
- Are tests readable? Do test names describe behavior, not implementation?
- Do tests capture intent or just verify the implementation? (Assert on outcomes, not which internal methods were
  called.)
- Speed tradeoff: fast is good, but not at the cost of test quality.
- Are there obvious test cases missing?
