---
name: workshop-facilitation
description: The canonical divergence/convergence facilitation pattern for running an interactive PM session over a set of options — one question at a time, visible progress, recommendations only at decision points. Reach for it inside an option-tradeoff session to structure how the dialogue is conducted.
---

# Workshop Facilitation (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** option-tradeoff · **Emits into:** PDR draft (`pdr/pdr-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `option-tradeoff` PM session; its output lands in the PDR draft. No terminal artifact of its own.

*Adapted, with permission, from [`deanpeters/Product-Manager-Skills/skills/workshop-facilitation`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/workshop-facilitation) by [Dean Peters](https://www.linkedin.com/in/deanpeters/) — fetched live 2026-07-10, direct-grant terms per [ADR-066](../../adrs/adr-066.md). Adaptation rules + experimental status: [`../README.md`](../README.md).*

## Why the session reaches for this

When an option-tradeoff session has more than one live option, the risk is a
premature jump to "the obvious one." This skill supplies the *facilitation
choreography* — how to diverge, then converge, without collapsing the round-trip
that PM mode exists to preserve. It governs the conversation; the substance
(the options, the scoring) is the recommendation-canvas's job.

## Entry modes (offer at the top of the session)

- **Guided** — one targeted question per turn.
- **Context dump** — the product authority front-loads what's known; you parse it
  and only ask for the gaps.
- **Best-guess** — you infer missing detail with each assumption **explicitly
  labeled**, so the authority can veto it. This is the shopsystem-compatible
  default when the authority is thin on time.

## The facilitation loop (retain the round-trip — do NOT batch)

1. **Diverge.** Surface every candidate option; forbid evaluation while
   diverging. Ask *"what other shape could solve this?"* one turn at a time.
2. **Progress labels.** Prefix each turn (`Options Q2/5`) so the authority always
   knows where they are.
3. **Single question per turn.** Never stack questions; never recommend after
   every answer.
4. **Converge only at decision points** — after option-set synthesis, and again
   at the final pick. There, and only there, offer **numbered** recommendations;
   accept multi-select input (`1,3` / `1 and 3`).
5. **Interruptions.** On a meta question, answer it, restate progress, resume.

## Consumer / framework-as-product fork

- **Consumer:** options are product directions for end-customers; the authority
  is the product owner.
- **Framework-as-product (bootstrap):** options are shopsystem design directions;
  the authority is the operator/adopter. Same choreography, different room.

## Lands in the PDR

The diverged option set becomes the PDR's **Options-considered**; the converged
pick and its rationale become the **Decision**. Capture the labeled assumptions
inline so the decision record shows what was inferred vs. confirmed.

## Pitfalls

Multiple questions at once · recommending after every turn · missing progress
labels · converging before the option set is fully diverged · silently promoting
a best-guess assumption into the record without flagging it.
