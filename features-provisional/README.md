# features-provisional/ — parked scenario sets (NOT in the aggregate gate)

Under the **lead-holds-all** feature-ownership model (David 2026-07-04), the
lead holds ALL features as conformant, tagged `.feature` files under
`features/`. The sets below remain here as **`.gherkin` (pre-schema)** because
they cannot yet be tagged conformantly to the ADR-056 three-dimension schema
(`@bc` + `@origin` feature-level + per-scenario `@scenario_hash`). They are
deliberately kept OUT of `features/` so `scenarios validate --aggregate` stays
green (the aggregate gate scans only `features/`).

## devcontainer/ (17 scenarios) — @bc OK, @origin UNRESOLVED
- `@bc:shopsystem-devcontainer` is legal (provisional manifest entry, deferred
  to the DDD review **lead-bh2m**). Each file already carries `@bc` + a
  reproduced `@scenario_hash`.
- **Blocker:** no durable `@origin` decision record. The devcontainer BC (image
  + framework-CLI-on-PATH + CI publish workflow) has no dedicated ADR/brief;
  the scenarios were authored under lead beads (lead-5fd / lead-sbp), which is
  a weak provenance for a permanent `@origin`. Left provisional pending a
  devcontainer ADR/brief (candidate home: the DDD review **lead-bh2m**).

## docs/ (5 scenarios) — no legal @bc
- References a `shopsystem-docs` BC that is **not in `bc-manifest.yaml`**, so
  there is no legal `@bc` owner token. Provenance would be
  `brief-007-end-user-adoption-documentation`, but without a manifest-registered
  owner the scenarios cannot be tagged conformantly. Left provisional pending a
  manifest decision on a docs BC (DDD review **lead-bh2m**).

## Migrated OUT of this directory (now conformant in features/)
- `dagger-ci/` → `features/dagger-ci/*.feature` — `@bc:shopsystem-bc-launcher`,
  `@origin:adr-052..055` (01→052, 02→053, 03→054, 04→055). bc-launcher-owned but
  productionization (**lead-fzxt**) incomplete, so NOT in the bc-launcher repo;
  held here in the lead. All 4 hashes reproduced 1:1.
- `test-harness/` → `features/test-harness/shop_test_harness.feature` —
  `@bc:shopsystem-test-harness`, `@origin:adr-002` (harness BC introduction).
  All 5 hashes reproduced 1:1.
