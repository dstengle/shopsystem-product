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

## State

Open — **rev 3 delivered; awaiting the authority's rulings**
(2026-08-22).

The R24 remediation is complete. The adversarial review (18 findings,
5 blockers, 17 required conditions) and the isolated cold read ran;
`definition-chain-migration` was amended (flow fix — its `derive-chain`
step had no exit, so no rewrite could ever run; plus a governed
`actions` input); `corpus-close-out`, `action-table`,
`close-out-report`, and the `migration-plan` typedef were authored
(all drafts pending approval); the archive contract is specced
(`archive/migration-2026-08` + `pre-migration` tag; `archive-move`
specced, not built). Migration plan rev 3 addresses all findings, and
its delivery went through the stakeholder-presentation process for the
first time: `briefs/brief-026.md`, status delivered, seven asks, four
cold-read rounds logged in `verified-by`, delivered at the round cap
with the residual round-4 findings repaired post-round and disclosed
at the top of the brief.

Resume point: the authority rules on brief-026's seven asks — asks 1–2
gate run 1, ask 3 gates archiving and deletion, asks 4–7 resolve on
silence by their stated defaults. Phase 1 does not begin before asks
1–2 are approved.

For the resuming session: the basis lives on `main` under `basis/`
(R25); the ledger above plus README rulings R1–R18 are the review's
full history; the memory channel is closed (R22) — state lives only in
governed records; standing session protocol is in the shop primer.
