---
type: feature
id: feat-request-routing
name: Request routing and the small-change lane
status: draft
version: 2
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
  route — into a discovery conversation, to a simple change, or
  declined with the authority — and can take a simple change to a
  verified result without the stages that protect a bet,
  so that getting simple things done no longer requires the full
  product flow: every ask is recorded on arrival and has a decided
  route, and a simple change reaches a verified result without the
  stages that protect a bet.

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
Appetite calls the screen of record.

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
  the originator can do next; a reason is never a code, a bead id, or
  a route name alone. Rides on *a declined ask is settled with the
  authority and its record survives*.
- U7 — one vocabulary (`consistent-not-uniform`): the record is called
  a request and the routes are named as this feature names them — the
  same words at the door, on the request, in the awaiting list, and in
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
  the delivery; a delivery gate the interaction conformance check
  judges, not a scenario's behavior.

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
(`control-stays-with-the-person`). It is not the list's *answer an
ask* — that task is the glossary's `ask`, a question a run puts to a
role. Like every entry on the list it is a hypothesis with no
observed use; it enters the core-task list through the corpus's own
change, not this feature, and user research confirms or removes it.
This feature names only the conversational type; `core-task-parity`
makes the three options due on every other type the moment one offers
the task.

## Scenarios

```gherkin
Feature: Request routing and the small-change lane
  The product authority, and anyone bringing the lead shop an ask,
  can bring an ask and see it recorded on arrival with a decided
  route — into a discovery conversation, to a simple change, or
  declined with the authority — and can take a simple change to a
  verified result without the stages that protect a bet,
  so that getting simple things done no longer requires the full
  product flow: every ask is recorded on arrival and has a decided
  route, and a simple change reaches a verified result without the
  stages that protect a bet.

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

  @feature:feat-request-routing @hash:b0b3207a6f3f
  Scenario: a simple change is defined up front before it is made
    Given a request routed to the small-change lane
    When the lane takes up the request
    Then a definition of the change — what will be different when it is done — is recorded, references the request, and stands before any change is made

  @feature:feat-request-routing @hash:c04c2a23411c
  Scenario: a simple change is checked by a role other than its maker
    Given a simple change made against its recorded definition
    When the change is checked
    Then the verdict is recorded by a role other than the one that made the change, judged against the recorded definition

  @feature:feat-request-routing @hash:487be54ed71d
  Scenario: a simple change reaches a verified result with no bet and no check of record
    Given a simple change that has passed its check
    When the change is verified
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

  @feature:feat-request-routing @hash:53c0cfb8f900
  Scenario: the example change reaches a verified result through the lane
    Given a request recording the authority's ask that a decision brief say what it relates to, routed to the small-change lane
    When the lane takes the change to its result
    Then a decision brief made afterwards says what it relates to, that effect is demonstrated in the running system, and the request records the verified result with no bet taken and no check of record run
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| A simple change that can only get done through the full product flow | the framing ("a simple, functional change can only get done through the full product flow, whose stages protect a bet the change does not spend") | Scenario: a simple change reaches a verified result with no bet and no check of record — the framed remedy; Scenario: a simple change is defined up front before it is made and Scenario: a simple change is checked by a role other than its maker — what the lane keeps of the flow's discipline |
| An ask arising in conversation with no record until a discovery conversation opens for it | the framing ("an ask arising in conversation has no record until a discovery conversation opens for it") | Scenario: an ask arising in open conversation is recorded as a request; Scenario: an ask brought to the lead shop is recorded as a request on arrival |
| Open conversation that never becomes an ask | the framing's originator ("The router can use open-discussion with the user to evaluate whether a request is being made" — discovery record sess-2026-09-04-b, quoted from the Framing's originator) | Scenario: open conversation that makes no ask leaves no request |
| An ask arising inside another process | the framing's originator ("possibly extraneous requests that pop up in other processes, like backlog requests" — discovery record sess-2026-09-04-b) | Scenario: an ask arising inside another process is recorded as a request |
| A request with no route decided | the framing's outcome ("every ask is recorded on arrival and has a decided route") | Scenario: a request not yet routed is visible as awaiting its route; Scenario: a recorded request has a decided route |
| A request that turns out large — not a simple change | the framing ("a simple change"); the For whom section ("a simple functional change") | Scenario: a request whose change turns out not simple is routed to discovery |
| A decline | the framing ("declined with the authority"); the framing's originator ("rejection handled with the product authority") | Scenario: a declined ask is settled with the authority and its record survives |
| The route into discovery kept open, and the initiative made from a request reaching the request (the hinge) | the initiative's Appetite ("the route into discovery kept open"); the initiative's history v1 ("discovery accepts a request as its input and the initiative can reference it") | Scenario: a request routed into discovery is the discovery conversation's input; Scenario: the initiative made from a request references the request |
| The measure's instance — a decision brief that says what it relates to, 0 to 1 | the For whom section ("a decision brief that says what it relates to — reaches a verified result through a recorded, routed ask, the full flow untouched") | Scenario: the example change reaches a verified result through the lane |
| The bet and the check of record inside the small lane | the initiative's Appetite (no-go: "The bet and the screen of record: they protect an appetite a simple change does not spend") | Scenario: a simple change reaches a verified result with no bet and no check of record — the lane runs without them; the full flow keeps both, untouched |
| An ask pointed at the configuration of the shopsystem itself | the framing's originator ("All requests are for the product unless they are pointed at the configuration of the shopsystem itself" — discovery record sess-2026-09-04-b); the initiative's Appetite (no-go lead-1d0eo) | Recorded and routed like any ask — Scenario: an ask brought to the lead shop is recorded as a request on arrival; Scenario: a recorded request has a decided route. A configuration lane as a fourth route is out of scope: lead-1d0eo, "no new types this session" |
| Grooming every open work item | the initiative's Appetite (no-go lead-izfpk) | Out of scope: ordering, not doing — the backlog-ordering process's, not this feature's |
| Converting the work register's open items into durable records | the initiative's Appetite (no-go lead-vx02q) | Out of scope: work of its own; this feature records asks from their arrival onward, not the pileup before it |
| Refining the Framing with the authority | the initiative's Appetite (no-go lead-ghulb) | Out of scope: not needed to route; the initiative typedef's Framing rule is that bead's |
| A new artifact type for the received ask or the small change | the initiative's Appetite (no-go: "we are not working through any new types") | Out of scope: the request is the existing type; the lane's change is defined and verified without a type of its own |
| Intent received by a Bounded Context shop | the initiative's Decomposition ("no Bounded Context is touched") | Out of scope: this feature covers the lead shop's own front end; no Bounded Context exists on this branch |
| The router reads open conversation's words as an ask the originator did not make | the designer's criteria (U3, A4) | Scenario: open conversation that makes no ask leaves no request — the router says its reading before recording, and the originator's "no" leaves no request |
| The originator objects to the route the router says | the designer's criteria (U4) | Scenario: a recorded request has a decided route — the route is said before action; the route recorded is the one standing after the objection, its reason answering it; the decision stays the lead-pm role's |
| The originator does not answer the router — whether the words are an ask, whether the route stands | the designer's criteria (U3, U4, A2) | Scenario: open conversation that makes no ask leaves no request — no request from silence; Scenario: a request not yet routed is visible as awaiting its route — the request stays awaiting, no route taken on a timeout |
| An ask recorded mid-run, the person present unsure whether it was recorded or acted on | the designer's criteria (U5) | Scenario: an ask arising inside another process is recorded as a request — the record and the run's continuing are said in one turn |
| A decline said as a code, a bead id, or a route name with no reason or next step | the designer's criteria (U6, A4) | Scenario: a declined ask is settled with the authority and its record survives — the criterion binds the form of the Then's "ruling and the reason" |
| The originator asked to restate an ask the request already holds | the designer's criteria (U7, A5) | Scenario: a request routed into discovery is the discovery conversation's input; Scenario: a recorded request has a decided route |
| The door delivered without its WCAG2ICT applicability record or an accessibility result at target | the designer's criteria (A6) | Out of scope of the scenarios: a delivery gate, not a behavior — the interaction conformance check judges it under `accessible-by-standard`'s third bullet |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-04 | update | Authored by the PO role alone in the feature-authoring draft step, from init-request-routing's Framing and For whom sections, with the discovery record sess-2026-09-04-b for the originator's words; fourteen scenarios, all owned by the lead shop per the initiative's Decomposition; interaction type conversational per its For whom; scenario hashes as sha256 of the scenario's text (its Scenario line and steps), first twelve hex digits, as in feat-roles-availability — the authoring session had no shell, so the values are filled by a script run after the draft and before the check, disclosed in the draft's return. |
| 2 | 2026-09-04 | update | Designer's criteria added in the feature-authoring add-usability step: seven usability acceptance criteria (U1–U7) and six accessibility criteria (A1–A6) in Contributors, riding on the scenarios that touch the conversational door — recording an ask (directly, in open conversation, mid-run), the awaiting list, seeing the route and its reason, objecting to it, the route changed, the decline — judged against the experience principle set (`core-task-parity`, `control-stays-with-the-person`, `errors-guide-recovery`, `consistent-not-uniform`, `evidence-not-opinion`, `accessible-by-standard`) and the core-task list, which carries no entry for making a request; the "make a request" hypothesis the criteria stand on stated under Interaction types, matching the initiative's Feasibility and usability attachment of 2026-09-04; seven Edges rows added for the cases the criteria name — six covered by scenario name, one (the WCAG2ICT applicability record) out of scope as a delivery gate. The criteria are labeled hypotheses: no observed use. Scenario text, hashes, owning shops, and frontmatter unchanged. |
