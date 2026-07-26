---
type: candidate
id: cand-007
title: One read-only CLI over the frontmatter graph — navigate, render-with-view-filtering, query
status: committed
created: 2026-07-25
updated: 2026-07-25
authors: [dstengle, "Claude (lead-pm)"]
description: "Shape for the folded tooling slice (#5/#6/#7): a single read-only CLI over the artifact frontmatter graph with three verbs — navigate edges from a document, render a document filtered to the current-system or transformation view, and query the corpus by frontmatter — with outputs in md/json/yaml. Makes the two-views requirement obtainable mechanically."
derives-from: [intent-009]
session: sess-2026-07-25-a
experiments: []
brief:
parked-until:
beads: [lead-vy38p, lead-jk8j4, lead-81ulx]
---

# cand-007 — one read-only CLI over the frontmatter graph

## Verbatim anchors

- 2026-07-20 (dstengle): the two-views principle — accepted set = current view
  (self-contained); supersede chains = transformation view, reachable not
  required.
- `drafts/artifact-system-restructuring.md`: #5 navigation, #6 rendering with
  section filtering, #7 query by frontmatter — #7 "shares the CLI with 5, 6."

## Problem

The two-views requirement (pdr-035) is declared but not *obtainable*: there is no
tool that filters the corpus to the current-system view, follows the materialized
edges, or selects documents by frontmatter. A reader gets the current view only
by hand-reading `status` and manually dropping superseded/changelog material —
exactly the error-prone thing the requirement exists to eliminate. Without this,
the whole restructuring's payoff (two usable views over one corpus) stays
theoretical.

## Appetite

Moderate. One CLI, three read verbs over the frontmatter graph, outputs in
md/json/yaml. Not a UI, not a running service, not a write tool.

## Solution sketch

A single read-only command surface over the artifact corpus with three verbs, at
capability altitude:

- **Navigate** — from a given document, follow the materialized edges
  (supersedes/superseded-by, derives-from/derived-by, references/referenced-by)
  and return the neighbourhood as structured data.
- **Render with view filtering** — emit a document in either the
  **current-system view** (accepted content sections only; changelog and any
  transformation-view material dropped) or the **transformation view** (full,
  including supersede chains). The view selector is the `status` axis.
- **Query by frontmatter** — select documents by type, status, tag, distribution,
  or edge participation; return either a compact document list or the matching
  documents rendered with the same view filtering.

All three share one CLI and one corpus loader; each supports md/json/yaml output.
The tool is read-only — it never maintains or mutates edges (that is the gate's
job, slice #2).

## Rabbit holes

- **Re-implementing the loader.** The corpus loader already exists in the
  knowledge BC (used by the gate); this tooling must reuse it, not fork a second
  graph reader that can drift.
- **Rendering leaking transformation material** into the current view — the
  single most important correctness property; the filter must drop changelog and
  superseded content, not just hide `status`.
- **Query language scope creep.** Keep selection to frontmatter fields and edges;
  do not grow a general expression language.
- **Depends on slice #2's materialized edges** — navigation is only meaningful
  once back-edges are materialized; this slice's mechanism follows #2.

## No-gos

- No write/mutation of artifacts or edges (read-only).
- No UI, no long-running service.
- Not the gate's edge maintenance (slice #2), not writing skills (slice #4), not
  per-artifact schema (slice #3).
- No general query expression language beyond frontmatter/edge selection.

## Evidence / experiments

- Grounded in pdr-035's two-views requirement and the shaped tooling slices in
  `drafts/artifact-system-restructuring.md`.
- The knowledge BC already ships a corpus loader (the `shop-knowledge-gate`
  cross-artifact loader) — a bounded Architect pre-state check should confirm its
  reuse surface before the mechanism ADR converges. No probe run yet; flagged in
  the mechanism-ADR dispatch.
- No experiments.

## Resolution

**Shaped 2026-07-25** in `sess-2026-07-25-a`, deriving from `intent-009`. Folds
the draft's slices #5/#6/#7 into one programmatic-access capability (router's
autonomous call under the draft's explicit open-slicing latitude; flagged for the
product authority). Appetite, shape, boundaries, and rabbit holes pinned. The
*need* stands on slice #1; the *mechanism* ADR is dispatched after slice #2
(materialized edges) is drafted, since navigation traverses those edges. Ready for
the needs-PDR and, after #2, the mechanism ADR.

## Changelog

- 2026-07-25 opened and shaped in `sess-2026-07-25-a`, deriving from `intent-009`,
  folding restructuring slices #5/#6/#7 into one read-only frontmatter-graph CLI.
