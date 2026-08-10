---
type: principle-set
id: basis-principles
title: Founding principles — format slice (three examples)
status: experiment
created: 2026-08-10
updated: 2026-08-10
authors: [dstengle, "Claude (lead-pm)"]
description: Three example principles in TOGAF four-part form with BCP 14 keywords; composed fitness screen applied.
---

# Principles — format slice

**Format:** TOGAF four-part (Name / Statement / Rationale / Implications),
imperative titles with stable handles, BCP 14 keywords (MUST/SHOULD/MAY,
capitals normative). **Example set:** three principles from the re-founding
dialogue — enough to prove the format; the full set (~10) is drafted only
after ratification. The composed fitness screen is applied at the end.

The key words MUST, SHOULD, and MAY are to be interpreted as described in
BCP 14 (RFC 2119, RFC 8174) when, and only when, they appear in capitals.

---

## Define before you build (`construction-precedes-inspection`)

**Statement.** Every activity MUST operate from an explicit definition of
good construction before it runs; checks and review rubrics MUST be derived
from that definition and MUST NOT be invented independently of it.

**Rationale.** Checks without a stated definition are scar tissue: each gate
encodes a fragment of an unstated standard, the gaps between fragments are
where gaming lives, and rejection-sampling bad output costs multiples of
generating good output. (Deming: cease dependence on inspection; build
quality in.)

**Implications.** New activities enter the system with their definition, or
not at all. A check that cannot cite the definition clause it projects is
deleted. Review seats audit conformance to a known standard instead of
supplying taste of last resort. Spot-check failures obligate a
definition-or-check fix, not only an artifact fix.

## Govern the generating context (`governed-context`)

**Statement.** Everything loaded into an agent's generating context —
prompts, skills, memories, primers — MUST trace to a ratified definition or
a governed record; unsanctioned context channels MUST NOT accumulate.

**Rationale.** The generating context defines the distribution work is
sampled from; an ungoverned surface is an ungoverned generator. The 67
unsanctioned bd memories are the observed failure: a feedback loop with no
consumer re-routed into the nearest ungoverned channel and became
load-bearing without ever being reviewed.

**Implications.** Context surfaces are versioned, promoted through a gated
step, and auditable (which definition version was in force when an artifact
was produced). Memory channels get a defined process with a consumer, or
they are closed. Skills ship with the tools they wrap, in lockstep.

## Every activity belongs to a process (`no-orphan-activities`)

**Statement.** Every activity in the system MUST be part of a defined
process with stated expected outcomes, expected outputs, and possible
resulting actions; every long-running loop MUST declare its exit — a
reached-state success exit, a round or budget cap, or both.

**Rationale.** An activity outside a process has no consumer for its output,
so the output accumulates or vents uselessly (mechanism_observation died
this way; the memory pile grew this way). Definition-level process contracts
are followable by any runtime — this is a definition requirement, not a
workflow-engine prescription.

**Implications.** Orphan activities are findings, not conveniences. Process
definitions are cheap to write (header + activity cells) so cost is no
excuse. Loops without declared exits do not pass review.

---

## Fitness screen applied (the composed checklist — TOGAF, Spool, Rumelt, Lencioni)

| Screen | construction-precedes-inspection | governed-context | no-orphan-activities |
|---|---|---|---|
| Understandable / Robust / Complete / Consistent / Stable (TOGAF) | pass | pass | pass |
| Helps you say no (Spool) | yes: rejects definition-less checks | yes: rejects unsanctioned channels | yes: rejects orphan activities |
| Not fluff, not a goal-in-disguise (Rumelt) | directs and constrains without prescribing method | same | same |
| Not permission-to-play (Lencioni) | pass — most systems do NOT work this way | pass | pass |
| Implies ≥1 practice and ≥1 check (shop rule) | derivation practice; check-citation audit | promotion gate; provenance audit | process-membership lint; loop-exit review |
