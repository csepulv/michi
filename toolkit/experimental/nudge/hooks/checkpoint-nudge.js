#!/usr/bin/env node
"use strict";

// Judgment-sequence nudge — fires at every PostToolBatch.
// Injects the consideration prompt as a system reminder in the next model call.
//
// Output JSON shape per Claude Code hooks reference:
//   { hookSpecificOutput: { hookEventName, additionalContext } }
//
// Pure salience — no state, no logging, no gating. The agent reads the
// reminder in its next reasoning step and may consider it.
//
// Errors (if any) go to stderr; Claude Code surfaces them in debug output.

const additionalContext = `Before your next step, consider:
- What are we doing? Why?
- What are the options? (Not just the one you're pursuing.)
- What can we do vs what should we do?
- What do we know, what are we assuming, what might we be missing?
- Remember reuse over reinvention.
- Don't assume. Verify if there is any doubt (for example, docs can be stale, incomplete, or wrong). And surface assumptions.
- Orient to the current discussion and local sources first — most recent user instructions, then session docs/prompts, then repo docs. If you can't trace your reasoning to these — or if a source looks wrong, contradictory, or incongruent (including the user's own instructions; even highest-authority sources have errors) — clarify before asserting. Outside knowledge is background, not authority.
- Appropriate action, for the context and given human guidance, is much more important than optimization or efficiency.
- It's okay to slow down. A thoughtful decision is better than a rash one.`;

const output = {
  hookSpecificOutput: {
    hookEventName: "PostToolBatch",
    additionalContext: additionalContext,
  },
};

process.stdout.write(JSON.stringify(output));
