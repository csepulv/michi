---
name: michi-pr-prep
description:
  Prepare a PR review guide — a companion document that helps reviewers understand what they're looking at, why
  decisions were made, and where to focus attention. Two modes based on available context.
---

# Michi PR Review Guide

Prepare a review guide for a pull request. Not the PR description — the "here's what to pay attention to and why"
companion that helps a reviewer navigate the change efficiently.

**The gap this fills:** PR authors have context that reviewers don't — why decisions were made, what tensions existed,
what was tried and abandoned, where the real risk lives. Without a guide, the reviewer discovers all of this by reading
the diff cold. A good guide transfers the author's context to the reviewer.

**Principles served:** Surface assumptions (the guide makes implicit decisions explicit). Shared context as foundation
(the reviewer gets the author's context). See `references/principles.md`.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there take priority over this skill's defaults.

## Two Modes

### In-Session: You Were There

You have the implementation context — the transcript, the decisions, the tensions, the abandoned approaches. This is
the premium output. Use when:

- You were the agent that wrote the code (or have the session transcript)
- The human was pairing and can supplement your context
- There's a plan doc with Decisions and Notes sections

**The guide tells the story behind the code.** Not just what was built, but how it was built — the process, the
pivots, the things that didn't work. The reviewer gets the journey, not just the destination.

### From the Diff: Reading It Cold

You're looking at a completed PR without implementation context. Use when:

- Reviewing someone else's work
- The session context is unavailable
- Preparing a guide for a PR that's already been submitted

**The guide provides a map.** Infer the design decisions from the code, flag what looks non-obvious, give the reviewer
an efficient reading order. You can't tell the story — you can reconstruct what seems important.

## The Guide Structure

Both modes produce the same structure. The depth and confidence differ.

### What This PR Does

Brief summary of the change — what it delivers, not how. Don't editorialize about why it matters or what the
reviewer's job is — the reviewer knows. If there are specific tensions or open questions worth flagging up front,
include them in-session or with the human's guidance.

### File Map

Organize the changed files by role, not alphabetically. Group by:

- New files (the core of the change)
- Modified files (integration points)
- Test files
- Config / infrastructure changes

For each group, one line per file explaining its role. The reviewer should be able to scan this and know where to
start reading.

### Design Decisions Worth Understanding Before Reviewing

The most valuable section. Each decision should explain:

- What was chosen
- Why (the tension, the tradeoff, the constraint)
- What the alternative was (if relevant)

**In-session:** Rich. You know the real reasons. Include abandoned approaches, pivots, things that were tried and
didn't work. Example: "The narrowing concept was abandoned because interactions among the test predicates made
clean-room reimplementation harder, not easier."

**From the diff:** Inferred. Frame as tensions: "This looks like a tradeoff between X and Y." Be honest about what
you're inferring vs. what's evident from the code.

### Things to Check During Review

Specific, actionable items the reviewer should verify. Not "check for bugs" — concrete instructions:

- "Every write loop should use MULTI/EXEC pipeline"
- "The error handling changes affect all resources, not just RBAC — verify existing 422 handling isn't broken"
- "The normalization consistency guarantee depends on the serializer calling normalize internally"

**In-session:** Targeted. The author knows where the risk lives. Point the reviewer there.

**From the diff:** Broader. Flag anything non-obvious — cross-cutting changes, defensive code patterns that suggest
fragility, error handling blast radius.

### What Was Not Changed (In-Session Only)

Explicitly scope what the reviewer should *not* worry about. This saves review time and prevents false-positive
comments on things that were intentionally left alone.

- "No call sites were changed to use the new implementations yet"
- "The dependency version was pinned *down*, not up — the newer version has a regression"

**From the diff:** Omit this section unless something is clearly in-scope but untouched (e.g., a schema was added but
no migration exists).

### Process Notes (In-Session Only)

How the code was built, when it matters for review. For example, understanding that tests were written against the
old library first and then retargeted gives the reviewer confidence in the test suite's fidelity.

Omit when the process was straightforward.

## Producing the Guide

### In-Session Flow

1. Review the plan doc's Decisions and Notes sections
2. Review the session transcript or your memory of the implementation
3. Draft the guide, focusing on decisions and "things to check"
4. Ask the human: "Anything I'm missing? Any decisions I under-explained?"
5. Include the guide in the PR body or as a companion comment

### From the Diff Flow

1. Get the file list (`gh pr view --json files`)
2. Read the diff (`gh pr diff`)
3. Read the PR description (it may already explain some decisions)
4. Organize files by role, infer the design decisions
5. Flag non-obvious patterns, cross-cutting changes, and potential risk areas
6. Present the draft guide — the human may add context you couldn't infer

### What's Next

Post the guide as part of the PR (body or comment). If the guide surfaced questions you can't answer from context,
flag them — they're valuable review prompts.
