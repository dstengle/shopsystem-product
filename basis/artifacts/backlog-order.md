---
type: artifact-typedef
id: backlog-order-typedef
defines: backlog-order
owner: product-authority
status: draft
version: 4
created: 2026-08-26
updated: 2026-08-28
ancestry: [backlog-order]
---

# Artifact type: backlog-order

## Identity and ancestry

- **Type:** `backlog-order` — the PO role's ordered list of requirements
  within the PM role's framing, as submitted for the PM role's check:
  which requirement the shops take up next, the PO role's exclusive
  decision, with the priority, recommendations, and contexts it was
  ordered against stated in the document itself.
- **Produced by:** the [PO role](../roles/lead-po.md); checked by the
  [PO output check](../processes/po-output-check.md) against the
  [backlog-order fitness set](../fitness/backlog-order.fitness.md).
  **Consumed by:** Bounded Context shops taking up work; the solutions
  architect role (§Rules); the PM role at the
  check.

## Required frontmatter

`type: backlog-order`, `id`, `status` (draft | checked | returned |
pending-definition | current | superseded — `current` replaces
`checked` when the PO role publishes the order the shops take up from,
and `superseded` marks the one it replaces), `version`, `date`, `priority` (link to the PM role's
recorded roadmap priority; provenance — the check judges the priority
stated in §1), `owner`, `created`, `updated`.

## Required sections

1. **Priority followed** — the roadmap priority stated, and a reason for
   each exception to it in the order.
2. **Enabler recommendations received** — each recommendation from the
   solutions architect role, placed with its position reasoned or
   declined with a reason.
3. **The order** — each item: the framing it serves or a declined mark
   with reason; the owning Bounded Context, with a cross-context item
   marked and its escalation to the PM role named; and for the first
   untaken item, ready (with its checked feature linked)
   or not ready with what it waits on.

## Rules

- An order that omits a recommendation received or misnames a context
  is the solutions architect role's to raise; the check judges only
  what the order states.
- A superseding order links the one it supersedes.

## Commitment (Definition of Done)

An order is done when it has passed the PO output check against its
fitness set and the framing. **Consequence on failure:** it is
returned with the criterion named and the current order stands.

## Sources

The Scrum Guide's product backlog (ordered, transparent, one owner);
the shop's own role definitions (the PO role's exclusive domain; the
PM role's roadmap priority; the solutions architect's enablers and
decomposition); the
[backlog-order fitness set](../fitness/backlog-order.fitness.md).

## Derived review checklist

- Every item names its framing or is declined with reason. *(§Required sections 3; fitness 1)*
- Priority stated and exceptions reasoned. *(§Required sections 1; fitness 2)*
- Recommendations placed or declined. *(§Required sections 2; fitness 3)*
- Contexts named; cross-context escalations named. *(§Required sections 3; fitness 4)*
- Next item's readiness stated. *(§Required sections 3; fitness 5)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction from the approved fitness set; the first definition to treat the backlog order as an artifact. |
| 1 | 2026-08-26 | review | Screened: findings — definition wrongly in the ancestry; current/superseded ungrounded; the commitment diverged from the process; checklist cited another document. |
| 2 | 2026-08-26 | update | Repairs: ancestry corrected; current and superseded's setter and trigger named; commitment aligned; checklist cites this typedef's clauses. |
| 2 | 2026-08-26 | review | Re-screened: clean; two stumbles. |
| 3 | 2026-08-26 | update | current's transition stated; the architect's raising rule kept in one home. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean — every round-2 change and stumble addressed; checklist citations resolve after renumbering. |
| 4 | 2026-08-28 | update | Owner decision: acceptance-scenarios re-formed as feature (product-level, scenarios assigned per Bounded Context by tag); the brief retired — shops receive their assigned scenarios. |
