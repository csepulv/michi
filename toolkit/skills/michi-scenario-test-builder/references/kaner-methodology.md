# Kaner's Scenario Testing Methodology

Source: "An Introduction to Scenario Testing" — Cem Kaner, Florida Tech, June 2003

## What Is a Scenario Test?

A scenario is a hypothetical story used to help a person think through a complex problem or system. A scenario test is a
test based on a scenario.

The key distinction: scenarios are **stories about people using the system for real purposes**, not mechanical
enumerations of inputs and outputs.

## The Five Quality Criteria

### 1. Story

The test is based on a story about how the program is used, including the motivations of the people involved.

A dry recital of steps doesn't capture imagination. To make the story effective, tell the reader:

- Why the user is doing what they're doing
- What they want to accomplish
- What the consequences of failure are

### 2. Motivating

A stakeholder with influence would push to fix a program that failed this test. The scenario must make someone care
enough to act.

Consider impact on:

- The user directly
- The user's business or workflow
- Your company (the software developer) — e.g., a bug that floods you with support calls

### 3. Credible

A stakeholder with influence believes this scenario will probably happen in the real world. Not just "could happen" but
"probably will happen."

Ways to establish credibility:

- Reference real user behavior you've observed
- Cite requirements specifications
- Draw from competitor product usage
- Use real-world data patterns

### 4. Complex

A complex story involves many features working together. Single-feature tests are better served by other techniques
(domain testing, unit testing). Scenarios discover problems in relationships among features, data flows, and system
components.

To increase power: exaggerate slightly. Make values more extreme, sequences more complicated, add more people or
documents. Hans Buwalda calls these "soap opera tests."

### 5. Easy to Evaluate

Despite complexity, it should be clear whether the program passed or failed. The more complex the test, the more likely
a plausible-looking result gets accepted as correct when it isn't.

Especially important for:

- Autonomous verification (agents checking results)
- Complex data transformations where output "looks right" but is subtly wrong
- Systems where errors are silent (data corruption, incorrect calculations)

## The Tester's Perspective vs. Requirements Analyst

Kaner draws a critical distinction:

- The **requirements analyst** fosters agreement about the system. The **tester** exploits disagreements to predict
  problems.
- The tester doesn't have to reach conclusions or make recommendations. Their task is to **expose credible concerns** to
  stakeholders.
- The tester doesn't have to respect prior agreements. They expose consequences of tradeoffs, especially unanticipated
  ones.
- The scenario tester's work need not be exhaustive, just **useful**.

## Risks of Scenario Testing

Kaner identifies three serious risks:

1. **Not suitable for early, unstable code.** Complex scenarios chaining features will be blocked by the first broken
   feature. Test in isolation first.

2. **Not designed for coverage.** Scenario tests don't systematically cover all features, statements, or requirements.
   Use other techniques for coverage.

3. **Don't reuse scenarios for regression.** Scenarios expose design errors. The second time around, you've learned what
   the test teaches about the design. Create new variations instead. Use unit tests for regression.

## When Scenario Testing Works Best

- Complex transactions or events
- End-to-end delivery of program benefits
- Exploring expert use of the program
- Surfacing requirements controversies and disagreements
- Making bug reports more persuasive and motivating
