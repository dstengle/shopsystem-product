---
type: request
id: req-2026-09-07-messaging-invocations
status: routed
version: 6
date: 2026-09-07
reader: lead-pm
owner: lead-pm
created: 2026-09-07
updated: 2026-09-09
originator: lead-pm
received-through: operational-contract
arose-in: feat-tool-skills-rest
route: discovery
route-reason: "Decided afresh at the request-intake process's route step, from the record alone, on the lane's reason for changing the route: the dispatch half asks for data the assign step does not produce — a work id, a feature title, a bc tag, one file per scenario or a pinned payload — where the assignment type carries only context, scenario hashes, and pre-state; what to produce and where it comes from is design the authority explores, not a correction of two lines. Form: review of evidence."
routed-to: ""
work-item: lead-1fiv7
---

# Request: the process definitions' messaging invocations match the tool

## 1. What is requested

Found at the delivery of feat-tool-skills-rest, 2026-09-07, when the
description beside `shop-msg` was written from what the tool shows
whoever runs it: the scenario-assignment process's dispatch step
invokes `shop-msg send --bc … --type assign_scenarios --feature … --tag …`,
where the tool takes `shop-msg send assign_scenarios --bc … --work-id …`;
the reconcile-and-close process's consume step omits the `--message-type`
argument the tool requires. Neither step runs while the shop is
frozen, so neither has failed yet. The implementer left the drift
unrepaired: descriptions follow the tools, and a process definition is
the owner's to change.

## 2. From whom

Reader: the lead-pm role. Originator: the lead-pm role, from the
implementer's delivery report (feat-tool-skills-rest v7, deviation 4).
Received through the lead shop's operational contract, which has no
artifact yet (lead-4kymc).

## 3. Route

Route said by the lead-pm role, 2026-09-07: **the small-change lane**.
Why: two steps of two approved process definitions, each corrected to
the invocation the tool's skill states, the skills re-rendered; within
the lead shop's own definitions; demonstrable in one session by the
lint's `--process` check and the skill-rendering check. Held until the
freeze lifts: the lane's verify step observes the change in the
running system, and the two steps cannot run while frozen. Topic:
"messaging invocations (req-2026-09-07-messaging-invocations)".

Originator's answer: **accepted** — the originator is the lead-pm
role. Held until 2026-09-09, when the authority's order for the session
released it; shop-msg itself does not run while frozen, so the
verifying observation is the lint's process check and the
skill-rendering check. Landed 2026-09-09 at the request-intake
process's land step: the answer stands as accepted; the small-change
lane runs on register item lead-1fiv7, which points at this request
and carries nothing of what was asked.

Route changed by the lead-pm role, 2026-09-09, at the small-change
process's reroute step: **discovery**. Why, in the words of the
lane's definer, judged against the glossary's simple-change entry:
the scenario-assignment dispatch half of this request is not a
simple change — `shop-msg send`'s stated invocation requires
`--work-id`, `--feature-title`, `--bc-tag`, and one `--scenario-file`
per scenario (or a `--payload` file), and the assign step's
assignment data (context, scenario_hashes, pre_state) carries none
of these. Supplying them requires deciding new data to produce — a
work-id source, a payload-vs-repeated-file approach, where a
per-scenario path comes from — design work the small-change lane's
appetite excludes. The originator reads the changed route and its
reason here, as the first route was read.

Originator's answer to the changed route: **accepted** — the
originator is the lead-pm role. The request, its route now
discovery, is the discovery conversation's input.

Route decided by the lead-pm role, 2026-09-09, at the request-intake
process's route step, the execution entered with the request and the
lane's reason and nothing else: **discovery**, form **review of
evidence**. Why: the lane's reason holds against the record — the
assignment type (`basis/types/assignment.md`) carries `context`,
`scenario_hashes`, and `pre_state` and nothing else, while the tool's
`send` needs a work id, a feature title, a bc tag, and one file per
scenario or a pinned payload, and a scenario's identity is its
`@hash:`, not a file. Deciding what the assign step must produce, and
where each value comes from, is design the authority explores; a
correction of two lines cannot carry it. The consume half — the
missing `--message-type` — would be simple alone, but one ask takes
one route, and the dispatch half decides it. The form is review of
evidence because the conversation reads a record, not a wish: the
tool's description, the two process definitions, the assignment type,
and how the frozen corpus on `main` produced the same message. Topic:
"messaging invocations match the tool
(req-2026-09-07-messaging-invocations)".

Originator's answer: **accepted** — the originator is the lead-pm
role. Landed 2026-09-09 at the request-intake process's land step, the
second pass through it in this execution: the route stands as decided,
discovery in the form of review of evidence, and is now acted on. No
register work item is opened on this route; lead-1fiv7, the item the
first pass opened for the small-change lane, stays named above as the
record of that run and is closed as not simple. The request, its
route discovery, is the discovery conversation's input.

## 4. Result

The small-change lane defined no change and made none. At its define
step the lane found the change not simple, for the reason section 3
records: the dispatch step's corrected invocation needs data the
assign step does not produce, and deciding what to produce and where
it comes from is design work outside the lane's appetite. No
definition, skill, or process was touched; register item lead-1fiv7
closes as not simple. Where the route now leads — the initiative the
discovery conversation frames — is recorded here when it exists.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Recorded by the lead-pm at the request-intake process's record step from the implementer's delivery report on feat-tool-skills-rest; route decided, said, and accepted; held until the freeze lifts. |
| 2 | 2026-09-09 | update | Hold lifted by the authority's order for the session of 2026-09-09: the lane runs now; its verifying observation is the lint's process check and the skill-rendering check the route names, since shop-msg itself does not run while the shop is frozen. |
| 3 | 2026-09-09 | update | Landed by the lead-pm at the request-intake process's land step: the originator's answer, accepted, anchored in section 3; the route stands as said; register item lead-1fiv7 opened for the small-change lane to run on and written to work-item. |
| 4 | 2026-09-09 | update | Route changed from small-change to discovery by the lead-pm at the small-change process's reroute step, status unchanged (routed): the lane's define step found the scenario-assignment dispatch half not simple by the glossary's test — the corrected invocation needs work-id, feature-title, bc-tag, and per-scenario files the assign step's data does not carry, and deciding that data is design work outside the lane's appetite. No change defined or made; lead-1fiv7 to close as not simple; routed-to stays empty until the discovery conversation frames an initiative. Self-check against define-good-up-front: the typedef's rule for a later change of route (lead-pm's, reason recorded the same way, status unchanged) read before this edit and followed. |
| 5 | 2026-09-09 | update | Route decided afresh by the lead-pm at the request-intake process's route step, entered with the request and the lane's reason (O8): discovery, form review of evidence, reason as section 3 records; originator's answer not yet answered, status unchanged (routed), routed-to stays empty until the conversation frames an initiative. Self-check against define-good-up-front: the lane's reason verified against the assignment type and the shop-msg skill before deciding, not taken on faith; the typedef's section-3 rule (a route not yet answered is recorded as said, no action taken) followed. |
| 6 | 2026-09-09 | update | Landed by the lead-pm at the request-intake process's land step, second pass in the same execution: the originator's answer to the re-decided route, accepted, anchored in section 3; the route stands as discovery, form review of evidence; status unchanged (routed); no register item opened on this route, work-item left naming lead-1fiv7 (closed, not simple) as the record of the earlier run; routed-to stays empty until the conversation frames an initiative. Self-check against define-good-up-front: the typedef's section-3 rule (a route acted on only after answered) and the land step's rule (an item only on small-change, work_item otherwise empty) read before this edit and followed. |
