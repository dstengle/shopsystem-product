# ADR-003 — Ecommerce as the first real-domain instantiation

**Status:** draft (2026-05-11)
**Authors:** dstengle, Claude
**Depends on:** [ADR-001](001-framework-packaging.md), [ADR-002](002-harness-bc-introduction.md)

## Decision

Stand up an **ecommerce product** as the first non-toy consumer of the
shopsystem framework. Ecommerce was the original framing the framework
was extracted from (per ADR-001's provenance note); using it as the
validation target tests the framework against a domain it was implicitly
designed for, but never previously instantiated end-to-end.

The instantiation is staged:

| Stage | Scope | Validates |
|---|---|---|
| 1 (this ADR) | Lead shop + one BC | Framework round-trips with real product intent (not toy `bc-shop`/temperature) |
| 2 (future ADR) | Lead shop + two BCs with one cross-BC contract | Prototype-1 §8 #1 (multi-BC topology, cross-BC fan-out) |
| 3+ (future ADRs) | Add BCs as real use cases demand | Cumulative pressure on the framework |

Stage 1 is the work this ADR commits to. Stages 2+ are sequencing
intent, not commitments.

## Stage 1 — what gets built

A new lead-shop repo `ecommerce-product` and one BC-shop repo
`ecommerce-catalog`. Naming follows ADR-001's convention: no "shop"
suffix; org/product prefix carries the structural context.

**Why Catalog as the first BC**:

- It's the most self-contained ecommerce BC — products, descriptions,
  prices, availability flags. Doesn't depend on Cart, Checkout, or
  Customer.
- It has a clear customer-facing contract (the public product list /
  product detail). Real product intent has a natural home here.
- It surfaces no transactional or PII-sensitive concerns at stage 1,
  keeping the validation exercise unencumbered.

**What `ecommerce-product` (the lead shop) holds**:

- Product brief: a one-page statement of what the ecommerce product is
  for. Authored by the PO (the human driver in this stage).
- ADR-003 (this file, copied into the new repo): the architectural
  context for stage 1.
- Domain & Context Map skeleton: lists the Catalog subdomain and its
  BC. Stage 2 adds the second BC and the first cross-BC relationship.
- `pyproject.toml` consuming the three framework packages + the
  test-harness (per consumer-wiring.md).
- `features/catalog/`: the canonical Gherkin scenarios for the first
  Catalog slice.

**What `ecommerce-catalog` (the BC-shop) holds**:

- Code implementing whatever the first slice's scenarios pin
  (`src/ecommerce_catalog/`).
- A small CLI surface for the slice's behavior (we'll see what makes
  sense — possibly `catalog add`, `catalog list`).
- Step defs + a Gherkin runner.
- A `shop-card.yaml` declaring the BC's metadata.

## Stage 1 — the first slice

Pick **one** vertical slice of catalog behavior that exercises the
framework end-to-end:

> *"As a catalog operator, I can register a product with a name, price,
> and availability flag, and list all currently-available products."*

This yields ~3-5 scenarios:

1. Register a product with valid attributes; list shows it.
2. Register a product whose availability flag is false; list omits it.
3. Register two products; list returns them in stable order.
4. Listing an empty catalog returns no rows and exits 0.

The slice is mechanically uninteresting (the implementation is a list
in memory or a SQLite file). The validation is **the dispatch and
review loop**: lead shop PO authors → Architect dispatches via
`shop-msg send assign_scenarios` → BC Implementer adds CLI + step
defs → BC Reviewer probes → work_done → reconciliation. If this loop
runs cleanly against real product intent (not framework-internal
backfill), Stage 1 has succeeded.

## What this validates that prior work didn't

Everything to date has been **framework-internal** — the lead shop's
work item was always to extend or pin the framework itself. Stage 1 is
the first time real product intent flows through the framework's
mechanisms. The risks Stage 1 exposes:

- **Brief-to-scenarios gap.** The PO has to translate a real product
  brief into Gherkin without the prior "the implementation already
  exists" anchor. Whether the lead-po role template is sufficient for
  this is unvalidated.
- **Architect choices on a clean slate.** The Architect picks which
  scenarios to assign in which order. No existing BC test layer is
  there to anchor pre-state. The lead-architect template's
  message-type discriminator hasn't been exercised on a virgin BC.
- **BC implementer creativity.** The implementer must invent code, not
  just pin existing behavior. Sufficiency check #4 ("does BC already
  implement this?") returns NO genuinely for the first time outside
  the harness slice.

## Stage 1 — sequence

1. Author this ADR (draft, this commit).
2. Create `ecommerce-product` GitHub repo. README + LICENSE +
   `pyproject.toml` + `bd init`. Set up beads remote
   `ecommerce-product-beads` (private).
3. Author a one-page product brief at `ecommerce-product/brief.md`
   (PO role; human-driven).
4. Create `ecommerce-catalog` GitHub repo. Same scaffolding. Beads
   remote.
5. Use the test harness (`shop-test-harness bootstrap`) to validate
   the inter-shop wiring works in an isolated topology before
   committing the production directories.
6. Lead PO authors 3-5 scenarios for the first slice.
7. Lead Architect dispatches `assign_scenarios` to `ecommerce-catalog`.
8. BC Implementer implements + Reviewer gates.
9. Reconcile; record findings in `ecommerce-product/findings/`.

## What this defers

- **Stage 2+ BCs**. Cart, Checkout, Customer, Inventory — all out of
  scope until Stage 1 closes.
- **Persistent storage choices**. Whether the catalog BC backs to
  SQLite, Postgres, an in-memory store, or something else is a Stage
  1 implementation detail and may be reconsidered each slice.
- **HTTP / API surface**. Stage 1 uses CLI subcommands. A web API
  surface (and the BC that owns it) is a future concern.
- **Real users**. The PO and Architect for Stage 1 are the human
  driver. No actual ecommerce stakeholders are interviewed at this
  stage. Stage 1's purpose is framework validation, not market
  validation.

## Open questions

1. **Should the first slice be `catalog add` + `catalog list`, or
   should it be the read-only "list available products" half only?**
   Going read-only-first keeps the slice smaller. Going write+read
   exercises a fuller round-trip but risks scope creep.
2. **Where does the ecommerce-product lead shop's brief come from?**
   The framework assumes stakeholder intent. With no real stakeholder,
   the PO writes a brief that's plausible but not externally
   anchored. Is this still a meaningful validation of the
   brief-to-scenarios path?
3. **Do we name `ecommerce-product`'s GitHub org under `dstengle`
   alongside `shopsystem-*`, or in a different org?** Naming
   convention (ADR-001) makes this cosmetic; the question is whether
   the visual coupling is helpful or noisy.

## What we'd learn from Stage 1

A small number of *generative* findings would justify Stage 1
regardless of whether the catalog behavior is interesting:

- Whether the lead-po template handles a virgin brief or if it needs
  template additions for "first slice from a blank brief."
- Whether the message-type discriminator (`assign_scenarios` vs
  `request_bugfix` vs `request_maintenance`) is intuitive for the
  Architect when no BC code exists.
- Whether the harness's `bootstrap/freeze/verify` actually helps an
  experiment-level validation, or is over-/under-scoped for real
  product work.
- Whether the dogfooding hash-flow (lead beads ID → scenario hash →
  work_done → reconciliation) works the same when production code is
  on the other end.

If any of those reveals a real gap, ADR-004 captures the response.
