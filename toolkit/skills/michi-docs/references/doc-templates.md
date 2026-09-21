# Doc Templates

Shapes for the reader-facing layer. **These are shapes, not forms to fill.** A section with nothing true to
say in it gets deleted, not padded. See the *Don't invent to fill a template* discipline in `SKILL.md`.

---

## The S Layer (start-here)

Goes in `README.md` at the project target, or at the top of the handoff artifact at the scope target.
One page. It must stand alone — a reader who reads only this should be able to describe the system
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
- If the project has one, the S layer is where the vocabulary a reader can't guess gets defined —
  four to eight terms, maximum. More than that means the reader needs the M layer.

---

## The M Layer (the working picture)

Three questions, three homes. Keep them separate — mixing them is what makes the epics unreadable.

### `PROJECT.md` — what it must do

Purpose · users and their goals · features / use cases · success criteria · **constraints (NFRs)** ·
related projects.

The constraints section is the one most often missing and most often needed. It covers what the system
must respect regardless of feature: language and runtime, deployment shape, data ownership and
directionality, performance and scale targets, security and auth, compliance, and any "never do X" rule
the project has adopted. **When constraints exist only as scattered decisions inside epics, aggregating
them here is the single highest-value thing this skill does.**

Watch for the failure this doc is most prone to: it gets written at project start and never re-scoped when
the main effort moves. If the roadmap table lists an effort that is no longer what the project is about,
the doc is describing a different project.

### `ARCHITECTURE.md` — how it's built

Component by component. For each: what it is, what it owns, what it talks to, and the gotchas someone will
otherwise rediscover. Section-level `**last-verified:** YYYY-MM-DD` stamps where the area moves fast.

### `STATUS.md` — where it stands

Short. Current state, active work, what's next. **Not a changelog** — reverse-chronological accumulation is
how this doc becomes unreadable in both directions, for agents and humans alike. When an effort closes,
replace its block with one line and a pointer to the epic.

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

## Re-Derivation

Every derived artifact is a second copy, and second copies drift and then mislead. Three mitigations, in
order of preference:

1. **Promote instead of deriving.** At the project target, edit the canonical doc. There is no second copy
   to drift.
2. **Date and scope it.** At the scope target, the as-of line plus the provenance block make staleness
   visible at the moment of reading.
3. **Say what wins.** Where a derived doc restates something a living doc owns, say which one is
   authoritative on disagreement — and prefer re-deriving the copy over patching it.

A dated snapshot that disagrees with the living record should be **re-derived or deleted, not patched.**
Patching is how two documents become two sources of truth.
