# Patterns and Anti-Patterns

A catalog of observed patterns and anti-patterns from running autonomous agent work. Each entry is tagged with a confidence level: **high** = repeatedly observed, **medium** = context-dependent, **low** = prescription, not yet validated.

---

## Patterns (Do This)

### Fast tests as primary feedback loop

**Confidence:** High — the single most effective quality gate

Run the test suite after every file change. A sub-second unit test suite enables this without friction. If your suite takes longer than 5 seconds, it's too slow — split into fast (unit) and slow (integration) tiers.

```
Change file → Run tests → See result → Iterate
```

A sub-second vitest suite lets the agent fall into a tight feedback loop naturally.

### Existing patterns as templates

**Confidence:** High — well-patterned codebases are the biggest autonomy accelerator

A codebase with consistent conventions (route patterns, test patterns, repository patterns) lets the agent produce correct code by following existing examples (e.g., `plugins-web.js` → `plugins-chat.js`).

**Implication:** Before running Michi on a project, invest in making patterns explicit and consistent. The agent amplifies whatever patterns exist — good or bad.

### Explore before implement

**Confidence:** High

Use Explore subagents to deeply analyze relevant code before writing anything. Map interfaces, trace data flows, understand existing patterns. Front-loaded investment that saves significant implementation time.

**Anti-pattern:** Exploring the wrong branch (see below).

### Incremental milestones with working increments

**Confidence:** High

Each milestone should produce something that works end-to-end, even if partially. Verification is possible at each step, bugs surface early, the human can review tangible progress.

**Anti-pattern:** Batching milestones in a single session.

### Plan docs as contracts

**Confidence:** High

Write the plan before implementing. The plan doc serves as:

- A scope agreement between human and agent
- A self-check for completeness
- A progress tracker (checkboxes)
- A record of what was decided and why

Plans survive context compaction better than conversation memory.

### Document judgment calls as they happen

**Confidence:** Low — prescription, not always practiced

When the agent makes an autonomous decision (e.g., "built adapter as placeholder because target wasn't installed"), document it immediately in the plan doc. The human reviews during debrief.

Real-time documentation is the goal; the mandatory `## Decisions` section in plan docs is the mechanism. Retroactive recall works while context is hot, but becomes unreliable in longer sessions.

### Grep for caller assumptions when adding entry points

**Confidence:** High — general principle

When adding a new caller (CLI, extension, worker) to an existing pipeline:

1. Grep for hardcoded values related to caller identity (service names, source strings, user agent strings)
2. Check all validation schemas (Zod, JSON Schema, etc.) for enum values needing updates
3. Check downstream services for assumptions about who's calling

This class of bug — missing enum value, hardcoded identity — is a frequent escapee of unit tests.

### Slack notifications at milestones

**Confidence:** Medium — good for async review, but notification fatigue is a risk

Post a structured message to Slack at milestone completion:

- What was built
- Test results
- Deviations from plan
- Whether the agent is blocked or continuing

### Migration-followup audit

**Confidence:** High — a class of bug that keeps surfacing

When updating an API version — or any contract-changing dependency migration — audit the adjacent dimensions, not just the one you migrated. Endpoint paths, response shapes, auth headers, rate limits, pagination, error semantics. The bug is almost never in the dimension you deliberately changed; it's in the neighbor you didn't think to re-check.

**How to apply:** After any migration, write the audit list before declaring done. Each item gets a one-line check: *"I confirmed <dimension> still works under the new version."* If you can't confirm one, that's the one that will bite.

**Related:** Self-validating tests — migration tests usually validate what you migrated, not the neighbors.

### Doc-update-after-feature (before claiming done)

**Confidence:** High

After adding a CLI flag, schema change, environment variable, or public-API change, update the README and relevant examples *before* declaring done. Docs drift is how users get confused in the very next session; the agent writes the right code and the wrong instructions.

**How to apply:** Treat the doc update as part of the feature, not post-completion polish. A feature that behaves correctly but has wrong docs is not done — the user who reads the docs next can't reproduce the behavior.

**Related:** Declaring done before verification is complete — docs are part of verification for anything user-facing.

---

## Anti-Patterns (Don't Do This)

### Self-validating test suites

**Confidence:** High — the core risk of autonomous agents

The agent writes code. The agent writes tests for that code. The tests validate the agent's implementation against the agent's understanding. This is circular.

**Fix:** Layer 3+ verification (smoke tests with real API calls, holdout tests, human verification). See [Verification Strategy](verification-strategy.md). See also principles.md — "Verification Governs Autonomy."

### Exploring the wrong branch

**Confidence:** High — simple to prevent, expensive when it happens

An agent exploring the wrong branch produces an incomplete picture of the codebase, leading to incorrect planning questions and wasted cycles.

**Fix:** Always run `git branch` on any repo before exploring. Add to pre-session checklist.

### Dry-run as verification

**Confidence:** High

A `--dry-run` flag that skips the real API call tests everything except the most important thing. Dry-runs can pass perfectly while the real submission fails on validation (e.g., a Zod schema).

**Fix:** Smoke tests must use real API calls. Dry-run is development convenience, not verification.

### Batching milestones in a single session

**Confidence:** High

Milestones rushed through a single autonomous stretch accumulate bugs that full plan-implement-verify treatment would have caught.

**Fix:** Each milestone gets full treatment. If you're batching, you're scoping wrong.

### Edit tool in late-session context

**Confidence:** High — known Claude Code behavior in long sessions

Context compaction evicts Read tool cache. Edit requires a preceding Read. In late sessions: re-read before every edit, or fall back to Bash sed/Write.

**Mitigation options:**

- Shorter sessions (one milestone per session)
- Write (full file replacement) instead of Edit in late sessions
- Batch related edits into a single Bash heredoc
- Explicit re-read checkpoints

### Mocked MongoDB tests for operator semantics

**Confidence:** High

Mocking MongoDB for unit tests is fine for verifying the right method is called. But mocked tests don't catch operator conflicts (e.g., a field in both `$set` and `$setOnInsert`). Use mongodb-memory-server for repository-level tests.

### Trusting undocumented formats

**Confidence:** Medium — sometimes unavoidable

Building adapters for undocumented or partially documented formats produces fragile code. Parsers that rely on magic-index navigation or implicit structure break if refactored.

**Mitigation:** Mark these adapters as explicitly fragile. Add extensive comments. Don't refactor without end-to-end testing against real data.

### Agent declares "done" before verification is complete

**Confidence:** High

The agent's definition of done defaults to "code written + unit tests pass." The human's definition is broader: all verification scenarios covered, docs updated, manual verification run.

**Fix:** Explicit verification checklist in CLAUDE.md. The deeper fix is encoding "done" criteria in the plan doc per milestone, not relying on the agent's judgment about completeness. See the standalone `verification-before-completion` skill and principles.md on "Deliberate and Methodical."

### Agent doesn't search outside its workspace

**Confidence:** Medium

Agents default to searching only within their immediate workspace. Useful tools, utilities, or reference code in sibling repos get missed unless the human points at them.

**Fix:** A "tools and resources" section in CLAUDE.md listing relevant utilities in sibling repos and external paths.

---

## Context-Dependent (Judgment Required)

### Task tracking overhead

Task tracking (TaskCreate/TaskUpdate) is useful for structured, planned work with multiple steps, but becomes overhead in rapid iterative phases.

**Guideline:** Use task tracking for milestones with 5+ steps. Skip for small, focused work.

### AskUserQuestion frequency

Too many questions slows the agent down. Too few leads to wrong assumptions.

**Guideline:** Ask during planning (scope, acceptance criteria, ambiguities). During implementation, make judgment calls and document them. Ask only when genuinely blocked.

### Commit frequency

Committing after each verified milestone creates save points and makes review easier. Mid-milestone partial commits are worse than no commits.

**Guideline:** Commit after each milestone passes verification. Don't commit mid-milestone.
