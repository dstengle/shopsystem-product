---
type: intent-record
id: intent-009
title: The artifact corpus needs programmatic access — navigate, render (with view filtering), and query the frontmatter graph
status: recorded
created: 2026-07-25
updated: 2026-07-25
authors: [dstengle, "Claude (lead-pm)"]
description: "The two-views requirement is only real if a reader can obtain each view mechanically: navigate the materialized frontmatter graph, render a document filtered to the current-system view (accepted content sections, changelog dropped) or the full transformation view, and query the corpus by frontmatter. Today none of that exists as tooling. This folds the restructuring's slices #5 (navigation), #6 (rendering with section filtering), and #7 (query by frontmatter) into one programmatic-access capability sharing a single CLI."
stakeholder: dstengle
session: sess-2026-07-25-a
superseded-by:
beads: [lead-vy38p, lead-jk8j4, lead-81ulx]
---

# intent-009 — programmatic access to the artifact frontmatter graph

## Verbatim anchors

- 2026-07-20 (dstengle, `sess-2026-07-20-a`): the two-views principle — the
  accepted set is the current-system view (self-contained), the supersede chains
  are the transformation view, reachable but never required.
- `drafts/artifact-system-restructuring.md` (2026-07-20 shaping): "Open slicing
  calls: whether #5–7 stay three intents or fold into one 'programmatic access'
  intent" — and #7 "shares the CLI with 5, 6."

## The goal behind the ask

The two-views requirement (intent-008 / pdr-035) is only real if a reader can
*obtain* each view mechanically rather than by hand-filtering frontmatter. That
means three tightly-coupled capabilities over one corpus, sharing one CLI:

- **Navigate** the graph — follow the materialized edges (supersedes, derives,
  references and their back-edges) from any document.
- **Render** a document with section filtering — the current-system view
  (accepted content sections, changelog and transformation material dropped) or
  the full transformation view.
- **Query** by frontmatter — select documents by type, status, tag, distribution,
  or edge, returning a compact list or rendered documents.

## Who it serves

The product authority and the operating roles (PM/PO/Architect) who need to read
the current-system view without replaying history, and any tool or gate that
consumes the graph. It is the payoff of the whole restructuring: the two views
become usable, not just declared.

## Constraints

- **Needs slice #1** (the two-views requirement) for its semantics and **slice #2**
  (the materialized edge schema) for the graph it traverses — so its *mechanism*
  is drafted after #2, though its *need* stands on #1.
- One shared CLI surface across the three capabilities (no three divergent tools).
- Read-only over the corpus — navigation/render/query never mutate artifacts.

## Non-goals

- The gate's edge *maintenance* (that is slice #2's schema mechanism, not this
  read-side tooling).
- Authoring/writing skills (slice #4).
- Any per-artifact schema decision (slice #3).

## Appetite signal

Moderate: one CLI with three read verbs over the frontmatter graph, outputs in
md/json/yaml. Not a UI, not a service.

## Failure conditions

- The three capabilities fragment into separate divergent tools instead of one
  CLI.
- Rendering leaks transformation-view material (superseded content, changelog)
  into the current-system view — defeating the self-containment requirement it
  exists to serve.

## Open threads

- **Fold decision (flagged for the product authority):** this record folds the
  draft's separate slices #5/#6/#7 into one programmatic-access capability. If the
  authority prefers three standalone slices, this intent re-splits — the fold is
  the router's autonomous call under the draft's explicit "open slicing" latitude,
  not a ratified decision.
