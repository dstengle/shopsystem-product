---
name: company-research
description: Build a cited, bounded intelligence brief on a competitor, peer product, or alternative framework — strategy, product philosophy, recent moves — to ground a brief/PDR in external reality instead of intuition. Use for the consumer-product competitive/market input to problem discovery, or to study a competing framework.
---

# Company / Alternative Research (adapted, EXPERIMENTAL)

**Discipline 1 — Problem discovery & selection, consumer-fork market input**
(and a worked instance of the *deep-research-as-method* the determination
named). Adapted, with permission, from
`deanpeters/Product-Manager-Skills/skills/company-research`, by
[Dean Peters](https://www.linkedin.com/in/deanpeters/) — direct-grant terms
per [ADR-066](../../adrs/adr-066.md).
See [`../README.md`](../README.md).

## Why the PO reaches for this

Discipline 1's sufficiency for the competitive/market input is *"names at least
one concrete external reference point rather than asserting desirability in a
vacuum."* This skill produces that reference point: a **bounded, cited** profile
of how someone else solves the job — their strategy, product philosophy, recent
launches, and where they are heading — so the brief reflects reality, not a hunch.

## What to extract (and stop)

Pull only what changes a product decision, each **attributed and dated**:

- **Overview** — who they are, the job they serve, scale.
- **Strategy & product philosophy** — the principles that drive their decisions
  (from exec interviews, engineering/product blogs, earnings calls — not the
  "About" page).
- **Recent moves** — launches and shifts in the last ~12–24 months; older signal
  is usually stale.
- **Where they are heading** — stated direction and the threats they name.
- **Takeaways for us** — the specific implication for our problem/opportunity.

## Lands in our artifacts

- The profile becomes the **market/competitive context section of the product
  brief**, and the cited "options considered" rationale of a PDR.
- A takeaway that reveals an **unserved job** loops straight back into
  `jobs-to-be-done` / `opportunity-solution-tree` as a new opportunity.
- It does not produce scenarios; it changes *which* problems are worth pinning.

## Product-general fork (this is the fork's sharpest case)

- **Consumer product (primary):** the subject is a **competitor company** or the
  alternative the user "hires" today. Full market-facing use — positioning,
  differentiation, segment gaps.
- **Framework-as-product (this repo, meta):** the subject is a **competing
  framework or approach** (other agentic / shop-system / spec-driven-development
  tooling). "Market" is the landscape of how others coordinate AI engineering;
  the takeaway is what shopsystem must do *differently or better*. Lighter than
  the consumer case, but not absent — the determination flagged this fork
  explicitly.

## Posture (bounded + cited; COMMIT-TO-SPECIFICS)

Two failure modes this skill must not hit, both from Discipline 3's deep-research
sufficiency (*bounded + cited*):

- **Unbounded** — name the question the research answers and **stop when it is
  answered**. No "research forever."
- **Uncited** — every claim that informs a decision carries a source and date.
  "I looked into it" is not evidence.

Where a finding can't be sourced, mark it `unverified` and commit the decision
without leaning on it, rather than stalling. Use the `deep-research` harness for
anything broad enough to warrant fan-out and adversarial verification.

## Sufficiency check

- At least one **concrete, cited external reference point** informs the brief —
  not desirability asserted in a vacuum.
- The research is **bounded**: a stated question, and a stop.
- Every decision-bearing claim is **attributed and dated**; stale (>~24mo) signal
  is flagged as such.
