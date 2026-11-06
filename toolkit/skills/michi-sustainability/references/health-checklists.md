# Health Checklists

The checklists Michi uses to judge the health of code, tests and design, and the test a library must pass to replace
custom code. `michi-sustainability` applies them from the builder's seat; `michi-second-look` applies them from
outside the session. Select what's relevant; not everything applies every time.

Contents: Code Quality · Test Quality · Architectural Alignment · Reuse Audit: Signals · Reuse Audit: Criteria

## Code Quality

- [ ] **Refactoring pass** — Scan recent changes for duplication, unclear naming, functions doing too many things. Does
      the code reveal its intent?
- [ ] **Readability audit** — Can someone scan this code and understand what it does and why, without reading every
      line? Are names describing intent, not mechanism?
- [ ] **Separation of concerns** — Are domain logic, orchestration, and presentation properly separated? Would you have
      to rewrite logic to use it with a different UI?
- [ ] **Dead code** — Unused imports, unreachable branches, or commented-out code from recent work?

## Test Quality

- [ ] **Mock appropriateness** — Are mocks at I/O boundaries (network, storage, timers), not between internal modules?
      Any mocks hiding real behavior?
- [ ] **Test readability** — Do test names describe behavior? Is test data human-readable (ISO dates, not epoch
      numbers)? Are expected values concrete, not regex patterns?
- [ ] **Intent vs implementation** — Do tests assert on outcomes, or on which internal methods were called? Would tests
      break if you refactored without changing behavior?
- [ ] **Coverage gaps** — Are there obvious scenarios not tested? Edge cases, error paths, integration boundaries?
- [ ] **Speed tradeoff** — Is the suite fast enough for tight feedback, but not so shallow that speed costs meaning? A
      5-10 second suite with meaningful tests beats a sub-second suite with shallow ones.

## Architectural Alignment

- [ ] **Design intent** — Does accumulated code match the intended architecture? Has design drifted in a direction that
      should be acknowledged or corrected?
- [ ] **Design evolution** — Has the work revealed that the original design should change? If so, is that captured?
- [ ] **Consistency** — Naming conventions, file organization, and patterns consistent across the codebase? Recent work
      introducing inconsistencies?
- [ ] **Cross-package coherence** — If the project spans packages, are boundaries clean? Contracts between packages
      explicit?

## Reuse Audit: Signals

Signals the code might warrant a reuse audit:

- Regex-heavy parsing of well-known formats (frontmatter, CSV, TOML, Markdown, etc.)
- Duplicated patterns across files — the same parse/format/merge logic repeated
- Manual implementations of solved problems (deep merge, glob matching, path expansion, retry, rate limiting)
- Verbose I/O wrappers that a utility library handles (recursive copy, temp directories, file watching)
- Hand-built JSON/YAML/TOML/Markdown serialization

If none of these signals are present, skip — the code is likely doing domain work, not reinventing.

## Reuse Audit: Criteria

A library earns its place when it passes ALL of:

- **Net simplification** — measurable reduction (lines removed > lines added for import + wrapper). Target: at
  least 30% reduction in the affected code.
- **Removes duplication** — eliminates repeated patterns across files, or consolidates a concern into one proven
  implementation.
- **Well-maintained** — actively maintained, widely used, minimal dependency tree. Check weekly downloads and last
  publish date.

And the library must NOT:

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
