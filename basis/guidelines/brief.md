---
type: quality-guideline
id: brief-guideline
target-type: brief
owner: product-authority
status: draft
version: 2
created: 2026-08-27
updated: 2026-08-27
---

# Guideline: brief

**Voice principle.** Write the brief for the Bounded Context shop that
must start work from it tomorrow with no one to ask: every sentence
names a problem, an outcome, an edge of scope, or a thing the shop
needs — nothing says how.

**Highlights (the layer compiled into generating context):** problem
and outcome in the first paragraph · the reader named · every
exclusion with its reason · neighbours placed in or out · no
technology, structure, or form · every term defined here or in the
framing, every artifact linked, every open question listed.

**Layers:** this guideline adds brief rules on top of the
[base writing style](base-writing-style.md); the base always applies
and is never overridden. When rules conflict, an approved principle
beats the [brief typedef](../artifacts/brief.md), which beats this
guideline. Every rule feeds the
[brief fitness set](../fitness/brief.fitness.md), scored in the
[PO output check](../processes/po-output-check.md).

---

## Rules

**1. Problem and outcome first.**
Before: "This brief covers the reporting area. Background: reports have
grown over the last year…" (the problem in paragraph four).
After: "Operators cannot tell which of last night's runs failed without
opening each one. Outcome: a failed run is visible from the run list
within one glance."
*Test:* read only the first paragraph. *Criterion:* it states a
problem and an outcome (whether they are the framing's is the
process's `framing` criterion). *Decision:* yes/no per
brief.
*Derived check:* judged — brief fitness scenario 5.

**2. What, never how.**
Before: "Add a `--failed` flag to `run list` that queries the status
column."
After: "The shop chooses how the failure becomes visible; the outcome
holds on the command line and the graphical interaction."
*Test:* list every sentence that names a technology, structure, or
interface form. *Criterion:* the list is empty; an interaction type
named is a what, not a form. *Decision:* yes/no per brief.
*Derived check:* judged — brief fitness scenario 2.

**3. Every exclusion carries its reason.**
Before: "Out of scope: notifications."
After: "Out of scope: notifying the operator when a run fails — a
separate framing (alerting) serves that outcome."
*Test:* read each out-of-scope statement. *Criterion:* each names why
it is out — for example, it serves another framing, is deferred by the
PM's priority, or belongs to another context. *Decision:* yes/no per exclusion.
*Derived check:* judged — brief fitness scenario 1.

**4. Place every neighbour.**
Before: silence on the archived-runs view that shares the run list.
After: "Neighbouring: the archived-runs view — in, since it is the same
list filtered; the run detail page — out, its own brief."
*Test:* for each piece of work the framing or the brief itself names
as neighbouring, look for an in/out statement or a deciding rule.
*Criterion:* every neighbour is placed. *Decision:* yes/no per
neighbour.
*Derived check:* judged — brief fitness scenario 3.

**5. The shop can start alone.**
Before: "Use the standard status vocabulary (see the usual place)."
After: "Status values are the vocabulary record's: `running`, `held`,
`done`, `cancelled` (linked). Open question, listed as open: whether a
`held` run counts as failed — the PM answers in the framing."
*Test:* list every term not defined in the brief or the framing, every
referenced artifact without a link, and every question the framing or
the brief raises that is neither answered nor listed as open.
*Criterion:* all three lists are empty. *Decision:* yes/no per brief.
*Derived check:* judged — brief fitness scenario 4.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-27 | update | Authored by owner direction so the brief's definition chain is complete — typedef, guideline, fitness set — before the first instance; each rule maps to one fitness scenario. |
| 1 | 2026-08-27 | review | Screened: findings — rule 3's criterion closed the set of admissible reasons the fitness set leaves open; "initiative" undefined. |
| 2 | 2026-08-27 | update | the reason list made illustrative; the undefined term removed. |
| 2 | 2026-08-27 | review | Re-screened: one finding — rule 1's criterion compared against the framing, which fitness 5 does not; repaired in place to presence only. |
