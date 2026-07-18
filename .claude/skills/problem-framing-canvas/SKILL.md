---
name: problem-framing-canvas
description: Reframe a messy or solution-shaped request into a clear, bias-checked problem statement and a "How Might We" question before committing intent. Use inside the discovery-dialogue when you suspect you're about to solve the wrong problem.
---

# Problem Framing Canvas (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** discovery-dialogue · **Emits into:** intent record (`intent/intent-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `discovery-dialogue` PM session; its output lands in the intent record. It has no terminal artifact of its own.

*Adapted, with permission, from [`deanpeters/Product-Manager-Skills/skills/problem-framing-canvas`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/problem-framing-canvas) (MITRE Innovation Toolkit) by [Dean Peters](https://www.linkedin.com/in/deanpeters/) — fetched live 2026-07-10, direct-grant terms per [ADR-066](../../adr/066-direct-grant-from-dean-peters-authorizes-mit-ingestion-of-deanpeters-derived-pm-skills-attribution-required.md). Adaptation rules + experimental status: [`../README.md`](../README.md).*

## When to reach for it

Before committing intent, this lens forces the problem open in three passes so the
framing is not just the requester's first guess. It is the antidote to
solution-first thinking and to optimizing for the shop rather than the user.

## The three passes (facilitated with the product authority — hold the turn open)

PM mode is interactive: run these as a live workshop with the authority, not a
one-shot commit. Each pass is a round of questions, not a fill-in-the-blank.

1. **Look Inward** — name the symptom, *why it isn't solved yet* (new / hard /
   deprioritized / unclear), and **how we are part of the problem**: what are we
   assuming, and are we converging on a solution prematurely?
2. **Look Outward** — *who* experiences it, *when/where*, with what consequence;
   who else has it and how they cope; **who has been left out** of the framing;
   and who benefits from the status quo.
3. **Reframe** — restate as: *"[who] struggles to [accomplish what] because [root
   cause], which leads to [consequence], and this was overlooked because [our
   assumption]."* Then a **How Might We**: *"How might we [action] so that
   [objective]?"* — broad enough to admit more than one solution.

## Input fork (passes identical; inputs differ)

- **Consumer product (primary):** "who experiences it" = user segments and
  personas; "who's been left out" = underserved/marginalized customers; equity
  and accessibility framing is real product surface.
- **Framework-as-product (bootstrap/meta):** "who experiences it" = adopters,
  operators, BC-shop agents; "who's been left out" = a BC role or shop type the
  framing forgot; "who benefits from the status quo" = process friction nobody
  owns. Same structure, pointed at the developer/operator experience.

## Emits into the intent record

Build is ~free, so the gate is the point:

- The reframed statement **is the problem framing** at the top of the intent
  record — the thing the rest of the intent is accountable to.
- The **How Might We** bounds the solution space; it also names what the intent is
  *not* — solutions outside the HMW are **non-goals**.
- The "who's been left out" pass routinely surfaces a scope decision; that is a
  live dialogue question for the authority, not a silent choice.
- At least one named, challenged **assumption** rides onto the record as a
  failure-condition to watch. Found none? You did not look inward.
