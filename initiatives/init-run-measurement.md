---
type: initiative
id: init-run-measurement
name: Run measurement
status: proposed
version: 1
owner: lead-pm
created: 2026-09-07
updated: 2026-09-07
request: ../requests/req-2026-09-07-run-efficiency.md
parent: init-run-efficiency
---

# Initiative: Run measurement

## Framing

Originator (product authority, 2026-09-07; the discovery on req-2026-09-07-run-efficiency): "This should be completely mechanical data gathering that can even be executed for each run to support optional analysis."

Problem: the cost of a run is known only when someone reads the transcripts by hand, as was done once for init-tool-skills. Outcome: every session close records, without a model, one row per agent run — step, role, minutes, context tokens, output tokens where the harness gives them, tool uses — beside the session record, so any run can be analysed on request.

## For whom

The authority, who reads the cost; the run-efficiency parent, whose measure this feeds. Measure: sessions whose close records the cost rows. Now: 0. Target: every session. Interaction types: none — a runtime step of session handoff.

## Appetite

To be set at the bet. No-gos: no analysis in the step itself — rows only; no measure that needs a model to compute.

## Feasibility and usability

Not yet.

## Decomposition

Not yet.

## Features

None yet.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Framed by the lead-pm at the discovery-conversation frame step (sess-2026-09-07-b) from the authority's words in req-2026-09-07-run-efficiency, section 1. |
