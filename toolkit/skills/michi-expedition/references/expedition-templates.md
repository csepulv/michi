# Expedition Templates

Worked skeletons for the artifacts `michi-expedition` produces. Copy and fill; these show *shape*, not required
content — adapt to the substrate. Capitalization, currency stamps, and homes follow `expedition-structure.md`.

---

## `charter.md` — a mission (charter mode)

The `portraits/<subject>/` it links to is named for the picture it builds; a charter can feed several portraits, and a
portrait can be fed by several charters.

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
**Picture:** <the portrait(s) this run feeds>
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

## The portrait library (review mode)

The portraits are read as a library: `portraits/tldr.md`, `glossary.md`, `contributor-guide.md`, and per portrait
`portrait.md`, `appendix.md`, `open.md` (who reads what: `expedition-structure.md`, *The portrait library*). Living
files are linked, not copied. A section with nothing true to say is left out, not padded.

### `portraits/tldr.md` — the landing (everyone)

```markdown
# <Expedition>: start here

<One paragraph: what the expedition studies, why, and what kind of picture it is building.>

## Where it stands

- **<portrait>:** <what it covers> — <how settled: early / taking shape / settled>, updated YYYY-MM-DD
- ...

Current state of the work: [STATUS.md](../STATUS.md).

## Where to go next

- **Reviewers,** to see what has been learned: pick a portrait above.
- **Contributors,** to pick the work up: the [contributor guide](contributor-guide.md).
- Terms: the [glossary](glossary.md).
```

### `portraits/glossary.md` — terms (everyone)

```markdown
# Glossary

## How the expedition works
- **Rung** — how far a claim goes: read → correlate → infer → hypothesize.
- **Confidence** — high / medium / low, with what it rests on.
- **Charter**, **campaign**, **portrait**, **mandate** — <one line each>.

## The subject
- **<term>** — <meaning>, from <charter's target vocabulary>.
```

### `portraits/contributor-guide.md` — picking the work up (contributors)

```markdown
# Contributor guide

## Where it stands
<Two or three sentences; then link STATUS.md for the per-charter state.>

## What's open
- Open questions by portrait: <links to each open.md>
- Still murky: [ruminations](../ruminations.md)
- Actionable, top of the queue: <the 3–5 priority-1 items of backlog.yaml, one line each> — [all](../backlog.yaml)

## Recent campaigns
<The last three rows of the log, one line each, as of writing; not refreshed by review>

Complete log, newest first: [iteration log](../iteration-log.md).

## The charters
- **<charter>** — <what it pursues>; feeds <portraits>. [charter](../charters/<charter>/charter.md)

## Running the next campaign
`/michi-expedition campaign <charter>`, then `run`, then `review` (the `michi-expedition` skill).
```

### `portraits/<subject>/portrait.md` — the picture (reviewers)

```markdown
# Portrait: <subject>

**Last updated:** YYYY-MM-DD

<Two or three sentences: what this picture is of, and where it stands — how settled, what it rests on.>

## <dimension from the charter's target vocabulary>
- <finding, one line> — [rung, confidence] ([details](appendix.md#<anchor>))

## <dimension>
(nothing promoted yet)

## What we can't see (yet)
- <promotable negative — what the data does NOT support> ([details](appendix.md#<anchor>))
```

Findings stay one line each; evidence goes to the appendix. The opening is rewritten, not appended to, when the
picture changes.

### `portraits/<subject>/appendix.md` — the details (reviewers, contributors)

```markdown
# <subject>: details

## <finding, short>
- **Claim:** <the finding> — [rung, confidence]
- **Evidence:** <what was run, what was seen, what it rests on>
- **Reports:** <links>   **Figures:** <links or embeds>
```

One entry per finding, in the portrait's order, so each portrait line links to its entry.

### `portraits/<subject>/open.md` — what's open for this picture (contributors)

```markdown
# <subject>: what's open

## Open questions
1. <question> — <why it matters to the picture>

## In the backlog
- <id> <title> — <status>

## Next
<What the next campaign on this picture should take up, and why.>

## Campaign history
<Generated from iteration-log.md rows whose portrait is <subject>, newest first. Re-drawn on each build; not edited.>
```

### `iteration-log.md` row — the listing

```markdown
| date | charter | portrait | mode | pass (what it asked) | report | promoted | human verdict | next |
|---|---|---|---|---|---|---|---|---|
| YYYY-MM-DD | <charter> | <portrait> | Paired / Entrusted | <the question> | [<slug>](<path>) | <what entered the portrait, or "nothing"> | <the human's> | <next move> |
```

Newest row first. The verdict column is the human's.

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
