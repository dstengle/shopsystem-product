---
type: fitness-set
id: feature-fitness
owner: product-authority
status: draft
version: 8
created: 2026-08-26
updated: 2026-08-28
target-type: feature
judged: true
executable: false
judged-by: cold-reviewer
---

# Fitness set: feature

A feature is a Gherkin Feature — one capability from the user's or
agent's point of view with the scenarios that state what counts as
done for it — authored by the PO role alone, product-level, its
scenarios later assigned to Bounded Contexts by the solutions
architect role.
The scenarios are executable by the owning shops; this set judges the
feature as a document and is never executed. These scenarios are the
criteria set the [PO output check](../processes/po-output-check.md)
screens a feature against, alongside the framing (criterion
`framing`). Evaluated by the `cold-reviewer` role. The judge reads only
the criteria set, the framing, and the feature; a fact the feature must
carry — an owning shop, a tag, an edge — is what these scenarios make it
carry. Assignment is not judged here: the `@bounded-context:` tag is
set after the check.

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
  present, and, where the Contributors section says the decomposition names them,
  the solutions architect role's non-functional constraints are
  present (sources are provenance, not documents to open)

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
  out of scope with a reason, and every case the framing or a contributor's criteria name appears
  in the table

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

## Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 — one observable behavior | "For each scenario and the Background: is the When one action, the Then observable in the running system, and no step implementation-specific? Cite any failing step." |
| 2 — ownership and criteria | "For each scenario: is an owning shop named? Where a type is named, are both designer criteria present? Where constraints are said to be named, are they present? Cite or name the absence." |
| 3 — identity tags | "For each scenario: `@feature:` present? `@hash:` present? Cite any scenario without both." |
| 4 — edges covered | "For each row of the Edges table and each case the framing or a contributor's criteria name: a covering scenario or a reasoned exclusion? Any uncovered or missing case = fail." |
| 5 — interaction types stated | "Does the Interaction types section name types, or 'none' with a reason the framing bears out? Cite the sentence or its absence." |
| 6 — narrative | "Does the Feature narrative name who, what, and the outcome, and is the outcome the framing's? Cite the lines or their absence." |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored as the criteria set the PO output check screens acceptance-scenario sets against. |
| 1 | 2026-08-26 | review | Screened: findings — "usability criteria" alone; an attribution record no definition carried; a hash comparison a reading judge cannot make; edge cases the judge would invent. |
| 2 | 2026-08-26 | update | Repairs: both criteria named with sources; co-production stated as what the set must say; hash reduced to presence; edges bound to the framing and the set's own contribution. |
| 3 | 2026-08-26 | update | Repairs: scenario 4 bound to the framing and the set's stated shop contribution; sources in the Then; the hash lint marked to-be-filed. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean. |
| 3 | 2026-08-26 | state | draft → approved by the owner. |
| 4 | 2026-08-28 | update | Owner decision: re-formed with the `feature` typedef — a Feature is product-level with scenarios owned by several contexts; scenario 2 reads per owning shop; scenario 3 asks for the feature tag only, the bounded-context tag being assignment's; scenario 6 added for the Feature narrative. Returned to draft with the typedef. File renamed. |
| 4 | 2026-08-28 | review | Screened with the chain: findings — scenario 4's Given named a set the judge could not enumerate; scenario 2 needed knowledge of who owns what; scenario 5 could not tell absence from omission; "hold on" unplain. |
| 5 | 2026-08-28 | update | Repairs: scenario 4 reads the Edges table; scenario 2 asks for a named source per scenario; scenario 5 reads a section that is always present; Background steps judged under scenario 1; the tag forms named. |
| 5 | 2026-08-28 | review | Re-screened: findings — scenario 3's absence clause failed correct features. |
| 6 | 2026-08-28 | update | Repairs: scenario 3 judges presence only; Edges rows by Scenario name; scenario 2's sources marked as provenance. |
| 6 | 2026-08-28 | review | Final screen (round 3): clean — every Then falsifiable from the three inputs. |
| 7 | 2026-08-31 | update | Owner decision: scenario 2 checks ownership and the two roles' criteria, not shop authorship. |
| 8 | 2026-08-31 | review | Round-2 screen: scenario 4 and its judge framing extended to cases a contributor's criteria name (matching the typedef's Edges sources); the constraints clause's antecedent named (Contributors section); the intro's source shop is an owning shop. |
