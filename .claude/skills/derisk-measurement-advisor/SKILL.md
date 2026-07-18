---
name: derisk-measurement-advisor
description: Scan a shaping candidate for risk across 10 dimensions — 4 internal (Desirability, Usability, Feasibility, Viability) and 6 external (PESTEL) — and triage each into act-now or track, so the candidate's rabbit-holes and risks name what to test before committing. Reach for it when a bet feels roadmap-ready and you want a structured "what could go wrong, internally and externally?"
---

# De-Risk Measurement Advisor (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** shaping · **Emits into:** candidate (`candidates/cand-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `shaping` PM session; its output lands in the candidate (problem / appetite / solution-sketch / rabbit-holes / no-gos / evidence). No terminal artifact of its own.

*Adapted, with permission, from [`deanpeters/Product-Manager-Skills/skills/derisk-measurement-advisor`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/derisk-measurement-advisor) by [Dean Peters](https://www.linkedin.com/in/deanpeters/) — fetched live 2026-07-10, direct-grant terms per [ADR-066](../../adr/066-direct-grant-from-dean-peters-authorizes-mit-ingestion-of-deanpeters-derived-pm-skills-attribution-required.md). Adaptation rules + experimental status: [`../README.md`](../README.md).*

## What this scans

A guided risk scan tied to *this* candidate, not a generic checklist. It asks two questions most shaping skips one of — **will the product itself work?** (internal) and **will the world let it work?** (external) — then triages every surfaced risk into **act now** or **track**. The question underneath: *is the orange worth the squeeze?*

## Two lenses, ten dimensions

**Internal — DUFV** (Cagan's four product risks):

| Category | Dimension | Core question |
|---|---|---|
| Product outcome | Desirability | Will customers value it enough to want it? |
| Product outcome | Usability | Can they figure out how to use it? |
| Business outcome | Feasibility | Can we build and sustain it at scale? |
| Business outcome | Viability | Does it work as a business / for the org? |

**External — PESTEL** (forces outside the org): **P**olitical, **E**conomic, **S**ocial, **T**echnological, **E**nvironmental, **L**egal. Market conditions don't just change — they change *us*; PESTEL is how you categorize and respond, not just observe.

## The act / track triage

Every risk gets one label:

- **Act now** — present, material, needs a response before committing: run a test, change the plan, close a gap.
- **Track** — real but not yet urgent: set a trigger threshold and a review cadence, then move on.

Anti-pattern: labeling everything "act now." If every risk is urgent, none are prioritized — force roughly a 40/60 act/track split.

## Where it lands in the candidate

- **Act-now risks → rabbit-holes / risks**, each with a concrete first step (who tests what, by when, how you'll know it's addressed). The highest-value act-now items are exactly what [`pol-probe-advisor`](../pol-probe-advisor/SKILL.md) then turns into probes on the candidate's **evidence** line.
- **Track risks → risks (watch list)**, each with a signal and a cadence.
- A dimension that would sink the bet is a candidate **no-go** until answered.
- The scan also pressure-tests **appetite**: a pile of unresolved act-now risk means the appetite is too small for the shape as drawn.

## PM mode is interactive — run the scan with the authority

This runs inside a live `shaping` dialogue. Open with the four context questions (idea, stage, primary concern, customer role), then walk the dimensions — offering context-specific candidate risks and asking, per risk, *act or track?* — one turn at a time. Do not batch-emit a finished register; the triage judgments are the authority's to make. Low-impact categories (often Environmental for software) get a quick "minimal" and you move on — but you still ask.

## Build is ~free, so the gate is the whole point

Cheap builds make it tempting to commit before scanning — and then a regulation, a platform dependency, or an unvalidated desirability gap kills the shape after the fleet already built it. The scan is the gate: both lenses, every time. End by sharpening the shape — the act-now risks that must be retired before this bet is worth building, and the ones that make it an explicit no-go for now.

## Consumer / framework fork (both lenses either way; inputs differ)

- **Consumer product (primary):** DUFV against end-customers and a real market; PESTEL against real regulation, funding, and social sentiment.
- **Framework-as-product (this repo, meta):** Desirability/Usability = will adopters/operators want and understand it; Feasibility/Viability = can the fleet build and sustain it; "PESTEL" reads as the ecosystem around the framework — competing frameworks (Technological), tooling/license shifts (Legal), community sentiment (Social).

## Sufficiency check

- **Both** lenses scanned — internal *and* external; skipping one is the blind spot this skill exists to close.
- Every risk names a **specific** test or signal for *this* candidate — "desirability is a risk" is not a risk.
- The split is genuinely **act vs. track**, roughly 40/60 — not everything urgent.
- Every act-now item has a **concrete first step**, not "run a test" — otherwise it's risk theater.
