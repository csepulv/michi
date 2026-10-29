---
name: michi-away
description: >-
  Switch to Entrusted while the human steps away — keep running the Michi cycle (debrief, planning, session) on a
  best-effort basis, log best guesses and blocks in an away-log, and walk the log together on return.
disable-model-invocation: true
---

# Michi Away

The human is stepping away. Keep making progress without them — **best effort, not best guess dressed as
certainty.** Where you'd normally ask, guess and log. Where you'd normally wait, log the block and move to other
work. When they return, the away-log is the agenda.

This skill is an **overlay**, not a new process. It drives the existing skills — `michi-debrief`,
`michi-planning`, `michi-session` — and swaps their ask-and-wait points for guess-and-log. Everything else in those
skills still applies, including the Iron Law: **no "done" without running full verification.** Away relaxes who
decides, not how the work is checked.

**Principles served:** Minimize latency (progress while the human is away). Surface assumptions (every guess is
written down). Verification governs autonomy (the verification discipline doesn't change). See
`references/principles.md`.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there take
priority over this skill's defaults.

**Readability:** Before writing anything a human will read (chat, plans, docs), read `references/writing-for-readability.md`.

## Entry — before the human leaves

Do this while they're still here. It's the last Paired moment.

1. **Find the epic and the position.** Which epic, which milestone, which step of the cycle (mid-session, session
   done and not debriefed, debriefed and not planned, planned and not started). Read STATUS.md and the plan doc; ask
   if it isn't clear.
2. **Git.** The operator's rules govern branches and commits — CLAUDE.md, settings, permissions. Some operators run
   all git themselves; others let the agent commit. Read the rules. **If they're ambiguous, ask now.** A separate
   branch for away work is recommended; the operator decides which branch, and who creates it.
3. **Create the away-log** at `docs/epics/<epic>/away-log.md` (template below). Quote the human's away instructions
   **verbatim** into `## Instructions`, plus anything else they said about scope or limits.
4. **Confirm and go.** One line back: epic, starting position, git arrangement, log path. Then start.

If the human left before entry was complete, do what you can from the docs, and log every entry gap as a guess.

## The posture swaps

| Where the skill says…                                  | While away…                                                          |
|--------------------------------------------------------|----------------------------------------------------------------------|
| Ask the human / get agreement                          | Make the best guess. Log it in `## Guesses`. Proceed.               |
| Blocked — notify and wait                              | Log it in `## Blocks`. Move to other unblocked work.                |
| Plan agreement (planning)                              | Write the plan; mark it `Drafted while away — not yet agreed`. Log the acceptance as a guess. |
| Human review, trust calibration, promotions (debrief)  | Draft them; mark them `pending review`. Promotions to long-lived docs are guesses — log each. |
| Reactive scope change                                  | Prefer a new milestone over extending the current one (session's Entrusted rule). Log it. |

**Never guessed — always a block:**

- **Contract changes** — public API, schema, a new service type, anything other code or people depend on.
- **North-star trades** — anything that trades a line in the epic's `north-stars.md`.
- **Destructive, irreversible, or leaves-the-machine actions** — deletes, overwrites of the human's work, pushes,
  deploys, sending messages (including Slack).

Log these as blocks with what you'd propose, and move on.

**Guess size.** Log what the human would plausibly decide differently: design choices, scope reads, interpretations
of their words. Don't log implementation details — those go in the plan doc's `## Decisions` as usual.

**Stay inside the epic.** Work the epic you were given. Opening a new epic, or wandering into unrelated fixes, is
scope the human didn't grant — log it as a candidate instead.

## The cycle

Run from the entry position: **session → debrief → planning → session → …**, using each skill as written with the
swaps above.

- **Session:** implement and verify the milestone. Verification is not relaxed.
- **Debrief:** a short debrief is usually enough. Anything that needs the human's judgment is `pending review`.
- **Planning:** plan the next milestone from the epic's spec, roadmap, or STATUS `Next`. If there is no next
  milestone the docs support, that's not a guess to make — there's nothing unblocked left here.

Re-read `north-stars.md` (if the epic has one) at every phase boundary, as the skills already require.

## Stop conditions

Stop when either holds:

- **Something unrecoverable** — the environment is broken, the test suite can't run, the same fix has failed three
  times (Rule of 3).
- **Nothing unblocked is left** — every remaining path goes through a block.

On stop: update `## Position` with why you stopped, write `## Return briefing`, apply the STATUS reflex, and end.
Don't idle-poll.

## Surviving compaction

The away-log is the state. Conversation memory is not.

- **Update `## Position`** at every phase boundary: current phase, milestone, next step.
- **Re-read the whole away-log** at every phase boundary, before logging a guess, and whenever you aren't sure what
  you were doing. If the log and your recollection disagree, the log wins.
- The human's instructions are quoted there verbatim so the rules survive exactly as given.

## Return — lights back on

When the human comes back, stop the cycle and go Paired. Point them at the log, then walk it with them:

1. **Blocks first** — they're waiting on a decision.
2. **Guesses next** — confirm, revise, or revisit. A revised guess may mean rework; name what it touches.
3. **Done** — what was completed and verified, and what's uncommitted (per the operator's git rules).

Record each disposition in the log (`confirmed` / `revised: …` / `revisit`). Then carry on Paired, or return to
the normal skills.

## Away-log template

```markdown
# Away log — <epic>

**Started:** YYYY-MM-DD HH:MM · **Branch:** <branch> · **Git:** <operator's arrangement>

## Instructions
<the human's away instructions, verbatim>

## Position
- **Phase:** session | debrief | planning
- **Milestone:** <mN — plan doc path>
- **Next step:** <one line>

## Return briefing
<written on stop: why stopped, headline counts — N done, N guesses, N blocks — and where to start>

## Blocks
### B1 — <title>
- **Where:** <phase, milestone, file>
- **Why blocked:** <which rule, or what's missing>
- **Proposal:** <what you'd do>
- **Disposition:** <filled in on return>

## Guesses
### G1 — <title>
- **Where:** <phase, milestone, file>
- **Guess:** <what you chose>
- **Alternatives:** <what else>
- **Why:** <reasoning>
- **Reversible:** yes | no — <what it touches if revised>
- **Disposition:** <filled in on return>

## Done
- <milestone / phase> — <what, verified how>
```

## Pitfalls

- **Guessing a block.** Contract changes, north-star trades, and outward or destructive actions are never guesses,
  however confident you are.
- **Relaxing verification.** Away changes who decides, not the Iron Law. Unverified is not done.
- **Silent guesses.** A guess not in the log is an assumption the human can't review.
- **Memory over the log.** After compaction, re-read the log; don't reconstruct from recollection.
- **Scope wandering.** Stay in the epic. Candidates go in the log, not in the work.
