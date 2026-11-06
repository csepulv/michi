# Verification Strategy

Reference for the michi session skill. Why verification works the way it does and how to apply it.

---

## The Problem

An autonomous agent writes code and writes tests for that code. The tests validate the agent's implementation against
the agent's understanding. This is circular — the agent is grading its own homework.

In one development run: 221 tests passed with 0 failures at completion, yet 2 bugs were found by a human running the
code for real. Both were integration-boundary bugs — cross-package gaps the agent's tests couldn't catch.

---

## The Framework: Scenario-Based Verification

Verification is co-designed with the spec during planning. The core unit is the **scenario** — a story about a user
getting a benefit, decomposed into executable Given-When-Then steps.

### Why Scenarios, Not Just Tests

Unit tests verify that code works as the agent intended. Scenarios verify that the system delivers what the user needs.
The difference:

- Unit tests validate individual components. Scenarios test the relationships _among_ components — where
  integration-boundary bugs live.
- The agent writes unit tests from its understanding of the code. Scenarios are co-designed with the human from
  understanding of user intent.
- A scenario like "user syncs chats and finds them searchable" tests the full pipeline. A real API call exercises the
  validation layer (e.g., a Zod schema) that unit tests with mocked boundaries never touch — exactly where escaped
  bugs have lived.

### Verification Levels

Not all verification can be automated. Scenarios are categorized by evaluator:

| Level | Evaluator                       | Example                                                 | When                      |
|-------|---------------------------------|---------------------------------------------------------|---------------------------|
| **A** | Agent executes autonomously     | API returns 200, data lands in ES, search results match | Post-milestone, mandatory |
| **B** | Agent executes, judgment needed | Error message is clear, output format is reasonable     | Debrief review            |
| **C** | Human evaluates                 | UX feels right, workflow is natural                     | Debrief or async review   |

The session skill executes Level A scenarios. Level B and C are evaluated during debrief.

### Given-When-Then Format

Each Level A scenario is decomposed into concrete steps:

```
Scenario: User creates a drawer and searches within it
  Given the API server and ES are running
  And the user has 5 existing bookmarks
  When the user creates a drawer called "React Resources" via POST /api/drawers
  And adds 3 bookmarks to the drawer
  Then the drawer appears in MongoDB with correct metadata
  And those 3 bookmarks have the drawer_id in their ES drawers[] array
  When the user searches within that drawer for "hooks"
  Then only bookmarks in that drawer matching "hooks" are returned
```

The agent executes these steps literally — making API calls, querying data stores, verifying assertions. Pass or fail
per step.

The checklist itself is in `target-code.md` (code) and `target-non-code.md` (non-code).

---

## Why This Matters

Verification quality constrains autonomy. You can only be trusted with as much independence as verification can catch.
Every scenario that passes builds trust. Every skipped check erodes it.
