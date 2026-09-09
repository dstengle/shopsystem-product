---
type: fitness-set
id: feature-fitness
target-type: feature
judged: true
executable: false
judged-by: cold-reviewer
owner: product-authority
status: approved
approved: 2026-08-31
version: 18
created: 2026-08-26
updated: 2026-09-09
generated: true
generated-by: basis/tools/compile_typedef.py
source: basis/artifacts/feature.md
source-digest: sha256:5f2bb94d3311
---

<!-- Generated from `basis/artifacts/feature.md` (its Fitness scenarios section) by `basis/tools/compile_typedef.py`; do not edit by hand — edit the typedef and re-render. -->

# Fitness set: feature

A feature is a Gherkin Feature — one capability from the user's or
agent's point of view with the scenarios that state what counts as
done for it — authored by the PO role alone, product-level, its
scenarios later assigned to Bounded Contexts by the solutions architect
role. The scenarios are executable by the owning shops; this set judges
the feature as a document and is never executed. These scenarios are
evaluated by the PO role at feature-authoring's self-check step,
alongside the framing (criterion `framing`). **Judged by:**
`cold-reviewer`, never executed; the judge reads only the criteria set,
the framing, and the feature; a fact the feature must carry — an
owning shop, a tag, an edge — is what these scenarios make it carry.
Assignment is not judged here: the `@bounded-context:` tag is set after
the check.

## Scenarios

Scenario 1: each scenario is one observable behavior
  Given a scenario in the feature's Gherkin block, Background steps
  included
  When its steps are read
  Then the When is one action or event, the Then an outcome observable
  in the running system, and no step names an implementation detail

Scenario 2: ownership and criteria are present
  Given the Contributors section
  When each scenario is read against it
  Then an owning shop is named for that scenario, and, where the
  Interaction types section names a type, the product designer role's
  usability acceptance criteria and the accessibility criteria are
  present, and, where the Contributors section says the decomposition
  names them, the solutions architect role's non-functional constraints
  are present (sources are provenance, not documents to open)

Scenario 3: identity tags are present
  Given each scenario's tags
  When they are read
  Then `@feature:<id>` and `@hash:<sha>` are present (whether the hash
  matches the text is a lint, not this judge's; the `@bounded-context:`
  tag is assignment's and is not judged here, present or absent)

Scenario 4: every listed edge is covered
  Given the Edges table and the cases the framing or a contributor's
  criteria name
  When each case is read
  Then it names the covering scenario by its Scenario name or is marked
  out of scope with a reason, and every case the framing or a
  contributor's criteria name appears in the table

Scenario 5: interaction types are stated
  Given the Interaction types section
  When it is read
  Then it names the types the capability must be available on, or
  "none" with a reason the framing bears out (the experience principle
  `core-task-parity`)

Scenario 6: the feature says who it is for and why
  Given the Feature line and its narrative
  When they are read
  Then they name who the capability is for, what they can do, and the
  outcome it serves, and that outcome is the framing's

Scenario 7: the Contributors body carries criteria, not reasoning
  Given the Contributors section's body
  When each passage is read
  Then every passage is an owning shop, a criterion, or a constraint,
  riding by name on the scenarios it bounds, in one short line; a
  passage carrying the reasoning behind a criterion or a maker's
  self-check fails, with the passage named (those stand in the
  Document History row, not read here)

Scenario 8: the feature meets its word target
  Given the feature document
  When its words are counted
  Then the count is at or under the base-writing-style word target for
  a feature

Scenario 9: each Document History row, Contributors passage, and Edges
row meets its own target
  Given a Document History row, the Contributors passage, or an Edges
  row
  When its words are counted
  Then the count is at or under the base-writing-style target for that
  item, with no overage accepted as a gap

## Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 — one observable behavior | "For each scenario and the Background: is the When one action, the Then observable in the running system, and no step implementation-specific? Cite any failing step." |
| 2 — ownership and criteria | "For each scenario: is an owning shop named? Where a type is named, are both designer criteria present? Where constraints are said to be named, are they present? Cite or name the absence." |
| 3 — identity tags | "For each scenario: `@feature:` present? `@hash:` present? Cite any scenario without both." |
| 4 — edges covered | "For each row of the Edges table and each case the framing or a contributor's criteria name: a covering scenario or a reasoned exclusion? Any uncovered or missing case = fail." |
| 5 — interaction types stated | "Does the Interaction types section name types, or 'none' with a reason the framing bears out? Cite the sentence or its absence." |
| 6 — narrative | "Does the Feature narrative name who, what, and the outcome, and is the outcome the framing's? Cite the lines or their absence." |
| 7 — Contributors body | "For each passage of the Contributors body: is it an owning shop, a criterion, or a constraint riding by name on the scenarios it bounds, in one short line? A passage of reasoning or of a maker's self-check = fail; name the passage." |
| 8 — word target | "Count the document's words. Is the count at or under the base-writing-style target for a feature? State the count and pass/fail." |
| 9 — section-item word targets | "Count the words of each Document History row, the Contributors passage, and each Edges row. Is each at or under its base-writing-style target? Cite any row or passage over, with its count." |
