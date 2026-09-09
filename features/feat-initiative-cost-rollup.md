---
type: feature
id: feat-initiative-cost-rollup
name: Initiative cost rollup
status: returned
version: 5
initiative: ../initiatives/init-run-measurement.md
owner: lead-po
created: 2026-09-08
updated: 2026-09-09
---

# Feature: Initiative cost rollup

## Feature

Feature: Initiative cost rollup
  The authority, who reads the cost, and the run-efficiency parent,
  whose measure this feeds,
  can have every run's anchor name the initiative it serves, and a
  rollup, run on request, sum a leaf initiative from its sessions'
  cost rows and a parent initiative from its children's rollups,
  so that what an initiative cost — one leaf, or a whole tree — is
  known on request, in place of reading transcripts by hand.

## Contributors

Owning shop, per scenario — from the initiative's Decomposition
section, which names no Bounded Context: the anchor field and the
rollup tool sit in the lead shop's own tree; no contract exists on
this branch. Every scenario is owned by shopsystem-product (the lead
shop):

- *an anchor names the initiative it serves* — shopsystem-product (the lead shop)
- *a leaf initiative's rollup sums its own sessions* — shopsystem-product (the lead shop)
- *a parent initiative's rollup sums its children* — shopsystem-product (the lead shop)
- *the rollup is computed only when requested* — shopsystem-product (the lead shop)

Usability and accessibility: none due — the initiative's For whom
section names no interaction type ("Interaction types: none — cost
recording is incorporated into the session handoff step"); no
usability or accessibility criterion rides on any of the four
scenarios.

Non-functional constraints: none — the Decomposition section names
none for this feature, as it does for its sibling feat-run-measurement;
no constraint rides on any scenario.

## Interaction types

None — the framing's second part names no person-facing action beyond
a request to run the sum: "a rollup on request sums a leaf initiative
from its sessions' rows and a parent from its children." No
core-task-list entry (start a run; hold, resume, or cancel a run;
answer an ask; submit output for a check; read a decision; raise a
clarify; deliver work for reconciliation) names reading or computing
a cost rollup, and the appetite's no-go against analysis in the step
— the same no-go the sibling feature stands under — keeps presenting
the summed rows out of this feature; the rollup is a mechanical sum,
invoked as a tooling step, not a designed interaction.

## Scenarios

```gherkin
Feature: Initiative cost rollup
  The authority, who reads the cost, and the run-efficiency parent,
  whose measure this feeds,
  can have every run's anchor name the initiative it serves, and a
  rollup, run on request, sum a leaf initiative from its sessions'
  cost rows and a parent initiative from its children's rollups,
  so that what an initiative cost — one leaf, or a whole tree — is
  known on request, in place of reading transcripts by hand.

  @feature:feat-initiative-cost-rollup @hash:pending
  Scenario: an anchor names the initiative it serves
    Given a run starting against a work item, under an initiative
    When the run starts
    Then the run's anchor records the initiative the run serves

  @feature:feat-initiative-cost-rollup @hash:pending
  Scenario: a leaf initiative's rollup sums its own sessions
    Given a leaf initiative with no child initiatives, and the cost rows for every session whose anchor names it
    When the rollup is requested for that initiative
    Then the rollup sums those rows for that initiative, without a model

  @bounded-context:shopsystem-product @feature:feat-initiative-cost-rollup @hash:pending
  Scenario: a parent initiative's rollup sums its children
    Given a parent initiative whose children each already have their own rollup
    When the rollup is requested for the parent
    Then the rollup sums its children's rollups for the parent, without a model

  @feature:feat-initiative-cost-rollup @hash:pending
  Scenario: the rollup is computed only when requested
    Given cost rows and anchors naming their initiatives
    When no rollup has been requested
    Then no rollup is computed or written for any initiative
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| Nothing links a session or its anchor to the initiative it served | the framing (Problem, req-2026-09-08-initiative-cost-rollup) | Scenario: an anchor names the initiative it serves |
| Nothing sums the cost rows per initiative | the framing (Problem, req-2026-09-08-initiative-cost-rollup) | Scenario: a leaf initiative's rollup sums its own sessions; Scenario: a parent initiative's rollup sums its children |
| A leaf initiative's own sessions | the framing (Outcome: "a leaf initiative from its sessions' rows") | Scenario: a leaf initiative's rollup sums its own sessions |
| A parent initiative's children | the framing (Outcome: "a parent from its children") | Scenario: a parent initiative's rollup sums its children |
| The rollup computed automatically rather than on request | the framing's own qualifier ("a rollup on request") | Scenario: the rollup is computed only when requested |
| The router recording the harness's usage on every anchor | the framing (second part: "the router records the harness's usage on every bead") | Out of scope: delivered already by feat-run-measurement (v9) and feat-process-runner; not re-specified here, per `single-source-of-truth` |
| Analysis of the summed rows | the appetite's first no-go (init-run-measurement §Appetite) | Out of scope: analysis belongs in a separate orchestration step, not this one |
| A rollup computed or estimated by a model | the appetite's second no-go | Scenario: a leaf initiative's rollup sums its own sessions; Scenario: a parent initiative's rollup sums its children |
| A session whose anchor was never router-moved, or a review or work-item anchor | the architect's feasibility finding and D2 (init-run-measurement history v2; adr-2026-09-08-run-cost-initiative-scope) | Out of scope: no anchor to key a row on, or scoped out by D2, the same bound as feat-run-measurement |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Authored by the PO role alone at feature-authoring's draft step, from init-run-measurement's Framing (v8) second part (req-2026-09-08-initiative-cost-rollup) and its unchanged For whom section; four scenarios, all owned by the lead shop per the unchanged Decomposition section (no Bounded Context, no contract on this branch; initiative history v2). The framing's word "bead" is rendered as "anchor," the glossary's defined term for the same record, per `use-defined-terms`; no substance changed. The router already recording usage on every anchor is not re-specified: feat-process-runner v9 and feat-run-measurement's scenarios already carry it, and a duplicate would break `single-source-of-truth`. Repository read in full, twelve other features; feat-run-measurement (v9) and feat-process-runner (v10) touched for shared vocabulary, text unchanged; no conflict found. `@hash:pending` on all four scenarios: no shell available, as disclosed by feat-run-measurement v1 and feat-process-runner v1. Declined, with the reason in Edges: analysis of the summed rows (appetite no-go 1); a session never router-moved, or a review or work-item anchor (the architect's feasibility finding and D2). Self-check against the feature fitness set: 1 pass — one event and one observable outcome per scenario, no implementation detail; 2 pass — owning shop named for all four, no interaction type so no designer criteria due, no constraint named; 3 pass on presence — both tags on all four; 4 pass — eight rows covering both problem statements, both outcome halves, the "on request" qualifier, both no-gos, and the feasibility bound with D2; 5 pass — none, reason tied to the framing and the core-task list; 6 pass — who, what, and the framing's own outcome; 7 pass — Contributors body holds only owning-shop, usability, and constraints lines. Feature id added to init-run-measurement's Features section. |
| 2 | 2026-09-08 | update | Designer's criteria added by the lead-product-designer role at feature-authoring's add-usability step, from init-run-measurement's For whom section (§2: "Interaction types: none — cost recording is incorporated into the session handoff step") and this feature's own Interaction types section, both naming no interaction type. Checked against the core-task list (basis/experience/core-tasks.md v4, its seven entries — start a run; hold, resume, or cancel a run; answer an ask; submit output for a check; read a decision; raise a clarify; deliver work for reconciliation): none names computing or reading an initiative's cost rollup, and the appetite's no-go against analysis in the step (init-run-measurement §Appetite, shared with the sibling feat-run-measurement) keeps the one activity that could become an interaction — presenting the summed rows "on request," the framing's own words — out of this feature, matching this feature's own Interaction types section. All four scenarios read against basis/experience-principles.md (v2) in full: `core-task-parity` and `accessible-by-standard` name no criterion, since no interaction type is named; `consistent-not-uniform`, `agent-is-a-user`, `evidence-not-opinion`, `errors-guide-recovery`, and `control-stays-with-the-person` likewise attach to no scenario — each Given/When/Then states an outcome on the anchor or the rollup sum directly (a field recorded, a sum computed, a sum withheld), naming no command line, terminal, graphical or web screen, API or SDK, conversational or voice exchange, or generated document. The rollup's own invocation ("run on request") is read as the same kind of tooling step as the sibling feature's cost-row write (feat-run-measurement Document History v9: write_cost_rows.py run directly, not through a designed interaction surface) and as the initiative's own designer offer already resolved for the artifact itself (init-run-measurement Document History v3, unknown U1: the artifact is raw mechanical data, not a designed presentation, until a future feature designs one) — no agent-facing tool definition is named for this feature to screen under `agent-is-a-user`. No Edges row added: no failure or boundary case is named by a usability or accessibility criterion, since none is due. Contributors' "Usability and accessibility" line left as written at v1, carrying the "none due" finding and its short reason only, per the feature typedef's rule that the body hold a contributor's criteria and nothing else; this entry carries the full reasoning and self-check. Self-check: the "none due" finding traces to the initiative's own For whom wording and this feature's own Interaction types section, not to a preference; all four scenarios re-read against the corpus's seven principles and the core-task list, none attaching; no Bounded Context's internals read, none existing on this branch. Version bumped 1 → 2. |
| 3 | 2026-09-08 | update | Non-functional constraints step run by the lead-solutions-architect role at feature-authoring's add-constraints step, from init-run-measurement's Decomposition section at its current version (v8): "None: no Bounded Context is touched — the new artifact, the runtime step, and any tooling change sit in the lead shop's own tree; no contract exists on this branch. Cross-context flow: none." — a Bounded-Context assignment, unchanged in substance since the attach-architecture offer this section carried at v2, naming no non-functional constraint of any kind (no throughput, latency, availability, security, or data-retention bound) for the rollup tool or the anchor field. Checked against the other candidate homes for a constraint before recording none: the attach-architecture offer's D1, D2, R1–R4, and U1–U4 (initiative Document History v2) are decisions, risks, and unknowns already carried by this feature's own vocabulary and its Edges row citing D2 and the feasibility finding (row 8, "a session whose anchor was never router-moved, or a review or work-item anchor"); none of them is a non-functional constraint the Decomposition section itself names, and re-deriving one here would duplicate a fact this feature's own Document History v1 already holds, contrary to `single-source-of-truth`. No constraint needing a decision not yet recorded is named. All four scenarios re-read against the Decomposition section's own text: none is bounded by a constraint it does not state. No Edges row added: no failure or boundary case is named by a non-functional constraint, since none is due. Contributors' "Non-functional constraints" line left as written at v1, carrying the "none" finding and its short reason only, per the feature typedef's rule that the body hold a contributor's criteria and nothing else; this entry carries the full reasoning and self-check. Self-check: the "none" finding traces to the Decomposition section's own current text, not to the sibling feature by analogy alone — the section itself was re-read at its current version, not assumed unchanged; the four scenarios re-checked against it; the Contributors body still holds only the owning-shop list and the two "none"/"none due" lines with their short reasons, no reasoning passage; no Bounded Context's internals read, none existing on this branch. Version bumped 2 → 3. |
| 4 | 2026-09-09 | update | Self-checked by the PO role at feature-authoring's self-check step against the feature fitness set (feature.fitness.md v17), read in full against feat-initiative-cost-rollup v3. Scenario 1 pass — each of the four scenarios' Given/When/Then names one event and one outcome observable on the anchor or the rollup sum, no step naming a file, a schema field, or a tool. Scenario 2 pass — an owning shop named for all four; no interaction type, so no designer criteria due; the decomposition naming no constraint, so none present — both match the designer's and architect's own findings at v2 and v3. Scenario 3 pass on presence — both `@feature:` and `@hash:` tags stand on all four scenarios; hash correctness is a lint, outside this judge's reach. Scenario 4: one gap found and fixed before this pass — the framing's own clause "the router records the harness's usage on every bead" named a case with no Edges row; added a row marking it out of scope, already delivered by feat-run-measurement (v9) and feat-process-runner, not re-specified here per `single-source-of-truth`; the table now stands at nine rows, under the draft step's cap of ten, and every case the framing, the appetite's two no-gos, and the architect's feasibility finding and D2 name is covered by a named scenario or a reasoned exclusion. Scenario 5 pass — the "none" reason traces to the framing's second part alone, naming the core-task list and the appetite's no-go, unaided by the initiative's For whom section. Scenario 6 pass — the narrative names the authority and the run-efficiency parent, the anchor-and-rollup capability, and an outcome — "what an initiative cost ... is known on request, in place of reading transcripts by hand" — traceable to the Framing section's Problem and second-part Outcome text. Scenario 7 pass — the Contributors body holds only the owning-shop list and the "none due"/"none" usability and constraints lines with their short reasons, no reasoning or self-check passage. Scenario 8 pass — approximately 810 words, counted across the Feature, Contributors, Interaction types, Scenarios, and Edges sections (frontmatter and this Document History table excluded, per this branch's own convention of counting a document's body separately from its history, e.g. init-run-measurement's Document History v4), against the 1,000-word target for a feature. Accepted gap, not fixed: `@hash:pending` stands on all four scenarios in place of a computed sha, unchanged since v1, because no shell is available to this self-check session; fitness scenario 3 judges tag presence, not hash correctness, so this does not block. Status set `checked`. init-run-measurement's status is already `active` (v6, on the sibling feature's pass); this step's status-write authority applies only to a `planned` initiative, so it is left unchanged. Version bumped 3 → 4. |
| 5 | 2026-09-09 | review | Scenario-assignment's assign step, by the lead-solutions-architect role, reading feat-initiative-cost-rollup v4. Pre-state: decomposition — none; this branch names no Bounded Context, and the initiative's Decomposition section already places every scenario in the lead shop's own tree, matching Contributors; contracts — none; basis/contexts/ is absent on this branch. The feature repository swept in full, fourteen other artifacts. Three of the four scenarios return unowned, each on the same case: the scenario contradicts an already-specified scenario in feat-execution-vocabulary (v9, checked) — `@hash:pending` (an anchor names the initiative it serves) names "a run" and "the run" three times as a noun for an instance and "anchor" once for the work register's identifier, contradicting feat-execution-vocabulary's `@hash:8d2f61a9c470` ("an instance of a process is named execution... never run as a noun"), `@hash:1c7b45de930f` ("run stands only as a verb"), and `@hash:96b2d4f70ae1` ("a bead is called a bead... never anchor for that identifier"); `@hash:pending` (a leaf initiative's rollup sums its own sessions) names "the cost rows for every session whose anchor names it", contradicting `@hash:96b2d4f70ae1`; `@hash:pending` (the rollup is computed only when requested) names "cost rows and anchors naming their initiatives", contradicting the same scenario. None of the three names a decomposition problem or a dual-context claim, and none asks for an owning-shop correction — Contributors' shopsystem-product line already matches the decomposition for all four; each is a specified-text conflict for the PO role to resolve against the framing, as feat-execution-vocabulary's own v5 return resolved its symmetric case (supersession, not conflict, decided there for that feature's own scenarios — a decision this sweep does not extend to a different feature's scenarios written after it without the PO role's own resolution). The fourth scenario, *a parent initiative's rollup sums its children*, names neither "run" as a noun nor "anchor" in its Given/When/Then and conflicts with nothing found in the sweep; it remains tagged `@bounded-context:shopsystem-product`, matching Contributors and the decomposition. One assignment entry computed for the owned scenario alone — context shopsystem-product, `@hash:pending` (a parent initiative's rollup sums its children), pre-state as above — not written to this history since `route` sends the run to `return`, not `dispatch`, while any scenario stands unowned (scenario-assignment-process v12, O1). No implementation guidance written: due only when no scenario is unowned. Ask: none — no scenario's ownership turns on a question the decomposition cannot answer; the conflict is the named case, not a scope question. Status set `returned`, the handoff to the PO role: the vocabulary conflict is resolved against the framing, most directly by reconciling this feature's three scenarios with feat-execution-vocabulary's target vocabulary (execution, bead) or by carrying the same supersession finding that feature's own Document History records, before reissue for assignment. |
