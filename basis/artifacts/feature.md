---
type: artifact-typedef
id: feature-typedef
defines: feature
owner: product-authority
status: draft
version: 7
created: 2026-08-26
updated: 2026-08-28
ancestry: [feature]
---

# Artifact type: feature

## Identity and ancestry

- **Type:** `feature` — a Gherkin Feature: one capability described
  from the user's or agent's point of view, with the scenarios that
  state, as requirements, what counts as done for it. A product-level
  artifact: it belongs to the [initiative](initiative.md) it is made
  from and may hold scenarios owned by
  several Bounded Contexts. The scenario is the atom; the feature is
  its grouping; a Bounded Context's scenario register is the subset of
  scenarios, across all features, tagged to it. The instance is a
  markdown document with frontmatter whose Scenarios section holds one
  fenced Gherkin block — the executable unit the shops receive; the
  other sections are the document's, not Gherkin's. Scenarios are
  executed by the owning shops; the feature as a document is judged by
  the [feature fitness set](../fitness/feature.fitness.md), never
  executed there. `ancestry` names no generic root: a feature is
  neither a request nor a definition.
- **Produced by:** the [PO role](../roles/lead-po.md), with the shops
  that own the behaviors (scope and wording from the PO; steps and edge
  cases from each owning shop; usability and accessibility criteria
  from the product designer role); checked by the
  [PO output check](../processes/po-output-check.md); its scenarios
  assigned to Bounded Contexts by the solutions architect role in the
  [scenario assignment](../processes/scenario-assignment.md) process.
  **Consumed by:** the shops, each receiving the scenarios tagged to it;
  the [interaction conformance check](../processes/interaction-conformance-check.md)
  for the interaction types named; the changelog rendering the same report proposes, when the
  [reconcile-and-close](../processes/reconcile-and-close.md) process
  closes the work that delivered its scenarios.

## Required frontmatter

`type: feature`, `id`, `status`, `version`, `name` (the Feature's
name), `initiative` (link to the initiative it is made from; its
framing is that document's first section), `owner`, `created`,
`updated`. `approved` does not apply: a feature's terminal state is
`assigned`. Status values and their writers: `draft` (the PO role);
`checked`, `returned`, `pending-definition` (the PO output check's
record step, replacing `draft`); a returned or pending feature the PO
role resubmits goes back to `draft`; `assigned` (the scenario
assignment process's record step, replacing `checked` when every
scenario carries its tag); a feature the assignment process returns
goes to `returned`.

## Required sections

1. **Feature** — the Gherkin `Feature:` line with its name, and the
   narrative beneath it: who the capability is for, what they can do,
   and the outcome it serves, in the framing's words.
2. **Contributors** — for every scenario, the shop named as the source
   of its steps and edge cases — the shop the solutions architect's
   decomposition places the behavior in; where the capability has an
   interaction, the product designer role's usability acceptance
   criteria and the accessibility criteria.
3. **Interaction types** — always present: the interaction types the
   capability must be available on, from the
   [core-task list](../experience/core-tasks.md), or "none" with the
   reason when the capability has no interaction.
4. **Scenarios** — one fenced `gherkin` block, the executable unit:
   it opens with the `Feature:` line and narrative of §1 verbatim (§1
   is the document's reading of the block's head; the block is the
   source, and the repeat is accepted so the document reads without
   the block), then an optional `Background:` (its Given steps judged as any
   step), then each `Scenario:` carrying the tags `@feature:<id>` (so a
   scenario travels alone to a register and still names its feature —
   the reason the Feature line's tag inheritance is not relied on),
   `@hash:<sha>` (a hash of the scenario's text), and, once assigned,
   `@bounded-context:<name>`; Given/When/Then with one action or event
   in the When and an outcome observable in the running system in the
   Then; no step names an implementation detail.
5. **Edges** — a table of every failure and boundary case the framing
   or a contributing shop named: case · who named it · the `Scenario:`
   name that covers it, or "out of scope" with the reason.

## Rules

- A scenario's `@bounded-context:` tag is written by the solutions
  architect role at assignment, never by the PO role — a writer rule
  the assignment process enforces; the check does not judge the tag's
  presence, since a re-verified or resubmitted feature may carry it. In
  the assignment process, a scenario whose owning context differs from
  its Contributors' shop is treated as unowned with that reason, so the
  feature returns (`returned`) for co-production with the newly named
  shop.
- A changed scenario text is a new scenario with a new `@hash:`.
  Whether the hash matches the text is a mechanical check, to be filed
  as a lint.
- A scenario written without the shop named as its source is not
  co-produced and fails the check.

## Commitment (Definition of Done)

A feature is done when it has passed the PO output check against its
fitness set and the framing, and every scenario carries a
`@bounded-context:` tag. **Consequence on failure:** it is returned
with the criterion named and no scenario enters a register.

## Sources

Gherkin (Feature, narrative, Background, Scenario, tags — the block's
form); Cucumber's guidance on the three amigos (co-production); the
experience principles `core-task-parity` and `accessible-by-standard`.

## Derived review checklist

- Feature line and narrative present, tied to the framing. *(§Required sections 1; fitness 6)*
- Each scenario one observable behavior, no how. *(§Required sections 4; fitness 1)*
- Every scenario has a named source shop; designer criteria where there is an interaction. *(§Required sections 2; fitness 2)*
- `@feature:` and `@hash:` on every scenario. *(§Required sections 4; fitness 3)*
- Every listed edge covered or excluded with reason. *(§Required sections 5; fitness 4)*
- Interaction types section present, named or "none" with reason. *(§Required sections 3; fitness 5)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored as `acceptance-scenarios` from the approved fitness set; carried the co-production statement and the tag's content the set asked the typedef to carry. |
| 1 | 2026-08-26 | review | Screened: findings — definition wrongly in the ancestry; fitness 2's two criteria collapsed; an undefined consumer; the tag's content in two homes. |
| 2 | 2026-08-26 | update | Repairs: ancestry corrected; both criteria named; the conformance check linked; the tag carries the frontmatter values. |
| 3 | 2026-08-26 | update | assigned's transition stated; edges bound to §1's stated contribution; core-task list linked. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean. |
| 4 | 2026-08-28 | update | Owner decision: re-formed as `feature` on Gherkin's own unit — the type was grouped per behavior and pre-assigned to one context, a dispatch convenience carried from `main`. A feature is product-level, belongs to its framing or initiative, holds scenarios owned by several contexts; assignment moves to the solutions architect's scenario-assignment process and lives on `@bounded-context:` tags; `context` leaves the frontmatter; a Feature line and narrative are required. File renamed from `acceptance-scenarios.md`. |
| 4 | 2026-08-28 | review | Screened with the chain: findings — the instance form unstated and the hash not Gherkin-legal; pre-assignment ownership undefined; the edge list required by nothing; status transitions incomplete; `date` undefined; consumers unlinked. |
| 5 | 2026-08-28 | update | Repairs: markdown instance with one fenced Gherkin block; `@feature:` and `@hash:` tags; ownership from the decomposition, confirmed or corrected at assignment; an edge table; every transition with its writer; `date` dropped; consumers linked; interaction types always present. |
| 5 | 2026-08-28 | review | Re-screened: findings — the "no bounded-context tag at the check" clause failed re-verified and resubmitted features; the correction path had no deciding step or status; the Edges reference form unstated; two insider references. |
| 6 | 2026-08-28 | update | Repairs: the clause removed, the writer rule kept and enforced by the assignment process, which returns a feature whose tag differs from its Contributors' shop; Edges rows reference the Scenario name; the block's head stated as the source; references located. |
| 6 | 2026-08-28 | review | Final screen (round 3): clean — no absence clause survives in any check; the correction path carried by the assignment process; two stumbles polished in place. |
| 7 | 2026-08-28 | update | The initiative typedef now exists: the feature links its initiative, whose first section is the framing. |
