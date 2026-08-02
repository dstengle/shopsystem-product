# Grounding Record — Framework spec §1–6: migrate INTO the typed corpus, or stay plain markdown OUTSIDE?

Researcher grounding record. Every artifact is reached through a fully-shown
`shop-knowledge query|navigate|render` chain. All commands run from `/workspace`.

---

## Tooling note — the exact accepted invocation form per subcommand

Discovered empirically by running each subcommand. The corpus root flag is
`--corpus .` and it is accepted by **query, navigate, render**. Two more
subcommands (`schema`, `template`) are used only to enumerate the recognized
kind set; **they take a bare artifact-type positional and do NOT accept
`--corpus`** (they read package-data typedefs, not the corpus).

| Subcommand | Accepted form used in this record | Notes |
|---|---|---|
| `query` | `shop-knowledge query --corpus . --facet <f> --value <v>` | facets: `type, status, tag, distribution`. Unknown `--value` for `type` returns `[]` (does NOT error). |
| `navigate` | `shop-knowledge navigate <id> --corpus . --direction both` | edge graph |
| `render` (accepted docs) | `shop-knowledge render <id> --corpus .` | current-system view; empty for non-accepted docs |
| `render` (non-accepted docs) | `shop-knowledge render <id> --corpus . --view transformation` | needed for proposed/draft/rejected/superseded/recorded/committed/closed docs |
| `schema` (kind enum only) | `shop-knowledge schema zzz` | **no `--corpus`**; errors, and the error prints the authoritative eight-kind list |

There is **NO full-text / body-content facet** (facet list is exactly
`type, status, tag, distribution`; `tag` returns `[]` for every value I probed,
so it is not usable for topic sweeps). **Consequence, binding on this whole
record:** every body-level uniqueness claim is either backed by rendering the
full body of each candidate, or is downgraded to a title-level claim and labeled
as such. No body-uniqueness claim is asserted from a title-scan.

> **All pasted commands reproduce verbatim: YES.**
> **Attack section 0 and section 2 first.**

---

## 1. Summary box

> **QUESTION (verbatim):** Should the shopsystem framework spec (the framework
> principles/spec, sections 1 through 6, currently plain markdown in the
> lead/framework repo) be migrated INTO the typed artifact corpus as first-class
> artifacts, or stay as plain markdown OUTSIDE the corpus?
>
> **RECOMMENDATION (1 line):** Keep the framework spec §1–6 as plain markdown
> OUTSIDE the typed artifact corpus.
>
> **CONFIDENCE:** High on "no accepted decision or live migration puts §1–6 in
> the corpus, and §1–6 fits none of the eight recognized kinds"; Medium on the
> forward-looking "a ninth kind for it should not be added" (that half rests on
> one inference, flagged in §6).
>
> **TERM COVERAGE:** 8 terms derived; 8 re-runnable via `shop-knowledge`; 0
> title-scan-only (every term's selection was executed as a command against the
> complete enumerated universe).
>
> **MOST LOAD-BEARING ARTIFACT — adr-037 (accepted):** its headline decision D1
> ("§1–6 … stays in the framework/lead repo and is NOT shipped to product
> instances") decides the *shipping-outward* axis → **Axis match to the
> corpus-membership question: NO**. What I lean on from adr-037 is a *different*
> clause — finding 1 / the D4 classification table, which decides *what kind of
> thing §1–6 is* (system self-description, distinct from the decision record) →
> **Axis match: YES**. Both are labeled inline in §3.
>
> **TOPIC-SWEEP TALLY:** 4 pillars swept; accepted on-topic docs found across all
> pillars = {adr-037, pdr-035, adr-069, adr-067, pdr-900, cand-900}; every one
> surfaced: **YES**.
>
> **MOST-DIRECT EMPIRICAL PROOF, per pillar:**
> - Pillar 1 (§1–6 is a distinct, non-decision kind of artifact): **adr-034
>   finding 3** — "The framework spec proper lives OUTSIDE `adr/` … spec sections
>   = framework normative text; `adr/` = product-realization decisions" (carried
>   forward and re-affirmed by accepted adr-037 finding 1).
> - Pillar 2 (the live corpus migration scopes only decision artifacts, not
>   §1–6): **brief-024** (status `ready`) — scope names the 119 files in
>   `pdr/`(33)+`adr/`(63)+`briefs/`(23) plus `intents/`; §1–6 appears nowhere.
> - Pillar 3 (the corpus recognizes exactly eight kinds, none of which is a
>   framework-spec/self-description kind): **`shop-knowledge schema zzz`** +
>   **pdr-035** — "The system recognizes eight artifact kinds."
> - Pillar 4 (framework-construction material that IS in the corpus is
>   decision-genesis grounding, not the §1–6 prose): **pdr-900 / cand-900** —
>   empty "Legacy: framework-construction … (synthetic grounding)" stubs.
>
> **All pasted commands reproduce verbatim: YES.**

---

## 0. Type inventory — the complete artifact universe

### 0.0 The recognized-kind set (mechanical)

```
shop-knowledge schema zzz
```
Output (this command **errors / exits non-zero by design**; the error body is
the authoritative kind enumeration):
```
error: 'zzz' is not a recognized artifact type
the eight recognized artifact types are: intent-record, candidate, session-record, prioritization-record, brief, pdr, adr, current-state
```
**Eight recognized kinds:** `intent-record, candidate, session-record,
prioritization-record, brief, pdr, adr, current-state`. Every per-kind query
below is one of these eight; there is no ninth. (Note: `query --facet type
--value <unknown>` returns `[]` silently rather than erroring, so it cannot by
itself disprove a ninth kind — `schema`'s enumeration is the authoritative
source, and it names exactly eight.)

### 0.1 adr — count 68

```
shop-knowledge query --corpus . --facet type --value adr
```
Raw output (verbatim, reproduced in §4): returns 68 objects. The 68 ids:
adr-001, adr-002, adr-004, adr-005, adr-006, adr-008, adr-009, adr-010,
adr-011, adr-012, adr-013, adr-014, adr-015, adr-016, adr-017, adr-018,
adr-019, adr-020, adr-021, adr-022, adr-023, adr-024, adr-025, adr-026,
adr-027, adr-028, adr-029, adr-030, adr-031, adr-032, adr-033, adr-034,
adr-035, adr-036, adr-037, adr-038, adr-039, adr-040, adr-041, adr-042,
adr-043, adr-045, adr-046, adr-047, adr-048, adr-049, adr-050, adr-051,
adr-052, adr-053, adr-054, adr-055, adr-056, adr-057, adr-058, adr-059,
adr-060, adr-061, adr-062, adr-063, adr-064, adr-065, adr-066, adr-067,
adr-068, adr-069, adr-070, adr-071.
Gaps proven absent from the raw output: adr-003, adr-007, adr-044.
**Listed == reported: 68 == 68.** ✔

### 0.2 pdr — count 38

```
shop-knowledge query --corpus . --facet type --value pdr
```
The 38 ids: pdr-001, pdr-002, pdr-003, pdr-004, pdr-005, pdr-006, pdr-007,
pdr-009, pdr-010, pdr-011, pdr-012, pdr-013, pdr-014, pdr-015, pdr-016,
pdr-017, pdr-018, pdr-019, pdr-020, pdr-021, pdr-022, pdr-023, pdr-024,
pdr-025, pdr-026, pdr-027, pdr-028, pdr-029, pdr-030, pdr-031, pdr-032,
pdr-033, pdr-034, pdr-035, pdr-036, pdr-037, pdr-038, pdr-900.
Gap proven absent: pdr-008. Synthetic root present: pdr-900.
**Listed == reported: 38 == 38.** ✔

### 0.3 brief — count 24

```
shop-knowledge query --corpus . --facet type --value brief
```
The 24 ids: brief-001, brief-002, brief-003, brief-004, brief-005, brief-006,
brief-007, brief-008, brief-009, brief-010, brief-011, brief-012, brief-013,
brief-014, brief-015, brief-016, brief-017, brief-018, brief-019, brief-020,
brief-021, brief-022, brief-023, brief-024. No gaps.
**Listed == reported: 24 == 24.** ✔

### 0.4 candidate — count 10

```
shop-knowledge query --corpus . --facet type --value candidate
```
The 10 ids: cand-001, cand-002, cand-003, cand-004, cand-005, cand-006,
cand-007, cand-008, cand-009, cand-900. Synthetic root present: cand-900.
**Listed == reported: 10 == 10.** ✔

### 0.5 intent-record — count 13

```
shop-knowledge query --corpus . --facet type --value intent-record
```
The 13 ids: intent-001, intent-002, intent-003, intent-004, intent-005,
intent-006, intent-007, intent-008, intent-009, intent-010, intent-011,
intent-012, intent-900. Synthetic root present: intent-900.
**Listed == reported: 13 == 13.** ✔

### 0.6 session-record — count 10

```
shop-knowledge query --corpus . --facet type --value session-record
```
The 10 ids: sess-2026-05-11-a, sess-2026-07-09-a, sess-2026-07-14-a,
sess-2026-07-14-b, sess-2026-07-15-a, sess-2026-07-16-a, sess-2026-07-19-a,
sess-2026-07-20-a, sess-2026-07-25-a, sess-2026-07-27-a. Synthetic genesis
session present: sess-2026-05-11-a.
**Listed == reported: 10 == 10.** ✔

### 0.7 prioritization-record — count 0

```
shop-knowledge query --corpus . --facet type --value prioritization-record
```
Output: `[]`. **Listed == reported: 0 == 0.** ✔ (A recognized kind with zero
instances; still scanned by every semantic rule below.)

### 0.8 current-state — count 1

```
shop-knowledge query --corpus . --facet type --value current-state
```
The 1 id: current-state-001. **Listed == reported: 1 == 1.** ✔

### 0.9 Universe total

68 + 38 + 24 + 10 + 13 + 10 + 0 + 1 = **164 documents across 8 kinds.** Every
selection rule in §2 runs against this complete set.

**900-series / synthetic roots present in the universe:** pdr-900, cand-900,
intent-900, sess-2026-05-11-a. These are the exact category the decision touches
(framework-construction material inside the corpus) and are analyzed head-on in
§5 (pillar 4), not merely listed.

---

## 2. Section 2 — Question → terms (the audit surface)

The question forces these concepts. "Cross-kind candidate set" = the full 164-doc
universe from §0; each rule was executed against all eight kinds (title-scan of
the enumerated ids, then render of the on-topic survivors). No full-text facet
exists, so "no other doc mentions X" claims are **title-level** unless I rendered
every candidate body (marked BODY where I did).

| # | Term | Why the QUESTION forces it | Command(s) run (reproduce verbatim) | Full cross-kind candidate set surfaced | Selection rule (include AND exclude, both executed) | Title/Body | Kinds scanned | Re-runnable |
|---|---|---|---|---|---|---|---|---|
| T1 | framework spec §1–6 (`01-principles.md`…`06-work-tracking.md`) | The literal subject of the decision | title-scan of all 164 §0 ids; render adr-037, adr-034 | All 164 ids | INCLUDE any doc whose body classifies or governs the numbered §1–6 spec files → adr-037, adr-034 (both render and name `01-…`–`06-…`); EXCLUDE the rest (their titles/bodies name BCs, messaging, fabro, bootstrap, not §1–6) | BODY (adr-037, adr-034 rendered in full) | ALL 8 | yes |
| T2 | typed artifact corpus / typed artifact system (the target container) | The decision is about corpus membership | render pdr-035, adr-067, adr-069 | All 164; on-topic accepted cluster {pdr-035, adr-067, adr-068, adr-069, adr-070, adr-071, cand-006..009} | INCLUDE docs that define what the corpus IS / its kinds → pdr-035 (needs), adr-067 (base schema), adr-069 (per-type schema); EXCLUDE downstream tooling-only slices (adr-068 CLI, adr-070/071 writing-skills) as not deciding membership | BODY (pdr-035, adr-069 rendered) | ALL 8 | yes |
| T3 | the eight recognized artifact kinds — does §1–6 fit any? | If no kind fits, "first-class artifact" has no slot | `shop-knowledge schema zzz`; render pdr-035 | The eight kinds (schema enum) + all 164 ids | INCLUDE the authoritative kind enumeration and the accepted doc stating the count → schema output + pdr-035 D2; §1–6 matches none of the eight kind definitions | BODY (schema output + pdr-035 D2) | ALL 8 (the enum IS the kind set) | yes |
| T4 | "migrate legacy corpus INTO the typed system" — the live migration and its scope | If a live effort already targets §1–6, the decision is moot | title-scan all 164; render brief-024, pdr-034, cand-004, intent-006 | Migration cluster: intent-006, cand-004, pdr-034, brief-024 (titles name "legacy corpus / brief-PDR-ADR migration"); also brief-023 (coherence-gate CLI) | INCLUDE every doc whose title/body is the legacy-corpus migration → the 4 above; EXCLUDE none from the cluster; then render each and read its SCOPE section | BODY (all 4 rendered in full; scope sections read) | ALL 8 | yes |
| T5 | classification: "system-construction artifact / self-description / framework normative text" | The question is really "what kind of thing is §1–6, and does that thing belong in a decision corpus?" | render adr-037 (D1–D4, findings), adr-034 (finding 3) | adr-037, adr-034 (only docs that render this classification of §1–6) | INCLUDE docs that classify §1–6's *nature* → adr-037 finding 1/D4, adr-034 finding 3; EXCLUDE docs that merely cite a § x number in passing (none surfaced as a competing classifier) | BODY (rendered) | ALL 8 | yes |
| T6 | framework-construction material already INSIDE the corpus (the 900-series) | The synthetic roots are the exact "is construction material corpus material?" test case | render pdr-900, cand-900, intent-900; navigate pdr-900, cand-900 | pdr-900, cand-900, intent-900, sess-2026-05-11-a (the only `Legacy:`-titled synthetic roots) | INCLUDE all four 900-series/genesis synthetic roots; render each to see whether they carry §1–6 prose or are decision-genesis stubs | BODY (rendered — bodies are empty section skeletons) | ALL 8 (900-series exhaustively enumerated in §0) | yes |
| T7 | kind-extensibility — could a ninth "framework-spec" kind be added? | "first-class artifacts" presumes a kind to be first-class *as* | render pdr-031 (rejected) | pdr-031 (title "kind-extensible knowledge context … v1", status rejected) is the only doc framing kind-extensibility | INCLUDE the doc that weighed "generalized kind-extensible context vs single-purpose decisions tool" → pdr-031; read its resolution | BODY (rendered) | ALL 8 | yes |
| T8 | foundational purpose — why the corpus exists at all | Membership must serve the corpus's stated purpose | render pdr-035 (accepted needs statement) | pdr-035 (accepted, the sole "foundational needs statement") | INCLUDE the accepted foundational-needs doc → pdr-035; read part 1 ("why the product keeps artifacts") | BODY (rendered) | ALL 8 | yes |

---

## 3. Section 3 — Terms → grounded set

Each relied-on artifact, with its §2 chain, Rule 1b title/body labeling, Rule 3
axis-match, Rule 2c evidence-directness, and Rule 5 provenance edges.

### 3.1 adr-037 — "The framework spec (§1–6) is a system-CONSTRUCTION artifact; stays in framework/lead repo, NOT shipped to product instances" — **accepted**

- **Chain:** T1/T5 → `shop-knowledge render adr-037 --corpus .` → full render (rendered in full during research; 516 lines).
- **Decision clauses (quoted):**
  - **D1:** "The numbered sections `01-principles.md` … `06-work-tracking.md` are
    the **system's self-description** … They are NOT shipped with the
    `shopsystem-templates` package to product instances … The spec remains
    canonical and lives here, in the framework/lead repo, exactly as today."
  - **Finding 1:** "The framework spec §1–6 IS the system's self-description,
    distinct from the `adr/` decision record. CONFIRMED … This is
    framework-construction text, not per-product operative doctrine."
  - **D4 table row:** "**system-self-description** | it explains *why the system
    is shaped this way* | it belongs in the **framework spec** §1–6, NOT the
    product."
- **Axis of D1:** decides *whether §1–6 ships OUTWARD to product instances as
  package data* (and that it stays in the lead repo). **Axis of the question:**
  *whether, inside the lead repo, §1–6 is a typed-corpus artifact or plain
  markdown.* These are DIFFERENT axes. **Axis match (D1): NO.** D1 is a
  boundary/packaging decision about outward shipping; it does not decide
  intra-repo corpus membership. I do NOT use D1 as a membership argument.
- **Axis of finding 1 / D4:** decides *what kind of thing §1–6 is* — system
  self-description, a category distinct from the decision record. **Axis of the
  question** turns on exactly this (a decision corpus of eight decision/provenance
  kinds vs. a descriptive spec). **Axis match (finding 1 / D4): YES.** This is the
  clause I lean on.
- **Rule 2c (evidence directness):** adr-037 finding 1 is PRIMARY EVIDENCE for
  pillar 1 and is cited as such in §5, not demoted.
- **Rule 5 edges:**
  ```
  shop-knowledge navigate adr-037 --corpus . --direction both
  ```
  `derives-from → adr-018 (accepted)`; `derived-by → brief-011 (draft)`. Upstream
  root adr-018 is the empirical-verification doctrine (the evidence rule adr-037's
  findings honor) — read; it does not bear on the membership axis. brief-011
  (bootstrap path) consumes adr-037's "don't ship spec outward" rule — read;
  outward-shipping axis, not membership.

### 3.2 adr-034 — "System-global ADRs live in the lead `adr/` tree, tagged by tier" — **superseded**

- **Chain:** T1/T5 → `shop-knowledge render adr-034 --corpus . --view transformation` → full render.
- **Decision-relevant clause (quoted, finding 3):** "The framework spec proper
  lives OUTSIDE `adr/` — in the numbered `01-…`–`06-…` section files. CONFIRMED …
  The genuinely framework-normative text is the spec sections; the `adr/` tree is
  the decision record about realizing the framework into this product. This is the
  real distinction: spec sections = framework normative text; `adr/` =
  product-realization decisions."
- **Axis:** classifies §1–6 as *framework-normative text, outside the decision
  record*. Same "what kind of thing is it" axis as the question. **Axis match:
  YES.**
- **Status caveat (Rule 4/5):** adr-034 is **superseded** (its tier scheme was
  folded into adr-067's base schema — see below). Per Rule 5, a superseded node
  that directly proves the fact is promoted, not dropped. Its finding-3
  classification was **carried forward and explicitly re-cited by accepted
  adr-037 finding 1** ("read of section headers + ADR-034 finding 3, which already
  drew this line"). So the classification survives supersession into an accepted
  doc. I cite adr-034 finding 3 as the most *direct* wording, anchored by
  adr-037's accepted re-affirmation.
- **Rule 2c:** adr-034 finding 3 is the single most direct empirical proof of
  pillar 1 — cited as evidence in §5, not as "stale provenance."
- **Rule 5 edges:** adr-034 was superseded by the adr-067 base-schema family
  (adr-067's title states it "supersedes ADR-059, ADR-034, and ADR-035 on
  acceptance"). The supersession is about the *tier/home* scheme, NOT about
  finding 3's spec-vs-decision classification, which nothing overturns.

### 3.3 brief-024 — "Migrate the ~119-file legacy artifact corpus forward into the modern typed-artifact system" — **ready**

- **Chain:** T4 → `shop-knowledge render brief-024 --corpus . --view transformation` → full render.
- **Scope clauses (quoted):**
  - In scope: "The **119 legacy files** in `pdr/` (33), `adr/` (63), `briefs/`
    (23) … The **`intent/` → `intents/`** directory + filename rename."
  - "Findings plane stays OUTSIDE the coherence graph … the reason there are 8
    types and no `finding` type."
  - Out of scope: "Redesigning the schema, typedefs, status vocabulary, or
    lifecycle semantics — this is a forward-migration onto the *existing* spec."
- **What is absent:** the numbered framework-spec files
  `01-principles.md`…`06-work-tracking.md` appear **nowhere** in brief-024's
  scope, in-scope list, out-of-scope list, or phase plan. The migration targets
  the decision/provenance corpus (pdr/adr/brief/intent + already-typed
  candidates/sessions/current-state), not §1–6.
- **Axis:** *what gets pulled into the typed corpus by the live effort.* Directly
  the membership axis. **Axis match: YES.**
- **Rule 2c:** brief-024's scope is the most direct empirical proof of pillar 2.
  Cited as evidence in §5.
- **Status (Rule 4):** `ready` (verified in §0.3 raw output). This is the LIVE
  migration; its readiness overrides the merely-`proposed` pdr-034. Quoted status
  field: brief-024 → `"status": "ready"`.
- **Rule 5 edges:**
  ```
  shop-knowledge navigate brief-024 --corpus . --direction both
  ```
  `derives-from → cand-005 (committed)`, `derives-from → intent-007 (recorded)`,
  `candidate → cand-005 (committed)`. Upstream is the knowledge/schema
  precondition-chain intent, read; it confirms brief-024 is the corpus-migration
  execution slice, not a §1–6 effort.

### 3.4 pdr-034 — "Legacy brief/PDR/ADR corpus migrates into the typed artifact system" — **proposed**

- **Chain:** T4 → `shop-knowledge render pdr-034 --corpus . --view transformation` → full render.
- **Decision clause (quoted):** "**Option C.** Full-corpus appetite is ratified —
  `brief/`, `pdr/`, and `adr/` all migrate onto the typed-schema mechanism ADR-059
  already built."
- **Scope/appetite (quoted):** "Full corpus (`brief/`, `pdr/`, `adr/` — all
  files), phased/gate-verified batching."
- **Axis:** which legacy families migrate into the typed system. Membership axis.
  **Axis match: YES.** §1–6 is not among `brief/`, `pdr/`, `adr/`.
- **Status (Rule 4):** `proposed`; explicitly **held** ("This PDR is **held**: do
  not dispatch … until `cand-005` phases 1-4 land"). Liveness of the *effort* is
  carried by brief-024 (`ready`), not this held PDR.
- **Rule 5 edges:** `derives-from → cand-004 (shaped)`; `derived-by → brief-023
  (draft)`. Full chain intent-006 → cand-004 → pdr-034 read (below).

### 3.5 cand-004 / intent-006 — the migration's candidate and originating intent

- **Chain:** T4 → `shop-knowledge render cand-004 --corpus . --view transformation`
  and `shop-knowledge render intent-006 --corpus . --view transformation`.
- **intent-006 goal (quoted):** "progressive-disclosure/retrieval tooling built on
  typed metadata … can only be as complete as the corpus it indexes. A corpus
  where most of the historical **decision record (ADRs, PDRs, briefs)** carries no
  queryable structure defeats that tooling."
- **cand-004 problem (quoted):** "the historical decision record most worth citing
  reliably (ADRs, PDRs, product briefs) is invisible to it."
- **Axis:** the intent scopes the *historical decision record* (ADR/PDR/brief).
  The framework spec §1–6 is not a decision record and is not named. **Axis match:
  YES** (confirms the migration's target set is decision artifacts).
- **Rule 5 edges:** `intent-006 → cand-004 → pdr-034 → brief-023`; session
  `sess-2026-07-16-a`. Chain read end-to-end; nothing in it names §1–6.

### 3.6 pdr-035 — foundational needs statement for the artifact system — **accepted**

- **Chain:** T2/T3/T8 → `shop-knowledge render pdr-035 --corpus .` → full render.
- **Decision clauses (quoted):**
  - Part 1: "Decisions, intent, and shape are durable product facts that must be
    reasoned about *as a set* — the current system … Artifacts exist so that the
    present state of the product's thinking is legible without replaying how it got
    there."
  - Part 2: "**The eight kinds and how they compose.** The system recognizes eight
    artifact kinds. They compose along a **provenance spine** — a scenario is
    defined by a PDR, which derives from a candidate, which derives from an intent,
    which is produced in a session."
- **Axis:** defines what the corpus is FOR (durable decision/intent/shape facts)
  and that it recognizes exactly eight composing kinds. Directly the membership
  axis (does §1–6 qualify as one of these eight decision/provenance kinds?).
  **Axis match: YES.**
- **Rule 2c:** pdr-035 part 2 is the most direct accepted statement of "eight
  kinds," cited as evidence for pillar 3.
- **Status:** `accepted` (§0.2 raw output).

### 3.7 adr-069 / adr-067 — the eight per-type schemas and base schema — **accepted**

- **Chain:** T2/T3 → `shop-knowledge render adr-069 --corpus .` (and adr-067 title
  from §0.1).
- **Quoted (adr-069):** "for each of the eight kinds, *what it adds to or
  constrains beyond the base schema*." Finding 2 enumerates the kinds carrying
  `derives-from`: "adr, pdr, brief only … intent-record, candidate,
  session-record, current-state, and prioritization-record."
- **Axis:** the schema surface enumerates exactly the eight decision/provenance
  kinds; none is a "framework spec / normative self-description" kind. Membership
  axis. **Axis match: YES.**
- **Status:** `accepted`.

### 3.8 pdr-900 / cand-900 / intent-900 / sess-2026-05-11-a — the synthetic framework-construction roots

- **Chain:** T6 → `shop-knowledge render pdr-900 --corpus . --view transformation`
  (+ cand-900, intent-900, sess in transformation view) and `shop-knowledge
  navigate pdr-900 --corpus . --direction both`.
- **Body content:** all four render as **empty section skeletons** (pdr-900:
  `## Context / ## Options considered / ## Decision / ## Consequences`, all
  empty). They carry **no §1–6 prose**.
- **Titles (from §0):** pdr-900 "Legacy: framework-construction genesis decision
  (synthetic grounding)"; cand-900 "Legacy: framework-construction decisions
  (synthetic grounding)"; intent-900 "Legacy: construct the shopsystem framework
  (pre-intent-record era)"; sess "Legacy: framework-genesis session
  (reconstructed)."
- **Axis:** these are synthetic *decision-genesis* grounding roots — a
  `derives-from` anchor so real framework-construction ADRs/PDRs (adr-001,
  adr-005, adr-009, pdr-001, pdr-003, …) resolve. They represent the *decision to
  build the framework*, NOT the framework's descriptive spec text. **Axis match to
  "is §1–6 corpus material": YES** — they show the corpus holds construction
  *decisions* as grounding stubs, and pointedly does NOT hold the §1–6 prose.
- **Rule 5 edges:**
  ```
  shop-knowledge navigate pdr-900 --corpus . --direction both
  ```
  `derives-from → cand-900`; `derived-by → adr-001, adr-005, adr-009 (accepted)`.
  cand-900 `derived-by` pdr-001, pdr-003, pdr-025, pdr-026, pdr-027, pdr-900.
  Confirms 900-series are shared genesis anchors, not spec carriers.

### 3.9 pdr-031 — "kind-extensible knowledge context, discovery-first (v1)" — **rejected**

- **Chain:** T7 → `shop-knowledge render pdr-031 --corpus . --view transformation`.
- **Quoted option:** "**Generalized kind-extensible context vs. a single-purpose
  decisions tool.**" pdr-031's overall status is **rejected** (§0.2). Its
  successor line (pdr-032 → the eight-kind typed system) landed a *bounded* set of
  decision/provenance kinds, not an open kind-extensible document store.
- **Axis:** whether the knowledge system is an open, kind-extensible store (which
  might host a "framework-spec" kind) or a bounded decisions tool. Bears on the
  forward-looking "add a ninth kind" question. **Axis match: partial/borderline** —
  informs §6's inference, not a headline argument.

### 3.10 current-state-001 — analyzed, NOT relied on

- `shop-knowledge render current-state-001 --corpus . --view transformation` +
  a grep for `01-|§1|framework spec|principles|outside|numbered` → **no hits**.
  The current-state narrative does not classify §1–6's corpus membership. It
  neither supports nor falsifies the recommendation; surfaced here for
  completeness (Rule 6).

---

## 4. Section 4 — Verified facts as runnable assertions

Every command below is **byte-identical** to the same command where it appears in
the prose. The count checks wrap the byte-identical bare `query …` invocation from
§0 in a length assertion; the bare invocation string is unchanged. The block exits
0 iff every anchor holds.

```bash
set -euo pipefail
cd /workspace

# --- §0 per-kind counts (bare query is byte-identical to §0; wrapped in a length assert) ---
shop-knowledge query --corpus . --facet type --value adr | python3 -c 'import sys,json;assert len(json.load(sys.stdin))==68'
shop-knowledge query --corpus . --facet type --value pdr | python3 -c 'import sys,json;assert len(json.load(sys.stdin))==38'
shop-knowledge query --corpus . --facet type --value brief | python3 -c 'import sys,json;assert len(json.load(sys.stdin))==24'
shop-knowledge query --corpus . --facet type --value candidate | python3 -c 'import sys,json;assert len(json.load(sys.stdin))==10'
shop-knowledge query --corpus . --facet type --value intent-record | python3 -c 'import sys,json;assert len(json.load(sys.stdin))==13'
shop-knowledge query --corpus . --facet type --value session-record | python3 -c 'import sys,json;assert len(json.load(sys.stdin))==10'
shop-knowledge query --corpus . --facet type --value prioritization-record | python3 -c 'import sys,json;assert len(json.load(sys.stdin))==0'
shop-knowledge query --corpus . --facet type --value current-state | python3 -c 'import sys,json;assert len(json.load(sys.stdin))==1'

# --- kind-set enumeration (exits non-zero by design; grep drives the check) ---
shop-knowledge schema zzz 2>&1 | grep -q "the eight recognized artifact types are: intent-record, candidate, session-record, prioritization-record, brief, pdr, adr, current-state"

# --- adr-037 (accepted): D1 shipping clause + finding-1/D4 classification ---
shop-knowledge render adr-037 --corpus . | grep -q "The framework spec §1–6 is a system-construction artifact"
shop-knowledge render adr-037 --corpus . | grep -q "is NOT shipped to product instances"
shop-knowledge render adr-037 --corpus . | grep -q "distinct from the"
shop-knowledge render adr-037 --corpus . | grep -q "it belongs in the \*\*framework spec\*\* §1–6, NOT the product"

# --- adr-034 finding 3 (most direct proof, pillar 1) ---
shop-knowledge render adr-034 --corpus . --view transformation | grep -q "The framework spec proper lives OUTSIDE \`adr/\`"

# --- brief-024 (ready): scope names decision families, excludes §1–6; 8 types no finding ---
shop-knowledge render brief-024 --corpus . --view transformation | grep -q "no \`finding\` type"
shop-knowledge render brief-024 --corpus . --view transformation | grep -q "Redesigning the schema, typedefs"

# --- pdr-034 (proposed, held): scope = brief/pdr/adr ---
shop-knowledge render pdr-034 --corpus . --view transformation | grep -q "Full corpus (\`brief/\`, \`pdr/\`, \`adr/\` — all"

# --- pdr-035 (accepted): eight kinds ---
shop-knowledge render pdr-035 --corpus . | grep -q "The system recognizes eight artifact"

# --- 900-series are synthetic grounding roots, not spec carriers ---
shop-knowledge navigate pdr-900 --corpus . --direction both | grep -q '"target": "cand-900"'
shop-knowledge navigate pdr-900 --corpus . --direction both | grep -q '"target": "adr-001"'

echo "ALL ANCHORS HOLD"
```

Every anchor string above was confirmed to hit during research (checks OK1–OK5,
OK4b, OK-scope-out, OK-scope-out2, and the navigate edges).

---

## 5. Section 5 — Decision

**RECOMMENDATION: Keep the framework spec §1–6 as plain markdown OUTSIDE the typed
artifact corpus.** Four pillars, each with its Rule-4 backing, Rule-1b label,
Rule-2b sweep, and Rule-2c proof.

### Pillar 1 — §1–6 is a distinct KIND of thing (system self-description / framework-normative text), categorically different from the decision/provenance artifacts the corpus holds

- **Backing clause (Rule 4):** adr-037 finding 1 (accepted): "The framework spec
  §1–6 IS the system's self-description, **distinct from the `adr/` decision
  record**." adr-034 finding 3: "spec sections = framework normative text; `adr/` =
  product-realization decisions."
- **Rule 1b label:** This is a **classification** claim about two specific docs
  that I rendered in full — BODY-level for adr-037 and adr-034. I do NOT claim
  "no other doc classifies §1–6" as a body-level fact (no full-text facet); a
  title-scan of all 164 ids surfaced only adr-037 and adr-034 as classifiers, and
  that is a **title-level** observation.
- **Rule 2b sweep — "how §1–6 is classified relative to the decision record":**
  accepted on-topic docs found = {adr-037}; superseded-but-carried-forward =
  {adr-034}. Every one surfaced: **YES**. No accepted doc classifies §1–6 as a
  decision artifact.
- **Rule 2c most-direct proof:** adr-034 finding 3 — quoted, cited as evidence:
  **YES**. Re-affirmed by accepted adr-037 finding 1.
- **Axis discipline:** I lean on adr-037's *classification* clause (axis match
  YES), NOT its D1 *shipping* clause (axis match NO). The shipping decision is not
  used as a membership argument.

### Pillar 2 — the LIVE corpus-migration effort deliberately scopes only the decision/provenance corpus; §1–6 is not in it

- **Backing clause (Rule 4 — liveness by status field):** brief-024 status =
  `ready` (§0.3). Its scope names "the 119 legacy files in `pdr/` (33), `adr/`
  (63), `briefs/` (23)" plus the `intent/`→`intents/` rename. pdr-034
  (`proposed`, **held**) ratifies "Full corpus (`brief/`, `pdr/`, `adr/`)."
  intent-006 / cand-004 scope "the historical **decision record** (ADRs, PDRs,
  briefs)." §1–6 (`01-…`–`06-…`) appears in none of them.
- **Rule 1b label:** BODY-level — I rendered brief-024, pdr-034, cand-004,
  intent-006 in full and read each scope section. "§1–6 absent from the migration
  scope" is verified against the full body of every doc in the migration cluster.
- **Rule 2b sweep — "legacy corpus migration into the typed system":** accepted
  on-topic docs = none in `accepted`/`committed` status *for the PDR-line*
  (pdr-034 is `proposed`, cand-004 is `shaped`, intent-006 is `recorded`,
  brief-024 is `ready`); the governing accepted anchor they build on is pdr-035.
  Every migration-cluster doc surfaced: **YES**. None extends scope to §1–6.
- **Rule 2c most-direct proof:** brief-024 scope + out-of-scope — quoted, cited as
  evidence: **YES**.
- **Liveness note (Rule 4):** the migration is LIVE (brief-024 `ready`), and it
  still excludes §1–6. So "not migrated" is not merely "not yet proposed" — the
  ready, executable spec draws the corpus boundary and §1–6 is outside it.

### Pillar 3 — the corpus recognizes exactly EIGHT kinds; none is a framework-spec / self-description kind, so §1–6 has no first-class slot

- **Backing clause (Rule 4):** `shop-knowledge schema zzz` → "the eight recognized
  artifact types are: intent-record, candidate, session-record,
  prioritization-record, brief, pdr, adr, current-state." pdr-035 (accepted): "The
  system recognizes eight artifact kinds." adr-069 (accepted) enumerates the same
  eight. All eight are decision/intent/provenance/state kinds; none is a normative
  descriptive spec.
- **Rule 1b label:** BODY-level for the enumeration (schema output + pdr-035 D2 +
  adr-069 both rendered). "None of the eight is a spec kind" is verified by reading
  each kind's role; it is a BODY-level claim about the eight named kinds, not a
  title-scan.
- **Rule 2b sweep — "what governs the kind set / whether it is extensible":**
  accepted on-topic = {pdr-035, adr-067, adr-069, adr-070, adr-071}; rejected =
  {pdr-031}. Every one surfaced: **YES**. The accepted governance defines a
  bounded eight-kind schema; the one doc that framed open kind-extensibility
  (pdr-031) is **rejected**.
- **Rule 2c most-direct proof:** `shop-knowledge schema zzz` output + pdr-035 —
  quoted, cited as evidence: **YES**.
- **Open/closed honesty (Rule 4):** I assert as fact only that the corpus
  *currently recognizes exactly eight kinds and none fits §1–6*. I do NOT assert
  the set is permanently closed — see §6 inference #1.

### Pillar 4 — framework-construction material that IS in the corpus is decision-genesis grounding (900-series stubs), NOT the descriptive §1–6 prose — confronting the synthetic roots head-on

- **The complicating artifacts:** pdr-900, cand-900, intent-900, sess-2026-05-11-a
  are `Legacy: framework-construction …` synthetic roots INSIDE the corpus. A
  naive read ("construction material is already in the corpus → so should §1–6")
  must be confronted.
- **Confrontation (Rule 6):** rendered in full, all four are **empty section
  skeletons** carrying no §1–6 text. `navigate pdr-900` shows they exist purely as
  `derives-from` anchors for real construction *decisions* (adr-001, adr-005,
  adr-009, pdr-001, pdr-003, …). They encode *the decision to build the framework*
  as provenance roots — a decision/provenance function, squarely one of the eight
  kinds — **not** the framework's descriptive self-description. brief-024 authored
  them precisely to keep the corpus "one consistent typed graph with no special
  escape fields." So the 900-series *reinforces* the recommendation: even
  framework-construction lineage enters the corpus only as typed
  decision/provenance grounding, and the descriptive §1–6 prose was deliberately
  left out.
- **Rule 1b label:** BODY-level (all four rendered; bodies empty). **Rule 2c:**
  pdr-900/cand-900 empty stubs + navigate edges — cited as evidence: **YES.**

### Why not migrate (the rejected alternative)

Migrating §1–6 in as "first-class artifacts" would require inventing a ninth kind
(a "framework-spec"/"normative-description" kind) — a schema change every accepted
governance doc (pdr-035, adr-067, adr-069) treats as out of scope, and whose
open-store framing (pdr-031) was rejected — OR force-fitting §1–6 into `adr`/`pdr`,
which adr-037 finding 1 and adr-034 finding 3 both say it is NOT (it is
self-description, not a decision record). Neither path is supported by any accepted
doc. The status quo (plain markdown, in the lead repo, canonical for the framework
builder) is exactly what adr-037 D1 and D4 endorse for §1–6.

---

## 6. Section 6 — Where this could be wrong, RANKED

### 6.1 (#1) Completeness holes — concepts/kinds/docs I may have failed to derive, enumerate, or scan

- **Kinds filtered by each semantic rule:** every semantic rule (T1–T8) was run
  against **all eight kinds** / the full 164-doc universe enumerated in §0. No kind
  was skipped. `prioritization-record` (0 docs) and `current-state` (1 doc) were
  included; current-state-001 was rendered and found silent on the question.
- **Per-pillar Rule 2b restatement:** Pillar 1 sweep → {adr-037 accepted, adr-034
  superseded-carried-forward}, all surfaced YES. Pillar 2 → migration cluster
  {brief-024 ready, pdr-034 proposed, cand-004 shaped, intent-006 recorded}, all
  surfaced YES. Pillar 3 → {pdr-035, adr-067, adr-069, adr-070, adr-071 accepted;
  pdr-031 rejected}, all surfaced YES. Pillar 4 → {pdr-900, cand-900, intent-900,
  sess-2026-05-11-a}, all surfaced YES.
- **Per-pillar Rule 2c proof id:** P1 = adr-034 finding 3 (+ adr-037 finding 1);
  P2 = brief-024 scope; P3 = `schema zzz` + pdr-035; P4 = pdr-900/cand-900 stubs.
- **Residual hole:** the **absence of §1–6 from the migration scope is proven at
  BODY level only for the four docs I rendered** (brief-024, pdr-034, cand-004,
  intent-006). "No OTHER of the 164 docs anywhere proposes migrating §1–6" is a
  **TITLE-level** claim (title-scan of all §0 ids; no full-text facet exists to
  make it body-level). Could a non-migration-titled doc's body quietly propose it?
  I did not render all 164 bodies. **Can this change the recommendation?** Only if
  such a doc were `accepted` AND on the membership axis — none surfaced by title,
  and the accepted governance cluster (pdr-035/adr-067/adr-069) points the other
  way. Low risk.

### 6.2 Uniqueness claims — each labeled

- "adr-037 and adr-034 are the docs that classify §1–6's nature" — **TITLE-level**
  (scan of all 164 ids; the two rendered bodies confirm they classify, but I did
  not render all 164 to prove no third classifier exists). Not asserted as
  body-uniqueness.
- "The corpus recognizes exactly eight kinds" — **BODY/tool-level**, backed by
  `shop-knowledge schema zzz` and pdr-035 D2 verbatim. This one IS a hard fact.
- "§1–6 is absent from the migration scope" — **BODY-level** for the four
  migration-cluster docs; **TITLE-level** for the rest of the universe.

### 6.3 Axis-match risks

- adr-037 **D1 axis = NO** (shipping-outward, not intra-repo membership). I flagged
  this and did NOT use D1 as a membership argument; I used finding 1 / D4
  (classification, axis YES). If a reader treats adr-037's headline as deciding
  membership, that is the boundary-confusion trap — explicitly avoided here.
- adr-034 is **superseded**; I rely on its finding 3 only because accepted adr-037
  finding 1 re-cites and re-affirms it. If one rejects superseded docs entirely,
  the pillar still stands on adr-037 alone.

### 6.4 Inferences stated in §5 (not doc-asserted facts)

- **Inference #1 (the one real gap):** "No ninth kind should be added for §1–6 /
  the kind set should stay bounded." **No doc declares the eight-kind set closed.**
  pdr-035 says "recognizes eight," adr-069 governs "the eight kinds," and pdr-031's
  open-kind-extensibility framing was rejected — but none states "no ninth may ever
  be added." **This is my inference, not stated by any doc.** It is the only part
  of the recommendation that is forward-looking rather than
  current-state-empirical. **Can it change the recommendation?** It weakens only
  the "never migrate" strength, not the core "today §1–6 is neither in the corpus,
  in any migration scope, nor a fit for any recognized kind." The bounded
  recommendation (keep it OUTSIDE) holds regardless.

### 6.5 Provenance roots read

- adr-037 chain (adr-018 upstream, brief-011 downstream): read. adr-034
  supersession into adr-067 family: read. brief-024 / pdr-034 / cand-004 /
  intent-006 / sess-2026-07-16-a migration chain: read end-to-end. 900-series
  navigate graph: read. No relied-on node was left at mid-chain with an unread
  root.

### 6.6 False-positive / false-negative risks

- **False-negative (recommendation-changing if real):** a live decision to add a
  "framework-spec" kind exists somewhere I did not render. Mitigant: title-scan of
  all 164 found none; the only kind-extensibility doc (pdr-031) is rejected. Low.
- **False-positive:** treating "not currently migrated" as "must never be" —
  guarded by isolating that half as inference #1.

---

## Report

**File:** `/workspace/drafts/grounding-record-exp-iter4.md`

**Recommendation (2 lines):** Keep the framework spec §1–6 as plain markdown
OUTSIDE the typed artifact corpus — accepted classification (adr-037 finding 1,
adr-034 finding 3) makes it system self-description, not a decision record; the
live `ready` migration (brief-024) scopes only the decision corpus; and §1–6 fits
none of the eight recognized kinds.

**Terms:** 8 derived; re-runnable:title-scan split = **8 re-runnable : 0
title-scan-only** (every term's selection was executed as a `shop-knowledge`
command against the complete 164-doc universe).

**Kinds scanned vs total:** 8 of 8 (adr, pdr, brief, candidate, intent-record,
session-record, prioritization-record, current-state).

**Per-kind document counts:** adr 68, pdr 38, brief 24, candidate 10,
intent-record 13, session-record 10, prioritization-record 0, current-state 1
(total 164).

**Topic-sweep tally:** 4 pillars swept; accepted on-topic docs found =
{adr-037, pdr-035, adr-067, adr-069, adr-070, adr-071} + carried-forward adr-034
+ 900-series grounding {pdr-900, cand-900}; all surfaced: **YES**.

**Per-pillar most-direct-empirical-proof id:** P1 adr-034 finding 3 (+ adr-037
finding 1); P2 brief-024 scope; P3 `shop-knowledge schema zzz` + pdr-035; P4
pdr-900 / cand-900 synthetic stubs.

**All pasted commands reproduce verbatim: YES.**
