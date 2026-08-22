# Rebaseline migration branch — session primer

This is the `rebaseline` branch: the greenfield tree of the
shopsystem-product migration, seeded 2026-08-22 under the approved
migration plan. Nothing exists here except through an explicit import
step; nothing from the old corpus is read here except through the
curated feed.

## Governing instruments (all on frozen `main`, read via `git show`)

- The approved migration plan: `main:drafts/migration-plan.md`
  (rev 5, status executing) — phases, entry conditions, action table.
- The review record: `main:basis/records/review-new-basis.md` —
  the authority's ruling ledger (R1–R30) and the migration's State.
  Its single source is `main`; this branch carries no copy.
- The frozen corpus: `main` — the BC shops' contract of record until
  cut-over. Never copy from it outside an import step or the curated
  feed.

## What lives here

- `basis/` — the approved definition corpus: principles, typedefs,
  processes, glossary, fitness sets, guidelines, roles, compiled
  skills, tools. Every activity on this branch operates through these
  definitions.
- `.claude/` — this context surface, regenerated from the basis.

## Operating rules

- The shop is frozen (ruling R27): no dispatches, no mailbox work;
  BC responses queue on `main`'s infrastructure until post-migration.
- Work proceeds by phase per the plan: Phase 0 (principle-set chain,
  a `definition-chain-migration` run) → Phase 1 (meta-chains first —
  ruling R29 — then PM/PO/Architect definitions) → Phase 2
  (progressive disclosure as first feature) → Phase 3 (corpus runs,
  entered only after the authority's review).
- The product authority reviews at every chain-and-exemplar step and
  phase exit; deliveries to the authority longer than ~300 words go
  through the `stakeholder-presentation` process — no exceptions.
- Session close: work is not done until `git push` succeeds on this
  branch, and any ruling is recorded in the review record on `main`.
