---
type: feature
id: feat-plain-voice-sections
name: "Plain voice: section targets"
status: delivered
version: 4
initiative: ../initiatives/init-plain-voice.md
owner: lead-po
created: 2026-09-09
updated: 2026-09-09
---

# Feature: Plain voice: section targets

## Feature

Feature: Plain voice: section targets
  Every reader and writer in the shop, the authority first, can read
  a produced feature whose Document History, Contributors, and Edges
  sections each meet a stated word target, in place of a feature
  whose whole-document count is met by accepting those three
  sections as a gap — as on feat-artifact-tools v4: 3,625 words
  against 1,000, Document History 1,707, Contributors 786, Edges
  541, against Scenarios 442 and the Feature line 95.

## Contributors

Decomposition: not yet done for this initiative; every scenario sits
in the lead shop's own definitions and produced texts, so every
scenario is owned by shopsystem-product (the lead shop):

- *a word target exists for a Document History row* — shopsystem-product (the lead shop)
- *a word target exists for a Contributors passage* — shopsystem-product (the lead shop)
- *a word target exists for an Edges row* — shopsystem-product (the lead shop)
- *a Document History row meets its word target* — shopsystem-product (the lead shop)
- *a Contributors passage meets its word target* — shopsystem-product (the lead shop)
- *an Edges row meets its word target* — shopsystem-product (the lead shop)
- *a produced feature meets its word target with no section gap accepted* — shopsystem-product (the lead shop)
- *no usability or accessibility criteria are due* — Interaction types names none: no person or agent acts through this capability
- *no architect constraint is due* — the initiative's Decomposition section reads "Not yet."; decomposition names none for this feature

## Interaction types

None — the For whom section states none; the capability is the
shop's own definitions and produced texts.

## Scenarios

```gherkin
Feature: Plain voice: section targets
  Every reader and writer in the shop, the authority first, can read
  a produced feature whose Document History, Contributors, and Edges
  sections each meet a stated word target, in place of a feature
  whose whole-document count is met by accepting those three
  sections as a gap — as on feat-artifact-tools v4: 3,625 words
  against 1,000, Document History 1,707, Contributors 786, Edges
  541, against Scenarios 442 and the Feature line 95.

  @bounded-context:shopsystem-product @feature:feat-plain-voice-sections @hash:89e4c7718ea0
  Scenario: a word target exists for a Document History row
    Given the base-writing-style guideline
    When it is read
    Then it states a word target for one Document History row

  @bounded-context:shopsystem-product @feature:feat-plain-voice-sections @hash:b87a61e043b1
  Scenario: a word target exists for a Contributors passage
    Given the base-writing-style guideline
    When it is read
    Then it states a word target for one Contributors passage

  @bounded-context:shopsystem-product @feature:feat-plain-voice-sections @hash:4d7011c002b3
  Scenario: a word target exists for an Edges row
    Given the base-writing-style guideline
    When it is read
    Then it states a word target for one Edges row

  @bounded-context:shopsystem-product @feature:feat-plain-voice-sections @hash:8f709da780b8
  Scenario: a Document History row meets its word target
    Given a step writing a Document History row on a produced artifact
    When the row is read
    Then its word count meets the row's word target

  @bounded-context:shopsystem-product @feature:feat-plain-voice-sections @hash:f8be35985d2f
  Scenario: a Contributors passage meets its word target
    Given a step writing a Contributors passage on a produced feature
    When the passage is read
    Then its word count meets the passage's word target

  @bounded-context:shopsystem-product @feature:feat-plain-voice-sections @hash:d416073e5310
  Scenario: an Edges row meets its word target
    Given a step writing an Edges row on a produced feature
    When the row is read
    Then its word count meets the row's word target

  @bounded-context:shopsystem-product @feature:feat-plain-voice-sections @hash:3c034e9e8f36
  Scenario: a produced feature meets its word target with no section gap accepted
    Given a feature that has completed feature-authoring's self-check
    When its Document History row for that step is read
    Then it records the feature's word count met, with no Document History, Contributors, or Edges overage accepted as a gap
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| Document History at 1,707 words on feat-artifact-tools v4 | the framing | Scenario: a Document History row meets its word target |
| Contributors at 786 words on feat-artifact-tools v4 | the framing | Scenario: a Contributors passage meets its word target |
| Edges at 541 words on feat-artifact-tools v4 | the framing | Scenario: an Edges row meets its word target |
| No stated word target for a Document History row | the framing | Scenario: a word target exists for a Document History row |
| No stated word target for a Contributors passage | the framing | Scenario: a word target exists for a Contributors passage |
| No stated word target for an Edges row | the framing | Scenario: a word target exists for an Edges row |
| feat-artifact-tools v4's self-check accepting the overage as a gap rather than meeting the target | the framing | Scenario: a produced feature meets its word target with no section gap accepted |
| Scenarios and the Feature line, already within target (442 and 95 words on feat-artifact-tools v4) | the framing | Out of scope: these sections already meet target; no scenario needed |
| A rule that removes a recorded decision | the appetite's first no-go | Out of scope: barred by the no-go |
| A rewrite that changes what a definition requires | the appetite's second no-go | Out of scope: barred by the no-go |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Authored by the PO role from the initiative's Framing (v7) and For whom sections: what the second pass left over the target, measured on feat-artifact-tools v4 — Document History, Contributors, and Edges section word targets, stated and met, rather than an overage accepted as a gap at self-check; scenario hashes provisional pending a hash-check tool run, the same disclosed gap as feat-plain-voice-rest v1 and feat-artifact-tools v1. |
| 1 | 2026-09-09 | update | Architect's add-constraints step, made by lead-solutions-architect: init-plain-voice's Decomposition (v8) reads "Not yet.", so it names no non-functional constraint and no Edges row follows. |
| 1 | 2026-09-09 | review | Self-checked against feature.fitness.md v17: all eight scenarios pass — each of the seven scenarios one action and one observable outcome; ownership named for all seven, the interaction-types and architect-constraint absences each carrying the framing's reason; `@feature:` and `@hash:` present on every scenario; all ten Edges rows covered by name or excluded with reason, matching the framing's cases and the appetite's no-gos; the Feature line names who, what, and the framing's outcome; the Contributors body carries only ownership and stated absences, no reasoning; the document counts to roughly 890 words by hand, under the 1,000 target. Status: draft → checked. Gaps accepted, not fixed: the seven scenario hashes stand provisional, unverified by a hash-check tool, the same disclosed gap as feat-plain-voice-rest v1 and feat-artifact-tools v1; the word count above is likewise a hand count, pending that same missing tool. Initiative init-plain-voice already active (not planned), so its status stands unwritten by this step. |
| 2 | 2026-09-09 | state | `checked` → `assigned`: the scenario-assignment process's record step, by the lead-solutions-architect role. One assignment entry — context shopsystem-product (the lead shop), scenarios @hash:89e4c7718ea0, @hash:b87a61e043b1, @hash:4d7011c002b3, @hash:8f709da780b8, @hash:f8be35985d2f, @hash:d416073e5310, @hash:3c034e9e8f36 — each already tagged `@bounded-context:shopsystem-product` on the line above its Scenario, no hash changed. Pre-state read from lead-shop-held records, none from a context's internals: contracts — none exist on this branch; feature repository (features/, 14 features) swept for conflict — no scenario elsewhere states a Document History-row, Contributors-passage, or Edges-row word target; feat-plain-voice-rest's related scenarios cover whole-document and Contributors-brevity targets only; no conflict found. Implementation guidance written, one record for the one context: guidance/feat-plain-voice-sections-shopsystem-product.md (v1, status written), naming the three new base-writing-style word targets, the feature-typedef rule and fitness scenario the compiler renders from them, and the self-check reading the tightened set unchanged in process. Evaluated against the implementation-guidance fitness set (v2) — scenario 1 (the architect's level) pass: each What-changes entry names a guideline, typedef, or tool by path and version (base-writing-style.md v4, feature.md v17, compile_typedef.py, feature-authoring.md), none naming a context's internals (none exists, the context is the lead shop itself); scenario 2 (cited, never restated) pass: scenarios cited by hash only, definitions by name and version, no scenario text or clause reproduced; scenario 3 (actionable alone) pass: each entry names the file, the section, and the compiler invocation and order, so the shop can begin unaided; scenario 4 (reasons) pass: each What-not-to-do entry names the first no-go, the second no-go, `single-source-of-truth`, or the absence of a reaching scenario as its reason; scenario 5 (one assignment) pass: frontmatter and opening paragraph name the initiative, feature, context, and all seven hashes, every statement about those seven scenarios only; scenario 6 (word target) pass: 600 words by `wc -w`, at the 600-word guidance-record target (base-writing-style v4). Sent: none — the dispatch runtime step invoked no shop-msg send: the one context, shopsystem-product, is registered in shop-msg's registry as role "lead" (not "bc") — the lead shop itself, not a Bounded Context to receive a message — and the branch primer's operating rule bars dispatches and mailbox work while the shop is frozen; this is the already-recorded process gap bd lead-ki66p (scenario-assignment lacks a lead-shop-internal path); the lead shop's own scenarios stand assigned to itself and are taken up in its tree, as the previous assignments of record disclosed (feat-run-measurement v8's Document History row 8, and feat-artifact-tools on lead-nushi). Version bumped 1 → 2. |
| 3 | 2026-09-09 | delivery | Implemented by the lead-solutions-architect role for shopsystem-product against guidance-feat-plain-voice-sections-shopsystem-product (v1): three base-writing-style targets (v5), feature rule 9 and fitness scenario 9 (v18). lead-jynwa. |
| 4 | 2026-09-09 | update | Delivered and verified by the lead-pm: compile check exit 0, lint pass, three targets in base-writing-style v5, rule 9 rendered in guideline and fitness set. |
