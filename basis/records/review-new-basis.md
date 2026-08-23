---
type: review-record
id: review-new-basis
status: open
conversation-type: review
work-item: lead-kmrd4
created: 2026-08-10
updated: 2026-08-22
---

# Review record: the new-basis experiment

## Material

- [`basis/`](../README.md) on `experiment/new-basis` — the experiment
  index is the walkthrough and the approval surface.
- The amended [principle set](../principles.md) and the draft seed
  typedefs, processes, and types the index lists.

## Rulings

R1–R18 predate this record type and are recorded in the
[experiment index](../README.md) — grandfathered there, linked here as
the ledger's opening span. From R19 the ledger lives in this record.

- **R19 (2026-08-22).** Conversations get definitions: the
  process-definition typedef gains the run lifecycle (running / held /
  done / cancelled; `hold-after` auto-parks inactive runs with a resume
  point) and sub-process steps (a conversation invoked from a parent
  process is a branched conversation, `branched-from` on its anchor);
  [`review-record`](../artifacts/review-record.md) is the anchor type;
  [`review-conversation`](../processes/review-conversation.md) defines
  the conversation this review has been all along; this record is the
  first instance. Applied: this file, both definitions, glossary terms
  (run, hold, checkpoint, branched conversation), compiler sub-process
  rendering.

- **R20 (2026-08-22).** The conversation-model package is approved:
  [`review-record`](../artifacts/review-record.md) and
  [`review-conversation`](../processes/review-conversation.md) carry
  `approved: 2026-08-22`; the run-lifecycle and sub-process amendments
  ride the process-definition typedef's own pending approval. Directed
  and applied: the remaining two conversation types —
  [`discovery-conversation`](../processes/discovery-conversation.md)
  (interlocutor dialogue; closes onto a session record by invoking
  session-handoff as the first sub-process step; nothing operationalized
  before the authority converges) and
  [`work-conversation`](../processes/work-conversation.md) (scoped to
  one work item; every exchange lands as a comment on it; closing the
  conversation does not close the item). Both draft, compiled, linted.

- **R21 (2026-08-22).** The discovery and work conversation types are
  approved:
  [`discovery-conversation`](../processes/discovery-conversation.md) and
  [`work-conversation`](../processes/work-conversation.md) carry
  `approved: 2026-08-22`. All three conversation types now stand
  approved; every conversation in the lead shop has a defined type,
  anchor, and end.

- **R22 (2026-08-22).** The memory action table is approved as amended
  and executed: 55 retire, 11 route-to-chain, 1 to backlog. Amendments:
  the archive lives on the branch `archive/memory-2026-08`, never on
  `main` (context-poisoning risk); the sc06 scenario body rides in
  backlog work item lead-df2pj, not the archive. Executed: archive
  branch pushed (verbatim, all 67), six chain-input work items filed,
  bulk forget completed — `bd memories` returns zero. The memory channel
  is closed; conversation anchors own cross-session state.

- **R23 (2026-08-22).** The remaining approval surface is approved: the
  nine-principle working set (`approved: 2026-08-22` — the prompt
  rendering regenerated with it), all nine seed typedefs, the
  definition-chain-migration and session-handoff processes, and the
  three supporting data types. Nothing on the branch remains in draft.
  The seed layer stands; migration is unblocked behind the migration
  plan's regeneration.

- **R24 (2026-08-22).** Migration plan rev 2 is returned with findings —
  not approved. The authority's findings: (1) the plan uses "kind" where
  the glossary rules the term is "artifact type" (glossary, "Not
  'kind'"); (2) the F-codes are under-explained — the collapse of many
  decision records into one rewritten record per family both threatens
  to overload what a single decision record can carry and is being
  decided before the decision-record chain exists to define what one
  record may hold, and the plan does not show where the authority's
  review input lands for each migrated artifact; (3) the plan's
  presentation leaned on opaque work-item references (`lead-kmrd4`)
  a reader cannot resolve; (4) readiness is not demonstrated — the
  definitions of the artifact types being migrated do not yet exist
  (the current basis artifacts are the meta-layer for creating those
  definitions, processes, and skills), so no rewrite could run today
  and the plan does not say how or when each run acquires its chain.
  Standing rule affirmed: a reader's misunderstanding of the plan is a
  defect of the plan, not of the reader — rev 2's "cold-read verified"
  claim is itself discredited and the cold-read check is a finding.
  Directed: an adversarial review of the migration plan together with
  the new basis, producing the required conditions to proceed; work
  continues until the plan is executable under the principles.

- **R25 (2026-08-22).** The basis merges to `main` before further work —
  authority directive on discovering the split state: the `basis/` tree
  lived only on `experiment/new-basis` while `main` already carried its
  compiled projections (the principles rendering, the compiled skills),
  a single-source-of-truth break. Executed: merge commit `c5f1495`
  (clean, purely additive), pushed; `lint_basis` passes on `main`. From
  this ruling the basis's home is `main` — the experiment branch is
  history, and this record lives at `basis/records/` on `main`. This
  settles the where-do-outputs-land half of the adversarial review's
  branch question; the migration plan must now name `main` as the
  target tree.

- **R26 (2026-08-22).** The migration-plan type gets a definition —
  authority ruling: migrations happen periodically and should have a
  definition; no bootstrap exception. Executed: typedef authored at
  `basis/artifacts/migration-plan.md` (status draft), joining the
  re-approval set of brief-026 ask 2. During the same remediation the
  adr-046 authority call was found mislabeled — it is the unimplemented
  framework-image parameterization (`bin/shop-shell:136` still bakes
  the literal), not a certificate-authority exemption; corrected in
  plan rev 3 and the brief, verified against the live script.

- **R27 (2026-08-22).** The execution model is restructured by
  authority direction, superseding rev 3's in-place model (the
  authority's concern: mid-migration confusion on `main`):
  (a) **Greenfield migration branch, additive seed ("branch plus"):**
  the migration runs on a new, mostly-empty branch; nothing exists on
  it unless an explicit import step brings it in with a precondition
  and a verification — no subtractive "main minus" seeding, and no
  features or keeps before progressive disclosure exists. Frozen
  `main` stays the contract of record for BC shops until cut-over.
  (b) **Total freeze:** the shop has no activity until the migration
  completes; in-flight dispatches are not being worked; mailboxes
  queue durably; no reconcile carve-out.
  (c) **Phase structure:** Seed (basis + tools + branch-native
  `.claude/` surface regenerated from the basis) → Phase 0
  architecture principles (everything derives from them) → Phase 1
  PM/PO/Architect definitions + chain → Phase 2 progressive
  disclosure built as the FIRST FEATURE through the new
  PM/PO/Architect flow, providing feedback and refinement of the
  Phase 1 definitions → Phase 3 the corpus migration runs, subject to
  an authority review before executing, after Phase 2. Root cause
  named: resetting the corpus without repairing the growth-mode
  problems (ad-hoc pre-state verification, context bloat) would hit
  the same limit again — supporting mechanisms come first.
  (d) **Code handoff:** lead-side bootstrap code (basis tools, PD
  implementation) is scenario-pinned during the migration and handed
  to a bounded context at migration end, per the spike-graduation
  pattern. Brief-026 is superseded as the decision surface by the
  forthcoming rev 4 brief.

- **R28 (2026-08-22).** The framework spec dissolves into the typed
  system; retirement requires named coverage. Authority direction over
  three exchanges: (a) the framework spec (02–06, artifact-lifecycle,
  consumer-wiring, README, current-state, structurizr) gets NO bespoke
  artifact type — its binding content re-homes into instances of the
  new artifact types (role definitions, process definitions, glossary,
  data types), authored through those types' chains; Phase 3's
  framework-spec run becomes a dissolution run. The principles alone
  have a dedicated home (the principle set, Phase 0). The scenario
  discipline reaches the branch as CONTENT of the Phase 1 PO/Architect
  process definitions (03/04 + scenario ADRs as curated source), which
  is how Phase 2 knows to pin capabilities with Gherkin. (b) A record
  with binding content MUST NOT retire unless each binding claim has a
  named covering home — new action treatment retire-with-coverage,
  plus a mechanical coverage check in the dissolution run; an unmapped
  claim blocks the retirement. 05-inter-shop-protocol retires against
  verified F3/schema/pin coverage. (c) Structurizr routes as: an ADR
  (the decision to maintain an architecture model as code), a
  sub-process definition (its maintenance/regeneration), operational
  import of the 3 source files under that process; only the generated
  cache is terminal. README/current-state re-authoring routes through
  the product-narrative path, late. Still open (recommendation
  standing, not ruled): completing the role-definition and
  process-definition meta-chains as Phase 1's first act.

- **R29 (2026-08-22).** The meta-chains complete as Phase 1's first
  act — authority ruling, resolving the open point from R28: before
  authoring the PM/PO/Architect definitions, Phase 1 first completes
  the role-definition and process-definition chains (quality guideline
  and fitness set for each; only their typedefs exist today), with the
  existing basis processes as exemplars. No meta-level authoring
  proceeds against a partial definition of good. Directed in the same
  ruling: deliver brief-028 as the decision surface, superseding
  brief-027.

- **R30 (2026-08-22).** Brief-028 is APPROVED on all seven asks; the
  authority directed the Seed to start. Applied: the plan (rev 5) is
  approved; the five definitions are stamped approved
  (`definition-chain-migration`, `corpus-close-out`, `action-table`,
  `close-out-report`, the `migration-plan` typedef) along with the
  glossary amendments; the archive contract is approved
  (`archive/migration-2026-08` + `pre-migration` tag; `archive-move`
  to be built to spec before first use); the attention contract,
  provisional type set, and done-standard stand as recommended. The
  three record-level calls are ruled retire: adr-033; adr-046 (fresh
  decision carried by backlog item lead-b7cn6); the system-BOM bundle
  (intent carried verbatim by backlog item lead-msm4m; its 6 pins
  retire). Action-table rows and counts updated (310 records:
  129 keep-rewrite / 5 keep / 169 retire / 7 terminal / 0 awaiting;
  pins 893: 860 keep / 33 retire). Brief-028 is decided — the first
  stakeholder-presentation run to complete through decision.

- **R31 (2026-08-23).** The execution mechanism inverts to pull, and
  the corpus migration becomes demand-pull with per-feature discovery
  — authority direction over two exchanges:
  (a) **Pull, never push.** `main` must not publish to `rebaseline`;
  the branch pulls from `main` as a read-only reference. New-system
  work happens in sessions resident in the `rebaseline` worktree,
  running under the branch's own `.claude` surface — not dispatched
  from the main session (this resolves finding F9 structurally).
  Rulings still flow to this record on `main`, its single-source home.
  (b) **Demand-pull replaces the Phase 3 conveyor.** The later planned
  runs stood on progressively shakier ground without progressive
  disclosure; instead, the new system is built up by cherry-picking.
  The action table becomes the inventory/census: a keep-rewrite row is
  ELIGIBLE for pull, not scheduled; anything never pulled retires by
  default at cut-over, with retire-with-coverage as the safety net so
  nothing binding is lost by omission. Feature-scenario contracts (the
  860 keep pins) are maintained as much as possible — functionality
  brought over preserves or consciously re-mints its pins.
  (c) **An interview per feature, not one interview.** The PM role
  (defined in Phase 1 through the meta-chains) interviews the
  authority per feature: first for progressive disclosure — Phase 2
  is the loop's first iteration — then further interviews as the
  census surfaces candidates for pull. The PM uses `main`, including
  the migration plan, as a reference point; the primary consideration
  is building a new, coherent version of the system.

- **R32 (2026-08-23).** The branch's `basis/principles.md` is amended
  by authority direction: rationale examples referencing the
  pre-migration corpus are removed — the branch carries no referent
  for them, and the specific examples are not necessary to rationalize
  the principles. Statements unchanged (verified mechanically: the
  compiled rendering's statement lines are bit-identical; new source
  digest 7f99b6697899). Two implication actors with no branch referent
  ("the router", "the journal") were generalized in the same pass. An
  isolated reference-resolvability cold read ran twice: round 1
  found six residuals (including a wrong glossary pointer introduced
  by the scrub itself); round 2 returned RESOLVABLE: clean. Branch
  commit `9991f8f`, rebased onto the authority's own branch commit
  `8ba040a` and pushed as `ea424c7`. Main's copy of the principle set
  stays frozen as pre-migration reference — the trees now
  intentionally diverge on rationale prose, not on statements.

## State

Open — **migration executing: Seed complete, Phase 0 begun; R31
pull model recorded; R32 principles scrub landed** (2026-08-23).

Seed executed and verified: orphan branch `rebaseline` (pushed,
commit `52b6e52`) holds exactly the basis corpus (minus `records/` —
this record's single source stays on `main`), its tools, and a
`.claude/` surface regenerated from the basis (CLAUDE.md, shop
identity, principles rendering digest 1e00df3daee9, migration primer,
the compiled stakeholder-presentation skill); whole-basis lint passes
on the branch. The plan's status is executing. Seed notes: the
principles compiler's hardcoded `@experiment/new-basis` source
citation was corrected to the in-tree path (main and branch); the
branch README's record links point at `main` as the record's home.

Phase 0 build steps complete (branch commit `9d5b02b`): the
principle-set chain's five missing links drafted (guideline, fitness
set, authoring process, cold-reviewer reused, compiled skill digest
fed20c3027db); derivation reports all six links; the exemplar (the
approved nine-principle set) passes all fitness scenarios with one
accepted tradeoff. Central discovery: the keeper `01-principles.md`
is ARCHITECTURE-scope while the approved set is WORKING-scope — two
instances of one type; the run's material records deltas D1–D10 and
friction findings F1–F7
(`rebaseline:basis/records/principle-set-chain-review-material.md`).

Resume point: the authority rules on brief-029 (delivered,
stakeholder-presentation, 4 cold-read rounds) — ask 1 the
chain-and-exemplar verdict (gates the stamps), ask 2 charter the
architecture principle set (gates Phase 0 exit), asks 3–7 resolve on
silence. On the rulings: stamp the chain links, apply the ask-4
amendments, file the F-findings as beads, move the review material to
`main` record-keeping, and start the architecture-set authoring
through the approved chain. The shop is frozen (R27).

Rev 3 was delivered via `briefs/brief-026.md`; before ruling, the
authority redirected the execution model (R27), and the plan was
restructured to rev 4 (phases Seed/0/1/2/3; census and action tables
carried over intact; the action table now also carries import stages
and the curated feed; `definition-chain-migration` gained the
queue-demoted amendment and `corpus-close-out` the cut-over staging
with branch promotion — drafts, lint-clean). Rev 4 was delivered via
`briefs/brief-027.md` (stakeholder-presentation, 4 cold-read rounds
logged in `verified-by`, delivered at the round cap with residuals
repaired post-round and disclosed at the top). Brief-026 is superseded
by brief-027 as the decision surface.

Resume point: the authority rules on brief-027's seven asks — asks 1–2
gate the Seed, ask 3 gates archiving/deletion/promotion, asks 4–7
resolve on silence by their stated defaults. The Seed does not begin
before asks 1–2 are approved.

For the resuming session: the basis lives on `main` under `basis/`
(R25); the ledger above plus README rulings R1–R18 are the review's
full history; the memory channel is closed (R22) — state lives only in
governed records; standing session protocol is in the shop primer.
