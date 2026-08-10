---
type: fitness-set
id: basis-fitness-decision-brief
title: decision-brief fitness set — judged Gherkin format slice
status: experiment
created: 2026-08-10
updated: 2026-08-10
authors: [dstengle, "Claude (lead-pm)"]
description: Judged qualitative fitness scenarios for the decision-brief kind, with a 1:1 compile mapping to judge-rubric assertions.
target-kind: decision-brief
judged: true
executable: false
judged-by: basis-role-cold-reviewer
judge-pinning: model and prompt version recorded with each round verdict
---

# Fitness set: decision-brief @judged

Non-executable — no step definitions exist or will exist; the front-matter
above is the schema-level marker. Segregated: this tree (`basis/fitness/`)
is never `features/`. Each Then compiles 1:1 to a judge-rubric assertion —
the mapping table below proves the compile.

Scenario: decidable without the annex
  Given the decision-brief and its labeled annex
  When the stakeholder reads only the brief
  Then every requested decision can be made without opening the annex

Scenario: the first paragraph answers
  Given the first paragraph of the brief alone
  When the reader stops there
  Then it states the answer or recommendation, not background

Scenario: no unintroduced terms
  Given any proper noun or coinage in the brief
  When it first appears
  Then a gloss appears with it, or the stakeholder demonstrably owns the term

Scenario: asks are complete and honest about gating
  Given each ask read in isolation
  When it is parsed
  Then it carries a recommendation, inline evidence, and a default
  And the ask set states which asks gate work and which resolve on silence

## Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion (established format, tool chosen later) |
|---|---|
| decidable without annex | "Could a reader make every numbered decision using only this document? Cite any decision that needs outside context." |
| first paragraph answers | "Does paragraph 1 state a recommendation or answer? Quote the sentence, or answer no." |
| no unintroduced terms | "List every proper noun whose first mention lacks a gloss and is not shop vocabulary. Empty list = pass." |
| asks complete | "For each ask: recommendation present? evidence present? default present? gate/default stated for the set? Any 'no' = fail, cite the ask." |
