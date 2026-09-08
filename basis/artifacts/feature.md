---
type: artifact-typedef
id: feature-typedef
defines: feature
owner: product-authority
status: approved
approved: 2026-08-31
version: 17
created: 2026-08-26
updated: 2026-09-08
ancestry: [feature]
---

# Artifact type: feature

## Identity and ancestry

- **Type:** `feature` — a Gherkin Feature: one capability described
  from the user's or agent's point of view, with the scenarios that
  state, as requirements, what counts as done for it. A product-level
  artifact: it belongs to the [initiative](initiative.md) it is made
  from — or, when small, to the [request](request.md) routed to the
  small-change lane it is made from — and may hold scenarios owned by
  several Bounded Contexts. The scenario is the atom; the feature is
  its grouping; the feature repository — the lead shop's directory of
  feature artifacts — is the record of what is specified, and a
  context's assigned set is the subset of scenarios, across all
  features, tagged to it. The instance is a
  markdown document with frontmatter whose Scenarios section holds one
  fenced Gherkin block — the executable unit the shops receive; the
  other sections are the document's, not Gherkin's. Scenarios are
  executed by the owning shops; the feature as a document is judged by
  the [feature fitness set](../fitness/feature.fitness.md), never
  executed there. `ancestry` names no generic root: a feature is
  neither a request nor a definition.
- **Produced by:** the [PO role](../roles/lead-po.md), as sole author —
  the scenarios' steps included; the product designer role contributes
  usability and accessibility criteria, the solutions architect role
  its non-functional constraints where the decomposition names them.
  The owning shops do not co-author: conflicts with behavior already
  specified are caught by the repository sweep at assignment, and a
  shop's objection travels as a clarify or a returned dispatch after
  it receives its scenarios. Checked by its own self-check step in
  [feature authoring](../processes/feature-authoring.md); its
  scenarios assigned to Bounded Contexts by the solutions architect
  role in the
  [scenario assignment](../processes/scenario-assignment.md) process.
  **Consumed by:** the shops, each receiving the scenarios tagged to it;
  the [interaction conformance check](../processes/interaction-conformance-check.md)
  for the interaction types named; the changelog rendering the same report proposes, when the
  [reconcile-and-close](../processes/reconcile-and-close.md) process
  closes the work that delivered its scenarios.

## Required frontmatter

`type: feature`, `id`, `status`, `version`, `name` (the Feature's
name), `initiative` (link to the initiative it is made from; its
framing is that document's first section), `owner`, `created`,
`updated`; `size` — `standard` | `small`, `standard` when absent.
When `size: small`, `request` (link to the request routed to the
small-change lane the feature is made from) stands in place of
`initiative`, and the framing is that request's section 1 (What is
requested); a small feature has no initiative to activate.
`approved` does not apply: a feature's terminal state is
`assigned`. Status values and their writers: `draft` (the PO role);
`checked` (feature-authoring's own self-check step, replacing
`draft`); `assigned` (the scenario assignment process's record step,
replacing `checked` when every scenario carries its tag); a feature
the assignment process returns goes to `returned`, and the PO role
resubmits it from `draft`.

## Required sections

1. **Feature** — the Gherkin `Feature:` line with its name, and the
   narrative beneath it: who the capability is for, what they can do,
   and the outcome it serves, in the framing's words.
2. **Contributors** — the owning shop per scenario, from the
   decomposition (ownership for assignment, not authorship); the
   designer's usability and accessibility criteria where there is an
   interaction; the architect's non-functional constraints where the
   decomposition names them — each riding by name on the scenarios it
   bounds. Nothing else: the reasoning, what was considered, and the
   maker's self-check go in the Document History row of the step that
   added them.
3. **Interaction types** — always present: the interaction types the
   capability must be available on, from the
   [core-task list](../experience/core-tasks.md), or "none" with the
   reason when the capability has no interaction.
4. **Scenarios** — one fenced `gherkin` block, the executable unit:
   it opens with the `Feature:` line and narrative of §1 verbatim (§1
   is the document's reading of the block's head; the block is the
   source, and the repeat is accepted so the document reads without
   the block), then an optional `Background:` (its Given steps judged as any
   step), then each `Scenario:` carrying the tags `@feature:<id>` (so a
   scenario travels alone to a shop and still names its feature —
   the reason the Feature line's tag inheritance is not relied on),
   `@hash:<sha>` (a hash of the scenario's text), and, once assigned,
   `@bounded-context:<name>`; Given/When/Then with one action or event
   in the When and an outcome observable in the running system in the
   Then; no step names an implementation detail.
5. **Edges** — a table of every failure and boundary case the framing
   or a contributor's criteria name: case · who named it · the
   `Scenario:` name that covers it, or "out of scope" with the reason.

## Rules

- `@bounded-context:` is written only by the architect, at
  assignment, never by the PO. A scenario whose owning context
  differs from its Contributors' shop is unowned; the feature
  returns for the PO to correct it.
- A changed scenario text is a new scenario with a new `@hash:`.
- A scenario's conflict with specified behavior is caught by the
  repository sweep at assignment, never asked during authoring; a
  shop's voice after dispatch is the clarify and the return.
- A small feature (`size: small`) comes from a request routed to the
  small-change lane; it links `request` in place of `initiative`,
  framed by the request's section 1, and is otherwise a feature like
  any other — no bet, no check of record between the request and it.
- A Contributors passage names an owning shop, a criterion, or a
  constraint in one short line, with no reasoning restated; the
  reasoning stands in the Document History row of the step that added
  it.

## Commitment (Definition of Done)

A feature is done when feature-authoring's self-check step has set it
checked against its fitness set and the framing, and every scenario
carries a `@bounded-context:` tag. **Consequence:** a feature the
scenario-assignment process cannot fully assign is returned and no
scenario is dispatched.

## Sources

Gherkin (Feature, narrative, Background, Scenario, tags — the block's
form); the
experience principles `core-task-parity` and `accessible-by-standard`;
the [feature fitness set](../fitness/feature.fitness.md).

## Writing rules

**Voice principle.** Write the feature for the person or agent it
serves and for the shops that will run its scenarios: a narrative that
says who and why, then scenarios that each state one action and one
observable outcome, with nothing about how, the whole document at or
under its word target.

**Highlights (the layer compiled into generating context):** a Feature
line and a narrative — who, what, the outcome, in the framing's words ·
one When, one observable Then, no how · each owning shop named per
scenario · the architect's constraints where the decomposition names
them · usability and accessibility criteria where there is an
interaction · `@feature:` and `@hash:` on every scenario · every named
edge covered or excluded with a reason · the interaction types stated,
or "none" with a reason · the whole document at or under the
base-writing-style word target for a feature.

**Layers:** this guideline adds feature rules on top of the
[base writing style](../guidelines/base-writing-style.md); the base
always applies and is never overridden. When rules conflict, an
approved principle beats the [feature typedef](feature.md), which
beats this guideline. Gherkin's own syntax governs the Feature,
Background, and Given/When/Then form. Every rule feeds the
[feature fitness set](../fitness/feature.fitness.md), scored at
feature-authoring's self-check step.

---

### Rules

**1. A narrative that says who and why.**
Before: "Feature: Run list" with scenarios beneath and no narrative.
After: "Feature: Failed runs visible in the run list / An operator
checking last night's runs / can see which failed without opening each
/ so that a failed run is noticed within one glance (the framing's
outcome)."
*Test:* read the Feature line and the lines beneath it. *Criterion:*
they name who the capability is for, what they can do, and the outcome
it serves, and the outcome is the framing's. *Decision:* yes/no per
feature.
*Derived check:* judged — feature fitness scenario 6.

**2. One action, one observable outcome, no implementation.**
Before: "When the user clicks the red button and the API returns 200,
Then the database row is updated."
After: "When the operator lists runs, Then each failed run is marked as
failed in the list."
*Test:* for each scenario and the Background, count the actions in the
When and check the Then against what a person or agent could observe
from outside the system. *Criterion:* one action or event; an outcome
observable in the running system; no step names an implementation
detail, such as a component, call, storage, algorithm, format, or
vendor. *Decision:* yes/no per scenario.
*Derived check:* judged — feature fitness scenario 1.

**3. Name the owning shop and the criteria for every scenario.**
Before: a feature with no contributors section.
After: "Contributors: the list scenarios are the reporting context's,
the CSV scenarios the export context's (per the decomposition); the
product designer role's criteria: marked within one glance; failure
not by color alone; the solutions architect role's constraint: the
list renders within one second at ten thousand runs."
*Test:* read each scenario against the Contributors section.
*Criterion:* every scenario has a named owning shop; where the
Interaction types section names a type, both designer criteria are
present; where the Contributors section says the decomposition names
constraints, they are present. *Decision:* yes/no per scenario.
*Derived check:* judged — feature fitness scenario 2.

**4. Tag every scenario with its feature and hash.**
Before: a scenario with a title only.
After: `@feature:failed-runs-visible @hash:3f9a…` on the line above
`Scenario:` (the `@bounded-context:` tag is the architect's, written at
assignment; its presence is not this rule's).
*Test:* read each scenario's tag line. *Criterion:* `@feature:` and
`@hash:` are present. *Decision:* yes/no per scenario.
*Derived check:* judged — feature fitness scenario 3.

**5. List every edge and cover or exclude it.**
Before: a happy path only, with the cancelled-run case the designer's
criterion named absent from the Edges table.
After: an Edges row "cancelled run · designer criterion · Scenario: a
cancelled run is not marked failed" and a row "runs older than
the retention window · framing · out of scope: the archive feature
owns them".
*Test:* read the Edges table and the cases the framing or a
contributor's criteria name.
*Criterion:* every row names a covering scenario or a reasoned
exclusion, and every case the framing or a contributor's criteria name
has a row. *Decision:* yes/no per case.
*Derived check:* judged — feature fitness scenario 4.

**6. State the interaction types, or "none" with a reason.**
Before: no Interaction types section.
After: "Interaction types: cli, gui — from the core-task list's 'read
a decision' row." or "Interaction types: none — the capability is a
nightly reconciliation with no person or agent at an interface."
*Test:* read the Interaction types section. *Criterion:* it names the
types the capability must be available on, or "none" with a reason the
framing bears out. *Decision:* yes/no per feature.
*Derived check:* judged — feature fitness scenario 5.

**7. Put criteria in the Contributors body; put the reasoning in the
Document History row.**
Before: a Contributors section that, after each criterion, explains
why it was chosen and closes with a self-check against the principles.
After: "the product designer role's criteria, on Scenario: a failed
run is marked: marked within one glance; failure not by color alone."
— and, in the Document History row of the step that added them: "two
candidates considered and not made criteria: neither serves the
framing's outcome; self-check: both ride by name on the scenario they
bound."
*Test:* read each passage of the Contributors body. *Criterion:* every
passage is an owning shop, a criterion, or a constraint, each riding by
name on the scenarios it bounds, in one short line; the reasoning
behind a criterion and the maker's self-check stand in the Document
History row, not the body. *Decision:* yes/no per passage.
*Derived check:* judged — feature fitness scenario 7.

**8. Meet the feature's word target.**
Before: a feature at 3,588 words, its Contributors and History rows
carrying reasoning the base style keeps out of the body.
After: a feature whose body holds only what rules 1–7 require, at or
under the target.
*Test:* count the words of the whole document. *Criterion:* the count
is at or under the base-writing-style word target for a feature.
*Decision:* yes/no per feature.
*Derived check:* judged — feature fitness scenario 8.

## Fitness scenarios

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

### Scenarios

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

### Compile mapping (each Then → one judge-rubric assertion)

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

## Derived review checklist

- Feature line and narrative present, tied to the framing. *(§Required sections 1; fitness 6)*
- Each scenario one observable behavior, no how. *(§Required sections 4; fitness 1)*
- Every scenario has a named owning shop; designer criteria where there is an interaction; architect constraints where named. *(§Required sections 2; fitness 2)*
- `@feature:` and `@hash:` on every scenario. *(§Required sections 4; fitness 3)*
- Every listed edge covered or excluded with reason. *(§Required sections 5; fitness 4)*
- Interaction types section present, named or "none" with reason. *(§Required sections 3; fitness 5)*
- `size` absent or `standard` with `initiative` linked; or `small` with `request` linked in its place, the framing the request's section 1. *(§Required frontmatter; §Rules)*
- Whole document at or under the base-writing-style word target for a feature. *(§Writing rules rule 8; fitness 8)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored as `acceptance-scenarios` from the approved fitness set; carried the co-production statement and the tag's content the set asked the typedef to carry. |
| 1 | 2026-08-26 | review | Screened: findings — definition wrongly in the ancestry; fitness 2's two criteria collapsed; an undefined consumer; the tag's content in two homes. |
| 2 | 2026-08-26 | update | Repairs: ancestry corrected; both criteria named; the conformance check linked; the tag carries the frontmatter values. |
| 3 | 2026-08-26 | update | assigned's transition stated; edges bound to §1's stated contribution; core-task list linked. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean. |
| 4 | 2026-08-28 | update | Owner decision: re-formed as `feature` on Gherkin's own unit — the type was grouped per behavior and pre-assigned to one context, a dispatch convenience carried from `main`. A feature is product-level, belongs to its framing or initiative, holds scenarios owned by several contexts; assignment moves to the solutions architect's scenario-assignment process and lives on `@bounded-context:` tags; `context` leaves the frontmatter; a Feature line and narrative are required. File renamed from `acceptance-scenarios.md`. |
| 4 | 2026-08-28 | review | Screened with the chain: findings — the instance form unstated and the hash not Gherkin-legal; pre-assignment ownership undefined; the edge list required by nothing; status transitions incomplete; `date` undefined; consumers unlinked. |
| 5 | 2026-08-28 | update | Repairs: markdown instance with one fenced Gherkin block; `@feature:` and `@hash:` tags; ownership from the decomposition, confirmed or corrected at assignment; an edge table; every transition with its writer; `date` dropped; consumers linked; interaction types always present. |
| 5 | 2026-08-28 | review | Re-screened: findings — the "no bounded-context tag at the check" clause failed re-verified and resubmitted features; the correction path had no deciding step or status; the Edges reference form unstated; two insider references. |
| 6 | 2026-08-28 | update | Repairs: the clause removed, the writer rule kept and enforced by the assignment process, which returns a feature whose tag differs from its Contributors' shop; Edges rows reference the Scenario name; the block's head stated as the source; references located. |
| 6 | 2026-08-28 | review | Final screen (round 3): clean — no absence clause survives in any check; the correction path carried by the assignment process; two stumbles polished in place. |
| 7 | 2026-08-28 | update | The initiative typedef now exists: the feature links its initiative, whose first section is the framing. |
| 8 | 2026-08-31 | update | Owner direction: the register is the lead shop's, viewed per context. |
| 9 | 2026-08-31 | update | Owner decision: co-production dropped — the PO authors alone (the register sweep and the post-dispatch clarify are the shop's voice); the architect's non-functional constraints added beside the designer's criteria; Contributors names ownership, not authorship. |
| 10 | 2026-08-31 | review | Round-1 screen of the co-production removal: the Edges table's sources are the framing and the contributors' criteria, not a shop. |
| 11 | 2026-08-31 | update | Owner direction: the repository/register split — the feature repository (the artifacts as specified) is what the conflict sweep at assignment reads; the scenario register is the tracker of implemented scenarios, a feature to be built. |
| 11 | 2026-08-31 | state | draft → approved with batch C as one block (brief-032 ask 2, default accepted). |
| 12 | 2026-09-04 | update | Under init-request-routing / feat-request-routing on the authority's standing direction of 2026-09-04, per adr-2026-09-04-request-front-end: frontmatter `size` (`standard` | `small`, `standard` by default); when `small`, a `request` link stands in place of `initiative` and the framing is the request's section 1 (What is requested), which the PO output check's `framing` input names for a small feature; rule added — a small feature is made from a request routed to the small-change lane when the change is best expressed as scenarios, the lane's definition step may produce one; Type bullet and checklist updated. Scenario and hash rules unchanged. Made by the architect role; the owner's approval of the amendment is pending. |
| 13 | 2026-09-08 | update | Under req-2026-09-07-contributors-body through the small-change lane (work item lead-ryr33): the Contributors entry (Required sections, item 2) states that the body holds a contributor's criteria and constraints — each riding by name on the scenarios it bounds — and that the reasoning behind them, what was considered and not made a criterion, and the maker's self-check stand in the Document History row of the step that added them; the rule the screen of feat-tool-skills applied by hand. Nothing else changed. Made by the solutions architect role. |
| 14 | 2026-09-08 | update | Under feat-plain-voice: the Contributors entry and the Rules section rewritten to the plain-voice rule, every requirement kept, prose cut. The hand-authored guideline and fitness set beside this typedef were not re-synchronized in this pass. |
| 15 | 2026-09-08 | update | Under feat-flow-simplification, retiring the PO output check: `checked` is written by feature-authoring's own self-check step, not a separate check's record step; `returned` and `pending-definition` drop from the status list — a self-checked feature only goes `returned` from the scenario-assignment process; Produced-by and the Commitment section point to the self-check. |
| 16 | 2026-09-08 | update | Under feat-plain-voice-rest (`@hash:7c2f4e9b6a13`): Rules gains a bullet — a Contributors passage names an owning shop, a criterion, or a constraint in one short line, no reasoning restated, the reasoning kept in the Document History row that added it. Made by the lead-solutions-architect role. |
| 17 | 2026-09-08 | update | Under feat-plain-voice-rest (`@hash:9a4e7c1b2f56`, `@hash:5f2b8d4c9a17`, `@hash:3d8b1c5f9e24`): Writing rules and Fitness scenarios sections added, carrying forward the feature guideline (v9) and fitness set (v9), tightened per base-writing-style v3, plus a new rule 8 and fitness scenario 8 holding the whole document to the base-writing-style feature word target; references updated from the retired PO output check to feature-authoring's self-check step. From this version the guideline and fitness set are renderings of this typedef, produced by `basis/tools/compile_typedef.py`; their own histories end at guideline v9 and fitness v9 and stay readable in the repository history. Made by the lead-solutions-architect role. |
