# 08 — Recommendation: implementation path, owning BC, and thin-slice decomposition

**Research stream:** recommendation / close-out (epic lead-x7bp, progressive-disclosure)
**Date:** 2026-07-04
**Status:** COMPLETE — the durable close-out of the progressive-disclosure
research initiative. Consumes [06-synthesis](06-synthesis.md) (picked direction)
and [07-experiment](07-experiment.md) (10/10 PASS on the real corpus), grounded in
[05-internal-grounding](05-internal-grounding.md) (repo precedent + BC surface).
**Protocol:** fabro-style (PDR-016) — research → notes → synthesis (06) →
experiment (07) → **recommend (this doc)**. No PDR/ADR authored here; this is
durable findings. The **no-PDR-before-finding rule is now satisfied** — this
finding + its verdict are the durable artifact the eventual PDR must cite.

---

## 1. VERDICT

**CONFIRM** — the epic lead-x7bp goals are achievable as designed.

Grounded in the experiment's measured results (07 §3, 10/10 goals PASS on the
REAL corpus, zero model calls):

- **Single source, no drift (the core claim):** identical source → byte-identical
  L0/L1/index/digest across runs, matching sha256, hashable exactly like
  `scenarios hash`; a one-field `description` edit propagated to exactly one index
  line and nothing else (Goal 5).
- **L1 is EXTRACTED, never summarized:** a non-empty `## Decision` block extracted
  for 15/15 ADRs = 100%, with clean PDR fallback (`## Point of intent` /
  `## The decisions`) — so the "no summary/full drift" property is structural, not
  aspirational (Goals 2, 9).
- **Right-sized for the corpus:** L0 index ≈ 8.3K tokens; the L1 digest of all 93
  active decisions ≈ 72.5K tokens = 36% of Anthropic's 200K load-whole threshold —
  load the digest WHOLE, no retriever, no embeddings (Goal 4). Every advanced-RAG
  branch (RAPTOR / GraphRAG / vector store / live server) stayed correctly unbuilt;
  the Goal-9 over-build tripwire never fired.
- **The coherence gate delivers immediate, non-hypothetical value:** the
  deterministic typed-edge pass flagged a GENUINE latent supersession the live repo
  carries only in prose — ADR-025 supersedes ADR-023 and ADR-024, yet neither
  target carries `superseded-by` and both remain `accepted` (Goal 7). It caught all
  four planted defects with zero false positives on the clean set (Goal 6), and the
  ADR-047-D3 advisory/blocking split behaves correctly (Goal 8).
- **The build shape is in-doctrine, low-novelty:** a single BC-owned `decisions`
  CLI whose surface graphs cleanly onto `scenarios`' verb-noun + stdin-or-file +
  generate/verify split (Goal 10). Every mechanism has a ratified in-repo precedent
  (ADR-019/043 single-source, nbx5 own-the-whole-projection, ADR-047 split gate).

**go-with-caveats — on ONE thing only: the frontmatter-backfill migration.** The
corpus today has ZERO YAML frontmatter, 18 relationship spellings, prose-only
supersession, no `description`/`superseded-by`/`id` fields. The spike de-risked
this but proved it is the sole real cost and surfaced three concrete hazards that
mandate a **human-reviewed, gate-verified migration** rather than a blind script
(07 §4):

1. **Multi-line prose supersede edges** — a naive line-by-line harvester silently
   caught only the first-named target (under-extraction).
2. **Irregular field-label boundaries** (parenthetical labels) — an over-reaching
   harvester mis-typed a `depends-on` pin as a `supersedes` edge (a false edge that
   would trip the gate — the more dangerous direction).
3. **Status vocabulary wider than the proposed enum** — the corpus uses `decided`
   (×3) and `ready` (×1) beyond `draft|proposed|accepted|rejected|deprecated|
   superseded`; 4 active docs were wrongly demoted before reconciliation.

**REFUTED (unbuilt and unneeded):** every LLM-in-loop / embedding / clustering /
live-server mechanism. At ~97 decision docs this is a `grep`/small-index scale
problem; any retriever machinery is both overkill and a determinism/drift leak.

---

## 2. RECOMMENDED IMPLEMENTATION PATH (ordered, lead-shop discipline)

The no-PDR-before-finding gate is now cleared (this finding exists). The path
honors PO-authors-intent-first (§3 of the shop spec) and ADR-018 (the CLI is
BUILT BY a BC; no BC source on the lead host).

1. **[DONE] Research finding + verdict** — streams 01–07 + this recommendation.
   CONFIRM / go-with-caveats-on-migration. This is the durable input the PDR cites.
2. **lead-po authors Gherkin scenarios pinning each behavior** — one scenario set
   per vertical slice in §4. Scenarios are authored BEFORE the PDR (intent-first);
   they pin the frontmatter conformance, the L0/L1/L2 projections, the
   determinism/idempotence property, the index/digest generation, the coherence
   gate (advisory/blocking split), and the distribution boundary. These are the
   canonical scenarios that will later be dispatched to the owning BC via
   `assign_scenarios`.
3. **PDR formalizes the intent** — the required frontmatter schema
   (`id,title,status,description,decision,supersedes,superseded-by,depends-on,tags`
   + `date`), the L0/L1/L2 disclosure levels as TOOL PROJECTIONS (never stored
   fields — the `tier` collision, 05 §5), single-sourcing as the anti-drift
   principle, and the coherence-gate posture. Cites this finding + 06 + 07.
4. **ADR realizes the mechanics** — deterministic projection (parse frontmatter+
   body → three emitters, model-free), the typed-edge coherence gate in the
   ADR-047-D3 advisory/blocking shape, the `decisions` CLI surface as a
   `scenarios` sibling, and the L1-distribution boundary as the blocking gate. Pins
   the PDR.
5. **The owning BC builds the `decisions` CLI** (§3) — dispatched via
   `assign_scenarios` (new capability). Surface:
   `decisions card|decision|full <file|->` (L0/L1/L2 emitters, = `hash` role),
   `decisions list <dir>`, `decisions index <dir> [--json]` (llms.txt + index.json),
   `decisions digest <dir>` (L1 active-only pour), `decisions check <dir> --mode
   {authoring,distribution} [--aggregate]` (the gate, = `verify` role), and
   `decisions backfill <file>` (migration helper). Installed to the lead host like
   `scenarios`.
6. **Frontmatter backfill migration** — the go-with-caveats work. A human-reviewed,
   `decisions backfill` + `decisions check`-guided pass over the ~97 docs: author
   the net-new `description` L0 one-liner per doc, human-confirm every harvested
   supersede edge, write the currently-absent `superseded-by` back-edges, flip
   superseded docs' status, and reconcile the status vocabulary. Not a
   script-and-forget.
7. **L1 distribution to BCs** — the skills-style pour of the generated
   `DECISIONS.md` L1 digest as the default ambient channel, with `shop-msg send` as
   the complementary work-specific targeted channel. The distribution boundary runs
   `decisions check --mode distribution` as a BLOCKING gate — never pour an
   incoherent digest to conforming BCs.
8. **Authoring gate wired into lead-po/lead-architect prompts** — "consult the
   decision index (L0) / run `decisions check` before authoring a new decision"
   becomes a named pre-authoring item, satisfying the epic's final acceptance
   criterion.

---

## 3. WHICH BC OWNS THE `decisions` CLI

**Recommendation: `shopsystem-scenarios`.**

Rationale, grounded in 05-internal-grounding:

- **It already owns the sibling the CLI mirrors.** The `decisions` surface is the
  `scenarios {hash,verify,list,…}` pattern applied to a new artifact type: one
  parse of a single source, deterministic named projections, an exit-coded verify
  gate. Same verb-noun + stdin-or-file + generate/verify architecture (05 §2). A BC
  that owns `scenarios` graduates `decisions` alongside it with maximal machinery
  reuse.
- **The single-source doctrine already LIVES in this BC.** ADR-019
  (canonicalization-ownership-in-scenarios-bc) and the nbx5 product directive
  ("scenario hashing must be done in ONE place — the scenarios BC tool") make
  shopsystem-scenarios the home of "own the whole extract→canonicalize→emit
  pipeline behind one tool call so no caller re-derives" (05 §4). The decisions
  tiers are exactly that pattern; putting them anywhere else re-opens the drift
  boundary the doctrine closed.
- **Co-graduation of the `--aggregate` surface.** Both `scenarios` and `decisions`
  want the aggregate-nonzero-exit gate that the ADRs record as intent but the
  installed `scenarios` v0.3.x does not yet ship (05 §2 caveat, 05 §3c). Building it
  once, in the BC that owns both, is efficient and keeps the two gates
  shape-identical.
- **It is a LIVE domain BC** (bc-manifest.yaml: the four live bcs are messaging,
  scenarios, templates, bc-launcher). shopsystem-docs is NOT a live owner — it does
  not appear in the manifest's `bcs:` set. Standing up a new `shopsystem-decisions`
  BC for ~97 docs of the same tooling class would be BC-bloat against a BC whose
  bounded context is already "canonicalize-and-verify a decision-bearing artifact."

**Caveat (flagged to the operator, §6 Q1):** a strict DDD reading could argue the
scenarios BC's bounded context is *Gherkin* canonicalization, and decision-doc
governance is a distinct context. The pragmatic, precedent-grounded call is
shopsystem-scenarios; if the DDD review (lead-bh2m) rules the boundary is
per-artifact-type, a `shopsystem-decisions` BC is the fallback. This is a genuine
decomposition judgment, not a router-operational default.

---

## 4. THIN-SLICE DECOMPOSITION (vertical slices, one behavior each)

Each slice pins ONE coherent behavior (work-splitting doctrine) and maps to one
scenario set → one child bead. Ordered so each unblocks the next.

- **S1 — Frontmatter schema conformance.** `decisions` validates a doc's
  frontmatter against the required-field set + `status` enum + well-formed typed
  edges; conforming passes, missing/malformed fails with a named diagnosis.
- **S2 — L0 card projection.** `decisions card <file|->` emits
  `{id,title,status,description,path}` — the relevance-triage tier.
- **S3 — L1 decision projection.** `decisions decision <file|->` EXTRACTS the
  `## Decision` section verbatim (doc-type fallback list) + rides
  `status`/`supersedes`/`superseded-by` inline. Never summarizes; `decision:`
  stays empty in frontmatter so the text has exactly one home.
- **S4 — L2 full passthrough.** `decisions full <file|->` emits the whole doc.
- **S5 — L0 index generation.** `decisions index <dir>` emits the llms.txt-style
  markdown index (H1 + blockquote + H2 group sections + `## Optional` band) and a
  parallel `index.json` from the same source.
- **S6 — L1 digest generation.** `decisions digest <dir>` emits the active-only
  `DECISIONS.md` L1 digest for the BC pour; each entry self-contained
  (carries its own `status`+`supersedes`).
- **S7 — Determinism / anti-drift property.** Identical source → byte-identical,
  sha256-stable output; a single-field edit propagates to exactly the affected
  lines. The hash/verify anti-drift core claim, exit-coded like `scenarios verify`.
- **S8 — Coherence gate: typed-edge checks.** `decisions check <dir>` runs the
  deterministic graph pass: asymmetric-supersede, active-yet-superseded,
  dangling-edge, supersede-cycle — each flagged by check-id + remediation, folded
  into one aggregate-nonzero verdict.
- **S9 — Coherence gate: advisory/blocking split.** `--mode {authoring,
  distribution}`: authoring WARNs + exits 0 (never inverts author authorship);
  distribution vetoes blocking-severity findings (exit non-zero), advisory-severity
  still only warns. ADR-047 D3 shape.
- **S10 — Backfill migration helper.** `decisions backfill <file>` drafts
  frontmatter from prose (id from H1 validated against filename; block-aware,
  label-boundary-safe edge harvest) — flags every harvested edge and the net-new
  `description` for human review. The go-with-caveats slice.
- **S11 — L1 distribution / pour.** The generated `DECISIONS.md` L1 digest poured
  to BC context (skills-style) + `shop-msg send` targeted channel; distribution
  gated by S9 blocking check.
- **S12 — Authoring-consult gate.** lead-po/lead-architect prompts carry a
  "consult the decision index / run `decisions check` before authoring" pre-step.

S1–S9 are the CLI build (owning BC); S10 is a CLI slice that also drives the
migration; S11–S12 are lead-shop wiring consuming the built tool.

---

## 5. PHASE-2 GRADUATION REQUIREMENTS (what must be true to dispatch)

Before dispatching build work to the owning BC:

1. **This finding is operator-reviewed** and the CONFIRM / go-with-caveats verdict
   accepted (the epic note forbids authoring until the 08 verdict is reviewed).
2. **lead-po scenario sets for S1–S9 are authored and coherence-checked** — the
   canonical scenarios that `assign_scenarios` will carry. Intent precedes build.
3. **The PDR (schema + levels-as-projections + gate posture) and the ADR
   (mechanics + CLI surface + distribution boundary) are authored and accepted**,
   pinning the scenarios.
4. **The status-vocabulary reconciliation is decided** (operator Q2) — the
   canonical `status` enum and the mapping for `decided`/`ready` must be fixed
   before the active/retired partition (hence digest membership and the
   active-yet-superseded check) can be correct.
5. **The owning-BC boundary is confirmed** (operator Q1) — scenarios BC vs a new
   decisions BC — so `assign_scenarios` addresses the right mailbox.
6. **The migration is scoped as a distinct, human-in-the-loop deliverable** (its
   own bead), NOT folded into the CLI build — the CLI ships first, then the
   `backfill`+`check`-guided authored migration runs against it.
7. **Scratch teardown confirmed** — the 07 prototype is disposable (ADR-030); the
   BC implements fresh from findings, nothing in scratch is load-bearing.

---

## 6. OPEN QUESTIONS FOR THE OPERATOR (minimal; genuine scope/vocabulary)

- **Q1 — BC boundary.** Does the `decisions` CLI live inside `shopsystem-scenarios`
  (recommended, on precedent) or a new `shopsystem-decisions` BC? A genuine DDD
  decomposition call; overlaps the DDD review lead-bh2m.
- **Q2 — Status vocabulary.** The real corpus uses `decided` (×3) and `ready` (×1)
  beyond the proposed `draft|proposed|accepted|rejected|deprecated|superseded`
  enum. What is the canonical mapping — `decided`→`accepted`, and where does `ready`
  land? Product vocabulary the migration cannot proceed without.
- **Q3 — Corpus scope.** The epic title names ADR/PDR/brief; the initiative also
  names `features/` and `findings/`. Does progressive disclosure cover
  features/findings in phase 2, or is it scoped to adr/pdr/briefs first with
  features/findings deferred? A scope call that sizes the migration.

---

*End of stream 08. This recommendation + 06 + 07 are the durable findings the
eventual PDR (authored separately, PO-first, outside this workflow) will cite. No
PDR/ADR is authored here.*
