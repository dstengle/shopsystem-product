---
type: decision-brief
status: delivered
date: 2026-08-22
reader: product-authority
decisions-requested: 7
annex: ../drafts/migration-plan.md
verified-by:
  - {round: 1, verdict: findings, judge: claude-fable-5, prompt: cold-read-v1}
  - {round: 2, verdict: findings, judge: claude-fable-5, prompt: cold-read-v1}
  - {round: 3, verdict: findings, judge: claude-fable-5, prompt: cold-read-v1}
  - {round: 4, verdict: findings, judge: claude-fable-5, prompt: cold-read-v1}
---

# Brief 026 — Rebaseline migration: rule on rev 3 and its preconditions

**Delivered at the round cap (4 cold-read rounds, final verdict
"findings").** The round-4 findings (first-mention glosses in ask 1,
"terminal" undefined, ask 5's unnamed types) were repaired after the
round, unverified by a further cold read; the structural tradeoffs in
asks 1–2 are marked accepted in place. Rounds 1–3 findings were
repaired and re-verified in later rounds.

## The answer first

You returned the migration plan with findings, and the adversarial
review you directed found worse defects underneath — repairs for all of
them are now landed as drafts on `main`, so what remains is your
ruling. **Recommendation: approve the plan (ask 1) and the five
definitions it depends on (ask 2), ratify the archive contract
(ask 3), and
let asks 4–7 resolve by their stated defaults.** Asks 1 and 2 gate the
start of migration work; ask 3 gates any archiving or deletion; asks
4–7 resolve on silence, each by the default stated with it. Nothing is
retired, deleted, or rewritten by silence alone.

The shape of the migration: six scheduled entries — five
definition-building runs (run 1 architecture principles, run 2
decision records, run 3 framework spec, run 4 PM records, run 5
findings) plus a mechanical scenario close-out. Each run first builds
and proves its type's definition ("chain": typedef, guideline, fitness
set, process, roles, compiled skill), takes your review of the chain
plus one real rewritten exemplar (up to 3 rounds, then it parks), and
mass-rewrites only after your approval. The definitions do not
pre-exist — building them is each run's first act, and the plan now
says so. The plan's census is its action tables: one row per record,
each row carrying an action — keep-rewrite, keep, retire (moved to the
archive branch), or terminal (deleted after the recovery snapshot tag
is cut) — and its evidence.

The three worst defects found and repaired: the approved migration
process had a broken step flow (a step with no exit before your review
loop — no rewrite could ever have run); the 163 retiring records had no
process that moves them; and record collapses were being decided before
any definition existed to license them.

What ask 1 makes final: the action of every census row except the five
records awaiting your ask-6 rulings, and the run order. What ask 1
only nominates: the rewrite-family groupings. Final record granularity
— your concern that collapsing many decisions into ~15 records
overloads a decision record — is decided at the run-2 chain review,
after the decision-record definition exists to say what one record may
carry.

## Asks

Gating restated for the set: asks 1–2 gate run 1, ask 3 gates
archiving and deletion, asks 4–7 resolve on silence by their defaults.

**1. Approve migration plan rev 3 as a block.** *(Gates run 1.)*
*Recommend: approve.* Evidence:

- Records — 310 total: 130 keep-rewrite, 5 keep, 163 retire,
  7 terminal, 5 awaiting your ask-6 rulings (adr-033 the unrealized
  architect-role record, adr-046 the unimplemented image
  parameterization, and the three records of the system-BOM bundle —
  the never-built system bill-of-materials manifest; all detailed in
  ask 6). Every count machine-verified against disk.
- Scenario pins — 893 total: 860 keep, 27 retire, 6 riding the
  system-BOM call (ask 6c below).
- Rev 2's arithmetic errors, "kind" usages, unexplained F-codes (the
  rewrite-family labels F2–F15 marking clusters nominated to
  collapse), and opaque references are all corrected; the family map
  is now the plan's own Appendix B.

*Default: the plan stays draft; nothing proceeds.* (Accepted tradeoff:
a block approval rules on the annexed tables through their stated
verification; sampling rows means opening the annex — the price of a
block form.)

**2. Approve the five definitions the plan depends on.** *(Gates
run 1.)* Five = one amended process + one new process + two new data
types + one new typedef. The typedef: `migration-plan` itself
(`basis/artifacts/migration-plan.md`) — authored on your ruling of
today that migrations recur and the type needs a definition; it pins
this plan's required sections, machine-derived counts, and
brief-plus-cold-read delivery. Amended: the migration process
(`basis/processes/definition-chain-migration.md`) — its `derive-chain`
step had no exit, so the flow dead-ended before your review and no
rewrite could ever have run; it also gained a governed `actions` input
so your approved per-record directives reach the rewrite step through
a defined channel, not a retired document. New: the `corpus-close-out`
process (the mechanical mover of the retire and terminal mass), the
`action-table` data type (the census rows as typed data: record id,
path, action, family nomination, your directives, evidence — the one
lawful source of rewrite instructions), and the `close-out-report`
data type (what each close-out stage moved, deleted, or failed to
account for). All five sit on `main` as drafts. *Recommend: approve
all five.* Evidence: whole-basis lint passes; the flow fix is visible
in the compiled diagram. (Accepted tradeoff: the repaired text itself
lives on `main`, one path-click away — this ask approves it by its
described deltas.) *Default: no run starts.*

**3. Ratify the archive contract.** *(Gates archiving and deletion.)*
One parentless branch
`archive/migration-2026-08` holding retired files verbatim — the same
pattern as the memory archive you approved in ruling R22 of the review
ledger (`basis/records/review-new-basis.md`) — never on `main`, plus
snapshot tag `pre-migration` before any terminal deletion, and the
`archive-move` tool built to that spec before first use. *Recommend:
ratify.* Evidence: contract specced once in `corpus-close-out`;
terminal deletions are recoverable from the tag. *Default: nothing
archives and nothing is deleted; the mass stays frozen in place.*

**4. Attention contract for the mass rewrite.** *(Resolves on
silence.)* How much of your
attention does each run's rewrite step get? *Recommend: per-family
sign-off before a family record is finalized, plus a spot-check of
every 10th rewritten record, plus a veto window before each run's
archive stage.* Evidence: rev 2 gave you one exemplar per run and cited
an "attention architecture" defined nowhere; the recommendation puts
sign-off at the granularity being decided (families), with sampling
for drift and a last look before anything leaves the tree. *Default:
every rewritten record awaits your explicit sign-off — costlier,
safer.*

**5. Provisional artifact-type set for runs 2–4.** *(Resolves on
silence.)* *Recommend: run 2 builds one provisional decision-record
chain covering today's adr and pdr records and settles the ADR/PDR
boundary at its own chain review (the lead-jozud.2 investigation — the
open artifact-type-set and role-ownership question); run 3 carries one
framework-spec type (the numbered spec chapters, README,
current-state, and the architecture-model tree); run 4 carries the
four current PM type names — intent, candidate, brief, session —
provisionally the same way.* Evidence: the run partition cannot wait
on the final type set without circularity. *Default: the
recommendation, with any later type merge re-typing records
mechanically at close-out.* It is an ask rather than a notification
because you may rule a different partition now; silence adopts the
recommendation.

**6. Three record-level calls.** *(Resolve on silence.)* *Recommend,
with evidence and its verification inline per call:*
(a) adr-033, a role record for a bounded-context-local architect (BC =
bounded context, the framework's unit of shop decomposition) — the
role was never realized: the pinned work-loop scenarios name only
Implementer and Reviewer seats. *Retire.*
(b) adr-046 decided the framework image in `bin/shop-shell` becomes a
parameterized variable, overriding an earlier baked-literal exemption
— never implemented: the live script still bakes the literal
(`bin/shop-shell:136`, re-verified today; rev 2 mislabeled this a
certificate exemption — now corrected in the plan). *Retire, and on
that ruling one backlog item is filed carrying the fresh decision the
as-built behavior needs, so live code is never left undocumented on a
promise.*
(c) the system-BOM bundle (adr-047 the decision record, pdr-030 the
product decision, brief-015 the brief, plus 6 scenario pins — "BOM" as
in bill of materials: a proposed machine-readable manifest of every
system component) — never built: no `system-manifest.yaml`, no tool
exists on disk. *Retire the records and file one backlog item carrying
the intent verbatim.*
*Default: any unruled call rides into the run-2 chain review as an
open item.*

**7. Done-standard.** *(Resolves on silence.)* *Recommend: accept the
plan's "What demonstrates
done" — per run: chain approved, rewritten records pass the type's
fitness set, lint clean; for the migration: the running system
demonstrates it (skills and renderings regenerate and load, gate and
lint green over the whole baseline, primers cite only rewritten
records, close-out report shows zero unaccounted rows).* Evidence:
counts and status stamps alone are exactly what the delivery-verified
principle rejects. *Default: the per-run minimum stands; the
migration-level standard is deferred to close-out review.*

## Deferred (notes, not asks)

- The plan's own type standing is RULED (your direction, 2026-08-22):
  migrations recur, so `migration-plan` gets a typedef, not a
  bootstrap exception — authored as part of ask 2's set. The plan
  stays excluded from its own census.
- The stakeholder-presentation process — the approved process that
  produces briefs like this one, with an independent cold read before
  delivery — was bypassed at both earlier deliveries of this material;
  that activation gap is filed as a finding under the review
  conversation, its fix for a later review. This brief is the
  process's first conforming run: at delivery, its cold-read round log
  replaces the `pending` value in the front-matter `verified-by` field
  above.

## Annex

Full plan: [drafts/migration-plan.md](../drafts/migration-plan.md)
(rev 3) — action tables, run order, entry conditions, review surface,
family map. Optional; every ask above is decidable from this brief.
