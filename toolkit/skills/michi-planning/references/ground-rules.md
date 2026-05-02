# Ground Rules: Reading Project Docs

**Last updated:** 2026-05-01

Reference for how to read project documentation. Loaded by Michi skills alongside `principles.md`. Where principles
shape *how to work*, ground rules shape *how to read what's written down*.

Docs save you the cost of re-discovering what someone already worked out — that's their value. They are not
single-source-of-truth; they are starting points with verification cost varying by signal. Most of the time they're
current. Sometimes they aren't. The skill is calibrating, not panicking.

---

## The Default Posture

Read docs as authoritative for what they cover, with two reflexes:

1. **Notice signals before citing.** A `Last updated:` stamp from six months ago in a recently-changed area = starting
   hypothesis. A recent stamp, or a doc kept current by reflex (STATUS.md), = trust.
2. **Ground claims that matter.** When the answer would change behavior — a design decision, an interface contract,
   what's deployed — verify against current code or state. When it's orientation only, don't over-verify.

The pattern worth guarding against has a specific shape: *an authoritative-sounding doc making a specific claim about
something that's changed since the doc was written, and the agent acting on the claim without checking.* Guard that
one; relax on the rest. If you find yourself verifying everything, you've over-corrected.

---

## Per-Doc Guidelines

Each root doc has a different shape, freshness contract, and trust calibration. Knowing them up front beats re-deriving
on each read.

### STATUS.md — Living pulse

Current project state. **Updated by reflex** on every session that changes the active picture. The `Last updated:` stamp
at the top is the truth signal. Trust it for "what's happening now." If the stamp is older than the latest commit on
`main`, fill the gap with `git log` — the doc is behind reality.

### CLAUDE.md — Standing rules

Conventions, agent rules, gotchas the agent should always know. **Durable rules only — not a journal.** Treat as binding
for what it covers. If a rule references a file path, tool, or skill that doesn't exist, it's rotted past the underlying
change; surface it.

### PROJECT.md — The why

Goals, users, key features, success criteria. **Non-volatile.** Use it to understand intent, not implementation detail.
If scope or success criteria conflict with what's actively being built, surface the conflict.

### ARCHITECTURE.md — Best-efforts map

Design overview — components, relationships, data flow. **Best-efforts guide. Incomplete by design.** Any non-trivial
project has more architecture than fits one document, and any document moves slower than the code beneath it. Use it
to orient and form hypotheses. **Verify specifics against the code before relying on them for design decisions.** Read
section-level `last-verified:` stamps where present — older stamps in changed areas mean ground first.

This is the doc most likely to lure confident wrong action. The risk isn't that it lies — it's that it sounds
authoritative in areas that have moved on. Read it, but ground anything load-bearing.

### journal.md — Append-only record

What happened, when, what was learned. Domain gotchas, open questions, discussion items. **Per-entry timestamps; the
doc as a whole is never "current," it's a history.** Recent entries reflect current thinking; older entries may have
been superseded. Don't read it as "this is how things are now" — read it as "this is how things were when written."

### memory.md — Working-together layer

How we work together, active threads, landmarks. **Calibration data, not project state.** Internalize at session start
to anticipate preferences and avoid corrections the human has already made. Landmarks that name files or functions are
frozen claims — verify before acting on them. Active threads decay fast; if project state contradicts an active thread,
project state wins.

---

## Stamp Conventions

Two stamp types:

- **`**Last updated:** YYYY-MM-DD`** at the top of the doc — STATUS.md and the active epic's journal.md. Edited on every
  change. Required.
- **`last-verified: YYYY-MM-DD`** per section — ARCHITECTURE.md and other long-lived reference docs. Stamp the section
  you edited; read the stamp before citing the section.

A stamp doesn't make a doc correct. It tells you the cost of trusting it cheaply: recent stamp = low verification
cost; old stamp in a fast-moving area = verify before acting; no stamp = the doc's default freshness contract above.

---

## What This Is Not

A license for paralysis. The reflexes here are calibration, not anxiety. Most reads don't need verification. There is
*one specific failure shape* worth guarding against — confident citation of an authoritative-sounding doc on a topic
that's changed. Guard that. Relax on everything else.
