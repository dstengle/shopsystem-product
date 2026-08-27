---
type: quality-guideline
id: backlog-order-guideline
target-type: backlog-order
owner: product-authority
status: draft
version: 2
created: 2026-08-27
updated: 2026-08-27
---

# Guideline: backlog order

**Voice principle.** Write the order for the shop deciding what to
take up next and the PM checking that the order follows the priority:
every item says which framing it serves, which context owns it, and
why it sits where it sits.

**Highlights (the layer compiled into generating context):** the
priority followed, stated in the document · every exception reasoned ·
every enabler recommendation placed or declined with a reason · every
item's framing and context named; cross-context items marked with
their escalation · the next item's readiness stated.

**Layers:** this guideline adds backlog-order rules on top of the
[base writing style](base-writing-style.md); the base always applies
and is never overridden. When rules conflict, an approved principle
beats the [backlog-order typedef](../artifacts/backlog-order.md), which
beats this guideline. Every rule feeds the
[backlog-order fitness set](../fitness/backlog-order.fitness.md),
scored in the [PO output check](../processes/po-output-check.md).

---

## Rules

**1. State the priority you followed, and reason every exception.**
Before: an ordered list with no reference to any priority.
After: "Priority followed: the PM's roadmap priority of 2026-08-20
(linked): failure visibility, then alerting, then archive. Exception:
item 3 (archive retention) precedes alerting because the archive
brief blocks the retention bug the shop reported."
*Test:* read §1 and compare the order against the priority it states.
*Criterion:* the priority is stated; every inversion carries a reason.
*Decision:* yes/no per order.
*Derived check:* judged — backlog-order fitness scenario 2.

**2. Every item names its framing or is declined with a reason.**
Before: "Item 4: refactor status handling."
After: "Item 4: status vocabulary alignment — serves the
failure-visibility framing (linked)." or "Declined: a status
refactor with no framed outcome; returned to the architect as enabler
work."
*Test:* read each item's framing reference. *Criterion:* a framing is
named, or the item is marked declined with its reason. *Decision:*
yes/no per item.
*Derived check:* judged — backlog-order fitness scenario 1.

**3. Place or decline each enabler recommendation, with reasons.**
Before: an architect's recommendation absent from the order.
After: "Enabler recommendations received: (a) list contract version 2
— placed at item 2, since item 3 depends on it; (b) status
consolidation — declined this order, no framing served yet."
*Test:* read §2 against the recommendations the order lists as
received. *Criterion:* each is placed with a reasoned position or
declined with a reason. *Decision:* yes/no per recommendation.
*Derived check:* judged — backlog-order fitness scenario 3.

**4. Name the owning context; mark and escalate cross-context items.**
Before: "Item 5: export failed runs as CSV."
After: "Item 5: export failed runs as CSV — reporting and export
contexts; cross-context, escalated to the PM role (linked)."
*Test:* read each item's context. *Criterion:* the owning Bounded
Context is named; an item crossing contexts is marked and its
escalation named. *Decision:* yes/no per item.
*Derived check:* judged — backlog-order fitness scenario 4.

**5. Say whether the next item is ready.**
Before: the first untaken item with no readiness statement.
After: "Next: item 1 — ready; its brief (linked) states it is checked."
or "Next: item 1 — not ready; waits on the designer's usability
criteria."
*Test:* read the first untaken item. *Criterion:* it is marked ready
with the artifact it states is checked linked, or not ready with what
it waits on. *Decision:* yes/no per order.
*Derived check:* judged — backlog-order fitness scenario 5.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-27 | update | Authored by owner direction to complete the type's definition chain; each rule maps to one fitness scenario. |
| 1 | 2026-08-27 | review | Screened: clean; "initiative" removed from an example as undefined. |
| 2 | 2026-08-27 | update | polish only. |
