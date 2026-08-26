---
type: quality-guideline
id: experience-document-guideline
target-type: interaction
interaction-type: document
owner: product-authority
status: draft
version: 3
created: 2026-08-26
updated: 2026-08-26
---

# Guideline: generated documents and notifications

**Voice principle.** Write the document or notification the product
sends for the person who will read it away from the product, later,
possibly on a phone or through a screen reader, and who must know from
it alone what happened and what to do.

**Highlights (the layer compiled into generating context):** the first
line states the event · one primary action · the same event reads the
same in every channel · structure a screen reader announces.

**Layers:** this guideline covers generated documents and
notifications (`document`: reports, receipts, exports, email, chat
messages, push) and layers its idiom on the common experience
guideline. Its platform guidelines, named by the corpus: WCAG 2.2 AA
as applied to documents (PDF/UA for PDF), and for notifications the
platform's own notification guidelines (the operating system's for
push; the chat platform's for its messages). Where they differ, the
platform's guideline governs form and WCAG governs accessibility. No
email platform guideline is named; rule 2 applies to email as this
guideline's own rule, the gap recorded here. The document type carries no core
task of its own — the product designer role records it so on the
core-task list — so the common guideline's rule 4 asks only that an
option a document offers matches the interaction it links to. Rule 1
derives from the base writing style rather than a principle bullet;
every other rule names its principle bullet or platform guideline.
Precedence when rules conflict: an approved principle beats the
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

**1. The first line states the event.**
Before: a notification that opens with the product's name and a
greeting and states the event in its fourth line.
After: "Your export is ready — 2,140 records, valid until Friday."
*Test:* read only the first line or subject. *Criterion:* it states the
event or result; nothing before it. *Decision:* yes/no per document.
*Derived check:* judged — interaction fitness scenario 6; the base
writing style's "lead with the point", applied to a document that is
read alone — this rule is that rule's application, not a second home.

**2. One primary action.**
Before: a notification with four links and no indication which to use.
After: the one next action as one link; anything else in a labeled
footer.
*Test:* count actions and links. *Criterion:* one primary action;
secondary links separated and labeled. *Decision:* yes/no per
notification.
*Derived check:* judged — interaction fitness scenario 6; the
platform's notification guideline via `consistent-not-uniform` bullet
2 (Apple's and Android's notification guidance each limit a
notification to one primary action; for email, this guideline's own
tightening).

**3. The same event reads the same in every channel.**
Before: an email that says "job failed" for what the interface calls a
"run" and the chat message calls a "task".
After: the same core sentence for the same event in email, chat, and
the interface's own notice.
*Test:* compare the same event across every channel that carries it.
*Criterion:* the core sentence is the same (the noun is the common
guideline's rule 1). *Decision:* yes/no per event.
*Derived check:* judged — interaction fitness scenario 6;
`consistent-not-uniform` bullet 1.

**4. Structure a screen reader announces.**
Before: a PDF export of a table as an image; an email whose meaning is
in an unlabeled icon.
After: real text with headings and a table a screen reader announces
as a table; the icon's meaning in words.
*Test:* open the document with a screen reader and without images.
*Criterion:* headings, reading order, and tables are announced as
such; no meaning rests on an image or colour alone (the attached
result is the common guideline's rule 5). *Decision:* yes/no per
document type.
*Derived check:* judged — interaction fitness scenario 6;
`accessible-by-standard` bullet 1; PDF/UA via `consistent-not-uniform`
bullet 2. A document accessibility check tool is not yet filed as a work item.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction as the second layer of the experience guidance corpus, applying the approved experience principles to generated documents and notifications. |
| 1 | 2026-08-26 | review | Screened with the other four: findings — Highlights promised a rule the document lacked; rules 1 and 2 had no source; "weight" and "tagged" undefined; the failure-notification rule duplicated the common error rule. |
| 2 | 2026-08-26 | update | Repairs: layered on the common guideline; rule 1 stated as the base style's application; rule 2 sourced to platform notification guidelines; the voice-dimension clause dropped until the corpus's voice exists; "tagged" replaced with what a screen reader announces; the failure rule folded into the common rule 3. |
| 2 | 2026-08-26 | review | Re-screened: Layers overstated the derivation rule for rule 1; email had no named guideline for rule 2; the type's core-task position unstated. |
| 3 | 2026-08-26 | update | Layers amended for all three. |
| 3 | 2026-08-26 | review | Final screen (round 3): clean — every rule decidable with a named scenario and derivation; two line edits and three optional stumbles polished in place. |
