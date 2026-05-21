---
name: michi-debrief
description:
  Structured post-session review — assess what was delivered, review decisions, capture learnings, audit what got
  invalidated, refresh the root docs, and calibrate trust for the next session.
---

# Michi Debrief

Run after a michi session completes. Can run in the same session (benefits from context) or a fresh session
(clean context, no compaction bias). If the session was long, prefer a fresh session.

**Principles served:** Sustain the system (knowledge capture and currency). Iterate spirally (each debrief improves
the next iteration). Surface assumptions (what got invalidated; what's now stale). Verification governs autonomy
(trust calibration). See `references/principles.md` and `references/ground-rules.md`.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there take priority
over this skill's defaults.

**Multi-project repos:** If the repo has `multi-project: true` in CLAUDE.md, the debrief and its promotions follow the
project that was the session's subject:

- **ROOT (umbrella):** debrief at `docs/ROOT/epics/<epic>/debriefs/mN-debrief.md`; promotions target
  `docs/ROOT/journal.md`, `docs/ROOT/reference/`, and **repo-root CLAUDE.md** (umbrella's identity is there, not
  in `docs/ROOT/`).
- **Sub-project:** debrief at `docs/<name>/epics/<epic>/debriefs/mN-debrief.md`; promotions target
  `docs/<name>/journal.md`, `docs/<name>/reference/`, `docs/<name>/CLAUDE.md`.
- **Cross-sub-project findings** (affect the umbrella or multiple sub-projects) go in `docs/ROOT/reference/` or
  repo-root `CLAUDE.md` (as repo-wide rules).

## Scaling

Not every session needs a full debrief. Match the depth to the work.

**Full debrief (all three passes):** Epic milestones — the default. Produces a debrief artifact in `debriefs/mN-debrief.md`
plus extracted findings in their long-lived homes.

**Short debrief:** Freeform paired work, workshops, small sessions. A summary entry in `docs/journal.md` (or the epic's
journal) covering what changed, why, and anything worth remembering. Pass 1 light, Pass 2 still required, Pass 3 still
required — staleness doesn't care about session size.

**Skip:** Trivial changes where the commit message is the whole story. Not every session needs a debrief.

**When in doubt, ask the user.** Present the options: "Full debrief in `debriefs/`? Short summary in journal? Skip?"
The human knows how much ceremony the work warrants.

### Where debriefs live

The debrief follows the work's home:

| Context | Location |
| --- | --- |
| Epic milestone | `docs/epics/<epic>/debriefs/mN-debrief.md` |
| Flat-file epic | `docs/epics/<epic>/debriefs/<epic>-debrief.md` (alongside the flat file; grows to subdir if the epic does) |
| Freeform / workshop / small session | `docs/journal.md` entry (short debrief) |

## Common Rationalizations

The debrief is where laziness is most tempting — the work feels done, the commits are in, this feels like paperwork.
It isn't. These are the excuses to push past:

| Excuse                                                                          | Reality                                                                                                                        |
|---------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| "Nothing fundamental changed — STATUS.md doesn't need updating."                | Read it cold. If any line is stale, rewrite. The reflex is read-and-update, not skip-if-trivial.                               |
| "Decisions are obvious from the journal — promotion isn't critical."            | Cold-start sessions don't read journals. Reference docs are how decisions persist. Promote.                                    |
| "This milestone was scoped — reference docs are probably fine."                 | Grep for citations of any mechanism you changed. Absence of grep ≠ absence of staleness.                                       |
| "Three passes is overkill for a small milestone."                               | The passes may be brief. They are not optional. Pass 2 is what catches the doc that's about to mislead the next session.       |
| "Memory entries from earlier in this epic are still useful."                    | Re-read them. Retire what's been superseded — stale memory misleads worse than missing memory.                                 |
| "ARCHITECTURE.md is still mostly right — updating sections is debrief overhead." | The sections you skip are the ones that lure confident wrong action next session. Stamp what you re-verified; flag what isn't. |
| "I'll follow up on the cleanup later."                                          | Pass 3 *is* the cleanup. Later means never.                                                                                    |
| "The bugs were caught — error analysis is paperwork."                           | The next class-of-bug isn't in the bug. It's in the scenario you'd write to catch it. Write the scenario.                      |

## The Three Passes

Rule of 3 applied to the debrief. Three passes, named, all required:

1. **Capture** — what happened, what was decided, what was learned. Additive. (Most of the existing debrief content.)
2. **Invalidate** — what did this milestone *break*? Reference docs that now lie, ARCHITECTURE sections superseded,
   memory entries that have aged out, decisions overruled. The pass that closes the doc-drift gap.
3. **Currency + Cleanup** — root docs read cold, stamps refreshed, archive candidates surfaced. The pass that keeps
   the project state honest.

Then trust calibration, then outputs.

The passes can be brief — but each must run. Pass 2 is the reflex that's been missing; Pass 3 is what keeps the project
state honest across sessions. Skipping either compounds drift.

---

## Pass 1: Capture

What happened, what was decided, what was learned. The additive pass.

### 1.1 Delivery Assessment

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

### 1.2 Decision and Discussion Review

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

### 1.3 Bug and Gap Analysis

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

### 1.4 Process Observations

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

**Tool usage:**

- Read cache failures? How many? When did they start?
- Did the agent fall back to Bash for reads/edits?
- Were subagent explorations useful?
- Was the code review subagent invoked? Useful?

**Human interactions:**

- How many? Categories? (course corrections, process direction, debugging, etc.)
- Which were avoidable with better planning or CLAUDE.md?
- Which were high-value interventions only a human could provide?

### 1.5 Knowledge Capture

#### Learnings

Separate into two categories:

**Domain learnings** (about the product/codebase) → epic's `journal.md`

- Gotchas, quirks, undocumented behavior
- Patterns specific to this codebase
- Integration boundaries needing special care

**Process learnings** (about methodology) → `docs/reference/patterns.md` or epic's `journal.md`

- New patterns or anti-patterns discovered
- Process improvements that worked or didn't
- Tool usage insights

#### Pattern Updates

Check `docs/reference/patterns.md` (seed from `references/patterns.md` if it doesn't exist):

- New patterns to add?
- Existing patterns needing revision based on this session?
- Anti-patterns validated or invalidated?

#### Applied Coding Principles

Review human interventions on code quality during the session. Look for moments where the human:

- Corrected the agent's approach to code structure, naming, or organization
- Applied a design principle in a non-obvious way
- Pushed back on code the agent considered acceptable

For each, capture the **applied example** in `docs/reference/code-style.md` — not the abstract principle (that belongs
in CLAUDE.md or global rules), but the concrete judgment: when the principle applies, the trigger, what the result looks
like.

If `docs/reference/code-style.md` doesn't exist, create it. If it does, append. This file grows incrementally through
debriefs — the project's calibration data for code quality judgment.

#### Memory: New Entries

Review the session for memory-worthy *additions*. Litmus test: "What would be painful to lose in a new session?"

**Prompts:**

- Did the human correct an approach? What was the correction and why?
- Did the human confirm a non-obvious approach? ("yes, exactly that")
- Was there a surprise — something that worked unexpectedly well or failed?
- Is there an active thread of thinking that hasn't resolved?
- Did we establish a trust pattern — "just do it for X, always check for Y"?

**Boundary:** Code patterns → `docs/reference/code-style.md`. What happened → journal. How we work / what would be
painful to lose → `docs/memory.md`.

(*Memory **retirement** — entries that should be removed because this session superseded them — happens in Pass 2.*)

---

## Pass 2: Invalidate

What did this milestone *break*? The pass that closes the doc-drift gap. Additive capture (Pass 1) is necessary but
not sufficient — if you only ever add, the docs that lie quietly never get caught.

This pass is short when the milestone is small. It is not optional.

### 2.1 Reference Doc Audit

For every mechanism this milestone changed (a config file, an API, a build step, a setup procedure, an env-file
convention, a migration mechanism), grep `docs/` for references:

```bash
grep -r "<old-mechanism>" docs/
```

For each hit, decide:

- **Update** — the doc references this and is now wrong. Fix it now (or note it for Pass 3).
- **Remove** — the reference no longer applies. Delete.
- **Leave** — historical reference (in a journal entry, an archived plan), correct in context. Skip.

Common mechanism changes that require this audit: env-file conventions, build commands, deploy commands, port
numbers, file paths in instructions, names of tools or scripts.

### 2.2 ARCHITECTURE.md Section Check

If the milestone touched architecture-relevant code (new components, changed boundaries, new contracts, deleted
modules), open ARCHITECTURE.md and read the affected sections cold:

- Does the section still describe reality?
- If yes — update the section's `last-verified:` stamp to today.
- If no — fix the section now (or note it for Pass 3) and stamp it after.
- If the section is structurally outdated (entire chunks describe a now-replaced design), flag for a focused
  ARCHITECTURE update outside this debrief.

This is the doc most likely to lure confident wrong action in the next session. Time spent here pays back.

### 2.3 Decisions Superseded

Read `docs/reference/key-decisions.md` and `docs/reference/patterns.md` (where present):

- Did this milestone change a decision recorded there? Update or annotate.
- Did this milestone validate or invalidate a pattern? Note the evidence.
- Are there entries that referenced now-removed code, files, or tools?

### 2.4 Memory Retirement

Read `docs/memory.md` with the session's changes in mind:

- Active threads now resolved? Move to landmarks or remove.
- Landmarks naming files, functions, or tools that no longer exist? Update or retire.
- Mental Model entries describing thinking that's since shifted? Refresh or remove.

Stale memory misleads worse than missing memory. The cost of an entry the agent trusts and is wrong about is higher
than the cost of an entry that isn't there.

---

## Pass 3: Currency + Cleanup

The pass that keeps the project state honest. Read root docs cold; stamp what's been re-verified; surface what should
be archived.

### 3.1 STATUS.md — Read Cold (Mandatory)

Open `STATUS.md` and read it as if you've never seen the project before. For every line:

- Is this still true after this session?
- If not, rewrite or remove.

Then:

- Update the active section to reflect what just shipped, what's next, what's deferred.
- Update the `**Last updated:** YYYY-MM-DD` stamp at the top.

This step is **not conditional on "anything significant changed."** The reflex is read-cold-and-update, every debrief.
If you find yourself thinking "STATUS doesn't really need updating," see the Common Rationalizations.

### 3.2 journal.md — Timestamp

The active epic's `journal.md` (or the project-level journal for freeform work) gets the new entry from Pass 1.5. Make
sure:

- The new entry has a date heading (`### YYYY-MM-DD — <topic>`).
- The doc's `**Last updated:** YYYY-MM-DD` stamp at the top is current.

### 3.3 CLAUDE.md / PROJECT.md / ARCHITECTURE.md

Read each cold *if* this milestone might have affected its contents. Indicators:

- **CLAUDE.md** — new convention, new "do not" rule, a tool or path referenced that's changed
- **PROJECT.md** — scope shift, new feature category, success-criteria evolution
- **ARCHITECTURE.md** — already covered in Pass 2.2; refresh stamps for any sections re-verified

If unaffected, skip. These are not updated every debrief — only when their content has been touched by reality.

### 3.4 Stamp Sweep

For any section of a long-lived reference doc you re-read and verified during this debrief, update its
`last-verified: YYYY-MM-DD` line. Stamps are how the next session knows what's trustworthy cheaply versus what needs
verification before citing. See `references/ground-rules.md` for the full convention.

### 3.5 Archive Candidates

Surface (don't necessarily act on):

- Plan docs for milestones now complete that can move to `docs/archive/`
- Sidebars whose work has fully landed — output captured in reference docs
- Old debriefs that referenced now-superseded approaches

Note candidates in the debrief artifact; the human decides what gets moved.

### 3.6 Inputs-vs-Outputs Check

Before producing the debrief artifact, scan what was read — the plan doc's `## Decisions`, `## Notes`, `## Discussion`,
`## Scenarios`, commit history, session transcript. Verify each significant source is reflected somewhere in the output
chain (the debrief itself, the journal, patterns.md, CLAUDE.md, memory). A debrief that pulls from a thick plan doc but
produces thin outputs has likely dropped material. Use the inputs as a checklist.

---

## Trust Calibration

Assess readiness for the next session's autonomy level.

**Signals that trust increased:**

- All acceptance criteria met without human intervention
- Decisions were reasonable and well-documented
- No post-completion bugs
- Verification checklist followed completely
- Level A scenarios all passed and caught at least one issue
- All three debrief passes ran cleanly without prodding

**Signals that trust decreased:**

- Agent declared "done" prematurely
- Cross-package gaps found
- Verification steps skipped or treated as optional
- Agent skipped or shortcut scenario execution
- Decisions made that should have been escalated
- Pass 2 surfaced doc drift the agent introduced and didn't catch
- Pass 3 found STATUS.md stale within the same session

**Recommendation for next session:**

- Same autonomy level
- Increase (e.g., move from interactive to semi-autonomous)
- Decrease (e.g., shorter milestones, more checkpoints)

---

## Outputs

For deeper assessment or readiness artifacts (e.g., end-of-epic checkpoint docs), `toolkit/checkpoint-doc-formats.md`
offers optional structured formats — Readiness Checklist, Assessment-doc tables, Operational Guide.

The debrief produces:

1. **Debrief artifact** → epic's `debriefs/mN-debrief.md`
   - The primary output — the coherent assessment itself
   - Covers: Pass 1 (delivery, decisions, bugs, process, knowledge), Pass 2 (what got invalidated), Pass 3 (currency
     + cleanup), trust calibration
   - Named to match the milestone(s) debriefed (e.g., `m3-debrief.md`, or `m3-m4-debrief.md` for combined sessions)

2. **Journal entry** → epic's `journal.md` or `docs/journal.md`
   - Domain learnings, gotchas, open questions — things worth preserving outside the debrief
   - Carries the date heading and refreshes the doc's `Last updated:` stamp

3. **Pattern/anti-pattern updates** → `docs/reference/patterns.md`
   - Only add patterns with high confidence and clear source

4. **CLAUDE.md updates** → project's CLAUDE.md
   - Only add rules that are durable and broadly applicable

5. **STATUS.md update** → project's STATUS.md
   - Reflect current state, what's next
   - Update the `**Last updated:**` stamp at the top — required, every debrief

6. **Memory update** → project's `docs/memory.md`
   - Additions from Pass 1.5
   - Retirements from Pass 2.4

7. **Reference-doc edits** → wherever Pass 2 found drift
   - The fixes themselves, plus refreshed `last-verified:` stamps where applicable

8. **Next session prep notes** (optional)
   - What needs to be ready before the next session
   - Holdout tests to write, environment changes, plan docs to create

### What's Next

If another milestone is ready, the natural next step is `/michi-planning`. If multiple milestones have accumulated without
a health check, `/michi-sustainability`. If the epic is complete, update STATUS.md and archive.
