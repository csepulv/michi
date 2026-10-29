# Writing for Readability

Michi chat and work docs have two readers: the agent that continues the work and the human who directs it. These
rules make the text readable to the human without removing anything the agent relies on.

## Always

- Give an internal ID its name in parentheses the first time it appears in each reply or section: "E5 (Starlight template CSS)", not a bare "E5". A list can share one parenthetical: "R5, R7, R9, R15 (the four medium-confidence changes)". Keep the ID; the name is for the reader.
- Lead with the point. Open each reply, section, or entry with one to three plain sentences anyone can follow, then give the detail.
- One word, one meaning. Call a thing by the same name every time. Don't invent synonyms, labels, or abbreviations for it.

## Example

Before:

> **Medium confidence:** R5, R7, R9, R15 (and R6b). Natural second wave if the first held. (R12 moved into M2.)

After:

> **Medium confidence: a likely second wave if the first wave holds.** R5 (evidence standard / typed
> uncertainty), R7 (behavioural trust-calibration questions), R9 (debrief diagnoses why the protection failed),
> and R15 (calibrate before distributing judgement work); at lower priority, R6b (guard or stamp for load-bearing
> numbers). R12 (extend Doc Drift Audit to the full auto-load chain) moved into M2 (Substrate).

Each name is the one the spec already uses.

## Sentences

- Write complete sentences. No shorthand, arrows, or undefined abbreviations in prose.
- Define a term before relying on it, and keep the project's existing names.
- Say which statements are verified and which are assumed.
- One idea per sentence. In steps, one instruction per sentence.
- Give each sentence a concrete subject and an active verb: "The audit found three stale counts", not "Three stale
  counts were found."
- Unpack noun strings: "the check that measures what loads at startup", not "the auto-load measurement check".
- Prefer plain words: "use", not "leverage"; "is", not "serves as".
- Repeat a name instead of "the former", "this", or "it" when the reader might pause.

## Documents

- In a document, a section is a `##` heading: name an ID at its first mention in each one.
- Lead-then-detail applies to every unit: a STATUS entry, a decision, a finding, a section. The lead is for anyone.
  The detail keeps everything the agent needs: IDs, paths, counts, evidence.
- Keep a lead next to its detail, and don't restate the same facts elsewhere. A second copy drifts.
- State the current fact. If a figure was corrected, say so once, plainly; don't keep a running correction log.
- Write about the work, not to the operator: "the criteria set at planning", not "the criteria you set".

## Avoid

- Announcing instead of saying: "Let's dive in".
- Puffery: "pivotal", "a testament to".
- Warm-up phrases: "at its core", "the real question is".
- Generic closers: "this sets us up well".
