---
id: PDR-025
kind: pdr
title: "`bin/agent-vault-approve-claude` verifies preconditions up front, runs idempotently, and supports updating the Claude OAuth tokens after the fact"
status: draft
date: "2026-06-29"
description: "`bin/agent-vault-approve-claude` verifies preconditions up front, runs idempotently, and supports updating the Claude OAuth tokens after the fact"
beads: [lead-al1r, lead-m1dc, lead-po]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-043, PDR-024]
  pins: []
  related: []
---
# PDR-025 — `bin/agent-vault-approve-claude` verifies preconditions up front, runs idempotently, and supports updating the Claude OAuth tokens after the fact

**Status:** draft (2026-06-29)
**Authors:** dstengle (intent), Claude (lead-po)
**Lead bead:** [`lead-m1dc`](#) — *approve-claude (v0.47.0) breaks halfway on a missing env var, half-completes, and re-run is broken* (bug, P1).
Follow-on to [`lead-al1r`](#) (the approve-claude oauth-credential fix).

**Anchored to** the product-authority statement (2026-06-29), verbatim:

> "the approve script breaks halfway through when it can't find the env var it
> needs. It says to retry, but it half-completed the work and re-run is broken.
> The fix should be to verify preconditions to be able to execute the full
> process and if at all possible be able to update the tokens after the fact as
> well."

That statement pins both scope and vocabulary for this PDR — no discovery
workshop was required.

**Anchored on (decisions this builds on — NOT re-decided here):**

- [`lead-al1r`](#) / scenario 202 (`@scenario_hash:1c054dfdc468860a`) — the
  scripted approve-claude step must write a NON-EMPTY `CLAUDE_OAUTH` credential
  (no blank writeback). Shipped as shop-templates v0.47.0, the `08136da`
  oauth-tokens path: resolve ops-coordinates → owner `POST /v1/auth/login` →
  ensure the `CLAUDE_OAUTH` proposal/slot → `POST /v1/credentials/oauth/tokens`
  with access+refresh. This PDR TIGHTENS that script's robustness; it does not
  retire the non-blank-writeback pin.
- [PDR-024](024-doctor-command-validates-bootstrapped-shop-credentials-and-connections.md)
  / scenario 217 (`@scenario_hash:5cf88671d3fab25b`) — `bin/doctor` asserts
  `CLAUDE_OAUTH` is present and refreshable. Doctor is the *diagnosis* of the
  credential's health; this PDR is the *provisioning* that makes the credential
  land reliably and stay updatable.
- [ADR-043](../adr/043-single-source-of-truth-for-derived-bootstrap-coordinates.md)
  — the single ops-coordinates artifact the script resolves.

## Point of intent

The just-shipped v0.47.0 approve-claude script does the right *writeback* but is
not *robust*: it discovers a missing required input partway through, after it has
already mutated vault state (e.g. created the `CLAUDE_OAUTH` proposal/slot), then
tells the operator to retry — but the retry hits the partial state and breaks.
For an adopter standing up a fresh product (the framework-as-product outcome),
this is the build-trap inverse: precise machinery that strands the operator in a
half-provisioned state with no clean recovery.

**Outcome (observable behavior change):** an adopter runs
`bin/agent-vault-approve-claude` and either it provisions the full refreshing
`CLAUDE_OAUTH` credential or it refuses up front with an actionable message and
changes nothing — and the operator can always re-run to recover or to refresh
tokens later, without hand-repairing vault state. Success is the adopter
provisioning Claude OAuth without filing a support request or manually unwinding
partial state; it is not "the script has more code."

## Decision

Pin three behaviors of the rendered `bin/agent-vault-approve-claude`, each as a
single-behavior scenario under `features/templates/`:

1. **Upfront precondition completeness + fail-fast + zero partial state**
   (scenario 219, `@scenario_hash:3b7e07095a354e0a`). Before ANY mutating step,
   verify every required input is present and every endpoint it will call is
   reachable; on any gap, exit non-zero with a diagnostic naming the missing
   precondition and make ZERO partial changes.

2. **Idempotent re-run** (scenario 220, `@scenario_hash:9aa82d211517155d`). A
   re-run after a failed OR a successful prior attempt completes cleanly —
   ensure (create-or-reuse) the proposal/slot rather than aborting because one
   exists — and lands the populated refreshing credential regardless of prior
   partial state.

3. **Update-tokens-after-the-fact** (scenario 221,
   `@scenario_hash:45dc18d4b0d1730e`). A later re-run that re-POSTs fresh token
   material to the oauth-tokens endpoint is a supported, non-error path.

## Options considered

- **Script-layer guard only (chosen).** Add upfront verification and make the
  mutating steps idempotent/updatable inside the rendered script. Localizes the
  fix to the layer the operator runs and keeps the proven v0.47.0 oauth-tokens
  path. Matches the product-authority ask directly.
- **Defer to `bin/doctor`.** Rejected: doctor diagnoses *after* the fact; it
  does not prevent the half-completed run or enable clean recovery. The two are
  complementary, not substitutes.
- **Document a manual unwind procedure.** Rejected: pushes recovery work onto
  every adopter for a defect the script can prevent; it is the order-taker
  non-fix.

## Work-splitting

Three distinct behaviors → three scenarios. Each has its own observable
`Then`: (219) zero partial state on precondition failure; (220) clean re-run end
state; (221) supported token update. They are not collapsible — a script could
satisfy precondition-checking yet still not be re-runnable, and vice versa.

## Preserved, not retired

- Scenario 202 (`@scenario_hash:1c054dfdc468860a`) — non-blank `CLAUDE_OAUTH`
  writeback. Still in force; this family adds preconditions and idempotency
  around the same writeback.
- Scenario 217 (`@scenario_hash:5cf88671d3fab25b`) — doctor's `CLAUDE_OAUTH`
  refreshability check. Complementary diagnosis surface.

## Scope thinness to flag for the Architect's pre-state

The product authority did not name WHICH specific env var the operator hit. The
scenarios deliberately pin the GENERAL precondition-completeness behavior (every
required input + endpoint verified before any mutating step) rather than a single
named variable, so the pin holds regardless of which input was missing. At
dispatch the Architect should confirm against the v0.47.0 / `08136da` script body
the exact set of required inputs (Claude credential/token source, owner login
credentials, broker address, resolvable ops-coordinates) and whether the
oauth-tokens endpoint already supports re-POST (the residual confidence item
recorded on `lead-al1r`).
