---
id: ADR-034
kind: adr
title: System-global (cross-BC, per-product, non-framework) architecture decisions live in the lead repo's existing `adr/` tree, tagged by tier; the `adr/` tree is NOT split into a second directory
status: accepted
date: "2026-06-10"
description: System-global (cross-BC, per-product, non-framework) architecture decisions live in the lead repo's existing `adr/` tree, tagged by tier; the `adr/` tree is NOT split into a sec...
beads: [lead-architect, lead-cnbu, lead-ir9m]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-018, PDR-013]
  pins: [ADR-035, PDR-013]
  related: []
---
# ADR-034 — System-global (cross-BC, per-product, non-framework) architecture decisions live in the lead repo's existing `adr/` tree, tagged by tier; the `adr/` tree is NOT split into a second directory

**Status:** accepted (2026-06-10)
**Authors:** dstengle, Claude (lead-architect)
**Pins:** the locked design intent recorded on `lead-ir9m` (dave, 2026-06-05)
— decision (3), the system-global tier of the three-tier ADR hierarchy:
*"system-global ADRs (lead repo, per-product, NOT template-delivered, new
home/convention needed)"*. This ADR resolves the system-global-tier slice of
the structural bet
[PDR-013](../pdr/013-bc-decomposition-discipline-and-design-quality-structural-bets.md)
§3 (S3) named-but-deferred to `lead-cnbu`. It is one of the three tiers
[ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md)
defines.
**Anchored to:** [ADR-018](018-empirical-verification-is-contract-surface.md)
(the artifact-surface evidence rule the pre-state findings honor — every
finding below is from this repo's `adr/`/`pdr/` records and directory layout;
no `repos/` BC source).
**Anchored on (PDR):**
[PDR-013](../pdr/013-bc-decomposition-discipline-and-design-quality-structural-bets.md)
(the three-tier hierarchy structural bet, which flagged the system-global tier
as *needing a new home/convention*).
**Related beads:** `lead-cnbu` (this design bead), `lead-ir9m` (the closed
umbrella that locked the three-tier decision).

---

## Context

`lead-ir9m` decision (3) and PDR-013 §3 (S3) name a three-tier ADR hierarchy
and flag one tier as having no home: **system-global** architecture decisions
— cross-BC, per-product structural decisions that are NOT framework-spec
decisions and are NOT BC-local. The flagged gap was *"a new home/convention
needed"* for this tier. This ADR decides that home.

The question is sharp: the lead repo already has an `adr/` tree. Is that tree
the *framework* ADR home (in which case system-global decisions need a separate
directory), or is it already the *per-product lead-repo* ADR home (in which
case system-global decisions already live there and only need a tier
convention)? The answer must be settled empirically, because the PDR-013
framing inherited an assumption — *"distinct from the framework `adr/`"* —
that the pre-state contradicts.

This is a structural / convention decision with no product-UX surface change —
hence an **ADR**, not a PDR.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

Verified from the lead CWD on 2026-06-10 against this repo's `adr/` tree and
directory layout. No BC source involved.

1. **The lead repo's `adr/` tree is ALREADY the per-product / system-global
   home — it is NOT a pristine "framework-spec-only" directory. CONFIRMED**
   (read of the `adr/` titles). Of the 30 ADRs present, the substantial
   majority are **system-global, cross-BC, per-product** decisions, not
   framework-spec edits:
   - ADR-004 (`shopsystem-bc-launcher` as a new BC), ADR-005/ADR-006
     (manifest / name-registry design), ADR-019 (canonicalization owned by
     `shopsystem-scenarios`), ADR-023–025 (scenario-journal decomposition
     across `scenarios`/`messaging`), ADR-026/ADR-028 (agent-vault broker
     standup + ownership) — all are **decisions about how THIS product's BCs
     relate**, i.e. system-global by the very definition the bead gives.
   - Only a minority (ADR-001 framework packaging, ADR-018 the empirical-verification
     doctrine, ADR-015 the `nudge` message type) are framework-spec-shaped, and
     even those are recorded in the same `adr/` tree.
   So the premise *"the framework `adr/` is distinct from a system-global home"*
   is **false on the pre-state**: the existing `adr/` tree is already serving
   as the system-global, per-product home. The "new home needed" framing was an
   inherited assumption, corrected here.

2. **There is NO separate system-global / decisions directory today, and no ADR
   carries a tier tag. CONFIRMED** (`ls -d */` surfaces no `system/`,
   `global/`, or `decisions/` directory; ADRs carry a `Status` / `Authors`
   header but no tier field). So whatever convention is chosen is net-new on
   the convention surface, even though the *directory* already exists.

3. **The framework spec proper lives OUTSIDE `adr/` — in the numbered
   `01-…`–`06-…` section files. CONFIRMED** (`01-principles.md` …
   `06-work-tracking.md`). The genuinely framework-normative text is the spec
   sections; the `adr/` tree is the *decision record* about realizing the
   framework into this product. This is the real distinction: **spec sections =
   framework normative text; `adr/` = product-realization decisions
   (system-global + framework-doctrine ADRs intermixed).** The bead's
   "distinct from framework `adr/`" should be read as "distinct from the
   framework SPEC," which the layout already provides.

4. **@scenario_hash retirement enumeration. CONFIRMED — empty.** Convention/
   home decision; no Gherkin, no pinned coverage touched.

### What could NOT be verified (asserted, not confirmed)

- **Whether a future, multi-product instantiation of the framework would want
  the framework-doctrine ADRs (ADR-001/015/018) physically separated from the
  per-product system-global ones** is a forward-looking concern with no current
  pre-state signal — there is one product (`shopsystem-product`). This ADR
  decides for the present single-product reality and records the forward path as
  an Open question.

---

## Decision

### D1 — System-global architecture decisions live in the lead repo's existing `adr/` tree; do NOT create a second directory

The lead repo's `adr/` tree **is** the system-global, per-product ADR home
(finding 1) — it already holds the cross-BC decisions the bead describes. The
PDR-013 framing's "new home needed" is corrected: **no new directory is
created.** System-global decisions continue to land in `adr/NNN-…md`, in the
existing format (Status, Authors, Context, pre-state empirical findings,
Decision, Alternatives, Consequences, Cross-references). This ADR, ADR-033, and
ADR-035 are themselves system-global ADRs in exactly this home.

The distinction the bead asks for is **"distinct from the framework SPEC,"**
which the layout already provides (finding 3): the framework's normative text is
the numbered `01-…`–`06-…` section files; `adr/` is the decision record about
realizing the framework into this product. We do not split `adr/` into
`adr/framework/` + `adr/system-global/`; splitting a 30-entry tree by a
distinction that is often a judgment call (ADR-018 is arguably both
framework-doctrine and system-global) would add filing friction without a
load-bearing benefit, and would break the flat-NNN cross-reference convention
every existing ADR uses.

### D2 — Tier is recorded as a lightweight header **tag** on each ADR, not a directory

To make the tier *legible* without fragmenting the tree, each ADR SHOULD carry
a tier marker. The three tiers
([ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md)):

- **`framework`** — a decision about the framework spec / doctrine itself
  (e.g. ADR-001 packaging, ADR-015 `nudge`, ADR-018 empirical-verification).
- **`system-global`** — a cross-BC, per-product structural decision (the
  majority; e.g. ADR-019 canonicalization ownership, ADR-026/028 broker, this
  ADR's siblings).
- (`bc-local` is the third tier but lives in the BC repos, not here — ADR-035
  D-BC-local.)

The tag is a one-line addition to the ADR header (e.g. a `**Tier:**` line
alongside `**Status:**`). Existing ADRs are NOT retroactively re-headed in bulk
as a blocking task; the tag is applied going forward and backfilled
opportunistically (the periodic review, ADR-035, is the natural backfill
occasion). The tag is convention, not schema — there is no tool that enforces
it, consistent with the framework's "invariants belong where they can be
enforced" posture (§4.3); its value is the *legibility* it gives the periodic
system-architect review.

### D3 — System-global ADRs are per-product and NOT template-delivered

Consistent with `lead-ir9m` decision (3): system-global ADRs are authored in
*this* product's lead repo and are **not** shipped by `shopsystem-templates`.
Only the *framework*-tier doctrine that genuinely belongs to every product
instantiation could ever be template-delivered, and even that is recorded here
as an `adr/` entry, not pushed from the templates BC. The templates BC ships
*role templates and canonical primers* (PDR-003), not a product's architecture
decisions. This keeps the per-product decision trail local and owned by the
product's lead architect.

---

## Alternatives considered

**Option A — Create a new `adr/system-global/` (or `decisions/`) directory
distinct from a framework-only `adr/`.** Rejected (D1) — the premise is false
on the pre-state (finding 1): the existing `adr/` is *already* the
system-global home; the genuinely framework-normative text is the spec sections
(finding 3), already distinct. A second directory would split a working
30-entry flat tree by an often-ambiguous distinction (ADR-018 is both),
breaking the flat-NNN cross-reference convention every ADR uses and adding
filing friction for no enforced benefit. The bead's "new home needed" was an
inherited assumption the empirical check corrects.

**Option B — Move the framework-doctrine ADRs (001/015/018) OUT of `adr/` into
the spec-section tree, leaving `adr/` purely system-global.** Rejected — those
are *decisions with rejected alternatives and rationale* (ADR shape), not
normative spec prose (spec-section shape). Re-homing them would lose the
decision audit trail the ADR format exists for, and ADR-018's own
Consequences section already cross-references spec sections it revises — the
two surfaces are designed to coexist, not merge.

**Option C — Add a tier *directory* later if/when a second product appears.**
Recorded as the Open-question forward path, not adopted now. Today there is one
product; a tier *tag* (D2) gives the legibility benefit without the split, and
is trivially promotable to a directory split later if multi-product reality
demands it.

---

## Consequences

- **No new directory; the existing `adr/` tree is the system-global home**
  (D1). The "new home needed" flag from PDR-013 §3 / `lead-ir9m` (3) is
  **resolved by correction**: the home already exists; what was missing was the
  *tier convention*, supplied by D2 and ADR-035.
- **Each ADR going forward carries a `**Tier:**` header tag** (`framework` /
  `system-global`) (D2); backfill is opportunistic at the periodic review
  (ADR-035), not a blocking bulk edit. *(This ADR, ADR-033, and ADR-035 are
  the first system-global ADRs that should carry the tag once the tag
  convention itself is ratified — see Open question on whether to backfill the
  three lead-cnbu ADRs immediately.)*
- **System-global ADRs stay per-product and lead-authored**, never
  template-delivered (D3); the templates BC ships role templates, not product
  decisions.
- **The framework SPEC remains the `01-…`–`06-…` section tree** (finding 3),
  distinct from the `adr/` decision record — which is the real distinction the
  bead asked for.
- **No Gherkin authored, no dispatch, no `@scenario_hash` retired** (finding 4).

### Open question (forward path, not decided here)

If/when the framework is instantiated for a **second product**, the
framework-tier doctrine ADRs (001/015/018) may warrant physical separation from
the per-product system-global ones (a shared `framework-adr` vs a per-product
`adr/`). There is no current signal (one product); the tier *tag* (D2) makes
this a cheap future promotion. Flagged for the periodic system-architect review
(ADR-035) to revisit when multi-product reality arrives.

## Cross-references

- [PDR-013](../pdr/013-bc-decomposition-discipline-and-design-quality-structural-bets.md)
  — the three-tier hierarchy bet (S3) whose system-global-tier "new home"
  question this ADR resolves (by correction: the home already exists).
- [ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md)
  — defines all three tiers (framework / system-global / bc-local) and the
  periodic review; this ADR supplies the system-global tier's home + tag.
- [ADR-033](033-bc-local-architect-role-design-sensibility-up-front-no-bc-po.md)
  — itself a system-global ADR living in this home; introduces the BC-local
  architect that produces the bc-local tier.
- [ADR-018](018-empirical-verification-is-contract-surface.md) — the
  artifact-surface evidence rule the pre-state findings honor; also an example
  of a `framework`-tier ADR that coexists in this same tree.
- `01-principles.md`–`06-work-tracking.md` — the framework SPEC sections, the
  surface genuinely distinct from `adr/` (finding 3).
- [lead-cnbu](beads:lead-cnbu), [lead-ir9m](beads:lead-ir9m).
