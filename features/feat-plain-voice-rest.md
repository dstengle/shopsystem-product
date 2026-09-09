---
type: feature
id: feat-plain-voice-rest
name: Plain voice: the rest
status: delivered
version: 4
initiative: ../initiatives/init-plain-voice.md
owner: lead-po
created: 2026-09-08
updated: 2026-09-08
---

# Feature: Plain voice: the rest

## Feature

Feature: Plain voice: the rest
  Every reader and writer in the shop, the authority first, can read a
  produced feature and a guidance record under the rule's word
  targets, where today a produced feature runs 3,588 words against
  1,000 and a guidance record 1,305 against 600 — driven by a
  feature's contributor passages, the implementation-guidance
  guideline and its records, and the feature guideline and fitness
  set kept by hand beside the typedef.

## Contributors

Decomposition: not yet done for this initiative; every scenario sits
in the lead shop's own definitions and produced texts, so every
scenario is owned by shopsystem-product (the lead shop):

- *a feature's contributor passages are short* — shopsystem-product (the lead shop)
- *a rewritten feature meets its word target* — shopsystem-product (the lead shop)
- *the feature guideline is produced, not hand-kept* — shopsystem-product (the lead shop)
- *the feature guideline stays current with the typedef* — shopsystem-product (the lead shop)
- *the implementation-guidance guideline is rewritten to the rule* — shopsystem-product (the lead shop)
- *an existing guidance record is rewritten to the rule* — shopsystem-product (the lead shop)
- *no usability or accessibility criteria are due* — Interaction types names none: no person or agent acts through this capability, so `core-task-parity` and `accessible-by-standard` do not apply
- *no architect constraint is due* — the initiative's Decomposition section reads "Not yet."; it names no non-functional constraint on any scenario

## Interaction types

None — no person or agent acts through it; the capability is the
shop's own definitions and produced texts, per the initiative's For
whom section.

## Scenarios

```gherkin
Feature: Plain voice: the rest
  Every reader and writer in the shop, the authority first, can read a
  produced feature and a guidance record under the rule's word
  targets, where today a produced feature runs 3,588 words against
  1,000 and a guidance record 1,305 against 600 — driven by a
  feature's contributor passages, the implementation-guidance
  guideline and its records, and the feature guideline and fitness
  set kept by hand beside the typedef.

  @bounded-context:shopsystem-product @feature:feat-plain-voice-rest @hash:7c2f4e9b6a13
  Scenario: a feature's contributor passages are short
    Given a feature's Contributors section rewritten to the rule
    When each passage is read
    Then it states an owning shop, a criterion, or a constraint in one short line with no reasoning restated

  @bounded-context:shopsystem-product @feature:feat-plain-voice-rest @hash:3d8b1c5f9e24
  Scenario: a rewritten feature meets its word target
    Given a feature rewritten under the revised guideline
    When its word count is measured
    Then the count meets the rule's target for a feature

  @bounded-context:shopsystem-product @feature:feat-plain-voice-rest @hash:9a4e7c1b2f56
  Scenario: the feature guideline is produced, not hand-kept
    Given the feature typedef carrying Writing rules and Fitness scenarios sections
    When the typedef is rendered
    Then the feature guideline and fitness set are generated texts, each marked generated with a source digest

  @bounded-context:shopsystem-product @feature:feat-plain-voice-rest @hash:5f2b8d4c9a17
  Scenario: the feature guideline stays current with the typedef
    Given a change to the feature typedef's rules
    When the typedef changes
    Then the guideline and fitness set are rendered again from it, with no hand edit left standing

  @bounded-context:shopsystem-product @feature:feat-plain-voice-rest @hash:2c9f3a7e1b48
  Scenario: the implementation-guidance guideline is rewritten to the rule
    Given the implementation-guidance typedef's Writing rules section rewritten to the rule
    When a record is written from the produced guideline
    Then its word count meets the rule's target for a guidance record

  @bounded-context:shopsystem-product @feature:feat-plain-voice-rest @hash:8b1d5c3f9e26
  Scenario: an existing guidance record is rewritten to the rule
    Given a guidance record written before the rule
    When it is rewritten to the revised guideline
    Then its word count meets the rule's target for a guidance record
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| A feature's contributor passages exceed the rule | the framing | Scenario: a feature's contributor passages are short |
| A produced feature at 3,588 words against the 1,000 target | the framing | Scenario: a rewritten feature meets its word target |
| The feature guideline and fitness set kept by hand beside the typedef | the framing | Scenario: the feature guideline is produced, not hand-kept |
| The feature guideline drifting from the typedef after a change | the single-source-of-truth principle | Scenario: the feature guideline stays current with the typedef |
| The implementation-guidance guideline over the guidance-record target | the framing | Scenario: the implementation-guidance guideline is rewritten to the rule |
| A guidance record at 1,305 words against the 600 target | the framing | Scenario: an existing guidance record is rewritten to the rule |
| A rule that removes a recorded decision | the appetite's first no-go | Out of scope: barred by the no-go |
| A rewrite that changes what a definition requires | the appetite's second no-go | Out of scope: barred by the no-go |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Authored by the PO role from the initiative's Framing (v4) and For whom sections: what the first pass left over the rule's targets — a feature's contributor passages, the feature guideline and fitness set kept by hand beside the typedef, and the implementation-guidance guideline and its records. Scenario hashes are provisional pending a hash-check tool run; no lint yet verifies a hash against its scenario text (a gap the typedef itself notes). |
| 2 | 2026-09-08 | update | Made by the solutions architect role, reading the initiative's Decomposition section (v5): it reads "Not yet" and names no non-functional constraint on any scenario, so no constraint line was added and no Edges row followed. Recorded in Contributors as "decomposition names none for this feature," per the writing task's own fallback instruction. Self-check against feature guideline rule 7: the added passage is one short line naming the absence and its source, with no reasoning restated in the body. |
| 2 | 2026-09-08 | review | Screened against feature.fitness.md v9 (PO output check): scenario 1 — all six scenarios are one observable behavior, no implementation step; scenario 2 — each of the six carries a named owning shop in Contributors, matching one for one; interaction types named "none" so no design criteria are due, decomposition names none so no constraint is due, both stated with source; scenario 3 — every scenario carries `@feature:` and `@hash:`; scenario 4 — all eight Edges rows covered, six by named scenario, two out of scope under the appetite's no-gos; scenario 5 — Interaction types states none with the framing's reason; scenario 6 — the Feature line names who (every reader and writer, the authority first), what (read a feature or guidance record under the rule's targets), and the framing's own outcome; scenario 7 — every Contributors passage is an owning shop or a stated absence, no reasoning restated. Gap accepted, not fixed: the six scenario hashes stand provisional since v1, unverified by a hash-check lint — Scenario 3 excludes hash-matching from this judge's scope, so left as is. Status: draft → checked. |
| 3 | 2026-09-08 | state | `checked` → `assigned`: the scenario-assignment process record step, by the lead-solutions-architect role. Assignment — one context, shopsystem-product (the lead shop): pre-state read — decomposition, init-plain-voice v5 reads "Not yet", no Bounded Context named, and the feature's Contributors (v2) already names shopsystem-product as owner for all six scenarios; contracts, none exist on this branch; feature repository, all twelve current features swept for conflict, no scenario elsewhere specifies the feature guideline/fitness set must stay hand-kept or that a guidance record may exceed 600 words, no conflict found. Scenarios assigned to shopsystem-product: @hash:7c2f4e9b6a13, @hash:3d8b1c5f9e24, @hash:9a4e7c1b2f56, @hash:5f2b8d4c9a17, @hash:2c9f3a7e1b48, @hash:8b1d5c3f9e26 — all six, no hash changed. Implementation guidance written: guidance/feat-plain-voice-rest-shopsystem-product.md (v1, status written, not sent); evaluated against the implementation-guidance fitness set (v1) — scenario 1 pass: each of the four What-changes items names a typedef, a guideline, a fitness set, a tool, or a guidance-record path by name and version, none a context's internals (none exists, the context is the lead shop itself); scenario 2 pass: scenarios cited by hash and definitions by name and version throughout, no scenario text or clause reproduced; scenario 3 pass: each item names the file to change, the compiler invocation, and the order — typedef, then compiler, then instances — so the four items are actionable without a further answer; scenario 4 pass: each of the six What-not-to-do entries carries its reason in a no-go, the single-source-of-truth principle, the typedef-rendering process's C3, or the record's own binding rule; scenario 5 pass: frontmatter and opening paragraph name the initiative, feature, context, and all six hashes, and every statement is about those six scenarios, none binding a later assignment or another context. Sent: none — no shop-msg send invoked at dispatch, since the one context, shopsystem-product, is registered as role "lead" not "bc" (the lead shop itself, not a Bounded Context to message) and the branch is frozen against dispatches; the same recorded gap as lead-ki66p, disclosed the same way in feat-run-measurement, feat-role-decisions, feat-process-runner, feat-tool-skills, and feat-tool-skills-rest. |
| 4 | 2026-09-09 | update | Delivered and verified by the lead-pm: the feature typedef produces its guideline and fitness set; the implementation-guidance guideline rewritten; five guidance records at 586–1,031 words from 1,305–3,201; the new records since land at 598. |
