---
type: feature
id: feat-plain-voice
name: Plain voice
status: delivered
version: 2
initiative: ../initiatives/init-plain-voice.md
owner: lead-po
created: 2026-09-08
updated: 2026-09-08
---

# Feature: Plain voice

## Feature

Feature: Plain voice
  Every reader and writer in the shop, the authority first, can load one short rule and read prompts and artifacts that stay under its word target, in place of a 17,000-word feature and a 1,000-word prompt before the task begins.

## Contributors

Every scenario is owned by shopsystem-product (the lead shop):

- *a plain-voice rule exists* — shopsystem-product (the lead shop)
- *every role loads the rule* — shopsystem-product (the lead shop)
- *a rendered role prompt is short* — shopsystem-product (the lead shop)
- *a rewritten feature is short* — shopsystem-product (the lead shop)
- *a rewritten initiative is short* — shopsystem-product (the lead shop)
- *a history row states one sentence* — shopsystem-product (the lead shop)
- *the rule keeps a recorded decision* — shopsystem-product (the lead shop)
- *the rule is tested before it stands* — shopsystem-product (the lead shop)

## Interaction types

None — no person acts through it.

## Scenarios

```gherkin
Feature: Plain voice
  Every reader and writer in the shop, the authority first, can load one short rule and read prompts and artifacts that stay under its word target, in place of a 17,000-word feature and a 1,000-word prompt before the task begins.

  @feature:feat-plain-voice @hash:819b720f2ef5
  Scenario: a plain-voice rule exists
    Given no plain-voice rule stands yet
    When the rule is authored and approved
    Then one short writing rule stands in the corpus

  @feature:feat-plain-voice @hash:1436a1e7a78a
  Scenario: every role loads the rule
    Given an approved role definition
    When the role is rendered
    Then its rendered prompt loads the plain-voice rule

  @feature:feat-plain-voice @hash:bd3025a24163
  Scenario: a rendered role prompt is short
    Given a role definition rewritten to the rule
    When the role is rendered
    Then the rendered prompt's word count meets the rule's target

  @feature:feat-plain-voice @hash:c4abd7cf8f40
  Scenario: a rewritten feature is short
    Given a feature rewritten to the rule
    When its word count is measured
    Then the count meets the rule's target for a feature

  @feature:feat-plain-voice @hash:ae2f5f70a4cb
  Scenario: a rewritten initiative is short
    Given an initiative rewritten to the rule
    When its word count is measured
    Then the count meets the rule's target for an initiative

  @feature:feat-plain-voice @hash:524bf34226c3
  Scenario: a history row states one sentence
    Given a Document History row written under the rule
    When the row is read
    Then it states its entry in one sentence

  @feature:feat-plain-voice @hash:2aead4f72760
  Scenario: the rule keeps a recorded decision
    Given a definition rewritten to the rule
    When the rewrite is checked against the definition before it
    Then every decision the definition recorded still reads in it

  @feature:feat-plain-voice @hash:8a33ef3dbd47
  Scenario: the rule is tested before it stands
    Given the rule applied to a real run
    When the run completes
    Then its word counts are recorded against the rule's targets before the rule is marked stable
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| Feature at 17,030 words | the framing | Scenario: a rewritten feature is short |
| Role prompt at 1,003 words before the task begins | the framing | Scenario: a rendered role prompt is short |
| Initiative at 4,935 words | the For whom section | Scenario: a rewritten initiative is short |
| A rule that removes a recorded decision | the appetite's first no-go | Out of scope: barred by the no-go |
| A rewrite that changes what a definition requires | the appetite's second no-go | Out of scope: barred by the no-go |
| The rule left untested | the framing | Scenario: the rule is tested before it stands |
| A role that does not load the rule | the For whom section | Scenario: every role loads the rule |
| History rows long and argued | the framing (Problem) | Scenario: a history row states one sentence |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Authored by the PO role from the initiative's Framing and For whom sections. |
| 1 | 2026-09-08 | delivery | Scenarios shown: *a plain-voice rule exists*, *every role loads the rule* (all seven rendered roles carry it via `compile_role.py`), *a rendered role prompt is short* (all seven now render under 400 words), *a rewritten feature is short* (this feature: 692 words, already under 1,000, unchanged), *a rewritten initiative is short* (init-plain-voice: 293 words, already under 400, unchanged), *a history row states one sentence*, *the rule keeps a recorded decision*. Not shown: *the rule is tested before it stands* — no real run has yet been measured against it; the rule stays unmarked stable. Word counts, rendered/rule text before → after: base-writing-style.md rule text 555 → 208 (331 with frontmatter and history); feature-authoring.md draft/add-usability/add-constraints prompts 171/73/61 → 116/55/53 words; cold-reviewer 249 → 212; lead-pm 1,001 → 398; lead-po 1,005 → 396; lead-product-designer 1,071 → 398; lead-solutions-architect 1,006 → 399; researcher 584 → 386; router 1,324 → 399. Lint: PASS 0 violations. |
</content>
| 2 | 2026-09-08 | update | Tested on the run: role prompts 386–399 words (target 400, met); feature-authoring prompts under 120; the re-authored feature 3,588 words against a 1,000 target (not met — the designer's and architect's passages and history rows); the guidance record 1,305 against 600 (not met). The rule stays unmarked stable; the next rewrite targets the contributor passages and the guidance guideline. |
