---
type: candidate
id: cand-010
title: Corpus entry-point finding as a composable, tag-based skill set — a question resolves to a reproducible, reviewable set of relevant artifacts
status: shaped
created: 2026-08-02
updated: 2026-08-02
authors: [dstengle, "Claude (lead-pm)"]
description: "First bet under intent-012 (verifiable grounding). Attacks the FIND half of the proven decomposition — complete+correct selection of the relevant artifacts for a question — which the 5-round adversarial experiment proved discipline alone cannot close. Tags (schema-native per ADR-067, 0/153 populated today) become the reproducible selection surface, populated via an inference bootstrap and queried through thin atomic corpus-command skills combined by one find-entry-points composite; an inference completeness sweep flags relevant-but-untagged docs so reproducible tag-selection is not a silent-false-negative machine. Deliberately excludes the grounding-record-form skill, semantic search, the full atom library, and the graph-as-domain / bd-coupling decisions."
derives-from: [intent-012]
derived-by:
session: sess-2026-08-02-b
experiments: []
brief:
parked-until:
beads: []
---

# cand-010 — corpus entry-point finding as a composable, tag-based skill set

## Verbatim anchors

- 2026-07-29 (dstengle): "verifiable grounding = a trace that STARTS FROM THE
  QUESTION -> the TERMS/concepts derived from it -> the queries/searches those
  terms drive -> results -> the grounded set -> the decision. The AUDIT SURFACE
  is the derived TERMS."
- 2026-08-02 (dstengle): "we need a way to find the correct entry points in the
  artifact graph using semantic terms" — naming **tagging** ("probably the single
  biggest gap right up front"), **per-doc inference relevance** ("Is this question
  X related to this title and description"), and **semantic search** as the
  mechanisms. "I want to deal with this inability to find relevant documents
  easily first."
- 2026-08-02 (dstengle): "It is a group of skills for specific command to find
  things in the corpus… Every interaction with the corpus should be able to be
  run with a skill that is able to just run a command, not figure out how to use
  the command and then use it. Things need to be decomposed and then combined
  intelligently."

## Problem

`intent-012` proved (via a 5-round adversarial experiment, wf_b6d2c8b3, 5/5 FAIL,
researcher prompt grown 2.6K→25.6K chars) that verifiable grounding decomposes
into two halves: **(a) traceable inclusion** ("no artifact from thin air"), a
discipline win the record-form closed; and **(b) complete + correct selection**
("found everything, read it right"), a **tool** problem discipline cannot close.
The experiment's live failures were the (b) kind — **missed relevant documents**
(pdr-038, cand-005) and misread axes — not un-traceable inclusions.

This candidate takes the **(b) FIND half first**, at the product authority's
direction: the shop cannot reliably surface the complete, correct set of relevant
artifacts an agent should ground a decision on. Grounded empirically this session
against the installed `shop-knowledge` v0.1.0 and the live 153-artifact corpus:

- **The reproducible selection surface exists but is empty.** ADR-067 (accepted)
  added a `tags` field to the base schema and ADR-068 shipped the read CLI with a
  `tag` facet — yet **0 of 153 artifacts** carry a non-empty `tags` field. The
  facet has nothing to query. Tag population, not tag tooling, is the gap the
  authority named "the single biggest right up front."
- **There is no freeform / semantic way in.** With tags empty and no full-text or
  similarity search, an agent's only route to "what's relevant to this question?"
  is `grep` + title-scan — exactly the non-reproducing, discretionary selection
  the experiment showed fails.
- **Tool usage is rediscovered, wastefully, at runtime.** The read verbs answer
  discoverability with an intentional arg-error string (and `--help` exits **0**
  on that error, so a caller cannot even detect failure). The `write-<kind>`
  skills already prove the fix pattern — they carry the exact invocation inline so
  authoring never probes — but the **read/find path has no such skill**. An agent
  that must figure out a command before using it is already paying the waste.

The result: an agent cannot cheaply, reproducibly, or completely find its entry
points, so it grounds on a partial/wrong basis — and the product authority stays
the safety net that catches the miss.

## Appetite

**Medium — one vertical slice through a composition architecture, not the
initiative — and, at commit, an *evidence-first* slice that proves on a
selection before it populates at scale.** The bet is bounded to: author the *few*
atomic corpus-command skills the find flow needs plus one composite that combines
them; a tagging skill; tags applied to a **selected subset** of documents (not the
whole corpus) with human feedback on those tags; a test that the skills work; and
a **re-run of the discovery probe to measure the impact of tagging** before any
full-corpus population is trusted. Full inference-bootstrap population is therefore
**gated on measured impact**, not part of the first cut. It is deliberately sized
well under intent-012's "large, multi-slice" appetite — it proves the
decompose-then-compose pattern and that tagging moves the needle, and nothing
more. If the shape starts pulling in semantic-search infrastructure, the
record-form skill, or the full skill library, the appetite has been blown and the
extra is out (see No-gos).

## Solution sketch

A **two-tier composition of skills** over the corpus, with **tags as the
reproducible selection spine** and **inference in two supporting roles**.

**Tier 1 — atomic corpus-command skills.** Each wraps exactly one corpus command
and *just runs it* with the correct invocation carried inline — no discovery, no
help-probe, no error-string fishing. The find flow needs a small set: run the
tag-facet query; write/refresh a document's tags; pull a document (and one
section) on demand; step the edge neighbourhood of a hit. These are thin,
single-responsibility, and independently reusable — the seed of the broader
"a skill per corpus interaction" library (which is the follow-on program, not
this bet).

**Tier 2 — one composite skill, `find-entry-points`.** Given a question it runs
the flow the atoms enable: derive the question's **terms** (the audit surface),
resolve them to tags, run the tag query to assemble a **reproducible candidate
set**, run the completeness sweep, and hand back a **reviewable entry-point set**
— the terms, the exact tag queries, and the hits, ready for an agent to ground
on. This is "combine the atoms intelligently."

**Tags as the reproducible spine, populated by inference.** A question-term → tag
match re-runs to the identical set — the exact, auditable "this term → these
documents" trace this whole initiative exists to produce. To avoid hand-tagging
153 documents, an **inference pass proposes tags per document** from its
metadata; the product authority ratifies the emerging vocabulary. Population is
bootstrapped, the query surface stays exact.

**An inference completeness sweep, built in.** Because tag recall is only as good
as tag coverage, a relevant-but-untagged document is a silent false-negative — the
exact failure mode the experiment hit. So the composite carries a second inference
role: a sweep that asks, per document, "is this relevant to the question?" —
**complete by construction** (it examines every document) — and *flags* anything
relevant the tag query missed. Its verdicts are a review signal, not the
authoritative selector (that stays the reproducible tag match), so its run-to-run
variance is acceptable where it would not be as the selector. The same inference
mechanism thus both **bootstraps population** and **guards completeness**.

Net: a question yields a reproducible, reviewable set of entry points, produced by
skills that run commands rather than rediscover them.

**Committed build sequence (authority-directed, 2026-08-03).** The slice is built
and proved in this order — cheapest proof first, full population last and gated:

1. **Tag-query command skill(s)** — the atomic skill(s) that run the tag query, so
   tags are queryable and visible first.
2. **Tagging skill** — the skill that writes/refreshes a document's tags.
3. **Tag a *selection* of documents** — apply tags to a chosen subset (not the
   whole corpus), then **get human feedback on those tags**.
4. **Test** that the tagging skills work as expected.
5. **Re-run the discovery probe and measure the impact of tagging** — the gate:
   full-corpus population is only trusted once this shows tagging moved the needle.

This ordering *is* the resolution of the "PoL probe before corpus-scale
population" rabbit hole: step 5's probe re-run is that gate, and step 3's feedback
loop is the vocabulary-ratification checkpoint — both on a selection, before scale.

## Rabbit holes

- **Tag vocabulary provenance and quality.** A badly-populated tag space just
  relocates the discretion. *Bound:* the vocabulary **emerges from the inference
  bootstrap and the product authority ratifies it** — no controlled taxonomy
  designed up front (that is a No-go). Vocabulary refinement is expected to
  iterate as tags are used, not to be solved before the bet ships.
- **The tag write path and gate acceptance.** The `tags` field exists (ADR-067)
  but whether tags are written by a dedicated corpus command or by a
  frontmatter edit revalidated through the coherence gate is unresolved. *This is
  an Architect call at brief time and does not block convergence* — tags are
  frontmatter and are gate-validated either way.
- **Inference tagging/relevance quality.** Whether a simple, cheap model produces
  usably-consistent tags and relevance verdicts is a real risk. *Resolved by the
  committed build sequence:* tags are applied to a **selection** first, with human
  feedback on them (step 3) and a discovery-probe re-run to measure impact (step 5)
  **before** any full-corpus population is trusted — the probe re-run is the
  Proof-of-Life gate.
- **Question → tag extraction reproducibility.** Extracting a question to tags is
  itself a judgment step; if it varies, reproducibility leaks upstream of the tag
  match. *Bound:* the composite **records the terms and tags it chose**, so the
  extraction is inspectable and re-runnable-with-the-same-terms even if the
  extraction judgment is not perfectly deterministic — the audit surface (the
  terms) is captured, per intent-012's core principle.

## No-gos

- **The grounding-record-form skill.** The (a)/inspection half of intent-012 —
  question → terms → per-term hard-linked interrogation → assembled set → decision
  — is the natural *next* bet (it makes each find *inspectable*), explicitly not
  this one.
- **Semantic / vector search.** The reproducibility+recall upgrade (spine "B")
  and any embedding or vector-store infrastructure are a follow-on, not this bet.
- **The full atomic-skill library and the operational-skills wave** (dispatch,
  hashing, reconcile, session, etc.). Same decompose-then-compose pattern, a
  separate and larger program.
- **The graph-as-domain decision (`lead-3gyuq`).** The find flow is scoped to the
  `shop-knowledge` artifact corpus; whether decisions + scenarios + beads are one
  navigable domain is a foundational decision taken separately and is out of
  bounds here.
- **The bd-coupling audit (`lead-d0jmz`).** Runs in parallel; this bet treats bd
  work-ids as just another artifact-class reference and does not resolve the
  provenance↔work coupling.
- **A controlled taxonomy designed up front.** The vocabulary emerges and is
  ratified; it is not specified before population.

## Evidence / experiments

- **5-round adversarial hardening experiment** (wf_b6d2c8b3, 2026-08-01):
  `drafts/grounding-record-exp-iter1-5.md`, `drafts/grounding-researcher-prompt-hardened.md`.
  Establishes the (a)/(b) decomposition and that complete+correct selection is a
  tool problem — the direct warrant for taking the FIND half as a tool/skill bet.
- **This session's empirical grounding** (2026-08-02), dogfooded via
  `shop-knowledge` against the live corpus: **0/153** artifacts carry non-empty
  `tags`; `query` returns clean L0 but `--help` returns an error string and
  **exits 0**; the `tag` facet exists (ADR-067) with nothing to query.
- **Solution-space analysis:** `drafts/knowledge-tools-and-skills-analysis.md`
  (tool/skill/doctrine gap analysis; the atom/composite and understanding-skill
  seeds).
- **Prior art reconciled — `cand-003`** ("Structured-corpus query tools as the
  primary retrieval interface," committed 2026-07-15, derives from `intent-004`).
  This candidate **succeeds cand-003's knowledge-corpus element**: cand-003's #1
  open rabbit hole — *"whether `shopsystem-knowledge` currently exposes a query
  interface at all, versus only validation"* — is **discharged** by this session's
  finding (it exposes query/navigate/render, with the gaps named above), and
  cand-003's premise ("the tool already gets it right; subagents just need to use
  it," true for the `scenarios` CLI) is **disproven for the knowledge corpus** by
  the experiment. cand-003's separate scenario-corpus element (the `scenarios` CLI,
  already correct) is untouched and not absorbed here.

## Resolution

**Shaped 2026-08-02** in `sess-2026-08-02-b` (lead-pm shaping mode), deriving from
`intent-012`, with the product authority (dstengle) resolving the open shaping
forks in-session: the first bet is the FIND half (not the record-form skill); the
reproducible spine is **tags** (spine "A") populated by inference, not semantic
search; the deliverable is a **composition of atomic command-skills + one
composite**, not a monolith; graph-as-domain and bd-coupling stay deferred; the
full skill library and semantic search are the named follow-on program.

**Committed 2026-08-03** by the product authority (dstengle), who directed the
evidence-first build sequence recorded in the Solution sketch (query skill →
tagging skill → tag a selection + human feedback → test → re-run the discovery
probe to measure impact, with full population gated on that impact). Routed to
`lead-po` for brief authoring; the brief's Architect input should resolve the tag
write-path/gate rabbit hole. The Proof-of-Life question is answered by the
directed sequence — step 5's probe re-run is that gate — so the brief carries the
sequence as the intended work-split rather than reopening it.

## Changelog

- 2026-08-02 opened and driven to `shaped` in `sess-2026-08-02-b`, deriving from
  `intent-012`. Spine, deliverable-shape (atoms + composite), completeness sweep,
  boundaries, and rabbit holes pinned with the product authority. Reconciled with
  prior art `cand-003` (absorbs its knowledge-corpus element; discharges its open
  query-interface rabbit hole). Companion follow-ons named: the grounding-record
  skill, semantic search, the full atomic-skill / operational-skills library.
- 2026-08-03 committed by the product authority, who directed an evidence-first
  build sequence: tag-query skill → tagging skill → tag a *selection* + human
  feedback → test → re-run the discovery probe to measure impact, with full-corpus
  population gated on that impact. Appetite narrowed to selection-first; the
  inference-quality rabbit hole is resolved by step 5's probe-re-run gate. Routed
  to `lead-po` for brief authoring.
