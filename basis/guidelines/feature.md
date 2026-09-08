---
type: quality-guideline
id: feature-guideline
target-type: feature
owner: product-authority
status: approved
approved: 2026-08-31
version: 17
created: 2026-08-26
updated: 2026-09-08
generated: true
generated-by: basis/tools/compile_typedef.py
source: basis/artifacts/feature.md
source-digest: sha256:603c7514828f
---

<!-- Generated from `basis/artifacts/feature.md` (its Writing rules section) by `basis/tools/compile_typedef.py`; do not edit by hand — edit the typedef and re-render. -->

# Guideline: feature

**Voice principle.** Write the feature for the person or agent it
serves and for the shops that will run its scenarios: a narrative that
says who and why, then scenarios that each state one action and one
observable outcome, with nothing about how, the whole document at or
under its word target.

**Highlights (the layer compiled into generating context):** a Feature
line and a narrative — who, what, the outcome, in the framing's words ·
one When, one observable Then, no how · each owning shop named per
scenario · the architect's constraints where the decomposition names
them · usability and accessibility criteria where there is an
interaction · `@feature:` and `@hash:` on every scenario · every named
edge covered or excluded with a reason · the interaction types stated,
or "none" with a reason · the whole document at or under the
base-writing-style word target for a feature.

**Layers:** this guideline adds feature rules on top of the
[base writing style](base-writing-style.md); the base
always applies and is never overridden. When rules conflict, an
approved principle beats the [feature typedef](../artifacts/feature.md), which
beats this guideline. Gherkin's own syntax governs the Feature,
Background, and Given/When/Then form. Every rule feeds the
[feature fitness set](../fitness/feature.fitness.md), scored at
feature-authoring's self-check step.

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

**3. Name the owning shop and the criteria for every scenario.**
Before: a feature with no contributors section.
After: "Contributors: the list scenarios are the reporting context's,
the CSV scenarios the export context's (per the decomposition); the
product designer role's criteria: marked within one glance; failure
not by color alone; the solutions architect role's constraint: the
list renders within one second at ten thousand runs."
*Test:* read each scenario against the Contributors section.
*Criterion:* every scenario has a named owning shop; where the
Interaction types section names a type, both designer criteria are
present; where the Contributors section says the decomposition names
constraints, they are present. *Decision:* yes/no per scenario.
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
Before: a happy path only, with the cancelled-run case the designer's
criterion named absent from the Edges table.
After: an Edges row "cancelled run · designer criterion · Scenario: a
cancelled run is not marked failed" and a row "runs older than
the retention window · framing · out of scope: the archive feature
owns them".
*Test:* read the Edges table and the cases the framing or a
contributor's criteria name.
*Criterion:* every row names a covering scenario or a reasoned
exclusion, and every case the framing or a contributor's criteria name
has a row. *Decision:* yes/no per case.
*Derived check:* judged — feature fitness scenario 4.

**6. State the interaction types, or "none" with a reason.**
Before: no Interaction types section.
After: "Interaction types: cli, gui — from the core-task list's 'read
a decision' row." or "Interaction types: none — the capability is a
nightly reconciliation with no person or agent at an interface."
*Test:* read the Interaction types section. *Criterion:* it names the
types the capability must be available on, or "none" with a reason the
framing bears out. *Decision:* yes/no per feature.
*Derived check:* judged — feature fitness scenario 5.

**7. Put criteria in the Contributors body; put the reasoning in the
Document History row.**
Before: a Contributors section that, after each criterion, explains
why it was chosen and closes with a self-check against the principles.
After: "the product designer role's criteria, on Scenario: a failed
run is marked: marked within one glance; failure not by color alone."
— and, in the Document History row of the step that added them: "two
candidates considered and not made criteria: neither serves the
framing's outcome; self-check: both ride by name on the scenario they
bound."
*Test:* read each passage of the Contributors body. *Criterion:* every
passage is an owning shop, a criterion, or a constraint, each riding by
name on the scenarios it bounds, in one short line; the reasoning
behind a criterion and the maker's self-check stand in the Document
History row, not the body. *Decision:* yes/no per passage.
*Derived check:* judged — feature fitness scenario 7.

**8. Meet the feature's word target.**
Before: a feature at 3,588 words, its Contributors and History rows
carrying reasoning the base style keeps out of the body.
After: a feature whose body holds only what rules 1–7 require, at or
under the target.
*Test:* count the words of the whole document. *Criterion:* the count
is at or under the base-writing-style word target for a feature.
*Decision:* yes/no per feature.
*Derived check:* judged — feature fitness scenario 8.
