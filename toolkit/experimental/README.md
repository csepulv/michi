# Experimental

This directory holds Michi work that's being shared but isn't part of
the regular toolkit.

## What's here

In-progress items — hooks, plugins, draft skills, prototype patterns — shared so
people can try them, give feedback, or fork them. The contents are real and usable,
but their shape is unsettled.

## What it isn't

- **Not part of the regular toolkit.** Don't expect the same stability or maturity.
- **Not supported.** No promise of bug fixes, breaking-change announcements, or
  documentation parity with the rest of `toolkit/`.
- **Not endorsed for adoption.** If an item lands here, the author thinks it's worth
  trying *with eyes open* — not "ready for production use."

## What might happen to items here

Each item lives at its own pace. Three possible futures:

- **Promoted to the regular toolkit** — the item earned its place; future versions
  ship alongside the rest of the toolkit.
- **Refined in place** — interface changes, content drifts, the README updates;
  experimental status remains until promotion is warranted.
- **Removed** — the item didn't work out. Removal is announced in the CHANGELOG with
  reasoning.

No guarantees of any of these.

## Naming convention

Experimental plugins are named with the `experimental-` prefix (e.g.,
`experimental-nudge`) so the install command itself signals that the item is
experimental.

## How to read items here

Each subdirectory has its own `README.md` with what it does, how to install or use
it, and the specific caveats for that item. Read those before installing.

## Feedback

Issues, observations, "this worked," "this didn't" — all welcome. Open an issue on
the public repo (`csepulv/michi`).
