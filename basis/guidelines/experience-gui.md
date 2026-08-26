---
type: quality-guideline
id: experience-gui-guideline
target-type: interaction
interaction-type: gui
owner: product-authority
status: draft
version: 3
created: 2026-08-26
updated: 2026-08-26
---

# Guideline: graphical and web interactions

**Voice principle.** Design the screen for the person who arrives from
another part of the product and expects to recognise it, and for the
person using it without a mouse, without colour, or through a screen
reader.

**Highlights (the layer compiled into generating context):** the
corpus's interaction patterns in the corpus's places · visual values
from the corpus's design tokens · errors at the field,
with a summary that links · the platform's interface guidelines for
shape and idiom.

**Layers:** this guideline covers the graphical and web interaction
type (`gui`) and layers its idiom on the common experience guideline.
Its platform guidelines, named by the corpus: the web platform's own
conventions for web, the operating system's human interface guidelines
for a native application; WCAG 2.2 AA is the accessibility target the
common guideline's rule 5 applies; Nielsen Norman Group's usability
heuristics for review. Where they differ, the platform's guideline
governs form and WCAG governs accessibility. Precedence when rules conflict: an approved principle beats the
[quality-guideline typedef](../artifacts/quality-guideline.md), which
beats the [common experience guideline](experience-common.md), which
beats this one; the base writing style is never overridden. Every rule
feeds scenario 6 of the
[interaction fitness set](../fitness/interaction.fitness.md), judged by
the product designer role, and names the principle bullet or the
corpus-named platform guideline (through `consistent-not-uniform`
bullet 2) it derives from.

---

## Rules

**1. Recognisable from the rest of the product.**
Before: a settings page whose primary action sits bottom-left while
every other page puts it top-right.
After: the placement the corpus's interaction pattern records, or a
recorded variation.
*Test:* compare the screen's pattern placements with the corpus's
interaction patterns. *Criterion:* every pattern is the corpus's or a
recorded variation (labels are the common guideline's rule 1).
*Decision:* yes/no per screen.
*Derived check:* judged — interaction fitness scenario 6;
`consistent-not-uniform` bullets 2 and 4.

**2. Visual values come from the design tokens.**
Before: `color: #1a73e8; padding: 13px` written in a component.
After: `color: var(--action-primary); padding: var(--space-3)` from the
corpus's design tokens.
*Test:* scan the interaction's styles for literal colour, spacing, and
type values. *Criterion:* every visual decision references a token the
corpus defines; a needed value with no token is a token request, not a
literal.
*Decision:* yes/no per component.
*Derived check:* judged — interaction fitness scenario 6; the working
principle `single-source-of-truth` applied to visual decisions
(tokens as the one home; Atlassian's design system names them "the
single source of truth"). A token lint is not yet filed as a work item.

**3. Errors at the field, with a summary that links.**
Before: a red banner "Invalid input" at the top of a long form.
After: the failing field outlined and labeled with what is wrong and
what would be right, focus moved to it; a form-level summary linking
to each failing field.
*Test:* submit each form with each invalid input. *Criterion:* the
error appears at the field and focus moves to it; a summary links to
every failing field (the message's content is the common guideline's
rule 3). *Decision:* yes/no per form.
*Derived check:* judged — interaction fitness scenario 6; WCAG 2.2
success criteria 3.3.1 and 3.3.3 via `accessible-by-standard` bullet 1;
the message content, interaction fitness scenario 3.

**4. Keyboard and screen reader, walked by the shop.**
Before: a modal the keyboard cannot leave; a control announced as
"button" with no name.
After: focus trapped and released; every control reachable and named
for assistive technology; the BC-shop's manual keyboard and
screen-reader walk attached with the automated result.
*Test:* the BC-shop walks the screen by keyboard and screen reader and
attaches the result with the automated check. *Criterion:* both
results attached; no AA failure. *Decision:* yes/no per screen.
*Derived check:* judged — interaction fitness scenario 6;
`accessible-by-standard` bullets 1 and 3 (the attachment itself is
the common guideline's rule 5). An automated WCAG check tool is not
yet filed as a work item.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction as the second layer of the experience guidance corpus, applying the approved experience principles to graphical and web interactions. |
| 1 | 2026-08-26 | review | Screened with the other four: findings — the token rule had no principle and no token set; rule 2 contradicted the principle's platform-word bullet; "form" ambiguous in Highlights; a passive without actor. |
| 2 | 2026-08-26 | update | Repairs: layered on the common guideline; the token rule derives from single-source-of-truth and is inactive until the token set exists; labels left to the common rule so the platform-word exception holds; the shop named as the actor of the accessibility walk; every derived check names the interaction fitness set. |
| 2 | 2026-08-26 | review | Re-screened: 'inactive until' wrote a third state into a yes/no rule while other record-dependent rules were unmarked; work items unlocated. |
| 3 | 2026-08-26 | update | the state removed — absent records return the fitness set's undecidable verdict, stated once in the common guideline; work items marked not yet filed. |
| 3 | 2026-08-26 | review | Final screen (round 3): clean — every rule decidable with a named scenario and derivation; two line edits and three optional stumbles polished in place. |
