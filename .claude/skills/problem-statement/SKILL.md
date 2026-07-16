---
name: problem-statement
description: Turn a request or a raw job into a crisp, user-centered problem statement using the "I am / trying to / but / because / which makes me feel" frame, so intent names a person and a barrier, not a solution. Use inside the discovery-dialogue to fix the problem before any solutioning.
---

# Problem Statement (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** discovery-dialogue · **Emits into:** intent record (`intent/intent-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `discovery-dialogue` PM session; its output lands in the intent record. It has no terminal artifact of its own.

*Adapted, with permission, from [`deanpeters/Product-Manager-Skills/skills/problem-statement`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/problem-statement) by [Dean Peters](https://www.linkedin.com/in/deanpeters/) — fetched live 2026-07-10, direct-grant terms per [ADR-066](../../adr/066-direct-grant-from-dean-peters-authorizes-mit-ingestion-of-deanpeters-derived-pm-skills-attribution-required.md). Adaptation rules + experimental status: [`../README.md`](../README.md).*

## When to reach for it

The dialogue has a fuzzy problem or a feature request, and you need the single
crisp sentence the rest of the intent will answer to. Where `problem-framing-canvas`
opens the problem up, this lens crystallizes it into an empathy-anchored statement.

## The five-part frame (built interactively, in the user's voice)

PM mode is interactive: draft each clause with the product authority and pressure-
test it, rather than filling the template alone.

- **I am** — a specific persona, not "busy professionals".
- **Trying to** — a desired *outcome*, not a task.
- **But** — the real barrier blocking progress.
- **Because** — the root cause (keep asking "why" past the symptom — "confusing
  UI" is a symptom).
- **Which makes me feel** — the authentic emotional impact, ideally in a real
  quote, never marketing language.

Add **context & constraints**, then collapse it into **one crisp problem
sentence**. Guard the pitfalls: solution smuggling, a business metric masquerading
as a user problem ("churn is down" is not a user problem), generic personas,
symptoms-as-causes, and fabricated emotion.

## Input fork (frame identical; the "I am" differs)

- **Consumer product (primary):** "I am" is an end-customer persona grounded in
  research.
- **Framework-as-product (bootstrap/meta):** "I am" is an adopter, operator, or
  BC-shop agent — e.g. *"I am an operator standing up a three-BC product, trying
  to get them talking, but the messaging wiring is undocumented, because contracts
  live only in code, which makes me feel I'm guessing."*

## Emits into the intent record

Build is ~free, so the gate is the point:

- The one-sentence statement becomes the intent record's **goal** framing.
- The **but / because** clauses bound what would count as *not solving it* —
  seeding **non-goals** and **failure conditions**.
- A statement you cannot ground in a real persona or a real quote is flagged
  **unvalidated** on the record and routed back to a discovery turn, not shipped.
