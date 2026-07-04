# 05 — Internal Grounding (research stream: `internal-grounding`)

**Date:** 2026-07-04
**Status:** COMPLETE — repo-grounded inventory of current metadata drift, the `scenarios` sibling-CLI surface to imitate, the ADR-047 coherence-gate precedent, and the nbx5/canonicalization single-source lesson. Verdict input for the L0/L1/L2 + generated-index + coherence-gate design.

This stream reads the ACTUAL repo (`/workspace`), not the web. Every claim cites `file:line` or a runnable command.

---

## 0. Sources consulted

- Metadata / frontmatter: `adr/*.md` (54 files present; ids 001–056 with gaps 003/007/044), `pdr/*.md` (30 files, 001–030), `briefs/*.md` (`briefs/`, NOT `brief/` — 15 files 001–015).
- Representative deep reads: `adr/018` (`:3-19`), `adr/035` (`:1-30`), `adr/047` (`:1-41`, `:115-230`), `adr/056` (`:1-25`), `pdr/016` (`:1-24`), `pdr/030` (`:1-25`).
- Sibling CLI: installed `scenarios` binary at `/usr/local/bin/scenarios` (`scenarios --help`, all six subcommand `--help`). Version banner: usage-only, no `--version`; `pip show shopsystem-scenarios` unavailable in this shell but `validate` is NOT a subcommand (installed surface = `{hash,verify,list,count,titles,tags}`).
- Coherence-gate precedent: `adr/047-system-version-manifest-bom-schema-release-wiring-and-coherence-gate-mechanics.md:175-230` (D3 split gate).
- Single-source lesson: `bd show lead-nbx5`; `.beads/issues.jsonl:324` (nbx5), `:329` (vglj round-trip), `:797` (agyy superseded); `adr/019`, `adr/043` titles.
- Tier terminology: `adr/035-three-tier-adr-hierarchy...md:1-30`.

---

## 1. Current metadata patterns — there is NO YAML frontmatter; two rival prose styles

**Finding 1a — zero YAML frontmatter exists today.** No file in `adr/`, `pdr/`, or `briefs/` opens with a `---` fenced block (checked: `head -1` of every file, none match `^---$`). All metadata is **markdown prose in the document body**, immediately under the H1. So the target schema (`id,title,status,description,decision,supersedes,superseded-by,depends-on,tags`) is a **greenfield add** — nothing to parse-migrate from an existing YAML convention; there IS a rich but inconsistent prose convention to normalize.

**Finding 1b — two mutually incompatible field syntaxes coexist.** Metadata fields are written either as bold-label lines `**Status:** ...` OR as dash-list lines `- Status: ...`:

- Bold style dominates ADRs: `**Status:**` ×42, `**Authors:**` ×41, `**Anchored to:**` ×39, `**Related beads:**` ×35, `**Pins:**` ×20 (grep of `^\*\*Label:\*\*`).
- Dash style is a large minority: `- Status:` ×11, `- Date:` ×11, `- Bead:` ×11, `- Implements:` ×9 (grep of `^- Label:`). `adr/047:3-6` is the canonical dash-style exemplar; `adr/018:3-19` the bold-style exemplar. A generator/parser must accept BOTH or the corpus splits.

**Finding 1c — `Status:` value drift.** Values seen: `accepted` (majority), `proposed` (2), `decided` (1, `adr/005`-era), `draft` (all PDRs use `draft`), plus one capitalized `Accepted`. Dates are inlined into the status string in many shapes: `accepted (2026-06-10)`, `accepted (2026-07-04, rev-2) — David approved...`, `accepted (ratified by dave, 2026-06-26, lead-kc0k); D2 artifact...`, `accepted (2026-06-09); D2 open... RESOLVED (2026-06-10)`. Status is NOT a clean enum today — it is a free-text sentence carrying status + date + ratifier + amendment history all in one line. A schema `status` enum + separate `date` field is a real normalization, not a rename.

**Finding 1d — relationship vocabulary is badly fragmented (the core drift the coherence gate needs fixed).** Across adr+pdr+briefs the "this decision relates to / builds on / replaces another" idea is spelled at least 18 different ways (union grep of bold+dash labels):

| Intent | Field spellings seen (counts across adr+pdr+briefs) |
|---|---|
| builds-on / depends-on | `Anchored to` ×74, `Anchored on` ×1, `Pins` ×21, `Implements` ×9, `Depends on` ×4, `Synthesizes` ×2, `Builds on` ×1, `Backed by` ×1, `Operationalizes` ×1, `Extends` ×1, `Graduates` ×1 |
| supersedes | `Supersedes` ×1, `Supersedes the trigger mechanism of` ×1, `Migrates to` ×1, `Amends` ×3 (some explicitly "does NOT supersede"), `Supplements / does not supersede` ×1 |
| references | `References` ×2, `Relates` ×2 |

`Anchored to` (74) + `Pins` (21) + `Implements` (9) are three names for what the target schema calls **`depends-on`**. `Anchored to` semantically = "decisions this builds on, NOT re-decided here" (`adr/047:8`, `adr/035:24` "Anchored on (PDR)"). `Pins` = "an ADR pins/realizes a PDR" (`adr/018:5`). `Implements` = the dash-style synonym of Pins (`adr/047:5`).

**Finding 1e — supersession is almost never a structured field; it lives in prose.** 75 occurrences of `supersed*` across adr+pdr, but exactly **1** is a top-level `**Supersedes:**` field. The rest are prose sentences ("supersedes lead-apk", `adr/010:12`; "supersedes the by-name membership mechanism", `pdr/023:9`; "998dc8df… are superseded and retired", `adr/027:63`) or scenario-hash-level supersession (`@supersedes:<hash>` tooling, `adr/027:90`). There is **NO `superseded-by` field anywhere** — the reverse pointer the schema wants (`superseded-by`) does not exist in the corpus at all. **Implication for the coherence gate:** it cannot rely on existing machine-readable supersede edges; those edges must be authored INTO the new frontmatter as a migration deliverable, and the gate's first value is catching the un-encoded supersessions already latent in prose.

**Finding 1f — `id` and `title` are regular enough to auto-extract; the separator is NOT.** Every ADR H1 is `# ADR-NNN <sep> <title>` and every PDR H1 is `# PDR-NNN <sep> <title>` (52/53 ADR, 29/30 PDR match `^# ADR-\d+`/`^# PDR-\d+`). BUT the separator drifts three ways: em-dash `—` (majority), ASCII double-hyphen `--` (`adr/050`–`055`), and colon `:` (`adr/005`). Filename is uniformly `NNN-slug.md`. So `id` = derivable from filename (most robust) OR H1; `title` = H1 after the separator, but a parser must tolerate `—|--|:`. There is **no `description` (one-line summary) field anywhere** — L0's one-liner does not exist yet and must be authored (the H1 title is the closest current proxy but is often a 3-line mega-sentence, e.g. `adr/056:1` runs ~180 words).

**Drift inventory summary (what the schema must absorb/normalize):**
- 2 field syntaxes (`**x:**` vs `- x:`) → pick one (YAML frontmatter dissolves both).
- `Status` free-text sentence → `status` enum + `date` + amendment-note fields.
- 18 relationship spellings → collapse to `depends-on` (was Anchored-to/Pins/Implements/…) + `supersedes` + `superseded-by`.
- Supersession is prose-only, `superseded-by` absent → migration must author the edges.
- No `description`, no `tags`, no `id` field → all three are net-new (id is derivable).

---

## 2. The `scenarios` sibling-CLI surface the `decisions` CLI must mirror

The installed tool is the precedent the epic names ("a CLI 'decisions' sibling to the installed 'scenarios' CLI"). Exact installed surface (`/usr/local/bin/scenarios --help`, 2026-07-04):

```
usage: scenarios [-h] {hash,verify,list,count,titles,tags} ...
  hash     canonicalize Gherkin from stdin and emit the scenario hash
  verify   check that a hash matches the canonical hash of Gherkin from stdin  (--hash HASH, reads stdin)
  list     list each scenario's title paired with its @scenario_hash value      ([file], stdin when omitted)
  count    print the number of scenarios in a feature file                       ([file], stdin when omitted)
  titles   print each scenario's title, one per line, in file order              ([file], stdin when omitted)
  tags     print the distinct @-tags across a feature file, one per line         ([file], stdin when omitted)
```

**Transferable CLI-shape conventions to imitate:**
1. **Verb-noun subcommand tree** under one binary (`scenarios <verb>`), not flags-on-one-command. `decisions` should mirror: `decisions list|card|decision|full|index|check`.
2. **stdin-OR-positional-file duality** — every read subcommand (`list/count/titles/tags`) takes an optional `[file]` and reads stdin when omitted. This is the unix-composable idiom the shop leans on (pipes into `shop-msg send`). `decisions` should accept an ADR/PDR path OR stdin.
3. **`hash` / `verify` split = generate vs check.** `hash` emits the canonical form; `verify --hash H` re-derives and compares, exit-coded. This is the **single-source pattern in miniature**: one canonicalizer, a verify that re-runs it. `decisions` L0/L1/L2 emitters are the `hash` analogue (generate the tier from the one source); the coherence gate is the `verify` analogue (re-derive + compare, exit-coded).
4. **Named projections over the same source** — `list` (title+hash), `titles`, `tags`, `count` are all thin projections of one parsed feature file. The `decisions` tiers L0/L1/L2 are exactly this: three projections of one frontmatter+body source. Same architectural move.
5. **Caveat — the installed CLI LAGS the ADRs.** `scenarios validate` and `scenarios ... --aggregate` are referenced as the design precedent in `adr/056` and `adr/047:71` ("scenario 218 … one aggregate verdict with nonzero exit") but are **NOT in the installed v0.3.x surface** (`scenarios validate` → `invalid choice`). So "mirror `scenarios --aggregate`" means mirror the DESIGN INTENT recorded in the ADRs, not a binary you can run today. The aggregate-nonzero-exit gate is a spec-level precedent, buildable, not yet built for scenarios either.

**Sibling-tool ownership note (ADR-018 constraint):** the eventual `decisions` CLI, like `scenarios`, is BUILT BY a BC and installed onto the lead host as a contract tool; the lead never carries its source. The lead consumes it exactly as it consumes `scenarios` today (`/usr/local/bin/`). Any experiment in this workflow that needs the tool must prototype it in the scratchpad, not commit BC source here.

---

## 3. ADR-047 coherence-gate precedent (the analogue the decision-coherence gate must follow)

`adr/047` D3 (`:175-230`) is the closest existing coherence-gate mechanic. Its shape, to be transferred:

**3a — Split posture: advisory vs blocking, gated by CONTEXT (`adr/047:190-205`).**
- **Authoring / dev-time = ADVISORY.** `bin/system-manifest validate` (+ a `bin/doctor` check) compares the manifest tuple to reality, WARNS on drift, but **exits 0**. Rationale (`:198-200`): a hard veto at authoring time "would invert the lead author's authorship of the tuple" — the author is deliberately allowed to be ahead of reality.
- **Adopter bootstrap / stand-up = BLOCKING.** The agent-less bootstrap (ADR-040) runs the same check as a stand-up step and, on incoherence, **refuses to proceed, exits non-zero** with a diagnostic naming the incoherent component, the pinned value, the observed value, and a remediation (`:200-205`).

**3b — Diagnosis surface reused, not reinvented (`adr/047:193-197`).** The warning rides the PDR-024 `bin/doctor` diagnosis format: `name (check-id) + pass/fail status + remediation hint`, folded into doctor's aggregate as a NON-FATAL line at dev-time. The gate is "an additive doctor check, not a re-design" (`:74`).

**3c — Aggregate-nonzero-exit is the pass/fail primitive (`adr/047:71`).** Many checks fold "into one aggregate verdict with nonzero exit on any failure" — this is the `scenarios ... --aggregate` sibling the epic names for the decision gate.

**3d — Compares a declared source against reality (`adr/047:205-230`).** The manifest (declared tuple) is compared against baked-image provenance (observed). For the DECISION gate the analogue is: the declared frontmatter edges (`supersedes`/`superseded-by`/`depends-on`/`status`) compared against COHERENCE RULES, e.g.:
- a doc with `status: accepted` that is the target of some other doc's `superseded-by` → contradiction (an active decision that something claims to have replaced).
- `supersedes: X` where X still has `status: accepted` and no reciprocal `superseded-by` → dangling/asymmetric supersede edge.
- two `accepted` docs with `depends-on` each other but contradictory decisions → the "contradictory active decisions" case the epic wants flagged.

**Transferable gate design for `decisions check`:** advisory (warn, exit 0) when a lead-architect is AUTHORING in the repo; blocking (exit non-zero) when the L1 digest is POURED/distributed to BCs (the "stand-up" analogue — you must not ship an incoherent digest to conforming BCs). Same split, same doctor-format diagnosis, same aggregate-nonzero primitive. **Note:** ADR-047's blocking leg lives in the deterministic bootstrap; our blocking leg lives at the L1-distribution boundary — pick that as the "stand-up-equivalent" hard gate.

---

## 4. The nbx5 single-source precedent + the scenario-hash / canonicalization drift lesson

**4a — What nbx5 actually is (`bd show lead-nbx5`; `.beads/issues.jsonl:324`).** Product directive (David, 2026-06-30): *"scenario hashing must be done in ONE place — the scenarios BC tool — so there is never confusion on how to do it."* The failure it fixes: `scenarios.hash.compute_scenario_hash` already centralized the CANONICALIZATION (strip whitespace, drop blanks + `@scenario_hash:` lines) but took RAW TEXT — so every CALLER did the BLOCK EXTRACTION (Scenario:→EOF, drop Feature/@lead_integration) by hand and did it DIFFERENTLY: lead-po used an awk-from-`@lead_integration` pipeline (over-included), the architect hashed the whole Feature-wrapped file (over-included differently) — **both wrong, producing hashes that don't reproduce.** Cost a full PO+architect round-trip (`lead-vglj`, `.beads/issues.jsonl:329`). Fix: the tool exposes ONE operation taking a FILE and owning the extraction so NO caller extracts by hand; all callers delegate.

**4b — The transferable lesson, stated as a rule.** Drift appears at the boundary where a shared artifact is RE-DERIVED by multiple consumers who each re-implement the derivation. Centralizing the CANONICALIZER is not enough if the EXTRACTION/PROJECTION step is left to callers — the drift just moves upstream to extraction. The fix is to own the WHOLE pipeline (extract → canonicalize → emit) behind one tool call. This is *exactly* the L0/L1/L2 risk: if L1 (decision-only digest) is hand-summarized by whoever pours it, it drifts from L2 the same way the awk-extracted hash drifted from the canonical hash. **Single-sourcing means the tiers are PROJECTIONS the tool computes from the one frontmatter+body source — never hand-authored summaries.** (This directly validates the epic's "no hand-maintained summaries" acceptance criterion.)

**4c — nbx5 also demonstrates the supersession-as-metadata pattern (`.beads/issues.jsonl:797`).** `lead-agyy` was closed as `close_reason: Closed` / "Superseded by lead-nbx5" — the bead registry records supersession as a structured close-reason + prose pointer. This is the *bead-level* analogue of the `superseded-by` field the ADR/PDR corpus lacks. Precedent that supersede edges ARE tracked structurally elsewhere in the shop (beads) — the ADR/PDR corpus is simply behind, which the frontmatter schema closes.

**4d — Related single-source ADRs to align with (titles).** `adr/043-single-source-of-truth-for-derived-bootstrap-coordinates.md` and `adr/019-canonicalization-ownership-in-scenarios-bc.md` are the doctrinal siblings: "derived state has ONE source; consumers read, never re-derive." The `decisions` tool + generated tiers/index sit squarely in this established doctrine class — this is NOT a novel architectural bet for the shop, it's applying an existing, repeatedly-ratified principle to a new artifact type.

---

## 5. Anti-patterns / overkill flags (repo-grounded)

- **`tier` terminology COLLISION — flag hard.** `**Tier:**` is ALREADY a live frontmatter field in 9 ADRs (`adr/056:9` "Tier: system-global"), meaning the ADR-035 three-tier GOVERNANCE hierarchy (framework / system-global / BC-local, `adr/035:1`). The epic's L0/L1/L2 are DISCLOSURE tiers — a different axis. If the new schema names a `tier` field for disclosure levels it will collide with the existing governance `tier`. **Recommendation: keep the existing `tier` field for governance; call disclosure levels "levels" (L0/L1/L2) and NEVER put a disclosure "tier" in frontmatter — disclosure level is a TOOL projection, not stored metadata.** (Storing the level in the doc would itself be a single-source violation.)
- **Don't over-engineer retrieval.** Corpus is ~54 ADR + 30 PDR + 15 brief + features/findings ≈ 100–120 decision docs. This is a `grep`/`awk`/small-index scale problem. The `scenarios` tool is plain argparse + a canonicalizer with NO index server, NO embeddings — and it's the right precedent. RAPTOR/GraphRAG/vector-RAG would be overkill for ~100 docs; a generated `llms.txt`/`index.md` + a linear coherence pass is proportionate.
- **Don't hard-block authoring.** ADR-047's rationale (`:198-200`) explicitly REJECTS a hard veto at authoring time (it inverts author authorship). The decision gate must be advisory in-repo, blocking only at the BC-distribution boundary. A blocking-everywhere gate would fight the corpus's own accepted doctrine.
- **Migration is real work, not a parse.** Because there's no YAML today and 18 relationship spellings + prose-only supersession, generating frontmatter is a per-doc authoring migration (esp. `description` and `superseded-by`, which don't exist). Don't assume a mechanical converter; budget an authored pass. Good news: `id`/`title`/`status`/`date` and the `## Decision` body anchor ARE mechanically extractable.

---

## 6. What this means for OUR L0/L1/L2 + generated-index + coherence-gate goals

- **L1 has a real, near-universal body anchor.** Every ADR has a `## Decision` H2 (52/53; `## Context` 49, `## Consequences` 48, `## Alternatives considered` 46, `## Cross-references` 26). 34 ADRs further use `### D1 —`/`### D2 —` numbered decision blocks. PDRs have `## Decision`(16)+`## The decision`(3) + `## Point of intent`(17). **So L1 (decision-only) can be GENERATED by extracting the `## Decision` section from the one source** — not hand-summarized. This is the strongest single enabler for the "no summary/full drift" goal: L2 = whole doc, L1 = the `## Decision` section verbatim, L0 = frontmatter `id`+`title`+`description`. Three projections, one source — the `scenarios list`/`titles`/`tags` pattern exactly.
- **The schema is greenfield frontmatter over a rich prose convention.** Adopt YAML frontmatter (dissolves the `**x:**` vs `- x:` split). Map the 18 relationship spellings: `Anchored-to`/`Anchored-on`/`Pins`/`Implements`/`Builds-on`/`Synthesizes`/`Backed-by`/`Operationalizes`/`Extends` → **`depends-on`**; `Supersedes`/`Migrates-to` → **`supersedes`**; add **`superseded-by`** (currently absent everywhere) as the gate's key edge. Keep `status` as an enum (`draft|proposed|accepted|superseded`) + separate `date`; preserve the existing governance **`tier`** field unchanged.
- **The coherence gate's first job is encoding what's already latent.** 75 prose `supersed*` mentions, only 1 structured field, 0 `superseded-by`. The gate + migration together surface supersessions the corpus has been carrying in prose (e.g. `adr/027`, `pdr/023`, `adr/020:196`, `adr/010`) — that's immediate value, not hypothetical.
- **Gate mechanics: copy ADR-047 D3 verbatim in shape.** Advisory (warn/exit-0) in-repo authoring; blocking (refuse/exit-nonzero) at the L1 BC-distribution boundary; diagnosis in the `bin/doctor` `name+status+remediation` format; fold into an aggregate-nonzero verdict (`decisions check --aggregate`). Coherence rules to check: dangling/asymmetric supersede edges, `accepted` docs that are some other doc's `superseded-by` target, `depends-on` pointing at a `superseded`/nonexistent id.
- **CLI to build (BC-owned, ADR-018): `decisions`** mirroring `scenarios`' verb-noun + stdin-or-file + generate/verify split: `decisions card|decision|full <file|->` (the L0/L1/L2 emitters, = `scenarios hash` role), `decisions list` (all ids+titles+status = `scenarios list`), `decisions index` (emit `llms.txt`/`index.md` from the corpus), `decisions check [--aggregate]` (the coherence gate, = `scenarios verify` + `--aggregate` role). Note the installed `scenarios` has NO `validate`/`--aggregate` yet — imitate the ADR-recorded intent, and the two tools can co-graduate that aggregate surface.
- **This is in-doctrine, low-novelty.** ADR-019/043 (single-source of derived state) + nbx5 (own the whole projection pipeline, not just the canonicalizer) + ADR-047 (split coherence gate) mean every mechanism the epic needs already has a ratified precedent in THIS repo. The design is application of settled shop doctrine to a new artifact type — argues for CONFIRM / go-with-caveats, with the only real cost being the authored frontmatter migration (no YAML exists; `description` and `superseded-by` are net-new per-doc authoring).
