---
type: candidate
id: cand-004
title: Migrate the legacy brief/PDR/ADR corpus into the typed artifact system
status: shaped
created: 2026-07-16
updated: 2026-07-16
authors: [dstengle, "Claude (acting lead-pm)"]
description: Shaped candidate closing the appetite gap cand-001 deliberately deferred — bring the ~90-file legacy brief/PDR/ADR corpus onto the same YAML-frontmatter typed schema PDR-032/ADR-059 already gave the newer six artifact types, so progressive-disclosure/retrieval tooling has one consistent corpus to index instead of two.
derives-from: [intent-006]
session: sess-2026-07-16-a
experiments: []
brief:
parked-until:
beads: []
---

# cand-004 — Migrate the legacy brief/PDR/ADR corpus into the typed system

## Problem

`cand-001` shaped the six-type artifact system (intent record, candidate,
session record, prioritization record, current-state, typedef/generator)
and named "migrated brief/PDR/ADR" in its own solution sketch as part of
the eventual vision — but explicitly deferred that migration to "its own
candidate," and PDR-032's ratified appetite line locked the exclusion in:
"Explicitly OUT of appetite: legacy corpus migration (prose-status →
enum...)."

That exclusion has now sat unrevisited since 2026-07-09. An overnight
corpus-validation pass (brief-019/`lead-5msa9`, using the newly-shipped
`shop-knowledge validate` CLI) confirmed its concrete effect: ~97 legacy
`adr/`/`pdr/`/`briefs/` files — including several authored this same
week — carry no frontmatter and validate against no schema, while only
the six newer types do. Two consequences, both undermining the schema
work's own stated purpose (`intent-006`):

- Any retrieval/progressive-disclosure tool built to query typed metadata
  can only see six of the corpus's artifact families; the historical
  decision record most worth citing reliably (ADRs, PDRs, product briefs)
  is invisible to it.
- The corpus now carries two conventions side by side with no unifying
  plan, which is itself a coherence-gate gap the whole schema effort was
  meant to close.

## Appetite

**Full corpus, in scope — batching/sequencing open.** The stakeholder's
own framing ("let's get it all fixed") reads as full scope, not a sample
or partial pass. What's still open is *how* the ~90 files get there: in
one pass, or in verified batches. That's the one decision this candidate
surfaces for the deciding conversation rather than assuming.

## Solution sketch

Bring `brief/`, `pdr/`, and `adr/` onto the same typed-schema mechanism
ADR-059 already built for the six newer types (per-type `typedef/*.yaml`
→ generated template + JSON Schema fragment, drift-checked). Concretely:

- Each legacy file gains YAML frontmatter (`type`, `id`, `status` as an
  enum rather than free prose, `authors`, `created`/`updated`, and
  whatever typed-link fields the type needs — `supersedes`/`refined-by`
  for ADR/PDR, `derives-from` for briefs where applicable).
- Existing decision *content* (the prose body) is preserved verbatim;
  only the status/metadata header changes shape. This is a metadata
  migration, not a rewrite of historical judgment.
- Where a changelog is required by the new schema but the legacy file has
  none, one is backfilled from git history (`git log` on the file) rather
  than invented.
- Runs through the same `shop-knowledge validate` gate used tonight to
  confirm conformance, file by file or batch by batch depending on the
  sequencing decision below.

**Mechanism is an open technical question, not decided here.** Per the
PM/Architect boundary (`intent-006`'s own Constraints), whether this is
best done as a scripted/mechanical pass, a subagent-driven semantic
migration per file, or a hybrid (script for the mechanical majority,
subagent judgment only where the gate flags an edge case) is an Architect
feasibility probe, not a PM-altitude decision.

## Rabbit holes

- **Fidelity risk at scale.** ~90 files, several with inconsistent legacy
  formatting (bold-label conventions have drifted slightly since
  2026-05). A single mechanical pass risks silent misparses; the
  sequencing decision below exists specifically to bound this risk.
- **Whether PDR-032 needs a formal supersession record**, or whether a
  fresh PDR ratifying full-corpus appetite is sufficient on its own,
  citing PDR-032/ADR-059 as the schema it extends coverage of rather than
  changes. Leaning the latter — matches the ADR-059-refines-PDR-032
  precedent already in this corpus — but not decided here.
- **Changelog backfill quality.** Reconstructing a changelog from git
  history for files that never had one is lossy (commit messages aren't
  always decision-grade prose); worth flagging as a known limitation
  rather than presenting backfilled changelogs as equivalent to
  originally-authored ones.

## No-gos

Re-opening the six-type schema itself (field shapes, lifecycle enums) —
already ratified. Building new retrieval/citation tooling on top of the
now-consistent corpus — that's `intent-004`'s territory, a distinct
follow-on this candidate unblocks but does not itself build.

## Evidence / experiments

**2026-07-16 — corpus-validation pass** (brief-019/`lead-5msa9`, same-day
evidence, not re-probed): `shop-knowledge validate` run against all 129
files in `adr/`, `pdr/`, `briefs/`, `candidates/`, `sessions/`, `intent/`,
`current-state.md` — 129/129 failed, but as two populations: ~97 legacy
files with zero frontmatter (this candidate's target), and 13 correctly-
typed newer files that instead diverge from the generated typedef itself
(a separate, already-filed finding, `lead-6n4j6` — not this candidate's
problem).

## Resolution

(open — awaiting sequencing decision and PDR ratification)

## Changelog

- 2026-07-16 opened and shaped in `sess-2026-07-16-a`, deriving from
  `intent-006`, in direct response to the stakeholder reopening
  `cand-001`'s deferred appetite exclusion after seeing tonight's
  corpus-validation results.
