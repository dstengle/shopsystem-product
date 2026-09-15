---
type: feature
id: feat-implementation-good
name: Implementation roles carry a stated definition of good
status: draft
version: 2
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

Usability, accessibility, and non-functional criteria: to be added at
the designer's and architect's steps.

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

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-15 | update | Authored alone from the initiative's Framing and For whom, scoped to session one; seven scenarios, all lead-shop-owned. Self-check against the feature guideline and typedef: narrative names who, what, and the framing's outcome (rule 1); each scenario one action and one observable Then, no implementation detail (rule 2); every scenario owned, interaction types "none" per the initiative's For whom (rules 3, 6); `@feature:` and `@hash:` present on all seven, hashes not computable here — no shell (rule 4); every case the framing names covered or excluded with reason, and the session-two content named out of scope (rule 5). Accepted gap: word targets (rules 8, 9) not counted by hand. |
| 2 | 2026-09-15 | update | Coordinator ran fill-hash after this step returned; all seven hashes filled. Revised per the coordinator's correction: scenario "the checking role requires an implementation's effect shown, not declared" named "the running system" — `delivery-verified`'s own mechanism, removed from the working set for being unmeetable by a corpus or a library — as the one form evidence must take. Its Then now requires evidence the effect occurred, in a form the definition of good or the product being built sets, keeping "not the maker's declaration alone," the defect that survives the removal. Its hash reset to pending; no shell here to re-run fill-hash. |
