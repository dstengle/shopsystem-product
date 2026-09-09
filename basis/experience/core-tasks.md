---
type: experience-record
id: experience-core-tasks
record: core-tasks
owner: product-authority
status: draft
version: 5
created: 2026-08-26
updated: 2026-09-09
maintained-by: lead-product-designer
---

# Experience record: core-task list

The tasks a person or an agent must be able to complete wherever the
product is reached, and the options every interaction type offering a
task must present. Read by the
[common experience guideline](../guidelines/experience-common.md)
rule 4, the [interaction fitness set](../fitness/interaction.fitness.md)
scenario 4, and the
[feature fitness set](../fitness/feature.fitness.md)
scenario 5. An entry means: every interaction type must complete the
task with every option named, except a type the removal column names
with its reason. Every entry is a hypothesis seeded from what the basis
processes have a person or agent do; user research is to confirm the
tasks, and the product designer role settles the removals.

## Entries

| Task | What is accomplished | Interaction types it holds on | Removed from, with reason | Options every type must offer | Source | Status |
|---|---|---|---|---|---|---|
| start an execution | a process begins against a work item with its parameters | every type | document: a document cannot start an execution; it links to an interaction that can | choose the process; supply parameters; see the execution's id | process-definition typedef §Run lifecycle | hypothesis |
| hold, resume, or cancel an execution | an execution pauses with its state kept, continues, or ends with a reason | every type | document: as above | name the execution; give a reason on cancel | process-definition typedef §Run lifecycle | hypothesis |
| answer an ask | a question an execution put to a role is answered or its default accepted | every type | document: the notification carries the question and links to the interaction that answers | see the question, kind, and default; answer or accept the default | ask type | hypothesis |
| submit output for a check | a PO artifact enters the PO output check | every type | document: as above | name the artifact and its framing | po-output-check process | hypothesis |
| read a decision | the result of a check is read with its reasons | every type | none | see verdict, criterion or gap, reasons | check-decision type | hypothesis |
| raise a clarify | a shop asks the lead shop a scope, vocabulary, structure, or contract question | every type | document: as above | state the question and its kind | glossary: clarify | hypothesis |
| deliver work for reconciliation | a shop returns work against its assignment | every type | document: as above | name the assignment; attach the scenario register | reconcile-and-close process | hypothesis |

## Checks

[Common experience guideline](../guidelines/experience-common.md)
rule 4; [interaction fitness set](../fitness/interaction.fitness.md)
scenario 4;
[feature fitness set](../fitness/feature.fitness.md)
scenario 5.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Seeded from the basis processes. |
| 1 | 2026-08-26 | review | Screened: findings — tasks removed from types with no reason, against core-task-parity; a document contradiction; every cell an unlabeled design assertion. |
| 2 | 2026-08-26 | update | Repairs: every task holds on every type unless the removal column gives the reason; the document type's removals reasoned; every entry marked hypothesis. |
| 2 | 2026-08-26 | review | Re-screened: findings — the document row for answering an ask contradicted the removal reasoning. |
| 3 | 2026-08-26 | update | document removed from that task with the notification's role stated. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean. |
| 4 | 2026-08-28 | update | Owner decision: acceptance-scenarios re-formed as feature (product-level, scenarios assigned per Bounded Context by tag); the brief retired — shops receive their assigned scenarios. |
| 5 | 2026-09-09 | update | `run` propagated to `execution` as the noun for a process instance, under req-2026-09-08-definition-vs-instance / feat-execution-vocabulary (shopsystem-product): mechanical, determiner-adjacent occurrences only (`a/the/this/one/another/each/no/any run(s)`); `run-by`, `run` as a schema field or step key, and compound/heading uses (e.g. `run-cost`, `run list`, `Run lifecycle`) left unchanged, that residue disclosed as not done in this pass. Self-check against define-good-up-front: diffed against the file's pre-edit text; no requirement, field name, or heading changed. Made by the lead-solutions-architect role. |
