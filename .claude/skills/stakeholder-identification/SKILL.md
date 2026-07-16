---
name: stakeholder-identification
description: Enumerate every stakeholder in a problem before engaging anyone — allies, audiences, influencers — with an equity lens that surfaces the marginalized voices a five-minute memory list misses. Use inside the discovery-dialogue to be sure the intent isn't framed for only the loudest party.
---

# Stakeholder Identification (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** discovery-dialogue · **Emits into:** intent record (`intent/intent-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `discovery-dialogue` PM session; its output lands in the intent record. It has no terminal artifact of its own.

*Adapted, with permission, from [`deanpeters/Product-Manager-Skills/skills/stakeholder-identification`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/stakeholder-identification) by [Dean Peters](https://www.linkedin.com/in/deanpeters/) — fetched live 2026-07-10, direct-grant terms per [ADR-066](../../adr/066-direct-grant-from-dean-peters-authorizes-mit-ingestion-of-deanpeters-derived-pm-skills-attribution-required.md). Adaptation rules + experimental status: [`../README.md`](../README.md).*

## When to reach for it

Before the dialogue frames a problem, ask *whose* problem it is — completely. This
lens builds the full stakeholder set so intent isn't quietly shaped for the one
person in the room. Identification only; prioritization is `stakeholder-mapping`.

## The six steps (run as an open brainstorm with the authority)

PM mode is interactive: brainstorm wide first, filter later — filtering during
generation is exactly how marginalized voices get dropped.

1. **Unconstrained brainstorm** — every individual, team, org, or community with
   any plausible stake. No filtering.
2. **Categorize** — Allies (active supporters), Audiences (directly/indirectly
   impacted), Influencers (shape decisions without participating).
3. **R/P/D mark** — tag each for Resources, Permission, or Decision authority.
4. **Equity lens** — who bears consequences without design power; whose
   perspective is missing; trace primary, secondary, tertiary effects.
5. **Bias check** — name who you defaulted to, who's absent, what assumptions
   shaped the list.
6. **Priority targets** — 2–3 stakeholders needing the deepest understanding
   (highest-power deciders, highest-impact least-understood users, likely blockers).

## Input fork (steps identical; the cast differs)

- **Consumer product (primary):** end-user segments, buyers, regulators, support,
  the marginalized non-buyer who still bears consequences.
- **Framework-as-product (bootstrap/meta):** adopters, operators, BC-shop agents,
  the router, downstream BCs, template maintainers — and the role or shop type
  nobody remembered to represent.

## Emits into the intent record

Build is ~free, so the gate is the point:

- The stakeholder set and the 2–3 priority targets land on the record as the
  people the intent's **goal** must serve.
- Stakeholders the intent explicitly does **not** serve this time become named
  **non-goals** — legible, not silently dropped.
- A high-consequence, no-voice stakeholder the dialogue could not reach is flagged
  as a **failure condition** to validate, and can trigger a `discovery-interview-prep`
  turn to bring their voice in.
