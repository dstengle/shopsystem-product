# DDD Current-State Inventory — system-as-DEFINED vs behaviors-ASSIGNED-over-time

**Epic:** lead-bh2m — DDD bounded-context review (ubiquitous language + scope per BC).
**Date:** 2026-07-02. **Branch:** dagger-spike. **Author:** lead-architect (dispatched).
**Method:** read-only artifact surface ONLY (ADR-018): this repo's `features/`,
`adr/`, `pdr/`, the framework spec §1–§6, `bc-manifest.yaml`, `bin/`, `compose.yaml`,
and `shop-msg registry list`. **No BC source cloned or read.** This is FACTUAL
current-state mapping + tension-spotting. It does **not** propose a target model —
that awaits David's ubiquitous-language/scope dialogue.

> Scope note: throwaway dogfood registry instances (`fabro-e2e`,
> `fabro-throwaway`, `shopsystem-bc-launcher-dagger`) are excluded as instructed.

---

## 0. The headline: three tiers of "defined-ness" do not agree

The single most important current-state fact is that **the set of BCs disagrees
across three authoritative surfaces**:

| Surface | BCs it names | Evidence |
|---|---|---|
| **ADR-introduced** (design intent) | product(lead), messaging, scenarios, templates, **test-harness**, bc-launcher, **docs**, **devcontainer** | ADR-001 (4 repos), ADR-002 (test-harness), ADR-004 (bc-launcher; names devcontainer as pre-existing Option B), ADR-008 (docs) |
| **`bc-manifest.yaml`** (committed registry) | messaging, scenarios, templates, **test-harness**, **devcontainer**, bc-launcher | `bc-manifest.yaml` (6 entries; **no docs, no lead**) |
| **`shop-msg registry list`** (live/running) | messaging, scenarios, templates, bc-launcher (+ lead) | registry query 2026-07-02 |

Drift, made explicit:

- **`shopsystem-docs`** — introduced by ADR-008, but **absent from `bc-manifest.yaml`
  AND from the live registry**. Never stood up (or abandoned). `features/docs/` (5
  scenarios) is orphaned coverage with no live owner.
- **`shopsystem-test-harness`** — introduced by ADR-002 (Platform Operations
  subdomain), **in the manifest but NOT live**. Defined, never running.
  `features/test-harness/` (5 scenarios) pins a BC that isn't in the fleet.
- **`shopsystem-devcontainer`** — in the manifest, has **17 `@bc:shopsystem-devcontainer`
  scenarios** (the only fully `@bc`-tagged non-messaging subdir), but **NOT live**,
  AND its flagship capability (the base image build) was **re-assigned to
  `bc-launcher` by ADR-021**. A hollowed BC — see Tension B.

So the review is largely **reconstructing from scratch, not refining**: the spec
DEFINES the artifacts (§3.3) but they are DEFERRED/uninstantiated (§4 below).

---

## 1. BC × capability map (intended purpose vs accreted reality)

Each row cites the defining ADR/PDR/spec and the `features/` subdir(s) that pin the
behavior. "Owner" = where the behavior is assigned today, not where it ideally belongs.

### 1.1 `shopsystem-messaging` — LIVE

- **Intended purpose (ADR-001, ADR-002):** the Messaging BC. UL = message_type,
  work_id, schema, inbox, outbox, wire format. Pydantic schemas for the 8 message
  types + the `shop-msg` CLI.
- **Accreted behaviors:**
  - Message catalog + schema validation — `features/messaging/01–13` (`@bc:shopsystem-messaging`).
  - `shop-msg watch` (postgres LISTEN/NOTIFY presence + notification) — `messaging/14–21`;
    ADR-014 (heartbeat collapsed into watch).
  - `consume outbox` mailbox mechanics — `messaging/22–25`.
  - **Name registry** (`shop-msg registry add/remove/list/sync`) — `features/messaging-registry/`
    (57 scenarios!); ADR-006, ADR-020 (abstract-name addressing, `--bc-root` eliminated).
  - **bd integration** ownership — ADR-016 (`shop-msg owns bd integration`), ADR-011/012/013.
- **Note:** `messaging-registry` (57) is a **separate feature subdir** from
  `messaging` (38) but the same BC — the largest single BC by pinned scenario count
  (95 combined). The registry is arguably its own coherent concern cohabiting the
  messaging context.

### 1.2 `shopsystem-scenarios` — LIVE

- **Intended purpose (ADR-001, ADR-019):** clean leaf domain. UL = scenario,
  canonical, hash, tag. Gherkin canonicalization rule + hash + the `scenarios` CLI.
  `Requires:` empty (a true leaf; messaging depends on it, not vice-versa).
- **Accreted behaviors:**
  - Canonicalization + hash + verify + list/count/titles/tags — `features/scenarios/`
    (12); ADR-019 (block-only canonicalization owned here, pins scenario 117).
  - **Scenario-completion journal as a FILE** — `features/scenario-journal/` (9);
    ADR-025 re-homed the journal INTO scenarios (retiring the mis-homed `messaging`
    implementation — see Tension D). ADR-023/024 lineage.

### 1.3 `shopsystem-templates` — LIVE — **OVERLOADED** (see Tension A)

- **Intended purpose (ADR-001):** the Templates BC / role discipline. UL = role,
  template, dispatch, sufficiency check, anti-rationalization. "All four role
  templates + the `shop-templates` CLI + structural tests." A tight charter.
- **Accreted reality:** `features/templates/` holds **225 scenarios** — by far the
  largest subdir, ~55% of all pinned coverage — tagged `@lead_integration:templates`.
  These are lead-integration checks over the canonical package data templates ships.
  They span **at least a dozen distinct concerns** (enumerated in Tension A).

### 1.4 `shopsystem-bc-launcher` — LIVE

- **Intended purpose (ADR-004):** own the `bc-container` command surface
  (launch/attach/inject/monitor/stop/status/list) + shared-network connectivity
  (sets `SHOPMSG_DSN` in-container). An "operational subdomain" distinct from
  image-building.
- **Accreted behaviors (heaviest accretion of any live BC):**
  - `bc-container` lifecycle — `features/bc-launcher/` (66).
  - **BC manifest** subcommands (read/validate/sync `bc-manifest.yaml`) —
    `features/bc-manifest/` (8); ADR-005 (`bc-container` owns manifest family).
  - **Launcher credentials** mounting — `features/launcher-credentials/` (8);
    `@bc:shopsystem-bc-launcher`.
  - **`shopsystem-bc-base` image** ownership + auto-rebuild/republish on utility
    release — ADR-021, ADR-022. **This was devcontainer's charter, moved here.**
  - **fabro** alternable orchestration substrate (launch-interface parity) —
    `features/fabro-orchestration/` (4); ADR-048–051.
  - **dagger** build-test substrate wraps this BC's `publish-bc-base.yml` —
    `features/dagger-ci/` (4); ADR-052–055 (dagger module's home is unstated; it
    is *anchored on* bc-launcher's bc-base — see Tension B).

### 1.5 `shopsystem-product` — the LEAD shop (not a BC)

- **Intended purpose (spec §3, ADR-001):** outward face; owns product-level
  artifacts; houses PO + Architect roles; single point for intent-in /
  reconciliation-out. Owns the **Domain & Context Map** and **Scenario-to-BC
  assignment** (§3.3 — both schema-DEFERRED, uninstantiated).
- **Behaviors accreted onto the lead itself (not dispatched to a BC):**
  - **agent-vault broker** as a lead-shop supporting-service (a compose service,
    **explicitly NOT a BC**) — `features/agent-vault-broker/` (13); ADR-026/028/045;
    lead-owned `bin/agent-vault-check`, `bin/agent-vault-provision`, `bin/shop-shell`.
  - **Spike / iterative-experimentation lifecycle** — `features/spike-lifecycle/`
    (8); PDR-014/016, ADR-029–032 (a first-class LEAD capability, no `request_spike`).
  - **System-version manifest (BOM) + release coherence gate** — ADR-047, PDR-030;
    `system-manifest.yaml` at repo root (sibling to `bc-manifest.yaml`). But its
    *scenarios* live under `features/templates/231–236` (see Tension C — management
    smeared across lead + templates).
  - **Release cadence / version-bump discipline** — ADR-039.

### 1.6 Defined-but-not-live BCs (coverage with no running owner)

- **`shopsystem-devcontainer`** — `features/devcontainer/` (17): Dockerfile
  build + the four CLIs-on-PATH + **CI workflow** (`12–17`: workflow file, trigger,
  permissions, build step, push target, image tags). ADR-004 Option B named it as the
  existing "build + publish an image" BC. Hollowed by ADR-021.
- **`shopsystem-test-harness`** — `features/test-harness/` (5): bootstrap
  lead/BC shop, freeze evidence, verify hash match. ADR-002 (Platform Operations;
  UL = experiment/slice/run/evidence/finding/baseline).
- **`shopsystem-docs`** — `features/docs/` (5): adopter entry doc, walkthrough
  end-state, plain-markdown-only v1. ADR-008. Not even in the manifest.

### 1.7 Unclear-home subdir

- **`features/beads-health/` (5)** — "BC session-start detects a healthy
  work-tracker" (Brief 010 §3). No `@bc` tag; describes **BC session-start
  behavior**, which is canonical BC-primer prose → most likely a **templates**
  concern (primer/settings poured by templates), but it is not explicitly anchored
  to any BC in an ADR. Flag for the dialogue.

---

## 2. Tension points (evidence-cited)

### Tension A — TEMPLATES IS OVERLOADED (David's named tension, confirmed)

`features/templates/` = **225 scenarios** under one `@lead_integration:templates`
tag. Its ADR-001 charter was narrow: "the four role templates + the `shop-templates`
CLI + structural tests." What actually lives there now, grouped by concern:

1. **Role-template prose + `shop-templates show/list`** (the original charter) —
   `01–16`, `146–158` (lead-po/lead-architect/bc-* section structure, PM disciplines,
   decomposition discipline).
2. **Canonical `.claude/` file pouring** — `settings.json` (`57–104`), `CLAUDE.md`
   + typed import files (`30–53`, `77–91`), primer prose (`131`, `167–169`, `191`,
   `223–230`).
3. **`shop-templates init / update / bootstrap` CLI** — `26–56`, `84–91`, `129–141`
   (managed-file re-pour, idempotence, shop-owned-edit preservation).
4. **`bc-emit-work-done` wrapper** (git-state preconditions before a BC may emit
   work_done) — `105–116`, `176–181`, `208–212`, `225`, `227`, `210`; ADR-042.
5. **Ops scaffolding / compose / coordinates artifact** — `133–141`, `170–174`,
   `198`, `204–205`, `211`, `213`, `228` (pgdata, network, slug-parametric names).
6. **`doctor` health command** (broker/db/oauth checks) — `215–218`, `236`; PDR-024.
7. **`approve-claude` OAuth provisioning** — `202`, `219–221`; PDR-025.
8. **Adopter bringup / footing runway** — `187`, `200–214`, `226`; ADR-040, PDR-019/021/022.
9. **agent-vault CA / broker delivery into launched sessions** — `200`, `214`, `216`.
10. **System-manifest BOM + coherence gate** — `231–236`; ADR-047 (see Tension C).
11. **Empty-repo product-discovery primer** — `223–224`, `229–230`; PDR-027.
12. **Lead-skill-group pour + provenance** — `160–164`, `182`, `193–197`; PDR-014/023.

Groups 4–11 are plausibly a **distinct "Adopter Footing / Provisioning / Installer"
context** (getting a shop stood up, credentialed, health-checked, release-coherent)
cohabiting with "role discipline" (groups 1–2) and "the pour engine" (group 3).
`shopsystem-templates` reads today less like "templates" and more like "the
shopsystem installer + canonical-artifact + role-prose BC." The name misleads —
exactly the ADR-004 warning about `devcontainer`-named-owns-`bc-container`.

### Tension B — BUILD-PIPELINE **MANAGEMENT vs EXECUTION** (David's named tension)

Where these currently sit (mapping only — **no target decided**):

**EXECUTION (actually build / push / launch / orchestrate a loop):**
- **bc-base image build + publish** → `bc-launcher` (ADR-021/022); `publish-bc-base.yml`.
- **devcontainer image build + CI workflow** → `shopsystem-devcontainer`
  (`features/devcontainer/12–17`) — the *original* image-build home, now **not live**
  and **overlapping** bc-launcher's bc-base. Two BCs both claim "build+publish an image."
- **dagger build-test substrate** → `features/dagger-ci/` (4), ADR-052–055; **wraps**
  `publish-bc-base.yml`, *anchored on* bc-launcher's bc-base — but **the dagger
  module's owning BC is never stated.** Homeless build substrate.
- **bc-container launch** → `bc-launcher` (ADR-004).
- **fabro orchestration substrate** (alternable launch+loop) → parity defined against
  bc-container (`bc-launcher`), ADR-048–051; a *distinct* orchestration-execution concern.

**MANAGEMENT (decide what composes a release / version coherence / cadence):**
- **`system-manifest.yaml` BOM** (system-version → component tuple) → lead-owned at
  repo root; ADR-047, PDR-030. *But scenarios live under `features/templates/231–236`.*
- **`bc-manifest.yaml`** (which BCs exist / remotes) → lead-owned file, managed by
  `bc-container manifest` (bc-launcher). Management-data owned by lead, management-tool
  owned by a BC.
- **Release cadence / version-bump** → ADR-039 (lead cadence step).
- **Bootstrap coherence gate** (verify pulled-image baked version, refuse stale) →
  `features/templates/226`, `234–235`; ADR-028/047. A *management* check living in
  the *templates/bootstrap* execution path.

**The ambiguity, stated plainly:** MANAGEMENT is smeared across **lead**
(system-manifest, bc-manifest data, cadence ADRs) **+ templates** (coherence-gate
scenarios, baked-version checks). EXECUTION is smeared across **bc-launcher**
(bc-base, launch, fabro) **+ devcontainer** (image CI, hollowed) **+ a homeless
dagger module + fabro**. Neither "manage the pipeline" nor "execute the build" has a
single home. The dagger-CI question ("where does the CI belong") is a *boundary*
question between these, not an ad-hoc merge.

### Tension C — system-manifest is a lead concern whose scenarios live under templates

ADR-047/PDR-030 make `system-manifest.yaml` a **lead-owned** BOM. But scenarios
`231–236` (assemble/validate/coherence-gate) are tagged `@lead_integration:templates`
and the bootstrap-standup refuse/proceed gate (`234/235`) is a bootstrap/templates
behavior. Note also: `bin/` contains `agent-vault-check`, `agent-vault-provision`,
`shop-shell` — but **no `bin/system-manifest`** yet, though ADR-047 D1 specifies
`bin/system-manifest assemble|validate`. Management concern is split between lead
ownership (the artifact) and templates ownership (the tooling/gate that acts on it).

### Tension D — capabilities that migrated between BCs (assignment churn)

- **bc-base image**: devcontainer (charter) → **bc-launcher** (ADR-021).
- **scenario-completion journal**: messaging (ADR-023 D2/D3, mis-homed) →
  **scenarios** as a file (ADR-025). ADR-025 explicitly "retires the mis-homed
  `messaging` journal implementation."
- **presence/heartbeat**: standalone → **collapsed into `shop-msg watch`** (ADR-014).

These migrations are healthy DDD in action, but they leave **dead coverage and
mixed ADR lineage** (e.g. `features/devcontainer/` still pins image-build behavior
now owned elsewhere). Reconciling the pinned-scenario set to actual ownership is part
of the review.

### Tension E — the `@bc` tagging convention is itself inconsistent

Only 4 subdirs carry `@bc:<name>` tags (messaging, devcontainer, bc-launcher,
scenarios). The rest (agent-vault-broker, bc-manifest, beads-health, dagger-ci,
docs, fabro-orchestration, launcher-credentials, messaging-registry, scenario-journal,
spike-lifecycle, test-harness) carry **no `@bc` tag at all** and are attributable to
a BC only via ADR/PDR anchors in Feature prose. The 225-scenario `templates` subdir
uses `@lead_integration:templates`, a *different* tag namespace. So "which BC owns
this scenario" is **not mechanically derivable from tags today** — it requires ADR
archaeology. That is a direct symptom of ad-hoc-over-time assignment.

---

## 3. Existing scope / ubiquitous-language artifacts? — MOSTLY NO

- **The Domain & Context Map** (the artifact that would answer "which subdomain,
  which BC, which UL, which relationships") is **DEFINED but NOT instantiated.**
  - Spec §2.6 and §3.3 name it as a lead-owned YAML artifact with two sections
    (subdomain→BC assignment; BC↔BC relationships).
  - **Its schema is explicitly DEFERRED** — §3.3: *"YAML; schema deferred to a
    future prototype — see findings/from-prototype-1.md §8."* Same for the
    **Scenario-to-BC assignment** YAML.
  - **No instantiated map file exists** for shopsystem-product. `02-bounded-contexts-
    and-subdomains.md` is the *abstract definition* of what a BC/subdomain IS, not a
    filled-in map of THIS system.
- **No shop-card / per-BC scope-doc artifact** was found on the lead surface. (The
  task's "request_shop_card" mechanic is not present in this repo's `features/` or
  ADRs; the closest scope statements are the per-BC "dist Summary" strings quoted
  inside ADR-019 — e.g. scenarios' *"Scenario domain logic — canonicalization and
  hashing… hash discipline is a scenario concern"* — but those live in BC package
  metadata, not a lead-held scope artifact.)
- **Per-BC subdomain classification exists only in ADR-002's table** (messaging =
  Inter-shop coordination; scenarios = Specification; templates = Role discipline;
  harness = Platform Operations). It is **stale** (predates bc-launcher, docs, fabro,
  dagger, the templates overload) and never carried subdomain core/supporting/generic
  classification per §2.2.

**Conclusion:** this review is **reconstructing the Domain & Context Map from
scratch** (filling a deferred-schema gap), not refining an existing one. The only
prior scope anchors are ADR-001's 4-repo table and ADR-002's subdomain table — both
predate most of the accretion.

---

## 4. Sharp questions the ubiquitous-language / scope dialogue should resolve first

1. **What is `shopsystem-templates` actually FOR?** Its charter is "role discipline
   + the pour CLI," but it has absorbed bootstrap, doctor, approve-claude, ops
   scaffolding, bc-emit-wrapper, footing, and the release coherence gate (Tension A,
   ~225 scenarios). Is there a distinct **"Adopter Footing / Provisioning / Installer"**
   bounded context waiting to be split out, and if so, where is the UL seam between
   "canonical role/artifact prose" and "stand a shop up and keep it coherent"?

2. **Where is the boundary between build-pipeline MANAGEMENT and EXECUTION**
   (Tension B), and does the homeless **dagger CI module** + **fabro substrate** +
   the **hollowed devcontainer** image-build role consolidate into one "Build /
   Release Execution" context — distinct from a lead-or-new "Release Management /
   BOM" context that owns `system-manifest.yaml` + `bc-manifest.yaml` + cadence?

3. **Are `docs`, `test-harness`, and `devcontainer` in or out?** Three ADR-defined
   BCs are not live (docs isn't even in the manifest; devcontainer's charter moved to
   bc-launcher). The map must decide, per BC: retire, resurrect, or absorb — and
   reconcile the orphaned `features/` coverage that pins each.

(Secondary: which subdomain — Core / Supporting / Generic, and is "Platform
Operations" the right umbrella — does each context serve? ADR-002's classification is
stale and never carried the strategic label §2.2 requires.)
