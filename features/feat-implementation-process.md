---
type: feature
id: feat-implementation-process
name: Implementation executes through one defined process
status: assigned
version: 4
initiative: ../initiatives/init-implementation-process.md
owner: lead-po
created: 2026-09-17
updated: 2026-09-17
---

# Feature: Implementation executes through one defined process

## Feature

Feature: Implementation executes through one defined process
  Every shop that implements — Bounded Context and lead alike — and
  the authority reading cost per initiative,
  can rely on one defined process, running the maker and checking
  roles that carry the definition of good, that every such shop
  executes on what it owns, with the lead shop permitted to execute it
  now, while the shop stands frozen,
  so that each execution's cost lands on the initiative it belongs to,
  in place of a build made outside any process.

## Contributors

Owning shop for all four scenarios: shopsystem-product (the lead
shop) — no Decomposition section exists, and the Appetite bars
dispatch to a Bounded Context shop.

- *a defined implementation process exists* — shopsystem-product
- *the process runs the maker role, then the checking role, before an execution counts done* — shopsystem-product
- *the lead shop executes the process on what it owns, without dispatch* — shopsystem-product
- *every execution's cost lands on the initiative that owns it* — shopsystem-product

Product designer: no usability or accessibility criteria due — no
scenario names an interaction type (Interaction types section).

Solutions architect, non-functional constraints — no Decomposition
section exists; three architecture principles bind, one per scenario:

- Scenario: a defined implementation process exists —
  `bidirectional-conformance`: an approved change to the process is a
  recorded update, never drift.
- Scenario: the process runs the maker role, then the checking role —
  `actor-neutral-discipline`: the roles' rules apply the same for any
  actor; the evidence bar rides on
  adr-2026-09-16-scenario-evidence-form.
- Scenario: every execution's cost lands on the initiative that owns
  it — `local-comprehension`: the cost record lands on the initiative
  itself, readable without opening execution internals.

## Interaction types

None — the outcome adds no core task, and the ones it touches hold
already (the initiative's For whom section).

## Scenarios

```gherkin
Feature: Implementation executes through one defined process
  Every shop that implements — Bounded Context and lead alike — and
  the authority reading cost per initiative,
  can rely on one defined process, running the maker and checking
  roles that carry the definition of good, that every such shop
  executes on what it owns, with the lead shop permitted to execute it
  now, while the shop stands frozen,
  so that each execution's cost lands on the initiative it belongs to,
  in place of a build made outside any process.

  @bounded-context:shopsystem-product @feature:feat-implementation-process @hash:e996f2d086ab
  Scenario: a defined implementation process exists
    Given a shop that implements, Bounded Context or lead
    When it looks for how to execute an implementation
    Then it finds one defined process, not an approach chosen anew per build

  @bounded-context:shopsystem-product @feature:feat-implementation-process @hash:afe74d3e9ff5
  Scenario: the process runs the maker role, then the checking role, before an execution counts done
    Given the implementation process
    When an execution runs
    Then the maker role produces the implementation and the checking role evaluates it before the execution counts done

  @bounded-context:shopsystem-product @feature:feat-implementation-process @hash:f90002450ad9
  Scenario: the lead shop executes the process on what it owns, without dispatch
    Given the lead shop's own tree, standing frozen to dispatch
    When the lead shop implements a scenario it owns
    Then it executes the defined process itself, with no step of that execution requiring dispatch to a Bounded Context shop or mailbox work

  @bounded-context:shopsystem-product @feature:feat-implementation-process @hash:0e92f2731640
  Scenario: every execution's cost lands on the initiative that owns it
    Given a completed execution of the process
    When the execution's cost is recorded
    Then it lands on the initiative whose feature the executed scenario belongs to, for the authority to read
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| No process governs how an implementation is executed, so each build follows its own approach | the framing (the problem); gap lead-ki66p | Scenario: a defined implementation process exists |
| An implementation counted done without both the maker and the checking role acting | the framing's outcome ("the roles that carry it") | Scenario: the process runs the maker role, then the checking role, before an execution counts done |
| The lead shop implementing without permission, or only through a dispatch the freeze bars | the Appetite (session two: "the lead shop's permission to execute it"); the Appetite no-go barring dispatch and mailbox work | Scenario: the lead shop executes the process on what it owns, without dispatch |
| An execution's cost left unrecorded, or recorded off any initiative | the framing's outcome; the For whom section's measure | Scenario: every execution's cost lands on the initiative that owns it |
| A Bounded Context shop executing the process before cut-over | the Appetite no-gos (the shop stands frozen; no change to a scenario assigned to a Bounded Context shop) | Out of scope: the process is defined for every shop that implements, but only the lead shop executes it now |
| Which execution proves the process | the Appetite v4 (the order flip; the boundary session two names) | Out of scope: the proof execution runs on the initiative's next real feature, chosen at that feature's own assignment, not on this bet's own artifacts |
| This feature's and feat-implementation-good's own scenarios, built before this process existed | the Appetite (the bootstrap) | Out of scope: declared the bootstrap, the last build this shop makes outside a defined process; not evidence the process works |
| The maker or checking role's evaluation skipped or lightened because an agent, not a human, performs it | the architect's constraints step (`actor-neutral-discipline`) | Scenario: the process runs the maker role, then the checking role, before an execution counts done |
| The defined process changes without a recorded update, and an execution follows the new approach unrecorded | the architect's constraints step (`bidirectional-conformance`) | Scenario: a defined implementation process exists |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-17 | update | Authored alone from the initiative's Framing and For whom, scoped to session two per Appetite v4: the process, the lead shop's permission to execute it, and the proof-execution boundary. Four scenarios, all lead-shop-owned; no Decomposition exists. feat-implementation-good read and not restated — its two roles named by role only. `@hash:pending` on all four, no shell here. Accepted gap: word targets not counted by hand. |
| 2 | 2026-09-17 | update | add-constraints run: verified for myself that no Decomposition section exists on the initiative and no `basis/contexts/` directory exists in the repository, rather than taking the declared input on trust. Screened all six architecture principles against all four scenarios: `actor-neutral-discipline`, `local-comprehension`, and `bidirectional-conformance` bind, one per scenario, each written as a Contributors line; `knowable-shape` and `contracts-between-contexts` do not bind — no Bounded Context or shop entity is created or described, and no channel crosses Bounded Contexts, since the feature bars dispatch; `intent-provenance` does not bind — the feature carries no new intent, only the initiative's own. Read adr-2026-09-16-scenario-evidence-form before writing the checking-role scenario's constraint: it already sets the evidence bar the process's check step will read, so that scenario rides on the recorded decision rather than needing one of its own; no "needs decision" line was written. Two Edges rows added, for the two constraints naming a case not already in the table; the third constraint's case (cost recorded off the initiative) is already covered by the existing cost-scenario row, so no row duplicates it. Self-evaluation against `define-good-up-front`: this step's definition of good is its own prompt — read the decomposition (confirmed absent), write constraints that ride by name on scenarios, flag a needed decision rather than deciding it, add Edges only for cases actually named — met: nothing was invented to fill the section, the one scenario near a decision was checked against the standing ADR before any flag was considered, and no flag was written. Accepted gap: the Contributors passage runs over the 70-word target (rule 9) — three principles' screening reasoning and three scenario-named constraints cannot be shortened further without losing which principle or scenario each answers to. Made by the lead-solutions-architect role. |
| 3 | 2026-09-17 | update | Self-check: pass 1–6; fixed 7 (Contributors reasoning trimmed to bullets, moved to history); fail 8–9 (whole doc, Contributors, Edges, prior rows over word targets, unfixed without cutting owed facts or rewriting past rows). |
| 4 | 2026-09-17 | state | `checked` → `assigned`: the scenario-assignment process's record step, by the lead-solutions-architect role. One assignment entry — context shopsystem-product (the lead shop), scenarios @hash:e996f2d086ab, @hash:afe74d3e9ff5, @hash:f90002450ad9, @hash:0e92f2731640. Pre-state read: verified no `basis/contexts/` tree and no `contracts/` tree exist on this branch, and init-implementation-process (v4) carries no Decomposition section; swept `features/` (feat-implementation-good v6, feat-process-runner v12, feat-run-measurement v13, feat-initiative-cost-rollup v11) for conflicts — none found. Implementation guidance written, one record for the one context: guidance/feat-implementation-process-shopsystem-product.md (v1, status written). Maker's evaluation against the implementation-guidance fitness set (v2) — scenario 1 (the architect's level) pass: every What-changes statement names a process-definition, a step's run-by, or an existing tool, none the lead shop's internals beyond that; scenario 2 (cited, never restated) pass: scenarios cited by hash, feat-implementation-good and the cost features cited by name and version, no scenario text reproduced; scenario 3 (actionable alone) pass: the shop can start the new process-definition and its two fixed-role steps with this record and the assigned scenarios alone; scenario 4 (reasons) pass: each What-not-to-do entry names its reason — `single-source-of-truth`, the initiative's no-go, or `contracts-between-contexts` binding nothing here; scenario 5 (one assignment) pass: frontmatter names the initiative, feature, context, and the four hashes, every statement scoped to them; scenario 6 (word target) pass: 486 words in the body, under the 600-word guidance-record target. Sent: none — no `assign_scenarios` message went out. The one context, shopsystem-product, is the lead shop itself, not a Bounded Context to receive a message; the branch primer bars dispatch and mailbox work while the shop stands frozen. This is the already-recorded process gap lead-ki66p (scenario-assignment defines no lead-shop-internal path), disclosed by the runner as the eleventh assignment handled this way — a later reader must not read this silence as a dispatch that happened. The lead shop's own scenarios stand assigned to itself and are taken up in its tree. Version bumped 3 → 4. |
