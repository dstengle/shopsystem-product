---
type: brief
id: brief-015
title: The shopsystem system-version manifest (Bill of Materials)
status: draft
created: 2026-06-30
updated: 2026-07-17
authors: [David Stenglein (product authority), Claude (lead-po)]
description: '**There is no single shopsystem system version today.** The product ships as a'
derives-from: [adr-005, adr-018, adr-039, adr-021]
---

## Summary

There is no single shopsystem system version today. The product ships as a set of
components, each on its own independent version line: shopsystem-templates (the
0.4x line, e.g. 0.48.0), shopsystem-bc-launcher (the 0.3.x line, e.g. 0.3.41),
shopsystem-messaging (the 0.4.x line, e.g. 0.4.4), shopsystem-scenarios (the 0.2.x
line), and future components. Because these lines move independently, "shopsystem
vN" names nothing coherent — a version number alone does not identify which tuple
of component versions a system comprises, and the same number can belong to
different lines. This is not hypothetical: it bit us concretely on lead-6b53. The
product authority said "release v0.49.0 so I can test bootstrap," but v0.49.0 is
the shopsystem-templates line, while the bootstrap fix that needed releasing (the
bnhn launch-diagnostic fix, commit dbbb98a) shipped on the shopsystem-bc-launcher
line at 0.3.41; the version string was ambiguous because it silently assumed one
component's line was "the" system version, and the dispatch had to carry a prose
footnote disambiguating the two lines by hand. The cost of the gap: every release
conversation, every bootstrap-test request, and every "what version are we on?"
question must be manually disambiguated against four moving lines, with no
authoritative answer to "which component versions constitute the system the
adopter is running?" — and lead-5xnd baking per-image provenance plus lead-h2p0
surfacing inter-component dependencies only make the absence of a roll-up more
glaring. Observable behavior change targeted: after this manifest exists, the lead
(and anyone reading the lead repo) names a single authoritative `shopsystem vN`
and resolves it to the exact tuple of component versions it composes — so "release
vN", "test vN", and "what version is this?" are unambiguous, answered from one
curated artifact rather than reconstructed across four version lines.

The model (product authority David, 2026-06-30): a manifest in the lead defines
the version of shopsystem as the composition (sum) of individual component
versions — a Bill of Materials mapping each component's version to one overall
shopsystem system release version, owned and maintained by the lead. The manifest
carries two things: (1) a component → version map — for each component the
explicit pinned version participating in this release (the BOM proper); and (2)
the derived overall system version — the single `shopsystem vN` string this tuple
is, a composition over the component map rather than an independent line that
floats free. The defining invariant: a system version is exactly its component
tuple — given `shopsystem vN` the manifest resolves it to the precise
`{templates, bc-launcher, messaging, scenarios}` set, and given a tuple there is
one system version that names it. Why the lead owns it: the lead is the fleet
integrator and the product's outward face, already holds the declarative fleet
registry (`bc-manifest.yaml`, ADR-005), and already receives per-component
provenance (lead-5xnd baked OCI labels/env) — composing the system version from
component versions is integrator work.

## Scope

In scope (this brief / the model it establishes): a lead-curated manifest. The
lead authors and maintains the component → version map and the derived system
version by hand (or by lead-side tooling), reading the already-available inputs:
the baked per-image provenance (lead-5xnd), the inter-component dependency view
(lead-h2p0), and the component repos' tags. Keeping the first increment
lead-curated means the manifest delivers the unambiguous-system-version outcome
without depending on any BC behavior change — buildable entirely from inputs the
lead already has.

Out of scope for now (explicit, product authority): BCs tagging back for the
release — each BC self-tagging its own component version into its own repo as part
of system-release assembly; the product authority was explicit this "isn't
necessary for now." Future leg (deferred, NOT this brief): BC self-tag reflection
— a later increment may have the lead dispatch tag-reflection to each BC (the BC
tags its own component version into its own repo, since per ADR-018 the lead
carries no BC source and cannot tag BC repos directly — it would orchestrate, the
BC would act). That automation is out of scope now; this brief establishes the
lead-curated manifest only.

Relationship to lead-h2p0 and placement: lead-h2p0 is the dependency-map input,
not a duplicate of the manifest — it surfaces the inter-component version
dependencies (which component version bakes/requires which; which versions are
compatible), and that data feeds the manifest so it pins a tuple that actually
holds together rather than an arbitrary cross-product. The manifest consumes
lead-h2p0's dependency data and adds the roll-up to a single system version; it
does not re-derive the dependency map. Where it would live: the lead repo root,
alongside the existing declarative fleet registry — `bc-manifest.yaml` already
sits there as the committed, well-known declarative registry of the product's BCs
(ADR-005), and the system-version BOM is the same kind of artifact one level up
(where `bc-manifest.yaml` says which BCs compose the product, the system-version
manifest says which versions compose a given release). The exact filename and
whether it is a sibling file or an extension of an existing one is left to the
follow-up PDR.

Open questions for the follow-up PDR (framed, not decided — this brief
establishes the model and intent, the PDR settles the mechanism): (1)
system-version derivation / bump policy — how the `shopsystem vN` string is
derived from the component tuple and what bumps it (an independent monotonic
system counter incremented whenever any component pin changes, a date/serial
scheme, or a semver derived from the kind of component change; the brief commits
only that the system version composes the component versions). (2) manifest file —
location, name, format, and relationship to `bc-manifest.yaml` (a new sibling file
at repo root such as `system-manifest.yaml` / `versions.yaml`, an extension of
`bc-manifest.yaml` with a `version:` per BC plus a top-level `system_version:`, or
a separate `releases/` history; schema shape and whether prior system versions are
retained as history). (3) how releases reference the manifest (when the authority
says "release vN" — the lead-6b53 trigger — does the release process consume the
manifest as the input that drives a coordinated release, the record that captures
one after the fact, or both; how it interacts with the existing per-package
release cadence, ADR-039, and the auto-rebuild coupling, ADR-021, bc-base/bc-lead
rebuild on utility release). (4) coherence validation against lead-h2p0 / baked
provenance (should the lead validate a manifest tuple against the lead-h2p0
dependency view and the lead-5xnd baked image labels; if so, is it a
`doctor`/`bootstrap` check and advisory or blocking). (5) boundary handshake with
the deferred BC-self-tag leg (when it lands, does the lead-curated manifest become
the source the lead dispatches tags from, or does BC self-tagging become an input
the manifest reconciles against — naming the intended direction now keeps the
deferred leg additive rather than a rework).

What would NOT satisfy the product authority: a per-component version bump that
does not roll up to a single authoritative system version (the status quo — four
independent lines — and the lead-6b53 ambiguity left unresolved); a "system
version" that floats free of its component tuple (a string that does not resolve
to which component versions it composes); pushing the first increment to depend on
BC self-tagging behavior (the model is lead-curated now; requiring BC tag-back
inverts the explicit scope boundary); and re-deriving the inter-component
dependency map inside the manifest rather than consuming lead-h2p0 as its
dependency input.

Grounding artifacts: lead-loos (this brief's bead, carrying the product
authority's scope-refinement); lead-h2p0 (the inter-component version-dependency
view, the manifest's dependency-map input); lead-6b53 (the v0.49.0 templates-line
vs 0.3.41 bc-launcher-line ambiguity, the motivating failure); lead-5xnd
(per-image baked version provenance, OCI labels + ENV, a manifest input and
validation surface); `bc-manifest.yaml` (the existing lead-owned declarative fleet
registry, ADR-005, the placement reference); ADR-039 (per-package release cadence,
the release-process surface Q3 must reconcile with); ADR-021 (bc-base/bc-lead
auto-rebuild on utility release, release-coupling input for Q3); and ADR-018 (the
lead carries no BC source and cannot tag BC repos directly — why the deferred
BC-self-tag leg is dispatched-orchestration, not a lead-side edit).

## Source (pre-modernization)

#### 1. Problem / motivation (this IS the problem)

**There is no single shopsystem system version today.** The product ships as a
set of components, each on its own independent version line:

- `shopsystem-templates` — the `0.4x` line (e.g. 0.48.0)
- `shopsystem-bc-launcher` — the `0.3.x` line (e.g. 0.3.41)
- `shopsystem-messaging` — the `0.4.x` line (e.g. 0.4.4)
- `shopsystem-scenarios` — the `0.2.x` line
- (and future components)

Because these lines move independently, **"shopsystem vN" names nothing
coherent.** A version number alone does not identify which tuple of component
versions a system actually comprises, and the *same* number can belong to
different lines.

This is not hypothetical — it bit us concretely on [`lead-6b53`](#). The
product authority said *"release v0.49.0 so I can test bootstrap,"* but
**`v0.49.0` is the `shopsystem-templates` line**, while the bootstrap fix that
needed releasing (the `bnhn` launch-diagnostic fix, commit `dbbb98a`) shipped
on the **`shopsystem-bc-launcher` line at `0.3.41`**. The version string was
ambiguous because it silently assumed one component's line was "the" system
version. The dispatch had to carry a prose footnote disambiguating the two
lines by hand.

**The cost of the gap:** every release conversation, every bootstrap-test
request, and every "what version are we on?" question must be manually
disambiguated against four moving lines. There is no authoritative answer to
*"which component versions constitute the system the adopter is running?"* —
and `lead-5xnd` baking per-image provenance plus `lead-h2p0` surfacing
inter-component dependencies only makes the absence of a *roll-up* more
glaring.

##### Observable behavior change targeted

Today, naming a shopsystem release requires manually picking a component line
and footnoting which one was meant. After this manifest exists, **the lead (and
anyone reading the lead repo) names a single authoritative `shopsystem vN` and
resolves it to the exact tuple of component versions it composes** — so
"release vN", "test vN", and "what version is this?" are unambiguous, answered
from one curated artifact rather than reconstructed across four version lines.

---

#### 2. The model — a lead-owned manifest; system version = composition of
component versions

The product authority's model (David, 2026-06-30), stated directly:

> A **manifest in the lead** defines the version of **shopsystem** as the
> **composition (sum) of individual component versions** — a Bill of Materials
> mapping each component's version to **one overall shopsystem system release
> version**. The **lead owns and maintains** this manifest.

Concretely, the manifest carries two things:

1. **A component → version map** — for each shopsystem component
   (`shopsystem-templates`, `shopsystem-bc-launcher`, `shopsystem-messaging`,
   `shopsystem-scenarios`, and future components), the **explicit pinned
   version** that participates in this system release. This is the Bill of
   Materials proper.

2. **The derived overall system version** — the single `shopsystem vN` string
   that this particular tuple of component versions *is*. The system version is
   a **composition over** the component map, not an independent line that
   floats free of its components.

The defining invariant: **a system version is exactly its component tuple.**
Given `shopsystem vN`, the manifest resolves it to the precise
`{templates: …, bc-launcher: …, messaging: …, scenarios: …}` set — and given a
component tuple, there is one system version that names it. The manifest is the
authoritative roll-up that does not exist today.

**Why the lead owns it.** The lead is the fleet integrator and the product's
outward face; it already holds the declarative fleet registry
(`bc-manifest.yaml`, ADR-005) and already receives per-component provenance
(`lead-5xnd` baked OCI labels/env). Composing the system version from component
versions is integrator work, and the integrator is the lead. This matches the
product authority's gut ("this version management belongs in the lead").

---

#### 3. Explicit scope boundary — lead-curated now; BC self-tagging deferred

**In scope (this brief / the model it establishes):** a **lead-curated**
manifest. The lead authors and maintains the component → version map and the
derived system version by hand (or by lead-side tooling), reading the
already-available inputs: the baked per-image provenance (`lead-5xnd`), the
inter-component dependency view (`lead-h2p0`), and the component repos' tags.

**Out of scope for now (explicit, product authority):** **BCs tagging back for
the release** — i.e. each BC self-tagging its own component version into its own
repo as part of system-release assembly. The product authority was explicit:
this *"isn't necessary for now."* The manifest is **lead-curated**; the
**BC-self-tag automation is a deferred future leg**, named here so it is not
silently assumed and not re-litigated:

> **Future leg (deferred, NOT this brief): BC self-tag reflection.** A later
> increment may have the lead *dispatch* tag-reflection to each BC (the BC tags
> its own component version into its own repo, since per ADR-018 the lead carries
> no BC source and cannot tag BC repos directly — it would orchestrate, the BC
> would act). That automation is **out of scope now.** This brief establishes the
> lead-curated manifest only.

Keeping the first increment lead-curated means the manifest delivers the
unambiguous-system-version outcome **without** depending on any BC behavior
change — it is buildable entirely from inputs the lead already has.

---

#### 4. Relationship to `lead-h2p0` and where the manifest would live

**`lead-h2p0` is the dependency-map input, not a duplicate of the manifest.**
`lead-h2p0` surfaces the inter-component *version dependencies* — which
component version **bakes / requires** which (e.g. `bc-launcher` vX bakes
`shop-templates` vY, `messaging` vZ; which versions are compatible). That
view's data **feeds** the manifest: it tells the lead which component-version
tuples are internally coherent, so the manifest pins a tuple that actually
holds together rather than an arbitrary cross-product. The manifest **consumes**
`lead-h2p0`'s dependency data and adds the roll-up to a single system version;
it does not re-derive the dependency map.

**Where it would live (lead repo).** The natural home is the lead repo root,
alongside the existing declarative fleet registry — `bc-manifest.yaml` already
sits there as the committed, well-known declarative registry of the product's
BCs (ADR-005). The system-version BOM is the same *kind* of artifact (a
committed, lead-owned, declarative manifest) at the next level up: where
`bc-manifest.yaml` says *which* BCs compose the product, the system-version
manifest says *which versions* of them compose a given system release. The exact
filename and whether it is a sibling file or an extension of an existing one is
left to the follow-up PDR (§5).

---

#### 5. Open questions for the follow-up PDR (framed, not decided)

This brief establishes the model and intent. A follow-up PDR settles the
mechanism. The open questions:

1. **System-version derivation / bump policy.** How is the `shopsystem vN`
   string *derived* from the component tuple, and what bumps it? Options to weigh:
   an independent monotonic system counter (`v1`, `v2`, …) that the lead
   increments whenever any component pin changes; a date/serial scheme; or a
   semver derived from the *kind* of component change (any component major →
   system major, etc.). The brief commits only that the system version
   **composes** the component versions — *how the string is computed* is the
   PDR's call.

2. **Manifest file — location, name, format, and relationship to
   `bc-manifest.yaml`.** A new sibling file at repo root (e.g.
   `system-manifest.yaml` / `versions.yaml`)? An extension of `bc-manifest.yaml`
   with a `version:` per BC plus a top-level `system_version:`? A separate
   `releases/` history? Schema shape and whether prior system versions are
   retained as history are PDR decisions.

3. **How releases reference the manifest.** When the product authority says
   "release vN" (the `lead-6b53` trigger), how does the release process *consume*
   the manifest — is the manifest the input that *drives* a coordinated release,
   the record that *captures* one after the fact, or both? How does it interact
   with the existing per-package release cadence (ADR-039: a version bump is part
   of the fix, dispatched as `request_maintenance`) and the auto-rebuild coupling
   (ADR-021: `bc-base`/`bc-lead` rebuild on utility release)?

4. **Coherence validation against `lead-h2p0` / baked provenance.** Should the
   lead validate a manifest tuple against the `lead-h2p0` dependency view and the
   `lead-5xnd` baked image labels (does the pinned tuple actually hold together,
   and does it match what is published)? If so, is that a `doctor`/`bootstrap`
   check (cf. `lead-5xnd` synergy note) and is it advisory or blocking?

5. **Boundary handshake with the deferred BC-self-tag leg.** When the future
   BC-self-tag automation lands, does the lead-curated manifest become the
   *source* the lead dispatches tags *from* (manifest drives BC tagging), or does
   BC self-tagging become an *input* the manifest reconciles against? Naming the
   intended direction now keeps the deferred leg additive rather than a rework.

---

#### 6. What would NOT satisfy the product authority

- A per-component version bump that does **not** roll up to a single
  authoritative system version (that is the status quo — four independent lines —
  and is exactly the `lead-6b53` ambiguity left unresolved).
- A "system version" that floats free of its component tuple (a version string
  that does not resolve to *which* component versions it composes).
- Pushing the first increment to depend on BC self-tagging behavior — the model
  is **lead-curated now**; requiring BC tag-back to deliver the unambiguous
  system version inverts the explicit scope boundary (§3).
- Re-deriving the inter-component dependency map inside the manifest rather than
  **consuming** `lead-h2p0` as its dependency input (§4).

---

#### 7. Grounding artifacts

- [`lead-loos`](#) — this brief's bead; carries the product authority's
  scope-refinement (David, 2026-06-30).
- [`lead-h2p0`](#) — inter-component version-dependency view; the manifest's
  dependency-map input (§4).
- [`lead-6b53`](#) — the `v0.49.0` (templates line) vs `0.3.41` (bc-launcher
  line) ambiguity; the motivating concrete failure (§1).
- [`lead-5xnd`](#) — per-image baked version provenance (OCI labels + ENV);
  a manifest input and validation surface (§5 Q4).
- [`bc-manifest.yaml`](../bc-manifest.yaml) — the existing lead-owned
  declarative fleet registry (ADR-005); the system-version manifest's sibling /
  placement reference (§4).
- [ADR-039](../adr/039-release-cadence-version-bump-is-part-of-the-fix-lead-reinstalls-as-a-cadence-step.md)
  — per-package release cadence; the release-process surface §5 Q3 must
  reconcile with.
- [ADR-021](../adr/021-bc-base-image-owned-by-bc-launcher-auto-rebuilds-on-utility-release.md)
  — `bc-base`/`bc-lead` auto-rebuild on utility release; release-coupling input
  for §5 Q3.
- [ADR-018](../adr/018-empirical-verification-is-contract-surface.md) — the lead
  carries no BC source and cannot tag BC repos directly; why the deferred
  BC-self-tag leg is dispatched-orchestration, not a lead-side edit (§3).
