---
type: feature
id: feat-implementation-good
name: Implementation roles carry a stated definition of good
status: checked
version: 5
initiative: ../initiatives/init-implementation-process.md
owner: lead-po
created: 2026-09-15
updated: 2026-09-15
---

# Feature: Implementation roles carry a stated definition of good

## Feature

Feature: Implementation roles carry a stated definition of good
  A shop that implements — Bounded Context or lead alike — can read
  one stated definition of good implementation engineering, carried
  by two named roles: one that makes an implementation, one that
  checks it against that definition,
  so that no implementation is judged by its own mechanism, a ledger
  of past incidents, or its maker's say-so.

## Contributors

Owning shop, per scenario, from the initiative: the lead shop's own
tree — its Appetite bars dispatch to a Bounded Context shop, and the
shop stands frozen (For whom section).

- *a stated definition of good implementation engineering exists* — shopsystem-product (the lead shop)
- *the definition judges an implementation by its outcome, not its mechanism* — shopsystem-product (the lead shop)
- *the definition states principle, not a ledger of past incidents* — shopsystem-product (the lead shop)
- *two implementation roles carry the definition, one making and one checking* — shopsystem-product (the lead shop)
- *the checking role requires an implementation's effect shown, not declared* — shopsystem-product (the lead shop)
- *the maker role holds no accountability for checking its own work* — shopsystem-product (the lead shop)
- *each implementation role's definition traces its accountability to the definition of good* — shopsystem-product (the lead shop)

Usability and accessibility criteria (designer): none are due. Checked
against the core-task list (basis/experience/core-tasks.md), not
taken on the initiative's word alone: none of its seven entries —
start, hold/resume/cancel, or read a decision on an execution; answer
an ask; submit output for a check; raise a clarify; deliver work for
reconciliation — names an act any of this feature's seven scenarios
performs. Each scenario reads or states a definition of good and two
role definitions; none is a person or an agent completing a core task
through an interaction type. The initiative's Appetite confirms this
reading: the implementation process, the lead shop's permission to
execute it, and the proof execution — where an execution would first
be started, held, or checked — are session two's, out of this
feature's scope. "None" in Interaction types stands, confirmed rather
than carried forward unread.

Non-functional criteria (architect): decomposition names none — the
initiative carries no Decomposition section, and the repository holds
no `basis/contexts/` directory or decomposition record of any kind.
`knowable-shape` and `bidirectional-conformance` (architecture
principles) screened against all seven scenarios: neither binds.
`knowable-shape`'s description obligation runs to Bounded Context and
shop entities, a closed set that does not include roles or definition
documents; `bidirectional-conformance` binds code to design, and no
code or running system sits in this feature's scope — the process and
its execution are session two's, per the initiative's Appetite. No
constraint written from either.

- the solutions architect role's constraint, on Scenario: the checking
  role requires an implementation's effect shown, not declared: needs
  decision: what form of evidence a check accepts, and which role
  declares it satisfied, now that `delivery-verified`'s removal
  (init-delivery-verified-removal) leaves no fixed mechanism naming the
  answer.

## Interaction types

None — the outcome adds no core task, and the ones it touches hold
already (the initiative's For whom section).

## Scenarios

```gherkin
Feature: Implementation roles carry a stated definition of good
  A shop that implements — Bounded Context or lead alike — can read
  one stated definition of good implementation engineering, carried
  by two named roles: one that makes an implementation, one that
  checks it against that definition,
  so that no implementation is judged by its own mechanism, a ledger
  of past incidents, or its maker's say-so.

  @bounded-context:shopsystem-product @feature:feat-implementation-good @hash:d11bce62c8e2
  Scenario: a stated definition of good implementation engineering exists
    Given a shop that implements, Bounded Context or lead
    When it looks for what counts as good implementation engineering
    Then it finds one stated definition, not scattered across a role's own prompt

  @bounded-context:shopsystem-product @feature:feat-implementation-good @hash:c4c48c7eef06
  Scenario: the definition judges an implementation by its outcome, not its mechanism
    Given the definition of good for implementation engineering
    When its criteria are read
    Then each criterion judges an implementation by the outcome it produces, and none names a tool, a step order, or a technique as the mark of good

  @bounded-context:shopsystem-product @feature:feat-implementation-good @hash:ab646950e73e
  Scenario: the definition states principle, not a ledger of past incidents
    Given the definition of good for implementation engineering
    When its criteria are read
    Then each criterion holds as a standing rule across cases, and none is keyed to a named past incident

  @bounded-context:shopsystem-product @feature:feat-implementation-good @hash:9dd7cbd13419
  Scenario: two implementation roles carry the definition, one making and one checking
    Given the two implementation roles
    When their definitions are read
    Then one is accountable for making an implementation and the other for checking it, and neither role is both

  @bounded-context:shopsystem-product @feature:feat-implementation-good @hash:bbccc3a1765c
  Scenario: the checking role requires an implementation's effect shown, not declared
    Given the checking role's definition
    When it states what counts as done
    Then it requires evidence that the effect occurred, in a form the definition of good or the product being built sets, and does not accept the maker's own declaration alone

  @bounded-context:shopsystem-product @feature:feat-implementation-good @hash:a9c2dc030958
  Scenario: the maker role holds no accountability for checking its own work
    Given the maker role's definition
    When it is read
    Then it names no accountability for checking its own implementation, and points that accountability to the checking role by name

  @bounded-context:shopsystem-product @feature:feat-implementation-good @hash:c78d764ecf61
  Scenario: each implementation role's definition traces its accountability to the definition of good
    Given the two implementation roles' definitions
    When they are read
    Then each names the definition of good for implementation engineering as the source its accountabilities are drawn from
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| No stated definition of good governs implementation engineering | the framing (the problem) | Scenario: a stated definition of good implementation engineering exists |
| Mechanism judged as good in place of outcome | the authority, confirmed defect (sess-2026-09-09-c) | Scenario: the definition judges an implementation by its outcome, not its mechanism |
| A ledger of past incidents standing in place of stated principle | the authority, confirmed defect (sess-2026-09-09-c) | Scenario: the definition states principle, not a ledger of past incidents |
| An implementation counted done without its effect shown | the authority, confirmed defect (sess-2026-09-09-c) | Scenario: the checking role requires an implementation's effect shown, not declared |
| The check held inside the maker's own prompt | the authority, confirmed defect (sess-2026-09-09-c) | Scenario: two implementation roles carry the definition, one making and one checking; Scenario: the maker role holds no accountability for checking its own work |
| The implementation process, the lead shop's permission to execute it, and one proof execution | the initiative's Appetite (session two) | Out of scope: this feature is session one's content; the process, the permission, and the proof execution are a later feature's |
| A Bounded Context shop dispatched new work | the initiative's Appetite no-gos (the shop stands frozen) | Out of scope: this feature's scenarios sit in the lead shop's own tree; no dispatch |
| What form of evidence a check accepts, with no fixed mechanism after `delivery-verified`'s removal | the architect's constraints step, on Scenario: the checking role requires an implementation's effect shown, not declared | needs decision — routed to adr-authoring; no scenario covers it |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-15 | update | Authored alone from the initiative's Framing and For whom, scoped to session one; seven scenarios, all lead-shop-owned. Self-check against the feature guideline and typedef: narrative names who, what, and the framing's outcome (rule 1); each scenario one action and one observable Then, no implementation detail (rule 2); every scenario owned, interaction types "none" per the initiative's For whom (rules 3, 6); `@feature:` and `@hash:` present on all seven, hashes not computable here — no shell (rule 4); every case the framing names covered or excluded with reason, and the session-two content named out of scope (rule 5). Accepted gap: word targets (rules 8, 9) not counted by hand. |
| 2 | 2026-09-15 | update | Coordinator ran fill-hash after this step returned; all seven hashes filled. Revised per the coordinator's correction: scenario "the checking role requires an implementation's effect shown, not declared" named "the running system" — `delivery-verified`'s own mechanism, removed from the working set for being unmeetable by a corpus or a library — as the one form evidence must take. Its Then now requires evidence the effect occurred, in a form the definition of good or the product being built sets, keeping "not the maker's declaration alone," the defect that survives the removal. Its hash reset to pending; no shell here to re-run fill-hash. |
| 3 | 2026-09-15 | update | add-usability run: read the core-task list (basis/experience/core-tasks.md) against all seven scenarios rather than taking the initiative's "none" on trust, and confirmed no core task — start, hold/resume/cancel, or read a decision on an execution; answer an ask; submit output for a check; raise a clarify; deliver work for reconciliation — is performed by a scenario that only reads or states a definition and two role definitions; the process and its first execution, where a core task would apply, are session two's, out of scope here. No usability or accessibility criteria added; the reason recorded in Contributors in place of the "to be added" placeholder; no Edges row added, since no criterion was written to name a failure or boundary case. Self-evaluation against define-good-up-front: this output's definition of good is the step's own prompt — write criteria or record their absence with reason, add Edges only for criteria actually written — and it is met: the "none" claim was checked against the named list rather than repeated, the reason given traces to the initiative's Appetite, and no criterion was manufactured to fill the section. Made by the lead-product-designer role. |
| 4 | 2026-09-15 | update | add-constraints run: verified for myself, not taken on the coordinator's word, that no decomposition exists — the initiative carries no Decomposition section and the repository has no `basis/contexts/` directory or decomposition record — and recorded that in Contributors rather than inventing constraints. Screened `knowable-shape` and `bidirectional-conformance` against all seven scenarios: neither binds, since the first's entity-description obligation is closed to Bounded Context and shop, not roles or definitions, and the second binds code to design, with no code or running system in this feature's scope. Judged scenario @hash:bbccc3a1765c's open question — what evidence form a check accepts, and who declares it, now that `delivery-verified`'s removal leaves no fixed mechanism — an unrecorded decision rather than mine to settle, and wrote it as "needs decision" on the constraint line it rides on, with one Edges row naming it, so product-flow routes it to adr-authoring. Self-evaluation against `define-good-up-front`: this step's definition of good is its own prompt — read decomposition, write constraints that ride by name on scenarios, name a needed decision rather than deciding it, record "none" where decomposition names none, add Edges only for constraints actually written — and it is met: the "no decomposition" claim was verified against the repository rather than repeated from the ask, no constraint was invented to fill the section, and the one line written names a decision, not a verdict. Accepted gap: the Contributors passage runs over the 70-word target (rule 9) — the screening reasoning and the needs-decision line both ride on scenario text that cannot be shortened without losing which scenario or principle each clause answers to. Made by the lead-solutions-architect role. |
| 5 | 2026-09-15 | update | Self-check: pass 1–6; fail 7 (designer/architect 'none' passages are reasoning); fail 8–9 (doc, Contributors, Edges, prior rows over word targets, unfixed). Needs-decision line correctly recorded. |
