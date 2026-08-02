# Grounding Record — Should the framework spec (§1–6) migrate INTO the typed artifact corpus?

Researcher grounding record. Every artifact below is reached by a fully shown
`shop-knowledge query|navigate|render` chain from `/workspace`. Corpus root is
`.` throughout. The tool exposes three read verbs (`query`, `navigate`,
`render`) plus `template`/`schema`/`validate`; `query` filters only by the four
facets `type`, `status`, `tag`, `distribution`.

---

## 1. Summary box

> **Question (verbatim):** "Should the shopsystem framework spec (the framework
> principles/spec, sections 1 through 6, currently plain markdown in the
> lead/framework repo) be migrated INTO the typed artifact corpus as first-class
> artifacts, or stay as plain markdown OUTSIDE the corpus?"
>
> **Recommendation (1 line):** Keep §1–6 as plain markdown OUTSIDE the typed
> corpus — under the eight-kind system as it stands today no kind fits the spec,
> and no live artifact proposes migrating it.
>
> **Confidence:** Medium-high. High that under the *current* eight-kind roster
> the spec is ineligible and that the one live migration effort excludes it;
> lower on the normative "should," because the kind set is *not declared closed*
> (adr-071 D1 contemplates a ninth kind) so a future decision could author a
> spec/principle kind — a decision no live artifact makes.
>
> **Term coverage:** 8 derived terms; 8 re-runnable via `query`/`navigate`/
> `render`; 0 resolved by title-scan-only (every selection reruns against the
> complete Section-0 universe).
>
> **Most load-bearing artifact:** pdr-037 (+ adr-069) — the roster of the eight
> kinds a corpus artifact must be one of. **Axis match: YES** (it decides the
> membership-eligibility axis: to be a typed artifact you must be a recognized
> kind; §1–6 is none). Caveat carried to §6: adr-071 D1 makes the roster
> *extensible*, so "no kind fits" is a today-fact, not a closure.
>
> **Topic-sweep tally:** 4 argument pillars + 2 residual-risk topics swept;
> accepted on-topic docs found across all sweeps = {pdr-035, pdr-037, adr-067,
> adr-068, adr-069, adr-070, adr-071, adr-037, pdr-900}; every one surfaced: **YES**.
>
> **Attack Section 0 and Section 2 first.**

---

## 2. Type inventory (Rule 2 — the complete universe)

### 2.0 The kinds command and its output

The corpus recognizes a fixed vocabulary of artifact *types*. The command that
lists them is `shop-knowledge template <bad>` / `schema <bad>`, whose error
enumerates the recognized set:

```
$ shop-knowledge schema notarealtype --corpus .
error: 'notarealtype' is not a recognized artifact type
the eight recognized artifact types are: intent-record, candidate, session-record, prioritization-record, brief, pdr, adr, current-state
```

**Eight kinds:** `intent-record, candidate, session-record,
prioritization-record, brief, pdr, adr, current-state`.

`query` accepts only four facets (proven by probe):

```
$ shop-knowledge query --corpus . --facet foo --value bar
error: unknown facet 'foo'; expected one of type, status, tag, distribution
```

The `tag` and `distribution` facets are **unpopulated corpus-wide** (every probe
returns `[]`, and a direct frontmatter read of adr-069 shows no `tags`/
`distribution` keys):

```
$ for v in artifact-system knowledge migration spec framework governance; do shop-knowledge query --corpus . --facet tag --value "$v"; done
[] [] [] [] [] []      # every tag probe empty
$ for v in product-lead product-wide bc-local; do shop-knowledge query --corpus . --facet distribution --value "$v"; done
[] [] []               # every distribution probe empty
$ shop-knowledge render adr-069 --corpus . --format yaml | (extract frontmatter keys)
KEYS: ['authors','beads','created','decision-makers','derived-by','derives-from','description','id','status','title','type','updated']   # no tags, no distribution
```

**Consequence:** `type` is the only discriminating enumeration axis, so the
per-`type` enumeration below IS the complete topic-sweep universe. Nothing hides
under a tag/distribution facet.

### 2.1 Per-kind enumeration — raw counts and every id (no ranges, no ellipses)

Each block below is the `query --facet type --value <kind>` result reduced to
`count` + the full id list via `python3 -c "…len(d)…ids"`. For each kind:
**listed count == count reported by the command.**

**intent-record — reported 13; listed 13:**
`intent-001 intent-002 intent-003 intent-004 intent-005 intent-006 intent-007
intent-008 intent-009 intent-010 intent-011 intent-012 intent-900`
listed(13) == reported(13). ✅ (gap proof: no intent-013+; the synthetic
`intent-900` is present and is not a range artifact.)

**candidate — reported 10; listed 10:**
`cand-001 cand-002 cand-003 cand-004 cand-005 cand-006 cand-007 cand-008
cand-009 cand-900`
listed(10) == reported(10). ✅

**session-record — reported 10; listed 10:**
`sess-2026-05-11-a sess-2026-07-09-a sess-2026-07-14-a sess-2026-07-14-b
sess-2026-07-15-a sess-2026-07-16-a sess-2026-07-19-a sess-2026-07-20-a
sess-2026-07-25-a sess-2026-07-27-a`
listed(10) == reported(10). ✅

**prioritization-record — reported 0; listed 0:** `[]` (empty). ✅

**brief — reported 24; listed 24:**
`brief-001 brief-002 brief-003 brief-004 brief-005 brief-006 brief-007
brief-008 brief-009 brief-010 brief-011 brief-012 brief-013 brief-014
brief-015 brief-016 brief-017 brief-018 brief-019 brief-020 brief-021
brief-022 brief-023 brief-024`
listed(24) == reported(24). ✅

**pdr — reported 38; listed 38:**
`pdr-001 pdr-002 pdr-003 pdr-004 pdr-005 pdr-006 pdr-007 pdr-009 pdr-010
pdr-011 pdr-012 pdr-013 pdr-014 pdr-015 pdr-016 pdr-017 pdr-018 pdr-019
pdr-020 pdr-021 pdr-022 pdr-023 pdr-024 pdr-025 pdr-026 pdr-027 pdr-028
pdr-029 pdr-030 pdr-031 pdr-032 pdr-033 pdr-034 pdr-035 pdr-036 pdr-037
pdr-038 pdr-900`
listed(38) == reported(38). ✅ (gap proof: `pdr-008` is absent from the raw
output — a real gap, not inferred; `pdr-038` IS present and `pdr-900` IS present.)

**adr — reported 68; listed 68:**
`adr-001 adr-002 adr-004 adr-005 adr-006 adr-008 adr-009 adr-010 adr-011
adr-012 adr-013 adr-014 adr-015 adr-016 adr-017 adr-018 adr-019 adr-020
adr-021 adr-022 adr-023 adr-024 adr-025 adr-026 adr-027 adr-028 adr-029
adr-030 adr-031 adr-032 adr-033 adr-034 adr-035 adr-036 adr-037 adr-038
adr-039 adr-040 adr-041 adr-042 adr-043 adr-045 adr-046 adr-047 adr-048
adr-049 adr-050 adr-051 adr-052 adr-053 adr-054 adr-055 adr-056 adr-057
adr-058 adr-059 adr-060 adr-061 adr-062 adr-063 adr-064 adr-065 adr-066
adr-067 adr-068 adr-069 adr-070 adr-071`
listed(68) == reported(68). ✅ (gap proof: `adr-003`, `adr-007`, `adr-044`
absent from raw output — real gaps; `adr-071` IS the highest present.)

**current-state — reported 1; listed 1:** `current-state-001`. ✅

**Universe total = 13+10+10+0+24+38+68+1 = 164 documents across 8 kinds.**

---

## 3. Section 2 — Question → terms (the audit surface)

Each row: a concept the QUESTION forces, the exact command, the FULL cross-kind
candidate set surfaced, the explicit selection rule, and the kinds scanned. The
"full candidate set" for a semantic rule is the complete Section-0 universe
(164 docs, all 8 kinds) filtered by title; only the survivors are named, and the
rejection rule is stated so the reader can rerun it against every id.

| # | Term | Why the QUESTION forces it | Command run | Full cross-kind candidate set surfaced | Selection rule (what it kept / rejected) | Kinds scanned | Re-runnable |
|---|---|---|---|---|---|---|---|
| T1 | **the framework spec §1–6 itself** | The subject of the question. | `query type=adr` → `adr-037`; title-scan of all 164 ids for "spec / §1–6 / principles / framework spec" | Across all 8 kinds, exactly ONE artifact names §1–6: **adr-037** ("The framework spec (§1–6) is a system-CONSTRUCTION artifact…"). No intent/candidate/pdr/brief/session/current-state title references §1–6 or "principles." | Keep any doc whose title/body names the numbered spec sections `01-…06-`. Only adr-037 matches; every other id rejected because none mentions §1–6. | ALL 8 | yes |
| T2 | **the eight recognized kinds (membership roster)** | "migrated INTO the corpus as first-class artifacts" ⇒ §1–6 must be *some kind*. | `schema notarealtype` (roster); `render pdr-035`, `render pdr-037`, `render adr-069` | Roster-defining docs: **pdr-035** (accepted), **pdr-037** (accepted), **adr-069** (accepted); base/read/skill governance **adr-067, adr-068, adr-070, adr-071** (all accepted). Superseded/rejected roster history: pdr-032 (superseded), pdr-031 (rejected). | Keep ACCEPTED docs that define what the kinds ARE and what a member must supply. Rejected pdr-031/superseded pdr-032/adr-059/adr-034/adr-035 kept only as provenance (§5/§6), not as ground. | ALL 8 | yes |
| T3 | **the legacy-corpus migration effort (scope test)** | "migrated INTO the corpus" — is §1–6 inside the one migration that exists? | `query type=intent-record/candidate/pdr/brief`; `render` each; `navigate` the chain | Migration cluster (one per stage): **intent-006** (recorded) → **cand-004** (shaped) → **pdr-034** (proposed) → **brief-024** (ready). No other id across 8 kinds proposes migrating any prose INTO the corpus. | Keep any doc whose title/body decides "migrate X into the typed artifact system." Four found; all scope themselves to `brief/`/`pdr/`/`adr/`. Every other id rejected (different subject). | ALL 8 | yes |
| T4 | **classification/home of §1–6** | "stay OUTSIDE the corpus" — where does the spec live and what is it? | `render adr-037` (D1/D4); `navigate adr-037` | **adr-037** only. | Keep the doc that classifies §1–6's nature and home. Only adr-037. | adr (all adr scanned) | yes |
| T5 | **framework-construction represented in the corpus (synthetic roots)** | Rule 6 — a 900-series category may BE "framework material as artifacts." | `query type=…` surfaced the `-900`/genesis ids; `render` + `navigate` each | **intent-900, cand-900, pdr-900** (accepted), **sess-2026-05-11-a** — all titled "Legacy: … framework-construction / framework-genesis (synthetic grounding)." | Keep every `-900`/"Legacy: framework" root. Four found and all rendered (empty scaffolds). | intent/candidate/pdr/session | yes |
| T6 | **is the kind set open / closed / extensible?** | Rule 4 — any "no kind fits" claim needs the governance docs on extensibility. | `render adr-071` (D1, finding 4); `render adr-067` (D5); `render pdr-031` (rejected) | **adr-071** (accepted, "adding a ninth kind's typedef…"), **adr-069/adr-067** (accepted), **pdr-031** (rejected, proposed a `development-principle` kind). | Keep every accepted governance doc bearing on roster extensibility + the rejected precedent. All surfaced. | adr + pdr | yes |
| T7 | **liveness/status of the migration** | Rule 4 — "not live / only proposed" needs status fields. | `query type=…` (status field); `render brief-024`, `render pdr-034`; `navigate sess-2026-07-25-a` | Statuses: intent-006 `recorded`, cand-004 `shaped`, pdr-034 `proposed`, brief-024 `ready`; sess-2026-07-25-a `closed` ("migrate branch landed to main"). | Read the literal `status` of every migration artifact; no title-scan. | intent/candidate/pdr/brief/session | yes |
| T8 | **what the corpus is FOR (does §1–6's content-type belong?)** | "first-class artifacts" — the founding purpose gates eligibility. | `render pdr-035` (parts 1–2); `render current-state-001 --view transformation` | **pdr-035** (accepted) + **current-state-001** (`current`) narrative. | Keep the founding needs statement + the live current-state narrative of the corpus's contents. Both surfaced. | pdr + current-state | yes |

---

## 4. Section 3 — Terms → grounded set

Every artifact leaned on, with its §2 chain, its Rule 3 axis-match verdict, and
its Rule 5 provenance edges.

### 3.1 pdr-037 — "Each of the eight artifact kinds gets its own stated needs" (status: accepted) — MOST LOAD-BEARING (with adr-069)

- **Chain (T2):** `schema notarealtype` names eight kinds → `render pdr-037` →
  it enumerates them verbatim.
- **Exact clause:** Context — *"the eight kinds (adr, pdr, brief, intent-record,
  candidate, session-record, current-state, prioritization-record)…"*; Decision —
  *"For each of the eight kinds, state its **needs** — why it exists, its role in
  the workflow, its characteristic sections, and its participation on the
  provenance spine and in the base schema's edges."*
- **Axis it decides:** the roster of recognized kinds and the contract each kind
  member must satisfy (a role on the provenance spine
  scenario→PDR→candidate→intent→session).
- **Axis the question asks:** may §1–6 become a first-class (typed) corpus
  artifact — i.e., is it eligible as one of the recognized kinds?
- **Axis match: YES.** Eligibility = being a recognized kind. §1–6 is a
  system self-description with no role on the product-decision provenance spine;
  it matches none of adr/pdr/brief/intent-record/candidate/session-record/
  current-state/prioritization-record. (Extensibility caveat → §6.)
- **Provenance (Rule 5):** `supersedes → pdr-032` (superseded);
  `derives-from → cand-008` (committed); `derived-by → adr-069` (accepted). Full
  chain read: pdr-032 (the bundled taxonomy this explodes) and adr-069 (the
  paired per-type schema) both rendered/analyzed below.

### 3.2 adr-069 — "Per-type schema for the eight artifact kinds" (status: accepted)

- **Chain (T2):** `render pdr-037` → `navigate` → `derived-by adr-069` →
  `render adr-069 --format yaml`.
- **Exact content:** additive per-type schema on adr-067's base; finding 1:
  *"The eight per-type typedefs are the current single source and each already
  carries per-type required sections, a status enum, and per-type link fields."*
- **Axis it decides:** what frontmatter/sections each of the eight kinds adds on
  the base schema — again presupposing exactly the eight-kind roster.
- **Axis match: YES** (same eligibility axis as pdr-037).
- **Provenance:** `supersedes/derives-from → adr-059` (superseded),
  `derives-from → pdr-035` (accepted); `derived-by → adr-070`. Upstream root
  pdr-035 read (3.3).

### 3.3 pdr-035 — foundational needs statement (status: accepted)

- **Chain (T8/T2):** `render pdr-035`.
- **Exact clauses:** Part 1 — *"Why the product keeps artifacts. Decisions,
  intent, and shape are durable **product** facts that must be reasoned about as
  a set."* Part 2 — *"The system recognizes **eight** artifact kinds. They
  compose along a **provenance spine** — a scenario is defined by a PDR, which
  derives from a candidate, which derives from an intent, which is produced in a
  session."*
- **Axis it decides:** what the artifact corpus is FOR (the product's own
  decisions/intent/shape) and that there are exactly eight composing kinds.
- **Axis match: YES.** The corpus is for *product* decisions/intent/shape;
  §1–6 is the *system's self-description* (adr-037), a different content-type
  with no spine position.
- **Provenance:** `supersedes → pdr-032`; `derives-from → cand-006`;
  `derived-by → adr-067`. Root cand-006 (committed) and adr-067 read.

### 3.4 brief-024 — "Migrate the ~119-file legacy artifact corpus" (status: ready) — the live migration scope

- **Chain (T3):** `query type=brief` → `brief-024` (only "migrate…forward"
  title) → `render brief-024 --view transformation` → `navigate`.
- **Exact scope clause:** In scope — *"The **119 legacy files** in `pdr/` (33),
  `adr/` (63), `briefs/` (23): directory rename to plural, filename rename,
  frontmatter synthesis, status-label→enum mapping, provenance preservation."*
  Nowhere does it name `01-…06-…`, "principles," or the framework spec.
- **Axis it decides:** which files the one live migration touches — exactly the
  brief/PDR/ADR decision families.
- **Axis the question asks:** is §1–6 part of "migrated INTO the corpus"?
- **Axis match: YES (scope axis).** The migration's own scope answers the
  question's sub-axis directly: §1–6 is excluded from the only migration that
  exists. Note brief-024 grounds framework-construction genesis roots with
  **empty synthetic 900-series artifacts** (`adr-001 → pdr-900 → cand-900 →
  intent-900`), *not* by ingesting spec prose — the migration deliberately keeps
  spec text out of the graph.
- **Provenance:** `derives-from → cand-005` (committed), `→ intent-007`
  (recorded); `candidate → cand-005`. The brief-024 chain is the precondition-
  chain lineage (cand-005), distinct from the brief/PDR/ADR *appetite* lineage
  (intent-006→cand-004→pdr-034) it executes.

### 3.5 pdr-034 / cand-004 / intent-006 — the migration appetite chain (proposed / shaped / recorded)

- **Chain (T3/T7):** `render` + `navigate` each. `intent-006 → cand-004 →
  pdr-034` is one derives-from spine.
- **Exact scope:** pdr-034 The question — *"PDR-032's own appetite line
  explicitly excluded the legacy `brief/`/`pdr/`/`adr/` corpus… Should that
  exclusion be lifted?"*; Decision — *"`brief/`, `pdr/`, and `adr/` all migrate
  onto the typed-schema mechanism."* intent-006/cand-004 repeat "legacy
  brief/PDR/ADR." **§1–6 appears in none.**
- **Axis match: YES (scope axis)** — the migration subject is the brief/PDR/ADR
  decision record, not the spec.
- **Provenance:** intent-006 `derived-by → cand-004`; cand-004 `derives-from →
  intent-006`, `derived-by → pdr-034`; pdr-034 `derives-from → cand-004`,
  `derived-by → brief-023`. Full spine read.

### 3.6 adr-037 — "The framework spec (§1–6) is a system-CONSTRUCTION artifact" (status: accepted)

- **Chain (T1/T4):** `query type=adr` → only adr-037 names §1–6 → `render
  adr-037` → `navigate`.
- **Exact clause D1:** *"The numbered sections `01-principles.md` …
  `06-work-tracking.md` are the **system's self-description** — the artifact a
  framework builder reads… They are NOT shipped with the `shopsystem-templates`
  package to product instances. The spec remains canonical and lives here, in the
  framework/lead repo, exactly as today."* D4 table row: *"**system-self-
  description** … it belongs in the **framework spec** §1–6, NOT the product."*
- **Axis it decides:** whether §1–6 propagates OUTWARD to product instances as
  package data (D1: no) — a shipping/packaging axis.
- **Axis the question asks:** whether §1–6 becomes a typed artifact INSIDE the
  corpus (a repo-membership/format axis).
- **Axis match: NO (for the decision clause).** Per Rule 3's boundary warning,
  "do not ship X to product instances" is a *different axis* from "X's membership
  inside the corpus." adr-037 D1 is therefore **not** used as decision argument
  #1. What adr-037 *does* supply on-axis is a **classification** (finding 1):
  §1–6 is self-description, *distinct from the `adr/` decision record* — and it
  treats §1–6 as remaining plain markdown "exactly as today." That classification
  supports (does not decide) the recommendation.
- **Provenance:** `derives-from → adr-018` (accepted); `derived-by → brief-011`
  (draft). adr-018 (empirical-surface doctrine) read via cross-refs.

### 3.7 The 900-series synthetic roots — intent-900 / cand-900 / pdr-900 / sess-2026-05-11-a (recorded / committed / accepted / closed)

- **Chain (T5):** surfaced by the type enumeration; `render` each →
  **all bodies are empty section-scaffolds**; `navigate` shows they exist only to
  give genesis-root ADRs/PDRs a resolvable `derives-from` target
  (`pdr-900 derived-by adr-001/adr-005/adr-009`; `cand-900 derived-by
  pdr-001/003/025/026/027/900`; `sess-2026-05-11-a produced
  intent-900/cand-900/pdr-900`).
- **Analysis (Rule 6):** these are the corpus's representation of
  *framework-construction* — and they represent it as **empty synthetic
  scaffolding grounding the decision ADRs/PDRs**, NOT by ingesting the §1–6 spec
  prose. This is the category closest to "framework material as artifacts," and
  it confirms the design chose to keep §1–6 text out of the graph, grounding
  roots with contentless nodes instead. Supports the recommendation.

### 3.8 current-state-001 — live current-state (status: current)

- **Chain (T8):** `render current-state-001 --view transformation` (it renders
  only in transformation view — its status `current` is not `accepted`);
  `navigate` for `incorporates`.
- **Exact clause:** *"**Artifact system (live).** The product's own decisions,
  intent, and shape are kept as a typed artifact corpus… **eight kinds**… "*
  Artifacts listed: intents, candidates, sessions, prioritizations, briefs, pdrs,
  adrs, current-state. **§1–6 / framework spec is not listed as a corpus member.**
- **Axis match: YES** — it narrates what the live corpus contains; §1–6 is absent.
- **`incorporates` (Rule 5):** includes adr-037, pdr-035, adr-067, adr-068,
  adr-069, adr-070, adr-071, pdr-037, pdr-038, pdr-900 — the governance cluster —
  but **not** pdr-034 or brief-024 (the legacy migration is not yet claimed
  incorporated, though its files are already typed on the branch).

---

## 5. Section 4 — Verified facts as assertions (runnable checks)

Each fact = a command + a must-contain anchor. The block exits 0 iff all anchors
hold. An auditor's re-run must reproduce the exact document set (per-kind count
anchors) and every leaned-on clause/status.

This block was executed and exits 0 (prints `ALL ANCHORS HOLD`). Note two
robustness details a re-runner must keep: (a) `render` wraps prose across
newlines, so multi-word anchors are grepped through a whitespace-flattening
helper `rf`; (b) `schema notarealtype` exits non-zero *by design* (it is an
error message), so its output is captured before grep and `pipefail` is NOT set.

```bash
#!/usr/bin/env bash
# Run from /workspace. Prints ALL ANCHORS HOLD and exits 0 iff every anchor holds.
set -u
cd /workspace
q(){ shop-knowledge query --corpus . --facet type --value "$1"; }
n(){ python3 -c "import sys,json;print(len(json.load(sys.stdin)))"; }
# render + flatten all whitespace to single spaces (render wraps lines):
rf(){ shop-knowledge render "$1" --corpus . "${@:2}" 2>&1 | tr '\n\t' '  ' | tr -s ' '; }
fail=0
chk(){ if eval "$1"; then :; else echo "FAIL: $2"; fail=1; fi; }

# --- Section-0 per-kind count anchors (reproduce the exact universe) ---
chk '[ "$(q intent-record|n)"         = 13 ]' "intent count"
chk '[ "$(q candidate|n)"             = 10 ]' "candidate count"
chk '[ "$(q session-record|n)"        = 10 ]' "session count"
chk '[ "$(q prioritization-record|n)" = 0  ]' "prioritization count"
chk '[ "$(q brief|n)"                 = 24 ]' "brief count"
chk '[ "$(q pdr|n)"                   = 38 ]' "pdr count"
chk '[ "$(q adr|n)"                   = 68 ]' "adr count"
chk '[ "$(q current-state|n)"         = 1  ]' "current-state count"

# --- Roster: eight kinds; §1–6 is none of them (schema exits non-zero by design) ---
chk 'ros="$(shop-knowledge schema notarealtype 2>&1)"; echo "$ros" | grep -q "the eight recognized artifact types are: intent-record, candidate, session-record, prioritization-record, brief, pdr, adr, current-state"' "roster"
chk 'rf pdr-037 | grep -q "the eight kinds (adr, pdr, brief, intent-record"' "pdr-037 eight"
chk 'rf pdr-037 | grep -q "participation on the provenance spine"' "pdr-037 spine"

# --- pdr-035: corpus is for PRODUCT facts; eight kinds ---
chk 'rf pdr-035 | grep -q "durable product facts"' "pdr-035 product facts"
chk 'rf pdr-035 | grep -q "recognizes eight artifact kinds"' "pdr-035 eight"

# --- adr-037 D1: spec stays in framework/lead repo; its axis is shipping outward ---
chk 'rf adr-037 | grep -q "system-construction artifact; it stays in the framework/lead repo and is NOT shipped to product instances"' "adr-037 D1"
chk 'rf adr-037 | grep -q "lives here, in the framework/lead repo, exactly as today"' "adr-037 today"

# --- Migration scope = brief/PDR/ADR only; §1–6 never named ---
chk 'rf brief-024 --view transformation | grep -q "119 legacy artifact files"' "brief-024 119"
chk 'rf brief-024 --view transformation | grep -q "33 in .pdr/., 63 in .adr/., 23 in .briefs/."' "brief-024 counts"
chk '! rf brief-024 --view transformation | grep -Eq "01-principles|06-work-tracking|framework spec .1"' "brief-024 no spec"
chk '! rf pdr-034 --view transformation | grep -Eq "01-principles|framework spec"' "pdr-034 no spec"

# --- Migration liveness (status fields, literal) ---
chk 'q candidate | grep -q "\"id\": \"cand-004\", \"title\": \"Migrate the legacy brief/PDR/ADR corpus into the typed artifact system\", \"status\": \"shaped\""' "cand-004 status"
chk 'q pdr       | grep -q "\"id\": \"pdr-034\", \"title\": \"Legacy brief/PDR/ADR corpus migrates into the typed artifact system\", \"status\": \"proposed\""' "pdr-034 status"
chk 'q brief     | grep -q "\"id\": \"brief-024\", \"title\": \"Migrate the ~119-file legacy artifact corpus forward into the modern typed-artifact system\", \"status\": \"ready\""' "brief-024 status"

# --- Kind set is EXTENSIBLE, not declared closed (Rule 4) ---
chk 'rf adr-071 | grep -q "adding a ninth kind.s typedef automatically extends the coverage"' "adr-071 ninth"

# --- 900-series are synthetic scaffolds representing framework construction ---
chk 'shop-knowledge navigate pdr-900 --corpus . --direction both | grep -q "Legacy: framework-construction"' "pdr-900 legacy"
chk 'shop-knowledge navigate sess-2026-05-11-a --corpus . --direction both | grep -q "pdr-900"' "sess produced pdr-900"

# --- current-state narrates the live corpus, eight kinds, no §1–6 ---
chk 'rf current-state-001 --view transformation | grep -q "Artifact system (live)"' "cs live"
chk '! rf current-state-001 --view transformation | grep -Eq "01-principles|framework spec .1"' "cs no spec"

[ $fail = 0 ] && echo "ALL ANCHORS HOLD" || { echo "SOME FAILED"; exit 1; }
```

---

## 6. Section 5 — Decision, justified strictly against §3–§4

**Recommendation: keep the framework spec §1–6 as plain markdown OUTSIDE the
typed artifact corpus.** Four pillars, each with its Rule 2b sweep result; the
one closure-shaped claim is flagged as inference and moved to §7.

**Pillar A — Under the current roster, §1–6 fits no kind (eligibility).**
`pdr-037` (§3.1) defines the eight kinds by *role on the product-decision
provenance spine* (scenario→PDR→candidate→intent→session); `pdr-035` (§3.3)
says the corpus exists for the product's own *decisions, intent, and shape*;
`adr-069` (§3.2) gives each kind its additive per-type schema. §1–6 is the
system's self-description (adr-037 finding 1), authored once as framework
construction, with no intent that raised it, no session that produced it, no
decision/candidate role — it occupies no spine position and matches none of the
eight kinds. To make it "first-class" you would have to author a ninth kind.
*Rule 2b sweep — "artifact-kind roster/governance": accepted on-topic docs =
{pdr-035, pdr-037, adr-067, adr-068, adr-069, adr-070, adr-071}; every one
surfaced: YES.* (adr-068 = the read CLI itself, tangential; adr-070 = per-kind
writing-skill structure — a spec kind would need a nonexistent `write-spec`
skill, reinforcing the roster; neither falsifies the pillar.)

**Pillar B — The one live migration excludes §1–6 by scope.** `brief-024`
(§3.4, status `ready`, executed per sess-2026-07-25-a "migrate branch landed to
main") and its appetite chain `intent-006→cand-004→pdr-034` (§3.5) all scope
themselves to `brief/`/`pdr/`/`adr/` — the decision families that already map
onto existing kinds. §1–6 is named in none of them (§4 negative anchors).
Migrating the spec is simply not the effort that exists. *Rule 2b sweep —
"migrate prose INTO the corpus": on-topic docs = {intent-006, cand-004, pdr-034,
brief-024}; every one surfaced: YES. None is ACCEPTED — the migration runs on a
`ready` brief, not a ratified decision; this is stated, not hidden.*

**Pillar C — Even the corpus's own representation of framework construction
keeps spec prose out.** The 900-series synthetic roots (§3.7,
`intent-900/cand-900/pdr-900/sess-2026-05-11-a`) are the deliberate mechanism
for putting *framework-construction* into the graph — and they are **empty
scaffolds** whose sole job is edge resolution, grounding genesis ADRs/PDRs
without ingesting §1–6. This is the Rule 6 confrontation: the category that most
looks like "framework material as artifacts" was built precisely to avoid
importing the spec text. Supports the recommendation. *Sweep — "framework
construction as corpus artifacts": {intent-900, cand-900, pdr-900,
sess-2026-05-11-a}; all surfaced: YES.*

**Pillar D — adr-037 classifies §1–6 as a distinct, home-in-the-repo category
(supporting, not deciding).** adr-037 (§3.6) treats §1–6 as self-description
that "lives here… exactly as today" (plain markdown) and is *distinct from the
`adr/` decision record.* **Axis caveat (Rule 3): adr-037's DECISION clause
decides the outward-shipping axis, NOT corpus membership — Axis match NO — so it
is a supporting classification, never the headline.** *Sweep — "classification/
home of §1–6": accepted on-topic docs = {adr-037}; surfaced: YES.*

**Confronting the complicating docs head-on:**
- **pdr-031 (rejected)** proposed a kind-extensible knowledge context with a
  `development-principle` kind for "durable principles / doctrine" — which is
  what §1–6 *is*. Had it been accepted, a home for spec-like material could
  exist. It was **rejected**; its accepted successor line (pdr-032→pdr-035)
  settled on exactly eight kinds, none a principle/spec kind. I do not ground on
  pdr-031; I surface it because it shows the idea was considered and not adopted.
- **adr-071 D1** (accepted) says "adding a ninth kind's typedef automatically
  extends the coverage domain." This means the roster is **not closed** — see §7.

---

## 7. Section 6 — Where this could be wrong, RANKED

**1 (completeness hole — the required #1).** Concepts/kinds/docs I may have
failed to derive or scan. *Kinds filtered by each semantic rule:* T1, T2, T3 were
run against **all 8 kinds** (the full 164-doc universe); T4 (adr), T5
(intent/candidate/pdr/session), T6 (adr+pdr), T7 (intent/candidate/pdr/brief/
session), T8 (pdr+current-state) filtered narrower kinds **but only after** the
all-8-kind title scan of T1/T3 confirmed no other kind carries a §1–6 or a
"migrate INTO corpus" title — so no kind was silently dropped from a *semantic*
rule. `tag`/`distribution` facets are unpopulated (§2.0), so no doc hides under
them. *Per-pillar Rule 2b restatement:* A — accepted {pdr-035, pdr-037, adr-067,
adr-068, adr-069, adr-070, adr-071} all surfaced; B — {intent-006, cand-004,
pdr-034, brief-024} all surfaced (none accepted); C — {intent-900, cand-900,
pdr-900, sess-2026-05-11-a} all surfaced; D — {adr-037} surfaced. Residual risk:
a doc whose title gives no hint of §1–6 or migration but whose *body* argues it —
`query` has no full-text facet, so a purely-in-body argument in one of the 164
docs could be missed. Mitigation: the four governance/migration clusters were
read in full and cross-reference each other without pointing to any such doc.
**Can change the recommendation only if such a hidden doc exists — not observed.**

**2 (inference, not fact — the closure question).** "No kind fits, so §1–6
cannot be a first-class artifact" is true **today** but rests on the roster being
effectively eight. **This is my inference; the accepted doc adr-071 D1 states the
opposite of closure — a ninth kind can be added.** No accepted doc declares the
kind set closed. So the honest position: *under the eight kinds as they stand
§1–6 is ineligible, but the system is extensible and a future decision could
author a spec/principle kind (an idea floated in rejected pdr-031).* This
**bounds the recommendation to "given the current system and no live effort,"
not "§1–6 can never be corpus material."** Surfaced accepted docs most on-point:
adr-071, adr-067, adr-069 (all cited in §3/§6).

**3 (axis-match NO).** adr-037's decision clause is on the *outward-shipping*
axis, not corpus membership (§3.6). I have kept it OUT of the headline and used
only its on-axis *classification*. If a reader treats adr-037 D1 as deciding
membership, that is the boundary-confusion Rule 3 warns against — it does not.
Does not change the recommendation (the recommendation stands on Pillars A/B).

**4 (liveness / status).** The brief/PDR/ADR migration is live-and-largely-
executed (brief-024 `ready`; corpus already shows typed adr/pdr/brief;
sess-2026-07-25-a "landed to main"), but its appetite PDR-034 is still `proposed`
/ held and is NOT yet in current-state's `incorporates`. None of this touches
§1–6. If a *new* intent/brief were later filed to migrate the spec, the picture
changes — none exists in the 164-doc universe today. **Could change the
recommendation only on a future artifact.**

**5 (provenance roots).** I read each relied-on chain to its root: pdr-037←
cand-008; pdr-035←cand-006; adr-067←pdr-035/adr-059; brief-024←cand-005/
intent-007; pdr-034←cand-004←intent-006; adr-037←adr-018. Superseded/rejected
nodes on these chains (pdr-032, adr-059, adr-034, adr-035, pdr-031) were rendered
or surfaced and accounted for as history, not ground. Root not fully rendered:
cand-005/cand-006/cand-008/intent-007 bodies were reached via `navigate` +
title, not full `render` — they are lineage, not load-bearing to the axis. Low
risk.

**False-positive / false-negative summary:** false-positive risk (recommending
"stay out" when a doc actually mandates migrating §1–6) — none found; no doc
mandates it. False-negative risk (a body-only argument for migration in an
unscanned-by-body doc) — see risk #1; not observed. Net: recommendation is robust
for the current system, explicitly bounded by the extensibility caveat (#2).

---

## Report

- **File:** `/workspace/drafts/grounding-record-exp-iter3.md`
- **Recommendation (2 lines):** Keep the framework spec §1–6 as plain markdown
  OUTSIDE the typed corpus. Under the current eight-kind roster it fits no kind,
  the one live migration (brief-024) scopes to brief/PDR/ADR only, and even the
  corpus's synthetic representation of framework construction keeps spec prose
  out — but the roster is extensible (adr-071 D1), so this is a "given the current
  system" recommendation, not a permanent impossibility.
- **Term count:** 8 terms; **re-runnable : title-scan = 8 : 0.**
- **Kinds scanned vs total:** 8 of 8 (intent-record, candidate, session-record,
  prioritization-record, brief, pdr, adr, current-state).
- **Per-kind counts:** intent-record 13, candidate 10, session-record 10,
  prioritization-record 0, brief 24, pdr 38, adr 68, current-state 1 (total 164).
- **Topic-sweep tally:** 4 pillars + 2 residual-risk topics swept; accepted
  on-topic docs found = {pdr-035, pdr-037, adr-067, adr-068, adr-069, adr-070,
  adr-071, adr-037, pdr-900}; **all surfaced: YES.**
