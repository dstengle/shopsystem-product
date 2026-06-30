# PDR-030 — The shopsystem system version is an independent standard semver mapped to a component-version tuple by a lead-owned BOM manifest

**Status:** draft (2026-06-30)
**Authors:** David Stenglein (product authority), Claude (lead-po)
**Lead bead:** [`lead-loos`](#) (P2) — *System build manifest (BOM): explicit
component versions mapped to one overall system release version.*
**Brief:** [Brief 015](../briefs/015-shopsystem-system-version-manifest-bom.md)
**Precursor input:** [`lead-h2p0`](#) (P2) — inter-component version-dependency
view; the manifest consumes its data, does not re-derive it.

**Anchored to** the product-authority decision (David, 2026-06-30) recorded on
`lead-loos`:

> The shopsystem **system version uses STANDARD SEMVER** (MAJOR.MINOR.PATCH),
> **INDEPENDENT of the underlying component versions.** The lead-owned manifest
> maps each shopsystem semver to its component-version tuple (the BOM), but the
> system semver is its **OWN line, bumped by product semantics** — it is NOT
> derived or computed from component-version bumps.

That statement pins both scope and vocabulary for this PDR — no discovery
workshop was required.

**Anchored on (decisions this builds on — NOT re-decided here):**

- [Brief 015](../briefs/015-shopsystem-system-version-manifest-bom.md) — the
  model (lead-owned BOM; system version names a component tuple) and the
  motivating `lead-6b53` ambiguity.
- [ADR-005 / PDR-006](006-bc-manifest-ownership.md) — `bc-manifest.yaml`, the
  existing lead-owned declarative fleet registry at repo root; this manifest's
  placement sibling.
- [ADR-039](../adr/039-release-cadence-version-bump-is-part-of-the-fix-lead-reinstalls-as-a-cadence-step.md)
  — per-package release cadence (a version bump is part of the fix, dispatched
  as `request_maintenance`); component lines continue under it unchanged.
- [ADR-021](../adr/021-bc-base-image-owned-by-bc-launcher-auto-rebuilds-on-utility-release.md)
  — `bc-base`/`bc-lead` auto-rebuild on utility release; release-coupling input.
- [`lead-5xnd`](#) — per-image baked version provenance (OCI labels + ENV); a
  manifest input and the coherence-check surface (Q4).
- [ADR-018](../adr/018-empirical-verification-is-contract-surface.md) — the lead
  carries no BC source and cannot tag BC repos directly; why BC self-tagging is
  a deferred dispatch-orchestration leg, not a lead-side edit (Q5).

---

## Point of intent

Today "shopsystem vN" names nothing coherent: the product ships as four
independently-versioned component lines (`shop-templates` 0.4x,
`bc-launcher` 0.3.x, `messaging` 0.4.x, `scenarios` 0.2.x). This bit us
concretely on `lead-6b53` — "release v0.49.0" silently meant the
*templates* line, while the bootstrap fix that needed releasing shipped on
the *bc-launcher* line at 0.3.41, and the dispatch had to carry a hand-written
prose footnote disambiguating the two.

The observable behavior change this PDR enables: **the lead (and anyone reading
the lead repo) names one authoritative `shopsystem vN` and resolves it to the
exact tuple of component versions it composes** — so "release vN", "test vN",
and "what version is this?" are answered from one curated artifact rather than
reconstructed across four moving lines.

This PDR settles the **product-level** decisions Brief 015 framed. Where a
question needs an architectural mechanism (exact file schema, doctor-check
internals, release-tool wiring), it is **framed for an architect ADR follow-up**
and explicitly NOT decided here.

---

## The decisions

### D1 — The system version is an independent standard semver (resolves Brief 015 Q1) — THE ANCHOR DECISION

The shopsystem system version is **standard semver `MAJOR.MINOR.PATCH`**, on its
**own line, independent of the component versions.** It is **bumped by product
semantics** — a deliberate product-release decision — and is **NOT derived,
computed, or auto-incremented from component-version bumps.**

The manifest **maps** each system semver to the component tuple it composes; the
mapping is the BOM. The mapping direction is *system semver → component tuple*,
not *component bumps → system version*.

**Worked example (the canonical illustration):**

> `shopsystem v1.3.0` = `{shop-templates: v0.48.0, bc-launcher: v0.3.41,
> messaging: v0.4.4, scenarios: v0.2.0}`. The next system bump to `v1.4.0` is a
> **product decision** — not a function of which component changed. A component
> could bump (say `messaging` → 0.4.5) and the product authority may choose to
> roll `v1.3.1`, `v1.4.0`, or hold at `v1.3.0` with an updated pin, per product
> semantics — the manifest records the choice; it does not dictate it.

**Rationale.**

1. **Decouples release identity from component churn.** The four component lines
   move independently and frequently (ADR-039 makes every fix a version bump).
   A system version *derived* from those bumps would inherit their churn and
   their arithmetic ambiguity — exactly the `lead-6b53` failure, where the
   "system version" was silently one component's line. An independent line gives
   the product a stable, intentional release identity that component activity
   cannot perturb.

2. **Makes "release vN" unambiguous.** A standard semver on its own line means
   "release v1.4.0" denotes exactly one thing: the system release whose tuple
   the manifest pins. No footnote, no "which line did you mean?" The
   `lead-6b53` disambiguation cost disappears because the system version no
   longer borrows a component's number.

3. **Standard semver is the least-surprise scheme.** Adopters, operators, and
   tooling already understand `MAJOR.MINOR.PATCH`. The product authority chose
   it deliberately over a bespoke counter, date/serial, or change-kind-derived
   scheme (the alternatives Brief 015 Q1 weighed) precisely so the system
   version reads like any other product's version.

4. **Product semantics, not mechanics, own the bump.** What constitutes a
   MAJOR vs MINOR vs PATCH system release is a product-meaning judgment
   (breaking adopter-facing change vs additive capability vs fix-level roll-up),
   owned by the product authority — not an automation over component diffs.

**Framed for architect ADR (NOT decided here):** the bump *guidance* (what
component/product changes typically motivate MAJOR vs MINOR vs PATCH) may be
documented as convention, but the bump itself stays a product call; the ADR
need only ensure the manifest records the chosen semver explicitly.

### D2 — A lead-owned, declarative YAML manifest at repo root, sibling to `bc-manifest.yaml` (resolves Brief 015 Q2 at product level; schema framed for ADR)

The manifest is a **committed, lead-owned, declarative YAML file at the lead
repo root**, a **sibling of `bc-manifest.yaml`** — the same *kind* of artifact
one level up. Where `bc-manifest.yaml` declares *which* BCs compose the product,
the system-version manifest declares *which versions* of them compose a given
system release.

**Product-level decisions recorded:**

- **Format:** YAML, declarative, committed (not gitignored), well-known path —
  matching `bc-manifest.yaml`'s contract shape so the same operator/tooling
  expectations carry over.
- **Proposed name:** `system-manifest.yaml`. (`versions.yaml` is the
  alternative; `system-manifest.yaml` is preferred because it reads as the
  system-level peer of `bc-manifest.yaml`.)
- **A separate file, not an extension of `bc-manifest.yaml`.** `bc-manifest.yaml`
  answers *which BCs exist and where their remotes are* (a fleet-membership
  registry); the system manifest answers *which versions compose release vN*
  (a release roll-up). Different jobs, different change cadences, different
  readers — keep them as siblings, consistent with PDR-029's "different
  questions, different vehicles" reasoning.
- **Content floor:** at minimum, a top-level `system_version:` (the standard
  semver of D1) and a `components:` map pinning each component (`shop-templates`,
  `bc-launcher`, `messaging`, `scenarios`, future components) to its explicit
  version.

**Framed for architect ADR (NOT decided here):**
- Exact schema/field shape (single-version file vs. a `releases:` history list
  retaining prior system versions; key names; whether dependency-coherence
  metadata from `lead-h2p0` is embedded or referenced).
- Whether prior system versions are retained as in-file history or via git tags
  on the lead repo.

### D3 — The manifest is the lead-side record that defines a system release; component release cadence (ADR-039) is unchanged and composes into it (resolves Brief 015 Q3 at product level)

**Product-level decisions recorded:**

- **Component releases continue under ADR-039 unchanged.** The 0.3.x/0.4.x/0.2.x
  lines keep moving per-package: a version bump is part of the fix, dispatched as
  `request_maintenance`, lead reinstalls as a cadence step. This PDR does **not**
  alter that cadence, and ADR-021 auto-rebuild coupling is untouched.
- **The manifest composes those component versions into a system semver at
  system-release time.** A "system release" is the act of: choosing a coherent
  component tuple (from versions already released under ADR-039), pinning it in
  `system-manifest.yaml`, and assigning it the product-chosen system semver (D1).
  The component lines are the *input*; the system semver is the lead's
  *composition* over them.
- **The manifest is the authoritative record of a system release.** When the
  product authority says "release vN," the manifest is the artifact that names
  the tuple `vN` is. Whether the manifest *also* drives a coordinated release
  (orchestrating component bumps) versus only *captures* an assembled tuple is a
  mechanism question; the product-level commitment is that the manifest is at
  minimum the **authoritative captured record**, eliminating the `lead-6b53`
  reconstruct-by-hand cost.

**Framed for architect ADR (NOT decided here):** whether a system release is
manifest-*driven* (the manifest is the input a release tool reads to coordinate
component pins) or manifest-*capturing* (the tool records an after-the-fact
tuple), or both; how the assemble/validate tooling is rendered (the `lead-loos`
router/architect recommendation: shop-templates-rendered furniture so every
product gets it) and how it reads ADR-039 component releases and ADR-021
rebuild state.

### D4 — Coherence validation is ADVISORY at authoring/dev-time, BLOCKING at adopter bootstrap/stand-up (resolves Brief 015 Q4)

The lead may validate a manifest tuple for coherence — does the pinned tuple
actually hold together per the `lead-h2p0` dependency view, and does it match
what is published per `lead-5xnd` baked image labels/ENV? The posture is
**split by gate**: **ADVISORY at authoring/dev-time** (warn on drift, do not
block) and **BLOCKING at adopter bootstrap / stand-up** (refuse to stand up an
incoherent tuple).

**Rationale.** Advisory-first matches the manifest's role as a curated record:
the lead author is the authority on the tuple, and a hard block would invert
that by letting a doctor/bootstrap probe veto a deliberate product decision
(e.g. pinning a tuple the dependency view has not yet caught up to). Warning
surfaces drift loudly without seizing authorship — consistent with the
doctor-diagnosis posture of PDR-024 (name + status + remediation hint), where
the verdict informs rather than forecloses.

**RESOLVED (product authority, David, 2026-06-30): BLOCK at adopter bootstrap /
stand-up; advisory everywhere else.** An adopter must not stand up an incoherent
component tuple — it yields a silently-broken system (the class of failure the
stale-image bootstrap bugs caused). The bootstrap/stand-up coherence check is
therefore a **hard gate**: it refuses to proceed on an incoherent tuple,
consistent with the "doctor gates operations" direction (`lead-arp1`).
Authoring- and dev-time validation stays **advisory** so it never blocks
iteration on a deliberately-ahead-of-the-dependency-view pin.

**Framed for architect ADR (NOT decided here):** whether the coherence check is
a `doctor` check (cf. PDR-024 D2's check set), a `bootstrap` step, or both; the
exact comparison mechanics against `lead-h2p0` and `lead-5xnd` baked labels; the
warning surface shape.

### D5 — BC self-tag handshake is DEFERRED / out of scope (resolves Brief 015 Q5)

The manifest is **lead-curated for now** (product authority, explicit). The lead
authors and maintains the component→version map and the system semver by hand or
lead-side tooling, reading inputs it already has (`lead-5xnd` baked provenance,
`lead-h2p0` dependency view, component repo tags).

**BC self-tagging — each BC tagging its own component version into its own repo
as part of system-release assembly — is a DEFERRED FUTURE LEG, explicitly out of
scope here.** It is named (not designed) so it is neither silently assumed nor
re-litigated: when it lands, it would be lead-*dispatched* tag-reflection (the BC
tags its own repo, since per ADR-018 the lead carries no BC source and cannot tag
BC repos directly). The *direction* of the future handshake (manifest drives BC
tagging vs. BC tags become an input the manifest reconciles) is left open as part
of that deferred leg; this PDR commits only that the first increment is
lead-curated and depends on **no BC behavior change.**

---

## Why a PDR (why this would be re-asked)

- **Why an independent semver and not a derived/computed system version?** D1's
  rationale is the record: deriving from component bumps re-creates the
  `lead-6b53` ambiguity and inherits four lines of churn. The decoupling is the
  whole point and would be re-questioned otherwise.
- **Why a separate manifest file, not a field on `bc-manifest.yaml`?** D2 records
  it: membership registry vs. release roll-up are different jobs with different
  cadences and readers.
- **Why advisory at authoring but blocking at bootstrap?** D4 records it: the
  lead author owns the tuple at authoring time (a hard veto there would invert
  authorship), but an adopter must not stand up an incoherent tuple — so the
  bootstrap/stand-up gate blocks.
- **Why is BC self-tagging not in the first increment?** D5 records the explicit
  product-authority scope boundary and the ADR-018 reason it is dispatch-
  orchestration rather than a lead edit.

---

## Decomposition / dispatch (architect, later — NOT done here)

This PDR records product-level decisions; it authors no Gherkin and dispatches
nothing. The architect's follow-up surface:

- **Architect ADR** settling D2's exact manifest schema, D3's release-tool wiring
  (manifest-driven vs. capturing; shop-templates-rendered assemble/validate
  furniture) and its reconciliation with ADR-039/ADR-021, and D4's doctor/
  bootstrap coherence-check mechanics.
- **lead-po** then authors the Gherkin scenarios pinning the manifest's
  presence/shape and the advisory coherence behavior, once the ADR fixes the
  schema/mechanism.
- Depends on `lead-h2p0` (dependency-view input) landing for D4's coherence
  comparison to have a data source.
