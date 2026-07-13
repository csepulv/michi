---
name: michi-loop
description: >-
  Set up and launch a disciplined lights-off loop — gate readiness, define the
  goal/verifier/stop contract, hand off to a loop mechanism, review at halt. For convergent work
  with a verifier you can trust. The convergent + autonomous counterpart to michi-expedition.
disable-model-invocation: true
---

# Michi Loop

Run a task as an autonomous, lights-off **loop** — the agent works unattended, checks its own output
against a verifier, and stops on a defined condition — *with Michi discipline around it.*

This skill is **discipline over mechanism**. It does not run the loop; Claude Code already ships the
runners (`/loop`, `/goal`, `claude -p`, `Workflow`). What it adds is the judgment the loop-engineering
literature skips: *have you earned lights-off, what does "done" mean, what checks the work, and when
does it stop?* You are invoked once, as the **designer and launcher** of a loop — not its body.

It is the **convergent + autonomous** lane — the sibling of `michi-expedition` (emergent +
Entrusted-spiral). The boundary between them is the *form of verification you can answer* (see the Gate).

## When to use (and when not)

**Use it when** the work is *convergent* (you can state "done when ___"), the verifier is *trustworthy*
(a real check, not the agent's say-so), the blast radius is *reversible* (a container, a worktree, a
branch), and autonomy has been *earned* (you've watched this kind of work go well Paired).

**Don't** when the work is exploratory or the end isn't knowable — that's `michi-expedition`. Don't
when you can't answer "done when ___". Don't when the only verifier is human visual judgment with no
automatable floor — a loop can't see the screen.

**Posture: surface-and-explore, you decide.** This skill *raises* the readiness checks; it does not
police them. The human makes the call to launch. For experimental work the agent's value is *fail
fast* — forcing too much up front defeats that. Be aware, not a gatekeeper.

## The flow

**Gate → Contract → Verifier → Stop → Readiness → Launch → Review.** Walk it once, with the human. The
first five steps are pre-flight (lights on); Launch hands off to the mechanism (lights off); Review
brings the lights back.

## 1. Gate — should this be a loop at all?

Surface, don't block:

- **Earned autonomy.** Read Complexity/Uncertainty and prior Paired alignment on *this kind* of work.
  High C/U with no prior alignment → not yet.
- **"This is done when ___."** If you can finish that sentence with measurable criteria, the work is
  convergent. If you can't, stop — it's an expedition (verify *progress*, not *done*) or stays Paired.
- **Which verification form can you answer?** *Convergent* ("how do I know I'm done?") → a loop fits.
  Only *progress* ("am I making progress, or spinning?") → hand to `michi-expedition`. The form routes
  the work. Both forms are the same discipline: care around grading your own homework.

## 2. Contract — what the loop is bound to

- **Goal** as a measurable contract — the exit criteria, concretely.
- **Allowed actions and constraints** — what the loop may touch, and what it must not.
- **Isolation / blast radius** — where it runs so a bad pass is reversible (container, worktree,
  branch). Name it explicitly; this is what makes lights-off safe.
- **Control surface** — how you'll *see progress* and how you'll *interrupt*. Lights-off is
  unattended, not blind or unstoppable: decide the log/monitor you'll check and the halt you'll use
  before you walk away.

## 3. Verifier — the check with teeth

The spine of the skill. The loop must be graded by something the agent **cannot talk its way past** —
not its own self-assessment.

- **Mechanical authority first:** a Stop hook that blocks "done" until checks pass; `/goal` (a goal
  Claude checks before stopping); a test / build / lint gate that returns binary pass/fail.
- **Independent judgment second:** a fresh-context reviewer (a separate agent, denied the builder's
  context) for what a gate can't assert. Holdout scenarios — verification the builder never sees —
  are the strongest form; see `michi-scenario-test-builder`'s `references/michi-adaptation.md`
  (Pattern 2: Scenarios as Holdout Verification).
- Keep it structurally separate from the generator. *Verification governs autonomy* — the loop's reach
  is bounded by what this verifier actually catches.
- **Unverifiable = not done.** If the environment can't *exercise* a done-criterion (missing service,
  queue, browser, fixture), that criterion is an open hole — flag it and fail it. Never let "we couldn't
  run it" get rationalized into a pass.

## 4. Stop conditions — non-negotiable

A loop without a stop is a runaway. Define all three (the *mandate*, borrowed from the expedition lane):

- **Iteration ceiling** — max passes before a forced halt.
- **No-progress detection** — halt when passes stop changing anything (spinning).
- **Budget / wall-clock cap** — a token or time limit that ends it before surprises.

## 5. Readiness — the shopping list

Make the shopping list, then check you actually have everything *before you start cooking*. List every
dependency needed to **build** each part **and to verify it** — services, env vars, tools (browser, test
runners), fixtures, queues/workers, auth, network reach — and confirm each is present and reachable **in
the target environment**.

The bar is higher than a Paired session: **there is no human mid-loop to notice a missing ingredient.**
In Paired/Entrusted the human silently supplies this — spots the gap, answers the question, stops the
run. Lights-off removes them, so the pre-check has to be exhaustive and explicit.

Walk each done-criterion and ask: *can this environment actually exercise it?* If not, that criterion is
an unverifiable hole — surface it now (drop it, fix the environment, or hand that piece to Paired); never
let the loop "pass" it blind. (Worked example: a "save all tabs → drawer" criterion needing a message
queue + worker the container didn't have — unrunnable, so it shipped broken-but-"passed.")

Put the **runner** on the shopping list too: can the runner you'll propose actually *exercise* every
verifier gate? (A `claude -p` worker fork can't spawn subagents — so it can't run a fresh-context-reviewer
gate; `/goal`'s evaluator reads the transcript, not the filesystem.) A gate the runner can't run is an
unverifiable hole — match the gates to the runner, or change the runner.

## 6. Launch & supervise — hand off, watch, keep the off-switch

**The runner is the human's call — present it and get a go before you launch. Do not jump ahead.** The
runner sets *who enforces the gate*, so it is not the launcher's silent decision: `/goal` has the
*harness* re-check the end-state before it can stop; a `claude -p` fork has the *agent* self-enforce its
own stop/verify (a weaker gate). **Default to `/goal`** (harness-enforced is safest) — but still surface
the choice and this tradeoff, and **confirm with the human before firing.**

The menu (default first; don't build a runner):

- **`/goal` (default)** — a persistent end-state the harness re-checks before allowing a stop; pair with
  `/loop` for recurring cycles. Harness-enforced.
- **`claude -p` (headless)** from a script — the truest unattended path, but the *agent* self-enforces
  stop/verify (mitigate with binary gates + an independent reviewer).
- **`Workflow`** — deterministic orchestration with built-in budget/iteration stops + verify gates, for
  multi-step / fan-out loops.
- **`/loop until: <condition>`** — recurring cycles until a stop condition.

**The loop body runs under Michi discipline — not raw.** Lights-off is not discipline-off; the toolkit
is *why* the autonomy is safe. Wire it into the `/goal` condition / launch prompt: each iteration runs
the `michi-session` core loop (implement → verify), uses TDD where it fits, runs verification and reads
the actual output before claiming any criterion met, and debugs failures systematically — root cause,
not symptom-patching. A loop that just codes until the evaluator says "yes" has thrown away the
discipline it exists to carry.

Launch *into the isolated environment* from the Contract. Then keep two controls live — the Contract's
control surface, enacted:

- **See progress** — a log or monitor you can check *without* interrupting the run: `/loop` job
  status, `Workflow` live progress (`/workflows`, `TaskOutput`), a tailed log file, or whatever
  monitoring stream the environment provides.
- **Interrupt** — a known, clean halt: stop the `/loop` or scheduled job, `TaskStop` a `Workflow`, or
  kill the headless process. The isolation is what makes an abrupt halt safe.

Watch the first runs. Reuse, don't reinvent: the bundled `verify` skill and quality-gate loop patterns
exist.

## 7. Review — lights back on

A loop ends one of exactly two ways. Both hand back to the human:

- **Verified done** — the verifier confirms the exit criteria. Convergent verification passed.
- **Abort** — it hit a wall: a stop condition fired, or progress stalled (spinning, dead end). It
  cannot get there from here.

Then: review the result against the contract, capture what was learned, and **spiral** — the transcript
is how this skill, and your trust in lights-off, improves. The review reads both forms: convergent (did
it meet the criteria?) and progress (did it advance, or churn?).

Close with `/michi-debrief` — a short debrief is usually enough — so learnings, scenario updates, and
trust calibration land in their long-lived homes rather than dying with the run.

## Pitfalls

- **Theater** — a toy target proves nothing. Conclusions need a real target.
- **Self-grading verifier** — if the agent decides its own "done," there is no gate. Give it teeth.
- **No stop conditions** — the fastest path to a runaway bill and an 18-hour spin.
- **Launching before earning autonomy** — lights-off is earned by watched alignment, not assumed.
- **Policing the gate** — surface the checks; the human decides. Don't block fail-fast experimentation.
- **Blind or unstoppable** — lights-off is not no-eyes-and-no-off-switch. If you can't see progress or
  can't halt the run, don't launch.
- **Discipline-off** — running the loop as raw code-until-the-evaluator-says-yes drops the very
  scaffolding (sessions, TDD, verification-before-completion) that makes autonomy safe. The loop carries
  the toolkit.
- **Passing the unverifiable** — a criterion the environment can't exercise is a hole, not a pass. The
  shopping list (step 5) is what catches it before launch.
- **Launching on the agent's say-so** — the runner choice *and* the go-ahead are the human's; the runner
  sets who enforces the gate. Default `/goal`, but confirm before firing — don't jump ahead.
