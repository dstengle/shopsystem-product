---
type: feature
id: feat-tool-skills-rest
name: Tool skills for the rest
status: draft
version: 1
initiative: ../initiatives/init-tool-skills.md
owner: lead-po
created: 2026-09-07
updated: 2026-09-07
---

# Feature: Tool skills for the rest

## Feature

Feature: Tool skills for the rest
  Every agent of the shop that runs a tool, and the shops whose tools
  the product accepts,
  can use each of the other eleven framework tools — the five
  compilers the shop owns and the six tools it runs but does not own —
  through a skill that states, for each use it supports, what it does,
  what it takes, what it returns, and how it fails: the skill produced
  from what the tool says about itself in answer to the one standard
  question, or, for a tool that cannot answer, from a description
  beside it in the same shape until its owner answers,
  so that every framework tool is usable through a skill produced
  from the tool's own answer — a tool from any shop is usable the
  moment it answers, a tool that cannot answer has a description
  beside it in the same shape, and a change to what a tool says about
  itself reaches its skill.

## Contributors

Owning shop, per scenario — from the initiative's Decomposition
section, which names no Bounded Context: every change sits in the
lead shop's tree, no contract exists on this branch, and the
cross-context flow is none. The six external tools are owned by other
shops, and each description beside one names that owner as the gap's
addressee; the scenarios that write the descriptions, produce the
skills, and record the gaps are the lead shop's, the shop that runs
the tools, as the decision the bet rests on places them.

- *a compiler the shop owns answers the standard question* — shopsystem-product (the lead shop)
- *a compiler's skill is produced from the compiler's own answer* — shopsystem-product (the lead shop)
- *the producer of tool skills produces its own skill from its own answer* — shopsystem-product (the lead shop)
- *a tool that cannot answer has a description beside it in the same shape* — shopsystem-product (the lead shop)
- *a description beside a tool that is not in the answer's shape yields no skill* — shopsystem-product (the lead shop)
- *the skill of a tool that cannot answer is produced from the description beside it* — shopsystem-product (the lead shop)
- *a tool that cannot answer is recorded as a gap against its owner* — shopsystem-product (the lead shop)
- *each use entry in a produced skill is complete* — shopsystem-product (the lead shop)
- *a change to what a compiler says about itself reaches its skill* — shopsystem-product (the lead shop)
- *a change to the description beside a tool reaches its skill* — shopsystem-product (the lead shop)
- *a tool skill not current with the description beside its tool is reported* — shopsystem-product (the lead shop)
- *a tool that begins to answer is used through its answer, not the description beside it* — shopsystem-product (the lead shop)
- *the check over the load point passes clean with every tool's skill in place* — shopsystem-product (the lead shop)
- *a tool's skill is loaded for a task that calls for the tool* — shopsystem-product (the lead shop)
- *an agent completes a use of a tool on the first invocation the skill states* — shopsystem-product (the lead shop)
- *a failure the agent meets is one the skill names, read as the skill states it* — shopsystem-product (the lead shop)

Vocabulary. The terms the Contributors section of
[feat-tool-skills](feat-tool-skills.md) defines — framework tool,
skill, gap, the standard question, the answer, use and use entry, a
part of its own, produced from, current with, the process that keeps
tool skills current, the check over tool skills, the agent's load
point, the check over the load point, a fresh context and its only
source on a tool, the first invocation, a bare invocation, a stable
code — are used here with the meaning that section gives them, read
of any tool where it reads of the lint. Terms this feature adds, in
the order the scenarios use them:

- **the five compilers the shop owns** — the framework tools under
  the lead shop's tools directory other than the lint: the four that
  render a definition into its produced text (a principle set, a
  typedef, a process, a role) and **the producer of tool skills** —
  the compiler that asks a tool the standard question and produces
  its skill from the answer, itself a framework tool that must answer
  (the initiative's Document History v11; the architect's second risk,
  v3). "A compiler" in a scenario is any one of the five, and a
  scenario over a compiler is read once per compiler.
- **a tool the shop runs but does not own**, **the six external
  tools** — bd (the work register), shop-msg, shop-knowledge,
  agent-vault, bc-emit, shop-templates (the initiative's Document
  History v11; the discovery's evidence table, sess-2026-09-06-c):
  framework tools named in the shop's definitions or used by hand,
  owned by other shops, none of which answers the standard question
  today. "A tool that cannot answer" in a scenario is any one of the
  six, and a scenario over one is read once per tool.
- **the owner of a tool** — the shop that owns the tool: the shop
  that can make it answer the standard question, and the addressee of
  the gap recorded while it does not.
- **a description beside a tool** — the framing's "description beside
  it in the same shape": what a tool that cannot answer would say
  about itself, written by the shop that runs the tool in the shape an
  answer takes — the tool's name, what it does, and one use entry per
  use with its four parts — naming the tool it stands beside and that
  tool's owner; the source of that tool's skill until the tool
  answers, when the answer replaces it. Written from what the tool
  shows whoever runs it — its help, its behavior when run — never from
  its source (the initiative's Appetite, second no-go).
- **the same shape** — the shape an answer takes, one shape for every
  tool from any shop; the decision the bet rests on,
  [adr-2026-09-07-tool-answer](../decisions/adr-2026-09-07-tool-answer.md)
  (checked), fixes it, and the scenarios name only its parts.
- **the tool's source** — for a tool that answers, its answer; for a
  tool that cannot answer, the description beside it. "Current with"
  is read against the tool's source so defined: a change to the
  answer, or to the description, since the skill was produced leaves
  a skill that is not current.
- **the measure** — the initiative's: framework tools usable through
  a skill produced from the tool's own answer. Now 1 of 12, the lint;
  target 12 of 12 — the twelve being the lint, the five compilers,
  and the six external tools, the last six counted on the
  description beside each until its owner answers (the initiative's
  Document History v11: the count is the PM role's to read).

Provenance of the scenarios, outside the ownership list. *The
producer of tool skills produces its own skill from its own answer*
stands on the initiative's Document History v11 and the architect's
second risk (v3): the producer is a framework tool of the shop and
counts in the measure. *A description beside a tool that is not in
the answer's shape yields no skill* and *a tool skill not current
with the description beside its tool is reported* stand on the
architect's fourth risk (v3): the descriptions are hand-written and
no check reaches their drift from the tool until the tool answers —
so what a check can reach, the shape and the skill's currency with
the description, is specified, and what it cannot is an Edges row.
*A tool that begins to answer is used through its answer, not the
description beside it* stands on the framing's "a tool from any shop
is usable the moment it answers" and the Appetite's "until their
owners answer". The last three scenarios serve the framing's "usable
through a skill" and stand on the product designer role's usability
acceptance criteria (a)–(c) for the PO role, offered in the
initiative's Feasibility and usability section and its Document
History (v5), read here of any of the eleven tools; the designer's
fifth risk there — a description beside a tool is a person writing in
a machine shape, a document interaction with no pattern, noted for
this feature — is the designer's step's to record. The initiative's
For whom section names no interaction type and its Decomposition
names no Bounded Context; what usability, accessibility, and
non-functional criteria are due, the designer's and the architect's
steps record below.

## Interaction types

None — a skill is read by an agent inside a process step; no core
task carries it (the initiative's For whom section). The description
beside a tool that cannot answer is written by the lead shop in the
answer's shape; the designer's attachment (the initiative's Document
History v5, its fifth risk) names that a document interaction with no
pattern, noted for this feature, and whether the core-task list
carries it is the designer's step to record — the For whom section's
answer stands until it does.

## Scenarios

```gherkin
Feature: Tool skills for the rest
  Every agent of the shop that runs a tool, and the shops whose tools
  the product accepts,
  can use each of the other eleven framework tools — the five
  compilers the shop owns and the six tools it runs but does not own —
  through a skill that states, for each use it supports, what it does,
  what it takes, what it returns, and how it fails: the skill produced
  from what the tool says about itself in answer to the one standard
  question, or, for a tool that cannot answer, from a description
  beside it in the same shape until its owner answers,
  so that every framework tool is usable through a skill produced
  from the tool's own answer — a tool from any shop is usable the
  moment it answers, a tool that cannot answer has a description
  beside it in the same shape, and a change to what a tool says about
  itself reaches its skill.

  @feature:feat-tool-skills-rest @hash:c648ef04449d
  Scenario: a compiler the shop owns answers the standard question
    Given a compiler the shop owns, one of the five
    When the compiler is asked the standard question
    Then the compiler answers with what it says about itself — its name, what it does, and for each use it supports what that use does, what it takes, what it returns, and how it fails — and performs none of its uses in answering, so that nothing is rendered and no file changes

  @feature:feat-tool-skills-rest @hash:6f6f93180b23
  Scenario: a compiler's skill is produced from the compiler's own answer
    Given a compiler's answer to the standard question
    When the compiler's skill is produced
    Then a skill for the compiler stands at the agent's load point, names the compiler as what it was produced from, states every use the answer states, and says nothing about the compiler that the answer does not say — produced from the answer and from nothing else, not the compiler's source, not its help

  @feature:feat-tool-skills-rest @hash:f20a781be781
  Scenario: the producer of tool skills produces its own skill from its own answer
    Given the producer of tool skills, the framework tool that produces each tool's skill from that tool's answer, and its own answer to the standard question
    When the producer's skill is produced
    Then a skill for the producer stands at the agent's load point, names the producer as what it was produced from, states every use the producer's answer states, and says nothing about the producer that its answer does not say

  @feature:feat-tool-skills-rest @hash:586e17ebd992
  Scenario: a tool that cannot answer has a description beside it in the same shape
    Given a tool the shop runs but does not own, which does not answer the standard question
    When a description for the tool is written beside it
    Then a description stands beside the tool in the same shape an answer takes — the tool's name, what it does, and for each use it supports what that use does, what it takes, what it returns, and how it fails — naming the tool it stands beside and the shop that owns that tool, and written from what the tool shows whoever runs it, not from the tool's source

  @feature:feat-tool-skills-rest @hash:a7657325c775
  Scenario: a description beside a tool that is not in the answer's shape yields no skill
    Given a description beside a tool that lacks a part the shape requires
    When the tool's skill is produced
    Then no skill is produced for that tool, and the lack is reported naming the tool and the part

  @feature:feat-tool-skills-rest @hash:f3c767a50e31
  Scenario: the skill of a tool that cannot answer is produced from the description beside it
    Given a description beside a tool that cannot answer, in the same shape an answer takes
    When the tool's skill is produced
    Then a skill for the tool stands at the agent's load point, names the description beside the tool as what it was produced from and the tool it stands beside, states every use the description states, and says nothing about the tool that the description does not say

  @feature:feat-tool-skills-rest @hash:c5624b8d33c8
  Scenario: a tool that cannot answer is recorded as a gap against its owner
    Given a tool the shop runs but does not own, with a description beside it
    When the tool's skill is produced from the description beside it
    Then a gap is recorded naming the tool and the shop that owns it — the tool does not answer the standard question, and its skill stands on a description beside it until it does

  @feature:feat-tool-skills-rest @hash:4d3e67a4f717
  Scenario: each use entry in a produced skill is complete
    Given the skill of any of the eleven tools, produced from the tool's answer or from the description beside it
    When a use entry in it is read
    Then it states what the use does; what it takes, each input named and an omitted input's treatment; what it returns; how it fails, each failure a stable code beside its explanation and next step; and the exact invocation

  @feature:feat-tool-skills-rest @hash:d6d0e85cf003
  Scenario: a change to what a compiler says about itself reaches its skill
    Given a compiler's answer to the standard question changed since its skill was produced
    When the process that keeps tool skills current runs
    Then the compiler's skill states what the compiler now says about itself and is current with the changed answer

  @feature:feat-tool-skills-rest @hash:f87375439754
  Scenario: a change to the description beside a tool reaches its skill
    Given the description beside a tool that cannot answer changed since the tool's skill was produced
    When the process that keeps tool skills current runs
    Then the tool's skill states what the description now says and is current with the changed description

  @feature:feat-tool-skills-rest @hash:8dfa9ca5923e
  Scenario: a tool skill not current with the description beside its tool is reported
    Given a tool skill not current with the description beside its tool, whatever the cause
    When the check over tool skills runs
    Then the check reports that skill as not current, naming the tool

  @feature:feat-tool-skills-rest @hash:62f7ccb607b9
  Scenario: a tool that begins to answer is used through its answer, not the description beside it
    Given a tool with a description beside it that now answers the standard question
    When the process that keeps tool skills current runs
    Then the tool's skill is produced from the tool's answer, names the tool as what it was produced from, and no description beside the tool stands as a source of its skill

  @feature:feat-tool-skills-rest @hash:0c53e2c42901
  Scenario: the check over the load point passes clean with every tool's skill in place
    Given the skills of the lint, the five compilers, and the six external tools at the agent's load point, each current with its tool's source, beside the skills of the approved processes
    When the check over the load point runs
    Then the check reports every tool skill as current, every approved process's skill as before, and no skill at the load point as unrecognized

  @feature:feat-tool-skills-rest @hash:14a7607203db
  Scenario: a tool's skill is loaded for a task that calls for the tool
    Given an agent in a fresh context with the skills of the twelve tools at its load point and no other source on any of them, and a task that calls for running one of the eleven
    When the agent begins the task
    Then that tool's skill is loaded for the task before any invocation of the tool, and the agent's invocation is the one the skill states, not a bare one

  @feature:feat-tool-skills-rest @hash:8a5b9a35a86a
  Scenario: an agent completes a use of a tool on the first invocation the skill states
    Given an agent in a fresh context with one of the eleven tools' skill its only source on that tool, and a task calling for one of the uses the skill states
    When the agent performs the task
    Then the agent's first invocation of the tool is the one the skill states for that use, with no read of the tool's source or help and no second attempt, and the use completes with the return the skill states

  @feature:feat-tool-skills-rest @hash:572bb00db7d9
  Scenario: a failure the agent meets is one the skill names, read as the skill states it
    Given an agent in a fresh context with one of the eleven tools' skill its only source on that tool
    When an invocation of the tool made through the skill fails
    Then the failure is one the skill names for that use, and the agent states, from the skill alone, what the failure means and the next step to take
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| Eleven framework tools the shop runs still not usable through a skill | the framing ("no framework tool the shop runs can be used through a skill"); the For whom section and its measure (1 of 12 after the proof, the Document History v11) | Scenario: a compiler's skill is produced from the compiler's own answer, read once per compiler; Scenario: the skill of a tool that cannot answer is produced from the description beside it, read once per external tool; Scenario: an agent completes a use of a tool on the first invocation the skill states — the skill in use |
| An agent that needs a tool reads its source or copies a prior command — the work register's flags copied script to script | the framing ("reads its source or copies a prior command — which the tools-through-skills principle now forbids"); the discovery's evidence table (sess-2026-09-06-c) | Scenario: an agent completes a use of a tool on the first invocation the skill states — "no read of the tool's source or help"; Scenario: a tool's skill is loaded for a task that calls for the tool — the invocation is the skill's, not a bare one |
| A tool from another shop unusable without its source | the framing ("a tool from another shop could not be used at all without its source"; "a tool from any shop is usable the moment it answers") | Scenario: a tool that cannot answer has a description beside it in the same shape — written from what the tool shows whoever runs it, not from its source; Scenario: the skill of a tool that cannot answer is produced from the description beside it; Scenario: a tool that begins to answer is used through its answer, not the description beside it — the moment it answers |
| A tool that cannot answer | the framing's outcome ("a tool that cannot answer has a description beside it in the same shape"); the initiative's Appetite (first no-go: "the external six by descriptions beside them until their owners answer") | Scenario: a tool that cannot answer has a description beside it in the same shape; Scenario: the skill of a tool that cannot answer is produced from the description beside it; Scenario: a tool that cannot answer is recorded as a gap against its owner |
| A description beside a tool not in the same shape — a use entry missing a part | the framing's outcome ("in the same shape"; the four parts); the architect's fourth risk (the initiative's Document History v3: the descriptions are hand-written) | Scenario: a description beside a tool that is not in the answer's shape yields no skill; Scenario: each use entry in a produced skill is complete — a skill that stands carries every part |
| A skill that states a use without what it returns or how it fails | the framing's outcome (the four parts); the architect's third risk (v3) | Scenario: each use entry in a produced skill is complete; Scenario: a compiler the shop owns answers the standard question — the answer carries the four parts per use |
| A use the answer or the description states that the skill omits | the framing's outcome ("for each use it supports" — every use, not some) | Scenario: a compiler's skill is produced from the compiler's own answer and Scenario: the skill of a tool that cannot answer is produced from the description beside it — "states every use"; Scenario: a tool skill not current with the description beside its tool is reported — a skill missing a use is not what a fresh production yields |
| A change to what a tool says about itself that does not reach its skill | the framing's outcome ("a change to what a tool says about itself reaches its skill") | Scenario: a change to what a compiler says about itself reaches its skill; Scenario: a change to the description beside a tool reaches its skill; Scenario: a tool skill not current with the description beside its tool is reported. For a tool that answers, the report is already specified in the repository — feat-tool-skills' *a tool skill not current with its tool's answer is reported* reads of any tool that answers — and is not specified twice here |
| A tool skill changed by hand | the framing's outcome's boundary (a skill changed other than through its tool's source) | Scenario: a tool skill not current with the description beside its tool is reported — "whatever the cause"; Scenario: a change to the description beside a tool reaches its skill and Scenario: a change to what a compiler says about itself reaches its skill — the skill that stands afterwards is produced from the source, not the edit |
| A description that depends on anything but the tool's own answer — a description written from the tool's source, or a compiler's skill written from anything but its answer | the initiative's Appetite (second no-go: "the tool answers, its source stays its own") | Scenario: a compiler's skill is produced from the compiler's own answer — "from nothing else"; Scenario: a tool that cannot answer has a description beside it in the same shape — written from what the tool shows whoever runs it, not from its source; the description is the framed stand-in, kept until the tool answers, and no other source is in scope |
| A description beside a tool that drifts from what the tool now does, with no answer to check it against | the architect's fourth risk (v3: "drift there is unreached by this bet's check — inside the no-go, named for the second feature") | Out of scope of a check: no check can read a tool that does not answer, and the framing's remedy is the owner's answer, which Scenario: a tool that cannot answer is recorded as a gap against its owner asks for. Found in use by Scenario: an agent completes a use of a tool on the first invocation the skill states and Scenario: a failure the agent meets is one the skill names, read as the skill states it — a use that does not complete as the skill states, or a failure the skill does not name, is the drift observed, and its repair is a change to the description, which Scenario: a change to the description beside a tool reaches its skill carries to the skill |
| A description beside a tool that has begun to answer — two homes for what the tool says about itself | the framing's outcome ("usable the moment it answers"); the Appetite ("until their owners answer") | Scenario: a tool that begins to answer is used through its answer, not the description beside it — no description stands as a source once the tool answers |
| The producer of tool skills, itself a framework tool that must answer | the initiative's Document History v11 ("the producer of tool skills … is itself a framework tool that must answer"); the architect's second risk (v3) | Scenario: the producer of tool skills produces its own skill from its own answer; Scenario: a compiler the shop owns answers the standard question, read once per compiler, the producer among the five |
| A compiler answering the standard question by rendering, by exiting on an error, or by reading the question as a file | the initiative's Feasibility and usability section and the roles' offers (Document History v3 and v5: three tools mislead a caller who asks for help; one exits on a traceback, one reads the flag as a file path) | Scenario: a compiler the shop owns answers the standard question — "performs none of its uses in answering, so that nothing is rendered and no file changes"; a traceback or a rendering is not an answer and the Then is unmet |
| Whether the compilers' help also answers as help | the designer's fourth risk (the initiative's Document History v5); the initiative's Document History v11 ("Open scope call kept: whether `--help` also answers as help") | Out of scope: the framed outcome is a skill an agent uses without reading the tool's help; what the help says serves no framed outcome here. The scope call stands open with the PM role, as feat-tool-skills recorded it; not decided here |
| The measure — 1 of 12 to 12 of 12 | the For whom section ("Measure: framework tools usable through a skill produced from the tool's own answer"); the Document History v11 (1 of 12) | Scenario: the check over the load point passes clean with every tool's skill in place — the twelve standing and current, read together; Scenario: an agent completes a use of a tool on the first invocation the skill states, read once per tool for at least one use it states, and Scenario: a failure the agent meets is one the skill names, read as the skill states it, read at least once over the eleven — "usable" read from those observations, not from a skill standing; the count itself is the PM role's to read |
| A use of an external tool the freeze bars running — a message sent, a dispatch made | the shop's operating rules (the primer: no dispatches, no mailbox work while frozen); the designer's first risk (v5: "usable" is a usability claim, a hypothesis until measured task completion) | Out of scope of the run: a use the freeze bars is not run in the proof, so for that tool "usable" is read from Scenario: an agent completes a use of a tool on the first invocation the skill states on a use the freeze allows, or stands as a hypothesis the delivery says so, until the freeze lifts — which of the two, per tool, is the PM role's to read with the measure. The skill stands regardless, by Scenario: the skill of a tool that cannot answer is produced from the description beside it |
| The owner of an external tool the lead shop cannot name | the framing's "the shops whose tools the product accepts"; the vocabulary's owner of a tool | Scenario: a tool that cannot answer has a description beside it in the same shape — the description names the owner, and the Then is unmet while it cannot. Proposed default, for the PM role: the description names the owner as the shop the tool's provenance names, and where none can be named it says so and the lead shop holds the gap as its own until an owner is found |
| The gap reaching its owner while the shop is frozen | the decision the bet rests on (its Document History v1, third candidate: how the gap for a tool that cannot answer is recorded to its owner while the shop is frozen); the primer's freeze | Out of scope: the record of the gap is Scenario: a tool that cannot answer is recorded as a gap against its owner's; its reaching the owner is the freeze's and the router's, the PM role's to route after the freeze — no scenario sends anything |
| Two tools answering, or described, under the same name | the framing's "every framework tool … usable through a skill" — each its own; the same shape's rule that a tool's name is unique among the product's tools | Scenario: the check over the load point passes clean with every tool's skill in place — two tools under one name leave one without a skill of its own, and the Then is unmet |
| The check over the load point rejecting a tool skill, or the approved processes' skills checked otherwise than before | feat-skills-availability's scenarios over the load point (the feature repository, read in full); the initiative's Feasibility and usability section (the load-point risk) | Scenario: the check over the load point passes clean with every tool's skill in place — the Given holds the approved processes' skills beside the twelve; "every approved process's skill as before" is what feat-skills-availability specifies, unchanged |
| "Usable" met as a hypothesis until measured task completion | the initiative's Feasibility and usability section; the designer's first risk (v5) | Scenario: an agent completes a use of a tool on the first invocation the skill states; Scenario: a failure the agent meets is one the skill names, read as the skill states it — until observed for a tool, the delivery says "hypothesis" for that tool |
| The agent's first invocation not the one the skill states — a read of the source or help, or a second attempt | the designer's criteria ((a), the initiative's Document History v5) | Scenario: an agent completes a use of a tool on the first invocation the skill states |
| A failure the agent meets that the skill does not name | the designer's criteria ((b), v5) | Scenario: a failure the agent meets is one the skill names, read as the skill states it; Scenario: each use entry in a produced skill is complete |
| The agent proceeding to a bare invocation with the skill present — twelve tool skills beside the process skills at one load point | the designer's criteria ((c), v5) and third risk (a skill not offered for the task) | Scenario: a tool's skill is loaded for a task that calls for the tool — the Given holds all twelve, so the right one is loaded among them |
| A description beside a tool written by a person in a machine shape — a document interaction with no pattern | the designer's fifth risk (v5: "in the second feature, noted for it") | Out of scope of the scenarios: whether the core-task list carries it, and what pattern it takes, is the designer's step's to record; Scenario: a tool that cannot answer has a description beside it in the same shape states what the description carries, not how it is written |
| The delivered skills screened as interfaces; the tools' names entered in the vocabulary | the designer's attachment (v5: the conformance screen at delivery; R2, the vocabulary's tool terms) | Out of scope of the scenarios: a delivery gate the designer's check judges and a corpus entry the designer makes, not a behavior of this feature |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Authored by the PO role alone in the feature-authoring draft step, from init-tool-skills's Framing and For whom sections (v11, active), its Appetite's first no-go as the scope — "the other eleven — the five compilers the shop owns answering the standard question; the six external tools (bd, shop-msg, shop-knowledge, agent-vault, bc-emit, shop-templates) by descriptions beside them in the same shape until their owners answer" — authorized by the authority's standing direction ("If it passes then proceed to the rest without asking me") on the proof's pass, recorded in the initiative's Document History v11; the decision the bet rests on, adr-2026-09-07-tool-answer (checked), read for what must hold and named in no scenario; sixteen scenarios, all owned by the lead shop per the initiative's Decomposition; interaction types none per its For whom; every scenario `@hash:pending` — the authoring session had no shell, so the lead-pm fills the values (sha256 of the scenario's text, first twelve hex digits, as in the repository's other features) before the check. The feature repository read in full: six features; feat-tool-skills (v8, assigned, delivered) specifies the proof on the lint and its general scenarios — *a tool skill not current with its tool's answer is reported* reads of any tool that answers and is not specified again here, cited in the Edges row on a change not reaching its skill; its Contributors vocabulary is referenced, not copied; feat-skills-availability's check over the load point carried in the Given of *the check over the load point passes clean with every tool's skill in place* and in an Edges row; the other four name no framework tool, answer, or skill. Maker's self-check against the feature fitness set (v8), each scenario read as Given/When/Then: scenario 1 (one observable behavior) pass — each When is one action or event (a compiler asked; a skill produced; a description written; the process run; the check run; the agent beginning or performing a task; an invocation failing), each Then observable in the running system (an answer given and nothing rendered; a skill standing at the load point naming its source; a description standing; no skill and a report; a gap recorded; parts present; a report naming the tool; a first invocation and its result; a failure and the agent's statement), and no step names a flag, a file path, a format, a tool by its program name, or a compiler by its program name — the five compilers and the six external tools are named by program name in the Contributors vocabulary and the Edges table only; scenario 2 (ownership and criteria) pass — an owning shop named for each of the sixteen; no interaction type named, so the designer's criteria are not due at this step, and the Contributors section says what the designer's and the architect's steps record; scenario 3 (identity tags) pass on presence — `@feature:feat-tool-skills-rest` and `@hash:pending` on every scenario, the values disclosed as pending; scenario 4 (edges) pass — twenty-seven rows: every case the framing's Problem and outcome, the For whom section and its measure, the Appetite's two no-gos, the Feasibility and usability section's risks and hypothesis, the Decomposition, the Document History v11's scope and open scope call, the designer's criteria (a)–(c), the architect's second, third, and fourth risks, and the repository's touch-point name is present, twenty covered by scenario name, and seven out of scope or out of scope of a check with reasons (the help's behavior; the drift of a description with no answer to check against; a use the freeze bars; the gap's reaching its owner while frozen; the description as a document interaction; the delivery screen and the vocabulary), one of them with a proposed default for the PM role (the owner that cannot be named); scenario 5 (interaction types) pass — "none" with the For whom section's reason, and the designer's fifth risk noted for that role's step; scenario 6 (narrative) pass — who (every agent of the shop that runs a tool, and the shops whose tools the product accepts), what (use each of the other eleven framework tools through a skill stating the four parts, produced from the answer or from a description beside a tool that cannot answer), the outcome the framing's ("every framework tool is usable through a skill produced from the tool's own answer … a tool that cannot answer has a description beside it in the same shape … a change to what a tool says about itself reaches its skill"). Scope declined or held, with the reason in the Edges table: the help's behavior — the open scope call stays with the PM role; sending the gap to its owner while the shop is frozen — the freeze's, no scenario sends. One question out to the PM role with its default, in the Edges table: the owner of an external tool the lead shop cannot name. Status draft pending the PO output check. |
