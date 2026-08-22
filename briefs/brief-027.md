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

# Brief 027 — Rebaseline migration, rev 4: rule on the plan under your phased model

**Delivered at the round cap (4 cold-read rounds; final round: all
seven asks decidable, findings limited to readability).** The round-4
residuals — the nested "terminal" definition, the ungrounded "~15"
figure, and two dense sentences — were repaired after the round,
unverified by a further cold read; the two structural tradeoffs
(asks 1–2 approve annexed/on-`main` material by described
verification) are marked accepted in place. Rounds 1–3 findings were
repaired and re-verified in later rounds.

## The answer first

Your restructure is executed: the migration plan (rev 4, the annex) now
schedules the foundation before any mass rewrite, on a greenfield
branch seeded additively, under a total activity freeze — the model you
ruled today (ruling R27 in the review ledger). **Recommendation: approve the
plan (ask 1) and the five definitions it depends on (ask 2), ratify
the archive contract (ask 3), and let asks 4–7 resolve by their stated
defaults.** Asks 1 and 2 gate the branch seed — nothing starts without
them; ask 3 gates archiving, deletion, and the final promotion; asks
4–7 resolve on silence, each by the default stated with it. Nothing is
retired, deleted, or rewritten by silence alone. This brief supersedes
brief-026, which was delivered but not ruled before your restructure.

The ruled sequence, restated: **Seed** — the branch gets the basis
(the approved definition corpus under `basis/`), its tools, and a
`.claude/` context surface regenerated from it; nothing else.
**Phase 0** — architecture principles; everything derives from them.
**Phase 1** — the updated PM, PO, and Architect definitions, authored
through the already-approved meta-definitions. **Phase 2** —
progressive disclosure (tiered L0/L1/L2 record projections, so
consumers load only the level a task needs) built as the first
feature *through* the new PM/PO/Architect flow, feeding refinements
back into Phase 1; its exit is the one-record demonstration you
approved, which also proves the decision-record chain. **Phase 3** —
the corpus migration runs, entered only after your explicit review:
features import, then decisions, framework spec, PM records, findings,
then operational imports, then cut-over (the branch becomes `main`)
and the code handoff to a bounded context (BC — the framework's unit
of shop decomposition). Frozen `main` stays the BC shops' contract of
record throughout; nothing crosses to the branch except through an
import step with a stated precondition and verification.

## Asks

Gating restated for the set: asks 1–2 gate the Seed, ask 3 gates
archiving/deletion/promotion, asks 4–7 resolve on silence by their
defaults.

**1. Approve migration plan rev 4 as a block.** *(Gates Seed.)*

The object approved is the plan's action table — the census of all
310 records and 893 pins, one row per record with its assigned action
and evidence (census: the four-pass survey of the live tree that
produced those rows). Approval makes final:
- the action of every row — keep-rewrite, keep, retire, or terminal —
  except the five records awaiting your ask-6 rulings. Terminal rows
  are deleted at cut-over, after the `pre-migration` snapshot tag
  (ask 3) is cut;
- the import-stage assignments;
- the Phase 3 run order (as listed in the ruled sequence above).

Approval only nominates: the rewrite-family groupings. Final record
granularity is decided at the Phase 3 decisions run's chain review
(each run's review of its chain plus one rewritten exemplar), once the
decision-record definition exists to say what one record may carry —
where your concern lands that collapsing many decisions into the ~15
nominated family records (the annex's family map) overloads a
decision record.

The action table is also the leakage control: the import schedule
(each keep row names its crossing step) and the curated feed — the
only source material a run's clean-context agent receives, so nothing
problematic reaches the new corpus from the old. *Recommend: approve.* Evidence: records — 310 total: 130
keep-rewrite, 5 keep, 163 retire, 7 terminal, 5 awaiting your ask-6
rulings; scenario pins — 893 total: 860 keep, 27 retire, 6 riding the
system-BOM call (system bill of materials — the never-built
machine-readable manifest; ask 6c below). Every count derived by
script against the working tree on 2026-08-22; derivation named in
the annex. *Default: the plan stays draft; nothing proceeds.*
(Accepted tradeoff: a block approval rules on the annexed tables
through their stated verification; sampling rows means opening the
annex — the price of a block form.)

**2. Approve the five definitions the plan depends on.** *(Gates
Seed.)* Five = one amended process + one new process + two new data
types + one new typedef, all drafts on `main`:

- `definition-chain-migration` (amended process) — the flow fix: its
  former `derive-chain` step had no exit, so no rewrite could ever
  run; a governed `actions` input; and, new today, demotions (keepers
  that fail rewrite twice and downgrade to retire) queue to cut-over
  instead of archiving per run.
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

*Recommend: approve all five.* Evidence:
whole-basis lint passes after every amendment; the flow fix and the
promotion steps are visible in the compiled diagrams. (Accepted
tradeoff: the text itself lives on `main`, one path-click away — this
ask approves it by its described deltas.) *Default: nothing starts.*

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
veto window before the single cut-over archive stage.* Evidence: the
pre-restructure plan gave you one exemplar per run and cited an
"attention architecture" defined nowhere; the recommendation puts
sign-off at the granularity being decided. *Default: every rewritten
record awaits your explicit sign-off — costlier, safer.*

**5. Provisional artifact-type set for the Phase 3 runs.** *(Resolves
on silence.)* *Recommend, per run:*
- decisions run — one provisional decision-record type covering
  today's adr and pdr records; the ADR/PDR boundary is settled at that
  run's chain review (the lead-jozud.2 investigation — the open
  artifact-type-set and role-ownership question);
- framework-spec run — one framework-spec type;
- PM-records run — the four current names, intent / candidate / brief
  / session, carried provisionally.

Evidence: the run partition cannot wait on the final type set without
circularity; Phase 2 already proves the decision-record chain before
the decisions run starts. *Default: the recommendation; any later
type merge re-types records mechanically at cut-over.* It is an ask
rather than a notification because you may rule a different partition
now.

**6. Three record-level calls.** *(Resolve on silence.)* *Recommend,
with evidence and its verification inline per call:*
(a) adr-033, a role record for a BC-local architect — never realized:
the pinned work-loop scenarios name only Implementer and Reviewer
seats. *Retire.*
(b) adr-046 ruled the container-image name in `bin/shop-shell` must
become a parameterized variable instead of a baked-in literal. The
ruling was never implemented: the live script still bakes the literal
(`bin/shop-shell:136`, re-verified against the script today). *Retire,
and on that ruling one backlog item is filed carrying the fresh
decision the as-built behavior needs, so live code is never left
undocumented on a promise.*
(c) the system-BOM bundle (adr-047 the decision record, pdr-030 the
product decision, brief-015 the brief, plus 6 scenario pins) — never
built: no `system-manifest.yaml`, no tool exists on disk. *Retire the
records and file one backlog item carrying the intent verbatim.*
*Default: any unruled call rides into the decisions-run chain review
as an open item.*

**7. Done-standard.** *(Resolves on silence.)* *Recommend: accept the
plan's "What demonstrates done" — each phase exits on your approval of
its named demonstration; each Phase 3 run is done when its chain is
approved, its rewritten records pass the type's fitness set (the
judged quality scenarios that score the type), and lint runs clean;
the migration is done when the running system demonstrates it ON THE
BRANCH before promotion: compiled skills and renderings regenerate and
load, the conformance gate (the shop's mechanical checks) and lint run
green, records cite only rewritten records, the close-out report
accounts for every row.* Evidence: counts and status
stamps alone are exactly what the delivery-verified principle rejects.
*Default: everything above stands except the migration-level standard,
which is deferred to the cut-over review.*

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
(rev 4) — phases with entry/exit conditions, import schedule, action
tables, review surface, family map. Optional; every ask above is
decidable from this brief.
