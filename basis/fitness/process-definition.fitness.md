---
type: fitness-set
id: process-definition-fitness
owner: product-authority
status: approved
approved: 2026-08-23
version: 1
created: 2026-08-23
updated: 2026-08-23
target-type: process-definition
judged: true
executable: false
judged-by: cold-reviewer
---

# Fitness set: process-definition

These scenarios are evaluated by the `cold-reviewer` role, never
executed; the compiler and linter carry the mechanical half of the
same requirements. The mapping table compiles each Then into the
judge-rubric assertion the reviewer scores. The scenarios project the
[process-definition typedef](../artifacts/process-definition.md)'s
requirements and the
[process-definition guideline](../guidelines/process-definition.md)'s
rules into a judge's rubric.

## Scenarios

Scenario 1: the definition is the single source its renderings claim
  Given the process definition, its flow diagram, and its rendered
  skill
  When the diagram and skill are compared to the steps section
  Then both correspond to the steps exactly — every step, prompt, and
  branch present, nothing added — and both declare themselves
  generated, never hand-edited

Scenario 2: every outcome has a live witness
  Given the outcomes list and the steps section
  When each outcome's named witness is looked up
  Then every outcome names a step, check, or branch that exists, and a
  reader can say from the witness alone whether the outcome held for a
  run

Scenario 3: every loop declares its exits
  Given every cycle in the flow
  When its branch rows are read
  Then each cycle carries a labeled reached-state success exit, a
  round or budget cap, or both — no loop can run unbounded

Scenario 4: steps read only what they list
  Given each step's prompt, checks, and run template
  When every reference in them is resolved
  Then each resolves to a declared input or output of that step, and
  no prompt directs the agent to load undeclared context

Scenario 5: the run returns the artifact
  Given the result declaration and the purpose
  When they are compared
  Then the run returns the artifact it exists to produce, or result is
  absent and the outcomes pin the run's value

Scenario 6: prose sits where prose belongs
  Given every step record and the guiding statement
  When each is read
  Then step prose appears only in prompt fields, and the guiding
  statement (when present) states a cross-step judgment, never a
  sequence

## Compile mapping (each Then/And → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 — renderings correspond | "Walk the diagram and skill against the steps: name any step, prompt, or branch missing or added, and any rendering not marked generated. Empty list = pass." |
| 2 — outcomes witnessed | "For each outcome, name the witnessing step/check/branch and confirm it exists. Any outcome with a missing or unverifiable witness = fail, cite it." |
| 3 — loop exits declared | "List every cycle and its labeled exits. Any cycle without a success exit or cap = fail, cite it." |
| 4 — declared reads only | "For each step, quote any reference in prompt/checks/run that is not a declared input or output, and any prompt directing undeclared context loads. Empty list = pass." |
| 5 — artifact result | "Name the result value and what the purpose says the run produces. Mismatch, or a status-shaped result = fail; absent result justified by value-pinning outcomes = pass." |
| 6 — prose placement | "Quote any prose in a step outside prompt, and quote the guiding statement if it sequences steps. Empty list = pass." |

## Sources

Gherkin syntax (readable G/W/T frame — syntax only, no runner);
G-Eval–style rubric decomposition for the mapping table; the tests
project the process-definition typedef's checklist and Commitment and
the guideline's rules, per the definition-chain shape the
principle-set chain established.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-23 | update | Authored as the process-definition meta-chain's fitness set. |
| 1 | 2026-08-23 | state | draft → approved by the owner, with the exemplar screens' findings accepted as valid and their repairs directed. |
