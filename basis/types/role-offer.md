---
type: data-type
id: role-offer
defines: role-offer
owner: product-authority
status: approved
approved: 2026-09-06
version: 1
created: 2026-09-06
updated: 2026-09-06
---

# Data type: role-offer

## Purpose

A lead-shop role's offer on attaching to an initiative: the complete
information on the decisions, or parts of decisions, in the role's
domain — the decisions its definition's Decisions owned section names
— given unasked, in one shape whichever role attaches. Produced by the
`attach-architecture` and `attach-usability` steps of
[`../processes/initiative-check.md`](../processes/initiative-check.md),
each by the role the step names; consumed by that process's `screen`
step, which judges it against the initiative fitness set, and its
`decide` step, where the authority reads it — both through its
rendering into the initiative, as the
[initiative typedef](../artifacts/initiative.md)'s Feasibility and
usability section states: the verdict with its reasons rendered there,
the full offer in the initiative's Document History until the cap's
split is ruled; and by the pre-bet route to a decision record, once
the process's owner adds it. The decision it implements is
[adr-2026-09-05-role-offer](../../decisions/adr-2026-09-05-role-offer.md).

`role` is the attaching role's id. `verdict` is the role's judgment
on the initiative in its domain's own terms — the solutions architect
role's feasibility verdict, the product designer role's usability
verdict — with its reasons. `decisions` are the decisions the bet
depends on that fall in the role's domain, each with `record`: the id
of a decision record standing in `decisions/` — an architecture
decision record or a product decision record, made through its own
process and checked before the bet — or the literal `none`, a value a
step can branch on; an entry in this offer, a Document History row, a
session record, or a work item is not the record. `risks` are the
risks to the initiative's measure. `unknowns` are what the role does
not know, each with the default it will apply. `evidence` is what the
role read — the records standing in the repository at its level: the
initiative, the feature repository, the contracts, the decision
records — never a Bounded Context's internals. Each of the four list
parts carries `none` — the reason the role's domain holds nothing
under it — when and only when its `entries` list is empty: a part is
never omitted, and a `none` is a claim the screen judges against the
role's domain. That `none` accompanies an empty `entries` and nothing
else is a judged check on the offer, not a schema constraint. The
attaching role writes every field.

## Schema

```yaml
schema:
  type: object
  fields:
    role: {type: string}                       # the attaching role's id, e.g. lead-solutions-architect
    verdict:
      type: object
      fields:
        value: {type: string}                  # the verdict in the role's domain's terms
        reasons: {type: string}
    decisions:                                 # the decisions the bet depends on, in the role's domain
      type: object
      fields:
        entries:
          type: array
          items:
            type: object
            fields:
              decision: {type: string}         # the decision, named
              record: {type: string}           # a decision record's id standing in decisions/, or the literal "none"
        none: {type: string, optional: true}   # required when entries is empty: why the role's domain holds no such decision
    risks:                                     # the risks to the initiative's measure
      type: object
      fields:
        entries: {type: array, items: {type: string}}
        none: {type: string, optional: true}   # required when entries is empty: the reason
    unknowns:                                  # what the role does not know
      type: object
      fields:
        entries:
          type: array
          items:
            type: object
            fields:
              unknown: {type: string}
              default: {type: string}          # what the role applies if the unknown stands at the bet
        none: {type: string, optional: true}   # required when entries is empty: the reason
    evidence:                                  # the records the role read, by id or path
      type: object
      fields:
        entries: {type: array, items: {type: string}}
        none: {type: string, optional: true}   # required when entries is empty: the reason
```

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Authored under init-role-decisions / feat-role-decisions on the authority's bet of 2026-09-06, implementing adr-2026-09-05-role-offer (checked, v3) §2 — one type, whichever role attaches — and the feature's constraints C1 (one shape, one type, one home; the parts as fields; a part outside the role's domain carried as "none" with the reason, never omitted), C4 (the evidence the role's admissible evidence at the coordinating level), and C5 (each decision entry's `record` a decision record's id or the literal "none", a routable value; what "a record stands" means). The name and field names are the author's under the data-type typedef (v3); the designer's U4 (the initiative's Document History v4) recommends the product designer role screen the field names — pending, a recommendation. Status approved on the authority's bet under the checked decision, as the implementation-guidance typedef's same-day precedent. Maker's evaluation against the data-type typedef's checklist: `defines` matches the id initiative-check references; producers (the two attach steps) and consumers (screen, decide, the pending pre-bet route) named and linked; every field typed, the one enum-like value (`none`) stated as a literal in its comment, nesting inline as the typedef admits. Made by the lead-solutions-architect role. |
