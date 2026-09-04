---
type: adr
id: adr-2026-09-04-request-front-end
title: Intent reaching the lead shop is recorded as a request on arrival and routed from that record
status: checked
version: 5
date: 2026-09-04
decided-by: product-authority
right: escalation
owner: lead-solutions-architect
created: 2026-09-04
updated: 2026-09-04
---

# ADR: Intent reaching the lead shop is recorded as a request on arrival and routed from that record

## 1. Context

The lead shop takes intent — a desired outcome expressed by an
originator at the product's edge; the word
[init-request-routing](../initiatives/init-request-routing.md) uses
for one expression of it is an *ask* — from the product authority, in
conversation. On 2026-09-04 the only door was the
[discovery conversation](../basis/processes/discovery-conversation.md):
it opens on a `topic` string (its parameter), frames an initiative,
and hands it to the initiative check and the authority's bet —
"the only door is discovery, the only path the full flow"
(init-request-routing, For whom). Intent arriving any other way — a direction given in a
session, a wish surfacing while another process runs ("backlog
requests", in the authority's words) — had no record of its own. It
was filed as a work item in the work register (`bd`, the beads tracker,
whose database stands at `/workspace/.beads`, outside this branch's
tree; an item carries a title and a close reason — a discovery
conversation's item is titled with its `topic` string — and the
discovery conversation's own work item, lead-1kp6m, carries no
description), or it stayed in the transcript. The
[`request` typedef](../basis/artifacts/request.md) (v2) defined the
type as the root for documents the shop *emits* — "any process whose
output asks for action or decision", `reader` required — the decision
brief to the authority being its one specialization; nothing the shop
received was a request. The first durable home an originator's words
had was the initiative's Framing, written only once a discovery
conversation had opened for them
([sess-2026-09-04-b](../sessions/sess-2026-09-04-b.md)).

Forces bearing: `intent-provenance` — whoever accepts intent records
it at the contract where it entered before working on it, and the
lead shop's operational contract has no artifact on this branch
(lead-4kymc, the work item for the missing artifact); the register
pileup the authority named — "we have no
process for handling the pileup" — items that are asks with no durable
home. Working principles bearing:
`single-source-of-truth` — the originator's expression has one
authoritative home and every other appearance is a reference — and
`governed-context` — an agent works from a governed record, not a
transcript: the authority's "transition from transcript -> conversation
that has been missing"
([working principle set](../basis/principles.md)).

**The escalation that settled it.** The decision is the authority's,
so it records under `right: escalation`: none of the five rights the
solutions architect role holds — stack, guardrail, decomposition,
contract between Bounded Contexts, non-functional requirement — covers
where intent enters the lead shop and as what record. The fork reached
the authority as the lead-pm's options in the discovery conversation
for init-request-routing on 2026-09-04 (lead-1kp6m, brainstorm form,
recorded in sess-2026-09-04-b), and the authority ruled in its words:
"I want request to become the front-end record for anything done by
the system, since we don't have a good entry-point to go from
open-ended human input to something an agent can work with", and
"Lead-pm should handle routing and all requests should be recorded and
rejection handled with the product authority, since the lead-pm is an
extension of the human authority." The ruling entered the initiative's
Document History (v1) and stands under the bet (v3). This record is
authored after the bet and before any definition amends, on the
authority's direction of the same day that the architect produce the
record the initiative rests on. The ruling bundled four positions;
this record carries the first, and the candidates list below names
the other three.

Options that were real:

- **Keep the work register as the record of an ask** — the standing
  practice for anything not yet framed. Declined for the authority's
  reason: "beads is not intended to be a system of record beyond
  current work in motion. Losing beads should not result in losing
  context about the system other than what is currently being
  executed." A register item is no artifact of a defined type — no
  typedef, no fitness set, no Document History, nothing in this
  branch's tree — so under `governed-context` an agent may not work
  from it as a governed record.
- **Open a discovery conversation for every ask** — the existing door.
  Declined: discovery frames an initiative for a bet, and a trivial
  functional change "shouldn't require a lot of process"; the
  authority asked instead for a small-change lane, "a small-change
  lane that even includes features, however minor" — a path that
  takes a simple change to a verified result without a bet or a
  screen of record. A screen of record is the cold screen an
  initiative passes before the authority bets, the check of record on
  its framing. Declined also because the ask has no record until the
  conversation opens, the Framing quoting the originator only then.
- **A new artifact type for the received ask.** The authority weighed
  one — "a request specialization might be a separate artifact with a
  different name like 'small-feature-task'". Declined by the
  authority's direction, "we are not working through any new types",
  and because the `request` root already fits: a received ask is a
  document asking a reader to act or decide, the root's own
  definition, once the type admits one the shop receives.
- **Routing by a role other than the lead-pm** — a dedicated router
  role, an open amendment on this branch. Not chosen: the authority placed routing with the
  lead-pm "since the lead-pm is an extension of the human authority"
  and made a decline an act taken with the authority; a router role,
  if it comes, would take the activity under this decision, not
  reopen it (see §4).

Candidates split out because a record carries one decision (the adr
typedef's rule), each the authority's
position from the same ruling (initiative history v1), taken here as
pre-state and decided by none of this record:

- *The work register holds work in motion only* — the register's
  role.
- *The small-change lane takes the form of a feature with a size,
  framed by its request, not a new artifact type* — the lane itself is
  a destination §2 establishes; its form is not decided here.
- *Discovery accepts a request as its input and the initiative
  references it* — the hinge: the point at which a routed request
  becomes an initiative's origin.

Screened against the
[architecture principle set](../basis/architecture-principles.md):
conforms on five; `intent-provenance` is the principle the decision
cannot fully satisfy today, and its exception stands in this record —
the bullet below and §4's review trigger — and in the lead shop's
operational contract artifact when that lands.

- `intent-provenance` — not fully satisfied today. The principle
  requires intent to enter through a contract — for the lead shop, its
  operational contract — and this decision records intent at a record
  where that contract has no artifact: the request is the
  record-at-entry practice, each route a recorded translation on it,
  and the originator chain begins at a request, but the contract it
  enters through is stated nowhere. The exception is escalated to the
  authority, this record's decider, and stands durably here — in this
  screen and in §4's review trigger — and in the operational contract
  artifact when it lands; conformance is restored when that artifact
  names the request as its entry record. lead-4kymc is the tracking
  pointer, not the exception's home.
- `knowable-shape` — the lead shop's description of what it accepts
  gains a stated entry record and three stated routes, readable from
  the request typedef and the intake process's definition; nothing
  about what the shop takes in has to be learned from its internals.
- `contracts-between-contexts` — no Bounded Context is touched
  (the initiative's Decomposition); a request whose route reaches a
  shop travels only as scenario assignment sends it.
- `actor-neutral-discipline` — recording attaches to whichever
  lead-shop role meets intent, routing to the lead-pm role in the
  intake process, with the same record whoever fills either role —
  the authority in person, agent-assisted, or an agent; "an extension of the human authority" states the role's
  standing, not a grant to an actor kind. A decline is the role's act
  with the authority, recorded on the request.
- `local-comprehension` — the request is a product-level record at the
  coordinating level; routing is performed from it alone, and a route
  into discovery hands on the record, never the transcript.
- `bidirectional-conformance` — the design change is recorded here
  before the definitions amend and the intake process runs; forward,
  the initiative's measure demonstrates it; reverse, the intake
  process's definition is what calls for each record the routing
  produces.

## 2. Decision

Every expression of intent the lead shop receives is recorded on
arrival as a `request` — the durable record, in the repository — and
routed from that record to one of three destinations: a discovery
conversation, the small-change lane — a destination this decision
establishes: a path that takes a simple change to a verified result
without a bet or a screen of record, its form left to a decision of
its own — or a decline settled with the product authority.

## 3. Consequences

- A record exists before any work. What changes: the request typedef
  must admit a received ask — the originator's words, the date, the
  route with its reason — and an intake process must carry the
  routing; the initiative's Feasibility names the amendments, their
  shape being the typedef owner's and the process author's. For whom:
  every lead-shop role, which records on meeting intent; the lead-pm,
  which routes; anyone bringing the lead shop intent. Cost: a record per ask, declined
  asks included; the typedef amendment; one intake process with its
  screen rounds. Forecloses: acting on an unrecorded ask — a direction
  in a transcript or a register item is not a route.
- The routing activity is the lead-pm's. What changes: the intake
  process places routing with the lead-pm role, on the authority's
  ruling that the lead-pm is "an extension of the human authority";
  recording stays any lead-shop role's act on meeting intent. For whom: the lead-pm; a router role, if one comes,
  takes the activity without reopening this decision. Cost: the
  lead-pm's session time per ask, the routing said before it is acted
  on.
- A decline is not the lead-pm's alone. What changes: the third
  destination is a decision taken with the authority and recorded on
  the request. For whom: the lead-pm; the authority, whose ruling each
  decline needs. Cost: the authority's attention per decline; a
  silent drop is no longer possible.
- The register is not the record of an ask. What changes: a work item
  opened for a routed ask points at its request, and what was asked is
  read from the request, never from the item. For whom: whoever opens
  or reads items. Cost: the reference on every such item. The wider
  rule — the register holds work in motion only — is the first
  candidate in §1, not decided here.
- Intent met mid-process has somewhere to go. What changes: a role
  that meets an ask while running another process records it as a
  request and continues, instead of acting on it or losing it. For
  whom: every lead-shop role. Cost: a record written outside the
  running step; its route waits for the lead-pm.
- Provenance starts at the request. What changes: a trace that
  dead-ends before a request is a recording defect; the initiative's
  Framing and the small-change path's work must reach the request. For
  whom: reviewers demanding the originator chain; the lead-pm at
  framing. Cost: the reference from each; whether the Framing quotes
  or references the originator's words is the third candidate in §1.

Bound on Bounded Context shops: none — a BC shop's intake stands under
its own operational contract; extending this decision to it would be a
guardrail decision, the architect role's.

## 4. Reversibility

Reversible at low cost until requests carry provenance: reverting is
amending the request typedef back to an emitted-only type and retiring
the intake process — design first, the reverse conformance check then
naming the process and its renderings for retirement. Hard once
initiatives and features name a request as their origin: each such
reference becomes a dead-ended trace under `intent-provenance` unless
the originator's words move back into the referencing document, one
edit per record. Review triggers: the lead shop's operational contract
artifact (lead-4kymc) landing with a different entry record; a router
role taking the routing activity from the lead-pm; a volume of
requests the lead-pm cannot route within a session; a Bounded
Context's product contract accepting intent directly, so that the lead
shop's front end is no longer the only one.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-04 | update | Authored through the adr-authoring process on the authority's direction of 2026-09-04 — "If this initiative needs an ADR, make sure the architect produces that" — for the ruling of the same day in the discovery conversation for init-request-routing (lead-1kp6m), after the bet (initiative v3) and before any definition amends. Right: `escalation` — the decider is the authority, and none of the five rights the solutions architect role holds covers where intent enters the lead shop and as what record; the typedef sends a decision no listed right covers to `escalation`, and §1 names the escalation. Recorded as an adr rather than a product decision record because the decision is about the product's shape — the record at which intent enters and keeps its provenance — the PM role ruling on the right at the check. Three of the ruling's four positions split out under the one-decision rule as named candidates (§1). Status draft pending the screen. |
| 2 | 2026-09-04 | review | Screen round 1 (judge: claude-fable-5-1 / screen prompt v6): five confident findings — lead-1kp6m used before introduction; the escalation paragraph's pointer to "the last paragraph" false; the decision sentence named the router; "reconcile-side" undefined; candidate 1's "points at the request" also a consequence — and three wobbly, ruled by the lead-pm — the second route unstated at the decision's level; `intent-provenance` claimed conditionally rather than named as the exception lead-4kymc carries; the no-bound statement listed as a consequence. Repaired. Register identifiers deferred here from §1: the conversation was triggered by lead-spnnl (the lighter process for small changes); converting the register's open items into durable requests (lead-vx02q) belongs to the first candidate, the third's Framing-rule change by lead-ghulb. |
| 3 | 2026-09-04 | review | Screen round 2 (judge: claude-fable-5-1 / screen prompt v6): six confident findings — recording allocated to the lead-pm in two places and to every role in a third; "the initiative" and "the work item" used before introduction; "the branch primer" unintroduced; the small-change lane and "the hinge" unintroduced in the candidates list; the screen's result stated twice — and four wobbly, ruled by the lead-pm — the lane gloss in §2 stands as the route, candidate 2 restated as its form only, "screen of record" introduced; the `intent-provenance` exception's home is this record and the contract artifact, lead-4kymc a pointer; "the PM role" replaced by "the lead-pm"; the v2 row's "drain" spelled out. Repaired. |
| 4 | 2026-09-04 | review | Screen round 3, the cap (judge: claude-fable-5-1 / screen prompt v6): one confident finding (lead-4kymc bare at first use) and three wobbly — whether the decision decides that the lane exists; option 2's decline sentence overloaded; 'the one-decision rule' undefined. Post-cap repairs, disclosed and not re-screened: the identifier introduced; the decision sentence made to say the lane is a destination this decision establishes, its form a candidate (the PM role's ruling); the decline split; the rule glossed. |
| 4 | 2026-09-04 | state | `draft` → `checked`: the PM role's pass. Reasons: no round's confident findings survived repair; the cap's open findings are wording the criteria do not settle, repaired past the cap and disclosed. The decider is the authority; the record is checked for form. `right: escalation` accepted as the typedef admits for a decision no architect right covers. |
| 5 | 2026-09-04 | update | Where the intent-provenance exception is recorded — in this record, lead-4kymc the pointer — ratified by the authority's ruling of 2026-09-04 on brief-035 — "Take defaults. For 5. take discovery" (brief-035 ask 4, default taken); the operational-contract artifact routed to discovery (ask 5; req-2026-09-04-operational-contract). |
