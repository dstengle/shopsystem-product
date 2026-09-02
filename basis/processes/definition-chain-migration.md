---
type: process-definition
id: definition-chain-migration-process
owner: product-authority
status: approved
approved: 2026-08-22
version: 5
created: 2026-08-20
updated: 2026-09-02
produces: [definition]
carried-by: definition-chain-migration-skill
condition-language: cel
external-refs: []
---

# Process: Definition-chain migration

> Amended 2026-08-22.
> Re-approved by the authority 2026-08-22.

**Purpose:** Convert one artifact type from the frozen corpus into the new
baseline: build its definition chain, prove the chain on a real keeper,
approve it, rewrite every keeper through it, and move what does not survive
to the archive.

**Guiding statement:** Nothing enters the new baseline except through a
approved definition. A document in an undefined format is source material
for a rewrite, never a usable artifact.

**Outcomes:**
- O1. The type's definition chain is approved by the authority — witnessed
  by the check on `approve-chain`.
- O2. Every keeper is rewritten or demoted, none silently dropped —
  witnessed by the check on `rewrite-keepers`.
- O3. Retired and demoted records leave the active tree — witnessed by
  the `queue-demoted` run and the cut-over close-out's post-check.
- O4. A chain the authority cannot approve parks with a filed finding
  instead of looping — witnessed by the failsafe branch of
  `route-review` and the `park` step.

**Roles:** product-authority (human-held role — reviews, approves,
spot-checks). lead-pm — held by the
authority; its agent steps assist: `build-chain`, `exemplar-rewrite`,
`revise-chain`, and `rewrite-keepers` prepare the drafts and rewrites
— a keeper that cannot reach the bar is filed as a demotion nomination,
never demoted by the agent — and the authority decides at the review
steps whether each stands and at the close-out whether a nomination
holds.
The per-instance reviewer roles come from the chain itself once approved.

**Scope note:** one run migrates one artifact type. The order of runs
comes from the approved migration plan; keepers for the run are the
rows in `actions` whose action is keep-rewrite for that type. The
retire and terminal mass is not this process's work — it closes out
mechanically through
[`corpus-close-out.md`](corpus-close-out.md).

## Flow (compiled)

Generated from the steps below by `tools/compile_process.py`; do not
edit by hand.

```mermaid
flowchart TD
  build_chain(["Build the definition chain — agent: lead-pm<br/>in — artifact_type: string, keepers: string[], actions: action-table<br/>out — authored: string[]"])
  derive_chain["Derive the chain from references — runtime<br/>in — artifact_type: string, authored: string[]<br/>out — chain: definition-chain"]
  exemplar_rewrite(["Prove the chain on one keeper — agent: lead-pm<br/>in — chain: definition-chain, keepers: string[], actions: action-table<br/>out — exemplar: string"])
  authority_review[["Authority reviews chain and exemplar — human: product-authority<br/>in — chain: definition-chain, exemplar: string<br/>out — review: review"]]
  route_review{"Route on the verdict<br/>in — review: review, round: integer"}
  revise_chain(["Revise the chain — agent: lead-pm<br/>in — chain: definition-chain, review: review<br/>out — chain: definition-chain"])
  advance_round["Advance the round counter — runtime<br/>in — round: integer<br/>sets — round: integer"]
  approve_chain[["Approve the chain's documents — human: product-authority<br/>in — chain: definition-chain"]]
  rederive_chain["Re-derive the approved chain — runtime<br/>in — artifact_type: string<br/>out — chain: definition-chain"]
  rewrite_keepers(["Rewrite every keeper through the chain — agent: lead-pm<br/>in — chain: definition-chain, keepers: string[], exemplar: string, actions: action-table<br/>out — rewritten: string[], demoted: string[]"])
  queue_demoted["Queue demotions for the cut-over close-out — runtime<br/>in — artifact_type: string, demoted: string[]"]
  park["Park the type with a finding — runtime<br/>in — artifact_type: string, review: review"]
  __end(("end<br/>result — chain: definition-chain"))
  __start(("start")) --> build_chain
  build_chain --> derive_chain
  derive_chain --> exemplar_rewrite
  exemplar_rewrite --> authority_review
  authority_review --> route_review
  route_review -->|success exit: clean or tradeoffs accepted| approve_chain
  route_review -->|failsafe exit: round >= 3| park
  route_review -->|else| revise_chain
  revise_chain --> advance_round
  advance_round --> authority_review
  approve_chain --> rederive_chain
  rederive_chain --> rewrite_keepers
  rewrite_keepers --> queue_demoted
  queue_demoted --> __end
  park --> __end
```


## Data

Each entry names a process-local value. Simple types use JSON Schema
names inline; every structured shape is a `$ref` to a defined type with
an explicit source — `from:` links the defining file, or names the owning
package as `pkg:<package>/<type>` (fetched through that package's
contract tool).

```yaml
data:
  artifact_type: {type: string}
  keepers: {type: array, items: {type: string}}
  actions: {$ref: action-table, from: ../types/action-table.md}
  authored: {type: array, items: {type: string}}
  chain: {$ref: definition-chain, from: ../types/definition-chain.md}
  exemplar: {type: string}
  review: {$ref: review, from: ../types/review.md}
  round: {type: integer, initial: 1}
  rewritten: {type: array, items: {type: string}}
  demoted: {type: array, items: {type: string}}
```

## Steps

The `archive-move` command in `queue-demoted` follows the archive
contract stated once in [`corpus-close-out.md`](corpus-close-out.md)
(§Archive contract — recommended, pending the authority's decision); it is not
restated here. Under the cut-over execution model no archive move happens
per run: a demoted keeper's file lives on frozen `main`, so the run
only QUEUES the demotion (`--queue` flips the keeper's action-table
row to retire, recording the failing check); the actual move runs once,
at the Phase 3 cut-over close-out. Until the tool exists and the
contract is approved the step blocks — which is correct: mass moves
are mechanical or they do not happen.

```yaml
start: build-chain
parameters: [artifact_type, keepers, actions]
result: chain
steps:
  - id: build-chain
    name: Build the definition chain
    run-by: {role: lead-pm, execution: agent}
    inputs: [artifact_type, keepers, actions]
    outputs: [authored]
    checks:
      - size(authored) >= 6
    prompt: |
      Draft every link of the definition chain for this artifact type:
      typedef, quality guideline, fitness set, authoring process, roles,
      and the compiled skill. Source the content from the authority's
      recorded decisions and verbatim anchors, an autopsy of the best and
      worst existing instances among the keepers, and established
      external standards; name every adopted form in each document's
      Sources section. A document in an undefined format is source
      material only — nothing is used as-is. Per-keeper directives and
      family nominations come only from `actions` — the governed channel
      — never from retired documents. Family codes in `actions` are
      nominations: the chain review decides final record granularity, so
      do not pre-commit a collapse.
    next: derive-chain

  - id: derive-chain
    name: Derive the chain from references
    run-by: {execution: runtime}
    inputs: [artifact_type, authored]
    outputs: [chain]
    checks:
      - chain.typedef != "" && chain.guideline != "" && chain.fitness != ""
      - chain.process != "" && chain.skill != ""
    run: |
      python3 tools/lint_basis.py --derive-chain ${artifact_type}
    next: exemplar-rewrite

  - id: exemplar-rewrite
    name: Prove the chain on one keeper
    run-by: {role: lead-pm, execution: agent}
    inputs: [chain, keepers, actions]
    outputs: [exemplar]
    prompt: |
      Rewrite one real keeper through the drafted chain's authoring
      process, exactly as mass rewriting would run it. Pick a keeper of median size
      among the type's keepers, preferring the most recently active —
      representative by measure, not by ease. The keeper's per-keeper
      directives come only from its `actions` row — the governed channel
      — never from retired documents; a family code there is a
      nomination, not a commitment, since the chain review decides final
      record granularity. Record
      every point where the chain failed to decide something — that
      friction is a finding about the chain, and it goes to the authority
      with the exemplar.
    next: authority-review

  - id: authority-review
    name: Authority reviews chain and exemplar
    run-by: {role: product-authority, execution: human}
    inputs: [chain, exemplar]
    outputs: [review]
    prompt: |
      One review, one type: the chain and the exemplar rewritten through
      it, side by side. Rule on both — the chain's definitions and what
      they actually produced. Findings land as decisions; verdict "clean"
      or "tradeoffs-accepted" approves, "findings" sends the chain back.
    next: route-review

  - id: route-review
    name: Route on the verdict
    run-by: {execution: runtime}
    inputs: [review, round]
    branches:
      - label: "success exit: clean or tradeoffs accepted"
        when: review.verdict in ["clean", "tradeoffs-accepted"]
        next: approve-chain
      - label: "failsafe exit: round >= 3"
        when: round >= 3
        next: park
      - else: revise-chain

  - id: revise-chain
    name: Revise the chain
    run-by: {role: lead-pm, execution: agent}
    inputs: [chain, review]
    outputs: [chain]
    prompt: |
      Repair every finding in the review across the chain's links, then
      re-run the exemplar through any link that changed. A finding
      repaired in one link is checked against the others — the chain is
      one definition in six parts, not six documents.
    next: advance-round

  - id: advance-round
    name: Advance the round counter
    run-by: {execution: runtime}
    inputs: [round]
    set:
      round: round + 1
    next: authority-review

  - id: approve-chain
    name: Approve the chain's documents
    run-by: {role: product-authority, execution: human}
    inputs: [chain]
    outputs: []
    prompt: |
      Approval stamps every linked document: status approved, approved
      date, owner. The chain's own status is derived — it reads approved
      only when every link does. From this point the chain is the
      standard the mass rewrite is checked against, and changes to any
      link go through you.
    next: rederive-chain

  - id: rederive-chain
    name: Re-derive the approved chain
    run-by: {execution: runtime}
    inputs: [artifact_type]
    outputs: [chain]
    checks:
      - chain.status == "approved"
    run: |
      python3 tools/lint_basis.py --derive-chain ${artifact_type}
    next: rewrite-keepers

  - id: rewrite-keepers
    name: Rewrite every keeper through the chain
    run-by: {role: lead-pm, execution: agent}
    inputs: [chain, keepers, exemplar, actions]
    outputs: [rewritten, demoted]
    checks:
      - size(rewritten) + size(demoted) == size(keepers)
    prompt: |
      Run the type's approved authoring process once per keeper: author
      role and fresh reviewer role per the chain, authority spot-checks
      at the rate the authority sets. Each keeper's per-keeper
      directives and family nomination come only from its `actions` row
      — the governed channel — never from retired documents; family
      codes are nominations, and the chain review's decision on record
      granularity governs, not a pre-committed collapse. A keeper that
      cannot reach the bar
      after two attempts is nominated for demotion: file the nomination
      with a note naming the failing check; the authority decides it at
      the close-out. Never lower a check to pass a keeper.
    next: queue-demoted

  - id: queue-demoted
    name: Queue demotions for the cut-over close-out
    run-by: {execution: runtime}
    inputs: [artifact_type, demoted]
    run: |
      archive-move --queue --type ${artifact_type} --ids ${demoted}
    next: end

  - id: park
    name: Park the type with a finding
    run-by: {execution: runtime}
    inputs: [artifact_type, review]
    run: |
      bd create --title "Chain parked: ${artifact_type} after 3 review rounds" \
        --body "${review.top_changes}"
    next: end
```

## Derived checks

| Outcome | Check | Kind | Where |
|---|---|---|---|
| O1 | chain status approved before any mass rewrite | mechanical | `approve-chain.checks` |
| O2 | rewritten + demoted counts equal keepers | mechanical | `rewrite-keepers.checks` |
| O3 | every demoted id is queued as a retire row; it leaves the active tree at cut-over | mechanical — `queue-demoted.run` now, close-out post-check at cut-over | `queue-demoted.run` |
| O4 | parked types carry a filed finding | mechanical | `park.run` |
| all | this definition compiles and screens against the principle set | mechanical + judged | the compiler; the principles screen |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-20 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-22 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
| 3 | 2026-08-25 | update | Owner direction: a near-synonym of "role" retired and banned. |
| 4 | 2026-08-26 | update | Owner decision: lead-pm is held by the authority in person; the Roles header now names what the role's agent steps prepare and what the authority decides, per the lead-pm role's Interfaces. |
| 4 | 2026-08-26 | review | Assist re-basing screened: the rewrite-keepers prompt had the agent demote a keeper with no review step behind it, and named an undefined "attention architecture" — repaired in place: the agent nominates, the authority decides at the close-out; spot-check rate set by the authority. |
| 4 | 2026-09-02 | review | Skill rendering run (skill-rendering-process): the definition stands approved with no carried-by skill id, so no loadable skill renders at the agent’s load point — finding "missing definition-chain-migration-process no-skill-id" escalated; the owner decides the amendment. |
| 5 | 2026-09-02 | update | Owner decision, resolving the skill-rendering first run's no-skill-id escalation: carried-by definition-chain-migration-skill added, so the process renders to the agent's load point like every approved definition; the prose Carried-by paragraph left to the consistency pass (lead-dyz0o). |
