---
type: initiative
id: init-run-efficiency
name: Run efficiency
status: proposed
version: 3
owner: lead-pm
created: 2026-09-07
updated: 2026-09-07
request: ../requests/req-2026-09-07-run-efficiency.md
---

# Initiative: Run efficiency

## Framing

Originator (product authority, 2026-09-07; req-2026-09-07-run-efficiency, section 1): "We need drastically higher efficiency. This was a relatively straightforward task and should not be so expensive." In the discovery: "Prose is missing as a top level issue... We need to define a voice that is straightforward and rejects complexity and excessive verbosity and explanation." "The lead-pm should not be coordinating a running graph at all... This should be a deterministic process that can be run by a very cheap and fast model."

Problem: one two-feature initiative cost 132 wall minutes, 171 agent-minutes, and about 85M tokens of context, three quarters of it in the lead-pm session that coordinates the flow; the artifacts are long, their history is most of their size, and every role reads them whole. Outcome: a unit of work costs a small fraction of that, and the cost is measured every run.

## For whom

Everyone who runs or pays for the shop. Measure: context tokens per delivered feature, with agent-minutes and wall minutes beside it. Now: about 42M per feature (init-tool-skills, two features). Target: under 5M. Interaction types: none.

## Appetite

None of its own: this initiative is a parent and is not bet on. Its measure is moved by its sub-initiatives, each bet on alone, in the order listed. No-gos: no change to what a process requires of its artifacts before the voice sub-initiative frames it; no second measurement system beside the one the measurement sub-initiative makes.

## Feasibility and usability

Not yet.

## Decomposition

Not yet.

## Features

None yet.

## Sub-initiatives

1. init-process-runner
2. init-flow-simplification
3. init-plain-voice
4. init-execution-vocabulary
5. init-run-measurement
6. init-artifact-tools

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Framed by the lead-pm at the discovery-conversation frame step (sess-2026-09-07-b) from the authority's words in req-2026-09-07-run-efficiency, section 1. |
| 2 | 2026-09-08 | update | init-flow-simplification added and ordered second with init-plain-voice third, on the authority's direction (req-2026-09-08-process-simplification); measurement and artifact tools follow. |
| 3 | 2026-09-08 | update | init-execution-vocabulary added fourth. |
