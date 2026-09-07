---
type: feature
id: feat-tool-skills
name: Tool skills
status: draft
version: 1
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

  @feature:feat-tool-skills @hash:debc381f2c7e
  Scenario: the lint answers the standard question
    Given the lint, the tool every session runs over the definition corpus
    When the lint is asked the standard question
    Then the lint answers with what it says about itself — its name, what it does, and for each use it supports what that use does, what it takes, what it returns, and how it fails — and performs none of its uses in answering

  @feature:feat-tool-skills @hash:a32ca18f8bd7
  Scenario: the answer states each use's returns and failures as parts of their own
    Given the lint's answer to the standard question
    When a use entry in the answer is read
    Then what the use does, what it takes, what it returns, and how it fails are each present as a part of its own, none of the four absent and none standing in for another

  @feature:feat-tool-skills @hash:c7fda8b95936
  Scenario: the lint's skill is produced from the lint's own answer
    Given the lint's answer to the standard question
    When the lint's skill is produced
    Then a skill for the lint stands at the agent's load point, names the lint as what it was produced from, and says nothing about the lint that the answer does not say — produced from the answer and from nothing else, not the lint's source, not its help

  @feature:feat-tool-skills @hash:fd838135411a
  Scenario: each use entry in the lint's skill is complete
    Given the lint's skill
    When a use entry in it is read
    Then it states what the use does; what it takes, each input named for the caller and an omitted input's treatment; what it returns; how it fails, each failure a stable code beside its explanation and next step; and the exact invocation

  @feature:feat-tool-skills @hash:80ac83f71c06
  Scenario: a change to what the lint says about itself reaches its skill
    Given the lint's answer to the standard question changed since its skill was produced
    When the process that keeps tool skills current runs
    Then the lint's skill states what the lint now says about itself and is current with the changed answer

  @feature:feat-tool-skills @hash:5d004d52d1b4
  Scenario: a tool skill not current with its tool's answer is reported
    Given a tool skill not current with what its tool says about itself, whatever the cause
    When the check over tool skills runs
    Then the check reports that skill as not current, naming the tool

  @feature:feat-tool-skills @hash:d33276bcc8ba
  Scenario: the check over the load point passes clean with the lint's skill in place
    Given the lint's skill at the agent's load point, current with the lint's answer, beside the skills of the approved processes
    When the check over the load point runs
    Then the check reports the lint's skill as current and no skill at the load point as unrecognized

  @feature:feat-tool-skills @hash:c3bde3a9b657
  Scenario: the lint's skill is loaded for a task that calls for the lint
    Given an agent in a fresh context with the lint's skill at its load point and no other source on the lint, and a task that calls for running the lint
    When the agent begins the task
    Then the lint's skill is loaded for the task before any invocation of the lint, and the agent's invocation is the one the skill states, not a bare one

  @feature:feat-tool-skills @hash:59116a209cb2
  Scenario: an agent completes a use of the lint on the first invocation the skill states
    Given an agent in a fresh context with the lint's skill its only source on the lint, and a task calling for one of the uses the skill states
    When the agent performs the task
    Then the agent's first invocation of the lint is the one the skill states for that use, with no read of the lint's source or help and no second attempt, and the use completes with the return the skill states

  @feature:feat-tool-skills @hash:0ca7705b8397
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
| An answer that does not answer — a tool that cannot answer | the framing's outcome ("a tool that cannot answer has a description beside it in the same shape"); the initiative's Appetite (first no-go: the external six by descriptions beside them, a second feature) | Out of scope: the second feature's, which the authority's standing direction authorizes on the proof's pass; the lint answers, and Scenario: the answer states each use's returns and failures as parts of their own is what tells an answer from a non-answer here |
| A change to what a tool says about itself that does not reach its skill | the framing's outcome ("a change to what a tool says about itself reaches its skill") | Scenario: a change to what the lint says about itself reaches its skill — the framed remedy; Scenario: a tool skill not current with its tool's answer is reported — an answer changed without its skill following is a skill not current, whatever the cause |
| A tool skill changed by hand | the framing's outcome's boundary (a skill changed other than through its tool's answer) | Scenario: a tool skill not current with its tool's answer is reported — the Given's "whatever the cause" holds a hand edit; Scenario: a change to what the lint says about itself reaches its skill — the skill that stands afterwards is produced from the answer, not from the edit |
| A description that depends on anything but the tool's own answer | the initiative's Appetite (second no-go: "the tool answers, its source stays its own") | Scenario: the lint's skill is produced from the lint's own answer — the Then's "from nothing else"; any skill produced otherwise is out of scope of this feature and of the measure |
| The lint answering by performing its normal function when asked | the initiative's Feasibility and usability section, the roles' offers (Document History v3 and v5: the lint answers a request for help by running its normal function) | Scenario: the lint answers the standard question — the Then's "performs none of its uses in answering" |
| Whether the lint's help also answers as help | the designer's attachment (the initiative's Document History v5, its fourth risk: "a scope call for the PM role") | Out of scope: the framed outcome is a skill an agent uses without reading the tool's help; what the help says serves no framed outcome here. Recommended to the PM role as a scope question, not decided here |
| The other ten tools, and the renderer once it exists | the initiative's Appetite (first no-go); the architect's risk on the count (Document History v3, its second risk; v4) | Out of scope: the second feature, authorized in advance by the authority's standing direction on the proof's pass; the measure's denominator is the PM role's, and this feature's measure is the target of 1 |
| The measure's instance — the lint, 0 to 1 | the For whom section ("Target: 1, the lint — the tool every session runs — proven end to end") | Scenario: an agent completes a use of the lint on the first invocation the skill states, read once per use the skill states; Scenario: a failure the agent meets is one the skill names, read as the skill states it, read once — the proof's last part; the 1 is read from those observations together with Scenario: the lint's skill is produced from the lint's own answer, not from one run |
| "Usable" met as a hypothesis until the proof's last part runs | the initiative's Feasibility and usability section ("a hypothesis until the proof's last part runs as measured task completion") | Scenario: an agent completes a use of the lint on the first invocation the skill states; Scenario: a failure the agent meets is one the skill names, read as the skill states it — until both are observed, the delivery says "hypothesis" |
| The agent's first invocation not the one the skill states — a read of the source or help, or a second attempt | the designer's criteria ((a), the initiative's Document History v5) | Scenario: an agent completes a use of the lint on the first invocation the skill states |
| A failure the agent meets that the skill does not name | the designer's criteria ((b), the initiative's Document History v5) | Scenario: a failure the agent meets is one the skill names, read as the skill states it; Scenario: each use entry in the lint's skill is complete — every failure named, each with a stable code, its explanation, and its next step |
| The agent proceeding to a bare invocation with the skill present | the designer's criteria ((c), the initiative's Document History v5) | Scenario: the lint's skill is loaded for a task that calls for the lint |
| The check over the load point rejecting a tool skill as unrecognized | the initiative's Feasibility and usability section ("Risk: the load-point check rejects a tool skill until amended") | Scenario: the check over the load point passes clean with the lint's skill in place — a tool skill the check names unrecognized fails this Then; the amendment that makes it pass is the process owner's, not a scenario here |
| The approved processes' skills at the load point still checked as before | feat-skills-availability's scenarios over the load point (the feature repository, read in full) | Scenario: the check over the load point passes clean with the lint's skill in place — the Given holds the approved processes' skills beside the lint's; nothing that feature specifies changes, one more source kind is recognized |
| The delivered skill screened as an interface | the designer's attachment (the initiative's Document History v5, its third unknown: the conformance screen at delivery) | Out of scope of the scenarios: a delivery gate the designer's check judges, not a behavior of this feature |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Authored by the PO role alone in the feature-authoring draft step, from init-tool-skills's Framing and For whom sections (v8, planned), its Appetite as the source of the proof, and the order's scope points — the architect's third risk (v3) and the designer's criteria (a)–(c) (v5); the decision the bet rests on, adr-2026-09-07-tool-answer (checked), read for what must hold and named in no scenario; ten scenarios, all owned by the lead shop per the initiative's Decomposition; interaction types none per its For whom; every scenario `@hash:pending` — the authoring session had no shell, so the lead-pm fills the values (sha256 of the scenario's text, first twelve hex digits, as in the repository's other features) before the check. The feature repository read in full: five features, none naming a framework tool, a tool's answer, or a tool skill; one touch-point, feat-skills-availability's check over the load point, carried as an Edges row and as the Given of *the check over the load point passes clean with the lint's skill in place*. Maker's self-check against the feature fitness set (v8), each scenario read as Given/When/Then: scenario 1 (one observable behavior) pass — each When is one action or event (the lint asked; a use entry read; the skill produced; the process run; the check run; the agent beginning or performing a task; an invocation failing), each Then observable in the running system (an answer given and no use performed; parts present; a skill standing at the load point; a report naming the tool; a skill loaded; a first invocation and its result; a failure and the agent's statement of it), and no step names a flag, a file, a format, a tool by its program name, or a compiler — "stable code" and "the exact invocation" are the designer's words for what the skill states, not how it is made; scenario 2 (ownership and criteria) pass — an owning shop named for each of the ten; no interaction type is named, so the designer's criteria are not due at this step, and the Contributors section says what the designer's and the architect's steps record; scenario 3 (identity tags) pass on presence — `@feature:feat-tool-skills` and `@hash:pending` on every scenario, the values disclosed as pending; scenario 4 (edges) pass — nineteen rows: every case the framing's Problem and outcome, the For whom section, the Appetite's two no-gos, the Feasibility and usability section's risk and hypothesis, the Decomposition, and the order's scope points name is present, fourteen covered by scenario name, four out of scope with reasons (a tool that cannot answer; the help's behavior; the other ten tools; the delivery screen), and one covered with its Bounded Context half out of scope (no Bounded Context on this branch); scenario 5 (interaction types) pass — "none" with the For whom section's reason; scenario 6 (narrative) pass — who (every agent of the shop that runs a tool, and the shops whose tools the product accepts), what (use a framework tool through a skill stating the four parts, produced from the tool's answer), the outcome the framing's ("every framework tool is usable through a skill produced from the tool's own answer … a change to what a tool says about itself reaches its skill"). Scope declined, with the reason in the Edges table: the help's behavior — serves no framed outcome here; recommended to the PM role. Status draft pending the PO output check. |
