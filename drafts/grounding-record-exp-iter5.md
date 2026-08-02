# Grounding record — Should the framework spec §1–6 migrate INTO the typed artifact corpus, or stay plain markdown OUTSIDE it?

Researcher's verifiable grounding record. All grounding via `shop-knowledge query|navigate|render` from `/workspace`.

---

## Per-command invocation forms (Rule 0 — no blanket flag claim)

There is **no single invocation form** valid across all subcommands. Each subcommand's accepted form was discovered by running it:

| Subcommand | Accepted form | `--corpus .`? |
|---|---|---|
| `query` | `shop-knowledge query --corpus . --facet <facet> --value <value>` | **required** |
| `navigate` | `shop-knowledge navigate <id> --corpus . --direction both` | **required** |
| `render` (accepted docs) | `shop-knowledge render <id> --corpus .` | **required** |
| `render` (non-accepted docs) | `shop-knowledge render <id> --corpus . --view transformation` | **required** |
| `schema` / `template` | `shop-knowledge schema <kind>` (bare kind) | **rejected** (takes exactly one artifact type) |

Valid `query` facets (from the tool's own error): **type, status, tag, distribution**. Valid `query` edges: **superseded-by, references, referenced-by** (plus `derives-from`/`derived-by` seen via `navigate`). **There is NO full-text / body-content facet.** Per Rule 1b this means *body-level uniqueness claims cannot be established by query alone* — every uniqueness claim below is labeled title-level, and no claim rests on unrun body-uniqueness. The `tag` and `distribution` facets returned `[]` for every topical value tried (`framework-spec`, `migration`, `legacy`, `corpus`, `product-lead`, `product-wide`, `bc-local`) — they are effectively unpopulated, so topic sweeps run over the `type` enumeration + title scans, not tags.

---

> ## Summary box
>
> **Question (verbatim):** "Should the shopsystem framework spec (the framework principles/spec, sections 1 through 6, currently plain markdown in the lead/framework repo) be migrated INTO the typed artifact corpus as first-class artifacts, or stay as plain markdown OUTSIDE the corpus?"
>
> **Recommendation (1 line):** **STAY as plain markdown OUTSIDE the typed corpus** — no live effort scopes §1–6 in, no recognized artifact kind fits it, and the one accepted decision about §1–6 (adr-037) keeps it in the framework/lead repo "exactly as today."
>
> **Confidence:** **Medium-high.** Every pillar points the same way and nothing contradicts, BUT no single *accepted* doc squarely decides the corpus-**membership** axis for §1–6 (adr-037 decides the shipping/location axis; the typed corpus postdates it), so the recommendation is a synthesis of adjacent decisions, and "migrate it in / mint a ninth kind" is not foreclosed by any doc — that residue is genuine product-authority judgment.
>
> **Term coverage:** 7 terms; **7 re-runnable**, 4 of them realized as reproducible **title-scans** over the full type enumeration; 0 rest on an unrun body claim.
>
> **Most load-bearing artifact:** brief-024 (the live migration's stated scope). **Axis match: YES** (it decides exactly what does/does not enter the corpus). Secondary: adr-037 — **Axis match: PARTIAL/borderline** (decides shipping-outward + "stays in repo as today," silent on typed-vs-markdown membership specifically).
>
> **Topic-sweep tally:** pillars swept = 4; accepted/committed/current on-topic docs found = adr-037, pdr-035, adr-067, adr-068, adr-069, adr-070, adr-071, pdr-037, pdr-900, cand-900, current-state-001; **all surfaced: YES.**
>
> **Counter-example tally:** negative-existential pillars = 2; accepted category-instances found = current-state-001 (product self-description in corpus), pdr-900/cand-900/intent-900/sess-2026-05-11-a (framework-construction artifacts in corpus); **each confronted: YES** (Section 5).
>
> **Most-direct-empirical-proof per pillar:** P1 → brief-024 (scope block); P2 → adr-037 D1; P3 → adr-069 / brief-024 ("8 types and no `finding` type"); P4 → sess-2026-05-11-a + brief-024 synthetic-grounding rule.
>
> **Every included doc's stated selection rule returns it on re-run: YES.**
> **All pasted commands reproduce verbatim: YES.**
>
> **Attack Section 0 and Section 2 first.**

---

## Section 0 — Type inventory (the complete universe)

**Kinds command** (exits 0, lists the eight kinds via the tool's own recognizer error; `|| true` makes the pasted string exit 0 both standalone and under `set -e`):

```
shop-knowledge schema zzz 2>&1 || true
```

Output (verbatim):

```
error: 'zzz' is not a recognized artifact type
the eight recognized artifact types are: intent-record, candidate, session-record, prioritization-record, brief, pdr, adr, current-state
```

The eight kinds: **intent-record, candidate, session-record, prioritization-record, brief, pdr, adr, current-state.** Each enumerated mechanically below. Every per-kind command carries `--corpus .` and exits 0.

### intent-record — `shop-knowledge query --corpus . --facet type --value intent-record`

```
[{"id": "intent-001", ...}, {"id": "intent-002", ...}, {"id": "intent-003", ...}, {"id": "intent-004", ...}, {"id": "intent-005", ...}, {"id": "intent-006", "title": "Legacy corpus (brief/PDR/ADR) migrates into the typed artifact system", "status": "recorded"}, {"id": "intent-007", ...}, {"id": "intent-008", ...}, {"id": "intent-009", ...}, {"id": "intent-010", ...}, {"id": "intent-011", ...}, {"id": "intent-012", ...}, {"id": "intent-900", "title": "Legacy: construct the shopsystem framework (pre-intent-record era)", "status": "recorded"}]
```

Reported count: **13.** Ids: intent-001, intent-002, intent-003, intent-004, intent-005, intent-006, intent-007, intent-008, intent-009, intent-010, intent-011, intent-012, intent-900. Listed == reported: **13 == 13.** (No intent-013…; no gap claimed.)

### candidate — `shop-knowledge query --corpus . --facet type --value candidate`

```
[{"id": "cand-001", ...}, {"id": "cand-002", ...}, {"id": "cand-003", ...}, {"id": "cand-004", "title": "Migrate the legacy brief/PDR/ADR corpus into the typed artifact system", "status": "shaped"}, {"id": "cand-005", ...}, {"id": "cand-006", ...}, {"id": "cand-007", ...}, {"id": "cand-008", ...}, {"id": "cand-009", ...}, {"id": "cand-900", "title": "Legacy: framework-construction decisions (synthetic grounding)", "status": "committed"}]
```

Reported count: **10.** Ids: cand-001, cand-002, cand-003, cand-004, cand-005, cand-006, cand-007, cand-008, cand-009, cand-900. Listed == reported: **10 == 10.**

### session-record — `shop-knowledge query --corpus . --facet type --value session-record`

```
[{"id": "sess-2026-05-11-a", "title": "Legacy: framework-genesis session (reconstructed)", "status": "closed"}, {"id": "sess-2026-07-09-a", ...}, {"id": "sess-2026-07-14-a", ...}, {"id": "sess-2026-07-14-b", ...}, {"id": "sess-2026-07-15-a", ...}, {"id": "sess-2026-07-16-a", "title": "Legacy corpus migration, then the full knowledge/schema precondition chain", "status": "closed"}, {"id": "sess-2026-07-19-a", ...}, {"id": "sess-2026-07-20-a", ...}, {"id": "sess-2026-07-25-a", ...}, {"id": "sess-2026-07-27-a", ...}]
```

Reported count: **10.** Ids: sess-2026-05-11-a, sess-2026-07-09-a, sess-2026-07-14-a, sess-2026-07-14-b, sess-2026-07-15-a, sess-2026-07-16-a, sess-2026-07-19-a, sess-2026-07-20-a, sess-2026-07-25-a, sess-2026-07-27-a. Listed == reported: **10 == 10.**

### prioritization-record — `shop-knowledge query --corpus . --facet type --value prioritization-record`

```
[]
```

Reported count: **0.** No prioritization-record documents exist. Listed == reported: **0 == 0.**

### brief — `shop-knowledge query --corpus . --facet type --value brief`

```
[{"id": "brief-001"...}, ... {"id": "brief-024", "title": "Migrate the ~119-file legacy artifact corpus forward into the modern typed-artifact system", "status": "ready"}]
```

Reported count: **24.** Ids: brief-001, brief-002, brief-003, brief-004, brief-005, brief-006, brief-007, brief-008, brief-009, brief-010, brief-011, brief-012, brief-013, brief-014, brief-015, brief-016, brief-017, brief-018, brief-019, brief-020, brief-021, brief-022, brief-023, brief-024. Listed == reported: **24 == 24.** (Contiguous 001–024, no gap.)

### pdr — `shop-knowledge query --corpus . --facet type --value pdr`

Reported count: **38.** Ids: pdr-001, pdr-002, pdr-003, pdr-004, pdr-005, pdr-006, pdr-007, pdr-009, pdr-010, pdr-011, pdr-012, pdr-013, pdr-014, pdr-015, pdr-016, pdr-017, pdr-018, pdr-019, pdr-020, pdr-021, pdr-022, pdr-023, pdr-024, pdr-025, pdr-026, pdr-027, pdr-028, pdr-029, pdr-030, pdr-031, pdr-032, pdr-033, pdr-034, pdr-035, pdr-036, pdr-037, pdr-038, pdr-900. Listed == reported: **38 == 38.** **pdr-008 is absent from the raw output** (008 does not appear between 007 and 009 in the returned array — a proven gap, not inferred). pdr-034 status = **proposed**; pdr-900 status = **accepted**.

### adr — `shop-knowledge query --corpus . --facet type --value adr`

Reported count: **68.** Ids: adr-001, adr-002, adr-004, adr-005, adr-006, adr-008, adr-009, adr-010, adr-011, adr-012, adr-013, adr-014, adr-015, adr-016, adr-017, adr-018, adr-019, adr-020, adr-021, adr-022, adr-023, adr-024, adr-025, adr-026, adr-027, adr-028, adr-029, adr-030, adr-031, adr-032, adr-033, adr-034, adr-035, adr-036, adr-037, adr-038, adr-039, adr-040, adr-041, adr-042, adr-043, adr-045, adr-046, adr-047, adr-048, adr-049, adr-050, adr-051, adr-052, adr-053, adr-054, adr-055, adr-056, adr-057, adr-058, adr-059, adr-060, adr-061, adr-062, adr-063, adr-064, adr-065, adr-066, adr-067, adr-068, adr-069, adr-070, adr-071. Listed == reported: **68 == 68.** **adr-003, adr-007, adr-044 are absent from the raw output** (proven gaps). adr-037 status = **accepted**; adr-034 & adr-035 status = **superseded**.

### current-state — `shop-knowledge query --corpus . --facet type --value current-state`

```
[{"id": "current-state-001", "title": "shopsystem-product — current state", "status": "current"}]
```

Reported count: **1.** Ids: current-state-001. Listed == reported: **1 == 1.**

**Universe total: 13 + 10 + 10 + 0 + 24 + 38 + 68 + 1 = 164 documents across 8 kinds.** Every selection rule in Sections 2–3 runs against this universe.

---

## Section 2 — Question → terms (the audit surface)

Terms derived generously from the question: the *artifact* (framework spec §1–6), the *action* (migrate into the typed corpus), the *alternative* (stay markdown outside), and the structural concepts that decide it (recognized kinds; the framework's construction/self-description nature; the framework's genesis already in the corpus).

| # | Term | Why the QUESTION forces it | Exact command (reproduces verbatim) | Full cross-kind candidate set surfaced | Selection rule (include AND exclude, both executed) | Rule returns the doc on re-run | Entry point per survivor | Title/body | Kinds scanned | Re-runnable |
|---|---|---|---|---|---|---|---|---|---|---|
| T1 | **framework spec §1–6 disposition** | The question's subject; need the doc that rules on §1–6 | `shop-knowledge query --corpus . --facet type --value adr` then title-scan `framework spec` | **adr-037** (only adr title containing "framework spec"); all other 67 adr titles scanned, none contains it | Include title matching `framework spec`; exclude 67 non-matching adr titles — scan executed, survivor set = **{adr-037}** | YES — title-scan returns exactly adr-037 | title-scan, facet type=adr | **title** | adr (the kind that rules on §1–6) | yes / title-scan |
| T2 | **migrate legacy corpus INTO typed system** | The action; need every doc proposing prose→corpus migration | `shop-knowledge query --corpus . --facet type --value <k>` for all 8 k, title-scan `migrat` | migrat-titled: intent-006, cand-004, sess-2026-07-16-a, sess-2026-07-25-a, brief-024, pdr-007, pdr-034, adr-042 | Include titles naming *legacy-corpus* migration → **{intent-006, cand-004, pdr-034, brief-024}** (+ session containers); **exclude pdr-007** (path-to-name addressing) and **adr-042** (ADR-036 procedural) — unrelated migrations, exclusion executed by reading each title | YES — the four survive; pdr-007/adr-042 visibly present and rejected | title-scan, all kinds | **title** | ALL 8 | yes / title-scan |
| T3 | **framework construction / self-description** | §1–6 *is* the framework's self-description; need docs classifying that category | `shop-knowledge query --corpus . --facet type --value <k>` for all 8 k, title-scan `legacy` | legacy-titled: intent-006, intent-900, cand-004, cand-900, sess-2026-05-11-a, sess-2026-07-16-a, brief-024, pdr-034, pdr-900 | Include `Legacy: framework-*` / `framework-construction` titles → **{intent-900, cand-900, pdr-900, sess-2026-05-11-a}**; migration-cluster (T2) excluded here as different subject | YES — the four framework-genesis stubs surface | title-scan + provenance edges (sess-2026-05-11-a `produced`) | **title** | ALL 8 | yes / title-scan |
| T4 | **recognized artifact kinds (does a kind fit §1–6?)** | To migrate in, §1–6 needs a target kind; need the kind taxonomy | `shop-knowledge schema zzz 2>&1 || true` and `shop-knowledge query --corpus . --facet type --value adr` title-scan `eight artifact kinds` | kinds recognizer → the 8 names; adr title-scan → adr-069; pdr title-scan → pdr-037 | The eight kind-names are the closed enumeration the recognizer returns; **none is "framework-spec/principles/self-description-of-framework"** — verified by reading all eight names | YES — recognizer returns exactly 8; adr-069 returns on `eight artifact kinds` scan | kinds recognizer + title-scan | **title** | schema recognizer + adr/pdr | yes / title-scan |
| T5 | **stay markdown OUTSIDE / status quo location** | The alternative; adr-037 governs where §1–6 lives | `shop-knowledge render adr-037 --corpus .` | adr-037 D1 + Option D (single doc; the T1 survivor) | Read D1/D4/Option D of the T1 survivor | YES (same doc as T1) | render of T1 survivor | **body** (D-clauses) | adr | yes |
| T6 | **framework genesis already in corpus (counter-example)** | Negative-existential guard: is any framework artifact already typed? | `shop-knowledge navigate sess-2026-05-11-a --corpus . --direction both` | sess-2026-05-11-a `produced` → intent-900, cand-900, pdr-900 | Follow `produced` edges — real graph edges, not prose | YES — navigate returns the three | provenance edge from sess-2026-05-11-a | edge | session→intent/cand/pdr | yes |
| T7 | **self-description artifact in corpus (counter-example)** | Negative-existential guard: does the corpus already hold a self-description doc? | `shop-knowledge query --corpus . --facet type --value current-state` | **current-state-001** (the only current-state doc) | Facet query returns the sole current-state instance | YES — the only row | facet query type=current-state | facet | current-state | yes |

---

## Section 3 — Terms → grounded set

Each relied-on artifact with its full chain, entry point (Rule 1c), title/body label (Rule 1b), axis verdict (Rule 3), evidence-directness (Rule 2c), and provenance edges (Rule 5).

### adr-037 — "The framework spec (§1–6) is a system-CONSTRUCTION artifact … stays in the framework/lead repo and is NOT shipped to product instances" — **status: accepted**

- **Entry point:** title-scan for `framework spec` over the facet query `type=adr` (T1) — a query/title-scan hit, NOT a prose citation. Unique survivor of 68 adr titles.
- **Title/body:** the uniqueness claim ("only adr title naming the framework spec") is **title-level** and proven by the full 68-id scan. The decision content relied on is **body-level** (D1, D4, Option D), read from the full render.
- **Rendered in full:** `shop-knowledge render adr-037 --corpus .`. Load-bearing clauses, quoted verbatim:
  - **D1:** "The numbered sections `01-principles.md` … `06-work-tracking.md` are the **system's self-description** … They are NOT shipped with the `shopsystem-templates` package to product instances. … The spec remains canonical and lives here, in the framework/lead repo, **exactly as today**."
  - **D4 taxonomy** distinguishes three guidance kinds; the third: "**system-self-description** | it explains *why the system is shaped this way* | it belongs in the **framework spec** §1–6, NOT the product (D1)."
  - **Option D (rejected):** "Delete §1–6 from the framework/lead repo entirely … **Rejected** … The spec is the system's self-description and remains canonical *for the framework builder*."
- **Axis it decides (one sentence):** whether §1–6 is *shipped outward to product instances as package data*, and whether it *stays in the framework/lead repo* (answer: not shipped; stays, "exactly as today").
- **Axis the question asks (one sentence):** whether §1–6 becomes a *typed first-class corpus artifact* vs. *plain markdown*.
- **Axis match: PARTIAL / borderline.** adr-037 affirms §1–6 stays in the repo in its current (markdown) form and must not be deleted — which *bears on* the format/membership question — but it does not explicitly rule on typed-artifact-vs-markdown membership, and the typed corpus (PDR-032/ADR-067, July) postdates adr-037 (pre-state verified 2026-06-12), so it could not have contemplated it. Used as a **supporting** pillar (P2), never as the sole headline.
- **Evidence directness (Rule 2c):** most direct proof that §1–6 is classed as the framework's self-description that "stays home as today" — quoted and cited as evidence, not demoted.
- **Provenance (Rule 5):** `shop-knowledge navigate adr-037 --corpus . --direction both` → `derives-from: adr-018` (accepted; the empirical-verification rule) and `derived-by: brief-011` (draft; the new-product bootstrap path). **No supersede edge, no edge to any type-system doc** — adr-037 is a live, unsuperseded node. adr-018 read: it is the "verify pre-state = contract/artifact surface" rule, upstream context only, not on the membership axis. brief-011 (draft) consumes adr-037's "spec not shipped outward" for bootstrap; downstream, not on axis.

### brief-024 — "Migrate the ~119-file legacy artifact corpus forward into the modern typed-artifact system" — **status: ready** (MOST LOAD-BEARING)

- **Entry point:** title-scan for `migrat` + `legacy` over all 8 kinds (T2/T3) — query/title-scan hit.
- **Title/body:** scope claim is **body-level**, read from the full `--view transformation` render.
- **Rendered in full:** `shop-knowledge render brief-024 --corpus . --view transformation`. Load-bearing clauses:
  - **In scope:** "The **119 legacy files** in `pdr/` (33), `adr/` (63), `briefs/` (23): directory rename … frontmatter synthesis …" plus the `intent/` → `intents/` rename.
  - **Explicitly out of scope:** "**Redesigning the schema, typedefs, status vocabulary, or lifecycle semantics** — this is a forward-migration onto the *existing* spec."
  - **Kind set, body-level:** "historical-reference-only — the reason there are 8 types and no `finding` type."
  - **Synthetic grounding:** genesis-root legacy ADRs get "**synthetic upstream artifacts** … `adr-001 → pdr-900 → cand-900 → intent-900`."
- **Axis it decides:** exactly which files enter the typed corpus and which do not — the corpus-**membership** axis. **The framework spec files `01-principles.md`…`06-work-tracking.md` appear nowhere in scope, in-scope or out-of-scope; the migration targets are `pdr/adr/briefs/intents` only.**
- **Axis match: YES.** This is the question's axis directly.
- **Evidence directness (Rule 2c):** THE most direct proof of Pillar 1 (the live migration does not scope §1–6 in) — quoted, cited as primary evidence, not a footnote.
- **Provenance (Rule 5):** `navigate` → `derives-from: cand-005` (committed), `intent-007` (recorded); `candidate: cand-005`. Root read: cand-005 = "close the knowledge/schema precondition chain"; brief-024 is its Phase-5 corpus slice. Upstream is the *tool-correctness* effort, reinforcing "migrate the corpus onto the existing spec," not redesign it.

### pdr-034 / cand-004 / intent-006 — the legacy-corpus-migration decision spine — **status: proposed / shaped / recorded**

- **Entry point:** title-scan `migrat`+`legacy`, all 8 kinds (T2/T3).
- **Title/body:** scope is **body-level**, from `--view transformation` renders.
- **Rendered in full:** `shop-knowledge render pdr-034 --corpus . --view transformation` (and cand-004, intent-006 likewise). Clauses:
  - **pdr-034 The question:** "PDR-032 gave six artifact types … its own appetite line explicitly excluded the legacy `brief/`/`pdr/`/`adr/` corpus … Should that exclusion be lifted?" **Decision:** "**Option C.** … `brief/`, `pdr/`, and `adr/` all migrate onto the typed-schema mechanism …" — scope is `brief/pdr/adr` only.
  - **intent-006 Non-goals:** "Re-opening the six-type schema itself … already ratified."
  - **cand-004 Evidence:** the target corpus is "all 129 files in `adr/`, `pdr/`, `briefs/`, `candidates/`, `sessions/`, `intent/`, `current-state.md`" — **the numbered spec files `01-…`–`06-…` are not among the enumerated targets.**
- **Axis it decides:** which legacy files migrate into the typed corpus — the membership axis. **§1–6 is not named.**
- **Axis match: YES.**
- **Status / liveness (Rule 4):** pdr-034 = **proposed** (and body-flagged "held" until cand-005 lands); cand-004 = **shaped** (parked); intent-006 = **recorded**; brief-024 = **ready** (the execution artifact). The effort is **live** (a `ready` brief exists) but scoped to `pdr/adr/brief/intent` — §1–6 excluded in every one.
- **Evidence directness:** direct proof the *decided* migration scope excludes §1–6.
- **Provenance (Rule 5):** `navigate` chain: intent-006 → cand-004 → pdr-034 (→ brief-023); brief-024 → cand-005/intent-007. Full spine read; consistent scope throughout.

### pdr-035 & adr-069 — the eight-kind taxonomy — **status: accepted**

- **Entry point:** title-scan `eight artifact kinds` (adr-069) / `the eight kinds` (pdr-035) over the type enumeration (T4); adr-069 also confirmed as a `current-state-001 incorporates` neighbour.
- **Title/body:** the "eight kinds" count is **title-level** (both titles carry it) and reinforced body-level.
- **Rendered:** `shop-knowledge render pdr-035 --corpus .` — "**The eight kinds and how they compose.** The system recognizes eight artifact kinds." `shop-knowledge render adr-069 --corpus .` — "For each of the eight kinds, the schema states **only** what that kind adds …". Neither names a framework-spec/principles/self-description-of-framework kind.
- **Axis it decides:** what artifact kinds the corpus recognizes.
- **Axis the question asks:** whether §1–6 can be a first-class artifact — which requires a fitting kind.
- **Axis match: YES** (kind-fit is a precondition of membership).
- **Evidence directness:** most direct proof that no recognized kind matches §1–6's category.
- **Provenance:** adr-069 supersedes-context = additive on adr-067 (accepted base schema); pdr-035 is slice #1 the restructuring supersedes into. Both accepted, live.

### current-state-001 — "shopsystem-product — current state" — **status: current** (COUNTER-EXAMPLE, confronted)

- **Entry point:** facet query `type=current-state` (T7) — the sole instance.
- **Rendered:** `shop-knowledge render current-state-001 --corpus . --view transformation`. "The product's own decisions, intent, and shape are **kept as a typed artifact corpus** …"; Artifacts list = "intents, candidates, sessions, prioritizations, briefs, product decisions (`pdrs/`), architecture decisions (`adrs/`), and this versioned current-state. **Findings are retired.**" The framework spec §1–6 is **not** among the listed corpus artifact families.
- **Why it matters:** it IS a self-description artifact living *inside* the typed corpus — the direct counter-example to a naive "no self-description doc is in the corpus" pillar. Confronted in Section 5.
- **Axis match with question: NO** (it self-describes the *product's* current state, a recognized `current-state` kind; not the framework's §1–6 design-rationale). Surfaced and analyzed, not leaned on to decide the question.

### pdr-900 / cand-900 / intent-900 / sess-2026-05-11-a — framework-construction genesis, synthetic — **status: accepted / committed / recorded / closed** (COUNTER-EXAMPLE, confronted)

- **Entry point:** title-scan `legacy` (T3) + provenance edges (T6) — `navigate sess-2026-05-11-a` returns `produced: intent-900, cand-900, pdr-900`; `navigate pdr-900` returns `derived-by: adr-001, adr-005, adr-009`.
- **Rendered:** `shop-knowledge render pdr-900 --corpus . --view transformation` (and the others) → **empty section skeletons** (frontmatter + edges, no body prose). They are synthetic *provenance anchors*, not narrative documents.
- **Why it matters:** the framework's *construction decisions* already have a home in the typed corpus (as pdr/cand/intent/session stubs grounding the genesis ADRs) — a counter-example to "no framework-construction artifact is in the corpus." Confronted in Section 5: they are decision-provenance stubs, NOT the §1–6 spec prose.
- **Axis match with question: NO** (they anchor legacy ADR provenance; they are not §1–6 and do not propose migrating §1–6).

---

## Section 4 — Verified facts as runnable assertions

Every command below is byte-identical to its Section 2/3 use. The block exits 0 iff all anchors hold.

This exact block was executed under `bash` and printed `ALL ANCHORS HOLD` (the two `schema zzz` lines emit the recognizer's eight-kind message by design; `|| true` keeps the block going under `set -e`). Status/uniqueness checks use single-quoted `python3 -c '…'` assigned to a variable, then a plain `[ "$var" = … ]` test — this avoids nesting double-quoted python inside `[ ]`.

```bash
set -e
cd /workspace

# --- Section 0: per-kind counts (universe = 164) ---
[ "$(shop-knowledge query --corpus . --facet type --value intent-record | python3 -c 'import sys,json;print(len(json.load(sys.stdin)))')" = 13 ] || { echo FAIL intent-count; exit 1; }
[ "$(shop-knowledge query --corpus . --facet type --value candidate | python3 -c 'import sys,json;print(len(json.load(sys.stdin)))')" = 10 ] || { echo FAIL cand-count; exit 1; }
[ "$(shop-knowledge query --corpus . --facet type --value session-record | python3 -c 'import sys,json;print(len(json.load(sys.stdin)))')" = 10 ] || { echo FAIL sess-count; exit 1; }
[ "$(shop-knowledge query --corpus . --facet type --value prioritization-record | python3 -c 'import sys,json;print(len(json.load(sys.stdin)))')" = 0 ] || { echo FAIL prio-count; exit 1; }
[ "$(shop-knowledge query --corpus . --facet type --value brief | python3 -c 'import sys,json;print(len(json.load(sys.stdin)))')" = 24 ] || { echo FAIL brief-count; exit 1; }
[ "$(shop-knowledge query --corpus . --facet type --value pdr | python3 -c 'import sys,json;print(len(json.load(sys.stdin)))')" = 38 ] || { echo FAIL pdr-count; exit 1; }
[ "$(shop-knowledge query --corpus . --facet type --value adr | python3 -c 'import sys,json;print(len(json.load(sys.stdin)))')" = 68 ] || { echo FAIL adr-count; exit 1; }
[ "$(shop-knowledge query --corpus . --facet type --value current-state | python3 -c 'import sys,json;print(len(json.load(sys.stdin)))')" = 1 ] || { echo FAIL cs-count; exit 1; }

# --- Kinds recognizer lists exactly eight, exits 0 ---
shop-knowledge schema zzz 2>&1 || true
shop-knowledge schema zzz 2>&1 | grep -qF "the eight recognized artifact types are: intent-record, candidate, session-record, prioritization-record, brief, pdr, adr, current-state" || { echo FAIL kinds; exit 1; }

# --- T1 title-scan survivor set is EXACTLY {adr-037} (over-claim fails) ---
ids=$(shop-knowledge query --corpus . --facet type --value adr | python3 -c 'import sys,json;print(",".join(x["id"] for x in json.load(sys.stdin) if "framework spec" in x["title"].lower()))')
[ "$ids" = "adr-037" ] || { echo FAIL T1-survivor; exit 1; }

# --- P2: adr-037 D1 decision clause + status accepted ---
shop-knowledge render adr-037 --corpus . | grep -qF "system-construction artifact; it stays in the framework/lead repo and is NOT shipped to product instances" || { echo FAIL adr037-D1; exit 1; }
shop-knowledge render adr-037 --corpus . | grep -qF "exactly as today" || { echo FAIL adr037-today; exit 1; }
shop-knowledge render adr-037 --corpus . | grep -qF "system-self-description" || { echo FAIL adr037-D4; exit 1; }
st=$(shop-knowledge query --corpus . --facet type --value adr | python3 -c 'import sys,json;print(next(x["status"] for x in json.load(sys.stdin) if x["id"]=="adr-037"))')
[ "$st" = accepted ] || { echo FAIL adr037-status; exit 1; }

# --- P1: brief-024 scope excludes schema redesign; migrates 119 legacy pdr/adr/brief; status ready ---
shop-knowledge render brief-024 --corpus . --view transformation | grep -qF "Redesigning the schema, typedefs, status vocabulary, or lifecycle" || { echo FAIL brief024-oos; exit 1; }
shop-knowledge render brief-024 --corpus . --view transformation | grep -qF "119 legacy files" || { echo FAIL brief024-scope; exit 1; }
shop-knowledge render brief-024 --corpus . --view transformation | grep -qF "the reason there are 8 types" || { echo FAIL brief024-8types; exit 1; }
st=$(shop-knowledge query --corpus . --facet type --value brief | python3 -c 'import sys,json;print(next(x["status"] for x in json.load(sys.stdin) if x["id"]=="brief-024"))')
[ "$st" = ready ] || { echo FAIL brief024-status; exit 1; }

# --- P1: pdr-034 decision clause; status proposed ---
shop-knowledge render pdr-034 --corpus . --view transformation | grep -qF "Full-corpus appetite is ratified" || { echo FAIL pdr034-body; exit 1; }
st=$(shop-knowledge query --corpus . --facet type --value pdr | python3 -c 'import sys,json;print(next(x["status"] for x in json.load(sys.stdin) if x["id"]=="pdr-034"))')
[ "$st" = proposed ] || { echo FAIL pdr034-status; exit 1; }

# --- P3: eight-kind taxonomy; none is a framework-spec kind ---
shop-knowledge render pdr-035 --corpus . | grep -qF "recognizes eight artifact" || { echo FAIL pdr035-eight; exit 1; }
shop-knowledge render adr-069 --corpus . | grep -qF "For each of the eight kinds" || { echo FAIL adr069-eight; exit 1; }

# --- Counter-examples surfaced (Rule 2d) ---
shop-knowledge render current-state-001 --corpus . --view transformation | grep -qF "kept as a typed artifact corpus governed by" || { echo FAIL cs-selfdesc; exit 1; }
st=$(shop-knowledge query --corpus . --facet type --value current-state | python3 -c 'import sys,json;print(json.load(sys.stdin)[0]["status"])')
[ "$st" = current ] || { echo FAIL cs-status; exit 1; }
shop-knowledge navigate sess-2026-05-11-a --corpus . --direction both | grep -qF '"target": "pdr-900"' || { echo FAIL genesis-edge; exit 1; }

# --- adr-037 provenance: no supersede edge, live node ---
shop-knowledge navigate adr-037 --corpus . --direction both | grep -qF '"target": "adr-018"' || { echo FAIL adr037-nav; exit 1; }

echo "ALL ANCHORS HOLD"
```

---

## Section 5 — Decision

**Recommendation: the framework spec §1–6 STAYS as plain markdown OUTSIDE the typed artifact corpus.**

### Pillar 1 — No live migration effort scopes §1–6 into the corpus. (most direct: brief-024)

- **Rule 2b topic-sweep** ("legacy prose → typed corpus migration"): the full cross-kind title-scan `migrat`/`legacy` returns intent-006 (recorded), cand-004 (shaped), pdr-034 (proposed), brief-024 (ready) as the legacy-corpus-migration cluster, plus unrelated pdr-007/adr-042 (excluded, execution shown in T2). **Accepted-on-topic docs found:** none of the four migration docs is `accepted` — but brief-024 is `ready` (the live execution artifact) and pdr-034 is the `proposed` decision. **All surfaced: YES.**
- **Rule 2c most-direct proof:** brief-024's scope block — in-scope = "119 legacy files in `pdr/` (33), `adr/` (63), `briefs/` (23)" + `intent/`; out-of-scope = "Redesigning the schema, typedefs, status vocabulary, or lifecycle semantics." The numbered spec files `01-…`–`06-work-tracking.md` are **named nowhere**. cand-004 enumerates its target set as `adr/ pdr/ briefs/ candidates/ sessions/ intent/ current-state.md` — again no spec files.
- **Rule 4 (liveness):** the effort **is live** — status fields quoted: brief-024 `ready`, pdr-034 `proposed`. It does not migrate §1–6; that is a *stated scope*, not my inference.

### Pillar 2 — The one accepted decision about §1–6 keeps it in the framework/lead repo "exactly as today." (most direct: adr-037 D1)

- adr-037 D1 (accepted, unsuperseded): §1–6 "remains canonical and lives here, in the framework/lead repo, **exactly as today**"; Option D (delete it) rejected; D4 classes it as **system-self-description**, a category it explicitly separates from product artifacts.
- **Rule 3 axis:** adr-037 decides the *ship-outward + location* axis and affirms the *status-quo markdown form*; it is **PARTIAL/borderline** on the precise typed-vs-markdown membership axis (the typed corpus postdates it). Therefore this is a **supporting** pillar, not the headline. It does not, by itself, forbid typing §1–6 — but its taxonomy (D4) frames §1–6 as a distinct construction/self-description artifact rather than one of the product-decision artifacts the corpus collects.

### Pillar 3 — No recognized artifact kind fits §1–6. (most direct: adr-069 / brief-024)

- The corpus recognizes **exactly eight kinds** (recognizer output; pdr-035 "recognizes eight artifact kinds"; adr-069 per-type schema for "the eight kinds"; brief-024 body "there are 8 types and no `finding` type"). None is a framework-spec / principles / framework-self-description kind. Migrating §1–6 in as a *first-class* artifact would require forcing it into an ill-fitting kind or **minting a ninth** — for which no schema exists.
- **Rule 4 (closure caveat):** *"the kind set is closed / no ninth is authorized"* is **my inference, not stated by any doc** — no rendered doc declares the set permanently closed, and ADR-067/adr-069 describe an *additive, extensible* typedef mechanism. So the honest form of this pillar is the **verifiable** part: *none of the eight existing kinds matches §1–6's category* (title/schema-level fact). Whether a ninth *should* be created is open — that residue is product-authority judgment and lowers confidence to Medium-high.

### Pillar 4 — The framework's genesis rationale is ALREADY represented in the corpus without importing the spec prose. (most direct: sess-2026-05-11-a + brief-024 synthetic-grounding rule)

- The synthetic 900-series (`sess-2026-05-11-a produced pdr-900, cand-900, intent-900`; `pdr-900 derived-by adr-001/005/009`) grounds the framework-construction ADRs as typed provenance anchors. brief-024 codifies this: genesis-root legacy ADRs get "synthetic upstream artifacts … `adr-001 → pdr-900 → cand-900 → intent-900`." The framework's *decisions* thus already live in the corpus as adr/pdr/cand/intent nodes — while the §1–6 *narrative* stays markdown. Migrating §1–6 itself adds nothing the decision graph doesn't already carry, and duplicates a narrative adr-037 already homes in the repo.

### Confronting the counter-examples (Rule 2d)

**Negative-existential pillar A:** "no recognized kind is a self-description artifact living in the typed corpus."
- **Category denied:** a self-description artifact inside the typed corpus. **Accepted instance found:** current-state-001 (status `current`) — it IS self-description in the corpus, and it says the product's "decisions, intent, and shape are kept as a typed artifact corpus." **Confronted:** I therefore do **not** assert pillar A in that broad form — it is **false**. current-state-001 is a *product-state* snapshot of a recognized `current-state` kind; it describes the product's *current decisions/BCs*, not the framework's *§1–6 design-rationale narrative*. adr-037 D4's taxonomy separates "product current-state (incorporates the decisions it reflects)" from "system-self-description (why the system is shaped this way → belongs in §1–6, NOT the product)." So the counter-example is a *different category* and does not support migrating §1–6; the corpus already having a product-state kind is not the corpus having a framework-spec kind. **Conceded and narrowed: YES.**

**Negative-existential pillar B:** "no framework-construction artifact lives in the corpus."
- **Category denied:** a framework-construction/genesis artifact inside the corpus. **Accepted/committed instances found:** pdr-900, cand-900, intent-900, sess-2026-05-11-a. **Confronted:** pillar B in that broad form is also **false** — framework-construction artifacts DO live in the corpus. But rendering them shows they are **empty-body synthetic provenance stubs** (pdr-900 renders as bare section headers), authored (per brief-024) purely to give legacy genesis ADRs a resolvable `derives-from` target. They are NOT the §1–6 spec prose and none proposes migrating §1–6. Their existence *strengthens* Pillar 4: the genesis decisions are already anchored without importing the narrative. **Conceded and re-homed as supporting evidence: YES.**

### Net

Four pillars converge: the live migration excludes §1–6 (P1, direct, YES-axis); the accepted decision keeps §1–6 as-is in the repo (P2, PARTIAL-axis, supporting); no existing kind fits it (P3, with the closure caveat flagged as inference); and its genesis rationale is already in the graph without the prose (P4). Nothing accepted contradicts. **Stay outside as markdown.**

---

## Section 6 — Where this could be wrong (RANKED)

**1 — Completeness hole (concepts/kinds/docs I may have failed to derive or scan).**
- **Kinds filtered by each semantic rule:** T2 (migration) and T3 (framework-construction) title-scans ran over **ALL 8 kinds** (raw output in Section 0). T1 (framework-spec disposition) scanned the **adr kind only** — justified because §1–6's disposition is a decision-record question and the recognizer confines decision records to adr/pdr; **residual risk:** a pdr or brief could in principle rule on §1–6 and my adr-only T1 scan would miss it. Mitigant: the all-kind `migrat`/`legacy` scans (T2/T3) would have surfaced any pdr/brief proposing to migrate §1–6, and none appeared.
- **Per-pillar Rule 2b sweep:** P1 swept (migration cluster, all surfaced); P2/P3 swept (taxonomy: adr-067/068/069/070/071, pdr-035/037 all surfaced); P4 swept (900-series via title + edges).
- **Per-pillar Rule 2d counter-example:** pillar A → current-state-001 (surfaced, conceded/narrowed); pillar B → 900-series (surfaced, conceded/re-homed).
- **Per-pillar Rule 2c most-direct-proof id:** P1→brief-024; P2→adr-037 D1; P3→adr-069/brief-024; P4→sess-2026-05-11-a.

**2 — Body-level uniqueness NOT verified (query exposes no full-text facet).** Every uniqueness claim here is **title-level** (T1 "only adr title naming the framework spec" proven over 68 ids; the eight-kind count proven over the recognizer). I did **not** render all 164 bodies. **Body-level uniqueness NOT verified — query exposes no full-text facet; claims cover titles only.** In particular, I cannot rule out that some doc's *body* discusses migrating §1–6 without its title signaling it. Mitigant: the on-point decision spine (adr-037, pdr-034, brief-024) was rendered in full and none does; but a body-buried proposal elsewhere is an unscanned residue that could, in principle, change the picture.

**3 — Axis mismatch on the strongest *accepted* doc.** adr-037's axis is ship-outward/location, only PARTIAL on typed-membership (Rule 3). The recommendation deliberately leans on brief-024 (YES-axis) as primary and treats adr-037 as supporting. If a reader insists only an *accepted* doc counts, note the primary membership evidence (brief-024/pdr-034) is `ready`/`proposed`, not `accepted` — so the *decided-and-accepted* answer to the exact membership axis does not yet exist. This is the core reason confidence is Medium-high, not High.

**4 — Closure asserted-as-inference.** "No ninth kind is authorized / the set is closed" is **my inference, not stated by any doc**; ADR-067/adr-069 describe an *additive* typedef mechanism, so the kind set may be **open**. The recommendation therefore rests only on the verifiable "none of the eight existing kinds fits §1–6," not on closure. If the product authority chose to mint a framework-spec kind (or fold §1–6 into a `current-state`-like framework snapshot), Pillar 3 weakens and the answer could flip. **This can change the recommendation** and is the main live judgment call.

**5 — Liveness of the migration.** Verified via status fields (brief-024 `ready`, pdr-034 `proposed`, held pending cand-005). The effort is live but scoped away from §1–6; if a future revision of brief-024/pdr-034 widened scope to include §1–6, Pillar 1 would need re-checking. No such widening exists today.

**6 — Prose-citation / provenance-root residues.** No doc in Section 3 was reached *only* by a prose citation; every one has a facet/title-scan or graph-edge entry point (current-state-001 cites pdr-035 in prose, but pdr-035 also has an independent title-scan entry, so it is not a prose-only inclusion). Provenance roots read to their ends: adr-037→adr-018 (root, read); brief-024→cand-005/intent-007 (read); pdr-034→cand-004→intent-006 (read); sess-2026-05-11-a→900-series (read). No mid-chain grounding on an unread root.

**False-negative check:** the docs that most *literally* bear on the question — adr-037 (the only §1–6 ruling) and brief-024 (the live scope) — are both cited as primary/supporting evidence in Section 5, not demoted. The two accepted counter-example categories (current-state-001; 900-series) are confronted head-on, not tagged "silent."

---

### Report

- **File:** `/workspace/drafts/grounding-record-exp-iter5.md`
- **Recommendation (2 lines):** The framework spec §1–6 should **stay as plain markdown outside the typed corpus**: no live migration effort scopes it in (brief-024/pdr-034 target `pdr/adr/brief/intent` only), no recognized artifact kind fits it, and adr-037 (accepted) keeps it in the framework/lead repo "exactly as today." Confidence Medium-high — the exact membership axis has no *accepted* ruling, and minting a ninth kind is not foreclosed.
- **Term count:** 7; **re-runnable : title-scan split** = 7 re-runnable, of which 4 are reproducible title-scans (T1–T4), 3 are facet/edge/render (T5–T7); 0 rest on an unrun body claim.
- **Kinds scanned vs total:** 8 of 8 scanned.
- **Per-kind counts:** intent-record 13, candidate 10, session-record 10, prioritization-record 0, brief 24, pdr 38, adr 68, current-state 1 (total 164).
- **Topic-sweep tally:** pillars swept 4; accepted/committed/current on-topic docs found 11 (adr-037, pdr-035, adr-067, adr-068, adr-069, adr-070, adr-071, pdr-037, pdr-900, cand-900, current-state-001); all surfaced: **YES**.
- **Counter-example tally:** negative-existential pillars 2; accepted category-instances found (current-state-001; pdr-900/cand-900/intent-900/sess-2026-05-11-a); each confronted: **YES**.
- **Most-direct-empirical-proof per pillar:** P1 brief-024; P2 adr-037; P3 adr-069/brief-024; P4 sess-2026-05-11-a.
- **Every included doc's stated selection rule returns it on re-run: YES.**
- **All pasted commands reproduce verbatim: YES.**
