---
type: feature
id: feat-run-measurement
name: Run measurement
status: draft
version: 4
initiative: ../initiatives/init-run-measurement.md
owner: lead-po
created: 2026-09-08
updated: 2026-09-08
---

# Feature: Run measurement

## Feature

Feature: Run measurement
  The authority, who reads the cost, and the run-efficiency parent,
  whose measure this feeds,
  can have every session close record, without a model, cost metrics
  for each agent run — step, role, minutes, context tokens, output
  tokens where the harness gives them, tool uses — beside the session
  record,
  so that any run can be analysed on request, in place of reading the
  transcripts by hand.

## Contributors

Owning shop, per scenario — from the initiative's Decomposition
section, which names no Bounded Context: the new artifact, the
runtime step, and any tooling change sit in the lead shop's own tree;
no contract exists on this branch. Every scenario is owned by
shopsystem-product (the lead shop):

- *a session close records a cost row for each agent run* — shopsystem-product (the lead shop)
- *a field the harness withholds is left blank* — shopsystem-product (the lead shop)
- *minutes are recorded as wall-clock time* — shopsystem-product (the lead shop)
- *no cost row is written for a runtime step* — shopsystem-product (the lead shop)
- *the cost artifact stands beside the session record without restating it* — shopsystem-product (the lead shop)

Usability and accessibility: none due — the initiative's For whom
section names no interaction type ("Interaction types: none — cost
recording is incorporated into the session handoff step"); no
usability or accessibility criterion rides on any of the five
scenarios.

Non-functional constraints: the decomposition names none for this
feature — init-run-measurement's Decomposition section reads in full,
"None: no Bounded Context is touched — the new artifact, the runtime
step, and any tooling change sit in the lead shop's own tree; no
contract exists on this branch. Cross-context flow: none," naming a
Bounded-Context assignment and not a non-functional constraint; no
constraint rides on any of the five scenarios.

## Interaction types

None — the framing's own outcome names no person-facing action: "every
session close records, without a model, cost metrics for each agent
run ... beside the session record, so any run can be analysed on
request." The outcome is stated entirely as a system state change at
session close; it names no command line, terminal, graphical or web
screen, API or SDK, conversational or voice exchange, or generated
document through which the authority or the run-efficiency parent
would act — so no core-task-list interaction type applies.

## Scenarios

```gherkin
Feature: Run measurement
  The authority, who reads the cost, and the run-efficiency parent,
  whose measure this feeds,
  can have every session close record, without a model, cost metrics
  for each agent run — step, role, minutes, context tokens, output
  tokens where the harness gives them, tool uses — beside the session
  record,
  so that any run can be analysed on request, in place of reading the
  transcripts by hand.

  @feature:feat-run-measurement @hash:pending
  Scenario: a session close records a cost row for each agent run
    Given a session whose run passed through the router, leaving an anchor that records each agent run's step and role
    When the session closes
    Then a cost row is written beside the session record for each agent run recorded on the anchor, naming its step, its role, its minutes, its context tokens, and its tool uses, none of them computed by a model

  @feature:feat-run-measurement @hash:pending
  Scenario: a field the harness withholds is left blank
    Given an agent run whose harness usage report does not expose one of the cost row's fields
    When the cost row for that run is written
    Then that field is left blank on the row, never estimated and never computed by a model

  @feature:feat-run-measurement @hash:pending
  Scenario: minutes are recorded as wall-clock time
    Given an agent run whose start and end are recorded as timestamps on the anchor
    When the cost row for that run is written
    Then its minutes is the wall-clock span between those two timestamps

  @feature:feat-run-measurement @hash:pending
  Scenario: no cost row is written for a runtime step
    Given an anchor recording a runtime step alongside agent and human steps
    When the session closes
    Then no cost row is written for the runtime step, and a row is written only for each agent step, each human step, and each top-level router or lead-pm turn

  @feature:feat-run-measurement @hash:pending
  Scenario: the cost artifact stands beside the session record without restating it
    Given a session record and the cost rows written at its close
    When the cost rows are read
    Then they stand in an artifact of their own, referencing the session record's own identifying fields rather than restating them, and the session record itself is left unchanged
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| The cost of a run known only by reading transcripts by hand | the framing (Problem) | Scenario: a session close records a cost row for each agent run |
| Cost metrics computed or estimated by a model | the appetite's second no-go | Scenario: a session close records a cost row for each agent run; Scenario: a field the harness withholds is left blank |
| Analysis of the recorded rows | the appetite's first no-go | Out of scope: analysis belongs to a separate orchestration step, not this one |
| Whether "minutes" is wall-clock, agent-minutes, or both | the architect's unknown U1 (initiative history v2) | Scenario: minutes are recorded as wall-clock time — the architect's default; agent-minutes is a separate question, not decided here |
| Whether a runtime step counts as an agent run for a row | the architect's unknown U3 (initiative history v2) | Scenario: no cost row is written for a runtime step |
| The new artifact drifting from the session record it sits beside | the architect's risk R4 (initiative history v2) | Scenario: the cost artifact stands beside the session record without restating it |
| A field the harness's usage report does not expose for a run | the architect's risk R1 (initiative history v2); the framing's own qualification ("where the harness gives them") | Scenario: a field the harness withholds is left blank |
| The new artifact amending the session-record schema | D1 (initiative history v2; adr-2026-09-08-run-cost-artifact) | Scenario: the cost artifact stands beside the session record without restating it — a new artifact, never an amendment to `pkg:shopsystem-knowledge/session-record` |
| A session no approved process definition moved through the router | the architect's feasibility finding (§3) | Out of scope: no anchor exists to key a row on; the "every session" target is bounded by the sibling init-process-runner's own rollout, not this feature's to reach |
| A review conversation's or a work item's close | D2 (initiative history v2; adr-2026-09-08-run-cost-initiative-scope); the architect's risk R3 | Out of scope: D2 scopes the target to the session-record anchor alone; a row for those two anchors, if wanted, is a separate request against reconcile-and-close and the review conversation's own anchor |
| The new artifact's exact name and location | the architect's unknown U2 (initiative history v2) | Out of scope: the maker's choice at build — one file per session record, named to pair with it, in `sessions/` — no scenario binds a path |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Authored by the PO role alone at feature-authoring's draft step, from init-run-measurement's Framing and For whom sections (v5, planned); five scenarios, all owned by the lead shop per the Decomposition section ("None: no Bounded Context is touched — the new artifact, the runtime step, and any tooling change sit in the lead shop's own tree"); Interaction types stated as none per the For whom section's own words. Vocabulary drawn from the architect's and PM role's attachments (initiative history v2, v4, v5): the cost row's fields, the anchor and the harness's usage report feat-process-runner already reads, the cost artifact D1 places beside the session record (adr-2026-09-08-run-cost-artifact), wall-clock minutes (U1's default), and the session-record anchor D2 scopes the target to (adr-2026-09-08-run-cost-initiative-scope). The repository read in full — eight features (feat-request-routing, feat-role-decisions, feat-roles-availability, feat-skills-availability, feat-tool-skills, feat-tool-skills-rest, feat-typedef-rendering, feat-process-runner); feat-process-runner (v10) touched for its context-at-end scenario and its anchor and harness-usage-report vocabulary, its scenario text unchanged; no conflict — no other feature names a session record, a cost row, or a close step. `@hash:pending` on each of the five scenarios: no shell available to this authoring session; the repository convention (sha256 of the scenario's text, first twelve hex digits, as filled by the lead-pm for feat-request-routing and feat-typedef-rendering) applies before the check. Declined or held, with the reason in Edges: analysis of the recorded rows (the appetite's first no-go); a session not yet router-moved (the architect's feasibility finding); a review conversation's or a work item's close (D2); the new artifact's exact name and location (U2, the maker's choice at build). Self-check against the feature fitness set: 1 pass — each When one event, each Then one observable outcome on the anchor or the artifact beside the session record, no step naming a file path, a schema field, or a tool; 2 pass — an owning shop named for all five, no interaction type so no designer criteria due yet, the architect's own add-constraints step still to run; 3 pass on presence — both tags on all five, hashes disclosed pending; 4 pass — eleven rows from the framing, both no-gos, U1–U3, R1, R3, R4, and D1–D2, each covered by Scenario name or out of scope with a reason; 5 pass — none, with the reason quoted from the For whom section; 6 pass — who (the authority; the run-efficiency parent), what (a mechanical cost row per agent run, without a model), the outcome (any run analysed on request, in place of reading transcripts by hand). Feature id added to init-run-measurement's Features section. |
| 2 | 2026-09-08 | update | Designer's criteria added by the lead-product-designer role at feature-authoring's add-usability step, from init-run-measurement's For whom section (v5, planned). None due: §2 states "Interaction types: none — cost recording is incorporated into the session handoff step," matching this initiative's own attach-usability offer at initiative-check (history v3) — no interaction type is named, so `core-task-parity` and `accessible-by-standard` (basis/experience-principles.md v2) name no criterion to attach. Checked against the core-task list (basis/experience/core-tasks.md v4, its seven entries — start a run; hold, resume, or cancel a run; answer an ask; submit output for a check; read a decision; raise a clarify; deliver work for reconciliation): none names reading a run's cost, and the appetite's own no-go against analysis in the step itself keeps the one activity that could become an interaction — presenting the rows "on request," the initiative's own words — out of this feature. All five scenarios read against that list and against `consistent-not-uniform`, `agent-is-a-user`, `evidence-not-opinion`, `errors-guide-recovery`, and `control-stays-with-the-person`: each states an outcome on the anchor or the cost artifact directly, naming no command line, terminal, graphical or web screen, API or SDK, conversational or voice exchange, or generated document in any Given/When/Then — no principle in the corpus attaches to a step with no such exchange. No Edges row added: no failure or boundary case is named by a usability or accessibility criterion, since none is due. Contributors section carries the "none due" line and its short reason only, per the feature typedef's rule that the body holds a contributor's criteria and nothing else (feature-typedef v13, Required sections item 2); this entry carries the full reasoning and self-check. |
| 3 | 2026-09-08 | update | Non-functional constraints step run by the lead-solutions-architect role at feature-authoring's add-constraints step, from init-run-measurement's Decomposition section (v2, planned). The section read in full: "None: no Bounded Context is touched — the new artifact, the runtime step, and any tooling change sit in the lead shop's own tree; no contract exists on this branch. Cross-context flow: none." — a Bounded-Context assignment, naming no non-functional constraint of any kind (no throughput, latency, availability, security, or data-retention bound is stated for the artifact, the runtime step, or the tooling change). Checked against the other candidate homes for a constraint before recording none: the attach-architecture offer's D1, D2, R1–R4, and U1–U4 (this initiative's Document History v2) are decisions, risks, and unknowns already carried by the vocabulary and Edges rows the PO role recorded at v1 — none of them is a non-functional constraint the Decomposition section itself names, and re-deriving one from them here would duplicate a fact this feature's Document History v1 already holds, contrary to `single-source-of-truth`. All five scenarios re-read against the Decomposition section's own text: none is bounded by a constraint it does not state. No Edges row added: no failure or boundary case is named by a non-functional constraint, since none is due. Contributors section carries the "none" line and its short reason only, per the feature typedef's rule that the body holds a contributor's criteria and constraints — each riding by name on the scenarios it bounds — and nothing else (feature-typedef v13, Required sections item 2); this entry carries the full reasoning and self-check. |
| 4 | 2026-09-08 | update | Repairs made by the PO role against the PO output check's three named findings (all criteria named against the feature fitness set, none uncovered), read against feat-run-measurement v3. Fitness Scenario 7 (confident): the Contributors "Vocabulary" block's six entries — cost row, anchor, the harness's usage report, the cost artifact, wall-clock minutes, the session-record anchor — were none of the three permitted passage types (owning shop / criterion / constraint) and rode by name on no scenario. Repair: the block removed from Contributors, leaving the owning-shop list, the "none due" usability line, and the "none" constraints line only. No re-homing to the glossary was needed: each term's authoritative definition already sits at the source the block itself cited and that this feature's own Document History v1 already carries as the reasoning behind the scenarios drawn from them — cost row in the framing's own words; anchor in the glossary and feat-process-runner's context-at-end scenario; the harness's usage report in feat-process-runner's Document History v9; the cost artifact in D1 (adr-2026-09-08-run-cost-artifact); wall-clock minutes in U1 (init-run-measurement's Document History v2); the session-record anchor in D2 (adr-2026-09-08-run-cost-initiative-scope). Fitness Scenario 5 / framing (wobbly): the Interaction types section's "none" reason quoted the initiative's For whom section, a section the framing input named to the check does not carry. Repair: restated from the Framing section's own words alone — the outcome ("every session close records, without a model, cost metrics for each agent run ... beside the session record, so any run can be analysed on request") is stated entirely as a system state change, naming no command line, terminal, graphical or web screen, API or SDK, conversational or voice exchange, or generated document — so no core-task-list interaction type applies. No owner ruling was needed: the Framing section's own text supports the same "none" unaided, without reaching into the For whom section or any other role's domain. Fitness Scenario 1 (wobbly), the fifth scenario ("the cost artifact stands beside the session record without restating it"): its Then named "frontmatter" and "schema field," document-structure terms rather than an outcome observable in the running system. Repair: restated as "referencing the session record's own identifying fields rather than restating them, and the session record itself is left unchanged" — an outcome checkable by reading the two records, naming no field or schema. No ask was raised: all three repairs restate content already carried by the framing, the Contributors block's own citations, or the scenario's own subject matter, reaching neither the originator's intent, a scope question, nor another role's domain. Self-check against the feature fitness set: scenario 7 — the Contributors body now holds an owning shop, a "none due" usability line, and a "none" constraints line only, no reasoning passage; scenario 5 — the "none" reason traces to the Framing section's own words, not the For whom section; scenario 1 — the fifth scenario's Then names an outcome (a reference relation and an unchanged record), no implementation detail, and the other four scenarios re-read unchanged still pass; scenarios 2, 3, 4, and 6 unaffected by these repairs. `@hash:pending` left as is on all five scenarios — none was ever filled, per v1's note that no shell was available to that authoring session. Version bumped 3 → 4. |
