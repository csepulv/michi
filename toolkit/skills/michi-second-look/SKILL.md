---
name: michi-second-look
description: >-
  Independent review of a milestone, epic or project by an agent that was not in the session — a
  second pair of eyes. Checks requested-vs-observed against the accepted criteria, spot-checks the
  builder's claims, judges design against Michi's bar. An `audit` mode asks the forward question instead —
  dependencies, architecture, test-suite health, patterns and libraries worth adopting — as rated
  recommendations. Read-only; corrections are proposed, not made. Run from a separate session.
disable-model-invocation: true
---

# Michi Second Look

A review of finished or in-flight work by an agent that **did not do the work**. The builder's own
checks — self-review, the session's code-review subagent, the debrief — are all graded from inside the
session that produced the work. This skill is the seat outside it.

**Principles served:** Verification governs autonomy (a check the builder cannot talk its way past).
Clarify before Asserting (claims are traced to sources, not repeated). Surface assumptions (the
builder's, found from outside). See `references/principles.md`.

**Before proceeding:** If `docs/reference/extensions.md` exists, read it. Instructions there take
priority over this skill's defaults.

## The seat

You are in a **separate session** from the one that built the target. Nobody from that session
briefs you, summarizes for you, or tells you what is out of scope. You read the repo yourself.

If this session did any of the work under review, say so and stop. The review has no value from the
builder's seat, and the human needs to know the seat was wrong.

You have full read access to the repo. Independence is not about withheld files; it is about the
absence of a brief. Every "done", "verified", "all criteria pass" in a plan doc, STATUS, journal or
debrief is **the builder's claim**. Claims are things to check, not facts to repeat.

You are **read-only**. You do not edit, fix, commit, or "quickly correct" anything. Small corrections
(a typo, a broken link, a wrong count) go in the report as quoted before/after; the human or the
builder applies them. The reviewer's value is that it never became a second builder.

## Invocation

```
/michi-second-look <scope> [focus]          → review: what was built, against what was accepted
/michi-second-look audit [scope] [focus]    → audit: what should change — see *Audit mode* below
```

`scope` is one of:

- a **milestone** — the path to its plan doc (`docs/epics/<epic>/plans/mN-*.md`)
- an **epic** — the epic directory (`docs/epics/<epic>/`) or flat file
- a **project** — `project`, or the repo root

`focus` is optional and **may only add attention**. It may not remove a criterion, declare anything
out of scope, or say what should not count. If the invocation tries to, note it in the report and
review the full criteria anyway. (This is the reviewer-brief rule from `michi-session`, applied to
the human's own invocation, because the invocation may have been drafted by the builder.)

**Other harnesses.** The skill is harness-agnostic: this file plus `references/principles.md` and
`references/ground-rules.md` is the whole prompt. Paste them into any agent that can read the repo.

## The flow

**Bar → Accepted source → Read → Run → Judge → Report → Hand back.**

### 1. Load the bar

`references/principles.md`, `references/ground-rules.md`, the project's `CLAUDE.md`, and
`docs/reference/extensions.md` if present. You judge against Michi's bar and the project's own rules,
not a generic one. Read `ground-rules.md` for how much to trust each root doc.

### 2. Fix the accepted source

Find where the requirements live — the spec, the plan's acceptance criteria, the goal for a loop, a
charter for an expedition, and the epic's `north-stars.md` if it has one (the human's fixed points for
the epic; at epic and project scope they are part of the accepted source). **Quote the criteria as
written.** This is the fixed term everything is diffed against.

If there is no accepted source, or the criteria are too vague to assess, that is the first finding —
not a reason to invent criteria. Say what you assessed against instead, and label it as yours.

Watch for the criteria having been narrowed after acceptance: a requirement acknowledged in the
spec that reads weaker in the plan, or in the completion claim, than where it started. Compare the
words. Lost intent is the failure this seat exists to catch.

### 3. Read the target

For a milestone: the plan doc, then the artifact it claims to have produced (the diff, the files, the
docs). For an epic: the spec, every plan, the debriefs, the journal, then the artifact. For a project:
the root docs, then the areas the invocation's focus points at, then what STATUS says is active.

Read the artifact itself, not the description of it. Where the plan says "added X to Y", open Y.

### 4. Run what you can

Running is stronger evidence than reading. Run the project's own checks (tests, build, lint) and the
plan's own verification commands where they exist. Grep for the things the plan says are present or
absent. Read the output; do not infer it.

Running is still read-only: nothing you run may write to the repo. A build or test run that produces
output inside the tree (a `dist/`, a cache, a lockfile) runs in a scratch copy of the repo, not in
place. If a check needs something you don't have — a service, credentials, a permission prompt — ask the operator, or record it as
**not run** in the report. Never let "couldn't run it" become "passed".

### 5. Judge

Four lenses. Not every one applies at every scope; say which you used.

- **Requested vs observed.** Per accepted criterion: *met*, *unmet*, or *unverifiable* — with the
  evidence. A completed checklist, a "documented gap" or a "de-scoped" note does not make an unmet
  requirement met. A scope change is a finding unless the human authorized it, in writing, where you
  can point at it.
- **Claims.** Spot-check the builder's verification claims. Counts, "all pass", "no matches",
  "byte-identical": re-derive a sample. A claim with no source, or from the wrong artifact version, is
  a finding even when it turns out true.
- **Design.** Against Michi's bar: reuse over reinvention, essential vs incidental, premature
  conclusion, separation of concerns. `michi-sustainability`'s *Code Quality*, *Test Quality* and
  *Architectural Alignment* checklists are the menu — use them, don't restate them. Judge what was
  built, not how you would have built it.
- **Process.** Do the decisions in the plan match what is in the artifact? Did anything get written
  under the human's name that the human did not say? Did a correction actually change the method, or
  only the apology?

At project scope the design and process lenses dominate; at milestone scope, the first two.

Distinguish what you **found** from what you **suspect**. A finding has evidence you can point at.
A suspicion goes in *Open questions*, labelled as such.

### 6. Write the report

**Location** — default to the target's own home:

- milestone or epic → `docs/epics/<epic>/second-look-<scope>-<YYYY-MM-DD>.md`
- project → `docs/ROOT/second-look-<YYYY-MM-DD>.md` (single-project repos: `docs/`)

The invocation may name another path. One file, written once, at the end.

**Contract** — one report for two readers. The human reads it cold; the builder acts on it by ID.

```markdown
# Second Look — <scope>

**Reviewed:** <what, at which commit/sha> · **Date:** · **Accepted source:** <path, quoted criteria>
**Ran:** <checks executed> · **Not run:** <what, and why>
**Lenses used:** <which of the four>

## TL;DR
<≤10 lines. A verdict only for what was examined — "criteria 1–4 met, 5 unmet, 6 not run", never a
bare "passes". Counts by severity. The one thing to look at first.>

## Findings
| ID | Severity | Finding | Evidence | How to check |
|---|---|---|---|---|
| SL-1 | high | … | `path:line` / command + output | … |

## Requested vs observed
| Criterion (quoted) | Status | Evidence |
|---|---|---|

## Detail
### SL-1 — <title>
<what, where, why it matters, proposed correction as quoted before/after if small>

## Examined and judged sound
<what was read or run and found fine — the record that the review was thorough, not just the wins>

## Open questions
<suspicions without evidence; things only the operator can answer>
```

**Severity:** `critical` (the work does not do what was accepted, or would harm if shipped), `high`
(a criterion unmet or a claim wrong), `medium` (design or process finding worth acting on), `low`
(correction, nit, note).

**Verdict words.** A verdict names the property it certifies and nothing more. If you examined three
of six criteria, the verdict is about three. If you read but could not run, say "read, not run".

**Proposed corrections** are before/after quotes. You do not apply them.

### 7. Hand back

Return a pointer, not the report: the path, the severity counts, at most ten lines. The human reads
first.

## Audit mode

```
/michi-second-look audit [scope] [focus]
```

The review asks *did we build what was accepted?* The audit asks *what should change?* — should
dependencies be updated, does the design still hold, is the test suite healthy, are there patterns or
libraries the project should now be using. Different question, same seat: not the builder, no brief,
read-only, run in a scratch copy, evidence per item, dispositions on receipt. `scope` defaults to the
project; a package or directory also works. Milestone scope rarely makes sense here.

The review's pitfall *how you would have built it* does not apply — the audit is invited to say how it
would build it now. Two others take its place, both from `references/principles.md`: **Avoid Premature
Optimization** (a change must be defended, never assumed) and the **black hole of the internet** (the
pull of training-data fashion on defaults). Every recommendation names the problem *in this codebase*
it solves. A recommendation whose only reason is "this is what people do now" is not
a recommendation; leave it out or put it under *Open questions*.

### The bar

There are no acceptance criteria to diff against. The accepted source is the project's **stated design
intent**: `ARCHITECTURE.md`, `PROJECT.md` (constraints especially), `CLAUDE.md` conventions,
`docs/reference/code-style.md` if present — plus Michi's principles. Quote it. Where intent is absent,
stale or contradicts the tree, that is the first finding, and the reading you audit against instead is
labelled *(mine)*, per step 2 of the review.

### Four passes

Say which you ran. Each points at existing material rather than restating it.

1. **Dependencies.** In the scratch copy, install and run the ecosystem's own tools read-only — for
   Node, `npm outdated` and `npm audit` (or the pnpm / yarn equivalents); other stacks have their
   counterparts. Then judge, don't list: for each dependency worth raising, current → latest, the semver
   gap, any advisory, a known breaking change, the runtime or its end-of-life. The output is *which
   updates matter and why*, and which are deliberately left alone.
2. **Architecture and design.** Stated intent against the tree: what has drifted, what has accreted,
   where boundaries leak, what the design cannot express that the work now needs. Then
   `michi-sustainability`'s *Architectural Alignment* and *Code Quality* menus, from this seat.
3. **Test-suite health.** Run it; read the output. Then `michi-sustainability`'s *Test Quality* menu —
   mocks at the wrong boundary, tests asserting on mechanism, obvious uncovered paths — plus what the
   run itself shows: duration, flakiness, skipped or disabled tests, suites that pass without asserting.
4. **Patterns and libraries.** `michi-sustainability`'s *Reuse Audit* signals (hand-rolled parsing,
   duplicated merge/retry/glob logic, verbose I/O wrappers) and the ecosystem's current idioms. Each
   candidate passes the Reuse Audit's own test: net simplification, removes duplication, well-maintained,
   doesn't break the project's patterns or force a public-API change.

### Recommendations, not findings

A recommendation is rated on Michi's own scale, not by severity:

```markdown
## Recommendations
| ID | Area | Recommendation | Effort | Benefit | Evidence | Risk |
|---|---|---|---|---|---|---|
| SL-A1 | deps | … | S / M / L / XL | S / M / L / XL | `path:line` / command + output | … |
```

*An L effort for S benefit is easy to decline; an S effort for L benefit is easy to accept* — the pair
makes the tradeoff visible so the human can decide. **Effort and benefit are the reviewer's estimates;
say so.** The rest of the report contract holds: the header (reviewed, ran, not run, passes used), a
TL;DR that names the one thing to look at first, a *Detail* section per ID, *Examined and judged sound*
— including dependencies and designs looked at and left alone — and *Open questions*. A defect found
along the way (a failing test, a wrong claim) is still a finding with a severity; keep the two tables
separate.

### On receipt

Dispositions as below, with one difference: **accept means *plan it*, not *do it*.** A recommendation is
almost always larger than a fix. An accepted set larger than a workshop goes to `/michi-planning` as a
milestone, with the recommendation IDs named in the plan. Do not carry the recommendations out in the
dispositions pass.

## When the report reaches the builder

This half runs in the **builder's** session, when the human presents the report. It is the part that
keeps a review from being rationalized away.

Every finding gets a **disposition**, written by ID. At milestone scope, into the plan doc under
`## Second-look dispositions`. At epic or project scope, into a sibling file beside the report,
`second-look-dispositions-<YYYY-MM-DD>.md`, so the pair stays together.

- **accept** — the finding stands, **and the disposition names the measurement that confirmed it**:
  the command you ran, the file you opened, the probe you repeated. Reproduce before you accept, not
  only before you contest. A disposition written from the report rather than from the tree is the
  same defect the report is about. The fix is normal work under the session skill, and the finding
  ID is named in the commit or plan step that closes it.
- **contest** — only with evidence: a file, a run, a quoted source the reviewer missed. Reasoning
  alone is not a contest. If the evidence is a claim the reviewer already checked, it is not new.
- **defer** — the human's call, named as such, with the reason.

A finding with no disposition is open. "Noted" is not a disposition. The disposition list is the
artifact that can come back wrong: the human can check it against the report.

## Pitfalls

- **Restating the plan.** A review that repeats the builder's claims in its own words has checked
  nothing. Every "met" needs evidence you produced.
- **Briefing yourself from STATUS.** STATUS and journals are the builder's account. Orient from
  them; verify against the artifact.
- **A verdict wider than the examination.** "Passes" after reading half is a false claim.
- **Fixing.** The moment you edit, you are a second builder with your own drift. Propose; don't apply.
- **Letting focus narrow scope.** A focus hint adds attention. The criteria stay whole.
- **Treating a documented gap as met.** Naming a miss does not close it. It is unmet until the human
  says otherwise.
- **How you would have built it.** Design findings are against the bar, not against your taste.
- **Sure without a source.** *Are you sure? Why?* If the why is a feeling, it is a suspicion, not a
  finding.

## What this is not

Not `michi-pr-prep` (the author writing *for* a reviewer). Not the session's code-review subagent
(launched and briefed by the builder, milestone scope). Not `michi-debrief` (the builder's own
retrospective). Not `michi-sustainability` (the builder's health check; this skill borrows its
checklists — audit mode is that health check asked from outside). Those all run from the builder's
seat. This one doesn't.
