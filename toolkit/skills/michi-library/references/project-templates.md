# Project Templates

The reader-facing documents the `project` target writes, and a template for each. `SKILL.md` (*The Project
Target*) says how to run it; this file says what each document is and what goes in it.

**These are shapes, not forms to fill.** A section with nothing true to say is left out, not padded (*Don't invent to
fill a template*, `SKILL.md`). The one exception: a document the named roles call for is always written, even when
it is short.

---

## The readers

**Readers are roles, not people.** A role is a mode of reading, and anyone can take any role.

| Role | What the reader asks |
|---|---|
| Observer | What is this? Why does it exist? What does it do? What are its limitations? Highlights of its history, phases, what's coming. |
| Practitioner | How do I get started and install it? Hello world. How do I use it: examples, recipes, gotchas? |
| Contributor | How do I set up for work? What is the design, architecture, flow? What tools do I need? What is the work lifecycle? What is planned or being considered? |

The contributor is the agent, the primary author, or a colleague taking over: someone working in the repo, not an
open-source outsider.

**The reader is a colleague:** a coworker or another community member, familiar with the domain and related work
outside the project. No level of technical competence is assumed; each role's documents state their own technical
prerequisites. **Assume the domain, explain the project.** Every idea the project embodies is explained; a domain term
the project uses in its own sense counts as a project idea.

**Readers have the repo.** Every reader can open the repository.

**Layers add, they don't repeat.** Essential content is for every role; incidentals are for contributors;
practitioners get what enables use. Where a topic appears in two roles, the later document adds detail and links
back. Separate documents, never two versions of one.

---

## The documents

Every document of a named role is written; only the FAQ is optional. Documents are not folded into sections of
others when a project is small. The one exception is hello world: a section of getting started when small, its own
document otherwise. The tl;dr and the glossary are written whatever roles are named. A project may need more
documents than these (*Documents beyond the templates*, below).

| Role | Document | File | Answers | Written |
|---|---|---|---|---|
| Observer | tl;dr / start here | `tldr.md` | What this is and why; status; key ideas. | Always |
| Observer | Overview | `overview.md` | Problem and motivation; what it does; limitations; status; use cases. | With the role |
| Observer | Reading guide | `reading-guide.md` | Where to go next, by role. | With the role |
| Observer | Roadmap | `roadmap.md` | What's coming: direction, not tasks. | With the role |
| Observer | Glossary | `glossary.md` | The project's own terms. | Always |
| Practitioner | Getting started | `getting-started.md` | Prerequisites, choices, install, setup. | With the role |
| Practitioner | Hello world | `hello-world.md` | A first use that works. | With the role; inline in getting started when small |
| Practitioner | Usage guide | `usage-guide.md` | Recipes and use cases. | With the role |
| Practitioner | Limitations | `limitations.md` | Gotchas and workarounds. | With the role |
| Practitioner | FAQ | `faq.md` | Recurring questions. | Optional |
| Practitioner | Reference | `reference.md` | Commands, API, configuration, for lookup. | With the role |
| Practitioner | Upgrading | `upgrading.md` | What to do after a change that requires action. | With the role, when a change has required the practitioner to act, with or without versions |
| Practitioner | Changelog | `changelog.md` | What changed in each version. | With the role, when the project has versioned releases |
| Contributor | contributor-guide | `contributor-guide.md` | Tools, setup, build/run/test, conventions, the work lifecycle, where to start. | With the role |
| Contributor | ARCHITECTURE.md | repo root | How it works and why it's built this way. | With the role |
| Contributor | Backlog | `backlog.md` | Experiments, research, and ideas under consideration. | With the role |
| Contributor | STATUS.md | repo root | Where things stand. Shared with the agent. | Not templated; linked |

**Where they live.** `<docs-root>/library/` by default (`docs/library/` when `docs-root` is unset). The user can
choose another location; CLAUDE.md records it under `## Michi` as `library-root: <path>`. STATUS.md and
ARCHITECTURE.md stay at the repo root. A part with its own Michi root docs (`docs/<name>/STATUS.md`,
`ARCHITECTURE.md`) uses those. Each part's documents go in a subfolder named for the part (`library/<part>/`). The
HTML is generated into `library/html/`.

---

## Documents beyond the templates

The templates are what every project gets, not everything a project may need. Some projects need more documents,
depending on the project and its context. There are two kinds.

**Situational questions.** A question some projects' readers bring and others never do. Examples, each raised by
one project:

- How exactly does it behave? An explanation at a practitioner's depth, beyond the overview's concepts.
- How is it deployed and operated?
- What happens to a user's data: where it is kept, who can see it, how to export or delete it?
- Is a part about to change under the people who use it?
- How does code move from a project that uses this one into it?
- What runs where, and on which machine?

**Expansions.** A topic significant or large enough for a document and a sidebar entry of its own. It may expand
something a template covers, or not overlap any template. Examples:

- Catalogs and detailed reference: an API, routes, examples, a catalog of definitions or rules (many playbooks, say).
- Detailed narratives or explanations: alternatives and their shortcomings; how the project evolved.

**Written on the user's yes.** The skill asks the user before drafting and again before closing whether anything
else is needed: a question that needs a document, or a document the user imagines needing (SKILL.md, *The Project
Target*). The agent may also propose an expansion it finds while drafting. Each proposal says what the document
answers and which role reads it. Nothing beyond the templates is written unasked.

**The same rules.** An extra document has no template; its first question shapes it. It follows *Rules every
template follows* (below), and its name says what it holds (`deployment.md`, `routes.md`). The reading guide lists
it with the rest.

**In the sidebar.** List it in `<library>/library.conf`, one `doc|<file>|<label>|<role>` line per document. The
build adds it to that role's sidebar, after the templated documents. A part's extra document goes in the part's
folder; the same line covers it there.

---

## Existing files

Most projects already have some of these documents, often in poor shape.

- **The general rule.** An existing document that does a template's job is **source material**. Refer to it, but
  don't simply link to it. Where it conflicts with the template, ask the user. Whether it is replaced is decided with
  the user in context, not presumed.
- **ARCHITECTURE.md**, for now, is linked as it is (see its template below).
- **PROJECT.md** stays as it is; the overview is written from it, and re-drawn from it on every run.
- **README.md** stays the project's own. When it exists, add one link to the tl;dr. When there is no README.md, don't
  create one: the library carries the content itself.
- **STATUS.md** stays as it is; the library links to it.
- **CHANGELOG.md**, when one exists, is linked, not copied.
- **The previous library** (on a re-run) is material like any other existing document: keep what is still true, and
  ask about anything that conflicts with a source.

---

## What adjusts each document

The role argument decides which documents are written. These details decide what each one emphasizes.

### Parts

A reader comes for "the thing", not the repo. When a project has parts, the reader has one extra question, "which
part?", and each role asks it differently.

**What counts as a part:**

- A part is what a reader would choose or skip. Propose the parts; the user confirms them.
- One level only. Anything finer is handled inside that part's documents.
- Material shared across parts goes at the umbrella level: shared setup in the umbrella's getting started, shared
  conventions in the contributor-guide's shared section.
- Parts that share a purpose relate, even if they don't depend on each other.

| Role | Parts that relate | Parts that don't relate (a multi-purpose repo) |
|---|---|---|
| Observer | The tl;dr maps the whole and its parts. | The top-level tl;dr is an inventory, a line and a status per purpose; each purpose has its own tl;dr. |
| Practitioner | Getting started helps choose parts and says what depends on what; practitioner documents per part. | Each purpose has its own practitioner documents; the top level points to them. |
| Contributor | The contributor-guide splits shared from per-part; ARCHITECTURE.md covers how parts depend on each other. | Contributor documents per purpose; only repo conventions are shared. |

### Size

Size doesn't decide which documents exist. It decides depth inside them: how much the reading guide routes, how
detailed ARCHITECTURE.md's building blocks are, whether the reference is split by part.

### Phase

- **Early:** status says what is stable and what isn't; more weight on the roadmap and open questions.
- **Mature:** more weight on usage and reference; the roadmap shrinks.
- Phase can differ per part, so status lines are per part.

### Other details

- **Prior knowledge** decides the entry point: from nothing (the tl;dr) or "what changed since" (STATUS.md,
  upgrading, the changelog).
- **Reading mode** decides structure: getting started and hello world are read in order; the usage guide,
  limitations, reference, and changelog are looked up.
- **Human or agent reader:** where an agent file already holds the content (CLAUDE.md conventions), the human
  document links to it instead of copying.
- **Currency:** fast-changing content (status, near-term work) lives in the files agents already maintain; library
  documents link to them rather than keeping a second copy.

---

## Rules every template follows

1. **Lead with the answer.** Open with one to three plain sentences that answer the document's first question, then
   give detail (`references/writing-for-readability.md`).
2. **Link up, don't restate.** Link to the tl;dr for "what this is", and to the earlier role's document for anything
   this one adds detail to.
3. **Explain project ideas.** A project term links to the glossary on first use. Domain terms are assumed unless the
   project uses them in its own sense.
4. **Status is per part.** Where there are parts, each status line names its part.
5. **Stay in the repo.** No link to material outside the repository (for example files under `~/.claude/`).
6. **One job per section.** A section that both teaches action and explains ideas is split.

---

## Observer templates

### tl;dr / start here (`tldr.md`)

- **First question:** what is this, and should I care?
- **Sections:**
  1. *What it is and why.* The problem or need, what this does about it, who it is for. One paragraph.
  2. *Status.* One line: maturity, phase, latest version or latest notable change. One line per part.
  3. *Key ideas.* Three to five, a sentence each, project terms linked to the glossary.
  4. *Parts* (when there are parts). Parts that relate: what each is, how they relate, which to read first. Parts
     that don't: an inventory, a line and a status per purpose, each linking to that purpose's tl;dr.
  5. *Where to go next.* One line per role, linking to the reading guide when it exists, otherwise to each named
     role's first document.
  6. *License.* One line, when there is one.
- **Size:** one to two screens or pages. Anything longer belongs in the overview.
- **Diagrams:** a concept or context diagram when it helps: the thing, who uses it, what it connects to. A parts
  diagram may replace it when parts relate.
- **Links:** reading guide, each role's first document, glossary.
- **Source:** Michi's own; the context diagram from arc42 section 3.

### Overview (`overview.md`)

- **First question:** why does it exist and what does it do, in enough detail to judge it?
- **Source of truth:** PROJECT.md (re-drawn every run); status from the changelog or the latest notable change.
- **Sections:**
  1. *Problem and motivation.* Optional: why this exists instead of alternatives, briefly.
  2. *What it is or does:* a feature overview. Optional: concepts, when the domain or key ideas are not obvious.
  3. *Limitations; open or known questions.* The essentials; the practitioner's limitations hold the gotchas.
  4. *Status:* latest version and most recent changelog entry, or the latest notable change. Optional: history
     highlights.
  5. *Use cases.*
- **Parts:** parts that relate get the whole first, then a short section per part. Parts that don't relate get an
  overview per purpose and none at the top level.
- **Diagrams:** a concept diagram in the concepts section; optional timeline for history highlights.
- **Links:** up to the tl;dr; across to the roadmap, glossary, changelog; down to the practitioner's limitations.
- **Source:** Michi's own; The Good Docs Project's concept template; Diátaxis' explanation form for concepts.

### Reading guide (`reading-guide.md`)

- **First question:** where do I go for what I came to do?
- **Sections:**
  1. *By role.* One line per role written: "to …, start at X, then Y".
  2. *Every document.* One line each: what it answers. Only documents that exist are listed.
- **Size:** a subway map, not an atlas.
- **Diagrams:** optional: the reading paths, one line per role.
- **Links:** every document in the set, including STATUS.md and ARCHITECTURE.md when the contributor role is
  written.
- **Source:** Michi's own.

### Roadmap (`roadmap.md`)

- **First question:** what's coming, and why does it matter?
- **Sections:**
  1. *Direction.* One paragraph: where the project is heading.
  2. *Coming.* Items grouped by how soon, each with what it is and why a observer would care.
  3. *Phases or evolution* (optional): how it got here, when that explains where it's going.
- **Diagrams:** optional: phases or a timeline.
- **Links:** overview status; the backlog, when the contributor role is written.
- **Source:** Michi's own; draws on an existing roadmap file or the backlog.

### Glossary (`glossary.md`)

- **First question:** what does this project's term mean here?
- **Entries:** the term; a one- or two-sentence definition in plain words; where it is used. Included: every name the
  project gives an idea, and domain terms used in the project's own sense. Excluded: domain terms in their ordinary
  sense. Alphabetical.
- **Diagrams:** none.
- **Links:** every document links into it on first use of a term.
- **Source:** The Good Docs Project's glossary template; arc42 section 12.

---

## Practitioner templates

### Getting started (`getting-started.md`)

- **First question:** how do I get this installed and set up?
- **Sections:**
  1. *What you'll have at the end.* One or two sentences.
  2. *Prerequisites.* What the reader needs to know and to have: tools, versions, accounts.
  3. *Choices before you install* (when there are any). Which parts or optional packages: what each provides, what
     depends on what, common combinations. How to consume it, when there is more than one way.
  4. *Install.* Numbered steps, each with the result to expect.
  5. *Set up.* The minimum configuration.
  6. *Check that it works.* One check with a visible result.
  7. *Hello world*, inline when small; otherwise a link.
  8. *Next.* Usage guide, reference, limitations.
- **Diagrams:** optional: parts and their dependencies, in section 3.
- **Links:** up to the tl;dr; the glossary; on to hello world and the usage guide.
- **Source:** The Good Docs Project's quickstart and installation-guide; Diátaxis' how-to form for the install steps.

### Hello world (`hello-world.md`)

- **First question:** can I make it do one real thing?
- **Sections:**
  1. *What you'll make.* The result, shown.
  2. *Before you start.* A link to getting started.
  3. *Steps.* Numbered, each with a visible result.
  4. *What just happened.* A few sentences, linking to the overview's concepts.
  5. *Next.* The usage guide.
- **Diagrams:** usually none; optionally one showing what happened.
- **Links:** getting started, overview concepts, usage guide.
- **Source:** Diátaxis' tutorial principles (visible results early, minimal explanation, ignore options, "aspire to
  perfect reliability"); The Good Docs Project's tutorial template.

### Usage guide (`usage-guide.md`)

- **First question:** how do I do this particular thing?
- **Structure:** an index of recipes, then the recipes grouped by task (by part when there are parts). Each recipe:
  goal as the title; when to use it; steps or an example; result; see also. A closing *use cases* section ties
  recipes to real situations.
- **Diagrams:** a flow per recipe, when the flow matters.
- **Links:** reference for exact options; limitations for gotchas.
- **Source:** Diátaxis' how-to form; The Good Docs Project's how-to template.

### Limitations (`limitations.md`)

- **First question:** what will trip me up, and what do I do about it?
- **Entries:** grouped by area. Each: the situation or symptom; the cause; the workaround, or "not supported". Also
  the known boundaries: what it does not do, limits of scale.
- **Diagrams:** none.
- **Links:** up to the overview's limitations; across to the usage guide and reference.
- **Source:** The Good Docs Project's troubleshooting template.

### FAQ (`faq.md`, optional)

- **First question:** has someone asked this before?
- **Entries:** the question as people ask it; a short answer; a link to the document with the full answer. Nothing
  lives only in the FAQ.
- **Diagrams:** none.
- **Links:** each answer to its full answer.
- **Source:** Michi's own.

### Reference (`reference.md`)

- **First question:** what exactly is this command, option, or call?
- **Structure:** mirrors the thing described (commands, API, configuration), split by part when there are parts.
  Each entry: name, description, parameters or options, an example. A table of contents at the top.
- **Diagrams:** none, unless a data model needs one.
- **Links:** to the recipes that use each entry.
- **Source:** Diátaxis' reference form; The Good Docs Project's reference template.

### Upgrading (`upgrading.md`)

- **First question:** what do I have to do after this change?
- **Sections:** one per change that requires action, newest first, headed by version, or by date when there are no
  versions. Each: what changed; the steps to take; deprecations to act on.
- **Diagrams:** none.
- **Links:** the changelog entry, when there is a changelog.
- **Source:** The Good Docs Project's installation-guide (upgrade section) and release-notes (deprecation notice).

### Changelog (`changelog.md`)

- **First question:** what changed, and when?
- **Entries:** one per version, newest first: version and date; highlights; then added, changed, deprecated, fixed,
  security, breaking. When a CHANGELOG.md exists, link to it instead.
- **Diagrams:** none.
- **Links:** upgrading, for versions with breaking changes.
- **Source:** The Good Docs Project's changelog template.

---

## Contributor templates

### contributor-guide (`contributor-guide.md`)

- **First question:** how do I get set up to work on this, and where do I start?
- **Sections:**
  1. *Tools and requirements,* including the contributor's technical prerequisites.
  2. *Setup.* Numbered steps to a working environment, each with the result to expect.
  3. *Build, run, and test.* The commands, and what passing looks like.
  4. *Conventions.* Link to agent rules in CLAUDE.md rather than copying them.
  5. *The work lifecycle.* How work moves from idea to done. In a Michi project: epics, plans, sessions, debriefs,
     briefly, with links.
  6. *Where to start.* The first files to read and the first kind of change to try.
- **Parts:** shared setup and conventions first, then a section per part; a contributor-guide per purpose when parts
  don't relate.
- **Diagrams:** optional: the work lifecycle.
- **Links:** up to the tl;dr; ARCHITECTURE.md, STATUS.md, the backlog; CLAUDE.md.
- **Source:** The Good Docs Project's contributing-guide (environment setup and best practices only); arc42 section 8
  overlaps conventions.

### ARCHITECTURE.md (repo root)

**On hold.** For now the library links to the project's current ARCHITECTURE.md and doesn't rewrite it. A first
trial (junkdrawer, 2026-10-27) showed that this outline, applied to an existing implementation map, produces a file
that is "so much more than architecture" (API routes, file trees, narrative). What an architecture document should
hold, and whether it is one file or several, is open. The outline below is kept as a record of the M3 design.

- **First question:** how does it work, and why is it built this way?
- **Sections** (adapted from arc42's minimal set):
  1. *Goals and constraints.* A few lines, linking to the overview for the why.
  2. *Context.* What the system talks to, and through which interfaces.
  3. *Solution strategy.* The few decisions that shape everything else.
  4. *Building blocks.* The whole system as boxes (level 1), then selected boxes opened (level 2). This is the
     implementation map: modules, short summaries, the complex parts.
  5. *Runtime flows.* A representative few.
  6. *Crosscutting concepts.* Patterns used throughout; link to the contributor-guide's conventions where they
     overlap.
  7. *Key decisions.* Linking to wherever decisions are recorded.
  8. *Risks and technical debt* (optional).
- **Parts:** how parts depend on each other at level 1; a section or file per part below.
- **Diagrams:** context (2); building blocks by level (4); a flow per runtime flow (5). Required.
- **Links:** up to the overview and tl;dr; contributor-guide; the decision record; glossary.
- **Currency:** a `**last-verified:** YYYY-MM-DD` stamp per section (`references/docs-structure.md`).
- **Source:** arc42 sections 1, 3, 4, 5, 6, 8, 9, 11.

### Backlog (`backlog.md`)

- **First question:** what is planned or being considered, and what could I pick up?
- **Sections:** opens with a link to STATUS.md's `## Next` and the active plans for near-term work, then:
  1. *Experiments and research to do, and why.*
  2. *Under consideration.* Ideas not yet committed.
  Each item: what it is, why, its state.
- **Diagrams:** none.
- **Links:** STATUS.md, plans and epics, the roadmap.
- **Source:** Michi's own; draws on plans, epics, and any roadmap file.

### STATUS.md (repo root)

Not templated. Its shape is governed by the STATUS reflex (`references/ground-rules.md`); the library links to it.

---

## Diagrams across the set

Each diagram serves its own document. Draw them with the `michi-diagrams` skill; `scripts/build-html.sh` renders them
for the HTML.

| Document | Diagram | Required |
|---|---|---|
| tl;dr | Concept or context; a parts diagram when parts relate. | When it helps |
| Overview | Concepts; a timeline for history highlights. | Optional |
| Reading guide | Reading paths. | Optional |
| Roadmap | Phases or timeline. | Optional |
| Getting started | Parts and dependencies. | Optional |
| Hello world | What just happened. | Optional |
| Usage guide | A flow per recipe. | Optional |
| contributor-guide | The work lifecycle. | Optional |
| ARCHITECTURE.md | Context; building blocks by level; runtime flows. | Yes |

None: glossary, limitations, FAQ, reference (unless a data model), upgrading, changelog, backlog.
