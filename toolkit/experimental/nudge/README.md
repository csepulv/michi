# experimental-nudge — judgment-sequence reminder for Claude Code

A small Claude Code plugin that fires a system reminder after every `PostToolBatch` event (each agent loop iteration). The reminder is a brief consideration prompt — the agent reads it, may engage with it, and proceeds. **Pure salience. No gating. No enforcement.**

**Experimental.** This plugin is part of `toolkit/experimental/`, not the regular Michi toolkit. See `toolkit/experimental/README.md` for the contract.

## What it does

After each iteration of the agent's tool-call loop, the plugin injects this content as a system reminder in the next model call:

```
Before your next step, consider:
- What are we doing? Why?
- What are the options? (Not just the one you're pursuing.)
- What can we do vs what should we do?
- What do we know, what are we assuming, what might we be missing?
- Remember reuse over reinvention.
- Don't assume. Verify if there is any doubt (for example, docs can be
  stale, incomplete, or wrong). And surface assumptions.
- Orient to the current discussion and local sources first — most recent user
  instructions, then session docs/prompts, then repo docs. If you can't trace
  your reasoning to these — or if a source looks wrong, contradictory, or
  incongruent (including the user's own instructions; even highest-authority
  sources have errors) — clarify before asserting. Outside knowledge is
  background, not authority.
- Appropriate action, for the context and given human guidance, is much
  more important than optimization or efficiency.
- It's okay to slow down. A thoughtful decision is better than a rash one.
```

The agent treats the reminder as it would any other system reminder — read, may consider, may ignore. No action is forced.

## What it doesn't do

- **Doesn't gate any action.** No `PreToolUse` blocks. The agent can always proceed.
- **Doesn't track state.** No counter, no state file, no per-session memory.
- **Doesn't log.** Errors go to stderr; success is silent.
- **Doesn't catch under-question failures.** This nudge fires *between* tool calls (`PostToolBatch`), not at user-prompt arrival. If the agent misreads the user's question and proceeds with the wrong frame, this nudge alone won't catch that — the user's correction is still load-bearing for that class of failure.

## Why this exists, briefly

This packages a hook that emerged from the Michi metacognition investigation: the observation that judgment in agent work is **the cumulative effect of many small choices**, not single big decisions. Periodic re-surfacing of a specific consideration sequence may bias those small choices toward more careful framing. The evidence is suggestive but not conclusive — see the experiment context section below.

The author's view is that the salience nudge **probably contributes** to better judgment in concert with other discipline (sharp human correction, principled docs, structured skills) but is **not sufficient on its own** and **not validated as a stand-alone intervention**.

## Install

Clone the public Michi repo and add the marketplace, then install:

```bash
git clone https://github.com/csepulv/michi.git
claude plugin marketplace add ./michi/toolkit
claude plugin install experimental-nudge@michi
```

Verify:

```bash
claude plugin list
# expect to see: experimental-nudge@michi (enabled)
```

The plugin is now active in every Claude Code session.

## Disable per-project

In a project where you don't want the nudge firing, add to that project's `.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "experimental-nudge@michi": false
  }
}
```

Project-level settings override user-level for plugin enablement.

## Disable globally

```bash
claude plugin disable experimental-nudge@michi
```

Or remove entirely:

```bash
claude plugin uninstall experimental-nudge@michi
```

## Verify it's firing

The hook produces no log file. To confirm it's working:

1. Start a Claude Code session in a project with the plugin enabled.
2. Ask the agent something that involves at least one tool call (e.g., "list files in this directory").
3. After the response, the system reminder should be in the agent's context for the next model call. You can verify by asking the agent in the next turn: *"What's the most recent system reminder you've seen?"* — it should describe the consideration prompt.

If the agent doesn't see the reminder, check Claude Code's debug output for hook execution errors.

## Customization

The prompt content is currently hardcoded. There's no `userConfig` or override mechanism in v0.1 — the bullets reflect Christian's judgment vocabulary, drawn from the [Michi playbook principles](https://github.com/csepulv/michi). If you want different content, fork the plugin and edit `hooks/checkpoint-nudge.js`.

A future version may expose a content-override path (e.g., reading from `docs/reference/extensions.md` per the Michi extensions pattern). Not in v0.1.

## Caveats

This plugin is **experimental and unproven as a stand-alone intervention**.

- **The evidence base is small.** A few A/B-shaped pairs of milestones on one project, plus end-to-end observation across one nine-milestone epic. Single author, single agent calibration history.
- **The nudge alone is unlikely to be sufficient.** The strongest evidence supports a *compound* effect: artifacts (Michi-style cumulative-judgment docs) + sharp human correction at moments of failure + this nudge. Stripping any of those three may degrade the result. If you install the nudge into a project without the other two, the value-add may be small or zero.
- **It may add noise.** If the agent treats the reminder as wallpaper after several firings, it stops doing useful work. The Michi research is consistent with this risk; we haven't observed it directly but haven't ruled it out either.
- **Content is opinionated.** The bullets reflect one person's judgment vocabulary. Other operators may find them generic, irrelevant, or wrong-shape.

If you try this and have observations (positive, negative, mixed), the author would like to hear them.

## Experiment context

This plugin is one piece of an ongoing investigation into agent judgment. The framing — *"judgement is the collective choices that put you on paths"* — comes from Christian Sepulveda's playbook. The specific bullet content is the evolving output of a multi-week investigation traced in `docs/sidebars/metacognition-in-dsf/` and `docs/epics/metacognition-applied/` in the Michi private repo.

State of the investigation as of 2026-05-08: directional evidence is positive across multiple dimensions; not validated as a stand-alone mechanism; not recommended for unconsidered adoption.

## License

MIT — see `LICENSE`.
