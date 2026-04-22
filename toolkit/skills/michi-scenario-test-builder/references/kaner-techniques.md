# Kaner's Twelve Techniques for Creating Scenarios

Source: "An Introduction to Scenario Testing" — Cem Kaner, 2003

Each technique is a different lens for generating test scenarios. Not all apply to every system. Select what fits, use
multiple techniques for broader coverage.

## Technique 1: Write Life Histories for Objects in the System

**What it is:** Trace an object (user account, document, order, device, record) from creation through every state change
to termination or archival.

**When to use:** Systems with stateful entities that have lifecycles — orders, subscriptions, devices, sessions,
policies, tickets.

**How to apply:**

1. Pick a key object in the system
2. Write its "biography" from creation to deletion
3. At each state transition: what could go wrong? What unusual but legitimate transitions exist?
4. Consider: late payments, cancellations, re-activations, ownership transfers, data corrections, merges, splits

**Example prompt:** "Trace the life of a WiFi client device from first observation through network changes,
disappearances, and reappearances over a 30-day period."

## Technique 2: List Possible Users, Analyze Their Interests and Objectives

**What it is:** Enumerate the different types of people who use (or are affected by) the system. For each, identify
their interests and objectives.

**When to use:** Always. Every system has multiple user types with different needs.

**How to apply:**

1. List all user types (not just primary — include admins, support staff, auditors, managers)
2. For each, list 2-3 interests (what they care about in their work)
3. For each interest, identify an objective for the system
4. Build scenarios around users pursuing their objectives

**Example prompt:** "For a security monitoring dashboard, list the SOC analyst, the CISO, the IT admin, and the
compliance auditor. What does each want from the system?"

## Technique 3: Consider Disfavored Users — How Do They Want to Abuse Your System?

**What it is:** Some users are adversarial. The system should make their objectives harder, not easier.

**When to use:** Any system with security, financial, or privacy implications.

**How to apply:**

1. List users who would benefit from the system failing or being misused
2. Identify their objectives (steal data, bypass controls, hide activity, cause confusion)
3. Design scenarios where they attempt those objectives
4. For autonomous agents: the agent itself is a potential disfavored user (it may take shortcuts, game metrics, or
   produce plausible-but-wrong output)

**Example prompt:** "An insider threat actor wants to use the wireless monitoring system to identify gaps in security
coverage. What would they look for?"

## Technique 4: List System Events — How Does the System Handle Them?

**What it is:** An event is any occurrence the system responds to. List them and test the response.

**When to use:** Event-driven systems, real-time systems, monitoring systems, APIs.

**How to apply:**

1. List all events the system processes (user actions, incoming data, scheduled jobs, external triggers)
2. For each: what should happen? What business rules apply?
3. Test normal handling, then: what if two events arrive simultaneously? In an unexpected state? Malformed?

**Example prompt:** "List every event type in the wireless observation stream. For each, what's the expected response?
What happens when events arrive out of order?"

## Technique 5: List Special Events — What Accommodations Does the System Make?

**What it is:** Predictable but unusual occurrences requiring special handling.

**When to use:** Systems with time-based logic, seasonal patterns, maintenance windows, regulatory deadlines.

**How to apply:**

1. Identify rare but expected events (year-end, daylight saving, leap year, maintenance mode, failover, data migration)
2. Design scenarios around them
3. Consider: what happens to in-progress work when a special event occurs?

**Example prompt:** "What happens to the wireless monitoring baseline when the office hosts a 500-person conference for
one day? How does the system distinguish a legitimate temporary change from an attack?"

## Technique 6: List Benefits and Create End-to-End Tasks to Check Them

**What it is:** Identify the benefits the system delivers and test full delivery of each.

**When to use:** Always. The most direct connection between "why does this exist?" and "does it work?"

**How to apply:**

1. List the top 5-10 benefits the system promises
2. For each, design a scenario where a user tries to obtain that benefit end-to-end
3. Start from the user's real starting point, not a convenient test setup

**Example prompt:** "The wireless monitoring system's key benefit is 'detect rogue access points within 5 minutes.'
Design a scenario testing this end-to-end, starting from a rogue AP being powered on."

## Technique 7: Interview Users About Famous Challenges and Failures

**What it is:** Talk to actual users. Get stories about the worst things that happened with the current or previous
system.

**When to use:** When replacing or upgrading an existing system. When users have domain expertise you lack.

**How to apply:**

1. Ask users to describe basic transactions
2. Encourage "funny stories" and "crazy things people tried"
3. Collect stories of annoying failures and edge cases
4. Convert into test scenarios

**Note for autonomous agent context:** If you can't interview directly, look for: bug reports, support tickets, incident
postmortems, forum complaints, competitor product reviews.

## Technique 8: Work Alongside Users to See How They Work

**What it is:** Observational research. Watch real users do real work.

**When to use:** When you have access to users and want to understand workflows documentation can't convey.

**How to apply:**

1. Sit with users during actual work sessions
2. Note workarounds, unexpected sequences, undocumented behaviors
3. Pay attention to frustrations and things they skip

**Adaptation for agents:** Analyze usage logs, session recordings, or analytics data to understand real usage patterns.

## Technique 9: Read About What Systems Like This Are Supposed to Do

**What it is:** Domain research. Learn what similar systems do and what users expect.

**When to use:** When you're new to the domain or testing a novel system.

**How to apply:**

1. Research similar products, industry standards, domain literature
2. Identify expected capabilities and common failure modes
3. Generate scenarios based on industry expectations vs. actual behavior

## Technique 10: Study Complaints About Predecessors and Competitors

**What it is:** Mine complaint data for scenario inspiration.

**When to use:** When predecessors or competitors exist (almost always).

**How to apply:**

1. Read customer complaints, support databases, review sites
2. Take "user errors" seriously — they reflect how users expected the system to work
3. Convert complaints into test scenarios

## Technique 11: Create a Mock Business — Treat It as Real and Process Its Data

**What it is:** Simulate realistic, sustained use. Not a demo — genuine, extended usage simulation.

**When to use:** When you need to test under realistic, evolving data conditions over time.

**How to apply:**

1. Set up a realistic environment with real-seeming data
2. Process data one transaction at a time (don't bulk-load)
3. Run reports, fix problems, handle special events — as if your livelihood depended on it
4. Push the system as hard as you would if it were your actual business

**This is the precursor to StrongDM's "digital twin" concept** — a realistic simulation environment driven hard.

## Technique 12: Try Converting Real-Life Data from Competing or Predecessor Systems

**What it is:** Run real historical data through your system and check results.

**When to use:** When real data is available and you want to validate against known-good historical results.

**How to apply:**

1. Obtain real data (sanitized if needed)
2. Process through your system
3. Compare results against known-good outputs from the predecessor
4. Watch for silent failures — output that looks plausible but is wrong

**Critical warning from Kaner:** 35% of bugs IBM found in the field had been exposed by tests but not recognized by
testers. Many came from this technique — the output looked right but wasn't. Check results very carefully.

---

## Selecting Techniques for Your System

| System Type                 | Most Useful Techniques                                                           |
| --------------------------- | -------------------------------------------------------------------------------- |
| **Web apps / SaaS**         | 1 (object lifecycles), 2 (user types), 6 (benefits), 9 (domain research)         |
| **Security / monitoring**   | 3 (disfavored users), 4 (system events), 5 (special events), 11 (mock business)  |
| **Data pipelines**          | 1 (data object lifecycles), 4 (events), 12 (real data conversion)                |
| **APIs / services**         | 4 (events), 5 (special events), 6 (benefits), 3 (abuse cases)                    |
| **ML / analytics**          | 6 (benefits), 11 (mock business), 12 (real data), 5 (special events)             |
| **Autonomous agent output** | 3 (agent as disfavored user), 6 (benefits delivered), 1 (code object lifecycles) |
