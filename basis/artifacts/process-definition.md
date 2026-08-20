---
type: artifact-typedef
id: process-definition-typedef
defines: process-definition
owner: product-authority
status: draft
created: 2026-08-19
updated: 2026-08-20
ancestry: [definition, process-definition]
---

# Artifact type: process-definition

## Identity and ancestry

- **Type:** `process-definition` — the single source of truth for a
  process: what it is for, what a run produces, and every step in a form
  a runtime can construct a workflow from. Skills, flow diagrams, and
  fabro graphs are its renderings.
- **Produced by:** seed drafting or governed evolution. **Consumed by:**
  the compiler (renderings), agents (via the rendered skill), reviewers
  (conformance and loop-exit review), fabro (via annotations).

## Required frontmatter

`type: process-definition`, `id`, `owner`, `status`, `created`,
`updated`; `produces` (artifact types a run creates);
`condition-language: cel`; optional: `carried-by` (the rendered skill's
id), `condition-functions` (declared extensions, name and signature),
`annotations` (process-level rendering metadata, keyed by rendering
target), `external-refs` (types that resolve in other registries, e.g.
the shop-msg catalog).

## Required sections

1. **Purpose** — one short paragraph.
2. **Guiding statement** (optional) — directs judgment across the whole
   process; the compiler copies it into every rendering.
3. **Outcomes** — each names the step or check that witnesses it.
4. **Roles** — seats and their accountability; role files carry identity,
   never sequencing.
5. **Flow (compiled)** — the diagram generated from the steps; never
   edited by hand.
6. **Data** — process-local value names. Simple types (JSON Schema
   primitives) inline; every structured shape is a `$ref` to a defined
   type; no structured shape is ever defined here.
7. **Steps** — the executable part (shape below).
8. **Derived checks** — outcome → check → where, cite-or-delete.

## The steps section

Top-level keys: `start` (first step id), optional `result` (the data
value a run returns — the artifact, not a status record). Each step:

- `id`, `name`; `run-by` — `{role, execution: agent}`,
  `{role, execution: human}` (a seat a person holds, e.g. an authority
  sitting), or `{execution: runtime}`; `fresh-context: true` where a seat
  must not carry memory between runs.
- `inputs` / `outputs` — lists of declared data names; the typed contract
  is the isolation mechanism (a step reads only what it lists).
- Agent and human steps carry `prompt` — **the only prose allowed in a
  step** (for a human step it is the sitting's ask).
- Runtime steps carry `set` (CEL assignments), `run` (command templates
  with `${...}` interpolation from typed inputs; `atomic: true` binds the
  lines into one all-or-nothing act), or `branches`.
- `checks` — CEL expressions over declared data.
- Routing: `next`, or `branches` of `{label, when (CEL), next}` rows plus
  one `else`. **Every loop declares its exits as labeled branch rows** —
  a reached-state success exit, a round or budget cap, or both.
- `annotations` — per-step rendering metadata keyed by target (e.g.
  `fabro: {model, max_attempts}`); the definition itself ignores them.

## Rendering contract

The compiler generates: the in-document flow diagram (typed inputs and
outputs on every node; the result on the end node) and the skill —
front-matter (`generated: true`, `generated-by`, `derived-from`,
`source`, `source-digest`) and body (purpose, guiding statement, result,
diagram, one section per step with the prompt verbatim). Conformance
check: re-run the compiler and diff.

## Commitment (Definition of Done)

A process definition is done when it compiles — every `$ref` resolves,
the diagram and renderings generate, `result` (if declared) names a data
value — and every loop declares its exit. **Consequence on failure:** it
cannot be dispatched, carried by a skill, or cited by a check.

## Sources

ISO/IEC/IEEE 24774 (name/purpose/outcomes header); GitHub Actions (step
records with typed inputs/outputs); CNCF Serverless Workflow
(data-condition transitions); CEL — Common Expression Language
(mechanically translatable conditions); Essence-style state exits plus a
round cap (the dual-exit rule).

## Derived review checklist

- Compiles clean: refs resolve, diagram and renderings regenerate
  byte-stable. *(Commitment)*
- No prose outside `prompt` fields in the steps. *(§The steps section)*
- Every loop has labeled success and/or cap exits. *(§The steps section)*
- Outcomes each name a witness. *(§Required sections 3)*
- `result`, if absent, is justified by outcomes that pin the run's value.
  *(§The steps section)*
