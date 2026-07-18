---
type: brief
id: brief-024
title: Migrate the ~119-file legacy artifact corpus forward into the modern typed-artifact system
status: ready
created: 2026-07-17
updated: 2026-07-17
authors: ["David Stenglein (product authority)", "Claude (lead-po)"]
description: Executable migration spec for moving this repo's ~119 pre-modernization pdr/adr/brief files (bold-label statuses, no frontmatter, numeric-slug filenames) forward onto the modern typed-artifact system (PDR-032/ADR-059) so the knowledge coherence gate — correct as built — runs green over the real corpus. Folds in all 2026-07-17 product-authority decisions — uniform-plural directories, synthetic legacy grounding in place of a legacyRoot exemption, findings-plane exclusion, and unincorporated-decision wiring. This is cand-005's promoted Phase 5.
derives-from: [cand-005, intent-007]
candidate: cand-005
---

## Summary

### Problem / why now — the reframe

This repo carries ~119 legacy artifact files — **33 in `pdr/`, 63 in `adr/`,
23 in `briefs/`** (counts verified 2026-07-17) — authored before the modern
typed-artifact system (PDR-032 / ADR-059) existed. Every one of them (with a
single exception, below) uses the pre-modernization conventions: no YAML
frontmatter, a bold-label `**Status:** accepted (2026-06-10)` header, and a
numeric-slug `NNN-slug.md` filename. Running `shop-knowledge validate` over
them fails 100% (`lead-6n4j6`), and `shop-knowledge-gate` cannot see them as
typed artifacts at all.

The load-bearing correction this brief records: **the tool is correct as
built; the corpus is what is stale.** The earlier direction — teach the
knowledge loader to *tolerate* legacy structure (originating in `lead-cea24`'s
framing) — is reframed by the product authority as a **mis-diagnosis**. The
coherence-gate CLI, its loader, and the eight typedefs are all
correct-as-designed against the modern layout; bending them to accept legacy
prose would re-introduce exactly the dual-format drift PDR-032/ADR-059 exist
to eliminate. The fix flows the other way: **migrate the corpus forward** to
the spec the tool already enforces.

### What changed on 2026-07-17 (the executable-spec revision)

This revision folds in the product-authority decisions from the 2026-07-17
design session (David + Claude), converting the prior shape-first draft into
the **executable spec the router runs against**. The two prior open
ratifications (RISK 1, RISK 2) are now **settled**, and the settlement changes
the mechanics materially:

1. **Uniform-plural directories.** `pdr/ -> pdrs/`, `adr/ -> adrs/`,
   `intent/ -> intents/`; `candidates/ sessions/ briefs/` are already plural.
   The **`intents/` rename is sequenced behind a separately-dispatched
   `shopsystem-knowledge` loader fix** (`SUBDIR_TYPES intent-record -> intents`)
   that must land first; `pdrs/`/`adrs/` proceed immediately because the loader
   already expects those plural keys (the very mismatch `lead-iohr`/`lead-cea24`
   surfaced).

2. **Synthetic grounding replaces the legacyRoot exemption (the big reversal).**
   The prior draft's RISK 1 recommended a `root: true` / `legacyRoot` typedef
   exemption via a knowledge-BC dispatch. **That is rejected.** There is **no
   `finding` type and no `legacyRoot` field.** Legacy artifacts that lack a
   real in-graph upstream are grounded by **authoring synthetic upstream
   artifacts** (synthetic intents/candidates/pdrs/sessions) that title
   themselves `Legacy: …`, giving each true genesis-root ADR/PDR a **real,
   resolvable `derives-from` target**. This keeps the corpus one consistent
   typed graph with no special escape fields, and needs **no typedef change** —
   it is lead-side authorship. Proven this session on `adr-001`: the synthetic
   chain `adr-001 -> pdr-900 -> cand-900 -> intent-900` (plus a synthetic
   session that produced them) validates **conforming** and the gate resolves
   the full chain with **zero dangling**.

3. **Provenance preserved in body (RISK 2 ratified).** All date / ratifier /
   amendment / refined-by prose stripped from the legacy `**Status:**` line
   relocates to a `## Provenance (pre-modernization)` body section. Verified
   validate-safe (extra sections conform). Lead-side, loss-free, no BC
   dependency.

4. **Findings plane stays OUTSIDE the coherence graph.** Per the
   spike-precedence rule (David 2026-07-06) and ADR-032/PDR-016, `findings/` is
   non-authoritative, historical-reference-only — the reason there are 8 types
   and no `finding` type. Durable/cited findings content is **absorbed as
   NOTES** into the synthetic-grounding artifacts (or the citing ADR/PDR).
   **Full `findings/` deletion is a staged follow-on phase, not this pass** —
   findings are off-graph, so leaving them does not block gate-green.

5. **Unincorporated-decision wiring.** The gate warns when an accepted `pdr`/
   `adr` is not claimed in `current-state.md`'s `incorporates` list. Every
   accepted decision is claimed as an explicit migration step.

The governing frame behind decisions 2–4 is the **object-graph provenance
model** decided 2026-07-17 (Scenario -> PDR -> Candidate -> Intent -> Session,
uniform single-parent spine). Its **scenario-side enforcement parts**
(always-PDR / `scenario.definedBy` / provenance-field enforcement) are
**captured as decision but built later** — see Scope. **The router should
record the governing decision as an ADR** (author-flagged below); this brief
executes only the corpus-migration slice of that model.

### The pinned target spec (the acceptance target)

Empirically verified by the Architect against `shopsystem-knowledge`
`@69dd0cd`; this brief builds on it. A migrated corpus is "done" when it
matches this spec and the gate runs green over it.

| Dimension | Target |
|---|---|
| **Tool** | `shop-knowledge` (`template`/`schema`/`validate`) + `shop-knowledge-gate <root>`. All 8 types recognized; **pdr/adr/brief typedefs already exist and are correct — no typedef-defining BC dispatch needed.** |
| **Target dirs** (all PLURAL) | `pdr/` → **`pdrs/`**, `adr/` → **`adrs/`**, `intent/` → **`intents/`** (gated on BC loader fix — Phase 0), `candidates/ sessions/ briefs/` already plural (their files still migrate). |
| **id patterns** | `pdr-NNN` / `adr-NNN` / `brief-NNN` / `intent-NNN` / `cand-NNN` / `sess-YYYY-MM-DD-x` (pattern-locked). |
| **Filenames** | `<id>.md` — e.g. `pdrs/pdr-032.md`, `adrs/adr-059.md`, `briefs/brief-023.md`, `intents/intent-001.md`. |
| **Required frontmatter** | shared 8: `type, id, title, status, created, updated, authors, description` — PLUS per-type: pdr → `+decision-makers, derives-from`; adr → `+derives-from` (**MUST be non-empty & resolvable**); brief → `+derives-from` (present; may be empty). |
| **`derives-from` gate** | **adr** derives-from must be **non-empty**; **pdr** derives-from **present, may be empty**; **brief** derives-from **present, may be empty**. (Re-confirmed empirically: an `adr` with `derives-from: []` validates non-conforming; `pdr`/`brief` tolerate empty.) So the hard grounding gate is **ADR-only**. |
| **Required body sections** | pdr → Context / Options considered / Decision / Consequences; adr → Context / Decision / Consequences; brief → Summary / Scope. (Extra sections tolerated — a `## Provenance` section validates `conforming`.) |
| **Status enums** (membership only) | pdr/adr → `proposed, accepted, superseded, rejected`; brief → `draft, ready, delivered, withdrawn`. |
| **id-derivation** | loader keys on frontmatter `id:`, not filename — adding frontmatter fixes id resolution regardless of filename; the `<id>.md` rename is still performed. |

### The status-label → enum mapping (defined here)

Every legacy `**Status:**` line becomes the **bare enum member only**; all
date, ratifier, amendment, `rev-N`, `as amended`, and trailing prose is
**stripped into the `## Provenance (pre-modernization)` body section**.

**pdr / adr** (target enum `proposed, accepted, superseded, rejected`):

- `accepted` / `Accepted` (with any `(date)`, `(ratified by X, date)`,
  `as amended`, `rev-N`, trailing clause) → **`accepted`**
- `decided` → **`accepted`** (a decision was ratified)
- `proposed` / `Proposed` → **`proposed`**
- `draft` → **`proposed`** — the pdr/adr enum has **no `draft` member**; a
  not-yet-accepted decision is `proposed`. This is the one semantically lossy
  mapping, called out explicitly.
- prose indicating superseded / retired / replaced → **`superseded`**;
  rejected / declined / abandoned → **`rejected`**.

**brief** (target enum `draft, ready, delivered, withdrawn`):

- `draft` (with `, narrowed`, `, intent gaps resolved`, `(date)`) → **`draft`**
- `committed` → **`ready`**
- `ready for architect dispatch` → **`ready`**
- prose indicating dispatched-and-landed → **`delivered`**; withdrawn /
  abandoned → **`withdrawn`** (applied only on clear evidence; default is to
  preserve the mapped `draft`/`ready` value).

### The synthetic-vs-real `derives-from` decision rule (defined here)

Applied **per legacy ADR and PDR** during frontmatter synthesis. Its purpose
is to satisfy the ADR non-empty-`derives-from` gate **without fabricating false
edges and without a `legacyRoot` field**, while **minimizing synthesis** —
many legacy ADRs already cite real PDRs/ADRs and need only an edge rewrite, not
a manufactured upstream.

For each legacy artifact **A**:

1. **Collect real upstream citations.** Enumerate every `pdr`/`adr`/
   `candidate`/`intent` id A references in its prose or markdown links that is
   itself a node in the migrating corpus (will resolve to a real typed file
   post-migration). Findings citations do **not** count (findings are
   off-graph).
2. **Kind-legality filter.** An **ADR** may `derives-from` a `pdr` or `adr`; a
   **PDR**'s spine parent is a `candidate` (its `derives-from` may also be
   empty and still validate).
3. **REAL grounding (preferred, no synthesis).** If A has ≥1 kind-legal
   citation resolving to a real in-corpus node, **rewrite that citation as A's
   `derives-from` edge** — no synthetic artifact is authored. Example:
   `ADR-059 refines PDR-032` → `derives-from: [pdr-032]`.
4. **SYNTHETIC grounding (only for true genesis roots).** A is a true genesis
   root only if it cites **only findings, or nothing, or only kind-illegal
   targets**. Then:
   - author (or **reuse**) a synthetic upstream chain titled `Legacy: <theme>`
     in the reserved **`9NN` id block** — a synthetic `intent-9NN` ← `cand-9NN`
     ← (for an ADR root) `pdr-9NN`, plus a synthetic `sess-*` whose `produced`
     list names them (proven pattern: `adr-001 -> pdr-900 -> cand-900 ->
     intent-900`);
   - **absorb** the genesis finding content (if any) as NOTES inside the
     synthetic `pdr-9NN`/`cand-9NN`;
   - point A's `derives-from` at the synthetic node of the **correct kind** (an
     ADR → the synthetic `pdr-9NN`; a PDR root that must be grounded → the
     synthetic `cand-9NN`).
5. **Reuse over proliferation.** Legacy roots sharing one genesis theme
   **share one synthetic chain** (one synthetic intent/candidate, one per-theme
   synthetic pdr) rather than each minting its own; mint a new chain only for a
   genuinely distinct genesis. The **filter handle is the `Legacy:` title
   prefix** (ids are pattern-locked, so the title carries the "this is
   synthetic scaffolding" signal).

**Note on PDRs and briefs:** because `pdr`/`brief` `derives-from` may be empty
and still validate + not dangle, PDR/brief genesis roots do **not** require
synthetic grounding for gate-green; ground a PDR root synthetically only where
full-trace-to-intent is wanted for that specific chain. The **hard grounding
requirement is ADR-only.**

## Scope

### In scope (this pass)

- The **119 legacy files** in `pdr/` (33), `adr/` (63), `briefs/` (23):
  directory rename to plural, filename rename to `<id>.md`, frontmatter
  synthesis, status-label→enum mapping, provenance preservation in body.
- The **`intent/` → `intents/`** directory + filename rename (gated on the
  Phase-0 BC loader fix). `intent/` files are already typed (cand-005 Phase 1),
  so this is rename + link-rewrite, not frontmatter synthesis.
- **Synthetic legacy grounding** for true genesis-root ADRs (and any PDR roots
  explicitly chosen for full-trace), per the decision rule above, with
  absorbed findings content as NOTES.
- **All cross-link and edge-id rewrites** the renames break — markdown relative
  links AND frontmatter edge-id lists (`derives-from`, `supersedes`,
  `superseded-by`, `depends-on`, `incorporates`, `produced`) — across all
  migrated files **and** the already-modern July artifacts that reference
  legacy ids.
- **Unincorporated-decision wiring**: every accepted `pdr`/`adr` claimed in
  `current-state.md`'s `incorporates` list.
- The **gate-green acceptance check** over the migrated corpus.

### Explicitly out of scope (this pass)

- **The object-graph model's scenario-side enforcement** — always-PDR
  (`scenario.definedBy -> PDR` required), the `@origin:bead` → `scenario.definedBy`
  layering inversion, and provenance-field enforcement. **Captured as decision
  in the governing ADR; built later.** This pass instantiates only the
  artifact/provenance-graph *corpus* slice.
- **Full `findings/` deletion** — durable content is absorbed as NOTES this
  pass; the directory's removal is a **named later phase** (Phase 6), not this
  pass, because findings are off-graph and their presence does not block
  gate-green.
- **`pdr/034-*.md`** — already fully typed (`id: pdr-034`, real frontmatter).
  **Move it to `pdrs/pdr-034.md`; do NOT re-frontmatter it.** Rename target only.
- **Redesigning the schema, typedefs, status vocabulary, or lifecycle
  semantics** — this is a forward-migration onto the *existing* spec. The only
  sanctioned BC touch is the one-line `SUBDIR_TYPES intent-record -> intents`
  loader mapping fix (Phase 0), which is a directory-key change, **not** a
  typedef change.
- **`candidates/`, `sessions/`, `current-state.md`** frontmatter — already
  typed; residual conformance gaps there are `lead-6n4j6`/brief-018 territory,
  not this brief. (Their **edge-id lists and `incorporates` list ARE rewritten/
  wired** here where they reference migrated ids — Phases 4/5.)
- **The `shop-knowledge-gate` UTF-8 guard** — throws on a non-UTF-8 file in a
  walked dir. Noted, not scoped; if hit during migration, track separately.
- **CI/pre-commit changes** — `bin/check-knowledge-artifacts` (cand-005 Phase 3)
  already warns-not-blocks on modified legacy files precisely so this migration
  can proceed; no change here.

## Migration plan — ordered, executable phases

Each phase's output is verifiable before the next begins. The only hard
cross-phase sequencing gate is the **BC loader fix (Phase 0) → `intents/`
rename (Phase 3)**; `pdrs/`/`adrs/` (Phases 1–2) proceed without waiting on it.

### Phase 0 — Prerequisites and sequencing gates (author-flagged)

- **Author the governing ADR.** Record the 2026-07-17 object-graph provenance
  model + spike-plane exclusion + synthetic-grounding + uniform-plural-directory
  decision as an ADR (the audit trail this migration executes against).
  **Author-flagged for the router** — the router drives ADR authorship/dispatch;
  this brief only flags it.
- **Dispatch the BC loader fix for `intents/`.** `shopsystem-knowledge`
  one-line `SUBDIR_TYPES intent-record -> intents`. Dispatched **separately**
  (its own `work_id`); the `intents/` rename (Phase 3) sequences behind its
  verified landing. `pdrs/`/`adrs/` need no BC change.
- **Acceptance:** the governing ADR is authored and itself validates
  `conforming`; the BC loader-fix dispatch is verified landed by installing the
  updated `shopsystem-knowledge` on the lead host and confirming a scratch
  typed file under `intents/` loads as an `intent-record` node (not dangling).

### Phase 1 — Legacy pdr/adr/brief forward migration (proceed immediately)

- Create plural dirs `pdrs/` and `adrs/`; `briefs/` already correct.
- Per-file migration of the 33 pdr + 63 adr + 23 brief legacy files:
  - synthesize YAML frontmatter — shared 8 + per-type required fields; `id`
    from the extracted `<type>-NNN`; `title` from the H1; `created`/`updated`
    from earliest/latest legacy dates; `authors` from ratifier prose where
    present else the legacy author; `description` a one-line synopsis;
  - `status` = bare enum member per the mapping table;
  - `decision-makers` (pdr) from ratifier prose;
  - `derives-from` via **REAL-citation grounding** per the decision rule
    (rewrite kind-legal in-corpus citations as edges); leave a true
    genesis-root ADR's `derives-from` empty **as the explicit input set to
    Phase 2** (do not fabricate);
  - relocate all stripped status prose into `## Provenance (pre-modernization)`;
  - ensure the required body sections exist (map legacy headings; extras
    tolerated).
- Rename each file to `<id>.md` under its (plural) dir; move `pdr/034` to
  `pdrs/pdr-034.md` untouched. Retire empty `pdr/`, `adr/`.
- **Acceptance:** every `pdrs/*.md` and `briefs/*.md` validates `conforming`;
  every `adrs/*.md` that received REAL-citation grounding validates
  `conforming`; the residual set = true genesis-root ADRs with empty
  `derives-from`, **enumerated as the Phase 2 work list**.

### Phase 2 — Synthetic legacy grounding for genesis roots

- For the Phase-1 residual genesis-root ADRs (and any PDR roots explicitly
  chosen for full-trace), author/reuse `Legacy: …`-titled synthetic chains in
  the `9NN` id block per the synthetic-vs-real rule; absorb genesis findings
  content as NOTES in the synthetic artifacts; set each root's `derives-from`
  to the correct-kind synthetic target.
- **Acceptance:** every `adrs/*.md` now validates `conforming` (non-empty,
  resolvable `derives-from`); each synthetic `intent-9NN`/`cand-9NN`/`pdr-9NN`/
  `sess-*` validates `conforming`; `shop-knowledge-gate` over
  `pdrs/`+`adrs/`+synthetic reports **zero dangling** for these edges (the
  `adr-001 -> pdr-900 -> cand-900 -> intent-900` pattern, generalized).

### Phase 3 — `intents/` rename (gated on Phase 0 BC fix)

- **Precondition:** Phase 0 BC loader fix verified landed. If not landed, this
  phase does not start; Phases 1–2 and 4–5 (for non-intent targets) are not
  blocked by it.
- Rename `intent/` → `intents/`; rename files to `intents/intent-NNN.md`;
  confirm frontmatter (already typed — rename + link-rewrite, no synthesis).
- **Acceptance:** every `intents/*.md` validates `conforming` and loads as an
  `intent-record` node under the new plural key (not dangling).

### Phase 4 — Cross-link + frontmatter edge rewrite (whole corpus)

- Rewrite every reference broken by the renames:
  - **markdown relative links** — `[PDR-031](031-….md)`, `../adr/059-….md`,
    `../intent/007-….md` → the new `../pdrs/pdr-031.md`, `../adrs/adr-059.md`,
    `../intents/intent-007.md` forms;
  - **frontmatter edge id-lists** — `derives-from` / `supersedes` /
    `superseded-by` / `depends-on` / `incorporates` / `produced` — across all
    migrated files **and** the already-modern July artifacts referencing legacy
    ids (`current-state.md`'s `incorporates`, `sessions/*`'s `produced`,
    `candidates/*`'s edges, etc.).
- **Acceptance:** `shop-knowledge-gate .` reports **zero `dangling-edge`
  findings** across the full corpus.

### Phase 5 — Unincorporated-decision wiring

- Claim every accepted `pdr`/`adr` in `current-state.md`'s `incorporates`
  list, so the gate's `unincorporated-decision` rule does not warn.
- **Acceptance:** `shop-knowledge-gate .` emits **zero `unincorporated-decision`
  findings**; every `incorporates` edge resolves (no new dangling introduced).

### Phase 6 — `findings/` deletion (STAGED FOLLOW-ON — named later phase, NOT this pass)

- After durable/cited findings content is absorbed as NOTES (inline in Phases
  2/4), remove `findings/` entirely. Deferred because findings are off-graph;
  their presence does not block gate-green, so deletion need not gate this
  migration. Executed as its own later pass, not silently dropped.
- **Acceptance (when run):** `findings/` absent; a full re-run of
  `shop-knowledge validate` (per file) + `shop-knowledge-gate .` still reports
  conforming + zero dangling (i.e. nothing in the graph depended on `findings/`).

## Definition of done (whole-corpus acceptance)

The migration (Phases 0–5) is accepted when, over the migrated corpus:

- **`shop-knowledge validate <file>` → `conforming` for every migrated file**
  (all 119, plus `pdrs/pdr-034.md`, plus every synthetic `9NN`/`sess-*`
  grounding artifact, plus every renamed `intents/*.md`).
- **`shop-knowledge-gate .` → zero `dangling-edge` findings** — every rewritten
  link and frontmatter edge resolves to a real typed target (including the two
  former `lead-cea24` grounding cases: PDR-034's `supersedes:[pdr-032]`;
  `current-state.md`'s `incorporates` list).
- **`shop-knowledge-gate .` → zero `unincorporated-decision` findings.**
- No `status` field carries date/qualifier prose; every `status` is a bare
  enum member of its type's enum.

## Dependencies and lead-side executability

- **Synthetic grounding, provenance-in-body, status mapping, renames, link/edge
  rewrites, unincorporated wiring** are **all lead-side** — no typedef change,
  no `legacyRoot` field, no `finding` type.
- **The only BC dependency is Phase 0's one-line `SUBDIR_TYPES
  intent-record -> intents` loader fix**, and it gates **only** the `intents/`
  rename (Phase 3). Everything else proceeds without it.
- `lead-cea24` (the P1 filed to make the gate tolerate legacy structure) is
  **disposition: close as reframed** once this migration lands and the gate runs
  green — its two "defects" (singular-dir mismatch, numeric-slug id-derivation)
  are the corpus being stale, now fixed by moving the corpus forward. The
  `intent-record -> intents` loader mapping is the one genuine BC item that
  survives, tracked via Phase 0.

## Changelog

- 2026-07-17 opened as a shape-first draft (cand-005 Phase 5), pinning the
  target spec, status-label→enum mapping, and two open ratifications (RISK 1
  root-ADR grounding; RISK 2 provenance loss).
- 2026-07-17 revised into the **executable spec** after the product-authority
  design session: RISK 1 resolved by **synthetic legacy grounding** (rejecting
  the `root:true`/`legacyRoot` typedef exemption; no `finding` type); RISK 2
  ratified as the `## Provenance (pre-modernization)` body section; uniform-
  plural directories added (`intent/ -> intents/` sequenced behind a BC loader
  fix); findings-plane exclusion + staged `findings/` deletion; unincorporated-
  decision wiring; the object-graph model's scenario-side enforcement scoped
  out (captured for the governing ADR, built later). Restructured as ordered
  Phases 0–6 with per-phase acceptance checks. Status `draft -> ready`.
