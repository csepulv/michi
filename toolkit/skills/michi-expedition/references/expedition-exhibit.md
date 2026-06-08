# Expedition Exhibit — the review surface

**Exhibit** = the digestible view of the expedition's picture, made for the human to **review and reflect.** The
portrait accretes (blobs → photograph); exhibiting it is putting it where the human can take it in — the docs-site is
the gallery, infographics / reading guides / tl;drs are the pieces. The **mechanism varies** (update the site if one
exists, else an infographic / html / markdown artifact); the **goal is constant** — the reviewer's
readability/digestibility. It **evolves** — start simple, grow richer.

This is **sustainability-flavored**: it sustains the *collaboration* (the human's capacity to keep up) — the
human-facing sibling of system-health sustainability. See `michi-sustainability` for the system side. *Reference only —
don't fold this into that skill; the lane is early. Sustainability informs the shape, no more.*

## Curate, don't dump

An exhibit is **curated** — you don't show everything. Cull to what the reviewer needs to see; a reading guide or a
tl;dr is as valid an exhibit as a chart. (This curation is the cull/prune that ties exhibit to sustainability.)

## The contract (what the agent produces)

A visual exhibit is a **claim** — same discipline as any finding:

- **Rung + confidence + the query** that produced it. Reproducible. Source from `derived/`, never the live read-only
  lake.
- **Static render** — PNG/SVG (matplotlib / seaborn / similar). No interactive/JS infra — static stays portable *and*
  agent-inspectable.
- **Emit the data, not just the image.** Write the underlying data (csv/json) next to the render. A PNG is a dead end;
  **data + a render is reusable** by a richer renderer later — this is what lets the exhibit get richer *without
  redoing it*.
- **Home:** `<charter-or-campaign-dir>/figures/<slug>.{png,csv}` — next to the doc that embeds it.
- **Embed:** in the portrait/report markdown — `![caption — what it shows](figures/<slug>.png)` — with a one-line
  takeaway.

(A non-visual exhibit — a reading guide, a tl;dr — is just markdown in the relevant doc. Same goal.)

## Where it appears (the docs site)

The docs site (Astro + Starlight; the project's `extensions.md` has the path) renders docs + figures. After
adding/updating, refresh it: `npm run sync` (re-copies content + figures; a running `npm run dev` hot-reloads) or
`npm run build` (static). The site copies `figures/*` automatically.

## Keep the boundary (essential vs. incidental)

- **The agent owns the essential:** *what to show* + the data + the chart/guide + the caption.
- **Not the agent's job (incidental):** site config, theme/styling, embedding mechanics, interactive infra. If a
  *richer* presentation is wanted (interactive, composed dashboards, a component layer), that's a presentation-layer
  build — **surface it, don't hand-roll it** per exhibit.

## Evolve deliberately

Start simple. Richness accrues on the **presentation side** over time — always serving the human's review-and-reflect,
never decoration for its own sake.
