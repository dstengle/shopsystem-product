---
type: artifact-typedef
id: acceptance-scenarios-typedef
defines: acceptance-scenarios
owner: product-authority
status: draft
version: 3
created: 2026-08-26
updated: 2026-08-26
ancestry: [acceptance-scenarios]
---

# Artifact type: acceptance-scenarios

## Identity and ancestry

- **Type:** `acceptance-scenarios` — the set of Gherkin scenarios that
  states, as requirements, what counts as done for one behavior; the
  set the PO role submits and the owning Bounded Context shop executes.
  The scenarios are executable by the shop; the set as a document is
  judged by the [acceptance-scenarios fitness set](../fitness/acceptance-scenarios.fitness.md),
  never executed there.
- **Produced by:** the [PO role](../roles/lead-po.md) with the owning
  shop (scope and wording from the PO; steps and edge cases from the
  shop; context ownership and feasibility from the solutions architect;
  usability and accessibility criteria from the product designer);
  checked by the [PO output check](../processes/po-output-check.md).
  **Consumed by:** the owning shop's scenario register; the solutions
  architect role for assignment; the
  [interaction conformance check](../processes/interaction-conformance-check.md)
  for the interaction types named.

## Required frontmatter

`type: acceptance-scenarios`, `id`, `status` (draft | checked |
returned | pending-definition | assigned — replaces `checked` when the
solutions architect role assigns the set), `version`, `date`,
`behavior` (the behavior's name), `context` (the owning Bounded
Context), `framing` (link), `owner`, `created`, `updated`.

## Required sections

1. **Contributors** — the owning shop named as the source of steps and
   edge cases; where the behavior has an interaction, the product
   designer role's usability acceptance criteria and the accessibility
   criteria.
2. **Interaction types** — those the behavior must hold on, from the
   [core-task list](../experience/core-tasks.md), where the
   behavior has an interaction.
3. **Scenarios** — each with a tag carrying the set's `behavior` and
   `context` values and a hash field; Given/When/Then with one action or event
   in the When and an outcome observable in the running system in the
   Then; no step names an implementation detail.
4. **Edges** — each failure or boundary case the framing or the shop's
   contribution stated in §1 names, as a scenario above or marked out of scope with
   a reason.

## Rules

- The hash is of the scenario's text; a changed text is a new
  scenario. Whether the hash matches is a mechanical check, to be filed
  as a lint.
- A scenario written without the owning shop is not co-produced and
  fails the check.

## Commitment (Definition of Done)

A set is done when it has passed the PO output check against its
fitness set and the framing. **Consequence on failure:** it is returned
with the criterion named and no scenario enters a register.

## Sources

Gherkin (Given/When/Then, tags); Cucumber's guidance on the three
amigos (co-production); the experience principles `core-task-parity`
and `accessible-by-standard`; the
[acceptance-scenarios fitness set](../fitness/acceptance-scenarios.fitness.md).

## Derived review checklist

- Each scenario one observable behavior, no how. *(§Required sections 3; fitness 1)*
- Owning shop and both designer criteria present. *(§Required sections 1; fitness 2)*
- Tag and hash present on every scenario. *(§Required sections 3; §Rules; fitness 3)*
- Named edges covered or excluded with reason. *(§Required sections 4; fitness 4)*
- Interaction types named. *(§Required sections 2; fitness 5)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction from the approved fitness set; carries the co-production statement and the tag's content the set asked the typedef to carry. |
| 1 | 2026-08-26 | review | Screened: findings — definition wrongly in the ancestry; fitness 2's two criteria collapsed; an undefined consumer; the tag's content in two homes; checklist cited another document. |
| 2 | 2026-08-26 | update | Repairs: ancestry corrected; both criteria named; the conformance check linked; the tag carries the frontmatter values; assigned's setter named; checklist cites this typedef's clauses. |
| 2 | 2026-08-26 | review | Re-screened: clean; two stumbles. |
| 3 | 2026-08-26 | update | assigned's transition stated; edges bound to §1's stated contribution; core-task list linked. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean — every round-2 change and stumble addressed; checklist citations resolve after renumbering. |
