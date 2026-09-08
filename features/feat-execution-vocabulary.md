---
type: feature
id: feat-execution-vocabulary
name: Execution vocabulary
status: returned
version: 5
initiative: ../initiatives/init-execution-vocabulary.md
owner: lead-po
created: 2026-09-08
updated: 2026-09-08
---

# Feature: Execution vocabulary

## Feature

Feature: Execution vocabulary
  Every role and every definition that names an instance, the router
  first, can read and write one term for it — execution — where today
  run, runner, and anchor each patch the distinction inconsistently
  across 147 files; a process definition is named by its full id, one
  execution is execution:<process>:<bead>, and a bead is called a
  bead, so the corpus names a definition and its instance the same
  way everywhere the old terms stood.

## Contributors

Decomposition: not yet done for this initiative; every scenario sits
in the lead shop's own definitions, glossary, and process corpus, so
every scenario is owned by shopsystem-product (the lead shop):

- *a process definition is referenced by its full id* — shopsystem-product (the lead shop)
- *an instance of a process is named execution* — shopsystem-product (the lead shop)
- *run stands only as a verb* — shopsystem-product (the lead shop)
- *one execution is written in its field form* — shopsystem-product (the lead shop)
- *a bead is called a bead* — shopsystem-product (the lead shop)
- *runner survives only inside process-runner* — shopsystem-product (the lead shop)
- *the glossary carries execution and drops run's instance sense* — shopsystem-product (the lead shop)
- *the corpus measure reaches its target* — shopsystem-product (the lead shop)
- *no usability or accessibility criteria are due* — Interaction types names none: no person or agent acts through this capability, so `core-task-parity` and `accessible-by-standard` do not apply
- *no architect constraint is due* — the decomposition is not yet attached; none is named for this feature

## Interaction types

None — the initiative's For whom section states none: nothing here
is reached at an interface, only read and written in the corpus.

## Scenarios

```gherkin
Feature: Execution vocabulary
  Every role and every definition that names an instance, the router
  first, can read and write one term for it — execution — where today
  run, runner, and anchor each patch the distinction inconsistently
  across 147 files; a process definition is named by its full id, one
  execution is execution:<process>:<bead>, and a bead is called a
  bead, so the corpus names a definition and its instance the same
  way everywhere the old terms stood.

  @bounded-context:shopsystem-product @feature:feat-execution-vocabulary @hash:4a19c7e2f6b3
  Scenario: a process definition is referenced by its full id
    Given a document naming a process definition
    When the reference is read
    Then it names the definition's full id, not a bare or shortened form

  @feature:feat-execution-vocabulary @hash:8d2f61a9c470
  Scenario: an instance of a process is named execution
    Given a document naming one instance of a process
    When the noun for it is read
    Then it reads execution, never run as a noun

  @feature:feat-execution-vocabulary @hash:1c7b45de930f
  Scenario: run stands only as a verb
    Given a document using the word run
    When its part of speech is read
    Then it is a verb, never a noun for an instance

  @bounded-context:shopsystem-product @feature:feat-execution-vocabulary @hash:e35a08f61c94
  Scenario: one execution is written in its field form
    Given a document naming one specific execution
    When its written form is read
    Then it reads execution:<process>:<bead>, colon-separated

  @feature:feat-execution-vocabulary @hash:96b2d4f70ae1
  Scenario: a bead is called a bead
    Given a document naming the work register's identifier
    When the term is read
    Then it reads bead, never anchor for that identifier

  @bounded-context:shopsystem-product @feature:feat-execution-vocabulary @hash:3f70c9a1e625
  Scenario: runner survives only inside process-runner
    Given a document using the word runner
    When its context is read
    Then it appears only inside process-runner, nowhere else

  @bounded-context:shopsystem-product @feature:feat-execution-vocabulary @hash:c81ef056a2b9
  Scenario: the glossary carries execution and drops run's instance sense
    Given the glossary
    When its execution and run entries are read
    Then execution is defined as the instance term and run's entry names no instance

  @bounded-context:shopsystem-product @feature:feat-execution-vocabulary @hash:7d4b19f0836c
  Scenario: the corpus measure reaches its target
    Given the corpus sweep counting old-term usage
    When it is run after the propagation
    Then it counts zero files outside the superseded set
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| A process definition referenced by a bare name, not its full id | the framing | Scenario: a process definition is referenced by its full id |
| "run" used as a noun for an instance | the framing | Scenario: an instance of a process is named execution |
| "run" used other than as a verb | the framing | Scenario: run stands only as a verb |
| An execution written other than execution:<process>:<bead> | the framing | Scenario: one execution is written in its field form |
| "anchor" used to name the bead's identifier | the framing | Scenario: a bead is called a bead |
| "runner" used outside "process-runner" | the framing | Scenario: runner survives only inside process-runner |
| The glossary's "run" entry still defining an instance | the framing | Scenario: the glossary carries execution and drops run's instance sense |
| An old term surviving outside the superseded set after propagation | the framing's measure | Scenario: the corpus measure reaches its target |
| An edit made in place of a delivered artifact | the appetite's first no-go | Out of scope: barred by the no-go |
| A change to what any definition requires | the appetite's second no-go | Out of scope: barred by the no-go |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Authored by the PO role from the initiative's Framing and For whom sections (v1): the eight cases the framing states — the full-id reference, execution as the instance noun, run as verb-only, the execution:<process>:<bead> form, bead named plainly, runner's process-runner exception, the glossary's split entries, and the corpus measure — each one scenario. Decomposition not yet attached, so every scenario is owned by shopsystem-product per the pattern feat-plain-voice-rest set. Scenario hashes are provisional pending a hash-check tool run, the same noted gap as prior features. |
| 2 | 2026-09-08 | review | Screened by the lead-product-designer role against experience-principles.md (v2) and core-tasks.md (v4): the initiative's For whom (v2) reads "Interaction types: none," so `consistent-not-uniform`, `core-task-parity`, `agent-is-a-user`, and `accessible-by-standard` do not attach — none of the eight scenarios is reached by a person or an agent at a command line, terminal, screen, API, or conversation; each names a document read or a term's written form inside the corpus itself, and none matches a core-tasks.md entry (start/hold/resume/cancel a run, answer an ask, submit output or read a decision on a check, raise a clarify, deliver work for reconciliation). Contributors' existing "no usability or accessibility criteria are due" line and the Interaction types section's "None" already carry this reasoning correctly; both left as authored, no criteria written into Contributors, and no Edges row added since no criterion names a failure or boundary case. |
| 3 | 2026-09-08 | update | Made by the lead-solutions-architect role, reading init-execution-vocabulary (v2) for the decomposition: it carries no Decomposition section — not yet attached, no Bounded Context or contract named — so it names no non-functional constraint on any scenario; no constraint line added, no Edges row followed. Contributors' existing "no architect constraint is due" line, authored at v1 on the same pattern feat-plain-voice-rest set, already states this correctly and is left as authored. Self-check against feature guideline rule 7: the passage is one short line naming the absence and its source, no reasoning restated in the body. |
| 4 | 2026-09-08 | review | Self-checked by the PO role at feature-authoring's self-check step against the feature fitness set (feature.fitness.md v17), read in full against feat-execution-vocabulary v3: scenario 1 passes — each of the eight scenarios' Given/When/Then names one read event and one outcome observable in the term or reference as written, no step naming an implementation detail such as a file, a tool, or a component; scenario 2 passes — an owning shop, shopsystem-product, named for all eight against Contributors, matching one for one by name; no interaction type is named so no designer criteria are due, the decomposition is not yet attached so no constraint is due, both stated with their source; scenario 3 passes on presence — both `@feature:` and `@hash:` stand on all eight scenarios; the hashes are provisional per v1's own note, unverified by a hash-check lint, outside this judge's reach (fitness scenario 3 judges presence, not matching); scenario 4 passes — the ten-row Edges table covers all eight framing-named cases (the full-id reference, run as the instance noun, run as verb-only, the execution:<process>:<bead> form, bead in place of anchor, runner's process-runner exception, the glossary's split entries, the corpus measure) plus the appetite's two no-gos, each out of scope with its reason; scenario 5 passes — Interaction types states none, the reason tracing to the initiative's For whom section's own words; scenario 6 passes — the narrative names who (every role and every definition, the router first), what (read and write one term, execution), and the framing's own outcome (one term naming an instance everywhere the old terms stood); scenario 7 passes — the Contributors body holds only the owning-shop lines and the two "no ... due" lines with their short reasons, no reasoning or self-check passage restated. Accepted gap, not fixed: scenario 8 fails on a hand count, this session having no word-count tool — roughly 1,250 words against the base-writing-style feature target of 1,000, the same disclosed manual-count limit as the pending-hash gap. The overage is structural, not surplus: eight framing-named cases each carry one scenario, one Contributors line, and one Edges row under rules 2, 4, and 5, and the Gherkin fence repeats the Feature narrative under Gherkin's own external syntax; no cut is available without dropping a named case's coverage or the Gherkin form itself. Not fixed here; recommended to the PM as a scope question for a future writing-rule pass, the same family of gap init-plain-voice already tracks. Status set `checked`; init-execution-vocabulary moved `planned` → `active` on this feature's first pass. Version bumped 3 → 4. |
| 5 | 2026-09-08 | review | Reviewed by the lead-solutions-architect role at scenario-assignment's sweep, reading feat-execution-vocabulary v4 against the feature repository. Three of the eight scenarios return unowned, each for the same case among the four this role tests — the scenario contradicts one already specified in the feature repository, which the PO role resolves against the framing: @hash:8d2f61a9c470 (an instance of a process is named execution) conflicts with feat-process-runner.md's nineteen already-specified, assigned-not-delivered scenarios (@hash:7f991d005cc5 through @hash:96124cdccf45), whose Given/When/Then use "run" as the noun for a process instance throughout, and with feat-request-routing.md's @hash:eec1236a2a09 ("the run continues without acting on the ask") — the repository still specifies run as a noun where this scenario requires execution; @hash:1c7b45de930f (run stands only as a verb) carries the identical conflict against the same two features' text; @hash:96b2d4f70ae1 (a bead is called a bead) conflicts with feat-process-runner.md's fourteen already-specified scenarios (@hash:7f991d005cc5, @hash:21a0a96524fb, @hash:dfb80114f737, @hash:4353a5e45d00, @hash:3a9dc4428ded, @hash:6bcebb4e0073, @hash:6c35e3f87cd0, @hash:767b608029a3, @hash:4d31a463c42e, @hash:8f5b65dca426, @hash:1809e3236eca, @hash:28b4f5a6d5dc, @hash:d2f51245aa9a, @hash:96124cdccf45), which name the record carrying a run's state "the anchor" throughout — feat-process-runner.md is not delivered, so its text stands as current specification, not the superseded set the corpus measure excepts. None of the three names a decomposition problem (no Decomposition section is attached to this feature, so no Bounded Context assignment is in question) and none asks for a scenario split or a Contributors correction; all three read as a specified-text conflict for the PO role to resolve against the framing, most directly by reconciling this feature's target vocabulary with feat-process-runner.md and feat-request-routing.md before either scenario reissues for assignment. Self-check against define-good-up-front: each line above names the conflicting scenario by hash and name, the specific already-specified text it collides with by feature and hash range, and the one case among the four this role's reason-reading distinguishes; this record is the check's own output, not self-approved, and is submitted to the PO role on the status change below. Status set `returned`. Version bumped 4 → 5. |
