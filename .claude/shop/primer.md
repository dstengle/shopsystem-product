# Rebaseline migration branch — session primer

The product is the **shopsystem**: the system by which a lead shop
and its Bounded Context shops — agent-run execution units — take a
problem from discovery to verified, running software; it is built by
the same kind of shops it defines, and this repository is its lead
shop. For whom: the people who stand up and run products on it — a
product authority who frames and bets, and the builders and operators
who meet the work through its interaction types. The shop's operating
process is
[product-flow](../../basis/processes/product-flow.md): discovery →
initiative check and bet → backlog ordering → feature authoring →
scenario assignment, each stage a defined sub-process with its own
check.

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
Phase 1: the meta-chains, the four lead-shop roles, the ask mechanism
(held-and-resumed only), and the experience guidance corpus stand
approved. The product flow is defined end to end and approved by
batch under brief-032: `discovery-conversation` (brainstorm,
interview, or review of evidence; frames the initiative) →
`initiative-check` (attach, screen as check of record, the
authority's bet) → `backlog-ordering` → `feature-authoring` (the PO
authors alone; designer criteria and architect constraints ride the
scenarios) → `po-output-check` (activates the initiative on the first
pass) → `scenario-assignment` (repository sweep, `assign_scenarios`
only), with `product-flow` as the top level. The initiative, feature,
backlog-order, and product-decision-record chains are approved. Open:
the reconcile-side amendments (the initiative's `completed` state,
the product changelog, the roadmap, the `router` role); the scenario
register — a feature to be built by integrating the work on `main`;
the designer role's corpus records (vocabulary, patterns, tokens;
core tasks stand as hypotheses); brief-030's role-definition typedef
amendment and the 38-skill import plan.

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
