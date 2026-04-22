---
name: michi-explore
description: Structured conversation with Michi discipline — explore ideas, research options, orient in a new space. Like a good interview: follow the thread, notice drift, surface assumptions, capture what matters.
---

# Michi Explore

A structured conversation for investigative work. Not the full planning → session → debrief lifecycle — just Michi
discipline applied to thinking together.

This skill is **flexible**. It's a posture, not a checklist.

**Principles served:** Surface assumptions (the core value). Shared context as foundation (understanding before
decisions). See `references/principles.md`.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there take priority over this skill's defaults.

## When to Use

- **Cold starts** — new session, new project, unfamiliar territory. Orient before deciding what to build.
- **Research** — evaluating options, surveying tools, understanding a codebase area.
- **Brainstorming** — sketching ideas, exploring directions, thinking through tradeoffs.
- **Pre-planning** — you need to explore before you know enough to write a plan.
- **Sidebars** — investigative work that informs epics but isn't an epic.

## Peek Mode

When the argument starts with `peek`, orient first — read, summarize, wait. Don't propose actions or start
investigating. Build shared context, then ask what the human wants to work on.

```
/michi-explore peek              → orient at M level (default)
/michi-explore peek S             → quick orientation
/michi-explore peek L             → deep read of project docs
/michi-explore peek src/api/      → orient on a specific area
/michi-explore peek XL            → full codebase survey
```

**What to read at each level:**

- **S:** STATUS.md and `docs/memory.md` — enough to not be a stranger
- **M:** Project docs (STATUS.md, PROJECT.md, CLAUDE.md, current plan docs, memory.md) — enough to work on the
  active thing
- **L:** Project docs + relevant codebase area or epic in depth — enough to contribute to a technical discussion
- **XL:** Full codebase survey — bootstrap-level understanding

When a specific pointer is given (a file path, folder, or topic), read that area and orient on it regardless of
level. The pointer replaces the default reading list — it's the human saying "point the flashlight here."

After reading, summarize what you understand — project state, active work, key patterns, relevant context. Then
stop and ask what the human wants to work on.

## Opening

When not in peek mode, start like a good interview — establish direction without over-structuring.

Either side can drive. The human might arrive with a question ("how does auth work in this codebase?") or the agent
might open with one:

- **"What are you hoping to take away from this?"** — what would make this time well spent?
- **"Do you have an agenda, or should we find one?"** — some explorations have a direction; others discover it.
- **"Where should we capture this?"** — suggest `docs/sidebars/<topic>.md` as default. Could also be a journal entry, a
  section in an existing doc, or just shared understanding.
- **Read `docs/memory.md` if it exists.** Collaboration context — how we work together, active threads, landmarks.
  Internalize it, don't just scan it.

If the direction is clear, start moving. If not, the first few exchanges will reveal it.

## The Conversation

No prescribed loop. Follow the thread wherever it leads. But maintain Michi discipline throughout — that's what separates
an exploration from a chat.

Explorations alternate between **dialogue** and **investigation**. Sometimes you're talking — brainstorming, asking
questions, thinking together. Sometimes the agent goes heads-down — reading files, analyzing code, building a
comparison, researching — and returns with findings. Both are part of the same conversation. The discipline applies to
both:

- Before investigating: state what you're looking for and what you're assuming.
- When returning: checkpoint — present findings, check if the direction is still right.
- If the investigation changed the question, say so before diving back in.

### Surface Assumptions

The single most valuable thing this skill does. As the conversation progresses:

- State assumptions explicitly: "I'm assuming X because Y."
- When an assumption is validated or invalidated, say so.
- Watch for the human's unstated assumptions too — name them gently.

### Notice Drift

A good interviewer tracks where the conversation started and where it is now. When the thread veers:

- **Name it:** "We started on X but we're now in Y."
- **Don't force it back.** The drift might be the discovery. But make it visible so the human can decide: follow the new
  thread, or return?
- **If the conversation is going in circles** — same ground, no new insight — say so. Suggest a different angle or ask
  what's missing.

### Capture Decisions

When a choice point emerges and a direction is taken, note it briefly:

- What was decided
- What alternatives existed
- Why this direction

Lighter than michi-session's full decision template. But captured, not lost.

### Flag Questions

Two kinds:

- **Prerequisite:** need an answer to continue. Ask.
- **Discovery:** emerged during exploration, belongs in the output. Note them — often the most valuable part.

## Wrapping Up

### Capture the Artifact

Write findings to the agreed location. Structure follows what emerged — don't force a template:

- **Evaluation:** options compared, recommendation, tradeoffs
- **Research:** findings by theme, open questions flagged
- **Exploration:** what was discovered, what it means, what's next
- **Brainstorm:** ideas generated, promising directions, initial assessment

**Inputs-vs-outputs check.** If substantial source material was read during exploration (multiple docs, a codebase
area, a stack of reference files), verify each significant source is reflected somewhere in the artifact — even if just
as a pointer. A thin artifact after heavy reading is a signal that something was dropped. Use the inputs as a checklist.

### Not Ready is a Valid Outcome

Exploration can conclude "not ready" — the work needs more investigation before a direction is clear, or a user
decision is needed before synthesis makes sense. Don't force a produced artifact when the honest answer is "we found
the shape of the question, not the answer." Name the gap, flag what would unblock it, and stop. That's a valid
outcome — sometimes the most valuable one.

### Mini-Reflection

Brief, built-in — not a separate debrief:

- **What did we learn?** — the key insight, in a sentence.
- **Decisions to capture?** — anything affecting future work, ensure it's in the artifact or journal.
- **Anything for memory?** — collaboration patterns, corrections, context that would help a future session.
- **What's next?** — does this feed into planning? Another exploration? Nothing yet?

### Update STATUS.md if warranted

If the exploration changes what's active, next, or understood about the project.

### What's Next

If the exploration produced a clear direction for implementation, the natural next step is `/michi-planning` to scope a
milestone. If there's more to investigate, another `/michi-explore` session. If the work is small and self-contained,
`/michi-workshop` may be enough. See `references/michi-skill-guide.md` for the full map.
