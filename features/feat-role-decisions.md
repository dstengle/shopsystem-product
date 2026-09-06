---
type: feature
id: feat-role-decisions
name: Roles own their decisions
status: draft
version: 2
initiative: ../initiatives/init-role-decisions.md
owner: lead-po
created: 2026-09-06
updated: 2026-09-06
---

# Feature: Roles own their decisions

## Feature

Feature: Roles own their decisions
  The four lead-shop roles — the PM, PO, solutions architect, and
  product designer roles — can offer, from their step's instruction
  alone with nothing added by the lead-pm, complete information on
  the decisions in their domain — a verdict, the decisions the bet
  depends on, the risks to the measure, what the role does not know,
  the evidence it used — and the authority at the bet and the lead-pm
  can read that offer from the initiative,
  so that no bet rests on an unrecorded decision.

## Contributors

Owning shop, per scenario — from the initiative's Decomposition
section, which names no Bounded Context: every amended definition
sits in the lead shop's tree, and no contract exists on this branch.

- *a role's definition names the decisions it owns* — shopsystem-product (the lead shop)
- *every lead-shop role's definition names the decisions it owns* — shopsystem-product (the lead shop)
- *a role attaching to an initiative offers complete information unasked* — shopsystem-product (the lead shop)
- *a part of the offer outside the role's domain reads none with its reason* — shopsystem-product (the lead shop)
- *an attachment missing a part is found before the bet* — shopsystem-product (the lead shop)
- *no bet rests on an unrecorded decision* — shopsystem-product (the lead shop)
- *the authority reads the roles' offers from the initiative at the bet* — shopsystem-product (the lead shop)
- *each of the four roles offers on its decisions at its own step* — shopsystem-product (the lead shop)

Vocabulary: *attach* is the initiative typedef's word for a role
writing into an initiative the section it owns before the bet — the
solutions architect role its feasibility and the decomposition, the
product designer role its usability evidence — in the initiative check;
an *attachment* is what it writes there. A role's *offer* is the
complete information it gives on the decisions in its domain, unasked:
its verdict with reasons, the decisions the bet depends on, the risks to
the measure, what it does not know, and the evidence it used — the
framing's five parts; an attachment carries the role's offer. *The
decisions a role owns* are the decisions, or parts of decisions, in the
role's domain (glossary: the role definition's exclusive domain and
decision rights), which its definition names. *The measure* is the
initiative's — roles whose definition names the decisions they own and
that, from their step's instruction alone, come back with complete
information on them; the *bet* and the *check of record* are the
glossary's terms. A role *acts on an initiative at its own step* when a
process names the role in a step that reads or writes the initiative;
which step that is for each role is its process's, since a role
definition says who and what for, never when.

The initiative's For whom section names no interaction type and its
Decomposition names no Bounded Context; what usability, accessibility,
and non-functional criteria are due is for the designer's and the
architect's steps to record.

Usability and accessibility criteria (product designer role, add-usability
step, 2026-09-06): none due, on examination of the eight scenarios against
the experience principle set v2 and the core-task list v4, not by default
from the "none". Every reader the scenarios name — a role reading a
definition, a role attaching, the check of record screening, the authority
reading the initiative at the bet, a role running its step — reads inside
a process step; the one person among them, the authority in scenario *the
authority reads the roles' offers from the initiative at the bet*, reads
an authored artifact in the repository, which is no interaction type in
the glossary's closed set (not a generated document or notification).
Against `core-task-parity`, no task on the list carries a role's
attachment; the nearest, *read a decision*, reads the check-decision the
attachment feeds, not the attachment, and no eighth task is added (the
initiative's Document History v4, D5). Against `accessible-by-standard`,
no interaction is delivered, so no accessibility target applies. Against
`agent-is-a-user`, the offer's data type (adr-2026-09-05-role-offer) is
outside the principle's closed set, so no interface screen is owed on this
feature; the screen of the type's field names when it is drafted is a
recommendation to the solutions architect role, recorded at the
initiative's v4 (U4), not a criterion here. Scenarios a usability test
would invalidate: none — no scenario claims an interaction is usable, so
nothing is labeled a hypothesis under `evidence-not-opinion`; scenario
*the authority reads the roles' offers from the initiative at the bet*
asks that the offer be readable from the initiative alone, and where in
the initiative it is read is the offer's home, ruled at the bet (the
initiative's v8: the cap soft with 20% variance, the attachments' home the
ADR's first candidate), with one observation bearing on it — the authority
read both baseline offers from the initiative's Document History and ruled
(v7–v8). No Edges rows are added: no criteria name a case.

## Interaction types

None — the attachment is read inside a process step; no core task
carries it (the initiative's For whom section).

## Scenarios

```gherkin
Feature: Roles own their decisions
  The four lead-shop roles — the PM, PO, solutions architect, and
  product designer roles — can offer, from their step's instruction
  alone with nothing added by the lead-pm, complete information on
  the decisions in their domain — a verdict, the decisions the bet
  depends on, the risks to the measure, what the role does not know,
  the evidence it used — and the authority at the bet and the lead-pm
  can read that offer from the initiative,
  so that no bet rests on an unrecorded decision.

  @feature:feat-role-decisions @hash:aba312f2b1ae
  Scenario: a role's definition names the decisions it owns
    Given one of the four lead-shop roles
    When its definition is read
    Then the definition names the decisions in the role's domain and states that the role offers complete information on them, unasked, when it attaches to or acts on an initiative

  @feature:feat-role-decisions @hash:d24c8e22069d
  Scenario: every lead-shop role's definition names the decisions it owns
    Given the four lead-shop roles — the PM, PO, solutions architect, and product designer roles
    When their definitions are read
    Then each of the four names the decisions in its domain, and none leaves them to the lead-pm's instruction

  @feature:feat-role-decisions @hash:74a11c38f2ce
  Scenario: a role attaching to an initiative offers complete information unasked
    Given a role attaching to an initiative in the initiative check, given its step's instruction with nothing added by the lead-pm
    When the role attaches
    Then its attachment offers its verdict with reasons, the decisions the bet depends on — each with its record, or that it has none — the risks to the measure, what the role does not know, and the evidence it used

  @feature:feat-role-decisions @hash:a66e2bd3cd35
  Scenario: a part of the offer outside the role's domain reads none with its reason
    Given a role attaching to an initiative whose domain holds nothing under one part of the offer
    When the role attaches
    Then that part reads "none" with the role's reason, the other parts are offered, and the attachment is complete

  @feature:feat-role-decisions @hash:2fef03c8cc09
  Scenario: an attachment missing a part is found before the bet
    Given an initiative whose attachment lacks one part of the offer — neither content nor "none" with a reason
    When the check of record screens the initiative
    Then the missing part is reported by name as a finding, and the bet is not available while that finding stands

  @feature:feat-role-decisions @hash:c15c4d3bdff0
  Scenario: no bet rests on an unrecorded decision
    Given an initiative whose attachment names a decision the bet depends on as having no record
    When the initiative reaches the bet
    Then a record of that decision stands, made before the bet, and the initiative references it

  @feature:feat-role-decisions @hash:3ffc45cf66b9
  Scenario: the authority reads the roles' offers from the initiative at the bet
    Given an initiative with its attachments made
    When the authority reads the initiative at the bet
    Then each attaching role's complete offer is readable from the initiative alone — its verdict with reasons, the decisions the bet depends on with their records, the risks to the measure, what the role does not know, and the evidence it used

  @feature:feat-role-decisions @hash:f7e1bb9a8d48
  Scenario: each of the four roles offers on its decisions at its own step
    Given the four lead-shop roles, each at the step of its own process where it acts on an initiative in its domain, given that step's instruction with nothing added by the lead-pm
    When each role runs its step
    Then each of the four comes back with complete information on the decisions its definition names — the measure's 4 of 4
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| A role attaching to an initiative with no defined shape for what it must offer | the framing ("a role attaching to an initiative has no defined shape for what it must offer") | Scenario: a role attaching to an initiative offers complete information unasked — the five parts are the shape; Scenario: a role's definition names the decisions it owns — the obligation is the role's, "an aspect of the role and not just instructions from the lead-pm" |
| The lead-pm supplying the offer by hand each time — an ad-hoc instruction added to the step's | the framing ("the lead-pm supplies it by hand each time"); the For whom section's measure ("given only their step's instruction with nothing added by the lead-pm") | Scenario: a role attaching to an initiative offers complete information unasked; Scenario: each of the four roles offers on its decisions at its own step — each Given holds the instruction to the step's own; how an agent's instruction is assembled is the Appetite's first no-go, out of reach here |
| A decision the bet rests on reaching the record only if someone asks | the framing ("the decisions a bet rests on reach the record only if someone asks"; the outcome "no bet rests on an unrecorded decision") | Scenario: no bet rests on an unrecorded decision; Scenario: a role attaching to an initiative offers complete information unasked — each decision the bet depends on named with its record, or that it has none, so an unrecorded one is visible before the bet |
| A part of the offer the role's domain does not cover — "decisions or parts of decisions that are in their domain" | the framing's originator words; the For whom section (the designer's offer, one of the two baseline offers, marked no usability attachment due) | Scenario: a part of the offer outside the role's domain reads none with its reason |
| An attachment offering less than complete information — a part missing without a reason | the framing's outcome ("offers complete information on the decisions it owns") | Scenario: an attachment missing a part is found before the bet |
| The two offers made before any definition named the decisions — the baseline, 0 of 4 | the For whom section ("Now: 0 of 4 — no definition names them yet; the two offers this check produced are the baseline") | Scenario: every lead-shop role's definition names the decisions it owns; Scenario: each of the four roles offers on its decisions at its own step — the measure counts a role whose definition names the decisions and that is observed offering on them; the baseline offers show the roles can, and are not counted |
| Roles with no attach step in the initiative check — the PM and PO roles | the For whom section ("each observed at its own step") | Scenario: each of the four roles offers on its decisions at its own step — which step is each role's process's, not this feature's: a role definition says who and what for, never when |
| The target, 4 of 4 | the For whom section ("Target: 4 of 4, each observed at its own step") | Scenario: every lead-shop role's definition names the decisions it owns — the definitions; Scenario: each of the four roles offers on its decisions at its own step — the observations |
| The authority reading the offer at the bet | the For whom section ("The authority at the bet"); the framing's outcome (the decisions the bet depends on, recorded) | Scenario: the authority reads the roles' offers from the initiative at the bet |
| Where the full offer lives in the initiative — the word bound's split, ruled soft with 20% variance at the bet, the attachments' home the checked design decision's first candidate | the initiative's Document History (v8, the bet) | Out of scope: the initiative typedef's, the authority's own amendment outside this appetite; Scenario: the authority reads the roles' offers from the initiative at the bet holds wherever the home lands — readable from the initiative alone |
| The architect's work list, or implementation guidance, inside the offer | the initiative's Document History (v7, the authority's review before the bet: "the architect's work list is not part of it") | Out of scope: implementation guidance is its own artifact, made through req-2026-09-06-implementation-guidance; Scenario: a role attaching to an initiative offers complete information unasked names the offer's parts, and a work list is not among them |
| How an agent's instruction is assembled | the initiative's Appetite (first no-go: the step-communication request) | Out of scope: that request's; this feature changes what a role offers from the instruction it has |
| Who takes the bet and on what | the initiative's Appetite (second no-go) | Out of scope: the initiative typedef's, the authority's own; Scenario: no bet rests on an unrecorded decision and Scenario: an attachment missing a part is found before the bet state what stands at the bet, not who takes it or its subject |
| A Bounded Context shop's own role attaching | the initiative's Decomposition ("no Bounded Context is touched") | Out of scope: a Bounded Context shop's attachments stand under its own operational contract; the four roles here are the lead shop's |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Authored by the PO role alone in the feature-authoring draft step, from init-role-decisions's Framing and For whom sections (v8, planned), with sess-2026-09-05-d for the originator's words; eight scenarios, all owned by the lead shop per the initiative's Decomposition; interaction types none per its For whom; every scenario `@hash:pending` — the authoring session had no shell, so the lead-pm fills the values (sha256 of the scenario's text, first twelve hex digits, as in the repository's other features) before the check. Maker's self-check against the feature fitness set (v8), each scenario read as Given/When/Then: scenario 1 (one observable behavior) pass — each When is one action or event (a definition read, the role attaching, the check of record screening, the initiative reaching the bet, the authority reading, each role running its step), each Then observable in the running system, no step naming a data type, a typedef section, a prompt, or a route; scenario 2 (ownership and criteria) pass — an owning shop named for each of the eight; no interaction type is named, so the designer's criteria are not due at this step, and the Contributors section leaves what is due for the designer's and the architect's steps to record; scenario 3 (identity tags) pass on presence — `@feature:feat-role-decisions` and `@hash:pending` on every scenario, the hash values disclosed as pending; scenario 4 (edges) pass — fourteen rows, every case the framing's Problem, outcome, originator words, For whom, Appetite no-gos, and Decomposition name present, ten covered by scenario name, four out of scope with reasons; scenario 5 (interaction types) pass — "none" with the For whom section's reason; scenario 6 (narrative) pass — who (the four lead-shop roles; the authority at the bet and the lead-pm), what (offer complete information from the step's instruction alone; read it from the initiative), the outcome the framing's ("no bet rests on an unrecorded decision"). Status draft pending the PO output check. |
| 2 | 2026-09-06 | update | Designer's criteria added at the feature-authoring add-usability step, from the step's prompt with nothing added by the lead-pm: the Interaction types section says "none", so the Contributors section records that no usability or accessibility criteria are due, with the reason examined against the experience principle set v2 (`core-task-parity`, `accessible-by-standard`, `agent-is-a-user`, `evidence-not-opinion`) and the core-task list v4; the scenarios a usability test would invalidate named as none; no Edges rows added; no scenario text touched. Maker's self-check against the feature fitness set v8, the scenarios that concern this part: scenario 2 (ownership and criteria) pass — no type is named in the Interaction types section, so the designer's criteria are not required, and the Contributors section now states that with its reason rather than leaving it to a later step; scenario 4 (edges) pass — the contributor's criteria name no case, so the table gains no row and none is missing; scenario 5 (interaction types) pass — "none" with a reason the framing bears out: the framing's problem and outcome concern what a role offers and what the bet rests on, read inside the initiative check, and the For whom section's reason ("the attachment is read inside a process step; no core task carries it") holds against the list on examination, the one person-reading scenario reading an authored artifact that is no interaction type. Scenarios 1, 3, and 6 are the PO's part and were not re-judged here. |
