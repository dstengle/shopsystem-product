---
type: quality-guideline
id: product-decision-record-guideline
target-type: product-decision-record
owner: product-authority
status: draft
version: 2
created: 2026-08-27
updated: 2026-08-27
---

# Guideline: product decision record

**Voice principle.** Write the record for the role that, a year from
now, must decide whether to undo this decision: one decision, the
alternatives that were real, what it cost, who held the right, and
what would bring it back for review.

**Highlights (the layer compiled into generating context):** exactly
one decision, as a sentence someone can act on · at least one
alternative the deciding role could have chosen, with the reason
against it · consequences priced: what changes, for whom, at what cost
· the deciding role and its right, or the escalation · reversibility
and its trigger.

**Layers:** this guideline adds product-decision-record rules on top
of the [base writing style](base-writing-style.md); the base always
applies and is never overridden. When rules conflict, an approved
principle beats the
[product-decision-record typedef](../artifacts/product-decision-record.md),
which beats this guideline. Every rule feeds the
[product-decision-record fitness set](../fitness/product-decision-record.fitness.md),
scored in the [PO output check](../processes/po-output-check.md).

---

## Rules

**1. One decision, actionable.**
Before: "We will improve the run list and consider notifications
later, and also revisit the status model."
After: "Failed runs are shown in the run list; notifications are a
separate decision (linked)."
*Test:* count the decisions in the decision sentence. *Criterion:*
exactly one, and a reader can say what to do differently tomorrow
because of it. *Decision:* yes/no per record.
*Derived check:* judged — product-decision-record fitness scenario 1.

**2. A real alternative, with the reason against it.**
Before: "Alternatives: do nothing." (a real alternative, with no
reason against it)
After: "Alternative: notify on failure instead of listing — declined
because the outcome is 'visible at a glance', and a notification is
read once and lost."
*Test:* read each alternative. *Criterion:* at least one is a choice
the deciding role could have made and carries the reason it was not. *Decision:* yes/no per record.
*Derived check:* judged — product-decision-record fitness scenario 2.

**3. Name the decider and the right.**
Before: "It was agreed that…"
After: "Decided by the PM role under its value-and-viability decision
right; the
architect's feasibility verdict (linked) was 'feasible within the
current stack'."
*Test:* read the frontmatter `decided-by` and `right`, and §1 where
`right` is `escalation`. *Criterion:* the role and the decision right
are named, or the escalation that settled it is. *Decision:* yes/no per
record.
*Derived check:* judged — product-decision-record fitness scenario 3.

**4. Price each consequence.**
Before: "This will affect the run list and possibly performance."
After: "The run list gains a status column: the reporting context
changes its list contract (a version); operators see one more column;
cost — one contract version and its consumers' updates."
*Test:* for each consequence, find what changes, for whom, and what it
costs or forecloses. *Criterion:* all three present. *Decision:* yes/no
per consequence.
*Derived check:* judged — product-decision-record fitness scenario 4.

**5. Say how hard it is to undo, and what would bring it back.**
Before: nothing on reversibility.
After: "Reversible: the column can be removed in one contract version.
Review trigger: if failed runs exceed one in five, listing is not
enough and the alerting alternative is reopened."
*Test:* read the reversibility section. *Criterion:* it states the
difficulty and, for a hard-to-reverse decision, the trigger that
reopens it. *Decision:* yes/no per record.
*Derived check:* judged — product-decision-record fitness scenario 5.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-27 | update | Authored by owner direction to complete the type's definition chain; each rule maps to one fitness scenario; the form follows Nygard's ADR (decision, consequences) and MADR (alternatives) as the typedef's Sources state. |
| 1 | 2026-08-27 | review | Screened: findings — rule 2 required a reason on every alternative where the fitness set asks for one; an idiom; an unintroduced right's name. |
| 2 | 2026-08-27 | update | criterion aligned to the fitness set; idiom replaced; the right named as the role defines it. |
