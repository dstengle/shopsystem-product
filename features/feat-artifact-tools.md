---
type: feature
id: feat-artifact-tools
name: Artifacts read and written by part
status: assigned
version: 3
initiative: ../initiatives/init-artifact-tools.md
owner: lead-po
created: 2026-09-09
updated: 2026-09-09
---

# Feature: Artifacts read and written by part

## Feature

Feature: Artifacts read and written by part
  Every role that reads or writes an artifact
  can read or write it by the part it needs, through tools used
  through their skills, and have a calculated field — a parent's
  children, what references an artifact — rendered on request,
  so that a role loads only the section it asked for instead of the
  whole file, an edit is made without quoting the text it replaces,
  and a fact held in one place is readable from the other end without
  a read across the corpus.

## Contributors

Owning shop, per scenario, from this step's judgment: the initiative's
Decomposition section reads "Not yet."; every scenario runs on the
lead shop's own definition corpus, so each sits with the lead shop
until a decomposition names a Bounded Context.

- *a role reads one section of an artifact* — shopsystem-product (the lead shop)
- *a role writes one part of an artifact* — shopsystem-product (the lead shop)
- *a parent's children are rendered on request* — shopsystem-product (the lead shop)
- *what references an artifact is rendered on request* — shopsystem-product (the lead shop)
- *a scenario's hash is filled by the tool* — shopsystem-product (the lead shop)
- *an execution's bead names its initiative* — shopsystem-product (the lead shop)
- *the router loads a step, not the whole skill* — shopsystem-product (the lead shop)

Designer's usability and accessibility criteria — judged against
experience-principles v2 and the core-tasks record v5, for interaction
types cli and api, added at feature-authoring's add-usability step:

- *a role reads one section of an artifact* — cli and api both name and
  accept "section" as the caller's parameter, the same word in both
  (`consistent-not-uniform`); an unknown or missing section name is
  answered with an error naming the artifact, the section asked for,
  and the section names that do exist, never a raw exception or empty
  output (`errors-guide-recovery`); cli output is plain text a screen
  reader can follow, with no meaning carried by color alone, under
  WCAG2ICT (`accessible-by-standard`); api is agent-facing and carries
  no separate accessibility target (`agent-is-a-user`).
- *a role writes one part of an artifact* — cli and api both name the
  same "part" the write targets, consistently with the vocabulary
  (`consistent-not-uniform`); a write naming a part the artifact does
  not have, or content that does not fit the part's shape, fails with
  an error naming the artifact, the part, and what to supply instead,
  never a diff-style internal message (`errors-guide-recovery`); the
  tool's parameters are named for the calling role, not the
  implementer's internal field names, and documented for that caller
  (`agent-is-a-user`).
- *a parent's children are rendered on request* — the "children"
  listing carries the same fields and the same result shape in cli and
  api (`core-task-parity`, applied to the two named types); a parent
  with no children returns an explicit empty result, not silence or an
  error (`errors-guide-recovery`); the field returned is named for what
  the caller asked for, not a storage detail (`agent-is-a-user`).
- *what references an artifact is rendered on request* — the
  "references" listing carries the same fields and shape in cli and
  api (`core-task-parity`); an artifact nothing references returns an
  explicit empty result, not silence or an error
  (`errors-guide-recovery`); the field is named for the caller's
  question, not a storage detail (`agent-is-a-user`).
- *a scenario's hash is filled by the tool* — the fill action is named
  the same verb in cli and api (`consistent-not-uniform`); text the
  tool cannot hash (malformed or missing scenario text) fails with an
  error naming the scenario and what is wrong with its text, never a
  raw computation exception (`errors-guide-recovery`); the written
  field and its format are documented for the caller that reads it
  back (`agent-is-a-user`).
- *an execution's bead names its initiative* — the fill action is named
  the same verb in cli and api (`consistent-not-uniform`); an execution
  or an initiative the tool cannot find fails with an error naming
  which one and what to check, never a silent no-op
  (`errors-guide-recovery`); the written field is documented for the
  router and any other caller that reads it (`agent-is-a-user`).
- *the router loads a step, not the whole skill* — the router is an
  agent caller of this tool; its parameter is named for the step it
  asks for, documented, and screened as an interface like any other
  (`agent-is-a-user`); a step name the skill does not have fails with
  an error naming the skill, the step asked for, and the step names
  that do exist, never the whole skill returned as a fallback
  (`errors-guide-recovery`).
- Accessibility target — cli interactions apply WCAG 2.2 via WCAG2ICT
  for non-web software (`accessible-by-standard`); the criteria
  addressed to pointer input, visual layout, audio, and video do not
  apply to a text-only command line and are recorded here, with that
  reason, as not applicable; api and SDK interactions are agent-facing
  and carry no separate accessibility target, governed instead by
  `agent-is-a-user`.
- Core-task check — none of this feature's seven scenarios matches an
  entry on the core-tasks record (v5); no core task is added, removed,
  or given a type-specific removal by this feature, so `core-task-parity`
  is applied above only within the feature's own two named types.

- *no architect constraint is due* — the decomposition is not yet
  attached; none is named for this feature.

## Interaction types

cli, api — the For whom section: "the tools are run at a prompt and
by other tools."

## Scenarios

```gherkin
Feature: Artifacts read and written by part
  Every role that reads or writes an artifact
  can read or write it by the part it needs, through tools used
  through their skills, and have a calculated field — a parent's
  children, what references an artifact — rendered on request,
  so that a role loads only the section it asked for instead of the
  whole file, an edit is made without quoting the text it replaces,
  and a fact held in one place is readable from the other end without
  a read across the corpus.

  @bounded-context:shopsystem-product @feature:feat-artifact-tools @hash:928568f1acda
  Scenario: a role reads one section of an artifact
    Given an artifact and the section a role needs
    When the role reads that section through the tool
    Then only that section's text loads, the artifact's other sections and its history left out unless asked for

  @bounded-context:shopsystem-product @feature:feat-artifact-tools @hash:92e0cea25506
  Scenario: a role writes one part of an artifact
    Given an artifact and a change to one section or field
    When the role writes that change through the tool
    Then the change is made without the role quoting the text it replaces or restating the artifact's other content

  @bounded-context:shopsystem-product @feature:feat-artifact-tools @hash:69bcf1b318fd
  Scenario: a parent's children are rendered on request
    Given a parent artifact and its children elsewhere in the corpus
    When a role asks the tool for the parent's children
    Then the tool renders the list of children read fresh from the corpus, not a field stored on the parent

  @bounded-context:shopsystem-product @feature:feat-artifact-tools @hash:d99fd67243d9
  Scenario: what references an artifact is rendered on request
    Given an artifact and other artifacts that name it
    When a role asks the tool what references the artifact
    Then the tool renders the list of referencing artifacts read fresh from the corpus, not a field stored on the artifact

  @bounded-context:shopsystem-product @feature:feat-artifact-tools @hash:7ca6f58466a8
  Scenario: a scenario's hash is filled by the tool
    Given a scenario's text in a feature
    When a role asks the tool to fill the scenario's hash
    Then the tool computes the hash from the scenario's text and writes it, with no hand-typed value

  @bounded-context:shopsystem-product @feature:feat-artifact-tools @hash:15fb1628e2ee
  Scenario: an execution's bead names its initiative
    Given an execution's bead and the initiative it belongs to
    When a role asks the tool to fill the bead's initiative
    Then the tool writes the initiative onto the bead, read fresh from the corpus, with no hand-typed value

  @bounded-context:shopsystem-product @feature:feat-artifact-tools @hash:8be406b70517
  Scenario: the router loads a step, not the whole skill
    Given a process's skill and the step the router needs
    When the router asks the tool for that step
    Then the tool returns only that step's text, the skill's other steps left out
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| A role reads a whole artifact to use one section | framing (Problem) | Scenario: a role reads one section of an artifact |
| History holds 40 to 90 percent of an artifact's words | framing (Problem) | Scenario: a role reads one section of an artifact — history left out unless asked for |
| An edit quotes the text it replaces | framing (Problem) | Scenario: a role writes one part of an artifact |
| A history row is one line of up to 1,700 words | framing (Problem) | Scenario: a role writes one part of an artifact — the row is added without restating the artifact's other content |
| A fact held in one place cannot be read from the other end without a read across the corpus | framing (Problem) | Scenario: a parent's children are rendered on request; Scenario: what references an artifact is rendered on request |
| Hashes filled by hand | For whom (what the runs showed) | Scenario: a scenario's hash is filled by the tool |
| An execution's bead not naming its initiative | For whom (what the runs showed) | Scenario: an execution's bead names its initiative |
| The router loading the whole skill for one step | For whom (what the runs showed) | Scenario: the router loads a step, not the whole skill |
| A calculated field given a second home instead of rendered fresh | Appetite (no-go: "no second home for any fact") | Scenario: a parent's children are rendered on request; Scenario: what references an artifact is rendered on request — both render fresh from the corpus, neither stores a new field |
| A role needing the whole artifact | edge (For whom's target reads by section, not an exclusive replacement) | Out of scope: this feature adds reading and writing by part; a whole-artifact read stays available as it is today |
| An unknown or missing section name is asked for | designer (add-usability) | Scenario: a role reads one section of an artifact — errors-guide-recovery criterion in Contributors |
| A write names a part the artifact does not have, or content that does not fit the part's shape | designer (add-usability) | Scenario: a role writes one part of an artifact — errors-guide-recovery criterion in Contributors |
| A parent with no children | designer (add-usability) | Scenario: a parent's children are rendered on request — errors-guide-recovery criterion in Contributors |
| An artifact nothing references | designer (add-usability) | Scenario: what references an artifact is rendered on request — errors-guide-recovery criterion in Contributors |
| Scenario text the tool cannot hash (malformed or missing) | designer (add-usability) | Scenario: a scenario's hash is filled by the tool — errors-guide-recovery criterion in Contributors |
| An execution or an initiative the tool cannot find | designer (add-usability) | Scenario: an execution's bead names its initiative — errors-guide-recovery criterion in Contributors |
| A step name the skill does not have | designer (add-usability) | Scenario: the router loads a step, not the whole skill — errors-guide-recovery criterion in Contributors |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Authored by the PO role alone in the feature-authoring draft step, from init-artifact-tools's Framing and For whom sections (v2, planned); the Decomposition section reads "Not yet.", so every scenario's owning shop is this step's judgment — shopsystem-product, the lead shop, since every scenario runs on the lead shop's own definition corpus — to be confirmed once a decomposition exists; the designer's and architect's steps still to run. Seven scenarios: reading and writing an artifact by part (the framing's Problem, two scenarios); a parent's children and what references an artifact rendered on request, neither a stored field (the framing's Outcome and Appetite no-go, two scenarios); the three cases the For whom section names as what the runs showed — hashes filled by a tool, an execution's bead naming its initiative, the router loading a step, not the whole skill. Interaction types cli and api, from the For whom section's own words. Ten Edges rows: five from the framing's Problem and Outcome, three from the For whom section, one from the Appetite's no-go, one an edge on the target's exclusivity, out of scope with its reason. Every scenario's `@hash:` is `pending`: this step had no shell to compute the sha256 the repository's other features use; a later step fills the twelve hex digits before self-check. No self-check recorded here: feature-authoring's self-check step follows add-usability and add-constraints, not this step. Status draft. |
| 1 | 2026-09-09 | update | Designer's usability and accessibility criteria added at feature-authoring's add-usability step, judged against experience-principles v2 (`consistent-not-uniform`, `core-task-parity`, `agent-is-a-user`, `errors-guide-recovery`, `accessible-by-standard`) and the core-tasks record v5 (no entry on the record matches any of these seven scenarios; `core-task-parity` applied instead within the feature's own two named types, cli and api). One line per scenario written into Contributors, each naming the vocabulary-consistency, core-task-parity, or agent-is-a-user obligation the scenario carries and the failure or boundary case its error-recovery obligation names; a closing accessibility-target line records cli's WCAG 2.2-via-WCAG2ICT target with the pointer-input, visual-layout, audio, and video criteria marked not applicable to a text-only command line, and api's target as none, governed instead by `agent-is-a-user`; a closing core-task-check line records that no core task is added, removed, or given a type-specific removal by this feature. `control-stays-with-the-person` not applied: it governs assistant interactions, a type this feature does not offer. `evidence-not-opinion` not applied: this step states requirements to test against, not a usability verdict, so no observed-use claim is made that would need labeling a hypothesis. Seven Edges rows added, one per scenario, each naming the failure or boundary case its errors-guide-recovery criterion names and covered by that criterion's line in Contributors; no existing Edges row, scenario text, hash, or owning-shop assignment changed. Self-check against define-good-up-front: each criterion checked back against experience-principles.md's statement text and the core-tasks.md entry list before being written, recorded here rather than as a separate step since feature-authoring's self-check step follows add-usability and add-constraints together, not this step alone. Made by the lead-product-designer role. |
| 1 | 2026-09-09 | update | Architect's non-functional constraints checked at feature-authoring's add-constraints step, against init-artifact-tools's Decomposition section: it reads "Not yet." — no Bounded Context named, so no non-functional constraint is attached to any scenario. Recorded in Contributors that decomposition names none for this feature; no Contributors criterion line, no Edges row, and no needs-decision line added. No scenario text, hash, owning-shop line, or designer criterion changed. Made by the lead-solutions-architect role. |
| 2 | 2026-09-09 | review | Self-checked by the PO role at feature-authoring's self-check step against the feature fitness set (feature.fitness.md v17), read against feat-artifact-tools v1. Scenario 1 passes — each of the seven scenarios' Given/When/Then names one action or event and one outcome observable in what the tool returns or writes; "read fresh from the corpus, not a field stored on the parent/artifact" states an observable non-duplication outcome, not an implementation detail, matching the Appetite no-go the two rendered-field scenarios trace to. Scenario 2 passes — Contributors names shopsystem-product for all seven scenarios by name, tracing to the initiative's unattached Decomposition; both cli and api designer criteria stand for all seven, added at add-usability; the architect's line records that decomposition names no constraint, so none is due. Scenario 3 passes on presence, not correctness — `@feature:` and `@hash:` stand on all seven scenarios; every hash reads `pending` because no prior step in this run had a shell to compute the sha256 the repository's other features use, and this step has none either. Accepted, not fixed: this fitness set's own scenario 3 judges hash presence, not whether the value is a matching sha, and the gap is self-describing — this feature's own scenario "a scenario's hash is filled by the tool" is the tool that will later fill it; recorded here rather than hand-typing a placeholder value that would misrepresent a computed hash. Scenario 4 passes — the sixteen-row Edges table covers every case the framing's Problem, Outcome, and Appetite no-go name, the three For-whom "what the runs showed" cases, the target's whole-artifact edge (out of scope, reasoned), and all seven of the designer's errors-guide-recovery cases, one row each. Scenario 5 passes — Interaction types states cli and api, quoting the For whom section's own words. Scenario 6 passes — the narrative names who (every role that reads or writes an artifact), what (read or write by part, with calculated fields rendered on request), and the framing's own outcome (loading only the part asked for, editing without quoting, reading a fact from the other end without a corpus-wide read). Scenario 7: fixed, not accepted — the architect's non-functional-constraints passage carried process narration ("added at feature-authoring's add-constraints step", "No Contributors line added, no Edges row added, no needs-decision line recorded"), a maker's-self-check passage this scenario reserves for the Document History row, not Contributors; trimmed in place to one bullet, "*no architect constraint is due* — the decomposition is not yet attached; none is named for this feature," matching the format the designer's and the ownership preamble's lines already hold and the pattern feat-execution-vocabulary's Contributors set. No other Contributors passage, scenario text, hash, or Edges row changed by this fix. Accepted gap, not fixed: scenario 8 fails on a hand count, this session again having no word-count tool — the document runs well past the 1,000-word base-writing-style target for a feature once the three Document History rows are counted with the body; no cut is available without dropping a named case's Edges coverage, a designer criterion line, or a required History record, the same structural-overage finding and the same standing recommendation to the PM already logged against feat-execution-vocabulary's Document History (v4, v9, v14). Status set `checked`. init-artifact-tools (v2, `planned`) moved to `active` on this feature's first pass. Version bumped 1 → 2. |
| 3 | 2026-09-09 | state | Recorded by the lead-solutions-architect role at scenario-assignment's record step, reading feat-artifact-tools v2 against `assignment`, `guidance`, and `sent`. One entry, context shopsystem-product, carries all seven scenario hashes (`@hash:928568f1acda`, `@hash:92e0cea25506`, `@hash:69bcf1b318fd`, `@hash:d99fd67243d9`, `@hash:7ca6f58466a8`, `@hash:15fb1628e2ee`, `@hash:8be406b70517`) with the pre-state read: decomposition none (no `basis/contexts/` directory exists on this branch, re-checked here; init-artifact-tools v3's Decomposition section reads "Not yet."); contracts none (no Bounded Context contract exists, for the same reason); feature repository — the other fourteen files in `features/` swept in full, one non-conflicting touch-point found (feat-initiative-cost-rollup v9, which states the same bead-carries-its-initiative fact but triggered at execution start, not by a role's ask, and whose assignment is separate) and no scenario in this feature colliding with any already-specified scenario elsewhere in the repository. One guidance record was written, `guidance/feat-artifact-tools-shopsystem-product.md` (v1), covering all seven hashes. Evaluated here, independently of the assign step's own self-check, against implementation-guidance-fitness (v2): scenario 1 passes — every What-changes entry names a tool, a skill, or an action on the lead shop's own definitions (the new read/write tool, the two render actions, the two fill actions, the router's one added call), each qualified by a guardrail (the appetite's two no-gos, `tools-through-skills`), none describing a Bounded Context's internals since none exists; scenario 2 passes — every scenario is cited by `@hash:`, every principle, glossary entry, and tool description by name and version or by file, with no scenario text or contract clause reproduced; scenario 3 passes — each What-changes item names the concrete action to build (parameter names, the hash algorithm and digest length, the `bd comment` write path, the router's one new call) and which hashes it serves, so the shop can begin from the record and the seven scenarios alone; scenario 4 passes — every What-not-to-do entry names its reason: the appetite's first or second no-go, the designer's errors-guide-recovery criterion, a scenario's own Then, `tools-through-skills`, or `bd.json`'s fixed four actions; scenario 5 passes — the frontmatter and opening paragraph name the initiative, feature, context, and all seven hashes, every What-changes and What-not-to-do statement stays inside those seven, and item 5 explicitly disclaims binding feat-initiative-cost-rollup's separate assignment rather than folding it in. Scenario 6 passes on independent count, not the assign step's own `wc -w` claim taken on faith: counted here with `wc -w`, the whole document (frontmatter through Document History) runs 598 words, at the 600-word guidance-record target in base-writing-style.md; the body alone (past frontmatter, through Document History) runs 568, and the body without the Document History table runs 447 — every reading stands at or under the target, so the record meets scenario 6 whichever span is counted, with the whole-document reading passing only by a two-word margin worth flagging for whoever revises this record next. No `assign_scenarios` message was sent: shopsystem-product is the lead shop itself, not a Bounded Context; the shop stands frozen (no dispatches, no mailbox work); and no BC named shopsystem-product exists to receive one — the dispatch step's disclosed, recorded lead-shop-internal gap (bd issue lead-ki66p: "scenario-assignment lacks a lead-shop-internal path"), the same handling every prior run assigning to the lead shop itself has used, most recently feat-execution-vocabulary's Document History v15. Status set `assigned`. Version bumped 2 → 3. |
