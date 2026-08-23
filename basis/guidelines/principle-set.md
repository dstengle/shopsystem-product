---
type: quality-guideline
id: principle-set-guideline
target-type: principle-set
owner: product-authority
status: approved
approved: 2026-08-23
created: 2026-08-22
updated: 2026-08-22
---

# Guideline: principle set

**Voice principle.** Write for the reviewer who must accept or reject a
piece of work against the rule tomorrow: every sentence binds, evidences,
or prices — nothing decorates.

**Highlights (the layer compiled into generating context):** statement
decidable yes/no on one piece of work · normative keywords in statements
only · rationale cites a held failure, never bare best practice ·
implications name the actor who absorbs the price · what the principle
rejects lives inside the four parts · cite principles by slug, never by
number.

**Layers:** this guideline adds principle-set rules on top of the
[base writing style](base-writing-style.md); the base always applies and
is never overridden. When rules conflict, an approved principle beats the
[principle-set typedef](../artifacts/principle-set.md), which beats this
guideline.

---

## Rules

**1. Make the statement decidable on one piece of work.**
Before: "Contracts matter and should generally be respected across
boundaries."
After: "Anything one context expects of another MUST pass through a
named, versioned contract."
*Test:* hold one concrete piece of work against the statement alone.
*Criterion:* a reviewer can answer yes or no without reading the
rationale or implications. *Decision:* yes/no per statement.
*Derived check:* judged — scenario 2 of
[principle-set.fitness.md](../fitness/principle-set.fitness.md).

**2. Confine normative keywords to statements.**
Before: "Implication: reviewers MUST delete unlinked checks."
After: "Implication: reviewers delete unlinked checks."
*Test:* scan for BCP 14 capitals. *Criterion:* capitals outside
statements appear only in the opening's keyword-definition sentence
(mentions, not uses). *Decision:* yes/no per occurrence.
*Derived check:* mechanical — the grep row of the principle-set typedef's
derived review checklist.

**3. Ground the rationale in a held failure.**
Before: "Industry best practice recommends a single source of truth."
After: "Consuming repos copied schema files instead of referencing the
registry and drifted from the real schemas within days."
*Test:* read each rationale. *Criterion:* it names the failure the rule
prevents and cites evidence we hold — an incident, a count, a dated
observation — or a named external source. *Decision:* yes/no per
rationale.
*Derived check:* judged — fitness scenario 3.

**4. Price implications on a named actor.**
Before: "Care must be taken to keep renderings consistent."
After: "Only the compiler touches renderings; a hand edit to a rendering
is reverted, not merged."
*Test:* parse each implication. *Criterion:* it names the actor who
absorbs the change, follows from a statement clause, and adds no
obligation the statement does not carry. *Decision:* yes/no per
implication.
*Derived check:* judged — fitness scenario 4, and the typedef's
traceability row.

**5. Keep rejections inside the four parts.**
Before: a free-standing "**Anti-pattern ruled out.** Two contexts that
'just know' how to interact." block after the implications.
After: the same failure carried in the rationale, or priced in an
implication — no fifth part.
*Test:* list every element of each principle. *Criterion:* only the four
parts appear, and what the principle rules out is stated inside them.
*Decision:* yes/no per principle.
*Derived check:* judged — fitness scenario 1.

**6. Cite a principle by its slug.**
Before: "Without Principle 2, Principle 4 collapses."
After: "Without `single-source-of-truth`, renderings drift."
*Test:* scan cross-references to principles, inside the set and in
documents citing it. *Criterion:* each reference uses the kebab-case
slug, never a number or a position. *Decision:* yes/no per reference.
*Derived check:* judged — fitness scenario 1's slug-citation assertion;
a mechanical reference lint is possible later and is listed as a
chain-review item, not assumed.

## Sources

Style-guide anatomy (voice principle → highlights → rules with
before/after → precedence) per the quality-guideline typedef; Deming's
operational definitions (each rule's test, criterion, decision); TOGAF's
four-part principle form and BCP 14 keyword discipline, which rules 1, 2,
and 5 project into prose; the before examples are drawn from the autopsy
of the retired spec chapter (numbered principles, free-standing
anti-pattern blocks), rewritten here as counter-examples, never reused
as content.
