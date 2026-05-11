---
name: michi-workshop
description:
  Lightweight Michi discipline for everyday work — bug fixes, small features, quick explorations. Same rigor, less
  ceremony. The EDC of software development.
---

# Michi Workshop

The everyday carry tool. Same discipline as the full michi software factory, less ceremony. Strong on rigor, flexible on process.

**When the pocket Leatherman is enough, don't go to the factory.** Bug fixes, small features, quick investigations,
focused improvements. Escalate to full Michi (planning → session → debrief) when **the ceremony needs to scale up** —
not when the work feels risky. Risk is handled inside workshop via *Mind the Complexity and Uncertainty* (see below).

**This skill encodes the questions Michi asks, not the artifacts Michi produces.** Artifacts emerge when the work demands
them.

**Principles served:** See `references/principles.md`. The workshop internalizes these — especially surface assumptions,
verification governs autonomy, and sustain the system.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there take priority over this skill's defaults.

## The Disciplines

These always apply. They're what makes this Michi and not just winging it.

### Surface Assumptions

Before acting, say what you're assuming. During work, name new assumptions as they appear. When you're wrong, say so.
This is the single most valuable habit — it catches bugs before they're written.

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
- **Medium:** A brief written plan saved alongside the work — a sidebar (`docs/sidebars/<topic>.md`), the active
  epic's plan dir, or a journal entry.
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
few sentences or bullet points in the doc you're keeping (sidebar, journal entry, or epic plan) is fine. But captured,
not lost.

### Know When to Escalate

The hardest discipline. Recognize when **the ceremony level needs to scale up** — this is about ceremony,
not about risk. (For risk, see *Mind the Complexity and Uncertainty* above.)

Signals that workshop ceremony is insufficient:

- The scope just expanded beyond what you planned
- You're making decisions that affect things outside this task
- The work needs an explicit contract with the human about scope, acceptance, or deliverables
- You need verification infrastructure that requires explicit design (scenarios, test plans, fixtures)
- The workshop doc is growing past a page

Flag it: "This is getting bigger than workshop — should we switch to a full session?" The human decides.

## Bug-Fix Mode

When invoked as `/michi-workshop bugfix <description>` or `/michi-workshop bug <description>`, adopt a leaner posture
appropriate to bug fixes:

- **Diagnose first.** Reproduce the bug before fixing. Understand the root cause, not just the symptom. Resist the
  urge to also "fix surrounding things you noticed" — bug-fix mode means *this bug*, not a refactor.
- **Verify with a regression test.** The reproduction case becomes the test. The full suite still runs before
  declaring done.
- **Light docs by default.** A `docs/journal.md` entry is usually enough — date, what broke, root cause, fix in one
  line, regression test added. **Confirm with the user** if uncertain whether more is warranted (a sidebar, an
  epic-journal entry, or a pattern in `docs/reference/patterns.md`). When in doubt, ask.
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

Workshop work doesn't get its own document tier. It rolls up into the existing structure based on scope:

- **Inside an active epic:** the epic's `journal.md` for learnings; `plans/<plan>.md` if the work is a discrete
  milestone-sized step; `sidebars/<topic>.md` for research that emerged inside the epic.
- **Standalone workshop with substantive design decisions:** a sidebar — `docs/sidebars/<topic>.md` — same shape as
  any other sidebar. Decisions, alternatives considered, what shipped, open follow-ups.
- **Bug fixes and small workshops:** a `docs/journal.md` entry is enough (see Bug-Fix Mode above).
- **Sometimes the code and commits are the whole artifact.** A typo fix, a one-line bug, a renamed variable — capture
  may be the commit message itself.

There's no `docs/workshop/` directory. If you find yourself reaching for one, either the work belongs in an epic
(escalate via `/michi-planning`) or it belongs as a sidebar.

Don't rationalize away the importance of capture — err on the side of documentation, not laziness. But match the
artifact to the work: a sidebar for substantive workshops, a journal entry for small ones, nothing for trivial fixes
beyond the commit.

### What's Next

If the work stayed small: you're done. If it grew beyond workshop scope, escalate to `/michi-planning` to scope a proper
milestone. If the workshop revealed something worth investigating further, `/michi-explore`.
