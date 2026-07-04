# 07 — Experiment: throwaway `decisions` spike validating the progressive-disclosure design on real repo ADRs

**Research stream:** experiment / spike (epic lead-x7bp, progressive-disclosure)
**Date:** 2026-07-04
**Status:** COMPLETE — the smallest throwaway prototype that validates the
[06-synthesis](06-synthesis.md) direction against REAL repo ADRs/PDRs/briefs.
**Protocol:** fabro-style (PDR-016) — research → notes → synthesize (06) →
**experiment (this doc)** → recommend. No PDR/ADR authored here.
**Isolation contract (ADR-030):** ALL prototype code lived in the disposable
scratch dir
`…/scratchpad/pd-experiment/`. Nothing committed; no code written outside scratch;
the only durable output is this findings file. **Scratch is disposable — tear it
down; nothing in it is load-bearing.**

---

## 0. One-sentence result

**Every one of the 10 synthesis goals PASSED on the real corpus.** A ~330-line
stdlib+PyYAML `decisions` prototype single-sources L0/L1/L2 + index + digest from
per-doc YAML frontmatter, regenerates byte-identically (hashable), and a
deterministic typed-edge gate catches a **genuine latent supersession the live
corpus carries only in prose** (ADR-025 supersedes ADR-023/024, both still
active). **Verdict: CONFIRM** the design; **go-with-caveats** on the frontmatter
backfill, which the spike de-risked but also proved is the sole real cost — it
surfaced three concrete backfill hazards (multi-line prose edge blocks,
parenthetical field-label boundaries, and an incomplete status enum) that a
naive migration would get wrong.

---

## 1. What I built

A single throwaway file `decisions.py` (~330 lines, `import`s: `sys os re
hashlib argparse glob json yaml` — nothing else). It is a verb-noun CLI shaped as
a sibling of the installed `scenarios {hash,verify,list,…}`:

| verb | tier / role | analogue in `scenarios` |
|---|---|---|
| `decisions card <file\|->` | **L0** — `{id,title,status,description,path}` JSON | `hash` (generate) |
| `decisions decision <file\|->` | **L1** — extract the `## Decision` section verbatim + status/edges | `hash` (generate) |
| `decisions full <file\|->` | **L2** — the whole doc | — |
| `decisions list <dir>` | all `id\tstatus\ttitle` | `list` |
| `decisions index <dir> [--json]` | llms.txt-style L0 index (+ `index.json`) | — |
| `decisions digest <dir>` | L1 decisions digest (active only) for BC pour | — |
| `decisions check <dir> --mode {authoring,distribution} [--aggregate]` | coherence gate | `verify` (exit-coded) |
| `decisions backfill <file>` | migration helper: prepend generated frontmatter | (one-time) |

**Single source = per-doc YAML frontmatter + the doc body.** The three tiers are
pure projections: L0 projects frontmatter fields; **L1 EXTRACTS the `## Decision`
section verbatim (never summarizes)** with a doc-type fallback list
(`## Decision → ## The decisions → ## The decision → ## Point of intent`); L2 is
the file. `decision:` is deliberately kept EMPTY in frontmatter — the decision
text has exactly one home, the body — so no summary/full drift is possible.

**Sample:** 19 real docs copied into `scratch/sample/` (15 ADRs incl. the full
supersede chains 023→025←024, the 009←010/027 amends cluster, 028←046, 036←042,
plus statuses accepted/proposed/draft and BOTH frontmatter styles; + PDR-011/016/030
and Brief-001 for cross-type coverage). Whole-corpus measurements (Goals 4/status
vocab) ran over ALL 97 real docs (`/workspace/{adr,pdr,briefs}`, permitted reads
— they are the contract surface, ADR-018).

---

## 2. Commands run (reproducible in scratch)

```
# backfill real prose headers -> frontmatter copies (scratch only)
for f in sample/*.md; do python3 decisions.py backfill "$f" > sample_fm/$(basename "$f"); done

# tiers + index + digest, twice, hash-compared (determinism)
python3 decisions.py index  sample_fm | sha256sum   # run1 == run2
python3 decisions.py digest sample_fm | sha256sum

# gate: clean set, four planted defects, real corpus
python3 decisions.py check gate_clean --mode distribution   # exit 0
python3 decisions.py check gate_a2   --mode distribution     # asymmetric  -> exit 1
python3 decisions.py check sample_fm --mode distribution     # REAL latent -> exit 1

# offline determinism proof (all sockets blocked) — generate+gate succeed
python3 -c "import socket; socket.socket=<blocked>; …emit_index/emit_digest/gate…"
```

---

## 3. Goal-by-goal results (all measured on real docs)

| # | Goal (from 06 §3) | Result | Evidence (measured) |
|---|---|---|---|
| 1 | Frontmatter round-trips existing docs without loss | **PASS** | id/title/status/date extracted correctly for **19/19 = 100%** of the sample (target ≥90%), spanning ADR+PDR+Brief, both `**Status:**` and `- Status:` styles, em-dash titles. Body below frontmatter **byte-identical for 19/19** (modulo the one conventional blank-line separator). Negation handled: ADR-010/027 "*does not supersede*" correctly yield NO edge. |
| 2 | `## Decision` extraction yields usable L1 for every ADR | **PASS** | Non-empty decision block for **15/15 ADRs = 100%** (anchor `## Decision` in every one). PDR fallback works: PDR-011→`## Decision`, PDR-016→`## Point of intent`, PDR-030→`## The decisions`. No per-doc hand-tuning. |
| 3 | L1 materially smaller than L2 (tokens) | **PASS** | Over the 15 ADRs (proxy = chars/4): **median L1/L2 = 32.5%**, mean 35.7% (target median ≤35%). Tail noted: decision-heavy docs (ADR-043 60%, ADR-056 58%, ADR-028 47%) where the `## Decision` section legitimately IS most of the doc — not extractor over-inclusion. |
| 4 | Whole-corpus L0 index + L1 digest fit in-context (no retriever) | **PASS** | Real 97-doc corpus (53 ADR + 29 PDR + 15 Brief): **L0 index ≈ 8,323 tokens** (target ≤15K). **L1 digest of ALL 93 active decisions (extracted verbatim) ≈ 72,496 tokens = 36.2% of Anthropic's 200K load-whole threshold.** Load whole, skip retrieval — the green light for the skills-style pour. |
| 5 | Tiers regenerate identically — no drift (core claim) | **PASS** | Identical source → **byte-identical output, matching sha256** for both index and digest across two runs. Editing ONE `description` field regenerated **exactly 1 changed index line** (the edited doc's row), nothing else. Idempotent + hashable like `scenarios hash`. |
| 6 | Gate flags planted defects, passes clean set | **PASS** | Clean set exits 0. Each planted defect flagged by check-id + remediation, exit 1: **(a) asymmetric-supersede**, **(b) active-yet-superseded**, **(c) dangling-edge**, **(d) supersede-cycle** (`ADR-201 → ADR-202 → ADR-201`). Zero false positives on clean; zero false negatives on defects. |
| 7 | Gate surfaces a REAL latent supersession the corpus carries in prose | **PASS** | Run over the backfilled real corpus, the gate flags **ADR-025 supersedes ADR-023 and ADR-024, but neither target carries `superseded-by` and both are still active** — a genuine inconsistency the live repo holds only in ADR-025's prose. Immediate, non-hypothetical value. Corroborated: **0 docs corpus-wide are spelled `status: superseded`** despite real supersessions existing. |
| 8 | Advisory/blocking split per ADR-047 D3 | **PASS** | **Authoring** WARNs and exits 0 on both advisory AND blocking findings (never inverts author authorship). **Distribution/pour** exits 1 on blocking-severity findings, and WARNs-but-exits-0 on advisory-only (a "please-confirm" coactive-shared-tag must not over-block the pour). Diagnosis in `name (check-id) + status + remediation` form, folded into one aggregate verdict. |
| 9 | No model call anywhere in generate/gate path | **PASS** | Imports = stdlib + PyYAML only; grep for `requests/urllib/http/openai/anthropic/embed/vector/faiss/gpt/gemini/torch` → **none**. Full generate + gate ran to success with **all sockets hard-blocked**. Self-hostable + reproducible. |
| 10 | CLI shape mirrors `scenarios` (verb-noun, stdin-or-file, generate/verify) | **PASS** | Subcommands `card\|decision\|full\|list\|index\|digest\|check`; `card/decision/full` accept a path OR `-` (stdin) — verified both; `check` is the exit-coded verify sibling. Clean sibling of `scenarios {hash,verify,list,count,titles,tags}` — a BC could graduate it alongside. |

**Score: 10 / 10 PASS.**

---

## 4. Surprises & new hazards (the fabro "unconditional-edge" analogue)

The spike's real payload is three concrete backfill hazards the design docs did
not fully anticipate. All three live in the **frontmatter-backfill migration** —
confirming the synthesis's call that migration is the sole real cost — and all
three are reasons the backfill must be **draft-then-human-review, never fully
automatic**:

1. **Prose supersede edges span MULTIPLE physical lines.** ADR-025's
   `**Supersedes:**` block names ADR-023 on its first line and ADR-024 three
   lines down. A naive line-by-line harvester silently caught only ADR-023 —
   an under-extraction that would have shipped a half-encoded supersede. Fixed by
   making the harvester block-aware (consume continuation lines until the next
   field label).

2. **Field-label boundaries are irregular (parenthetical labels).** The
   block-aware harvester then OVER-reached: it ran past
   `**Pins (the contract surface this rests on):**` and mis-harvested ADR-019
   (a *depends-on* pin) as a *supersedes* edge — because the boundary regex
   didn't expect a parenthetical inside the bold label. This is the more
   dangerous direction (a false supersede edge that would trip the gate).
   Fixed by matching any `**…:**` label. **Lesson: the 18 relationship spellings
   stream 05 flagged are real, and edge backfill cannot be trusted without a
   human confirming each harvested edge.**

3. **The status vocabulary is WIDER than the proposed 6-value enum.** The real
   corpus uses `accepted`(54), `draft`(35), `proposed`(4), **`decided`(3)**,
   **`ready`(1)** — and `decided`/`ready` are NOT in the synthesis's
   `draft|proposed|accepted|rejected|deprecated|superseded` enum. Result: 4
   active docs (ADR-006, Brief-007, PDR-007, PDR-009) were wrongly demoted into
   the index's `## Optional`/retired band because the ACTIVE partition didn't
   recognize their status. This is the **status analogue of the spelling
   problem**: the migration must reconcile the actual status vocabulary
   (map `decided`→`accepted`, decide where `ready` lands) BEFORE the
   active/retired partition — and therefore the digest membership and the
   gate's active-yet-superseded check — is correct.

Two smaller notes:
- **id is more robustly derived from the H1 than the filename.** The filename
  carries only the number, not the ADR/PDR/Brief type (the type is the parent
  dir, lost if you ever flatten). The H1 (`# ADR-018 —`, `# Brief 001 —`) carries
  the full canonical id; deriving `id` from the H1 (validating against the
  filename number) is the safer single-source. A refinement to the synthesis's
  "id filename-derived."
- **The advisory/blocking exit semantics needed sharpening.** My first cut
  blocked the pour on advisory-only findings, which inverts the advisory/blocking
  distinction. The principled ADR-047 D3 mapping (adopted): authoring = all
  advisory (exit 0); distribution = blocking-severity vetoes (exit 1),
  advisory-severity still only warns. An unconfirmed "please confirm" must not
  over-block a pour.

---

## 5. What this de-risks for the eventual PDR/ADR (authored elsewhere)

- The **deterministic-projection + typed-edge-gate** design is not just
  plausible, it is *demonstrated* on the real corpus with zero model calls, zero
  drift, and immediate latent-defect value. Every REFUTED branch (RAPTOR /
  GraphRAG / embeddings / live server) stayed correctly unbuilt — the spike never
  needed them (Goal 9 tripwire never fired).
- The **single BC-owned `decisions` CLI** (built by a BC, installed like
  `scenarios`, ADR-018) is the right build shape; the surface graphs cleanly onto
  the existing `scenarios` generate/verify split.
- The **migration is the work.** Budget it as: (i) author the net-new
  `description` L0 one-liner per doc (no source field exists — every backfill
  flagged `description-net-new-required`); (ii) human-review every harvested
  supersede edge (hazards 1–2); (iii) reconcile the status vocabulary (hazard 3)
  and write the currently-absent `superseded-by` back-edges + flip superseded
  docs' status. The `decisions backfill` + `decisions check` pair makes this a
  guided, gate-verified migration rather than a hand edit — but it is a
  human-in-the-loop pass, not a script-and-forget.

---

## 6. Verdict

**CONFIRM** the 06-synthesis design end to end — all 10 goals PASS on real
docs.
**go-with-caveats** on the frontmatter-backfill migration: de-risked here, but
the spike proved it carries three real hazards (multi-line edge blocks,
parenthetical field boundaries, an under-spec'd status enum) that mandate a
human-reviewed, gate-verified migration pass rather than a blind script.
**REFUTED** (unbuilt and unneeded): every LLM-in-loop / embedding / clustering /
live-server mechanism.

---

## 7. Teardown

The prototype lives entirely in the disposable scratch dir
`…/scratchpad/pd-experiment/` (`decisions.py`, `sample/`, `sample_fm/`,
`realall/`, `gate_*`/`out/`). None of it is committed or referenced by anything
in `/workspace`. It is safe to delete; this findings file is the durable record.
Per ADR-030 the spike code is thrown away — the eventual implementation is
authored fresh, by a BC, from this findings doc and 06-synthesis.

*End of stream 07.*
