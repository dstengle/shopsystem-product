---
name: prioritization-advisor
description: Select the prioritization method that fits the current context — MoSCoW, RICE, ICE, weighted scoring, Kano, Value/Effort, Cost of Delay — instead of defaulting to one dogmatically. Reach for it inside a prioritization session before scoring anything, to pick the right lens for the stage, data, and decision at hand.
---

# Prioritization Advisor (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** prioritization · **Emits into:** prioritization record (`prioritizations/prio-YYYY-MM-DD.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `prioritization` PM session; its output lands in the prioritization record. No terminal artifact of its own.

*Adapted, with permission, from [`deanpeters/Product-Manager-Skills/skills/prioritization-advisor`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/prioritization-advisor) by [Dean Peters](https://www.linkedin.com/in/deanpeters/) — fetched live 2026-07-10, direct-grant terms per [ADR-066](../../adrs/adr-066.md). Adaptation rules + experimental status: [`../README.md`](../README.md).*

## Why the session reaches for this

There is no universal "best" prioritization method — the right one depends on
stage, team alignment, decision type, and how much data you actually have.
Picking the *method* is a distinct step that must precede scoring; this skill
runs that selection so the prioritization record opens with a justified method,
not an arbitrary one.

## The selection questions (ask one at a time — retain the round-trip)

1. **Stage** — pre-PMF / growth / mature / multi-product platform?
2. **Team context** — small & aligned / larger / misaligned / cross-BC complex?
3. **Decision need** — filter a backlog / align stakeholders / drive on data /
   manage a tradeoff?
4. **Data available** — minimal / some signal / rich metrics?

Do NOT batch these into one prompt; each answer narrows the next. Where the
authority already stated context, parse it and skip the covered questions.

## The method menu (match, don't default)

- **MoSCoW** — fast alignment, low data; must/should/could/won't.
- **Value/Effort** — quick 2×2 when a rough read beats precision.
- **RICE / ICE** — comparative scoring when reach/impact/effort are estimable.
- **Weighted scoring** — multi-criteria tradeoffs with agreed weights.
- **Kano** — separate delighters from must-haves (needs user signal).
- **Opportunity scoring** — importance-vs-satisfaction gaps.
- **Cost of Delay** — when timing/sequence dominates value.

## Consumer / framework-as-product fork

- **Consumer:** items are product features; reach = users, value = customer impact.
- **Framework-as-product (bootstrap):** items are shopsystem beads/BCs; reach =
  adopters/operators, value = framework health & developer experience. Same
  method menu; the selection questions read against the framework's own stage.

## Not a calculator, not strategy

This skill picks the *method* and hands over its scoring template, pitfalls, and
**reassessment triggers** (when to switch methods as context shifts). It does not
compute the scores or substitute for strategy.

## Lands in the prioritization record

Write `prioritizations/prio-YYYY-MM-DD.md` opening with the **selected method +
rationale** (the four answers), then the **scoring template** for that method,
the **ranked result** once scored, and the **reassessment trigger** that would
invalidate this ordering.
