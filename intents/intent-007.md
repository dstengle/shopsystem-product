---
type: intent-record
id: intent-007
title: The knowledge/schema system's full precondition chain must actually hold, not just its individual pieces
status: recorded
created: 2026-07-16
updated: 2026-07-16
authors: [dstengle, "Claude (acting lead-pm)"]
description: Stakeholder intent to enumerate and close every precondition the knowledge/schema/progressive-disclosure system depends on to actually function, after investigation showed most of them silently unmet even though individual pieces (the CLI, the generator) work correctly in isolation.
stakeholder: dstengle
session: sess-2026-07-16-a
superseded-by:
beads: []
---

# intent-007 — The knowledge/schema system's full precondition chain

## Verbatim anchors

2026-07-16: "Put it this way, what are all of the necessary preconditions
for the knowledge and schema system to work properly? Templates in the
lead, skills that don't skip schema checks, skills that use the templates
properly, etc. Knowledge was supposed to add a gate as well."

2026-07-16 (immediately prior, motivating the question): "Before we do
that, I'm concerned that adr/048-... doesn't look right to me. It doesn't
have properly formatted front-matter. Does it pass the schema checker? If
so, the schema checker has bugs."

## The goal behind the ask

Checking a single file (`ADR-048`) against the schema validator surfaced
that the validator itself works correctly, but that finding only mattered
because it prompted checking the *system around* the validator — and
every other link in that system turned out to be broken or unwired. The
stakeholder's question reframes the problem: individual pieces passing
their own test in isolation (the CLI validates a file correctly; the
generator emits a template that matches its own typedef) says nothing
about whether the system as a whole does what it was built for. This
intent asks for the full dependency chain, checked end to end, not
piece by piece.

Ten links were checked directly against this repo's live state in the
same session (cited in `cand-005`'s Evidence, not restated here). One
holds. The rest are broken, unwired, or never built:

- The typedefs for `candidate`/`intent-record`/`session-record` generate
  templates that share almost no structure with any real instance ever
  authored (`lead-6n4j6`).
- None of this repo's 8 poured PM skills reference `shop-knowledge` at
  all — the wiring that's supposed to add this (`lead-5msa9.2`) landed on
  shop-templates' `main` branch but was never re-poured here.
- The installed `shop-templates` package (`0.52.6`) predates that fix,
  which is merged but unreleased (tracked at `lead-jqew9`).
- This repo's actual skill files were last fully re-rendered from
  `v0.51.0` (2026-07-10) — two releases behind, independent of the
  release-gap above.
- No CI, pre-commit hook, or `bin/doctor` exists in this repo to block a
  non-conforming commit — none was stopped when four were made this same
  session.
- The cross-artifact coherence gate PDR-032 scoped (link resolution,
  bidirectional supersession, `incorporates`-claims, lifecycle
  conditions — "gate rules 4-8") was never built; `shop-knowledge`
  exposes only `template`/`schema`/`validate`, none of which touch the
  cross-artifact graph. This is almost certainly the "gate" the
  stakeholder recalls being promised.

## Who it serves

The product authority, and every future PM/PO/Architect session or piece
of retrieval/citation tooling (`intent-004`) that assumes the schema
system is load-bearing infrastructure rather than a set of individually-
working but disconnected parts.

## Constraints

- Must sequence correctly: migrating the legacy corpus onto a typedef
  that doesn't match established practice (`cand-004`/PDR-034, already
  drafted) would just add an eleventh broken link. That migration is now
  understood to be the *last* step of this chain, not an independent
  first step.
- Whether the typedef should be fixed to match practice, or practice
  restructured to match the typedef, is not decided here — Architect
  feasibility input needed on which direction is actually cheaper/safer,
  though the evidence (five independently-authored instances agreeing
  with each other and disagreeing with the typedef) leans toward the
  typedef being the actual defect.
- Reconciles with `intent-004` (retrieval/citation-provenance) and
  `intent-006`/`cand-004` (legacy migration, now a downstream phase of
  this) rather than duplicating either.

## Non-goals

- Redesigning the six-type schema's fields/lifecycle semantics from
  scratch — the goal is making the existing design actually hold, not
  re-opening what it should be.
- Building new retrieval/citation tooling on top of a working system —
  that stays `intent-004`'s territory, unblocked by this but not built
  here.

## Appetite signal

Not stated — larger scope than originally assumed when `cand-004` was
shaped. Appetite (full chain now vs. phased with explicit deferred
phases) to be set at candidate shaping / PDR ratification.

## Failure conditions

- Treating each precondition as independently fixable without checking
  whether fixing it actually closes the chain end to end (the same
  failure mode that let the CLI, the generator, and the drift-gate each
  ship "working" while the system around them still didn't function).
- Proceeding with `cand-004`/PDR-034's legacy migration before the
  typedef and skill-wiring layers it depends on are actually fixed.

## Open threads

- Full 5-phase appetite vs. a smaller first commitment (e.g. typedef fix
  + repour only, deferring the coherence-gate build and legacy migration
  as named follow-ons) — for candidate shaping / PDR ratification.
- Which direction reconciles the typedef-vs-practice gap — Architect
  feasibility input needed, not decided here.
