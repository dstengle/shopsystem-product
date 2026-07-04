# PHASE 4 — the lead-mirror REBUILD + the source-of-truth CUTOVER (epic lead-vzxd)

**Date:** 2026-07-04 · **Branch:** `dagger-spike` (main UNTOUCHED) · **Lead shop:**
shopsystem-product · **Blocks:** DDD review `lead-bh2m`
**Status:** DESIGN + prepare ONLY. **NO destructive replace, NO cutover executed
— both flagged for David's nod (§6).** No `shop-msg` send. All verification is
artifact/`shop-msg`-mailbox/contract-surface only (ADR-018 D1/D2).
**Companion records:** ADR-056 (schema; D6 feature=decision×context; D9 services;
D10 known-value sets; **D11 cutover — beads deauthorized for assignment**),
ADR-018 (no cross-BC source on any host; the lead reasons via the mailbox),
ADR-028 (agent-vault-broker + postgres are SUPPORTING SERVICES, not BCs; the
broker's behaviors are pinned by a **lead-owned integration surface**), ADR-005
(`bc-manifest.yaml`), ADR-047 (`bin/doctor`/`system-manifest` coherence gate),
ADR-042 (`bc-emit work-done` gate), ADR-011 (bead↔message field mapping —
deauthorized for assignment), ADR-023/024/025 (scenario journal).
**Builds on / refines:** `00-design.md`, `01`, `02`, `03-backfill-plan.md`
(this doc SHARPENS the `03 §2` lead-mirror decision — see §1.4).

---

## 0. Verified pre-state (this session, artifact + mailbox surface)

**Backfill is DONE across all 4 live BCs — GREEN under `scenarios` v0.3.1**
(validate == CLI hash == `compute_scenario_hash` producer, single-sourced).
Read back from each BC's `work_done` payload via
`shop-msg read outbox --bc <bc> --work-id lead-vzxd.N`:

| BC | work_id | origin/main | files / scenarios | owner tag | aggregate |
|----|---------|-------------|-------------------|-----------|-----------|
| shopsystem-scenarios | lead-vzxd.3 | `27bec6d` | 15 `.feature` / 43 | `@bc:shopsystem-scenarios` (13 product + 2 `@bc_internal`) | exit 0 |
| shopsystem-messaging | lead-vzxd.4 | `d4ca688` | 57 files / 148 | `@bc:shopsystem-messaging` (145 product + 3 `@bc_internal`) | exit 0 (v0.3.1) |
| shopsystem-bc-launcher | lead-vzxd.5 | `8149ff4` | 170 product + 3 `@bc_internal` | `@bc:shopsystem-bc-launcher` | exit 0 |
| shopsystem-templates | lead-vzxd.6 | `c60dfc8` | 102 files / 253 | `@bc:shopsystem-templates` (182 product + 71 `@bc_internal`) | exit 0 |

Each BC's OWN repo: all `.feature`, feature-level `@bc:<self>` + `@origin` (ALL
resolved — **ZERO `@origin:unresolved`, ZERO `@bc:unassigned`** across all 4),
per-scenario `@scenario_hash` == v0.3.1 canonical, `@bc_internal` exempt, zero
`.gherkin`. Service tags present where exercised (bc-launcher: 34
`@service:agent-vault-broker` + 8 `@service:postgres`; messaging: 28
`@service:postgres`; templates: `@service:agent-vault-broker` on `footing_*`).

**Two mechanism_observations rode back on the sweeps — follow-ups, NOT this
design's scope:** (1) messaging's v0.3.0 Scenario-Outline reconstruction fork
(`lead-vzxd.4` blocked row), RESOLVED by v0.3.1 (validate==producer for Outlines
too) → messaging is green at `d4ca688`; (2) bc-launcher's `Clarify.work_id`
pattern `^[a-zA-Z0-9-]+$` rejects dotted sub-bead work_ids (`lead-vzxd.5`) —
file a fresh lead bead to relax it (align to the validator's dotted lead-bead
rule). Neither blocks the rebuild.

**The LEAD mirror is STILL the 484-`.gherkin` jumble** (`find features -name
'*.gherkin' | wc -l` = 484; 1 `.feature` = the guard). Under v0.3.1 the lead's
`scenarios validate --aggregate features/` is correctly **RED** (E_STRAY_GHERKIN
+ missing tags). Its subdir jumble (e.g. messaging surfaces under `templates/`)
was a **MIRROR FILING ARTIFACT** — each BC's own repo is correctly-owned
(templates confirmed NO foreign scenarios in its repo). Current mirror subdirs:

```
agent-vault-broker/13  bc-launcher/66  bc-manifest/8  beads-health/5  dagger-ci/4
devcontainer/17  docs/5  fabro-orchestration/4  launcher-credentials/8
messaging/38  messaging-registry/57  scenario-integrity/1(.feature)
scenario-journal/9  scenarios/12  spike-lifecycle/8  templates/225  test-harness/5
```

---

## 1. THE FORK — what does the lead's `features/` BECOME post-cutover?

### 1.1 The two options

- **(a) FULL PROJECTION** — the lead's `features/` is REBUILT to mirror ALL 4
  BCs' registered scenarios (import each register, regroup by (origin × bc) into
  `.feature` files, persist them). Faithful and complete.
- **(b) LEAD-OWNED-ONLY** — the lead's `features/` holds ONLY the scenarios the
  lead product itself owns (`@bc:shopsystem-product`: the agent-vault-broker
  integration surface, spike-lifecycle, beads-health, system-manifest/coherence).
  BC-owned scenarios live ONLY in the BCs and are visible **on demand** via
  `request_scenario_register`. No standing BC copy on the lead.

### 1.2 RECOMMENDATION: **(b) LEAD-OWNED-ONLY.**

The deciding argument is that **(a) re-creates the exact disease this whole epic
exists to cure.** A standing full-projection mirror is a SNAPSHOT of BC-side
canonical truth that begins drifting the instant any BC edits a scenario. That
is precisely the failure ADR-056's pre-state measured: **56% (213/379) of
beads-pinned hashes had already drifted off their bodies** because a second copy
of the truth (beads) was allowed to persist and diverge. Option (a) moves that
second copy from beads into `features/*.feature` — the same drift, a new
location, now dressed as conformant Gherkin so it LOOKS authoritative while
silently going stale. The lead cannot even detect the drift, because ADR-018
forbids it reading BC repos to compare.

Option (b) keeps a **single source of truth per bounded context**: each BC's own
repo is canonical (ADR-018), and the lead holds only its OWN context. This is
the product-vs-production "mirror as projection" model taken to its honest
conclusion — the lead's `features/` is the lead's bounded context, not a copy of
everyone else's.

Supporting alignments:
- **ADR-018** — the lead reasons about BCs through the mailbox, not local
  copies. A standing BC mirror is a local copy by another name.
- **findings/00 A.iii** — `request_scenario_register` is characterized as
  **VISIBILITY-ONLY, on-demand**; post-cutover it is the RETURN PATH carrying
  `@bc`/`@origin` back. Option (b) uses it exactly as characterized; option (a)
  would have to promote it to a standing-sync mechanism it was never meant to be.
- **ADR-056 D11 + Consequences** — the tags on the artifact are authoritative
  and each BC owns its own; nothing in ADR-056 asks the lead to hold a full copy.

### 1.3 The architect's pre-state need — does on-demand import SUFFICE?

This is the one real objection to (b): the lead-architect's sufficiency check
**Q5 (`@scenario_hash` conflict enumeration)** and Q1 (pre-state verification)
both need to SEE a BC's current scenario hashes at dispatch time. Under (a) that
is a local `grep -r "@scenario_hash" features/`; under (b) it is a
`request_scenario_register` round-trip.

**On-demand import suffices — and is strictly MORE correct than a standing
mirror.** The enumeration/pre-state check must be run **against current
authoritative truth at compose time**. A standing mirror answers with a
snapshot that may be stale — which is exactly the wrong-premise dispatch hazard
the lead-architect template warns against ("package data may LAG the BC's
`origin/main`; reconcile"). `request_scenario_register` answers with the BC's
CURRENT register, freshly. The cost is a round-trip; the benefit is that the
architect never enumerates against a drifted local copy. For a step that is
already gated on "verify the pre-state empirically, do not assert from a local
poured copy," the round-trip is not overhead — it IS the verification.

Net: the standing mirror's only advantage (local grep) is a liability
(guaranteed staleness with no drift-detection). **Register-import-on-demand is
the correct pre-state instrument; a standing full projection is not.**

### 1.4 This SHARPENS `03 §2`

`03 §2` chose "REBUILD-FROM-REGISTERS is primary; hand-tag only the lead-owned
residue," and its prose ("regroup imported registers by (origin × bc) and
replace the jumbled `.gherkin`") leaned toward PERSISTING the imported BC
registers — i.e. option (a)-shaped. **This doc refines that:** the
register-import MECHANISM is retained, but the imported BC registers are consumed
**transiently** — for reconciliation (confirm the register landed, hashes match)
and for on-demand pre-state — and are **NOT persisted** as standing `.feature`
files. Only the lead-owned set is persisted. §1.4 supersedes the persist
question in `03 §2`; the rebuild-vs-hand-tag reasoning (hand-tag-in-place caps at
~40% and manufactures a second source of truth) still holds and in fact argues
FOR (b) more strongly than (a).

### 1.5 DDD linkage (`lead-bh2m`)

The lead-owned set IS the lead product's own bounded context. `lead-bh2m` is
producing the §3.3 Domain & Context Map; under (b) the lead's `features/` becomes
the concrete, validated scenario inventory of the `shopsystem-product` context
entry in that map — nothing more, nothing less. The four BC contexts appear in
the map with their scenarios living in their repos, surfaced on demand. Option
(a) would make the lead's `features/` a copy of the whole map's scenarios, which
is neither what the map is nor what the lead's context owns. **(b) makes the
mirror and the context map the same shape** — the explicit `lead-vzxd`↔`lead-bh2m`
linkage.

### 1.6 The one exception: provisional contexts have no other home

`devcontainer/` (17) + `test-harness/` (5) = 22 scenarios belong to
NOT-LIVE provisional contexts (`bc-manifest` `deferred_to: lead-bh2m`). There is
no live BC to hold them, so under (b) the lead `features/` is their ONLY home
until `lead-bh2m` rules them in (→ a live BC that adopts them) or out (→ retire).
Recommendation (carries `03` David-decision-3): keep them in the lead mirror,
hand-tagged best-effort `@bc:shopsystem-devcontainer` / `@bc:shopsystem-test-harness`
(legal provisional manifest values, D10) + best-effort `@origin`, and define the
Phase-4 DONE as **"live-corpus green"** = the 4 BC repos + the lead-owned
`@bc:shopsystem-product` set green, with the 22 provisional scenarios explicitly
PARKED behind `lead-bh2m` (tracked, not blocking). This is the only residue where
the defined-end is not purely mechanical.

---

## 2. MECHANISM — the DESTRUCTIVE REPLACE (spec only; DO NOT RUN — David-nod gate #1)

Target shape unchanged from `03 §1`: every retained scenario lands in a
`Feature:`-headed `.feature` whose unit is (originating decision × owning
context), feature-level `@bc`/`@origin` inherited, per-scenario block-only
`@scenario_hash` preserved.

### 2.1 The authoritative owner map REPLACES the beads/dir jumble

The four `work_done` registers (mailbox, §0) are now the authoritative
`(title, @scenario_hash) → @bc/@origin` map for every BC-owned scenario — the
drift-free replacement for the ~40%-ceiling beads oracle and the dir-name jumble.
Build the **BC-claimed set** = the union of all four registers' scenario entries
(each carries title + `@scenario_hash` + `@bc` + `@origin`, captured in §0). This
is a mailbox-surface artifact (ADR-018 admissible), not a `repos/<bc>` read.

### 2.2 Classify every one of the 484 `.gherkin` (by REGISTER cross-check, not by subdir)

For each lead `.gherkin` scenario, test membership in the BC-claimed set by
block-only hash (recompute via `scenarios list`/`hash`, v0.3.1 parser path) and
title:

- **BC-CLAIMED → DELETE.** The scenario is owned by a live BC and lives in that
  BC's repo now. It leaves the mirror entirely. (Directory is irrelevant: a
  messaging scenario misfiled under `templates/` is claimed by the messaging
  register and deleted the same as one under `messaging/`.)
- **NOT claimed, lead-product-owned → MIGRATE + RETAG** `@bc:shopsystem-product`.
  Candidates (confirm each by register-exclusion, NOT by subdir): the
  agent-vault-broker integration surface (`agent-vault-broker/`, 13 — ADR-028
  lead-owned integration checks; the register cross-check CONFIRMS these are NOT
  in the templates register, correcting the earlier beads-seed mis-resolution to
  templates), `spike-lifecycle/` (8), `beads-health/` (5), and any
  system-manifest/coherence scenarios the lead owns (ADR-047; e.g. the loos
  Increment-1 set). `docs/` (5) → resolve owner: if a `shopsystem-docs` context
  (ADR-008) claims them, DELETE; else `@bc:shopsystem-product`.
- **NOT claimed, provisional → PARK** (§1.6): `devcontainer/` (17),
  `test-harness/` (5), hand-tagged best-effort.
- **NOT claimed, genuine orphan → `@bc:unassigned`** (transitional forcing
  marker; must be driven to zero — surface each to David/`lead-bh2m`).

Indicative split (register cross-check is authoritative; subdir counts only
size it): DELETE ≈ 436 (bc-launcher 66, messaging 38, messaging-registry 57,
templates 225, scenarios 12, scenario-journal 9, bc-manifest 8,
launcher-credentials 8, fabro-orchestration 4, dagger-ci 4, docs 5-if-BC-owned);
RETAIN as `@bc:shopsystem-product` ≈ 26 (agent-vault-broker 13, spike-lifecycle
8, beads-health 5); PARK 22 (devcontainer 17, test-harness 5).

### 2.3 The concrete step-list (ready to execute on David's nod)

1. **Snapshot** the BC-claimed set from the four registers into a working map
   (mailbox surface; no BC read).
2. **Classify** all 484 `.gherkin` per §2.2; produce three lists (DELETE,
   RETAIN-lead-owned, PARK-provisional) + any orphan list.
3. **MIGRATE the RETAIN set** into grouped `.feature` files, one per (origin ×
   `shopsystem-product`), using the **hash-preserving** helper:
   `scenarios consolidate --feature-name <name> --bc shopsystem-product
   --origin <ref> <bare-body-files…>` (or `create` for singletons). Add
   feature-level `@service:agent-vault-broker`/`@service:postgres` where a
   scenario exercises a supporting service (the agent-vault-broker integration
   surface gets `@service:agent-vault-broker` per ADR-028 D9). The helper stamps
   / preserves each block-only `@scenario_hash` — standard formatting, avoiding
   the `lead-vzxd.9` formatting-robustness issue.
4. **`git rm` the DELETE set** — every BC-owned `.gherkin` mirror copy. They live
   in the BCs; the lead surfaces them via `request_scenario_register` on demand.
5. **PARK the provisional residue** (§1.6): hand-tag best-effort, keep in mirror.
6. **VALIDATE GREEN** over the retained lead corpus:
   `scenarios validate --aggregate features/ --manifest bc-manifest.yaml
   --origin-index scenario-refs/origin-index.txt` → exit 0, INCLUDING the
   stray-`.gherkin` guard (v0.3.1) → **zero `.gherkin` remain**, zero
   `@bc:unassigned` (modulo any surfaced orphan), zero `@origin:unresolved`
   (modulo parked provisional best-effort).
7. **Reconcile** counts: RETAIN + PARK = the new mirror total; DELETE count == the
   BC-claimed subset of the mirror; no scenario in two corpora, none silently
   dropped (every DELETE is provably present in a BC register).

This is the DESTRUCTIVE REPLACE. **Specced, not run** — David-nod gate #1 (§6).

---

## 3. CUTOVER — consumer repoint + deauthorize-beads (spec only — David-nod gate #2)

### 3.1 Consumer-repoint list (beads dispatch metadata → the `@bc` TAG)

Everything that today reads scenario ownership/assignment from beads
(`dispatched_to_bc` / `scenario_hashes_pinned`, ADR-011) repoints onto the
on-artifact `@bc`/`@origin` tags (source: findings/00 A.ii + ADR-056
Consequences):

1. **lead-architect `@scenario_hash` enumeration** (sufficiency Q5) → enumerate
   from the lead-held `features/` (lead-owned) + `request_scenario_register` for
   any BC-owned conflict set. No beads hash lookup.
2. **Reconciliation** → confirm the BC register's tags, not beads pins.
3. **Scenario-to-BC assignment** → owner is the `@bc` the PO authors, not a
   dispatch record.
4. **`request_scenario_register` import** → now the VISIBILITY return path
   carrying `@bc`/`@origin` (findings/00 A.iii); this is the lead's window into
   BC-owned scenarios under option (b).
5. **`bc-emit` gate + bc-reviewer/bc-implementer templates** (owned by
   `shopsystem-templates`) → gate on `scenarios validate` (tags present), not on
   beads. (Repoint lands via the C6 templates BF — §3.3.)
6. **DDD review `lead-bh2m`** → reads `@bc` + `@origin`/feature-grouping off the
   tags.
7. **Scenario-completion journal** (ADR-023/024/025) → keyed on `@scenario_hash`
   over the tagged corpus.
8. **Beads dispatch metadata itself** → becomes AUDIT-ONLY (§3.2).

Lead-side repoints (this repo + the inline role-template copies at
`.claude/agents/lead-architect.md` / `lead-po.md`, kept in sync with the
canonical `shopsystem-templates` source) land on `dagger-spike`; the
template-gate repoints are `shopsystem-templates`-owned (§3.3).

### 3.2 The deauthorize-beads step (ADR-056 D11)

**What CHANGES:** beads `dispatched_to_bc` / `scenario_hashes_pinned` are
**deauthorized as the scenario ownership/assignment oracle**. No consumer resolves
"who owns scenario X" or "which hashes are pinned to BC Y" from beads any longer;
that truth is the on-artifact `@bc`/`@scenario_hash` tags. This is a POLICY +
tooling cutover, **not a data deletion** — the existing beads pins stay in place
as historical/audit trail.

**What STAYS (beads' enduring role):** beads remains the lead's **work-tracking
registry** — `bd ready`/`claim`/`close`, dependency tracking, and critically the
**`work_id` source of truth**: lead bead IDs remain the canonical `work_id` that
flows outward in `shop-msg send` (CLAUDE.md + ADR-011 field mapping for
work_id/status). Only the *scenario-ownership/assignment* semantics are retired;
the *work-tracking* semantics are untouched.

**Mechanics (on David's nod):** (1) mark ADR-056 D11 effective; (2) land the
consumer repoints (§3.1) so no live path reads owner-from-beads; (3) leave beads
data intact as audit. There is no destructive beads operation.

### 3.3 Enforcement wiring (the defined-end teeth)

- **ADR-047 `bin/doctor` aggregate gate** — wire `scenarios validate --aggregate
  features/` (+ the v0.3.1 stray-`.gherkin` guard) into the ADR-047 D4 coherence
  gate so the system is **RED until** zero `@bc:unassigned` + zero
  `@origin:unresolved` + all files schema-valid + zero stray `.gherkin`. Owned by
  `shopsystem-templates` (renders `bin/doctor`) → **BF → shopsystem-templates**
  (tightens the existing coherence gate). This green aggregate gate IS the
  defined DONE for `lead-vzxd` (ADR-056 D8).
- **`bc-emit work-done` gate** (ADR-042) — extend the pre-emit wrapper (rendered
  by `shopsystem-templates` into bc-reviewer/bc-implementer) to run `scenarios
  validate` (schema + `@bc`/`@origin` presence + off-the-shelf Gherkin) before any
  scenario-file emit; wire into CI → **BF → shopsystem-templates** (tightens the
  existing gate). Going-forward, no scenario file emits/merges non-conformant.
- **stray-`.gherkin` guard** — ALREADY in v0.3.1 (the tool enforces it); the
  remaining work is the `bin/doctor` WIRING above so the aggregate gate is not
  trivially satisfiable by leaving files unmigrated (the `03 §0`/§4 blind spot).

Both enforcement BFs are `shopsystem-templates`-owned and land via that BC's
own loop + republish; they are the going-forward teeth, dispatched AFTER the
lead-side rebuild + cutover land (sequencing §5).

---

## 4. GRADUATION — what lands on `main`

`main` is currently UNTOUCHED; all Phase-1..4 lead work is on `dagger-spike`.
The 4 BC backfills + `scenarios` v0.3.1 are already on THEIR respective
`origin/main`s (§0). Graduation of THIS (lead) repo = the `dagger-spike → main`
merge carrying:

1. **ADR-056** (rev-2, accepted) — the decision record.
2. **`bc-manifest.yaml`** — reconciled `bcs:` (4 live + 2 provisional) + new
   `services:` section (`postgres`, `agent-vault-broker`) (ADR-056 D10).
3. **`scenario-refs/origin-index.txt`** (112 ids) + **`bin/gen-scenario-refs`**
   (the reproducible generator) — the `@origin` membership index.
4. **`features/scenario-integrity/`** — the guard `.feature` (already conformant).
5. **The REBUILT `features/`** — lead-owned-only (`@bc:shopsystem-product`),
   BC-owned mirror copies deleted, provisional residue parked; `scenarios
   validate --aggregate features/` GREEN.
6. **`findings/scenario-integrity/{00,01,02,03,04}.md`** — the full design trail.

**Sequencing into graduation:** the §2 destructive replace and §3 cutover happen
on `dagger-spike` FIRST (each behind its David nod), the lead `features/` goes
green, THEN `dagger-spike → main` is the graduation merge. The enforcement wiring
(§3.3, templates-owned BFs) lands on `shopsystem-templates`' main and flows to the
lead via republish/re-pour — it is a going-forward gate, not a blocker of the
lead graduation merge, but the defined-end DONE for `lead-vzxd` is only reached
once that gate is wired AND green over the live corpus (4 BC repos + rebuilt lead
mirror), with the 22 provisional scenarios parked to `lead-bh2m`.

---

## 5. Sequence

```
0. [DONE] 4 BC sweeps green under scenarios v0.3.1 (§0); lead reference artifacts
   (bc-manifest.yaml, scenario-refs/origin-index.txt, bin/gen-scenario-refs) +
   ADR-056 committed on dagger-spike.                                     [lead]
        │
1. FORK decision (§1): option (b) LEAD-OWNED-ONLY. [recommend; David nod folds
   into gate #1 since it defines what the destructive replace produces]
        │
2. ── DAVID NOD GATE #1: DESTRUCTIVE REPLACE ──
   Run §2.3: classify 484 .gherkin by register cross-check → migrate lead-owned
   to @bc:shopsystem-product .feature (hash-preserving consolidate), git rm the
   BC-owned copies, park provisional residue, validate --aggregate GREEN.  [lead]
        │
3. ── DAVID NOD GATE #2: DEAUTHORIZE-BEADS CUTOVER ──
   Run §3: repoint consumers beads→@bc tag; mark ADR-056 D11 effective; beads
   stays work-tracking/work_id only.                              [lead + templates]
        │
4. ENFORCE (§3.3): BF → shopsystem-templates — wire scenarios validate --aggregate
   (+ stray-.gherkin guard) into bin/doctor (ADR-047); extend bc-emit gate. [BF→templates]
        │
5. GRADUATION (§4): dagger-spike → main merge (ADR-056 + bc-manifest + scenario-refs
   + features/scenario-integrity + rebuilt features/ + findings).           [lead]
        │
6. DONE for lead-vzxd = ADR-047 aggregate gate GREEN over the live corpus
   (4 BC repos + rebuilt lead mirror), zero transitional markers, no stray
   .gherkin; 22 provisional scenarios parked to lead-bh2m.
```

---

## 6. The TWO David-nod gates (flagged; do NOT proceed without)

1. **DESTRUCTIVE MIRROR REPLACE (§2).** `git rm` of ~436 BC-owned `.gherkin`
   mirror copies + migration of ~26 lead-owned to `@bc:shopsystem-product`
   `.feature` files, on `dagger-spike`. It is destructive to committed lead
   `.gherkin` (they are removed, not migrated-in-place, because they live in the
   BCs now). The FORK recommendation (option (b) lead-owned-only) is folded into
   this gate because it defines what the replace produces. **Prepared, not run.**
2. **DEAUTHORIZE-BEADS CUTOVER (§3).** ADR-056 D11 effective: beads deauthorized
   as the scenario ownership/assignment oracle (audit-only thereafter);
   consumers repoint to the `@bc` tag; beads retains work-tracking + `work_id`.
   No beads data deletion, but it changes the authoritative source for every
   ownership-reading consumer. **Prepared, not run.**

Two smaller items to surface alongside (not blocking): the `docs/` owner
resolution (`shopsystem-docs`/ADR-008 vs `@bc:shopsystem-product`), and the
provisional-context DONE scope (recommend interim "live-corpus green" with the 22
devcontainer/test-harness scenarios parked to `lead-bh2m` — `03` David-decision-3).
