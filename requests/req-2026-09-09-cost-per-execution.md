---
type: request
id: req-2026-09-09-cost-per-execution
status: routed
version: 1
date: 2026-09-09
reader: lead-pm
owner: lead-pm
created: 2026-09-09
updated: 2026-09-09
originator: lead-pm
received-through: operational-contract
arose-in: req-2026-09-09-usage-report-shape
route: small-change
route-reason: "the run-cost typedef binds one cost artifact to one session and one anchor, so a session that ran several executions keeps the rows of one; the artifact carries every anchor the session ran, or one artifact stands per execution, decided at the lane's define step; within the lead shop's own definitions"
routed-to: ""
---

# Request: a session's cost covers every execution it ran

## 1. What is requested

Found 2026-09-09 at the close of sess-2026-09-09-a, which ran seven
executions through the router (lead-lv37s, lead-r86dp, lead-ipi60,
lead-o0bkh, lead-6p8xu, lead-lgkmh, lead-st6wo): the cost-row tool
writes sessions/<session>-cost.md from one anchor, and the run-cost
typedef names one anchor per artifact, so the session's cost artifact
carries the feature-authoring rows and none of the other six. The
rollup for an initiative therefore sums one execution where the
session ran three for the feature.

## 2. From whom

Reader: the lead-pm role. Originator: the lead-pm role, at the
session's close. Received through the lead shop's operational
contract (lead-4kymc).

## 3. Route

Route said by the lead-pm role, 2026-09-09: **the small-change lane**.
Why: the run-cost typedef, the cost-row tool, the session-handoff
process's write-cost-rows step, and the rollup are the lead shop's
own; the define step decides between one artifact naming every anchor
and one artifact per execution, and the proof is a rollup that sums
every execution a session ran. Accepted — the originator is the
lead-pm role. Not started: after req-2026-09-09-rollup-reads-typedef.

## 4. Result

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Recorded by the lead-pm at the request-intake process's record step at the session's close; routed to the lane, accepted, not started. |
