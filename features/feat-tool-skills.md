---
type: feature
id: feat-tool-skills
name: Tool skills
status: assigned
version: 6
initiative: ../initiatives/init-tool-skills.md
owner: lead-po
created: 2026-09-07
updated: 2026-09-07
---

# Feature: Tool skills

## Feature

Feature: Tool skills
  Every agent of the shop that runs a tool, and the shops whose tools
  the product accepts,
  can use a framework tool through a skill that states, for each use
  it supports, what it does, what it takes, what it returns, and how
  it fails — the skill produced from what the tool says about itself
  in answer to one standard question, proven end to end on the lint —
  so that every framework tool is usable through a skill produced
  from the tool's own answer: a tool from any shop is usable the
  moment it answers, and a change to what a tool says about itself
  reaches its skill.

## Contributors

Owning shop, per scenario — from the initiative's Decomposition
section, which names no Bounded Context: every change sits in the
lead shop's tree, no contract exists on this branch, and the
cross-context flow is none.

- *the lint answers the standard question* — shopsystem-product (the lead shop)
- *the answer states each use's returns and failures as parts of their own* — shopsystem-product (the lead shop)
- *the lint's skill is produced from the lint's own answer* — shopsystem-product (the lead shop)
- *each use entry in the lint's skill is complete* — shopsystem-product (the lead shop)
- *a change to what the lint says about itself reaches its skill* — shopsystem-product (the lead shop)
- *a tool skill not current with its tool's answer is reported* — shopsystem-product (the lead shop)
- *the check over the load point passes clean with the lint's skill in place* — shopsystem-product (the lead shop)
- *the lint's skill is loaded for a task that calls for the lint* — shopsystem-product (the lead shop)
- *an agent completes a use of the lint on the first invocation the skill states* — shopsystem-product (the lead shop)
- *a failure the agent meets is one the skill names, read as the skill states it* — shopsystem-product (the lead shop)

Vocabulary, one term per entry, in the order the scenarios use them:

- **framework tool**, **skill**, **gap** — the glossary's terms: a
  tool the shop's definitions name for an activity; the rendering at
  the agent's load point that states an activity or a tool's use so
  an agent performs it from the definition alone; a missing
  definition, tool, or skill the shop records rather than works
  around.
- **the lint** — the framework tool every session runs over the
  definition corpus; the initiative's target of 1, the tool the proof
  runs on.
- **the standard question** — the framing's word for the one question
  every framework tool is asked about itself, the same question for
  every tool from any shop. The decision the bet rests on,
  [adr-2026-09-07-tool-answer](../decisions/adr-2026-09-07-tool-answer.md)
  (checked), fixes the question and the shape of its answer; the
  scenarios name neither.
- **the answer** — what the tool says about itself in reply to the
  standard question: its name, what it does, and one use entry per
  use it supports.
- **use**, **use entry** — one thing a tool can be asked to do (the
  lint's, by its definitions: a run over the definition corpus; the
  derivation of one artifact type's chain; the check of one process
  definition — the answer decides the list); its entry, the four parts
  the framing names — what it does, what it takes, what it returns,
  how it fails — and, in the skill, the exact invocation.
- **a part of its own** — a part of a use entry that is present as
  itself, not inferred from another part: what a use returns stated,
  not read off what it takes; how it fails stated, not read off what
  it returns.
- **produced from** — the skill is produced from the answer when it
  is, in the glossary's term, a rendering of it: never edited by
  hand, never the source; a produced skill names the tool it is
  produced from.
- **current with** — a skill is current with its tool's answer when
  the skill is what a fresh production from the answer as the tool
  now gives it would yield; an answer changed since the production
  and a skill changed by hand each leave a skill that is not current.
  This is what "current with" means in every Then.
- **the process that keeps tool skills current** — the process whose
  run produces each tool skill from its tool's answer as the tool now
  gives it, and whose check is the check over tool skills.
- **the check over tool skills** — the check that reads each tool
  skill against its tool's answer and reports one that is not
  current.
- **the agent's load point** — where the agent runtime loads skills
  from; the place feat-skills-availability's scenarios read.
- **the check over the load point** — the check feat-skills-availability
  specifies over the agent's load point, which today names any skill
  whose source it does not recognize.
- **a fresh context**, **its only source on the lint** — an agent
  whose context holds the lint's skill and nothing else about the
  lint: not the lint's source, not its help, not a prior command, not
  another agent's run.
- **the first invocation** — the first command the agent issues to
  the lint for a use; the skill states one per use.
- **a bare invocation** — the lint run other than as its skill states
  it; the working principle `tools-through-skills` has an agent
  prefer the skill over it.
- **a stable code** — a failure's identifier, the same on every run
  that fails the same way, from a closed set the skill names.
- **the proof** — the initiative's Appetite: the lint answering the
  standard question, the skill produced from the answer and current
  with it by a check, and an agent in a fresh context, the skill its
  only source, completing the lint's uses and reading one failure as
  the skill states it.

Provenance of the scenarios, outside the ownership list: the last
three scenarios and *each use entry in the lint's skill is complete*
serve the framing's "usable through a skill" and stand on the
product designer role's usability acceptance criteria (a)–(c) for the
PO role, offered in the initiative's Feasibility and usability
section and its Document History (v5): (a) the agent's first
invocation of each use is the one the skill states; (b) each use
entry is complete, invalidated by a failure the agent meets that the
skill does not name; (c) the skill's description gets the skill
offered for the task. *The answer states each use's returns and
failures as parts of their own* stands on the solutions architect
role's risk (the initiative's Document History, v3, its third risk):
the proof's check must read those parts present, not the question
answered. The initiative's For whom section names no interaction type
and its Decomposition names no Bounded Context; what usability,
accessibility, and non-functional criteria are due, the designer's
and the architect's steps record below.

The product designer role's criteria (feature-authoring's
add-usability step, 2026-09-07):

*Due: none.* The Interaction types section says "none", and the
reason holds against the corpus: the core-task list (v4) carries no
task a tool skill or a tool's answer completes, so `core-task-parity`
has no hold, and the typedef's §2 asks this role's usability and
accessibility criteria only where a core task carries the capability.
That section answers parity — which types the capability must be
available on. It does not answer whether the capability delivers an
interface, and this one delivers two an agent uses, which
`agent-is-a-user` bullet 1 makes this role's to design and screen
whether or not a type is named: the lint's skill, an agent tool
definition (the `api` type, the api guideline's voice principle — an
agent reading it with nothing else); and the lint's answer to the
standard question, a command-line interaction on the lint (the `cli`
type, the cli guideline; clig.dev its platform guideline). The
criteria below stand on that ground, as the initiative attachment
(v5) offered them, and each is a hypothesis under
`evidence-not-opinion` bullet 1 until the run named under it is
observed; the evidence form is measured task completion, the corpus's
admissible form, the invocations and results recorded in the
delivery.

Usability acceptance criteria, riding on the scenarios by name, no
scenario text changed:

- (a) *the first invocation is the skill's* — rides on *an agent
  completes a use of the lint on the first invocation the skill
  states*, read once per use the skill states, and on *the lint's
  skill is loaded for a task that calls for the lint*. Met when the
  agent's first command to the lint for a use is the invocation the
  skill states for that use and the use completes with the return the
  skill states. Invalidated by a read of the lint's source or help, a
  second attempt, or a bare invocation with the skill present.
- (b) *each use entry is complete* — rides on *each use entry in the
  lint's skill is complete* (the api guideline's rules 1–3: named for
  the caller; the effect, omitted inputs' treatment, the return, each
  failure; a stable code beside its explanation and next step — the
  error pattern, common guideline rule 3) and, as its test in use, on
  *a failure the agent meets is one the skill names, read as the skill
  states it*. Met when every use entry carries the five parts the
  scenario states and the one failing run's failure is one its entry
  names, read by the agent from the skill alone. Invalidated by a
  failure the agent meets that the skill does not name, or a part
  inferred from another rather than present.
- (c) *the skill is offered for the task* — rides on *the lint's
  skill is loaded for a task that calls for the lint*. Met when, in a
  fresh context with the skill at the load point, the skill is loaded
  for a task calling for the lint before any invocation. Invalidated
  by the agent proceeding to a bare invocation with the skill present,
  whatever the cause; a description that does not name the tool and
  its uses is the expected cause (the initiative's Document History
  v5, R3), and its remedy is the producer's, not a scenario.

*Accessibility criteria: none due* — no type is named; and by
`accessible-by-standard`, the skill is an agent-facing interface
governed by `agent-is-a-user` (bullet 2's parenthetical), so no WCAG
target applies to it, and the lint's answer is a `cli` interaction
whose WCAG2ICT application and applicability record (text on
standard output; no meaning resting on colour, cli rule 1) are
written at the delivery screen, not as an acceptance criterion: no
scenario names the answer's form, and a criterion naming one would
put an implementation detail in a Then (Edges row added).

Until *an agent completes a use of the lint on the first invocation
the skill states* and *a failure the agent meets is one the skill
names, read as the skill states it* are observed, "usable" is a
hypothesis and the delivery says so (the Edges row on it stands). The
delivered skill (`api`) and the answer (`cli`) are screened by this
role at delivery under the interaction-conformance-check process,
findings to the solutions architect role and undecidables to the
corpus — a delivery gate the Edges table already holds, not a
criterion.

The solutions architect role's constraints (feature-authoring's
add-constraints step, 2026-09-07):

*Contract bound: none; cross-context flow: none.* The initiative's
Decomposition section names no Bounded Context — every change sits in
the lead shop's tree, no contract exists on this branch, and the
cross-context flow is none — so no contract's bound and no flow binds
these scenarios, and every scenario stays the lead shop's. Pre-state
read from lead-shop-held records, none from a context's internals: the
feature repository in full — six features; the five assigned ones name
no framework tool, no tool's answer, and no tool skill; the one
touch-point is feat-skills-availability's check over the load point,
carried in the Given of *the check over the load point passes clean
with the lint's skill in place* and in its Edges row; no conflict —
and the decision records, which hold no contract on this branch.

*Guardrail: one, and it binds.* The decision the bet rests on,
[adr-2026-09-07-tool-answer](../decisions/adr-2026-09-07-tool-answer.md)
(checked, v3), is a guardrail under this role's right, and its first
consequence and its bound reach the lead shop's own tools as they
reach a Bounded Context shop's: the lint is a framework tool the
product uses, and the scenarios' "the standard question" and "the
answer" are what that record fixes and this feature declines to name.
The constraints below are that record's bounds read onto the
scenarios — what must hold, not how the lint, the producer, or the
check does it; the how is the maker's within them, and a choice
outside them is raised as a question against the record, not vetoed
here. Six, none new: each is a sentence of the record's §2, §3, or its
bound, riding on the scenarios by name, no scenario text changed.

- (1) *what counts as an answer* — rides on *the lint answers the
  standard question* and *the answer states each use's returns and
  failures as parts of their own*. The lint's reply is an answer only
  as the record's §2 counts one: given on the standard flag the record
  fixes, written to standard output with exit status 0 before any
  other action and with other arguments ignored, and parsing against
  the tool-description data type; any other reply — a traceback, a
  usage sheet, the normal function run, an exit status other than 0,
  output that does not parse — is "cannot answer", the first
  scenario's Then unmet, and the proof not begun. Held only when both
  observations are made together: the exit status and the parse.
- (2) *the shape is the contract's* — rides on *the answer states each
  use's returns and failures as parts of their own* and *each use
  entry in the lint's skill is complete*. The parts a use entry states
  — what it does, what it takes, what it returns, how it fails, the
  exact invocation — are fields of the tool-description data type
  (`basis/types/tool-description.md`, the versioned contract the
  record's §2 names; relationship kind: the shape a published
  language, the answering tool an open host service), under the data
  type's names, each present as a field the check reads — the
  initiative's third risk (Document History v3) — not as prose the
  check interprets; a failure entry carries the four things the data
  type fixes (a stable code from its closed set, the exit status, the
  condition, the caller's next step); no per-tool variant of the
  shape. Bound on this feature's delivery: the data type stands —
  approved through the definition chain — before the check reads an
  answer against it; the record's second consequence names it, and it
  is enabler work this role recommends into the PO role's backlog
  (Edges row added).
- (3) *sole source, and the direction of repair* — rides on *the
  lint's skill is produced from the lint's own answer*, *a change to
  what the lint says about itself reaches its skill*, and *a tool
  skill not current with its tool's answer is reported*. The answer is
  the skill's sole source (the record's one sentence); "current with"
  is decided by asking the tool again and digesting the fresh answer
  as it comes — never from a copy of the answer kept since the last
  production, never from the tool's source; and a difference resolves
  toward the answer, always: the skill is re-produced from it, the
  answer is not edited to agree with a skill, and a hand-edited skill
  does not survive the next production.
- (4) *the load-point check recognizes, never exempts* — rides on *the
  check over the load point passes clean with the lint's skill in
  place*. The lint's skill carries the provenance the check over the
  load point already reads for a process skill — the source it was
  produced from and a digest over that source — so the check reads it
  by its source kind, whether the skill-rendering process is amended
  or a sibling process is defined for tool skills (the record's third
  consequence; the process owner's choice); it is not passed by an
  exemption, a skip list, or a hand-marked exception. Until the
  recognition lands, the lint's skill at the load point is a standing
  `unrecognized` escalation and the scenario's Then is unmet — the
  initiative's first risk — and feat-skills-availability's seven
  scenarios pass exactly as they do today (the Edges row on them
  stands).
- (5) *the answer's form binds no shop's language* — rides on *the
  lint answers the standard question* and *the lint's skill is
  produced from the lint's own answer*. The framed outcome it
  protects: a tool from any shop is usable the moment it answers. So
  the answer is given in a form a tool written in any shop's language
  gives from that language's standard library (the record's JSON
  bound), and neither answering the question nor producing the skill
  from the answer adds a dependency that binds a shop's language. A
  dependency, a vendor, or a recurring cost added by the proof is the
  record's delivery read by this role, not a scenario (the Edges row
  on it stands).
- (6) *the skill is the artifact of use* — rides on *the lint's skill
  is loaded for a task that calls for the lint*, *an agent completes
  a use of the lint on the first invocation the skill states*, and *a
  failure the agent meets is one the skill names, read as the skill
  states it*. The invocation the skill states for a use is the use's
  command line as the answer gave it, and it is the invocation
  whoever performs the step (the record's fifth consequence). The
  proof's fresh context holds the skill and nothing else on the lint
  — not the lint's answer either: the answer is the artifact for
  producing the skill, the skill the designated artifact for using the
  tool at the shop's level (`local-comprehension`), so the
  vocabulary's "its only source on the lint" is read to exclude the
  answer and the data type as well as the source and the help. A use
  the agent completes only by reading the answer is a skill that does
  not suffice — the designer's (b) invalidated (Edges row added).

The six constraints' screen against the architecture principle set
is recorded in this document's history (v3, v4).

## Interaction types

None — a skill is read by an agent inside a process step; no core
task carries it (the initiative's For whom section). The designer's
attachment states the skill and the standard question as agent-facing
interfaces it screens regardless (the initiative's Feasibility and
usability section); the criteria that came of that are the scenarios
the Contributors section's provenance names, and the screen of the
delivered skill is the designer's step's to record.

## Scenarios

```gherkin
Feature: Tool skills
  Every agent of the shop that runs a tool, and the shops whose tools
  the product accepts,
  can use a framework tool through a skill that states, for each use
  it supports, what it does, what it takes, what it returns, and how
  it fails — the skill produced from what the tool says about itself
  in answer to one standard question, proven end to end on the lint —
  so that every framework tool is usable through a skill produced
  from the tool's own answer: a tool from any shop is usable the
  moment it answers, and a change to what a tool says about itself
  reaches its skill.

  @bounded-context:shopsystem-product @feature:feat-tool-skills @hash:debc381f2c7e
  Scenario: the lint answers the standard question
    Given the lint, the tool every session runs over the definition corpus
    When the lint is asked the standard question
    Then the lint answers with what it says about itself — its name, what it does, and for each use it supports what that use does, what it takes, what it returns, and how it fails — and performs none of its uses in answering

  @bounded-context:shopsystem-product @feature:feat-tool-skills @hash:a32ca18f8bd7
  Scenario: the answer states each use's returns and failures as parts of their own
    Given the lint's answer to the standard question
    When a use entry in the answer is read
    Then what the use does, what it takes, what it returns, and how it fails are each present as a part of its own, none of the four absent and none standing in for another

  @bounded-context:shopsystem-product @feature:feat-tool-skills @hash:1bf0cead0957
  Scenario: the lint's skill is produced from the lint's own answer
    Given the lint's answer to the standard question
    When the lint's skill is produced
    Then a skill for the lint stands at the agent's load point, names the lint as what it was produced from, states every use the answer states, and says nothing about the lint that the answer does not say — produced from the answer and from nothing else, not the lint's source, not its help

  @bounded-context:shopsystem-product @feature:feat-tool-skills @hash:c51b20dd4cd9
  Scenario: each use entry in the lint's skill is complete
    Given the lint's skill
    When a use entry in it is read
    Then it states what the use does; what it takes, each input named and an omitted input's treatment; what it returns; how it fails, each failure a stable code beside its explanation and next step; and the exact invocation

  @bounded-context:shopsystem-product @feature:feat-tool-skills @hash:80ac83f71c06
  Scenario: a change to what the lint says about itself reaches its skill
    Given the lint's answer to the standard question changed since its skill was produced
    When the process that keeps tool skills current runs
    Then the lint's skill states what the lint now says about itself and is current with the changed answer

  @bounded-context:shopsystem-product @feature:feat-tool-skills @hash:5d004d52d1b4
  Scenario: a tool skill not current with its tool's answer is reported
    Given a tool skill not current with what its tool says about itself, whatever the cause
    When the check over tool skills runs
    Then the check reports that skill as not current, naming the tool

  @bounded-context:shopsystem-product @feature:feat-tool-skills @hash:d33276bcc8ba
  Scenario: the check over the load point passes clean with the lint's skill in place
    Given the lint's skill at the agent's load point, current with the lint's answer, beside the skills of the approved processes
    When the check over the load point runs
    Then the check reports the lint's skill as current and no skill at the load point as unrecognized

  @bounded-context:shopsystem-product @feature:feat-tool-skills @hash:c3bde3a9b657
  Scenario: the lint's skill is loaded for a task that calls for the lint
    Given an agent in a fresh context with the lint's skill at its load point and no other source on the lint, and a task that calls for running the lint
    When the agent begins the task
    Then the lint's skill is loaded for the task before any invocation of the lint, and the agent's invocation is the one the skill states, not a bare one

  @bounded-context:shopsystem-product @feature:feat-tool-skills @hash:59116a209cb2
  Scenario: an agent completes a use of the lint on the first invocation the skill states
    Given an agent in a fresh context with the lint's skill its only source on the lint, and a task calling for one of the uses the skill states
    When the agent performs the task
    Then the agent's first invocation of the lint is the one the skill states for that use, with no read of the lint's source or help and no second attempt, and the use completes with the return the skill states

  @bounded-context:shopsystem-product @feature:feat-tool-skills @hash:0ca7705b8397
  Scenario: a failure the agent meets is one the skill names, read as the skill states it
    Given an agent in a fresh context with the lint's skill its only source on the lint
    When an invocation of the lint made through the skill fails
    Then the failure is one the skill names for that use, and the agent states, from the skill alone, what the failure means and the next step to take
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| No framework tool the shop runs can be used through a skill | the framing ("no framework tool the shop runs can be used through a skill"); the For whom section ("Now: 0 of 11") | Scenario: the lint's skill is produced from the lint's own answer — the framed remedy, on the lint; Scenario: an agent completes a use of the lint on the first invocation the skill states — the skill in use |
| An agent that needs a tool reads its source or copies a prior command | the framing ("an agent that needs one reads its source or copies a prior command — which the tools-through-skills principle now forbids") | Scenario: an agent completes a use of the lint on the first invocation the skill states — the Then's "no read of the lint's source or help"; Scenario: the lint's skill is loaded for a task that calls for the lint — the invocation is the skill's, not a bare one |
| A tool from another shop unusable without its source | the framing ("a tool from another shop could not be used at all without its source"; the outcome's "a tool from any shop is usable the moment it answers") | Scenario: the lint's skill is produced from the lint's own answer — the Then's "produced from the answer and from nothing else, not the lint's source", which is what makes a tool usable without its source. The bound on a Bounded Context shop's tool: out of scope — no Bounded Context exists on this branch (the initiative's Decomposition), and the bound is the decision the bet rests on, not a behavior here |
| A skill that states a use without what it returns or how it fails | the framing's outcome (the four parts); the architect's risk (the initiative's Document History v3, its third risk: the answer's shape must carry returns and failures as parts of their own, or the skill states neither) | Scenario: the answer states each use's returns and failures as parts of their own; Scenario: each use entry in the lint's skill is complete |
| A use the answer states that the skill omits | the framing's outcome ("a skill that states, for each use it supports, …" — every use, not some) | Scenario: the lint's skill is produced from the lint's own answer — the Then's "states every use the answer states"; Scenario: a tool skill not current with its tool's answer is reported — a skill missing a use is not what a fresh production from the answer yields, so it is not current and is reported |
| An answer that does not answer — a tool that cannot answer | the framing's outcome ("a tool that cannot answer has a description beside it in the same shape"); the initiative's Appetite (first no-go: the external six by descriptions beside them, a second feature) | Out of scope: the second feature's, which the authority's standing direction authorizes on the proof's pass; the lint answers, and Scenario: the answer states each use's returns and failures as parts of their own is what tells an answer from a non-answer here |
| A change to what a tool says about itself that does not reach its skill | the framing's outcome ("a change to what a tool says about itself reaches its skill") | Scenario: a change to what the lint says about itself reaches its skill — the framed remedy; Scenario: a tool skill not current with its tool's answer is reported — an answer changed without its skill following is a skill not current, whatever the cause |
| A tool skill changed by hand | the framing's outcome's boundary (a skill changed other than through its tool's answer) | Scenario: a tool skill not current with its tool's answer is reported — the Given's "whatever the cause" holds a hand edit; Scenario: a change to what the lint says about itself reaches its skill — the skill that stands afterwards is produced from the answer, not from the edit |
| A description that depends on anything but the tool's own answer | the initiative's Appetite (second no-go: "the tool answers, its source stays its own") | Scenario: the lint's skill is produced from the lint's own answer — the Then's "from nothing else"; any skill produced otherwise is out of scope of this feature and of the measure |
| The lint answering by performing its normal function when asked | the initiative's Feasibility and usability section, the roles' offers (Document History v3 and v5: the lint answers a request for help by running its normal function) | Scenario: the lint answers the standard question — the Then's "performs none of its uses in answering" |
| Whether the lint's help also answers as help | the designer's attachment (the initiative's Document History v5, its fourth risk: "a scope call for the PM role") | Out of scope: the framed outcome is a skill an agent uses without reading the tool's help; what the help says serves no framed outcome here. Recommended to the PM role as a scope question, not decided here |
| The other ten tools, and the renderer once it exists | the initiative's Appetite (first no-go); the architect's risk on the count (Document History v3, its second risk; v4) | Out of scope: the second feature, authorized in advance by the authority's standing direction on the proof's pass; the measure's denominator is the PM role's, and this feature's measure is the target of 1 |
| The measure's instance — the lint, 0 to 1 | the For whom section ("Target: 1, the lint — the tool every session runs — proven end to end") | Scenario: an agent completes a use of the lint on the first invocation the skill states, read once per use the answer states — every one of which the skill states, by Scenario: the lint's skill is produced from the lint's own answer; Scenario: a failure the agent meets is one the skill names, read as the skill states it, read once — the proof's last part; the 1 is read from those observations together with Scenario: the lint's skill is produced from the lint's own answer, not from one run |
| "Usable" met as a hypothesis until the proof's last part runs | the initiative's Feasibility and usability section ("a hypothesis until the proof's last part runs as measured task completion") | Scenario: an agent completes a use of the lint on the first invocation the skill states; Scenario: a failure the agent meets is one the skill names, read as the skill states it — until both are observed, the delivery says "hypothesis" |
| The agent's first invocation not the one the skill states — a read of the source or help, or a second attempt | the designer's criteria ((a), the initiative's Document History v5) | Scenario: an agent completes a use of the lint on the first invocation the skill states |
| A failure the agent meets that the skill does not name | the designer's criteria ((b), the initiative's Document History v5) | Scenario: a failure the agent meets is one the skill names, read as the skill states it; Scenario: each use entry in the lint's skill is complete — every failure named, each with a stable code, its explanation, and its next step |
| The agent proceeding to a bare invocation with the skill present | the designer's criteria ((c), the initiative's Document History v5) | Scenario: the lint's skill is loaded for a task that calls for the lint |
| The check over the load point rejecting a tool skill as unrecognized | the initiative's Feasibility and usability section ("Risk: the load-point check rejects a tool skill until amended") | Scenario: the check over the load point passes clean with the lint's skill in place — a tool skill the check names unrecognized fails this Then; the amendment that makes it pass is the process owner's, not a scenario here |
| The approved processes' skills at the load point still checked as before | feat-skills-availability's scenarios over the load point (the feature repository, read in full) | Scenario: the check over the load point passes clean with the lint's skill in place — the Given holds the approved processes' skills beside the lint's; nothing that feature specifies changes, one more source kind is recognized |
| The delivered skill screened as an interface | the designer's attachment (the initiative's Document History v5, its third unknown: the conformance screen at delivery) | Out of scope of the scenarios: a delivery gate the designer's check judges, not a behavior of this feature |
| The skill's names undecidable against the vocabulary until the tool terms are entered | the designer's criteria ((b), and this document's history, v2 and v4; the initiative's Document History v5, R2) | Out of scope of the scenarios: a finding against the corpus, the designer's action before the delivery screen; the names in use are judged by Scenario: an agent completes a use of the lint on the first invocation the skill states and Scenario: a failure the agent meets is one the skill names, read as the skill states it |
| The lint's answer as a command-line interaction — its WCAG2ICT applicability record | the designer's criteria (this feature's Contributors section, v2; `accessible-by-standard` bullet 2) | Out of scope of the scenarios: the record for the `cli` type, written at the delivery screen; no scenario names the answer's form, and Scenario: the lint answers the standard question states what the answer says, not how it is shown |
| The lint's reply that exits other than 0 or does not parse against the tool-description data type — a traceback, a usage sheet, the normal function run | the solutions architect role's constraint (1) (this feature's Contributors section, v3); the initiative's Feasibility and usability section and the record's pre-state (the lint runs its normal function on `--help`) | Scenario: the lint answers the standard question — such a reply is not an answer and the Then is unmet; Scenario: the answer states each use's returns and failures as parts of their own — a reply with no use entries as fields |
| The tool-description data type not standing approved when the check reads the answer | the solutions architect role's constraint (2) (this feature's Contributors section, v3); the record's second consequence | Out of scope of the scenarios: enabler work — the data type is written under adr-2026-09-07-tool-answer and approved through the definition chain before the proof's check, recommended by the solutions architect role into the PO role's backlog; until it stands, Scenario: the answer states each use's returns and failures as parts of their own has no shape to be read against and is pending its definition, not failed |
| The check over tool skills reading a kept copy of the answer, or the lint's source, instead of asking the lint again | the solutions architect role's constraint (3) (this feature's Contributors section, v3) | Scenario: a change to what the lint says about itself reaches its skill — a kept copy does not see the change and the Then is unmet; Scenario: a tool skill not current with its tool's answer is reported |
| The lint's skill passing the check over the load point by exemption rather than recognition of its source kind | the solutions architect role's constraint (4) (this feature's Contributors section, v3) | Scenario: the check over the load point passes clean with the lint's skill in place — the Then asks the check to report the skill as current, which an exemption cannot; Scenario: a tool skill not current with its tool's answer is reported |
| A dependency, a vendor, or a recurring cost added by the proof; a dependency that binds a shop's language | the solutions architect role's constraint (5) (this feature's Contributors section, v4); the record's JSON bound | Out of scope of the scenarios: the record's delivery read, made against the tree by the solutions architect role; any such addition escalates to the authority before it is made, the threshold being unset. The framed half — a tool from any shop usable the moment it answers — is Scenario: the lint's skill is produced from the lint's own answer's, "from the answer and from nothing else" |
| An agent completing a use of the lint only by reading the lint's answer or the data type | the solutions architect role's constraint (6) (this feature's Contributors section, v3); the designer's (b) | Scenario: an agent completes a use of the lint on the first invocation the skill states — the Given's "its only source on the lint" excludes the answer; Scenario: a failure the agent meets is one the skill names, read as the skill states it — "from the skill alone" |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Authored by the PO role alone in the feature-authoring draft step, from init-tool-skills's Framing and For whom sections (v8, planned), its Appetite as the source of the proof, and the order's scope points — the architect's third risk (v3) and the designer's criteria (a)–(c) (v5); the decision the bet rests on, adr-2026-09-07-tool-answer (checked), read for what must hold and named in no scenario; ten scenarios, all owned by the lead shop per the initiative's Decomposition; interaction types none per its For whom; every scenario `@hash:pending` — the authoring session had no shell, so the lead-pm fills the values (sha256 of the scenario's text, first twelve hex digits, as in the repository's other features) before the check. The feature repository read in full: five features, none naming a framework tool, a tool's answer, or a tool skill; one touch-point, feat-skills-availability's check over the load point, carried as an Edges row and as the Given of *the check over the load point passes clean with the lint's skill in place*. Maker's self-check against the feature fitness set (v8), each scenario read as Given/When/Then: scenario 1 (one observable behavior) pass — each When is one action or event (the lint asked; a use entry read; the skill produced; the process run; the check run; the agent beginning or performing a task; an invocation failing), each Then observable in the running system (an answer given and no use performed; parts present; a skill standing at the load point; a report naming the tool; a skill loaded; a first invocation and its result; a failure and the agent's statement of it), and no step names a flag, a file, a format, a tool by its program name, or a compiler — "stable code" and "the exact invocation" are the designer's words for what the skill states, not how it is made; scenario 2 (ownership and criteria) pass — an owning shop named for each of the ten; no interaction type is named, so the designer's criteria are not due at this step, and the Contributors section says what the designer's and the architect's steps record; scenario 3 (identity tags) pass on presence — `@feature:feat-tool-skills` and `@hash:pending` on every scenario, the values disclosed as pending; scenario 4 (edges) pass — nineteen rows: every case the framing's Problem and outcome, the For whom section, the Appetite's two no-gos, the Feasibility and usability section's risk and hypothesis, the Decomposition, and the order's scope points name is present, fourteen covered by scenario name, four out of scope with reasons (a tool that cannot answer; the help's behavior; the other ten tools; the delivery screen), and one covered with its Bounded Context half out of scope (no Bounded Context on this branch); scenario 5 (interaction types) pass — "none" with the For whom section's reason; scenario 6 (narrative) pass — who (every agent of the shop that runs a tool, and the shops whose tools the product accepts), what (use a framework tool through a skill stating the four parts, produced from the tool's answer), the outcome the framing's ("every framework tool is usable through a skill produced from the tool's own answer … a change to what a tool says about itself reaches its skill"). Scope declined, with the reason in the Edges table: the help's behavior — serves no framed outcome here; recommended to the PM role. Status draft pending the PO output check. |
| 2 | 2026-09-07 | update | The product designer role's criteria added in feature-authoring's add-usability step, from the step's declared inputs (the feature v1, the initiative v9, the experience principle set v2, the core-task list v4) and this role's own corpus (the api and cli guidelines v3, the patterns v2 and vocabulary v3 records, the feature typedef v12 and fitness set v8 for the check's shape). Verdict recorded in the Contributors section: no usability and no accessibility criteria due — the Interaction types section's "none" holds against the core-task list, and that section answers parity, not whether an interface is delivered; stated regardless under `agent-is-a-user` bullet 1, the skill (`api`) and the lint's answer (`cli`) being interfaces this role screens: criteria (a)–(c) placed on the scenarios by name with what meets and what invalidates each, each a hypothesis until measured task completion in the delivery; the api guideline's retry clause not made a criterion; names-for-the-caller and nothing-only-an-agent-can-do noted as delivery-screen reads; the WCAG2ICT record for the answer named as the screen's, not a criterion. Two Edges rows added: the vocabulary's missing tool terms (a finding against the corpus, this role's action pending); the answer's WCAG2ICT record. No scenario text changed; the Interaction types section untouched. Maker's self-check against the feature fitness set (v8), the scenarios that concern this part: scenario 2 (ownership and criteria) pass — no type named, so the designer's criteria are not required, and the section records none due with its reason; the criteria stated regardless each name the scenario they ride on; scenario 4 (edges) pass — every case these criteria name is in the table: (a), (b), (c) and the hypothesis label in the rows the draft carried, the two new cases added, twenty-one rows, each covered by Scenario name or out of scope with a reason; scenario 5 (interaction types) pass — "none" unchanged, the For whom reason the framing bears out (a skill read by an agent inside a process step), and the Contributors text says why the screen's two types do not change that answer. Scenario 1 re-read on the two new Edges rows only: neither names a scenario step, so no implementation detail enters the block. |
| 3 | 2026-09-07 | update | The solutions architect role's constraints added in feature-authoring's add-constraints step, from the step's declared inputs (the feature v2; the decomposition — init-tool-skills' Decomposition section, v9) and this role's own records (adr-2026-09-07-tool-answer v3 checked, the decision the feature implements; the architecture principle set v6; the feature repository read in full, six features; the feature typedef v12, guideline v8, and fitness set v8 for the check's shape). Verdict recorded in the Contributors section: contract bound none and cross-context flow none, with the Decomposition's reason — no Bounded Context, no contract on this branch; one guardrail binds, the checked record, whose bound reaches the lead shop's own tools; six constraints placed on the scenarios by name, each a sentence of the record's §2, §3, or its bound stated as what must hold — what counts as an answer; the shape is the contract's; sole source and the direction of repair; the load-point check recognizes, never exempts; the stack bound; the skill is the artifact of use — and one enabler recommended into the PO role's backlog (the tool-description data type, approved before the check reads against it). The six screened against the architecture principle set: conforms on six, `intent-provenance` on the standing exception, no new escalation. Six Edges rows added, twenty-seven in all. No scenario text changed; the Interaction types section untouched. Maker's self-check against the feature fitness set (v8), the scenarios that concern this part: scenario 2 (ownership and criteria) pass — the Contributors section says a guardrail names constraints and six are present, each naming the scenarios it rides on; the contract bound and the flow read none with the Decomposition's reason; every scenario's owning shop unchanged; scenario 4 (edges) pass — every case the six constraints name is in the table, five covered by Scenario name and two out of scope with reasons (the enabler; the delivery read of the stack bound), the existing rows on the normal-function reply, the hand edit, and the load-point rejection left standing and now bound by (1), (3), and (4); scenario 1 re-read on the addition only: the constraints and rows sit outside the gherkin block, and the flag's behaviour, the data type's path, and the digest are named in Contributors and Edges alone, the flag's name nowhere, and none in a step. The lint run on the tree after the edit: `PASS: 0 violation(s)`, exit 0; the gherkin block byte-identical to v2. |
| 3 | 2026-09-07 | review | PO output check, the one screen (judge: claude-fable-5-1 / screen prompt v6): three confident by named criterion — the produced-skill Then one-directional against the framing's "for each use it supports" (criterion 4); the not-a-criterion passages and the makers' principle screens in the body (framing); and two wobbly, ruled by the PM role — "named for the caller" not observable from the skill alone (criterion 1); constraint (5) tracing to the record and not the framing (framing); the "nothing only an agent can do" read with no Edges row (criterion 4). Three more marked uncovered, the PM role's to decide: "digest", "the renderer", and "the producer" unintroduced; Edges rows 5 and 21 naming different scenarios as what tells an answer from a non-answer; the Contributors section's length against the block. |
| 4 | 2026-09-07 | update | The one revise, by the PO role, the findings with a named criterion. Criterion 4: *the lint's skill is produced from the lint's own answer*'s Then made two-directional — "states every use the answer states, and says nothing about the lint that the answer does not say" — a new scenario by hash (`@hash:pending`, the lead-pm fills it; no shell at this step); an Edges row added, *A use the answer states that the skill omits*, covered by that scenario and by *a tool skill not current with its tool's answer is reported*; the measure's row now reads "once per use the answer states — every one of which the skill states". Criterion 1: "named for the caller" dropped from *each use entry in the lint's skill is complete*'s Then, which now reads "each input named and an omitted input's treatment" (new hash, `@hash:pending`); the designer's criterion (b) carries "named for the caller" as before, judged at delivery by the agent's use. Framing, other roles' passages edited on the PM role's ruling, substance kept here: the designer's (b) sentence on the api guideline's rule 2 — a retry's safety and a replay's return are not made a criterion, the framing naming four parts and the scenarios stating them; whether a fifth is wanted is the delivery screen's finding to the solutions architect role — moved to this row; the designer's "two rules of the corpus" paragraph moved to this row — names for the caller are judged at delivery by the agent's use under (a) and (b), not by the vocabulary screen, the vocabulary (v3) holding no tool term so that screen returns undecidable until the designer enters the terms (the initiative's v5, R2 and D1; the Edges row stands, its source re-pointed here); and nothing only an agent can do (`agent-is-a-user` bullet 2; api rule 4) — every use the skill states is a command a person runs at the prompt, the lint being a command line — is a delivery-screen read, struck from the body rather than given an Edges row (the PM role's ruling on the wobbly finding); the architect's screen of the six constraints against the architecture principle set (v6) moved to this row — `knowable-shape` (1), (2): the answer suffices without the lint's source; `contracts-between-contexts` (2): the data type the named, versioned contract with its relationship kind, no Bounded Context on this branch building to it yet; `actor-neutral-discipline` (6): the invocation binds whoever performs the step; `local-comprehension` (3), (6): no read below the designated artifact; `bidirectional-conformance` (3), (4): the reverse direction fixed, drift re-produced or reported, never absorbed; `intent-provenance`: the record and the step each recorded, resting on the exception the record cites (work item lead-4kymc), no new one; no constraint a design cannot satisfy, nothing to escalate, no vendor and no recurring cost — a one-line pointer to this history left in the body. Framing, constraint (5) restated on the framed outcome it protects — a tool from any shop is usable the moment it answers — as *the answer's form binds no shop's language*: the answer in a form any shop's language gives from its standard library, no dependency binding a shop's language added by answering or producing; the cost, vendor, and dependency read kept as the record's delivery read in its Edges row, now naming the framed half's cover. Left as marked uncovered, the PM role's: the three unintroduced terms; rows 5 and 21; the section's length — the framing repair shortens it by three passages and no more. Maker's self-check against the feature fitness set (v8) after the revise: scenario 1 pass — the two changed Thens each remain one observable outcome (a skill standing with every use and nothing more; an entry's parts read), "named" without "for the caller" observable from the skill alone, no implementation detail added; scenario 2 pass — ownership unchanged for all ten; the designer's criteria (a)–(c) and the architect's constraints (1)–(6) present, each riding by name; scenario 3 pass on presence — `@feature:` on all ten, `@hash:` on all ten, two pending; scenario 4 pass — twenty-eight rows, the new case covered by scenario name, every row's case still sourced to the framing or a contributor's criteria, the two re-pointed rows sourcing to criterion (b) and constraint (5) as they now stand; scenario 5 pass — unchanged; scenario 6 pass — the narrative untouched. |
| 5 | 2026-09-07 | state | `draft` → `checked`: the PM role's pass after the one screen and the one revise the process allows. Every finding with a named criterion is repaired in v4 — read at the places the review's quotes point to: the produced-skill Then now two-directional with its Edges row; "named for the caller" out of the entry Then and carried by criterion (b); the not-a-criterion passages and the makers' principle screens in this history, not the body; constraint (5) on the framed outcome it protects; the agent-only sentence struck. The three findings still open are uncovered and none needs a criterion — the rulings: (i) the three unintroduced terms — "digest" is adr-2026-09-07-tool-answer's term for the sha256 stamp the skill carries over the answer it was produced from; "the producer" and "the renderer" both name the process that keeps tool skills current, the record's `compile_tool.py`; the implementation guidance record names them concretely and the designer enters them in the vocabulary at the delivery screen (R2), so no scenario criterion is wanted; (ii) Edges rows 5 and 21 — row 21 governs: *the lint answers the standard question* is the scenario that tells an answer from a non-answer, as constraint (1) rides on it; row 5's clause is read as naming the completeness of an answer's parts, not the answer/non-answer line; (iii) the Contributors section's length — the framing repair took the three passages the screen named; the remaining reasoning is the designer's and the architect's own record of their criteria and constraints, which the feature typedef places in that section, and the 500-word soft cap with its 20% variance is the authority's rule on the sections it names, not on contributors' passages; no criterion is wanted. The last two hashes filled by the lead-pm after the revise (@hash:1bf0cead0957, @hash:c51b20dd4cd9), the convention the repository's other features use. |
| 6 | 2026-09-07 | state | `checked` → `assigned`: the scenario-assignment record step (process v12). One assignment entry — context shopsystem-product (the lead shop), scenarios @hash:debc381f2c7e, @hash:a32ca18f8bd7, @hash:1bf0cead0957, @hash:c51b20dd4cd9, @hash:80ac83f71c06, @hash:5d004d52d1b4, @hash:d33276bcc8ba, @hash:c3bde3a9b657, @hash:59116a209cb2, @hash:0ca7705b8397 — each tagged `@bounded-context:shopsystem-product`, the owning shop the Contributors section names for every scenario, and the decomposition's ruling (init-tool-skills v10, Decomposition: none — every change in the lead shop's tree, no contract on this branch, cross-context flow none); the tag added on the tag line above each Scenario, no hash changed. The process's lead-shop-internal gap stands as lead-ki66p and the run is handled disclosed as the two prior runs were. No scenario unowned; no ask — the one scope question the feature carries (whether `--help` also answers as help) is already out of scope in its Edges table and recommended to the PM role, and no scenario's ownership turns on it. Pre-state read from lead-shop-held records, none from a context's internals: contracts — none exist on this branch; the guardrail adr-2026-09-07-tool-answer at v3 (checked), read for §2, §2.1, §3; the tool-description data type it names at basis/types/tool-description.md — not yet in the tree, the enabler bound named in constraint (2); the lint at basis/tools/lint_basis.py observed on the flag by running it, 2026-09-07 — `--describe` runs the normal function, `PASS: 0 violation(s)`, exit 0: cannot answer, the first scenario's Then unmet today; basis/tools holding four compilers and the lint, no compile_tool.py; skill-rendering at v7, its check step marking any load-point skill whose `source:` is not under basis/processes `unrecognized` and escalating it by path — the standing escalation a tool skill would meet today; the process-definition typedef at v7, whose commitment bars approving a definition that names a tool the repository lacks (the order the guidance fixes); the data-type typedef at v3; reconcile-and-close at v4; interaction-conformance-check at v4, draft; the working principle set v11 and the architecture principle set v6; the research the guardrail rests on registered in research/index.md v9. The feature repository swept in full — six artifacts, this feature and the five assigned — no conflict: feat-request-routing (v8) specifies asks, requests, and the lane; feat-role-decisions (v7) roles' decisions and offers; feat-roles-availability (v6) rendered role definitions; feat-typedef-rendering (v8) a typedef's produced texts, the same generate-then-gate pattern on a different source with no scenario shared; and no scenario of any names a framework tool, a tool's answer, or a tool skill. The touch-point is feat-skills-availability (v8), whose seven scenarios bind process skills at the load point: @hash:4899d4bba6ad (the clean pass: no divergence and no missing skill) and @hash:26f78a3ca4a6 (a hand-diverged skill reconciled toward its definition) — @hash:d33276bcc8ba extends the same check by one recognized source kind and asks nothing that feature's Thens deny, and @hash:5d004d52d1b4 resolves drift in the same direction, toward the source; contradicts none. Implementation guidance written, one record for the one context: guidance/feat-tool-skills-shopsystem-product.md (v1, written) — the data type, the lint's handler, the compiler, the check's recognition, and the proof, in the order the guardrail and the typedef's commitment require, with versions, paths, and invocations; the one choice left to the process owner (amend skill-rendering or define a sibling) named with what must hold either way; maker's evaluation against the implementation-guidance fitness set v1, all five pass: at the architect's level (definitions, tools, step ids, and the guardrail's sections named; how the lint composes its answer left to the maker; no internals of any context); cited never restated (hashes, ids, versions, and sections only; the shape's parts pointed at, not listed); actionable alone (every definition, tool, invocation, check, and order named; what is not in this assignment named as such); each thing not to do with its reason (thirteen entries, each to the guardrail's section, a constraint, a principle, a typedef's commitment, the Appetite's no-go, or the decomposition); bound to one assignment (frontmatter and opening paragraph; the not-in-this-assignment items say so rather than bind a later one). Not sent. Sent: none — the owning shop is the lead shop itself; the freeze bars dispatch and no Bounded Context exists to receive; the gap stands as lead-ki66p. The initiative's Features section still reads checked; its update is the lead-pm's with the commit. |
