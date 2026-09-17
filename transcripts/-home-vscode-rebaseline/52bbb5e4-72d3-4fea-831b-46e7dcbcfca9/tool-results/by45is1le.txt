---
type: feature
id: feat-typedef-rendering
name: Typedef rendering
status: assigned
version: 8
initiative: ../initiatives/init-typedef-rendering.md
owner: lead-po
created: 2026-09-05
updated: 2026-09-05
---

# Feature: Typedef rendering

## Feature

Feature: Typedef rendering
  The makers and checkers of every artifact type, and the authority
  when the standard changes,
  can work from one standard for an artifact type — the maker's text
  and the checker's text both from it, a change to the standard
  reaching both, and the checker's tests runnable by the author
  first —
  so that whoever makes an artifact and whoever checks it work from
  the same standard, when the standard changes it reaches both, and
  the checker's tests can be run by the author first.

## Contributors

Owning shop, per scenario — from the initiative's Decomposition
section, which names no Bounded Context: the standard, the two texts,
and the checks that read them sit in the lead shop's tree, and no
contract exists on this branch to rely on.

- *the maker's text and the checker's text for a type come from its one standard* — shopsystem-product (the lead shop)
- *an author runs the checker's tests on their own draft before the check* — shopsystem-product (the lead shop)
- *a change to the standard reaches the maker's text and the checker's text* — shopsystem-product (the lead shop)
- *a text not current with its standard is reported* — shopsystem-product (the lead shop)
- *a text not current with its standard is made current, whatever the cause* — shopsystem-product (the lead shop)
- *a check screens against the produced text as it did before* — shopsystem-product (the lead shop)
- *the product decision record of this initiative's bet is made and checked from one standard* — shopsystem-product (the lead shop)

Vocabulary, one term per entry, in the order the scenarios use them
and then the order the constraints do:

- **standard** — the framing's word for what the maker and the
  checker of an artifact of a type work from: the type's writing
  rules and the tests an instance is checked against. The design
  decision the initiative rests on
  ([adr-2026-09-05-typedef-rendering](../decisions/adr-2026-09-05-typedef-rendering.md))
  names that document: the type's typedef.
- **maker's text** — what a maker of an artifact of the type reads
  for its writing rules; the glossary's `guideline`.
- **checker's text** — what a check of an artifact of the type
  screens it against; the glossary's `fitness set`: judged
  Given/When/Then scenarios.
- **produced from** — a text is produced from a standard when it is,
  in the glossary's term, a rendering of it: never edited by hand,
  never the source; a produced text names the standard it is produced
  from.
- **current with** — a text is current with its standard when the
  text is what a fresh production from the standard as it now stands
  would yield; a standard changed since the production and a text
  changed by hand each leave a text that is not current. This is what
  "current with" means in every Then.
- **checker's tests** — the scenarios the checker's text carries,
  each Given/When/Then, applied by a reader to an instance.
- **the process that keeps the texts current** — the process whose
  run produces each text from its standard as it now stands, and
  whose check is the check over the texts.
- **the check over the texts** — the check that reads each text
  against its standard and reports one that is not current; distinct
  from the checks that screen an artifact against the checker's text,
  the PO output check among them.
- **the proof** — the initiative's Appetite: the product decision
  record of this initiative's bet, made by the PO role from the
  maker's text and screened by its check against the checker's text,
  the check's use counting whether or not it screens for form only.
- **typedef** — the glossary's single source a type is generated
  from; the document the design decision names as a type's standard.
- **the linter** — the check the tree runs on every definition.
- **Highlights, Scenarios, Compile mapping** — the parts the two
  texts carry today: Highlights the maker's text's, the layer loaded
  into an author's context; Scenarios and Compile mapping the
  checker's text's — the tests, and the table taking each test into
  one judge assertion.
- **the artifact-typedef, quality-guideline, and fitness-set
  typedefs** — the definitions of those three document types: of a
  typedef itself, of a maker's text, of a checker's text.
- **the compiler** — the tool whose run produces a text from its
  typedef; the process that keeps the texts current runs it.

No usability or accessibility criteria are due on this feature: its interaction types are none, and no entry in the core-task list carries reading a standard or a text produced from it, or running the checker's tests on a draft — the nearest, *submit output for a check*, begins after the author's self-run in scenario 2, which is a reading inside the authoring step of that type's process, not an option an interaction type must offer (designer, 2026-09-05).

Non-functional constraints — due. The initiative's Decomposition
names no Bounded Context, so no cross-context constraint applies;
what it does name is a bound — the typedef, the compiler, and the
renderings sit in the lead shop's tree, and no contract exists on
this branch to rely on — and the design decision the initiative rests
on,
[adr-2026-09-05-typedef-rendering](../decisions/adr-2026-09-05-typedef-rendering.md)
(checked, v4), sets what an implementation of these scenarios must
hold to, under the working principle set every session compiles in.
Each constraint says what must hold, not how; each rides on the
scenarios it bounds. (architect, 2026-09-05)

- C1 — one hand-edited document (the ADR's Decision;
  `single-source-of-truth`): a type's typedef is the one hand-edited
  document of its standard, and the maker's text and the checker's
  text are produced from it and never edited by hand — a hand edit
  of either is drift, reported by the check over the texts and
  reconciled by producing the text again from the typedef, never by
  editing the typedef to match the edit. Rides on *the maker's text
  and the checker's text for a type come from its one standard*, *a
  change to the standard reaches the maker's text and the checker's
  text*, *a text not current with its standard is reported*, *a text
  not current with its standard is made current, whatever the
  cause*. (architect, 2026-09-05)
- C2 — every produced text names its source and carries its digest
  (the ADR's second consequence): a produced text's
  frontmatter marks it as produced, names the typedef it is produced
  from, and carries the source-digest of that typedef's text, and a
  text is current with its typedef only when both that digest and the
  text itself match a fresh production from the typedef as it
  stands — a text with no digest, naming a source that is not its
  type's typedef, or differing from the fresh production while its
  digest matches, is not current, whatever else it says. Rides on *the maker's text and the checker's
  text for a type come from its one standard*, *a change to the
  standard reaches the maker's text and the checker's text*, *a text
  not current with its standard is reported*, *a text not current
  with its standard is made current, whatever the cause*, *the
  product decision record of this initiative's bet is made and
  checked from one standard*. (architect, 2026-09-05)
- C3 — the produced texts land where the checks already read, in the
  shape they read (the ADR's fourth consequence; the initiative's
  first no-go): the maker's text and the checker's text are written
  at the paths the checks and the linter read today and keep the type
  keys, `target-type`, Highlights, Scenarios, and Compile mapping
  those readers require, so no check's definition, no `criteria_path`
  (the input by which a check names the checker's text it reads),
  and no linter check changes for this — a production that drops a
  heading or a key a reader requires is a defect of the production,
  not a reason to change the reader. Rides on *the maker's text and
  the checker's text for a type come from its one standard*, *a check
  screens against the produced text as it did before*, *the product
  decision record of this initiative's bet is made and checked from
  one standard*. (architect, 2026-09-05)
- C4 — the checker's tests stay judged Given/When/Then, the same
  whoever produces them (the authority's direction in the ADR's
  Context): the type's fitness scenarios
  stand in its typedef as Given/When/Then, are produced into the
  checker's text in that form, and are applied by a reader — an
  author on a draft, a judge at a check — never turned into a test
  runner's tests; and the production yields the same text whoever
  runs it. Rides on *an author runs the checker's tests on their own
  draft before the check*, *a check screens against the produced text
  as it did before*. (architect, 2026-09-05)
- C5 — a change to a standard is a change to its typedef under that
  typedef's own rules (the ADR's first and fifth consequences): a
  type's rules and its tests change only by an edit to the type's
  typedef with a Document History row, under the artifact-typedef
  typedef as amended to require those sections, and the produced
  texts carry no version or history of their own; the amendments to
  the artifact-typedef, quality-guideline, and fitness-set typedefs
  each go through their own rules with a history row before any
  produced text relies on them. Rides on *a change to the standard
  reaches the maker's text and the checker's text*, *a text not
  current with its standard is made current, whatever the cause*.
  (architect, 2026-09-05)
- C6 — nothing loads into a maker or a check that does not trace to
  an approved typedef or a governed record (`governed-context`,
  `least-context`; the ADR's declined render-at-check-time option;
  the Decomposition): the maker's text a maker reads and the checker's
  text a check reads are each a committed file traceable through its
  source name and digest to a typedef standing approved — a text made
  inside a step and not committed, or produced from a typedef not yet
  approved, is read by no maker and no check; and the compiler and
  its rendering process are the lead shop's own tools, bounding no
  Bounded Context shop. Rides on *an author runs the checker's tests
  on their own draft before the check*, *a check screens against the
  produced text as it did before*, *the product decision record of
  this initiative's bet is made and checked from one standard*.
  (architect, 2026-09-05)

## Interaction types

None — the standard is read inside process steps; no core task
carries it (the initiative's For whom section).

## Scenarios

```gherkin
Feature: Typedef rendering
  The makers and checkers of every artifact type, and the authority
  when the standard changes,
  can work from one standard for an artifact type — the maker's text
  and the checker's text both from it, a change to the standard
  reaching both, and the checker's tests runnable by the author
  first —
  so that whoever makes an artifact and whoever checks it work from
  the same standard, when the standard changes it reaches both, and
  the checker's tests can be run by the author first.

  @bounded-context:shopsystem-product @feature:feat-typedef-rendering @hash:c343799a9f3f
  Scenario: the maker's text and the checker's text for a type come from its one standard
    Given an artifact type whose standard stands approved and states its writing rules and its tests
    When the maker's text and the checker's text for that type are read
    Then each names the one standard it is produced from and is current with it, and no rule in the maker's text and no test in the checker's text is absent from that standard

  @bounded-context:shopsystem-product @feature:feat-typedef-rendering @hash:a1764d43919d
  Scenario: an author runs the checker's tests on their own draft before the check
    Given an author holding a draft of an artifact of a type whose checker's text is produced from its standard
    When the author applies the checker's text to the draft
    Then the author has, recorded on the draft, a pass or a fail for each test, each test read as Given/When/Then, before any check runs

  @bounded-context:shopsystem-product @feature:feat-typedef-rendering @hash:78ebb1454bb7
  Scenario: a change to the standard reaches the maker's text and the checker's text
    Given an artifact type whose standard has changed since its maker's text and checker's text were produced
    When the process that keeps the texts current with the standard runs
    Then the maker's text and the checker's text each carry the change, re-produced together, and are current with the changed standard

  @bounded-context:shopsystem-product @feature:feat-typedef-rendering @hash:b45c64bb564a
  Scenario: a text not current with its standard is reported
    Given a maker's text or a checker's text that is not current with its standard, whatever the cause
    When the check over the texts runs
    Then the check reports that text as not current with its standard, naming the type and the text

  @bounded-context:shopsystem-product @feature:feat-typedef-rendering @hash:5a5094ad9e2c
  Scenario: a text not current with its standard is made current, whatever the cause
    Given a maker's text or a checker's text that is not current with its standard, whatever the cause
    When the process that keeps the texts current with the standard runs
    Then that text is produced from the standard as it now stands and is current with it

  @bounded-context:shopsystem-product @feature:feat-typedef-rendering @hash:5101a990271c
  Scenario: a check screens against the produced text as it did before
    Given a check that screens an artifact of a type against that type's checker's text
    When the checker's text it reads becomes one produced from the type's standard
    Then the check runs from its definition as it stood before, finds the checker's text where it read it before, and its definition's history records no change for this

  @bounded-context:shopsystem-product @feature:feat-typedef-rendering @hash:0569fe126e77
  Scenario: the product decision record of this initiative's bet is made and checked from one standard
    Given the product decision record type's maker's text and checker's text, each produced from that type's one standard and current with it
    And the product decision record of this initiative's bet, made by the PO role from that maker's text
    When the record's check screens it
    Then the record's history names the PO role as its maker, the maker's text it was made from, and the checker's text its check screened it against, both naming the same standard, and the check's verdict
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| The maker and the checker of an artifact work from different words | the framing ("whoever makes an artifact and whoever checks it work from different words, because the standard for an artifact type is written in several places by hand") | Scenario: the maker's text and the checker's text for a type come from its one standard — the framed remedy |
| A text that says something its standard does not | the framing's outcome ("the maker and the checker of an artifact work from the same standard" — its boundary: a rule or test in a text and not in the standard) | Scenario: the maker's text and the checker's text for a type come from its one standard — the Then's "no rule ... and no test ... is absent from that standard" |
| A change to the standard that does not reach both texts | the framing ("a change to it does not reliably reach both"); the framing's outcome ("a change to the standard reaches both") | Scenario: a change to the standard reaches the maker's text and the checker's text — the framed remedy; Scenario: a text not current with its standard is reported — a standard changed without its texts following is a text not current, whatever the cause |
| A hand edit to a produced text | the framing's outcome ("a change to the standard reaches both" — its boundary: a text changed other than through its standard); the design decision the initiative rests on ("a hand edit of a guideline or a fitness set — it is drift") | Scenario: a text not current with its standard is reported — the Given's "whatever the cause" holds a hand edit; Scenario: a text not current with its standard is made current, whatever the cause — the text that stands afterwards is produced from the standard, not from the edit. The case of reconciling by editing the typedef to match the edit: never — the standard stays as it was and the text is re-produced from it, the same scenario's Then ("produced from the standard as it now stands"), with C1 binding it |
| The checker's tests changed in form so the author cannot run them | the framing's outcome ("the checker's tests, the fitness set's scenarios, can be run by the author first") | Scenario: an author runs the checker's tests on their own draft before the check — the Then's "each test read as Given/When/Then" |
| An author skipping the self-run | the framing's outcome ("can be run by the author first" — the run is the author's option, not a gate) | Out of scope: the self-run is the author's option, not a gate — no scenario makes it a condition of the check, and skipping it is no failure of this feature |
| A type with no maker's text or no checker's text today | the For whom section ("every artifact type"; "Now: 0 of 22"); the initiative's Appetite ("The other 21 types follow as one batch") — the 21 include the types with no guideline or fitness set today | Out of scope: the second bet's feature (the batch of 21), which carries the type with no text today and the standard that states none is due; this bet is the proof on one type, whose standard has both texts |
| The batch of the other 21 types | the initiative's Appetite ("The other 21 types follow as one batch, a second bet sized after the proof") | Out of scope: the second bet's feature (the batch of 21), which carries the type with no text today and the standard that states none is due; converting the 21 is that bet's work, and this feature's measure is the initiative's target of 1 |
| The measure's instance — the product decision record, 0 to 1 | the For whom section ("Target: 1, the product decision record"); the Appetite (the proof) | Scenario: the product decision record of this initiative's bet is made and checked from one standard |
| The bet's record screened for form only | the initiative's Appetite ("a form-only screen counts as the check's use"); the product decision record type's rule that a record whose decider is the authority is checked for form only | Scenario: the product decision record of this initiative's bet is made and checked from one standard — the Then holds for a form-only screen: the check screened against the checker's text, whatever it screened for |
| A change to the checking processes themselves | the initiative's Appetite (no-go: "the checks are not what this bet changes") | Scenario: a check screens against the produced text as it did before — nothing a check does changes, only what it reads; any change to a check is out of scope, a later request |
| Checking that the standards of different types agree with each other | the initiative's Appetite (no-go: "struck by the authority as not needed here") | Out of scope: every scenario reads one type's texts against that type's standard; no scenario reads two standards against each other |
| A maker's text or a checker's text with no artifact type behind it | the For whom section ("every artifact type" — its boundary: a text that belongs to no type) | Out of scope: the framing is per artifact type; a source for such a text is a question the design decision the initiative rests on lists as not decided there |
| A produced text with no digest, or naming a source that is not its type's typedef | the architect's constraints (C2) | Scenario: a text not current with its standard is reported — the Given's "whatever the cause" holds a text whose digest cannot be matched to its typedef; Scenario: the maker's text and the checker's text for a type come from its one standard — the Then's "names the one standard it is produced from" |
| A production that drops a heading or a type key the checks or the linter read | the architect's constraints (C3); the design decision the initiative rests on ("a renderer that drops one breaks a check without changing it") | Scenario: a check screens against the produced text as it did before — the check finds the checker's text where and as it read it before; a check that cannot is a defect of the production, not of the check |
| A type's rules or tests changed other than by an edit to its typedef with a history row, or a produced text relying on a typedef amendment not yet made | the architect's constraints (C5) | Scenario: a change to the standard reaches the maker's text and the checker's text — the change the texts carry is the typedef's; Scenario: a check screens against the produced text as it did before — a text whose frontmatter its type's typedef does not yet admit is not read by the check as it read before. Out of scope, the other half: whether a typedef's own history is in order is the artifact-typedef typedef's check's and the linter's to judge, not a behavior of this feature |
| A production whose text differs by who ran it | the architect's constraints (C4) | Scenario: a text not current with its standard is reported — a production that differs by its runner leaves a committed text that differs from a fresh production, which is a text not current, whatever the cause, and is reported |
| A produced text carrying a version or a Document History of its own | the architect's constraints (C5) | Scenario: a text not current with its standard is reported — a text with its own history differs from a fresh production, so it is not current and is reported; Scenario: the maker's text and the checker's text for a type come from its one standard — the Then's "is current with it"; C5 binds the form: a text's history is its standard's |
| A text made inside a step and not committed, or produced from a typedef not yet approved | the architect's constraints (C6) | Out of scope: the process that keeps the texts current names its own inputs (approved typedefs) and outputs (committed texts) in its definition, and its own screen judges that; no scenario here is its cover |
| A Bounded Context shop's own guidelines and fitness sets | the architect's constraints (C6); the initiative's Decomposition ("no Bounded Context is touched") | Out of scope: no Bounded Context exists on this branch, and the design decision the initiative rests on binds none — extending the rule to a Bounded Context shop is a guardrail decision, not this feature's |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Authored by the PO role alone in the feature-authoring draft step, from init-typedef-rendering's Framing and For whom sections, with its Appetite as the source of the proof scenario; nine scenarios, all owned by the lead shop per the initiative's Decomposition; interaction types none per its For whom. Scenario hashes: the authoring session had no shell, so the draft carried `@hash:pending` and the lead-pm filled the values by the repository convention — sha256 of the scenario's text (its Scenario line and steps), first twelve hex digits, as in feat-request-routing — on 2026-09-05, before the check. |
| 2 | 2026-09-05 | update | Designer's criteria: none due, at the add-usability step. |
| 3 | 2026-09-05 | update | Architect's constraints C1–C6 at the add-constraints step. |
| 4 | 2026-09-05 | review | PO output check round 1 (judge: claude-fable-5-1 / screen prompt v6): one confident — "current with" defined twice, the Vocabulary's (the standard unchanged since production) and C2's (the digest matches), neither holding a hand edit — and eight wobbly, ruled by the PM role: the self-run-skipped row covered by scenario 8 rather than excluded; C4's same-text-whoever case covered by scenario 4; C5's no-version-or-history clause with no Edges row; scenario 2's Then not observable; scenario 7 (no text due) resting on no framing words; the Vocabulary below the constraints it glosses, with "the linter", the three section names, and the three typedef names unglossed; the principle ids in C2, C4, and C5; the Vocabulary withholding the document C1 names; the v1 row's hash sentence stale. |
| 4 | 2026-09-05 | update | Round 1 repairs: "current with" defined once in Vocabulary — the text is what a fresh production from the standard as it now stands would yield, holding a changed standard and a hand edit alike — and every Then reads it so; the self-run-skipped row made out of scope with its reason; C4's row excluded as the rendering process's own check's case; an Edges row added for a produced text carrying a version or history, covered by scenario 1's Then with C5 binding the form; scenario 2's Then made observable ("recorded on the draft"; new hash); scenario 7's row traced through the Appetite's batch — the 21 include the types with no guideline or fitness set today; the Vocabulary moved above the constraints and glossing the linter, Highlights, Scenarios, Compile mapping, and the artifact-typedef, quality-guideline, and fitness-set typedefs; the Vocabulary names the typedef as the standard's document per the design decision, "not this feature's to say" dropped; the v1 row's hash sentence amended. Architect's passages edited on the PM role's ruling, substance kept: C2 now requires the text itself, not only the digest, to match a fresh production; the principle ids dropped from C2, C4, and C5. |
| 5 | 2026-09-05 | review | PO output check round 2 (judge: claude-fable-5-1 / screen prompt v6): no confident finding; eight wobbly, ruled by the PM role — the proof scenario's When ("passes its check") unreachable by a screened-and-failed record; the two batch-case scenarios (a type with no text today; a standard stating none is due) belonging to the second bet, not this proof; the C4 row's exclusion contradicting scenario 4's "whatever the cause"; the C5 row mixing a check case with a linter case; C6 placing the compiler's definitions under an operational contract that has no artifact; `criteria_path` unglossed in C3; the designer's sentence naming the feature-authoring step for a type whose process is not feature-authoring; the Vocabulary a paragraph, not a list. |
| 5 | 2026-09-05 | update | Round 2 repairs: the proof scenario's When is "the record's check screens it" and its Then ends with "the check's verdict" (new hash); scenarios *a type with no maker's text or no checker's text has both once its standard states them* and *a type whose standard states that no text is due has none and is not reported* removed with their ownership lines — the second bet's feature carries them — and their Edges rows made out of scope to that feature; the C4 row covered by *a text not current with its standard is reported*; the C5 row keeps *a check screens against the produced text as it did before* for the check half and marks the linter half out of scope; the designer's sentence reads "inside the authoring step of that type's process"; the Vocabulary a definition list, one term per entry, in the scenarios' order of use then the constraints'. Architect's passages edited on the PM role's ruling, substance kept or deferred: C5's "a statement that no text is due" clause trimmed (no scenario here binds it; the second feature's), its rides-on list and C2's cut to the scenarios that remain; C6 says the compiler and its rendering process are the lead shop's own tools, bounding no Bounded Context shop, the operational-contract clause dropped; C3 glosses `criteria_path`. Seven scenarios stand. |
| 6 | 2026-09-05 | review | PO output check round 3, the cap (judge: claude-fable-5-1 / screen prompt v6): two confident — the not-committed / not-approved Edges row covered by scenarios whose Then does not reach it; "the compiler" used in the constraints and unglossed — and five wobbly, ruled by the PM role: the proof scenario's Given not holding the record it screens; scenarios 3 and 5 overlapping (held: both stand, 3 to carry what 5 does not); the narrative's so-that missing the framing's third clause; the version-or-history row covered by scenario 1's Then alone; the hand-edit row silent on reconciling by editing the typedef. |
| 6 | 2026-09-05 | update | Post-cap repairs, disclosed and not re-screened: the not-committed / not-approved row made out of scope — the process that keeps the texts current names its inputs and outputs in its definition and its own screen judges that; Vocabulary entry for *the compiler*; the proof scenario gains a Given ("And the product decision record of this initiative's bet, made by the PO role from that maker's text"; new hash); scenario 3's Then reads "each carry the change, re-produced together, and are current with the changed standard" (new hash) — what scenario 5, one text whatever the cause, does not say; the narrative's so-that carries the framing's third clause ("and the checker's tests can be run by the author first") in the section and the block head, not hashed; the version-or-history row names *a text not current with its standard is reported* as cover; the hand-edit row adds the case of reconciling by editing the typedef — never, the text is re-produced — with C1 binding it. |
| 6 | 2026-09-05 | state | `draft` → `checked`: the PM role's pass; no finding in any round named a criterion the feature still fails; the cap's two confident findings were an Edges row's coverage and a gloss, repaired past the cap and disclosed. |
| 7 | 2026-09-05 | state | `checked` → `assigned`: the scenario-assignment record step. One assignment entry — context shopsystem-product (the lead shop), scenarios @hash:c343799a9f3f, @hash:a1764d43919d, @hash:78ebb1454bb7, @hash:b45c64bb564a, @hash:5a5094ad9e2c, @hash:5101a990271c, @hash:0569fe126e77. Pre-state read: the initiative's Decomposition ruling — no Bounded Context touched; the typedef, the compiler, and the renderings in the lead shop's tree, read from its records: the product decision record's standard stands as three hand-written documents, each with its own frontmatter, version, and Document History and none marked produced or naming a source — the product-decision-record typedef at v6 (approved 2026-08-31; owner rulings of 2026-09-02), the product-decision-record guideline at v2 (approved 2026-08-31; Rules as its one section), and the product-decision-record fitness set at v3 (approved 2026-08-26; judged, not executable; Scenarios and Compile mapping); no compiler produces either text from the typedef — `basis/tools/` holds compile_principles.py, compile_process.py, compile_role.py, and lint_basis.py, none naming the type — so no maker's text or checker's text is current with a standard in this feature's sense today, which is the 0 of 1 the initiative measures from; the owning shop matches the Contributors section for every scenario; the feature repository swept in full — four artifacts, this feature, feat-request-routing, feat-roles-availability, and feat-skills-availability, no conflict: the three assigned features specify the recording and routing of asks and the small-change lane, and checks over rendered definitions (process definitions to `.claude/skills/`, role definitions to `.claude/agents/`), and no scenario of any names a typedef, a guideline, a fitness set, a maker's or checker's text, or the product decision record; the two touch-points run the same way as these scenarios — feat-request-routing's C8 changes the decision-brief typedef through the typedef with its history row, as C5 here requires of a standard, and the two availability features' current-with checks over renderings are the pattern this feature applies to a type's texts, contradicting none; no BC contract in the pre-state — the decomposition names no context whose contract bears on these behaviors, and none exists on this branch. Sent: none — the owning shop is the lead shop itself; the freeze bars dispatch and no Bounded Context exists to receive; the gap stands as lead-ki66p. |
| 8 | 2026-09-05 | update | Delivered in the lead shop's own tree under the assignment: artifact-typedef typedef v3, quality-guideline v5 and fitness-set v3 typedefs, product-decision-record typedef v7 (scenario 1; C1, C5); compile_typedef.py with write and --check (scenarios 1, 4, 5; C2, C3, C4); the typedef-rendering process v4, approved after three screen rounds with the maker's own check first, rendered, first run clean (scenarios 3, 4, 5; C6); the proof — pdr-2026-09-05-bet-typedef-rendering made by the PO from the produced guideline, the author's own run of the produced fitness set's scenarios recorded on the draft (scenario 2), screened by the check from the same rendering, checked (scenario 7; scenario 6: no check definition changed). Not demonstrated by a run this session: a standard changed after production (scenario 3's Given) and a hand edit (scenario 5's Given) — the definitions and the compiler's --check carry them and the process's screen judged them. |
