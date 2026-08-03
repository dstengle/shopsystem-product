---
type: brief
id: brief-025
title: Prove tag-based corpus entry-point finding on a selection — composable tag-query and tagging skills, with full-corpus population gated on a measured discovery-probe re-run
status: ready
created: 2026-08-03
updated: 2026-08-03
authors: ["David Stenglein (product authority)", "Claude (lead-po)"]
description: "Commitment brief for cand-010, the first bet under intent-012 (verifiable grounding). Takes the FIND half — complete + correct selection of the artifacts relevant to a question — and proves it on a SELECTION of documents before any corpus-scale tag population. Carries the product authority's evidence-first build sequence verbatim as the intended work-split: tag-query skill, tagging skill, tag a selection with human feedback, test, re-run the discovery probe and measure impact; full-corpus population is gated on that measurement. Re-verifies cand-010's empirical claims against the live 167-artifact corpus (0 populated tags confirmed and traced to its root cause on the write surface; one exit-code claim drifted) and flags one open Architect question — the tag write path — without answering it."
derives-from: [cand-010]
candidate: cand-010
---

## Summary

### The outcome this brief commits to

An agent asking *"which artifacts are relevant to question X?"* over the tagged
selection **invokes a skill that runs one tag query and gets back a named,
re-runnable set** — it does not probe the CLI for usage, and it does not
compose a `grep`. The product authority can read, in the agent's own output,
**the terms, the exact query, and the exact returned set**, and re-run them
himself to the same result.

That is a behavior change, not a deliverable. It is measurable at step 5 by
three quantities, all defined in **Acceptance**: **recall** on artifacts the
pre-tag baseline run missed, **re-run identity** of the returned set, and
**precision** against deliberately-tagged decoys. `shop-knowledge` gaining a
populated `tags` column is an output; an agent finding its entry points without
the product authority feeding it context cues is the outcome.

**What this bet is NOT claiming:** that the corpus is tagged, that grep is
eliminated, or that grounding is now verifiable end to end. It proves the
decompose-then-compose skill pattern works and that **tagging moves the
needle** — enough to justify (or refuse) corpus-scale population. Nothing more.

### Why now

`intent-012` proved by a 5-round adversarial experiment (wf_b6d2c8b3, 5/5 FAIL,
researcher prompt grown ~2.6K → ~25.6K chars) that verifiable grounding
decomposes into **(a) traceable inclusion** — a discipline win the
grounding-record form closed — and **(b) complete + correct selection**, a
**tool** problem discipline cannot close. Every live failure in that experiment
was the (b) kind: **missed relevant documents** (`pdr-038`, `cand-005`) and
misread axes, never an un-traceable inclusion. `cand-010` takes the (b) half
first, at the product authority's direction: *"I want to deal with this
inability to find relevant documents easily first."*

The reproducible selection surface for (b) already exists in schema and in the
read CLI — and is **empty**. That is the gap.

### Re-verification of cand-010's empirical claims (2026-08-03)

Grounded from the lead CWD against the contract/artifact surface only
(ADR-018 D1/D2): the installed `shop-knowledge` / `shop-knowledge-gate` /
`scenarios` CLIs, this repo's `features/`, `adrs/`, `pdrs/`, `candidates/`. No
BC source is on this host and none was read.

| cand-010 claim (established 2026-08-02) | Re-verified 2026-08-03 | Status |
|---|---|---|
| **0 of 153** artifacts carry non-empty `tags` | **0 of 167.** Stronger than claimed: the `tags` **key is absent from the frontmatter of all 167**, not merely empty. Swept via `shop-knowledge query --facet type` over all eight kinds, then `render --view transformation --format yaml` per id. | **HOLDS** (corpus grew 153 → 167) |
| The `tag` facet exists (ADR-067 / ADR-068) with nothing to query | `shop-knowledge query --corpus . --facet tag --value <v>` returns `[]`, exit 0, for every value tried. The facet is live and correct; the column is empty. | **HOLDS** |
| `--help` returns an error string and **exits 0**, so a caller cannot detect the failure | **Half drifted.** The *error string* holds and is worse than described: there is **no usage text anywhere** — top-level `--help`, bare invocation, and `--help` on every verb all return a one-line arg-error. But the *exit 0* half **no longer reproduces**: every error path (`--help`, unknown subcommand, unknown facet, missing args, unknown id) now exits **2**. A caller *can* detect failure. (`shop-knowledge-gate`, by contrast, does emit real usage.) | **PARTIALLY DRIFTED** |

The discoverability gap that motivates "usage lives in a loaded skill, not in a
prettier help" is therefore **intact**; the specific "silent success on error"
argument is **retired** and must not be restated. A *different*, real
silent-failure surface was found in its place — see finding 3.

### New empirical findings (2026-08-03), decision-relevant

1. **The root cause of 0% tag population sits on the WRITE surface, not the
   read surface.** No generated `shop-knowledge template <kind>` emits a `tags:`
   key — verified for all eight kinds — and `shop-knowledge schema <kind>` does
   not name `tags` either. Every artifact authored through a `write-<kind>`
   skill is authored from a template with no tags line, which mechanically
   explains why the field is absent in 167/167. The field is nonetheless fully
   legal: `features/shopsystem-knowledge/base_schema_distribution_and_fields.feature`
   pins *"an artifact carrying a tags list conforms"* and *"an artifact omitting
   the optional tags field still conforms"*. **Tags are legal and invisible.**
   This is direct input to the open Architect question below and is
   deliberately **not** resolved here.

2. **`shop-knowledge render --format json` fails on 167 of 167 artifacts** —
   exit 1, unhandled `TypeError: Object of type date is not JSON serializable`.
   `--format md` and `--format yaml` work. `query`'s JSON list output is
   unaffected. `features/shopsystem-knowledge/corpus_read_cli.feature` pins
   *"render emits either document markdown or a structured envelope carrying
   the rendered body and frontmatter facets"*, so the json path is a genuine
   defect against an existing pin. **Consequence for this brief:** any atom
   needing machine-readable *full-document* output is blocked today; the atoms
   this bet needs must be specified against `query` JSON and `render --format
   yaml|md`. Fixing the json path is **out of scope** (see Out of scope) and is
   flagged for separate routing.

3. **The default `render` view silently misses 107 of 167 artifacts** — exit 0
   with the prose message *"<id> has no current-system rendering because it is
   not in the accepted set."* The miss set is **100% of briefs (24), candidates
   (11), intent-records (13), session-records (12), and current-state (1)**,
   plus 26 pdrs and 20 adrs, because their in-force statuses are `ready` /
   `committed` / `recorded` / `closed` / `current`, not `accepted`. **This is
   pinned, intended behavior**, not a defect — `corpus_read_cli.feature` pins
   *"render current-system view has no rendering for a document whose status is
   not accepted."* It is also the sharpest possible argument for this bet's
   central premise: a caller who does not carry `--view transformation` inline
   **silently drops two thirds of the corpus and gets exit 0**. That invocation
   discipline is exactly what a loaded skill exists to carry, and it must be
   pinned by scenario.

4. **Citation drift (non-blocking).** `cand-010` and `intent-012` both cite
   `drafts/grounding-record-exp-iter1-5.md`; that path does not exist. The
   evidence is five files, `drafts/grounding-record-exp-iter{1,2,3,4,5}.md`.
   Recorded because an unresolvable citation is precisely the failure this
   initiative exists to remove.

### Prior art reconciled — cand-003

`cand-010` succeeds `cand-003`'s **knowledge-corpus element**. `cand-003`'s #1
open rabbit hole — *"whether `shopsystem-knowledge` currently exposes a query
interface at all, versus only validation"* — is **discharged**: it exposes
`query` / `navigate` / `render` (ADR-068, pinned by `corpus_read_cli.feature`).
`cand-003`'s governing premise — *"the tool already gets it right; subagents
just need to use it"* — is **true for the `scenarios` CLI and disproven for the
knowledge corpus**: here the tool is correct but the data it queries is empty,
so routing through it changes nothing until tags exist. `cand-003`'s separate
**scenario-corpus element** is untouched and not absorbed. This brief does not
re-derive any of it.

### Appetite — medium, selection-first

One vertical slice through the composition architecture, deliberately sized
**well under** `intent-012`'s large, multi-slice appetite. Full-corpus
inference population is **not in this bet** — it is gated on step 5. If the
work starts pulling in semantic search, the grounding-record form, the full
atom library, or an up-front taxonomy, **the appetite has been blown and the
extra is out.**

## Scope

### The work-split — the authority-directed, evidence-first build sequence

**This sequence is settled.** It was directed by the product authority on
2026-08-03 at commit and is carried here as the intended work-split. It is
**not to be re-litigated, re-ordered, or replaced with an alternative proving
path** by any downstream role. Step 5 **is** the Proof-of-Life gate; the
question "should a probe gate corpus-scale population?" is **answered — yes,
step 5 is that probe** — and is not reopened.

**Step 1 — Tag-query command skill(s).** The atomic skill(s) that run the tag
query, so tags are queryable and visible first. Each wraps exactly one corpus
command and *just runs it*, carrying the correct invocation inline — no
discovery, no help-probe, no error-string fishing. Per finding 3, an atom that
pulls a document **carries `--view transformation` inline**; per finding 2, no
atom may depend on `render --format json`.

**Step 2 — Tagging skill.** The skill that **writes or refreshes a document's
tags**. It is the *write* mechanism and is deterministic: given a document and
a tag set, it writes them and leaves the artifact conforming. Its write path is
the open Architect question below.

**Step 3 — Tag a SELECTION of documents, then get human feedback on those
tags.** Not the corpus. Tags for the selection are **proposed by inference**
(not hand-curated) — see the PO disposition below for why that is load-bearing
— and the **product authority ratifies the emerging vocabulary**, per-value:
accept / reject / rename. The ratified vocabulary is written down as the output
of this step.

**Step 4 — Test that the tagging skills work as expected.** The skills from
steps 1–2 are exercised and pinned, including the invocation-discipline
properties (correct flags carried inline, no help-probe, no silent
current-system miss).

**Step 5 — Re-run the discovery probe and MEASURE the impact of tagging.**
The gate. The probe is re-run over the tagged selection with tags as the only
changed variable, and the three quantities in **Acceptance** are recorded.
**Full-corpus population is trusted only if this step shows tagging moved the
needle.** A red or ambiguous step 5 is a legitimate, recorded outcome: it stops
corpus-scale population and returns the question to the product authority.

**After the gate (NOT in this brief):** full-corpus inference population.

### Also in scope, bounded to what the sequence needs

- **The `find-entry-points` composite** and the **inference completeness
  sweep** described in `cand-010`'s solution sketch, scoped to exactly what
  step 5's probe re-run exercises — the composite is the instrument step 5 is
  run through, not a separate workstream. The composite **records the terms and
  the tag queries it chose**, so the extraction is inspectable and
  re-runnable-with-the-same-terms. The sweep's verdicts are a **review signal
  that flags relevant-but-untagged documents**, never the authoritative
  selector; the reproducible tag match stays the selector.
- **Only the atoms the composite actually needs** — the tag query, the tag
  write, a document pull, an edge step. Not a library.

### PO dispositions on points cand-010 left open

These are commitment-owner calls, made here so no downstream role has to infer
them. Each is a scope/vocabulary call, which is the PO's to settle.

- **"The discovery probe" (step 5) is pinned as:** a re-run of the `intent-012`
  grounding-record researcher task using `drafts/grounding-researcher-prompt-hardened.md`,
  against the same question round 5 ran (framework-spec §1–6 corpus membership),
  with **`drafts/grounding-record-exp-iter5.md` as the recorded pre-tag
  baseline**. Reason: an existing baseline with a recorded miss set is what
  makes "moved the needle" measurable at all; a fresh probe question would have
  no before.
- **"A selection of documents" (step 3) is pinned by composition, not by
  count.** The selection MUST: (a) include every artifact the pre-tag baseline
  run cited; (b) include every artifact the pre-tag runs **missed** — at
  minimum `pdr-038` and `cand-005`; (c) include **at least 10 artifacts that
  are NOT relevant to the probe question**, so precision is measurable and the
  gate cannot be passed by tagging everything; (d) span **at least four of the
  eight artifact kinds**. Reason: recall alone is a gate a lazy tagger passes.
- **Tags in step 3 are inference-PROPOSED, then human-ratified — not
  hand-authored.** Reason: step 5 must measure the quality of the mechanism
  that would run at corpus scale. A hand-curated selection would return a green
  gate that says nothing about corpus-scale population, which is the only
  decision the gate exists to inform.
- **"Human feedback" (step 3) means:** the product authority's per-tag-value
  accept / reject / rename verdict, recorded durably (session record or bead
  comment) alongside the resulting ratified vocabulary. Not an informal read.

## Out of scope

The `cand-010` **No-gos**, carried verbatim. Pulling any of these in means the
appetite has been blown:

- **The grounding-record-form skill** — `intent-012`'s (a)/inspection half. The
  natural *next* bet, explicitly not this one.
- **Semantic / vector search** — spine "B", and any embedding or vector-store
  infrastructure. A follow-on.
- **The full atomic-skill library and the operational-skills wave** (dispatch,
  hashing, reconcile, session, …). Same pattern, separate and larger program.
- **The graph-as-domain decision (`lead-3gyuq`)** — the find flow is scoped to
  the `shop-knowledge` artifact corpus; whether decisions + scenarios + beads
  are one navigable domain is taken separately.
- **The bd-coupling audit (`lead-d0jmz`)** — runs in parallel; bd work-ids are
  treated here as just another artifact-class reference.
- **A controlled taxonomy designed up front** — the vocabulary emerges from the
  inference bootstrap and is ratified; it is not specified before population.

Additionally out of scope, arising from this pass's findings — **flagged, not
absorbed**:

- **Fixing `shop-knowledge render --format json`** (finding 2). A real defect
  against an existing pin, and a plain fix; route it separately. This brief
  specifies around it.
- **Fixing `shop-knowledge` help / discoverability** (the re-verified finding
  above). Already noted as separate cleanup in `sess-2026-08-02-b`'s open
  threads. The answer to runtime tool-rediscovery in *this* bet is the loaded
  skill, not a prettier help.
- **Changing the current-system view's semantics** (finding 3). Pinned,
  intended behavior. The atoms carry `--view transformation` inline; the view
  is not renegotiated.
- **Full-corpus tag population** — gated on step 5, by construction.

## Open question requiring Architect input

**One, and it does not block this brief.**

> **How are tags written?** `cand-010` names this an Architect call at brief
> time and it is not a PO call: it is a mechanism/contract decision about which
> BC surface owns the write and how the coherence gate participates.

The two shapes `cand-010` named:

- **(i)** a **dedicated corpus write command** on `shop-knowledge` that sets a
  document's tags; or
- **(ii)** a **frontmatter edit revalidated through the coherence gate**
  (`shop-knowledge validate` + `shop-knowledge-gate`).

Evidence assembled here for that decision, offered **without a recommendation**:

- `shop-knowledge` exposes exactly six verbs — `template`, `schema`,
  `validate`, `navigate`, `render`, `query`. **There is no write verb today**,
  so shape (i) is net-new BC capability and shape (ii) is available now.
- Validation already accepts tags, pinned both ways
  (`base_schema_distribution_and_fields.feature`: a tags list conforms; an
  omitted tags field conforms). `shop-knowledge-gate .` is currently **green
  with zero findings** over the 167-artifact corpus — whichever shape is taken
  must keep it green.
- **Finding 1 raises a third consideration the rabbit hole did not name:** no
  generated `template <kind>` emits a `tags:` key and `schema <kind>` does not
  report the field, so the write surface currently makes tags invisible to
  every authoring path. Whether that template/typedef gap is inside this
  question, adjacent to it, or a separate item is **also the Architect's
  call** — the PO is flagging it, not scoping it.

This question must be resolved **before step 2's scenarios are authored**; it
does not gate step 1, and it does not gate this brief.

## Acceptance

### Per-step

- **Step 1 accepted** when a tag-query skill exists whose body carries the
  exact, working invocation inline (`shop-knowledge query --corpus <root>
  --facet tag --value <v>`), an agent following it runs the query with **zero
  help-probe or arg-error invocations**, and any document-pull atom carries
  `--view transformation` so it does **not** silently return the
  "no current-system rendering" message on a non-`accepted` artifact.
- **Step 2 accepted** when the tagging skill writes a document's tags, the
  written document passes `shop-knowledge validate` as **conforming**, and
  `shop-knowledge-gate .` stays at **zero findings**. (Mechanism per the
  Architect's resolution above.)
- **Step 3 accepted** when the selection satisfies all four composition rules
  above, its tags were inference-proposed, and the product authority's per-value
  accept/reject/rename verdicts plus the resulting **ratified vocabulary** are
  recorded durably.
- **Step 4 accepted** when the step 1–2 skills are exercised against the
  tagged selection and their invocation-discipline properties are pinned by
  scenario, not asserted in prose.
- **Step 5 accepted** when the probe has been re-run against the pinned
  baseline and the three measurements below are **recorded** — green or red.
  Recording a red is acceptance; skipping the measurement is not.

### The step-5 measurements (the gate)

1. **Recall.** Of the artifacts the pre-tag baseline run **missed** (at minimum
   `pdr-038`, `cand-005`), how many does the tag query now return?
2. **Re-run identity.** Re-running the composite with the **same terms**
   returns a **byte-identical** artifact set.
3. **Precision.** How many of the ≥10 not-relevant decoys in the selection does
   the tag query wrongly return?

**Gate rule:** full-corpus population proceeds **only** on a step-5 result the
product authority reads as "tagging moved the needle." Anything else stops
corpus-scale population and returns the decision to him. This brief commits the
shop to the measurement, not to the population.

### Whole-brief definition of done

- Steps 1–5 accepted as above.
- `shop-knowledge validate` **conforming** for this brief and for every
  artifact whose tags were written; `shop-knowledge-gate .` at **zero
  findings** over the corpus, unchanged from the 2026-08-03 baseline.
- The step-5 measurement is recorded durably and the population decision is
  explicitly taken (proceed / stop), with a reason.
- **No No-go was pulled in.**

## Dependencies and BC ownership

- **`shopsystem-knowledge`** owns the `tags` field (ADR-067), the `tag` query
  facet and the read CLI (ADR-068), the per-kind typedefs and their generated
  templates/schemas (ADR-069/ADR-070), and the coherence gate. Steps 1–2 touch
  its contract surface.
- **`shopsystem-templates`** owns skills: the canonical lead skill-group is
  shipped as package data and poured/updated per
  `features/shopsystem-templates/lead_skill_group*.feature` and
  `cli_pours_skills_on_bootstrap.feature` / `cli_repours_skills_on_update.feature`.
- **An available sequencing mechanism, noted as evidence — the Architect's call
  at dispatch:** `features/shopsystem-templates/skills_provenance_marker.feature`
  pins that a **LOCAL**-marked skill survives a re-pour byte-for-byte, that an
  experiment skill absent from canonical package data persists, and that a
  LOCAL skill can be **graduated to CANONICAL** by adding it to package data and
  flipping its marker. Steps 1–4 could therefore be proved with LOCAL-marked
  skills on the lead host, with graduation to canonical package data sequenced
  after the step-5 gate. Recorded because it is empirically pinned and it
  lowers the cost of a selection-first slice; **it changes nothing about the
  sequence**, and choosing it is a decomposition decision, not a PO call.
- **No BC source exists on this host** (ADR-018). Everything above was
  established against the contract/artifact surface: the installed CLIs, this
  repo's `features/`, `adrs/`, `pdrs/`, `candidates/`, and the gate.

## Changelog

- 2026-08-03 authored by `lead-po` (bead `lead-cx7w9`, linked to epic
  `lead-fb3vk`) against `cand-010`, committed the same day by the product
  authority (d6e9585). Carries the authority-directed evidence-first build
  sequence verbatim as the work-split, with step 5 as the Proof-of-Life gate
  and full-corpus population gated on it. Re-verified cand-010's empirical
  claims against the live 167-artifact corpus: the 0-populated-tags claim holds
  and strengthens (the key is absent, not empty; root-caused to the write
  surface, which emits no `tags:` key for any of the eight kinds); the
  `--help`-exits-0 claim partially drifted (error strings hold, exit codes are
  now 2) and is retired; two new findings recorded (`render --format json`
  fails corpus-wide; the default view silently misses 107/167 — pinned
  behavior, and the sharpest argument for invocation-in-a-skill). Four PO
  dispositions taken on points cand-010 left open (the probe's identity, the
  selection's composition, inference-proposed-not-hand-authored tags, the form
  of human feedback). One open Architect question flagged and deliberately
  unanswered: the tag write path. Opened directly at `ready` — the brief is
  complete and the pending Architect input is its next step, not a blocker.
