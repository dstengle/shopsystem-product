---
type: fitness-set
id: interaction-fitness
owner: product-authority
status: draft
version: 2
created: 2026-08-26
updated: 2026-08-26
target-type: interaction
judged: true
executable: false
judged-by: lead-product-designer
---

# Fitness set: interaction

These scenarios are the conformance screen the product designer role
runs on a delivered interaction of any interaction type against the
experience guidance corpus — the [experience principles](../experience-principles.md),
the [common experience guideline](../guidelines/experience-common.md),
and the per-type guideline for the interaction's type. They are judged
by the `lead-product-designer` role, never executed. The judge's model
and prompt version (or the person's name) are recorded with each
verdict. The process that runs this screen at delivery is not yet
defined; until it is, the product designer role runs it on request from
the [PO output check](../processes/po-output-check.md) or a Bounded
Context shop; the process is not yet filed as a work item. Where a
scenario judges against a corpus record that does not yet exist — the
vocabulary, the variations record, the core-task list, the interaction
patterns — the verdict is "undecidable: record absent", recorded as a
finding against the corpus, never a pass.

## Scenarios

Scenario 1: one vocabulary, recorded mappings
  Given every noun and verb the interaction shows or accepts
  When each is compared with the corpus vocabulary
  Then it is the vocabulary's word or a platform mapping the vocabulary
  records

Scenario 2: the platform's idiom
  Given the platform guideline the corpus names for the interaction
  type
  When the interaction's form is compared with it
  Then each departure is a variation the corpus records with a reason

Scenario 3: errors guide recovery
  Given each error the interaction can show
  When it is read
  Then it says what happened in the vocabulary and what to do next,
  and any internal identifier stands alongside, not in place

Scenario 4: core tasks and options hold
  Given the corpus's core-task list and the options other interaction
  types offer for those tasks
  When the interaction is walked
  Then every core task completes and every option offered elsewhere for
  the task is present

Scenario 5: accessible before delivery
  Given the accessibility target the corpus names for the interaction
  type
  When the delivery's attached accessibility result is read
  Then it exists, meets the target, and for a non-web type carries the
  WCAG2ICT applicability record

Scenario 6: the per-type rules hold
  Given the per-type experience guideline for the interaction's type
  When each of its rules' tests is run
  Then each rule's criterion is met

## Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 — vocabulary | "List every term that is neither the vocabulary's nor a recorded platform mapping. Empty list = pass." |
| 2 — platform idiom | "List every departure from the named platform guideline without a recorded variation. Empty list = pass." |
| 3 — errors | "For each error: what happened, in the vocabulary? what next? identifier alongside only? Cite any error failing one." |
| 4 — core tasks and options | "For each core task: does it complete? For each option offered elsewhere: present? Cite any missing." |
| 5 — accessibility | "Is the accessibility result attached, at target, with the WCAG2ICT record for a non-web type? Cite the result or its absence." |
| 6 — per-type rules | "For each rule of the type's guideline: run its test; cite each criterion not met, or the record it needs that is absent." |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored with the experience guidelines so that their derived checks name a check that exists: scenarios 1–5 carry the common guideline's rules, scenario 6 defers to the per-type guideline. The process that runs this screen at delivery is a filed gap owned by the product designer role. |
| 1 | 2026-08-26 | review | Screened: the PO output check unlinked; the process gap 'filed' nowhere; scenario 6 carried a variation escape with no meaning for a per-type rule; no verdict for an absent corpus record. |
| 2 | 2026-08-26 | update | process linked and marked not yet filed; escape removed from scenario 6; the absent-record verdict defined. |
| 2 | 2026-08-26 | review | Final screen (round 3): clean — every rule decidable with a named scenario and derivation; two line edits and three optional stumbles polished in place. |
