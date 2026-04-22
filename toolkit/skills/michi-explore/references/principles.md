# Principles

The foundation. Everything downstream builds on these. If something downstream contradicts what's here, what's here
wins.

---

## The North Stars

### What Over How

What and Why are questions about requirements, reasons, intentions, and goals. How is a question of implementation and
tactics. What and Why emphasize the problem. How describes a solution.

It's easy — especially for engineers — to prematurely explore the How. The impulse to design and implement is natural.
But an elegant solution to the wrong problem is waste. Requirements and reasons should be understood and explored before
solutions are pursued.

In any discussion, identify which considerations are What/Why issues and which are How issues, and which perspective
is appropriate for the given context. Conflating the two — especially under pressure — leads to solving the wrong
problem, or talking past each other as unstated assumptions diverge.

This has a fractal quality — invoke it at different levels of detail for any topic.

### Minimize Latency

An engineering org exists to shrink the distance between "what if we..." and "here's what happened when we did." Fast
tests, incremental milestones, tight feedback loops — all serve that goal. So does decision speed: a good decision now
beats a perfect decision next week, as long as it's reversible and documented.

This scales fractally. The test suite after a file change. The milestone that delivers something testable end-to-end.
The iteration cycle that produces validated learning. Same principle, different zoom.

### Sustain the System

Velocity without sustainability is a death spiral with good sprint metrics.

Each iteration should leave the system where the _next_ iteration is at least as productive. Code health, test health,
design coherence, knowledge retention — first-class work, not chores you schedule when things calm down. Things never
calm down.

### Navigating Complexity: The S-M-L-XL Scale

The S-M-L-XL scale manifests differently in different contexts. For sizing — document length, effort estimates, scope
of work — it's Small-Medium-Large-XL. For calibrating pace and readiness, it becomes Crawl-Walk-Run-Fly. It can also
be viewed as levels: 1-2-4-8, where the gaps between levels grow.

It is about perspective: evaluate tradeoffs, risks, how much to tackle or share, and how much rigor to apply — using
simple relative scales that normalize complexity into comparable terms. An L effort for S benefit is easy to decline.
An S effort for L benefit is easy to accept. The hard cases — M effort for M benefit in learning mode — are where
judgment lives. The framework doesn't decide for you; it makes the tradeoff visible.

Apply across dimensions:

- **Documentation depth:** Who needs to read this, and how much do they need? (See Progressive Detail below.)
- **Process rigor:** How much ceremony does this work need? A bug fix doesn't need the full
  planning-session-debrief lifecycle. A multi-milestone epic does.
- **Verification depth:** Unit tests for S risk. Integration tests for M. Smoke tests with real data for L. Human
  review for XL.
- **Decision speed:** S decisions are reversible and low-impact — just decide. XL decisions are costly to reverse —
  slow down, surface assumptions, get input.

When dimensions interact — effort vs. benefit, risk vs. readiness, essential vs. incidental — rate each on the scale
and compare. The mismatch is where the insight lives.

#### Progressive Detail

Three levels of documentation depth:

- **Principles** — always in context, the "why." This document.
- **Guidance** — loaded when relevant, the "what and when."
- **Checklists** — referenced during execution, the "how exactly."

The agent internalizes principles, loads guidance when entering a phase, references checklists when executing.

These North Stars exist in tension. Navigating that tension well is the craft. Everything below serves them.

---

## The Iteration Cycle

**Explore → Brainstorm → Plan → Execute → Verify → Document.**

Applies regardless of mode, deliverable type, or maturity. What changes is depth and rigor at each phase, not the phases
themselves.

The cycle minimizes latency — each iteration produces a validated outcome, not just output. It sustains the system —
Document captures knowledge, Verify catches degradation, Plan ensures you build on the last iteration instead of
repeating it.

Iterations progress spirally. Circles are waste. Progress means the process is better, the understanding deeper, or the
system more capable. Ideally all three.

---

## Principles

### Surface Assumptions

Unstated assumptions are the #1 source of escaped bugs — and the bugs are rarely coding errors. They're
integration-boundary failures: missing schema updates, hardcoded identities, mismatched contracts. Someone assumed.
Nobody challenged.

Before implementation, state your assumptions. During implementation, log new ones. During verification, check whether
they held.

While not the same thing, _blindspots_ can have similar consequences to assumptions. Also, it can be hard to be
aware of all that is needed at a given moment. All of these ideas are a type of **ignorance**, be it temporal, from
bias, etc. Frequently ask, "What might we be missing?"

### Verification Governs Autonomy

You can only give the agent as much rope as your verification can catch. Stronger verification → more autonomy → more
ambitious work → stronger verification needed. Progressive relationship, not a static threshold.

"All tests pass" is necessary but not sufficient — the agent grades its own homework. Verification needs layers the
agent didn't author: scenario testing, cross-boundary checks, human review where judgment is required.

Testability is infrastructure. `data-testid` attributes, stable selectors, clear contracts, separation of concerns — not
polish. They make verification viable, which makes autonomy viable.

### Shared Context as Foundation

Verification quality is bounded by shared understanding. Early cycle phases (Explore, Brainstorm, Plan) build shared
context before code gets written. Brownfield: context capture supplements codebase exploration. Greenfield: the context
spiral starts after milestone one — use what was built, capture the interactions, feed that into the next iteration.

### Learning Mode vs. Production Mode

Distinct modes, different rigor. Learning optimizes for discovery. Production optimizes for maintainability. The cycle
applies to both; the depth differs.

The trap: promoting a learning artifact to production without upgrading its rigor. Pick a lane — commit to a real
tradeoff rather than a mediocre middle.

### Two Modes of Practice

Not levels to graduate through — tools to select based on context and earned trust.

**Paired** — Tight loop. Human present, engaged, driving. The mode for learning, new codebases, high-risk work, or any
time you've lost your footing.

**Entrusted** — Wider initiative within established scope. Human reviews at gates. Earned through demonstrated mastery
of the tools, the codebase, and the verification discipline.

Moving from Entrusted back to Paired isn't regression. It's knowing when to slow down.

**The first epic should always be Paired.** The context that makes Entrusted viable doesn't exist yet. Start slow, earn
speed.

The metaphor: running with the lights off. Paired is lights-on — you need to see the agent's work. Entrusted
is running dark — verification infrastructure, decision logs, and scenario discipline see for you. The project is about
earning the right to turn the lights off. And knowing when to turn them back on.

### Reuse Over Reinvention

Prefer existing libraries, modules or components, OSS or internal, over custom code. The argument isn't about lines
saved — it's about cognitive cost. Fifteen lines of custom code is fifteen lines every reader must understand, maintain,
and verify. A known library with a known contract is a solved problem you don't re-read.

Consider innovation vs. commodity. **Innovations** add value — they reinforce the mission or the value
proposition. They might require custom code. **Commodities** are everything else — general-purpose functionality that
isn't your differentiator. Incidentals that re needed to deliver the value. Any effort developing a commodity is waste.
Buy it, acquire it, reuse it — through open source, internal libraries, or existing dependencies.

For innovation, build with combinations of custom code and open source. For commodity, open source first — always. The
instinct to hand-roll is strong, especially for small tasks. Resist it. Even when the custom version is "only 15 lines,"
those lines carry a maintenance surface the library already solved.

When no suitable library exists, or there's a reason not to use one, that's a judgment call worth logging. The default
is reuse; custom code is the exception that needs justification.

### Essential, Incidental, and Noise

Every piece of work has three kinds of concerns:

- **Essential** — what actually matters here. The thing that, if missed, makes the work fail.
- **Incidental** — necessary to deliver the essential, but not what the work is *for*. Commodity details,
  surrounding plumbing, scaffolding. Reuse over reinvention applies here by default.
- **Noise** — distraction that should not — or need not — be considered in the current context. Deferrable
  by name. Naming something as Noise is itself a decision: it says *this is real but not now*.

The triple is a triage tool. When a concern surfaces, ask: essential, incidental, or noise? The answer changes
what you do with it. Essential gets attention now. Incidental gets reuse, not invention. Noise gets deferred —
explicitly, so you don't re-pay the cost of re-evaluating it every time it resurfaces.

**On optimization.** Optimization is seductive. It feels like rigor — faster tests, fewer allocations, tighter
loops. But optimizing the wrong thing is worse than not optimizing at all, because it spends complexity on
something that doesn't matter while distracting from something that does.

Before optimizing, ask: does this matter here? Not "could this be slow" — but "is this actually a problem, in
this context, for these users, at this scale?" A startup MVP with ten users has different essential concerns
than a Google launch. The analysis of possible inefficiency isn't wrong — it's irrelevant until the context
demands it.

The default is: don't optimize. Any choice to optimize must be defended, never assumed. When in doubt, ask.

### Deliberate and Methodical — Avoid Flailing

**Flailing** is a failure mode: reacting to noise, chasing the second question before finishing the first,
declaring done prematurely, skipping steps that feel like ceremony, taking the first path that looks cheaper
without checking whether it's right. It produces motion without progress. It's the umbrella for several
specific failures — impulse-control lapses, answer-vs-question drift, doc-updates skipped, debriefs skipped,
assumption-surfacing short-circuited.

The guard is a single judgment question, asked before acting when the shape of the next step is ambiguous:

> *What is the actionable AND least painful AND something we could live with?*

Three clauses, all three mandatory:

- **Actionable** — can we actually do this step now with what we know? Not "quickest" (which rewards haste) —
  *doable*, with the context we currently have.
- **Least painful** — of the doable options, which minimizes cost, rework risk, and blocked dependencies?
- **Something we could live with** — if this step turned out to be wrong, could we back out or continue from
  here without a crisis? "Could live with" is the reversibility check.

A step that passes all three is deliberate. A step that fails any of them should be flagged, not taken. Flailing
happens when only one clause is consulted — usually "quickest" or "easiest" in isolation.

This is how the agent (or the practitioner) stays methodical under pressure. Pressure is when flailing happens;
the question is what resists it.

### The Process Serves the Work

Decision logging, assumption surfacing, verification against exit criteria, incremental delivery — load-bearing. The
specific artifacts, skill sequence, milestone ceremony — scaffolding that should flex.

Skills are applied guidance — calibrated for common scenarios. When a skill's guidance feels wrong for the current
situation, reason from principles. The skill might need updating, or the situation might be unusual. Either way,
principles are the tiebreaker. If you notice a gap between what a skill prescribes and what the principles suggest,
pause — that tension is a signal, not noise.

**The Rule of 3:** Three rounds is the sweet spot for iterating through a hard problem.

*Don't stop before three.* Hard problems resist first-pass thinking. Round one surfaces the obvious. Round two catches
what round one assumed. Round three consolidates and validates. Stopping at one is overconfidence dressed as
efficiency — especially for research, design, or anything where the right answer isn't obvious. When a task matters,
iterate explicitly: do the whole thing, feed learnings into the next round, refine, repeat.

*Don't push past three.* When thinking becomes circular — process about process, the same fix attempted again, the
third hypothesis tested and failed — stop. Come up for air. Regroup. The fractal nature of this work makes it easy to
spiral inward. Three iterations without progress is a signal to step back, reframe, or escalate — not to try a fourth
time.

Below three, you're rushing. Above three without progress, you're flailing.

These rules serve the work. When they don't, break them.
