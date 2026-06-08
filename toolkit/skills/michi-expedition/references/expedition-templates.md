# Expedition Templates

Worked skeletons for the artifacts `michi-expedition` produces. Copy and fill; these show *shape*, not required
content — adapt to the substrate. Capitalization, currency stamps, and homes follow `expedition-structure.md`.

---

## `charter.md` — a mission (charter mode)

```markdown
# Charter: <Mission Name>

**Last updated:** YYYY-MM-DD
**Status:** active | paused | dormant
**Portrait:** ../../portraits/<subject>/portrait.md

## Mission
<What this thread is about and why. One paragraph. This is learning work — the
answer isn't known in advance; we spiral toward it.>

## Scope
IN:
  - <what's in>
OUT (for now):
  - <what's explicitly out — and why>

## Target vocabulary
<The labels / questions the expedition tries to establish. Each carries a
confidence rung when asserted (read → correlate → infer → hypothesize). This
vocabulary is itself a hypothesis — revise the charter as the work teaches
better labels. Substrate-specific vocabulary may live in extensions.md.>
  - <label-or-question>
  - ...

## Gates-to-set (a campaign fixes these at activation)
  - Budget — passes / time / breadth
  - Substrate scope — which partition(s) / window / source set
  - Surfacing — what state means "stop and bring it back"
  - Verification — what a claim must pass before it promotes

## Assumptions (surfaced, not buried)
  A1. <assumption> — <VERIFIED | UNVERIFIED; what breaks if false>
```

---

## `mandate.md` — a campaign's contract (campaign mode)

```markdown
# Mandate — <charter>, YYYYMMDD

**Last updated:** YYYY-MM-DD
**Charter:** <charter-name>
**Care posture:** crawl | walk | run   (how much care the next steps deserve — not a gate)

## Scope
<This campaign's slice — right-sized. A plan SKETCH, not a rigid plan.>
Thread sketch (not a checklist):
  T1. <thread>
  T2. <thread>
Explicitly NOT this campaign: <what you're deferring to later campaigns>

## Budget   (bound the open-endedness from outside)
  - <N passes; Rule-of-3 within any single thread>
  - <time / session bound>
  - <breadth cap — which partitions/sources this run may touch>

## When to stop (surfacing criteria)
Stop and bring it back when ANY of:
  - <nominal done: each thread has a report>, OR
  - <a thread hits 3 dry passes>, OR
  - <budget reached>, OR
  - <a finding redirects the effort — surface immediately>

## Finding-verification (before a claim promotes to the portrait)
  - rung label on every claim (read → correlate → infer → hypothesize)
  - <read-rung facts: promote on a clean re-run>
  - <correlate/infer: require corroboration / a null model before promoting>
  - <any surprise/negative: re-check the field/query before recording>
```

---

## `reports/<slug>.md` — one pass (run mode)

```markdown
# Report: <thread> — <short title>

- **Activity id:** <backlog id / thread id>, pass N
- **Care posture:** crawl-leaning | walk | run
- **Date:** YYYY-MM-DD
- **Scope:** <partition / window / sample sizes; the read path>

## Hypothesis & framing
> **Hypothesis:** <what you expect / are testing>
> **Framing:** <what this pass actually does, and why this thread now>

## What was seen
<Facts, each tagged with its rung and confidence. Facts before conclusions.>
  - [read] <fact> — confidence: high
  - [correlate] <fact> — confidence: medium (corroborated by ...)
  - [infer] <claim> — confidence: low (alternatives not yet ruled out)

## Line-check (within / near / can't-see)
<Did this pass stay within its care posture? What did you deliberately NOT do
(the next rung)? What can the data not show here? Note any judgment calls.>
<If human-adjacent: note any inference that approached the charter's ethics
boundary — surfaced, not recorded.>

## Open questions
1. <question for review / next spiral>

## Follow-ups → backlog
  - <thread to add to backlog.yaml, with type + a one-line summary>
  - <reference/ promotion, only if it's proven worth memorializing>
```

---

## `portrait.md` — the accreting picture (review mode)

```markdown
# Portrait: <subject>

**Last updated:** YYYY-MM-DD

> The best-current picture. Starts as a blank canvas; campaigns add blobs,
> review promotes verified findings, the picture sharpens (→ photograph).
> Each claim keeps its rung + confidence + a link to the report that earned it.

## <dimension from the charter's target vocabulary>
- [rung, confidence] <promoted finding> — <report link>

## <dimension>
(nothing promoted yet)

## What we can't see (yet)
<Promotable negatives — what the data does NOT support, and why. As real as
the positives; keeps the picture honest.>
```

---

## `backlog.yaml` — the living work queue

A flat, charter-tagged queue the agent appends/updates each pass; the human reviews. Reports link back by `id`.

```yaml
# status:   idea | queued | active | blocked | done | parked
# type:     <project-specific; e.g. characterize | identity | behavior | method | question>
# priority: 1 (next) .. 5 (someday)
meta:
  updated: YYYY-MM-DD
items:
  - id: <short-id>            # e.g. C1, CH2 — reports reference this
    title: <one line>
    type: <see header>
    status: idea
    priority: 1
    created: YYYY-MM-DD
    updated: YYYY-MM-DD
    notes: >
      <what it is; on completion, a one-line result summary>
    links: [<report path(s)>]
```

The `type` vocabulary is substrate-specific — define the allowed types for the project (in `extensions.md` or the
charter), don't hardcode them here.
