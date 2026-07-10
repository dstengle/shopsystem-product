---
name: stakeholder-mapping
description: Prioritize an identified stakeholder set with two complementary 2x2 grids — Power×Interest for engagement strategy and Impact×Power to surface who bears consequences but lacks voice — then compare them to find the blind spots. Use inside the discovery-dialogue after identification to decide whose voice the intent must elevate.
---

# Stakeholder Mapping (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** discovery-dialogue · **Emits into:** intent record (`intent/intent-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `discovery-dialogue` PM session; its output lands in the intent record. It has no terminal artifact of its own.

*Adapted from [`deanpeters/Product-Manager-Skills/skills/stakeholder-mapping`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/stakeholder-mapping) (MITRE Innovation Toolkit) — fetched live 2026-07-10. Adaptation rules + experimental status: [`../README.md`](../README.md).*

## When to reach for it

You have a full stakeholder list (from `stakeholder-identification`) and need to
decide whose voice weights the intent. Runs *two* grids and compares them — the
insight lives in the comparison, not either grid alone.

## The two grids + comparison (a live, discussed placement)

PM mode is interactive: place stakeholders with the product authority, argue the
edge cases, don't quantify within a quadrant.

- **Power × Interest** — how much each can shape the initiative × how much they
  care. Yields engagement strategy: manage closely / keep satisfied / keep
  informed / monitor. The grid most PMs already run.
- **Impact × Power** — who bears the consequences × how much org power they hold.
  Surfaces **Q1: high impact, low power** — the people most likely to hit the
  failure modes and least likely to be in the feedback loop.
- **Compare** — a stakeholder in "keep informed" on grid 1 but Q1 on grid 2 is
  being under-engaged relative to how much the product affects them. That is a
  product risk, not just an equity note. Impact ≠ power; conflating them is the
  most common mapping error.
- **Migration** — name who you want to move (Q1 → a real advisory role; skeptic →
  ally) and what action triggers the move. A snapshot becomes a plan.

## Input fork (grids identical; axes read differently)

- **Consumer product (primary):** power is org/market authority; Q1 is the
  underserved user segment whose workflow breaks but who has no roadmap seat.
- **Framework-as-product (bootstrap/meta):** power is influence over the spec /
  templates; Q1 is often the BC-shop agent or operator who lives with a contract
  decision but doesn't get a vote on it.

## Emits into the intent record

Build is ~free, so the gate is the point:

- The whose-voice-weights ranking sharpens the intent's **goal** — who it is
  primarily for.
- The Power×Interest / Impact×Power gap for each priority stakeholder rides onto
  the record as a **risk / failure condition**.
- Elevating a Q1 voice may open a genuine scope question — that is a live dialogue
  turn with the authority, and its resolution sets a **non-goal** boundary.
