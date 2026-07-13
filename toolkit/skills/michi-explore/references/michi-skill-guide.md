# Michi Skill Guide

Quick reference for which Michi skill fits the current moment. Use this to suggest transitions — not to force them. The
human decides when to move.

## The Skills

| Skill | When to use | Invoke |
|-------|-------------|--------|
| `michi-bootstrap` | Setting up a project for Michi work (first time or closing gaps) | `/michi-bootstrap` |
| `michi-explore` | Investigating, researching, orienting, brainstorming — before you know enough to plan | `/michi-explore` |
| `michi-planning` | Ready to scope a milestone — you know what to build, need to define how and how to verify | `/michi-planning` |
| `michi-session` | Plan exists, ready to implement — rigid execution with verification discipline | `/michi-session` |
| `michi-debrief` | Milestone or session complete — review decisions, capture learnings, calibrate trust | `/michi-debrief` |
| `michi-sustainability` | Health check — code quality, test quality, architectural alignment, knowledge gaps | `/michi-sustainability` |
| `michi-scenario-test-builder` | Need verification scenarios — Kaner methodology, use during planning | `/michi-scenario-test-builder` |
| `michi-workshop` | Small task — bug fix, quick feature, focused improvement. Full lifecycle is overkill. | `/michi-workshop` |
| `michi-expedition` | Open-ended learning work — the end isn't known; spiral toward clarity with a feedback flywheel | `/michi-expedition charter` |
| `michi-loop` | Convergent work with a trustworthy verifier — design and launch a lights-off autonomous loop | `/michi-loop` |
| `michi-pr-prep` | PR ready for review — prepare the reviewer's companion guide | `/michi-pr-prep` |
| `michi-docs-site` | Docs infrastructure — scaffold an internal docs browser, or a PDF build recipe | `/michi-docs-site` |

## The Natural Flow

```
bootstrap → explore → planning → session → debrief → planning (next milestone)...
                                                    ↘ sustainability (between epics)
```

Not every project hits every skill. Not every session follows the full flow. The flow is a default, not a mandate.

## The Lanes

The flow above is the **production lane** — convergent work marching toward a known deliverable. Two other lanes exist,
and the *form of verification you can answer* routes between them:

- **Convergent** ("how do I know I'm *done*?") → the production lane; or, when done-criteria are measurable, a
  trustworthy verifier exists, and autonomy has been earned, `michi-loop` (lights-off autonomous execution).
- **Progress** ("am I making progress, or spinning?") → `michi-expedition` (the learning-mode lane: charter → campaign
  → run → review, accreting a portrait instead of shipping a deliverable).

## Recognizing Transitions

**Explore → Planning:** The exploration has produced a clear direction. You know what to build and roughly how. The
conversation has shifted from "what should we do?" to "how should we do it?"

**Planning → Session:** The plan doc exists with acceptance criteria, scenarios, and steps. The human has approved it.

**Session → Debrief:** The milestone is complete and committed (or the session is ending). Time to review what happened.

**Debrief → Planning:** The debrief revealed what's next. Another milestone is ready to scope.

**Debrief → Sustainability:** Multiple milestones have accumulated. Time for a deeper health check before the next epic.

**Explore → Expedition:** The investigation turns out to be open-ended — the end isn't known, and the work wants a
spiral with a feedback flywheel rather than a planned milestone (mapping a data corpus, surveying a field, sustained
research). Hand off to `/michi-expedition charter`.

**Planning/Session → Loop:** The work is convergent ("done when ___" is statable with measurable criteria), a verifier
with teeth exists, the blast radius is reversible, and this kind of work has gone well Paired. `michi-loop` designs and
launches the lights-off run; the human makes the launch call.

**Session → PR-prep:** The milestone is committed and a PR is going up for review. Prepare the reviewer's guide.

**Any → Workshop:** The work is small enough to hold in your head. You don't need the full lifecycle — just the
discipline.

**Workshop → Full Michi:** The work grew beyond what the workshop can hold. Scope expanded, decisions are affecting other
things, you need verification infrastructure. Escalate.
