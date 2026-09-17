---
type: feature
id: feat-request-routing
name: Request routing and the small-change lane
status: checked
version: 6
initiative: ../initiatives/init-request-routing.md
owner: lead-po
created: 2026-09-04
updated: 2026-09-04
---

# Feature: Request routing and the small-change lane

## Feature

Feature: Request routing and the small-change lane
  The product authority, and anyone bringing the lead shop an ask,
  can bring an ask and see it recorded on arrival with a decided
  route — into a discovery conversation, to a simple change (the
  small-change lane), or declined with the authority — and can take a
  simple change to a
  verified result without the stages that protect a bet,
  so that getting simple things done no longer requires the full
  product flow.

## Contributors

Owning shop, per scenario — from the initiative's Decomposition
section, which names no Bounded Context: every amended definition and
the example change sit in the lead shop's tree, and no contract exists
on this branch to rely on.

- *an ask brought to the lead shop is recorded as a request on arrival* — shopsystem-product (the lead shop)
- *an ask arising in open conversation is recorded as a request* — shopsystem-product (the lead shop)
- *open conversation that makes no ask leaves no request* — shopsystem-product (the lead shop)
- *an ask arising inside another process is recorded as a request* — shopsystem-product (the lead shop)
- *a request not yet routed is visible as awaiting its route* — shopsystem-product (the lead shop)
- *a recorded request has a decided route* — shopsystem-product (the lead shop)
- *an objection to the route is answered before the route is acted on* — shopsystem-product (the lead shop)
- *a route said but not answered is recorded as said and not acted on* — shopsystem-product (the lead shop)
- *a request routed into discovery is the discovery conversation's input* — shopsystem-product (the lead shop)
- *the initiative made from a request references the request* — shopsystem-product (the lead shop)
- *a simple change is defined up front before it is made* — shopsystem-product (the lead shop)
- *a simple change is checked by a role other than its maker* — shopsystem-product (the lead shop)
- *a simple change reaches a verified result with no bet and no check of record* — shopsystem-product (the lead shop)
- *a request whose change turns out not simple is routed to discovery* — shopsystem-product (the lead shop)
- *a declined ask is settled with the authority and its record survives* — shopsystem-product (the lead shop)
- *the example change reaches a verified result through the lane* — shopsystem-product (the lead shop)

Vocabulary: *ask* is the framing's word for one expression of intent
brought to the lead shop by an originator (glossary: `intent`,
`originator`); it is not the glossary's `ask` — the question one
activity puts to another role. *Request* is the artifact type of the
same name, the record an ask becomes on arrival. *The small-change
lane* is the initiative's name for the route a simple change takes;
*check of record* is the glossary's term for what the initiative's
Appetite calls the screen of record. A change is *simple* when it
spends no appetite worth a bet: it stays within the lead shop's own
definitions or one instance of them, touches no Bounded Context, and
its effect is demonstrable in the running system in one session; the
lead-pm role judges this at routing, and the lead-po role may find
otherwise once the change is defined, which changes the request's
route to a discovery conversation with the reason. In the lane, the
lead-po role defines a simple change — its definition is a
requirement; the role that makes the change is its *maker*; the check
sits with a role other than the maker. *The intake process* is the process in which an ask is
recorded as a request and routed — the router's process, distinct
from the lane and from the discovery conversation.

Usability acceptance criteria — due: the initiative's For whom section
names the conversational type. Judged against the experience principle
set and the core-task list; they stand on the "make a request"
hypothesis stated under Interaction types, and each says what must
hold for the originator — the product authority or anyone bringing an
ask — at the conversational door, not how the door is built. The door
is an assistant interaction (glossary): the product acts on a stated
intent, so `control-stays-with-the-person` binds it. The router is the
lead-pm role, as the scenarios name it. (designer, 2026-09-04)

- U1 — the task's three options hold at the door (`core-task-parity`):
  the originator states the ask in their own words and the request
  records those words, not a paraphrase; the originator is given the
  request's id in the same turn the record is confirmed, alongside the
  words and never in place of them; the originator can read the route
  and its reason from the door. Rides on *an ask brought to the lead
  shop is recorded as a request on arrival*, *an ask arising in open
  conversation is recorded as a request*, *a recorded request has a
  decided route*.
- U2 — the door says what it can do (`control-stays-with-the-person`,
  first bullet): the originator can learn from the door, without
  leaving it, that an ask is recorded on arrival and the three routes
  it can take — a discovery conversation, the small-change lane,
  declined — with what each means. Rides on *an ask brought to the
  lead shop is recorded as a request on arrival*, *a recorded request
  has a decided route*.
- U3 — the router's reading is said before it is recorded
  (`control-stays-with-the-person`, third and fourth bullets): when
  open conversation's words are read as an ask, the door says so
  before a request is recorded; the originator's "no" leaves no
  request; when the router cannot tell, it asks rather than records;
  silence is not a yes. Rides on *an ask arising in open conversation
  is recorded as a request*, *open conversation that makes no ask
  leaves no request*.
- U4 — the route is said before it is acted on
  (`control-stays-with-the-person`, second and third bullets): the
  originator hears the route and its reason before a discovery
  conversation opens on the request, the lane takes it up, or a
  decline is settled; an objection the originator makes then is heard
  before action, the route recorded is the one standing after it, and
  its reason answers the objection — the decision stays the lead-pm
  role's. A request stays visibly awaiting its route until the route
  is said; no route is taken because the originator did not answer. A
  route changed later is read with its reason the same way the first
  was. Rides on *a recorded request has a decided route*, *a request
  not yet routed is visible as awaiting its route*, *a request whose
  change turns out not simple is routed to discovery*.
- U5 — an ask arising mid-run neither derails the run nor vanishes:
  the person present hears, in one turn, that the ask was recorded
  with its id and that the run continues without acting on it. Rides
  on *an ask arising inside another process is recorded as a request*.
- U6 — the decline guides recovery (`errors-guide-recovery`): the
  decline is said in the originator's natural language — that the ask
  was declined, that the authority ruled, and the reason — with what
  the originator can do next; a reason is never a code, a work-item id, or
  a route name alone. Rides on *a declined ask is settled with the
  authority and its record survives*.
- U7 — one vocabulary (`consistent-not-uniform`): the record is called
  a request and the routes are named as this feature names them — the
  same words at the door, on the request, in the list of requests awaiting a route, and in
  the discovery conversation opened on the request; the originator is
  never asked to restate an ask the request already holds. Rides on
  *a request not yet routed is visible as awaiting its route*, *a
  recorded request has a decided route*, *a request routed into
  discovery is the discovery conversation's input*.

Evidence (`evidence-not-opinion`): these criteria and the hypothesis
they stand on rest on no observed use; the door's usability is a
hypothesis at delivery until a user test or measured task completion
is recorded. A usability test invalidates the scenarios U1, U4, and
U6 ride on when an originator, after the router's turn, cannot say
whether a request was recorded, which route was taken or how to
object to it, or what to do after a decline. (designer, 2026-09-04)

Accessibility criteria — the conversational door is a non-web
assistant interaction: `accessible-by-standard`'s second bullet
applies the WCAG 2.2 success criteria as WCAG2ICT describes for
non-web software, with an applicability record; its third bullet sets
conformance before delivery. (designer, 2026-09-04)

- A1 — meaning in words (SC 1.3.3 Sensory Characteristics and 1.4.1
  Use of Color, as applied): the record's confirmation, the id, the
  route, and the reason are conveyed in text; nothing the originator
  needs is carried by colour, symbol, position, or sound alone. Rides
  on *an ask brought to the lead shop is recorded as a request on
  arrival*, *an ask arising in open conversation is recorded as a
  request*, *a recorded request has a decided route*, *a declined ask
  is settled with the authority and its record survives*.
- A2 — no time limit on the originator's turn (SC 2.2.1 Timing
  Adjustable, as applied): the router's question — whether words are
  an ask, whether the route stands — waits for the originator; no
  request is recorded and no route acted on because a time ran out.
  Rides on *open conversation that makes no ask leaves no request*,
  *a request not yet routed is visible as awaiting its route*, *a
  recorded request has a decided route*.
- A3 — consistent identification (SC 3.2.4, as applied): the request,
  its id, and each route are named the same way every time the door
  says them and wherever the request is read. Rides on *a request not
  yet routed is visible as awaiting its route*, *a recorded request
  has a decided route*, *a request routed into discovery is the
  discovery conversation's input*, *a request whose change turns out
  not simple is routed to discovery*.
- A4 — errors identified with a way forward (SC 3.3.1 Error
  Identification and 3.3.3 Error Suggestion, as applied): a misread
  ask, a changed route, and a decline are described in text with what
  the originator can do. Rides on *open conversation that makes no ask
  leaves no request*, *a request whose change turns out not simple is
  routed to discovery*, *a declined ask is settled with the authority
  and its record survives*.
- A5 — no redundant entry (SC 3.3.7, as applied): an originator whose
  ask is recorded is not asked to state it again for it to be routed
  or for discovery to open on it — the request is read. Rides on *a
  recorded request has a decided route*, *a request routed into
  discovery is the discovery conversation's input*.
- A6 — the applicability record: before the door is delivered, the
  record of which WCAG 2.2 success criteria do not apply to the
  conversational type and why stands in the experience guidance
  corpus, and an accessibility result at the target is attached with
  the delivery; a delivery gate the check the experience guidance
  corpus defines for an interaction judges, not a scenario's behavior.

Non-functional constraints — due. The initiative's Decomposition
names no Bounded Context, so no cross-context constraint applies;
what it does name is a bound — every amended definition and the
example change sit in the lead shop's tree, and no contract exists on
this branch to rely on — and the architecture decision record the
initiative rests on,
[adr-2026-09-04-request-front-end](../decisions/adr-2026-09-04-request-front-end.md)
(checked, v4), sets the guardrails an implementation of these
scenarios must respect, under the working principle set every
session compiles in. Each constraint says what must hold, not how;
each rides on the scenarios it bounds. (architect, 2026-09-04)

- C1 — the request is the existing root type, amended (the ADR's
  declined third option; the initiative's no-go "we are not working
  through any new types"): the record an ask becomes is an instance
  of the `request` artifact type as its typedef stands amended to
  admit a received ask — the originator's words, the date it arrived,
  the route with its reason, and where the route led — and no new
  artifact type is introduced for the received ask, for the simple
  change's definition, or for its verified result. The amendment is
  made to the typedef, by its owner, with its Document History row,
  before any instance relies on what it admits. Rides on *an ask
  brought to the lead shop is recorded as a request on arrival*, *an
  ask arising in open conversation is recorded as a request*, *an ask
  arising inside another process is recorded as a request*, *a
  recorded request has a decided route*, *a declined ask is settled
  with the authority and its record survives*, *a simple change is
  defined up front before it is made*, *a simple change reaches a
  verified result with no bet and no check of record*.
- C2 — the request is the durable record, in the repository (the
  ADR's decision): a request stands as a governed artifact in this
  branch's tree from the moment it is recorded, declined asks
  included. A work-register item, a session record, or a transcript
  is not the record of an ask; an ask that exists only in one of
  these is not recorded, and "recorded" in every scenario's Then
  means this. Rides on *an ask brought to the lead shop is recorded
  as a request on arrival*, *an ask arising in open conversation is
  recorded as a request*, *an ask arising inside another process is
  recorded as a request*, *a request not yet routed is visible as
  awaiting its route*, *a declined ask is settled with the authority
  and its record survives*.
- C3 — the ask's words have one home (`single-source-of-truth`; the
  ADR's sixth consequence): the originator's words live on the
  request, and every other appearance — the list of requests awaiting a route, the
  discovery conversation's anchor, the initiative's Framing, the
  change's definition, a work item — references the request by its
  id or is rendered from it; a quotation carries the reference. Rides on
  *a request not yet routed is visible as awaiting its route*, *a
  request routed into discovery is the discovery conversation's
  input*, *the initiative made from a request references the
  request*, *a simple change is defined up front before it is made*,
  *the example change reaches a verified result through the lane*.
- C4 — a register item points at the request (the ADR's fourth
  consequence): a work item opened for a routed ask — the discovery
  conversation's, the lane's — points at its request by id, and what
  was asked, the route, and the result are read from the request,
  never from the item; losing the register loses no context about
  the ask. This constraint binds only items opened for routed asks.
  Rides on *a request
  routed into discovery is the discovery conversation's input*, *a
  simple change is defined up front before it is made*, *a simple
  change reaches a verified result with no bet and no check of
  record*, *the example change reaches a verified result through the
  lane*.
- C5 — recording is any lead-shop role's act, routing the lead-pm's
  (`actor-neutral-discipline`; the ADR's second and third
  consequences): the request is the same record whichever lead-shop
  role meets the ask and whoever fills that role — the authority in
  person, agent-assisted, or an agent; the route is recorded by the
  lead-pm role and by no other; a decline is recorded only with the
  authority's ruling. No recording, route, or decline attaches to an
  actor kind, and a role that meets an ask does not hold it for the
  lead-pm to record. Rides on *an ask brought to the lead shop is
  recorded as a request on arrival*, *an ask arising inside another
  process is recorded as a request*, *a request not yet routed is
  visible as awaiting its route*, *a recorded request has a decided
  route*, *a declined ask is settled with the authority and its
  record survives*.
- C6 — the lane keeps the discipline the working principles demand
  (`define-good-up-front`, `delivery-verified`,
  `no-orphan-activities`): the change's recorded definition is the
  stated definition of good that drives both the making and the
  check; the check sits with a role holding a different
  accountability from the maker's; the result counts done only when
  its effect is demonstrated in the running system — the definition
  existing, the check passing, or a review approving do not count on
  their own; and the lane is a defined process with stated expected
  outcomes, outputs, and resulting actions, its exit for a change
  found not simple declared. Rides on *a simple change is defined up
  front before it is made*, *a simple change is checked by a role
  other than its maker*, *a simple change reaches a verified result
  with no bet and no check of record*, *a request whose change turns
  out not simple is routed to discovery*, *the example change reaches
  a verified result through the lane*.
- C7 — no Bounded Context contract is touched (the Decomposition;
  `contracts-between-contexts`; the ADR's "Bound on Bounded Context
  shops: none"): every definition amended and every record produced
  for these scenarios sits in the lead shop's tree; no contract
  between contexts is created or amended, no message type to a
  Bounded Context shop is added, and a request's route reaches a shop
  only as scenario assignment sends work. A Bounded Context's intake
  stands under its own operational contract, outside this feature.
  Rides on every scenario.
- C8 — the example change goes through its typedef
  (`single-source-of-truth`; `bidirectional-conformance`): "a
  decision brief says what it relates to" is a change to the
  decision-brief typedef — its closed frontmatter set or its required
  sections — recorded in that typedef's Document History, and in its
  schema where the frontmatter changes, before any brief instance
  carries it; a brief that carries the field ahead of its typedef
  does not demonstrate the change. Rides on *the example change
  reaches a verified result through the lane*.
- C9 — nothing enters an agent's context untraced (`governed-context`,
  `least-context`): what the routing and the lane load into an
  agent's context — the request, the list of requests awaiting a route, the change's
  definition, a process prompt — traces to an approved definition or
  a governed record; a transcript is never loaded, and a discovery
  conversation opened on a request loads the request, not the
  conversation that produced it; the intake process's definition and
  the amended discovery conversation's name what each step loads and
  its source, and both reach the runtime only as renderings of their
  approved definitions. Rides on *an ask arising inside another
  process is recorded as a request*, *a request not yet routed is
  visible as awaiting its route*, *a recorded request has a decided
  route*, *a request routed into discovery is the discovery
  conversation's input*, *a simple change is defined up front before
  it is made*.
- C10 — the originator chain starts at the request, the exception
  carried (`intent-provenance`; the ADR's screen): every trace — the
  initiative's Framing, the change's definition, the verified
  result — reaches the request it came from, and a trace that
  dead-ends before a request is a recording defect; the request
  states the contract the ask entered through in the form the
  initiative uses — the lead shop's operational contract, which has
  no artifact yet (lead-4kymc) — until that artifact lands. The
  principle is not fully satisfied while the contract has no
  artifact; the exception is the ADR's and the authority's, restated
  here and not treated as satisfied. Rides on *an ask brought to the lead shop
  is recorded as a request on arrival*, *the initiative made from a
  request references the request*, *a simple change is defined up
  front before it is made*.

## Interaction types

Conversational — the initiative's For whom section ("Interaction
type: conversational"): an ask is brought in conversation, and the
route is decided and read there. The core-task list carries no entry
for making a request; the initiative's Feasibility and usability
section holds "make a request" as a core-task entry in hypothesis, the
product designer role's to settle.

The hypothesis the designer's criteria stand on, matching the
initiative's Feasibility and usability section (designer,
2026-09-04): *make a request* is a core-task entry holding on every
interaction type — an originator states an ask, and it is recorded
and routed — with three options every type offering it must present:
state the ask in the originator's words; see the request's id; see
its route (a discovery conversation, the small-change lane, declined)
and its reason. The conversational door is an assistant interaction
(glossary): the product acts on the stated intent, so the router says
the route before acting and the originator can correct it
(`control-stays-with-the-person`). Like every entry on the list it is
a hypothesis with no observed use; it enters the core-task list
through the corpus's own change, not this feature, and user research
confirms or removes it.

## Scenarios

```gherkin
Feature: Request routing and the small-change lane
  The product authority, and anyone bringing the lead shop an ask,
  can bring an ask and see it recorded on arrival with a decided
  route — into a discovery conversation, to a simple change (the
  small-change lane), or declined with the authority — and can take a
  simple change to a
  verified result without the stages that protect a bet,
  so that getting simple things done no longer requires the full
  product flow.

  @feature:feat-request-routing @hash:d25c1b573bff
  Scenario: an ask brought to the lead shop is recorded as a request on arrival
    Given an originator bringing the lead shop an ask
    When the originator states the ask
    Then a request records the ask in the originator's words and the date it arrived, and the originator can refer to the request by its id

  @feature:feat-request-routing @hash:5cd27711d5fe
  Scenario: an ask arising in open conversation is recorded as a request
    Given an open conversation between an originator and the lead shop, opened for no request
    When the originator's words amount to an ask
    Then a request records the ask in the originator's words, with no discovery conversation opened to make the record

  @feature:feat-request-routing @hash:f2d38c0020da
  Scenario: open conversation that makes no ask leaves no request
    Given an open conversation between an originator and the lead shop, opened for no request
    When the conversation ends with no ask made
    Then no request is recorded from the conversation

  @feature:feat-request-routing @hash:eec1236a2a09
  Scenario: an ask arising inside another process is recorded as a request
    Given a role running a process of the lead shop
    When an ask outside that process's scope arises during the run
    Then a request records the ask in the words it arose in, and the run continues without acting on the ask

  @feature:feat-request-routing @hash:57f41d5f9f17
  Scenario: a request not yet routed is visible as awaiting its route
    Given a request recorded from an ask and not yet routed
    When the lead-pm role asks which requests await a route
    Then that request is among them

  @feature:feat-request-routing @hash:9e019e058ee2
  Scenario: a recorded request has a decided route
    Given a request recorded from an ask and not yet routed
    When the lead-pm role routes the request
    Then the request records one route — into a discovery conversation, to the small-change lane, or declined — with the reason, and the originator can read the route and its reason from the request

  @feature:feat-request-routing @hash:1cb77cfffd40
  Scenario: an objection to the route is answered before the route is acted on
    Given a request recorded from an ask and its route said to the originator before any action on it
    When the originator objects to the route
    Then the route recorded is the one standing after the objection, with a reason that answers it, and no action on the earlier route was taken

  @feature:feat-request-routing @hash:f09ad469b17e
  Scenario: a route said but not answered is recorded as said and not acted on
    Given a request recorded from an ask and its route said to the originator
    When the request is read before the originator answers
    Then the request records the route as said, with its reason, and no action on it has been taken

  @feature:feat-request-routing @hash:f529feca1e32
  Scenario: a request routed into discovery is the discovery conversation's input
    Given a request routed into a discovery conversation
    When the discovery conversation opens for the request
    Then the conversation opens on the request, and what was asked is read from the request rather than restated

  @feature:feat-request-routing @hash:086df5ac784d
  Scenario: the initiative made from a request references the request
    Given a discovery conversation opened on a request
    When the conversation frames an initiative
    Then the initiative references the request it was made from, and the request records that initiative as where its route led

  @feature:feat-request-routing @hash:ca14b5a4169a
  Scenario: a simple change is defined up front before it is made
    Given a request routed to the small-change lane
    When the lane takes up the request
    Then a definition of the change, written by the lead-po role — what will be different when it is done — is recorded, references the request, and stands before any change is made

  @feature:feat-request-routing @hash:c04c2a23411c
  Scenario: a simple change is checked by a role other than its maker
    Given a simple change made against its recorded definition
    When the change is checked
    Then the verdict is recorded by a role other than the one that made the change, judged against the recorded definition

  @feature:feat-request-routing @hash:4b038539c9e9
  Scenario: a simple change reaches a verified result with no bet and no check of record
    Given a simple change that has passed its check
    When the lane records the change's result for the request
    Then its effect is demonstrated in the running system, the request records the verified result, and between the request and that result no bet was taken and no check of record was run

  @feature:feat-request-routing @hash:66cd94ec755c
  Scenario: a request whose change turns out not simple is routed to discovery
    Given a request routed to the small-change lane
    When the change, once defined, is found not to be a simple change
    Then the request's route is changed to a discovery conversation with the reason, and the lane makes no change for it

  @feature:feat-request-routing @hash:91af507a8128
  Scenario: a declined ask is settled with the authority and its record survives
    Given a request whose route is to be declined
    When the lead-pm role settles the decline with the product authority
    Then the request records the route as declined with the authority's ruling and the reason, and the request remains readable afterwards

  @feature:feat-request-routing @hash:9699594c6fac
  Scenario: the example change reaches a verified result through the lane
    Given a request recording the authority's ask that a decision brief say what it relates to, routed to the small-change lane
    When the lane records its result for the request
    Then a decision brief made afterwards says what it relates to, that effect is demonstrated in the running system, and the request records the verified result with no bet taken and no check of record run
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| A simple change that can only get done through the full product flow | the framing ("a simple, functional change can only get done through the full product flow, whose stages protect a bet the change does not spend") | Scenario: a simple change reaches a verified result with no bet and no check of record — the framed remedy; Scenario: a simple change is defined up front before it is made and Scenario: a simple change is checked by a role other than its maker — what the lane keeps of the flow's discipline |
| An ask arising in conversation with no record until a discovery conversation opens for it | the framing ("an ask arising in conversation has no record until a discovery conversation opens for it") | Scenario: an ask arising in open conversation is recorded as a request; Scenario: an ask brought to the lead shop is recorded as a request on arrival |
| Open conversation that never becomes an ask | the framing's outcome ("every ask is recorded on arrival and has a decided route" — its boundary: words that are no ask); the session record sess-2026-09-04-b as source of the authority's words, "The router can use open-discussion with the user to evaluate whether a request is being made" | Scenario: open conversation that makes no ask leaves no request |
| An ask arising inside another process | the framing's outcome ("every ask is recorded on arrival and has a decided route" — every ask, wherever it arises); the session record sess-2026-09-04-b as source of the authority's words, "possibly extraneous requests that pop up in other processes, like backlog requests" | Scenario: an ask arising inside another process is recorded as a request |
| A request with no route decided | the framing's outcome ("every ask is recorded on arrival and has a decided route") | Scenario: a request not yet routed is visible as awaiting its route; Scenario: a recorded request has a decided route |
| A request that turns out large — not a simple change | the framing ("a simple change"); the For whom section ("a simple functional change") | Scenario: a request whose change turns out not simple is routed to discovery |
| A decline | the framing's outcome ("every ask is recorded on arrival and has a decided route — into discovery, to a simple change, or declined with the authority") | Scenario: a declined ask is settled with the authority and its record survives |
| The route into discovery kept open, and the initiative made from a request reaching the request — the hinge: discovery accepts a request as its input, and the initiative made from it references the request | the initiative's Appetite ("the route into discovery kept open") | Scenario: a request routed into discovery is the discovery conversation's input; Scenario: the initiative made from a request references the request — the back-reference traces through the Appetite's "the route into discovery kept open" and the originator chain: from the initiative's Framing back to the request the ask was recorded as |
| The measure's instance — a decision brief that says what it relates to, 0 to 1 | the For whom section ("a decision brief that says what it relates to — reaches a verified result through a recorded, routed ask, the full flow untouched") | Scenario: the example change reaches a verified result through the lane |
| The bet and the check of record inside the small lane | the initiative's Appetite (no-go: "The bet and the screen of record: they protect an appetite a simple change does not spend") | Scenario: a simple change reaches a verified result with no bet and no check of record — the lane runs without them; the full flow keeps both, untouched |
| An ask pointed at the configuration of the shopsystem itself | the framing's outcome ("every ask is recorded on arrival and has a decided route" — every ask, this kind included); the initiative's Appetite (no-go lead-1d0eo); the session record sess-2026-09-04-b as source of the authority's words, "All requests are for the product unless they are pointed at the configuration of the shopsystem itself" | Recorded and routed like any ask — Scenario: an ask brought to the lead shop is recorded as a request on arrival; Scenario: a recorded request has a decided route. A configuration lane as a fourth route is out of scope: lead-1d0eo, "no new types this session" |
| Grooming every open work item | the initiative's Appetite (no-go lead-izfpk) | Out of scope: ordering, not doing — the backlog-ordering process's, not this feature's |
| Converting the work register's open items into durable records | the initiative's Appetite (no-go lead-vx02q) | Out of scope: work of its own; this feature records asks from their arrival onward, not the pileup before it |
| Refining the Framing with the authority | the initiative's Appetite (no-go lead-ghulb) | Out of scope: not needed to route; the initiative typedef's Framing rule is that work item's (lead-ghulb) |
| A new artifact type for the received ask or the small change | the initiative's Appetite (no-go: "we are not working through any new types") | Out of scope: the request is the existing type; the lane's change is defined and verified without a type of its own |
| Intent received by a Bounded Context shop | the initiative's Decomposition ("no Bounded Context is touched") | Out of scope: this feature covers the lead shop's own front end; no Bounded Context exists on this branch |
| The router reads open conversation's words as an ask the originator did not make | the designer's criteria (U3, A4) | Scenario: open conversation that makes no ask leaves no request — the router says its reading before recording, and the originator's "no" leaves no request |
| The originator objects to the route the router says | the designer's criteria (U4) | Scenario: an objection to the route is answered before the route is acted on (U3, U4, A2); Scenario: a recorded request has a decided route |
| The originator does not answer the router — whether the words are an ask, whether the route stands | the designer's criteria (U3, U4, A2) | Scenario: a route said but not answered is recorded as said and not acted on (U4, A2); Scenario: open conversation that makes no ask leaves no request (U3); Scenario: a request not yet routed is visible as awaiting its route |
| A route acted on before the originator hears it | the designer's criteria (U4) | Scenario: an objection to the route is answered before the route is acted on; Scenario: a route said but not answered is recorded as said and not acted on — both Givens hold the route as said to the originator before any action, so each Then is reachable only after the route was said; U4 binds the form |
| A paraphrase recorded instead of the originator's words | the designer's criteria (U1) | Scenario: an ask brought to the lead shop is recorded as a request on arrival; Scenario: an ask arising in open conversation is recorded as a request — the Then's "in the originator's words"; U1 binds the form: those words, not a paraphrase |
| The request's id given in place of the originator's words | the designer's criteria (U1) | Scenario: an ask brought to the lead shop is recorded as a request on arrival — the criterion binds the form of the Then: the id alongside the words, never in place of them |
| The routes unexplained at the door — what each of the three means | the designer's criteria (U2) | Scenario: an objection to the route is answered before the route is acted on; Scenario: a recorded request has a decided route — the criterion binds the form: the three routes and what each means, learnable at the door without leaving it |
| Meaning carried by colour, symbol, position, or sound alone | the designer's criteria (A1) | Scenario: an ask brought to the lead shop is recorded as a request on arrival; Scenario: a recorded request has a decided route; Scenario: a declined ask is settled with the authority and its record survives — the criterion binds the form of each Then: the confirmation, the id, the route, and the reason in text |
| The request or a route named differently in two places | the designer's criteria (A3, U7) | Scenario: a request not yet routed is visible as awaiting its route; Scenario: a recorded request has a decided route; Scenario: a request routed into discovery is the discovery conversation's input — the criterion binds the form: the same names at the door, on the request, in the list of requests awaiting a route, and in the discovery conversation |
| An ask recorded mid-run, the person present unsure whether it was recorded or acted on | the designer's criteria (U5) | Scenario: an ask arising inside another process is recorded as a request — the record and the run's continuing are said in one turn |
| A decline said as a code, a work-item id, or a route name with no reason or next step | the designer's criteria (U6, A4) | Scenario: a declined ask is settled with the authority and its record survives — the criterion binds the form of the Then's "ruling and the reason" |
| The originator asked to restate an ask the request already holds | the designer's criteria (U7, A5) | Scenario: a request routed into discovery is the discovery conversation's input; Scenario: a recorded request has a decided route |
| The door delivered without its WCAG2ICT applicability record or an accessibility result at target | the designer's criteria (A6) | Out of scope of the scenarios: a delivery gate, not a behavior — the check the experience guidance corpus defines for an interaction judges it under `accessible-by-standard`'s third bullet |
| A request instance recorded ahead of its typedef's amendment | the architect's constraints (C1) | Scenario: an ask brought to the lead shop is recorded as a request on arrival — C1 binds the form: the record is an instance of the `request` type as amended to admit a received ask, the amendment made before any instance relies on it |
| An ask that exists only in a work-register item, a session record, or a transcript | the architect's constraints (C2) | Scenario: an ask brought to the lead shop is recorded as a request on arrival; Scenario: an ask arising inside another process is recorded as a request — "recorded" means a request standing in the repository; an ask held only in one of these is unrecorded |
| The ask's words appearing somewhere — a Framing, a change's definition, a work item — with no reference to the request | the architect's constraints (C3, C4) | Scenario: the initiative made from a request references the request; Scenario: a simple change is defined up front before it is made — the definition references the request; the item opened for it points at it |
| A request recorded differently by which role met the ask, or held for the lead-pm to record | the architect's constraints (C5) | Scenario: an ask brought to the lead shop is recorded as a request on arrival; Scenario: an ask arising inside another process is recorded as a request — the same record whichever role meets the ask |
| A simple change counted done on its definition existing or its check passing, its effect undemonstrated | the architect's constraints (C6) | Scenario: a simple change reaches a verified result with no bet and no check of record — the effect demonstrated in the running system is the verified result |
| The change's definition and its check held by the same role | the architect's constraints (C6) | Scenario: a simple change is checked by a role other than its maker |
| A route that reaches a Bounded Context shop, or a contract amended for the front end | the architect's constraints (C7) | Out of scope: no Bounded Context exists on this branch, and a request's work reaches a shop only as scenario assignment sends it — the assignment process's, not this feature's |
| A decision brief carrying "what it relates to" ahead of its typedef | the architect's constraints (C8) | Scenario: the example change reaches a verified result through the lane — the effect demonstrated is the typedef's change carried by a brief made afterwards; an instance ahead of its typedef does not count |
| A discovery conversation opened on a request that loads the transcript it came from | the architect's constraints (C9) | Scenario: a request routed into discovery is the discovery conversation's input — the conversation opens on the request |
| The intake process or the amended discovery conversation reaching the runtime other than as a rendering of its approved definition | the architect's constraints (C9) | Out of scope of the scenarios: a delivery gate the skill-rendering process's check judges (feat-skills-availability), not a behavior of this feature |
| A trace — a Framing, a change's definition, a verified result — that dead-ends before a request | the architect's constraints (C10) | Scenario: the initiative made from a request references the request; Scenario: a simple change is defined up front before it is made — the definition references the request |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-04 | update | Authored by the PO role alone in the feature-authoring draft step, from init-request-routing's Framing and For whom sections, with the discovery record sess-2026-09-04-b for the originator's words; fourteen scenarios, all owned by the lead shop per the initiative's Decomposition; interaction type conversational per its For whom; scenario hashes as sha256 of the scenario's text (its Scenario line and steps), first twelve hex digits, as in feat-roles-availability — the authoring session had no shell, so the values are filled by a script run after the draft and before the check, disclosed in the draft's return. |
| 2 | 2026-09-04 | update | Designer's criteria added in the feature-authoring add-usability step: seven usability acceptance criteria (U1–U7) and six accessibility criteria (A1–A6) in Contributors, riding on the scenarios that touch the conversational door — recording an ask (directly, in open conversation, mid-run), the list of requests awaiting a route, seeing the route and its reason, objecting to it, the route changed, the decline — judged against the experience principle set (`core-task-parity`, `control-stays-with-the-person`, `errors-guide-recovery`, `consistent-not-uniform`, `evidence-not-opinion`, `accessible-by-standard`) and the core-task list, which carries no entry for making a request; the "make a request" hypothesis the criteria stand on stated under Interaction types, matching the initiative's Feasibility and usability attachment of 2026-09-04; seven Edges rows added for the cases the criteria name — six covered by scenario name, one (the WCAG2ICT applicability record) out of scope as a delivery gate. The criteria are labeled hypotheses: no observed use. Scenario text, hashes, owning shops, and frontmatter unchanged. |
| 3 | 2026-09-04 | update | Architect's constraints added in the feature-authoring add-constraints step: ten non-functional constraints (C1–C10) in Contributors, riding on the scenarios they bound — the decomposition names no Bounded Context, so no cross-context constraint; its ruling (every amended definition and the example change in the lead shop's tree, no contract to rely on) and the checked adr-2026-09-04-request-front-end (v4) the initiative rests on set the guardrails, under the working principle set: the request as the existing root type amended, not a new type; the request as the durable record in the repository; the ask's words in one home, referenced elsewhere; a register item pointing at the request; recording any lead-shop role's act and routing the lead-pm's; the lane's define-check-verify discipline; no Bounded Context contract touched; the example change through the decision-brief typedef; nothing loaded into an agent's context untraced; the originator chain starting at the request with `intent-provenance`'s exception carried, not absorbed. Ten Edges rows added for the cases the constraints name — eight covered by scenario name, two out of scope with reasons (a route reaching a Bounded Context; a rendering gate the skill-rendering check judges). Scenario text, hashes, the designer's criteria, owning shops, and the initiative unchanged. |
| 4 | 2026-09-04 | review | PO output check round 1 (judge: claude-fable-5-1 / screen prompt v6): one confident, seven wobbly. Confident — Edges row on the hinge cited the initiative's history v1 for words the row did not carry (re-sourced to the Appetite's "the route into discovery kept open" alone, the hinge glossed at that first use, the back-reference stated as tracing through the Appetite and the originator chain); the decline row's originator quotation carried "product" the history does not (dropped). Wobbly — the objection and no-answer cases were covered by criteria alone (new scenario *the route is said to the originator before it is acted on*, `@hash:pending` until filled, named in both rows; A2, U3, U4 kept as the criteria binding the form); cases U1, U2, A1, A3 name had no rows (five rows added, each covered by scenario name with the criterion binding the Then's form); the hinge row's back-reference (stated, no scenario text change); Interaction types duplicated the `ask` disambiguation the Vocabulary paragraph carries and closed on other types (both cut, the hypothesis kept); the two verification scenarios' When clauses (held — the judge read the criterion as satisfiable; text and hashes stand); uncovered terms ("the awaiting list" → "the list of requests awaiting a route" throughout, "bead id" → "work-item id", "the hinge" glossed) and the narrative's repeated capability clause inside the "so that" (cut, in the section and the block head; hashes unaffected). Other roles' passages edited on the PM role's ruling, substance unchanged: C3's Framing-candidate sentence and C4's register-candidate sentence cut to the scope clause; A6 and its Edges row gloss "the interaction conformance check" as "the check the experience guidance corpus defines for an interaction"; C10's "not absorbed" → "not treated as satisfied". Repaired. |
| 5 | 2026-09-04 | review | PO output check round 2 (judge: claude-fable-5-1 / screen prompt v6): one confident, five wobbly. Confident — *the route is said to the originator before it is acted on* carried two branches and "is heard" in one Then; split into *an objection to the route is answered before the route is acted on* and *no route is recorded while the originator has not answered*, each with the branch as its When and one observable Then (both `@hash:pending` until filled); the ownership list and the three Edges rows that named the old scenario updated. Wobbly, ruled by the PM role — the two verification scenarios' When restated so the demonstration is the outcome ("the lane records the change's result for the request"; "the lane records its result for the request"; new hashes); "simple change" defined in Vocabulary (spends no appetite worth a bet: within the lead shop's definitions or one instance, no Bounded Context, demonstrable in one session; judged by the lead-pm at routing, revisable by the lane's definer); "the intake process" defined in Vocabulary (where an ask is recorded and routed; the router's process, distinct from the lane and discovery); the three Edges rows sourced to "the framing's originator" via the discovery record re-sourced to the Framing's outcome sentence, the authority's words kept and labelled as the session record's, and the decline row sourced to the outcome sentence alone; the two split scenarios' rows state they are the designer's contribution (U3, U4, A2) serving the framed "decided route" outcome. Repaired. |
| 6 | 2026-09-04 | review | Round 3, the cap (judge: claude-fable-5-1 / screen prompt v6): two confident findings, both uncovered wording — "bead" surviving; "the lane's definer" unnamed — and eight wobbly: the no-answer scenario's When a state and its Then withholding the lead-pm's record; Vocabulary's "back to routing" against the not-simple scenario; the verification Whens (held); C1's case without an Edges row; the plain said-before-acted case without a row; the second route named two ways; the Covered-by cells overloaded. Post-cap repairs, disclosed and not re-screened: "that bead's" → "that work item's (lead-ghulb)"; Vocabulary names the lane's definer — the lead-po role defines a simple change (its definition is a requirement), the role that makes it is its maker, the check sits with a role other than the maker — and the Then of *a simple change is defined up front before it is made* now reads "a definition of the change, written by the lead-po role, …" (hash recomputed); Vocabulary's "sends the request back to routing" → "changes the request's route to a discovery conversation with the reason", the not-simple scenario standing; *no route is recorded while the originator has not answered* renamed *a route said but not answered is recorded as said and not acted on*, When "the request is read before the originator answers", Then "the request records the route as said, with its reason, and no action on it has been taken" (hash recomputed) — reconciled with *a recorded request has a decided route*: the lead-pm's decision is recorded, action waits on the originator per U4; the ownership list and the rows naming it updated; the verification scenarios' When clauses held as ruled in round 2, a fresh reader's stumble recorded; an Edges row added for a request instance recorded ahead of its typedef's amendment (C1 binding the form of scenario 1); an Edges row added for a route acted on before the originator hears it, covered by the objection and said-not-answered scenarios' Givens, U4 binding the form; the narrative names the second route "to a simple change (the small-change lane)" in the section and the block head (not hashed); the Covered-by cells for the objection and no-answer rows cut to scenario names and criterion ids. The two split scenarios are the designer's contribution (U3, U4, A2) serving the framing's decided-route outcome. |
| 6 | 2026-09-04 | state | `draft` → `checked`: the PM role's pass. Reasons: no finding in any round named a criterion the feature still fails; the cap's confident findings were wording no criterion names, repaired past the cap and disclosed; the one substantive question — whether the lead-pm's route is recorded before the originator answers — ruled: recorded as said, not acted on. The initiative moves to active on this pass, written by the check's record step. |
