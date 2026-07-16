---
name: recommendation-canvas
description: Structured evaluation of a candidate option — outcomes, hypotheses, assumptions, risks, value, metrics — treating each option as a bet to validate, not a commitment. Reach for it inside an option-tradeoff session to turn a raw option list into a defensible pick with rationale.
---

# Recommendation Canvas (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** option-tradeoff · **Emits into:** PDR draft (`pdr/pdr-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `option-tradeoff` PM session; its output lands in the PDR's Options-considered + Decision. No terminal artifact of its own.

*Adapted, with permission, from [`deanpeters/Product-Manager-Skills/skills/recommendation-canvas`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/recommendation-canvas) by [Dean Peters](https://www.linkedin.com/in/deanpeters/) — fetched live 2026-07-10, direct-grant terms per [ADR-066](../../adr/066-direct-grant-from-dean-peters-authorizes-mit-ingestion-of-deanpeters-derived-pm-skills-attribution-required.md). Adaptation rules + experimental status: [`../README.md`](../README.md).*

## Why the session reaches for this

`workshop-facilitation` choreographs the room; this skill supplies the
*substance* — the per-option evaluation grid that makes convergence honest.
Every option is a **bet to validate, not a commitment**: the canvas surfaces the
assumptions and risks that would kill it, so the PDR records *why* one option
won, not just that it did.

## The canvas dimensions (evaluate each live option against these)

1. **Business outcome** it moves — `[Direction] [Metric] [Outcome] [Context]`.
2. **Customer/adopter outcome** it moves — the outcome for the one who hires it.
3. **Problem framing** it addresses — trace back to the pinned problem.
4. **Solution hypothesis** — the smallest thing that would prove it.
5. **Positioning** — who it's for, against what alternative.
6. **Assumptions** — what must be true; label the shakiest.
7. **Risks / PESTEL** — specific, not generic ("adoption stalls if X", not "risky").
8. **Value justification** — why this outcome is worth the build.
9. **Success metric** — SMART; how we'd know it worked.
10. **Next step** — the validating experiment or the commit.

Outcomes over features throughout: "cuts dispatch-to-work_done latency 40%",
never "adds a queue."

## Retain the round-trip (PM mode is interactive)

Fill the canvas *with* the product authority, one dimension at a time where
evidence is thin — do NOT batch-commit a full canvas from assumption. Where
evidence exists, commit the specific and move on; where it doesn't, mark the cell
as an open assumption to confirm rather than fabricating certainty.

## Consumer / framework-as-product fork

- **Consumer:** business+customer outcomes, real-market positioning, end-user metrics.
- **Framework-as-product (bootstrap):** adopter/operator/BC-shop outcomes,
  developer-experience positioning, framework-health metrics. Same ten cells.

## Not a PRD

The canvas is not a requirements doc, not a finalized business case, not a
feature list. It is decision evidence.

## Lands in the PDR

Each option's filled canvas becomes an entry under **Options-considered**; the
winning canvas's outcome + rationale becomes the **Decision**, and its "next
step" seeds the follow-on (validating scenario or dispatch).
