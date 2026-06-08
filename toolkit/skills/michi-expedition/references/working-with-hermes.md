# Working with Hermes (and other agent harnesses)

Michi grew up inside **Claude Code**, which injects a lot for free: it auto-loads `CLAUDE.md` and your global rules,
carries your working preferences and the iteration cycle into every session, discovers skills, and lets you interrupt
the agent mid-turn. The agent starts already *shaped* — and much of Michi's discipline rides in on that scaffolding.

A **different harness does not provide that scaffolding.** Hermes — a long-running ("daemon-mode") container agent
reachable over a chat transport — is the worked example here, but the gap is the same for any non-Claude-Code harness:
the model is the same, the *scaffolding* is missing. Two differences matter most:

1. **There's an empty character slot.** No `CLAUDE.md`, no global rules, no auto-loaded principles. Nothing tells the
   agent *how to work* — the Michi way, your register, the Paired/Entrusted discipline — unless you put it there.
2. **You often can't interrupt a turn in flight.** On a chat transport (Discord, Slack, SMS) the human's messages
   *queue* until the agent's turn ends. The agent's own frequent, short yields become the human's only mid-task
   steering lever — so the synchronous-review discipline stops being a nicety and becomes load-bearing.

This is why a Michi agent on Hermes can feel like it's "outrunning" you even when the model is identical: the
correction machinery Claude Code provides for free — mid-turn interrupt, always-loaded character — isn't there. The fix
is to supply the character up front, so correction shifts from *wrangling* to *refinement*.

## The SOUL file

`soul-template.md` (next to this doc) is that character slot, externalized. It's a principles-tier identity file —
North Stars, the iteration cycle, Paired/Entrusted (including the *"let's" = synchronous, yield-the-turn* rule),
Clarify-before-Asserting, the impulse-control gate, Rule of 3, Essential/Incidental/Noise, progressive disclosure,
verification-governs-autonomy, and the working register. It is identity-framed ("You are **{{NAME}}** — a Michi
agent…") rather than rule-framed, because a backbone the agent *is* survives better than a checklist it's told to
follow.

**Install (Hermes):**

1. Copy the body of `soul-template.md` (everything below the HTML comment).
2. Replace `{{NAME}}` with the agent's name.
3. Place it where Hermes loads system-prompt context — Hermes reads `SOUL.md` into system-prompt slot #1.
4. Mind the cap: Hermes truncates context files at **20,000 characters** (head/tail), so keep the SOUL
   **principles-tier, not a rulebook** — the template fits comfortably under the cap; if you extend it, don't blow it.

**Install (other harnesses):** the template is harness-agnostic. Put the body wherever your harness loads persistent
system-prompt / character context, and respect that harness's size limits. The *content* is the same; only the
*install location and limits* are harness-specific.

## What still has to be supplied explicitly

The SOUL file carries *character*. The harness still won't auto-load the rest of Michi the way Claude Code does, so
make sure the agent can reach:

- **The skills it needs** — install or make `michi-expedition` (and any others) available in the harness's skill
  mechanism. The agent invokes them explicitly.
- **The project's docs and references** — `STATUS`, the expedition root, `extensions.md`, the structure reference. The
  agent re-grounds from these every run (see the expedition orientation ritual); it can't rely on a `CLAUDE.md`
  `@`-ref chain pulling them in.
- **The substrate** — the corpus or data the work reads, mounted into the agent's workspace (see
  `expedition-structure.md` → *Agent isolation — zones*).

## Why this lives with expeditions

The isolated, Entrusted, lights-off agent — running on its own in a container against a mandate — is exactly the
[expedition](expedition-structure.md) case. That's where the missing scaffolding bites hardest (long autonomous runs,
chat-only steering), and where the SOUL file earns its place. The same template and guidance apply to any Michi work
on a non-Claude-Code harness; expeditions are just where it shows up first.
