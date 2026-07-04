# PHASE 3 — the corpus backfill (epic lead-vzxd)

**Date:** 2026-07-04 · **Branch:** `dagger-spike` (main untouched) · **Lead shop:**
shopsystem-product · **Blocks:** DDD review `lead-bh2m`
**Status:** DESIGN + dispatch-specs ONLY — **NO `shop-msg` send.** Router
dispatches after David's checkpoint. All findings are artifact/`bd export`
surface only (ADR-018 D1/D2).
**Companion records:** ADR-056 (schema, D6 feature=decision×context, D7 BC
self-tagging, D8 defined-end gate, D10 known-value sets, D11 cutover), ADR-018
(no cross-BC source on any host), ADR-005 (`bc-manifest.yaml`), ADR-028
(services model), ADR-047 (`bin/doctor` aggregate coherence gate), ADR-023/024/025
(scenario journal). **Builds on:** `00-design.md`, `01-reference-data-sourcing.md`,
`02-reference-pipeline.md`.

Phase 1 (the GUARD) is DONE: `scenarios` **v0.3.0** is installed on the lead and
provides `validate` / `create` / `consolidate`, off-the-shelf gherkin-official
parsing, name-extraction from the real dict-entry `bc-manifest.yaml`, and
`--origin-index` membership. This phase designs the one-time backfill that drives
the corpus to the ADR-056 D8 defined-end.

---

## 0. Empirical pre-state of the corpus (this session, artifact surface)

Measured over `/workspace/features/` (the LEAD MIRROR):

| Fact | Value | How measured |
|------|-------|--------------|
| `.gherkin` legacy files | **484** | `find features -name '*.gherkin'` |
| `.feature` files | **1** (the guard) | `find features -name '*.feature'` |
| scenarios (parser) | 562 across 484 files | ADR-056 pre-state (`scenarios list`) |
| files with a real `^@bc:` **tag line** | **53 (~11%)** | `grep -rlE '^@bc:'` |
| files matching `@bc` as substring (incl. **comments**) | 91 | `grep -rl '@bc'` |
| files with a real `^@origin:` tag | **0** | `grep -rlE '^@origin:'` |
| files with a real `^@scenario_hash:` tag | **417** | `grep -rlE '^@scenario_hash:'` |
| files with a `^Feature:` line | 114 (→ 370 have NONE) | `grep -rlE '^Feature:'` |
| legacy owner tag still in use | `@lead_integration:templates` (13) | tag-line grep |

**Correction to the phase framing (empirically):** the "~18% carry `@bc`" figure
is the *comment-inclusive* 91; the real **`@bc:` tag-line** coverage is **53
(~11%)**, and **zero** files carry a real `@origin:` tag. The single `.feature`
already conformant is the guard. So the backfill must produce `@bc` + `@origin`
tags for essentially the whole corpus, preserve the 417 existing hashes, and
stamp hashes on the ~145 scenarios that lack one.

**The jumble is real.** `features/templates/` (225 files) mixes owners: 72 of its
files reference messaging surfaces (`nudge`/`shop-msg`/`mailbox`/`inbox`/`outbox`)
— i.e. `shopsystem-messaging`-owned behavior filed under `templates/`. Directory
name is NOT owner (ADR-056 rejected directory=owner); the true owner is BC
self-knowledge.

**The aggregate gate is BLIND to `.gherkin` today (reproduced).**
`scenarios validate --aggregate features/ --manifest bc-manifest.yaml
--origin-index scenario-refs/origin-index.txt` returns **exit 0** — because
`--aggregate` globs **`*.feature` only** (confirmed in `validate --help`: "over
every .feature file under it"). It sees the 1 conformant guard and passes,
silently ignoring 484 non-conformant `.gherkin`. **A stray-`.gherkin` guard is
mandatory in enforcement** (§4) or the defined-end gate is trivially satisfiable
by leaving the whole corpus unmigrated.

**Reference artifacts + helpers are ready (verified):** `bc-manifest.yaml`
(dict `bcs:`/`services:`), `scenario-refs/origin-index.txt` (112 ids: 53 adr +
29 pdr + 15 briefs; `adr-056` present), `bin/gen-scenario-refs`, and the
`scenarios create`/`consolidate` helpers (both take `--feature-name --bc
--origin` + bare body files; `consolidate` preserves each pre-consolidation
block-only hash; `create` stamps hashes on bare bodies).

---

## 1. TARGET SHAPE

Every scenario lands in a **`Feature:`-headed `.feature` file** whose unit is
**(originating decision × owning context)** (ADR-056 D6):

```
@bc:<owner>            # feature-level, inherited — exactly one, a known context
@origin:<ref>          # feature-level, inherited — exactly one; ref = adr-NNN|pdr-NNN|brief-<slug>|<lead-bead-id>
[@service:<name>]       # feature-level, 0..1 — only when a supporting service (postgres|agent-vault-broker) is exercised
Feature: <name>
  @scenario_hash:<16hex>   # per-scenario, = parser block-only hash (preserved)
  Scenario: ...
  @scenario_hash:<16hex>
  Scenario: ...
```

- **Extension:** `.gherkin → .feature`. Off-the-shelf `@cucumber/gherkin`-valid
  (forces the `Feature:` header that 370 files lack).
- **Grouping key = `@origin`** = the originating decision, derived from
  beads+briefs+pdrs+adrs (lead-side floor ~50.5%, drift-independent; BC
  self-tagging raises it via each BC's own repo history). Residue →
  `@origin:unresolved`.
- **`@bc` = owning context**, from BC self-knowledge (near-100% in-repo). Residue
  → `@bc:unassigned`.
- Both `@bc:unassigned` and `@origin:unresolved` are **TRANSITIONAL forcing
  markers**, driven to zero by the aggregate gate (ADR-056 D8). They are the
  measured backfill deficit, not permanent honest defaults.
- **Hash discipline:** block-only, parser path; hash-preserving via
  `consolidate`/`create` (verified 100% reproduction, findings/00 §B). The
  ~145 currently-hashless scenarios get their block-only hash stamped by the
  helper on emit.

---

## 2. THE LEAD-MIRROR QUESTION — decision + rationale

**Question:** does the lead HAND-TAG/consolidate its 484 jumbled `.gherkin` in
place, OR REBUILD the mirror from the BCs' backfilled+tagged registers (via
`request_scenario_register`) after the per-BC sweeps?

### DECISION: REBUILD-FROM-REGISTERS is primary; HAND-TAG only the genuinely lead-owned residue. (Hybrid, register-led.)

**Rationale — hand-tag-in-place is structurally incapable of reaching the
defined green end:**

1. **It caps at the lead's ~40% derivability ceiling.** Owner-by-hash resolves
   only 29.5% (56% of pinned hashes have drifted, ADR-056 pre-state); with tags
   + work_id inference ~40%. For the ~60% residue the lead can only stamp
   `@bc:unassigned` — and it can **never drive those to zero**, because ADR-018
   forbids it reading BC repos to discover the true owner. Hand-tag-in-place
   therefore cannot satisfy ADR-056 D8 (zero `@bc:unassigned`). The defined end
   is *unreachable* on this path for the majority of the corpus.
2. **The mirror is a derived VISIBILITY projection, not the canonical source.**
   Per ADR-018 each BC's own repo is the canonical owner of its scenarios; the
   lead mirror is a projection (findings/00 A.iii: the register vehicle is
   visibility-only). Hand-tagging the projection in place *manufactures a second
   source of truth* that will diverge from BC-side truth — the exact drift this
   whole effort exists to kill.
3. **It preserves the jumble.** The 72 messaging-owned files under
   `templates/`, and every other misfiled scenario, stay mislocated; the lead
   would have to correctly relocate each — again a per-scenario true-owner
   resolution it cannot do past ~40%.

**Rebuild-from-registers** makes the mirror an honest projection: each BC
self-tags in its own repo (near-100% `@bc`, high `@origin` from its own
history), emits its conformant register, and the lead **regroups by (origin ×
bc) and replaces** the jumbled `.gherkin`. The only scenarios the lead tags
directly are the ones it *authoritatively owns* — the `@bc:shopsystem-product`
lead integration surface (ADR-028: the agent-vault-broker/postgres integration
checks, 13 files, + the `bc-manifest`/doctor/coherence lead-owned scenarios),
which no BC will claim.

**Post-cutover mechanic (ADR-056 Consequences):** `request_scenario_register`
becomes the RETURN PATH carrying `@bc`/`@origin` + scenario bodies back into the
mirror. The rebuild consumes those.

**Is this a David decision?** The **mechanism** (register import + regroup) is
**architect-settleable** — it follows directly from ADR-018 (BC repo is
canonical) + ADR-056 D7/D8 (BC self-tagging, defined-end). Two aspects carry a
product implication worth a **David nod, not a blocking question**:
(a) the rebuild is **destructive** to committed lead `.gherkin` (they are
replaced, migrated-then-deleted on `dagger-spike`); (b) the **lead-owned vs
BC-owned boundary** for ambiguous scenarios (the `@bc:shopsystem-product` set)
overlaps the already-open service-ownership decision (findings/00 §D.3). Both
are surfaced in §5; the recommendation stands and proceeds absent objection.

---

## 3. PER-BC BACKFILL — dispatch specs (do NOT send)

Four LIVE BCs sweep their OWN repos: `shopsystem-messaging`,
`shopsystem-scenarios`, `shopsystem-templates`, `shopsystem-bc-launcher`. The
two PROVISIONAL contexts (`shopsystem-devcontainer`, `shopsystem-test-harness`)
are **not-live** — no running loop to self-tag — so they are NOT swept; their
scenarios are lead-side residue gated on `lead-bh2m` (§4/§5).

**Vehicle for all four: `request_maintenance` (MT).** Discriminator, run per
ADR-056 sufficiency order:
- **Q1 — capability exists?** YES. The scenarios already exist and are already
  pinned in the BC repo (they carry `@scenario_hash`). Contract-surface
  citation: the lead-held `features/` mirror carries 417 `^@scenario_hash:` tag
  lines whose bodies the parser reproduces 100% (ADR-056 §B); nothing net-new is
  being introduced. → not `assign_scenarios`.
- **Q2 — pinned?** YES (`@scenario_hash` present). → not a `request_bugfix`
  tightening of unpinned behavior.
- **Q3 — behavioral or flat?** **FLAT.** Adding feature-level `@bc`/`@origin`,
  regrouping bare scenarios into `Feature:`-headed files, and stamping/preserving
  `@scenario_hash` is metadata + structure only — **no new scenarios, no
  behavioral change, every hash preserved** (verified hash-preserving). →
  `request_maintenance`.
- **@scenario_hash conflict enumeration (ADR-056 sufficiency Q5):** the sweep
  **retires/supersedes NOTHING** — it is hash-preserving by construction, so
  there is no conflicting `@scenario_hash` set to enumerate/retire. Each dispatch
  instead asserts hash-preservation as a measurable acceptance criterion (below).
  (The receiving BC re-runs `grep -r "@scenario_hash"` + `scenarios hash` in its
  own repo to confirm on emit.)

### Common dispatch body (per BC, parameterized by `<self>`)

> **`request_maintenance` — one-time scenario-schema backfill (ADR-056), your repo.**
> **work_id:** `<fresh lead bead — one per BC>`. **Precondition:** pin
> `scenarios` **v0.3.0** (provides `validate`/`create`/`consolidate` + hardened
> dict-manifest name-extraction + `--origin-index` membership).
>
> **What:** bring every scenario in your `features/` corpus to the ADR-056
> three-dimension schema. This is a FLAT structural change — no new scenarios,
> no behavior change, every `@scenario_hash` preserved.
>
> **Steps (mechanical, use the helper):**
> 1. **Group** your scenarios into features by **(originating decision × this
>    context)** — scenarios sharing an originating decision form one feature.
> 2. For each group, emit a conformant `.feature` via
>    `scenarios consolidate --feature-name <name> --bc <self> --origin <ref>
>    <bare-body-files…>` (or `create` for a single-scenario group). The helper
>    stamps/preserves each block-only `@scenario_hash`. Rename `.gherkin →
>    .feature`; the old bare files are replaced.
> 3. `@bc` = **`<self>`** for everything you own (you own your whole repo →
>    near-100%; no `@bc:unassigned` should remain for you). Add `@service:<name>`
>    (feature-level) only where a scenario exercises `postgres` or
>    `agent-vault-broker`.
> 4. `@origin` = the originating decision, derived from your OWN repo history
>    (commits/PRs/beads) + the in-file ADR/PDR/brief/bead references. Residue you
>    genuinely cannot resolve → `@origin:unresolved` (transitional; list them in
>    your `work_done` so the lead can help resolve).
> 5. **Run `scenarios validate` on each emitted file (and
>    `--aggregate features/`) to GREEN before emit**, using the inline reference
>    data below via `--manifest`/`--origin-index`.
>
> **Reference data — CONVEYED INLINE (do not source cross-repo; ADR-018):**
> - **Legal `@bc:` set** — `shopsystem-messaging`, `shopsystem-scenarios`,
>   `shopsystem-templates`, `shopsystem-bc-launcher`, `shopsystem-test-harness`,
>   `shopsystem-devcontainer`, plus the lead product token
>   `shopsystem-product`, plus `unassigned`. (You self-tag as `<self>`.)
> - **Legal `@service:` set** — `postgres`, `agent-vault-broker`.
> - **Legal `@origin:` set** — the 112-identifier `origin-index.txt` (adr-001…
>   adr-056, pdr-001…pdr-029, brief-001…/brief-<slug>), plus your own lead bead
>   ids (resolve via the `lead-*`/`shopsystem-*` prefix rule), plus
>   `unresolved`. [Attach `scenario-refs/origin-index.txt` verbatim as a bundle
>   file; point `--origin-index` at it.]
> - **Beads-derived SEED/cross-check** (NOT the resolver — ADR-056 D7): [attach
>   the lead's `hash→@bc`/`@origin` map for scenarios that hash-resolve to
>   `<self>`]. Use it to cross-check; your own repo is authoritative where they
>   disagree.
>
> **Acceptance (measurable):** `scenarios validate --aggregate features/` exits
> 0 in your repo; **zero `@bc:unassigned`**; every emitted `@scenario_hash`
> equals its pre-consolidation block-only hash (re-run `scenarios hash`/`list` to
> confirm); `@origin:unresolved` minimized with each residual listed + reason in
> `work_done`; no `.gherkin` remains under `features/`.

### Provisioning INLINE vs FIRST — decision

**Convey the reference data INLINE in each dispatch. Provisioning does NOT come
first.** Spec B from findings/02 (bc-launcher provisions the bundle at launch)
is **net-new bc-launcher work deferred to enforcement** and would serialize the
entire backfill behind a bc-launcher dispatch. The reference data is small (a
name list + a 112-line index), the validator's injectable seam
(`--manifest`/`--origin-index`) already accepts a supplied file, and Spec A
(v0.3.0 hardening) is ALREADY LANDED — so inline conveyance unblocks all four
sweeps immediately and in parallel. Launcher provisioning becomes the *durable*
delivery for the going-forward enforcement gate (§4), not a backfill precondition.

### Per-BC seed sizing (from the lead-side beads map — a SEED only)

The lead mirror's directory jumble is NOT a reliable owner map (dir≠owner), but
it sizes the sweep and seeds the cross-check. Indicative (BC self-knowledge is
authoritative and WINS on conflict):

- **`shopsystem-messaging`** — `messaging/` (38) + `messaging-registry/` (57) +
  the ~72 messaging-surface files misfiled under `templates/` + service-dep
  scenarios touching `postgres`. Largest `@service:postgres` surface.
- **`shopsystem-templates`** — the bulk of `templates/` (225 minus the
  messaging/scenarios-owned misfiles) + `bc-manifest`-render + `docs`/render
  surfaces it owns. The 13 `@lead_integration:templates` legacy tags convert to
  `@bc:shopsystem-templates`.
- **`shopsystem-scenarios`** — `scenarios/` (12) + `scenario-journal/` (9,
  ADR-023/024/025) + the canonicalization/hash-rule scenarios misfiled under
  `templates/` + its own `scenario-integrity` dogfood.
- **`shopsystem-bc-launcher`** — `bc-launcher/` (66) + `launcher-credentials/`
  (8) + `fabro-orchestration/` (4, ADR-048–051) + `dagger-ci/` (4, ADR-052–055)
  + `@service:agent-vault-broker` dep scenarios.

Every BC gets its own fresh lead bead as `work_id`.

---

## 4. REACHING GREEN — the defined end + "system-consistent" across corpora

**Defined end (ADR-056 D8):** the **ADR-047 aggregate coherence gate is GREEN**
over the relevant corpus — **full schema conformance + zero `@bc:unassigned` +
zero `@origin:unresolved`**.

**The stray-`.gherkin` blind spot MUST be closed in ENFORCEMENT.** As reproduced
(§0), `--aggregate` globs `*.feature` only → the gate passes while 484
`.gherkin` sit unmigrated. Fold a **stray-source guard** into the enforcement
work (findings/00 C6, `shopsystem-templates`-owned `bin/doctor` wiring):

> the aggregate gate FAILS if any `*.gherkin` (or any non-`.feature`
> scenario-shaped file) remains under a scenario root.

Without this the defined-end is satisfiable by *ignoring* the corpus, not by
migrating it. This is a small BF against the existing gate — spec it as part of
C6, not Phase 3, but Phase 3 DEPENDS on it for a meaningful DONE.

**Progress tracking DURING backfill (by counting, since the gate is not yet
teeth-bearing over `.gherkin`):** per corpus, track to zero —
(1) `.gherkin` files remaining, (2) `@bc:unassigned` count, (3)
`@origin:unresolved` count, and up — (4) conformant `.feature` count
(`scenarios validate` exit 0). DONE per corpus = (1)=(2)=(3)=0.

**"System-consistent" is MULTI-CORPUS.** DONE is not one aggregate run — it is:
- **Each of the 4 live BC repos** green under its own `scenarios validate
  --aggregate features/` (enforced going-forward by its `bc-emit` gate, C6), AND
- **The lead mirror** green under the same gate (rebuilt from the imported
  registers + the lead-owned integration scenarios), AND
- The mirror is a **faithful projection** of ⋃(BC registers) ∪ (lead-owned
  scenarios) — no scenario owned by two corpora, none dropped.

**Provisional-context GATE on `lead-bh2m` (important).** The `devcontainer` (17)
+ `test-harness` (5) = **22** mirror scenarios belong to contexts whose *in/out
as bounded contexts is deferred to `lead-bh2m`* (`bc-manifest` `deferred_to:
lead-bh2m`). No live loop can self-tag them. So **full system-green is BLOCKED
on `lead-bh2m`** for that residue: either the lead hand-tags them
`@bc:shopsystem-devcontainer`/`-test-harness` (legal manifest values) with
best-effort `@origin`, OR `lead-bh2m` folds/retires them. This is the one place
the defined-end is not purely mechanical — flagged as a David/`lead-bh2m` scope
call (§5).

---

## 5. SEQUENCE + David-decision vs architect-settleable

### Sequence

```
0. [DONE] scenarios v0.3.0 installed; guard + --aggregate + create/consolidate
   exist; bc-manifest.yaml (dict bcs/services) + scenario-refs/origin-index.txt
   + bin/gen-scenario-refs committed on dagger-spike.                    [lead]
        │
1. Mint fresh backfill beads: one per live BC (4) + one lead-owned-mirror bead
   + one enforcement bead (stray-.gherkin guard, C6). Compute the per-BC
   beads-derived SEED map. bd dep: mirror-rebuild AFTER the 4 BC sweeps.  [lead]
        │
2. Dispatch 4 per-BC MT sweeps IN PARALLEL (reference data inline; precondition
   each pins scenarios v0.3.0). Each self-tags + consolidates + validates green
   in its own repo, then emits work_done.               [MT → each live BC]
        │
3. As each work_done lands: reconcile (register lands, hashes match, residual
   @origin:unresolved list captured). Then request_scenario_register to import
   the BC's conformant tagged register into the lead mirror.        [lead+architect]
        │
4. Lead-mirror REBUILD: regroup imported registers by (origin × bc) into
   .feature files; DELETE the migrated .gherkin; hand-tag the genuinely
   lead-owned integration scenarios (@bc:shopsystem-product) directly.    [lead]
        │
5. Provisional residue (devcontainer/test-harness, 22): hand-tag best-effort OR
   park behind lead-bh2m (see David decision 3).             [lead / lead-bh2m]
        │
6. ENFORCE (C6, templates-owned): add the stray-.gherkin guard to the aggregate
   gate + wire into bin/doctor; cut over (deauthorize beads, ADR-056 D11).  [BF→templates]
        │
7. Aggregate gate GREEN over ALL corpora (4 BC repos + lead mirror), zero
   transitional markers, no stray .gherkin  ==  DONE for lead-vzxd.
```

Order is: BC sweeps (parallel) → reconcile+import → mirror rebuild → enforce →
green. The mirror rebuild is AFTER the sweeps because it consumes their
registers.

### Genuine DAVID decisions (product judgment — surface these)

1. **Lead-mirror rebuild-vs-hand-tag (§2).** Recommend **rebuild-from-registers**
   (mechanism architect-settleable). David nod on: the rebuild is **destructive**
   to committed lead `.gherkin`, and the **lead-owned vs BC-owned boundary**
   (the `@bc:shopsystem-product` set) — which overlaps decision 4 below.
2. **`@origin` tier-2 residue resolution.** ~49.5% lead-underivable; BC
   self-tagging closes most, but the genuinely origin-ambiguous residual
   (whatever the BCs return as `@origin:unresolved`) needs a **product pass** to
   decide `@origin:<ref>` vs leaving it `unresolved`. "Harder to backfill, but
   necessary" (David). This is the residue that keeps the gate RED until
   resolved — product-authority review, per-scenario.
3. **Provisional contexts gate DONE on `lead-bh2m` (§4).** The 22
   devcontainer/test-harness scenarios cannot self-tag (not-live). SCOPE call:
   (a) block full system-green on `lead-bh2m` resolving their in/out, or (b)
   define an interim **"live-BC-corpus green"** milestone (4 live BCs + lead
   mirror, excluding the two deferred contexts) as the Phase-3 DONE, with the
   deferred residue tracked to `lead-bh2m`. **Recommend (b)** — it lets Phase 3
   close on the live corpus without waiting on the DDD review, with the deferred
   22 explicitly parked.
4. **Service-ownership reconfirm (carried from findings/00 §D.3).**
   `agent-vault-broker` scenarios (13) → `@bc:shopsystem-product` +
   `@service:agent-vault-broker` (lead-owned integration surface, ADR-028);
   postgres deps → consuming `@bc` + `@service:postgres`. Confirm.

### Architect-settleable (no David needed — decided here)

- **Vehicle = `request_maintenance`** per BC sweep (flat, hash-preserving; Q3).
- **Reference data conveyed INLINE**, not provisioning-first (§3): unblocks the
  four sweeps in parallel; launcher-provisioning is the durable going-forward
  delivery, not a backfill precondition.
- **Grouping/emit mechanics** = `scenarios consolidate`/`create` (hash-preserving).
- **Stray-`.gherkin` enforcement guard** folded into C6 (a small BF on the
  existing aggregate gate); Phase 3 depends on it for a meaningful DONE.
- **Progress-by-counting** during backfill (`.gherkin` / `@bc:unassigned` /
  `@origin:unresolved` → 0).
- **Rebuild MECHANISM** = `request_scenario_register` import + regroup by
  (origin × bc); BC-side truth wins on any lead/BC ownership conflict (ADR-018).

---

## 6. Summary

- **Target shape:** per-(decision × context) `.feature` files, feature-level
  `@bc`+`@origin` inherited, per-scenario block-only `@scenario_hash` preserved;
  `.gherkin → .feature`; transitional `@bc:unassigned`/`@origin:unresolved`
  driven to zero.
- **Lead-mirror decision:** **REBUILD from BC registers** (register-led), hand-tag
  ONLY the genuinely lead-owned integration surface — because hand-tag-in-place
  structurally caps at the lead's ~40% ceiling and can never reach the defined
  green end, and would manufacture a second source of truth against ADR-018.
- **Per-BC specs:** 4 parallel `request_maintenance` sweeps (each BC self-tags
  its own repo), reference data conveyed **inline**, beads map as SEED only,
  hash-preservation + `validate --aggregate` green + zero `@bc:unassigned` as
  measurable acceptance. Precondition: pin `scenarios` v0.3.0.
- **DONE / system-consistent:** the ADR-047 aggregate gate GREEN over ALL
  corpora (4 live BC repos + the rebuilt lead mirror) — zero transitional
  markers, full conformance, **plus a mandatory stray-`.gherkin` enforcement
  guard** (the gate globs `*.feature` only today → exit 0 while 484 `.gherkin`
  sit ignored; reproduced this session).
- **David decisions:** (1) rebuild-vs-hand-tag nod + lead-owned boundary,
  (2) `@origin` tier-2 residue product pass, (3) provisional-context DONE scope
  (recommend interim "live-BC-corpus green"), (4) service-ownership reconfirm.
  Everything else — vehicle, inline conveyance, mechanics, enforcement guard,
  rebuild mechanism — is architect-settled here.
```
