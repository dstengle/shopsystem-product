---
type: feature
id: feat-flow-simplification
name: Flow simplification
status: delivered
version: 4
initiative: ../initiatives/init-flow-simplification.md
owner: lead-po
created: 2026-09-08
updated: 2026-09-09
---

# Feature: Flow simplification

## Feature

Feature: Flow simplification
  The authority, who frames and reads sweeps, and every role, which makes and self-checks, can move a bet to a verified build in six agent runs or fewer, with no human step past framing and no check inside the flow, in place of twenty runs and six human decisions.

## Contributors

Every scenario is owned by shopsystem-product (the lead shop):

- *a run goes from bet to verified build in six runs or fewer* — shopsystem-product (the lead shop)
- *a feature is authored without a human check* — shopsystem-product (the lead shop)
- *no cold read runs in the flow* — shopsystem-product (the lead shop)
- *no brief runs in the flow* — shopsystem-product (the lead shop)
- *a decision is recorded after the feature that needs it* — shopsystem-product (the lead shop)
- *a human step completes only at discovery or framing* — shopsystem-product (the lead shop)
- *a run holds only for a question outside the process's scope* — shopsystem-product (the lead shop)
- *a quality sweep runs on request, not at session close* — shopsystem-product (the lead shop)

## Interaction types

Command line — the authority starts runs there.

## Scenarios

```gherkin
Feature: Flow simplification
  The authority, who frames and reads sweeps, and every role, which makes and self-checks, can move a bet to a verified build in six agent runs or fewer, with no human step past framing and no check inside the flow, in place of twenty runs and six human decisions.

  @feature:feat-flow-simplification @hash:527e1309b1f8
  Scenario: a run goes from bet to verified build in six runs or fewer
    Given an initiative bet by the authority
    When the run moves from the bet to a verified build
    Then the run passes through six agent runs or fewer

  @feature:feat-flow-simplification @hash:92810fc73464
  Scenario: a feature is authored without a human check
    Given a feature drafted by the PO role
    When feature authoring completes
    Then no human step checks the feature before it is assigned

  @feature:feat-flow-simplification @hash:73f755fc9e82
  Scenario: no cold read runs in the flow
    Given a run moving from bet to verified build
    When the run's steps are read
    Then no step is a cold read

  @feature:feat-flow-simplification @hash:2edc17f010ba
  Scenario: no brief runs in the flow
    Given a run moving from bet to verified build
    When the run's steps are read
    Then no step produces or reads a brief

  @feature:feat-flow-simplification @hash:b1bb897c385e
  Scenario: a decision is recorded after the feature that needs it
    Given a feature authored and assigned
    When a decision the feature depends on is made
    Then the decision is recorded after the feature, from what it needs

  @feature:feat-flow-simplification @hash:00835d6f9fa0
  Scenario: a human step completes only at discovery or framing
    Given a run moving from bet to verified build
    When the run's human steps are read
    Then every human step in the run is a discovery step or a framing step

  @feature:feat-flow-simplification @hash:ef0a19ddee98
  Scenario: a run holds only for a question outside the process's scope
    Given a run reaching an open question
    When the question falls outside the process's own scope
    Then the run holds for it and for nothing else

  @feature:feat-flow-simplification @hash:5b7bcafea6e1
  Scenario: a quality sweep runs on request, not at session close
    Given a session closing
    When the session close step runs
    Then no quality check runs at close, and a sweep runs only when requested

  @feature:feat-flow-simplification @hash:d116c4de3e15
  Scenario: an execution goes from bet to verified build in six executions or fewer
    Given an initiative bet by the authority
    When the execution moves from the bet to a verified build
    Then the execution passes through six agent executions or fewer

  @feature:feat-flow-simplification @hash:be96137a97da
  Scenario: no cold read executes in the flow
    Given an execution moving from bet to verified build
    When the execution's steps are read
    Then no step is a cold read

  @feature:feat-flow-simplification @hash:82713ffaf451
  Scenario: no brief executes in the flow
    Given an execution moving from bet to verified build
    When the execution's steps are read
    Then no step produces or reads a brief

  @feature:feat-flow-simplification @hash:5a9e88396213
  Scenario: a human step completes only at discovery or framing, restated
    Given an execution moving from bet to verified build
    When the execution's human steps are read
    Then every human step in the execution is a discovery step or a framing step

  @feature:feat-flow-simplification @hash:b57766b6b387
  Scenario: an execution holds only for a question outside the process's scope
    Given an execution reaching an open question
    When the question falls outside the process's own scope
    Then the execution holds for it and for nothing else
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| Twenty agent runs and six human decisions between bet and build | the framing (Problem) | Scenario: a run goes from bet to verified build in six runs or fewer |
| A screen on a record of a decision already taken | the framing (Problem) | Scenario: a feature is authored without a human check |
| A cold read anywhere in the flow | the framing (the authority's words) | Scenario: no cold read runs in the flow |
| A brief anywhere in the flow | the framing; the appetite's third no-go | Scenario: no brief runs in the flow |
| An ADR written before the feature it decides for | the framing (the authority's words) | Scenario: a decision is recorded after the feature that needs it |
| A human step after discovery and framing | the framing; the appetite's second no-go | Scenario: a human step completes only at discovery or framing |
| A check running at session close | the framing (the authority's words) | Scenario: a quality sweep runs on request, not at session close |
| A question the process cannot answer | the framing (checks become requests) | Scenario: a run holds only for a question outside the process's scope |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Authored by the PO role from the initiative's Framing and For whom sections. |
| 2 | 2026-09-08 | update | Delivered as changed definitions, compiled and linted clean: "a feature is authored without a human check", "no cold read runs in the flow", "no brief runs in the flow", "a decision is recorded after the feature that needs it", "a human step completes only at discovery or framing", and "a quality sweep runs on request, not at session close" are shown directly by the definitions (no check/screen/revise/decide step, no cold-reviewer or brief step in product-flow's chain, adr-authoring gated between the feature's self-check and assignment, the one human step confined to discovery's frame, review-sweep uncalled and unscheduled). "a run goes from bet to verified build in six runs or fewer" and "a run holds only for a question outside the process's scope" need a run to observe. |
</content>
| 3 | 2026-09-08 | update | Verified on init-run-measurement: feature-authoring v8 ran four agent steps with no human step (anchor lead-lc00j), scenario-assignment one (lead-zdqn1), the build one — six runs, no cold read, no brief. |
| 4 | 2026-09-09 | update | Under req-2026-09-08-definition-vs-instance / feat-execution-vocabulary (shopsystem-product), scenario-assignment's widened supersession clause: five delivered scenarios that name a process instance "run" are superseded, not conflicted, by five new scenarios restating them with "execution" — @hash:527e1309b1f8 superseded by @hash:d116c4de3e15 ("an execution goes from bet to verified build in six executions or fewer"); @hash:73f755fc9e82 superseded by @hash:be96137a97da ("no cold read executes in the flow"); @hash:2edc17f010ba superseded by @hash:82713ffaf451 ("no brief executes in the flow"); @hash:00835d6f9fa0 superseded by @hash:5a9e88396213 ("a human step completes only at discovery or framing, restated"); @hash:ef0a19ddee98 superseded by @hash:b57766b6b387 ("an execution holds only for a question outside the process's scope"). The five old scenarios' Gherkin text stands unchanged, per the appetite's no-edit-in-place rule; nothing about what any scenario requires changed, only the noun for an instance. Hashes computed sha256 of each new scenario's Scenario/Given/When/Then text, first twelve hex digits, the repository convention. Made by the lead-solutions-architect role. |
