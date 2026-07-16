---
name: discovery-process
description: The end-to-end discovery arc — frame, plan, research, synthesize, validate, decide — used to sequence a multi-turn discovery-dialogue and know which technique skill comes next. Use when a discovery is large enough to need staging rather than a single lens.
---

# Discovery Process (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** discovery-dialogue · **Emits into:** intent record (`intent/intent-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `discovery-dialogue` PM session; its output lands in the intent record. It has no terminal artifact of its own.

*Adapted, with permission, from [`deanpeters/Product-Manager-Skills/skills/discovery-process`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/discovery-process) by [Dean Peters](https://www.linkedin.com/in/deanpeters/) — fetched live 2026-07-10, direct-grant terms per [ADR-066](../../adr/066-direct-grant-from-dean-peters-authorizes-mit-ingestion-of-deanpeters-derived-pm-skills-attribution-required.md). Adaptation rules + experimental status: [`../README.md`](../README.md).*

## When to reach for it

Most requests need one lens. Some need a *sequence*: the problem is fuzzy, spans
several jobs, or the evidence is thin. This is the orchestration lens — it stages
the dialogue and names which technique skill runs at each step, so the session
doesn't stall in analysis or leap to a build.

## The arc (six phases — a live, staged dialogue, not a waterfall)

PM mode is interactive: each phase is a round with the product authority, and the
decision gates are conversational checkpoints, not sign-off forms. Continuous, not
one-time — re-enter the arc whenever new evidence lands.

1. **Frame the problem** — scope and success criteria. Runs `problem-framing-canvas`
   / `problem-statement`. *Gate: enough context to research?*
2. **Plan research** — method and who to talk to. Runs `discovery-interview-prep`;
   `stakeholder-identification` / `-mapping` to pick whom.
3. **Research** — hear the actual users; capture verbatim, not paraphrase.
4. **Synthesize** — find patterns; rank pains via `jobs-to-be-done`. *Gate:
   saturation — same insight across 3+ sources?*
5. **Generate & validate** — options via `opportunity-solution-tree`; state a
   hypothesis + success signal before building. *Gate: did it validate?*
6. **Decide & document** — build / pivot / kill, written into the intent record.

Guard the named failure modes: skipping the "why", leading questions, too-small a
sample, analysis paralysis, and treating discovery as a one-time pre-build step.

## Input fork (arc identical; cadence differs)

- **Consumer product (primary):** weeks-long cycles, real customer touchpoints,
  costed experiments — the classic continuous-discovery cadence.
- **Framework-as-product (bootstrap/meta):** the "research" is dogfooding the
  framework and reading adopter/operator/BC-shop friction; the cycle is tighter
  because the fleet can build a probe cheaply — which raises, not lowers, the bar
  on stating a hypothesis first.

## Emits into the intent record

Build is ~free, so the gate is the point. The arc's job is to reach a defensible
decision, not to run forever:

- The framing (phase 1) and synthesized job (phase 4) become the record's **goal**.
- Options considered and killed (phase 5) become **non-goals**, recorded so they
  aren't re-litigated.
- Each decision gate that was passed on assumption rather than evidence rides onto
  the record as a **failure condition**. The document is the artifact; the process
  produces nothing of its own.
