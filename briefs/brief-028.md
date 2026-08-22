---
type: decision-brief
status: decided
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

# Brief 028 — Rebaseline migration, rev 5: rule on the plan with the spec dissolved

**Delivered at the round cap (4 cold-read rounds; final round: all
seven asks decidable, findings limited to ask 1's layout).** The
round-4 residuals — ask 1's fused recommend/evidence/default layout
and the five-records arithmetic — were repaired after the round,
unverified by a further cold read; the two structural tradeoffs
(asks 1–2 approve annexed/on-`main` material by described
verification) are marked accepted in place. Rounds 1–3 findings were
repaired and re-verified in later rounds. One disclosed budget
overage: the body runs ~1,700 words against the type's ~1,500
guideline — the asks carry three rulings' added content (R27–R29),
and trimming further would cut glosses earlier rounds required.

## The answer first

The plan (rev 5, the annex) carries everything you ruled today: the
phased greenfield model (ruling R27 in the review ledger), the
framework-spec dissolution with the retire-with-coverage discipline
(R28), and the meta-chains completing as Phase 1's first act (R29). **Recommendation: approve the plan (ask 1) and the five
definitions it depends on (ask 2), ratify the archive contract
(ask 3), and let asks 4–7 resolve by their stated defaults.** Asks 1
and 2 gate the branch seed — nothing starts without them; ask 3 gates
archiving, deletion, and the final promotion; asks 4–7 resolve on
silence, each by the default stated with it. Nothing is retired,
deleted, or rewritten by silence alone. This brief supersedes
brief-027, which was delivered before your dissolution and meta-chain
rulings.

The ruled sequence, restated:

- **Seed** — the branch gets the basis (the approved definition corpus
  under `basis/`), its tools, and a `.claude/` context surface
  regenerated from it; nothing else.
- **Phase 0** — architecture principles; everything derives from them.
- **Phase 1** — first completes the role-definition and
  process-definition meta-chains (R29), then authors the updated PM,
  PO, and Architect definitions through them. Those definitions carry
  the scenario discipline (capabilities pinned as Gherkin scenarios)
  as their own content — that is how Phase 2 knows to use it.
- **Phase 2** — progressive disclosure (tiered L0/L1/L2 record
  projections; consumers load only the level a task needs) built as
  the first feature *through* the new PM/PO/Architect flow, feeding
  refinements back into Phase 1. Exits on the one-record
  demonstration you approved, which also proves the decision-record
  chain.
- **Phase 3** — the corpus migration runs, entered only after your
  explicit review: features import → decisions → the dissolution run
  (the old framework spec re-homes into instances of existing types;
  no bespoke spec type is ever created) → PM records → findings →
  operational imports → cut-over (the branch becomes `main`) → code
  handoff to a bounded context (BC — the framework's unit of shop
  decomposition).

Frozen `main` stays the BC shops' contract of record throughout;
nothing crosses to the branch except through an import step with a
stated precondition and verification.

## Asks

Gating restated for the set: asks 1–2 gate the Seed, ask 3 gates
archiving/deletion/promotion, asks 4–7 resolve on silence by their
defaults.

**1. Approve migration plan rev 5 as a block.** *(Gates Seed.)*

The object approved is the plan's action table — the census of all
310 records and 893 pins, one row per record with its assigned action
and evidence (census: the four-pass survey of the live tree that
produced those rows).

**Approval finalizes:**
- the action of every row — keep-rewrite, keep, retire, or terminal —
  except the five records ruled in ask 6 (a: 1 record, b: 1, c: 3).
  Terminal rows are deleted at cut-over, after the `pre-migration`
  snapshot tag (ask 3) is cut;
- the import-stage assignments;
- the Phase 3 run order (as in the ruled sequence above), including
  the dissolution routing. Its largest single item: structurizr, the
  architecture-model tree, becomes a new decision record plus a
  maintenance sub-process; its 3 source files import as operational
  files; only its generated cache is deleted.

**Approval nominates only:** the rewrite-family groupings. Final
record granularity is decided at the Phase 3 decisions run's chain
review (each run's review of its chain plus one rewritten exemplar),
once the decision-record definition exists to say what one record may
carry. Your stated concern — that ~15 family records could overload
the decision-record type — is resolved there, not here.

**Riding mechanisms:** coverage — a retire row with binding content
is tagged **retire-with-coverage**, naming each claim's covering
home, and a mechanical check blocks its retirement while any claim is
unmapped (`05-inter-shop-protocol.md` retires this way, mapped to the
rewritten messaging records, the shop-msg schemas, and the scenario
pins); and leakage — the table is the import schedule (each keep row
names its crossing step) and the curated feed, the only source
material a run's clean-context agent receives.

*Recommend: approve.* Evidence:

- Records — 310 total: 129 keep-rewrite, 5 keep, 164 retire
  (including the coverage-tagged rows, notably 05), 7 terminal,
  5 awaiting your ask-6 rulings.
- Scenario pins — 893 total: 860 keep, 27 retire, 6 riding the
  system-BOM call (system bill of materials — the never-built
  machine-readable manifest; ask 6c below).
- Counts derived by script against the working tree on 2026-08-22;
  the totals already include the two rev-5 action changes — the 05
  retirement and the structurizr routing — with row-level deltas
  shown in the annex.

*Default: the plan stays draft; nothing proceeds.* (Accepted
tradeoff: a block approval rules on the annexed tables through their
stated verification; sampling rows means opening the annex — the
price of a block form.)

**2. Approve the five definitions the plan depends on.** *(Gates
Seed.)* Five = one amended process + one new process + two new data
types + one new typedef, all drafts on `main`:

- `definition-chain-migration` (amended process) — the flow fix: its
  former `derive-chain` step had no exit, so no rewrite could ever
  run; a governed `actions` input; and demotions (keepers that fail
  rewrite twice and downgrade to retire) queue to cut-over instead of
  archiving per run.
- `corpus-close-out` (new process) — all archive moves, terminal
  deletions, and the branch-becomes-main promotion run once, at
  cut-over, ending in a loud post-check.
- `action-table` (new data type) — the census rows as typed data: one
  row = record id, path, action, family nomination, your directives,
  evidence; the one lawful carrier of rewrite instructions.
- `close-out-report` (new data type) — what each close-out stage
  moved, deleted, or failed to account for.
- `migration-plan` (new typedef) — your ruling: migrations recur, the
  type gets a definition.

*Recommend: approve all five.* Evidence: whole-basis lint passes; the
flow fix and the promotion steps are visible in the compiled diagrams.
(Accepted tradeoff: the text itself lives on `main`, one path-click
away — this ask approves it by its described deltas.) *Default:
nothing starts.*

**3. Ratify the archive contract.** *(Gates archiving, deletion, and
promotion.)* One parentless branch `archive/migration-2026-08` holding
retired files verbatim — the same pattern as the memory archive you
approved in ruling R22 of the review ledger — never on `main`; snapshot
tag `pre-migration` before any terminal deletion; the `archive-move`
tool built to the spec (move, verify, and queue forms) before first
use; promotion of the migration branch to `main` only after the
close-out post-check passes. *Recommend: ratify.* Evidence: contract
specced once in `corpus-close-out`; terminal deletions recoverable
from the tag; everything runs at cut-over, so frozen `main` is never
edited mid-migration. *Default: nothing archives, nothing is deleted,
nothing promotes; the mass stays frozen in place.*

**4. Attention contract for the mass rewrite.** *(Resolves on
silence.)* How much of your attention does each Phase 3 run's rewrite
step get? *Recommend: per-family sign-off before a family record is
finalized, plus a spot-check of every 10th rewritten record, plus a
veto window before the single cut-over archive stage.* Evidence:
without a contract, your only guaranteed look at a run's output is
its single reviewed exemplar; the recommendation puts sign-off where
the risk is —
at the family level, where granularity is decided; sampling for drift
in the long tail; and a last look before anything leaves the tree. *Default: every rewritten
record awaits your explicit sign-off — costlier, safer.*

**5. Provisional artifact-type set for the Phase 3 runs.** *(Resolves
on silence.)* *Recommend, per run:*
- decisions run — one provisional decision-record type covering
  today's adr and pdr records; the ADR/PDR boundary is settled at that
  run's chain review (the lead-jozud.2 investigation — the open
  artifact-type-set and role-ownership question);
- dissolution run — no type at all: content re-homes into instances
  of existing types (your R28 ruling, restated not re-asked);
- PM-records run — the four current names, intent / candidate / brief
  / session, carried provisionally.

Evidence: the run partition cannot wait on the final type set without
circularity; Phase 2 already proves the decision-record chain before
the decisions run starts. *Default: the recommendation; any later
type merge re-types records mechanically at cut-over.* It is an ask
rather than a notification because you may rule a different partition
now.

**6. Three record-level calls — (a) and (b) cover one record each,
(c) covers three.** *(Resolve on silence.)* *Recommend, with evidence
and its verification inline per call:*
(a) adr-033, a role record for a BC-local architect — never realized:
the pinned work-loop scenarios name only Implementer and Reviewer
seats. *Retire.*
(b) adr-046 ruled the container-image name in `bin/shop-shell` must
become a parameterized variable instead of a baked-in literal. The
ruling was never implemented: the live script still bakes the literal
(`bin/shop-shell:136`, re-verified against the script today). *Retire.
On this retire ruling a backlog item is filed to decide the as-built
behavior fresh — the live code is never left without a governing
decision.*
(c) the system-BOM bundle (adr-047 the decision record, pdr-030 the
product decision, brief-015 the brief, plus 6 scenario pins) — never
built: no `system-manifest.yaml`, no tool exists on disk. *Retire the
records and file one backlog item carrying the intent verbatim.*
*Default: any unruled call rides into the decisions-run chain review
as an open item.*

**7. Done-standard.** *(Resolves on silence.)* *Recommend: accept the
plan's "What demonstrates done":*
- *each phase exits on your approval of its named demonstration;*
- *each Phase 3 run is done when its chain is approved, its rewritten
  records pass the type's fitness set (the judged quality scenarios
  that score the type), and lint runs clean — the dissolution run
  additionally only when its coverage check reports zero unmapped
  claims;*
- *the migration is done when the running system demonstrates it ON
  THE BRANCH before promotion: compiled skills and renderings
  regenerate and load, the conformance gate (the shop's mechanical
  checks) and lint run green, records cite only rewritten records,
  the close-out report accounts for every row.*

Evidence: counts and status stamps alone are exactly what the
delivery-verified principle rejects. *Default: everything above stands
except the migration-level standard, which is deferred to the
cut-over review.*

## Deferred (notes, not asks)

- Phase 2 leans on the progressive-disclosure recommendation finding
  (`findings/progressive-disclosure/08-recommendation.md`) — itself a
  retire row: it enters as curated source material, never used as-is,
  and retires at cut-over. Flagged so the dependency is seen, not
  discovered.
- The migration branch's proposed name is `rebaseline` — a drafting
  default, renameable at Seed without re-ruling.
- Lead-side bootstrap code (basis tools, the progressive-disclosure
  implementation) is scenario-pinned as it is built; its BC handoff is
  the first post-migration dispatch — the shop's established
  graduation path for spike-born code. No ask.

## Annex

Full plan: [drafts/migration-plan.md](../drafts/migration-plan.md)
(rev 5) — phases with entry/exit conditions, import schedule, action
tables, dissolution routing, review surface, family map. Optional;
every ask above is decidable from this brief.
