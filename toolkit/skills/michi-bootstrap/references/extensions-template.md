# Michi Extensions

Instructions in this file override or extend Michi skill behavior for this project.
Skills read this file before applying their defaults — anything here takes priority.

This file was created by `/michi-bootstrap customize`. Edit it directly to add
team conventions, org standards, coding guidelines, or skill-specific overrides.

---

## Common

Instructions here apply to all Michi skills.

Examples of what belongs here:
- Issue tracker and how to use it ("Create a GitHub issue for each milestone
  before starting work. Link it in the plan doc.")
- Branch naming convention ("Use `feature/<issue-number>-<slug>`.")
- Deploy or release process ("Tag a release after each milestone ships.")
- Review requirements ("All PRs need two approvals before merge.")
- Coding standards pointer ("See `docs/reference/code-style.md` for project
  coding standards. Follow them when writing or reviewing code.")

---

## michi-planning

Instructions here apply only when running the planning skill.

Examples:
- Verification requirements ("Every plan must include a load test scenario
  for any endpoint that changes.")
- Epic naming conventions ("Use Jira project key as prefix: `PROJ-<n>-<slug>`.")

---

## michi-session

Instructions here apply only during a session.

Examples:
- Definition of done additions ("A milestone is not complete until the staging
  deploy succeeds.")
- Commit message conventions ("Use conventional commits: `feat:`, `fix:`, `docs:`.")
- Notification triggers ("Post to #eng-deploys Slack channel when a milestone
  completes.")

---

## michi-explore

Instructions here apply only during explore conversations.

Examples:
- Output location overrides ("Save explore findings to `docs/research/` instead
  of `docs/sidebars/`.")
- Scope constraints ("Explorations involving auth must include a security
  considerations section.")

---

## michi-debrief

Instructions here apply only during a debrief.

Examples:
- Promotion rules ("Always promote decisions about the data model to
  `docs/reference/key-decisions.md`.")
- Required debrief sections ("Every debrief must include a 'what to watch'
  section for the next milestone.")

---

## michi-workshop

## michi-sustainability

## michi-pr-prep

## michi-docs-site

## michi-scenario-test-builder
