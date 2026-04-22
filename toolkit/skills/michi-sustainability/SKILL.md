---
name: michi-sustainability
description:
  Assess and maintain system health — code quality, test quality, architectural alignment, and knowledge capture. Scales
  from a brief within-milestone check to a deep between-epic review.
---

# Michi Sustainability Check

Assess and maintain long-term system health. Invoke between milestones, between epics, or whenever accumulated work
needs a step-back review. This skill is **flexible** — select from the menu based on context and scale.

**Principles served:** Sustain the system (core purpose). Iterate spirally (each check leaves the system better for the
next iteration). Surface assumptions (identify drift or unchallenged assumptions). See `references/principles.md`.

**Before proceeding:** If `docs/reference/extensions.md` exists, read this file. Instructions found there take priority over this skill's defaults.

**Multi-project repos:** If the repo has `multi-project: true` in CLAUDE.md, name the scope at session start:

- **Sub-project scope:** review code/docs/tests under `tools/<name>/` + `docs/<name>/`.
- **Umbrella (ROOT) scope:** review umbrella-level code + `docs/ROOT/` working docs + repo-root CLAUDE.md /
  PROJECT.md / STATUS.md / ARCHITECTURE.md (umbrella identity docs live at repo root).
- **Cross-sub-project health checks** (shared infra, repo-wide coding standards): span all sub-projects; findings
  promote to repo-root CLAUDE.md (as repo-wide rules) or `docs/ROOT/reference/` (as cross-project patterns).

## When to Use

| Context                | Scope                                                      | Time      |
| ---------------------- | ---------------------------------------------------------- | --------- |
| **Within a milestone** | Light — focused on work just completed                     | 10-15 min |
| **Between milestones** | Medium — accumulated work across the current epic          | 30-60 min |
| **Between epics**      | Deep — overall direction, design coherence, process health | 1-2 hours |

The session skill includes a brief sustainability step before each commit (within-milestone scope). This skill is for
broader reviews that don't fit inside a milestone's implementation flow.

## Menu

Select what's relevant. Not everything applies every time.

**Framing findings.** As you work through the menu, categorize what you find into four buckets: **done** (working as
intended), **in progress** (partial, with known next steps), **known gap** (missing, but we know it's missing), and
**unknown gap** (missing, and we only just noticed). Unknown gaps are the valuable discoveries — the ones that wouldn't
surface without deliberate review. Name them explicitly so they don't fade back into invisibility.

### Code Quality

- [ ] **Refactoring pass** — Scan recent changes for duplication, unclear naming, functions doing too many things. Does
      the code reveal its intent?
- [ ] **Readability audit** — Can someone scan this code and understand what it does and why, without reading every
      line? Are names describing intent, not mechanism?
- [ ] **Separation of concerns** — Are domain logic, orchestration, and presentation properly separated? Would you have
      to rewrite logic to use it with a different UI?
- [ ] **Dead code** — Unused imports, unreachable branches, or commented-out code from recent work?

### Test Quality

- [ ] **Mock appropriateness** — Are mocks at I/O boundaries (network, storage, timers), not between internal modules?
      Any mocks hiding real behavior?
- [ ] **Test readability** — Do test names describe behavior? Is test data human-readable (ISO dates, not epoch
      numbers)? Are expected values concrete, not regex patterns?
- [ ] **Intent vs implementation** — Do tests assert on outcomes, or on which internal methods were called? Would tests
      break if you refactored without changing behavior?
- [ ] **Coverage gaps** — Are there obvious scenarios not tested? Edge cases, error paths, integration boundaries?
- [ ] **Speed tradeoff** — Is the suite fast enough for tight feedback, but not so shallow that speed costs meaning? A
      5-10 second suite with meaningful tests beats a sub-second suite with shallow ones.

### Architectural Alignment

- [ ] **Design intent** — Does accumulated code match the intended architecture? Has design drifted in a direction that
      should be acknowledged or corrected?
- [ ] **Design evolution** — Has the work revealed that the original design should change? If so, is that captured?
- [ ] **Consistency** — Naming conventions, file organization, and patterns consistent across the codebase? Recent work
      introducing inconsistencies?
- [ ] **Cross-package coherence** — If the project spans packages, are boundaries clean? Contracts between packages
      explicit?

### Knowledge and Questions

- [ ] **Question lifecycle** — Open questions: any resolved by recent work? New ones raised? Any open too long?
- [ ] **Journal update** — Capture learnings, gotchas, discoveries in the epic's `journal.md`. What would a future
      session need to know?
- [ ] **Discussion items** — Anything to raise with the human? Add to the plan doc's `## Discussion` or the epic's
      journal.
- [ ] **Assumption check** — Planning-phase assumptions that turned out wrong? New unstated assumptions to surface?
- [ ] **Applied coding principles** — Patterns in the codebase demonstrating design judgment not yet captured in
      `docs/reference/code-style.md`? Examples: a clean what/how separation, a well-structured test showing the
      project's testing philosophy, a naming pattern revealing intent. If undocumented, a future session may not follow
      them.
- [ ] **Memory hygiene** — Review `docs/memory.md` if it exists. Memories still accurate? Anything superseded by
      CLAUDE.md rules, code-style.md, or other docs? Prune what's stale. Challenge memories that have calcified into
      unexamined rules. Keep focused on collaboration patterns — if drifting toward journal territory, trim.

### Direction (between-epic scope)

- [ ] **Overall trajectory** — Does the direction still make sense? Has anything changed that should shift priorities?
- [ ] **Principles alignment** — Living the north stars (minimize latency, sustain the system) or drifting?
- [ ] **Knowledge base health** — Docs current? Anything important missing? Stale docs misleading?
- [ ] **Process retrospective** — What should change about how the next epic is run? Skill updates, template changes,
      verification improvements?
- [ ] **Trust calibration** — What mode are we in (Paired, Entrusted)? Should it change based on demonstrated quality?
      Reason to tighten the loop?

## Optional: Reuse Audit

The "Reuse Over Reinvention" principle says: prefer existing libraries over custom code when the library genuinely
simplifies. This sub-mode turns that principle into a systematic scan of a module or area. **Not default** — offer it
when the code shows the signals, then run only if the human agrees.

**Signals the code might warrant an audit:**

- Regex-heavy parsing of well-known formats (frontmatter, CSV, TOML, Markdown, etc.)
- Duplicated patterns across files — the same parse/format/merge logic repeated
- Manual implementations of solved problems (deep merge, glob matching, path expansion, retry, rate limiting)
- Verbose I/O wrappers that a utility library handles (recursive copy, temp directories, file watching)
- Hand-built JSON/YAML/TOML/Markdown serialization

If none of these signals are present, skip — the code is likely doing domain work, not reinventing.

**If the human agrees to run the audit:**

1. **Scope it.** One module or directory at a time. Read every file in scope before evaluating anything — get the full
   picture of patterns and constraints (dependency injection, factory functions, etc.) before proposing changes.
2. **List candidates.** For each, note what it would replace, how many lines, and which files.
3. **Evaluate each candidate against pass/fail criteria.** A library earns its place when it passes ALL of:
   - **Net simplification** — measurable reduction (lines removed > lines added for import + wrapper). Target: at
     least 30% reduction in the affected code.
   - **Removes duplication** — eliminates repeated patterns across files, or consolidates a concern into one proven
     implementation.
   - **Well-maintained** — actively maintained, widely used, minimal dependency tree. Check weekly downloads and last
     publish date.
4. **And the library must NOT:**
   - **Break existing patterns** — if the codebase uses `deps={}` injection for testability, a library that requires
     module-level singletons is disqualified.
   - **Force public-API changes** — sync→async migrations, changed return shapes, new error types. The ripple cost
     often exceeds the benefit.
   - **Save too little** — replacing 3-5 lines with a dependency adds maintenance surface (version bumps, breaking
     changes, supply chain) without meaningful simplification.
   - **Just swap approaches** — `Object.assign` for `deepmerge` when the merge is shallow, `execFileSync` for `execa`
     when the call is already a one-liner. Different is not simpler.
   - **Replace domain logic disguised as reinvention** — custom code handling business-specific edge cases or
     priority ordering is purpose-built, not reinvented.

### Audit Output

Produce two sections. The second is as valuable as the first.

**Recommended replacements.** For each winner:

- What it replaces — specific functions, line ranges, files
- Package — name, weekly downloads, what it does
- Why it earns its place — net line reduction, duplication removed, edge cases delegated
- Edge cases — anything the library doesn't handle that the current code does; how to bridge (options, thin wrapper)
- Changes needed — file-by-file
- Test impact — which existing tests should still pass, which may need adaptation

**Evaluated and skipped.** Table form:

| Candidate | Verdict | Why |
|-----------|---------|-----|
| `deepmerge` for X | Skip | Current merge is shallow. 30 lines of clear code. |
| `execa` for Y | Skip | Would force sync→async. Small gain, large ripple. |
| `chalk` for Z | Skip | UX improvement, not simplification. Different initiative. |

The skipped table documents the thoroughness of the audit and explains why seemingly obvious replacements were
rejected. Don't skip the skipped table — it's the record that the judgment was applied, not just the wins.

## Output

The sustainability check produces:

1. **Findings** — logged in the plan doc's `## Notes` (within-milestone) or the epic's `journal.md` (between
   milestones/epics)
2. **Action items** — immediate fixes (refactoring, test additions) or deferred items for the next milestone's plan
3. **Discussion items** — questions and observations for human review
4. **Process observations** — insights about methodology → epic's `journal.md`

**Inputs-vs-outputs check before finalizing.** Sustainability checks often read substantial source material — recent
commits, multiple files, journals, prior debriefs. Before closing out, verify the findings reflect what was reviewed.
If you read 13 files and produced 3 bullet points, something was likely dropped. Use the inputs as a checklist.

For deeper checkpoint-style outputs (readiness assessments, milestone-end reviews), `toolkit/checkpoint-doc-formats.md`
offers optional structured formats — Readiness Checklist, Assessment-doc tables, Operational Guide. Use when the
lightweight Output above isn't enough.
