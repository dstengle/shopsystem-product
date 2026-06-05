---
name: problem-framing-canvas
description: Reframe a messy or solution-shaped request into a clear, bias-checked problem statement and a "How Might We" question before committing intent. Use when you suspect you're about to solve the wrong problem, or when a request arrives pre-converged on a solution.
---

# Problem Framing Canvas (adapted, EXPERIMENTAL)

**Discipline 1 — Problem discovery & selection.** Adapted from
`deanpeters/Product-Manager-Skills/skills/problem-framing-canvas` (MITRE
Innovation Toolkit). See [`../README.md`](../README.md) for adaptation rules and
experimental status.

## Why the PO reaches for this

Before committing a brief or PDR, this lens forces the problem open in three
passes so the framing is not just the requester's first guess. It is the
antidote to solution-first thinking and to optimizing for the shop rather than
the user.

## The three passes

1. **Look Inward** — name the symptom, *why it isn't solved yet* (new / hard /
   deprioritized / unclear), and **how we are part of the problem**: what are we
   assuming, and are we converging on a solution prematurely?
2. **Look Outward** — *who* experiences it, *when/where*, and with what
   consequence; who else has it and how they cope; **who has been left out** of
   the framing; and who benefits from the status quo.
3. **Reframe** — restate as: *"[who] struggles to [accomplish what] because
   [root cause], which leads to [consequence], and this was overlooked because
   [our assumption]."* Then a **How Might We**: *"How might we [action] so that
   [objective]?"* — broad enough to admit more than one solution.

## Lands in our artifacts

- The reframed statement **is the problem statement** at the top of a brief or
  PDR — the thing the rest of the intent is accountable to.
- The **How Might We** sets the solution space a PDR's options explore, or that
  `opportunity-solution-tree` branches from.
- The "who's been left out" pass routinely surfaces a missing scope decision —
  route that to the operator as a `clarify` rather than silently choosing.

## Product-general fork (inputs differ; passes are identical)

- **Consumer product (primary):** "who experiences it" = user segments and
  personas; "who's been left out" = underserved/marginalized customers; equity
  and accessibility framing is real product surface.
- **Framework-as-product (this repo, meta):** "who experiences it" = adopters,
  operators, BC-shop agents; "who's been left out" = a BC role or shop type the
  framing forgot; "who benefits from the status quo" = often a piece of process
  friction nobody owns. The same structure, pointed at the developer/operator
  experience.

## Posture (COMMIT-TO-SPECIFICS, not a workshop)

The source skill is a facilitated, multi-perspective workshop with a human team.
You run all three passes yourself, in one move, committing a concrete reframe —
not eight rounds of questions. Where a pass turns up a genuine **scope or
vocabulary** decision that is the operator's to make, surface that one decision
as a `clarify`; commit everything else. Do not stall the whole reframe on one
open question.

## Sufficiency check

- The reframed problem is **specific** (who / what / root cause / consequence),
  not "improve the experience."
- The **How Might We** is broad enough to admit more than one solution (not "how
  might we add feature X").
- At least one **assumption** from "Look Inward" is named and challenged — if you
  found none, you did not look inward.
