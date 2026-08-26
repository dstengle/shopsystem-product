---
type: artifact-typedef
id: brief-typedef
defines: brief
owner: product-authority
status: draft
version: 3
created: 2026-08-26
updated: 2026-08-26
ancestry: [request, brief]
---

# Artifact type: brief

## Identity and ancestry

- **Type:** `brief` — the PO role's bounded statement of a problem and
  its scope for a Bounded Context shop: what the shop is asked for,
  which framing it serves, what is in and out, and what the shop must
  know to start. A request, not a specification: it names the problem
  and the outcome, never the how.
- **Produced by:** the [PO role](../roles/lead-po.md), from the PM
  role's framing; checked by the
  [PO output check](../processes/po-output-check.md) against the
  [brief fitness set](../fitness/brief.fitness.md). **Consumed by:** the
  receiving Bounded Context shop; the PM role at the check.

## Required frontmatter

`type: brief`, `id`, `status` (draft | checked | returned |
pending-definition), `version`, `date`, `reader` (the
receiving shop), `framing` (link to the framing it serves), `owner`,
`created`, `updated`.

## Required sections

1. **What is requested** — the request ancestor's first section: the
   first paragraph states what problem the shop is asked to solve and
   the outcome the framing states.
2. **From whom** — the request ancestor's second section: the
   receiving shop, as `reader` names it.
3. **Scope** — what is in; what is out, each exclusion with its reason;
   for each neighbouring piece of work the framing or this brief names,
   in or out or the rule that decides.
4. **What the shop needs** — every term defined here or in the framing,
   every referenced artifact linked, and every question the framing or
   this brief raises either answered or listed as open.

## Rules

- The brief names no technology, structure, or interface form the shop
  would otherwise choose; it may name the interaction types the
  behavior must hold on, from the
  [core-task list](../experience/core-tasks.md) — a what, not a form.
- Declined scope carries its reason.

## Commitment (Definition of Done)

A brief is done when it has passed the PO output check against the
brief fitness set and the framing. **Consequence on failure:** it is
returned to the PO role with the criterion named, and no shop receives
it.

## Sources

The [brief fitness set](../fitness/brief.fitness.md), whose scenarios
this typedef inherits section by section; the [request typedef](request.md) as
ancestor; the [decision-brief typedef](decision-brief.md)'s answer-first
opening.

## Derived review checklist

- The first paragraph states problem and outcome; the reader named. *(§Required sections 1–2; fitness 5)*
- No how; interaction types named as what. *(§Rules; fitness 2)*
- Every neighbour the framing or brief names is placed. *(§Required sections 3; fitness 3)*
- Terms, links, and open questions complete. *(§Required sections 4; fitness 4)*
- Declined scope reasoned. *(§Rules; fitness 1)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction from the approved brief fitness set, which stood in for it; the frozen corpus on `main` was the reference for the type's purpose, rewritten here, never pasted. |
| 1 | 2026-08-26 | review | Screened: findings — the request ancestor's sections not carried; fitness 3 narrowed; an interaction-types section ungrounded; the architect named a consumer without a use; checklist cited another document; an extra status no one sets. |
| 2 | 2026-08-26 | update | Repairs: request's sections carried by equivalence; neighbours the brief names included; interaction types grounded; consumer list corrected; checklist cites this typedef's clauses; delivered status dropped. |
| 2 | 2026-08-26 | review | Re-screened: findings — the request ancestor's "From whom" carried by equivalence, not as a heading; an interaction-types section no criterion grounds. |
| 3 | 2026-08-26 | update | "From whom" is a heading; interaction types moved to Rules as permitted, linked to the core-task list; the request typedef linked. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean — every round-2 change and stumble addressed; checklist citations resolve after renumbering. |
