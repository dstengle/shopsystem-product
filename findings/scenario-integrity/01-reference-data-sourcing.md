# Reference-data sourcing for per-BC `scenarios validate` — design

**Date:** 2026-07-04 · **Branch:** `dagger-spike` · **Lead shop:** shopsystem-product
**Epic:** `lead-vzxd` (scenario data-integrity) · **Guard:** `lead-vzxd.1`
(scenarios-BC `scenarios validate`) · **Links:** `lead-bh2m` (DDD context map)
**Status:** DESIGN ONLY — no `shop-msg` dispatch. Router sends the drafted BC
answer after David's checkpoint. All findings are artifact-surface only (ADR-018).
**Companion records:** ADR-056 (schema + D10 known-value sets), ADR-005
(`bc-manifest.yaml` ownership), ADR-020 (routing registry), ADR-018 (no
cross-BC source on any host), ADR-050 (bc-launcher container provisioning).

---

## 0. The observation, restated precisely

The scenarios BC built `scenarios validate` (guard `lead-vzxd.1`) with an
**injectable seam** (`--manifest` / `--origin-root`, defaulting to repo-local
fixtures) so `tests/22-scenarios` pass. To validate the REAL corpus (and to
run the step-3 backfill this guard gates) the validator needs two reference
inputs that do NOT exist in the `shopsystem-scenarios` repo:

- **(a) the legal `@bc:` / `@service:` value set** — needed by the
  `E_UNKNOWN_BC` / `E_UNKNOWN_SERVICE` checks (ADR-056 D4.3/D9). Authoritative
  home today: `bc-manifest.yaml` `bcs:` / `services:` (lead-owned, reconciled
  2026-07-04 per ADR-056 D10).
- **(b) the legal `@origin:` value set** — needed by `E_UNKNOWN_ORIGIN`
  (D4.4). Authoritative home today: the lead's `adr/` (53) + `pdr/` (29) +
  `briefs/` (15) roots, plus lead bead IDs.

ADR-056 D10 reconciled both sets **on the lead** (STEP 1) — but that STEP 1
artifact never lands in the BC. ADR-018 forbids the BC from reading them
cross-repo. So the core question:

> How does **system-wide reference data** reach a per-BC `scenarios validate`
> that runs INSIDE each BC's gated loop, when ADR-018 forbids cross-BC source
> on any host?

**Key reframing that shrinks the problem (load-bearing):** the two reference
inputs are **membership INDICES, not document corpora**. `E_UNKNOWN_ORIGIN`
asks only *"is `adr-056` a known origin identifier?"* — a set-membership test.
It never reads ADR-056's prose. So what must be distributed is:

- an **index of legal `@bc`/`@service` identifiers** (a curated name list), and
- an **index of legal `@origin` identifiers** (`adr-NNN` / `pdr-NNN` /
  `brief-<slug>` / `lead-<bead-id>` — identifiers only).

**No ADR/PDR/brief BODIES are ever distributed to a BC.** Existence-in-a-
published-index is sufficient for validation. This is what makes the whole
thing tractable under ADR-018: we ship two small curated lists, not the lead's
governance-document tree.

---

## 1. Inventory of candidate authoritative sources

| Candidate | Owner | What it is | Fit as the legal-`@bc` source |
|-----------|-------|-----------|-------------------------------|
| **`bc-manifest.yaml` `bcs:`/`services:`** | LEAD (ADR-005) | Committed, auditable, curated BC + supporting-service registry; already reconciled to the 4 live BCs + 2 provisional + 2 services (ADR-056 D10) | **CURATED, correct today.** Conflates the product context list with production config (remotes, roles, clone targets, provisional flags). The `bcs:`/`services:` *names* are exactly the legal `@bc`/`@service` set. |
| **`shop-msg registry`** | MESSAGING (ADR-020) | The `<system>/<name>` routing/collision key table | **REJECT as source.** ADR-020 + ADR-056 D10 both note it carries THROWAWAYS (`shopsystem-bc-launcher-dagger`, `fabro-e2e*`, `fabro-throwaway`). It is a PRODUCTION routing registry, uncurated — using it as the legal-`@bc` set re-imports exactly the throwaways D10 excluded. |
| **§3.3 Domain & Context Map** | LEAD via `lead-bh2m` (DDD review, in progress) | The authoritative, curated list of bounded contexts + ubiquitous language + scope per BC | **THE PRODUCT-TRUTH SOURCE.** This IS the "which contexts are legal owners" question, as a first-class product artifact rather than a launcher-config side effect. Not yet landed. See §4. |
| **`adr/` `pdr/` `briefs/` roots** | LEAD | Decision-record bodies | Source of the `@origin` **index** (identifiers), NOT distributed as bodies. |

**The tell that `bc-manifest.yaml` is a projection, not the source:** its
provisional entries (`shopsystem-test-harness`, `shopsystem-devcontainer`)
carry `deferred_to: lead-bh2m` — i.e. whether they are *real bounded contexts*
is explicitly a `lead-bh2m` (DDD) decision, not a launcher-config decision. The
manifest is already deferring the product-truth question to the context map.

---

## 2. Product-vs-production framing

David's product-vs-production distinction resolves both halves cleanly.

### (a) The legal `@bc`/`@service` registry is a PRODUCT fact

"Which bounded contexts the domain decomposes into" is a **product fact** —
the domain decomposition itself. Its first-class home is the **§3.3 Domain &
Context Map** that `lead-bh2m` is instantiating. `bc-manifest.yaml` is a
**production-config PROJECTION** of that product fact: it takes the curated
context list and adds the operational fields bc-launcher needs (remotes, roles,
clone targets). The `shop-msg registry` is a pure **production-system fact**
(runtime routing identities) and is *uncurated* — it must NOT be the source.

So: the legal-`@bc` set is a **PRODUCT artifact that must be PUBLISHED/
DISTRIBUTED to BCs** (ADR-018: BCs cannot read it cross-repo). Its authoritative
source is the DDD context map; `bc-manifest.yaml` `bcs:`/`services:` is the
interim curated projection until that map lands.

### (b) The `@origin` corpus: bodies are lead-private; the INDEX is a published product fact

The decision *records* (ADR/PDR/brief bodies) are lead-authored governance
artifacts — effectively lead-private for BC purposes, and ADR-018 says BCs
carry no cross-repo copy of them. But the validator needs only the **index of
which origin identifiers exist** — a published product fact of the same shape
as a version/BOM manifest (ADR-047). The index is publishable; the bodies stay
on the lead. **Existence-in-index is enough for `E_UNKNOWN_ORIGIN`.**

---

## 3. Sourcing mechanism — options, tradeoffs, recommendation

Three delivery topologies, given a curated SOURCE:

### Option (a) — Published reference artifact (furniture / versioned package)

Publish `{context-index, origin-index}` as a versioned artifact through the
existing furniture channel (the `shop-templates` pip package, or a small new
reference package). BCs bake it (like `bc-base` bakes `shop-templates` via a
VCS pin — see `findings/templates-publishing-flow`) or pour it.

- **Pro:** versioned, auditable, offline-capable, git-diffable — matches
  ADR-005's committed-file doctrine and the proven templates distribution path.
- **Con:** a new BC or new ADR requires republish + rebuild/re-pour before BCs
  can validate against it. This lag is **acceptable and arguably correct** —
  adding a BC or an origin is a deliberate product event, not a hot-path change.

### Option (b) — Query service (shop-msg exposes a curated legal-set endpoint)

The validator calls a live `shop-msg`-hosted endpoint for the legal `@bc` set +
origin resolution.

- **Pro:** always fresh, no rebuild lag.
- **Con (disqualifying as primary):** (1) couples gated-loop validation to live
  postgres/`shop-msg` reachability — the validator can no longer run offline in
  the BC loop or in CI; (2) the only existing `shop-msg` registry is the
  UNCURATED routing table (ADR-020) that includes throwaways — exposing it
  re-creates the D10 problem; a *curated* endpoint is net-new `shop-msg`
  behavior + a new coupling; (3) turns a product fact into a runtime service
  call, contradicting ADR-005's self-contained doctrine. **Rejected as primary.**

### Option (c) — Injectable seam stays; bc-launcher provisions the bundle at launch

Keep the validator's `--manifest`/`--origin-root` seam (already built). At
launch, **bc-launcher provisions the curated reference bundle into the
container** and points the seam at it. This reuses machinery bc-launcher
ALREADY runs: it reads `bc-manifest.yaml` (ADR-005), clones the BC into the
container, pours skills furniture, and injects DSN + agent-vault credentials
(ADR-050 P2–P4). "Provision the reference bundle" is one more provisioned input
alongside those.

- **Pro:** the injectable seam the BC built is CORRECT and stays; the launcher
  fills it with the published bundle instead of a repo-local fixture. Bundle is
  as-fresh-as-the-launch (no image rebuild — re-launch/re-inject refreshes it).
  Respects ADR-018: the BC never reads cross-BC source; the launcher — a
  lead-orchestrated component that already holds the manifest — projects the
  curated bundle IN. No new publisher, no new service.
- **Con:** the reference data is only present in launched containers, not in a
  bare `git clone` of the BC — but that is exactly the ADR-018 posture (BCs
  don't self-source cross-repo), and tests keep the repo-local fixture default.

### Recommendation: (a)-as-SOURCE + (c)-as-DELIVERY (they compose)

- **AUTHORITATIVE SOURCE + PUBLICATION (what / who-owns):** the LEAD owns the
  source. The **context-index** is the curated `@bc`/`@service` set (interim:
  `bc-manifest.yaml` `bcs:`/`services:`; target: the `lead-bh2m` context map —
  §4). The **origin-index** is a committed, generated artifact in the lead repo
  (parallel to `bc-manifest.yaml`, ADR-005 auditability) — a flat list of
  `adr-NNN`/`pdr-NNN`/`brief-<slug>` identifiers regenerated from `adr/`/`pdr/`/
  `briefs/`, plus the valid lead bead-ID space. No bodies.
- **DELIVERY (how it reaches the BC):** via option (c) — bc-launcher derives the
  reference bundle from the lead's two committed indices and provisions it into
  each BC container at launch, pointing `--manifest`/`--origin-root` at it. The
  injectable seam STAYS.
- **REJECT (b)** as primary (live-service coupling + uncurated-registry hazard +
  breaks offline validation). Option (a)'s furniture/package channel is a viable
  *alternate* delivery for the same source if launch-provisioning proves
  insufficient (e.g. validating outside a launched container) — noted, not chosen.

### How `@origin` resolves without ADR bodies

`E_UNKNOWN_ORIGIN` is a **set-membership test** against the provisioned
origin-index: `@origin:adr-056` resolves because `adr-056` is a member, not
because the container holds ADR-056's text. The origin ROOT the BC points at is
the **provisioned index**, not the lead `adr/` tree. Bodies are never shipped.
If a future consumer needs provenance *content* (e.g. rendering "why does this
feature exist"), that is a separate docs-publication concern (ADR-008 docs BC),
NOT the validator's — and NOT a reason to distribute bodies now.

---

## 4. Genuine David decision vs architect-settleable

### THE David decision (product-vs-production ownership — surface this)

> **Is the legal bounded-context registry (the `@bc`/`@service` value set the
> validator enforces) a PRODUCT artifact — the published §3.3 Domain & Context
> Map that `lead-bh2m` is producing — of which `bc-manifest.yaml` is merely a
> production-config PROJECTION? Or is `bc-manifest.yaml` itself the authoritative
> source of that set?**

This is the same product-vs-production call David is driving, and it is the
**explicit linkage between `lead-vzxd` and `lead-bh2m`:** the legal-`@bc` set
`scenarios validate` enforces is *literally the context map `lead-bh2m`
produces*. `bc-manifest.yaml` already defers its provisional entries to
`lead-bh2m` (`deferred_to: lead-bh2m`) — so "which names are legal owners" is
already a DDD-review decision in flight.

**Recommended answer (David to confirm):** the DDD context map (`lead-bh2m`) is
the authoritative PRODUCT source of the legal `@bc` set; `bc-manifest.yaml`
`bcs:`/`services:` is its production-config projection. **Until `lead-bh2m`
lands, the reconciled `bc-manifest.yaml` (ADR-056 D10) IS the interim
authoritative source** — which is exactly what the guard's injectable-seam
default already assumes, so nothing blocks.

### Architect-settleable (no David needed)

- **Delivery mechanism:** launcher-provisioned bundle + retained injectable seam
  (option (c)). Recommended above.
- **`@origin` = identifiers-only index, no bodies:** existence-index suffices.
- **Origin-index as a committed generated lead artifact** parallel to
  `bc-manifest.yaml` (ADR-005 auditability); regenerated on ADR/PDR/brief add.
- **Bundle format / versioning / provisioning path** (bake vs mount vs inject):
  a bc-launcher realization detail, settled when that work is decomposed.

### Downstream work this implies (NOT part of guard `lead-vzxd.1`)

1. **bc-launcher** gains reference-bundle provisioning at launch — **net-new
   behavior → `assign_scenarios` to `shopsystem-bc-launcher`** (verify pre-state
   at dispatch; the launcher has no such provisioning today).
2. **Lead** generates + commits the `origin-index` artifact; the context-index
   is `bc-manifest.yaml` today, repointed to the `lead-bh2m` map on that
   review's landing.
3. **`scenarios` BC** needs NO change on this axis — the injectable seam it
   already built is the correct integration point.

---

## 5. Drafted answer to the scenarios BC (do NOT send — router sends post-checkpoint)

**Vehicle:** `clarify_response` (architecture clarify → architect answers).
This is a shape/integration question, not new behavior for the scenarios BC, so
it is a clarify answer, not a `request_maintenance`. **Naming `lead-vzxd.1`.**

> **Re your `mechanism_observation` on `lead-vzxd.1` — reference-data sourcing
> for `scenarios validate`.**
>
> Your injectable-seam design (`--manifest` / `--origin-root`, repo-local
> default) is **correct — keep building on it.** Here is how the real reference
> data reaches you, and how `@origin` resolves. None of this blocks the guard.
>
> 1. **You do NOT sync or source `bc-manifest.yaml` or the `adr/pdr/briefs`
>    roots cross-repo.** ADR-018 forbids any BC reading another shop's source.
>    The reference data is **provisioned INTO your container at launch** by
>    bc-launcher (the same component that already clones you, pours your skills,
>    and injects your DSN/credentials). It fills your existing
>    `--manifest`/`--origin-root` seam with a curated bundle; you keep the
>    repo-local fixture default for `tests/22-scenarios`.
>
> 2. **The reference data is two membership INDICES, not document corpora:**
>    (a) the curated legal `@bc`/`@service` identifier set — authoritatively the
>    lead's reconciled `bc-manifest.yaml` `bcs:`/`services:` (ADR-056 D10), and
>    (b) a legal `@origin` identifier index (`adr-NNN`/`pdr-NNN`/`brief-<slug>`/
>    `lead-<bead-id>`). Build `E_UNKNOWN_BC`/`E_UNKNOWN_SERVICE`/`E_UNKNOWN_ORIGIN`
>    as **set-membership tests against whatever the seam points at** — do not
>    assume a filesystem `adr/` tree.
>
> 3. **`@origin` resolves by existence, not content.** `@origin:adr-056` is legal
>    because `adr-056` is a MEMBER of the origin-index — you do NOT need ADR-056's
>    body. No ADR/PDR/brief bodies are ever shipped to you. Your own dogfooded
>    `features/scenario-integrity` file (`@bc:shopsystem-scenarios`,
>    `@origin:adr-056`) validates green once the bundle carries `shopsystem-
>    scenarios` in the context-index and `adr-056` in the origin-index — both do.
>
> 4. **Interim vs target source:** the reconciled `bc-manifest.yaml` is the
>    interim authoritative context-index; the DDD review (`lead-bh2m`) may
>    repoint it to the published Domain & Context Map. Either way the SHAPE you
>    consume (a legal-identifier set behind the seam) is unchanged — you are
>    insulated from that ownership decision.
>
> **Net for you:** proceed on the injectable-seam default; treat the seam as the
> sole integration point; make the unknown-value checks pure set-membership over
> the provisioned indices. The launcher-provisioning wiring and the origin-index
> publication are separate downstream work (bc-launcher + lead) and do not gate
> your guard.

---

## 6. Summary

- **Recommended sourcing model:** LEAD owns the authoritative source (context-
  index = `bc-manifest.yaml` `bcs:`/`services:` today → `lead-bh2m` context map;
  origin-index = a committed generated identifier list from `adr/pdr/briefs`).
  **bc-launcher DELIVERS** it by provisioning the bundle into each container at
  launch, filling the validator's existing `--manifest`/`--origin-root` seam.
  `@origin` resolves by **index membership** — no bodies distributed.
- **Product-vs-production:** the legal `@bc`/`@service` set is a PRODUCT fact
  (the Domain & Context Map); `bc-manifest.yaml` is its production-config
  projection; the `shop-msg` registry (uncurated, ADR-020) is a pure
  production-system fact and is NOT the source. `@origin` bodies are lead-
  private; the `@origin` INDEX is a published product fact.
- **David decision to surface:** is the legal-context registry the published DDD
  context map (`lead-bh2m`) of which `bc-manifest.yaml` is a projection — the
  explicit `lead-vzxd`↔`lead-bh2m` linkage — with `bc-manifest.yaml` the
  confirmed interim source (guard proceeds either way).
- **Architect-settleable:** launcher-provisioned delivery + retained seam;
  identifiers-only origin-index; committed origin-index artifact; bundle format.
- **BC answer drafted** (clarify_response, naming `lead-vzxd.1`): seam is
  correct, reference data is launcher-provisioned not BC-sourced, `@origin` is
  existence-index membership, guard is not blocked.
