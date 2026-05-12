---
name: michi-pr-prep
description:
  Prepare a PR review guide — a companion document that helps reviewers understand what they're looking at, why
  decisions were made, and where to focus attention. Two output shapes (TLDR + Details by default, or TLDR-only
  via `/michi-pr-prep tldr`); two context modes (in-session, from-diff).
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

## Output Shapes

The skill produces two output shapes:

- **Default (`/michi-pr-prep`)** — the full guide: **TLDR** section followed by **Details** section.
- **TLDR only (`/michi-pr-prep tldr`)** — only the TLDR section. A short, essential version for a reviewer who
  needs orientation, not a deep map.

TLDR composes: *What This PR Does*, *How the diff breaks down*, *What to look at first*.
Details composes: *File Map*, *Design Decisions Worth Understanding Before Reviewing*, *Things to Check During
Review*, *What Was Not Changed*, *Process Notes*.

Use TLDR-only when the PR is small enough that Details would over-engineer the review, when the reviewer already
has the context, or when the author wants a fast orientation post that won't drown out a quick read. When in
doubt, default to the full guide — TLDR + Details is additive, and the reviewer can stop reading at the TLDR
boundary.

Output shape (TLDR vs full) is **orthogonal** to context mode (in-session vs from-the-diff) below. Context mode
shapes confidence and depth; output shape controls length.

## Context Modes

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

Both context modes produce the same structure. The depth and confidence differ.

The guide has two top-level sections — **TLDR** and **Details**. Default invocation produces both; `/michi-pr-prep
tldr` produces only the TLDR and skips Details entirely.

### TLDR

The short, essential version for the reviewer.

#### What This PR Does

Brief summary of the change — what it delivers, not how. Don't editorialize about why it matters or what the
reviewer's job is — the reviewer knows. If there are specific tensions or open questions worth flagging up front,
include them in-session or with the human's guidance.

#### How the diff breaks down

A table categorizing the changed files by area, with file counts and line deltas. Gives the reviewer a "what kind
of change is this and how big" orientation in one glance.

**Generating the table:**

- Source data: `git diff --stat <base>...HEAD` (or `gh pr diff --stat <number>` for a remote PR). For deeper
  per-area breakdowns, `git diff --numstat <base>...HEAD` gives raw per-file adds/deletes that can be summed by
  category.
- Default categories: `docs/`, production source (`src/` or `*/src/**`), tests (`tests/` or `*/tests/**`), and a
  catch-all `Other (config, lockfiles, top-level)`.
- Monorepos and large changes may warrant subsystem-shaped areas (e.g., `*/migration/`, `*/orbit/`) when several
  areas are touched at meaningful scale. Use judgment — the goal is for the reviewer to see the shape of the
  change, not to itemize every directory.
- The Note column says in one short phrase what's in that area. Avoid "various files" — name the seam, the
  pattern, the directories that matter, the rough split (e.g., "mostly new files; almost zero deletions").
- Include a bold **Total** row.

Example:

````markdown
### How the diff breaks down

| Area | Files | + lines | - lines | Note |
|---|---:|---:|---:|---|
| `docs/` (epic narrative) | 49 | +13,389 | -45 | Plans, debriefs, journal, pattern docs, epic.md, deferrals. Mostly new files; almost zero deletions |
| `*/src/**` (production code) | 153 | +4,008 | -727 | The seam (`common/search/`) + sweeps in `*/migration/`, `*/orbit/`, `*/lantern/`, `*/installer/`, etc. |
| `*/tests/**` | 107 | +3,594 | -546 | Unit + integration; ~equal scale to src changes |
| Other (config, lockfiles, top-level) | 14 | +1,221 | -30 | `pyproject.toml`, `uv.lock`, `STATUS.md`, `docker-compose.override.yml`, etc. |
| **Total** | **323** | **+22,212** | **-1,348** | |
````

#### What to look at first

Two to four bullets pointing the reviewer at the highest-value or highest-risk parts of the diff. Concrete — name
the file, the seam, or the decision. Not "review carefully" — "review `common/search/adapter.py` first; it's the
seam that ties the new and old paths together."

**In-session:** Drawn from where the author knows the work was hardest or where the implementation surprised them.

**From the diff:** Inferred — large-deletion files, cross-cutting changes, new abstractions, anything that looks
load-bearing.

### Details

Skip this section entirely if invoked as `/michi-pr-prep tldr`.

#### File Map

Organize the changed files by role, not alphabetically. Group by:

- New files (the core of the change)
- Modified files (integration points)
- Test files
- Config / infrastructure changes

For each group, one line per file explaining its role. The reviewer should be able to scan this and know where to
start reading.

#### Design Decisions Worth Understanding Before Reviewing

The most valuable section. Each decision should explain:

- What was chosen
- Why (the tension, the tradeoff, the constraint)
- What the alternative was (if relevant)

**In-session:** Rich. You know the real reasons. Include abandoned approaches, pivots, things that were tried and
didn't work. Example: "The narrowing concept was abandoned because interactions among the test predicates made
clean-room reimplementation harder, not easier."

**From the diff:** Inferred. Frame as tensions: "This looks like a tradeoff between X and Y." Be honest about what
you're inferring vs. what's evident from the code.

#### Things to Check During Review

Specific, actionable items the reviewer should verify. Not "check for bugs" — concrete instructions:

- "Every write loop should use MULTI/EXEC pipeline"
- "The error handling changes affect all resources, not just RBAC — verify existing 422 handling isn't broken"
- "The normalization consistency guarantee depends on the serializer calling normalize internally"

**In-session:** Targeted. The author knows where the risk lives. Point the reviewer there.

**From the diff:** Broader. Flag anything non-obvious — cross-cutting changes, defensive code patterns that suggest
fragility, error handling blast radius.

#### What Was Not Changed (In-Session Only)

Explicitly scope what the reviewer should *not* worry about. This saves review time and prevents false-positive
comments on things that were intentionally left alone.

- "No call sites were changed to use the new implementations yet"
- "The dependency version was pinned *down*, not up — the newer version has a regression"

**From the diff:** Omit this section unless something is clearly in-scope but untouched (e.g., a schema was added but
no migration exists).

#### Process Notes (In-Session Only)

How the code was built, when it matters for review. For example, understanding that tests were written against the
old library first and then retargeted gives the reviewer confidence in the test suite's fidelity.

Omit when the process was straightforward.

## Producing the Guide

Pick the context mode (in-session or from-the-diff) based on what you have. Pick the output shape (TLDR + Details
or TLDR only) based on the invocation — `/michi-pr-prep` produces both; `/michi-pr-prep tldr` produces only the
TLDR. The flows below cover the full sequence; if invoked as `tldr`, stop after the TLDR steps and skip the
Details work.

### In-Session Flow

1. Review the plan doc's Decisions and Notes sections
2. Review the session transcript or your memory of the implementation
3. **TLDR** — generate the diff-breakdown table (`git diff --stat <base>...HEAD`); draft *What This PR Does* and
   *What to look at first* using author context
4. **Details** (skip if `tldr` mode) — draft File Map, Design Decisions, Things to Check, What Was Not Changed,
   Process Notes
5. Ask the human: "Anything I'm missing? Any decisions I under-explained?"
6. Include the guide in the PR body or as a companion comment

### From the Diff Flow

1. Get the file list and stats: `gh pr view --json files` and `gh pr diff --stat` (or `git diff --numstat
   <base>...HEAD` for local raw per-file numbers)
2. Read the diff (`gh pr diff`) and the PR description (it may already explain some decisions)
3. **TLDR** — categorize the changed files into areas, generate the diff-breakdown table, draft *What This PR
   Does*, infer *What to look at first* from the diff
4. **Details** (skip if `tldr` mode) — organize files by role for the File Map, infer Design Decisions, flag
   non-obvious patterns and cross-cutting changes
5. Present the draft guide — the human may add context you couldn't infer

### What's Next

Post the guide as part of the PR (body or comment). If the guide surfaced questions you can't answer from context,
flag them — they're valuable review prompts.
