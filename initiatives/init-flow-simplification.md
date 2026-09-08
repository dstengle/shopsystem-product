---
type: initiative
id: init-flow-simplification
name: Flow simplification
status: proposed
version: 1
owner: lead-pm
created: 2026-09-08
updated: 2026-09-08
request: ../requests/req-2026-09-08-process-simplification.md
parent: init-run-efficiency
---

# Initiative: Flow simplification

## Framing

Originator (product authority, 2026-09-08; req-2026-09-08-process-simplification, section 1): "We need to remove checks and cold reads." "We need to remove all of the human checks throughout the process." "ADR writing should be AFTER the features are written." "Briefs - drop." "Human steps - complete after discovery and framing." "Checks - not on session close. Repairs run as new requests."

Problem: twenty agent runs and six human decisions stand between a bet and a build. Most are screens on records of decisions already taken. Outcome: after discovery and framing, a feature is authored, assigned, built, and verified with no human step and no check cycle; decisions are recorded after the feature, from what it needs; quality review is a sweep run on request whose findings become requests.

## For whom

The authority, who frames and reads sweeps; every role, which makes and self-checks. Measure: agent runs from bet to verified build. Now: about 20. Target: 6 or fewer. Interaction types: command line.

## Appetite

One working session per process definition changed. No-gos: no new check inside the flow; no human step after framing; no brief.

## Feasibility and usability

Not yet.

## Decomposition

Not yet.

## Features

None yet.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Framed by the lead-pm from the authority's words in req-2026-09-08-process-simplification. |
