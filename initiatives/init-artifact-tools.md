---
type: initiative
id: init-artifact-tools
name: Artifact tools
status: active
version: 3
owner: lead-pm
created: 2026-09-07
updated: 2026-09-07
request: ../requests/req-2026-09-07-artifact-tools.md
parent: init-run-efficiency
---

# Initiative: Artifact tools

## Framing

Originator (product authority, 2026-09-07; req-2026-09-07-artifact-tools, section 1): "I want a request put in to have tools (interfaces) to read and write artifacts, since that would solve many issues with context size and editing complexity, as well as rendering calculated fields like bi-directional relationships."

Problem: a role reads a whole artifact to use one section, and history is 40 to 90 percent of an artifact; an edit quotes the text it replaces, and a history row is one line of up to 1,700 words; a fact held in one place (a child naming its parent) cannot be read from the other end without a read across the corpus. Outcome: artifacts are read and written by part through tools that answer the standard question and are used through their skills, and calculated fields (children of a parent, what references an artifact) are rendered on request.

## For whom

Every role that reads or writes an artifact. Measure: context tokens loaded per artifact read by a role. Now: the whole file, up to 17,000 words. Target: the section asked for. Interaction types: command line and API — the tools are run at a prompt and by other tools. The scenarios also cover what the runs showed: hashes filled by a tool, not by hand; an execution's bead naming its initiative; the router loading a step, not the whole skill, where a tool can serve it.

## Appetite

To be set at the bet. No-gos: no change to the artifact typedefs beyond what the tools need to address a part; no second home for any fact.

## Feasibility and usability

Not yet.

## Decomposition

Not yet.

## Features

[feat-artifact-tools](../features/feat-artifact-tools.md) — draft.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Framed by the lead-pm at the discovery-conversation frame step (sess-2026-09-07-b) from the authority's words in req-2026-09-07-artifact-tools, section 1. |
| 2 | 2026-09-09 | state | `proposed` → `planned`: the authority's bet by its order of 2026-09-08 ("Follow your order"); the framing widened to what the runs showed. |
| 2 | 2026-09-09 | update | Features section: feat-artifact-tools added, draft — written by the feature-authoring draft step (the PO role); seven scenarios, all owned by the lead shop per this step's judgment, the Decomposition section not yet attached; interaction types cli and api, from the For whom section's own words; every scenario's hash left pending for a later step to fill. |
| 3 | 2026-09-09 | state | `planned` → `active`: feat-artifact-tools passed feature-authoring's self-check (v2) on its first pass. |
