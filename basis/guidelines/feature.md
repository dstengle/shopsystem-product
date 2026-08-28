---
type: quality-guideline
id: feature-guideline
target-type: feature
owner: product-authority
status: draft
version: 5
created: 2026-08-27
updated: 2026-08-28
---

# Guideline: feature

**Voice principle.** Write the feature for the person or agent it
serves and for the shops that will run its scenarios against the real
system: a narrative that says who and why, then scenarios that each
state one action and one observable outcome, with nothing about how.

**Highlights (the layer compiled into generating context):** a Feature
line and a narrative — who, what, the outcome, in the framing's words ·
one When, one observable Then, no how · each owning shop named as the
source of its scenarios' steps and edges · usability and accessibility
criteria where there is an interaction · `@feature:` and `@hash:` on every
scenario · every named edge
covered or excluded with a reason · the interaction types stated, or "none" with a reason.

**Layers:** this guideline adds feature rules on top of the
[base writing style](base-writing-style.md); the base always applies
and is never overridden. When rules conflict, an approved principle
beats the [feature typedef](../artifacts/feature.md), which beats this
guideline. Gherkin's own syntax governs the Feature, Background, and
Given/When/Then form. Every rule feeds the
[feature fitness set](../fitness/feature.fitness.md), scored in the
[PO output check](../processes/po-output-check.md).

---

## Rules

**1. A narrative that says who and why.**
Before: "Feature: Run list" with scenarios beneath and no narrative.
After: "Feature: Failed runs visible in the run list / An operator
checking last night's runs / can see which failed without opening each
/ so that a failed run is noticed within one glance (the framing's
outcome)."
*Test:* read the Feature line and the lines beneath it. *Criterion:*
they name who the capability is for, what they can do, and the outcome
it serves, and the outcome is the framing's. *Decision:* yes/no per
feature.
*Derived check:* judged — feature fitness scenario 6.

**2. One action, one observable outcome, no implementation.**
Before: "When the user clicks the red button and the API returns 200,
Then the database row is updated."
After: "When the operator lists runs, Then each failed run is marked as
failed in the list."
*Test:* for each scenario and the Background, count the actions in the
When and check the Then against what a person or agent could observe
from outside the system. *Criterion:* one action or event; an outcome
observable in the running system; no step names an implementation
detail, such as a component, call, storage, algorithm, format, or
vendor. *Decision:* yes/no per scenario.
*Derived check:* judged — feature fitness scenario 1.

**3. Name a source shop for every scenario.**
Before: a feature with no contributors section.
After: "Contributors: the reporting shop supplied the steps and edge
cases for the list scenarios; the export shop for the CSV scenarios;
the product designer role supplied the usability criterion (marked
within one glance) and the accessibility criterion (failure not by
color alone)."
*Test:* read each scenario against the Contributors section.
*Criterion:* every scenario has a named source shop; where the
Interaction types section names a type, both designer criteria are
present. *Decision:* yes/no per scenario.
*Derived check:* judged — feature fitness scenario 2.

**4. Tag every scenario with its feature and hash.**
Before: a scenario with a title only.
After: `@feature:failed-runs-visible @hash:3f9a…` on the line above
`Scenario:` (the `@bounded-context:` tag is the architect's, written at
assignment; its presence is not this rule's).
*Test:* read each scenario's tag line. *Criterion:* `@feature:` and
`@hash:` are present. *Decision:* yes/no per scenario.
*Derived check:* judged — feature fitness scenario 3.

**5. List every edge and cover or exclude it.**
Before: a happy path only, with the cancelled-run case the shop named
absent from the Edges table.
After: an Edges row "cancelled run · reporting shop · Scenario: a
cancelled run is not marked failed" and a row "runs older than
the retention window · framing · out of scope: the archive feature
owns them".
*Test:* read the Edges table and the cases the framing names.
*Criterion:* every row names a covering scenario or a reasoned
exclusion, and every case the framing names has a row. *Decision:*
yes/no per case.
*Derived check:* judged — feature fitness scenario 4.

**6. State the interaction types, or "none" with a reason.**
Before: no Interaction types section.
After: "Interaction types: cli, gui — from the core-task list's 'read
a decision' row." or "Interaction types: none — the capability is a
nightly reconciliation with no person or agent at an interface."
*Test:* read the Interaction types section. *Criterion:* it names the
types the capability must be available on (the typedef requires them
to come from the [core-task list](../experience/core-tasks.md);
whether they do is a gap to be filed, for a lint or the conformance
check),
or "none" with a reason the framing bears out. *Decision:* yes/no per feature.
*Derived check:* judged — feature fitness scenario 5.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-27 | update | Authored as the acceptance-scenarios guideline to complete the type's definition chain. |
| 1 | 2026-08-27 | review | Screened: findings — rule 5's criterion carried a clause no check decides; rule 1 narrower than the typedef; a section reference by number. |
| 2 | 2026-08-27 | update | Repairs applied. |
| 2 | 2026-08-27 | review | Re-screened: clean. |
| 3 | 2026-08-28 | update | Owner decision: re-formed for the `feature` type — a narrative rule added; contributors per owning shop; the bounded-context tag left to assignment; the exclusion example names a feature, not a brief. File renamed. |
| 3 | 2026-08-28 | review | Screened with the chain: findings — rule 4 stricter than its scenario and failing every assigned feature; a hash form Gherkin cannot parse; rule 5 reading a list the typedef did not require; rule 6 undecidable on absence; rule 2 narrower than scenario 1. |
| 4 | 2026-08-28 | update | Repairs: rule 4 presence-only with the tag forms; rules 3, 5, 6 aligned to scenarios 2, 4, 5; rule 2 widened to any implementation detail. |
| 4 | 2026-08-28 | review | Re-screened: findings — rule 4's absence clause; rule 2's test without Background and a closed detail list; an invented reference form; the core-task source unchecked anywhere. |
| 5 | 2026-08-28 | update | Repairs applied; the core-task source named as a filed gap. |
| 5 | 2026-08-28 | review | Final screen (round 3): clean; "to be filed" aligned with the typedef. |
