# Fitness set: decision-brief @judged

<!-- Format slice: judged fitness tests. NON-EXECUTABLE — no step
     definitions exist or will exist; these scenarios are evaluated by the
     cold-reviewer role (roles/cold-reviewer.md), not run by a test runner.
     Segregated: this tree (basis/fitness/) is never features/. Judge
     pinning: the reviewing model + prompt version are recorded with each
     round verdict. Each Then compiles 1:1 to a judge-rubric assertion —
     mapping table below proves the compile. -->

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
