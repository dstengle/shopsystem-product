---
type: quality-guideline
id: experience-common-guideline
target-type: interaction
interaction-type: all
owner: product-authority
status: draft
version: 2
created: 2026-08-26
updated: 2026-08-26
---

# Guideline: every interaction

**Voice principle.** Design every interaction for the person or agent
who arrives from another part of the product and expects the same
words, the same tasks, an error that helps, and an interface they can
use — whichever way they reached it.

**Highlights (the layer compiled into generating context):** the
vocabulary's word, or a recorded platform mapping · the platform's
idiom for form, departures recorded · every error: what happened, in
the vocabulary, and what next; identifiers alongside · every core task
and every option offered elsewhere · the accessibility target met and
attached before delivery.

**Layers:** this guideline applies the
[experience principles](../experience-principles.md) to every
interaction type; the per-type experience guidelines (command line,
API, graphical, assistant, document) layer their idiom on it and never
override it, as every prose guideline layers on the
[base writing style](base-writing-style.md), which governs every
string an interaction shows. Precedence when rules conflict: an
approved principle beats the
[quality-guideline typedef](../artifacts/quality-guideline.md), which
beats this guideline, which beats a per-type guideline; the platform
guideline the corpus names for a type governs that type's form, and
the platform's word governs a name where `consistent-not-uniform`
bullet 3 says so. Every rule feeds the
[interaction fitness set](../fitness/interaction.fitness.md), judged by
the product designer role. The rules here and in the per-type
guidelines judge against corpus records the product designer role has
not yet authored — the vocabulary and its platform mappings, the
variations record, the core-task list, the interaction patterns, the
design tokens, the hard-to-reverse classification, the persona and
voice; none is yet filed as a work item. Until a record exists, a
rule that needs it returns "undecidable: record absent" — a finding
against the corpus, never a pass — as the fitness set states.

---

## Rules

**1. The vocabulary's word, or a recorded platform mapping.**
Before: the web interface says "Remove", the command is `delete`, the
assistant says "drop".
After: the vocabulary names the action once; each interaction type uses
that name unless the platform guideline the corpus names for it uses
another, and the mapping is recorded in the vocabulary.
*Test:* list every noun and verb the interaction shows or accepts
against the vocabulary and its recorded mappings. *Criterion:* every
term is the vocabulary's or a recorded mapping. *Decision:* yes/no per
interaction.
*Derived check:* judged — interaction fitness scenario 1;
`consistent-not-uniform` bullets 1 and 3.

**2. The platform's idiom for form; departures recorded.**
Before: a command line whose subcommands mimic the web navigation; a
native app whose dialogs follow the web page instead of the operating
system.
After: form follows the platform guideline the corpus names for the
type; the product designer role records a departure in the corpus
with its reason.
*Test:* compare the interaction's form with the named platform
guideline. *Criterion:* every departure is a recorded variation.
*Decision:* yes/no per interaction.
*Derived check:* judged — interaction fitness scenario 2;
`consistent-not-uniform` bullets 2 and 4.

**3. Every error: what happened, in the vocabulary, and what next.**
Before: `Error: ENOENT`; a red banner "Invalid input"; "Sorry, I didn't
get that."
After: the thing named in the vocabulary, the cause, and at least one
next step; an internal identifier alongside — in a log, a verbose
mode, or a field beside the message — never in place.
*Test:* trigger each error path. *Criterion:* the message names what
happened in the vocabulary and gives a next step; identifiers stand
alongside only. *Decision:* yes/no per error.
*Derived check:* judged — interaction fitness scenario 3;
`errors-guide-recovery` bullets 1 and 2. Per-type guidelines say where
the message goes (at the field; in the response body; as a repair
turn — the assistant guideline's rule 5).

**4. Every core task, and every option offered elsewhere.**
Before: an export only the command line offers; a chat assistant with
three choices of which the screen shows one.
After: every task on the corpus's core-task list completes in the
interaction, and every option another interaction type offers for the
task is present.
*Test:* walk the core-task list and the options other types offer.
*Criterion:* every task on the list completes; every option is
present. A task the type cannot carry is removed from the list for
that type by the product designer role, with the reason recorded — the
principle's own implication — never waived here.
*Decision:* yes/no per interaction.
*Derived check:* judged — interaction fitness scenario 4;
`core-task-parity` bullets 1 and 2.

**5. The accessibility target, met and attached, before delivery.**
Before: an interaction delivered with accessibility "to follow".
After: the delivery carries the accessibility result at the target the
corpus names for the type — WCAG 2.2 AA for web, graphical, and
document types; the WCAG2ICT application with its applicability record
for command line, terminal, voice, and assistant types.
*Test:* read the delivery's attached accessibility result. *Criterion:*
it exists, meets the target, and carries the applicability record for
a non-web type; the BC-shop that delivered the interaction attached it.
*Decision:* yes/no per delivery.
*Derived check:* judged — interaction fitness scenario 5;
`accessible-by-standard` bullets 1–3.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored after the first screen of the five per-type experience guidelines found the vocabulary, error, accessibility, and core-task rules written five times with drifting criteria: the common rules now have one home, the per-type guidelines layer their idiom on it, and every derived check names the interaction fitness set. |
| 1 | 2026-08-26 | review | Screened: rule 4's escape let a guideline waive a principle's MUST; the corpus records the rules depend on were unstated; a passive without actor. |
| 2 | 2026-08-26 | update | rule 4 defers to the principle's implication (the role edits the list); the dependent corpus records listed once with the absent-record verdict; actor named. |
| 2 | 2026-08-26 | review | Final screen (round 3): clean — every rule decidable with a named scenario and derivation; two line edits and three optional stumbles polished in place. |
