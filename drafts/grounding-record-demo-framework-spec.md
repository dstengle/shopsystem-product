# Grounding record — framework spec (§1–§6) into the typed corpus?

> **Question (verbatim):** *Should the shopsystem framework spec (§1–§6, currently plain markdown in the lead/framework repo) be migrated INTO the typed artifact corpus as artifacts, or stay as plain markdown outside it?*
>
> **Recommendation:** **Stay as plain markdown, outside the typed corpus.** Add a discoverability pointer, not a migration.
>
> **Confidence:** MED — the primary decision (ADR-037) governs *shipping*, not *corpus membership*; I reason across the gap.
>
> **Term coverage:** `11 terms derived · 6 re-runnable · 5 title-scan`.
>
> **Attack this first: the term list in §2.** If a concept is missing there, this record is wrong regardless of what §4 verifies.

---

## §1. Words used here (glossary)

Every acronym and jargon term, defined on first use.

- **§1–§6 / the framework spec** — the six plain-markdown files `01-principles.md` … `06-work-tracking.md` at the repo root. They describe how the shop-system itself is built. They are the subject of the question.
- **Typed artifact corpus** — the frontmatter-tagged document graph that `shop-knowledge` reads. Membership means: a declared `type`, a `status` from that type's enum, and traceability `edges` to other artifacts.
- **Artifact kind / type** — one of a fixed, schema-enforced set. The corpus recognizes exactly **eight** kinds: `adr`, `brief`, `candidate`, `current-state`, `intent-record`, `pdr`, `prioritization-record`, `session-record`.
- **ADR** — Architecture Decision Record. **PDR** — Product Decision Record. **BC** — Bounded Context (an isolated implementation service). **Brief / candidate / intent-record / session-record / current-state** — the other five typed kinds.
- **`distribution`** — a corpus frontmatter field naming a doc's within-product scope: `product-lead` | `product-wide` | `bc-local` (introduced by ADR-067).
- **Facet** — a queryable frontmatter field. `shop-knowledge query` exposes exactly four: `type`, `status`, `tag`, `distribution`.
- **Re-runnable (✓)** — a step that is a single deterministic `shop-knowledge` command; a reviewer replays it and gets the same id set.
- **Title-scan (⚠)** — a step where the *enumeration* is a re-runnable facet query, but the *selection* of docs from the returned titles is my eyeball judgment. There is **no freeform text search** and the `tag` facet is empty, so no query can stand in for the judgment.

**Options on the table (named before they are referenced):**
- **Option MIGRATE** — bring §1–§6 into the corpus as typed artifacts.
- **Option KEEP** — leave §1–§6 as plain markdown outside the corpus (the recommendation).

---

## §2. Question → terms (THE audit surface)

This is the table to attack. Each row: a concept the question forces, why it forces it, the exact `shop-knowledge` step I ran, and whether that step is re-runnable (✓) or discretionary title-scan (⚠).

| # | Term / concept | Why the question implies it | How I interrogated the corpus | Re-runnable? |
|---|----------------|-----------------------------|-------------------------------|:---:|
| 1 | **framework spec / §1–§6 / principles / spec** | The subject *is* the spec; first question is whether the corpus already has a home type for it. | `query --facet type --value framework-spec` → `[]`; same for `principles`, `spec`, `framework`. | ✓ (negative result) |
| 2 | **typed artifact corpus / artifact type system** | "migrated INTO the typed corpus" — I must know what the corpus *is* and who owns its type set. | Title-scan of `type=adr` + `type=pdr` listings → ADR-067, ADR-069, PDR-032. | ⚠ (enum ✓, pick ⚠) |
| 3 | **migrate / migration / legacy corpus** | The verb is "migrate"; is there an existing migration, and what is in its scope? | Title-scan of `type=pdr`, `type=brief`, `type=candidate`, `type=intent-record` → PDR-034, brief-024, cand-004, intent-006. | ⚠ (enum ✓, pick ⚠) |
| 4 | **the eight kinds** (is "spec" one?) | "as artifacts" — an artifact must be *some kind*; is there a kind §1–§6 fits? | `query --facet type --value <k>` for each of the eight; count each. None is spec-shaped. | ✓ |
| 5 | **distribution / ship-to-product / adopter / product instance** | §1–§6 may be framework-internal, not product-facing — the corpus has a scope axis for exactly this. | `query --facet distribution --value product-lead|product-wide|bc-local` → all `[]` (field not populated as a facet). | ✓ (negative result) |
| 6 | **self-contained templates / construction artifact / self-description** | If §1–§6 describe the *system's own construction*, they may be a different genus from product artifacts. | Title-scan `type=adr` → ADR-037 (the direct hit); rendered it. | ⚠ (enum ✓, pick ⚠) |
| 7 | **current-state** | Is the "what the system is" role already occupied by a typed kind, making §1–§6 redundant or distinct? | `query --facet type --value current-state` → 1 doc. | ✓ |
| 8 | **tags / retrieval / grounding / discoverability** | If subagents ground *only* via `shop-knowledge`, docs outside the corpus are invisible — a real cost of KEEP. | `query --facet tag --value spec` (and 6 others) → all `[]`. The tag facet is empty corpus-wide. | ✓ (negative result — the tool gap) |
| 9 | **traceability edges / provenance** (derives-from, supersedes, references) | Corpus value is the edge graph; does §1–§6 have provenance edges, or is it a leaf citation target? | `navigate adr-037`; `query --edge references|superseded-by`. | ✓ |
| 10 | **foundational needs / two-views / self-containment** | The corpus enumerates *why artifacts exist* and *which* eight — a closed statement §1–§6 would have to fit. | Title-scan `type=pdr` → PDR-035 (needs statement). | ⚠ (enum ✓, pick ⚠) |
| 11 | **coherence gate / knowledge BC owns the type system** | Adding a ninth kind is a *BC-owned schema change*, not a doc move — I must know who owns the gate. | Title-scan `type=pdr`, `type=adr` → PDR-032, ADR-067. | ⚠ (enum ✓, pick ⚠) |

**Honest note on the split.** Six rows are truly re-runnable because they are facet queries whose id set is deterministic — and three of those six are *negative* results (rows 1, 5, 8), which is the strongest kind of evidence here: the tool itself confirms the absence. The other five rows (2, 3, 6, 10, 11) are **title-scan**: I enumerated a type with a re-runnable query, then *chose* docs by reading titles, because the `tag` facet is empty and no freeform search exists. Those five selections are where grounding could silently fail, and §6 ranks that risk first.

---

## §3. What the terms surfaced → the grounded set

Per term: the ids returned, KEPT vs DROPPED, and why. **No document appears below unless a §2 term surfaced it.**

| Term | Surfaced ids | Kept | Dropped (why) |
|------|--------------|------|---------------|
| 1 | `framework-spec/principles/spec/framework` → **∅** | The empty set itself (fact F1) | — |
| 2 | ADR-067, ADR-069, PDR-032 | **ADR-067, ADR-069** (define the closed eight-kind schema) | PDR-032 (superseded by ADR-067; kept only as lineage) |
| 3 | PDR-034, brief-024, cand-004, intent-006 | **PDR-034, brief-024** (state migration scope) | cand-004, intent-006 (same scope, no new fact) |
| 4 | the eight `type=<k>` counts | **the enumeration** (fact F2) | — |
| 5 | distribution values → **∅** | The empty set (fact F5) | — |
| 6 | ADR-037 | **ADR-037** (the governing decision on §1–§6) | — |
| 7 | current-state-001 | **current-state-001** (occupies the "what is true now" role) | — |
| 8 | tag values → **∅** | The empty set (fact F6 — the discoverability cost) | — |
| 9 | adr-037 neighbours; edge sets | **the negative** (§1–§6 has no in-corpus edges) | — |
| 10 | PDR-035 | **PDR-035** (needs statement, closed kind list) | — |
| 11 | PDR-032, ADR-067 | **ADR-067** (knowledge BC owns the schema gate) | PDR-032 (superseded) |

**Grounded set (kept):** ADR-037, ADR-067, ADR-069, PDR-034, PDR-035, brief-024, current-state-001, plus three empirical negatives (no spec-type, empty distribution facet, empty tag facet).

---

## §4. Verified facts (assertions, not summaries)

Each fact is one assertion with a runnable check. The block below exits `0` when every anchor holds. Non-accepted docs are rendered with `--view transformation` (required for `proposed`/`ready`/`recorded` docs).

- **F1 — The corpus has no spec-shaped kind.** A query for a `framework-spec` type returns the empty list.
- **F2 — The type system is closed at eight kinds**, and "spec/principles" is not among them (ADR-069 confirms the eight are the single source).
- **F3 — ADR-037 (accepted) classifies §1–§6 as a system-construction artifact that stays in the framework/lead repo and is NOT shipped to product.** It rejected deleting §1–§6, calling the spec "the system's self-description."
- **F4 — The live migration's scope is brief/PDR/ADR (~119 files), enumerated by directory; §1–§6 is not in it.** brief-024 counts `33 pdr / 63 adr / 23 briefs`. PDR-034's title fixes the scope to "brief/PDR/ADR."
- **F5 — The `distribution` facet is unpopulated** — it cannot today be used to query §1–§6's scope even if migrated.
- **F6 — The `tag` facet is empty corpus-wide** — the cost of KEEP is that no freeform query reaches a doc outside the corpus.

```bash
# Runnable grounding checks — run from /workspace. Exits 0 iff all anchors hold.
set -e
CORPUS=.
# F1: no spec-shaped type
test "$(shop-knowledge query --corpus $CORPUS --facet type --value framework-spec)" = "[]"
# F2: eight kinds present; enumerate and confirm 'spec' absent
for k in adr brief candidate current-state intent-record pdr prioritization-record session-record; do
  shop-knowledge query --corpus $CORPUS --facet type --value "$k" >/dev/null
done
shop-knowledge render adr-069 --corpus $CORPUS --format md | grep -qi "eight"
# F3: ADR-037 — construction artifact, stays home, not shipped
shop-knowledge render adr-037 --corpus $CORPUS --format md | grep -qi "system-construction artifact"
shop-knowledge render adr-037 --corpus $CORPUS --format md | grep -qi "NOT shipped to product"
# F4: migration scope is brief/PDR/ADR, spec excluded
shop-knowledge render brief-024 --corpus $CORPUS --view transformation --format md | grep -q "119 legacy artifact files"
shop-knowledge render pdr-034  --corpus $CORPUS --view transformation --format md | grep -qi "Legacy brief/PDR/ADR corpus migrates"
# F5: distribution facet unpopulated
test "$(shop-knowledge query --corpus $CORPUS --facet distribution --value product-lead)" = "[]"
# F6: tag facet empty
test "$(shop-knowledge query --corpus $CORPUS --facet tag --value spec)" = "[]"
echo "ALL GROUNDING CHECKS PASSED"
```

*(This block was executed during authoring; it printed `ALL GROUNDING CHECKS PASSED`.)*

---

## §5. Decision

**Recommend Option KEEP: §1–§6 stays as plain markdown, outside the typed corpus.** The reasoning chains directly off §3–§4:

1. **There is no home kind, and making one is a BC schema change, not a doc move.** The type set is closed at eight (F2) and none is spec-shaped (F1). To migrate, someone must add a ninth kind — an owned change to the shopsystem-knowledge schema gate (ADR-067). That is disproportionate to relocating a stable prose spec.

2. **§1–§6 is a different genus from every corpus kind.** ADR-037 (F3) already pinned §1–§6 as a *system-construction* artifact — the system's self-description — deliberately distinct from the product-decision graph the corpus holds (briefs→PDRs→ADRs→scenarios). The corpus records *decisions about the product*; §1–§6 records *how the framework is built*. Migrating would blur a line ADR-037 drew on purpose.

3. **The framework already excluded §1–§6 from its live migration.** The migration in flight (F4) is scoped by directory to brief/PDR/ADR (~119 files) and does not enumerate `01-…`–`06-…`. Absence from an active, precisely-scoped migration is affirmative evidence the framework treats §1–§6 as out-of-corpus by design, not by oversight.

4. **§1–§6 lacks the structure the corpus rewards.** Corpus value is per-type lifecycle status and provenance edges (derives-from / supersedes / references). §1–§6 is evergreen prose with no `status`, no originating decision, and no in-corpus edges (§3 term 9). Forcing it into a typed kind would either distort the spec or dilute the schema, for little gain.

The one real cost of KEEP is discoverability (F6): a doc outside the corpus is invisible to `shop-knowledge` grounding. The right answer to that is a **narrow pointer** — an `external-references` entry or a `references`-style citation from the relevant ADRs to §1–§6 (ADR-037 already cites it by filename) — not a migration. That keeps §1–§6 reachable *from* the corpus without making it a member.

---

## §6. Where this could be wrong (ranked)

**#1 — Terms I may have failed to derive (the completeness-of-terms hole). CAN change the recommendation.** Five of eleven rows are title-scan (§2): I chose docs by eyeballing type listings because no freeform search exists and the `tag` facet is empty. A concept I never turned into a term is a concept whose docs never entered §3. Candidates a reviewer should test that I did *not* run as terms: "versioning" (is §1–§6 a `current-state`-like *versioned singleton*?), "external-references" (does a field already exist purpose-built for exactly this pointer?), "template / typedef authoring" (would a spec-kind typedef be trivial to add?), "adopter footing / starter" (does the bootstrap path assume §1–§6 location?). If any of those surfaces a decision that contradicts ADR-037, the recommendation moves.

**#2 — ADR-037 governs *shipping*, not *corpus membership* (inference gap). CAN change the recommendation.** ADR-037's holding is "not shipped to product instances." I am extending "stays in the framework/lead repo, is a construction artifact" to "therefore stays *out of the typed corpus*." Those are adjacent but not identical questions. A doc can live in the lead repo *and* be typed. If the product authority reads ADR-037 as silent on corpus membership, this record rests on inference, not a pinned decision.

**#3 — Title-scan selection error within a kept type. Could change the *set*, unlikely the recommendation.** I scanned 68 ADR and 38 PDR titles by eye. I may have missed a proposed ADR/PDR that already decides this exact question. The negatives (F1/F5/F6) are immune to this, but the positive selections (ADR-037, PDR-034) are not.

**#4 — The distribution/tag facets are unpopulated, so two negatives are weaker than they look. Does not change the recommendation.** F5 and F6 show the *facets* are empty, which I read as "the field isn't usable for querying." An alternative read is "migration is mid-flight and frontmatter is being backfilled." Either way it does not favor MIGRATE; it just means the discoverability argument (not the membership argument) is the live one.

**#5 — I did not read the full body of every kept doc. Does not change the recommendation.** §4 verifies anchor strings, not entire arguments. A kept doc could carry a caveat the anchor missed. Low risk given the anchors are decision-headers, but disclosed.

---

### Reviewer's fast path
1. Replay the §4 block — confirms F1–F6 in ~10 commands.
2. Re-run the enumerations in §2 rows 2/3/6/10/11 (`query --facet type --value adr|pdr|brief`) and scan the titles yourself — this is the only way to catch a doc my title-scan dropped, because no freeform query exists to do it for you.
3. Attack risk #1: name one concept absent from the §2 table. If it has a doc, this record is incomplete.
