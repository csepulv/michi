---
name: michi-docs
description:
  Produce reader-facing documentation from agent-facing sources — a project's living docs (README,
  PROJECT, ARCHITECTURE, STATUS) or a self-contained handoff for a feature, module, or branch. Use when
  work needs to be understood by someone who wasn't in the sessions.
---

# Michi Docs

Michi's working docs are written for an agent: dense, additive, decision-log shaped, exhaustive because
omission costs the agent context. That is the right shape while the human is in the loop. It fails at
**handoff** — when the work has to be understood by someone who wasn't in the sessions.

This skill derives the reader-facing layer. **The agent-facing sources stay as they are.** Epics, plans,
debriefs and journals are the record; they are not the deliverable, and this skill does not rewrite them.

**The gap this fills:** an engineer joining the project, a teammate receiving a module, a reviewer picking
up a branch. They need to know what the thing is, what it must do, what constrains it, and where to start
reading — in that order. The epics answer none of those questions first.

**Principles served:** Progressive Detail — size the document to its audience and moment. Essential,
Incidental, and Noise — the operator's trust calibration is essential to the operator and noise to a
newcomer. Clarify before Asserting — every claim about the system gets checked against the system.
See `references/principles.md` and `references/docs-structure.md`.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there
take priority over this skill's defaults.

## Targets

**The target decides the output shape.** Ask for it if the invocation doesn't say.

```
/michi-docs project              → the living project docs
/michi-docs scope <thing>        → a self-contained handoff artifact
/michi-docs audit                → diagnose only; change nothing
```

| target | what it produces | touches root docs? |
|---|---|---|
| **project** | README · PROJECT.md · ARCHITECTURE.md · STATUS.md, promoted in place | **yes** |
| **scope** | a new standalone artifact for a feature / module / branch / epic | **no** |
| **audit** | a findings report — the failure modes present, what's stale, what's contradictory | no |

**At the scope target, ask who the reader is — it changes the rules.**

| | **internal handoff** | **external share** |
|---|---|---|
| reader | a teammate with repo access | outside the team or the org |
| repo paths | **keep them** — the reading path is the most useful thing in the doc | **none.** Inline the fact or drop it |
| internal identifiers (`§2.48b`, `M19`) | drop from the body; a named doc is fine | drop entirely |
| "we" / "our" | fine | rewrite to third person |
| provenance block | brief | mandatory, and marked internal |

Getting this backwards is a real cost in both directions: stripping paths from an internal handoff removes
its most useful section, and leaving them in an external one makes the doc unusable to the reader it was
written for.

**Prefer promoting over emitting.** A new parallel doc is a second copy, and second copies drift and then
mislead. At the **project** target, edit the canonical doc. Emit a new file only at the **scope** target,
where the artifact is meant to leave the repo.

## The Five Failure Modes

This is the diagnostic core. Run it against the existing docs before writing anything — at every target,
including `audit`. Most of these are greppable, which is what gives this skill verification with teeth
rather than prompt pressure.

**1 — Addressed to the operator.** *"Three criteria **you** set." "**Your** decision." "weight a
measurement **I** hand you."* The reader isn't reading a document, they're eavesdropping on a conversation
between one human and one agent. **Fix:** third person about the system. The system has properties; nobody
in the document has a conversation.

**Check — and the distinction matters, or the check produces false positives:**

| form | verdict |
|---|---|
| second person presuming the reader made the decisions — *"the criteria **you** set"* | **fail.** Assumes the reader is the operator. |
| first person singular — *"**I** measured", "**my** explanation was withdrawn"* | **fail.** There is no "I" in a document. |
| a role word standing in for a person — *"the operator was right"* | **fail.** |
| second person addressing *any* reader — *"**you** will see", "read this first"* | **fine.** Ordinary documentation voice. |
| first person plural — *"**our** own authorship"* | **audience-dependent.** Correct for a teammate inside the org; wrong for an external share. |

**2 — The self-correction record.** The agent's revision history embedded in the artifact: *"this count was
wrong four times", "retracted the same day", "my first explanation was withdrawn"*, ⚠/⭐ annotation on every
other claim. This is high-value trust calibration **for the operator** and noise for a reader who needs to
know what the system does. **Check:** density of ⚠/⭐/**RETRACTED**/**CORRECTED** markers; any paragraph
whose subject is a previous version of the document. **Fix:** state the current fact. Where the history
changes how much to trust a number, say so once, plainly, in a caveats section — not inline on every claim.

**3 — Status where structure is needed.** *"Where does it stand"* presupposes knowing what "it" is. A
newcomer needs what-it-is → how-it's-built → what-constrains-it → where-it-stands, in that order.
**Check:** does the doc define the system before reporting on it? **Fix:** structure first, status last,
status short.

**4 — Unresolvable references.** `§2.48b`, `S114`, `M19`, `follow-ups.md`, bare repo paths. A reader
outside the repo can resolve none of them. **Check:** grep for `§`, `M<n>`, `S<n>`, `.md`, `src/`. **Fix:**
inline the fact, or drop it. If provenance matters, put it in a provenance block marked internal — not in
the body.

**5 — No landing.** No start-here, single altitude, no ordering across a multi-doc set. **Check:** can a
reader tell, in thirty seconds, which document to open first and why? **Fix:** the S layer below.

## Progressive Detail for Docs

Four layers. The reader chooses a depth; each layer is complete at its own depth and names the next.

| layer | answers | length | audience |
|---|---|---|---|
| **S** | What is this? Why does it exist? Where do I start? | ≤ 1 page | anyone, first contact |
| **M** | What must it do, how is it built, what constrains it? | a few pages | someone about to contribute |
| **L** | The deep reference — specs, per-component detail, data models | as needed | someone implementing |
| **XL** | The record — epics, plans, debriefs, journals | unbounded | posterity; reached via provenance only |

Two rules that do most of the work:

- **The S layer must stand alone and name the reading order.** It is not an index of links; it is the
  shortest true description of the system, ending with *"read these next, in this order, for these
  reasons."*
- **XL is never linked from S or M as if it were reading material.** The epics are provenance, not
  documentation. Point at them from a provenance block, once.

### Phased reading — the layers go *inside* the document

The most common failure here is subtle: a doc written at one altitude that ends with a reading list.
That is a table of contents, not progressive disclosure. The reader still has to consume the whole thing
to reach the part they needed, and the "next steps" list dumps them at the door of an L-grade spec.

**Build the phases into the artifact.** Each phase answers one question, is complete at its own depth, and
ends by naming what to read next *for that phase*. A reader stops at the phase that answered them. The
four-phase spine below generalizes across systems:

| phase | answers | for |
| --- | --- | --- |
| **What it is** | what is this, and why does it exist? | anyone who needs to talk about it |
| **What it can and can't do** | the domain model, the pipeline, the real limits | someone scoping or reviewing work |
| **How it's built** | code map, data flow, where to make changes | someone about to change it |
| **Where it stands** | status, open questions, what else is going on | someone planning or deciding |

Two things make this work rather than just look tidy:

- **Show, don't characterize.** Phase 1 of anything rule-driven, schema-driven or config-driven needs a
  **real example, quoted verbatim and annotated line by line**. One concrete artifact does more than three
  paragraphs describing its shape — and quoting it forces you to read it.
- **Phase 2 must state the limits.** What the system *cannot* express is the highest-value content in the
  whole document and the most likely to be missing, because sources describe what was built. Look
  specifically for: escape hatches and their governance, features specified but unproven, dependencies on
  something upstream, and things deliberately excluded from the model.

## Aggregation

The harder half. When the material lives across many epics, the reader needs more than a concatenation.
Four moves, taken from a working example (see `references/doc-templates.md`):

- **The through-line.** What single question does this body of work answer? Say it in a sentence, then show
  how the parts relate — a loop, a pipeline, a layering. Name it if the relationship isn't a straight line.
- **The overlap map.** The same entity recurs under different names across epics. Tabulate it: *entity ·
  how it appears in each source · the watch-out.* Without this, a reader counts one thing as three.
- **What is not comparable.** Where numbers come from different populations, say so explicitly and say
  "don't cross-add." Where two things share a name but not a meaning, separate them.
- **One honest through-line.** The conclusion the sources converge on, including the unflattering part.
  A handoff that only carries good news isn't a handoff.

## The Reader Tests

Verification before claiming done. Run all four; report the results, don't assert them.

1. **The stranger test.** Read the draft as someone who has never met this project and cannot open the
   repo. Where do you stop? That's the defect.
2. **The pronoun sweep.** Grep the draft for first- and second-person subjects. Every hit is failure mode 1
   unless it's in a quoted decision.
3. **The claim check.** Every structural claim — directories, components, counts, "currently implemented" —
   verified against the actual repo **in this session**. This is where drifted docs are caught; one project's
   README listed three packages that don't exist and omitted one that does. Recollection is not a source.
4. **The contradiction sweep.** Read the docs *against each other*. Two root docs disagreeing about what the
   repo contains is worse than either being stale alone, because the reader can't tell which to trust.
5. **The citation check — read everything you send the reader to.** Every document named in a reading path
   must have been read *in this session*, at least well enough to say truthfully what it answers and why it
   is worth the reader's time. Routing someone to an unread document is the same failure as asserting an
   unread fact, and it is worse in one way: it is invisible, because the recommendation looks identical
   whether or not you opened the file. Where you genuinely could not read a source in full, **say so in the
   provenance block** and name which claims therefore came second-hand. A reading path is a set of claims
   about documents, and claims get verified.

## Flow

**1 — Inventory, and inventory *all* of it.** List the candidate sources and their sizes. A word count per
doc is the cheapest signal there is; if the set totals 30,000 words with no entry point, that is the finding,
before you read a line.

**Enumerate the whole set before diagnosing anything — and specifically look for an existing map or index**
(`docs/README.md`, an epic `README.md`, a doc atlas). Diagnosing from the two or three documents you happened
to open produces a confident, wrong diagnosis, and the wrongness runs in the expensive direction: you
conclude something is missing and build a duplicate of what already exists. If the project has already
solved part of this, that is the most important thing to learn in step 1, not step 5.

**2 — Diagnose.** Run the five failure modes and the contradiction sweep over what exists. At the `audit`
target, stop here and report.

**3 — Determine entry state** (project target only):

- **Absent or mis-scoped** — no doc owns "what is this and what must it do", or PROJECT.md describes work
  that is no longer the main effort. → **Build.** Sweep the epics for features, use cases and constraints;
  aggregate; write the S and M layers.
- **Present but drifted** — the bones are good, the facts are stale, the docs contradict each other. →
  **Reconcile.** Check every claim against the repo, resolve contradictions, promote. Do not start over;
  a rewrite of a good drifted doc loses information the drift didn't touch.
- **Already reconciled** — someone has done this work, and the docs are current and honestly scoped. →
  **Find the actual gap, which is narrower than it first looked, and do only that.** This state is easy to
  misread as "absent" when you have read only part of the set, and misreading it produces a duplicate of
  work already done. A doc that states its own scope limits (*"this covers X only, for Y read Z"*) is a
  strong signal you are in this state, not the first one.

**4 — Agree the shape before writing.** Present the proposed layer structure and what goes where. This is a
cheap checkpoint and it prevents a large wasted draft.

**5 — Draft.** Third person, current tense, structure before status. Every claim traceable to something read
this session.

**6 — Run the reader tests.** Report results.

**7 — Promote or deliver.** Project target: edit the canonical docs, note what changed. Scope target: write
the artifact with an **audience line**, an **as-of date**, and a **provenance block marked internal**.

**8 — Capture.** What was stale, what contradicted what, what the sources couldn't answer. The gaps are a
finding in their own right — they usually mean a decision was never written down.

### Update STATUS.md (and journal)

If this produced or promoted a doc, update STATUS.md before closing out.

Follow the **STATUS reflex** in `references/ground-rules.md` — fix, subtract, stamp.

## Discipline

**Don't invent to fill a template.** If the sources never state the constraints, the answer is "the
constraints aren't written down anywhere" — surface it as a gap and ask. A confident invented requirement is
worse than an acknowledged hole, because it will be believed. This is the *Clarify before Asserting* failure
this skill is most exposed to: the template creates a slot, and the slot creates pressure to fill it.

**Don't launder uncertainty.** Making prose readable must not make a hedged finding sound settled. If a
number needed three attempts, the reader deserves to know its confidence — once, plainly, not as a
running correction log.

**Match the depth to the ask.** A request to hand off one module is not a request to document the project.

### What's Next

If the docs revealed that requirements or constraints were never written down, that's `/michi-explore` or
`/michi-planning` work, not documentation work. If the drift is broad enough to be structural, check
`/michi-sustainability` — its Doc Drift Audit and Archive Candidates sub-modes handle the repo-shaped
version of this problem.
