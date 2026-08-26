---
type: experience-record
id: experience-hard-to-reverse
record: hard-to-reverse
owner: product-authority
status: draft
version: 3
created: 2026-08-26
updated: 2026-08-26
maintained-by: lead-product-designer
---

# Experience record: hard-to-reverse actions

The product actions an assistant interaction must state and confirm
before taking, and what it states. Read by the
[experience principles](../experience-principles.md)
`control-stays-with-the-person` bullet 2, the
[assistant guideline](../guidelines/experience-assistant.md) rule 2,
the patterns record's confirmation pattern, and the
[interaction fitness set](../fitness/interaction.fitness.md) scenario
6. An entry means: an assistant that takes this action without first
stating it and receiving confirmation fails the screen. Seeded from
the product actions the basis defines as terminal or externally
visible; each is a hypothesis until the product designer role, who
keeps this record under the principle's implication, confirms it with
the solutions architect role's account of the product's shape.

## Entries

| Action | Why it is hard to reverse | What the assistant states before it | Source | Status |
|---|---|---|---|---|
| cancel a run | cancelled is a terminal run state; continuing means a new run | the run, its state, and that it will not resume | glossary: run, hold | hypothesis |
| publish a contract change | a contract is a named, versioned promise; consumers may already depend on it | the contract, its version, and who consumes it | glossary: contract; architecture principles `contracts-between-contexts` | hypothesis |
| apply an authority decision to governed artifacts | the change is recorded in Document History and read by every later activity | the artifacts changed and the entry to be written | review-conversation process, apply step | hypothesis |
| resolve an ask by default | the asking run proceeds on the default without an answer | the question, the default, and that the run resumes on it | ask type | hypothesis |

## Checks

[Assistant guideline](../guidelines/experience-assistant.md) rule 2;
[interaction fitness set](../fitness/interaction.fitness.md) scenario
6; the [patterns record](patterns.md)'s confirmation pattern.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Seeded from the basis's terminal and externally visible actions. |
| 1 | 2026-08-26 | review | Screened: findings — two shop operating actions (push, close-out) listed as product actions; the cancel cell unsourced; the record's keeper misassigned to the architect. |
| 2 | 2026-08-26 | update | Repairs: shop actions removed; cancel grounded in the glossary's run states; the designer role keeps the record with the architect's input; every entry marked hypothesis. |
| 2 | 2026-08-26 | review | Re-screened: findings — "with a reason" attributed to the glossary, which does not carry it. |
| 3 | 2026-08-26 | update | the cancel cell reduced to what the glossary says. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean. |
