# Grounding Record — Framework spec §1–6: migrate INTO the typed corpus, or stay plain markdown OUTSIDE?

Researcher grounding record. Every included artifact carries a fully-shown,
reproducible chain (question → term → exact command → full candidate set →
explicit selection rule). All grounding was obtained via
`shop-knowledge query|navigate|render` from `/workspace`. No grep/glob was used
to *discover* what is relevant; grep appears only in Section 4 as re-runnable
verification anchors over already-selected artifacts.

Definitions used throughout (defined on first use):
- **Framework spec §1–6** — the six numbered plain-markdown files at the repo
  root: `01-principles.md`, `02-bounded-contexts-and-subdomains.md`,
  `03-lead-shop.md`, `04-bc-shop.md`, `05-inter-shop-protocol.md`,
  `06-work-tracking.md`. They are the shop-system framework's own written spec.
- **Typed artifact corpus** — the set of documents carrying YAML frontmatter and
  a typed schema, reachable by `shop-knowledge` (`query`/`navigate`/`render`).
- **Kind / type** — one of the artifact families the corpus recognizes.
- **ADR** — Architecture Decision Record. **PDR** — Product Decision Record.
- **Corpus-membership axis** — whether a document is a first-class typed corpus
  artifact vs. plain markdown. **Shipping-outward axis** — whether a document is
  packaged and propagated to *product instances* built with the framework. These
  are two different axes and the distinction is load-bearing below.

---

## Section 0 — Type inventory (the complete universe every later rule runs against)

Command that lists the recognized kinds (the CLI names them in its error text):

```
$ shop-knowledge template zzz
error: 'zzz' is not a recognized artifact type
the eight recognized artifact types are: intent-record, candidate, session-record, prioritization-record, brief, pdr, adr, current-state
```

Per-kind enumeration command (run once per kind) and document counts:

```
$ for t in intent-record candidate session-record prioritization-record brief pdr adr current-state; do
    shop-knowledge query --corpus . --facet type --value "$t"; done
```

| # | Kind | Count | IDs (full set) |
|---|------|-------|----------------|
| 1 | intent-record | **13** | intent-001…intent-012, intent-900 |
| 2 | candidate | **10** | cand-001…cand-009, cand-900 |
| 3 | session-record | **10** | sess-2026-05-11-a, -07-09-a, -07-14-a, -07-14-b, -07-15-a, -07-16-a, -07-19-a, -07-20-a, -07-25-a, -07-27-a |
| 4 | prioritization-record | **0** | (none) |
| 5 | brief | **24** | brief-001…brief-024 (no brief-…gaps beyond numbering) |
| 6 | pdr | **38** | pdr-001…pdr-037 (no pdr-008), pdr-900 |
| 7 | adr | **68** | adr-001…adr-071 (gaps: 003, 007, 044; plus adr-900-series none) |
| 8 | current-state | **1** | current-state-001 |

**Total: 164 documents across 8 kinds.** There is a synthetic **900-series**
(intent-900, cand-900, pdr-900) — the "Legacy: …" synthetic-grounding roots —
inside the intent/candidate/pdr kinds; there is no separate 900 *kind*. Every
semantic selection rule in Section 2 was run against this full 164-doc,
8-kind universe (prioritization-record is empty, so it contributes no
candidate but was checked).

**Critical structural fact from this inventory:** none of the eight recognized
kinds is a "spec", "principles", or "framework" kind. There is no kind whose
membership the framework spec §1–6 would occupy as a first-class artifact.

---

## Section 1 — Summary box

> **Question (verbatim):** Should the shopsystem framework spec (the framework
> principles/spec, sections 1 through 6, currently plain markdown in the
> lead/framework repo) be migrated INTO the typed artifact corpus as first-class
> artifacts, or stay as plain markdown OUTSIDE the corpus?
>
> **Recommendation (1 line):** Keep §1–6 as plain markdown OUTSIDE the typed
> corpus — the live migration effort scopes it out, no recognized kind fits it,
> and it is categorically system-self-description, not a typed decision artifact.
>
> **Confidence:** Medium-high on the recommendation; medium on its *finality*.
> High because the live migration's own scope excludes §1–6 and no kind exists
> to hold it; capped because **no doc explicitly forbids** a future §1–6 kind,
> and the typedef mechanism is additive (Section 6, risk 2).
>
> **Term coverage:** 7 terms derived; 7 re-runnable via exact commands; 0 pure
> title-scan (every selection ran a stated rule over the complete Section-0
> inventory).
>
> **Most load-bearing artifact:** `brief-024` (status **ready** = live) — the
> migration's executable scope. **Axis match: YES** (it enumerates exactly which
> files enter the corpus; §1–6 is absent).
>
> **Runner-up cited artifact:** `adr-037` (accepted). **Axis match: NO** — it
> decides the shipping-outward axis, not the corpus-membership axis; used only as
> supporting *framing*, never as decision argument #1.
>
> **Attack Section 2 first.**

---

## Section 2 — Question → terms (the audit surface)

Every row's "full cross-kind candidate set" is the complete Section-0 inventory
(164 docs, all 8 kinds); the stated rule was applied against all of it. Kinds
actually scanned = **all 8** for every semantic row.

| # | Term (why the question forces it) | Exact command | Full candidate set surfaced | Explicit selection rule | Kinds scanned | Re-runnable |
|---|---|---|---|---|---|---|
| 1 | **Framework spec §1–6 itself** — the literal subject; must confirm its current corpus status | `shop-knowledge render 01-principles --corpus .` (and `principles`, `framework-spec`, `spec-001`) | All four id probes return `no document with id … present in the corpus`; `ls /workspace/0[1-6]-*.md` lists all six files | Rule: does any corpus id resolve to §1–6? → **No id resolves; the six files exist only as root-level plain markdown.** §1–6 is currently OUTSIDE the corpus. | all 8 | yes |
| 2 | **Legacy-corpus migration** — the question is literally "migrate INTO"; must find the migration effort and read its scope | `shop-knowledge query --corpus . --facet type --value <kind>` scanned for "migrat"/"legacy corpus" titles across all kinds | intent-006 (Legacy corpus brief/PDR/ADR migrates), cand-004 (Migrate legacy brief/PDR/ADR), pdr-034 (Legacy brief/PDR/ADR migrates), brief-024 (Migrate ~119-file legacy corpus). No other kind has a migration artifact. | Rule: any artifact whose subject is "migrate legacy prose INTO the typed corpus", across ALL kinds. → 4 matches, one chain (intent-006→cand-004→pdr-034; brief-024 is the executable slice). All four scope the corpus as **brief/PDR/ADR (+intent)** — never §1–6. | all 8 | yes |
| 3 | **System-construction / self-description artifact** — the spec might be a *category* the corpus treats specially | `shop-knowledge query --corpus . --facet type --value adr` scanned for "framework spec"/"self-description"/"construction" | adr-037 ("The framework spec (§1–6) is a system-CONSTRUCTION artifact …") is the sole title-level match; adr-034/adr-035 are cross-referenced by it | Rule: any decision that classifies what §1–6 *is*. → adr-037 uniquely names §1–6 by section range. | all 8 | yes |
| 4 | **The eight kinds / does a kind fit §1–6?** — "first-class artifacts" requires a home kind | `shop-knowledge template zzz` (kinds list) + `shop-knowledge query … type=<each>` | The 8 kinds: intent-record, candidate, session-record, prioritization-record, brief, pdr, adr, current-state | Rule: is any kind a spec/principles/framework kind that §1–6 would join? → **None.** No kind fits §1–6 as first-class content. | all 8 | yes |
| 5 | **Synthetic grounding / 900-series** — the framework's construction may already have a corpus representation | `shop-knowledge navigate pdr-900 --corpus . --direction both` + `render` of intent-900/cand-900/pdr-900 | intent-900, cand-900, pdr-900 — "Legacy: construct the shopsystem framework (pre-intent-record era)" chain; render shows **empty section-header-only bodies** | Rule: does any corpus artifact already carry §1–6 *content*? → The 900-series are empty provenance anchors, not spec content; they carry the *construction genesis* as a derives-from target, not §1–6 prose. | all 8 | yes |
| 6 | **Foundational artifact-system statement** — adjacency risk: could be confused with "framework spec" | `shop-knowledge query … type=intent-record/pdr/adr`; render adr-067 decision | intent-008, cand-006, pdr-035, adr-067 ("artifact-system base schema … the eight artifact kinds") | Rule: is this about §1–6, or about the *artifact system itself*? → adr-067 D1 is the artifact-system base schema, NOT §1–6. **Ruled out** — different subject. | all 8 | yes |
| 7 | **Current-state incorporation** — does the live system snapshot treat §1–6 as a tracked artifact? | `shop-knowledge navigate current-state-001 --corpus . --direction both`; `render … --view transformation | grep framework-spec/01-/principles` | current-state-001 `incorporates` a list of accepted ADRs/PDRs; grep for §1–6 / framework-spec returns **empty** | Rule: does the current-state snapshot reference §1–6 as corpus material? → No; §1–6 is not incorporated or referenced. | all 8 | yes |

---

## Section 3 — Terms → grounded set

Each artifact below carries its Section-2 chain, its Rule-3 axis verdict (with
the exact decision clause quoted), and its Rule-5 provenance edges (navigate
output pasted).

### 3.1 `brief-024` — the live migration's executable scope (PRIMARY)

- **Chain:** Term 2 → `shop-knowledge query … type=brief` surfaced brief-024
  "Migrate the ~119-file legacy artifact corpus forward"; rendered via
  `shop-knowledge render brief-024 --corpus . --view transformation`.
- **Status field (Rule 4 liveness):** **`ready`** (query output:
  `{"id":"brief-024", … "status":"ready"}`; changelog line: "Status `draft ->
  ready`"). A `ready` brief is live, and per the liveness rule overrides the
  `held/proposed` PDR-034.
- **What it decides (quoted scope):**
  - "This repo carries ~119 legacy artifact files — **33 in `pdr/`, 63 in
    `adr/`, 23 in `briefs/`**".
  - In scope: "The **119 legacy files** in `pdr/` (33), `adr/` (63), `briefs/`
    (23) … The **`intent/` → `intents/`** directory + filename rename".
  - The synthetic-grounding pattern it proves: "the synthetic chain `adr-001 ->
    pdr-900 -> cand-900 -> intent-900` … validates **conforming**".
  - §1–6 (`01-principles.md … 06-work-tracking.md`) appears **nowhere** in its
    in-scope, out-of-scope, or file-count lists.
- **Axis (Rule 3):** The clause decides *which files are migrated into the typed
  corpus*. **The question asks exactly that.** **Axis match: YES.** §1–6 is not
  among them.
- **Provenance edges (navigate, pasted):**
  `derives-from → cand-005` (committed, "Close the knowledge/schema precondition
  chain"), `derives-from → intent-007` (recorded), `candidate → cand-005`. Its
  upstream root is the precondition-chain intent-007/cand-005, not the
  legacy-migration intent-006 — i.e. brief-024 is the *execution vehicle* that
  cand-005 sequenced the migration into (cand-005 Phase 5). Full chain read.

### 3.2 The migration decision chain `intent-006 → cand-004 → pdr-034`

- **Chain:** Term 2, all three surfaced by title scan of the full inventory for
  "legacy corpus … migrates".
- **Status fields (Rule 4 liveness):** intent-006 `recorded`; cand-004 `shaped`
  and **parked** ("Do not dispatch ahead of cand-005 phases 1-4"); pdr-034
  `proposed` and **held** ("This PDR is **held**: do not dispatch … until
  cand-005 phases 1-4 land"). The *decision* is ratified (Option C, full-corpus)
  but the *dispatch* was held; brief-024 (3.1) is the live realization.
- **Quoted scope, each:**
  - intent-006 title/body: "Legacy corpus **(brief/PDR/ADR)** migrates"; body
    scopes "~97 legacy `adr/`/`pdr/`/`briefs/` files". No §1–6.
  - cand-004: "Bring `brief/`, `pdr/`, and `adr/` onto the same typed-schema
    mechanism". No §1–6.
  - pdr-034 Decision: "`brief/`, `pdr/`, and `adr/` all migrate onto the typed-
    schema mechanism". No §1–6.
- **Axis (Rule 3):** All three decide the corpus-membership migration scope —
  **same axis as the question. Axis match: YES.** All three define "the legacy
  corpus" as the *decision* artifacts (brief/PDR/ADR), which are themselves
  existing typed *kinds*; §1–6 is never included.
- **Provenance edges (navigate, pasted):**
  - intent-006: `derived-by → cand-004`, `session → sess-2026-07-16-a`. (Root of
    the chain — fully read above.)
  - cand-004: `derives-from → intent-006`, `derived-by → pdr-034`,
    `session → sess-2026-07-16-a`.
  - pdr-034: `derives-from → cand-004`, `derived-by → brief-023`. (brief-023 is
    the coherence-gate CLI slice, not a §1–6 vehicle.)

### 3.3 `adr-037` — the categorical framing (SUPPORTING ONLY, axis NO)

- **Chain:** Term 3 → sole title match naming §1–6; rendered in full via
  `shop-knowledge render adr-037 --corpus .` (accepted → renders directly).
- **Status:** `accepted`.
- **Exact decision clause (D1, quoted):** "**The framework spec §1–6 is a
  system-construction artifact; it stays in the framework/lead repo and is NOT
  shipped to product instances.**" And: "The spec remains canonical and lives
  here, in the framework/lead repo, **exactly as today**".
- **D4 table row (quoted):** "**system-self-description** | it explains *why the
  system is shaped this way* | it belongs in the **framework spec** §1–6, NOT the
  product".
- **Axis the clause decides (one sentence):** whether §1–6 is *packaged and
  shipped outward to product instances* built with the framework (D1 rejects
  shipping; Option D rejects deletion — "it stays home").
- **Axis the question asks (one sentence):** whether §1–6 is a *first-class typed
  corpus artifact vs. plain markdown*, both of which live inside the same
  lead/framework repo.
- **Axis match: NO.** These are different axes (shipping-outward vs.
  corpus-membership). The corpus is inside the lead repo, so "stays in the repo,
  exactly as today" neither mandates nor forbids corpus migration. **Therefore
  adr-037 is used only as supporting framing (§1–6 is categorically
  self-description, a category the 8 typed kinds do not contain), never as the
  deciding argument.** "exactly as today" describes plain-markdown status quo but
  is stated about the shipping question, so it is not a corpus-membership ruling.
- **Provenance edges (navigate, pasted):** `derives-from → adr-018` (accepted,
  "Verify pre-state empirically … lead carries no BC code"); `derived-by →
  brief-011` (draft, "end-to-end new-product bootstrap path"). Upstream root
  adr-018 read (it is the evidence-surface rule, not a §1–6 ruling). No further
  upstream on this edge.

### 3.4 The 900-series synthetic roots (Rule 6 confrontation)

- **Chain:** Term 5 → navigate pdr-900 + render all three.
- **Status:** intent-900 `recorded`, cand-900 `committed`, pdr-900 `accepted`.
- **What the render shows:** all three bodies are **empty** — only section
  headers (`## Context / ## Options considered / ## Decision / ## Consequences`
  for pdr-900, etc.), zero prose.
- **Analysis (support/complicate/falsify):** These are the very "framework
  construction" category the recommendation calls categorically not typed-corpus
  content — so Rule 6 demands they be confronted. They **support** the
  recommendation: the framework's *construction genesis* is represented in the
  corpus only as **empty provenance anchors** whose sole job is to give
  genesis-root ADRs (adr-001, adr-005, adr-009, …) a resolvable `derives-from`
  target (navigate: `pdr-900 derived-by → adr-001, adr-005, adr-009`). They carry
  **no §1–6 content**. The corpus deliberately keeps framework-construction as
  thin synthetic scaffolding while the actual self-description prose (§1–6) stays
  outside as plain markdown. They do **not** falsify the recommendation and are
  **not** a counter-example of "§1–6 migrated in."
- **Provenance edges (navigate, pasted):** `intent-900 ↔ cand-900 ↔ pdr-900`
  (single spine); `pdr-900 derived-by → adr-001, adr-005, adr-009`; `cand-900
  derived-by → pdr-001, pdr-003, pdr-025, pdr-026, pdr-027, pdr-900`. Full chain
  read; all nodes are empty scaffolding.

### 3.5 Ruled-out adjacency: `adr-067` / foundational chain

- **Chain:** Term 6. Rendered `adr-067` (accepted).
- **Decision clause (quoted):** "The artifact-system **base schema** is the
  shared frontmatter contract every one of the **eight artifact kinds** carries".
- **Axis:** the *artifact system's own schema*, not §1–6. **Axis match to the
  question: NO / different subject → ruled out**, not leaned on. Recorded so the
  auditor sees it was scanned and rejected, not dodged.

---

## Section 4 — Verified facts as runnable assertions

Each fact is a command + a must-contain anchor. The block exits 0 iff every
anchor holds. Run from `/workspace`.

```bash
#!/usr/bin/env bash
set -euo pipefail
cd /workspace
fail() { echo "ANCHOR FAILED: $1" >&2; exit 1; }

# F1 — the corpus recognizes exactly eight kinds, none a spec/framework kind
shop-knowledge template zzz 2>&1 | grep -q \
  "intent-record, candidate, session-record, prioritization-record, brief, pdr, adr, current-state" \
  || fail "F1 eight-kinds list"

# F2 — framework spec §1–6 has NO corpus id (it is outside the corpus)
shop-knowledge render 01-principles --corpus . 2>&1 | grep -q "no document with id" \
  || fail "F2 01-principles not in corpus"

# F3 — the §1–6 files exist as plain markdown at repo root
test -f 01-principles.md && test -f 06-work-tracking.md || fail "F3 spec files present"

# F4 — brief-024 is status 'ready' (LIVE migration)
shop-knowledge query --corpus . --facet type --value brief 2>&1 \
  | jq -e '.[] | select(.id=="brief-024") | .status=="ready"' >/dev/null \
  || fail "F4 brief-024 ready"

# F5 — brief-024 scopes exactly the 119 pdr/adr/brief files (not §1–6)
shop-knowledge render brief-024 --corpus . --view transformation 2>&1 \
  | grep -q "119 legacy artifact files" || fail "F5 brief-024 119-file scope"

# F6 — the migration intent defines 'legacy corpus' as brief/PDR/ADR
shop-knowledge query --corpus . --facet type --value intent-record 2>&1 \
  | jq -e '.[] | select(.id=="intent-006") | (.title | test("brief/PDR/ADR"))' >/dev/null \
  || fail "F6 intent-006 brief/PDR/ADR scope"

# F7 — pdr-034 is only 'proposed' (held), not accepted
shop-knowledge query --corpus . --facet type --value pdr 2>&1 \
  | jq -e '.[] | select(.id=="pdr-034") | .status=="proposed"' >/dev/null \
  || fail "F7 pdr-034 proposed"

# F8 — adr-037 is accepted and its D1 decides the SHIPPING axis
shop-knowledge query --corpus . --facet type --value adr 2>&1 \
  | jq -e '.[] | select(.id=="adr-037") | .status=="accepted"' >/dev/null \
  || fail "F8a adr-037 accepted"
shop-knowledge render adr-037 --corpus . 2>&1 \
  | grep -q "it stays in the framework/lead repo and is NOT shipped to product instances" \
  || fail "F8b adr-037 D1 shipping-axis clause"

# F9 — the 900-series is a synthetic spine feeding genesis-root ADRs
shop-knowledge navigate pdr-900 --corpus . --direction both 2>&1 \
  | grep -q '"target": "cand-900"' || fail "F9a pdr-900->cand-900"
shop-knowledge navigate pdr-900 --corpus . --direction both 2>&1 \
  | grep -q '"target": "adr-001"' || fail "F9b pdr-900 grounds adr-001"

# F10 — adr-067 (foundational) is about the eight-kind base schema, NOT §1–6
shop-knowledge render adr-067 --corpus . 2>&1 \
  | grep -q "base schema" || fail "F10 adr-067 base-schema subject"

echo "ALL ANCHORS HOLD"
```

---

## Section 5 — Decision

**Recommendation: keep the framework spec §1–6 as plain markdown OUTSIDE the
typed artifact corpus.** Justified strictly from Sections 3–4:

1. **The live migration effort scopes §1–6 out (primary, axis YES).** brief-024
   is `ready` (F4) — the live realization of the ratified full-corpus migration.
   Its own scope is "the **119 legacy files** in `pdr/` (33), `adr/` (63),
   `briefs/` (23)" plus the `intent/`→`intents/` rename (F5); §1–6 is absent from
   every in/out-of-scope list. The upstream decision chain (intent-006 →
   cand-004 → pdr-034) defines "the legacy corpus" identically as **brief/PDR/ADR**
   (F6), never §1–6. This is on the exact axis the question asks
   (corpus-membership), so it is decision argument #1.

2. **No recognized kind can hold §1–6 as a first-class artifact (structural).**
   The corpus recognizes exactly eight kinds (F1); none is a spec/principles/
   framework kind. "First-class artifact" requires membership in a kind, and §1–6
   fits none of the eight. Empirically, §1–6 resolves to no corpus id and lives
   only as root markdown (F2, F3). *Caveat (Rule 4): "no kind fits" is a
   present-state fact, not a declared permanent bar — see Section 6, risk 2.*

3. **§1–6 is categorically system-self-description, not a typed decision
   artifact (supporting framing; adr-037 axis NO).** adr-037 (accepted, F8)
   classifies §1–6 as a "system-construction artifact" and D4 gives its home as
   "the framework spec §1–6, NOT the product." I do **not** present this as
   deciding the corpus-membership axis — adr-037's operative clause decides the
   *shipping-outward* axis (F8b), a different axis (Section 3.3). It supports the
   recommendation only by confirming §1–6 is a distinct category from the typed
   decision record the eight kinds capture.

4. **The framework's construction is already represented in the corpus as empty
   synthetic anchors, not as spec content (Rule 6 confrontation).** The
   900-series (intent-900/cand-900/pdr-900) are the synthetic-grounding roots for
   framework construction (F9), and they render with **empty bodies** — they hold
   no §1–6 prose. The corpus's chosen representation of framework construction is
   a thin provenance anchor, with the actual self-description prose kept outside.
   This complicating category, examined head-on, **supports** rather than
   falsifies the recommendation.

**On uniqueness/closure (Rule 4 honesty):** I do **not** claim "the eight kinds
are closed" or "§1–6 is forbidden from the corpus." No rendered doc declares
either. The recommendation rests on (a) the live scope excluding §1–6, (b) no
present kind fitting it, and (c) the categorical framing — not on a closure
clause. The migration's *liveness* is asserted from a status field: brief-024 is
`ready` (F4), overriding the `held/proposed` pdr-034 (F7).

---

## Section 6 — Where this could be wrong (RANKED)

**1 — Concepts/terms/kinds I may have failed to derive or scan (the completeness
hole).** I derived 7 terms and ran every semantic rule against the **full
Section-0 inventory (all 8 kinds, 164 docs)** — no rule was scoped to
"adr+pdr only." Specifically: Term 2 (migration scope) was filtered across all 8
kinds and matched intent-006/cand-004/pdr-034/brief-024 only; Term 3 (§1–6
classification) across all 8 and matched adr-037 only; Term 4 (kind fit) is the
kinds list itself. **Kinds filtered by a semantic rule: all 8.** The empty
`prioritization-record` (0 docs) contributes no candidate. Residual risk: if a
relevant artifact's *title* does not contain any of my scan tokens
("migrat/legacy/framework spec/self-description/construction/principles/spec"),
my title-level filter could miss it — I mitigated by also reading full bodies of
the migration chain and adr-037, whose cross-references named no additional §1–6
artifact. *Can change the recommendation only if such a hidden artifact
explicitly rules §1–6 into the corpus.*

**2 — The eight-kind set may be open; a §1–6 kind could be authored (inference,
not stated).** My argument #2 ("no kind fits") is a *present-state* fact. **No
doc declares the set closed.** The typedef/generator mechanism (adr-059/adr-067)
is additive by construction — a ninth `framework-spec` typedef is mechanically
possible. PDR-031 ("kind-extensible knowledge context") was *rejected*, which
weakly points away from open-ended extensibility, but it does not close the set.
**This is my inference, not stated by any doc.** *Can change the recommendation
if the product authority chooses to author a spec kind — the recommendation is
"don't, given current kinds/scope," not "it is impossible."*

**3 — adr-037 axis-match is NO (borderline-leaned).** adr-037 is the runner-up
citation and its axis (shipping-outward) is not the question's axis
(corpus-membership). I confined it to *supporting framing* and made brief-024
(axis YES) argument #1. Risk: a reader might over-read "stays … exactly as
today" as a corpus ruling. It is not — that clause is stated about shipping. *If
adr-037 were (wrongly) read as deciding corpus-membership, it would still point
the same way (keep §1–6 as-is), so this does not flip the recommendation.*

**4 — Liveness inference.** I call brief-024 "the live migration" from its
`ready` status field (F4) and treat pdr-034 as held (its own body says "held").
Empirically the migrate branch appears to have landed (the corpus is already in
plural typed form and §1–6 remain plain markdown), consistent with this. Risk: a
newer, unread artifact could re-open §1–6 scope. I found no such artifact; no
governing ADR for the object-graph model (brief-024 Phase 0 flagged authoring
one) currently exists under a scannable title. *Would change the recommendation
only if that artifact both exists and pulls §1–6 in.*

**5 — Provenance roots read.** brief-024's upstream (cand-005 → intent-007) and
the migration chain's root (intent-006) were both read in full; the 900-series
spine and adr-037→adr-018 were navigated to their roots. No mid-chain node was
leaned on without its root. *No open root remains that could change the
recommendation.*

**6 — False-positive / false-negative.** False-positive risk (recommending
"stay out" when a doc actually mandates migration in): low — no doc mandates it.
False-negative risk (missing a doc that mandates staying out): irrelevant to the
direction — it would only strengthen the recommendation. The genuine open
question is future *choice* (risk 2), not current *evidence*.

---

### Report

- **File:** `/workspace/drafts/grounding-record-exp-iter2.md`
- **Recommendation (2 lines):** Keep framework spec §1–6 as plain markdown
  OUTSIDE the typed corpus. The live `ready` migration (brief-024) scopes only
  the 119 brief/PDR/ADR decision files, no recognized kind fits §1–6, and §1–6 is
  categorically system-self-description — not a decision artifact.
- **Terms:** 7 total — 7 re-runnable, 0 pure title-scan.
- **Kinds scanned:** 8 of 8 (intent-record, candidate, session-record,
  prioritization-record [empty], brief, pdr, adr, current-state).
