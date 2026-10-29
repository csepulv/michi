# Layout and renderers

## Why the layout looks like that

Mermaid's default engine (dagre) assigns every node a rank from the order it
meets nodes and edges in the source, then places ranks top-to-bottom (`TB`) or
left-to-right (`LR`). You cannot place anything by coordinate. Everything you
can do to improve a layout is one of these:

| Tactic | What it does | When |
| --- | --- | --- |
| **Declare in reading order** | earlier declarations get earlier ranks | always; scattered declarations scatter the layout |
| **Keep a group's nodes adjacent in source** | related nodes land together | always |
| **Switch `TB` ↔ `LR`** | often removes most crossings on its own | first thing to try when edges cross |
| **Wrap a phase in a subgraph** | constrains placement, labels the boundary | when a region is a real boundary |
| **Remove the loop-back edge** from an overview | a single back-edge can invert the whole layout | when a `commit → feed` or `revise → load` arrow flips the figure upside down; state the loop in the caption, or draw the cycle in a `stateDiagram` |
| **Insert a dispatcher node** | flattens a 5+-edge fan-out | when one node sprays edges everywhere |
| **Split into overview + detail** | two readable figures instead of one tall one | past ~15 nodes, or when the PNG is taller than 3× its width |

Try these in order. If after that the layout still fights you, the figure is
carrying two ideas — split it.

## Things that fail silently on the target renderers

The document will be read on GitHub (light and dark) and in IDE previews.
Each runs its own Mermaid build. These are the differences that matter.

| Do not | Because | Instead |
| --- | --- | --- |
| `%%{init: {...}}%%` or `---\nconfig:\n---` | overrides the host theme; breaks GitHub dark mode; some renderers strip it | `classDef` per node category |
| `layout: elk` / `defaultRenderer: elk` | GitHub does not ship ELK; falls back to dagre and the figure you inspected is not what ships | restructure using the tactics above |
| `classDef` without `color:` | text colour comes from the host theme: light text on your pastel fill in dark mode | `fill`, `stroke` and `color` on every `classDef` |
| very light fills (`#f8fafc`) or very dark fills (`#1e293b`) | vanish against one of the two backgrounds | medium pastels: `#dbeafe` `#dcfce7` `#fef3c7` `#fee2e2` `#ede9fe` `#ffedd5`, dark text `#1e293b`-ish |
| inline `style nodeId fill:...` | same dark-mode problem, and unmaintainable | `classDef` + `class` |
| `graph TD` | legacy; no subgraph `direction`, fewer shapes | `flowchart TD` |
| `\n` in a label | renders as the two characters | `<br>` inside a quoted label |
| `<br/>` | fails in some contexts (timeline details) | `<br>` |
| HTML tags other than `<br>` | inconsistent; some renderers strip, some crash | plain text |
| icons (`fa:` / `@{ icon }`) | need a font or icon pack the host may not load | words |
| `@{ shape: ... }` new shapes | need Mermaid ≥ 11.3; some IDE previews are older | the classic shape syntax |

## Parser traps

| Trap | Symptom | Fix |
| --- | --- | --- |
| unquoted `( ) [ ] { } : ; # @ / < > \| "` in a label | parse error, often far from the real line | `["quoted label"]` — when in doubt, quote |
| a node whose whole label is `end` | treated as a block terminator | `x["end"]` or capitalise |
| `end` as the *last word* of a sequence note or message | same | reword |
| `;` inside sequence message or note text | statement separator — the rest of the line is parsed as a new statement | reword or `#59;` |
| node id starting with `o` or `x` followed by `--` | parsed as a circle- or cross-ended edge | use a longer id |
| underscore in a label (v11) | renders as italic | quote the label |
| `subgraph My Title` with spaces and no id | works but you cannot link to it | `subgraph id["My Title"]` |
| linking to a subgraph **and** a node nested inside it | parse error | link to nodes only, or to the outer subgraph only |
| missing `end` on a nested subgraph / `alt` / `loop` / `par` | parse error | count them |
| apostrophe in a sequence participant alias | "unclosed (" error | drop it |
| `-.->` written `-.>` | parse error | three characters in the middle: `-.->` |

## The subgraph-direction trap

A subgraph with `direction LR` inside a `flowchart TB` looks like it should lay
its contents out horizontally. It does — **only if no node inside has an edge
to a node outside**. One cross-boundary edge and the subgraph inherits the
parent direction. Worse: with nested subgraphs and crossing edges, dagre may
draw the subgraph as a single empty box with edges terminating on its border
and the contents stacked somewhere else.

So:

- local `direction` + group→group edges: works
- local `direction` + node→node edges across the boundary: direction ignored
- nested subgraphs + edges crossing two levels: expect a collapsed box

If you see a collapsed box, drop the inner `direction` and the nesting, or
promote the cross-boundary edges to group→group.

## Sequence diagrams

- Declare every participant at the top, in order of first interaction,
  initiator leftmost. Mermaid otherwise infers the order from first
  appearance, which usually zigzags.
- `autonumber` on any technical flow with more than three messages; it makes
  "at step 4" possible in the prose.
- Activations (`+`/`-`) are tracked linearly. Deactivating in both branches of
  an `alt` raises "inactive participant". Keep activation inside one branch or
  outside the block.
- Three levels of nested `alt`/`loop` is the limit for readability. Split.
- Notes: `Note over A,B: text`. A `Note right of` on the rightmost
  participant clips.

## Rendering locally

`scripts/render.sh file.mmd` writes `file.light.png` (white background) and
`file.dark.png` (GitHub dark background, Mermaid dark theme) and exits
non-zero on a parse error. Open both PNGs. What to look for:

- clipped or overlapping labels
- a subgraph drawn as an empty box with edges on its border
- a figure much taller than it is wide (split it)
- edge labels sitting on top of each other
- text you cannot read on the dark PNG (a `classDef` missing `color`)
- a layout that implies an order the source does not state

Note the local `mmdc` may be newer than GitHub's build. Syntax that renders
locally but is newer than ~Mermaid 10.x may not render there; the "do not"
table above lists the known cases.

## Attribution

Parser traps are collected from testing and from the MIT-licensed
awesome-skills/mermaid-syntax-skill, whose SKILL.md documents several of them
(subgraph direction inheritance, nested-subgraph linking, the `;` separator,
`o`/`x` ids, v11 markdown-by-default).
