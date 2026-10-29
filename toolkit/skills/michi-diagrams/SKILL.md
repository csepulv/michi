---
name: michi-diagrams
description: >-
  Draw Mermaid diagrams for project documentation, design docs, READMEs, specs
  and architecture pages that will be viewed on GitHub and in IDE markdown
  previews (VS Code, JetBrains, Obsidian). Use this whenever a document needs a
  figure of a pipeline, architecture, hand-off, decision flow, state lifecycle,
  data model, sequence of calls, plan or timeline — including when the user
  says "add a diagram", "visualize this", "draw the flow", "show how X works",
  or references a figure that is missing. Also use it when another skill is
  writing a design doc or spec and needs figures, or when an existing Mermaid
  block renders badly, looks wrong in dark mode, or breaks on GitHub. Produces
  Mermaid source that renders identically on GitHub light/dark and in IDEs,
  rendered and inspected before delivery.
---

# Mermaid diagrams for documentation

The job: turn facts in a document into a figure that shows a relationship the
prose can only describe — who hands off to whom, where a record goes when it is
rejected, which checks gate a release, what is shared, what loops back.

Two things decide whether the figure is any good. It has to be **true to the
source**, and it has to **render the same everywhere the document will be
read**. Everything below serves one of those two.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there
take priority over this skill's defaults.

**Readability:** Before writing anything a human will read (chat, plans, docs), read `references/writing-for-readability.md`.

**Rendering** uses `mmdc` from PATH when it is installed; otherwise `scripts/render.sh` runs it through `npx`, which
needs Node 22.13 or later. The first `npx` run downloads the package and a headless browser.

## Workflow

1. **Find the relationship.** Read the source. Name, in one sentence, the one
   thing the reader should see that they cannot get from a bullet list. If you
   cannot name it, a diagram is not the right tool — say so.
2. **Fix the facts.** List the components, edges and boundaries you will draw
   and where each comes from in the source. Nothing goes on the figure that is
   not in that list. See *Source of truth* below.
3. **Pick the smallest diagram type that fits** (table below). Default to
   `flowchart`; reach for the others when their grammar matches the meaning.
4. **Draft** using the visual grammar in `references/visual-grammar.md`:
   shapes carry one meaning each, solid vs dotted edges mean something, groups
   are real boundaries, labels stay short.
5. **Render both modes and look at the result.** Run
   `scripts/render.sh <file.mmd>`; it writes a light and a dark PNG. Open both.
   Fix what you see — clipped labels, a collapsed subgraph, a loop that
   inverted the layout, text unreadable on dark — using the tactics in
   `references/layout-and-renderers.md`. Re-render. Repeat until clean.
6. **Deliver** as a fenced ```` ```mermaid ```` block in the document (or a
   `.mmd` file if asked), followed by a caption of **one sentence** that tells
   the reader what to notice ("Solid arrows are the request path; the No
   branch returns to intake."). Omissions, inferences and the edge convention,
   if they need saying, go in a short note *after* the caption, not inside it —
   a caption that runs to a paragraph is prose the figure failed to carry.
   Say "rendered and inspected" only if you did; otherwise "syntax reviewed".

## Source of truth

A figure that is beautiful and wrong is worse than no figure. A reader will
trust the picture over the prose.

- Draw only what the source states. A document that says "the shape decides
  where a sighting is emitted, not the trigger" gets a decision node labelled
  with that sentence, not a tidy linear pipeline that contradicts it.
- If the source supplies real names — endpoints, field names, event names,
  thresholds — use them. They are what makes a figure teach rather than label.
- If something is implied but not stated, draw it dotted and say so in the
  caption. If a component is referenced but undefined, suffix its label with
  `?`. Never promote an inference to a solid edge.
- When another skill or agent hands you an analysed model, treat it as
  authoritative. Reorganise it visually; do not re-derive or extend it.
- Leave a relationship out rather than invent one to make the picture look
  complete. A gap is honest; a fabricated arrow is not.

## Choosing the diagram type

| The reader needs to see | Type | Notes |
| --- | --- | --- |
| steps, branches, hand-offs, data flow, architecture | `flowchart` | the default; `LR` for pipelines, `TB` for branching processes |
| who sends what to whom over time, retries, cache hits | `sequenceDiagram` | `alt`/`loop`/`par` blocks around real messages |
| a lifecycle with stages that have internal states | `stateDiagram-v2` | composite states for "in review" with sub-states |
| tables, keys, how many of A per B | `erDiagram` | a join entity for every many-to-many |
| what depends on what, what is critical, when things can overlap | `gantt` | `after`, `crit`, `milestone` |
| a plan or hierarchy with gates and open questions | `mindmap` | shape vocabulary: `[ ]` work, `{{ }}` gate, `) (` open question |
| classes and their relations | `classDiagram` | only when the source is actually OO |

Per-type syntax, worked examples and the traps specific to each are in
`references/diagram-types.md`. Read the section for the type you chose.

## Renderer rules (non-negotiable for the GitHub + IDE target)

GitHub, VS Code, JetBrains and Obsidian each run their own Mermaid build with
their own theme, and the reader picks light or dark. The diagram must carry
everything it needs and assume nothing about the host.

- **No `%%{init: …}%%` directives and no `---config---` frontmatter.** They
  override the host theme, break GitHub dark mode, and are stripped or ignored
  by some renderers. Theming goes in `classDef`, nowhere else.
- **No ELK layout.** GitHub's Mermaid does not ship it, so `layout: elk` or
  `defaultRenderer: elk` silently falls back to dagre and the layout you
  inspected is not the one the reader gets. If dagre fights you, restructure
  the graph (see layout tactics); do not change renderer.
- **Every `classDef` sets `fill`, `stroke` and `color`.** Omitting `color`
  hands text colour to the host theme: white text on a pastel fill in dark
  mode. Use medium pastels with dark text; stroke darker than fill.
- **`flowchart`, never `graph`.** `graph` lacks subgraph direction and newer
  shapes.
- **Line breaks are `<br>`** inside a quoted label. `\n` renders literally.
- **Quote any label with punctuation** — `["Send (optional)"]`. `end` as a
  bare node label terminates a block; quote it.
- **No `;` in sequence-diagram message text** — it is a statement separator
  there. Reword or use `#59;`.

The full list, with the reason behind each and the ones that only bite on
one renderer, is in `references/layout-and-renderers.md`.

## Styling

Colour describes a *category of responsibility* (automated / human / terminal
/ exception), not decoration. Three or four `classDef`s per diagram; the same
colour means the same thing in every figure of the same document. Shape
describes the *kind of node* (process / store / decision / terminal). Keep the
two axes separate so that a human decision and a human action can share a
colour and differ in shape. Never let colour be the only carrier of a meaning
— a reader on a monochrome print or a screen reader must still get it from
the label or the shape.

## Keep it readable

- One idea per diagram. When the figure needs more than ~15 nodes, split into
  an overview (groups and their hand-offs) and one detail figure per group.
  Split; never merge. Two things the source lists separately are two nodes —
  collapsing "acquire evidence" and "interpret evidence" into one box to save
  space changes what the source says.
- Labels: a few words per line, up to three lines, about 60 characters in
  total. The sentence that explains a node belongs in the caption or the
  surrounding prose, not inside the box. If a label needs a clause, the
  figure has absorbed prose that should stay prose.
- Shapes mean one thing each: rectangle = a step or component, cylinder = a
  store, diamond = a decision with at least two labelled exits, stadium = where
  a flow starts or ends. A component that "decides" is still a rectangle unless
  the figure shows its alternatives leaving it. Any other shape needs its
  meaning stated in the caption.
- The failure or rejection path is drawn as deliberately as the happy path.
- When several things are alternatives (parallel checks, actions a runner may
  pick from), draw them as siblings with the same edge into each from the
  thing that chooses — the fan-out is the point. One edge to the group box
  hides it.
- Group only by a real boundary — owner, phase, service, trust zone. A group
  that exists to tidy the layout misleads.

## Before you deliver — checklist

Facts
- every node and edge traceable to the source; inferred ones dotted and noted
- real names used where the source has them
- the failure / rejection / loop-back path present

Rendering
- rendered with `scripts/render.sh`; both PNGs opened and inspected
- no `%%{init}`, no config frontmatter, no ELK
- every `classDef` has `fill`, `stroke`, `color`
- no clipped labels, no subgraph drawn as an empty box with edges on its border

Design
- shapes used per the grammar; diamonds only where ≥ 2 labelled exits leave
  them; any extra shape explained in the caption
- solid = main path, dotted = supporting signal or inference; stated in the
  caption if a reader could read them the same way
- ≤ ~15 nodes, or split — and nothing the source lists separately was merged
- labels ≤ 3 lines and ≈ 60 characters; alternatives drawn as siblings with
  their own edges
- caption says what to notice

## References

- `references/visual-grammar.md` — shapes, edges, groups, the twelve
  techniques (phases with local direction, layered architecture, fan-in gate,
  sequence blocks, store vs transform, class vocabulary, signal edges,
  composite states, join entities, shared node, mindmap shapes, gantt
  dependencies), each with a worked example.
- `references/layout-and-renderers.md` — why dagre lays things out the way it
  does and how to steer it; the subgraph-direction trap; the GitHub/IDE
  compatibility matrix; the full pitfall list.
- `references/diagram-types.md` — per-type syntax reference and traps.
- `scripts/render.sh` — renders light + dark PNGs with `mmdc`; exits non-zero
  on a parse error so you cannot miss one.
