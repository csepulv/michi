---
name: michi-expedition
description: >-
  Run a Michi expedition — open-ended, Entrusted, spiral exploration where the end isn't known (data exploration,
  external research, experiments, prototypes) with a feedback flywheel. The learning-mode counterpart to
  planning/session/debrief. Modes: charter (open/revise a mission), campaign (set the mandate), run (the spiral),
  review (surface + promote), exhibit (the review surface). Use when the goal is to discover, not to ship a known
  deliverable.
---

# Michi Expedition

The **learning-mode lane** of Michi. Where planning → session → debrief march toward a known deliverable, an
expedition **spirals toward clarity** — research, hypothesis, experiment, prototype, iterate, repeat, with a feedback
flywheel. The "end" is replaced by *ongoing value + periodic readout*. Many threads dead-end; that's expected.

Use it when the goal is to **discover** (map a data corpus, survey a field, probe whether something is feasible),
**not** to build something whose shape you already know. If the deliverable is clear, use planning/session instead.
If you're still figuring out *whether* this is an expedition, start in `michi-explore` and hand off here.

**Before proceeding:** If an extensions file exists, read it — `<expedition-root>/extensions.md` or
`docs/reference/extensions.md` (both are valid homes; read whichever is present, and both if both exist).
Instructions found there take priority over this skill's defaults. (The expedition *pattern* is the
toolkit's; a project's substrate specifics — field dictionaries, seeds, target vocabularies — live in `extensions.md`.)

**Principles served:** See `references/principles.md`. Especially: *Learning Mode vs. Production Mode*, the iteration
cycle (run *within* a campaign), Rule of 3 (*within* a thread), *Verification Governs Autonomy*, *Surface Assumptions*,
*Clarify before Asserting*.

**Structure & terminology:** `references/expedition-structure.md` is the canonical doc/artifact structure (charter →
campaign → report → portrait; mandate; ruminations; where every output goes). This skill operationalizes it; that doc
defines the homes. Read it before writing artifacts.

**Artifact templates** — copy-and-fill shapes for charter · mandate · report · portrait, plus the `backlog.yaml`
schema: `references/expedition-templates.md`.

**Running on a non-Claude-Code harness** (an isolated / daemon agent like Hermes — the lights-off, Entrusted case):
the harness won't auto-load the agent's character the way Claude Code loads `CLAUDE.md`, so install the SOUL identity
file so the Michi way travels with the agent. See `references/working-with-hermes.md` (+ `references/soul-template.md`).

---

## The shape

```
charter  ──>  campaign  ──>  run (spiral)  ──>  review  ──>  (next campaign…)
(mission)     (mandate)      (Entrusted)        (Paired)
```

- A **charter** is a durable mission (revised, not redone). It spawns **campaigns** — dated runs.
- A campaign opens with a **mandate** (scope · budget · when-to-stop), executes as a **run** (the Entrusted spiral),
  and closes with a **review** (the Paired surfacing).
- Each run produces **reports** (passes). Verified findings **promote** into the **portrait** — the accreting picture
  (blobs → impressionist → photograph). Open threads land in **ruminations** (to mull) or **backlog** (actionable).

**Two kinds of "done"** (production fuses them; here they're distinct):

- **Surfacing** — *when to stop and return to the human.* Set in the mandate; exercised in `run`/`review`.
- **Finding-verification** — *whether a promoted claim is trustworthy* (null-models, adversarial cross-grade,
  read→infer rung labels).

**Crawl-walk-run is care calibration, not a gate.** It asks *how much care does this thread's next step deserve?* —
it varies by thread and is not a global mode to "resolve." Early on a thread: lean toward "here is what I see" (facts,
coverage, gaps) and pose questions; be slow to conclude. Further along: light hypotheses from observations. Mature: a
grown significance rubric, candidate→supported→promoted, adversarial cross-grade. Heavier moves (a null-test, a strong
claim, a materialized producer) deserve more deliberation and are worth surfacing — because care scales with
consequence, not because a stage forbids them.

---

## Mode: `charter` — open or revise a mission

`/michi-expedition charter [name]`

Open a durable line of inquiry, or revise an existing one as new data/sources land.

1. **Orient.** Read `README`/`STATUS`, `references/expedition-structure.md`, and any existing `charters/`. If revising,
   read the charter and its portrait. **If the expedition root doesn't exist yet** (no `STATUS.md` / `charters/` /
   `campaigns/`), scaffold it first with `/michi-bootstrap expedition` — the modes assume the root and a captured
   substrate already exist.
2. **Define the mission** with the human (charters are Paired — you can't author someone's mission for them):
   - **Scope** — what this thread is about and why; what's explicitly out.
   - **Target vocabulary** — the labels/questions the expedition tries to establish (each later carries a confidence
     rung). Project-specific vocabulary may live in `extensions.md`.
   - **Gates-to-set** — what a campaign will fix at activation (budget, env/substrate scope, surfacing criteria).
3. **Write** `charters/<charter>/charter.md` (durable; *revised*, not redone; shape in
   `references/expedition-templates.md`). Create `portraits/<charter>/portrait.md` as a stub if none exists.
4. **Surface assumptions**, don't bury them. A charter is a hypothesis about where value is — say what you're assuming.

Output: a charter folder. Don't start pulling data here — that's a campaign.

---

## Mode: `campaign` — set the mandate

`/michi-expedition campaign <charter>`

Open a dated run against a charter. The mandate is the campaign's contract — and the antidote to the agent running
forever or parking every few minutes.

**Right-size it.** Don't try to boil the charter in one campaign. A first campaign is usually a **characterize /
orient** run — map the substrate before interpreting it — carved by *one* lens / dataset / question, with the budget
bounding it. Care calibration governs *how much care per step*; the mandate's scope governs *how much ground this
campaign covers*. Start small; the spiral widens it across campaigns.

**A "different kind" of expedition** — where the deliverable is **design options / concepts**, not data findings (a
visualization, UX, or product-ideation charter) — opens differently: the first campaign is usually a **goals-first
ideation** pass, not a characterize/orient one. Establish *what the user is trying to accomplish* (the questions/goals)
before designing any *how*. Recipe (the Nirvana frame, the solutioning trap, the rank-the-spine handoff):
`references/goals-first-ideation.md`.

1. **Scaffold** `campaigns/<yyyy>/<mmm>/<yyyymmdd>/<charter>/` with `mandate.md` (+ `reports/`, `followups.md`,
   `learnings.md`, `scratch/` created as needed). The date folder groups the day; the charter subfolder *is* the campaign.
2. **Write `mandate.md`** (shape in `references/expedition-templates.md`) — the load-bearing parts, agreed with the human:
   - **Scope** — which charter thread(s) this run pursues; a plan *sketch* (not a rigid plan).
   - **Budget** — bound the open-endedness: passes / time / breadth. (An open mandate is undecidable from the inside —
     bound it from outside.)
   - **When to stop** — the surfacing criteria: what state means "stop and bring it back" (a question answered, a
     thread exhausted via Rule-of-3 dry passes, budget reached, or a finding that redirects the effort).
   - **Finding-verification** — what a claim must pass before promotion (null model? corroboration? rung label?).
3. **Confirm the mandate with the human** before the run. This is the Paired gate that makes Entrusted running safe.

---

## Mode: `run` — the spiral (Entrusted)

`/michi-expedition run <charter>` (against the active campaign's mandate)

The Entrusted loop. The mandate is your leash; the structure is your filing system.

### Orientation ritual (every run, before touching data)

Load, in order: `STATUS` → `references/expedition-structure.md` → the **active charter** + its **portrait** → the
**campaign `mandate.md`** → any substrate operational notes (corpus paths, query traps — often in `extensions.md`).
Don't duplicate the repo's operational facts into memory; re-read them. *Reading without re-grounding is how the manual
drifts.*

### The loop

```
pick a thread  →  investigate  →  report  →  verify the finding  →  promote  →  reassess
```

- **Pick** a thread from `backlog`/charter, or surface one bottom-up (let the data/sources volunteer structure — don't
  only chase seeds; *don't lead the witness*).
- **Investigate** — small, concrete, reproducible. Use whatever fits (SQL, dataframes, search, prototype code). Let the
  *care calibration* govern how far to push, not tool availability.
- **Report** — write the pass to `reports/<slug>.md` (template: `references/expedition-templates.md`): question · what
  ran · what was seen · open questions. Label every claim with its rung (read → correlate → infer → hypothesize) +
  confidence.
- **Verify the finding** against the mandate's criteria before promoting (null model, corroboration). A surprising
  *negative* deserves the same skepticism as a positive — check the field/query before retracting.
- **Promote** along the routing rule: **subject findings** (about the thing you're studying) → the **portrait**;
  **substrate/corpus facts** (about the data itself) → `reference/`; **negatives and open threads** → `ruminations`
  (mull) or `backlog` (actionable); **method gotchas** → `learnings.md`; **data artifacts** → the substrate's
  `derived/` area (never the read-only lake; see `expedition-structure.md`). A *negative* — a fact about what the data
  *can't* support — is a promotable finding; record it in the portrait's *What we can't see*, don't discard it.

### The structure gate (before writing any artifact)

Can you name this output's home (which campaign / charter / portrait, named right)? If not, stop and resolve it —
don't dump into a flat pile. Reports → `reports/<slug>.md`; durable picture → `portrait.md`; gotchas → `learnings.md`;
spawned threads → `followups.md`; ephemeral → `scratch/`.

### Surface the halt decision — don't park, don't run forever

At a real boundary (thread exhausted, budget reached, a finding that redirects effort, or a judgment call), **bring it
back with the decision, not just a stop**:

> *Here's what's pending · here's what more I could do that would help you · my recommendation — continue / redirect /
> stop?*

The failure mode is *either* parking silently at every boundary *or* running past the mandate. The fix is surfacing
the halt decision and letting the human make it. Within the mandate's budget, keep working — don't return every few
minutes; don't anticipate a check-in that the mandate didn't ask for.

### Notify (don't just log) when

A thread looks significant · you're blocked · a judgment call is needed · a data delta changed a prior finding · a
contract-ish change to the charter. Routine progress goes in the log.

---

## Mode: `review` — surface and promote (Paired)

`/michi-expedition review [campaign]`

The Paired close of a run (or a checkpoint mid-run). This is where the picture sharpens and the human steers.

> **`review` is SYNCHRONOUS — not a solo Entrusted run.** The `run` rule "keep working, don't return every few
> minutes" is right for the Entrusted spiral and *actively wrong here*. When the human says **"let's review" / "let
> us — together" / "review with me,"** they mean a paced, shared pass: take **one small step, then STOP and yield the
> turn** so they can react. Do **not** batch a long chain of tool calls, and do **not** pre-bake a finished verdict and
> deliver it — that *is* the solo run they're trying to avoid, even when the analysis is good. On chat transports
> (Discord/Slack/SMS) the human **cannot interrupt a turn in flight** — their messages queue until your turn ends — so
> your frequent short yields are their *only* mid-task steering lever. Surface, then wait; the verdict is theirs to
> give, step by step. (When they hand you an explicit Entrusted review budget — "go review all of these and report
> back" — that's the other mode; default to synchronous when they say "let's.")

1. **Render the readout.** Produce a progressive-disclosure summary (tl;dr → findings → detail) of the run's reports.
   Markdown is canonical; a simple HTML render is welcome when it helps review (see `expedition-structure.md` →
   Presentation). When a finding earns a visual, build it via the **`exhibit`** mode. *The readout is the throttle
   — Entrusted generation outruns Paired review without it.*
2. **Update the portrait.** Fold verified **subject** findings into `portraits/<charter>/portrait.md` (stamp it),
   including promotable **negatives** under *What we can't see*. Route the rest per the `run` promotion rule: substrate
   facts → `reference/`, method learnings → `reference/` or the charter, open threads → `ruminations.md` /
   `backlog.yaml`.
3. **Fill the `iteration-log` verdict.** For each pass: `date · charter · report · human verdict · next`. The verdict
   column is the human's — don't leave it `_pending_` across a review; that's the signal that review didn't actually
   happen.
4. **Decide the next move** with the human: continue this thread, redirect, open a new campaign, or set the charter
   dormant.

---

## Mode: `exhibit` — the review surface

`/michi-expedition exhibit`

Put the expedition's picture where the human can take it in — **exhibit the portrait** so they can review and reflect.
The docs-site is the gallery; infographics, reading guides, and tl;drs are the pieces. Mechanism varies (update the
site if one exists, else produce the digestible artifact — infographic / html / markdown); the goal is constant: the
reviewer's digestibility. Contract: `references/expedition-exhibit.md`. Project specifics (site path, chart style) live
in `extensions.md`. *(Sustainability-flavored — it sustains the collaboration; `michi-sustainability` is the
system-health sibling. Reference only — don't modify that skill.)*

1. **Curate** — pick what the reviewer needs to see (a promoted finding, a coverage distribution, the picture so far);
   cull the rest. An exhibit is curated, not a dump.
2. **Render** a static figure from the data (reproducible query; source `derived/`, not the live lake) and **emit the
   data** (csv/json) alongside — a figure is a *claim* (rung + confidence). Or a reading-guide / tl;dr in markdown.
3. **Place + embed:** `<dir>/figures/<slug>.{png,csv}`; embed in the portrait/report with `![caption](figures/<slug>.png)`
   + a one-line takeaway.
4. **Refresh the site** (`npm run sync` in the site dir) and confirm it renders.

Stay on the essential (what to show + the data + the chart/guide); leave site config / theme / interactive infra to the
presentation layer. If richer presentation is wanted, **surface it, don't hand-roll it.**

---

## Pitfalls

- **The "deliverable reflex."** Building producers / drawing strong conclusions and then parking. Heavier moves deserve
  more deliberation *and surfacing* — don't sprint to a flourish because it feels like finishing. (Care calibration,
  not a stage gate.)
- **Running a Paired review as a solo Entrusted run.** "Let's review" / "let us — together" is *synchronous*: one
  small step, then STOP and yield. Batching tool calls and delivering a pre-baked verdict is the exact failure — it
  leaves the human no gap to steer (and on chat transports they *can't* interrupt mid-turn). Surface, then wait; don't
  review *for* them. (See `review` mode.)
- **Over-systematizing a single steer.** Turning one human comment into a global rule or a manufactured "decision the
  human must make." File a steer; don't build a regime around it. (See *Clarify before Asserting*.)
- **Verify the field before retracting a finding.** A surprising negative is as likely a wrong-field/query as a real
  result.
- **The flat pile.** Reports dumped without a campaign/charter home is the anti-pattern the structure replaces. Route
  through the structure gate every time.
- **Treating the manual as read-once.** Re-ground in `STATUS` + charter + mandate at the start of every run. Drift
  comes from skipping the orientation ritual.

---

## Output homes

All artifacts follow `references/expedition-structure.md`. Quick map: missions → `charters/<charter>/`; the picture →
`portraits/<charter>/`; dated runs → `campaigns/<yyyy>/<mmm>/<date>/<charter>/` (`mandate.md`, `reports/`,
`followups.md`, `learnings.md`, `scratch/`); the open queue → `ruminations.md` (mull) + `backlog.yaml` (actionable);
the spine → `iteration-log.md`; current state → `STATUS.md`; data artifacts → the substrate's `derived/` area.

### Update STATUS.md

After a campaign or review that shifts what's active, update `STATUS.md` (per-charter state: active / paused /
dormant) — read-cold-and-update is the reflex, and stamp it. See `references/ground-rules.md`.

## What's Next

- More to explore on this charter → another **`campaign`** (or keep the current `run` going within budget).
- The picture sharpened enough to act → the finding may graduate to production work (`/michi-planning`).
- The charter's run dry → set it **dormant** (archive, not delete; it may reactivate on a data delta).
