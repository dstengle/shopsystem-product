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

## State

Open — **rev 5 amendment in flight (R28/R29); brief-028 delivery
queued** (2026-08-22).

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
