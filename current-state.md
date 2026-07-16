---
# Lineage: arc42 living overview / Diátaxis Reference tier / the
# product fact sheet. The ONE document rewritten in place rather than
# superseded. Present-tense fact plus links; if a sentence explains
# WHY, it belongs in a decision record. Stewarded by the PM; the
# mechanical update obligation fires at decision acceptance via the
# `incorporates` gate. The README and site are outward renderings of
# this document — every capability claim there must anchor to an
# entry here.
type: current-state
id: current-state
title: shopsystem-product — current state
status: live
created: 2026-07-12
updated: 2026-07-12
authors: [dstengle, "Claude (lead-pm)"]
description: Living current-state fact sheet for shopsystem-product.
incorporates: [pdr-032, pdr-033, adr-059]   # every accepted PDR/ADR id; gate-checked
substrate:
  system: shopsystem
  bom-version: self
beads: []
---

# shopsystem-product — current state

shopsystem-product is the outward face of the shopsystem framework itself —
a lead shop that routes product intent into bounded contexts (BCs) rather
than building implementation code in place. Its stakeholders are the product
authority and the agents operating the shop; today it classifies each request,
authors intent as briefs, PDRs, and Gherkin scenarios, verifies BC pre-state
empirically against the contract surface, and dispatches work to BCs via
`shop-msg`. The BC-shop loop runs inside each BC container; the lead shop's
own move is reconciliation when `work_done` returns.

## Owned bounded contexts

<!-- Seed: no BC entries authored yet for this instance. One entry per BC
this product recognizes and builds, following the template entry shape below. -->

### <bc-canonical-name>

- **Does:** <one present-tense sentence.>
- **Interface:** <CLI / schema / image / API, with version line.>
- **Contract:** `features/<bc-name>/`
- **Shaped by:** <accepted decision ids — the same ids in `incorporates`.>
- **Status:** live | provisional | retiring

## Platform substrate

<!-- Seed: shopsystem components this product runs on but does not build,
at the pinned BOM version (`self` for the self-hosting instance). One line
each, no deep links. -->

- `<component>` @ <version> — <one clause: used for what.>

## System invariants

<!-- Seed: cross-cutting present-tense facts, each citing its decision. -->

- <invariant.> (<decision-id>)

## Lead shop

- **Name:** shopsystem-product
- **Product authority:** dstengle
- **Artifacts:** intent `intent/`, candidates `candidates/`,
  sessions `sessions/`, prioritizations `prioritizations/`,
  briefs `briefs/`, product decisions `pdr/`,
  architecture decisions `adr/`, findings `findings/`.
- **Artifact lifecycle:** documented in graph form at
  [`artifact-lifecycle.md`](artifact-lifecycle.md) (added 2026-07-16,
  `cand-005`) — cross-type flow plus per-type status lifecycle, marked
  pinned vs. observed-only.
