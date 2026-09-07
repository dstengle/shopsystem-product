---
type: feature
id: feat-tool-skills-rest
name: Tool skills for the rest
status: assigned
version: 8
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

Vocabulary. Terms defined in the Contributors section of
[feat-tool-skills](feat-tool-skills.md), used here with that
section's meaning and read of any tool where it reads of the lint —
one clause each to read by, the definition staying that feature's:
**framework tool** — a tool the shop's definitions name for an
activity; **skill** — the rendering at the agent's load point that
states a tool's use so an agent performs it from the skill alone;
**gap** — a missing definition, tool, or skill the shop records
rather than works around; **the standard question** — the one
question every framework tool is asked about itself, the same for a
tool from any shop; **the answer** — what a tool says in reply: its
name, what it does, one use entry per use; **use**, **use entry** —
one thing a tool can be asked to do, and its entry of four parts
with, in the skill, the exact invocation; **a part of its own** — a
part present as itself, not inferred from another; **produced from**
— a rendering of its source, never edited by hand and never the
source; **current with** — what a fresh production from the source as
it now stands would yield; **the process that keeps tool skills
current** — the process whose run produces each tool skill afresh
from its source; **the check over tool skills** — that process's
check, reporting a skill not current; **the agent's load point** —
where the agent runtime loads skills from; **the check over the load
point** — the check feat-skills-availability specifies there; **a
fresh context**, **its only source on a tool** — an agent whose
context holds the tool's skill and nothing else about the tool; **the
first invocation** — the first command the agent issues to the tool
for a use; **a bare invocation** — the tool run other than as its
skill states; **a stable code** — a failure's identifier, the same on
every run that fails the same way. Terms this feature adds, in the
order the scenarios use them:

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
  answers, when the answer replaces it. "For each use it supports",
  read of a description (the designer's question, ruled at the
  check): at least every use of the tool a shop definition or a
  load-point skill names and every use the shop runs by hand; a use
  outside that is described when a task first calls for it, never
  run bare. Where a description is written from is a rule on its
  writer, constraint (7).
- **the same shape** — the shape an answer takes, one shape for every
  tool from any shop; the decision the bet rests on,
  [adr-2026-09-07-tool-answer](../decisions/adr-2026-09-07-tool-answer.md)
  (checked), fixes it, and the scenarios name only its parts.
- **what the tool says about itself** — for a tool that answers, its
  answer; for a tool that cannot answer, the description beside it,
  standing in the answer's place until the tool answers. "Current
  with" is read against this: a change to the answer, or to the
  description, since the skill was produced leaves a skill that is
  not current. **The tool's source**, wherever it appears in this
  document, means the program's source — what the
  tools-through-skills principle forbids an agent to read — and never
  the answer or the description.
- **the measure** — the initiative's: framework tools usable through
  a skill produced from the tool's own answer. Now 1 of 12, the lint;
  after this feature 6 of 12 — the lint and the five compilers. The
  six external tools are usable through a skill produced from the
  description beside each and are not counted until their owners
  answer (the PM role's ruling at the check; the count is that role's
  to read).

Provenance of the scenarios, outside the ownership list: *the
producer of tool skills produces its own skill from its own answer* —
the initiative's Document History v11 and the architect's second risk
(v3), the producer a framework tool that counts in the measure; *a
description beside a tool that is not in the answer's shape yields no
skill* and *a tool skill not current with the description beside its
tool is reported* — the architect's fourth risk (v3), what a check
can reach of a hand-written description, the rest an Edges row; *a
tool that begins to answer is used through its answer, not the
description beside it* — the framing's "usable the moment it answers"
and the Appetite's "until their owners answer"; *a tool that cannot
answer is recorded as a gap against its owner* — the stand-in part of
the decision the bet rests on, in scope by the PM role's ruling at
the check, the authority's "until their owners answer" presupposing
it; the last three scenarios — the designer's usability acceptance
criteria (a)–(c) (the initiative's Document History v5), read of any
of the eleven. The For whom section names no interaction type and
the Decomposition no Bounded Context; what criteria are due, the
designer's and the architect's passages below record.

The product designer role's criteria (feature-authoring's
add-usability step, 2026-09-07):

*Due: none.* The For whom section's "none" holds against the
core-task list (v4): no core task carries a tool skill, a tool's
answer, or a description beside a tool. Four interfaces are delivered
regardless and screened under `agent-is-a-user` — each tool's skill
(`api`), each compiler's answer (`cli`), the producer's report to a
description's writer (`cli`), and the gap record as its owner reads
it — so the criteria below stand, each a hypothesis under
`evidence-not-opinion` until observed as measured task completion in
the delivery; the reasoning, the accessibility reasoning, and the
delivery screen's routing are in this document's history (v2, v4).

Usability acceptance criteria, riding on the scenarios by name, no
scenario text changed — (a)–(c) feat-tool-skills' read of any of the
eleven, (d) and (e) this feature's own:

- (a) *the first invocation is the skill's* — rides on *an agent
  completes a use of a tool on the first invocation the skill states*
  and *a tool's skill is loaded for a task that calls for the tool*.
  Met, per tool, when the agent's first command to the tool for a use
  is the invocation the skill states and the use completes with the
  return the skill states; read once per tool on at least one use the
  skill states — for a tool whose uses the freeze bars, on a use it
  allows, or "hypothesis" for that tool in the delivery. Invalidated
  by a read of the tool's source, its help, its answer, or the
  description beside it; a second attempt; or a bare invocation with
  the skill present.
- (b) *each use entry is complete* — rides on *each use entry in a
  produced skill is complete* and, as its test in use, *a failure the
  agent meets is one the skill names, read as the skill states it*.
  Met when every use entry of every produced skill carries the five
  parts the scenario states and the failing run's failure is one its
  entry names, read from the skill alone; read at least once over the
  eleven and at least once on a skill produced from a description —
  there a failure the skill does not name is the description's drift
  observed (the Edges row on drift). Invalidated by a failure the
  skill does not name, or a part inferred from another rather than
  present.
- (c) *the skill is offered for the task* — rides on *a tool's skill
  is loaded for a task that calls for the tool*. Met when, in a fresh
  context with the twelve tool skills at the load point, the skill of
  the tool the task calls for is loaded before any invocation.
  Invalidated by a bare invocation with the skill present, or by
  another tool's skill loaded in its place; the remedy for either is
  the producer's, not a scenario.
- (d) *the lack is reported for the writer* — rides on *a description
  beside a tool that is not in the answer's shape yields no skill*
  and *the producer of tool skills produces its own skill from its own
  answer*. Met when the report names the tool and the part (the
  vocabulary's word or its recorded api mapping), gives the next
  step, and carries a stable code beside that and not in place of it —
  and the failure is one the producer's own skill names, so the writer
  reads it from that skill alone. Invalidated by a traceback, a
  parser's message, or a schema path standing in place of the part;
  by the part named without the tool; or by a failure on a
  description that the producer's skill does not name.
- (e) *the gap is actionable by its owner* — rides on *a tool that
  cannot answer is recorded as a gap against its owner*. Met when the
  record, read by the owning shop with nothing else, states in its
  first line what happened — the tool does not answer the standard
  question — and, as its one action, what answering takes: the
  standard question and where its shape is published. Invalidated by
  a record from which the owner must ask what to answer or in what
  shape. A hypothesis until a gap reaches an owner after the freeze
  (the Edges row on it), and the delivery says so.

*Accessibility criteria: none due* — no type is named; the skill is
agent-facing under `agent-is-a-user`, so no WCAG target applies to
it; the compilers' answers and the producer's report are `cli`
interactions whose WCAG2ICT applicability record is written once for
the type at the delivery screen; the description is a file its writer
edits in their own editor; the gap record's accessibility is the
request lane's record's. No criterion names an output's form (Edges
row added). The delivery screen of the four interfaces under the
interaction-conformance-check process is a gate the Edges table holds,
not a criterion.

The solutions architect role's constraints (feature-authoring's
add-constraints step, 2026-09-07):

*Contract bound: none; cross-context flow: none.* The initiative's
Decomposition section (v12) names no Bounded Context, no contract
exists on this branch, and none of the six tools' owners is relied on
by contract — what the lead shop holds about each is its own
description, under (7); every scenario stays the lead shop's.
*Guardrail: one, and it binds.* The decision the bet rests on,
[adr-2026-09-07-tool-answer](../decisions/adr-2026-09-07-tool-answer.md)
(checked, v3), whose §2, §3 fourth consequence, and bound on Bounded
Context shops reach every one of the eleven as they reached the lint.
Nine constraints — what must hold, not how; the how is the maker's
within them, and a choice outside them is a question against the
record: (1)–(6) the first feature's read of any of the eleven, each
with what this feature adds; (7)–(9) this feature's own. Each rides
on scenarios by name; no scenario text changed by this role. The
pre-state read for them and their screen against the architecture
principle set are in this document's history (v3, v4).

- (1) *what counts as an answer* — rides on *a compiler the shop owns
  answers the standard question*, read once per compiler, *the
  producer of tool skills produces its own skill from its own answer*,
  and *a tool that begins to answer is used through its answer, not
  the description beside it*. A reply is an answer only as the
  record's §2 counts one: given on the standard flag, written to
  standard output with exit status 0 before any other action and with
  other arguments ignored, parsing against the tool-description data
  type; a traceback, a usage sheet, the flag read as a file path, a
  rendering performed, another exit status, or output that does not
  parse is "cannot answer" and the Then unmet. The producer is one of
  the five with no special case. The same line, both observations
  made together, decides when a tool a description stands beside has
  begun to answer; a reply that fails either leaves it a tool that
  cannot answer, and the description stands.
- (2) *the shape is the contract's — one shape, the description in it
  too* — rides on *a tool that cannot answer has a description beside
  it in the same shape*, *a description beside a tool that is not in
  the answer's shape yields no skill*, and *each use entry in a
  produced skill is complete*. The data type stands approved (v2),
  and every answer and every description is read against it. A
  description is an instance of that same data type (the record's §2
  stand-in part): the same schema block, the same validation, no
  relaxed variant for a hand-written file; kept at the one home the
  data type names; carrying the two fields the data type reserves for
  it — which tool it stands beside, which shop owns that tool — so a
  description lacking either is not in the shape and yields no skill;
  its name unique among the product's twelve tools, being the skill's
  name. The lack is reported by the part's name as the data type fixes
  it; the report's wording for its writer is the designer's (d).
- (3) *sole source, and the direction of repair* — rides on *a
  compiler's skill is produced from the compiler's own answer*, *the
  skill of a tool that cannot answer is produced from the description
  beside it*, *a change to what a compiler says about itself reaches
  its skill*, *a change to the description beside a tool reaches its
  skill*, and *a tool skill not current with the description beside
  its tool is reported*. For a compiler, as at the lint: the answer is
  the sole source; "current with" is decided by asking again and
  digesting the fresh answer, never a kept copy, never the program's
  source; a difference resolves toward the answer. For a tool that
  cannot answer, the file beside it is the source in the same sense:
  the digest over the file's bytes as they stand, "current with"
  decided by re-producing from the file each run, the skill's
  provenance naming the file and, beside it, the tool it stands
  beside; a difference resolves toward the file, and a hand-edited
  skill does not survive the next production. Drift found in use (the
  Edges row on it) is repaired in the description, never in the skill;
  the description is the source only until the tool answers.
- (4) *the load-point check recognizes, never exempts — three source
  kinds now* — rides on *the check over the load point passes clean
  with every tool's skill in place*, *a tool skill not current with
  the description beside its tool is reported*, and *a tool that
  begins to answer is used through its answer, not the description
  beside it*. The check reads a skill by its source kind — an approved
  process definition, a tool under the shop's tools directory, or a
  description at the home the data type names — never by an
  exemption, a skip list, or a hand-marked exception; the producer's
  own skill is checked through the producer like any tool's. For the
  third kind (the record's digest gate; its §3 fourth consequence):
  each run re-produces from every description and diffs, reporting a
  difference by the tool's name, and asks the tool every description
  stands beside — an answer there is the finding the record names, a
  second home, resolved by producing the skill from the answer and
  retiring the description, never by editing the answer. The
  amendment that recognizes the third kind is the process owner's,
  raised at skill-rendering v8, in the order the process-definition
  typedef's commitment fixes; until it lands the clean-pass Then is
  unmet; feat-skills-availability's seven scenarios pass as today.
- (5) *the answer's form binds no shop's language* — rides on *a
  compiler the shop owns answers the standard question* and *a tool
  that cannot answer has a description beside it in the same shape*.
  The framed outcome it protects: a tool from any shop is usable the
  moment it answers, in whatever language it is written. Every
  answer, and every description, is given in the form the record's
  JSON bound fixes, and neither answering nor producing a skill from
  an answer or a description adds a dependency that binds a shop's
  language. A dependency, a vendor, or a recurring cost added by this
  feature is the record's delivery read by this role, not a scenario.
- (6) *the skill is the artifact of use* — rides on *a tool's skill is
  loaded for a task that calls for the tool*, *an agent completes a
  use of a tool on the first invocation the skill states*, and *a
  failure the agent meets is one the skill names, read as the skill
  states it*. The invocation the skill states for a use is the use's
  command line as the answer, or the description, gave it, and it is
  the invocation whoever performs the step (the record's fifth
  consequence). The fresh context's "its only source on that tool"
  excludes the description beside a tool as it excludes the answer,
  the data type, the program's source, and the help; a use completed
  only by reading the description is a skill that does not suffice,
  the designer's (a) invalidated — distinct from a use that does not
  complete as the skill states, which is the description's drift and
  repairs under (3).
- (7) *a description is the lead shop's record, not the owner's
  contract* — rides on *a tool that cannot answer has a description
  beside it in the same shape* and *a tool that cannot answer is
  recorded as a gap against its owner*. One description per tool that
  cannot answer, naming the tool as the check asks it — the field for
  which tool it stands beside carries the invocation the check makes
  — and the shop that owns it. It is written from what the tool shows
  whoever runs it — its help, its behaviour when run — and never from
  the tool's source (the Appetite's second no-go; `knowable-shape`).
  Written by the consuming shop about another shop's tool (the
  record's bound on Bounded Context shops): no promise in it is owed
  by the owner, nothing the lead shop relies on in it is a contract of
  the owner's — the relationship kind while the tool does not answer
  is conformist; the moment the tool answers, the kind is the
  record's, published language and open host service, and the
  description is retired.
- (8) *the gap's life is the description's* — rides on *a tool that
  cannot answer is recorded as a gap against its owner* and *a tool
  that begins to answer is used through its answer, not the
  description beside it*. One gap per tool, opened when its
  description is written and standing while the description is a
  skill's source; what it asks is fixed by the record's bound — that
  the tool answer the standard flag in the data type's shape — and the
  designer's (e) fixes how its owner reads it. It closes on one event
  only: the check observing the tool's answer, the skill produced from
  it, and the description retired — never by a hand edit, a change to
  the description, or a skill written around the tool
  (`tools-through-skills`). Its form, ruled at the check on this
  role's default: one request record per tool under the request lane,
  addressed to the owning shop, held and not routed while the shop is
  frozen, naming the tool, its owner, the standard flag, and the data
  type; no work item unless the lane asks one. Its reaching the owner
  stays out of scope (the Edges row).
- (9) *asking is the check's only invocation of an external tool* —
  rides on *the check over the load point passes clean with every
  tool's skill in place* and *a tool that begins to answer is used
  through its answer, not the description beside it*. Under (4) the
  check asks each of the six the standard question every run, while
  the shop is frozen and the tool is another shop's; a tool that
  cannot answer promises nothing about what it does when asked. So
  the check asks with the flag alone and no other argument, invokes
  the tool for nothing else, and a tool observed to perform a use when
  asked is a finding to this role, its asking suspended for that tool
  until its owner answers (the Edges row).

Enabler work recommended into the PO role's backlog: none new — the
one definition change this feature needs, the check's third source
kind, is the process owner's amendment already raised at
skill-rendering v8 and lands inside this delivery in the order (4)
fixes, as the first feature's did.

## Interaction types

None — a skill is read by an agent inside a process step; no core
task carries it (the initiative's For whom section). Recorded at the
designer's step and ruled at the check: the description beside a tool
that cannot answer is not an interaction type — it is what a person
gives the product in the data type's published shape, and the product
meets its writer at the producer's command line, which criterion (d)
covers; and the gap record another shop will read is a request record
the lead shop holds, not an interaction of the product. "None"
stands.

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

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:c648ef04449d
  Scenario: a compiler the shop owns answers the standard question
    Given a compiler the shop owns, one of the five
    When the compiler is asked the standard question
    Then the compiler answers with what it says about itself — its name, what it does, and for each use it supports what that use does, what it takes, what it returns, and how it fails — and performs none of its uses in answering, so that nothing is rendered and no file changes

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:6f6f93180b23
  Scenario: a compiler's skill is produced from the compiler's own answer
    Given a compiler's answer to the standard question
    When the compiler's skill is produced
    Then a skill for the compiler stands at the agent's load point, names the compiler as what it was produced from, states every use the answer states, and says nothing about the compiler that the answer does not say — produced from the answer and from nothing else, not the compiler's source, not its help

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:f20a781be781
  Scenario: the producer of tool skills produces its own skill from its own answer
    Given the producer of tool skills, the framework tool that produces each tool's skill from that tool's answer, and its own answer to the standard question
    When the producer's skill is produced
    Then a skill for the producer stands at the agent's load point, names the producer as what it was produced from, states every use the producer's answer states, and says nothing about the producer that its answer does not say

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:802c8401fbc7
  Scenario: a tool that cannot answer has a description beside it in the same shape
    Given a tool the shop runs but does not own, which does not answer the standard question
    When a description for the tool is written beside it
    Then a description stands beside the tool in the same shape an answer takes — the tool's name, what it does, and for each use it supports what that use does, what it takes, what it returns, and how it fails — naming the tool it stands beside and the shop that owns that tool

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:a7657325c775
  Scenario: a description beside a tool that is not in the answer's shape yields no skill
    Given a description beside a tool that lacks a part the shape requires
    When the tool's skill is produced
    Then no skill is produced for that tool, and the lack is reported naming the tool and the part

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:f3c767a50e31
  Scenario: the skill of a tool that cannot answer is produced from the description beside it
    Given a description beside a tool that cannot answer, in the same shape an answer takes
    When the tool's skill is produced
    Then a skill for the tool stands at the agent's load point, names the description beside the tool as what it was produced from and the tool it stands beside, states every use the description states, and says nothing about the tool that the description does not say

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:5441feae9b88
  Scenario: a tool that cannot answer is recorded as a gap against its owner
    Given a tool the shop runs but does not own, which does not answer the standard question
    When a description for the tool is written beside it
    Then a gap is recorded naming the tool and the shop that owns it — the tool does not answer the standard question, and its skill stands on a description beside it until it does

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:4d3e67a4f717
  Scenario: each use entry in a produced skill is complete
    Given the skill of any of the eleven tools, produced from the tool's answer or from the description beside it
    When a use entry in it is read
    Then it states what the use does; what it takes, each input named and an omitted input's treatment; what it returns; how it fails, each failure a stable code beside its explanation and next step; and the exact invocation

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:d6d0e85cf003
  Scenario: a change to what a compiler says about itself reaches its skill
    Given a compiler's answer to the standard question changed since its skill was produced
    When the process that keeps tool skills current runs
    Then the compiler's skill states what the compiler now says about itself and is current with the changed answer

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:f87375439754
  Scenario: a change to the description beside a tool reaches its skill
    Given the description beside a tool that cannot answer changed since the tool's skill was produced
    When the process that keeps tool skills current runs
    Then the tool's skill states what the description now says and is current with the changed description

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:8dfa9ca5923e
  Scenario: a tool skill not current with the description beside its tool is reported
    Given a tool skill not current with the description beside its tool, whatever the cause
    When the check over tool skills runs
    Then the check reports that skill as not current, naming the tool

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:62f7ccb607b9
  Scenario: a tool that begins to answer is used through its answer, not the description beside it
    Given a tool with a description beside it that now answers the standard question
    When the process that keeps tool skills current runs
    Then the tool's skill is produced from the tool's answer, names the tool as what it was produced from, and no description beside the tool stands as a source of its skill

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:1177727e510a
  Scenario: the check over the load point passes clean with every tool's skill in place
    Given the skills of the lint, the five compilers, and the six external tools at the agent's load point, each current with what its tool says about itself, beside the skills of the approved processes
    When the check over the load point runs
    Then the check reports every tool skill as current, every approved process's skill as current, and no skill at the load point as unrecognized

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:14a7607203db
  Scenario: a tool's skill is loaded for a task that calls for the tool
    Given an agent in a fresh context with the skills of the twelve tools at its load point and no other source on any of them, and a task that calls for running one of the eleven
    When the agent begins the task
    Then that tool's skill is loaded for the task before any invocation of the tool, and the agent's invocation is the one the skill states, not a bare one

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:8a5b9a35a86a
  Scenario: an agent completes a use of a tool on the first invocation the skill states
    Given an agent in a fresh context with one of the eleven tools' skill its only source on that tool, and a task calling for one of the uses the skill states
    When the agent performs the task
    Then the agent's first invocation of the tool is the one the skill states for that use, with no read of the tool's source or help and no second attempt, and the use completes with the return the skill states

  @bounded-context:shopsystem-product @feature:feat-tool-skills-rest @hash:572bb00db7d9
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
| A tool from another shop unusable without its source | the framing ("a tool from another shop could not be used at all without its source"; "a tool from any shop is usable the moment it answers") | Scenario: a tool that cannot answer has a description beside it in the same shape — the description in the same shape, and constraint (7) for where it is written from: what the tool shows whoever runs it, never its source; Scenario: the skill of a tool that cannot answer is produced from the description beside it; Scenario: a tool that begins to answer is used through its answer, not the description beside it — the moment it answers |
| A tool that cannot answer | the framing's outcome ("a tool that cannot answer has a description beside it in the same shape"); the initiative's Appetite (first no-go: "the external six by descriptions beside them until their owners answer") | Scenario: a tool that cannot answer has a description beside it in the same shape; Scenario: the skill of a tool that cannot answer is produced from the description beside it; Scenario: a tool that cannot answer is recorded as a gap against its owner |
| A description beside a tool not in the same shape — a use entry missing a part | the framing's outcome ("in the same shape"; the four parts); the architect's fourth risk (the initiative's Document History v3: the descriptions are hand-written) | Scenario: a description beside a tool that is not in the answer's shape yields no skill; Scenario: each use entry in a produced skill is complete — a skill that stands carries every part |
| A skill that states a use without what it returns or how it fails | the framing's outcome (the four parts); the architect's third risk (v3) | Scenario: each use entry in a produced skill is complete; Scenario: a compiler the shop owns answers the standard question — the answer carries the four parts per use |
| A use the answer or the description states that the skill omits | the framing's outcome ("for each use it supports" — every use, not some) | Scenario: a compiler's skill is produced from the compiler's own answer and Scenario: the skill of a tool that cannot answer is produced from the description beside it — "states every use"; Scenario: a tool skill not current with the description beside its tool is reported — a skill missing a use is not what a fresh production yields |
| A change to what a tool says about itself that does not reach its skill | the framing's outcome ("a change to what a tool says about itself reaches its skill") | Scenario: a change to what a compiler says about itself reaches its skill; Scenario: a change to the description beside a tool reaches its skill; Scenario: a tool skill not current with the description beside its tool is reported. For a tool that answers, the report is already specified in the repository — feat-tool-skills' *a tool skill not current with its tool's answer is reported* reads of any tool that answers — and is not specified twice here |
| A tool skill changed by hand | the framing's outcome's boundary (a skill changed other than through what its tool says about itself) | Scenario: a tool skill not current with the description beside its tool is reported — "whatever the cause"; Scenario: a change to the description beside a tool reaches its skill and Scenario: a change to what a compiler says about itself reaches its skill — the skill that stands afterwards is produced from what the tool says about itself, not from the edit |
| A description that depends on anything but the tool's own answer — a description written from the tool's source, or a compiler's skill written from anything but its answer | the initiative's Appetite (second no-go: "the tool answers, its source stays its own") | Scenario: a compiler's skill is produced from the compiler's own answer — "from nothing else"; Scenario: a tool that cannot answer has a description beside it in the same shape — the shape; constraint (7) for the rule on the description's writer — from what the tool shows whoever runs it, never from its source — a rule on the maker, not a behavior, accepted as the row's cover; the description is the framed stand-in, kept until the tool answers, and no other source is in scope |
| A description beside a tool that drifts from what the tool now does, with no answer to check it against | the architect's fourth risk (v3: "drift there is unreached by this bet's check — inside the no-go, named for the second feature") | Out of scope of a check: no check can read a tool that does not answer, and the framing's remedy is the owner's answer, which Scenario: a tool that cannot answer is recorded as a gap against its owner asks for. Found in use by Scenario: an agent completes a use of a tool on the first invocation the skill states and Scenario: a failure the agent meets is one the skill names, read as the skill states it — a use that does not complete as the skill states, or a failure the skill does not name, is the drift observed, and its repair is a change to the description, which Scenario: a change to the description beside a tool reaches its skill carries to the skill |
| A description beside a tool that has begun to answer — two homes for what the tool says about itself | the framing's outcome ("usable the moment it answers"); the Appetite ("until their owners answer") | Scenario: a tool that begins to answer is used through its answer, not the description beside it — no description stands as a source once the tool answers |
| The producer of tool skills, itself a framework tool that must answer | the initiative's Document History v11 ("the producer of tool skills … is itself a framework tool that must answer"); the architect's second risk (v3) | Scenario: the producer of tool skills produces its own skill from its own answer; Scenario: a compiler the shop owns answers the standard question, read once per compiler, the producer among the five |
| A compiler answering the standard question by rendering, by exiting on an error, or by reading the question as a file | the initiative's Feasibility and usability section and the roles' offers (Document History v3 and v5: three tools mislead a caller who asks for help; one exits on a traceback, one reads the flag as a file path) | Scenario: a compiler the shop owns answers the standard question — "performs none of its uses in answering, so that nothing is rendered and no file changes"; a traceback or a rendering is not an answer and the Then is unmet |
| Whether the compilers' help also answers as help | the designer's fourth risk (the initiative's Document History v5); the initiative's Document History v11 ("Open scope call kept: whether `--help` also answers as help") | Out of scope: the framed outcome is a skill an agent uses without reading the tool's help; what the help says serves no framed outcome here. The scope call stands open with the PM role, as feat-tool-skills recorded it; not decided here |
| The measure — 1 of 12 to 6 of 12 | the For whom section ("Measure: framework tools usable through a skill produced from the tool's own answer"); the Document History v11 (1 of 12); the PM role's ruling at the check (the measure counts skills produced from the tool's own answer) | Scenario: a compiler's skill is produced from the compiler's own answer, read once per compiler — the five that join the lint in the count; Scenario: the check over the load point passes clean with every tool's skill in place — the twelve standing and current, read together; Scenario: an agent completes a use of a tool on the first invocation the skill states, read once per tool for at least one use it states, and Scenario: a failure the agent meets is one the skill names, read as the skill states it, read at least once over the eleven — "usable" read from those observations, not from a skill standing. The six external tools are usable through a skill produced from the description beside each and are not counted until their owners answer; the count itself is the PM role's to read |
| A use of an external tool the freeze bars running — a message sent, a dispatch made | the shop's operating rules (the primer: no dispatches, no mailbox work while frozen); the designer's first risk (v5: "usable" is a usability claim, a hypothesis until measured task completion) | Out of scope of the run: a use the freeze bars is not run in the proof, so for that tool "usable" is read from Scenario: an agent completes a use of a tool on the first invocation the skill states on a use the freeze allows, or stands as a hypothesis the delivery says so, until the freeze lifts — which of the two, per tool, is the PM role's to read with the measure. The skill stands regardless, by Scenario: the skill of a tool that cannot answer is produced from the description beside it |
| The owner of an external tool the lead shop cannot name | the framing's "the shops whose tools the product accepts"; the vocabulary's owner of a tool | Scenario: a tool that cannot answer has a description beside it in the same shape — the description names the owner, and the Then is unmet while it cannot. Proposed default, for the PM role: the description names the owner as the shop the tool's provenance names, and where none can be named it says so and the lead shop holds the gap as its own until an owner is found |
| The gap reaching its owner while the shop is frozen | the decision the bet rests on (its Document History v1, third candidate: how the gap for a tool that cannot answer is recorded to its owner while the shop is frozen); the primer's freeze | Out of scope: the record of the gap is Scenario: a tool that cannot answer is recorded as a gap against its owner's; its reaching the owner is the freeze's and the router's, the PM role's to route after the freeze — no scenario sends anything |
| Two tools answering, or described, under the same name | the framing's "every framework tool … usable through a skill" — each its own; the same shape's rule that a tool's name is unique among the product's tools | Scenario: the check over the load point passes clean with every tool's skill in place — two tools under one name leave one without a skill of its own, and the Then is unmet |
| The check over the load point rejecting a tool skill, or the approved processes' skills checked otherwise than before | feat-skills-availability's scenarios over the load point (the feature repository, read in full); the initiative's Feasibility and usability section (the load-point risk) | Scenario: the check over the load point passes clean with every tool's skill in place — the Given holds the approved processes' skills beside the twelve; "every approved process's skill as current" is what feat-skills-availability's clean pass specifies, unchanged |
| "Usable" met as a hypothesis until measured task completion | the initiative's Feasibility and usability section; the designer's first risk (v5) | Scenario: an agent completes a use of a tool on the first invocation the skill states; Scenario: a failure the agent meets is one the skill names, read as the skill states it — until observed for a tool, the delivery says "hypothesis" for that tool |
| The agent's first invocation not the one the skill states — a read of the tool's source, its help, its answer, or the description beside it, or a second attempt | the designer's criteria ((a), the initiative's Document History v5; this feature's Contributors section, v2) | Scenario: an agent completes a use of a tool on the first invocation the skill states |
| A failure the agent meets that the skill does not name | the designer's criteria ((b), v5) | Scenario: a failure the agent meets is one the skill names, read as the skill states it; Scenario: each use entry in a produced skill is complete |
| The agent proceeding to a bare invocation with the skill present — twelve tool skills beside the process skills at one load point | the designer's criteria ((c), v5) and third risk (a skill not offered for the task) | Scenario: a tool's skill is loaded for a task that calls for the tool — the Given holds all twelve, so the right one is loaded among them |
| A description beside a tool written by a person in a machine shape — a document interaction with no pattern | the designer's fifth risk (v5: "in the second feature, noted for it"); recorded by the designer's criteria (this feature's Contributors section, v2) | Recorded: not a document interaction — the file is what a person gives the product in the data type's published shape, and the product meets its writer through the producer's command line; no core task carries it and no pattern is wanted for the file. The writer's side is Scenario: a description beside a tool that is not in the answer's shape yields no skill, under criterion (d); Scenario: a tool that cannot answer has a description beside it in the same shape states what the description carries, not how it is written |
| The delivered skills screened as interfaces; the tools' names entered in the vocabulary | the designer's attachment (v5: the conformance screen at delivery; R2, the vocabulary's tool terms) | Out of scope of the scenarios: a delivery gate the designer's check judges and a corpus entry the designer makes, not a behavior of this feature |
| Another tool's skill loaded for the task in place of the one the task calls for — twelve tool skills at one load point, each offered on its description | the designer's criteria ((c), this feature's Contributors section, v2) | Scenario: a tool's skill is loaded for a task that calls for the tool — "that tool's skill is loaded"; the remedy is the producer's composed description, not a scenario |
| A report of a lack the description's writer cannot act on — a traceback, a parser's message, or a schema path in place of the part; the part named but not the tool | the designer's criteria ((d), v2); `errors-guide-recovery` | Scenario: a description beside a tool that is not in the answer's shape yields no skill — "naming the tool and the part"; Scenario: the producer of tool skills produces its own skill from its own answer — the failure the writer meets is one the producer's skill names |
| A gap record its owner cannot act on — the tool and its owner named, what answering takes absent | the designer's criteria ((e), v2) | Scenario: a tool that cannot answer is recorded as a gap against its owner — its Then's clause is the what-happened; the one action is criterion (e)'s, observed when a gap reaches an owner after the freeze (the row on the gap's reaching stands) |
| A use of an external tool that a shop definition or a skill at the load point names, which the description beside the tool omits | the designer's criteria ((a) and (c), v2); the framing's "for each use it supports" | Scenario: a tool's skill is loaded for a task that calls for the tool — the Then's "the invocation is the one the skill states, not a bare one" is unmet when the skill states none for the use; Scenario: the skill of a tool that cannot answer is produced from the description beside it reaches only what the description states. Ruled at the check, the designer's default accepted: a description states at least every use of the tool a shop definition or a load-point skill names and every use the shop runs by hand; a use outside that is described when a task first calls for it, never run bare — the vocabulary's entry for a description beside a tool carries it |
| The compilers' answers and the producer's report as command-line interactions — their WCAG2ICT applicability record | the designer's criteria (this feature's Contributors section, v2; `accessible-by-standard` bullet 2) | Out of scope of the scenarios: the record for the `cli` type is written once at the delivery screen — pending since feat-tool-skills — and reads of every answer and report of the same form; no scenario names an output's form |
| A description lacking one of the two fields the shape reserves for it — which tool it stands beside, which shop owns that tool | constraint (2); the tool-description data type (v2) | Scenario: a description beside a tool that is not in the answer's shape yields no skill — a description lacking either is not in the shape; Scenario: a tool that cannot answer has a description beside it in the same shape — the Then names both |
| A description-sourced skill at the load point before the check recognizes the third source kind — reported as a tool that gave no answer today | constraint (4); skill-rendering v8's check step; the process-definition typedef v7's commitment | Scenario: the check over the load point passes clean with every tool's skill in place — the Then unmet until the definition amends; the amendment is the process owner's, in the order (4) fixes, not a scenario |
| A description standing for a tool that has begun to answer, which the check never asks — the second home unfound | constraint (4); the decision the bet rests on (§3, fourth consequence) | Scenario: a tool that begins to answer is used through its answer, not the description beside it — met only when the check asks the tool each description stands beside, every run |
| The gap closed by any means but the answer — closed by hand, closed on a change to the description, or closed on a skill written around the tool | constraint (8); the working principle `tools-through-skills` | Scenario: a tool that cannot answer is recorded as a gap against its owner — "until it does"; Scenario: a tool that begins to answer is used through its answer, not the description beside it — the one closing event |
| The form of the gap record — a request, a work item, or both — while the shop is frozen | constraint (8); the glossary's definition of gap ("records as a request rather than works around"); the precedent of gaps recorded as work items (lead-ki66p) | Scenario: a tool that cannot answer is recorded as a gap against its owner — the Then names what the record carries, not its form. Ruled at the check, the architect's default accepted: one request record per tool under the request lane, addressed to the owning shop, held and not routed while the shop is frozen, naming the tool, its owner, the standard flag, and the data type; no work item unless the lane asks one — constraint (8) carries it |
| A tool that performs a use when asked the standard question — the check's asking, every run, under the freeze | constraint (9); the primer's freeze; the decision the bet rests on (§2, the flag's behaviour) | Out of scope of a scenario: observed 2026-09-07, none of the six does — each rejects the flag as unknown or as a missing command, exit 1 or 2, no use performed; a tool that does is a finding to the solutions architect role, its asking suspended for that tool until its owner answers, and the flag rule binds the owner once it does |
| A promise in a description read as owed by the tool's owner — the description taken for a contract | constraint (7); the decision the bet rests on (its bound on Bounded Context shops) | Out of scope: no contract exists on this branch, and the description is the lead shop's own record about another shop's tool; the relationship kind while the tool does not answer is conformist, the record's published language and open host service once it answers — carried into the record's history at the delivery by the solutions architect role, a resulting action, not a scenario |
| A dependency, a vendor, or a recurring cost added by a compiler's answer or by producing from a description | constraint (5); the decision the bet rests on (the JSON bound) | Out of scope of a scenario: the record's delivery read by the solutions architect role; on the pre-state, the producer's reading of the contract's schema block through PyYAML is the shop's existing stack, imported by every tool under the tools directory — nothing added; the cost threshold is unset, so any addition escalates to the authority before it is made |
| Descriptions outnumbering answering tools after this feature — the record's last review trigger | the decision the bet rests on (§4, its fifth trigger); constraint (7) | Out of scope of a scenario: at this feature's delivery six descriptions stand beside six answering tools (the lint and the five compilers) — equal, the trigger not fired; read by the solutions architect role at the delivery, the count itself the PM role's |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Authored by the PO role alone in the feature-authoring draft step, from init-tool-skills's Framing and For whom sections (v11, active), its Appetite's first no-go as the scope — "the other eleven — the five compilers the shop owns answering the standard question; the six external tools (bd, shop-msg, shop-knowledge, agent-vault, bc-emit, shop-templates) by descriptions beside them in the same shape until their owners answer" — authorized by the authority's standing direction ("If it passes then proceed to the rest without asking me") on the proof's pass, recorded in the initiative's Document History v11; the decision the bet rests on, adr-2026-09-07-tool-answer (checked), read for what must hold and named in no scenario; sixteen scenarios, all owned by the lead shop per the initiative's Decomposition; interaction types none per its For whom; every scenario `@hash:pending` — the authoring session had no shell, so the lead-pm fills the values (sha256 of the scenario's text, first twelve hex digits, as in the repository's other features) before the check. The feature repository read in full: six features; feat-tool-skills (v8, assigned, delivered) specifies the proof on the lint and its general scenarios — *a tool skill not current with its tool's answer is reported* reads of any tool that answers and is not specified again here, cited in the Edges row on a change not reaching its skill; its Contributors vocabulary is referenced, not copied; feat-skills-availability's check over the load point carried in the Given of *the check over the load point passes clean with every tool's skill in place* and in an Edges row; the other four name no framework tool, answer, or skill. Maker's self-check against the feature fitness set (v8), each scenario read as Given/When/Then: scenario 1 (one observable behavior) pass — each When is one action or event (a compiler asked; a skill produced; a description written; the process run; the check run; the agent beginning or performing a task; an invocation failing), each Then observable in the running system (an answer given and nothing rendered; a skill standing at the load point naming its source; a description standing; no skill and a report; a gap recorded; parts present; a report naming the tool; a first invocation and its result; a failure and the agent's statement), and no step names a flag, a file path, a format, a tool by its program name, or a compiler by its program name — the five compilers and the six external tools are named by program name in the Contributors vocabulary and the Edges table only; scenario 2 (ownership and criteria) pass — an owning shop named for each of the sixteen; no interaction type named, so the designer's criteria are not due at this step, and the Contributors section says what the designer's and the architect's steps record; scenario 3 (identity tags) pass on presence — `@feature:feat-tool-skills-rest` and `@hash:pending` on every scenario, the values disclosed as pending; scenario 4 (edges) pass — twenty-seven rows: every case the framing's Problem and outcome, the For whom section and its measure, the Appetite's two no-gos, the Feasibility and usability section's risks and hypothesis, the Decomposition, the Document History v11's scope and open scope call, the designer's criteria (a)–(c), the architect's second, third, and fourth risks, and the repository's touch-point name is present, twenty covered by scenario name, and seven out of scope or out of scope of a check with reasons (the help's behavior; the drift of a description with no answer to check against; a use the freeze bars; the gap's reaching its owner while frozen; the description as a document interaction; the delivery screen and the vocabulary), one of them with a proposed default for the PM role (the owner that cannot be named); scenario 5 (interaction types) pass — "none" with the For whom section's reason, and the designer's fifth risk noted for that role's step; scenario 6 (narrative) pass — who (every agent of the shop that runs a tool, and the shops whose tools the product accepts), what (use each of the other eleven framework tools through a skill stating the four parts, produced from the answer or from a description beside a tool that cannot answer), the outcome the framing's ("every framework tool is usable through a skill produced from the tool's own answer … a tool that cannot answer has a description beside it in the same shape … a change to what a tool says about itself reaches its skill"). Scope declined or held, with the reason in the Edges table: the help's behavior — the open scope call stays with the PM role; sending the gap to its owner while the shop is frozen — the freeze's, no scenario sends. One question out to the PM role with its default, in the Edges table: the owner of an external tool the lead shop cannot name. Status draft pending the PO output check. |
| 2 | 2026-09-07 | update | The product designer role's criteria added in feature-authoring's add-usability step, from the step's declared inputs (the feature v1, the initiative v12, the experience principle set v2, the core-task list v4) and this role's own corpus (the vocabulary v6 and patterns v4 records; the common, api, cli, and document guidelines v3; the tool-description data type v2 for the beside-description's home and fields; the feature typedef v12 and fitness set v8 for the check's shape; feat-tool-skills v8 for the precedent — its criteria (a)–(c), the passages moved to its history at v4, and the check's rulings at v5). Verdict recorded in the Contributors section: no usability and no accessibility criteria due — the For whom section's "none" holds against the core-task list, and that section answers parity, not whether an interface is delivered; stated regardless under `agent-is-a-user` bullet 1, four interfaces being delivered: the skills (`api`), the compilers' answers and the producer's report (`cli`), the gap record as another shop reads it (`document`). The fifth risk of this role's attachment (the initiative's v5) resolved: the description beside a tool is not a `document` interaction — the document guideline covers what the product sends (reports, receipts, notifications), and the description is what a person gives the product, in the data type's published shape; the product meets its writer at the producer's command line, so the writer's interaction is `cli` and its criterion is (d), the error pattern (common rule 3; cli rule 4) applied to the producer's report; no core task carries it — a core task is one a person or agent completes wherever the product is reached, and the description is written in one place, the shop's tree; and no pattern is entered for the file, since its shape is the data type's and a second home for it would fail `single-source-of-truth`. Criteria (a)–(c) placed on the scenarios by name as at feat-tool-skills, read of any of the eleven, each with what this feature adds: (a) read once per tool, a use the freeze bars replaced by one it allows or labeled hypothesis for that tool; the read of the answer or the description beside the tool added to what invalidates, the vocabulary's "its only source on a tool" meaning nothing else about the tool (the architect's constraint (6) at feat-tool-skills read the same); (b) read at least once on a tool whose skill was produced from a description, since the failures such a skill names are the shop's words and a failure it does not name is the description's drift — the architect's fourth risk — observed in use, which is the only place it can be; (c) another tool's skill loaded in place of the right one added to what invalidates, twelve tool skills now standing at one load point. Two criteria of this feature's own: (d) the lack report for a description's writer, under `errors-guide-recovery` and api rule 3, tied to the producer's own skill (the producer answers, so its failures are named for its callers, the writer among them); (e) the gap record as its owner reads it, under the document guideline's rules 1 and 2 (the first line states the event; one primary action), a hypothesis whose observation the freeze defers. Not made criteria, as ruled at feat-tool-skills v4 and v5: the api guideline's retry clause; nothing only an agent can do (api rule 4), a delivery-screen read — every use of the eleven is a command a person runs at the prompt; names for the caller (api rule 1), judged at delivery by the agent's use under (a) and (b) — with one difference recorded for the screen: in a description beside a tool the use names and input descriptions are the lead shop's writing, not the tool owner's, so a finding on them goes to the lead shop as writer, not to the solutions architect role. Accessibility: none due, with the reasons in the body; the WCAG2ICT applicability record for the `cli` type is not yet in the tree (searched 2026-09-07: only the guidelines, the roles, and the deferrals at the initiative, feat-tool-skills, and its guidance name it), so the body says it is written once at the delivery screen, not that it exists. Five Edges rows added and one amended — the row deferring the document-interaction question to this step now records the answer — thirty-two rows in all; one carries a proposed default for the PM role: what "for each use it supports" means for a description beside a tool with many uses, the work register above all — the default: at least every use a shop definition or a load-point skill names and every use the shop runs by hand, the rest described when a task first calls for it and never run bare. Resulting action of this role's own, outside this step's writes: a `document` pattern for a gap notice to another shop is absent from the patterns record (v4), so the delivery screen of the gap record would return "undecidable: record lacks the entry" — entered as a hypothesis before that screen, with the document guideline's rules 1 and 2 as its shape. No scenario text changed; the gherkin block untouched; the Interaction types section untouched — its "the For whom section's answer stands until it does" now points at a recorded answer that leaves "none" standing. Maker's self-check against the feature fitness set (v8), the scenarios that concern this part: scenario 2 (ownership and criteria) pass — no type named, so the designer's criteria are not required, and the section records none due with its reason; the five stated regardless each name the scenario they ride on; every scenario's owning shop unchanged; scenario 4 (edges) pass — every case the criteria name is in the table: (a), (b), (c), and the hypothesis label in the rows the draft carried; the wrong skill, the lack report, the gap record, the omitted use, and the applicability record in the five new rows, three covered by Scenario name, one covered with a proposed default, one out of scope with its reason; the amended row covered by Scenario name; scenario 5 (interaction types) pass — "none" unchanged, the For whom reason the framing bears out (a skill read by an agent inside a process step), and the Contributors text says why the four interfaces screened do not change that answer; scenario 1 re-read on the new and amended rows only — none names a scenario step, so no implementation detail enters the block; scenario 3 unaffected, every hash filled by the lead-pm before this step. The lint could not be run from this session (no shell); its mechanical checks applied by hand — frontmatter `version` 2, Document History the last section, no link added, no banned term, no numbered-decision reference. |
| 3 | 2026-09-07 | update | The solutions architect role's constraints added in feature-authoring's add-constraints step, from the step's declared inputs (the feature v2; the decomposition — init-tool-skills' Decomposition section, v12) and this role's own records (adr-2026-09-07-tool-answer v3, checked, the guardrail; the tool-description data type v2, approved, the contract it names; feat-tool-skills v8's constraints (1)–(6) and guidance/feat-tool-skills-shopsystem-product.md v1, the precedent; the architecture principle set v6; the vocabulary v6's beside-description entry; the glossary's `gap`; the feature typedef v12, guideline v8, and fitness set v8 for the check's shape). Pre-state read from lead-shop-held records and by running the tools, none from a context's internals: the feature repository in full — seven features, no conflict, one touch-point (feat-skills-availability's check over the load point); the tools observed on the flag 2026-09-07 — none of the five compilers answers (compile_principles a traceback, compile_process the flag as a file path, compile_role, compile_tool, and compile_typedef a usage sheet; exit 1, 1, 2, 1, 2), none of the six external tools answers and each rejects the flag without performing a use (bd and agent-vault "unknown flag", exit 1; shop-msg, bc-emit, shop-templates "required: command", exit 2; shop-knowledge "unknown subcommand", exit 2); the producer reads no description beside a tool and stamps a skill's `source` with the tool's path; skill-rendering v8's check asks only `basis/tools/*.py` and reads any load-point skill sourced under `basis/tools/` as `no-answer` when no fresh production of its name exists; `basis/tools/descriptions/` does not exist; every tool under `basis/tools` imports PyYAML. Verdict recorded in the Contributors section: contract bound none and cross-context flow none, with the Decomposition's reason — no Bounded Context, no contract on this branch, none of the six tools' owners relied on by contract; one guardrail binds, the checked record, its stand-in part, fourth consequence, and bound on Bounded Context shops now reaching the six as its §2 reached the lint; nine constraints placed on the scenarios by name — (1)–(6) the first feature's read of any of the eleven, each with what this feature adds (the producer under (1) with no special case and the answer/non-answer line deciding when a tool has begun to answer; the description an instance of the same data type under (2), its two reserved fields part of the shape; the file as source, the digest over its bytes, and the description as the place of repair under (3); three source kinds, the check asking the tool each description stands beside, and the order of the amendment under (4); PyYAML read as the shop's existing stack under (5); the description excluded from the fresh context under (6)) — and three of this feature's own: (7) a description is the lead shop's record, not the owner's contract, the relationship kind conformist until the tool answers; (8) the gap's life is the description's, closed on the answer alone; (9) asking is the check's only invocation of an external tool, a tool that performs a use when asked a finding with its asking suspended. Enabler recommended: none new — the check's third source kind is the process owner's amendment already raised at skill-rendering v8, landing inside the delivery in (4)'s order. The nine screened against the architecture principle set (v6), recorded here and not in the body as the first feature's check ruled: `knowable-shape` (2), (7) — the description is the tool's description sufficient without its source, written from what the tool shows, the owner's answer replacing it; `contracts-between-contexts` (2), (7), (8) — the data type the named, versioned contract for a tool that answers; for one that does not, the description is a recorded reliance of the consuming shop's own and the gap is the contract-change request the principle's implication names, never a silent workaround — conforms as the record's §2.1 screened it, the six being other shops' operational tools and no Bounded Context existing on this branch; `actor-neutral-discipline` (6), (7) — the invocation binds whoever performs the step, the description written and gated under the same rule whoever writes it; `local-comprehension` (3), (6), (7) — the skill for use, the description for producing, the tool's help and behaviour observed only to write the description and never its source; `bidirectional-conformance` (3), (4), (8) — forward, every one of the twelve has a skill or a recorded gap; reverse, a description standing for an answering tool is a finding resolved by retiring it, a hand-edited skill re-produced, a gap closed only on the answer; `intent-provenance` — the record and this step each recorded, resting on the standing exception the record cites (work item lead-4kymc), no new one. No constraint a design cannot satisfy; nothing to escalate; no vendor and no recurring cost; the record's fifth review trigger read — six descriptions beside six answering tools at delivery, equal, not fired. One ask, with its default in the Edges table, for the PM role: the form of the gap record while the shop is frozen — default a request under the request lane, one per tool, held and not routed. One resulting action of this role's own, outside this step's writes: the record's fourth consequence is silent on the relationship kind while a tool does not answer; carried into adr-2026-09-07-tool-answer's history at the delivery. Nine Edges rows added, forty-one in all; the existing rows on the producer, on two tools under one name, on drift, on the hand edit, and on the load-point rejection left standing and now bound by (1), (2), (3), and (4). No scenario text changed — the gherkin block byte-identical to v2 (sha256 053f35810eae… before and after); the Interaction types section untouched. Maker's self-check against the feature fitness set (v8), the scenarios that concern this part: scenario 2 (ownership and criteria) pass — the Contributors section says the decomposition names no Bounded Context and a guardrail names constraints, nine are present, each naming the scenarios it rides on; the contract bound and the flow read none with the Decomposition's reason; every scenario's owning shop unchanged; scenario 4 (edges) pass — every case the nine constraints name is in the table: the missing reserved fields, the unrecognized third kind, the second home unfound, the gap wrongly closed, and the gap's form covered by Scenario name (the last with a proposed default), the tool that performs a use when asked, the description taken for a contract, the dependency read, and the review trigger out of scope with reasons; scenario 1 re-read on the addition only — the constraints and rows sit outside the gherkin block; the flag's name, the data type's path and field names, the tools' program names, the descriptions' home, and PyYAML are named in Contributors and Edges alone, none in a step; scenarios 3, 5, and 6 unaffected. The lint run on the tree after the edit: `PASS: 0 violation(s)`, exit 0; no banned term in the feature. Not committed: the lead-pm commits. |
| 3 | 2026-09-07 | review | PO output check, the one screen (judge: claude-fable-5-1 / screen prompt v6): nine findings — the vocabulary's "the tool's source" carrying two meanings (uncovered, confident); the Interaction types section deferring to a step that had run (criterion 5, confident); the Contributors section's length and the pre-state, principle, and verdict reasoning in the body (uncovered, confident); the description scenario's Then stating how the file was written (criterion 1); whether the gap scenario is framed (framing, wobbly); the measure's target (framing, wobbly); the first-invocation Edges row's case (criterion 4, wobbly); the referenced terms arriving without a gloss (uncovered, wobbly); the clean-pass Then's "as before" (criterion 1, wobbly) — each ruled by the PM role, with the two contributors' asks (the form of the gap record; what "for each use it supports" means for a description) decided on their defaults. |
| 4 | 2026-09-07 | update | The one revise, by the PO role, on the nine findings as ruled and the two asks as decided. (1) The answer-or-description meaning given its own term, **what the tool says about itself**, in the vocabulary, in the Given of *the check over the load point passes clean with every tool's skill in place*, and in the "current with" reading; "the tool's source" now means the program's source everywhere, the vocabulary saying so; the two Edges rows on the hand edit re-worded to the new term. (2) The Interaction types section states the recorded answer: the description is not an interaction type, the gap record is a request record the lead shop holds, "none" stands. (3) The Contributors section cut to the ownership list, the vocabulary, the provenance, and each criterion and constraint as ride-on plus met/invalidated or what must hold; the rest moved here with its substance — the designer's and architect's passages edited on the PM role's ruling, as at feat-tool-skills v4: *the designer's interface reasoning* — four interfaces delivered and screened under `agent-is-a-user` whether or not a type is named: each tool's skill (`api`, the tool-skill use entry pattern); each compiler's answer to the standard question (`cli`, the self-description on request pattern); the producer's report on a description not in the answer's shape (`cli`, the error pattern — the one interaction here a person meets, as the description's writer); the gap record as the owning shop reads it (the designer's `document`; ruled at the check a request record the lead shop holds, so criterion (e) reads of that record once routed). The description beside a tool is not itself an interaction type: it is what a person gives the product, in the shape the tool-description data type publishes, and the product meets its writer through the producer, so no core task carries it, no pattern is wanted for the file, and the writer's criteria are (d). Under (c), the twelve tool skills stand beside the process skills at one load point, each offered on its `description`, and the remedy for a wrong or absent load is the producer's composed `description`. Under (d), whoever writes a description runs the producer over it with the producer's skill as their source, and the stable code is from the data type's closed set. Under (e), where the shape is published is the tool-description data type. *The designer's accessibility reasoning* — by `accessible-by-standard`, the skill is an agent-facing interface governed by `agent-is-a-user` (bullet 2's parenthetical), so no WCAG target applies; the compilers' answers and the producer's report are `cli` interactions of the same form as the lint's answer — text on standard output or standard error, no meaning resting on colour (cli rule 1) — whose WCAG2ICT applicability record is written once for the type at the delivery screen and reads of all of them; the description is a file its writer edits in their own editor, no rendering of the product's; the gap record's accessibility is that of the record it is kept in — the designer wrote the work register's, and the ruling on its form makes it the request lane's; no criterion names an output's form. *The designer's delivery-screen routing* — until (a) is observed on each tool and (b) once over the eleven, "usable" is a hypothesis per tool and the delivery says so; the skills (`api`), the answers and the report (`cli`), and the gap record are screened at delivery under the interaction-conformance-check process, with the lint's skill and answer whose screen stands pending from feat-tool-skills — findings to the solutions architect role, findings on a description's names to the lead shop as its writer, undecidables to the corpus. *The architect's pre-state* — read from lead-shop-held records, none from a context's internals: the feature repository in full, seven features, the five assigned before init-tool-skills naming no framework tool, answer, skill, or description, feat-tool-skills carrying the general scenario over a tool that answers and constraints (1)–(6), the one touch-point feat-skills-availability's check over the load point, no conflict; the decision records holding no contract; the tools observed by running each on the flag, not by reading any — none of the five compilers answers today (a traceback, the flag read as a file path, three usage sheets; exit 1, 1, 2, 1, 2, the producer among the three), none of the six external tools does, each rejecting the flag as unknown or as a missing command without performing a use (exit 1 or 2); the tool-description data type approved (v2), so the enabler bound the first feature's constraint (2) set now holds; the producer reads no description yet; skill-rendering v8's check asks only the tools under the tools directory, reads a skill sourced anywhere under it as `no-answer` when no fresh production of that name exists, and asks the six nothing — so a description-sourced skill placed before the recognition lands is a standing finding, and the order of the amendment is the process-definition typedef v7's commitment, the producer reading a description before the definition naming that use is approved. *The architect's guardrail reasoning* — the record's §2 fixes what counts as an answer, the shape, the contract artifact, the digest gate, the stand-in description, and the JSON bound; its §3 fourth consequence and its bound on Bounded Context shops fix what a description is and what a tool that does not answer owes; (7)–(9) are each a sentence of the stand-in part, the fourth consequence, or the bound. Under (1), "cannot answer" is every compiler's reply today. Under (5), read on the pre-state, the producer reads the contract's schema block through PyYAML, which every tool under the tools directory already imports — the shop's stack, nothing added. Under (7), writing a description from what the tool shows whoever runs it is the shop reasoning from an entity's observable shape at its own level (`knowable-shape`), not a read below it; the record's fourth consequence is silent on the interim relationship kind, and this role carries it into the record's history at the delivery — a resulting action outside the step's writes. Under (9), a tool that answers performs nothing when asked (the record's flag rule), and each of the six, observed today, rejects the flag without performing a use. (4) The description scenario's Then ends at "the shop that owns that tool"; the writing rule stays in constraint (7), and the Edges rows on the second no-go and on a tool from another shop cite the scenario for the shape and constraint (7) for the source rule — a rule on the maker, accepted as a row's cover. (5) The gap scenario in scope by the ruling — the stand-in part of the decision the bet rests on, presupposed by "until their owners answer" — its trigger aligned to constraint (8): the Given a tool that does not answer, the When the description written beside it; the form of the gap record on the architect's default, accepted: one request record per tool under the request lane, addressed to the owning shop, held and not routed while frozen, naming the tool, its owner, the standard flag, and the data type, no work item unless the lane asks one — written into constraint (8) and the Edges row, the provenance paragraph saying the ruling. (6) The measure stated as ruled: 6 of 12 after this feature, the lint and the five compilers; the six external tools usable through a skill produced from the description beside each and not counted until their owners answer — the vocabulary and the measure's Edges row, which now also cites the produced-skill scenario read once per compiler. (7) The first-invocation Edges row's case extended to a read of the answer or the description. (8) Each referenced term given one clause in the vocabulary, the definitions staying feat-tool-skills'. (9) The clean-pass Then reads "every approved process's skill as current"; its Edges row follows. The designer's ask on "for each use it supports", decided on its default: carried in the vocabulary's entry for a description beside a tool and the Edges row on the omitted use. Three scenarios changed and rehashed, each `@hash:pending` for the lead-pm to fill: *a tool that cannot answer has a description beside it in the same shape*; *a tool that cannot answer is recorded as a gap against its owner*; *the check over the load point passes clean with every tool's skill in place*. The narrative, the other thirteen scenarios, and the forty-one Edges rows' cases are unchanged; no ask returned — every repair had its ruling. Maker's self-check against the feature fitness set (v8) after the revise: scenario 1 pass — the three changed scenarios each keep one action in the When (a description written; the check run) and an outcome observable in the running system in the Then (a description standing with its parts and its two names; a gap recorded; the check's report), and the clause on how the description was written is gone from the block; scenario 2 pass — ownership unchanged for all sixteen; the designer's (a)–(e) and the architect's (1)–(9) present, each riding by name with what meets or invalidates it or what must hold; scenario 3 pass on presence — `@feature:` on all sixteen, `@hash:` on all sixteen, three pending; scenario 4 pass — forty-one rows, every case still sourced to the framing or a contributor's criteria, the eight edited rows each covered by Scenario name, by a constraint where the ruling accepts one for a rule on the maker, or out of scope with its reason, the two proposed defaults now recorded as ruled; scenario 5 pass — "none" with the For whom section's reason and the recorded answer; scenario 6 pass — the narrative untouched. The lint could not be run from this session (no shell); its mechanical checks applied by hand — frontmatter `version` 4, Document History the last section, no link added, no banned term, no numbered-decision reference. Not committed: the lead-pm commits. |
| 5 | 2026-09-07 | state | `draft` → `checked`: the PM role's pass after the one screen and the one revise the process allows. Every finding with a named criterion is repaired in v4, read at the places the review's quotes point to: the Interaction types section states the designer's recorded answer; the description scenario's Then ends at the observable shape, the writing rule constraint (7)'s; the first-invocation Edges row names the answer and the description; the clean-pass Then reads "as current". The PM role's rulings on the framing findings, given with the review and applied: the gap scenario is in scope — the bound of the decision the bet rests on and how an owner comes to answer — its trigger the description's writing, its form one request record per tool held while frozen (the architect's default); the measure reads 6 of 12 after this feature, the six external tools usable through description-produced skills and not counted until their owners answer. The three uncovered findings ruled repaired in the same revise, none needing a criterion: one term for what the tool says about itself, the tool's source meaning the program's source; the Contributors section cut to what a shop reads to build, the reasoning in this history (the rule itself is req-2026-09-07-contributors-body's, routed to the lane); one clause per referenced term. The designer's ask on a description's uses: default accepted. The three hashes filled by the lead-pm after the revise (@hash:802c8401fbc7, @hash:5441feae9b88, @hash:1177727e510a). |
| 7 | 2026-09-07 | update | Delivery by the lead shop as the owning context, under guidance/feat-tool-skills-rest-shopsystem-product.md (v1), in its order. Made: the five compilers answer `--describe` — basis/tools/compile_principles.py (one use, `render`), compile_process.py (`compile`, `compile-skill`), compile_role.py (`validate`, `render`, `check`), compile_typedef.py (`produce`, `check`), compile_tool.py (`ask`, `produce`) — each answer written to standard output with exit 0 before any other action, other arguments ignored, and each compiler's failures now one line on standard error carrying a code from the data type's closed set (compile_typedef's inside its `will-not-compile` row on standard output, the row its process reads), arguments strict, so the failures each answer names are the failures the tool gives; compile_tool.py reads its second source, a description at basis/tools/descriptions/<name>.json — the same schema block, the same validation, `stands_beside` and `tool_owner` required of that kind, the file's stem its `name`, a path outside the home refused — and produces the skill from the file's bytes, `source` the file, `source-digest` over its bytes, `stands-beside` and `tool-owner` beside them; a lack is reported `unparseable: <file>: the description beside `<tool>` is not in the answer's shape: uses[<i>] lacks `<field>` (<part>)` with the next step in the producer's own skill; a tool named by a bare command is found on PATH and asked with the flag alone. Six descriptions written from what each tool shows whoever runs it — its help and its behaviour when run, its source not read: bd (create, comment, close, dolt-push), shop-msg (send, consume), shop-knowledge (validate, schema), agent-vault (run), bc-emit (work-done), shop-templates (list, show). Six gap requests recorded, requests/req-2026-09-07-<tool>-answer.md, status recorded, route awaiting, originator this role, arose-in this feature, the owning shop the addressee in the body, held and not routed under the freeze. skill-rendering v9: the third source kind (`descriptions` in Data; the check's description loop — `description-missing`, `description-diverged`, `description-invalid`, `tool-answers`; the load-point scan's `no-description`; a skill sourced from a command the check asks read by the tool kind; reconcile's re-production, repair-in-the-description, and retirement with the closing event written to the gap request), its skill re-rendered; basis/README.md v14. Observed in the running tree, 2026-09-07: each of the five asked with the flag and another argument beside it — exit 0, parses against the data type, nothing rendered, the tree unchanged (@hash:c648ef04449d, read five times); each compiler's skill produced from its answer and placed, the producer's by the same invocation on itself (@hash:6f6f93180b23, @hash:f20a781be781); each description's skill produced and placed (@hash:f3c767a50e31, read six times); a scratch description lacking `returns` on one use, one lacking `tool_owner`, one not JSON — no skill, the report naming the tool and the part (@hash:a7657325c775); the check step of skill-rendering v9 run as written under bash over 22 approved definitions, six answering tools, and six descriptions — no row (@hash:1177727e510a); a compiler's answer changed by one word — `tool-diverged basis/tools/compile_principles.py`, re-produced, the skill stating the new words, the change reverted and re-produced to digest 55a98386214d (@hash:d6d0e85cf003); a description changed — `description-diverged basis/tools/descriptions/shop-templates.json`, re-produced, the skill stating the new words, reverted and re-produced to 66641bd47172 (@hash:f87375439754); a description-sourced skill hand-edited — `description-diverged basis/tools/descriptions/shop-knowledge.json`, naming the tool by the file's stem, overwritten by re-production (@hash:8dfa9ca5923e); a scratch tool on PATH with a description beside it that began to answer — `tool-answers scratch-answers basis/tools/descriptions/scratch-answers.json`, the skill produced from the answer (`source: scratch-answers`), the description removed, the next check clean, the scratch tool and skill then removed (@hash:62f7ccb607b9); the gap for each of the six recorded when its description was written (@hash:5441feae9b88), the Then met for the four whose owner the tool's provenance names — shop-msg (shopsystem-messaging, the installed distribution's metadata), shop-knowledge (shopsystem-knowledge, the same), bc-emit and shop-templates (shopsystem-templates, the distribution carrying both entry points and naming its repository) — and reported unmet for bd and agent-vault, whose provenance as shown (`bd version 1.1.0`, `agent-vault 0.32.0`, their help) names no shop: the description and the request say so and the lead shop holds those two gaps as its own, the Edges row's default, the PM role's to rule; @hash:802c8401fbc7 likewise met for four and unmet for bd and agent-vault on the owner clause. Every use entry of the eleven skills carries what it does, what it takes with each input and its omitted treatment, what it returns, how it fails with a stable code beside condition and next step, and the exact invocation (@hash:4d3e67a4f717, read over all eleven). The proof (the designer's (a)–(c); constraint (6)): nine agents in fresh contexts, each forbidden every file, the tools' help and flag, and the load point's files, each loading the tool's skill through the Skill tool before its first command, each first invocation the one the skill states, no second attempt — compile-principles `render` (basis/principles.md to scratch: `rendered 10 principles (digest 3c4576a133a4)`, exit 0); compile-process `compile-skill` (work-conversation to a scratch skill, both lines, exit 0, the definition's bytes unchanged); compile-role `check` (six `ok` rows, exit 0) and `validate` on a missing path (`unreadable`, exit 2, read from the skill with its next step); compile-typedef `check` on implementation-guidance (no rows, exit 0, read as both texts current); compile-tool `ask` on the lint (`answers as lint-basis`, digest c523a32fcb0f, exit 0) and on a missing tool (`unreadable`, exit 2, read from the skill); bd `comment` on lead-176ti (the proof item this role opened and closed to observe the register's returns; `✓ Comment added`, exit 0) and `close` on a missing id (`unreadable`, exit 1, read from the skill — the failure on a description-produced skill the designer's (b) asks for); shop-knowledge `validate` on sess-2026-09-05-d (`conforming`, exit 0) and on basis/README.md (`check-failed`, exit 1, the four findings, read from the skill); agent-vault `run` (`echo proof` under a session: the two proxy lines, `proof`, exit 0); shop-templates `list` (the five names, exit 0), `show lead-architect` (the text; the agent's pipeline exit not captured, its shell lacking PIPESTATUS — the use observed complete by its output alone), `show nonexistent` (`unreadable`, exit 1, read from the skill). So @hash:14a7607203db, @hash:8a5b9a35a86a, and @hash:572bb00db7d9 stand observed on nine of the eleven; shop-msg and bc-emit stand as hypothesis — every use of each the freeze bars, none run — for the PM role to read with the measure. Deviations from the guidance, each with its reason: shop-msg's `vehicle-for` is not described — the tool rejects it as an invalid choice, and the only place a definition names it is scenario-assignment's Document History v2, an invented use repaired at v3; bd's `dolt` use is named `dolt-push` with invocation `bd dolt push`, the one `bd dolt` subcommand a definition runs (session-handoff's land step); the check recognizes a load-point skill whose `source:` is a bare command as the tool kind, since a tool of another shop that has begun to answer has its skill's source outside the tools directory and the guidance's three kinds would otherwise leave it `unrecognized`; the compilers' failure codes required each compiler's exit paths to change, not only a handler added — the lint's precedent (v7 of feat-tool-skills). Drift found between definitions and tools, not repaired here (the description follows the tool): scenario-assignment's dispatch step invokes `shop-msg send --bc <ctx> --type assign_scenarios --feature ... --tag ...`, while the tool takes `shop-msg send assign_scenarios --bc --work-id ...`; reconcile-and-close's consume-close step omits `--message-type`, which the tool requires. One proof item in the work register, lead-176ti, closed. Lint on the tree: PASS: 0 violation(s). Not committed: the lead-pm commits. |
| 6 | 2026-09-07 | state | `checked` → `assigned`: the scenario-assignment process (v12) record step, by the lead-solutions-architect role. Assignment — one context, shopsystem-product (the lead shop): the decomposition (init-tool-skills v13, Decomposition: none — every change in the lead shop's tree, no contract, no cross-context flow) and the Contributors section agree on all sixteen, and no scenario asks another shop to act (a tool's owner answering is a Given in @hash:62f7ccb607b9, not a behavior); scenarios @hash:c648ef04449d, @hash:6f6f93180b23, @hash:f20a781be781, @hash:802c8401fbc7, @hash:a7657325c775, @hash:f3c767a50e31, @hash:5441feae9b88, @hash:4d3e67a4f717, @hash:d6d0e85cf003, @hash:f87375439754, @hash:8dfa9ca5923e, @hash:62f7ccb607b9, @hash:1177727e510a, @hash:14a7607203db, @hash:8a5b9a35a86a, @hash:572bb00db7d9, each tagged @bounded-context:shopsystem-product on the line above its Scenario, no hash changed. Pre-state read: contracts — none exist on this branch; the tool-description data type (v2, approved) the shape every answer and description is read against; the feature repository in full — seven features, no conflict; touch-points feat-tool-skills (v8) @hash:5d004d52d1b4 (reads of any tool that answers, not specified again here) and @hash:d33276bcc8ba (the clean pass with the lint's skill, included in @hash:1177727e510a's Given), feat-skills-availability (v8) @hash:4899d4bba6ad and @hash:26f78a3ca4a6 (the load-point check, extended by one source kind and otherwise unchanged), feat-request-routing (v8) @hash:eec1236a2a09 and @hash:57f41d5f9f17 (the form the gap records take: an ask arising inside a run, recorded, awaiting its route); the tools observed on the flag alone 2026-09-07, not read — the lint answers, the five compilers cannot (a traceback, the flag read as a path, three usage sheets; exit 1, 1, 2, 1, 2), the six external tools reject the flag without performing a use (exit 1 or 2); basis/tools/descriptions/ absent; skill-rendering v8 reading two source kinds. Unowned: none. Ask: none — the one open question, an owner the lead shop cannot name (the Edges row, the PM role's to rule), is a datum of the delivery and not whether a behavior is in the product; the guidance names the default that stands and what to report. Implementation guidance written: guidance/feat-tool-skills-rest-shopsystem-product.md (v1, status written, not sent); maker's evaluation against the implementation-guidance fitness set (v1) — scenario 1 pass: each of the eight items in What changes names a lead-shop tool by path, a definition by id and version, a process step, a record's home, or the guardrail's section, none a context's internals; scenario 2 pass: scenarios by hash, the guardrail and definitions by id, version, and section, no scenario text, constraint text, or schema field list reproduced; scenario 3 pass: every tool and definition to change named with path or version, the producing and re-render invocations given, the descriptions' home, the gap records' form, and the minimum uses per external tool fixed, the order and its reason fixed, the one choice left to another owner and the one open datum each given what stands; scenario 4 pass: each of the sixteen entries in What not to do carries its reason in the guardrail, a constraint, a principle, a typedef's commitment, a no-go, the freeze, or the decomposition; scenario 5 pass: frontmatter and opening paragraph name the initiative, feature, context, and the sixteen hashes, and item 8 names what is outside this assignment rather than binding a later one. Sent: none — the dispatch step is barred under the freeze, no Bounded Context existing on this branch to receive (work item lead-ki66p); the lead shop's own scenarios stand assigned to itself and are taken up in its tree, as the previous assignments recorded. |
| 8 | 2026-09-07 | review | Verified by the lead-pm in the running tree after the delivery, each by running: the six tools under basis/tools answer `--describe` with exit 0; the six descriptions stand at basis/tools/descriptions/; the six external tools asked with the flag alone reject it without performing a use (exit 1 or 2); a fresh production of every one of the twelve to a scratch load point is byte-equal to the skill at .claude/skills/ (12 equal, 0 differing); the skill-rendering check step (v9) run as written under bash returns no finding over 22 process skills and 12 tool skills (34 at the load point); the roles' check and a fresh principles rendering report every other rendering current; `python3 basis/tools/lint_basis.py` and `--process basis/processes/skill-rendering.md` both `PASS: 0 violation(s)`; the harness lists the twelve tool skills beside the process skills in this session. The proof runs (v7) read as recorded: nine fresh-context agents, each loading the skill first and invoking as the skill states, 9 of 11 tools observed; shop-msg and bc-emit stand as hypothesis, every described use being one the freeze bars — the designer's criterion (a) foresaw this reading. The implementer's six defaults ruled by the PM role: (1) a use the tool rejects is not described — stands; (2) `dolt-push` as the use's name — stands; (3) a skill whose source is a bare command read by the tool kind — stands as the maker's how under constraint (4); (4) the drift between two process definitions' invocations of shop-msg and the tool's own — not repaired here, recorded as req-2026-09-07-messaging-invocations for the lane; (5) the gap request's closing escalated to the lead-pm, the typedef naming the status writers — stands; (6) the compilers' failure paths made to give the failures their answers name — stands, the lint's precedent. The owner that provenance cannot name (bd, agent-vault): the Edges default stands — the description and the request say so and the lead shop holds those two gaps as its own. Status stays assigned: what the reconcile-and-close process reads when the work returns. |
