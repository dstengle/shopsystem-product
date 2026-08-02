# Grounding Record — Framework spec (§1–6): migrate into the typed artifact corpus, or stay plain markdown outside it?

> **Question (verbatim):** Should the shopsystem framework spec (the framework principles/spec, sections 1 through 6, currently plain markdown in the lead/framework repo) be migrated INTO the typed artifact corpus as first-class artifacts, or stay as plain markdown OUTSIDE the corpus?
>
> **Recommendation (1 line):** STAY as plain markdown outside the corpus — an accepted decision (ADR-037) already classifies §1–6 as a distinct "system self-description" artifact that lives in the framework/lead repo, and migrating it in would require adding a ninth kind to a closed eight-kind schema that no decision authorizes.
>
> **Confidence:** High. The exact object of the question (framework spec §1–6) is the named subject of an accepted ADR whose D1/D4 answer the placement question directly; the corpus's kind set is a closed enumeration of eight (accepted PDR-035 / ADR-069) that does not include a framework-spec kind; and the one migration decision that touches the corpus (PDR-034) scopes itself explicitly to `brief/`/`pdr/`/`adr/` only. Residual risk is a term I failed to derive (Section 6 #1).
>
> **Term coverage:** 10 terms derived · 6 re-runnable (exact command + deterministic output) · 4 title-scan (exact command, selection by scanning a fully-pasted title list).
>
> **Attack Section 2 first.**

---

## 1. Glossary

- **Framework spec / §1–6.** The six numbered plain-markdown files at the lead-repo root: `01-principles.md`, `02-bounded-contexts-and-subdomains.md`, `03-lead-shop.md`, `04-bc-shop.md`, `05-inter-shop-protocol.md`, `06-work-tracking.md`. They describe what the shop-system framework *is*. This is the object the question asks about.
- **Typed artifact corpus / artifact system.** The set of YAML-frontmatter-typed documents governed by the `shopsystem-knowledge` bounded context, queried/rendered via the `shop-knowledge` CLI. Each document declares a `type`, `id`, `status`, and typed edges.
- **`shop-knowledge`.** The read-only corpus CLI used for all grounding here. Verbs: `template`, `schema`, `validate`, `navigate`, `render`, `query`. `render` of a non-`accepted` document requires `--view transformation`.
- **ADR / PDR / brief / candidate / intent-record / session-record / prioritization-record / current-state.** The **eight artifact kinds** the corpus recognizes (see PDR-035 D2, ADR-069). ADR = Architecture Decision Record; PDR = Product Decision Record.
- **First-class artifact.** A document that carries typed frontmatter, a `type` recognized by the schema, and participates in the corpus edge graph — i.e. is returnable by `shop-knowledge query`.
- **Distribution / ship-to-product boundary.** Whether an artifact propagates into a *product instance* built with the framework, versus staying in the framework/lead repo. ADR-037 turns on this boundary.

**Options on the table (the question's own two):**
- **Option MIGRATE** — bring §1–6 into the typed corpus as first-class artifacts (new frontmatter, a recognized `type`, edge participation).
- **Option STAY** — keep §1–6 as plain markdown outside the corpus (status quo).

---

## 2. Question → terms (THE audit surface)

One row per derived concept. "Full candidate set" is the complete output the command produced and that I scanned; the two large title lists are pasted once in Appendix A and referenced by name to keep rows scannable. Selection rule states exactly why THIS artifact was chosen and the others rejected.

| # | Term | Why the QUESTION forces this term | Exact command | Full candidate set | Selection rule | Re-runnable? |
|---|---|---|---|---|---|---|
| T1 | **framework-spec as a corpus `type`** | The question asks whether §1–6 become "first-class artifacts". A first-class artifact has a recognized `type`. So I must test whether any framework-spec-shaped type already exists in the corpus. | `shop-knowledge query --corpus /workspace --facet type --value framework-spec` (and `--value spec`, `--value principle`) | Each returns exactly `[]` (empty). For contrast the recognized kinds return non-empty: adr→68, pdr→38, brief→24, candidate→10, current-state→1, intent-record→13, session-record→10, prioritization-record→0. | Empty result = the corpus has NO framework-spec/spec/principle type today; the recognized set is the eight kinds. This establishes the empirical pre-state (§1–6 are NOT in the corpus) with a deterministic command. | **yes** |
| T2 | **§1–6 as a queryable document** | "Currently plain markdown" is a claim I must verify, not assume. If §1–6 were already corpus documents, the question would be moot. | `shop-knowledge navigate 01-principles --corpus /workspace` | `error: no document with id '01-principles' is present in the corpus` | An id-not-present error confirms §1–6 files are outside the corpus graph. Rejected the alternative (that they are silently indexed) by direct lookup. | **yes** |
| T3 | **framework spec placement decision** | The core question is a *placement* decision for §1–6. I must find any decision record whose subject IS the framework spec's placement. | `shop-knowledge query --corpus /workspace --facet type --value adr` → scan titles | **Appendix A (full ADR list, 68 rows).** | Title-scan rule: select the row whose title names "the framework spec (§1–6)" as its subject. Exactly one matches — **ADR-037** ("The framework spec (§1–6) … stays in the framework/lead repo and is NOT shipped to product instances"). Adjacent artifact-system ADRs (067/068/069) are about the corpus mechanism, not §1–6's placement — rejected as not-the-subject. | title-scan |
| T4 | **legacy corpus migration** | The question is literally a *migration* question. I must find any decision that migrates existing prose documents INTO the typed corpus, and read its scope. | `shop-knowledge query --corpus /workspace --facet type --value pdr` → scan titles | **Appendix B (full PDR list, 38 rows).** | Title-scan rule: select rows whose title contains "corpus migrate"/"migrates into the typed artifact system". Exactly one matches — **PDR-034** ("Legacy brief/PDR/ADR corpus migrates into the typed artifact system"). PDR-007 ("Path-to-name addressing migration") is a routing migration, not a corpus migration — rejected on title. | title-scan |
| T5 | **the eight artifact kinds (closure)** | Making §1–6 "first-class" means giving them a recognized kind. Whether the kind set is *open* or *closed* decides whether that is a config add or a schema change. | `shop-knowledge query --corpus /workspace --facet type --value pdr` → scan titles | **Appendix B (full PDR list, 38 rows).** | Title-scan rule: select the row stating the artifact system's *founding needs / the kinds*. Exactly one — **PDR-035** ("The artifact system rests on a foundational needs statement — why artifacts exist, the eight kinds and how they compose…"). Chosen over PDR-032 (superseded) and PDR-037 (per-kind needs, downstream of 035). | title-scan |
| T6 | **per-type schema (adding a kind)** | If §1–6 need a new kind, I must know what defining a kind costs mechanically, and whether the schema is fixed at eight. | `shop-knowledge query --corpus /workspace --facet type --value adr` → scan titles | **Appendix A (full ADR list, 68 rows).** | Title-scan rule: select the row that is the *per-type schema for the artifact kinds*. Exactly one — **ADR-069** ("Per-type schema for the eight artifact kinds"). ADR-067 (base schema) and ADR-068 (read CLI) are the adjacent slices; ADR-067 is cited as supporting context, ADR-068 is the CLI mechanism — neither is the per-kind schema, so ADR-069 is the primary and 067 secondary. | title-scan |
| T7 | **corpus purpose / two-views** | To judge whether §1–6 *belong* in the corpus I need the corpus's stated purpose — what class of document it is for. | `shop-knowledge render pdr-035 --corpus /workspace` | Full PDR-035 body (Decision parts 1–4). | Same doc as T5 (already selected). Read its Decision D1 ("Why the product keeps artifacts": decisions, intent, shape) to characterise the corpus's intended content class. No new selection. | **yes** |
| T8 | **ship-to-product / distribution boundary** | ADR-037 (T3) rests on a boundary — construction-of-the-system vs product doctrine. I must confirm that reasoning is the ADR's actual load-bearing axis, by reading it. | `shop-knowledge render adr-037 --corpus /workspace` | Full ADR-037 body (Context, D1–D4, Alternatives A–D). | Same doc as T3 (already selected). Read D1/D4 + Option D. No new selection. | **yes** |
| T9 | **live corpus narration** | The current-state artifact narrates what the corpus actually is right now; it is the authoritative "as-built" cross-check on T5/T6. | `shop-knowledge query --corpus /workspace --facet type --value current-state` then `render current-state-001 --view transformation` | `[{"id": "current-state-001", "status": "current"}]` — exactly one current-state document. | current-state is a singleton kind (one row); select it. Read its "Artifact system (live)" paragraph. | **yes** |
| T10 | **status of the migration decision** | A migration decision that is only `proposed`/`held` cannot be cited as authorizing migration. I must read PDR-034's status and hold state. | `shop-knowledge query --corpus /workspace --facet type --value pdr` (status field) + `render pdr-034 --view transformation` | PDR-034 row shows `status: proposed`; body shows it is **held** pending cand-005. | Read the status facet already returned in the T4 list and the body's "held" changelog. No new selection. | **yes** |

---

## 3. Terms → grounded set

Every artifact I rely on, each with its full chain back to Section 2. Nothing appears here without that chain.

### ADR-037 — *The framework spec (§1–6) is a system-construction artifact; it stays in the framework/lead repo and is NOT shipped to product instances* (status: accepted)
- **Chain:** T3/T8 → `query --facet type --value adr` → Appendix A (68 rows) → title-scan rule "row whose subject is the framework spec §1–6" → uniquely ADR-037.
- **What it grounds (read via `render adr-037`):**
  - It is the accepted decision *about the placement of the exact files in the question*. Its Context opens: "The framework spec lives in this repo as the numbered section files `01-principles.md` … `06-work-tracking.md`."
  - **D1:** §1–6 are the system's **self-description** — "the artifact a *framework builder* reads" — and "remains canonical and lives here, in the framework/lead repo, exactly as today."
  - **D4** gives a three-way classifier for where guidance lives: *operative doctrine* → inline in templates; *situational* → skills; **system-self-description** ("it explains *why the system is shaped this way*") → "it belongs in the **framework spec** §1–6, NOT the product." §1–6 is the third kind by name.
  - **Option D** ("Delete §1–6 from the framework/lead repo entirely") is **rejected**: the spec "is the system's self-description and remains canonical *for the framework builder*." So the spec has an affirmed, distinct home that is not the product corpus.

### PDR-034 — *Legacy brief/PDR/ADR corpus migrates into the typed artifact system* (status: proposed, HELD)
- **Chain:** T4/T10 → `query --facet type --value pdr` → Appendix B (38 rows) → title-scan rule "row that migrates the legacy corpus into the typed system" → uniquely PDR-034.
- **What it grounds (read via `render pdr-034 --view transformation`):**
  - The one decision that migrates existing prose docs into the corpus scopes itself **explicitly and only** to `brief/`, `pdr/`, `adr/`: "Full corpus (`brief/`, `pdr/`, `adr/` — all files)." The framework spec §1–6 is **not** in its scope.
  - It is **proposed** and **held**: "This PDR is **held**: do not dispatch the Architect feasibility probe … until `cand-005` phases 1-4 land." So even the in-scope migration is not yet authorized to execute — a fortiori it grants nothing for §1–6.

### PDR-035 — *The artifact system rests on a foundational needs statement … the eight kinds* (status: accepted)
- **Chain:** T5/T7 → `query --facet type --value pdr` → Appendix B (38 rows) → title-scan rule "founding needs / the kinds" → uniquely PDR-035.
- **What it grounds (read via `render pdr-035`):**
  - **Kind closure:** Decision part 2 — "The system recognizes eight artifact kinds." The set is an enumeration, not open-ended.
  - **Corpus purpose:** Decision part 1 — artifacts exist so "the present state of the **product's** thinking is legible": *decisions, intent, and shape*. This is product-thinking content, a different category from the framework's account of its own design (which ADR-037 D1 assigns to §1–6).

### ADR-069 — *Per-type schema for the eight artifact kinds* (status: accepted)
- **Chain:** T6 → `query --facet type --value adr` → Appendix A (68 rows) → title-scan rule "per-type schema for the kinds" → uniquely ADR-069 (with ADR-067 base-schema as adjacent supporting slice, named in ADR-069's own Context).
- **What it grounds (read via `render adr-069`):**
  - The schema is defined "for each of the **eight** kinds, *what it adds to or constrains beyond the base schema*." A ninth kind (framework-spec) is not present; adding one is a schema change to this accepted per-type schema, not a configuration toggle.

### current-state-001 — *shopsystem-product — current state* (status: current)
- **Chain:** T9 → `query --facet type --value current-state` → single row `current-state-001` → render `--view transformation`.
- **What it grounds:** The "Artifact system (live)" paragraph confirms as-built: "The product's own decisions, intent, and shape are kept as a typed artifact corpus governed by `shopsystem-knowledge`: **eight kinds** on a single-sourced typedef→generator base schema." The live corpus is eight kinds; §1–6 is not listed among its artifacts (it lists intents, candidates, sessions, prioritizations, briefs, PDRs, ADRs, and the current-state).

---

## 4. Verified facts as assertions

Each fact is a command plus a must-contain anchor. The block below exits 0 iff every anchor holds. Re-run verbatim from `/workspace`.

```bash
#!/usr/bin/env bash
# Grounding checks — exits 0 iff every anchor holds. Run from /workspace.
set -u
pass=0; fail=0
chk(){ if eval "$2" >/dev/null 2>&1; then echo "PASS: $1"; pass=$((pass+1));
       else echo "FAIL: $1"; fail=$((fail+1)); fi; }

# F1: the corpus has NO framework-spec / spec / principle type (empty result).
chk "F1a framework-spec type is empty" \
  "[ \"\$(shop-knowledge query --corpus /workspace --facet type --value framework-spec)\" = '[]' ]"
chk "F1b spec type is empty" \
  "[ \"\$(shop-knowledge query --corpus /workspace --facet type --value spec)\" = '[]' ]"
chk "F1c principle type is empty" \
  "[ \"\$(shop-knowledge query --corpus /workspace --facet type --value principle)\" = '[]' ]"

# F2: §1 (01-principles.md) is NOT a document in the corpus graph.
chk "F2 01-principles absent from corpus" \
  "shop-knowledge navigate 01-principles --corpus /workspace 2>&1 | grep -q \"no document with id '01-principles'\""

# F3: ADR-037 (accepted) keeps §1-6 in the framework/lead repo, not shipped to products.
chk "F3 ADR-037 keep-in-framework-repo" \
  "shop-knowledge render adr-037 --corpus /workspace | grep -q 'stays in the framework/lead repo and is NOT shipped to product instances'"

# F4: PDR-034 scopes legacy-corpus migration to brief/pdr/adr only (Full corpus line).
chk "F4 PDR-034 scope is brief/pdr/adr" \
  "shop-knowledge render pdr-034 --corpus /workspace --view transformation | grep -q 'Full corpus'"

# F5: PDR-035 (accepted) fixes the kind set at eight.
chk "F5 PDR-035 recognizes eight kinds" \
  "shop-knowledge render pdr-035 --corpus /workspace | grep -q 'recognizes eight artifact'"

# F6: ADR-069 (accepted) defines the schema for exactly the eight kinds.
chk "F6 ADR-069 per-type schema for eight" \
  "shop-knowledge render adr-069 --corpus /workspace | grep -q 'for each of the eight kinds'"

# F7: live current-state narrates the corpus as eight kinds.
chk "F7 current-state narrates eight kinds" \
  "shop-knowledge render current-state-001 --corpus /workspace --view transformation | grep -q 'eight kinds'"

echo "----- PASS=$pass FAIL=$fail -----"
[ "$fail" -eq 0 ]
```

*Observed result at authoring time: `PASS=9 FAIL=0` (F1 is three sub-checks).*

**What each fact establishes:**
- **F1 + F2** — Empirical pre-state: §1–6 are plain markdown *outside* the corpus today; no framework-spec-shaped type exists. (The question's premise is verified, not assumed.)
- **F3** — The placement of §1–6 is already an *accepted* decision: they stay in the framework/lead repo.
- **F4** — The only corpus-migration decision explicitly excludes §1–6 (scope is brief/pdr/adr).
- **F5 + F6 + F7** — The corpus kind set is a closed enumeration of eight, in the founding needs (PDR-035), the per-type schema (ADR-069), and the live current-state. A framework-spec kind is not among them.

---

## 5. Decision

**Recommendation: STAY — keep §1–6 as plain markdown outside the typed corpus.** Justified strictly against Sections 3–4:

1. **The placement is already decided, and decided the other way.** ADR-037 (accepted; F3) takes the framework spec §1–6 as its explicit subject and rules that it "remains canonical and lives here, in the framework/lead repo, exactly as today." Its D4 classifies §1–6 as **system-self-description**, a category it deliberately keeps *out* of the product-facing surface. Migrating §1–6 into the product's typed corpus as first-class artifacts runs against this accepted decision; re-opening it needs a superseding decision, which does not exist in the grounded set.

2. **The corpus is for a different content class.** PDR-035 D1 (F5) states the corpus exists for "the **product's** … decisions, intent, and shape." The framework spec is the *system's* self-description of its own design (ADR-037 D1) — not the product's thinking. Category mismatch: §1–6 is not the kind of thing the corpus is built to hold.

3. **"First-class" would force a schema change no decision authorizes.** The kind set is closed at eight (PDR-035 D2, ADR-069, current-state-001; F5–F7). Making §1–6 first-class requires a ninth kind — a change to the accepted per-type schema (ADR-069) and base needs (PDR-035). No grounded artifact proposes or accepts a framework-spec kind.

4. **The one migration effort excludes §1–6 and is not even live.** PDR-034 (F4) scopes legacy-corpus migration to `brief/`/`pdr/`/`adr/` only, and is `proposed` + held (T10). It provides zero authorization for migrating §1–6.

Nothing in the grounded set argues for MIGRATE. Every relevant accepted artifact points to STAY.

**Narrow caveat (still within the record):** ADR-037 D4 leaves the door open to *authoring* §1–6-shaped material as a distinct future artifact category for the framework builder — but that would be a **new kind** decided by a superseding ADR/PDR, not "migrate the existing markdown into the current eight-kind product corpus." The question as posed (migrate INTO the typed artifact corpus as first-class artifacts) is answered STAY.

---

## 6. Where this could be wrong (ranked)

1. **Concepts/terms I may have failed to derive (completeness-of-terms hole).** I derived terms from the question's own words plus adjacents (self-description, distribution boundary, schema closure). A term I did not derive could carry a contrary decision — e.g. a "spec as artifact" or "framework-doctrine artifact" or "principles corpus" decision filed under a title my scans would not have matched. Mitigation: I scanned the *complete* ADR (68) and PDR (38) title lists, not a filtered subset, so any such decision would have to be titled in a way that reads as unrelated to framework spec / corpus / migration / kinds. **Could change the recommendation** if such a doc exists and accepts a ninth kind. Judged low-likelihood but this is the residual hole.
2. **False positive on ADR-037's currency (I rely on it being live).** If ADR-037 were superseded, my primary ground weakens. Check: `shop-knowledge query --facet type --value adr` shows ADR-037 `status: accepted` (not superseded), and `navigate adr-037 --direction both` shows only `derives-from adr-018` / `derived-by brief-011` — no `superseded-by` edge. **Would change confidence, not direction** (PDR-035/ADR-069 kind-closure still independently support STAY).
3. **False negative on the migration scope (maybe a newer doc widens PDR-034).** PDR-034 is `proposed`; a later accepted decision could broaden legacy migration to include §1–6. Check: no ADR/PDR title in Appendices A/B names the framework spec as a migration target, and F1/F2 confirm §1–6 remain un-migrated as-built. **Would change the recommendation** only if such a doc both exists and is accepted — not found.
4. **Interpretation risk on "first-class artifact."** I read "first-class" as "carries a recognized `type` and participates in the edge graph" (the corpus's own definition of membership). If the user means something looser — e.g. merely giving §1–6 frontmatter for retrieval *without* a corpus `type* — the schema-closure argument (point 3 in §5) softens, though ADR-037's placement decision (point 1) still holds. **Could shift the framing** but not the core STAY recommendation.
5. **Tag facet is empty (a discovery channel I could not use).** All selection here is title-scan or exact type/status query; the `tag` facet returned nothing to filter on. A tag-based grouping (had it existed) might have surfaced an artifact a title-scan misses. This compounds risk #1 rather than adding a new one.

---

## Appendix A — Full ADR candidate set (scanned for T3, T6)

Command: `shop-knowledge query --corpus /workspace --facet type --value adr` (68 rows; `id | status | title`).

```
adr-001 | accepted | Framework packaging into bounded-context-aligned repos
adr-002 | accepted | Introducing the harness Bounded Context
adr-004 | accepted | shopsystem-bc-launcher as a new Bounded Context
adr-005 | accepted | BC Manifest as a Committed File in the Lead Repo, Managed via bc-launcher CLI
adr-006 | accepted | Messaging name registry design
adr-008 | accepted | shopsystem-docs as a new Bounded Context
adr-009 | accepted | Clarify-resolution vehicle: re-dispatch via existing catalog message types
adr-010 | accepted | Clarify-resolution work_done.scenario_hashes scope: strict subset of the resolving dispatch
adr-011 | accepted | Bead/message field mapping: lead bd schema for projecting shop-msg lifecycle
adr-012 | accepted | Outbox-pattern atomicity: bd-first writes for shop-msg send/respond
adr-013 | accepted | Dispatch dependencies via bd dep add honored by shop-msg send
adr-014 | accepted | Presence heartbeat collapsed into shop-msg watch
adr-015 | accepted | nudge message type for operational liveness
adr-016 | accepted | shop-msg owns bd integration; state changes via CLI, not agent
adr-017 | accepted | BC-side bead creation on inbox drain; cross-reference via shared work_id
adr-018 | accepted | "Verify pre-state empirically" means the contract/artifact surface; the lead carries no BC code
adr-019 | accepted | Scenario canonicalization and hash discipline owned by shopsystem-scenarios
adr-020 | accepted | Routing identity is an abstract <system>/<name> address; shop_root eliminated
adr-021 | accepted | shopsystem-bc-base image owned and built by shopsystem-bc-launcher
adr-022 | accepted | bc-base rebuilds are CENTRALIZED in shopsystem-bc-launcher
adr-023 | proposed | scenario-completion journal decomposed scenarios(KEY) + messaging + lead snapshot
adr-024 | accepted | Journal bootstrap/rebuild (sc08) is a new op ON the messaging-owned journal store
adr-025 | accepted | scenario-completion journal is a FILE owned by shopsystem-scenarios
adr-026 | accepted | BC credentials brokered through an agent-vault server
adr-027 | accepted | shop-msg respond is BC->lead only; lead answers clarifies via re-dispatch
adr-028 | accepted | agent-vault broker is a lead-shop supporting-service, not a BC
adr-029 | accepted | Spike vehicle: extend PDR-014 graduation; reject request_spike for now
adr-030 | accepted | Spike isolation contract: spike- scratch, dummy data, throwaway worktree
adr-031 | accepted | Human-in-the-loop wall protocol for autonomous spikes
adr-032 | accepted | Spikes execute via Workflow and return markdown findings
adr-033 | accepted | BC-local architect role; there is NO BC-local PO
adr-034 | superseded | System-global architecture decisions live in the lead repo's adr/ tree, tagged by tier
adr-035 | superseded | Three-tier ADR hierarchy + periodic system-architect review cadence
adr-036 | accepted | Procedural preconditions mechanically checked are CLI-layer
adr-037 | accepted | The framework spec (§1-6) is a system-CONSTRUCTION artifact; stays in framework/lead repo, NOT shipped to product instances
adr-038 | accepted | manifest product: field is the canonical product-identity source
adr-039 | accepted | Release cadence for lead-facing packages
adr-040 | accepted | adopter Footing is a deterministic agent-less bootstrap script
adr-041 | accepted | launch/engage failure writes a host-readable diagnostic file
adr-042 | proposed | ADR-036 procedural-precondition migration as-built through enforcement layer
adr-043 | accepted | Every derived bootstrap coordinate computed ONCE at a canonical point
adr-045 | proposed | AGENT_VAULT_CA_PEM carries inline PEM content, not a filesystem path
adr-046 | proposed | framework launcher/leaf image in bin/shop-shell is a parameterized variable
adr-047 | proposed | system-manifest.yaml BOM mechanics
adr-048 | proposed | Fabro is an alternable in-container BC-orchestration substrate
adr-049 | proposed | Agent-vault is the SOLE credential surface under fabro
adr-050 | proposed | Fabro launch-interface parity with bc-container
adr-051 | proposed | fabro DOT loop-graph contract
adr-052 | proposed | Dagger is the local+CI build/test substrate for bc-base
adr-053 | proposed | Same-definition-locally-and-in-CI (no-divergence)
adr-054 | proposed | Agent-vault sole credential surface for the dagger build egress
adr-055 | proposed | build-time CA-trust prerequisite for the MITM-local dagger loop
adr-056 | accepted | Scenario files conform to a three-dimension schema
adr-057 | accepted | BC work-loop single-sourced from shopsystem-templates, projected to .claude/ and .fabro/
adr-058 | proposed | fabro engage reactive watcher is a REAL CYCLIC dispatcher graph
adr-059 | superseded | shopsystem-knowledge single-sources each artifact FORMAT from per-type typedef/*.yaml
adr-060 | accepted | on-wire ScenarioPayload.hash aligns to BLOCK-ONLY
adr-061 | accepted | External-content ingestion MUST pass an MIT-compatibility check
adr-062 | proposed | Cross-runtime (tmux/fabro) parity via a SINGLE SHARED Python anchor module
adr-063 | accepted | fleet-wide tier+effort->model mapping table is bc-launcher-owned
adr-064 | proposed | Scenario-retirement convention
adr-065 | accepted | Spike/findings material never authoritative over ADR/PDR
adr-066 | accepted | Direct grant from Dean Peters authorizes MIT ingestion of PM skills
adr-067 | accepted | The artifact-system base schema (base fields, edge pairs, tags, distribution) — supersedes ADR-059/034/035
adr-068 | accepted | The corpus read-side mechanism — one read-only CLI with navigate/render/query
adr-069 | accepted | Per-type schema for the eight artifact kinds
adr-070 | accepted | Per-type writing-skill template structure
adr-071 | accepted | shop-templates enforces every recognized artifact kind has a valid writing skill
```

Rows matching the T3 rule ("subject IS the framework spec §1–6"): **adr-037** only. Rows matching the T6 rule ("per-type schema for the kinds"): **adr-069** only (with adr-067 the base-schema slice named in adr-069's Context).

## Appendix B — Full PDR candidate set (scanned for T4, T5)

Command: `shop-knowledge query --corpus /workspace --facet type --value pdr` (38 rows; `id | status | title`).

```
pdr-001 | proposed | Lead-shop role templates must be role-complete, identity-first
pdr-002 | proposed | Lead-shop PO and Architect dispatched as subagents (router pattern)
pdr-003 | proposed | CLAUDE.md update propagation
pdr-004 | proposed | BC container command ownership
pdr-005 | proposed | Architect technical review gate before dispatch
pdr-006 | proposed | BC manifest ownership
pdr-007 | accepted | Path-to-name addressing migration
pdr-009 | accepted | Implicit CWD-based shop resolution in shop-msg
pdr-010 | accepted | bd is authoritative for system state; shop-msg is transport + wakeup + liveness
pdr-011 | proposed | "Verify pre-state empirically" means verify the contract surface, not BC code
pdr-012 | proposed | Elevate lead-po to empowered Product-Manager scope
pdr-013 | proposed | BC decomposition/splitting discipline; BC-local architect role + three-tier ADR hierarchy
pdr-014 | proposed | Canonical lead skill-group: shop-templates pours it, graduation path
pdr-015 | proposed | Scenario-completion journal + lead snapshot: solution-space framing
pdr-016 | proposed | Iterative experimentation is a first-class lead capability: spike lifecycle
pdr-017 | proposed | Agent-vault broker standup + fleet credential flip
pdr-018 | proposed | dummy-product instantiation spike is the MVP acceptance gate
pdr-019 | proposed | Adopter bootstrap: the Footing is a deterministic agent-less script
pdr-020 | proposed | lead shell is a bc-container-launched bc-base session
pdr-021 | accepted | Unify product bringup on the Footing runway
pdr-022 | accepted | Footing DELEGATES agent-vault provisioning to bin/agent-vault-provision
pdr-023 | proposed | Skills provenance marker: re-pour overwrites only CANONICAL skills
pdr-024 | proposed | rendered bin/doctor validates a bootstrapped shop's credentials
pdr-025 | proposed | bin/agent-vault-approve-claude verifies preconditions up front
pdr-026 | proposed | Published bc-launcher images carry version provenance
pdr-027 | proposed | Empty-repo detection fires a proactive product-discovery trigger
pdr-028 | proposed | bin/bootstrap verifies the pulled image's baked shop-templates version
pdr-029 | accepted | request_scenario_register is a distinct vehicle
pdr-030 | proposed | shopsystem system version is an independent standard semver
pdr-031 | rejected | shopsystem-knowledge: a kind-extensible knowledge context, discovery-first
pdr-032 | superseded | shopsystem-knowledge owns the artifact type system and coherence gate (EXTEND)
pdr-033 | accepted | PM as main-session mode; PO retains convergent contract work
pdr-034 | proposed | Legacy brief/PDR/ADR corpus migrates into the typed artifact system
pdr-035 | accepted | artifact system rests on a foundational needs statement — the eight kinds
pdr-036 | accepted | corpus gets one read-only CLI — navigate, render, query
pdr-037 | accepted | Each of the eight artifact kinds gets its own stated needs
pdr-038 | accepted | Every artifact kind gets a writing skill
pdr-900 | accepted | Legacy: framework-construction genesis decision (synthetic grounding)
```

Rows matching the T4 rule ("migrates the legacy corpus into the typed system"): **pdr-034** only. Rows matching the T5 rule ("founding needs / the kinds"): **pdr-035** only (pdr-032 superseded, pdr-037 is the downstream per-kind needs).
