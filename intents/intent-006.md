---
type: intent-record
id: intent-006
title: Legacy corpus (brief/PDR/ADR) migrates into the typed artifact system
status: recorded
created: 2026-07-16
updated: 2026-07-16
authors: [dstengle, "Claude (acting lead-pm)"]
description: Stakeholder intent to close the appetite gap cand-001 deliberately deferred — migrate the legacy brief/PDR/ADR corpus into the typed YAML-frontmatter artifact system, since the resulting split-corpus inconsistency undermines the progressive-disclosure tooling the typed system exists to support.
stakeholder: dstengle
session: sess-2026-07-16-a
superseded-by:
beads: []
---

# intent-006 — Legacy corpus migrates into the typed artifact system

## Verbatim anchors

2026-07-16: "Wow, I don't remember the exclusion, given that this was meant
to fix consistency issues it doesn't make sense either. Let's get it all
fixed or the progressive disclosure tools will be pretty useless."

## The goal behind the ask

PDR-032 (ratified 2026-07-09, refined by ADR-059) introduced YAML
frontmatter and a typed schema for six artifact types (intent record,
candidate, session record, prioritization record, current-state, plus the
typedef/generator mechanism itself). `cand-001`'s own solution sketch
always named "migrated brief/PDR/ADR" as part of the eventual vision, but
its Rabbit holes explicitly deferred that migration ("own candidate"), and
PDR-032's own appetite line ratified the exclusion: "Explicitly OUT of
appetite: legacy corpus migration (prose-status → enum...)."

An overnight corpus-validation pass (brief-019/`lead-5msa9`, run via the
newly-shipped `shop-knowledge validate` CLI) empirically confirmed the
resulting state: ~97 legacy `adr/`/`pdr/`/`briefs/` files — including ones
authored this same week (brief-022, ADR-064, ADR-065) — carry zero
frontmatter and validate against no schema, while only the six newer types
do. On hearing this, the stakeholder does not recall endorsing a
*permanent* exclusion and observes it undermines the actual purpose of the
schema work: progressive-disclosure/retrieval tooling built on typed
metadata (`intent-004`'s theme) can only be as complete as the corpus it
indexes. A corpus where most of the historical decision record (ADRs,
PDRs, briefs) carries no queryable structure defeats that tooling for
exactly the material — architecture and product decisions — that most
needs disciplined retrieval.

## Who it serves

The product authority, and every future PM/PO/Architect session or
progressive-disclosure/citation tool (`intent-004`, `lead-x7bp`) whose
ability to reliably query or cite "what was decided and why" depends on
the *full* decision corpus carrying the same structured metadata, not
just the newest six types.

## Constraints

- **Content fidelity is non-negotiable.** These are historical decision
  records; migration may restructure or add metadata but must not alter
  or lose decision content.
- Migration mechanism (parsing ~90 files of varied legacy prose-status
  formatting) is a technical unknown — per the PM/Architect boundary,
  mechanism routes to an Architect feasibility probe, not decided at the
  PM altitude.
- Reconciles with, does not duplicate, `cand-001`'s original solution
  sketch (already named this migration as in-vision) and `intent-004`'s
  broader retrieval/citation-provenance theme.

## Non-goals

- Re-opening the six-type schema itself (field shapes, lifecycle enums)
  — already ratified by PDR-032/ADR-059.
- Building new retrieval/citation tooling (`intent-004`'s territory) —
  this closes the corpus-consistency precondition that tooling depends
  on; it does not build the tooling itself.

## Appetite signal

Stakeholder wants it "all fixed" — reads as full-corpus scope, not a
partial/sample migration. Batching/sequencing appetite not yet set — open
thread for candidate shaping.

## Failure conditions

- A migration that corrupts or silently reinterprets historical decision
  content in service of schema conformance.
- A partial migration that still leaves the corpus split across two
  conventions.

## Open threads

- Batching/sequencing: single pass vs. phased-with-checkpoints — for
  candidate shaping.
- Migration mechanism (scripted/mechanical vs. subagent-driven semantic
  migration vs. hybrid) — Architect feasibility probe, not decided here.
- Whether PDR-032's appetite line needs a formal supersession record, or
  a fresh PDR ratifying full-corpus appetite suffices — leaning the
  latter, per this repo's own supersession precedent (ADR-059
  REFINES/SUPERSEDES PDR-032).
