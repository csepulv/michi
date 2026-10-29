# Doc Templates

Shapes for the `scope` and `epic` targets. The `project` target's templates are in
`references/project-templates.md`. **These are shapes, not forms to fill.** A section with nothing true to
say in it gets deleted, not padded. See the *Don't invent to fill a template* discipline in `SKILL.md`.

---

## The S Layer (start-here)

Goes at the top of the handoff artifact at the scope target. One page. It must stand alone — a reader who reads only this should be able to describe the system
correctly, if shallowly.

```markdown
# <Name>

<One paragraph: what this is and what it's for. No jargon, or jargon defined in the same sentence.>

## What problem it solves

<Two to four sentences. The situation before, and what changes.>

## How it fits together

<The shortest true structural description — three to six components and how they relate.
A small diagram if the relationship isn't a straight line. Not a file tree.>

## Where to start

| read | for | size |
|---|---|---|
| `<doc>` | <the question it answers> | S / M / L |
| `<doc>` | <the question it answers> | M |

<One sentence saying which to read first and why.>
```

**Rules:**
- "Where to start" names *the question each doc answers*, not the doc's title restated.
- Epics, plans, debriefs and journals do **not** appear in this table. They are provenance.
- If the scope has one, the S layer is where the vocabulary a reader can't guess gets defined —
  four to eight terms, maximum.

---

## The Handoff Artifact (scope target)

Extracted from a working example: a two-document handoff set (`README.md` + `overview.md`) written for an
external engineering audience, which reads standalone — the shape below is its generalization.

```markdown
# <Scope> — overview

<One paragraph: what this covers and why these pieces belong together.>

**Audience:** <who this is for>.
**As-of:** <dates of the underlying sources> (compiled <date>; <live vs snapshot>).

---

## The set

| doc | the question it answers | <lead metric / key fact> |
|---|---|---|
| **<doc>** | *<question in the reader's words>* | <the number or fact that anchors it> |

**The through-line:**

<A sentence, then a small diagram if the relationship isn't linear. Name the shape —
"a loop, not a line" — when a reader would otherwise assume a pipeline.>

## Where they overlap

<Only when the material comes from multiple sources. The same entity recurs under different names;
without this table a reader counts one thing as three.>

| shared entity | in <source A> | in <source B> | the watch-out |
|---|---|---|---|
| **<entity>** | <how it appears> | <how it appears> | **one thing.** <why the repeat isn't a new item> |

## What is not comparable

<Where counts come from different populations, or two things share a name but not a meaning.
State it plainly: "these are different axes — never add or compare them directly.">

## One honest through-line

<The conclusion the sources converge on, including the unflattering part.
A handoff that only carries good news isn't a handoff.>

## Caveats

- <Snapshot vs live; what transfers across environments and what doesn't.>
- <Known weaknesses in the measurements or the coverage.>

---

**Provenance (internal — not part of the shareable doc):** <the epics, plans, scripts and data this
was derived from, and how to refresh it.>
```

**Rules:**
- **Internal identifiers (`§2.48b`, `M19`, `S114`) never appear in the body**, at either audience. Inline
  the fact or drop it.
- **Repo paths depend on the audience.** External share: none — the reader can't open the repo, so a path
  is dead weight. Internal handoff: keep them, especially in "Where to start"; a reading path without
  paths is the least useful version of the most useful section.
- The **as-of** line is mandatory. A derived doc without a date is a doc that will be trusted after it
  stops being true.
- The **provenance block** is what makes the artifact re-derivable rather than a fork. It names the
  sources and how to refresh them.

---

## The Epic Overview (epic target)

A front door for an epic, for a cold reader: anyone new to the context, including the original author after a pause.
It goes in the epic folder as `overview.md` (not `README.md`, which may be hand-made). Two variants; propose one with
a one-line reason and let the human confirm.

| Variant | For |
|---|---|
| **Epic full** | new features, strategic work, conceptual work, spikes, rebuilds |
| **Epic condensed** | maintenance, cleanup, tweaks, small features |

### Epic condensed

A few bullets to half a page.

```markdown
# <Epic name>

<One or two sentences: what this was.>

**Where it stands:** <done | open items remain | …>, as of <date>, from <the latest document read>.

## What was done
- <change, in plain words; behaviour and contract changes first>

<One line, only if something surprising changed what was done.>

## Open
- <any major open item or question>   (omit the section if none)

<Where to look, one line, if a reader might want the detail.>
```

### Epic full

About a page to several pages. At the longer end, each section is complete at its own depth, so a reader can stop
after any of them.

```markdown
# <Epic name>

<What this is: one to three plain sentences. What the epic set out to do, and what came of it.>

## The problem
<The problem and why it mattered; the constraints the work accepted.>

## Where it stands
**State:** <active | done | done, not closed | paused | superseded by <epic> | decision pending>, as of <date>, from <source>.
<What is open right now, as a short current list.>

## The process and work
<How it was approached and what was done. The story, not the step list: a reversal, how a design was found, what
testing showed. One subsection per thread if the epic held several.>

## Surprises and how it evolved
<What turned out differently than expected, and how the epic's direction, scope, or design changed along the way:
reversals, premises that didn't hold, scope that grew or was cut, milestones re-ordered, decisions that surprised.
What prompted each change.>

## Results
<What came of it: what was built or decided, findings with their numbers, premises refuted.>

## Takeaways
<Follow-ups, open questions, learnings. Key operating facts or references someone will need again, briefly or as a
pointer.>

## Related work   (only when it applies)
<Supersedes, superseded by, or reverses another epic; what carried forward.>

## Where to look
| Read | For |
|---|---|
| `<doc>` | <the question it answers> |
<Where lasting knowledge lives now, if it moved.>
```

### Rules for both variants

- **Leave out** step lists and file tables; gate results and test counts; debrief bookkeeping (trust calibration,
  interaction counts, stamp sweeps); verification artifacts; raw data and transcripts; superseded plans; the agent's
  self-correction narrative.
- **Omit an empty section; never pad it.** See *Don't invent to fill a template* in `SKILL.md`.
- **State comes from the latest evidence, not a header.** Status lines are often written before the outcome and never
  updated; where one disagrees with the evidence, say so.
- **Point, don't copy**, when knowledge was promoted to a reference doc, another repo, or a later epic.
- **Name every ID at its first mention** (`references/writing-for-readability.md`). Decision IDs collide between a
  spec and its plans.
- **A person's call is a reason.** If something was just the user's call, say so; don't invent an argument for it.

### When neither variant fits

Say so when proposing the variant, and propose the lighter answer instead of forcing one: usually, point to the
existing doc as the front door, perhaps with a one-line state added. For example, an epic that became a living
product (its front door is its maintenance doc), or a vision with no work yet (the vision doc is the summary). Which
answer fits depends on the situation; the human confirms.

---

## Re-Derivation

Every derived artifact is a second copy, and second copies drift and then mislead. Three mitigations, in
order of preference:

1. **Link instead of copying.** Where a living doc owns fast-changing content (STATUS.md, plans), link to it.
   Where a document is derived on purpose (the project overview from PROJECT.md), re-draw it on every run
   rather than editing it by hand.
2. **Date and scope it.** At the scope target, the as-of line plus the provenance block make staleness
   visible at the moment of reading.
3. **Say what wins.** Where a derived doc restates something a living doc owns, say which one is
   authoritative on disagreement — and prefer re-deriving the copy over patching it.

A dated snapshot that disagrees with the living record should be **re-derived or deleted, not patched.**
Patching is how two documents become two sources of truth.
