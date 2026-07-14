# Brief 019 — `shop-knowledge` CLI exposes artifact-schema validation; the six PDR-033 PM skills consume it before closing

**Status:** draft (2026-07-14)
**Authors:** David Stenglein (product authority), Claude (lead-po)
**Lead bead:** [`lead-5msa9`](#) (P1, FEATURE) — two-BC dispatch split across
shopsystem-knowledge and shopsystem-templates, sub-beads
[`lead-5msa9.1`](#) (knowledge CLI) and [`lead-5msa9.2`](#) (templates
consumption, linked as depending on `.1`).
**Committed-contract input:** this brief transcribes a decisive, fully
specified fix directed by the product authority this session — there is no
intent record or candidate behind it, and none is needed. The gap and the
fix shape are both already established; this brief does not re-shape either,
it turns the directed fix into scenarios. (Contrast with brief-017, which
transcribes a shaped candidate — see brief-018 for the same committed-
contract precedent this brief follows.)

**Anchored to (decisions this builds on — NOT re-decided here):**

- [PDR-032](../pdr/032-knowledge-bc-owns-artifact-type-system.md) — the
  shopsystem-knowledge BC owns the artifact type system: conventions,
  per-type templates, frontmatter JSON Schema, and the coherence gate, over
  exactly eight artifact types (intent-record, candidate, session-record,
  prioritization-record, brief, pdr, adr, current-state).
- [ADR-059](../adr/059-knowledge-bc-single-sources-artifact-formats-from-per-type-typedef-yaml-generator-emits-template-and-schema-fragment-generated-files-read-only-check-drift-gate.md)
  — each type's template and JSON Schema fragment are generated,
  read-only projections of one per-type `typedef/*.yaml`, drift-gated by a
  `--check` mode. This brief does not touch the typedef/generator model at
  all — it exposes the generator's and validator's *existing output* as a
  CLI, nothing about how that output is produced changes.
- [ADR-018](../adr/018-empirical-verification-is-contract-surface.md) D2 —
  a **contract tool** is an installed CLI whose input is contract text and
  whose output is a contract fact (`scenarios hash` is the canonical
  example). `shop-knowledge template`/`schema`/`validate` are new instances
  of exactly this category, not BC-implementation execution.
- `features/shopsystem-knowledge/per_type_typedef_generation.feature`,
  `frontmatter_schema_conformance.feature`, `body_section_conformance.feature`
  — the internal generation and validation behavior this brief exposes
  externally. This brief does not re-pin or alter any of those; it adds a
  new observation surface (a CLI) over the same internal facts.
- **`lead-ptr7a`** (in-flight clarify, handled separately) — the concrete,
  already-realized cost this brief's root cause names: this repo's
  `intent/` and `candidates/` PM artifacts do not conform to
  shopsystem-knowledge's real, live schema, because nothing in the
  authoring path ever consulted it. This brief fixes the structural gap
  that allowed that drift; it does not fix the drifted files themselves
  (see Out of scope) or resolve `lead-ptr7a`'s narrow `Verbatim anchors`
  clarify (handled separately, in flight).

---

## 1. The problem

Two confirmed, empirical gaps compound into one failure mode:

1. **The six PDR-033 PM `lead_skills` that terminate in a schema-governed
   artifact carry no reference to the canonical schema at all.** Verified
   by grepping the full installed `shop_templates` package for any pointer
   language (`template`, `schema`, `typedef`, `canonical`, `knowledge`)
   across every one of the six skills' `SKILL.md` — nothing found in
   `discovery-dialogue` or `shaping` (grep hits are false positives about
   *product-language altitude*, e.g. "no env var names, no schemas, no CLI
   flags" — not schema references), and no hits at all in `option-tradeoff`,
   `prioritization`, `problem-space-mapping`, or `product-narrative`. No
   bundled `resources/` template file exists either. A skill user has no
   way to know an artifact's real shape except by copying a pre-existing
   file in the repo — which is exactly what produced this repo's drifted
   `intent/`/`candidates/` files.
2. **shopsystem-knowledge already has the schema-validation logic, but
   exposes no CLI for anything outside itself to invoke it.** Confirmed by
   direct inspection of `frontmatter_schema_conformance.feature` and
   `body_section_conformance.feature`: the internal check is precise
   enough to name exact missing fields and missing `x-required-sections`
   entries by name, but nothing outside the knowledge context can run it.

Stakeholder's own words: "The point of shopsystem-knowledge was to have
strong artifact schemas and prevent drift but it somehow got specified and
built without serving that purpose."

## 2. The job-to-be-done

*When a PM skill is about to produce or has just produced a schema-governed
artifact, I want the skill to fetch the real canonical shape and check its
own output against it before closing, so that a PM session can no longer
silently drift a document's shape away from what shopsystem-knowledge
actually enforces.*

## 3. The outcome (observable behavior change)

- Any PM session that runs a schema-governed skill (discovery-dialogue,
  shaping, option-tradeoff, prioritization, or product-narrative's
  current-state branch) produces a document that either **passes
  `shop-knowledge validate`** or the skill **surfaces the failure to the
  product authority** — a session no longer closes with a silently
  non-conforming artifact.
- A skill author (human or agent) who wants to know an artifact type's real
  shape can run `shop-knowledge template <type>` and get the actual
  generated template — not a possibly-drifted example file.
- Anything outside the knowledge context — a skill, a future gate, a
  script — can validate a document against its type's schema by running
  one CLI command and reading a structured, fix-actionable diagnosis, the
  same detail the internal check already produces.

Output (a new CLI, six edited `SKILL.md` files) is not the measure; the
behavior change — PM-produced artifacts stop drifting from the schema that
is supposed to govern them, because the authoring path now actually
consults it — is.

## 4. The pinned solution shape (as directed, not re-derived here)

Two elements, split across the two BCs that already own the relevant
surfaces, with a real, named dependency:

- **shopsystem-knowledge** exposes its existing internal
  typedef-generation and validation logic as an installable CLI,
  `shop-knowledge` (named by the PO following the `shop-msg`/`shop-templates`
  prefix convention — see Vocabulary):
  - `shop-knowledge template <type>` / `shop-knowledge schema <type>` print
    the type's generated template / JSON Schema fragment.
  - `shop-knowledge validate <path>` checks a document's frontmatter and
    body against its own declared type's schema, reporting **every**
    violation found (not merely the first), with the same fix-actionable
    diagnosis detail (named missing field, named missing section) the
    internal check already produces.
- **shopsystem-templates** updates each schema-governed `lead_skill`'s
  `SKILL.md` so it (a) names fetching the canonical template via
  `shop-knowledge template <type>` before or while producing the artifact,
  and (b) names running `shop-knowledge validate` against the produced
  document and surfacing a failure to the product authority rather than
  closing silently.

**Dependency (named explicitly for the Architect):** shopsystem-templates'
half cannot be meaningfully implemented or tested until shopsystem-knowledge's
CLI exists — the templates scenarios assert that each skill's prose names
the literal `shop-knowledge template <type>` / `shop-knowledge validate`
invocations this brief pins, so the CLI's surface must be settled (if not
necessarily fully implemented) before that half is dispatched. `lead-5msa9.2`
is linked in `bd` as depending on `lead-5msa9.1`.

## 5. A verified correction to the six-skill framing — not all six are uniformly in scope

The six PDR-033 lead_skills are: `discovery-dialogue`, `shaping`,
`option-tradeoff`, `prioritization`, `problem-space-mapping`, and
`product-narrative` (confirmed exhaustive against the installed package's
`templates/lead_skills/` directory, alongside two non-artifact-producing
siblings, `bring-up-bc` and `create-bc`, correctly excluded). Checking each
skill's terminal artifact against shopsystem-knowledge's actual eight-type
typedef set (not assumed) surfaces a real mismatch the directive's
"by the same pattern presumably" framing did not anticipate:

| skill | terminal artifact | knowledge-BC governed? |
|---|---|---|
| discovery-dialogue | intent record | yes — `intent-record` |
| shaping | shaped candidate | yes — `candidate` |
| option-tradeoff | PDR draft **or** candidate fork | yes on both branches — `pdr` / `candidate` |
| prioritization | prioritization record | yes — `prioritization-record` |
| product-narrative | README, site, **or** current-state revision | **only the current-state branch** — `current-state`; README and site are outward renderings, not one of the eight typed artifacts |
| problem-space-mapping | problem-space map revision | **no** — "problem-space-map" is not one of the eight recognized types (confirmed against `per_type_typedef_generation.feature`'s "exactly the eight artifact types" pin) |

Applying a fetch-and-validate gate to an artifact family the knowledge BC
does not govern would either force an implementer to invent a typedef that
was never decided (scope creep this brief does not authorize) or produce a
silent-inference gap exactly like the one this brief exists to close.
Instead, this brief scopes precisely: the gate applies unconditionally to
four skills, applies to product-narrative's current-state branch only, and
explicitly does **not** apply to product-narrative's README/site branches or
to problem-space-mapping at all — both carve-outs are pinned as their own
negative-assertion scenarios (§7) so the exclusion is enforced, not merely
undocumented.

**Recorded reason for deferral, not silent drop:** whether "problem-space-map"
(and/or README/site) should become a ninth+ knowledge-BC-governed type is a
real, open product-direction question — extending the governed type set is
not a lead-po decision. Flagged here for the lead-pm main-session mode to
pick up as a possible future intent, not decided or folded into this brief.

## 6. Vocabulary (load-bearing)

- **`shop-knowledge`** — the new installed CLI exposing shopsystem-knowledge's
  artifact-format and validation logic. Named by the PO following the
  `shop-msg` (shopsystem-messaging) / `shop-templates` (shopsystem-templates)
  prefix convention already established for two of this fleet's three
  existing contract-tool CLIs (`scenarios`, the third, is the convention's
  one exception — a bare domain noun with no collision risk). This is a
  procedural naming choice, not a re-opened product decision.
- **`shop-knowledge template <type>`** / **`shop-knowledge schema <type>`** —
  print the named type's generated authoring template / JSON Schema
  fragment verbatim. `<type>` ranges over the eight recognized artifact
  types; an unrecognized value is rejected with a named diagnosis, never
  silently accepted or defaulted.
- **`shop-knowledge validate <path>`** — validates the document at `<path>`
  against its own declared `type`'s frontmatter schema and required-section
  set, reporting every violation found (not merely the first) and exiting
  non-zero on any non-conformance, zero on conformance.
- **the gate** — this brief's shorthand for "fetch the canonical template
  before/while producing the artifact, then validate the produced document
  before closing the session, surfacing any failure to the product
  authority rather than closing silently." Applies to the five governed
  skill/type pairs named in §5's table; explicitly does not apply to the
  two carved-out branches.

## 7. Scope

**In scope** (pinned by the scenarios below):

- `shop-knowledge template <type>` / `shop-knowledge schema <type>` /
  `shop-knowledge validate <path>` on shopsystem-knowledge, over the
  existing eight-type typedef set, reusing (not altering) the existing
  internal generation and validation logic.
- The gate wired into: discovery-dialogue (intent-record), shaping
  (candidate), option-tradeoff (pdr and candidate branches),
  prioritization (prioritization-record), and product-narrative's
  current-state branch only.
- Explicit carve-outs, pinned as their own scenarios: product-narrative's
  README/site branches, and problem-space-mapping in its entirety.
- The literal-CLI-naming discipline on every gated skill's closing step
  (mirroring the existing `bc_implementer_your_job_cli_naming.feature` /
  `lead_po_responding_to_clarify_cli_naming.feature` precedent already in
  this repo — a vague "check the artifact" step is not acceptable).

**Out of scope / explicit non-goals (do not scope these in — per the task
directive):**

- **Remediating this repo's 7 existing non-conformant PM artifacts**
  (`intent-001` through `intent-005`, `cand-001`, `cand-002`). This brief
  builds the tooling that makes a future reconciliation pass possible; it
  does not run that pass. Deferred with reason: reconciliation needs the
  validation CLI to exist first, and needs its own scoped decision about
  how to handle already-drifted history (append-only records — see
  brief-018's own non-goal reasoning for the same class of decision).
- **Resolving `lead-ptr7a`'s narrow `Verbatim anchors` clarify.** Handled
  separately, in flight; not superseded or absorbed by this brief (see
  Housekeeping below).
- **Extending the knowledge-BC's eight-type set** to cover
  problem-space-map, README, or site. Flagged in §5 as an open
  product-direction question, not decided here.
- **Any change to the typedef/generator internals** (ADR-059). This brief
  exposes existing output as a CLI; it does not change how that output is
  produced.

## 8. Two-BC dispatch split (explicit, not left implicit)

- **`features/shopsystem-knowledge/artifact_schema_cli.feature`** — 8
  scenarios, targets **shopsystem-knowledge**.
- **`features/shopsystem-templates/lead_skill_artifact_validation_gate.feature`**
  — 4 scenarios, targets **shopsystem-templates**.

Both files carry `@bc:unassigned @origin:brief-019` (the ADR-056 D8
transitional marker) — the Architect assigns the real `@bc:<name>` tag at
dispatch. Directory placement already signals intended target.

**Sequencing note for the Architect:** `lead-5msa9.2` (shopsystem-templates)
is linked in `bd` as depending on `lead-5msa9.1` (shopsystem-knowledge) —
per §4's named dependency, this is a hard sequencing dependency, not a soft
preference.

## 9. Pinned scenarios

Authored, hashed, and written to disk at:

- [`features/shopsystem-knowledge/artifact_schema_cli.feature`](../features/shopsystem-knowledge/artifact_schema_cli.feature)
  - `@scenario_hash:f4f5ed358bd8cb05` (K1) — `shop-knowledge template <type>`
    prints the canonical template for each of the eight recognized types.
  - `@scenario_hash:5b4249797a787e87` (K2) — `shop-knowledge schema <type>`
    prints the canonical JSON Schema fragment for each of the eight types.
  - `@scenario_hash:89a5c44117688941` (K3) — both `template` and `schema`
    reject an unrecognized type, naming the offending value.
  - `@scenario_hash:a640a9d897c0b144` (K4) — `shop-knowledge validate`
    reports a conforming document as conforming.
  - `@scenario_hash:a72ff18b65420b35` (K5) — a missing frontmatter field is
    named, matching the internal check's diagnosis.
  - `@scenario_hash:9bfae1a9bd3103c9` (K6) — a missing required body
    section is named, matching the internal check's diagnosis.
  - `@scenario_hash:60ba623cc4f6f4b0` (K7) — every violation on a
    multiply-non-conforming document is reported, not only the first —
    the detail-preservation guarantee the task directive named explicitly.
  - `@scenario_hash:3c0e3cd8259c8698` (K8) — a missing/unrecognized `type`
    field is diagnosed specifically, never silently skipped.
- [`features/shopsystem-templates/lead_skill_artifact_validation_gate.feature`](../features/shopsystem-templates/lead_skill_artifact_validation_gate.feature)
  - `@scenario_hash:107bb9e2d7ddb530` (T1) — each of the five governed
    skill/type pairs (Outline, 6 rows including option-tradeoff's two
    branches) names fetching the template, validating the produced
    document, and surfacing failure rather than closing silently.
  - `@scenario_hash:cfdf2213b1c77bfb` (T2) — product-narrative's README/site
    branches are explicitly named as NOT gated (carve-out, pinned
    positively so it can't silently regress into over-application).
  - `@scenario_hash:c0c636fb86c5579c` (T3) — problem-space-mapping is
    explicitly named as NOT gated (carve-out).
  - `@scenario_hash:c47a92f5486ea893` (T4) — the literal-CLI-naming
    discipline on every gated skill's closing step (Outline, 5 rows).

All `@scenario_hash` values were computed by the PO via the installed
`scenarios hash` CLI (block-only canonicalization) and reproduce exactly
via `scenarios list` against the on-disk files — verified before this brief
was written.

## 10. Strategic trace

Serves the same artifact-integrity bet PDR-032/ADR-059 already committed
to — "strong artifact schemas and prevent drift" — but closes the specific
mechanism gap this session discovered empirically: the schema existing
inside shopsystem-knowledge was never actually reachable from the one place
(the PM authoring skills) whose output it was supposed to govern. Without
this brief, PDR-032/ADR-059's investment keeps protecting against a drift
vector (hand-edited generated files) that isn't the one that actually fired
in this repo (an authoring path that never consulted the schema at all).

## 11. What would NOT satisfy the stakeholder

- Exposing the CLI but leaving the six skills unwired — the tooling exists
  but the drift mechanism is untouched.
- Wiring all six skills uniformly, including problem-space-mapping and
  product-narrative's README/site branches, by inventing an ad-hoc schema
  for artifact families the knowledge BC was never decided to govern.
- Flattening `shop-knowledge validate`'s diagnosis to a bare pass/fail,
  losing the fix-actionable detail the task directive explicitly required
  survive the CLI exposure.
- A skill update that references validation vaguely ("check the artifact
  against the schema") rather than naming the literal `shop-knowledge`
  invocation — exactly the vagueness this repo's own CLI-naming precedent
  (`bc_implementer_your_job_cli_naming.feature`) already exists to forbid.

## Housekeeping

**On whether `lead-ptr7a` should be superseded/absorbed by this brief:**
**no — recorded, not silently duplicated.** `lead-ptr7a` is a narrow,
already-in-flight fix to the `candidate` typedef itself (adding a
`Verbatim anchors` section) being negotiated directly with
shopsystem-knowledge via clarify. This brief is a structural fix one layer
up: making *any* typedef (including the one `lead-ptr7a` is actively
revising) reachable and checkable from the authoring path. The two are
complementary, not overlapping — `lead-ptr7a`'s typedef edit will simply be
one more thing `shop-knowledge template candidate` / `shop-knowledge
validate` correctly reflects once both land. No scope from `lead-ptr7a`
moves into this brief, and this brief creates no new work for `lead-ptr7a`
to absorb. Once this brief's CLI exists, remediating this repo's 7 drifted
PM artifacts (explicitly out of scope here, §7) becomes a well-tooled
follow-up — including reconciling `cand-002` against whatever `Verbatim
anchors` shape `lead-ptr7a` lands.
