---
name: michi-workshop
description:
  Lightweight Michi discipline for everyday work — bug fixes, small features, quick explorations. Same rigor, less
  ceremony. The EDC of software development.
---

# Michi Workshop

The everyday carry tool. Same discipline as the full michi software factory, less ceremony. Strong on rigor, flexible on process.

**When the pocket Leatherman is enough, don't go to the factory.** Bug fixes, small features, quick investigations,
focused improvements. But know when you've outgrown it — if the work is expanding beyond what you can hold in your head,
escalate to full Michi (planning → session → debrief).

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

### Plan and Agree

Always make a plan. Always get agreement before working. The plan scales to the work:

- **Small:** A few bullets in the conversation. "Here's what I'll do: X, Y, Z."
- **Medium:** A brief written plan saved to a workshop doc.
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
few sentences or bullet points in the workshop doc is fine. But captured, not lost.

### Know When to Escalate

The hardest discipline. Recognize when the EDC isn't enough:

- The scope just expanded beyond what you planned
- You're making decisions that affect things outside this task
- You need verification infrastructure you don't have
- The workshop doc is growing past a page
- You're unsure whether the change is safe

Flag it: "This is getting bigger than workshop — should we switch to a full session?" The human decides.

## Flow

The natural rhythm of small work:

**Orient** — What's the situation? Read the relevant code, understand the context. Investigation is part of workshop —
you don't need a separate explore skill for "let me understand this bug."

**Agree** — State the plan, get agreement. Answer the three verification questions.

**Work** — Implement with TDD. Test as you go. Keep the human informed at natural checkpoints.

**Verify** — Run the full test suite. Demonstrate the fix or feature works. Show nothing broke. Evidence, not assertion.

**Capture** — Write up what happened — it can be short, it might be long. Update STATUS.md if the project state changed.
Quick check as you write: did anything you investigated not land in the writeup? If so, is that intentional? Dropped
source material is the most common capture failure — name it or keep it.

## Output

Default location: `docs/workshop/<topic>.md` — a single compressed doc with plan, results, and learnings in one place.
Not every workshop produces a doc — sometimes the code and commits are the artifact.

But don't rationalize away the importance of capture — err on the side of documentation, not laziness. When the work
warrants fuller documentation, use the standard docs structure. The workshop doesn't constrain where things go — it just
defaults to something lightweight.

### What's Next

If the work stayed small: you're done. If it grew beyond workshop scope, escalate to `/michi-planning` to scope a proper
milestone. If the workshop revealed something worth investigating further, `/michi-explore`.
