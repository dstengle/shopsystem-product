# Rebaseline migration branch — session primer

This is the `rebaseline` branch: the greenfield tree of the
shopsystem-product migration, seeded 2026-08-22 under the approved
migration plan. Nothing exists here except through an explicit import
step; nothing from the old corpus is read here except through the
curated feed.

## Governing instruments

- `basis/` on this branch — the definition corpus. Every activity here
  operates through these definitions; the index is
  [`basis/README.md`](../../basis/README.md).
- The migration plan: `main:drafts/migration-plan.md` (read via
  `git show`; reference only) — phases, entry conditions, action table.
- The frozen corpus: `main` — the BC shops' contract of record until
  cut-over, and the pre-migration reference. Never copy from it outside
  an import step or the curated feed. The branch pulls from `main`;
  `main` never publishes to the branch.

## Current state

Seed and Phase 0 are complete: both principle sets stand approved.
Phase 1 is open, meta-chains first — complete the role-definition and
process-definition chains (a quality guideline and fitness set for
each; only their typedefs exist) with the existing basis processes as
exemplars, before authoring the PM/PO/Architect definitions.

## Operating rules

- The shop is frozen: no dispatches, no mailbox work; BC responses
  queue on `main`'s infrastructure until post-migration.
- Work proceeds by phase: Phase 0 (architecture principles) → Phase 1
  (meta-chains, then PM/PO/Architect definitions) → Phase 2
  (progressive disclosure as the first feature) → Phase 3 (demand-pull
  corpus migration, one discovery interview per feature).
- The product authority decides at every chain-and-exemplar step and
  phase exit; deliveries to the authority longer than ~300 words go
  through the `stakeholder-presentation` process — no exceptions.
- Decisions are applied as changes to the affected definitions and
  recorded in their Document History; no decision ledger exists, and no
  document cites one as authority.
- Session close: work is not done until `git push` succeeds on this
  branch.
