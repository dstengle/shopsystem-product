# Grounding record — Corpus scope for the understanding path (intent-012 / epic lead-fb3vk)

*Experiment: ground first via `shop-knowledge` only, record the grounding inspectably, then decide against it. Written 2026-07-27. Draft for the router — not committed, no artifact modified.*

---

## Decision

**Recommendation: DO NOT extend `shop-knowledge` to index `features/` and mailbox/bd
state. Build the understanding path as an orchestrating skill that spans three
domain-owned surfaces — `shop-knowledge` (artifact frontmatter graph), the
`scenarios` CLI (Gherkin/`features/`), and `shop-msg`/`bd` (mailbox + system
state) — each keeping its own domain.**

Justification, cited to the grounding below:

1. **Domain ownership is already decided policy, and it cuts against absorbing
   scenarios into `shop-knowledge`.** ADR-019 (accepted) settles that scenario
   canonicalization/hashing is owned by `shopsystem-scenarios` and that other
   contexts *transport* scenarios but must not *re-enact* the scenario domain —
   rendered verbatim: *"Messages carry scenarios; messages do not define what a
   scenario is"* (A4). Indexing `features/` inside `shop-knowledge` would make the
   knowledge context re-enact a domain ADR-019 explicitly walls off. The same shape
   holds for state: PDR-010 (accepted) fixes *"bd is authoritative for system state;
   shop-msg is transport"* (A5) — mailbox/bd already has an authoritative owner.

2. **`shop-knowledge` is deliberately scoped to the artifact frontmatter graph.**
   PDR-036 (accepted, the capability decision behind the CLI I grounded with) scopes
   the read-side CLI to *"the artifact frontmatter graph"* and query facets *type,
   status, tag, distribution, or edge participation* (A6). Its charter is artifacts;
   widening it to two more domains contradicts the accepted boundary.

3. **The scenarios surface is already the correct, purpose-built query tool — the
   real defect is agents not using it, not a missing index.** brief-022 (rendered,
   A7) records that `scenarios journal rebuild` / `scenarios validate --aggregate`
   already scan the whole `features/` tree correctly (`rglob("*.feature")`), and the
   documented failures came from subagents grepping instead of calling that tool.
   That is an *orchestration/routing* gap, not an *indexing* gap — so the fix is a
   skill that routes to the right owned tool, not a second index that duplicates
   (and will drift from) the scenarios contract. cand-003 ("Structured-corpus query
   tools as the primary retrieval interface," shaped) is the standing shape for
   exactly this retrieval-routing capability (A2, A7).

4. **It serves intent-012's actual goal — trust by inspection.** intent-012
   (rendered, A3) optimizes for *"legible, verifiable grounding"* where trust is
   earned by *seeing* a decision was built on current truth. Three domain-owned
   tools, each with its own contract and its own verifiable output, are *more*
   inspectable than one merged index whose provenance blurs three domains. A merged
   index adds a synchronization surface (index vs. live `features/`/mailbox) that is
   itself a new thing the authority would have to trust — the opposite of the intent.

Cost acknowledged: an orchestrating skill leaves three query dialects instead of
one, and (per section C) none of the three offers topical/full-text search today —
so this decision does not, by itself, eliminate discretionary grep. It routes grep
to owned tools where those tools exist. Closing the topical-search gap (section C)
is the follow-up that would actually retire grep.

---

## A. Tool-derived grounding (verifiable / re-runnable)

Every fact here came from a `shop-knowledge` verb. Commands are exact; re-run from
`/workspace`.

**A1 — Complete artifact inventory by type (query, full sets).**
```
shop-knowledge query --corpus . --facet type --value <pdr|adr|brief|intent-record|candidate|current-state|prioritization-record|session-record>
```
Returns the complete id/title/status list per kind. Relevant totals: 38 PDRs,
~66 ADRs, 24 briefs, 13 intent-records, 10 candidates, 1 current-state, **0
prioritization-records**, 10 session-records. Decision-topical ids this surfaced:
`intent-012`, `cand-003`, `brief-019`, `brief-022`, `pdr-031` (rejected),
`pdr-032` (superseded), `pdr-036`, `adr-019`, `adr-056`, `adr-067`, `adr-068`.

**A2 — cand-003 provenance (navigate).**
```
shop-knowledge navigate cand-003 --corpus . --direction both --format yaml
```
Edges: `derives-from → intent-004` ("Tier/provenance-aware retrieval and
citation-validation discipline for roles and subagents", recorded); `session →
sess-2026-07-15-a`. Confirms cand-003 is the live shape for retrieval-interface
work. (Note for section B: it carries **no** edge to intent-012.)

**A3 — intent-012 body (render, transformation view).**
```
shop-knowledge render intent-012 --corpus . --view transformation --format md
```
Yields the goal statement: *"legible, verifiable grounding that lets him trust by
inspection"*; *"Trust is earned by seeing that a decision was built on the current
truth, not by the absence of mistakes"*; the named solution ("knowledge tools as
the basis, eliminate grep…") is *"a means; the end is verifiable grounding."*
(The default view fails here — see C3.)

**A4 — adr-019 body: domain ownership (render).**
```
shop-knowledge render adr-019 --corpus . --view transformation --format md
```
Verbatim: `shopsystem-scenarios` = *"Scenario domain logic — canonicalization and
hashing… Separate from the messaging catalog: messages happen to carry scenarios,
but hash discipline is a scenario concern"*; module docstring *"The canonicalization
rule is part of the scenario contract, not the messaging contract… Messages carry
scenarios; messages do not define what a scenario is."* This is the
transport-not-re-enact principle the decision leans on.

**A5 — pdr-010 title/status (query A1) + edges (navigate).**
```
shop-knowledge navigate pdr-010 --corpus . --direction both --format yaml
```
Title (accepted): *"bd is authoritative for system state; shop-msg is transport +
wakeup + liveness."* Establishes the owner of the mailbox/state domain.

**A6 — pdr-036 body: the `shop-knowledge` CLI charter (render).**
```
shop-knowledge render pdr-036 --corpus . --view current-system --format md
```
Decision text scopes the CLI to *"the artifact frontmatter graph"* with three verbs
(navigate / render-with-view-filtering / query) and query facets *"type, status,
tag, distribution, or edge participation."* Options-considered rejects "three
separate tools" because they *"all read the same frontmatter graph through the same
loader"* — i.e. the CLI's cohesion argument is *one domain, one loader*, which is
itself an argument against bolting on two more domains.

**A7 — brief-022 body: scenarios tooling already serves `features/` (render).**
```
shop-knowledge render brief-022 --corpus . --view transformation --format md
```
Verbatim: *"the tool's aggregate operations (`scenarios journal rebuild`… and
`scenarios validate --aggregate`…) already scan the full tree correctly… no
path-shape assumption, no partial-scan defect. The gap is exclusively that
subagents reach for a hand-scoped `grep` instead of the tool that already gets this
right."* Edges (navigate): `derives-from → adr-056` (scenarios own the scenario
schema, enforced by `scenarios validate`), `adr-064`, `adr-018`; `candidate →
cand-003`.

**A8 — adr-068 provenance (navigate), the corpus-CLI mechanism ADR.**
```
shop-knowledge navigate adr-068 --corpus . --direction both --format yaml
```
`derives-from → pdr-036` and `→ adr-067` (base schema). Confirms the accepted read
mechanism traverses ADR-067's *materialized frontmatter edges* over artifacts —
scenarios/mailbox are not in its edge model.

**A9 — accepted-set size (query, status facet).**
```
shop-knowledge query --corpus . --facet status --value accepted   # → 61 documents
```
Used to bound the "current decided state" I'm grounding against.

---

## B. Discretionary grounding (agent judgment — scrutinize this)

**This section is the heart of the experiment. Almost all *relevance selection* was
discretionary**, because the tools offer no topical/freeform search (see C1). Flag
each:

- **B1 — Which documents are topically relevant to "corpus scope" was my judgment,
  not the tool's.** I enumerated every type with A1, then *read the titles* and
  hand-picked intent-012, cand-003, brief-022, pdr-036, adr-019, pdr-010, adr-056,
  adr-067, adr-068, pdr-031, pdr-032 as the relevant set. No tool ranked, searched,
  or filtered *by topic*; `query` only slices by type/status (tag/distribution are
  empty — C2). A reviewer cannot re-derive *this selection* from a command; they can
  only re-verify each doc once named. **This is the dominant discretionary act.**

- **B2 — Linking cand-003 and intent-012 was mine.** cand-003 is the retrieval-
  interface shape and intent-012 is the grounding intent driving *this* decision, yet
  A2 shows **no edge** between them (cand-003 derives from intent-004). I judged them
  topically coupled from their titles/bodies. The graph did not assert it.

- **B3 — Generalizing "domain ownership" from ADR-019 (scenarios) and PDR-010
  (bd/shop-msg) to a rule that binds `shop-knowledge` is my synthesis.** No single
  artifact says "therefore do not index features/ in shop-knowledge." I composed the
  principle across A4/A5/A6. Reasonable, but it is inference, not a retrieved
  decision.

- **B4 — Reading pdr-031 (rejected) / pdr-032 (superseded) as "a bundled
  one-knowledge-context-owns-everything design was already rejected/superseded" is
  from their titles only.** I did *not* render them (their non-accepted status makes
  the default render fail — C3, and I chose not to spend the transformation-view read).
  Treat this supporting point as unverified beyond the title strings in A1.

- **B5 — "A merged index adds a sync/drift surface" is a general engineering
  judgment**, reinforced by A7's drift-avoidance framing but not itself a retrieved
  fact about this corpus.

---

## C. Coverage gaps / what I could not verify via tools

Specific, quantified tool gaps encountered:

- **C1 — No freeform/full-text/topical search. This is the decisive gap.** There is
  no verb to ask "which decisions discuss indexing `features/` or mailbox state?"
  Discovery of *what is relevant* is impossible through the tools; it fell entirely
  to B1. The tools verify content I had already chosen — they do not find it.

- **C2 — The `tag` and `distribution` facets are effectively dead.** Every probe
  returned `[]`:
  ```
  shop-knowledge query --corpus . --facet tag --value <retrieval|knowledge|scenarios|corpus|artifact|grounding|messaging|fabro|migration>   # all []
  shop-knowledge query --corpus . --facet distribution --value <all|canonical|product-lead|product-wide|bc-local>                            # all []
  ```
  So the one facet that *could* approximate topical retrieval (`tag`) and the
  scope-axis facet from ADR-067 (`distribution`) return nothing — the frontmatter is
  unpopulated for both, or the query doesn't match. Either way, topical/scope-based
  querying is unavailable, forcing everything in B1.

- **C3 — `render` defaults to the current-system view and hard-fails for every
  non-accepted doc.** `render <id> --corpus .` (and `--view current-system`) returns
  *"has no current-system rendering because it is not in the accepted set"* for
  intent-012 (recorded), cand-003 (shaped), current-state-001 (current), and would
  for all draft briefs / proposed PDRs. To read the actual decision anchor (an
  intent) I had to know to pass `--view transformation`. There is no "just show me
  this doc" default; grounding on in-flight (non-accepted) work has a usability trap.

- **C4 — `navigate` is 1-hop and only as good as author-supplied edges; edges are
  sparse and sometimes topically wrong.** intent-012 has exactly one edge (its
  session). Topical adjacency is not modeled (C/B2). And the edges include noise:
  `adr-056` (scenario schema) lists `derived-by → brief-017` (fabro LLM
  provider selection), an implausible topical link. So the graph can neither be
  trusted to surface all relevant neighbours nor to exclude irrelevant ones without
  my judgment.

- **C5 — The decision's own subject matter is entirely outside the tool.**
  `features/` scenarios and mailbox/bd state cannot be inspected through
  `shop-knowledge` at all — which is precisely the thing being decided. I could not
  verify the *current* `features/`-side or mailbox-side facts through the sanctioned
  path; I relied on brief-022's *rendered description* of the scenarios tooling
  (A7), not on querying `features/` itself. (Doing so directly would require the
  `scenarios`/`shop-msg` CLIs — exactly the point of the "each keeps its own domain"
  recommendation.)

- **C6 — No "current set" default filter.** To reason over "current decided state" I
  had to hand-filter by `status` (A9 gives the count, but assembling the set is
  manual per type).

---

## Honest read on the A/B ratio

**Content verification was strongly tool-derived; relevance selection was almost
entirely discretionary.** Once I named a document, the tools let me verify its
status, its edges, and its exact text re-runnably (A1–A9) — that half is solid and a
reviewer can reproduce it. But *deciding which ~11 of ~200 documents mattered* had
no tool support at all: `tag` and `distribution` return nothing (C2), there is no
freeform search (C1), and navigate's edges are too sparse/noisy to walk to relevance
(C4). So if you weight by "load-bearing grounding for the decision," the relevance
spine is discretionary (B1 dominates), with the tools supplying verifiable *evidence
for* choices I made by reading titles.

**The single missing tool that would move the most from B to A: a topical/full-text
search verb over artifact titles + bodies (equivalently, a populated, queryable
`tag` index).** That one capability collapses B1, B2, and B4 into re-runnable
commands — it would let a reviewer reproduce not just "is this doc's text X?" but
"is this the *relevant set*?", which is the trust question intent-012 actually
cares about.
