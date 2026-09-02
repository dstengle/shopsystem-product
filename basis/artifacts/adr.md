---
type: artifact-typedef
id: adr-typedef
defines: adr
owner: product-authority
status: approved
approved: 2026-09-02
version: 2
created: 2026-09-02
updated: 2026-09-02
ancestry: [adr]
---

# Artifact type: adr

## Identity and ancestry

- **Type:** `adr` — the record of one architecture decision and its
  reasons: what was decided about the product's shape — its stack,
  platform guardrails, decomposition, contracts, or non-functional
  requirements — by which role under which right, against which
  considered options, with what consequences, and how hard it is to
  reverse. The architecture-side counterpart of the
  [product-decision-record](product-decision-record.md).
- **Produced by:** the
  [solutions architect role](../roles/lead-solutions-architect.md),
  for a decision that role or the authority has taken; authored and
  checked through the [adr-authoring](../processes/adr-authoring.md)
  process against the [adr fitness set](../fitness/adr.fitness.md).
  **Consumed by:** Bounded Context shops, whose choices a checked
  record bounds; every role whose later decision the record bounds;
  the architect role reading the pre-state; the PM role at the check.

## Required frontmatter

`type: adr`, `id`, `title` (one line naming the decision — never a
summary of the record), `status` (draft | checked | returned |
pending-definition | superseded — replaces `checked` when a later
record names this one in `supersedes`), `version`, `date`,
`decided-by` (the role, or `product-authority`), `right` (the decision
right exercised — `stack`, `guardrail`, `decomposition`, `contract`,
or `non-functional-requirement`, as the solutions architect role
defines them — or `escalation`, in which case §1 names the escalation
that settled it), `owner`, `created`, `updated`; optionally
`derives-from` (records this decision builds on) and `supersedes`
(the record this one replaces).

## Required sections

1. **Context** — the forces and the pre-state that made the decision
   necessary, with the evidence they rest on; each option that was
   real appears here with the reason it was not chosen, and where no
   other option was real, the context says so.
2. **Decision** — exactly one decision, as a sentence a reader can act
   on.
3. **Consequences** — each: what changes, for whom, and what it costs
   or forecloses; where the decision sets a bound for Bounded Context
   shops, the bound is stated as one.
4. **Reversibility** — how hard the decision is to reverse and, if
   hard, what would trigger revisiting it.

## Rules

- Instances live in `decisions/` at the repository root — one shared
  home with the product-decision-record type; the filename prefix
  (`adr-`, `pdr-`) and the frontmatter `type` discriminate, never the
  directory.
- The right exercised decides which type records a decision: a right
  the solutions architect role holds records as an adr; a PM or PO
  right records as a product-decision-record. A decision no listed
  right covers is the authority's and records under
  `right: escalation` in the type whose deciding side raised it; a
  decision exercising rights from both sides is more than one
  decision and splits.
- One decision per record. A bundle of decisions is split into linked
  records; sub-numbered decisions inside one record are ruled out.
- The record states the result of the decision's screen against the
  [architecture principle set](../architecture-principles.md):
  conformance, or the escalated exception named — the record never
  absorbs a deviation.
- Whether the named role held the right it exercised is the PM role's
  ruling at the check, not the record's claim; a record whose decider
  is the authority is checked for form only.
- A superseding record names the superseded one in `supersedes`; the
  reverse edge is derived by search, never written into the superseded
  record's frontmatter.

## Commitment (Definition of Done)

A record is done when it has passed the adr-authoring check against
its fitness set. **Consequence on failure:** it is returned with the
criterion named and binds nothing — no guardrail is in force and no
Bounded Context choice is bounded by it.

## Sources

Nygard's architecture decision record (context, decision,
consequences); MADR's considered options, folded into Context by owner
direction rather than held as a required section — the frozen corpus's
keepers carry their options there, and a separate section would force
a retroactive rewrite the fold avoids; decider, right, and
reversibility from the
[product-decision-record typedef](product-decision-record.md)'s shop
additions, so the two decision-record types stay parallel; the frozen
corpus's `derives-from` provenance edge adopted, its `derived-by`
reverse edge rejected — a hand-maintained reverse index is a second
home for one fact (`single-source-of-truth`); the
[adr fitness set](../fitness/adr.fitness.md).

## Derived review checklist

- Title names the decision in one line; the decision sentence carries
  exactly one decision, actionable. *(§Required frontmatter; §Required
  sections 2; §Rules; fitness 1)*
- Context carries the evidence and the real options — at least one
  with the reason against it, or the statement that none was real.
  *(§Required sections 1; fitness 2)*
- Decider and right, or the escalation, named. *(§Required
  frontmatter; fitness 3)*
- Each consequence names what changes, for whom, at what cost; a bound
  on Bounded Context shops stated as one. *(§Required sections 3;
  fitness 4)*
- Reversibility and its trigger stated. *(§Required sections 4;
  fitness 5)*
- The architecture-principles screen's result stated — conformance or
  the named escalated exception. *(§Rules; fitness 6)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-02 | update | Authored through the definition-chain-migration process by owner direction: the chain lands before any keeper is pulled from `main`, and the keeper rewrite is deferred to the demand-pull phase. Form per the owner's ruling — Nygard base with Reversibility required and considered options folded into Context; decider and right mirror the product-decision-record typedef. Autopsy of the frozen corpus's keepers (adr-006 and adr-027 as best, adr-058 and adr-066 as worst) sourced the one-decision rule, the one-line title rule, and the derives-from/derived-by ruling. |
| 1 | 2026-09-02 | review | Authority review of the chain with its exemplar (brief-033): approved as recommended. Asks 3 and 4 ruled — the exercised right decides the ADR/PDR boundary; one shared `decisions/` is the instance home, the owner weighing separate directories as near-cosmetic once type lives in frontmatter, with a per-audience publication boundary named as the trigger to revisit. |
| 2 | 2026-09-02 | update | The rulings applied as rules: the instance home and the boundary rule; this typedef is the boundary rule's one home, the product-decision-record typedef references it. |
| 2 | 2026-09-02 | state | draft → approved by the owner (brief-033 ask 1; the derived-by removal approved with the chain). |
