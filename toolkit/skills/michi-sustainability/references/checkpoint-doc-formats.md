# Checkpoint Doc Formats

Optional structured formats for checkpoint documentation — assessment artifacts, readiness reports, operational
guides. Use when a milestone-end review, epic closeout, or handoff warrants more structure than a free-form
debrief or journal entry.

**These are patterns, not mandates.** Michi's default doc homes (journals, debriefs, plan docs, reference docs) are
defined in `docs-structure.md`. This file adds three structural formats that have proved useful when the default
formats feel too loose for the job — typically at epic boundaries, when preparing artifacts for a broader audience,
or when the review needs to drive a concrete gap list.

Adapt each format to the work. Drop sections that don't apply. Add ones that do. The value is the structural
discipline, not the template.

---

## Readiness Checklist

**When to use.** End of an epic, pre-handoff, pre-deploy, or any moment you need an honest answer to "what's
ready and what's not." A forcing function for gap visibility.

**Why it earns its place.** Free-form status text lets "mostly done" items hide in narrative. The checklist forces
each item into one of three states, and "Needs work" forces notes on what's missing.

```
# [Scope] — Readiness Checklist

Status: **[Overall assessment — one sentence]**

## Legend
- **Ready** — Working, tested, no changes needed
- **Needs work** — Functional but has known gaps (notes required)
- **Not started** — No work done (priority signal required)

## [Domain 1]
| Item | Status | Notes |
|------|--------|-------|
| ... | Ready | - |
| ... | Needs work | Missing error handling on X; reconnect logic flaky under Y |
| ... | Not started | Priority: high (blocks deploy) |

## [Domain 2]
...
```

**Discipline:**

- "Ready" means genuinely ready — not "works on my machine," not "tested locally once"
- "Needs work" items must have notes on what's missing
- "Not started" items must have a priority signal — blocking, high, nice-to-have
- Domains vary by project: infrastructure, application, security, observability, operations, docs, etc.

---

## Assessment Doc

**When to use.** When an epic or milestone warrants a category-by-category review — what changed, why, and what
tradeoffs were accepted. Typically written after the work is done but before the epic is archived. Pairs well with a
Readiness Checklist.

**Why it earns its place.** A debrief captures process; an assessment captures *state*. The category tables make the
tradeoffs legible to someone who wasn't in the session.

```
# [Scope] — Assessment

[One-line context: when/why this assessment was conducted, who asked, what's in scope]

## [Category 1 — e.g., Product code changes]

### What Changed
| Change | Location | Why |
|--------|----------|-----|
| Added rate limiting middleware | src/api/middleware/ | Traffic spike revealed the need |
| ... | ... | ... |

### Decisions
| Decision | Rationale |
|----------|-----------|
| Used token bucket, not sliding window | Simpler, sufficient for current load |
| ... | ... |

### Tradeoffs
[Paragraph explaining the tradeoff and why it's acceptable — or not.]

## [Category 2]
...
```

**Discipline:**

- Every decision gets a rationale. "We chose X" without "because Y" is incomplete.
- Tradeoffs are not failures — naming them explicitly is how you signal the intent was deliberate.
- Skip sections that don't apply within a category. Use "What Changed" + "Decisions" + "Tradeoffs" as a menu,
  not a required triplet.

---

## Operational Guide

**When to use.** When a checkpoint reveals operational knowledge that's currently only in someone's head —
deployment steps, incident response, environment setup, a tricky command sequence. Captures it before it's lost.

**Why it earns its place.** "It works if you do X, Y, Z" written in a Slack thread evaporates. The guide makes it
searchable and survivable.

```
# [Topic] Guide

[One-line context — what this is for, when to use it]

## Prerequisites
1. [Numbered list of what must be in place before starting]
2. ...

## [Step-by-step sections]
1. Command: `...`
   Expected output: ...
   Common variations: ...

## Troubleshooting
| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| ... | ... | ... |

## Verification
- How to confirm it worked
- What "done" looks like
```

**Discipline:**

- Include expected output — the "did it work?" signal
- Troubleshooting entries pay for themselves the first time they save a debugging loop
- Verification is separate from "the last command succeeded" — they're often not the same thing

---

## Usage notes

- Checkpoint docs aren't a required artifact type. Most sessions close out with a debrief + journal entry and that's
  enough. Reach for these formats when the default formats feel too loose for what the work produced.
- Location: put checkpoint docs where the work lives. Epic-scoped readiness and assessment → `docs/epics/<epic>/`.
  Project-scoped operational guides → `docs/reference/` (they outlive epics). Epic-scoped operational guides that
  apply broadly can be promoted to `docs/reference/` during debrief.
- Pair with other Michi artifacts — an assessment doc paired with a debrief gives the same session two lenses
  (process + state). Both have value; neither replaces the other.
