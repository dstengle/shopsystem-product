---
type: annex
id: annex-037
brief: brief-037.md
date: 2026-09-06
---

# Annex 037: the init-role-decisions run, in full (optional)

## Artifacts produced or changed, with versions

Under the initiative, made by the lead-solutions-architect role from the scenarios and the guidance record, each history row saying the owner's (the product authority's) approval is pending:

- `basis/types/role-offer.md` — v1, new; approved on the bet under the checked ADR, as the implementation-guidance typedef's same-day precedent.
- `basis/artifacts/role-definition.md` — v4: required section 3, Decisions owned; checklist row added. `basis/fitness/role-definition.fitness.md` — v3: one scenario judging the section; hand-amended.
- `basis/roles/lead-pm.md` v10, `basis/roles/lead-po.md` v14, `basis/roles/lead-solutions-architect.md` v11, `basis/roles/lead-product-designer.md` v3 — each with the section; `.claude/agents/*.md` re-rendered, `compile_role.py --check` ok four times.
- `basis/processes/initiative-check.md` — v8: the attach steps output `feasibility_offer` and `usability_offer` beside the initiative; prompts one sentence; `.claude/skills/initiative-check/SKILL.md` re-rendered.
- `basis/artifacts/initiative.md` — v11: §4 states the offer in the type's shape, verdict rendered there, the full offer in the Document History until the cap's split is ruled. `basis/fitness/initiative.fitness.md` v5: scenario 5 judges the five parts by name. `basis/guidelines/initiative.md` v5.

Around the initiative:

- `initiatives/init-role-decisions.md` — v11, active; v7 the authority's review positions, v8 the bet, v10 active on the feature's pass, v11 the delivery record.
- `decisions/adr-2026-09-05-role-offer.md` — v3, checked; decider the authority, `right: escalation`.
- `decisions/pdr-2026-09-06-bet-role-decisions.md` — v3, checked; the PO role's record of the bet, made from the produced guideline (source-digest `d2e74320dabb`).
- `backlog/order-2026-09-06.md` — v3, checked; init-role-decisions first. `roadmap.md` v6.
- `features/feat-role-decisions.md` — v7: drafted (v1), designer criteria none due (v2), architect constraints C1–C7 (v3), checked (v5), assigned (v6), delivery record (v7). Eight scenarios, all owned by the lead shop.
- `guidance/feat-role-decisions-shopsystem-product.md` — v1, written; the first record of its type.
- `requests/req-2026-09-06-implementation-guidance.md` — done, v5 (work item lead-i9mde closed). `requests/req-2026-09-06-tools-through-skills.md` — done, v7 (lead-xsbuk closed). `requests/req-2026-09-06-plain-status.md` — routed, v1, awaiting the answer. `requests/req-2026-09-05-step-communication.md` — routed, v1, awaiting the answer.
- `basis/principles.md` — v11 (`tools-through-skills`); `.claude/shop/principles.md` re-rendered. `basis/glossary.md` v23 (framework tool, skill, gap).
- `basis/artifacts/implementation-guidance.md` v1 with its produced guideline and fitness set; `basis/processes/scenario-assignment.md` v12; `basis/README.md` v12; the lint's check 12 over `guidance/`.
- `sessions/sess-2026-09-06-a.md` (the review before the bet, the guidance lane), `sessions/sess-2026-09-06-b.md` (the bet to delivery, this brief).

## The Decisions owned sections, quoted

- lead-pm: "the framing (exclusive); value and viability; roadmap priority; the pass, fail, or definition change on the PO role's output; the resolution of a conflict between the framing and another role's domain; and, as parts of decisions the authority takes, the product decisions a bet depends on that fall in this domain."
- lead-po: "backlog order (exclusive); the placement or declining of enabler work; the declining of scope that serves no framed outcome; which scenario a clarify resolves against; the split of a returned crossing-contexts scenario within the framing; and, as parts of decisions the authority takes, the product decisions a bet depends on that fall in this domain."
- lead-solutions-architect: "the stack (exclusive); the platform guardrails; the decomposition and each contract's relationship kind; integration strategy; the product's non-functional requirements; the feasibility verdict on a framed problem or a feature; which context owns each scenario; and, as parts of decisions the authority takes, the architecture decisions a bet depends on."
- lead-product-designer: "the experience guidance corpus and conformance (exclusive); the information architecture and task flows of each interaction type; which interaction type a capability is offered through first; what user research runs and how usability is evaluated; the usability verdict on a candidate — evidence, a hypothesis, 'not yet' with the ask, or none due where no interaction type is named; and, as parts of decisions the authority takes, the experience decisions a bet depends on."

Each ends: "On each, this role offers complete information, unasked, in the role-offer data type's shape, when it attaches to or acts on an initiative."

## The attach prompt, as it now stands (both steps)

> Read the initiative at initiative and add your attachment — your offer, the role-offer type this step outputs, rendered into the initiative as its typedef states — or ask questions.

The type's fields: `role`; `verdict` (value, reasons); `decisions` (entries of decision and record — a decision record's id in `decisions/` or the literal `none`); `risks`; `unknowns` (each with a default); `evidence`. Each list part carries `none` with the reason when and only when its entries are empty.

## Screens this run (judge claude-fable-5-1 throughout)

Confident: a finding the judge is sure of. Wobbly: one the judge could not settle. Under the single-cycle rule every screen ran once and was followed by one revise.

| Artifact | Criteria | Self-check before | Confident | Wobbly | Outcome |
|---|---|---|---|---|---|
| Initiative (2026-09-05) | initiative fitness v4 (screen v5) | no — framed at the discovery | 1 | 5 | revised; two held for the authority at the bet (the precedent; the cap's split) |
| ADR (2026-09-05) | adr fitness (screen v6) | yes | 3 | 3 | revised; checked |
| Backlog order | backlog-order fitness (screen v6) | yes — its record over-claimed, corrected | 4 (all glosses) | 0 | revised; checked |
| Bet record (PDR) | produced product-decision-record fitness, `d2e74320dabb` (screen v6) | yes, five of five, re-run after the revise | 1 | 2 | revised; checked |
| Feature | feature fitness v8 (screen v6) | yes | 1 | 6 | revised; checked; the eighth scenario made per role |
| Principle (lane check) | principle-set fitness (screen v6) | yes | 4 | 3 | repaired; verified exit 0 |

Totals: 6 screens on 6 artifacts, 6 revises; 14 confident findings, 8 of them glosses. Not screened: the assignment (a repository sweep) and the delivery (lint, render checks). Yesterday, like for like: 16 rounds on 6 artifacts, 25 confident.

## The flow's timeline, from commit times (UTC, 2026-09-06)

Agent time per step is not recorded in the repository; these are wall-clock commit times.

| Time | Stage |
|---|---|
| 15:43 | The authority's review positions recorded (initiative v7); req-implementation-guidance routed and accepted |
| 15:46 | The guidance lane's define step done (PO) |
| 15:52 | The guidance lane done: typedef, produced texts, scenario-assignment v12, glossary, lint, README (architect; lead-pm check; exit 0) |
| 15:53 | req-tools-through-skills recorded and routed; session a closed |
| 17:48 | The bet: initiative v8 planned; roadmap v6; the tools-through-skills route accepted |
| 17:50 | Backlog order drafted (PO, self-check five of five); req-plain-status recorded and routed |
| 17:51 | Order checked (v3) |
| 17:52 | Bet record checked (v3) |
| 17:53 | Principle made (principles v10) |
| 17:57 | Principle done through the lane (v11) after one screen and one repair; feature drafted (PO) |
| 17:58 | Feature v2: designer criteria none due |
| 18:05 | Feature v3: architect constraints C1–C7 |
| 18:10 | Feature checked (v5); initiative active (v10) |
| 18:16 | Feature assigned (v6); the guidance record produced (v1) |
| 18:25 | Delivered (initiative v11, feature v7) |
| 18:26 | Session b drafted; lead-1qzt0 filed |

Bet to delivery: 38 minutes wall-clock, with the principle's lane (17:53–17:57) and one intake inside it. Every role in the flow was given its step's own prompt and nothing else; the lead-pm filled scenario hashes (the authoring session had no shell) and ruled wobbly findings at the checks, both recorded.

## The two lanes

- Implementation guidance (req-2026-09-06-implementation-guidance): defined by the PO (ten Given/When/Then statements), made by the architect in one round, checked by the lead-pm, verified by the runtime (exit 0). Session a's timing: define 2 minutes, make 5, check and verify under 1. Effect: the next assignment produces one guidance record per Bounded Context; this feature's assignment produced the first.
- Tools-through-skills (req-2026-09-06-tools-through-skills): the principle's three statements — every framework tool usable through a skill that states its uses; an agent prefers the skill over a bare invocation; a tool with no skill is recorded as a gap. The one screen found the same defect the maker-self-check principle's screen had found: two obligations in one bullet; and three binding terms undefined — the lead-pm widened the lane's paths to the glossary at the check step; repaired in one round.

## The ADR's three candidates (adr-2026-09-05-role-offer §1)

1. The 500-word cap's split between §1–3 and the attachments, or the full offer's home outside the cap — the initiative typedef owner's. At the bet: cap soft with 20% variance; the home not ruled. The baseline attachments: 668 and 629 words.
2. Whether the designer's offer fits the one shape — settled by the designer's own attachment: one role-neutral shape, a part outside the role's domain marked "none" with the reason.
3. The pre-bet route from the initiative check to decision-record authoring on a "none" entry — bounded, not decided; Ask 2.

## The guidance record, in brief

`guidance/feat-role-decisions-shopsystem-product.md` names eight changes in the order the constraints require (typedef, then instances, then renders), two things outside the assignment (the pre-bet route; the PM and PO observations at their own steps), the done condition, and ten things not to do, each with its reason. The implementer's self-check: five of five fitness scenarios pass.

## The requests awaiting the authority

- `req-2026-09-06-plain-status` — route said: the lane; target `basis/guidelines/base-writing-style.md`, one rule. Originator's words: "What is meant by nothing else is independent?" — "How will you know to say that from here after the session ends?"
- `req-2026-09-05-step-communication` — route said: discovery, interview form, after init-typedef-rendering's proof (in since 2026-09-05). Originator's words: "communication between steps and agents … should be broken down into the most effective format for clear communication."

## Notes filed

- lead-1qzt0: the skill-rendering check step's run script word-splits `${approved}` only under bash; under zsh every definition reads "missing … no-skill-id". Target `basis/processes/skill-rendering.md`: state the shell, or quote the loop so it holds under both.
- lead-j30gv: journal messages offline.
- Glossary candidates: "offer" (the information a role gives on the decisions it owns) and "attach" (a role writing into an initiative the section it owns before the bet) — defined in feat-role-decisions's vocabulary paragraph; no glossary entry.

## This brief's cold read

Recorded in the brief's Document History.
