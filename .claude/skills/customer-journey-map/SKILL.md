---
name: customer-journey-map
description: Map the SEQUENCE a user moves through to get a job done — stage by stage, with their actions, thoughts, emotions, friction/drop-off points, moments-of-truth, and where cognitive load spikes — so selection targets the highest-friction moment instead of a point-in-time pain. Use when the request is about an end-to-end experience (onboarding, adoption, a multi-step flow), or when point-in-time discovery (JTBD) keeps missing where the journey actually breaks.
---

# Customer Journey Map (adapted, EXPERIMENTAL)

**Discipline 1 — Problem discovery & selection.** Adapted from
`deanpeters/Product-Manager-Skills/skills/customer-journey-map` (source fetched
live, 2026-06-18; the upstream skill is a workshop/KPI-alignment artifact —
heavily re-cut here). See [`../README.md`](../README.md) for the adaptation
rules and experimental status.

## Why the PO reaches for this

JTBD, problem-framing, and the opportunity tree are all **point-in-time** lenses:
they recover the stable job and the acute pain, but they say nothing about *where
in the sequence* the experience breaks. Many real problems are not a single pain —
they are a **journey** where a job that is easy to state ("stand up shopsystem")
dies across a chain of steps, each fine in isolation, that compound into drop-off.

The journey map is the one discovery lens that makes the **sequence** legible:
the stages a user passes through to get the job done, and per stage their actions,
thoughts, emotions, the touchpoints they hit, where friction and drop-off live,
where the **moments of truth** are (make-or-break steps that decide whether they
continue), and where **cognitive load spikes**. That sequence-and-friction
dimension is exactly what the point-in-time skills miss.

This serves Discipline 1's sufficiency criterion by locating *which moment* is
worth fixing: selection should target the highest-friction, highest-stakes step,
not whatever pain surfaced first.

## The lens

Map the job as a sequence of **stages**, then fill each stage with the
experience dimensions — not the upstream KPI/ownership columns (those are an
internal-alignment artifact we don't carry):

- **Stages** — the ordered steps from "not yet started" to "job done" (e.g. for
  adopter bring-up: *discover → install → stand up lead shop → create first BC →
  dispatch first work → see it land*). Name them as the user experiences them,
  not as our internal phases.
- **Actions** — what the user concretely *does* at this stage (the command they
  run, the file they edit, the doc they read).
- **Thoughts** — what they're trying to figure out ("which of these is the lead
  shop?", "did that work?").
- **Emotions** — confidence, confusion, frustration, relief — tracked as a curve
  across stages, because the dips are where you lose people.
- **Friction / drop-off** — obstacles, ambiguity, manual wiring, silent
  failures: the places a user stalls, backtracks, or quits.
- **Moments of truth** — the make-or-break steps where the experience either
  earns continuation or loses the user (first successful dispatch; first "it
  actually built the thing"). A failure here outweighs ten small frictions.
- **Cognitive-load spikes** — stages demanding too much held context at once
  (too many concepts before the first win, unexplained vocabulary). High load
  early is a top drop-off driver.

Then **rank the moments** — a friction at a moment-of-truth or a load spike before
the first win outranks a mild annoyance late in the journey. That ranking is the
raw input to selection.

## Lands in our artifacts

- The stage-by-stage map and its emotion/friction curve become the **journey
  framing in the product brief** — the evidence that an intent is worth
  committing, and *where* in the experience it bites.
- The single highest-ranked friction (the worst moment-of-truth or load spike)
  feeds a **problem statement** in a PDR — pairs with `problem-framing-canvas`
  to sharpen it and with `opportunity-solution-tree` to choose the bet.
- It does **not** by itself produce Gherkin. The map justifies *which moment* we
  fix; the scenario (Discipline 4) pins *what behavior* removes the friction.
- It is **not a new artifact type.** There is no "journey-map register" — the map
  is working evidence that collapses into brief/PDR/findings.

## Product-general fork (inputs differ; lens is identical) — framework fork FOREGROUNDED

- **Framework-as-product (the immediate use):** the "user" is the **shopsystem
  adopter standing the framework up from an empty directory**. The journey is the
  bring-up sequence — *find the docs → install the lead shop → understand the lead
  vs. BC split → create the first BC → dispatch the first unit of work → watch it
  land*. Actions are real commands and edits; friction is developer-experience
  friction (unexplained vocabulary, setup that silently half-works, concepts that
  arrive before the first win); the moment-of-truth is the **first dispatch that
  visibly produces work**. Evidence is the install/getting-started docs, the
  cold-walkthrough record, and operator reports — not interviews we cannot run.
  This is the fork that `lead-y73x` (adopter-bootstrap journey) needs first.
- **Consumer product (the general case):** the user is a real end customer and the
  stages are their buying/usage lifecycle (awareness → consideration → first
  use → habit). Emotions are load-bearing; evidence is interviews, switch
  stories, support tickets, analytics drop-off funnels.

## Posture (COMMIT-TO-SPECIFICS, not a workshop)

The source skill convenes a cross-functional workshop and asks one question at a
time. You do not. Commit the specific stages and per-stage experience from the
best evidence on the contract/artifact surface (the getting-started docs, the
cold-walkthrough, operator reports). Where a stage's emotion or friction is
**assumed, not observed**, mark it `unvalidated` and either raise a bounded
`clarify` to the operator or open a bounded research task (a fresh cold-walkthrough
is the framework-fork equivalent of an interview). Never stall waiting for a
stakeholder turn the loop does not have. A fabricated emotion curve is worse than
an honestly-marked unvalidated one.

## Sufficiency check (the build-trap gate)

A journey map that does not drive selection has failed — it must **end by
sharpening what is worth fixing and what is not.**

- The journey is captured as an **ordered sequence of stages**, each with at
  least actions + emotion + friction (not a single point-in-time pain).
- At least one **moment-of-truth** and any **cognitive-load spike** are
  identified and ranked above the mild frictions.
- The map terminates in a **single named highest-priority moment** to fix —
  stated as a problem, not a solution — ready to hand to `problem-framing-canvas`
  / a PDR. Frictions that are real but not worth fixing are explicitly listed as
  *not selected*, so the map drives a cut, not just a picture.
