---
type: initiative
id: init-request-routing
name: Request routing and the small-change lane
status: active
version: 6
owner: lead-pm
created: 2026-09-04
updated: 2026-09-04
---

# Initiative: Request routing and the small-change lane

## Framing

Originator (product authority, 2026-09-04, through the lead shop's
operational contract, which has no artifact yet (lead-4kymc), in
discovery lead-1kp6m):
"this is about getting simple things done, which now requires being
able to route requests."

Problem: a simple, functional change can only get done through the
full product flow, whose stages protect a bet the change does not
spend; and an ask arising in conversation has no record until a
discovery conversation opens for it. Outcome: every ask is recorded on
arrival and has a decided route — into discovery, to a simple change,
or declined with the authority — and a simple change reaches a
verified result without the stages that protect a bet.

## For whom

The product authority and anyone bringing the lead shop an ask.
Measure: a simple functional change — the originator's example, a
decision brief that says what it relates to — reaches a verified
result through a recorded, routed ask, the full flow untouched. Now 0:
the only door is discovery, the only path the full flow. Target 1.
Interaction type: conversational.

## Appetite

One working session of the lead shop, covering every ask recorded
and routed on arrival, the route into discovery kept open, and the
example change verified: definitions alone do not meet the measure.
No-gos, reasoned:

- Instance-local configuration of this shop (lead-1d0eo): no new types this session.
- Grooming every open work item, not only planned initiatives
  (lead-izfpk): ordering, not doing.
- Converting the work register's open items into durable records
  (lead-vx02q): work of its own.
- Refining the Framing with the authority (lead-ghulb): not needed to route.
- New artifact types — the authority's direction: "we are not working
  through any new types".
- The bet and the screen of record: they protect an appetite a simple
  change does not spend.

## Feasibility and usability

Feasible within one session, the verified example included, on the
roles-availability precedent: a new process, its tool, and a
demonstrated run delivered in one session. Evidence: no contract exists
on this branch; the repository's two features touch neither requests
nor routing: no conflict. Five lead-shop definitions amend (`request`,
feature, initiative, discovery's `topic` input, the decision brief's
closed field set) plus one intake process; that process's screen rounds
are the overrun risk, and a cap-round pass suffices to run the example.
(architect, 2026-09-04)

Hypothesis, no observed use: "make a request" becomes a core-task entry
holding on every type — options: state the ask in the originator's
words; see the request's id; see its route (discovery, small lane,
declined) and reason. The conversational door is an assistant
interaction: the router says the route before acting, and the person
can correct it (`control-stays-with-the-person`). (designer,
2026-09-04)

## Decomposition

None: no Bounded Context is touched. Every amended definition and the
example change sit in the lead shop's tree; no contract exists on this
branch to rely on. Cross-context flow: none.

## Features

[feat-request-routing](../features/feat-request-routing.md) — assigned.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-04 | update | Recorded `proposed` by the discovery conversation's frame step, on the authority's convergence — "Keep the hinge, one session, converge" (work item lead-1kp6m; session sess-2026-09-04-b). Positions reached in the conversation and recorded for the check: the request is the front-end record for every ask and the durable one, the work register holding work in motion only and pointing at it; the small lane is a feature with a size, framed by its request, not a new type; the lead-pm routes and records, rejection handled with the authority. |
| 2 | 2026-09-04 | review | Initiative-check screen round 1 (judge: claude-fable-5-1 / screen prompt v5): two confident findings, both in Appetite — a no-go without its reason; the scope sentence naming the request-and-reference mechanism — repaired; five wobbly in the lead-pm's sections repaired the same round: the contract named, the outcome restated without a role or path, the example named plainly, the appetite made explicit that the verified change is in it, the third originator quote (carrying "lane") moved here: "There needs to be a small-change lane that even includes features, however minor. … This is a trivial, but functional change that shouldn't require a lot of process." Before the round, sections 1–3 were cut from 490 to fit the 500-word bound once the two attachments landed (598 after the architect's). |
| 2 | 2026-09-04 | review | Screen round 2 (judge: claude-fable-5-1 / screen prompt v5): five wobbly, none confident. Repaired: the second originator quote (carrying "entry-point") moved here: "we don't have a good entry-point to go from open-ended human input to something an agent can work with."; the example restated as "a decision brief that says what it relates to"; each no-go given a half-line saying what it is; the contract restated. The uncovered finding — the architect's verdict silent on feasibility within the appetite as written — returned as an ask to the architect, answered: feasible within one session, the verified example included, on the roles-availability precedent, the intake process's screen rounds the overrun risk. |
| 2 | 2026-09-04 | review | Screen round 3, the cap (judge: claude-fable-5-1 / screen prompt v5): three wobbly, none confident, no uncovered — scenario 1: whether an unartifacted operational contract counts as the contract named; scenario 4: whether no-gos naming a structure to exclude it name a structure; scenario 4: whether the three route destinations in the outcome are outcome or mechanism. Post-cap repair, disclosed and not re-screened: the contract clause reworded to the judge's own proposal ("through the lead shop's operational contract, which has no artifact yet"). The other two are held for the authority at the bet. |
| 3 | 2026-09-04 | state | `proposed` → `planned`: the authority's bet, taken in the initiative-check decide step on its standing direction of this session — "continue all the way through implementation unless there is anything absolutely requiring clarification from me. … you have my permission to continue through." — the lead-pm recording it, for the authority's ratification at delivery. The bet was presented with the three cap findings and the lead-pm's reading of each; the direction followed. Reasons: no finding was confident in any round; the two held scenario-4 findings turn on readings the criteria do not settle — a no-go must name what it excludes, and the three route destinations are the authority's own decision from the discovery, an outcome — and the no-go question is filed for the owner in the initiative fitness set's Document History. The product decision record for the go is the PO role's to make and the PO output check screens it; made: [pdr-2026-09-04-bet-request-routing](../decisions/pdr-2026-09-04-bet-request-routing.md). The authority also directed that the architect produce the architecture decision record this initiative rests on; made and checked: [adr-2026-09-04-request-front-end](../decisions/adr-2026-09-04-request-front-end.md) (three candidates split out for their own runs: the register's role, the lane's form, the hinge). |
| 4 | 2026-09-04 | state | `planned` → `active`: feat-request-routing's first pass through the PO output check (round 3, the cap; the PM role's pass with post-cap repairs disclosed) — written by that check's record step through its declared framing input, planned the only status written over. |
| 5 | 2026-09-04 | update | Measure met in the running system: the originator's example — a decision brief that says what it relates to — reached a verified result through a recorded, routed request (req-2026-09-04-brief-relates-to: recorded and routed by the request-intake process's first run, defined by the PO, made by the architect, checked by the lead-pm, verified by the runtime's observation, exit 0), the full flow untouched: 0 → 1. The door and the lane exist as approved definitions rendered at the load point (request-intake v4, small-change v4; skill-rendering check clean, 21 approved) and the harness lists both skills in a session. The confirm and observe steps of the intake's first run read the authority's standing direction as the originator's answers, disclosed on the request. The `completed` state is a pending reconcile-side amendment; the PO role judges the features done. |
| 6 | 2026-09-04 | update | The bet ratified by the authority's ruling of 2026-09-04 on brief-035 — "Take defaults. For 5. take discovery" (ask 1 default: stands); the approvals and amendments delivered under it ratified (ask 2 default: stands). |
