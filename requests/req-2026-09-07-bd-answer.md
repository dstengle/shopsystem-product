---
type: request
id: req-2026-09-07-bd-answer
status: recorded
version: 1
date: 2026-09-07
reader: lead-pm
owner: lead-pm
created: 2026-09-07
updated: 2026-09-07
originator: lead-solutions-architect
received-through: operational-contract
arose-in: feat-tool-skills-rest
route: awaiting
route-reason: ""
routed-to: ""
---

# Request: `bd` does not answer the standard question

## 1. What is requested

`bd`, the work register, does not answer the standard question: asked
`bd --describe` with the flag alone on 2026-09-07, it rejects the
flag and performs no use. Its skill at the lead shop's load point
stands on a description written beside it,
[`basis/tools/descriptions/bd.json`](../basis/tools/descriptions/bd.json),
until it does.

The one action asked of the owning shop: make `bd` answer
`--describe` — written to standard output with exit status 0 before
any other action, other arguments ignored — in the shape the
[tool-description data type](../basis/types/tool-description.md)
(v2, approved) publishes: the tool's name and what it does, and one
use entry per use it supports, each with what it does, what it takes,
what it returns, and how it fails. The decision the shape rests on is
[adr-2026-09-07-tool-answer](../decisions/adr-2026-09-07-tool-answer.md)
(§2 the flag's behaviour and the answer's shape; §3 the bound on
Bounded Context shops).

The lead-solutions-architect role's words, 2026-09-07, at the
delivery of feat-tool-skills-rest: "`bd` does not answer the
standard question; its skill stands on a description beside it until
it does. The gap is recorded against its owner: that the tool answer
`--describe` in the tool-description data type's shape."

## 2. From whom

Reader: the lead-pm role, which routes. Originator: the
lead-solutions-architect role, at the delivery of feat-tool-skills-rest
(the feature's scenario *a tool that cannot answer is recorded as a
gap against its owner*). Received through the lead shop's operational
contract, which has no artifact yet (lead-4kymc). Addressee, once
routed: the lead shop itself, holding the gap.

Owner of the tool: **not named — the tool's provenance as shown whoever runs it (`bd version 1.1.0 (8e4e59d39)`, its help) names no shop, so the lead shop holds this gap as its own until an owner is found; the description says the same.**

## 3. Route

Not yet said. Held, not routed and not sent, while the shop is frozen
(the primer's operating rules; work item lead-ki66p): a gap's reaching
its owner is the lead-pm role's to route after the freeze.

## 4. Result

Empty while the route is `awaiting`. This gap closes on one event
only: the skill-rendering process's check observing `bd` answer
the standard question, the skill produced from that answer, and the
description beside the tool retired — never by hand, by a change to
the description, or by a skill written around the tool.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Recorded by the lead-solutions-architect role at the delivery of feat-tool-skills-rest (v6) under init-tool-skills, when the description beside `bd` was written — the gap's opening event (the feature's constraint (8)); one request per tool that cannot answer, in the form the PO output check ruled at the feature's v5. The tool asked with the flag alone and nothing else, not read. Not routed, not sent: the shop is frozen. |
