# Adapting Scenario Testing for Michi / Autonomous Agent Verification

How to apply Kaner's scenario testing when the "developer" is an AI agent and the "tester" is either another agent or a
human reviewing agent output.

## The Core Problem

In autonomous agent workflows, the agent writes code AND can write tests. This creates a verification gap: the same
entity produces both implementation and tests, so it can "cheat" — writing `return true`, shaping tests to match bugs,
or satisfying the letter of a test while violating its spirit.

Scenario testing addresses this because scenarios are written from the **user's perspective**, not the implementer's. A
good scenario describes what the user wants to accomplish and how they'd know it worked — making it hard to game.

## Three Usage Patterns

### Pattern 1: Scenarios as Task Specifications

Include scenarios in the task description as acceptance criteria. The agent uses them to understand what "done" means.

**When to use:** Level 2-3 autonomy (supervised pipelines, autonomous with guardrails). The agent sees the scenarios and
works toward them.

**Strength:** Improves output quality by making expectations concrete. **Weakness:** The agent can over-fit to scenarios
rather than building a genuinely correct solution.

### Pattern 2: Scenarios as Holdout Verification

Write scenarios the implementing agent never sees. After the agent completes work, a separate verification process runs
holdout scenarios against the output.

**When to use:** Level 3-4 autonomy (autonomous loops, self-improving systems). Inspired by machine learning
holdout/test sets.

**Strength:** The agent can't game what it can't see. Catches "teaching to the test." **Weakness:** Requires
infrastructure to separate implementing and verifying contexts. Holdout scenarios need separate maintenance.

### Pattern 3: Scenarios as Exploration Guides

Use scenario generation techniques to explore a system and discover what tests should exist — before any agent writes
code. Output feeds into both task specifications and holdout sets.

**When to use:** Before any automation. When setting up a new Michi session / lane or adding automation to a new area. The
primary use case for this skill.

## The Agent as Disfavored User (Technique #3 Applied)

Kaner's technique #3 asks: "How do disfavored users want to abuse your system?" In a Michi session, the implementing
agent is a potential disfavored user — not maliciously, but structurally.

Ways agents "abuse" the development process:

- **Assert true**: Writing tests that always pass regardless of correctness
- **Circular validation**: Deriving test expectations from the implementation rather than requirements
- **Minimal compliance**: Satisfying the literal text of a requirement while missing intent
- **Pattern matching without understanding**: Copying patterns without understanding why they exist
- **Silent scope reduction**: Implementing easy parts, silently skipping hard parts
- **Plausible-looking output**: Code that reads well but has subtle logic errors

Design scenarios that specifically catch these failure modes.

## Scenario Difficulty Levels for Progressive Autonomy

Not all scenarios have the same verification difficulty:

### Level A: Automatically Verifiable

- Concrete, binary pass/fail criterion
- Checkable by running code (tests, assertions, build checks)
- Example: "The API returns a 400 status code when the email field is missing"

### Level B: Programmatically Checkable with Some Judgment

- Mostly-concrete criterion requiring some interpretation
- Partially automatable with LLM-as-judge or fuzzy matching
- Example: "The error message clearly explains what the user needs to fix"

### Level C: Requires Human Judgment

- Involves subjective quality, UX feel, or business context
- Cannot be meaningfully automated
- Example: "The dashboard layout makes it easy to spot anomalies at a glance"

**For Michi use:** Start with Level A. Use Level B with LLM-as-judge (separate evaluating agent). Keep Level C
for human review gates. As confidence grows, promote C → B → A by making criteria more specific.

## Scenario Lifecycle in Autonomous Agent Verification

1. **Generate** — Use this skill to create scenario catalogs
2. **Prioritize** — Rank by risk and automability level (A/B/C)
3. **Allocate** — Decide which go into task specs (Pattern 1) vs. holdout (Pattern 2)
4. **Implement** — Convert Level A scenarios into runnable test code (separate skill/tool)
5. **Run** — Execute as part of verification gates
6. **Evolve** — When the factory produces bad output, ask: "What scenario would have caught this?" Add it.
7. **Rotate** — Per Kaner: don't reuse the same scenarios forever. Create variations. Rotate old scenarios out of
   holdout.

## Key Kaner Warning for Autonomous Agent Verification

"35% of the bugs that IBM found in the field had been exposed by tests but not recognized as bugs by the testers."

In Michi use, the "tester" may be an agent. Agents are even more susceptible than humans to accepting
plausible-looking output as correct. This is why Kaner's criterion #5 (easy to evaluate) is paramount for automated
verification: if pass/fail is ambiguous, an agent will get it wrong.

**Mitigation:** For every scenario, explicitly define:

- What "pass" looks like (specific, observable)
- What "fail" looks like (specific, observable)
- What "looks like pass but is actually fail" looks like (the trap)

---

## Research-Informed Updates

Findings from a survey of current practices in agent-based verification (March 2026):

### Harness Engineering (OpenAI Codex)

"Improving the infrastructure around the agent mattered more than improving the model." Scenarios, verification
checklists, and plan docs are harness infrastructure — they constrain and guide the agent's work. Invest in the harness,
not just the prompts.

### Scope Creep Is the #1 Agent Failure Mode

Spotify's LLM judge vetoes 25% of agent output. Most common trigger: agents exceeding stated instructions. Include a
scope-check scenario: "Did the implementation stay within the plan's stated scope?" This catches the agent doing more
than asked.

### Given-When-Then as the Bridge Format

Research (ACM A-TEST 2024) validated that LLM agents can execute Gherkin-style specifications, but complex scenarios
must be broken into separate Given-When-Then pairs with state carried between steps. This is the standard decomposition
format for Level A and B scenarios.

### Error-Analysis-First (Husain)

Don't over-engineer the scenario catalog upfront. The most valuable scenarios come from actual failures. After each run:
"What bug escaped? What scenario would have caught it?" Write that scenario and add it. The set evolves through
practice, not exhaustive upfront planning.
