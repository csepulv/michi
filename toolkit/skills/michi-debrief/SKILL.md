---
name: michi-debrief
description:
  Structured post-session review — assess what was delivered, review decisions, capture learnings, update knowledge
  base, and calibrate trust for the next session.
---

# Michi Debrief

Run after a michi session completes. Can run in the same session (benefits from context) or a fresh session
(clean context, no compaction bias). If the session was long, prefer a fresh session.

**Principles served:** Sustain the system (sustainability assessment, knowledge capture). Iterate spirally (each debrief
improves the next iteration). Verification governs autonomy (trust calibration). See `references/principles.md`.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there take priority over this skill's defaults.

**Multi-project repos:** If the repo has `multi-project: true` in CLAUDE.md, the debrief and its promotions
follow the project that was the session's subject:

- **ROOT (umbrella):** debrief at `docs/ROOT/epics/<epic>/debriefs/mN-debrief.md`; promotions target
  `docs/ROOT/journal.md`, `docs/ROOT/reference/`, and **repo-root CLAUDE.md** (umbrella's identity is there, not
  in `docs/ROOT/`).
- **Sub-project:** debrief at `docs/<name>/epics/<epic>/debriefs/mN-debrief.md`; promotions target
  `docs/<name>/journal.md`, `docs/<name>/reference/`, `docs/<name>/CLAUDE.md`.
- **Cross-sub-project findings** (affect the umbrella or multiple sub-projects) go in `docs/ROOT/reference/` or
  repo-root `CLAUDE.md` (as repo-wide rules).

## Scaling

Not every session needs a full debrief. Match the depth to the work.

**Full debrief (sections 1–7):** Epic milestones — the default. Produces a debrief artifact in `debriefs/mN-debrief.md`
plus extracted findings in their long-lived homes.

**Short debrief:** Freeform paired work, workshops, small sessions. A summary entry in `docs/journal.md` (or the epic's
journal) covering what changed, why, and anything worth remembering. Skip sections that don't apply — no bug table for a
docs change, no trust calibration for a 15-minute fix.

**Skip:** Trivial changes where the commit message is the whole story. Not every session needs a debrief.

**When in doubt, ask the user.** Present the options: "Full debrief in `debriefs/`? Short summary in journal? Skip?"
The human knows how much ceremony the work warrants.

### Where debriefs live

The debrief follows the work's home:

| Context | Location |
| --- | --- |
| Epic milestone | `docs/epics/<epic>/debriefs/mN-debrief.md` |
| Sidebar with its own directory | `docs/sidebars/<sidebar>/debriefs/` (or `docs/epics/<epic>/sidebars/<sidebar>/debriefs/`) |
| Freeform / workshop / small session | `docs/journal.md` entry (short debrief) |

## 1. Delivery Assessment

Start with the facts.

**For each milestone in the session:**

- What was the scope in the plan?
- What was actually delivered?
- What was deferred or cut? Why?
- Were acceptance criteria met? (Check each one explicitly)

**Results (adapt to target):**

For code targets:

- Unit: __ pass / __ fail
- Integration: __ pass / __ fail
- Level A scenarios: __ pass / __ fail / not run
- Code review: done / skipped / issues found

For non-code targets:

- Exit criteria: __ met / __ not met / __ partially met
- Named deliverables: __ produced / __ missing
- Discovery questions surfaced: __ (documented in Discussion)

**Commits:**

```bash
git log --oneline <branch> --since="<session-start>"
```

Are all milestones committed? Any uncommitted work?

## 2. Decision and Discussion Review

Read `## Decisions` and `## Discussion` from each milestone's plan doc.

**For each decision:**

- Was it reasonable given context?
- Were there consequences the agent didn't anticipate?
- Should it be reversed, refined, or accepted?
- Does it create a repeating pattern? (If so, codify it)

**Flag decisions that should flow into CLAUDE.md** — things the agent should know for all future sessions, not just this
milestone.

**For each discussion item:**

- Resolve now (answer the question, make the decision)
- Defer (not ready — note why and when to revisit)
- Promote to project-level question (affects more than this epic — move to `docs/reference/` or project STATUS.md)

## 3. Bug and Gap Analysis

**Bugs found during the session:**

| Bug | Found by                                                   | When                                                        | Root cause | Systemic?                     |
| --- | ---------------------------------------------------------- | ----------------------------------------------------------- | ---------- | ----------------------------- |
|     | Unit test / Integration / Smoke / Manual / Post-completion | During implementation / During verification / After session |            | Does this class of bug recur? |

**For each bug, ask:**

- Would a Level A scenario have caught it? A holdout test?
- Would a code review subagent have caught it?
- What process change prevents this class of bug?

**Error analysis (evolve the scenario set):**

The most valuable scenarios come from actual failures. For each bug found:

- What scenario would have caught it? Write it in Given-When-Then format.
- Add it to the scenario catalog for the next session.
- This is how the verification set evolves — driven by actual errors, not imagined ones.

**Cross-package gaps:**

- Did the agent update all downstream schemas when introducing new types?
- Were there hardcoded assumptions about callers?
- Were there URL construction issues?

## 4. Process Observations

**What worked well?**

- Patterns or approaches worth repeating
- Places where the skill guidance was valuable

**What didn't work?**

- Friction points — tool failures, process overhead, unclear instructions
- Places where the agent deviated from the skill and it caused problems
- Places where the agent followed the skill rigidly when it should have adapted

**Scenario quality assessment:**

- Were Level A scenarios useful? Did they catch anything unit tests missed?
- Were they too granular (overhead without value) or too vague (didn't catch real issues)?
- Did the agent execute them faithfully, or skip/shortcut?
- Were any Level B/C scenarios that should be promoted to Level A by making criteria more specific?
- Did regression scenarios catch anything? Were any slow or redundant?
- Recommendations for scenario design in the next session

**Scenario lifecycle decisions:**

The debrief determines what happens to verification artifacts:

- **Promote:** New scenarios with ongoing regression value → add to the catalog
- **Update:** Existing scenarios broken by intentional changes → update to reflect new behavior
- **Retire:** Scenarios no longer relevant → remove from catalog
- **Add:** Error-analysis scenarios (from bugs found) → add for the next session

The scenario catalog is a living asset. It grows through planning (co-design) and debrief (error analysis), and is
pruned during debrief. Maintenance between sessions (reorganizing, consolidating) can be a separate activity.

**Sustainability assessment:**

- Test health: meaningful or shallow? Mock usage appropriate? Obvious gaps?
- Architectural drift: does accumulated code match design intent? Unacknowledged drift?
- Readability: can someone scan the code and understand what it does and why?
- Knowledge gaps: what's been learned that isn't written down?
- What scope should the next sustainability check cover?

**Tool usage:**

- Read cache failures? How many? When did they start?
- Did the agent fall back to Bash for reads/edits?
- Were subagent explorations useful?
- Was the code review subagent invoked? Useful?

**Human interactions:**

- How many? Categories? (course corrections, process direction, debugging, etc.)
- Which were avoidable with better planning or CLAUDE.md?
- Which were high-value interventions only a human could provide?

## 5. Knowledge Capture

### Learnings

Separate into two categories:

**Domain learnings** (about the product/codebase) → epic's `journal.md`

- Gotchas, quirks, undocumented behavior
- Patterns specific to this codebase
- Integration boundaries needing special care

**Process learnings** (about methodology) → `docs/reference/patterns.md` or epic's `journal.md`

- New patterns or anti-patterns discovered
- Process improvements that worked or didn't
- Tool usage insights

### Pattern Updates

Check `docs/reference/patterns.md` (seed from `references/patterns.md` if it doesn't exist):

- New patterns to add?
- Existing patterns needing revision based on this session?
- Anti-patterns validated or invalidated?

### Applied Coding Principles

Review human interventions on code quality during the session. Look for moments where the human:

- Corrected the agent's approach to code structure, naming, or organization
- Applied a design principle in a non-obvious way
- Pushed back on code the agent considered acceptable

For each, capture the **applied example** in `docs/reference/code-style.md` — not the abstract principle (that belongs
in CLAUDE.md or global rules), but the concrete judgment: when the principle applies, the trigger, what the result looks
like.

If `docs/reference/code-style.md` doesn't exist, create it. If it does, append. This file grows incrementally through
debriefs — the project's calibration data for code quality judgment.

### Memory Update

Review the session for memory-worthy content. Litmus test: "What would be painful to lose in a new session?"

**Prompts:**

- Did the human correct an approach? What was the correction and why?
- Did the human confirm a non-obvious approach? ("yes, exactly that")
- Was there a surprise — something that worked unexpectedly well or failed?
- Is there an active thread of thinking that hasn't resolved?
- Did we establish a trust pattern — "just do it for X, always check for Y"?

**Boundary:** Code patterns → `docs/reference/code-style.md`. What happened → journal. How we work / what would be
painful to lose → `docs/memory.md`.

Update `docs/memory.md` if warranted. Review the Mental Model section — has anything changed? Active threads resolved?
New ones emerged?

### CLAUDE.md Updates

Based on the session, should CLAUDE.md be updated with:

- New gotchas or conventions?
- New "do not" rules?
- References to new docs or tools?
- Verification instructions specific to this project?

## 6. Trust Calibration

Assess readiness for the next session's autonomy level.

**Signals that trust increased:**

- All acceptance criteria met without human intervention
- Decisions were reasonable and well-documented
- No post-completion bugs
- Verification checklist followed completely
- Level A scenarios all passed and caught at least one issue

**Signals that trust decreased:**

- Agent declared "done" prematurely
- Cross-package gaps found
- Verification steps skipped or treated as optional
- Agent skipped or shortcut scenario execution
- Decisions made that should have been escalated

**Recommendation for next session:**

- Same autonomy level
- Increase (e.g., move from interactive to semi-autonomous)
- Decrease (e.g., shorter milestones, more checkpoints)

## 7. Outputs

**Inputs-vs-outputs check before writing.** Before producing the debrief artifact, scan what was read — the plan doc's
`## Decisions`, `## Notes`, `## Discussion`, `## Scenarios`, commit history, session transcript. Verify each significant
source is reflected somewhere in the output chain (the debrief itself, the journal, patterns.md, CLAUDE.md, memory).
A debrief that pulls from a thick plan doc but produces thin outputs has likely dropped material. Use the inputs as a
checklist.

For deeper assessment or readiness artifacts (e.g., end-of-epic checkpoint docs), `toolkit/checkpoint-doc-formats.md`
offers optional structured formats — Readiness Checklist, Assessment-doc tables, Operational Guide.

The debrief produces:

1. **Debrief artifact** → epic's `debriefs/mN-debrief.md`
   - The primary output — the coherent assessment itself
   - Covers: delivery summary, decision review, bug/gap analysis, process observations, trust calibration
   - Named to match the milestone(s) debriefed (e.g., `m3-debrief.md`, or `m3-m4-debrief.md` for combined sessions)
   - This is the complete record; the other outputs below extract specific findings into their long-lived homes

2. **Journal entry** → epic's `journal.md` or `docs/journal.md`
   - Domain learnings, gotchas, open questions — things worth preserving outside the debrief
   - Not a session summary (that's in the debrief artifact now)

3. **Pattern/anti-pattern updates** → `docs/reference/patterns.md`
   - Only add patterns with high confidence and clear source

4. **CLAUDE.md updates** → project's CLAUDE.md
   - Only add rules that are durable and broadly applicable

5. **STATUS.md update** → project's STATUS.md
   - Reflect current state, what's next

6. **Next session prep notes** (optional)
   - What needs to be ready before the next session
   - Holdout tests to write, environment changes, plan docs to create

7. **Memory update** → project's `docs/memory.md`
   - Collaboration patterns, corrections, confirmed approaches
   - Mental model changes (new threads, resolved threads)
   - New landmarks

### What's Next

If another milestone is ready, the natural next step is `/michi-planning`. If multiple milestones have accumulated without
a health check, `/michi-sustainability`. If the epic is complete, update STATUS.md and archive.
