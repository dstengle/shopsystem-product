---
id: ADR-038
kind: adr
title: The manifest `product:` field is the canonical product-identity source; the fleet tooling derives the system slug, docker network, BC-name-shape prefix, and image namespace from it, with explicit flag/env overrides layered on top
status: accepted
date: "2026-06-12"
description: The manifest `product:` field is the canonical product-identity source; the fleet tooling derives the system slug, docker network, BC-name-shape prefix, and image namespace from...
beads: [lead-6ze3, lead-architect, lead-owned, lead-repo, lead-t12k, lead-tgsb, lead-wm2r, lead-xntx]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-005, ADR-018, ADR-020, PDR-011, PDR-018]
  pins: [ADR-005]
  related: []
---
# ADR-038 — The manifest `product:` field is the canonical product-identity source; the fleet tooling derives the system slug, docker network, BC-name-shape prefix, and image namespace from it, with explicit flag/env overrides layered on top

**Status:** accepted (2026-06-12)
**Tier:** system-global (per [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md) / [ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md) — this is a cross-BC, per-product structural decision about *how this product declares its identity once and the fleet tooling derives it everywhere*; it touches the manifest contract (lead-owned) and how bc-launcher reads it, not one BC's internals, and not a framework-doctrine edit to §1–6.)
**Authors:** dstengle (intent), Claude (lead-architect)
**Pins:** the WS-1.3 slice of the externalize-identity-constants finding recorded on `lead-t12k` (finding 2 of the independent MVP review) — *"manifest `product:` field -> shopsystem-bc-launcher + ADR-005 successor (architect ADR): mechanism implemented-but-undocumented-and-unused; define + populate live manifest."* It is the **ADR-005 successor** for the one field [ADR-005](005-bc-manifest-in-lead-repo.md) never defined.
**Anchored to:** [ADR-018](018-empirical-verification-is-contract-surface.md) (every pre-state finding below is from this repo's `adr/`/`pdr/` records, the committed `bc-manifest.yaml`, and the installed `bc_launcher` manifest schema / `controller.launch()` behavior as reported by the WS-0 spike — no `repos/` BC source read or run). [ADR-005](005-bc-manifest-in-lead-repo.md) (the manifest-as-committed-file decision this ADR extends with one field). [ADR-020](020-routing-identity-is-abstract-system-name-shop-root-eliminated.md) — the abstract-address projection whose silent cross-product failure is the downstream harm a single declared identity prevents.
**Anchored on (PDR):** [PDR-018](../pdr/018-dummy-product-instantiation-spike.md) — the dummy-product instantiation spike (WS-0) whose WS-1 dependency surface forecasts this exact wall (WS-1.3: *"manifest `product:` field (implemented, undocumented, unused; ADR-005 never defines it)"*); [PDR-011](../pdr/011-empirical-verification-is-contract-surface.md) (the contract-surface evidence rule).
**Related beads:** `lead-t12k` (WS-1 identity-constants, parent), `lead-wm2r` (epic — framework genericity / path to a second product), `lead-tgsb` (WS-1.1 `SHOPMSG_SYSTEM_SLUG`, shipped), `lead-6ze3` (WS-1.2 `BC_IMAGE`, shipped), `lead-xntx` (WS-1.4 BC-name-shape gate on non-default slug, shipped).

---

## Context

[ADR-005](005-bc-manifest-in-lead-repo.md) made the BC manifest a committed
file in the lead repo and named it the single source of truth for *which BCs
belong to the product, each BC's canonical name, GitHub remote, and role*. It
did **not** define a field for the product's own identity. The shopsystem is a
framework whose telos is building *other* products, yet the one thing every
layer needs to know — *which product is this?* — has no declared home. The
independent MVP review (finding 2) found that identity instead hard-coded
across five layers in four repos, each baking `shopsystem` independently.

WS-1 has since externalized three of those constants as independent override
surfaces. What remains (WS-1.3) is to give them a **single declarative
source** rather than three knobs an adopter must set in lockstep. The
manifest already has a partial, accidental footing here: `controller.launch()`
reads a `product:` key to slugify the docker network name — a mechanism that
is *implemented but undocumented and unused* (no `product:` key exists in the
live manifest, and the schema does not list it, so the read always falls back
to the hard default). This ADR promotes that accidental field to a
first-class, documented, single-source product-identity field, and pins what
derives from it.

This is a structural/contract decision with no product-UX surface change for
the shopsystem product itself — hence an **ADR**, not a PDR.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

Verified 2026-06-12 from the lead CWD against this repo's `adr/`/`pdr/`
records, the committed `bc-manifest.yaml`, and the installed `bc_launcher`
manifest schema / `controller` behavior as reported by the WS-0 spike
(PDR-018). No BC source read or run.

1. **ADR-005 defines `name`/`remote`/`role` only; `product:` is never
   mentioned. CONFIRMED** (read of `adr/005-bc-manifest-in-lead-repo.md`):
   its Decision names exactly four single-sources — *which BCs belong, each
   BC's name, remote, role* — and the per-entry fields are `name/remote/role`.
   There is no product-identity field at any level of the manifest.

2. **The committed `bc-manifest.yaml` carries no `product:` key. CONFIRMED**
   (read of `bc-manifest.yaml`): the file is a header comment plus a `bcs:`
   list of `{name, remote, role}` entries. There is no top-level
   `product:` key, so `controller.launch()`'s `product:` read falls back to
   its hard default on every launch today.

3. **The installed manifest schema lists `name/remote/role`, no `product`.
   CONFIRMED** (WS-0 spike, `manifest.py`): the schema validates the per-BC
   fields only; `product:` is not a recognized field, so even a hand-added
   key would be schema-undeclared.

4. **`controller.launch()` reads `product:` ONLY to `_slugify()` the docker
   network name. CONFIRMED** (WS-0 spike iter-2 finding, `controller.py`):
   the sole consumer of `product:` today is network-name derivation. The
   field is real in code but undeclared in schema, unset in the live
   manifest, and used for exactly one of the four identity surfaces — the
   "implemented-but-undocumented-and-unused" state finding 2 of the review
   named.

5. **The three WS-1 identity surfaces ship as independent env knobs, not a
   single source. CONFIRMED** (read of `lead-tgsb`, `lead-6ze3`, `lead-xntx`
   notes): `SHOPMSG_SYSTEM_SLUG` (messaging, lead-tgsb), `BC_IMAGE`
   (bc-launcher, lead-6ze3), and the `PRODUCT_SLUG`-gated BC-name-shape
   enforcement (bc-launcher, lead-xntx) each landed as its *own* override
   with its *own* default. lead-xntx in particular established the
   load-bearing guarantee this ADR must preserve: name-shape enforcement is
   gated on `slug != DEFAULT_PRODUCT_SLUG`, so **under the default slug the
   accepted set is provably unchanged** (additive-only). No single field
   sets all three coherently today.

6. **@scenario_hash retirement enumeration — empty. CONFIRMED.** This is a
   manifest-contract / convention decision. `grep -r "@scenario_hash"
   features/` over the lead-held Gherkin returns no hashes on the
   bc-manifest features; the BC's mailbox-reported scenario register carries
   `scenario_hashes: []` (per lead-xntx reconciliation). No pinned BC-side
   coverage is retired, superseded, or contradicted by this ADR. The
   downstream WS-1.3 dispatch is therefore additive and carries no
   conflicting-hash retirement instruction.

---

## Decision

### D1 — `product:` is a first-class, documented manifest field declaring the product/system slug

The manifest gains a top-level **`product:`** field (string), the canonical
declaration of *which product this system instance is*. It is added to the
`bc_launcher` manifest schema (finding 3 — it is currently schema-undeclared)
and documented in the manifest header (finding 1/2 — ADR-005 never defined
it). Its value is the product slug (e.g. `shopsystem`, `dummyco`). This is the
field ADR-005 omitted; ADR-038 supplies it as the successor.

### D2 — `product:` is the single source the fleet tooling derives identity from

The tooling derives the following from the one declared `product:` value,
rather than from N independently-set env vars (finding 5):

- **the system slug** — the default for messaging's `SHOPMSG_SYSTEM_SLUG`
  (the ADR-020 address-projection slug; the silent-cross-product-routing
  surface lead-tgsb externalized);
- **the docker network name** — already derived via `_slugify(product)`
  (finding 4), now sourced from a *declared* value rather than an
  always-defaulting read;
- **the BC-name-shape prefix** — the `<product>-<id>` shape the lead-xntx
  name-shape gate enforces (so the gate's "non-default slug" is the declared
  `product:`, not a separately-set `PRODUCT_SLUG`);
- **the image namespace where applicable** — the namespace component of the
  BC image reference (`BC_IMAGE`, lead-6ze3), *where the image is published
  under the product/org namespace*. See the **Open question** below: whether
  `product:` drives the image namespace by default, or the image stays an
  independent override, is the one genuinely open knob this ADR flags rather
  than settles.

The intent of D2 is **declare-once**: a second product sets `product:` once
and the fleet derives its identity, instead of threading
`SHOPMSG_SYSTEM_SLUG` / `PRODUCT_SLUG` / `BC_IMAGE` separately and keeping
them in sync by hand.

### D3 — Precedence: explicit flag / env override > manifest `product:` > hard default (`shopsystem`)

Identity resolves by precedence, highest first:

1. an **explicit flag or env override** for a specific surface
   (`SHOPMSG_SYSTEM_SLUG`, `BC_IMAGE`, `PRODUCT_SLUG`, `--image`, etc.) — the
   ad-hoc per-surface escape hatch, unchanged from WS-1;
2. the **manifest `product:`** value — the declarative baseline identity;
3. the **hard default `shopsystem`** — when `product:` is absent or set to
   `shopsystem`, and no override is present.

So `product:` sets the baseline declaratively while envs remain for ad-hoc
override. Critically, **`product:` absent or `product: shopsystem`, with no
overrides, preserves ALL current behavior** — additive, consistent with the
lead-xntx default-slug guarantee (finding 5): under the default slug the
name-shape accepted set stays provably unchanged. This ADR adds a source; it
removes no escape hatch and changes no default-slug behavior.

### D4 — The per-constant env overrides become overrides of the manifest-declared identity, not the primary surface

The three WS-1 env knobs (`SHOPMSG_SYSTEM_SLUG`, `BC_IMAGE`, `PRODUCT_SLUG`)
are **retained but demoted**: they move from being the *only* way to set
identity to being *overrides on top of* the manifest-declared `product:`
(D3 rank 1 over rank 2). They are no longer the primary identity surface —
the manifest is. This keeps every ad-hoc and CI override path working
(nothing is removed) while making the declarative single-source the normal
path an adopter reaches for first.

---

## Alternatives considered

**Option A — Keep the N independent env vars; do not add `product:`.**
Rejected. This is the pre-state (finding 5) the MVP review flagged as the
genericity defect: a second product cannot stand up without setting three
constants across repos in lockstep, with no single declared source and no
audit of *which product this is*. The whole WS-1 finding is that identity is
*distributed*; leaving it distributed fails the spike's declare-once gate.

**Option B — Add `product:` but keep network-name as its only consumer
(ratify the accidental status quo).** Rejected. That leaves the field
"implemented but unused" for three of four surfaces (finding 4) and does not
close the WS-1.3 gap — the slug, name-prefix, and image namespace would still
be threaded separately. The value of `product:` is precisely that it is the
*single* source D2 names, not one more partial knob.

**Option C — Make `product:` authoritative and remove the env overrides
entirely.** Rejected (D3/D4). The env overrides are load-bearing for CI,
ad-hoc runs, and the per-surface escape hatch; removing them is a strictly
worse, less flexible surface and would break existing override paths. The
precedence ladder (override > manifest > default) keeps both: declarative
baseline *and* ad-hoc override.

**Option D — Put `product:` in a separate config file, not the manifest.**
Rejected (ADR-005). The manifest is already *the* committed, auditable,
self-contained single source of truth for the product's BC set; product
identity is the most fundamental fact about that set and belongs in the same
file, auditable via `git log -- bc-manifest.yaml` alongside BC additions. A
separate file re-splits what ADR-005 unified.

---

## Consequences

- **The manifest contract gains one field** (`product:`, D1) — a schema
  addition in `bc_launcher`'s `manifest.py`, a header-doc line in
  `bc-manifest.yaml`, and population of the live manifest with
  `product: shopsystem` (which, per D3, preserves all current behavior). This
  is dispatched to **shopsystem-bc-launcher** as a **`request_bugfix`** (the
  manifest/launch behavior exists and is unpinned; the per-constant overrides
  already ship — see the WS-1.3 dispatch, work_id below).
- **`controller.launch()` becomes the single derivation point** (D2): the
  slug, network name, name-shape prefix, and (subject to the Open question)
  image namespace all derive from the one declared `product:`, with the D3
  precedence applied. The lead-xntx default-slug guarantee is a hard
  acceptance pin on that work: `product:` absent/`shopsystem` ⇒ accepted set
  provably unchanged.
- **The WS-1 env knobs are retained as overrides, not removed** (D4) — no
  existing override or CI path breaks. messaging's `SHOPMSG_SYSTEM_SLUG`
  (lead-tgsb) keeps working; this ADR only adds a manifest-derived *default*
  beneath it. (No new dispatch to messaging is required by this ADR: D3 only
  changes where bc-launcher *sources* the slug default it passes; the
  messaging override surface is unchanged.)
- **WS-1.3 closes the WS-1 set** (lead-t12k scorecard): SYSTEM_SLUG ✓
  (lead-tgsb), BC_IMAGE ✓ (lead-6ze3), BC_NAME_RE ✓ (lead-xntx),
  manifest `product:` ✓ (this ADR + the WS-1.3 dispatch). The
  declare-once identity is the WS-1.3 wall PDR-018 forecast, now closed.
- **A second product declares `product: <slug>` once** in its manifest and
  the fleet tooling derives its identity end-to-end — the concrete genericity
  win the spike exists to prove. The dummy-product run (PDR-018 conditions
  2/5) exercises exactly this projection under a non-default slug.
- **No Gherkin authored, no `@scenario_hash` retired** (finding 6). The
  downstream WS-1.3 `request_bugfix` is additive and carries no
  conflicting-hash retirement instruction.
- **This ADR is tier `system-global`** (per ADR-034/035) — a cross-BC,
  per-product identity-contract decision, not a framework-doctrine edit and
  not one BC's internals.

### Open question (flagged for the user, not settled here)

**Does `product:` drive the image namespace by default, or does the image
stay a fully independent override?** D2 lists the image namespace "where
applicable" deliberately: deriving the BC image reference's *namespace* from
`product:` is clean when images are published under a per-product/org
namespace, but the org and the registry path are a second axis (the review
named `dstengle` org-coupling separately from `shopsystem` slug-coupling).
The conservative reading — and what the WS-1.3 dispatch pins as the *minimum*
— is that `BC_IMAGE` remains an independent override (lead-6ze3, unchanged)
and `product:` drives slug/network/name-prefix; whether `product:` *also*
becomes the image-namespace default is left to the user. The dispatch below
is written to the conservative reading so it is correct either way.

## Cross-references

- [ADR-005](005-bc-manifest-in-lead-repo.md) — the manifest-as-committed-file
  decision this ADR succeeds by adding the `product:` field it omitted.
- [ADR-020](020-routing-identity-is-abstract-system-name-shop-root-eliminated.md) — the abstract-address projection; the silent
  cross-product routing failure a single declared identity prevents (PDR-018
  condition 2).
- [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md)
  / [ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md)
  — the tier (system-global) and tag convention.
- [ADR-018](018-empirical-verification-is-contract-surface.md) /
  [PDR-011](../pdr/011-empirical-verification-is-contract-surface.md) — the
  contract-surface evidence rule the pre-state findings honor.
- [PDR-018](../pdr/018-dummy-product-instantiation-spike.md) — the spike whose
  WS-1.3 dependency-surface wall this ADR resolves.
- Beads: `lead-t12k` (WS-1 parent), `lead-wm2r` (epic), `lead-tgsb` /
  `lead-6ze3` / `lead-xntx` (the three shipped WS-1 surfaces this ADR
  unifies).
