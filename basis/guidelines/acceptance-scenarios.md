---
type: quality-guideline
id: acceptance-scenarios-guideline
target-type: acceptance-scenarios
owner: product-authority
status: draft
version: 2
created: 2026-08-27
updated: 2026-08-27
---

# Guideline: acceptance scenarios

**Voice principle.** Write each scenario for the shop that will run it
against the real system and the reviewer who must say, from the text
alone, whether passing it means the behavior is done: one action, one
observable outcome, no implementation.

**Highlights (the layer compiled into generating context):** one When,
one observable Then, no how · the owning shop named as the source of
steps and edges · usability and accessibility criteria present where
there is an interaction · tag and hash on every scenario · every
named edge covered or excluded with a reason · the interaction types
the behavior must hold on named.

**Layers:** this guideline adds acceptance-scenario rules on top of
the [base writing style](base-writing-style.md); the base always
applies and is never overridden. When rules conflict, an approved
principle beats the
[acceptance-scenarios typedef](../artifacts/acceptance-scenarios.md),
which beats this guideline. Gherkin's own syntax governs the
Given/When/Then form. Every rule feeds the
[acceptance-scenarios fitness set](../fitness/acceptance-scenarios.fitness.md),
scored in the [PO output check](../processes/po-output-check.md).

---

## Rules

**1. One action, one observable outcome, no implementation.**
Before: "When the user clicks the red button and the API returns 200,
Then the database row is updated."
After: "When the operator lists runs, Then each failed run is marked as
failed in the list."
*Test:* for each scenario, count the actions in the When and check the
Then against what a person or agent could observe from outside the
system. *Criterion:* one action or event; an outcome observable in the
running system; no step names a component, call, storage, or algorithm.
*Decision:* yes/no per scenario.
*Derived check:* judged — acceptance-scenarios fitness scenario 1.

**2. Name who wrote what.**
Before: a set with no contributors section.
After: "Contributors: the reporting shop supplied the steps and the
edge cases (partial failures, cancelled runs); the product designer
role supplied the usability criterion (marked within one glance) and
the accessibility criterion (failure not by color alone)."
*Test:* read the contributors section. *Criterion:* the owning shop is
named as the source of steps and edges; where the behavior has an
interaction, both designer criteria are present. *Decision:* yes/no
per set.
*Derived check:* judged — acceptance-scenarios fitness scenario 2.

**3. Tag and hash every scenario.**
Before: a scenario with a title only.
After: `@reporting @list-failed-runs` and `hash: 3f9a…` above the
scenario, the tag carrying the set's `behavior` and `context`.
*Test:* read each scenario's header. *Criterion:* a tag carrying the
frontmatter values and a hash field are present (whether the hash
matches the text is a lint, not this rule). *Decision:* yes/no per
scenario.
*Derived check:* judged — acceptance-scenarios fitness scenario 3.

**4. Cover the named edges or exclude them with a reason.**
Before: a happy path only, with cancelled runs unmentioned though the
shop named them.
After: a scenario for a cancelled run, and "Out of scope: runs older
than the retention window — the archive brief owns them."
*Test:* list each failure or boundary case the framing or the §1
contribution names (the Contributors section); find its scenario or its exclusion. *Criterion:*
every case has one or the other. *Decision:* yes/no per case.
*Derived check:* judged — acceptance-scenarios fitness scenario 4.

**5. Name the interaction types the behavior holds on.**
Before: silence on where the behavior applies.
After: "Interaction types: cli, gui — from the core-task list's 'read
a decision' row."
*Test:* read the interaction-types section where the behavior has an
interaction. *Criterion:* the types are named (the typedef requires them to come
from the [core-task list](../experience/core-tasks.md); whether they
do is not this judge's check). *Decision:* yes/no per
set.
*Derived check:* judged — acceptance-scenarios fitness scenario 5.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-27 | update | Authored by owner direction to complete the type's definition chain; each rule maps to one fitness scenario; Gherkin governs the form, this guideline the content. |
| 1 | 2026-08-27 | review | Screened: findings — rule 5's criterion carried a clause no check decides; rule 1 narrower than the typedef's "implementation detail"; a section reference by number. |
| 2 | 2026-08-27 | update | criterion limited to what the judge decides; algorithm added; the section named. |
