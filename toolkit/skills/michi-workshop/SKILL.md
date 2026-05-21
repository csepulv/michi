---
name: michi-workshop
description:
  Lightweight Michi discipline for everyday work — bug fixes, small features, quick explorations. Same rigor, less
  ceremony. The EDC of software development.
---

# Michi Workshop

The everyday carry tool. Same discipline as the full michi software factory, less ceremony. Strong on rigor, flexible on process.

**Workshop holds "what does done mean" and "how to build it" in one head.** Planning + session deliberately separates
those modes — defining requirements and verification first, then implementing. Use workshop when that separation
isn't earning its weight; escalate when it is. Size correlates (smaller work usually doesn't need the split) but
isn't the criterion. Risk is a separate axis, handled inside workshop via *Mind the Complexity and Uncertainty*
(see below).

Bug fixes, small features, quick investigations, focused improvements — these are workshop's natural shape.
**When the pocket Leatherman is enough, don't go to the factory.**

**This skill encodes the questions Michi asks, not the artifacts Michi produces.** Artifacts emerge when the work demands
them.

**Principles served:** See `references/principles.md`. The workshop internalizes these — especially surface assumptions,
verification governs autonomy, and sustain the system.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there take priority over this skill's defaults.

## The Disciplines

These always apply. They're what makes this Michi and not just winging it.

### Surface Assumptions

Before acting, say what you're assuming. During work, name new assumptions as they appear. When you're wrong, say so.
This is the single most valuable habit — it catches bugs before they're written. Watch especially for assumptions
about *scope* — "they probably also want X" or "while I'm in here, I'll fix Y" is the *impulse to help* pull
(see *Clarify before Asserting* in `references/principles.md`), not service. Surface scope expansion as a question.

### Mind the Complexity and Uncertainty

Workshop is about ceremony, not risk. The same Complexity/Uncertainty axis from *Two Modes of
Practice* (see `references/principles.md`) applies — but here it shapes pacing and pairing
*within* workshop, not whether to use workshop at all. **Don't confuse *small* with *safe*.**

**Signals that this workshop is High C/U:**

- Tightly-constrained brownfield code where existing conventions must be preserved
- A named code pattern (adapter, strategy, façade, ...) whose interpretation could be ambiguous
- First time the agent has worked in this codebase or subsystem
- Small change to load-bearing logic

**When High C/U:** keep workshop ceremony, but tighten the posture — shorter turns, more frequent
checkpoints, Crawl/Walk pacing, explicit surfacing of interpretation choices. The artifact stays
small; the discipline tightens.

**When Mixed C/U:** confirm pacing with the user before defaulting to Run.

### Plan and Agree

Always make a plan. Always get agreement before working. The plan scales to the work:

- **Small:** A few bullets in the conversation. "Here's what I'll do: X, Y, Z."
- **Medium:** A brief written plan saved alongside the work — a flat-file epic (`docs/epics/<topic>.md`), the
  active epic's plan dir, or a journal entry.
- **Large:** If you need a formal plan doc with exit criteria and verification scenarios — you need the full factory,
  not the workshop.

### Verify Before Claiming Done

Three questions, answered before you start working — not after:

1. **How will you know when you're done?** Definition of done — concrete, not vibes.
2. **How can you verify you're done?** What to check, what to run, what to test.
3. **How will you demonstrate that it works and nothing broke?** Regressions matter. The whole test suite matters.

Then: use TDD. Run the full automated test suite. Add tests where needed. Flag new scenarios that emerged. The tests
aren't paperwork — they're the verification.

### Capture Decisions

When a choice is made, note what was decided, what the alternatives were, and why. Doesn't need a formal template — a
few sentences or bullet points in the doc you're keeping (journal entry or epic doc) is fine. But captured,
not lost.

### Know When to Surface (the Human Decides)

Sometimes work grows in ways where the planning + session split would help — separating "what is done" from "how to
build it" deserves its own pass. Signals worth *surfacing* (not triaging unilaterally):

- The scope just expanded — and the new shape would benefit from an explicit contract on what's done
- Decisions are landing that affect things outside this task
- Verification infrastructure is calling for explicit design (scenarios, test plans, fixtures)
- The two modes ("what does done mean" and "how to build it") are getting tangled

Mention what you're seeing; the human decides. **Don't argue if the human says "stay in workshop."** They have
context the agent doesn't — and the framework is for their use, not for the agent to apply against their choice.

(For risk inside workshop — High C/U pacing — see *Mind the Complexity and Uncertainty* above; ceremony scaling
is separate from risk.)

## Bug-Fix Mode

When invoked as `/michi-workshop bugfix <description>` or `/michi-workshop bug <description>`, adopt a leaner posture
appropriate to bug fixes:

- **Diagnose first.** Reproduce the bug before fixing. Understand the root cause, not just the symptom. Resist the
  urge to also "fix surrounding things you noticed" — bug-fix mode means *this bug*, not a refactor.
- **Verify with a regression test.** The reproduction case becomes the test. The full suite still runs before
  declaring done.
- **Light docs by default.** A `docs/journal.md` entry is usually enough — date, what broke, root cause, fix in one
  line, regression test added. **Confirm with the user** if uncertain whether more is warranted (a flat-file epic,
  an epic-journal entry, or a pattern in `docs/reference/patterns.md`). When in doubt, ask.
- **Escalate if it stops being a bug fix.** Scope creep ("while I'm in here…") is the failure mode. If the diagnosis
  reveals the fix needs explicit design discussion or touches multiple subsystems, surface that and offer to switch to
  a full session.

The disciplines (Surface Assumptions, Mind the Complexity and Uncertainty, Plan and Agree, Verify Before Claiming
Done, Capture Decisions, Know When to Escalate) all still apply. Bug-fix mode adjusts the *output ceremony*, not the
*process rigor*.

## Flow

The natural rhythm of small work:

**Orient** — What's the situation? Read the relevant code, understand the context. Investigation is part of workshop —
you don't need a separate explore skill for "let me understand this bug."

**Agree** — State the plan, get agreement. Answer the three verification questions.

**Work** — Implement with TDD. Test as you go. Keep the human informed at natural checkpoints.

**Verify** — Run the full test suite. Demonstrate the fix or feature works. Show nothing broke. Evidence, not assertion.

**Capture** — Write up what happened — it can be short, it might be long. Quick check as you write: did anything you
investigated not land in the writeup? If so, is that intentional? Dropped source material is the most common capture
failure — name it or keep it.

### Update STATUS.md (and journal)

If this workshop produced any artifact, commit, or decision that affects what's active, what's next, or what just
shipped, update STATUS.md before closing out — and the active epic's `journal.md` if you wrote to it.

**Read STATUS.md cold** — re-open the file and read each line against current reality, not against your in-context
recollection. Edit anything stale. Update the `**Last updated:** YYYY-MM-DD` stamp at the top.

Not "if anything significant changed" — the reflex is read-cold-and-update. See `references/ground-rules.md` for the
freshness contract on root docs.

## Output

Workshop work doesn't get its own document tier. It rolls up based on scope:

- **Inside an active epic:** the epic's `journal.md` for learnings; `plans/<plan>.md` if the work is a discrete
  milestone-sized step.
- **Substantive workshop with standalone design decisions:** an epic — flat file `docs/epics/<topic>.md`, grows
  to a subdirectory if it earns one. Same structure as any other epic — decisions, alternatives considered, what
  shipped, open follow-ups.
- **Bug fixes and small workshops:** a `docs/journal.md` entry is enough (see Bug-Fix Mode above).
- **Sometimes the code and commits are the whole artifact.** A typo fix, a one-line bug, a renamed variable — capture
  may be the commit message itself.

There's no `docs/workshop/` directory. If you find yourself reaching for one, the work belongs in an epic
(use `/michi-planning` to scope it out) or already fits inside an existing one.

Don't rationalize away the importance of capture — err on the side of documentation, not laziness. But match the
artifact to the work: an epic for substantive workshops, a journal entry for small ones, nothing for trivial fixes
beyond the commit.

### What's Next

If the work stayed small: you're done. If it grew beyond workshop scope, escalate to `/michi-planning` to scope a proper
milestone. If the workshop revealed something worth investigating further, `/michi-explore`.
