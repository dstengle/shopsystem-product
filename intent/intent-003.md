---
type: intent-record
id: intent-003
title: Granular LLM spend observability for fabro, starting with a per-token spend-cap guardrail
status: recorded
created: 2026-07-14
updated: 2026-07-14
authors: [dstengle, "Claude (acting lead-pm)"]
description: Stakeholder intent for incrementally-built, granular visibility into fabro's LLM token spend — triggered by the move to per-token billing (OpenRouter) but rooted in a longer-standing want for effectiveness observability.
stakeholder: dstengle
session: sess-2026-07-14-a
superseded-by:
beads: [lead-2ckf7]
---

# intent-003 — Granular LLM spend observability for fabro

## Verbatim anchors

2026-07-14: "Along with this change, we are going to need to start
tracking costs in a granular way throughout the system. This will need
to be developed incrementally in slices and I'll need some help
determining the path."

2026-07-14: "Guardrail — this is interesting since the starter
provider, openrouter, has per-token spend limits. The system will need
to know if it is headed towards the caps and if it will be stopped in
its tracks. This feels like it would need a real-time element, but I'm
willing to have a discussion on this point to discuss the tradeoff on
complexity and (potential) system stability issues of having a
real-time mechanism or not."

2026-07-14: "I have always wanted observability on token use in order
to judge effectiveness of the system."

2026-07-14: "I'm mainly concerned with LLM usage right now. The
ultimate granularity would be the token use per node in fabro, for
maximum visibility, but something much less granular to start would be
acceptable."

## The goal behind the ask

Two motives converge on the same underlying capability gap — the shop
has no visibility into LLM token spend at all today:

1. **Guardrail.** Once [[intent-002]] lands real spend on OpenRouter
   (a provider with hard per-token spend caps), the fleet can run out
   of budget and be cut off mid-run with no warning. The system needs
   to know when usage is heading toward a cap.
2. **Effectiveness.** Independent of billing risk, the stakeholder has
   a standing want to judge the system's effectiveness by token use —
   this predates and outlives the OpenRouter move, and overlaps with
   the existing (unshaped) backlog item `lead-2ckf7` (system-
   effectiveness harness: token-use + model-effectiveness across
   prompt/model variants).

Explicitly **not** MVP: cross-provider/cross-model cost *comparison*
("is OpenRouter cheaper than the subscription for this work") — named
by the stakeholder as real but a later roadmap item, not the first
slice.

## Who it serves

The stakeholder (dstengle) as budget owner (guardrail) and as the
person trying to evaluate whether the fleet's LLM usage is effective
(observability) — same person, two distinct decisions the data needs
to support.

## Constraints

- Scope, for now, is **LLM usage only** (not every metered resource the
  shop touches — compute, other brokered APIs are explicitly out).
- Must be buildable **incrementally in slices** — the stakeholder was
  explicit this is not a single deliverable, and asked for help
  determining the sequencing/MVP, not a full design up front.
- Ultimate target granularity is **per fabro node** (maximum
  visibility); the stakeholder explicitly accepts a coarser starting
  granularity.

## Non-goals (for the first slice; not permanent)

- Cross-provider/cross-model cost comparison (roadmap, not MVP).
- Non-LLM cost tracking.
- A resolved real-time-vs-batch mechanism — see Open threads. The
  stakeholder asked to discuss this tradeoff explicitly rather than
  have it decided inside discovery.

## Appetite signal

Not stated numerically. Stakeholder explicitly wants help shaping the
MVP/slice sequence — this is a candidate-shaping question, to be set
when [[intent-003]] is driven to a candidate.

## Failure conditions

- Building toward maximum per-node granularity first and never shipping
  a usable slice (violates the stated incremental-slices constraint).
- A guardrail mechanism whose complexity or real-time requirements
  destabilize the very system it's meant to protect — the stakeholder
  named this risk directly and wants it weighed, not assumed away.

## Open threads

- **Real-time guardrail vs. after-the-fact tracking** — the stakeholder
  explicitly flagged the complexity/stability tradeoff of a real-time
  spend-cap mechanism and wants a dedicated deciding conversation
  (option-tradeoff) on this before it's built, not a default assumed
  here.
- Relationship to `lead-2ckf7` (existing unshaped backlog item covering
  token-use/model-effectiveness harness) — likely the same underlying
  capability as the "effectiveness" motive above; needs reconciling
  when this is shaped so the two don't diverge into parallel work.
- Whether the guardrail motive (block 1) and the effectiveness motive
  (block 2) can share one MVP slice, or need to be sequenced separately
  given their different urgency (guardrail is coupled to intent-002
  shipping; effectiveness is a standing want with no hard trigger) —
  not resolved, worth surfacing at shaping/prioritization.
