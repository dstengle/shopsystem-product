# 06 — Synthesis: scorecard, recommended direction, and goals to validate

**Research stream:** synthesis (epic lead-x7bp, progressive-disclosure)
**Date:** 2026-07-04
**Status:** COMPLETE — cross-cuts streams 01–05 into a per-axis scorecard, a
picked direction per axis, and an ordered, measurable list of claims the
experiment (07) must prove on REAL repo ADRs/PDRs.
**Protocol:** fabro-style (PDR-016) — research → notes → synthesize (this doc) →
experiment (07) → recommend. No PDR/ADR authored here; this is durable findings.

---

## 0. The one-sentence result

All five streams converge on a single, low-novelty design: **YAML frontmatter is
the ONE source; L0/L1/L2 are deterministic field/section projections computed by
a `decisions` CLI (sibling to `scenarios`); the index is a generated
llms.txt/OKF-style markdown file; the coherence gate is a deterministic
typed-edge graph pass in the ADR-047 advisory/blocking shape; the L1 digest is
distributed to BCs.** Every mechanism has a ratified in-repo precedent
(ADR-019/043 single-source, nbx5 own-the-whole-projection, ADR-047 split gate,
the `scenarios` generate/verify CLI). The corpus (~97 decision docs: 53 ADR + 29
PDR + 15 briefs, all under Anthropic's 200K "don't retrieve" threshold) is below
the scale where any advanced-RAG machinery is warranted — every LLM-in-the-loop
mechanism (RAPTOR summaries, GraphRAG extraction, embeddings) is REFUTED as both
overkill and a determinism/drift leak.

The **only** real cost and the **only** genuine risk both live in one place: the
**frontmatter backfill migration** of a prose corpus that today has *zero* YAML
frontmatter, 18 relationship spellings, prose-only supersession, and no
`description`/`superseded-by`/`id` fields. That is the go-with-caveats item the
experiment must de-risk.

---

## 1. SCORECARD — design options per decision axis

Judged against the four operator constraints:
**[S] simple · [H] self-hostable · [D] single-sourced / no-drift · [100]
right-sized for ~100 docs.** Rating: ✅ strong fit · ➖ partial / caveated · ❌
disqualifying against that constraint.

### Axis (a) — Frontmatter schema (fields + prior art)

| Option | S | H | D | 100 | Notes / prior art |
|---|---|---|---|---|---|
| **MADR-minimal** (`status,date,decision-makers,consulted,informed`) | ✅ | ✅ | ➖ | ✅ | Proven, tiny. But has **no `id`, no `description`, no typed supersede edges**; crams supersession into the `status` string (`"superseded by ADR-0123"`) — not gate-parseable (stream 03). Under-serves L0 and the gate. |
| **Structured-MADR full** (`title,description,type,category,tags,status,created,updated,author,project,related[]`+JSON-LD/MIF/3 conformance tiers/Ajv) | ➖ | ➖ | ✅ | ❌ | Right field *set* (has `description`=L0!, `tags`, `status` enum) and the right principle ("markdown canonical, JSON derived"). But the JSON-LD/MIF/vendored-Ajv/tier apparatus is enterprise-audit machinery — **overkill** at 100 docs (stream 03). And it still has **no `supersedes`/`superseded-by`/`depends-on`** typed edges — the gate's whole substrate. |
| **OKF** (`type` required; `title,description,tags,timestamp` recommended; validator enforces 4) | ✅ | ✅ | ✅ | ✅ | Great "spec permissive / validator strict" lesson (stream 02), `description`=L0 one-liner. But relationships are **untyped prose links** — too weak for a supersede graph (stream 02 anti-pattern). |
| **★ Target schema** (`id,title,status,description,decision,supersedes,superseded-by,depends-on,tags`+`date`) | ✅ | ✅ | ✅ | ✅ | Streams 03+05 pick. Takes Structured-MADR's field set, adds the **three typed edges** MADR/OKF/Structured-MADR all lack, adds `id` (our ids already flow into `shop-msg` as `work_id`; filename-derivable). `decision` is EXTRACTED from the `## Decision` body anchor, not re-typed (anti-drift caveat, below). 9–10 fields = at MADR's stated upper bound but no higher. |

**Disqualifiers surfaced:** every off-the-shelf schema lacks typed supersede
edges; that gap *is* the coherence-gate bug we are fixing, so a bespoke
(precedent-grounded) schema is unavoidable — this is a justified divergence, not
NIH (stream 03 grounds each field). One hard collision flag (stream 05):
**`tier` is already a live governance field in 9 ADRs** (ADR-035
framework/system-global/BC-local). Disclosure L0/L1/L2 must NEVER be stored as a
`tier`/`level` frontmatter field — the level is a *tool projection*, and storing
it would itself be a single-source violation.

### Axis (b) — Tier-generation mechanism (parser + emitter shape)

| Option | S | H | D | 100 | Notes |
|---|---|---|---|---|---|
| **Hand-authored L0/L1 mirrors** (write the index & digest by hand) | ✅ | ✅ | ❌ | ✅ | The disqualified baseline. llms.txt's documented real-world failure — "a second copy nobody regenerates … will drift, guaranteed" (stream 01, A2). nbx5 is the same lesson in-repo (stream 05). **Ruled out by constraint D.** |
| **LLM-summarized tiers** (RAPTOR nodes / GraphRAG community summaries / OKF `synthesize_description` gemini call) | ➖ | ➖ | ❌ | ➖ | Non-deterministic, un-reproducible under a hash/CI check, and *re-introduces the exact summary/full drift the epic exists to kill* (streams 02, 04). **Ruled out by D and H.** Even OKF's own LLM rollup step is flagged AVOID (stream 02). |
| **★ Deterministic projection** (`parse frontmatter+body → project fields / extract `## Decision` section → emit`, model-free) | ✅ | ✅ | ✅ | ✅ | Streams 02/04/05 pick. OKF `regenerate_indexes` (~90 lines stdlib+PyYAML) is a near-verbatim template: walk → `OKFDocument.parse` → project tuple → group/sort → `write_text`, idempotent. L0 = project `(id,title,description[,status])`; **L1 = extract the `## Decision` H2 verbatim** (present in all 53 ADRs — verified); L2 = the whole file. Three emitters, one `parse()`. Zero model calls → drift structurally impossible, trivially self-hostable, hashable. |

**Load-bearing enabler (verified):** all 53 ADRs carry a `## Decision`-class
anchor, so **L1 is EXTRACTED, never summarized** — this is what makes "no
summary/full drift" achievable rather than aspirational (stream 05 §6). The one
subtlety: don't *also* duplicate the decision into a `decision:` YAML string
(that re-creates drift). Frontmatter carries at most a one-sentence pin; the
digest body comes from the `## Decision` section (stream 03 caveat).

### Axis (c) — Index format

| Option | S | H | D | 100 | Notes |
|---|---|---|---|---|---|
| **JSON catalog / sitemap only** | ✅ | ✅ | ➖ | ✅ | Machine-readable but not human-prose; a second artifact a human can't read (stream 02). Fine as a *secondary* emit, wrong as *primary*. |
| **OKF `index.md`** (`# <Group>` sections of `* [title](rel) - description`, no frontmatter, self-excluded) | ✅ | ✅ | ✅ | ✅ | The generator template itself (stream 02 §3). Dual human+machine markdown. |
| **★ llms.txt-style** (H1 + blockquote + H2 group sections of `[id — title](path): decision one-liner`, with a `## Optional` band) | ✅ | ✅ | ✅ | ✅ | Streams 01/02 pick. Essentially OKF's index shape + two extras that *earn their place*: (1) the **format IDE/coding agents already fetch** (Cursor/Claude Code/Windsurf) — validated for exactly agent-consumes-doc-corpus (stream 01); (2) the **`## Optional` band** = a real budget lever ("context, not conformance") a BC can skip. Emit an `index.json` from the *same* generator only if the gate wants structured input — same source, never hand-kept. |

**Overkill flags:** MCP URI-templates / live subscription server (stream 01) —
we want a *generated static artifact*, not a running server; borrow MCP's *data
model* (list/read descriptors, `audience`/`priority`/`size` annotation hints),
not its RPC machinery. Descriptor grammar is universally `{id/title, locator,
one-line description}` across llms.txt/MCP/Skills — that IS L0.

### Axis (d) — Coherence gate algorithm

| Option | S | H | D | 100 | Notes |
|---|---|---|---|---|---|
| **Prose/NLP supersede detection** (parse "supersedes X" from body text) | ➖ | ✅ | ➖ | ➖ | What the corpus forces today (75 prose `supersed*` mentions, 1 structured field, 0 `superseded-by` — stream 05). Fragile, NLP-ish. The gate's job is to *replace* this by reading typed edges. |
| **GraphRAG-style LLM edge extraction + community reasoning** | ❌ | ➖ | ❌ | ❌ | The extraction stage is the entire GraphRAG cost ($33k→$33/1M-tok, LLM-per-chunk, non-deterministic — stream 04). We have **no extraction step**: edges are authored in frontmatter. **Ruled out — build-a-cathedral.** |
| **★ Deterministic typed-edge graph pass** (nodes=docs, edges=`supersedes`/`superseded-by`/`depends-on`+`status`) in the ADR-047 advisory/blocking shape | ✅ | ✅ | ✅ | ✅ | Streams 03/04/05 pick. Standard graph checks, **zero LLM** (GraphRAG's insight minus its expensive half — stream 04). Checks: (1) **asymmetric supersede** — `A.supersedes:[B]` but `B.superseded-by≠A` (the adr-tools "one-sided-update rot" — stream 03); (2) **active-yet-superseded** — a `status: accepted` doc that is some doc's `superseded-by` target; (3) **dangling edge** — `depends-on`/`supersedes` → nonexistent or retired id; (4) **supersede cycle**; (5) **advisory** — two `accepted` docs sharing `tags` with conflicting decisions (flag for human, don't auto-resolve), `date` breaks the newer-of-two tie. |

**Gate posture (copy ADR-047 D3 verbatim in shape — stream 05 §3):** ADVISORY
(warn, exit 0) in-repo while a lead-architect authors — a hard veto "would invert
the author's authorship" (ADR-047:198); BLOCKING (refuse, exit non-zero) at the
**L1-digest distribution boundary** (the "stand-up" analogue — you must not pour
an incoherent digest to conforming BCs). Diagnosis in the PDR-024 `bin/doctor`
format (`name (check-id) + pass/fail + remediation`), folded into one
aggregate-nonzero verdict — the `scenarios --aggregate` sibling the epic names
(spec-level intent; not yet in the installed `scenarios` surface — stream 05).
This maps to `scenarios`' generate/`verify` split: emitters = `hash` (generate
tier from source), gate = `verify` (re-derive + compare, exit-coded).

### Axis (e) — BC distribution of the L1 digest

| Option | S | H | D | 100 | Notes |
|---|---|---|---|---|---|
| **Live MCP resource server** (`audience`-annotated resources, subscribe) | ➖ | ➖ | ✅ | ➖ | Cleanest *conceptual* model — `annotations.audience:["assistant"]`=L1→BC, `["user"]`/lead=L2; `priority`=must-conform ranking (stream 01). But a running server is overkill transport; borrow the *data model*, not the RPC. |
| **shop-msg send** (dispatch the digest as a message-typed payload) | ✅ | ✅ | ✅ | ✅ | In-doctrine transport; the lead already dispatches to BCs only via `shop-msg send`. Good for a *targeted* pour tied to a specific `assign_scenarios`/`request_bugfix` work item. Point-in-time; not ambient. |
| **★ Skills-style pour** (generate `DECISIONS.md`/`decisions.txt` L1 digest as a file placed in the BC's context, à la a SKILL.md the BC always loads) | ✅ | ✅ | ✅ | ✅ | Streams 01/04 pick as the *default*. Anthropic's 200K threshold (stream 04) says: the L1 digest for ~100 docs is a few–low-tens-of-K tokens → **load it WHOLE, no retrieval**. Skills proves "distill essential upward, always-load the lean tier, pull heavy detail one level down." The digest is a generated static file the BC always has; `## Optional` gives the budget lever. **shop-msg is the complementary targeted channel**, not a rival — pour the ambient digest, `shop-msg` the work-specific pin. |

Self-containment caveat (stream 04 contextual-retrieval lesson): each L1 entry
must read STANDALONE carrying its own `status`+`supersedes`, and the gate must
refuse to publish a digest containing an active-but-superseded contradiction — a
BC receiving only L1 must never conform to an orphaned/superseded statement.

---

## 2. RECOMMENDED DIRECTION (picked, per axis)

- **(a) Frontmatter schema — ADOPT the 9-field target schema**
  `id, title, status, description, decision, supersedes, superseded-by,
  depends-on, tags` + `date`. `id` filename-derived; `status` a lowercase enum
  `draft|proposed|accepted|rejected|deprecated|superseded` (+ separate `date`,
  splitting supersession OUT of the status string); `description` = the net-new
  one-line L0; the three typed edges are the justified divergence every prior-art
  schema lacks. **Preserve the existing governance `tier` field unchanged; never
  store a disclosure level in frontmatter** (it's a tool projection). Enforce the
  required set in the *validator*, keep the prose spec permissive (OKF lesson).

- **(b) Tier generation — DETERMINISTIC PROJECTION, model-free.**
  One `parse(frontmatter+body)`, three emitters: **L0** = project
  `(id,title,description[,status])`; **L1** = EXTRACT the `## Decision` section
  verbatim + ride `status`/`supersedes`/`superseded-by` inline; **L2** = the
  whole file. OKF `regenerate_indexes` (~90 lines stdlib+PyYAML) is the skeleton.
  No LLM anywhere in the generate path — that is what makes drift structurally
  impossible and keeps it behind a hash/CI gate. Do **not** duplicate the
  decision text into a YAML string as well as the body.

- **(c) Index format — llms.txt-style markdown** (H1 + blockquote + H2 group
  sections of `[id — title](path): one-line description`, plus an `## Optional`
  band), generated from frontmatter. It's OKF's proven index shape plus the two
  features that earn inclusion: the format coding agents already fetch, and the
  skippable Optional budget lever. Emit a parallel `index.json` from the *same*
  generator only if the gate/CLI wants structured input — never a second source.

- **(d) Coherence gate — DETERMINISTIC typed-edge graph pass in the ADR-047 D3
  advisory/blocking shape.** Zero LLM. Checks: asymmetric supersede, active-yet-
  superseded, dangling edge, supersede cycle (all BLOCKING at distribution); plus
  ADVISORY "two active decisions, shared tags, conflicting" flagged for human.
  Advisory (exit 0) in-repo authoring; blocking (exit non-zero) at the L1-pour
  boundary; PDR-024 doctor diagnosis format; one aggregate-nonzero verdict —
  mirroring `scenarios verify`/`--aggregate` intent.

- **(e) BC distribution — Skills-style pour of a whole `DECISIONS.md` L1 digest
  as the default, with `shop-msg send` as the complementary targeted channel.**
  Under 200K tokens → load whole, no retriever. Encode who-each-tier-is-for as an
  `audience`-like projection (L1→BC, L2→lead-only); `## Optional` = the BC's
  must-conform-vs-context budget lever. Each L1 entry is self-contained; the gate
  won't ship a contradictory digest.

- **Cross-cutting build shape:** a single BC-owned `decisions` CLI (ADR-018:
  built by a BC, installed to the lead host like `scenarios`, never sourced
  here), verb-noun + stdin-or-file + generate/verify split:
  `decisions card|decision|full <file|->` (L0/L1/L2 emitters = `hash` role),
  `decisions list` (all ids+titles+status = `scenarios list` role),
  `decisions index` (emit the llms.txt/index.md), `decisions check [--aggregate]`
  (the gate = `verify`+`--aggregate` role), `decisions supersede <old> --by <new>`
  (writes BOTH edges — automate both sides, adr-tools `-s` lesson).
  **Verdict: CONFIRM** the design; **go-with-caveats** on the frontmatter-backfill
  migration (the sole real cost/risk); **REFUTED** for every LLM-in-loop /
  embedding / clustering / live-server mechanism.

---

## 3. GOALS TO VALIDATE EXPERIMENTALLY (07-experiment.md executes verbatim)

Each is a concrete pass/fail on the REAL repo corpus (`/workspace/adr/`,
`/workspace/pdr/`, `/workspace/briefs/`). Prototype the `decisions` CLI in the
scratchpad only (ADR-018: no BC source committed here). Ordered so each unblocks
the next.

1. **Frontmatter round-trips existing docs without loss.** Take a representative
   sample of ≥15 real docs spanning both prose styles (`**x:**` bold and `- x:`
   dash), both id separators (`—`/`--`/`:`), ADRs *and* PDRs *and* briefs.
   Mechanically extract `id` (from filename), `title` (H1 after the separator,
   tolerating `—|--|:`), `status`, and `date` into YAML frontmatter, then
   serialize back. **PASS:** id/title/status/date extract correctly for ≥90% of
   the sample with the remainder flagged (not silently wrong); the body below the
   frontmatter is byte-identical to the original body. **FAIL:** any silent
   mis-parse of id/title, or a separator variant that crashes the parser.

2. **`## Decision` extraction yields a usable L1 for every ADR.** Run the L1
   emitter (extract the `## Decision`-class section verbatim) over all 53 ADRs.
   **PASS:** a non-empty decision block is extracted for 100% of ADRs (the
   verified anchor prevalence predicts this), and for PDRs the emitter falls back
   cleanly to `## Decision`/`## The decision`/`## Point of intent`. **FAIL:** any
   ADR yields an empty or wrong-section L1, or the extractor requires
   hand-tuning per doc.

3. **L1 is materially smaller than L2 in tokens.** For the same representative
   ADR set, measure tokens(L1 extracted decision + status/edges) vs tokens(full
   L2 doc). **PASS:** L1 median ≤ 35% of L2 tokens (target: the decision section
   is a small fraction of context/alternatives/consequences); report the
   distribution. **FAIL:** L1 is not meaningfully smaller (would mean the tier
   buys no budget benefit) — investigate whether docs are decision-heavy or the
   extractor is over-including.

4. **The whole-corpus L0 index and L1 digest fit in-context (no retriever
   needed).** Generate the L0 index (all ~97 docs) and the L1 digest (all
   accepted decisions) and count tokens. **PASS:** L0 index ≤ ~15K tokens and the
   full L1 digest well under 200K (Anthropic's "load whole, skip retrieval"
   threshold — the green-light for skills-style pour). **FAIL:** either artifact
   approaches 200K (would force a retrieval design we've argued against).

5. **Tiers regenerate identically from source — no drift (the core claim).**
   Generate L0/L1/index, hash them; re-run the generator on unchanged source and
   re-hash. Then edit ONE `description` in ONE doc's frontmatter and regenerate.
   **PASS:** identical input → byte-identical output (idempotent, hashable like
   `scenarios hash`); a single-field edit propagates to every index/digest line
   mentioning that doc with no other change. **FAIL:** any run-to-run diff on
   unchanged input (a determinism leak — e.g. unstable sort or a stray model
   call), or an edit that fails to propagate.

6. **Coherence gate flags a planted supersede-conflict and passes a clean set.**
   Build a clean frontmatter set (symmetric edges, no active-yet-superseded);
   confirm `decisions check` exits 0. Then plant each defect one at a time:
   (a) asymmetric supersede (`A.supersedes:[B]`, `B.superseded-by` empty);
   (b) active-yet-superseded (`accepted` doc that is a `superseded-by` target);
   (c) dangling `depends-on`/`supersedes` → nonexistent id; (d) a supersede
   cycle. **PASS:** the gate flags each planted defect by check-id with a
   remediation line, exits non-zero on each, and exits 0 on the clean set — one
   aggregate verdict. **FAIL:** any planted defect passes (false negative) or the
   clean set is flagged (false positive).

7. **The gate surfaces a REAL latent supersession the corpus carries in prose.**
   Using the stream-05 leads (e.g. `adr/027` retired hashes, `pdr/023`
   by-name-membership supersession, `adr/010` "supersedes lead-apk"), author the
   typed edges for one real prose-only supersession and show the gate would have
   caught its un-encoded state before authoring. **PASS:** at least one genuine
   corpus supersession is demonstrably encodable and gate-checkable, proving
   immediate (not hypothetical) value. **FAIL:** no real supersession maps onto
   the typed-edge model (would suggest the edge vocabulary is wrong).

8. **Advisory/blocking split behaves per ADR-047 D3.** Run `decisions check` in
   an "authoring" mode over a set with a known advisory-only issue (two active
   `tags`-sharing decisions) and in a "distribution/pour" mode over a set with a
   blocking issue. **PASS:** authoring mode WARNS and exits 0 on the advisory
   issue; distribution mode REFUSES and exits non-zero on the blocking issue;
   diagnosis is in `name (check-id) + status + remediation` form. **FAIL:**
   authoring hard-blocks (inverts author authorship) or distribution ships an
   incoherent digest.

9. **Determinism guard — NO model call anywhere in the generate/gate path.**
   Grep the prototype for any network/LLM/embedding call; run generation with
   network disabled. **PASS:** generation and the gate complete fully offline,
   proving self-hostable + reproducible (the REFUTED-branch tripwire from stream
   04 §6 — if the spike reaches for a vector store or summarizer, that's the
   over-build signal). **FAIL:** any generate/gate step needs the network or a
   model.

10. **CLI shape mirrors `scenarios` (verb-noun, stdin-or-file, generate/verify).**
    Confirm the prototype exposes `card|decision|full|list|index|check` as
    subcommands, each read subcommand accepting a path OR stdin, with the
    generate (`card`/`decision`/`full`/`index`) vs verify (`check`) split
    exit-coded like `hash`/`verify`. **PASS:** the surface is a clean sibling of
    the installed `scenarios {hash,verify,list,count,titles,tags}`. **FAIL:** the
    shape diverges enough that a BC couldn't graduate it alongside `scenarios`.

---

*End of stream 06. This synthesis + the 07 experiment results are the durable
findings the eventual PDR (authored separately, outside this workflow) will cite.
No PDR/ADR is authored here.*
