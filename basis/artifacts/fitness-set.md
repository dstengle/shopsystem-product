---
type: artifact-typedef
id: fitness-set-typedef
defines: fitness-set
owner: product-authority
status: approved
approved: 2026-08-22
created: 2026-08-19
updated: 2026-08-19
ancestry: [definition, fitness-set]
---

# Artifact type: fitness-set

## Identity and ancestry

- **Type:** `fitness-set` — a small set of Given/When/Then scenarios that
  a judge scores against an artifact type's instances. Judged, never
  executed: there are no step definitions, and the schema says so where
  tools can read it.
- **Produced by:** the author of the target type's quality definition.
  **Consumed by:** the judging role named in the frontmatter, at the
  review step of the producing process and at any later re-verification.

## Required frontmatter

`type: fitness-set`, `id`, `target-type` (the artifact type judged),
`judged: true`, `executable: false`, `judged-by` (the role), `owner`,
`status`, `created`, `updated`.

## Required sections

1. **Scenarios** — Given/When/Then, each `Then` falsifiable: a competent
   judge shown a failing instance can say "fails" and point at why.
2. **Compile mapping** — a table taking every `Then`, one for one, into a
   judge-rubric assertion, proving the set rests on established
   evaluation practice and not a bespoke engine.

## Rules

- **Hard segregation from executable scenarios:** fitness sets never live
  in `features/`, and `executable: false` is schema-level, so no test
  runner can pick one up by accident.
- Judge verdicts are recorded with the judge's model and prompt version
  pinned; the owner grades a sample on a standing calibration loop.

## Commitment (Definition of Done)

A fitness set is done when every `Then` is falsifiable and mapped to a
rubric assertion. **Consequence on failure:** its verdicts carry no
standing in review.

## Sources

Gherkin syntax (the readable G/W/T frame — syntax only, no runner);
LLM-judge practice (G-Eval–style rubric decomposition, promptfoo's
llm-rubric assertions); EvalGen-style human calibration of judges.

## Derived review checklist

- Frontmatter guardrails present (`judged`, `executable`, `judged-by`).
  *(schema)*
- Not under `features/` — mechanical path check. *(§Rules)*
- Every `Then` appears in the compile-mapping table. *(§Required sections 2)*
