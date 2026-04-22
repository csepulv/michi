# Optimization Discipline

Guidance for recognizing and resisting premature optimization during implementation. Implements the "Essential Over
Incidental" principle from `references/principles.md`.

## The Problem

Agents and developers share the same instinct: when they spot a potential inefficiency, they optimize. The analysis is
usually correct — yes, this could be slow, yes, a mock is faster than an in-memory database. But correctness of
analysis is not the same as correctness of decision. The question isn't "could this be better?" — it's "does it matter
here?"

### Example: Test Speed vs. Test Fidelity

An agent building a MongoDB-backed service chose mock-based tests to preserve a 400ms test suite. The agent correctly
identified fast tests as the primary quality gate. But the mock tests validated the agent's understanding of MongoDB
operators, not MongoDB's actual behavior. A `$set`/`$setOnInsert` conflict passed mocks but failed against a real
database. The bug was only caught later during human testing.

The essential concern was test fidelity — does the test catch real bugs? The incidental concern was test speed — 400ms
vs. maybe 2 seconds with an in-memory MongoDB server. The agent optimized the incidental at the cost of the essential.

## The Decision Tree

When you're about to optimize something — faster tests, cached results, batched operations, pre-computed values,
simpler mocks — run through this:

**1. Does speed/efficiency actually matter here?**
If no, stop. You're done. Use the straightforward approach.

**2. If yes, why?**
Name the specific impact. "It could be slow" is not a reason. "The test suite takes 30 seconds and runs after every
file change" is a reason.

**3. If there's a real reason, consider the costs:**
- What does this optimization take away from? (Fidelity? Readability? Maintainability?)
- Does it complicate the code?
- Does it make testing harder or less trustworthy?
- Does it change the design?
- Do you have evidence this is needed, or is it speculation?
- What are you assuming? What have you measured?
- Can you defer this and do it later if it turns out to matter?

You don't need to build a complex justification addressing all of these. But if the answer to any of them gives you
pause, that's a signal.

## Mode-Specific Behavior

**Paired mode:** If you think something needs optimization, present the tradeoff to the human. Name what you'd
optimize, what it costs, and why you think it matters. Let the human decide.

If the *human* is pushing for optimization, it's okay — preferred, even — to sanity-check it. Run through the same
decision tree: does it matter here, what's the cost, is there evidence? The human may have context you don't, or they
may be falling into the same trap. Surface the tradeoff either way.

**Entrusted mode:** Default to the straightforward approach. If you optimize, log it as a decision with the reasoning
and the tradeoff. Flag for debrief review.

## Red Flags

- "This will be slow" — Have you measured? Or are you guessing?
- "This mock is faster" — Faster at what cost to fidelity?
- "We should batch this" — Is the unbatched version actually a problem?
- "Let me cache this" — Is the cache invalidation simpler than just computing it?
- "This is O(n^2)" — For what value of n? If n is 20, nobody cares.
