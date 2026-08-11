---
name: stakeholder-presentation
description: Reform any document or message aimed at the product authority into a decision-first presentation, then verify it with an independent cold read before delivery. Use before delivering any report, sitting material, or status update longer than ~300 words.
type: skill
id: basis-skill-stakeholder-presentation
title: Stakeholder presentation skill — derived-projection format slice
status: experiment
created: 2026-08-10
updated: 2026-08-10
authors: [dstengle, "Claude (lead-pm)"]
derived-from: basis-process-stakeholder-presentation
conformance-checked: 2026-08-10
activation: model-judged
promotion: experiment-local
---

# Stakeholder presentation (derived from the process definition)

**Lead with the answer.** The reader must get the most important thing even
if they stop after the first paragraph, and must be able to make every
requested decision without opening an annex or the author's head.

## A1 — Frame (from the definition's activity A1)

Name the reader and the decisions. Enumerate asks; scope to the decision
horizon — defer what does not gate the next unit of work (deferrals are
notes, never asks); group; order by consequence; ≤7 asks. Split oversized
material by decision, not topic.

## A2 — Compose (activity A2)

Three layers: decision layer ≤ ~400 words (SCQA opening, ≤4 sentences, then
recommendations and asks); decision + support ≤ ~1,500 words; everything
else a labeled optional annex. Each ask: question → recommendation → inline
evidence → default. State which asks gate and which default on silence.
Block-ratifications state what they bind. Gloss every proper noun at first
mention. No commitments outside asks; no process citations or
revision-delta talk; numbers over adjectives; "e.g." on every illustrative
example. Style detail: `basis/guidelines/stakeholder-communication.md`.

## A3 — Cold-read loop (activity A3)

The author cannot cold-read their own text. Spawn a fresh
`cold-reviewer` (see `basis/roles/cold-reviewer.md`) per round — never
reuse one; revise on its findings with a consistency sweep (counts,
cross-references, promises checked against every later line). **Success
exit:** a round returns clean or author-accepted tradeoffs only.
**Failsafe exit: 4 rounds** — deliver with the open findings stated first.

## A4 — Deliver (activity A4)

Deliver; record the round verdicts (judge model + prompt version pinned).
Fitness set: `basis/fitness/decision-brief.fitness.md`, judged by the
cold-reviewer role.
