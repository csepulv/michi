# Expedition Structure

Reference for how a Michi **expedition** organizes its documents and artifacts. An expedition is the
**learning-mode lane** of Michi: open-ended, Entrusted, spiral exploration where the *end isn't known* —
research, hypothesis, experiment, prototype, iterate, repeat, with a feedback flywheel. It is the sibling of the
production lane (`docs-structure.md`), not a replacement.

**This doc covers structure only — how an expedition's docs and artifacts are organized and named.** The *why*
(the frame: emergent-not-convergent, the painting/promotion model, surfacing vs. finding-verification, the
process/enforcement split) lives in the epic spec; the *executable loop* (charter → campaign → run → review) lives
in the `michi-expedition` skill. This doc is the bridge between them.

Used by the `michi-expedition` skill to decide where information goes and when it's read. Inherits all of
`docs-structure.md`'s conventions (capitalization, currency stamps, archive naming, progressive file→folder,
promote-by-reference) — only the *units* and the shape of "done" differ.

---

## Terminology — the units

The unit names *are* the directory structure. The production lane and the expedition lane share a skeleton; the
names flag the mode.

| term | what it is | lifespan | production analog |
| --- | --- | --- | --- |
| **charter** | a durable mission/theme; revisited as new data/sources land | long-lived, *revised* not redone | epic |
| **campaign** | one dated run against a charter | episodic, *closes* | milestone |
| **report / finding** | one pass within a campaign: question · what ran · what was seen · open questions | per-pass | a milestone's work product |
| **portrait** | the promoted, accreting **picture** — best-current understanding of the charter's subject | long-lived, accretes | — (new to this lane) |
| **mandate** | a campaign's contract: scope · budget · **when to stop** · surfacing + verification criteria | per-campaign | plan, sharpened |
| **ruminations** | the open/murky companion to the portrait — what's unresolved, to mull (not yet actionable) | long-lived, accretes | — (new to this lane) |

`charter : campaign :: epic : milestone`. The parallel itself communicates mode. The unit name **signals the work's
shape**: "epic" connotes a definition-of-done and milestone-convergence; "charter" connotes a standing mission with
no fixed end — which is why the lane doesn't reuse "epic."

**The picture and its two companions** (keep distinct so they don't blur):

- **portrait** — what's *becoming clear* (emerging clarity; the goal-proxy that replaces "deliverable")
- **ruminations** — what's *still murky* (open questions, tensions to mull — not yet actionable)
- **backlog** — what's *actionable* (typed, status-tracked work queue)

A thread migrates: ruminations → portrait (clarified) or ruminations → backlog (became doable). A finding promotes
up the result tiers: **scratch** (ephemeral WIP) → **report** (a reviewed pass) → **portrait** (promoted clarity).
Promotion is the refinement mechanism — blobs of color → impressionist → photograph.

---

## Directory structure

Charters and portraits are **folders, not files** — they are durable, accreting, and revisited by design (the
opposite of the "might stay small" case that file-first optimizes for), so foldering them from birth avoids
file→folder migration churn. Portraits especially need a folder: the picture includes figures and HTML renders, not
just prose. Reports stay files (per-pass; they don't accrete).

```
<expedition-root>/                  in a standalone repo: expeditions/ ; in a Michi repo: docs/epics/<name>/
  STATUS.md                  current state per charter (active / paused / dormant); always-read
  iteration-log.md           the chronological spine across ALL campaigns:
                               date · charter · report · human verdict · next
  backlog.yaml               living, typed, status-tracked work queue (charter-tagged)
  ruminations.md             global open/murky companion to the portraits

  charters/
    <charter>/
      charter.md             durable mission: scope, target vocabulary, gates-to-set; links to its portrait
      reference/             (optional) charter-scoped reference — only when it earns its own space

  portraits/
    <subject>/               start per-charter; may split per-subject once a charter has crawled enough
      portrait.md            the accreting picture (promoted clarity); carries a Last-updated stamp
      (figures, HTML renders, charts)

  reference/                 global substrate facts — the DEFAULT home for reference (see Reference Scoping)

  campaigns/
    yyyy/mmm/
      <yyyymmdd>/                  one date = a day's run; groups that day's campaigns
        <charter>/                 a campaign = one charter's dated run against its charter
          mandate.md         scope · budget · WHEN TO STOP · surfacing + verification criteria (+ a plan sketch)
          reports/<slug>.md  per-pass findings (+ optional <slug>.html render; markdown stays canonical)
          followups.md       threads THIS run spawned → promote durable ones up to backlog.yaml / ruminations.md
          learnings.md       method gotchas → promote durable ones up to reference/ or the charter
          scratch/           ephemeral queries / probes (gitignorable)
```

**Data artifacts live outside the repo.** Materialized aggregates, feature tables, derived Parquet, saved charts →
a substrate-side derived area (e.g. `$CORPUS_ROOT/derived/<id>/` for a data corpus; a source vault for external
research). A report references the path; the repo holds narrative, not data.

*Example: a `characterization` charter, its dated run at `campaigns/2026/may/20260531/characterization/`, and
derived Parquet "producers" in `$CORPUS_ROOT/derived/characterizations/`.*

### How the structure answers "navigate by time vs. by topic"

| You want… | You open… |
| --- | --- |
| Everything done on a given day | `campaigns/<yyyy>/<mmm>/<date>/` — that day's campaigns, grouped |
| One campaign (a charter's dated run) | `campaigns/<yyyy>/<mmm>/<date>/<charter>/` |
| All of a charter's work, ever | `portraits/<subject>/portrait.md` — the picture + links down to each campaign |
| The chronological thread | `iteration-log.md` |
| What's active / paused / dormant | `STATUS.md` |
| What's open to explore | `ruminations.md` (murky) · `backlog.yaml` (actionable) |

Topic-first alone scatters "today" across N charters; date-first alone scatters "all of charter X" across N dates.
Carrying **both axes** — charters (theme) and campaigns (time) — with the portrait linking down and campaign docs
linking up is what keeps it navigable as it grows. One source of truth each way; no content duplicated.

---

## Reference scoping

Two tiers, **global by default.** Reference is durable substrate knowledge; campaigns are episodic — so reference
gravitates *up*, never down.

- **Global `reference/`** (default) — substrate facts true across all charters: data dictionaries, interpretation
  cautions, lookup tables, pipeline/provenance notes.
- **Charter-scoped** — durable knowledge specific to one mission (e.g. a target vocabulary). Starts *inline* in
  `charter.md`; splits to `charters/<charter>/reference/` only when it earns the space (progressive rule).
- **No campaign-level reference.** A campaign is a point in time; reference is durable. A campaign learning that
  proves durable **promotes up** to charter or global reference — same logic as promoting a finding.

---

## Presentation

The readout is the **throttle** on Entrusted autonomy: Paired review can only keep pace with Entrusted generation if
findings are cheap to review. So presentation is part of the surfacing checkpoint, not cosmetics.

- **Markdown is canonical; HTML is a render/companion.** Start with simple agent-authored HTML when a richer readout
  helps the human. Keep the markdown as the source of truth so a richer renderer can consume it later with no rework.
- **Defer the framework.** When a richer presentation is wanted, integrate an existing static-site renderer (e.g. the
  Michi internal docs browser, Astro + Starlight over the markdown) rather than inventing one.
- **Progressive disclosure in the readout itself** — tl;dr → findings → detail — so a reviewer can triage at a glance
  and drill only where needed.

---

## Agent isolation — zones (container vs. host)

When an expedition runs in an **isolated agent** (a long-running Docker container — the lights-off, Entrusted case), the
repo splits into three zones. The cut lines are an isolation boundary, not just tidiness: the agent should see its
workspace and nothing more.

| zone | what it holds | mounted into the agent? |
| --- | --- | --- |
| **Harness** | the agent's own container definition — mounts, home, process config (e.g. a `container/` definition dir) | **Never.** Mounting the agent's own config is circular and lets it edit its own escape hatch. |
| **Expedition workspace** | the expedition-root (`charters/` `campaigns/` `portraits/` …) + its site render | **Yes** — this is the agent's project. Ideally a **single mount**. |
| **Host-only** | the repo's outer identity and host-side tooling the agent doesn't use (Michi root docs, build/publish scripts) | **Never.** Out of the agent's lane; least privilege. |

Separately, the **substrate / corpus** — the data the expedition reads and the derived artifacts it writes — already
lives *outside the repo* (see "Data artifacts live outside the repo" above). It is its own mount (`$CORPUS_ROOT`),
distinct from the workspace.

**Default for a new containerized expedition: co-locate the workspace so it's one mount.** Keep the expedition-root
and its site under a single parent the agent mounts as its workspace; keep the harness and host-only material out.
The convergence target is **one workspace mount + one corpus mount**, harness and host-only zones unmounted.
Multiple ad-hoc mounts work and are a fine *starting* point while the shape is still being learned — just don't
mistake the starting point for the structure.

**Where the harness lives is a separate choice.** It can sit *inside* the subject repo (self-contained, versioned
with the project) or *beside* it (keeps the repo pure subject matter and removes the circularity outright). Both are
valid — pick per project, and lean "beside" when the repo is shared work rather than personal.

---

## Project-specifics: the extensions split

The expedition *pattern* is toolkit; a given project's *substrate details* are local, carried in the project's
`extensions.md` at the expedition root (`<expedition-root>/extensions.md`; or `docs/reference/extensions.md` in a
Michi repo) — the standard Michi extensions mechanism, read first and treated as overrides. The split:

| Lives in the toolkit (this doc + the skill) | Lives in the project's `extensions.md` (or `reference/`) |
| --- | --- |
| The units (charter/campaign/portrait/mandate/ruminations) | The substrate's field dictionary / schema |
| The directory structure + naming conventions | Seeds / lenses / framing specific to the subject |
| Reference scoping, presentation, promotion rules | The charter's target vocabulary |
| The loop and gates (in the skill) | Substrate gotchas, operational notes (corpus paths, query traps) |

*Example: the charter/campaign/portrait structure is toolkit; a corpus's field dictionary, the domain seeds, a
charter's target vocabulary, and query-engine gotchas (e.g. timestamp-unit traps) are project-local.*

Expect this split to mature as the lane is exercised across more than one project.

---

## Inherited conventions

From `docs-structure.md` — the expedition lane inherits these unchanged:

- **Capitalization signals priority.** `UPPERCASE.md` = top-tier, always-read (`STATUS.md`, `README.md`);
  lowercase = working docs scoped to a charter or campaign (`charter.md`, `mandate.md`, report slugs).
- **Currency stamps.** `STATUS.md`, each campaign `learnings.md`, and each `portrait.md` carry a top-of-doc
  `**Last updated:** YYYY-MM-DD`. Read-cold-and-update is the reflex.
- **Archive.** A finished or set-aside charter is **archived, not deleted** — moved to `archive/<name>-MMDDYY/`. In
  this lane a charter usually goes **dormant** (it may reactivate when new data/sources land), so archiving is
  reversible by intent.
- **Progressive file→folder.** The structure grows with the work — but charters and portraits are folders from birth
  (see above), because they are designed to accrete.
- **Promote by reference / one source of truth.** Findings, learnings, and reference promote *up* the tiers; the
  lower tier links to the promoted home rather than duplicating it.
