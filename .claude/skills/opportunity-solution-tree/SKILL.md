---
name: opportunity-solution-tree
description: Move from a target outcome down through opportunities (problems) to candidate solutions to a chosen bet, so shaping commits the candidate to the right problem before it converges on a sketch. Reach for it when a request arrives outcome-shaped or solution-shaped and you need to keep "what are we moving?" upstream of "what do we build?"
---

# Opportunity Solution Tree (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** shaping · **Emits into:** candidate (`candidates/cand-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `shaping` PM session; its output lands in the candidate (problem / appetite / solution-sketch / rabbit-holes / no-gos / evidence). No terminal artifact of its own.

*Adapted, with permission, from [`deanpeters/Product-Manager-Skills/skills/opportunity-solution-tree`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/opportunity-solution-tree) by [Dean Peters](https://www.linkedin.com/in/deanpeters/) — fetched live 2026-07-10, direct-grant terms per [ADR-066](../../adrs/adr-066.md). Adaptation rules + experimental status: [`../README.md`](../README.md).*

## Why reach for this in shaping

It keeps "what outcome are we moving?" upstream of "what do we build?". It forces **divergence before convergence** — explore multiple opportunities and multiple solutions before picking one — which is exactly the discipline the build trap erodes when shipping is cheap. In shaping terms, the tree is how you earn the candidate's **solution sketch** honestly instead of pasting in the first idea.

## The tree

```
            Desired Outcome            (1 — measurable change in behavior)
                  |
       +----------+----------+
   Opportunity Opportunity Opportunity (≥3 — problems, NOT solutions)
       |          |          |
     S S S      S S S      S S S       (≥3 solutions each — divergent)
                  |
              Chosen bet                (1 — carries a hypothesis + success signal)
```

- **Outcome** — a measurable behavior change, not "improve UX". Every downstream item is accountable to it.
- **Opportunities** — customer **problems/needs**, phrased as problems ("users don't reach value in the trial"), never solutions in disguise ("we need a checklist").
- **Solutions** — at least three per opportunity, to force real divergence.
- **Chosen bet** — the one to pursue first, carrying a **hypothesis** ("if we [bet], then [outcome] moves X→Y, because [reason]") and a **success signal**.

## Where it lands in the candidate

- **Outcome → problem.** The measurable outcome sharpens the candidate's *problem* statement (and the appetite it justifies).
- **Chosen bet → solution sketch.** The bet — at breadboard/fat-marker altitude — becomes the candidate's *solution sketch*; the hypothesis + success signal become the candidate's *evidence* line the shape is judged against.
- **Rejected branches → no-gos / rabbit-holes.** Opportunities and solutions you weighed and dropped are recorded, not discarded — the legible "we considered and did not build X" that prevents re-litigation and marks explicit *no-gos*.

## PM mode is interactive — run the loop, do not batch it

This is a `shaping` lens, and shaping is a live dialogue with the product authority. Build the tree **with** them: propose the outcome and get it confirmed or corrected; surface candidate opportunities and let them add/kill; diverge solutions out loud before converging. Do not collapse to a single silent "here's the committed bet" move — the divergence has to actually happen in the room. Where the outcome is a genuine strategy call, that is a real question to put to the authority, not an assumption to bury.

## Build is ~free, so the gate is the whole point

The source ends each solution in a costly experiment because for humans, building to learn is expensive. Here the BC fleet can often just build it — which makes the hypothesis *more* important, not less. "Build all three and see" is the build trap in a lab coat. Still state the hypothesis and success signal **before** the sketch lands in the candidate, so what comes back is judged against an outcome rather than admired as output. End by sharpening the shape: which bet is worth building, and which branches are explicit no-gos.

## Consumer / framework fork (inputs differ; tree is identical)

- **Consumer product (primary):** outcome = a customer/business metric (activation, retention, conversion); opportunities from user research; market fit is a real scoring axis.
- **Framework-as-product (this repo, meta):** outcome = an adoption / developer-experience metric (time-to-first-running-shop, contract clarity, fewer clarifies per dispatch); opportunities are adopter/operator problems; "market fit" = fit against how competing frameworks solve it.

## Sufficiency check

- The **outcome is measurable** — if you can't state X→Y, you have a theme, not an outcome.
- Every opportunity is a **problem**, not a solution in disguise.
- The chosen bet carries a **hypothesis and a success signal** before its sketch lands in the candidate (no signal = build trap).
- At least one opportunity and one solution were **explicitly rejected** — a one-branch tree is a foregone conclusion, not discovery.
