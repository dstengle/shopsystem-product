---
name: pol-probe-advisor
description: Select the right Proof-of-Life probe flavor for a given hypothesis by working backward from the harshest truth, not from tooling comfort. Reach for it inside shaping when you know an assumption needs testing but aren't sure whether it's a feasibility check, a task test, a narrative, a simulation, or a vibe-coded probe.
---

# PoL Probe Advisor (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** shaping · **Emits into:** candidate (`candidates/cand-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `shaping` PM session; its output lands in the candidate (problem / appetite / solution-sketch / rabbit-holes / no-gos / evidence). No terminal artifact of its own.

*Adapted from [`deanpeters/Product-Manager-Skills/skills/pol-probe-advisor`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/pol-probe-advisor) — fetched live 2026-07-10. Adaptation rules + experimental status: [`../README.md`](../README.md).*

## What this decides

The advisor picks *how* to validate, not *whether* to. Given a hypothesis and its risk, it matches the cheapest useful probe to the harshest truth — so you don't validate the wrong assumption with the most comfortable tool. It pairs with [`pol-probe`](../pol-probe/SKILL.md), which then designs the chosen probe. Precondition: a hypothesis already exists (if not, that's `opportunity-solution-tree` / `problem-framing-canvas` first).

## The core move: work backward from the risk

The pitfall is **method-hypothesis mismatch** — picking a probe because the tool is familiar, then learning nothing about the actual risk. Instead: name the single blocking risk, then pick the flavor whose core question *is* that risk.

| If the core question is… | …the risk is | Flavor | Window |
|---|---|---|---|
| "Can this even be built / does the data hold?" | technical feasibility | **Feasibility check** | 1-2 days |
| "Can a user complete the job without friction?" | usability / task | **Task-focused test** | 2-5 days |
| "Does the workflow story land?" | comprehension / alignment | **Narrative prototype** | 1-3 days |
| "Can we model it without production risk?" | edge cases / unknowns | **Synthetic-data simulation** | 2-4 days |
| "Will it survive real user contact?" | end-to-end UX signal | **Vibe-coded probe** ⚠️ | 2-3 days |

The vibe-coded probe is the highest-risk pick: it looks real enough to confuse momentum with readiness, so set the disposal date before building it. Guiding principle: **the cheapest prototype that tells the harshest truth** — usually not code.

## Where it lands in the candidate

The advisor's output is the *chosen flavor + why*, which becomes the header of the candidate's **evidence / experiments** line before `pol-probe` fills in the hypothesis, threshold, and disposal date. If the scan reveals the real risk is political ("will execs approve a polished demo?") rather than product, the correct answer is *no probe* — record that as a candidate **no-go / rabbit-hole** rather than manufacturing prototype theater.

## PM mode is interactive — run the selection with the authority

This runs inside a live `shaping` dialogue. Ask the authority the four context questions — what's the hypothesis, what single risk needs eliminating, what timeline, what resources — one at a time, then reflect back a *recommended* flavor with its reasoning and let them confirm or redirect. Do not silently assign a flavor. If the hypothesis is too broad to place, narrow it with them first ("what's the smallest testable element? how would failure look?") before recommending.

## Build is ~free, so the gate is the whole point

Because the fleet can just build, the default drift is "skip the probe, build the real thing." The advisor exists to insert the cheap-test gate anyway: even a free build should be pointed at the *right* risk, and a $0 probe that kills a bad bet beats a cheap build that ships one. End by sharpening the shape: the flavor chosen, the risk it isolates, and — if the honest answer is "no useful probe exists" — the risk being carried knowingly.

## Consumer / framework fork (same selection logic; inputs differ)

- **Consumer product (primary):** risks skew desirability/usability; probes run against real or recruited users and real markets.
- **Framework-as-product (this repo, meta):** risks skew feasibility/comprehension of contracts and operator workflows; probes run against the artifact surface (`features/`, schemas, a throwaway BC), never production BCs.

## Sufficiency check

- The flavor was chosen from the **risk**, not from tooling comfort or visual impressiveness.
- Exactly **one** hypothesis is in scope — multiple risks mean multiple, sequenced probes.
- If the "risk" is internal politics or a foregone conclusion, the recommendation is **no probe**, recorded as a no-go — not a demo.
- The chosen flavor is the **cheapest** one that still tells the harsh truth.
