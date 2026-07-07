---
id: ADR-046
kind: adr
title: The framework launcher/leaf image in `bin/shop-shell` is a parameterized, repo-file-defaulted variable; ADR-028's product-neutral-framework-image exemption is OVERRIDDEN
status: accepted
date: "2026-06-27"
description: The framework launcher/leaf image in `bin/shop-shell` is a parameterized, repo-file-defaulted variable; ADR-028's product-neutral-framework-image exemption is OVERRIDDEN
beads: [lead-integration, lead-ml51, lead-mz8v, lead-shop]
edges:
  supersedes: []
  superseded-by: []
  amends: [ADR-028]
  depends-on: []
  anchored-on: []
  pins: [ADR-043]
  related: []
---
# ADR-046 — The framework launcher/leaf image in `bin/shop-shell` is a parameterized, repo-file-defaulted variable; ADR-028's product-neutral-framework-image exemption is OVERRIDDEN

- Status: Accepted (2026-06-27)
- Date: 2026-06-27
- Amends: [ADR-028](028-agent-vault-broker-is-a-lead-shop-supporting-service-broker-own-behaviors-pinned-by-lead-integration-surface.md)
  — specifically the product-neutral-framework-image treatment under which the
  launcher image `ghcr.io/dstengle/shopsystem-bc-lead` and the leaf-BC runtime
  `shopsystem-bc-base` are baked into the rendered `bin/shop-shell` as fixed,
  exempt product-neutral literals.
- Extends: [ADR-043](043-single-source-of-truth-for-derived-bootstrap-coordinates.md)
  — this is the framework-image leg of ADR-043 Phase-1 (D1/D2): the framework
  image becomes one more coordinate that derives from the single source rather
  than being re-spelled.
- Relates: PDR-020, ADR-038 (manifest `product:` as identity root), ADR-026,
  ADR-018 (artifact-surface verification).
- Bead: lead-ml51 (dispatch); pre-state finding recorded on lead-mz8v.
- Pins: the 2026-06-27 product-authority decision — *`bin/shop-shell` carries NO
  product-specific literals; every product value (the framework image INCLUDED)
  is a variable reference whose default is read from the single ADR-043
  ops-coordinates artifact and is env-overridable.*

## Context

ADR-028 settled that the agent-vault broker is a lead-shop supporting-service and
that the ephemeral launcher carrying the docker CLI is the vehicle that stands up
a leaf-BC session. Under that design, and the compose.yaml product-neutral
agent-vault-image precedent it leaned on, the framework launcher/leaf images
(`ghcr.io/dstengle/shopsystem-bc-lead` for the launcher, `shopsystem-bc-base` for
the leaf-BC runtime — later both `bc-lead` under PDR-020) were treated as
PRODUCT-NEUTRAL: every adopter pulls the SAME image regardless of slug, so the
image was held EXEMPT from the cross-product-literal generification rule and baked
as a fixed literal in the rendered `bin/shop-shell`. That exemption is the
load-bearing assumption behind scenarios 172 (`@scenario_hash:725562869d9df919`)
and 175 (`@scenario_hash:166b86d779ecd0e7`), which positively assert the fixed
image literals are PRESENT and PRESERVED in the rendered wrapper.

ADR-043 then established (D1) that the manifest `product:` field is the single
identity root and (D2) that bootstrap renders ONE canonical ops-coordinates
artifact every `bin/` script SOURCES, so each value appears as a literal in
exactly ONE place and everywhere else is a reference.

On 2026-06-27 the product authority decided that `bin/shop-shell` is to carry NO
product-specific literals at all so it can be freely updated — and explicitly
extended that scope to the FRAMEWORK IMAGE: the image name is to become a
variable whose default is sourced from the repo-file single source, env-
overridable, so an operator can point shop-shell at a different image without
editing the script. This collides head-on with ADR-028's product-neutral-image
exemption.

## Decision

**The framework launcher/leaf image referenced by `bin/shop-shell` is no longer a
fixed product-neutral literal. It is a parameterized, env-overridable shell
variable whose default is sourced from the single ADR-043 ops-coordinates
artifact (the manifest `product:` derivation root, D1/D2).** ADR-028's
product-neutral-framework-image exemption — the carve-out that permitted
`ghcr.io/dstengle/shopsystem-bc-lead` / `shopsystem-bc-base` to be baked as fixed
literals in the rendered wrapper — is OVERRIDDEN for `bin/shop-shell`.

Consequences for the contract surface:

1. The image joins the ADR-043 D2 coordinate set: it is rendered ONCE into the
   ops-coordinates artifact and referenced (never re-spelled) by `bin/shop-shell`.
   This is the framework-image leg of ADR-043 Phase-1, fully consistent with D1
   (manifest `product:` is the single root) — the image default is DERIVED from
   that root at render time, not independently hardcoded.

2. The "product-neutral therefore exempt" reasoning no longer protects the image
   *as a literal in shop-shell*. Product-neutrality is now expressed by the
   DEFAULT VALUE living in the single source (the artifact), not by spelling the
   literal in the script. Adopters still pull the same default image; they now
   also get env-overridability for free.

3. The new behavior is pinned by the PO-authored scenarios under lead-ml51:
   - 203 (`@scenario_hash:827dec9656d97a38`) — the rendered `bin/shop-shell`
     carries ZERO product literals for a non-default slug, the framework image
     INCLUDED (no `ghcr.io/dstengle/shopsystem-bc-lead`).
   - 205 (`@scenario_hash:1885dea2b4550fde`) — the image is an env-overridable
     variable whose default is sourced from the single artifact; this is the 1:1
     ledger event for THIS amendment.
   - 204 (`@scenario_hash:b7ea0de32ef49854`) — the sibling slug/org references.

4. The prior image-literal pins are SUPERSEDED and retired at dispatch: 172
   (`@scenario_hash:725562869d9df919`), 175 (`@scenario_hash:166b86d779ecd0e7`),
   and — found by the architect's supersession enumeration, beyond the PO's flag
   — 134 (`@scenario_hash:a3b723341d9f2872`, which spells `SHOPSYSTEM_DATA` with
   default `$HOME/.local/share/shopsystem` directly in the wrapper, contradicting
   203/204's reference-only mechanism).

## Scope boundary

This amendment is scoped to `bin/shop-shell` (the script the product authority
asked to clean up) as the immediate target. The compose.yaml product-neutral
agent-vault-broker image treatment (ADR-028's original precedent) is NOT touched
by this ADR; the shared ADR-043 coordinates-artifact mechanism is what generalizes
across the other `bin/` scripts under lead-ml51's umbrella.

## Open dependency — ADR-043 D2 shape (RESOLVED 2026-06-28, lead-7wta)

> **UPDATE 2026-06-28 (lead-7wta):** ADR-043 D2 is now FINALIZED — the
> ops-coordinates artifact is `bin/ops-coordinates`, a rendered, directly
> shell-sourceable `KEY=value` env-file derived at bootstrap from the manifest
> `product:` root (the lean recorded below, ratified). `OPS_FRAMEWORK_IMAGE` is
> the framework-image key this amendment's scenario 205 sources. The PO
> re-author of 204/205 to sharpen the source-target leg to the concrete path is
> gated on lead-ml51 reconcile (it is IN FLIGHT carrying the filename-agnostic
> 204/205). See ADR-043 "D2 — FINALIZED".

ADR-043 D2 deliberately leaves the ops-coordinates artifact's concrete shape/path
open ("an `ops/coordinates` env-file OR a `[product]` block of the manifest").
Scenarios 204/205 are therefore filename-agnostic: they pin that shop-shell
SOURCES the single artifact by a `source `/`. ` directive and carries references,
without pinning the artifact filename/format. Architect note for D2 finalization:
the scenarios' own `source`/`. ` mechanism requires the artifact to be directly
shell-sourceable, which a manifest YAML `[product]` block is NOT — this leans D2
toward a RENDERED, shell-sourceable env-file derived at bootstrap from the
manifest `product:` root (consistent with D1). D2 finalization + the resulting
PO re-author/re-hash to sharpen the source-target leg is tracked as a follow-up;
this amendment does not pin it.

## Alternatives considered

- **Keep the ADR-028 exemption (status quo).** Rejected by explicit
  product-authority decision: the operator wants to update `bin/shop-shell`
  freely and override the image without editing the script. A baked literal
  defeats both.
- **Parameterize the image but hardcode its default IN shop-shell.** Rejected —
  that re-introduces a product literal in the script (violates 203) and a second
  source of truth for the image (violates ADR-043 D1/D2). The default must live
  in the single artifact.
