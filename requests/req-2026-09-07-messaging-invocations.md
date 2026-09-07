---
type: request
id: req-2026-09-07-messaging-invocations
status: routed
version: 1
date: 2026-09-07
reader: lead-pm
owner: lead-pm
created: 2026-09-07
updated: 2026-09-07
originator: lead-pm
received-through: operational-contract
arose-in: feat-tool-skills-rest
route: small-change
route-reason: "two process definitions invoke the messaging command in a form the tool rejects — scenario-assignment's dispatch step and reconcile-and-close's consume step — corrected to the invocations the tool's description states; within the lead shop's own definitions, demonstrable in one session; held until the freeze lifts, since neither step runs while frozen"
routed-to: ""
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
role. Held, not started.

## 4. Result

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Recorded by the lead-pm at the request-intake process's record step from the implementer's delivery report on feat-tool-skills-rest; route decided, said, and accepted; held until the freeze lifts. |
