---
type: initiative
id: init-process-runner
name: Process runner
status: proposed
version: 2
owner: lead-pm
created: 2026-09-07
updated: 2026-09-07
request: ../requests/req-2026-09-07-run-efficiency.md
parent: init-run-efficiency
---

# Initiative: Process runner

## Framing

Originator (product authority, 2026-09-07; req-2026-09-07-run-efficiency, section 1, and the discovery): "The lead-pm should not be coordinating a running graph at all, not just the bookkeeping. This should be a deterministic process that can be run by a very cheap and fast model." "converge, but make process runner first"

Problem: the process definitions draw the flow as runtime steps, agent steps, and human steps, but nothing runs them; the lead-pm runs them by hand in one long context that carries every step, and that context was 64M of the 85M tokens the last initiative cost. Outcome: a process definition runs itself: runtime steps run as written, each agent step is launched with only its declared inputs, human steps wait for the human, and the coordinator carries no more than the step it is on.

## For whom

The lead-pm, who stops coordinating; every role, which receives only its inputs. Measure: context tokens processed by the coordinator per delivered feature. Now: 32M (init-tool-skills). Target: under 1M. Interaction types: command line — the runner is started and answered at a prompt.

## Appetite

To be set at the bet. The authority's direction, 2026-09-07: "I would like to avoid the expense of a code implementation for now and just get a cheap model to do what the lead-pm has been doing to coordinate and do bookkeeping." No-gos: no code runner now — the runner is a cheap, fast model in a coordinator role that runs the definition as written; no change to the shape of a process definition that a running process does not need; the migration question (req-2026-09-06-migration-review) decides later whether a code runner is a lead-shop tool or the shopsystem engine.

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
| 2 | 2026-09-07 | update | Appetite: the authority's direction at the start of the check — a cheap model as the coordinator, no code runner now. |
