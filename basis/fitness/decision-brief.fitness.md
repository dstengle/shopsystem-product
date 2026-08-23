---
type: fitness-set
id: decision-brief-fitness
owner: product-authority
status: approved
approved: 2026-08-19
version: 1
created: 2026-08-10
updated: 2026-08-21
target-type: decision-brief
judged: true
executable: false
judged-by: cold-reviewer
---

# Fitness set: decision-brief

These scenarios are evaluated by the `cold-reviewer` role, never executed —
no step definitions exist or will exist. The judge's model and prompt
version are recorded with each round verdict. The mapping table at the end
compiles each Then into the judge-rubric assertion the reviewer scores.

## Scenarios

Scenario 1: decidable without the annex
  Given the decision-brief and its labeled annex
  When the stakeholder reads only the brief
  Then every requested decision can be made without opening the annex

Scenario 2: the first paragraph answers
  Given the first paragraph of the brief alone
  When the reader stops there
  Then it states the answer or recommendation, not background

Scenario 3: no unintroduced terms
  Given any proper noun or coinage in the brief
  When it first appears
  Then a gloss appears with it, or the term is recorded shop or product
  vocabulary (in the glossary or the product's own documents)

Scenario 4: asks are complete and honest about gating
  Given each ask read in isolation
  When it is parsed
  Then it carries a recommendation, inline evidence, and a default
  And the ask set states which asks gate work and which resolve on silence

## Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion (established format, tool chosen later) |
|---|---|
| 1 — decidable without annex | "Could a reader make every numbered decision using only this document? Cite any decision that needs outside context." |
| 2 — first paragraph answers | "Does paragraph 1 state a recommendation or answer? Quote the sentence, or answer no." |
| 3 — no unintroduced terms | "List every proper noun whose first mention lacks a gloss and is not recorded shop or product vocabulary. Empty list = pass." |
| 4 (Then) — each ask complete | "For each ask: recommendation present? evidence present? default present? Any 'no' = fail, cite the ask." |
| 4 (And) — gating stated for the set | "Does the ask set state which asks gate work and which resolve on silence? Yes/no; cite the sentence or its absence." |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-10 | update | Authored (seed layer); earlier history, if any, in the review record ledger on `main`. |
| 1 | 2026-08-19 | state | draft → approved. |
