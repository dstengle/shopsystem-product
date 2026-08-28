---
type: experience-record
id: experience-vocabulary
record: vocabulary
owner: product-authority
status: draft
version: 3
created: 2026-08-26
updated: 2026-08-28
maintained-by: lead-product-designer
---

# Experience record: vocabulary

The product's one vocabulary — the word every interaction type uses
for each thing and action — with the platform mappings the
`consistent-not-uniform` principle allows. Read by the
[common experience guideline](../guidelines/experience-common.md)
rule 1 and the
[interaction fitness set](../fitness/interaction.fitness.md) scenario
1. An entry means: this is the word; an interaction using another is a
finding unless the mapping column records the platform's word for that
type. Glossary terms carry the glossary's meaning. Every entry is a
hypothesis until user research confirms the person-facing word; the
screen returns "undecidable: entry is a hypothesis" for it until then.

## Entries

| Term | Meaning | Platform mappings (type: word) | Source | Status |
|---|---|---|---|---|
| Bounded Context | see glossary | none recorded | glossary | hypothesis |
| shop | see glossary | none recorded | glossary | hypothesis |
| run | see glossary | none recorded | glossary | hypothesis |
| hold, resume, cancel | the actions that move a run between its states (see glossary: hold) | none recorded | glossary | hypothesis |
| ask | see glossary | none recorded | glossary | hypothesis |
| clarify | see glossary | none recorded | glossary | hypothesis |
| acceptance scenario | see glossary | none recorded | glossary | hypothesis |
| feature | a Gherkin Feature: one capability from the user's or agent's view, with its acceptance scenarios | none recorded | feature typedef | hypothesis |
| decision record | the record of one product-level decision | none recorded | product-decision-record typedef | hypothesis |
| backlog | the ordered list of requirements within the framing | none recorded | backlog-order typedef | hypothesis |
| framing | see glossary | none recorded | glossary | hypothesis |
| contract | see glossary | none recorded | glossary | hypothesis |
| check | the screen of an output against its criteria and the decision on it | none recorded | po-output-check process | hypothesis |

## Checks

[Common experience guideline](../guidelines/experience-common.md)
rule 1; [interaction fitness set](../fitness/interaction.fitness.md)
scenario 1.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Seeded from the glossary and the approved definitions. |
| 1 | 2026-08-26 | review | Screened: findings — invented CLI mappings for a command line that does not exist; meanings drifting from the glossary; "scenario" not the defined term; a person-facing column promised and absent. |
| 2 | 2026-08-26 | update | Repairs: mappings removed; glossary terms say "see glossary"; acceptance scenario used; every entry marked hypothesis pending user research. |
| 2 | 2026-08-26 | review | Re-screened: clean. |
| 2 | 2026-08-26 | review | Re-screened (round 3): clean. |
| 3 | 2026-08-28 | update | Owner decision: acceptance-scenarios re-formed as feature (product-level, scenarios assigned per Bounded Context by tag); the brief retired — shops receive their assigned scenarios. |
