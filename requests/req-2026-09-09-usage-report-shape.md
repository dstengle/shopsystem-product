---
type: request
id: req-2026-09-09-usage-report-shape
status: routed
version: 2
date: 2026-09-09
reader: lead-pm
owner: lead-pm
created: 2026-09-09
updated: 2026-09-09
originator: lead-pm
received-through: operational-contract
arose-in: init-run-measurement
route: small-change
route-reason: "the cost-row tool reads a comment form the router no longer writes and a token quad the harness no longer reports; aligned to what stands, within the lead shop's own definitions, demonstrable in one session on a real anchor"
routed-to: ""
---

# Request: the cost rows read what the harness now reports

## 1. What is requested

Found on the first cost reading after the run-efficiency work
(2026-09-09, anchors lead-lv37s, lead-ipi60, lead-jsqmr, lead-r86dp):
`write_cost_rows.py` reads a `context` comment carrying an
input/cache-creation/cache-read/output quad; the router (v10) writes a
`usage` comment, and the harness now reports to the starter one
figure per agent step — `subagent_tokens`, with `tool_uses` and
`duration_ms` — and reports nothing per turn to the router itself,
which once wrote the remaining budget as if it were consumption
(lead-lv37s) and otherwise leaves the field blank. So the rows carry
no token figure for any step, and the initiative rollup sums blanks.
The figures the harness does report reach only the starter, who
records them on the anchor by hand.
Run on lead-lv37s, the tool also writes no step row at all: it reads
a step event as `step <id>` and the router writes `step: <id>`, so
the rows table came out empty (sessions/sess-2026-09-09-a-cost.md).

## 2. From whom

Reader: the lead-pm role. Originator: the lead-pm role, as the starter
of the four executions. Received through the lead shop's operational
contract (lead-4kymc).

## 3. Route

Route said by the lead-pm role, 2026-09-09: **the small-change lane**.
Why: the tool and the router's usage line are the lead shop's own; the
tool reads the router's `usage` comment and a starter's `report`
comment in the form the harness gives — one tokens figure and tool
uses per step — and the run-cost typedef's columns follow, its
renderings re-produced; no figure is computed by a model. Accepted —
the originator is the lead-pm role. Not started: this session's order
named three lane items.

## 4. Result

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Recorded by the lead-pm at the request-intake process's record step from the starter's reading of the four anchors; routed to the lane, accepted, not started. |
| 2 | 2026-09-09 | update | Second finding added: the tool's step-line form differs from the router's, so the rows table is empty on a real anchor. |
