# M[N]: [Title]

## Context

[Why this milestone exists — the problem or need it addresses, what prompted it]

## Scope

[What this milestone delivers]

**Out of scope:** [What it explicitly does NOT include]

## Acceptance Criteria

[Explicit conditions for "done" — verified, not just asserted]

- [ ] [Specific verifiable outcome]
- [ ] [Specific verifiable outcome]
- [ ] Real API call with real data succeeds (not dry-run)
- [ ] Result verified in data store
- [ ] Cross-package schemas updated (if new types/enums introduced)
- [ ] Committed on milestone branch

## Scenarios

[Co-designed during planning. Each scenario is a story about a user accomplishing something. Scenarios shape the spec —
writing them surfaces gaps, ambiguities, and integration concerns.]

### Scenario: [Name]

**Story:** [2-3 sentences — who is doing what, why it matters, what benefit they expect] **Level:** A / B / C
**Given-When-Then:**

```
Given [precondition]
When [action]
Then [expected outcome]
```

[Repeat for each scenario. Aim for 3-5 per milestone.]

## Steps

[Numbered implementation steps]

1. [Step with file paths]
2. [Step with file paths]

## Files

| File              | Action          | Purpose        |
| ----------------- | --------------- | -------------- |
| `path/to/file.js` | Create / Modify | [What and why] |

## Decisions

[Empty — agent fills during implementation]

[Format for each decision:]

```
### [Short title]
- **Decision:** [What you chose]
- **Alternatives:** [What else you considered]
- **Reasoning:** [Why this choice]
- **Impact:** implementation-detail | design-choice | contract-change
- **Reversible:** Yes / No
```

## Notes

[Empty — agent fills during implementation with gotchas, surprises, things to remember]

## Verification

### During Implementation (fast feedback)

[Scenarios and tests to run during the implementation cycle — fast, cheap, guiding development like TDD]

- [ ] Unit tests pass after each file change
- [ ] [Fast Level A scenarios that validate core behavior as it's built]

### Final Verification (comprehensive, post-milestone)

[All mandatory before declaring done.]

**New scenarios (this milestone):** [Given-When-Then steps from ## Scenarios above]

**Regression scenarios (previous milestones):** [Existing scenarios from the project's verification catalog relevant to
this milestone. List or reference the catalog.]

**Standard checks:**

- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Cross-package schemas updated (if new types/enums introduced)
- [ ] No hardcoded caller assumptions introduced
- [ ] Scope check — implementation stays within the plan's stated scope

### Level B/C Scenarios (debrief/human review)

[Scenarios requiring judgment — noted here, evaluated during debrief]
