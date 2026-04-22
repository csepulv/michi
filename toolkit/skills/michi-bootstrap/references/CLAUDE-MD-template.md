# [Project Name]

## References

@./PROJECT.md
@./STATUS.md
@./ARCHITECTURE.md

## Michi

docs-root: docs

## Current Work

[Update this section each session to point at the active milestone]

@./docs/epics/[epic-name]/plans/[current-milestone].md

## Structure

[Brief project structure — monorepo layout, key directories, packages]

## Build & Test

```bash
[install command]
[dev command]
[test command]
[build command]
```

## Conventions

[Language, file naming, code style, patterns the agent should follow]

## Key Files

[Files that exemplify the project's patterns — the agent uses these as templates]

- `path/to/exemplar-route.js` — route pattern to follow
- `path/to/exemplar-test.js` — test pattern to follow
- `path/to/exemplar-service.js` — service pattern to follow

## Gotchas

[Project-specific things that trip people up — framework quirks, config surprises, naming inconsistencies]

---

## Michi Instructions

### Session Protocol

1. **Before starting:** Read the plan doc for this milestone. Verify correct branch (`git branch`).
2. **During implementation:** Run tests after every file change.
3. **After implementation:** Run the full verification checklist in the plan doc.
4. **After verification:** Commit with `michi(mN): description`. Update STATUS.md. Notify via Slack.

### Decision Logging

When you make a choice without human input, log it immediately in the plan doc's `## Decisions` section.

**Classification:**

- `implementation-detail` — internal choices (naming, file organization, algorithm). Log it.
- `design-choice` — interface shape, data format, library selection. Log it, human reviews during debrief.
- `contract-change` — public API change, schema modification, new service type. **Log it AND notify the human
  immediately.**

If unsure whether something is a contract-change: it is. Notify.

### Verification Checklist

After completing a milestone, you MUST complete all of these:

- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] At least one real API call with real data succeeds (NOT dry-run)
- [ ] Result verified in data store
- [ ] Cross-package schemas updated (if new types/enums introduced)
- [ ] No hardcoded caller assumptions introduced
- [ ] Committed on milestone branch

### Cross-Package Changes

When adding a new entry point (CLI, extension, worker, API route) to an existing pipeline:

1. Grep for hardcoded caller assumptions — service names, source strings, user agent strings
2. Check all validation schemas (Zod, JSON Schema) for enum values needing updates
3. Check downstream services for assumptions about who's calling

### Code Review

For milestones touching multiple packages or modifying schemas: launch a code-reviewer subagent with the diff and spec.
Do not provide your implementation reasoning — let the reviewer evaluate independently.

### Git

- Commit after each milestone with `michi(mN): description`
- Add specific files — do not `git add -A`
- Do NOT push — the human controls what leaves the machine
- Do NOT create PRs unless explicitly asked

### Communication

- **Notify on:** milestone completion, contract-change decisions, verification failures, blockers
- **Channel:** [Slack channel / remote-control / other]
- **Don't notify on:** routine progress, implementation-detail decisions

### Non-Code Work

For non-code deliverables (research, roadmaps, design reviews, backlog generation), do not use superpowers skills
(brainstorming, writing-plans, executing-plans). They assume code deliverables. Use Michi skills with the non-code target
reference.

### Learnings

[Project-specific gotchas discovered during previous sessions — update after each debrief]
