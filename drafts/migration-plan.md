---
type: migration-plan
id: migration-plan
revision: 5
supersedes: rebaseline-bill (2026-08-04)
owner: product-authority
status: executing
created: 2026-08-22
updated: 2026-08-22
---

# Migration plan: rebaseline against the approved basis

Census run 2026-08-22 by four independent lanes over the live tree,
verifying the 2026-08-04 census where it overlapped and judging
everything after it fresh. This plan is the rebaseline's action table
plus the phased execution schedule under the authority-ruled execution
model (R27, 2026-08-22, `basis/records/review-new-basis.md`): a
greenfield migration branch with an additive seed, a total freeze on
shop activity, and the phase sequence Seed → Phase 0 → Phase 1 →
Phase 2 → Phase 3 defined in "Execution phases" below. Approving this
plan's Ask 1 starts Seed, subject to the entry conditions in
"Execution readiness" below. Rev 5 applies R28 (2026-08-22, same
record): the framework spec dissolves into instances of existing
artifact types — Phase 3's framework-spec run is re-scoped as a
dissolution run — and retiring a record with binding content now
requires named coverage (the new retire-with-coverage treatment).

**Phase-vocabulary note (collision fixed at rev 4):** "phase" in this
plan means one of this plan's execution phases — Seed, 0, 1, 2, 3.
Intent-013's re-founding arc has its OWN four-phase numbering
(freeze → shrink → enforce → standard); that arc numbering is a
different scale and is never meant when this plan says "Phase N". This
migration as a whole executes the rebaseline phase of intent-013's
arc; rev 3's use of "Phase 1" in that arc sense is purged from this
revision.

All counts in this document were derived mechanically on 2026-08-22 by
a scratch script (`counts.sh`, session scratchpad) run against the
working tree; every figure in the Summary, the execution phases, and
the appendices is pasted from its output, none by hand.[^counts]

[^counts]: The script counts `*.md` files per directory, anchored
`@scenario_hash:` tag lines per features directory, and files per
terminal tree, and cross-sums lanes A/B/D against their action splits.
It lives in the session scratchpad, not the repo; its full output is
reproducible from the commands it contains. Rev 5 adjusts exactly two
figures against that baseline — lane D keep-rewrite 15→14 and retire
115→116 (and the column totals) — by arithmetic on the single R28 row
flip (05-inter-shop-protocol), not by a recount; no file moved on
disk.

## How to rule

**Ask 1 (block): approve the action table, the family nominations, and
this plan as the execution instrument — approval starts Seed.** Every
row carries its lane's one-line evidence. The execution model itself —
the greenfield branch, the total freeze, the phase structure, and the
Phase 3 run order — is already RULED (R27, 2026-08-22) and is restated
here, not re-asked; R28 (2026-08-22) re-scopes Phase 3's third run as
a dissolution run and adds the retire-with-coverage treatment —
likewise restated, not re-asked. Approval fixes three things: which records are
keepers, which retire, and which are terminal (the census rows); the
F-family groupings **as nominations only**; and the action table's
import-stage assignments (the table's second use — see "Execution
phases"). Approval does NOT fix: the final granularity of rewritten
records (decided at the decisions-run chain review, after the
decision-record typedef, guideline, and fitness set exist — see
Appendix B), the final artifact-type set, or the archive execution
(its contract is a pending ruling). The three record-level authority
calls below each carry a recommendation and a default; silence on a
call is itself handled — the default carries it into the decisions
run's chain review as an open item; nothing is retired or deleted by
silence.

The remaining structural rulings are listed under **Open rulings**
below. They will be finalized in a separate decision-brief; this plan
carries each only as a one-line question with a recommendation and a
default.

### Vocabulary for this document

Terms marked (g) are defined in the approved glossary
(`basis/glossary.md` — the basis merged to `main` at c5f1495 and is
the operating tree; `experiment/new-basis` is history); the rest are
defined here for this document.

- **chain** (g: definition chain) — a type's full definition of good:
  six linked definitions — typedef, guideline, fitness set, process,
  roles, compiled skill. One `definition-chain-migration` run builds a
  chain and rewrites that type's keepers through it.
- **chain review** — the authority review of a run's chain and
  exemplar inside that run (the `authority_review` / `route_review`
  steps of the process); verdicts and round cap in "The authority's
  review surface" below.
- **phase** — one of THIS PLAN's execution phases: Seed, Phase 0
  (architecture principles), Phase 1 (PM/PO/Architect definitions),
  Phase 2 (progressive disclosure as first feature), Phase 3 (the
  corpus migration runs). Ruled structure, R27. Never intent-013's arc
  phases, which are a different numbering (see the phase-vocabulary
  note above).
- **migration branch** — the greenfield branch the migration runs on;
  proposed name `rebaseline` (the NAME is a drafting default, not a
  ruling; the branch model itself is ruled). Nothing exists on it
  except through an explicit import step.
- **import step** — the only way anything reaches the migration
  branch: a named step with a stated precondition and a stated
  verification. No subtractive "main minus" seeding exists.
- **curated feed** — the keep-rewrite rows of the action table for one
  run: the ONLY source material that run's clean-context migration
  agent receives. Governed-context is enforced structurally — the
  agent's worktree physically lacks the old corpus.
- **cut-over** — the final Phase 3 step: the `corpus-close-out` stages
  run (snapshot tag, terminal deletions, archive moves, scenario-refs
  regeneration) and the migration branch becomes `main`. Until
  cut-over, frozen `main` remains the contract of record.
- **keeper** (g) — a record whose action is keep-rewrite; rewritten
  forward through its type's approved chain, never used as-is.
- **Actions** — the enum covering every action cell: *keep-rewrite* —
  content still binding, re-authored through the chain; *keep* — stays
  as-is, no rewrite (scenarios and operational files) — under the
  ruled branch model a keep row crosses to the branch at its import
  stage rather than "staying in place"; *retire* —
  value passed with nothing binding, moves to the archive branch
  (never `main`); *retire-with-coverage* (new at rev 5, R28) — a
  retire whose record carries binding content: the row MUST name the
  covering home (receiving record, process definition, schema, or
  scenario pin) for each binding claim, and the dissolution run runs a
  mechanical coverage check — any unmapped claim blocks the
  retirement. Rows tagged retire-with-coverage outside the dissolution
  run get the same check at close-out, before their archive move; in
  every count, retire-with-coverage rows count in the retire column.
  Plain *retire* remains for records whose value has passed with
  nothing binding; *terminal*
  — junk or never-advanced, deleted or closed as never-accepted.
  (Vocabulary note: the glossary's `action` enum is keep-rewrite /
  retire / terminal; this plan extends it with *keep* for records
  already in native format and *retire-with-coverage* per R28 —
  flagged for glossary amendment.)
- **authority-call** — a row MARKER, not an action: the row awaits an
  authority ruling and neither rewrites nor retires until ruled.
- **lane** — one of the four independent census passes (A decisions,
  B PM records, C scenarios, D docs/findings/drafts/root/junk); each
  lane read the tree independently and its evidence stands per row.
- **census** — the four-lane read-only survey of the live tree whose
  rows this action table carries; this plan's tables are the census.
- **pin** — one anchored `@scenario_hash:` tag line in `features/`,
  fixing one canonical scenario block. Pins are counted separately
  from records and never enter a record total.
- **F-codes / rewrite families** — clusters of decision records
  NOMINATED to collapse into a small number of rewritten records.
  Nominations only: final record granularity is decided at the
  decisions-run chain review. The authoritative family map is
  Appendix B.
- **RACI** — the standard responsibility matrix (Responsible /
  Accountable / Consulted / Informed); here, the open question of
  which role owns which record type, under investigation as
  lead-jozud.2 (glossed below).
- **trust break** — the 2026-08-03 quality failure that triggered the
  re-founding (intent-013, the re-founding instrument: the authority's
  recorded direction to re-found the typed-artifact system in four
  phases after finding systemic quality failures).
- **provenance spine** — the `derives-from`/`derived-by` edge graph
  rooted at intent records, along which every PM record traces to a
  recorded want.
- **doctrine loop** — the iterative doctrine-capture loop under
  intent-013 (opened sess-2026-08-04-a, in that arc's own early
  phase — arc numbering, not this plan's), which produced pdr-039
  over review iterations instead of one-shot authoring.

### External references glossed

- **lead-jozud.2** — the merged artifact-type-set + RACI
  investigation (see `sessions/sess-2026-08-05-a.md`): which record
  types survive, the ADR/PDR boundary, and role ownership per type.
- **lead-x7bp** — the progressive-disclosure epic (2026-07-04): tiered
  L0/L1/L2 artifact format plus task-conditioned access, against
  context bloat and unnoticed contradictory decisions.
- **lead-iixm** — the in-progress PO task under lead-x7bp: author the
  scenario sets pinning decision-disclosure conformance (frontmatter
  schema, L0/L1/L2 projections, determinism/anti-drift).
- **sc06** — a deferred scenario body (hash 5174e405a19358fa, per
  adr-024 D2); now carried verbatim by backlog item lead-df2pj.
- **the 153-hash prior census (2026-08-04)** — the scenario-retirement
  lane of the superseded rebaseline-bill, which proposed retiring 153
  scenario hashes across 30 files; this plan dissolves most of it (see
  Summary scenario notes).
- **the 2026-07-04 "no current use" ruling** — the authority's ruling
  recorded in `features-provisional/README.md`: devcontainer has no
  current use and is parked out of the canonical features tree.
- **Peters grant** — adr-066: Dean Peters, rights holder of
  deanpeters/Product-Manager-Skills, granted MIT ingestion of the
  derived PM skills conditioned on attribution.
- **memory-archive pattern** — authority ruling R22 (2026-08-22,
  `basis/records/review-new-basis.md`): retired memories moved to the
  parentless branch
  `archive/memory-2026-08`, verbatim, never on `main`. The archive
  contract below follows this pattern.
- **intent-013** — the re-founding instrument: the authority's
  recorded direction, after the trust break, for the phased
  freeze → shrink → enforce → standard arc. This plan executes that
  arc's rebaseline phase (the arc's own numbering, distinct from this
  plan's Seed/0/1/2/3 execution phases).
- **rebaseline-bill** — this plan's superseded predecessor
  (2026-08-04). Its family map now lives in this plan's Appendix B;
  the bill itself is a retire row in Appendix A.

## Open rulings

Finalized in a separate decision-brief; listed here so the plan is
honest about what it does not settle. Each: question — recommendation
— default if unruled.

**Ruled since rev 3 — no longer open.** The execution-tree model and
the phase structure are RULED (R27, 2026-08-22,
`basis/records/review-new-basis.md`): greenfield migration branch with
additive seed ("branch plus", no "main minus" subtraction), total
freeze on shop activity, the Seed → 0 → 1 → 2 → 3 phase sequence with
progressive disclosure as the first feature, the Phase 3 entry review,
and the end-of-migration code handoff to a bounded context. Rev 3's
in-place execution model (rewrites landing beside the frozen mass on
`main`) is superseded. R28 (2026-08-22, same record) is likewise
RULED: the framework spec gets no bespoke artifact type — its binding
content re-homes into instances of existing artifact types, and Phase
3's third run becomes a dissolution run — and a record with binding
content must not retire without a named covering home per claim
(retire-with-coverage). Within the ruled model, the migration branch's
NAME — proposed `rebaseline` — remains a drafting default, not a
ruling. This plan's own type standing is likewise RULED (2026-08-22):
no bootstrap exception; the typedef is authored at
`basis/artifacts/migration-plan.md` (status draft; its approval rides
ruling 5's re-approval set); the plan remains excluded from its own
census (see lane D intro).

Still open:

1. **Collapse timing (family granularity).** When is the final
   record granularity of the F-families fixed? — *Recommend:* at the
   decisions-run chain review (Phase 3), after the decision-record
   typedef, guideline, and fitness set exist (built in Phase 2 as the
   demonstration vehicle); this plan's families are nominations only.
   — *Default:* nominations stand as written until that review rules.
2. **Provisional artifact-type set for the decisions and PM-records
   runs.** These runs must write records as SOME type before
   lead-jozud.2 settles the final set. (Rev 5, R28: the framework-spec
   provisional TYPE is gone — the dissolution run needs no new type;
   it authors instances of existing types through those types' chains,
   and its outward-narrative slot's type is defined by the run that
   needs it.) — *Recommend:* the
   decision-record chain built in Phase 2 is provisional as to the
   type set, and the ADR/PDR boundary is a decisions-run chain-review
   question; the PM-records run carries the current PM type names
   provisionally. — *Default:* current type names carried
   provisionally; any type merge re-types records mechanically at
   close-out.
3. **Attention contract during mass rewrite.** How much authority
   attention does the mass-rewrite step get? — *Recommend:* the
   PROPOSED contract in "The authority's review surface" §5
   (per-family sign-off + every-10th spot-check + pre-archive veto
   window). — *Default:* every rewritten record awaits explicit
   authority sign-off (the costlier, safer posture).
4. **Archive contract.** — *Recommend:* ratify the pending contract:
   one parentless branch `archive/migration-2026-08`, verbatim files,
   never on `main`, plus snapshot tag `pre-migration` for terminal
   recovery (the memory-archive R22 pattern). — *Default:* nothing
   archives and nothing is deleted; the retire and terminal mass stays
   frozen in place until ruled. (The formerly open branch question —
   where chains and rewritten records land — is superseded by R27:
   outputs land on the migration branch, which becomes `main` at
   cut-over; frozen `main` stays the contract of record until then.)
5. **Amended-definitions re-approval (the five draft definitions).**
   The amended `definition-chain-migration` process (flow fix + the
   new governed `actions` input) and the `corpus-close-out` process
   (its stages re-homed to cut-over under R27) are on `main` under
   `basis/processes/` with supporting types
   `basis/types/action-table.md` and `basis/types/close-out-report.md`
   — all status draft, pending re-approval before Seed starts. The
   new `basis/artifacts/migration-plan.md` typedef joins this set. —
   *Recommend:* approve all five at this plan's review. — *Default:*
   Seed does not start.
6. **Done-standard.** — *Recommend:* accept "What demonstrates done"
   below as the standard. — *Default:* per-run done = chain approved +
   fitness pass + lint clean (the minimum); the migration-level
   standard is deferred to the Phase 3 close-out review.

## Summary

Records (markdown files) by lane and action. Trees and scenario pins
are counted on separate lines below the table — they are different
units and never mix into the records total.

| lane | records (md) | keep-rewrite | keep | retire | terminal | authority-call rows |
|---|---|---|---|---|---|---|
| A — decisions (adrs, pdrs) | 108 | 87 | — | 21 | 0 | 0 |
| B — PM records (intents, candidates, briefs, sessions) | 67 | 28 | — | 32 | 7 | 0 |
| D — docs, findings, drafts, root | 135 | 14 | 5 | 116 | 0 | 0 |
| **records total (md)** | **310** | **129** | **5** | **169** | **7** | **0** |

Rev 5 (R28) count note: `05-inter-shop-protocol.md` flipped from
keep-rewrite to retire-with-coverage — hence lane D 15→14 keep-rewrite
and 115→116 retire, totals 130→129 / 163→164; records total unchanged
at 310. Retire-with-coverage rows count in the retire column: 05
(lane D), pdr-012 and pdr-013 (lane A), brief-007 (lane B) — the lane
A and B rows were already retire, so their counts are unchanged.

Separate units, not in the records total:

- **Trees:** `structurizr/` (44 files) — re-routed at rev 5 per R28,
  no longer keep-rewrite as one tree: one new ADR authored in the
  decisions run (the decision to maintain an architecture model as
  code, in structurizr — currently documented nowhere; only a passing
  mention in adr-037), one sub-process definition (model
  maintenance/regeneration), operational import of the 3 source files
  (README.md, workspace.dsl, workspace.json) at the operational-keeps
  stage under that process, and the 41 generated `.structurizr/`
  cache files terminal. Counted as a tree throughout — its files
  enter no record total. Seven junk trees —
  terminal, deleted whole (653 files total, 82 md files among them:
  61 in `.fabro-e2e-scratch/`, 21 in `.specstory/`); they are counted
  as trees, never as records.
- **Scenarios (lane C):** 893 pins across 291 feature files in
  `features/` — 860 keep, 33 retire, 0 authority-call.[^pins]
  `features-provisional/` holds 23 further files (17 devcontainer +
  5 docs + 1 README), all retire.

[^pins]: The 6 system-manifest pins (ruled retire, R30) are
pins, not records; they ride the system-BOM record ruling (call 3) and
appear in no record total.

Scenario notes: scenarios are already the system's native format —
keepers stay as-is; the prior census's 153-hash retirement never
executed and mostly dissolves: of its old set, only the pdr-031 surface
files and the three templates writing-skill files retire (the knowledge
directory is live contract). `scenario-refs/origin-index.txt`
is stale since 2026-07-04 and regenerates mechanically at close-out.
`features-provisional/devcontainer` retires per the authority's
2026-07-04 "no current use" ruling; `features-provisional/docs` retires
with adr-008 (shopsystem-docs is a dead letter); the
`features-provisional/README.md` parking note leaves with them. The
test-harness authority flag resolved during census:
`shopsystem-test-harness` is now in `bc-manifest.yaml`, so its feature
file keeps and adr-002 keep-rewrites.

## Execution phases (RULED model — R27, 2026-08-22)

The execution model and phase structure below are authority-ruled
(R27); this section restates the ruling as the schedule. Rev 3's "run
order" survives inside Phase 3 — the runs themselves are unchanged
`definition-chain-migration` runs; what changed is where they sit and
what exists around them.

**The ruled model — greenfield branch, additive seed ("branch
plus").** The migration runs on a new branch (proposed name
`rebaseline` — the name is a drafting default, not a ruling). NOTHING
exists on that branch unless an explicit import step brings it in,
each import with a stated precondition and a stated verification.
There is no subtractive "main minus" seeding, and no features or
operational keeps land on the branch before progressive disclosure
exists. Frozen `main` remains the contract of record for the BC shops
until cut-over — BCs never see an intermediate state.

**Total freeze.** The shop has no activity until the migration
completes. In-flight dispatches are not being worked; BC mailboxes
queue durably; the drain runs post-migration. No carve-outs.

**The action table's second use.** Beyond its census role, the action
table becomes the branch's import and feed register: every *keep* row
gains an import stage — which phase or Phase 3 step brings it across —
in place of rev 3's "stays in place"; every *keep-rewrite* row is the
curated feed for its run — the ONLY source material that run's
clean-context migration agent receives. Governed-context is enforced
structurally, not by instruction: the agent's worktree physically
lacks the old corpus.

### Seed

The branch is created holding exactly: `basis/` plus its tools, and a
branch-native `.claude/` surface (primer, principles rendering,
compiled skills) regenerated from the basis — so migration sessions
run under the new model from the first minute. Beads continuity is
free (the registry is dolt, not git — no import step needed). **Exit:**
the branch exists, holds exactly that, and whole-basis lint passes on
it.

### Phase 0 — architecture principles

Everything derives from them. The principle-set chain is built and
approved, and spec `01-principles.md` rewrites through it — this
absorbs rev 3's run 1. Chain state today: 1 of 6 links (the typedef,
in the seed layer). **Exit:** chain approved; rewritten principle set
approved.

### Phase 1 — PM/PO/Architect definitions and their chain

The updated PM, PO, and Architect role definitions and their
processes, authored through the already-approved meta-chains (the
role-definition and process-definition typedefs, approved R23).
**Exit:** the authority approves the definitions.

**Entry condition (RULED — R29, 2026-08-22):** complete the
role-definition and process-definition meta-chains — a quality
guideline plus a fitness set for each; only their typedefs exist today
(on disk, `basis/fitness/` holds only `decision-brief.fitness.md` and
`basis/guidelines/` only the brief-writing pair) — as Phase 1's first
act, before authoring the PM/PO/Architect definitions. The existing
basis processes serve as exemplars. No meta-level authoring proceeds
against a partial definition of good.

**Scope note (R28):** the PO and Architect process definitions CARRY
the scenario discipline — capabilities pinned as Gherkin scenarios,
the PO authors them, the Architect dispatches against hashes — as
their own content, sourced from 03/04 plus the scenario-discipline
ADRs via the curated feed. This is how Phase 2 knows to pin its
feature with Gherkin.

### Phase 2 — progressive disclosure, the FIRST FEATURE

Progressive disclosure is built as the first feature THROUGH the new
PM/PO/Architect flow — exercising and refining the Phase 1
definitions with real work. Root cause on record (R27): resetting the
corpus without repairing the growth-mode problems — ad-hoc pre-state
verification, context bloat — would hit the same limit again;
supporting mechanisms come first.

PD implementation is scenario-pinned from day one — it continues the
existing work items lead-x7bp (the progressive-disclosure epic:
L0/L1/L2 tiers + task-conditioned access against context bloat) and
lead-iixm (the PO task authoring the disclosure-conformance scenario
sets) — and lives as lead-side bootstrap code under the
spike-isolation precedent (adr-030's contract), handed off at
migration end (see Phase 3).

**Exit (authority-approved wording, verbatim):**

> Phase 2 ends with one demonstration on one real record. Pick one
> decision record from the frozen corpus. Then show that the new model
> can carry it, start to finish: (1) the decision-record chain exists
> and the authority has approved it; (2) the updated PM, PO, and
> Architect processes — not ad-hoc effort — perform the rewrite; (3)
> the rewritten record comes out at all three disclosure levels: L0
> (one line), L1 (the decision layer), L2 (the full record); (4) a
> consumer task then answers a real question about that record by
> loading only the level it needs — proving the disclosure levels are
> consumed, not just emitted. When that demonstration passes, Phase 2
> is over. Any definition not needed for it is not foundation work —
> it gets built later, by the run that needs it.

Consequence: the decision-record chain is built in Phase 2 (as the
demonstration vehicle), so Phase 3's decisions run starts with its
chain already proven.

### Phase 3 — the corpus migration runs

Subject to an explicit authority entry review before executing, after
Phase 2. Order within Phase 3:

1. **Features import** — precondition: progressive disclosure in
   place (met by the Phase 2 exit) plus hash verification tooling on
   the branch; verification: every imported pin's hash recomputes
   clean and scenario-refs regenerate.
2. **Decisions run (adr, pdr)** — the trust break lived here; 87
   keepers, the largest judgment mass. The chain arrives already
   proven from Phase 2; this run's chain review settles the standing
   artifact-type-set question (ADR vs PDR boundary, RACI) with the
   lead-jozud.2 evidence — the old separate gate is absorbed into this
   review — and fixes the final granularity of the F-family
   nominations (Appendix B), as before. It also authors the new
   structurizr architecture-model ADR (R28 — see the dissolution
   run's routing below).
3. **Dissolution run (R28 — replaces rev 4's framework-spec run)** —
   the framework spec gets NO bespoke type; once decisions are
   stable, its binding content re-homes into INSTANCES of existing
   artifact types, authored through those types' chains. Routing:
   `03-lead-shop.md` / `04-bc-shop.md` → role definitions, process
   definitions, glossary entries (much already consumed by Phase 1 as
   curated source — this run verifies coverage rather than
   re-authoring); `02-bounded-contexts-and-subdomains.md` /
   `06-work-tracking.md` → process definitions, data types, glossary;
   `05-inter-shop-protocol.md` → RETIRES with coverage
   (retire-with-coverage): channel/routing → the adr-006/adr-020
   rewrites (F3), message catalogue → the F3 vehicle-catalog record,
   wire format + schema invariants → the shop-msg schemas, scenario
   delivery → the scenario pins, cross-references → the adr-017
   rewrite — the run's mechanical coverage check blocks the
   retirement on any unmapped claim; `structurizr/` → one new ADR
   authored in the decisions run (the decision to maintain an
   architecture model as code, in structurizr — currently documented
   nowhere; only a passing mention in adr-037), one sub-process
   definition (model maintenance/regeneration), operational import of
   the 3 source files (README.md, workspace.dsl, workspace.json) at
   the operational-keeps stage under that process, and the 41
   generated `.structurizr/` cache files terminal; `README.md` /
   `current-state.md` / `artifact-lifecycle.md` / `consumer-wiring.md`
   → the run's outward-narrative slot: still keep-rewrite,
   re-authored late through the product-narrative path, their type
   defined by the run that needs it.
4. **PM-records run (intent, candidate, brief, session)** — 28
   keepers plus `drafts/artifact-system-restructuring.md`, which this
   plan assigns to this run: it is the initiative record this plan
   executes, direction-shaped and PM-lane; its rewritten type is
   decided at this run's chain review.
5. **Findings run** — the 4 ADR-cited keepers get the finding chain;
   the other 95 retire without one (99 findings md files on disk − 4
   keepers = 95).
6. **Operational keeps import** — `bin/`, compose, manifests, plus
   the 3 structurizr source files under the model-maintenance
   sub-process (R28) — when the migration-level done-demonstration
   needs a running system; precondition: the demonstration step that
   needs each keep; verification: the demonstration runs on the
   branch.
7. **Close-out / cut-over (mechanical, not a chain run)** — the
   `corpus-close-out` process runs all its stages at cut-over:
   snapshot tag `pre-migration` on `main`, terminal deletions, retire
   moves to the archive branch, retirement of the listed scenario
   files, `scenario-refs` regeneration, the close-out report — then
   the archive branch is cut and the migration branch becomes `main`.
   No chain — the scenario format is native.
8. **Code handoff** — the lead-side bootstrap code (basis tools, PD
   implementation) hands to a bounded context as the first
   post-migration dispatch, its contracts pre-existing via its
   scenario pins (the spike-graduation pattern, R27(d)).

## Execution readiness and entry conditions (per phase)

**The chains do not pre-exist.** Rev 2 claimed the principle-set
chain was "nearly complete"; that was false. The definitions of good
for the migrated types do not yet exist anywhere — each chain-bearing
phase or run BUILDS its type's chain first (build-chain → derive →
exemplar → authority review rounds, cap 3 → authority approval) and
only then rewrites keepers through it. What exists today is the seed
layer plus two session-record links; everything else is the phases'
own output.

Per-phase entry conditions and exits:

| phase | entry conditions | chain links existing today (of 6) | imports (precondition → verification) | exit (authority gate) |
|---|---|---|---|---|
| Seed | this plan approved (Ask 1); the five draft definitions approved (ruling 5); action table transcribed as the governed `actions` input | n/a — no chain work in Seed | `basis/` + its tools (lint passes on `main` → whole-basis lint passes on the branch); branch-native `.claude/` surface regenerated from the basis (basis imported → regenerated files match compiler output and a session loads under them). Beads: no import — dolt continuity is free | branch exists and holds exactly the seed; whole-basis lint passes on it |
| 0 | Seed exit | principle-set 1/6 — typedef only (seed layer) | curated feed only: the principle-set keeper (`01-principles.md`) per its action-table row | principle-set chain approved; rewritten principle set approved |
| 1 | Phase 0 exit; RULED (R29): meta-chains completed (guideline + fitness per meta-type) as this phase's first act | meta-chains approved (R23): role-definition and process-definition typedefs; the three role chains themselves 0/6 | curated feed only: source material named by the meta-chain authoring processes, including 03/04 + the scenario-discipline ADRs — the scenario discipline lands as PO/Architect process content (R28) | authority approves the PM, PO, and Architect definitions and their processes |
| 2 | Phase 1 exit; PD scenario pins exist (lead-iixm's scenario sets, sharpened as this phase's first PO work if not yet complete) | decision-record 0/6 — built IN this phase as the demonstration vehicle | curated feed only: one decision record from the frozen corpus (the demonstration keeper); PD bootstrap code lands under the spike-isolation contract | the verbatim Phase 2 exit demonstration passes and the authority approves it |
| 3 | Phase 2 exit; the explicit Phase 3 entry review passes; hash verification tooling on the branch (features import); `archive-move` tool built + archive contract ruled (ruling 4 — gates the close-out step, not the runs) | decision-record chain proven (Phase 2); PM types, finding 0/6 (session-record 2/6 — process + role exist); the dissolution run needs no bespoke chain — it authors instances of existing types (R28); scenarios need no chain (native format) | features import (PD in place + hash tooling → every pin's hash recomputes clean, scenario-refs regenerate); per-run curated feeds (87 decisions, the dissolution set, 28 PM + artifact-system-restructuring, 4 findings); operational keeps (`bin/`, compose, manifests — when the done-demonstration needs them → the demonstration runs) | every run done; migration done demonstrated ON the branch; close-out report accounts for every row; cut-over: branch becomes `main` |

Standing preconditions carried from rev 3, now placed at their gates:
the amended `definition-chain-migration` process and its governed
`actions` input (type `action-table`: rows of id / path / action /
family / directives / evidence — THE lawful channel for per-keeper
directives and family nominations) gate Seed via ruling 5; no run
reads this markdown directly — the transcribed `action-table` instance
is what the runs consume. The `archive-move` tool is specced, not yet
built (its contract is pending ruling 4); under R27 it gates only the
Phase 3 close-out step. The `corpus-close-out` process (stages
re-homed to cut-over) rides ruling 5's approval set.

## The authority's review surface

Every point where the authority sees, and can reject, migration work:

1. **This plan.** Block-approves the action table as census, the
   F-families as NOMINATIONS, and the import-stage assignments; its
   approval STARTS SEED. Rejectable here: any row, any family
   nomination, any import stage. Not decided here: final record
   granularity, final artifact-type set, archive execution. (The
   phase structure and Phase 3 run order are ruled, R27; the
   dissolution re-scope and the retire-with-coverage treatment, R28 —
   restated, not re-asked.)
2. **Phase gates.** Each phase exits only on authority approval: the
   Seed exit (branch holds exactly the seed, lint passes), the Phase 0
   and Phase 1 approvals, the Phase 2 exit demonstration, and — an
   explicit named gate — the **Phase 3 entry review** before any
   corpus run executes. Rejectable: any phase exit, which holds the
   next phase closed.
3. **Per run: chain + exemplar review.** The run's chain and one
   exemplar keeper rewritten through it come to review together.
   Verdicts: *clean*, *tradeoffs-accepted*, or *findings* (send back
   with the findings attached). Round cap 3; a chain that cannot pass
   within the cap PARKS with a filed finding — it never loops
   unbounded. Rejectable: any chain link, the exemplar, or the
   framing of the type itself.
4. **Chain approval stamps.** After a clean or tradeoffs-accepted
   verdict the authority stamps each chain document approved
   (`approve-chain`). Withholding the stamp stops the run before any
   mass rewrite; nothing is rewritten through an unapproved chain.
5. **During mass rewrite — PROPOSED attention contract** (pending
   ruling 3; presented as a recommendation): (a) per-family sign-off —
   no family's collapsed record is finalized without the authority's
   sign-off on that record; (b) a spot-check sample — e.g. every 10th
   rewritten keeper is pulled for authority reading; a failed
   spot-check pulls its whole family back to draft; (c) a veto window
   before each run's archive stage — the authority can hold any
   archive move before it executes. Rejectable: any family record,
   any sampled keeper (and with it its family), any archive move.
6. **Close-out / cut-over.** Mechanical, no judgment inside it — but
   it emits a post-check report (close-out-report): what was deleted,
   what moved to the archive branch, refs regenerated, and an
   accounting of every action-table row — and only after that report
   is accepted does the branch-becomes-`main` promotion run.
   Rejectable: the report itself — any unaccounted row or unexplained
   residue reopens the close-out and holds the promotion.

## Authority calls (record-level)

**All three calls RULED per the recommendation (R30, 2026-08-22,
brief-028 ask 6): retire.** The rows above carry the rulings; the
adr-046 fresh-decision and system-BOM-intent backlog items are filed.
The original calls are preserved below for the record.

1. **adr-033 (BC-local architect role)** — never realized; the pinned
   loop is Implementer→Reviewer only. *Recommend retire*: the role
   system re-founds through chains; a needed seat gets decided fresh.
   Default: held to the decision-chain review.
2. **adr-046 (shop-shell framework-image exemption)** — adr-046
   (status proposed) decided the framework image in `bin/shop-shell`
   becomes a parameterized, env-overridable variable sourced from the
   ADR-043 ops-coordinates artifact, overriding ADR-028's
   product-neutral-image exemption — but the live script still bakes
   the literal (`bin/shop-shell:136`,
   `--image ghcr.io/dstengle/shopsystem-bc-lead:latest`) and its
   comments still describe the exemption as in force: the record says
   one thing, the running system does another. (Rev 2 mislabeled this
   a "certificate-authority exemption"; verified against the script
   2026-08-22.) *Recommend retire*: the as-built behavior gets its
   decision fresh in the operations chain. Default: held to the
   decision-chain review.
3. **The system-BOM bundle (adr-047 + pdr-030 + brief-015 +
   features/system-manifest, 6 pins)** — pinned yet unrealized for
   months; no `system-manifest.yaml`, no tool. *Recommend retire the
   records and file one backlog work item carrying the intent verbatim*
   — the same pattern that preserved the sc06 scenario body (now
   backlog item lead-df2pj) in the memory close-out. Default: held to
   the decision-chain review.

## Action table — decisions (lane A, 108 rows)

The census covers what exists on disk: 69 ADR files + 39 PDR files =
108. Four ids in the numbering have no file and therefore no row:
adr-003, adr-007, adr-044, and pdr-008 are absent from the working
tree — never landed or already gone (adr-003 survives only as the
unmerged draft branch `adr-003-ecommerce-draft`). They were not
missed; there is nothing to disposition.

Keep-rewrite rows carry an F-family nomination in the reason cell
where one exists (map: Appendix B). Two keep-rewrite rows carry no
family — adr-002 and pdr-039; they rewrite one-to-one through the
decision chain unless the decisions-run chain review folds them into a
family.

| id | status | action | reason |
|---|---|---|---|
| adr-001 | accepted | keep-rewrite | Genesis; folds into F2 fleet record (now five+ BCs) |
| adr-002 | accepted | keep-rewrite | Contested fact resolved: harness BC now in manifest; no family — one-to-one |
| adr-004 | accepted | keep-rewrite | F2 fleet identity; bc-launcher live |
| adr-005 | accepted | keep-rewrite | F2; manifest mechanism live, header cites it |
| adr-006 | accepted | keep-rewrite | F3 addressing/registry; shop-msg live |
| adr-008 | accepted | retire | shopsystem-docs is a dead letter; no tags, not in manifest |
| adr-009 | accepted | keep-rewrite | F3 clarify vehicle; re-verify deferred primitive first |
| adr-010 | accepted | keep-rewrite | F3 clarify hash-scope rule; still binding |
| adr-011 | accepted | keep-rewrite | F3 bd-msg field mapping; live |
| adr-012 | accepted | keep-rewrite | F3 outbox atomicity; live |
| adr-013 | accepted | keep-rewrite | F3 dependency honoring; live |
| adr-014 | accepted | keep-rewrite | F3 heartbeat-in-watch; watcher is this shop's mechanism |
| adr-015 | accepted | keep-rewrite | F3 nudge liveness; live |
| adr-016 | accepted | keep-rewrite | F3 CLI-owned state changes; live |
| adr-017 | accepted | keep-rewrite | F3 shared work_id cross-reference; live |
| adr-018 | accepted | keep-rewrite | F5 empirical-verification discipline; quoted in live primers |
| adr-019 | accepted | keep-rewrite | F4 canonicalization ownership; scenarios CLI live |
| adr-020 | accepted | keep-rewrite | F3 abstract addressing; live registry |
| adr-021 | accepted | keep-rewrite | F2 bc-base image ownership; images published |
| adr-022 | accepted | keep-rewrite | F2 centralized rebuilds; live build path |
| adr-023 | proposed | retire | Superseded-in-fact by adr-025 (journal re-homed) |
| adr-024 | accepted | keep-rewrite | F4 journal rebuild; sc06-deferral clause scrubbed at rewrite (body carried by lead-df2pj) |
| adr-025 | accepted | keep-rewrite | F4 journal-as-file; live scenarios tooling |
| adr-026 | accepted | keep-rewrite | F9 broker architecture; broker healthy |
| adr-027 | accepted | keep-rewrite | F3 respond directionality; live |
| adr-028 | accepted | keep-rewrite | F9 broker-as-supporting-service; live |
| adr-029 | accepted | keep-rewrite | F7 mandatory rewrite; doctrine-loop record |
| adr-030 | accepted | keep-rewrite | F7 spike isolation contract; pinned scenarios |
| adr-031 | accepted | keep-rewrite | F7 wall protocol; pinned |
| adr-032 | accepted | keep-rewrite | F7 spike output form; pinned |
| adr-033 | accepted | retire | RULED R30: role never realized; pinned loop is Implementer-Reviewer only |
| adr-034 | superseded | retire | Superseded by adr-067 |
| adr-035 | superseded | retire | Superseded by adr-067 |
| adr-036 | accepted | keep-rewrite | F8 CLI-vs-prose enforcement; wrapper live |
| adr-037 | accepted | keep-rewrite | F8 spec-distribution boundary; still binding |
| adr-038 | accepted | keep-rewrite | F2 product-identity derivation; live |
| adr-039 | accepted | keep-rewrite | F2 release cadence; live |
| adr-040 | accepted | keep-rewrite | F10 Footing bootstrap; ~30 bootstrap features |
| adr-041 | accepted | keep-rewrite | F2 launch diagnostics; live |
| adr-042 | proposed | retire | Status-correction non-decision; open leg stale |
| adr-043 | accepted | keep-rewrite | F10 compute-once coordinates; 2nd-most origin-cited |
| adr-045 | proposed | keep-rewrite | F9 CA transport realized at shop-shell; needs terminal state |
| adr-046 | proposed | retire | RULED R30: decided image parameterization never implemented (`bin/shop-shell:136`); fresh decision carried by backlog item |
| adr-047 | proposed | retire | RULED R30 (system-BOM): never built; intent carried verbatim by backlog item |
| adr-048 | proposed | keep-rewrite | F12 fabro substrate realized; recover dates at rewrite |
| adr-049 | proposed | keep-rewrite | F12 vault-sole-credential; may fold into F9 |
| adr-050 | proposed | keep-rewrite | F12 launch parity; realized |
| adr-051 | proposed | keep-rewrite | F12 loop graph; poured and pinned |
| adr-052 | proposed | keep-rewrite | F13 dagger substrate; pinned dagger-ci features |
| adr-053 | proposed | keep-rewrite | F13 no-divergence rule; live |
| adr-054 | proposed | keep-rewrite | F13 build-egress credentials; live |
| adr-055 | proposed | keep-rewrite | F13 CA-trust base layer; live |
| adr-056 | accepted | keep-rewrite | F4 mandatory rewrite; most origin-cited (~10 decisions) |
| adr-057 | accepted | keep-rewrite | F12 pour projection; poured .fabro pinned |
| adr-058 | proposed | keep-rewrite | F12 reactive watcher; recover falsified date at rewrite |
| adr-059 | superseded | retire | Superseded by adr-067 |
| adr-060 | accepted | keep-rewrite | F4 block-only hash alignment; live |
| adr-061 | accepted | keep-rewrite | F15 licensing doctrine; collapses with adr-066 |
| adr-062 | proposed | keep-rewrite | F12 cross-runtime anchor; recover falsified date |
| adr-063 | accepted | keep-rewrite | F2 model mapping; verify via bc-launcher work_done |
| adr-064 | proposed | keep-rewrite | F4 retirement convention; this rebaseline's citation target |
| adr-065 | accepted | keep-rewrite | F7 findings-authority rule; may merge into doctrine |
| adr-066 | accepted | keep-rewrite | F15 Peters grant; skills poured and used |
| adr-067 | accepted | keep-rewrite | F14 mandatory rewrite; adopted fields only |
| adr-068 | accepted | keep-rewrite | F14 read-side CLI; verbs live |
| adr-069 | accepted | keep-rewrite | F14 per-type schema; gate green |
| adr-070 | accepted | keep-rewrite | F14 writing-skill structure; 8 skills poured |
| adr-071 | accepted | keep-rewrite | F14 writing-skill enforcement; check passes 8/8 |
| adr-072 | rejected | retire | Rejected; archive as-is |
| pdr-001 | proposed | keep-rewrite | F6 role system; router pattern live |
| pdr-002 | proposed | keep-rewrite | F6 subagent topology; content awaits artifact-type-set review |
| pdr-003 | proposed | keep-rewrite | F8 CLAUDE.md propagation; pour live |
| pdr-004 | proposed | keep-rewrite | F2 container command ownership; live |
| pdr-005 | proposed | keep-rewrite | Folds into F6 roles record |
| pdr-006 | proposed | keep-rewrite | F2 manifest ownership; live |
| pdr-007 | accepted | keep-rewrite | F3 name addressing; live |
| pdr-009 | accepted | keep-rewrite | F3 CWD resolution; live |
| pdr-010 | accepted | keep-rewrite | F3 bd/shop-msg authority split; live |
| pdr-011 | proposed | keep-rewrite | F5; collapses into ADR-018 discipline record |
| pdr-012 | proposed | retire-with-coverage | PM half superseded by pdr-033; binding structurizr half's covering home: the F6 rewrite (carry noted in Appendix B) |
| pdr-013 | proposed | retire-with-coverage | Three-tier half died with adr-067; splitting half's covering home: the work-splitting skill (compiled, live) |
| pdr-014 | proposed | keep-rewrite | F8 skill-group pour/graduation; live |
| pdr-015 | proposed | keep-rewrite | F4 journal intent; joins journal record |
| pdr-016 | proposed | keep-rewrite | F7 spike lifecycle; 8 pinned scenarios |
| pdr-017 | proposed | retire | Intent framing consumed by broker standup |
| pdr-018 | proposed | retire | One-shot MVP gate consumed |
| pdr-019 | proposed | retire | Decomposition/dispatch plan consumed |
| pdr-020 | proposed | keep-rewrite | F10 lead shell; sessions run inside it |
| pdr-021 | accepted | keep-rewrite | F10 Footing runway; live |
| pdr-022 | accepted | keep-rewrite | F9 provisioning delegation; tool exists |
| pdr-023 | proposed | keep-rewrite | F8 provenance marker; grounds live pour |
| pdr-024 | proposed | keep-rewrite | F10 doctor; bin/doctor exists |
| pdr-025 | proposed | retire | Named script absent; family re-adjudicates at chain review |
| pdr-026 | proposed | keep-rewrite | F2 image provenance labels; live |
| pdr-027 | proposed | keep-rewrite | F6 empty-repo discovery trigger; live standing rule |
| pdr-028 | proposed | keep-rewrite | F2 bootstrap version check; live |
| pdr-029 | accepted | keep-rewrite | F3 vehicle catalog; live |
| pdr-030 | proposed | retire | RULED R30 (system-BOM): rides adr-047 retirement |
| pdr-031 | rejected | retire | Rejected; its scenario surface retires with it |
| pdr-032 | superseded | retire | Superseded by pdr-035/037 line |
| pdr-033 | accepted | keep-rewrite | F6 PM-mode re-cut; only accepted RACI record |
| pdr-034 | proposed | retire | Superseded-in-fact by intent-013 rebaseline |
| pdr-035 | accepted | keep-rewrite | F14 needs statement; grounds adr-067 line |
| pdr-036 | accepted | keep-rewrite | F14 read-CLI needs; realized |
| pdr-037 | accepted | keep-rewrite | F14 per-type needs; rewrite writes missing sections |
| pdr-038 | accepted | keep-rewrite | F14 writing-skill mandate; realized |
| pdr-039 | proposed | keep-rewrite | Governing instrument; flips accepted at doctrine-loop exit; no family — one-to-one |
| pdr-900 | accepted | retire | Self-described legacy synthetic grounding |

## Action table — PM records (lane B, 67 rows)

67 rows = 14 intents + 11 candidates + 25 briefs + 17 session records
on disk.

| id | status | action | reason |
|---|---|---|---|
| intent-001 | recorded | keep-rewrite | Spine root of PM system; want ongoing |
| intent-002 | recorded | retire | Fulfilled via briefs 020/021 |
| intent-003 | recorded | keep-rewrite | Spend observability unbuilt; live want |
| intent-004 | recorded | retire | Superseded by intent-012 reframe |
| intent-005 | recorded | keep-rewrite | Ordering need unmet; feeds artifact-type-set review |
| intent-006 | recorded | retire | Fulfilled 07-25; approach superseded by intent-013 |
| intent-007 | recorded | keep-rewrite | Spine parent of committed cand-005 |
| intent-008 | recorded | keep-rewrite | Foundational-statement need is the live arc |
| intent-009 | recorded | retire | Fulfilled; CLI live, only bugfix beads remain |
| intent-010 | recorded | keep-rewrite | Per-type definitions is current direction |
| intent-011 | recorded | keep-rewrite | Authoring-guidance want re-founds |
| intent-012 | recorded | keep-rewrite | Live epic; grounds cand-010/brief-025 |
| intent-013 | recorded | keep-rewrite | Governing instrument of the rebaseline |
| intent-900 | recorded | retire | Synthetic reconstruction; historical |
| cand-001 | shaped | retire | Realized; superseded by restructuring |
| cand-002 | shaped | retire | Delivered via briefs 017/020/021 |
| cand-003 | shaped | terminal | Never committed; superseded by cand-010 |
| cand-004 | shaped | retire | Parked; rebaseline supersedes |
| cand-005 | committed | keep-rewrite | Origin-cited x5; committed-arc exemplar |
| cand-006 | committed | retire | Delivered as pdr-035 |
| cand-007 | committed | retire | Delivered as pdr-036 |
| cand-008 | committed | retire | Delivered as pdr-037; re-founds under artifact-type-set review |
| cand-009 | committed | retire | Delivered as pdr-038; skills shipped |
| cand-010 | shaped | keep-rewrite | Live first bet under intent-012; frozen not dead |
| cand-900 | committed | retire | Synthetic grounding; historical |
| brief-001 | draft | keep-rewrite | Most origin-cited lane record (x19 pins) |
| brief-002 | draft | keep-rewrite | Origin-cited x4; bootstrap scenarios live |
| brief-003 | draft | keep-rewrite | Origin-cited x2; activation is this session's watcher |
| brief-004 | draft | keep-rewrite | Origin-cited x2; container isolation live |
| brief-005 | draft | keep-rewrite | Origin-cited x1; manifest live |
| brief-006 | draft | keep-rewrite | Origin-cited x3; registry/inbox live |
| brief-007 | ready | retire-with-coverage | Never dispatched; covering home: its anchored ADRs' F-family rewrites carry the binding content |
| brief-008 | draft | terminal | Orphan draft; never advanced |
| brief-009 | draft | keep-rewrite | Origin-cited x5; journal shipped |
| brief-010 | draft | terminal | Draft never ready; never advanced |
| brief-011 | draft | terminal | Draft never ready; superseded framing |
| brief-012 | draft | terminal | Draft never ready; never advanced |
| brief-013 | draft | keep-rewrite | Origin-cited x5; healthy-bootstrap live |
| brief-014 | draft | keep-rewrite | Origin-cited x2; rides F3 catalog rewrite |
| brief-015 | draft | retire | RULED R30 (system-BOM): rides adr-047 retirement |
| brief-016 | draft | terminal | Draft never ready; re-homes per RACI specimen |
| brief-017 | draft | keep-rewrite | Origin-cited x2; live capability |
| brief-018 | draft | keep-rewrite | Origin-cited x1; re-homes in F14 rewrite |
| brief-019 | draft | keep-rewrite | Origin-cited x2; validation CLI shipped |
| brief-020 | ready | retire | Delivered; fabro provider fix shipped |
| brief-021 | ready | retire | Delivered; egress shim shipped |
| brief-022 | draft | terminal | Draft riding terminal cand-003; zero feature citations |
| brief-023 | draft | keep-rewrite | Origin-cited x1; gate CLI live |
| brief-024 | ready | retire | Executed 07-25; rebaseline supersedes |
| brief-025 | ready | keep-rewrite | Freeze-paused live commitment; re-anchors |
| sess-2026-05-11-a | closed | retire | Synthetic genesis reconstruction |
| sess-2026-07-09-a | closed | retire | Closed history; artifacts carry content |
| sess-2026-07-14-a | closed | retire | Closed history; intents carry content |
| sess-2026-07-14-b | closed | retire | Closed history; intents carry content |
| sess-2026-07-15-a | closed | retire | Closed history; line terminal anyway |
| sess-2026-07-16-a | closed | retire | Closed history; migration consumed |
| sess-2026-07-19-a | closed | retire | Closed history; known dangle noted |
| sess-2026-07-20-a | closed | retire | Closed history; withdrawal recorded |
| sess-2026-07-25-a | closed | retire | Closed history; artifacts carry it |
| sess-2026-07-27-a | closed | retire | Closed history; intent-012 carries reframe |
| sess-2026-08-02-a | closed | retire | Closed history; findings in intent-012 |
| sess-2026-08-02-b | closed | retire | Closed history; cand-010 carries shape |
| sess-2026-08-03-a | closed | retire | Closed history; outcomes carried |
| sess-2026-08-03-b | closed | retire | Closed history; intent-013 records direction |
| sess-2026-08-04-a | open | keep-rewrite | Open doctrine loop; produced pdr-039 |
| sess-2026-08-05-a | closed | keep-rewrite | Post-census; redirect not re-homed yet |
| sess-2026-08-05-b | closed | keep-rewrite | Post-census; live new-basis thread |

## Action table — scenarios (lane C, by directory; file rows only where different)

Units here are files and pins (anchored `@scenario_hash:` tag lines),
never records.

| path | files | pins | action | reason |
|---|---|---|---|---|
| features/agent-vault-broker/ | 1 | 15 | keep | Live broker contract; service running |
| features/dagger-ci/ | 4 | 4 | keep | Live CI-gate contracts adr-052..055 |
| features/shopsystem-bc-launcher/ | 67 | 222 | keep | Live fleet contract; RETIRED markers are completed retirements |
| features/shopsystem-knowledge/ | 27 | 141 | keep | Live contract, gate green — except four pdr-031 files below |
| features/shopsystem-knowledge/active_digest_generation.feature | 1 | 3 | retire | Rejected pdr-031 surface, no successor |
| features/shopsystem-knowledge/authoring_discovery.feature | 1 | 5 | retire | Rejected pdr-031 surface |
| features/shopsystem-knowledge/single_source_projection.feature | 1 | 4 | retire | Rejected pdr-031 surface |
| features/shopsystem-knowledge/distribution_boundary.feature | 1 | 3 | retire | Rejected pdr-031 surface |
| features/shopsystem-messaging/ | 58 | 153 | keep | Strongest-grounded contract; watcher runs on it |
| features/shopsystem-scenarios/ | 15 | 43 | keep | scenarios 0.3.1 live contract |
| features/shopsystem-templates/ | 116 | 296 | keep | Live BC — except three writing-skill files below |
| features/shopsystem-templates/writing_skill_template_structure.feature | 1 | 3 | retire | Writing-skill mechanism re-authors for smaller artifact-type set |
| features/shopsystem-templates/writing_skill_enforcement.feature | 1 | 5 | retire | Same |
| features/shopsystem-templates/lead_skill_artifact_validation_gate.feature | 1 | 4 | retire | Same |
| features/spike-lifecycle/ | 1 | 8 | keep | @origin:pdr-016; live |
| features/system-manifest/ | 1 | 6 | retire | RULED R30 (system-BOM): 6 pins retire with the bundle |
| features/test-harness/ | 1 | 5 | keep | Resolved: shopsystem-test-harness now in bc-manifest.yaml |
| features-provisional/devcontainer/ | 17 | — | retire | Authority 2026-07-04: no current use |
| features-provisional/docs/ | 5 | — | retire | Retires with adr-008 (shopsystem-docs dead letter) |
| features-provisional/README.md | 1 | — | retire | Parking note for the two retiring subtrees; leaves with them |
| scenario-refs/origin-index.txt | 1 | — | keep | Stale since 2026-07-04; bin/gen-scenario-refs regenerates it mechanically at close-out |

Pin arithmetic: 893 total = 860 keep + 27 retire (15 pdr-031 + 12
writing-skill) + 6 system-manifest (RULED R30).

## Action table — docs, findings, drafts, root (lane D, 135 md records + trees)

This lane's record unit is the markdown file: 135 on disk = 6 spec
files (01–06) + 8 root md files + 2 docs/runbooks + 99 findings + 20
drafts. **Self-exclusion:** `drafts/migration-plan.md` — this document
— is excluded from its own census (a register cannot disposition
itself); its type standing is RULED (see the Open rulings preamble;
the typedef rides ruling 5's approval set). Trees are counted
separately below, never as records. Rev 5 (R28) flipped
`05-inter-shop-protocol.md` from keep-rewrite to retire-with-coverage
and re-routed the `structurizr/` tree; the counts below reflect
exactly those flips.

Keep-rewrite (14 md): spec 01–04 and 06 (01 → Phase 0; 02–04 and 06
re-home as instances of existing artifact types in the dissolution
run — routing in Execution phases run 3); README.md;
current-state.md; artifact-lifecycle.md; consumer-wiring.md (these
four re-home to the dissolution run's outward-narrative slot,
re-authored late through the product-narrative path);
drafts/artifact-system-restructuring.md (the initiative record this
plan executes — assigned to the PM-records run, see Execution phases);
findings/adopter-journey-exploration-2026-06-18.md,
findings/external-content-license-compatibility.md,
findings/iterative-experimentation-capability.md,
findings/bc-workloop-single-source/02-oq1-generation-spike.md (the four
ADR-cited findings).

Structurizr tree (44 files — re-routed at rev 5 per R28, no longer
keep-rewrite as one tree): one new ADR authored in the decisions run
(the decision to maintain an architecture model as code, in
structurizr — currently documented nowhere; only a passing mention in
adr-037); one sub-process definition (model
maintenance/regeneration); the 3 source files (README.md,
workspace.dsl, workspace.json) import at the operational-keeps stage
under that process; the 41 generated `.structurizr/` cache files are
terminal. Counted as a tree throughout — its files enter no record
total.

Keep as-is (5 md): CLAUDE.md, INSTALL.md, AGENTS.md, both
docs/runbooks.

Terminal (7 trees, deleted whole at the cut-over close-out, after
the `pre-migration` snapshot tag): .fabro-e2e-scratch/, .specstory/,
scratch/, scratch_bodies/, scratch_k6xq/, scratchpad/,
scratchpad-bodies/ — 653 files, of which 82 are md (61 + 21 in the
first two; the rest hold 4 or 0 files). Counted as trees; the md files
inside them appear in no record total.

Retire (116 md): 05-inter-shop-protocol.md (retire-with-coverage —
flipped from keep-rewrite at rev 5 per R28; its coverage map is the
dissolution run's routing: channel/routing → adr-006/adr-020 rewrites
(F3), message catalogue → the F3 vehicle-catalog record, wire format
+ schema invariants → the shop-msg schemas, scenario delivery → the
scenario pins, cross-references → the adr-017 rewrite), all other
findings (95 = 99 on disk − 4 keepers), all other drafts (19), and
work-summary.md (1) — the full per-file list is Appendix A; every
plain-retire row's reason is "value passed / consumed / superseded"
with no ADR citing it as governing.

## The two-tree model (replaces rev 3's "interim consistency")

Rev 3's in-place model put frozen and rewritten records side by side
on `main` and managed the mix by discipline; R27 replaces that with
structure. There are exactly two trees, each internally consistent at
every moment:

- **`main` — all-frozen and operative.** The contract of record for
  the BC shops until cut-over: citable, unedited, under total freeze.
  Consumers on `main` see nothing of the migration until cut-over —
  BCs never see an intermediate state.
- **The migration branch — all-conforming.** Nothing exists on it
  except what an import step brought in (with precondition and
  verification) or what a chain-governed run produced. Migration
  sessions run on it under the branch-native `.claude/` surface from
  the first minute.

The mid-migration confusion window — a consumer mixing frozen and
rewritten records without noticing — structurally does not exist:
no tree ever holds both. Compiled skills, primers, and the principles
rendering on the branch regenerate from branch content only; the
frozen tree's projections stay untouched on `main` until the branch
becomes `main` at cut-over.

## What demonstrates done (PROPOSED standard — ruling 6)

Per the delivery-verified principle, artifacts existing and reviews
approving do not count as done on their own.

**Per phase, done means the phase's exit holds** — each exit as
stated in "Execution phases": Seed's branch-holds-exactly-the-seed
plus lint; Phase 0's and Phase 1's approved definitions; Phase 2's
verbatim exit demonstration, consumed and not just emitted; Phase 3's
runs and close-out.

**Per run (within Phase 3, and the Phase 0 principle-set run), done
means:** the chain is approved (stamps on all six links) AND the
exemplar and every rewritten keeper pass the type's fitness set AND
lint runs clean over the branch tree. For the dissolution run — which
builds no chain of its own (R28) — done means every authored instance
passes its receiving type's fitness set AND the mechanical coverage
check passes with zero unmapped claims.

**For the migration as a whole, done is demonstrated ON THE BRANCH,
before cut-over:** the compiled skills regenerate from the new
definitions and load; the principles rendering regenerates from the
approved set; gate and lint run green over the whole baseline; primers
and records cite only branch-native records; the operational keeps
imported for the demonstration actually run; and the close-out report
accounts for every action-table row with zero unaccounted. Only then
does cut-over promote the branch to `main`.

## Execution notes

- Retire mass moves to the archive branch per the pending archive
  contract (ruling 4): one parentless branch
  `archive/migration-2026-08`, verbatim files, never on `main` — the
  memory-archive R22 pattern. Terminal trees delete at the cut-over
  close-out, recoverable via the `pre-migration` snapshot tag. Under
  the branch model, retire and terminal rows are simply never
  imported to the migration branch; the archive moves and deletions
  execute against frozen `main` at cut-over.
- The 153-hash retirement from the prior census dissolves: hashes
  re-mint mechanically wherever contracts are re-authored; only the
  listed scenario files retire as files.
- Keeper counts by run: the decisions run carries 87 decision records;
  the PM-records run carries 28 PM records plus
  artifact-system-restructuring; the principle-set (Phase 0),
  dissolution, and findings runs are small (1 principle set; the
  dissolution set — 8 keep-rewrite md: 02–04 and 06 re-homing as
  instances, plus the four outward-narrative files — plus the 05
  retire-with-coverage check and the structurizr routing; 4
  findings).
- Edge closure verified: every keep-rewrite child has a keep-rewrite
  parent on the provenance spine.

## Sources

Per the external-standards-first principle, the external forms
considered for this plan:

- **Records-management disposition schedule** (retention/disposition
  register: record id / action / authority / evidence) — adopted: the
  action-table shape follows it, one row per record with a bounded
  action enum and per-row evidence.
- **Data-migration runbook pattern** (snapshot, entry conditions,
  staged execution, verification, rollback) — adopted: the snapshot
  tag, the per-run entry-condition table, the done-standard, and the
  mechanical close-out follow it.
- **Nygard ADR form** — considered for the plan itself; rejected: this
  is a register plus a runbook, not a single decision, and forcing it
  into a decision record would bury the table.

Recorded gap justifying the bespoke `migration-plan` form: no external
form found combines a disposition register with per-type
definition-chain builds whose output granularity is decided by a
downstream review — the family-nomination column has no external
analogue. The form's typedef is authored at
`basis/artifacts/migration-plan.md` per the 2026-08-22 ruling (see
Open rulings preamble); its approval rides ruling 5's set.

## Appendix A — lane D retire rows (116 md files)

spec (1): 05-inter-shop-protocol (retire-with-coverage, flipped at
rev 5 per R28 — the only non-plain retire in this list; its coverage
map lives in the dissolution run's routing, Execution phases run 3).

drafts/ (19 = 17 md + 2 skill files): artifact-definition-packet,
definition-format-decision-brief, definition-format-research,
grounding-record-demo-framework-spec, grounding-record-exp-iter1..5
(5 files), grounding-researcher-prompt-hardened,
knowledge-tools-and-skills-analysis, memory-action-table (executed),
probe-grounding-record-corpus-scope,
probe-grounding-record-graceful-shutdown (+v2),
process-definition-pilot, rebaseline-bill (superseded by this plan;
its family map lives on as Appendix B),
skills/test-driven-development/ (2 files).

findings/ top level (12): architect-prestate-verification-discipline,
from-mechanism-observation-v1, from-prototype-1,
independent-mvp-review-2026-06 (+WORKPLAN),
install-walkthrough-2026-06-15,
provision-template-value-format-probe-discipline,
scenario-retirement-rides-contract-vehicle-not-nudge,
scenario-supersession-and-dispatch-discipline,
templates-publishing-flow-2026-06-23,
typedef-doctrine-carrier-feasibility-2026-08-03,
venv-install-hygiene-and-fix-tooling-discipline.

findings/bc-lifecycle/ (1): 01-graceful-shutdown-recommendation.

findings/bc-workloop-single-source/ (1):
01-generation-mechanism-design (02-oq1-generation-spike is a keeper).

findings/ddd/ (5): 00-current-state-inventory,
01-artifact-options-research; research/ A-per-context-definition-artifacts,
B-strategic-map-artifacts, C-discovery-and-fit.

findings/prioritization-2026-06-30/ (6): 00-decision-and-research,
01-wsjf-report, 02-moscow-report, 03-contrast, 04-prioritized-list,
factors.

findings/progressive-disclosure/ (10): 00-plan through
09-handoff-P01-collision-reconciliation.

findings/scenario-integrity/ (5): 00-design through
04-mirror-and-cutover.

findings/archive/ (55): top level (9) — agent-vault-credential-spike,
dummyco-spike-iter-2..7 (6 files), fabro-2pc-as-steps-spike,
substrate-candidate-comparison-vs-fabro; dagger-spike/ (13);
fabro-spike/ (19 at top level); fabro-spike/fabro-defs/ (14).

root (1): work-summary.md.

Sum: 1 + 19 + 12 + 1 + 1 + 5 + 6 + 10 + 5 + 55 + 1 = 116 (115 plain
retire + the 05 retire-with-coverage row).
Findings check: 12 + 1 + 1 + 5 + 6 + 10 + 5 + 55 = 95 = 99 on disk −
4 keepers.

## Appendix B — Rewrite families (F-map)

The authoritative family table, recovered from the superseded
rebaseline-bill (2026-08-04, §1) and reconciled against this census's
reason cells; where they differ, this census wins. **Families are
NOMINATIONS** (open ruling 1): approving this plan approves the
groupings as the starting hypothesis the decisions-run chain review
works from; the final record granularity — how many rewritten records
each family actually becomes, and whether nominated folds hold — is
decided at that review, after the decision-record typedef, guideline,
and fitness set exist (built in Phase 2). Target counts below are
therefore nominal.

Rows with no family (adr-002, pdr-039 — see lane A intro) rewrite
one-to-one unless the decisions-run chain review folds them.

| code | name | members (keep-rewrite ids) | n | nominated output records (target) | rationale |
|---|---|---|---|---|---|
| F1 | Genesis | — (dissolved) | 0 | 0 | Assigned by the 2026-08-04 census to adr-001 alone with target 0 — its own fold sent adr-001 into F2's fleet record; this census carries adr-001 directly in F2. Dissolved, not lost. |
| F2 | BC fleet lifecycle | adr-001, adr-004, adr-005, adr-021, adr-022, adr-038, adr-039, adr-041, adr-063; pdr-004, pdr-006, pdr-028, pdr-026 | 13 | ~4: fleet registry + identity; image build/publish/provenance; launch diagnostics; model mapping | One live mechanism (bc-container fleet, five live BCs) currently described by thirteen records |
| F3 | Messaging and dispatch | adr-006, adr-009, adr-010, adr-011, adr-012, adr-013, adr-014, adr-015, adr-016, adr-017, adr-020, adr-027; pdr-007, pdr-009, pdr-010, pdr-029 | 16 | ~5: addressing + registry; bd↔msg integration + atomicity; liveness; clarify resolution; vehicle catalog | Strongest-grounded contract (shop-msg); rider: brief-014 rides the catalog rewrite |
| F4 | Scenario integrity | adr-019, adr-024, adr-025, adr-056, adr-060, adr-064; pdr-015 | 7 | ~4: canonicalization + hash; scenario schema + DONE gate; completion journal; retirement convention | The scenario contract mechanism; adr-056 alone bundles ~10 decision items |
| F5 | Empirical verification | adr-018; pdr-011 | 2 | 1: the empirical-verification discipline record | One discipline, quoted verbatim in live primers |
| F6 | Roles and PM | pdr-001, pdr-002, pdr-005, pdr-027, pdr-033 | 5 | ~2: role system; PM mode | Content gated on the lead-jozud.2 outcome; carry: the structurizr half of retiring pdr-012 |
| F7 | Spike and experiment | adr-029, adr-030, adr-031, adr-032, adr-065; pdr-016 | 6 | ~2: spike lifecycle; findings-authority + archive rule | Doctrine-loop territory; adr-029 rewrite must not fork from the loop record |
| F8 | Templates, pour, and skills | adr-036, adr-037; pdr-003, pdr-014, pdr-023 | 5 | ~3: pour/provenance/update; CLI-vs-prose enforcement; spec distribution | Largest pinned surface (shopsystem-templates) |
| F9 | Credentials and agent-vault | adr-026, adr-028, adr-045; pdr-022 | 4 | ~2: broker architecture; CA/credential transport | Broker healthy; adr-049 (F12) may fold in here — a decisions-run review question |
| F10 | Bootstrap, Footing, and operations | adr-040, adr-043; pdr-020, pdr-021, pdr-024 | 5 | ~3: Footing/bootstrap; lead shell; doctor/ops | This lead session runs inside the pdr-020/021 shell |
| F11 | System BOM | — (contingent, no keepers) | 0 | 0–1 | Reserved by the 2026-08-04 census for the system-BOM bundle, which holds zero keep-rewrite members — adr-047 and pdr-030 are authority-call rows. F11 is absent from the reason cells because no keeper carries it; it materializes (target 1) only if call 3 rules keep; the recommended retire leaves it at 0. |
| F12 | Fabro substrate | adr-048, adr-049, adr-050, adr-051, adr-057, adr-058, adr-062 | 7 | ~3: substrate + parity boundary; loop graph + reactive watcher; pour projection + cross-runtime anchor | Realized substrate stuck `proposed`; rewrites recover true dates from git |
| F13 | Dagger build | adr-052, adr-053, adr-054, adr-055 | 4 | ~2: build substrate + no-divergence; build-egress credentials + CA trust | Lead-side confirmation is the BC's work_done (dagger absent from lead host by design) |
| F14 | Typed-artifact knowledge system | adr-067, adr-068, adr-069, adr-070, adr-071; pdr-035, pdr-036, pdr-037, pdr-038 | 9 | ≤5 | The rebaseline's own subject records; adr-067 mandatory rewrite carrying only adopted fields; rider: brief-018 re-homes here |
| F15 | Licensing and ingestion | adr-061, adr-066 | 2 | 1: licensing doctrine + grant register | The Peters grant and the doctrine it resolves within |

Membership arithmetic: 13 + 16 + 7 + 2 + 5 + 6 + 5 + 4 + 5 + 7 + 4 +
9 + 2 = 85 familied keepers + 2 unfamilied (adr-002, pdr-039) = 87 =
lane A's keep-rewrite total. Nominal output: ~32–38 rewritten decision
records including the two one-to-one rows and F11's contingent 0–1 —
final counts at the decisions-run chain review.
