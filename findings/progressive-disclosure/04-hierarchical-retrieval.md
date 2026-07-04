# 04 — Hierarchical / tiered retrieval: what transfers to a ~100-doc decision corpus

**Research stream:** `hierarchical-retrieval` (epic lead-x7bp, process bead lead-x2rl)
**Date:** 2026-07-04
**Status:** RESEARCH COMPLETE — verdict per mechanic below. Headline: the three
"advanced RAG" techniques are all **retrieval-at-scale** machinery that is
**OVERKILL for our corpus size**; borrow two *concepts* (abstraction-tiers,
typed-edge graph), reject all three *mechanisms* (LLM clustering, LLM
summarization, embedding pipelines). Our corpus sits **below the threshold where
retrieval is even needed** — Anthropic's own 200K-token cutoff.

---

## The frame this stream must answer

The epic wants L0/L1/L2 tiers + a generated index + a coherence gate over ~100
decision docs (~56 ADR, ~29 PDR, ~10 brief, + features/findings). The three
techniques below (RAPTOR, GraphRAG, contextual retrieval) are the canonical
"hierarchical / graph / context-aware retrieval" state of the art. The stream's
job: separate **the mechanic worth borrowing** from **the scale-driven
machinery that is dead weight** at ~100 docs, under the operator's hard
constraint — *relatively simple AND self-hostable*
(`findings/substrate-candidate-comparison-vs-fabro.md:8`, the calibration line
"under the user's hard constraints: relatively simple AND self-hostable").

**The single most decision-relevant fact in this whole stream:** all three
techniques exist to make retrieval work when *you cannot fit the corpus in the
model's context*. Our L1 "decisions digest" (id + title + decision statement +
status + edges for ~100 docs) is on the order of **a few thousand to low tens of
thousands of tokens** — it fits in context whole. **We are not in the regime any
of these techniques were built for.** They solve a problem we do not have.

---

## Sources consulted

RAPTOR
- RAPTOR paper (arXiv 2401.18059), abstract + method — https://arxiv.org/abs/2401.18059 , https://arxiv.org/html/2401.18059v1
- Official implementation (GMM soft-clustering + UMAP + BIC + LLM summaries) — https://github.com/parthsarthi03/raptor
- Explainer (tree construction / collapsed-tree retrieval) — https://aiengineering.academy/RAG/09_RAPTOR/

Microsoft GraphRAG
- "From Local to Global: A GraphRAG Approach to Query-Focused Summarization" (arXiv 2404.16130 v2) — https://arxiv.org/html/2404.16130v2
- Community detection (Leiden, hierarchical) — https://www.mintlify.com/microsoft/graphrag/concepts/community-detection
- Default dataflow (index pipeline stages) — https://microsoft.github.io/graphrag/index/default_dataflow/
- Cost critique / "when it's overkill" — https://sider.ai/blog/ai-tools/is-graphrag-worth-it-a-hands-on-review-of-the-graph-powered-rag-paradigm ; https://medium.com/graph-praxis/the-graphrag-cost-cliff-how-33-000-became-33-in-eighteen-months-be1b0fbe37e4 ; FastGraphRAG / KET-RAG cost-reduction note https://arxiv.org/html/2502.09304v2

Anthropic contextual retrieval
- Anthropic Engineering, "Contextual Retrieval in AI Systems" — https://www.anthropic.com/engineering/contextual-retrieval
- DataCamp implementation guide — https://www.datacamp.com/tutorial/contextual-retrieval-anthropic

Internal precedent
- `findings/substrate-candidate-comparison-vs-fabro.md:8` — the "relatively simple AND self-hostable" operator constraint.
- `findings/progressive-disclosure/00-plan.md` — the L0/L1/L2 + generated-index + coherence-gate goal statement (lines 26-36).

---

## (a) RAPTOR — recursive summary tree

**What it is.** Bottom-up tree over a corpus: embed chunks → soft-cluster them
(Gaussian Mixture Models, with UMAP dimensionality reduction and Bayesian
Information Criterion to pick cluster count) → LLM-**summarize** each cluster →
those summaries become parent nodes → recurse until a root. At query time you
retrieve across *all* tiers (the "collapsed tree"), so a query can hit a
fine-grained leaf chunk **or** a high-level cluster summary, whichever is most
relevant. (arXiv 2401.18059; github.com/parthsarthi03/raptor.)

**Problem it solves.** Flat chunk retrieval loses the forest for the trees:
multi-hop / "integrate information across a long document" questions need
abstraction the raw chunks don't carry. RAPTOR manufactures the missing
abstraction layers. Headline result: +20% on the QuALITY benchmark with GPT-4
(https://arxiv.org/abs/2401.18059).

**Scale where it pays off.** Long-document / book-length QA where you *cannot*
read the whole thing and the answer spans many chunks. The summarization tree is
a *lossy compression* to fit long context into a retrievable budget.

**What transfers — the CONCEPT of tiers of abstraction.** This is the closest
technique to our L0/L1/L2 idea: multiple resolution levels of the same content,
retrieve the level that fits the task. That is precisely our design instinct
(L0 triage / L1 conform / L2 author). **RAPTOR is external validation that
tiered abstraction is a real, benchmarked retrieval primitive — not something we
invented.**

**What does NOT transfer — the MECHANISM.** Every RAPTOR tier is an
**LLM-generated summary of a cluster the algorithm discovered**. That is exactly
the *summary/full drift* failure the epic exists to kill (00-plan.md:29 "no
summary/full drift"). RAPTOR's tiers are:
- **non-deterministic** (GMM clustering + LLM summarization vary run to run),
- **derived, not authored** (nobody wrote the L1; a model guessed it),
- **drift-prone** (regenerate → the summary changes → BCs conforming to it get a
  moving target).

Our tiers must be the opposite: **deterministic projections of authored
frontmatter fields** — L0 = `id/title/description`, L1 = `decision/status/edges`,
L2 = the file. No clustering (our "clusters" are already the documents; the
boundaries are authored, not discovered). No summarization LLM call (the L1
*decision statement* is authored by lead-architect in frontmatter, not
synthesized). RAPTOR's whole value-add — *discovering* structure and *writing*
summaries — is work our corpus has **already done by hand** in ADR/PDR authoring.

**Overkill verdict:** MECHANISM REFUTED, CONCEPT CONFIRMED. Borrow "tiers of
abstraction, retrieve by task." Reject GMM/UMAP/BIC clustering and
LLM-summarized nodes entirely — they reintroduce the drift we are trying to
eliminate and add a heavy non-deterministic pipeline for a corpus small enough
to hand-tier.

---

## (b) Microsoft GraphRAG — entity/community graph + community summaries

**What it is.** A pipeline: LLM extracts entities + relationships from every
chunk into a knowledge graph (subject–predicate–object triples) → the graph is
partitioned into a **hierarchy of communities** with the **Leiden** algorithm
(recursively, so you get levels C0 root → C1/C2 → C3 leaf) → an LLM writes a
**community summary** for every community at every level → at query time
("global" mode) each community summary independently emits a partial answer and
those are map-reduced into a global answer.
(https://arxiv.org/html/2404.16130v2 ; community detection:
https://www.mintlify.com/microsoft/graphrag/concepts/community-detection.)

**Problem it solves.** Vanilla vector RAG *cannot answer "global sensemaking"
questions* — "what are the main themes across the whole corpus?" — because those
have no single semantically-similar chunk to retrieve; the answer is a property
of the *whole graph*. GraphRAG pre-computes the corpus-level map (community
summaries) so those global questions become answerable
(https://arxiv.org/html/2404.16130v2, §"local to global").

**Scale where it pays off.** Large, messy, cross-document corpora (the paper's
demo: ~1M-token podcast/news datasets) where the *questions are thematic*.
Explicitly **not** worth it for lookups: the field consensus is "'what does
document X say about Y?' doesn't need a knowledge graph … for simple factual
retrieval, vector RAG is faster, cheaper, and equally accurate"
(https://sider.ai/blog/ai-tools/is-graphrag-worth-it-a-hands-on-review-of-the-graph-powered-rag-paradigm).

**Cost reality (the anti-pattern flag).** The index requires **an LLM call per
chunk** for entity extraction plus LLM summaries per community. Concrete
numbers: indexing the ~1M-token podcast set took **281 minutes on GPT-4-turbo**
(https://arxiv.org/html/2404.16130v2); early-2024 enterprise indexing runs were
reported at **$33,000**, and even a single 32K-word book costs ~$7 to index
(https://medium.com/graph-praxis/the-graphrag-cost-cliff-how-33-000-became-33-in-eighteen-months-be1b0fbe37e4).
Costs have fallen and cheaper variants exist (FastGraphRAG using spaCy/NLTK
instead of an LLM extractor; KET-RAG multi-granular indexing,
https://arxiv.org/html/2502.09304v2), but the *shape* stands: GraphRAG is an
LLM-heavy, multi-stage, non-deterministic indexing pipeline. That is the polar
opposite of "relatively simple AND self-hostable."

**What transfers — TWO concepts, both strong.**

1. **The decision corpus IS a graph, and its edges are the coherence signal.**
   GraphRAG's core insight is "model the corpus as a typed graph and reason over
   edges." Our frontmatter already declares the edges: `supersedes`,
   `superseded-by`, `depends-on`. **These ARE graph edges.** The coherence gate
   the epic wants (flag supersede-conflicts / contradictory active decisions) is
   a **graph-analysis pass** over exactly this graph — and it is *cheap and
   deterministic* because **we skip the expensive part**. GraphRAG spends its
   entire budget on *extracting* entities and edges from prose with an LLM; **we
   have no extraction step** — the entities are the docs (one node per file) and
   the edges are authored in frontmatter. The gate reduces to standard graph
   checks with zero LLM calls:
   - cycle detection in `supersedes` (A supersedes B supersedes A),
   - "superseded-but-still-`status: active`" (edge/status contradiction),
   - dangling edges (`depends-on` a non-existent / withdrawn id),
   - two `active` decisions both claiming to be the authority on the same
     `tags` scope (contradiction candidate → flag for human, don't auto-resolve).
   This is the direct analogue the epic names (`scenarios --aggregate` / the
   ADR-047 coherence gate). GraphRAG is the *proof that edge-reasoning catches
   corpus-level incoherence*; we get that proof's benefit for near-zero cost
   because our edges are pre-declared.

2. **Community summaries ARE an index — and our L1 digest is the degenerate,
   better version of one.** GraphRAG generates community summaries so a reader
   (LLM) can grasp the corpus without ingesting all of it. That is *exactly the
   job of our L0/L1 index* (llms.txt / OKF style, per 00-plan.md:35). The
   difference: GraphRAG must *invent* the communities (Leiden) and *write* the
   summaries (LLM) because its source is undifferentiated prose. Our
   "communities" are already authored — `tags` groups, `depends-on` clusters —
   and our "summaries" are already authored — the `description` (L0) and
   `decision` (L1) fields. So we get GraphRAG's community-summary index **as a
   deterministic projection of frontmatter**, no Leiden, no summary LLM.

**What does NOT transfer — the entire indexing pipeline.** LLM entity
extraction, Leiden community detection, LLM community summarization, the
map-reduce global-query engine. All of it is machinery for *recovering
structure that our corpus already has explicitly*. Running Leiden over 100 docs
to "discover" communities we already declared in `tags` would be
build-a-cathedral-to-hang-a-picture.

**Overkill verdict:** PIPELINE REFUTED, GRAPH-MODEL CONFIRMED. Borrow "corpus as
typed graph; coherence via edge analysis; the edge index is the distributable
map." Reject the LLM extraction/detection/summarization pipeline — we already
hold, by authoring convention, everything that pipeline exists to reconstruct.

---

## (c) Anthropic contextual retrieval — prepend context to chunks before embedding

**What it is.** Before embedding a chunk, use an LLM to write a 50–100-token
blurb situating that chunk in its parent document ("This section discusses X in
the context of document Y about Z"), prepend it, then embed **and** BM25-index
the augmented chunk. Combined with reranking it cuts top-20 retrieval failures
by up to **67%** (https://www.anthropic.com/engineering/contextual-retrieval;
https://www.datacamp.com/tutorial/contextual-retrieval-anthropic).

**Problem it solves.** Chunk-level embeddings lose document context ("revenue
grew 3%" — *whose* revenue, *when*?), so retrieval misses. The prepended context
restores enough grounding that the chunk retrieves correctly.

**Scale where it pays off.** Anthropic is unusually explicit, and this is the
**single most load-bearing external quote for our whole design**:

> "For knowledge bases smaller than 200,000 tokens (about 500 pages of
> material), … you can just include the entire knowledge base in the prompt …
> no need for RAG or similar methods."
> — https://www.anthropic.com/engineering/contextual-retrieval

Above 200K tokens, retrieval becomes necessary and contextual retrieval helps.
One-time preprocessing cost is quoted at **$1.02 per million document tokens**,
made affordable by prompt caching the reference doc across its chunks.

**What transfers.** *Mechanically, nothing* — we are not chunking, not
embedding, not doing similarity retrieval. But the **threshold is a direct
green-light for our architecture**: our L1 decisions digest for ~100 docs is far
under 200K tokens, so the correct design per Anthropic is **"put the whole
digest in context, skip retrieval entirely."** That is *literally what
distributing the L1 digest to a BC does* (00-plan.md:35 "L1 digest distributed
to BCs"). Contextual retrieval validates, from the vendor whose models we run,
that at our scale the entire retrieval apparatus is unnecessary — the right move
is a single, whole, in-context artifact. Our L0/L1/L2 tiering is then not a
retrieval optimization at all; it is a **context-budget / relevance-triage**
optimization (give the agent the smallest tier that answers its task), which is
a much simpler thing to build than a retriever.

**One transferable nuance for L1 quality.** Contextual retrieval's real lesson
is "a fragment is useless without its context." For our L1 decision statements
that means: **an L1 entry must be self-contained** — the `decision` field must
read correctly *standalone*, carrying its own `status` and `supersedes` so a BC
that receives only L1 is never conforming to an orphaned or superseded
statement. That is the anti-"context-loss" principle applied to authoring, not
to embedding.

**Overkill verdict:** MECHANISM REFUTED (no embedding/retrieval at our scale),
THRESHOLD + SELF-CONTAINMENT PRINCIPLE CONFIRMED. This source is best read as
*permission to NOT build a retriever*.

---

## Cross-cutting: transferable mechanics vs. overkill flags

**Transferable mechanics (borrow these):**
- **Tiered abstraction, retrieve-by-task** (from RAPTOR) → our L0/L1/L2, but
  deterministic projections of authored fields, not LLM cluster-summaries.
- **Corpus-as-typed-graph; coherence via edge analysis** (from GraphRAG) → the
  coherence gate = deterministic graph checks over authored `supersedes` /
  `superseded-by` / `depends-on` edges. No LLM.
- **A pre-computed map/index of the corpus** (GraphRAG community summaries;
  llms.txt) → our generated L0/L1 index, projected from `description` /
  `decision` / `tags`.
- **Self-contained fragments** (from contextual retrieval) → L1 decision
  statements must stand alone with their own status/supersedes.
- **"Under 200K tokens, skip retrieval, load whole"** (Anthropic threshold) →
  distribute the L1 digest whole; no retriever, no vector DB.

**Overkill / anti-pattern flags (do NOT build these):**
- **LLM summarization of tiers** (RAPTOR nodes) — reintroduces summary/full
  drift; our tiers are authored fields, not synthesized text.
- **Cluster discovery** (RAPTOR GMM/UMAP/BIC; GraphRAG Leiden) — we already
  declared the groupings in `tags`/edges; discovering them is redundant compute.
- **LLM entity/relationship extraction** (GraphRAG index) — our "entities" are
  files and our "relationships" are frontmatter edges; nothing to extract.
- **Embedding + vector store + reranker** (contextual retrieval, all vector RAG)
  — corpus is under the threshold where retrieval is needed at all.
- **Non-deterministic indexing pipelines generally** — violates the epic's
  single-source, no-drift, deterministic-generation requirement AND the
  operator's "simple + self-hostable" constraint. Every LLM call in an index
  pass is a determinism leak and a self-hosting cost.

**The scale argument, stated plainly.** RAPTOR, GraphRAG, and contextual
retrieval are all answers to "the corpus is too big to fit in context, and its
structure is buried in prose." Our corpus is (1) small enough to fit whole at L1,
and (2) already structured by authored frontmatter. Both premises of the
advanced-RAG world are false for us. Adopting their *mechanisms* would be
importing a solution to a problem we don't have and forfeiting the determinism
we need. This is the same conclusion pattern as the substrate comparison
(`substrate-candidate-comparison-vs-fabro.md`): powerful general tools, wrong
fit for a small, invariant-constrained, self-hosted system.

---

## What this means for OUR L0/L1/L2 + generated-index + coherence-gate goals

1. **L0/L1/L2 is sound and externally corroborated** (RAPTOR = tiered
   abstraction is real). But build it as **deterministic field-projection**, not
   LLM summarization. L0 = project `id,title,description`; L1 = project
   `id,title,decision,status,supersedes,superseded-by`; L2 = the file. Zero
   model calls in generation → zero drift, trivially self-hostable, a pure CLI
   projection (fits the "decisions" CLI-sibling-of-scenarios shape).

2. **Retrieval is a non-goal at our scale.** Do not build embeddings / vector
   store / reranker. Anthropic's 200K-token threshold says: distribute the L1
   digest *whole* and let the agent read the tier it needs. The problem is
   **triage + budget**, not **search**. This dramatically shrinks the build.

3. **The coherence gate is the highest-value borrow, and it's cheap.** Model the
   decisions as a graph (nodes = docs, edges = `supersedes`/`superseded-by`/
   `depends-on`) and run deterministic checks: supersede cycles,
   superseded-yet-active status conflicts, dangling edges, and multiple active
   authorities on one `tags` scope (flag, don't auto-resolve). This is the
   GraphRAG edge-reasoning insight with the expensive extraction stage deleted —
   a direct analogue to `scenarios --aggregate` / the ADR-047 coherence gate.

4. **The generated index is a "community-summary map" we get for free.** Because
   `description`/`decision`/`tags` are authored, the machine+human index
   (llms.txt / OKF) is a deterministic dump — no Leiden, no summary LLM. Group
   by `tags` for the human view; emit L0 lines for the machine view.

5. **Author L1 to be self-contained** (contextual-retrieval lesson): a BC that
   receives only the L1 decisions digest must never be able to conform to a
   superseded or context-orphaned statement — so `status` and `supersedes` ride
   *inside* each L1 entry, and the gate refuses to publish a digest containing an
   active-but-superseded contradiction.

6. **Anti-pattern budget for the eventual PDR/experiment:** the experiment
   (07-experiment.md) should prove the *deterministic projection + graph gate*
   path on real repo ADRs and explicitly demonstrate we did **not** need
   embeddings, clustering, or LLM summarization to hit every epic goal. If the
   spike ever reaches for a vector store or an LLM summarizer, that is the signal
   we've over-built past our scale — treat it as a REFUTED branch.

**Stream verdict:** for hierarchical-retrieval prior art →
**go-with-caveats**. Borrow the *concepts* (tiers; typed-edge graph + coherence;
pre-computed map; self-contained fragments) and the *200K-token "don't retrieve"
threshold*; **reject every mechanism** (LLM summarization, cluster discovery,
entity extraction, embedding/vector/rerank pipelines) as overkill for a ~100-doc,
deterministic, self-hosted, drift-averse system.
