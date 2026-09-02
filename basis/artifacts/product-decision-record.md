---
type: artifact-typedef
id: product-decision-record-typedef
defines: product-decision-record
owner: product-authority
status: approved
approved: 2026-08-31
version: 6
created: 2026-08-26
updated: 2026-09-02
ancestry: [product-decision-record]
---

# Artifact type: product-decision-record

## Identity and ancestry

- **Type:** `product-decision-record` — the record of one product-level
  decision and its reasons: what was decided, by which role under which
  right, against which alternatives, with what consequences, and how
  hard it is to reverse. The product-side counterpart of the
  architecture decision record.
- **Produced by:** the [PO role](../roles/lead-po.md), for a decision the
  PM role or the PO role has taken; checked by the
  [PO output check](../processes/po-output-check.md) against the
  [product-decision-record fitness set](../fitness/product-decision-record.fitness.md).
  **Consumed by:** every role whose later decision the record bounds;
  Bounded Context shops; the PM role at the check.

## Required frontmatter

`type: product-decision-record`, `id`, `status` (draft | checked |
returned | pending-definition | superseded — replaces `checked` when the PO role
files a later record naming this one as superseded), `version`, `date`,
`decided-by` (the role, or `product-authority`), `right` (the decision
right exercised — for the authority's go, hold, or no-go on an
initiative, `bet` — or
`escalation`, in which case §1 names the escalation that settled it), `owner`, `created`, `updated`.

## Required sections

1. **Decision** — exactly one decision, as a sentence a reader can act
   on.
2. **Alternatives** — at least one the deciding role could have chosen,
   with the reason it was not.
3. **Consequences** — each: what changes, for whom, and what it costs or
   forecloses.
4. **Reversibility** — how hard the decision is to reverse and, if hard,
   what would trigger revisiting it.

## Rules

- Instances live in `decisions/` at the repository root — one shared
  home with the adr type, the filename prefix and the frontmatter
  `type` discriminating; which type records a decision is decided by
  the right exercised, per the rule the
  [adr typedef](adr.md) states.
- Whether the named role held the right it exercised is the PM role's
  ruling at the check, not the record's claim; a record whose decider
  is the authority is checked for form only.
- A superseding record links the one it supersedes.

## Commitment (Definition of Done)

A record is done when it has passed the PO output check against its
fitness set and the framing. **Consequence on failure:** it is returned with the
criterion named and binds nothing.

## Sources

Nygard's architecture decision record (decision, consequences); MADR
(considered alternatives); decider and reversibility as the shop's own
additions, from the roles' decision rights; the
[product-decision-record fitness set](../fitness/product-decision-record.fitness.md).

## Derived review checklist

- One decision, actionable. *(§Required sections 1; fitness 1)*
- A real alternative with its reason. *(§Required sections 2; fitness 2)*
- Decider and right, or the escalation, named. *(§Required frontmatter; fitness 3)*
- Each consequence names what changes, for whom, at what cost. *(§Required sections 3; fitness 4)*
- Reversibility and its trigger stated. *(§Required sections 4; fitness 5)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction from the approved fitness set; the ADR and MADR forms adopted for decision, consequences, and alternatives, with decider and reversibility as the shop's own additions. |
| 1 | 2026-08-26 | review | Screened: findings — definition wrongly in the ancestry; a PM-agent producer path ungrounded; the framing missing from the commitment; the escalation branch under-carried; an unverifiable Fowler attribution; checklist cited another document. |
| 2 | 2026-08-26 | update | Repairs: ancestry corrected; PO role sole producer; framing added; escalation named when right is escalation; attribution dropped; superseded's setter named; checklist cites this typedef's clauses. |
| 2 | 2026-08-26 | review | Re-screened: clean; two stumbles. |
| 3 | 2026-08-26 | update | the escalation's home named; superseded's transition from checked stated. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean — every round-2 change and stumble addressed; checklist citations resolve after renumbering. |
| 4 | 2026-08-28 | update | From the initiative chain's screen: the authority admitted as decider with the `bet` right, so the go/no-go on an initiative can be recorded; such a record is checked for form only. |
| 5 | 2026-08-31 | review | Batch A+B screen round 1: the bet right covers the go, the hold, and the no-go, so a cancellation at the bet or a discovery decline records under it. |
| 5 | 2026-08-31 | state | draft → approved with batch A+B as one block (brief-032 ask 2, default accepted). |
| 6 | 2026-09-02 | update | Owner rulings at the adr chain's review (brief-033 asks 3 and 4): instances live in the shared `decisions/` home, and the exercised right decides which decision-record type records a decision — the rule's one home is the adr typedef, referenced here. |
