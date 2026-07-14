# ADR-063 — The fleet-wide tier+effort→model mapping table is a shopsystem-bc-launcher-owned artifact, single-sourced on that BC's own contract surface, not a lead-owned integration surface

**Status:** accepted (2026-07-14)
**Tier:** system-global (per ADR-034/035 — governs a cross-BC ownership
question: which of two BCs, or the lead shop itself, owns a fleet-wide
artifact both `assign_scenarios` dispatches under brief-017 depend on — not
one BC's internals).
**Authors:** dstengle (product authority, via brief-017 ratification), Claude
(lead-architect)
**Anchored to:**
[ADR-057](057-bc-work-loop-single-sourced-two-poured-projections-claude-and-fabro-def-generated-at-pour-not-baked.md)
D4 (the `model_stylesheet` skeleton pours static and verbatim from
shopsystem-templates — this ADR does not touch that; it decides where the
*resolution* data lives, which is explicitly NOT the pour surface);
[ADR-028](028-agent-vault-broker-is-a-lead-shop-supporting-service-broker-own-behaviors-pinned-by-lead-integration-surface.md)
D1/D2 (the precedent this ADR distinguishes itself from — a lead-owned
integration surface is the right home only when **no BC legitimately owns**
the artifact; here one does);
[ADR-018](018-empirical-verification-is-contract-surface.md) (pre-state
evidence is the contract/artifact surface only).
**Realizes:** [brief-017](../briefs/017-fabro-llm-provider-model-selection.md)
§5 ("Where the tier+effort→model mapping table is authored/pinned... named
above as open; the Architect decides at dispatch, not the PO here") and
[cand-002](../candidates/cand-002.md) Rabbit holes ("Where exactly this table
itself is authored/pinned... is an open ownership question — Architect's call
at dispatch time").
**Related beads:** `lead-ifye3` (the umbrella dispatch this ADR unblocks).

## Context

brief-017 splits fabro LLM provider/model selection across two BCs:
shopsystem-templates authors an abstract-labeled `model_stylesheet` skeleton
(three `{{ inputs.<NAME> }}` placeholders: `MODEL_CODING`, `MODEL_REVIEW`,
`MODEL_DEFAULT`); shopsystem-bc-launcher resolves those placeholders into
literal, provider-specific model IDs at launch time via fabro run `-I`
inputs. The resolution needs a lookup: a fleet-wide, provider-keyed
(tier+effort → literal model ID) mapping table. Both the brief and cand-002
explicitly left where this table is authored/pinned as an open Architect
decision, not a PO/product-shape decision — it is a decomposition/ownership
question.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

1. **shopsystem-templates explicitly does not own it.**
   `features/shopsystem-templates/fabro_model_stylesheet_tier_labels.feature`
   `@scenario_hash:8aab2c5c071e349f` pins: "the tier+effort-to-model mapping
   table and the active-provider dial are both absent from the templates BC's
   pour surface — resolving a placeholder to a literal model ID is not a
   templates-BC behavior." **Confirmed** by direct read of the pinned
   scenario body.
2. **shopsystem-bc-launcher is the sole consumer.** brief-017 §4 and
   `features/shopsystem-bc-launcher/fabro_llm_provider_openrouter_override.feature`
   `@scenario_hash:22f2a5bda5c29044` both pin that bc-launcher is the party
   that "resolves each poured node-class placeholder to a literal model ID
   via fabro run `-I` inputs, sourced from the provider-keyed mapping table
   for the active provider." No other BC reads or writes this table anywhere
   on the artifact surface. **Confirmed.**
3. **The ADR-028 D1/D2 precedent (lead-owned integration surface) does not
   transfer here.** ADR-028 D2 homed the agent-vault broker's own behaviors
   on a lead-owned integration surface for exactly one reason: the broker is
   vendored infrastructure with **no BC to hand it to** (D1 rejected both "a
   new BC shop" and "bc-launcher-owned" as broker owners). Here the opposite
   holds — bc-launcher is already the pinned, sole resolver of this table
   (finding 2), so a legitimate single BC owner exists. Routing the table to
   a lead-owned surface would manufacture the same dishonesty ADR-028 D2
   rejected in the other direction: a lead-owned artifact that only one BC
   ever reads is a mis-homed pin, not a genuine lead concern.
4. **Duplicated fleet-wide artifacts across two homes are a known, already
   burned failure class in this fleet.** The `workflow.fabro` def previously
   existed both as a bc-launcher `assets/fabro-def/` mirror and as
   shopsystem-templates' poured source, and drifted — fixes landed in one
   copy and silently failed to reach the runtime artifact sourced from the
   other, stranding three fabro-reliability fixes in the same session this
   brief derives from (lead memory `fabro-fixes-stranded-by-delivery-path`).
   Single-sourcing the mapping table inside the one BC that both authors and
   consumes it avoids re-creating this class of bug; there is no second
   party that needs its own copy.

## Decision

**The fleet-wide tier+effort→model mapping table is a
shopsystem-bc-launcher-owned artifact, versioned in that BC's own repo,
single-sourced with no mirror or copy anywhere else in the fleet.** Its
concrete file format/path is an implementation decision inside
shopsystem-bc-launcher's own contract surface (not further pinned by this
ADR or by brief-017's scenarios, per finding 1/2 — no scenario names a
storage location, only that the table is consulted and keyed by provider and
node-class tier). shopsystem-bc-launcher's Implementer authors and maintains
it as part of implementing scenario `22f2a5bda5c29044`'s resolution logic.

This is a same-shape decision to ADR-057's existing pin-ownership table
(templates owns the pour, bc-launcher owns engage-time provider/credential
wiring): the mapping table is data feeding bc-launcher's own resolution
logic, which is already bc-launcher's contract surface, not a new
cross-cutting concern.

## Alternatives considered

- **A lead-owned integration surface (the ADR-028 D2 pattern).** Rejected
  (finding 3): that pattern is the right home only when no BC can
  legitimately own the artifact (vendored infra with no natural BC owner).
  Here bc-launcher is already the pinned sole consumer/resolver — handing the
  table to the lead would mis-home data that belongs on the BC that uses it,
  and would require the lead to keep it in sync with bc-launcher releases
  for no compensating benefit.
- **A new BC shop dedicated to model-mapping concerns.** Rejected — no
  scenario, brief, or candidate motivates a third BC; this would be
  over-decomposition for a single lookup table one existing BC already
  consumes exclusively (ADR-004's BC-shop bar — a deliverable with its own
  contract surface — is not met by a config table).
- **A shared/mirrored copy on shopsystem-templates' surface** (so templates
  could theoretically validate placeholder names against table rows).
  Rejected (finding 4): this repeats the exact `workflow.fabro`
  mirror-drift failure class already burned this session. Scenario
  `8aab2c5c071e349f` already pins that templates' pour surface is blind to
  the table by design; a mirror would contradict that pin the moment the two
  copies diverged.

## Consequences

- shopsystem-bc-launcher's `request_bugfix`/`assign_scenarios` dispatch
  under `lead-ifye3` carries the expectation that the BC authors the mapping
  table as part of its own implementation, with no further lead-side
  storage-location pin.
- No lead-owned integration surface is created for this artifact — contrast
  the agent-vault broker (ADR-028 D2), which does get one, because it lacks
  a BC owner. The discriminator going forward: a lead-owned integration
  surface is for artifacts/behaviors **no BC can own**; a BC-owned artifact
  stays on that BC's own contract surface even when it is fleet-wide in
  scope.
- Future providers/models are added by a `request_maintenance` or
  `request_bugfix` dispatch to shopsystem-bc-launcher (a flat data update to
  its own owned table), not a lead-shop edit.

## Cross-references

- [brief-017](../briefs/017-fabro-llm-provider-model-selection.md) — the
  realizing brief that named this as an open Architect decision.
- [cand-002](../candidates/cand-002.md) — the committed candidate whose
  Rabbit holes section first raised the ownership question.
- [ADR-057](057-bc-work-loop-single-sourced-two-poured-projections-claude-and-fabro-def-generated-at-pour-not-baked.md)
  D4 — the existing pin-ownership split this decision extends without
  modifying.
- [ADR-028](028-agent-vault-broker-is-a-lead-shop-supporting-service-broker-own-behaviors-pinned-by-lead-integration-surface.md)
  D1/D2 — the lead-owned-integration-surface precedent this ADR
  distinguishes itself from.
- `features/shopsystem-templates/fabro_model_stylesheet_tier_labels.feature`
  `@scenario_hash:8aab2c5c071e349f` — pins the table's absence from
  templates' pour surface.
- `features/shopsystem-bc-launcher/fabro_llm_provider_openrouter_override.feature`
  `@scenario_hash:22f2a5bda5c29044` — pins bc-launcher as the table's
  consumer.
- lead memory `fabro-fixes-stranded-by-delivery-path` — the burned
  mirror-drift precedent motivating single-sourcing.
