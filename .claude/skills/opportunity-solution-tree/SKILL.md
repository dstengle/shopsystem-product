---
name: opportunity-solution-tree
description: Move from a target outcome to opportunities (problems) to candidate solutions to a chosen bet, so a PDR commits to the right problem before converging on a build. Use when turning a validated problem or a strategic outcome into a PDR, especially to avoid feature-factory convergence.
---

# Opportunity Solution Tree (adapted, EXPERIMENTAL)

**Discipline 1 — Problem discovery & selection** (bridges into Discipline 2,
outcome ownership). Adapted from
`deanpeters/Product-Manager-Skills/skills/opportunity-solution-tree` (Teresa
Torres, *Continuous Discovery Habits*). See [`../README.md`](../README.md).

## Why the PO reaches for this

It is the structure that keeps "what outcome are we moving?" upstream of "what
do we build?". It forces **divergence before convergence** — explore multiple
opportunities and multiple solutions before picking one — which is precisely the
discipline the build trap erodes when shipping is cheap.

## The tree

```
            Desired Outcome            (1 — measurable; Discipline 2)
                  |
       +----------+----------+
   Opportunity Opportunity Opportunity (≥3 — problems, NOT solutions)
       |          |          |
     S S S      S S S      S S S       (≥3 solutions each — divergent)
                  |
              Chosen bet                (1 — with hypothesis + success signal)
```

- **Outcome** — a measurable change in behavior, not "improve UX". This is the
  Discipline-2 anchor every downstream item is accountable to.
- **Opportunities** — customer **problems/needs**, phrased as problems ("users
  don't reach value in the trial"), never as solutions in disguise ("we need a
  checklist").
- **Solutions** — at least three per opportunity, to force real divergence.
- **Chosen bet** — the one to pursue first, each carrying a **hypothesis**
  ("if we [bet], then [outcome] moves from X to Y, because [reason]") and a
  **success signal**.

## Lands in our artifacts

- The tree **is the body of a PDR**: outcome → opportunities considered →
  solutions weighed → the chosen bet and why (this is the PDR's "options
  considered" + "decision", already our house structure).
- The chosen bet's **behavior** becomes the Gherkin scenarios (Discipline 4) that
  get dispatched. The **hypothesis + success signal** stay in the PDR as the
  outcome the work is accountable to.
- Rejected opportunities/solutions are recorded, not discarded — they are the
  legible "we considered and did not build X" that prevents re-litigation.

## The cheap-build adaptation (read this)

The source skill ends each solution in a costly experiment (A/B test, prototype,
50 trial users) because in a human shop, building to learn is expensive. Here it
often isn't — the BC fleet can just build it. **That does not remove the
hypothesis; it makes it more important.** The temptation when build is free is to
skip straight to "build all three and see" — that is the build trap wearing a
lab coat. Still state the hypothesis and the success signal *before* dispatch, so
that what comes back can be judged against an outcome rather than admired as
output. "Just build it and look" is permitted only when the build is genuinely
cheaper than the thinking *and* a success signal is still recorded.

## Product-general fork (inputs differ; tree is identical)

- **Consumer product (primary):** outcome = a customer/business metric
  (activation, retention, conversion); opportunities from user research; market
  fit is a real scoring axis.
- **Framework-as-product (this repo, meta):** outcome = an adoption / developer-
  experience metric (time-to-first-running-shop, contract clarity, fewer
  clarifies per dispatch); opportunities are adopter/operator problems; "market
  fit" = fit against how competing frameworks solve it.

## Posture (COMMIT-TO-SPECIFICS, not a workshop)

The source walks a human through Q1–Q5 with menu picks. You build the tree in one
move from the available evidence and **commit a chosen bet**, showing the
opportunities and solutions you weighed. Where the outcome itself is the
operator's call (a genuine strategy decision), surface that one as a `clarify`;
otherwise commit and proceed.

## Sufficiency check

- The **outcome is measurable** — if you can't state X→Y, you have a theme, not
  an outcome.
- Every opportunity is a **problem**, not a solution in disguise.
- The chosen bet carries a **hypothesis and a success signal** before any
  scenario is dispatched (no signal = build trap).
- At least one opportunity and one solution were **explicitly rejected** — a tree
  with one branch is a foregone conclusion, not discovery.
