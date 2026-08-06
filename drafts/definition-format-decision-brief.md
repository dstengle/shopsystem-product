# Definition formats — decision brief

**Sitting material, 2026-08-06.** Everything needed to decide is on these two
pages. Full verified research:
[`definition-format-research.md`](definition-format-research.md) (reference
annex, optional). Presented per the `stakeholder-presentation` skill.

## The answer first

We are re-founding the quality layer on the rule that construction definitions
precede checks, and you asked — before any seed-layer drafting — whether the
world already has the formats we need, and whether your Gherkin fitness-test
idea holds up. The research is done and source-verified. **The answer: adopt
or adapt established forms for every element — no container format needs
inventing** — and **your Gherkin proposal is sound with three guardrails**.
Eight choices need your ratification; each carries my recommendation and a
default, so you can accept or override rather than open-solve.

## The seven formats (recommended)

| Element | Recommended form | Source | Bespoke residue |
|---|---|---|---|
| Process definitions | Name + purpose + 3–8 observable outcomes; each activity an entry/task/validation/exit cell; loops terminate on reached states, not step counts | ISO 24774, ETVX, Essence | none |
| Role definitions | Our existing subagent file: frontmatter = capability contract, body = 4–8 accountability bullets; RACI only as a derived consulted/informed overlay compiled into role files — never a standalone chart | Claude Code, Scrum, RACI | none |
| Artifact schemas | Generic type + per-kind required content (the shape `write-*` already has), plus one DoD-style quality commitment per kind and a worked sample in frontmatter | ISO 15289, Scrum, Prompty | field content only |
| Principles | Name / Statement / Rationale / Implications, with normative-keyword discipline | TOGAF, BCP 14 | fitness rubric assembled from published criteria |
| Quality guidelines | Every rule = test + criterion + yes/no decision; single-point rubrics; 5–9-item checklists; style guide + prose linter | Deming, rubric practice, Gawande, Vale | none |
| Fitness tests | 3–10 Gherkin scenarios per output kind, LLM-judged | your proposal, over the established judge pattern | the Gherkin surface |
| Context/skill governance | One activity per skill; 200-line role primers; gated template promotion; ISO 9001 document control as the audit rubric | Anthropic, ISO 9001 §7.5 | none |

## Gherkin fitness tests: adopt, with guardrails

The pattern underneath (scenario + plain-language criteria + LLM judge) is
established shipping practice; only the Gherkin syntax is ours, justified by
reusing the shop's proven contract vocabulary. Three guardrails are
non-negotiable — without them it degrades into vibes: every `Then` names a
falsifiable observable property; judged scenarios live outside `features/`
and are marked non-executable; each `Then` compiles 1:1 into an established
judge format. Judges are pinned, and you spot-grade a sample on a standing
loop (ask 6).

## Your eight decisions

**Format choices**
1. **Normative keywords** — BCP 14 (MUST/SHOULD in caps) or ISO
   (shall/should)? *Recommend BCP 14*: directly lintable, native to the
   agent-tooling world. Default: BCP 14.
2. **Decision records** — keep our Nygard ADR form or switch to MADR?
   *Recommend keep Nygard, add MADR's "Confirmation" section* (how compliance
   is verified) *and a one-line summary field*. Default: as recommended.

**Strictness**
3. **Verdicts per artifact kind** — binary pass/fail or graded ladders
   (draft/ship/exemplary)? *Recommend binary to start*; add ladders only
   where a kind demonstrably needs stages. Default: binary.
4. **Traceability ceremony** — explicit outcome→check tables per process, or
   by-convention links? *Recommend links*; tables only for the seed-layer
   processes themselves. Default: links.

**Operations**
5. **Judge runner** — adopt promptfoo (established) or build a minimal
   in-house harness? *Recommend promptfoo first*: zero bespoke-runner risk;
   revisit if the coupling hurts. Default: promptfoo.
6. **Calibration cadence** — you grade a sample of judge verdicts: batched at
   sittings, or continuously? *Recommend batched at sittings, recorded in the
   session record.* This is a call about your own time — no default.

**Scope**
7. **State vocabulary** (the named states our long-running concerns move
   through) — decide now, or per-process as each definition is drafted?
   *Recommend per-process, deferred.* Default: defer.
8. **Principle set** — target size ~10; one set, or split
   canonical-vs-shop-local? *Recommend ~10, single set now*; split later only
   if template promotion requires it. Default: single set.

*(These regroup the annex's §4 open questions by decision type.)*

## On ratification

I draft the seed layer — the principles update and the definition-format
meta-definition — in the forms you ratify, as the next sitting material.
