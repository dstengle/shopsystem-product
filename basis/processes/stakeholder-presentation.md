---
type: process-definition
id: basis-process-stakeholder-presentation
title: Stakeholder presentation — loop-bearing process example
status: experiment
created: 2026-08-10
updated: 2026-08-10
authors: [dstengle, "Claude (lead-pm)"]
description: Turn source material into a decidable presentation, verified by an independent cold read; ISO 24774 header + ETVX cells + dual-exit loop.
annotations-namespace: runtime
produces: [decision-brief]
carried-by: skills/stakeholder-presentation/SKILL.md
---

# Process: Stakeholder presentation

**Format slice: the loop-bearing example.** Header per ISO/IEC/IEEE 24774
(name, purpose, observable outcomes); activities as ETVX cells (entry /
tasks / validation / exit); loop with dual exit (Essence-style reached-state
success + round-cap failsafe). `runtime.*` annotations are projection
metadata only — translators consume them, definition semantics ignore them.

**Purpose:** Turn source material into a presentation the product authority
can decide from in one short sitting, verified by an independent cold read
before delivery.

**Outcomes:**
- O1. A presentation exists within budget: decision layer ≤ ~400 words,
  decision + support ≤ ~1,500.
- O2. Every ask carries a recommendation, inline evidence, and a default,
  and states whether it gates work or resolves on silence.
- O3. An independent cold read has returned clean, or flags only
  author-accepted tradeoffs.
- O4. The original material survives intact as a labeled, linked annex.

**Roles:** author — lead-pm (Accountable). cold reviewer —
[`../roles/cold-reviewer.md`](../roles/cold-reviewer.md) (Verifier; never
the author).

**Artifacts:** in — source material with named reader and decisions. out —
a [`decision-brief`](../artifacts/decision-brief.md) (+ annex, + round
verdicts).

**Carried by:**
[`../skills/stakeholder-presentation/SKILL.md`](../skills/stakeholder-presentation/SKILL.md)
— a derived projection of this definition, never the source of truth.

## Activities

### A1 — Frame
- **Entry:** source material exists; reader and decision(s) named.
- **Tasks:** enumerate asks; scope to the decision horizon (defer what does
  not gate the next unit of work); group, order by consequence; split the
  material if the budget cannot hold it.
- **Validation:** each ask names the decision it serves; ≤7 asks after
  grouping.
- **Exit:** ask list meeting validation exists.
- **Annotations:** `runtime.claude-code: {carrier: SKILL.md §Decision-asks}`
  · `runtime.fabro: {model: high-reasoning tier (e.g.), max_attempts: 2}`

### A2 — Compose
- **Entry:** A1 exit.
- **Tasks:** write decision + support layers fresh; gloss every proper noun
  at first mention; attach every block to an ask or label it informational;
  demote the original to a labeled annex.
- **Validation:** budgets met (O1); no unglossed coinages; no commitments
  outside asks.
- **Exit:** complete draft + labeled annex.
- **Annotations:** `runtime.claude-code: {carrier: SKILL.md §Structure,
  §Style}` · `runtime.fabro: {model: high-reasoning tier (e.g.)}`

### A3 — Cold-read loop (A3a review → A3b revise, repeat)
- **A3a Review:** a fresh-context cold reviewer (no annex, no prior-round
  memory) reads the presentation alone; reports stumbles, unintroduced
  terms, per-ask decidability, overload verdict, top changes.
- **A3b Revise:** author repairs findings; consistency sweep (counts,
  cross-references, promises held against every later line).
- **Success exit (reached state):** a round returns clean or
  author-accepted-tradeoffs only.
- **Failsafe exit (cap):** 4 rounds — deliver with open findings attached
  rather than loop on. (Count-only exits are legal where rounds are the
  semantics.)
- **Annotations:** `runtime.claude-code: {A3a: fresh subagent per round}` ·
  `runtime.fabro: {A3a/A3b: separate nodes, separate contexts; loop: cyclic
  edge, guard = success exit, counter = cap}`

### A4 — Deliver
- **Entry:** A3 exited (either exit).
- **Tasks:** deliver; record round verdicts; on failsafe exit, state open
  findings first.
- **Validation:** O1–O4 hold.
- **Exit:** stakeholder has the presentation; instance closed.

## Derived checks (full traceability — seed-document rule)

| Outcome | Check | Kind |
|---|---|---|
| O1 | word counts vs budgets | mechanical |
| O2 | ask structure parse (rec + evidence + default + gate marker) | mechanical |
| O2 | ask decidability | judged — [`../fitness/decision-brief.fitness.md`](../fitness/decision-brief.fitness.md) |
| O3 | round verdicts recorded; final round clean or tradeoffs marked | mechanical + judged |
| O4 | annex present, labeled, linked | mechanical |
