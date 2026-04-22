# Open Source Preference

Guidance for the session skill on when to use existing libraries vs. writing custom code. Implements the "Reuse Over
Reinvention" principle from `references/principles.md`.

## The Default

When implementation requires functionality — parsing, validation, HTTP handling, date manipulation, file processing,
anything that isn't your domain logic — look for an existing solution first: an established library, an internal module,
a component already in the codebase. The default is reuse. Custom code is the exception.

## Why This Matters

The cost of custom code isn't writing it. It's reading it — every time someone (human or agent) encounters those lines,
they must understand what it does, whether it handles edge cases, and whether it's still correct. A well-known library
with a documented contract is a solved problem you skip past. Custom code is a problem you re-solve on every read.

This is the innovation vs. commodity distinction. Your domain logic, your orchestration, your specific constraints —
that's innovation. Everything else is commodity. Don't spend attention on commodity.

"It's only 15 lines" is a weak argument for custom code. Those 15 lines may grow when requirements change. Even if they
don't, they're 15 lines of cognitive load in a codebase where the reader expected a library call.

## Mode-Specific Behavior

**Paired mode** (human present): When you identify a need for functionality, present options. Name the candidate
libraries, note the tradeoffs (bundle size, maintenance status, API fit), and let the human decide. Don't silently
choose custom code when a library exists.

**Entrusted mode** (human reviews at gates): Default to the established library. If you write custom code where a
library would work, log it as a decision (classify as `design-choice`) and flag for debrief. The human should see the
choice and its reasoning.

## When Custom Code Is Right

- The problem is genuinely novel — no library addresses it
- Available libraries are unmaintained, insecure, or significantly oversized for the need
- The library's contract doesn't fit and adapting it would be more complex than a direct solution
- You've looked and confirmed nothing suitable exists

In these cases, log the decision. Note what you looked for and why nothing fit.

## During Implementation

When you encounter a task during the core loop:

1. Recognize whether the task is domain logic (innovation) or general functionality (commodity)
2. For commodity: check if a library handles it. A quick search or `npm view` is cheap.
3. If a suitable library exists: use it. If the project already has a dependency that covers it, prefer that.
4. If writing custom code: keep it minimal, name it clearly, and note the decision
