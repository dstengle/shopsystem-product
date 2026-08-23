---
type: quality-guideline
id: role-definition-guideline
target-type: role-definition
owner: product-authority
status: draft
version: 1
created: 2026-08-23
updated: 2026-08-23
---

# Guideline: role definition

**Voice principle.** Write for the runtime that must instantiate the
seat tomorrow and the reviewer who must catch it acting outside its
domain: every line either contracts a capability, names an
accountability, or claims the seat's one decision — nothing narrates.

**Highlights (the layer compiled into generating context):** who and
what for, never when · the capability contract enforces the stance
mechanically · exactly one exclusive domain, phrased as a decision ·
accountabilities are answerable after a run · no actor-kind commitments
unless the seat is an owner's human seat.

**Layers:** this guideline adds role-definition rules on top of the
[base writing style](base-writing-style.md); the base always applies
and is never overridden. When rules conflict, an approved principle
beats the [role-definition typedef](../artifacts/role-definition.md),
which beats this guideline.

---

## Rules

**1. Say who and what for — never when.**
Before: "After the author finishes the draft, the reviewer reads it
and returns findings."
After: "Accountable for: reporting stumbles in reading order, with
quotes."
*Test:* scan every sentence for ordering or timing language about the
role's own actions. *Criterion:* none present — sequencing lives in the
process definitions that name the role in their steps. *Decision:*
yes/no per sentence.
*Derived check:* judged — scenario 2 of
[role-definition.fitness.md](../fitness/role-definition.fitness.md).

**2. Enforce the stance in the capability contract.**
Before: "This reviewer only reads; it never edits files." (tools:
Read, Edit, Write)
After: "tools: Read" with "maxTurns: 8".
*Test:* compare each stance claim in the prose to the frontmatter's
functional keys. *Criterion:* every claim that can be enforced
mechanically is — read-only seats get read-only tools, drift-prone
seats get a turn cap; prose never promises what the contract permits
violating. *Decision:* yes/no per claim.
*Derived check:* judged — fitness scenario 5.

**3. Claim exactly one exclusive domain, phrased as a decision.**
Before: "The reviewer participates in quality assurance and shares
ownership of the verdict."
After: "**Domain (exclusive):** the round's verdict. The author
revises; the reviewer alone decides what this round found."
*Test:* count the exclusive-domain claims and parse each. *Criterion:*
exactly one, and it names a decision only this seat may make — the
one-responsible-seat rule made concrete. *Decision:* yes/no per role.
*Derived check:* judged — fitness scenario 3.

**4. Make accountabilities answerable.**
Before: "Cares about quality and communicates proactively."
After: "A per-ask decidability verdict: confident / wobbly / cannot
decide, with what is missing."
*Test:* read each accountability bullet after imagining a finished
run. *Criterion:* a reviewer can say whether the seat delivered it —
each bullet names an output or a judgment, not a character trait; the
section holds 4–6 bullets. *Decision:* yes/no per bullet.
*Derived check:* judged — fitness scenario 4.

**5. Write the seat for any capable actor.**
Before: "The human reviewer applies professional intuition."
After: "You simulate the product authority reading cold: technically
expert, ~5 minutes of attention."
*Test:* scan for commitments to an actor kind. *Criterion:* none,
unless the seat is an owner's seat a person must hold — then the human
requirement is stated once, as the seat's authority, not as working
instructions. *Decision:* yes/no per role.
*Derived check:* judged — fitness scenario 1's instantiability
assertion.

## Sources

Style-guide anatomy per the quality-guideline typedef; Deming's
operational definitions (test, criterion, decision per rule); the
capability-contract practice and one-Accountable rule named in the
[role-definition typedef](../artifacts/role-definition.md)'s Sources;
the before examples are generic counter-examples, never drawn from
this product's history.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-23 | update | Authored as the role-definition meta-chain's guideline, with the existing basis roles as exemplars. |
