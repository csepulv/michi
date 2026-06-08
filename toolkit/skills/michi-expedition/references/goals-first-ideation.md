# Goals-first ideation (the Nirvana frame) — before you design solutions

For a "different kind" of expedition where the deliverable is **design options / concepts**, not data
findings (e.g. a visualization or UX charter). The trap is sprinting to solutions (chart types,
layouts, components) before establishing **what the user is trying to accomplish**. This recipe forces
the goals-first sequence.

## The Nirvana exercise

Imagine the **ideal end-state, ignoring cost / time / constraints**. What would be perfect? Then work
**backwards** to a plan that approximates it or hits a milestone toward it.

- **Focus on *what*, not *how*.** This is the whole discipline. The output of a Nirvana pass is the set
  of **questions/goals that, if satisfied, produce the ideal feeling** — NOT the mechanisms that
  satisfy them. Naming chart types / widgets / endpoints here is scope leakage; defer it.
- **If you can't picture the ideal, that's signal** — it means strategic uncertainty / absent goals,
  which is itself worth surfacing rather than papering over with activity.
- Frame it as a single **Nirvana statement** ("the user closes the app feeling they have a *handle* on
  X — they could describe it, point at what's normal vs odd, say how it changed"), then decompose into
  goals, each with focused sub-questions.

## How to run it as an expedition pass

1. **Pull the user's actual method/reference** if they name one (don't paraphrase a framework you half-
   remember — fetch it; the discipline lives in the details, e.g. "what not how").
2. **Write the ideation as questions+goals**, tagged and grouped (one *goal* = the job; *questions* =
   what serves it). Do NOT propose solutions. Add an explicit **"What I deliberately did NOT do"**
   line-check naming the solution-temptation you resisted — it proves you held the line.
3. **For each question, note a rough buildability/data read** (drivable-today / needs-X / unknown) so
   the goals carry their feasibility without yet committing to a *how*. Coverage/applicability is a
   *report-the-share* fact, not a gate.
4. **Surface the cross-cutting observations** (e.g. "X is a *lens* applied within other goals, not its
   own goal"; "concept Y is load-bearing for half these questions"). These reshape the campaign.
5. **End by asking the human to rank the spine** (which 2–3 goals anchor round one) and to confirm the
   persona — those are Paired calls that change everything downstream. Offer your instinct *with
   reasoning*, but it's their pick.

## Then — and only then — turn ranked goals into options

Once the human ranks goals + persona, the run produces **sample artifacts** (throwaway is fine and
often correct for brainstorming — "know it when I see it"). Generate **divergent breadth, not a single
polished pick**; converging on a winner is the *review's* job, not the run's. Judge every option
against any quality bar the human named (e.g. "demo-able / enticing") rather than making that bar its
own thread.

## Pitfalls

- **Solutioning during the goals pass.** The single most common failure. If you're naming chart types
  / components / APIs in the ideation doc, you've drifted from *what* to *how* — pull back.
- **Over-systematizing one steer.** A single human comment ("make it sexy") becomes a goal, a regime,
  a manufactured decision. File it as a *quality bar*, not a thread. (Cf. the skill's "over-
  systematizing a single steer" pitfall.)
- **Skipping the persona question.** "Who is this for" reorders the whole goal ranking; demo-viewer vs
  power-user pull opposite directions. Ask before ranking.
