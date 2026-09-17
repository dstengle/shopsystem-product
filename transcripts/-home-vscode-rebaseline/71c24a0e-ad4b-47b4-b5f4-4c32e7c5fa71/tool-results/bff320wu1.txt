---
type: feature
id: feat-role-decisions
name: Roles own their decisions
status: assigned
version: 7
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
  the evidence it used — and the authority at the bet can read that
  offer,
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
- *a role offers on its decisions at its own step* — shopsystem-product (the lead shop)

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
and non-functional criteria are due were recorded at their steps below.

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

Non-functional constraints — due. The initiative's Decomposition
names no Bounded Context and no cross-context flow, so no
cross-context constraint applies; what it does name is a bound —
every amended definition sits in the lead shop's tree, and no
contract exists on this branch to rely on — and the architecture
decision record this feature implements,
[adr-2026-09-05-role-offer](../decisions/adr-2026-09-05-role-offer.md)
(checked, v3), with the authority's rulings before and at the bet
(the initiative's Document History, v7–v8), sets what an
implementation of these scenarios must hold to, under the working
principle set every session compiles in. Each constraint says what
must hold, not how; each rides on the scenarios it bounds. Pre-state
read for them: the feature repository in full — five features, the
other four `assigned` and delivered in the lead shop's tree; no
scenario elsewhere names a role's decisions, an offer, or an attach
step; touch-points: feat-roles-availability's *a role not current
with its approved definition is reconciled* and
feat-skills-availability's *a hand-diverged skill is reconciled*
carry the re-renders C2 and C6 rely on, and feat-typedef-rendering
binds none of the texts amended here, the role-definition and
initiative fitness sets being hand-written (no source digest); no
conflict. Contracts: none exist. (architect, 2026-09-06)

- C1 — one shape, one type, one home (the ADR's Decision;
  `knowable-shape`; `single-source-of-truth`): a role's offer is one
  data type in `basis/types`, under the data-type typedef — its
  Purpose naming the attach steps that produce it and the steps that
  consume it (the check of record's screen and the decide step, and
  the pre-bet route once its owner amends the process), its schema
  carrying the five parts as fields: the verdict with its reasons,
  the decisions the bet depends on each with its record or "none",
  the risks to the measure, the unknowns each with a default, and
  the evidence read — one type whichever role attaches (the
  designer's D4 answering the architect's U2), a part the role's
  domain does not cover carried as "none" with the reason, never
  omitted. The shape is stated in the type and nowhere else: neither
  an attach prompt, a role definition's section, nor the initiative
  typedef's Feasibility and usability section restates the parts —
  each references the type or is rendered from it. Rides on *a role
  attaching to an initiative offers complete information unasked*,
  *a part of the offer outside the role's domain reads none with its
  reason*, *an attachment missing a part is found before the bet*,
  *the authority reads the roles' offers from the initiative at the
  bet*. (architect, 2026-09-06)
- C2 — the definition names what the role owns; typedef, then
  instances, then renders (the ADR's bound and second consequence;
  `bidirectional-conformance`): the role-definition typedef gains
  one required section naming the decisions the role owns and that
  it offers on them, its fitness set hand-amended under the
  artifact-typedef typedef's rule for a type whose texts are not
  produced, each with a Document History row; the four role
  definitions gain the section after the typedef names it and are
  re-rendered from the definition — a rendered file is never the
  source; the definition is — and a definition carrying the section
  ahead of the typedef does not count toward the measure's 4 of 4.
  The section names decisions, not steps: it says what the role owns
  and that it offers, under the typedef's no-sequencing rule, and it
  does not restate the offer's parts (C1). Rides on *a role's
  definition names the decisions it owns*, *every lead-shop role's
  definition names the decisions it owns*, *each of the four roles
  offers on its decisions at its own step*. (architect, 2026-09-06)
- C3 — the obligation attaches to the role and the activity, not to
  the actor or to an instruction (`actor-neutral-discipline`;
  `governed-context`; the authority's words in the ADR's Context;
  the ADR's fourth consequence): the same offer is due whoever fills
  the role — the authority in person, agent-assisted, or an agent —
  and from the step's prompt as the process definition states it,
  which for the attach steps is one sentence naming the initiative
  and asking for the role's attachment or its questions; a shape gap
  found at a screen is repaired in the type (C1) or the definition
  (C2), with a row, never by an instruction added at the step; and
  an observation counts toward the measure only when the step's
  prompt was the whole instruction. Rides on *a role attaching to an
  initiative offers complete information unasked*, *a role offers on its
  decisions at its own step*, *a role's
  definition names the decisions it owns*. (architect, 2026-09-06)
- C4 — the offer is read from the initiative alone, at the
  coordinating level (`local-comprehension`; the ADR's Decision on
  rendering and its fifth consequence; the bet's ruling): every part
  of each attaching role's offer, and every record it names, is
  reachable from the initiative — the verdict with its reasons
  rendered into the Feasibility and usability section; the full
  offer where the initiative typedef's owner rules its home (the
  ADR's first candidate; at the bet the cap ruled soft with 20%
  variance) and, until that ruling, in the initiative's Document
  History as the ADR's Decision stands; a decision's record linked
  from the initiative by id. No part of an offer lives only in a
  transcript, a session record, a work item, or an ask. The evidence
  an offer names is the role's admissible evidence at the
  coordinating level — records standing in the repository: the
  initiative, the feature repository, the contracts, the decision
  records — never a Bounded Context's internals. Rides on *the
  authority reads the roles' offers from the initiative at the bet*,
  *no bet rests on an unrecorded decision*, *a role attaching to an
  initiative offers complete information unasked*. (architect,
  2026-09-06)
- C5 — a decision the bet depends on is a routable value, and its
  record is a decision record (the ADR's third consequence and third
  candidate; `bidirectional-conformance` — a design change is a
  recorded activity): each decision entry in an offer carries the id
  of a record standing in `decisions/` — an architecture decision
  record or a product decision record under its typedef, with its
  check's decision recorded through its own process — or the value
  "none"; a value a step can branch on, as `route-screen` branches
  on `review.verdict`. "A record stands" in *no bet rests on an
  unrecorded decision* means that: the decision's own record, made
  through adr-authoring or the PO role's record process before the
  decide step, and referenced from the initiative — an entry in the
  offer, a history row, or a note in a session is not the record.
  The pre-bet route that reads the value is a process amendment
  under initiative-check's owner (the ADR's D3), bounded here and
  not decided; until it lands, the lead-pm routes a "none" entry by
  hand, as it did for D1 (the initiative's v3), and the route
  landing changes no scenario. Rides on *no bet rests on an
  unrecorded decision*, *a role attaching to an initiative offers
  complete information unasked*, *the authority reads the roles'
  offers from the initiative at the bet*. (architect, 2026-09-06)
- C6 — a missing part fails by a named criterion
  (`define-good-up-front`; `least-context`; the ADR's first
  consequence): the check of record — the cold reviewer's screen,
  reading the criteria set and the initiative and nothing else —
  finds a missing part by name only if the initiative fitness set
  names the parts, so its scenario 5 is amended to judge the five
  parts, "none" with its reason a passing value and a "none" a claim
  the screen judges, hand-amended with a row before the screen is
  relied on for it; a finding by a named criterion is what keeps the
  bet unavailable — an "uncovered" finding does not, by the decide
  step's own rule — so a missing part must never be reportable only
  as uncovered. The initiative-check definition's attach steps
  output the type and are the only place the process changes for
  this; the skill is re-produced from the definition — a rendered
  file is never the source; the definition is. Rides on *an attachment
  missing a part is found before the bet*, *a part of the offer
  outside the role's domain reads none with its reason*, *no bet
  rests on an unrecorded decision*. (architect, 2026-09-06)
- C7 — no bound on a Bounded Context shop (the Decomposition; the
  ADR's "Bound on Bounded Context shops: none";
  `contracts-between-contexts`): the type, the typedef's section,
  the four definitions, the amended steps, the fitness amendment,
  and the renders sit in the lead shop's tree and bind the lead
  shop's roles only; a Bounded Context shop's own attachments stand
  under its own operational contract, and extending the shape to
  them would be a guardrail decision of this role, recorded on its
  own — none is made here. Rides on all eight scenarios as their
  scope; the Edges row *A Bounded Context shop's own role attaching*
  carries it. (architect, 2026-09-06)

Provenance, outside the constraints: the initiative's U1 (the
architect's attachment, v2) records brief-030's pending amendment to
the same typedef; its order with the section C2 names is the typedef
owner's, and no scenario here depends on it.

Screened against the architecture principle set (v6):
`knowable-shape` — conforms, the offer's shape readable from the
type and the definition's section (C1, C2);
`contracts-between-contexts` — no context touched (C7);
`actor-neutral-discipline` — conforms (C3); `local-comprehension` —
conforms (C4); `bidirectional-conformance` — conforms: each
amendment a recorded activity, definitions first and renders from
them (C2, C6), and in reverse a step writing an offer no type calls
for is a defect (C1); `intent-provenance` — rests on the exception
[adr-2026-09-04-request-front-end](../decisions/adr-2026-09-04-request-front-end.md)
carries, escalated to the authority (lead-4kymc), the ADR's own
screen — not absorbed here, and no new exception is raised.
(architect, 2026-09-06)

## Interaction types

None — the offer is made by a role at the attach step and read at the
bet inside the initiative check; no one reaches it outside a process
run (the initiative's For whom section: "the attachment is read inside
a process step; no core task carries it" — the core-task list as
provenance).

## Scenarios

```gherkin
Feature: Roles own their decisions
  The four lead-shop roles — the PM, PO, solutions architect, and
  product designer roles — can offer, from their step's instruction
  alone with nothing added by the lead-pm, complete information on
  the decisions in their domain — a verdict, the decisions the bet
  depends on, the risks to the measure, what the role does not know,
  the evidence it used — and the authority at the bet can read that
  offer,
  so that no bet rests on an unrecorded decision.

  @bounded-context:shopsystem-product @feature:feat-role-decisions @hash:aba312f2b1ae
  Scenario: a role's definition names the decisions it owns
    Given one of the four lead-shop roles
    When its definition is read
    Then the definition names the decisions in the role's domain and states that the role offers complete information on them, unasked, when it attaches to or acts on an initiative

  @bounded-context:shopsystem-product @feature:feat-role-decisions @hash:d24c8e22069d
  Scenario: every lead-shop role's definition names the decisions it owns
    Given the four lead-shop roles — the PM, PO, solutions architect, and product designer roles
    When their definitions are read
    Then each of the four names the decisions in its domain, and none leaves them to the lead-pm's instruction

  @bounded-context:shopsystem-product @feature:feat-role-decisions @hash:74a11c38f2ce
  Scenario: a role attaching to an initiative offers complete information unasked
    Given a role attaching to an initiative in the initiative check, given its step's instruction with nothing added by the lead-pm
    When the role attaches
    Then its attachment offers its verdict with reasons, the decisions the bet depends on — each with its record, or that it has none — the risks to the measure, what the role does not know, and the evidence it used

  @bounded-context:shopsystem-product @feature:feat-role-decisions @hash:a66e2bd3cd35
  Scenario: a part of the offer outside the role's domain reads none with its reason
    Given a role attaching to an initiative whose domain holds nothing under one part of the offer
    When the role attaches
    Then that part reads "none" with the role's reason, the other parts are offered, and the attachment is complete

  @bounded-context:shopsystem-product @feature:feat-role-decisions @hash:2fef03c8cc09
  Scenario: an attachment missing a part is found before the bet
    Given an initiative whose attachment lacks one part of the offer — neither content nor "none" with a reason
    When the check of record screens the initiative
    Then the missing part is reported by name as a finding, and the bet is not available while that finding stands

  @bounded-context:shopsystem-product @feature:feat-role-decisions @hash:c15c4d3bdff0
  Scenario: no bet rests on an unrecorded decision
    Given an initiative whose attachment names a decision the bet depends on as having no record
    When the initiative reaches the bet
    Then a record of that decision stands, made before the bet, and the initiative references it

  @bounded-context:shopsystem-product @feature:feat-role-decisions @hash:3ffc45cf66b9
  Scenario: the authority reads the roles' offers from the initiative at the bet
    Given an initiative with its attachments made
    When the authority reads the initiative at the bet
    Then each attaching role's complete offer is readable from the initiative alone — its verdict with reasons, the decisions the bet depends on with their records, the risks to the measure, what the role does not know, and the evidence it used

  @bounded-context:shopsystem-product @feature:feat-role-decisions @hash:a7aa73a0b41d
  Scenario: a role offers on its decisions at its own step
    Given one of the four lead-shop roles at the step of its process where it acts on an initiative, given that step's instruction with nothing added by the lead-pm
    When the role runs that step
    Then it comes back with complete information on the decisions its definition names
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| A role attaching to an initiative with no defined shape for what it must offer | the framing ("a role attaching to an initiative has no defined shape for what it must offer") | Scenario: a role attaching to an initiative offers complete information unasked — the five parts are the shape; Scenario: a role's definition names the decisions it owns — the obligation is the role's, "an aspect of the role and not just instructions from the lead-pm" |
| The lead-pm supplying the offer by hand each time — an ad-hoc instruction added to the step's | the framing ("the lead-pm supplies it by hand each time"); the For whom section's measure ("given only their step's instruction with nothing added by the lead-pm") | Scenario: a role attaching to an initiative offers complete information unasked; Scenario: a role offers on its decisions at its own step — each Given holds the instruction to the step's own; how an agent's instruction is assembled is the Appetite's first no-go, out of reach here |
| A decision the bet rests on reaching the record only if someone asks | the framing ("the decisions a bet rests on reach the record only if someone asks"; the outcome "no bet rests on an unrecorded decision") | Scenario: no bet rests on an unrecorded decision; Scenario: a role attaching to an initiative offers complete information unasked — each decision the bet depends on named with its record, or that it has none, so an unrecorded one is visible before the bet |
| A part of the offer the role's domain does not cover — "decisions or parts of decisions that are in their domain" | the framing's originator words; the For whom section (the designer's offer, one of the two baseline offers, marked no usability attachment due) | Scenario: a part of the offer outside the role's domain reads none with its reason |
| An attachment offering less than complete information — a part missing without a reason | the framing's outcome ("offers complete information on the decisions it owns") | Scenario: an attachment missing a part is found before the bet |
| The two offers made before any definition named the decisions — the baseline, 0 of 4 | the For whom section ("Now: 0 of 4 — no definition names them yet; the two offers this check produced are the baseline") | Scenario: every lead-shop role's definition names the decisions it owns; Scenario: a role offers on its decisions at its own step — the measure counts a role whose definition names the decisions and that is observed offering on them; the baseline offers show the roles can, and are not counted |
| Roles with no attach step in the initiative check — the PM and PO roles | the For whom section ("each observed at its own step") | Scenario: a role offers on its decisions at its own step — which step is each role's process's, not this feature's: a role definition says who and what for, never when |
| The target, 4 of 4 | the For whom section ("Target: 4 of 4, each observed at its own step") | Scenario: every lead-shop role's definition names the decisions it owns — the definitions; Scenario: a role offers on its decisions at its own step — one observation per role, at its own step; the measure's 4 of 4 is the aggregate: every definition naming the decisions, and each of the four roles observed by that scenario once — the count is read from the four observations, not from one run |
| The authority reading the offer at the bet | the For whom section ("The authority at the bet"); the framing's outcome (the decisions the bet depends on, recorded) | Scenario: the authority reads the roles' offers from the initiative at the bet |
| Where the full offer lives in the initiative — the word bound's split, ruled soft with 20% variance at the bet, the attachments' home the checked design decision's first candidate | the initiative's Document History (v8, the bet) | Out of scope: the initiative typedef's, the authority's own amendment outside this appetite; Scenario: the authority reads the roles' offers from the initiative at the bet holds wherever the home lands — readable from the initiative alone |
| The architect's work list, or implementation guidance, inside the offer | the initiative's Document History (v7, the authority's review before the bet: "the architect's work list is not part of it") | Out of scope: implementation guidance is its own artifact, made through req-2026-09-06-implementation-guidance; Scenario: a role attaching to an initiative offers complete information unasked names the offer's parts, and a work list is not among them |
| How an agent's instruction is assembled | the initiative's Appetite (first no-go: the step-communication request) | Out of scope: that request's; this feature changes what a role offers from the instruction it has |
| Who takes the bet and on what | the initiative's Appetite (second no-go) | Out of scope: the initiative typedef's, the authority's own; Scenario: no bet rests on an unrecorded decision and Scenario: an attachment missing a part is found before the bet state what stands at the bet, not who takes it or its subject |
| A Bounded Context shop's own role attaching | the initiative's Decomposition ("no Bounded Context is touched"); the architect's constraints (C7) | Out of scope: a Bounded Context shop's attachments stand under its own operational contract; the four roles here are the lead shop's |
| The offer's parts restated in a second home — an attach prompt, a role definition's section, or the initiative typedef's Feasibility and usability section | the architect's constraints (C1, C2) | Out of scope: where the shape is stated is judged at the data type's and the typedef's own checks under `single-source-of-truth`; the scenarios here judge attachments and definitions, not prompts |
| A part marked "none" without its reason, or a "none" the screen finds untrue for the role's domain | the architect's constraints (C1, C6) | Scenario: a part of the offer outside the role's domain reads none with its reason — the reason is part of the value; Scenario: an attachment missing a part is found before the bet — a "none" with no reason is a missing part, and a "none" is a claim the screen judges |
| A missing part reported only as an "uncovered" finding, leaving the bet available | the architect's constraints (C6) | Scenario: an attachment missing a part is found before the bet — the finding is by a named criterion, which is what holds the bet |
| A decision the bet depends on "recorded" only in the offer's own entry, a history row, a session record, or a work item | the architect's constraints (C5) | Scenario: no bet rests on an unrecorded decision — a record is a decision record under its typedef, checked through its own process before the bet |
| A decision entry naming a record that does not stand — no such record, or one still draft at the bet | the architect's constraints (C5) | Scenario: no bet rests on an unrecorded decision — "stands" is checked through its process and referenced from the initiative |
| A "none" entry reaching the bet while the process has no route to adr-authoring | the architect's constraints (C5) | Scenario: no bet rests on an unrecorded decision — the Then holds whether the route is the process's or the lead-pm's hand, as the initiative's v3 shows; the route is initiative-check's owner's to add |
| An offer, or a part of one, readable only by opening a transcript, a session record, a work item, or an ask | the architect's constraints (C4) | Scenario: the authority reads the roles' offers from the initiative at the bet |
| An offer whose evidence is a Bounded Context's internals | the architect's constraints (C4) | Out of scope: no Bounded Context exists on this branch; the evidence a role may read is its definition's admissible evidence, judged at the role definition's own check |
| A role definition's section saying at which step the role offers | the architect's constraints (C2); the role-definition typedef's no-sequencing rule | Scenario: a role's definition names the decisions it owns — "when it attaches to or acts on an initiative" names the activity, not a step; which step is the process's (the row *Roles with no attach step in the initiative check*) |
| A role definition carrying the section before the typedef names it, or the initiative fitness set judging the parts before its amendment | the architect's constraints (C2, C6) | Scenario: every lead-shop role's definition names the decisions it owns — a section the typedef does not yet require does not count toward the measure's 4 of 4; Scenario: an attachment missing a part is found before the bet — the finding is by a named criterion, so the criterion stands first |
| A rendered role file or the initiative-check skill edited by hand, or not re-produced after its definition's amendment | the architect's constraints (C2, C6) | Out of scope: feat-roles-availability's *a role not current with its approved definition is reconciled* and feat-skills-availability's *a hand-diverged skill is reconciled* carry it; this feature's scenarios read the definitions |
| The offer's shape differing by which role attaches | the architect's constraints (C1); the designer's D4 (the initiative's v4) | Scenario: a part of the offer outside the role's domain reads none with its reason — one shape, the part outside the role's domain marked "none" with its reason |
| An instruction added at the step to obtain a part the type lacks | the architect's constraints (C3) | Scenario: a role attaching to an initiative offers complete information unasked — the Given holds the instruction to the step's own; a gap is repaired in the type, and an observation made with an added instruction does not count toward the measure (the row *The lead-pm supplying the offer by hand each time*) |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Authored by the PO role alone in the feature-authoring draft step, from init-role-decisions's Framing and For whom sections (v8, planned), with sess-2026-09-05-d for the originator's words; eight scenarios, all owned by the lead shop per the initiative's Decomposition; interaction types none per its For whom; every scenario `@hash:pending` — the authoring session had no shell, so the lead-pm fills the values (sha256 of the scenario's text, first twelve hex digits, as in the repository's other features) before the check. Maker's self-check against the feature fitness set (v8), each scenario read as Given/When/Then: scenario 1 (one observable behavior) pass — each When is one action or event (a definition read, the role attaching, the check of record screening, the initiative reaching the bet, the authority reading, each role running its step), each Then observable in the running system, no step naming a data type, a typedef section, a prompt, or a route; scenario 2 (ownership and criteria) pass — an owning shop named for each of the eight; no interaction type is named, so the designer's criteria are not due at this step, and the Contributors section leaves what is due for the designer's and the architect's steps to record; scenario 3 (identity tags) pass on presence — `@feature:feat-role-decisions` and `@hash:pending` on every scenario, the hash values disclosed as pending; scenario 4 (edges) pass — fourteen rows, every case the framing's Problem, outcome, originator words, For whom, Appetite no-gos, and Decomposition name present, ten covered by scenario name, four out of scope with reasons; scenario 5 (interaction types) pass — "none" with the For whom section's reason; scenario 6 (narrative) pass — who (the four lead-shop roles; the authority at the bet and the lead-pm), what (offer complete information from the step's instruction alone; read it from the initiative), the outcome the framing's ("no bet rests on an unrecorded decision"). Status draft pending the PO output check. |
| 2 | 2026-09-06 | update | Designer's criteria added at the feature-authoring add-usability step, from the step's prompt with nothing added by the lead-pm: the Interaction types section says "none", so the Contributors section records that no usability or accessibility criteria are due, with the reason examined against the experience principle set v2 (`core-task-parity`, `accessible-by-standard`, `agent-is-a-user`, `evidence-not-opinion`) and the core-task list v4; the scenarios a usability test would invalidate named as none; no Edges rows added; no scenario text touched. Maker's self-check against the feature fitness set v8, the scenarios that concern this part: scenario 2 (ownership and criteria) pass — no type is named in the Interaction types section, so the designer's criteria are not required, and the Contributors section now states that with its reason rather than leaving it to a later step; scenario 4 (edges) pass — the contributor's criteria name no case, so the table gains no row and none is missing; scenario 5 (interaction types) pass — "none" with a reason the framing bears out: the framing's problem and outcome concern what a role offers and what the bet rests on, read inside the initiative check, and the For whom section's reason ("the attachment is read inside a process step; no core task carries it") holds against the list on examination, the one person-reading scenario reading an authored artifact that is no interaction type. Scenarios 1, 3, and 6 are the PO's part and were not re-judged here. |
| 3 | 2026-09-06 | update | Architect's constraints C1–C7 added at the feature-authoring add-constraints step, from the step's prompt with nothing added by the lead-pm: the initiative's Decomposition names no Bounded Context and no flow, so no cross-context constraint applies; what it names is a bound (the lead shop's tree; no contract), and the design decision the feature implements, adr-2026-09-05-role-offer (checked, v3), with the authority's rulings at the initiative's v7–v8, sets the constraints — one type, one home (C1); the typedef's section, then instances, then renders (C2); the obligation the role's and the activity's, the instruction unchanged (C3); the offer readable from the initiative alone (C4); a decision's record a decision record, the entry routable (C5); a missing part a named criterion's finding (C6); no Bounded Context bound (C7) — with the principles screen stated per principle. Fourteen Edges rows added and one amended (C7); no scenario text touched — the Gherkin block's sha256 before and after the edit is identical (407539f3…). Pre-state read: the feature repository in full (five features, no conflict, three touch-points named); contracts none. Maker's self-check against the feature fitness set v8, the scenarios that concern this part: scenario 2 (ownership and criteria) pass — the Contributors section says the decomposition names a bound and the design decision sets the constraints, and seven are present, each riding by name on the scenarios it bounds; scenario 4 (edges) pass — every failure or boundary case C1–C7 name has a row, each covered by a Scenario name or marked out of scope with its reason, and no earlier row was removed. Scenarios 1, 3, 5, and 6 are the PO's and the designer's parts and were not re-judged here. |
| 3 | 2026-09-06 | update | Hashes filled by the lead-pm on 2026-09-06 by the repository convention — sha256 of each scenario's text (its Scenario line and steps), first twelve hex digits — replacing the eight `@hash:pending` values the draft carried; scenario text unchanged. |
| 3 | 2026-09-06 | review | PO output check, the one screen (judge: claude-fable-5-1 / screen prompt v6): one confident — the Contributors sentence leaving the criteria "for the designer's and the architect's steps to record" stale once both were in; six wobbly, ruled by the PM role — the eighth scenario's Given and Then aggregating four roles in one run; the narrative's outcome clause naming the offer's home and the lead-pm beyond the framing's words; C2 carrying brief-030's ordering clause; C2 and C6 naming rendering tools; the Interaction types reason not in the framing's terms; the 4-of-4 count inside a scenario's Then. |
| 4 | 2026-09-06 | update | The one revise, all seven: the Contributors sentence in the past tense ("were recorded at their steps below"); the eighth scenario made per role — *a role offers on its decisions at its own step*: Given one of the four lead-shop roles at the step of its process where it acts on an initiative, given that step's instruction with nothing added by the lead-pm; When the role runs that step; Then it comes back with complete information on the decisions its definition names — a new scenario by hash (`@hash:pending`, the lead-pm fills it), the 4-of-4 aggregate moved to the Edges row *The target, 4 of 4*, and the ownership list, four Edges rows, and C2's and C3's "Rides on" lists renamed to it; the narrative's outcome clause in the framing's words — "and the authority at the bet can read that offer" — in §1 and the block head alike (the narrative is not hashed), the offer's home left to C4; the Interaction types reason restated in the framing's terms with the core-task list as provenance. Edits to the architect's passages on the PM role's ruling, substance unchanged: C2's brief-030 ordering clause cut and its Edges row removed, a one-line provenance note added outside the constraints; C2's "re-rendered by role-rendering, never edited in the rendered file" and C6's "re-produced from the definition by the rendering tool, never edited by hand" each restated as the what — "a rendered file is never the source; the definition is". Maker's self-check against the feature fitness set v8 after the revise: scenario 1 pass — the new eighth scenario has one Given, one When (the role runs that step), one observable Then, no count and no implementation detail; the other seven unchanged; scenario 2 pass — the ownership list names the lead shop for the renamed scenario; the designer's and architect's passages present and the sentence introducing them no longer defers them; scenario 3 pass on presence — `@feature:` on all eight, `@hash:` on all eight, one pending; scenario 4 pass — the brief-030 row removed with its constraint clause, so no case in the table lacks a source, and the four rows naming the eighth scenario name its new title; scenario 5 pass — "none" with a reason in the framing's terms; scenario 6 pass — who, what, and the outcome, the outcome's clause now the framing's words. |
| 5 | 2026-09-06 | state | `draft` → `checked`: the PM role's pass after the one screen and the one revise the process allows — the confident finding (a stale sentence) repaired; the wobbly ones ruled: the eighth scenario per role, the narrative in the framing's words, the tool names out of the constraints. The last hash filled by the lead-pm after the revise. |
| 6 | 2026-09-06 | state | `checked` → `assigned`: the scenario-assignment record step (process v12). One assignment entry — context shopsystem-product (the lead shop), scenarios @hash:aba312f2b1ae, @hash:d24c8e22069d, @hash:74a11c38f2ce, @hash:a66e2bd3cd35, @hash:2fef03c8cc09, @hash:c15c4d3bdff0, @hash:3ffc45cf66b9, @hash:a7aa73a0b41d — each tagged `@bounded-context:shopsystem-product`, the owning shop the Contributors section names for every scenario, and the decomposition's ruling — no Bounded Context touched; every amended definition in the lead shop's tree. Pre-state read from the lead shop's records: the role-definition typedef at v3 (two required sections, none naming a role's decisions) and its fitness set at v2, hand-written; the initiative typedef at v10 (§4 asking the verdict with reasons; the 500-word rule) and its fitness set at v4, hand-written, scenario 5 judging the verdict's presence alone; initiative-check at v7, its two attach steps outputting `initiative` only with the shape carried in their prompts; the data-type typedef at v3 with twelve types and none carrying an offer; the four role definitions at lead-pm v9, lead-po v13, lead-solutions-architect v10, lead-product-designer v2; adr-2026-09-05-role-offer at v3 (checked); the feature repository swept in full — five artifacts, this feature and the four assigned, no conflict: feat-request-routing specifies the recording and routing of asks and the lane, the two availability features checks over rendered role and process definitions, feat-typedef-rendering a type's produced texts, and no scenario of any names a role's decisions, an offer, an attachment, or the bet; the touch-points are the two reconcile scenarios (@hash:d707d4311bdf, @hash:26f78a3ca4a6), which carry the re-renders C2 and C6 rely on and contradict none, and feat-typedef-rendering, which binds produced texts only, the two fitness sets amended here being hand-written; no BC contract in the pre-state — the decomposition names no context and none exists on this branch. Implementation guidance written, one record for the one context: guidance/feat-role-decisions-shopsystem-product.md (v1, written) — the definitions and tools to change in order, with versions and invocations; maker's evaluation against the implementation-guidance fitness set v1, all five pass: at the architect's level (definitions, tools, and step ids named, no internals); cited never restated (hashes and versions only, the offer's parts pointed at in the ADR, not listed); actionable alone (every definition, tool, check, and order named; what is not in this assignment named as such); each thing not to do with its reason (ten entries, each to a principle, a constraint, a typedef's rule, or the bound); bound to one assignment (frontmatter and opening paragraph). Not sent. Sent: none — the owning shop is the lead shop itself; the freeze bars dispatch and no Bounded Context exists to receive; the gap stands as lead-ki66p. |
| 7 | 2026-09-06 | update | Delivered in the lead shop's own tree from the scenarios and guidance/feat-role-decisions-shopsystem-product.md alone: role-offer type v1 (scenarios 3, 4, 6; C1, C4, C5); role-definition typedef v4 and its fitness set v3, the four role definitions (scenarios 1, 2; C2); initiative-check v8 with one-sentence attach prompts outputting the type, skill re-rendered (scenario 3; C3, C6); initiative typedef v11, its fitness set v5 and guideline v5 (scenarios 5, 7; C4, C6); renders re-produced (C2, C6). Demonstrated: the definitions and renderings current at the load points; the attach prompt as one sentence. Not demonstrated by a run this session: scenario 8's four observations at their own steps under the changed definitions — the next initiative check, frame, and draft runs are where they are read. |
