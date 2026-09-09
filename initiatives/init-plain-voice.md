---
type: initiative
id: init-plain-voice
name: Plain voice
status: active
version: 9
owner: lead-pm
created: 2026-09-07
updated: 2026-09-09
request: ../requests/req-2026-09-07-run-efficiency.md
parent: init-run-efficiency
---

# Initiative: Plain voice

## Framing

Originator (product authority, 2026-09-07 and 2026-09-08; req-2026-09-07-run-efficiency and req-2026-09-08-process-simplification, section 1): "The language needs to be drastically simplified and much more terse." "Feature creation prompt needs significant tightening." "Existing definitions to new language. Foundational artifacts are creating bloat." "Language - agree but will need testing and verification."

Problem: artifacts, prompts, and history rows are long and argued; a feature is 17,000 words, a role prompt 1,000 words before the task begins, and the language propagates. Outcome: one short writing rule governs every artifact, prompt, and history entry; the existing definitions and prompts are rewritten to it, the feature prompt first; the rule is tested on real runs before it stands. After the second pass (feat-plain-voice-rest), a guidance record lands at 598 words; a feature does not. The newest feature (feat-artifact-tools v4) runs 3,625 words against 1,000: Document History 1,707, Contributors 786, Edges 541, Scenarios 442, the Feature 95. What exceeds the target is the history row each step writes and the Contributors and Edges passages, not the scenarios.

## For whom

Every reader and writer in the shop, the authority first. Measure: words per rendered prompt and per artifact of each type. Now: role prompt 1,003; feature 17,030; initiative 4,935. Target: set by the rule and tested. Interaction types: none.

## Appetite

One working session for the rule and the feature prompt; then one per definition family rewritten. No-gos: no rule that removes a recorded decision; no rewrite that changes what a definition requires.

## Feasibility and usability

Not yet.

## Decomposition

Not yet.

## Features

feat-plain-voice

[feat-plain-voice-rest](../features/feat-plain-voice-rest.md) — delivered.

[feat-plain-voice-sections](../features/feat-plain-voice-sections.md) — delivered.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Framed by the lead-pm at the discovery-conversation frame step (sess-2026-09-07-b) from the authority's words in req-2026-09-07-run-efficiency, section 1. |
| 2 | 2026-09-08 | update | Reframed from the authority's direction of 2026-09-08: existing definitions rewritten, the feature prompt first, tested before it stands. |
| 3 | 2026-09-08 | update | Delivered in part: the rule and the rewritten roles and prompts; the feature and guidance targets not yet met; the rule stays under test. |
| 4 | 2026-09-08 | update | Framing: what the first pass left over the targets, named for the second feature. |
| 5 | 2026-09-08 | update | Features section: feat-plain-voice-rest added, draft — written by the feature-authoring draft step (the PO role); six scenarios, all owned by the lead shop, over the contributor passages, the hand-kept feature guideline and fitness set, and the implementation-guidance guideline and its records. |
| 6 | 2026-09-09 | update | Second feature delivered; the rule stays under test until a feature lands under 1,000 words. |
| 7 | 2026-09-09 | update | Framing: what the second pass left over the target, measured on feat-artifact-tools v4, named for the third feature; feat-plain-voice-rest delivered. |
| 8 | 2026-09-09 | update | Features section: feat-plain-voice-sections added, draft — written by the feature-authoring draft step (the PO role); seven scenarios, all owned by the lead shop, over Document History, Contributors, and Edges section word targets. |
| 9 | 2026-09-09 | update | Third feature delivered: per-row targets bind history, Contributors, and Edges. This feature: 1,165 words at self-check, 1,611 delivered; no feature under 1,000 yet. |
