---
name: pol-probe
description: Design a Proof-of-Life probe — a lightweight, disposable experiment that tests one falsifiable hypothesis before expensive work — and land it in the candidate's evidence/experiments line. Reach for it when a shape rests on an assumption cheap enough to test in hours or days and honest enough to kill the bet if it fails.
---

# PoL Probe (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** shaping · **Emits into:** candidate (`candidates/cand-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `shaping` PM session; its output lands in the candidate (problem / appetite / solution-sketch / rabbit-holes / no-gos / evidence). No terminal artifact of its own.

*Adapted, with permission, from [`deanpeters/Product-Manager-Skills/skills/pol-probe`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/pol-probe) by [Dean Peters](https://www.linkedin.com/in/deanpeters/) — fetched live 2026-07-10, direct-grant terms per [ADR-066](../../adrs/adr-066.md). Adaptation rules + experimental status: [`../README.md`](../README.md).*

## What a PoL probe is

A **Proof-of-Life probe** is a reconnaissance mission, not an MVP: a disposable experiment built to surface a harsh truth *before* the shape gets built. It has five traits — **lightweight** (hours/days), **disposable** (planned for deletion after learning), **narrow** (one falsifiable hypothesis), **brutally honest** (real signal, not vanity metrics), and **tiny**. A probe decides *whether* to build the bet; an MVP is the smallest thing you'd ship *because* you decided to. The failure mode it exists to prevent is **prototype theater** — a polished demo that impresses and teaches nothing.

## Five probe flavors — match the probe to the risk

| Flavor | Core question | Best for | Window |
|---|---|---|---|
| **Feasibility check** | "Can this even be built / does the data hold?" | technical unknowns, API/data integrity | 1-2 days |
| **Task-focused test** | "Can a user complete the job without friction?" | critical UI moment, labels, decision points | 2-5 days |
| **Narrative prototype** | "Does the workflow story land?" | comprehension, alignment on a complex flow | 1-3 days |
| **Synthetic-data simulation** | "Can we model this without production risk?" | edge cases, unknown-unknowns | 2-4 days |
| **Vibe-coded probe** | "Will it survive real user contact?" | workflow/UX signal from a semi-real "Frankensoft" | 2-3 days |

Guiding principle: **use the cheapest probe that tells the harshest truth.** (See `pol-probe-advisor` to pick the flavor.)

## Where it lands in the candidate

The probe writes the candidate's **evidence / experiments** line: the hypothesis under test, the flavor, the **pass/fail/learn threshold set *before* running**, and the disposal date. A probe that *would falsify* the bet, and the branch it protects, is often also a candidate **rabbit-hole** or **no-go** made explicit — record it there too. The shape is not "done" until each load-bearing assumption either has a probe or is consciously accepted as unprobed risk.

## PM mode is interactive — design the probe with the authority

This runs inside a live `shaping` dialogue. Elicit the hypothesis in the authority's words ("If [action] for [persona], then [outcome]"), agree the single risk it isolates, and settle the pass/fail threshold *together* before anyone builds — that agreement is the whole value. Do not silently pick a flavor and declare it done. One probe tests **one** hypothesis; if the shape carries several risks, that is several probes, sequenced by which failure would hurt most.

## Build is ~free, so the gate is the whole point

The BC fleet can often just build the real thing — which is exactly why an un-probed assumption is dangerous: "just build it and look" spends fleet capacity to discover, three weeks in, that the wrong hypothesis was under test. A probe is cheaper than a wrong build *and* forces a written success signal. End by sharpening the shape: which assumption is now retired, which bet the probe result greenlights or kills, and which risk you are knowingly carrying unprobed.

## Consumer / framework fork (same probe discipline; inputs differ)

- **Consumer product (primary):** hypothesis about end-user demand/behavior; probe against real or recruited users; harsh truth = they won't/can't.
- **Framework-as-product (this repo, meta):** hypothesis about adopter/operator/BC-shop behavior — will an operator understand a contract, will a scenario dispatch cleanly; probe against the artifact surface or a throwaway BC, not production BCs.

## Sufficiency check

- **One** falsifiable hypothesis per probe — not workflow + pricing + UI at once.
- A **pass/fail/learn threshold written before building** — "we'll know it when we see it" produces opinions, not truth.
- A **disposal date** — celebrate the jank, delete after learning; a probe that survives into production is scope creep.
- The probe tests the **harshest** truth cheaply, not the one most comfortable to build.
