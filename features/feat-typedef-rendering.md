---
type: feature
id: feat-typedef-rendering
name: Typedef rendering
status: draft
version: 3
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
  the same standard, and when the standard changes it reaches both.

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
- *a type with no maker's text or no checker's text has both once its standard states them* — shopsystem-product (the lead shop)
- *a type whose standard states that no text is due has none and is not reported* — shopsystem-product (the lead shop)
- *a check screens against the produced text as it did before* — shopsystem-product (the lead shop)
- *the product decision record of this initiative's bet is made and checked from one standard* — shopsystem-product (the lead shop)

No usability or accessibility criteria are due on this feature: its interaction types are none, and no entry in the core-task list carries reading a standard or a text produced from it, or running the checker's tests on a draft — the nearest, *submit output for a check*, begins after the author's self-run in scenario 2, which is a reading inside the feature-authoring step, not an option an interaction type must offer (designer, 2026-09-05).

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
  (the ADR's second consequence; `knowable-shape`): a produced text's
  frontmatter marks it as produced, names the typedef it is produced
  from, and carries the source-digest of that typedef's text, and
  "current with" in every Then means that digest matches a fresh
  production from the typedef as it stands — a text with no digest,
  or naming a source that is not its type's typedef, is not current,
  whatever else it says. Rides on *the maker's text and the checker's
  text for a type come from its one standard*, *a change to the
  standard reaches the maker's text and the checker's text*, *a text
  not current with its standard is reported*, *a text not current
  with its standard is made current, whatever the cause*, *a type
  with no maker's text or no checker's text has both once its
  standard states them*, *the product decision record of this
  initiative's bet is made and checked from one standard*.
  (architect, 2026-09-05)
- C3 — the produced texts land where the checks already read, in the
  shape they read (the ADR's fourth consequence; the initiative's
  first no-go): the maker's text and the checker's text are written
  at the paths the checks and the linter read today and keep the type
  keys, `target-type`, Highlights, Scenarios, and Compile mapping
  those readers require, so no check's definition, no `criteria_path`,
  and no linter check changes for this — a production that drops a
  heading or a key a reader requires is a defect of the production,
  not a reason to change the reader. Rides on *the maker's text and
  the checker's text for a type come from its one standard*, *a check
  screens against the produced text as it did before*, *the product
  decision record of this initiative's bet is made and checked from
  one standard*. (architect, 2026-09-05)
- C4 — the checker's tests stay judged Given/When/Then, the same
  whoever produces them (the authority's direction in the ADR's
  Context; `actor-neutral-discipline`): the type's fitness scenarios
  stand in its typedef as Given/When/Then, are produced into the
  checker's text in that form, and are applied by a reader — an
  author on a draft, a judge at a check — never turned into a test
  runner's tests; and the production yields the same text whoever
  runs it. Rides on *an author runs the checker's tests on their own
  draft before the check*, *a check screens against the produced text
  as it did before*. (architect, 2026-09-05)
- C5 — a change to a standard is a change to its typedef under that
  typedef's own rules (the ADR's first and fifth consequences;
  `bidirectional-conformance`): a type's rules, its tests, and a
  statement that no text is due for it change only by an edit to the
  type's typedef with a Document History row, under the
  artifact-typedef typedef as amended to require those sections, and
  the produced texts carry no version or history of their own; the
  amendments to the artifact-typedef, quality-guideline, and
  fitness-set typedefs each go through their own rules with a history
  row before any produced text relies on them. Rides on *a change to
  the standard reaches the maker's text and the checker's text*, *a
  text not current with its standard is made current, whatever the
  cause*, *a type with no maker's text or no checker's text has both
  once its standard states them*, *a type whose standard states that
  no text is due has none and is not reported*. (architect,
  2026-09-05)
- C6 — nothing loads into a maker or a check that does not trace to
  an approved typedef or a governed record (`governed-context`,
  `least-context`; the ADR's declined render-at-check-time option;
  the Decomposition): the maker's text a maker reads and the checker's
  text a check reads are each a committed file traceable through its
  source name and digest to a typedef standing approved — a text made
  inside a step and not committed, or produced from a typedef not yet
  approved, is read by no maker and no check; and the compiler and
  its rendering process are the lead shop's own tools, bounding no
  Bounded Context shop, whose definitions stand under its own
  operational contract. Rides on *an author runs the checker's tests
  on their own draft before the check*, *a check screens against the
  produced text as it did before*, *the product decision record of
  this initiative's bet is made and checked from one standard*.
  (architect, 2026-09-05)

Vocabulary: *standard* is the framing's word for what the maker and
the checker of an artifact of a type work from — the type's writing
rules and the tests an instance is checked against; which document of
the lead shop's tree is that standard is the design decision the
initiative rests on
([adr-2026-09-05-typedef-rendering](../decisions/adr-2026-09-05-typedef-rendering.md)),
not this feature's to say. The *maker's text* is what a maker of an
artifact of the type reads for its writing rules — the glossary's
`guideline`. The *checker's text* is what a check of an artifact of
the type screens it against — the glossary's `fitness set`: judged
Given/When/Then scenarios, the *checker's tests*. A text is *produced
from* a standard when it is, in the glossary's term, a rendering of
it — never edited by hand, never the source — and *current with* the
standard when the standard has not changed since the text was
produced from it; a text names the standard it is produced from, so a
reader can tell both from the text. *The check over the texts* is the
check that reads each text against its standard and reports one that
is not current, distinct from the checks that screen an artifact
against the checker's text (the PO output check among them); it
belongs to the process that keeps the texts current. *The proof* is
the initiative's Appetite: the product decision record of this
initiative's bet, made by the PO role from the maker's text and
screened by its check against the checker's text, the check's use
counting whether or not it screens for form only.

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
  the same standard, and when the standard changes it reaches both.

  @feature:feat-typedef-rendering @hash:c343799a9f3f
  Scenario: the maker's text and the checker's text for a type come from its one standard
    Given an artifact type whose standard stands approved and states its writing rules and its tests
    When the maker's text and the checker's text for that type are read
    Then each names the one standard it is produced from and is current with it, and no rule in the maker's text and no test in the checker's text is absent from that standard

  @feature:feat-typedef-rendering @hash:da49c43d4fb3
  Scenario: an author runs the checker's tests on their own draft before the check
    Given an author holding a draft of an artifact of a type whose checker's text is produced from its standard
    When the author applies the checker's text to the draft
    Then the author has a pass or a fail on the draft for each test, each test read as Given/When/Then, before any check runs

  @feature:feat-typedef-rendering @hash:dbd6fbd3b4c6
  Scenario: a change to the standard reaches the maker's text and the checker's text
    Given an artifact type whose standard has changed since its maker's text and checker's text were produced
    When the process that keeps the texts current with the standard runs
    Then the maker's text and the checker's text each carry the change and are current with the changed standard

  @feature:feat-typedef-rendering @hash:b45c64bb564a
  Scenario: a text not current with its standard is reported
    Given a maker's text or a checker's text that is not current with its standard, whatever the cause
    When the check over the texts runs
    Then the check reports that text as not current with its standard, naming the type and the text

  @feature:feat-typedef-rendering @hash:5a5094ad9e2c
  Scenario: a text not current with its standard is made current, whatever the cause
    Given a maker's text or a checker's text that is not current with its standard, whatever the cause
    When the process that keeps the texts current with the standard runs
    Then that text is produced from the standard as it now stands and is current with it

  @feature:feat-typedef-rendering @hash:55d00c65dfac
  Scenario: a type with no maker's text or no checker's text has both once its standard states them
    Given an artifact type with no maker's text or no checker's text, whose standard stands approved and states its writing rules and its tests
    When the process that keeps the texts current with the standard runs
    Then the type has a maker's text and a checker's text, each produced from that standard and current with it

  @feature:feat-typedef-rendering @hash:568474cbd484
  Scenario: a type whose standard states that no text is due has none and is not reported
    Given an artifact type whose standard stands approved and states that no maker's text, or no checker's text, is due for it
    When the check over the texts runs
    Then no such text stands for the type and the check reports nothing for it

  @feature:feat-typedef-rendering @hash:5101a990271c
  Scenario: a check screens against the produced text as it did before
    Given a check that screens an artifact of a type against that type's checker's text
    When the checker's text it reads becomes one produced from the type's standard
    Then the check runs from its definition as it stood before, finds the checker's text where it read it before, and its definition's history records no change for this

  @feature:feat-typedef-rendering @hash:f0a39652ddd4
  Scenario: the product decision record of this initiative's bet is made and checked from one standard
    Given the product decision record type's maker's text and checker's text, each produced from that type's one standard and current with it
    When the product decision record of this initiative's bet passes its check
    Then the record's history names the PO role as its maker, the maker's text it was made from, and the checker's text its check screened it against, both texts naming the same standard, and the record stands checked
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| The maker and the checker of an artifact work from different words | the framing ("whoever makes an artifact and whoever checks it work from different words, because the standard for an artifact type is written in several places by hand") | Scenario: the maker's text and the checker's text for a type come from its one standard — the framed remedy |
| A text that says something its standard does not | the framing's outcome ("the maker and the checker of an artifact work from the same standard" — its boundary: a rule or test in a text and not in the standard) | Scenario: the maker's text and the checker's text for a type come from its one standard — the Then's "no rule ... and no test ... is absent from that standard" |
| A change to the standard that does not reach both texts | the framing ("a change to it does not reliably reach both"); the framing's outcome ("a change to the standard reaches both") | Scenario: a change to the standard reaches the maker's text and the checker's text — the framed remedy; Scenario: a text not current with its standard is reported — a standard changed without its texts following is a text not current, whatever the cause |
| A hand edit to a produced text | the framing's outcome ("a change to the standard reaches both" — its boundary: a text changed other than through its standard); the design decision the initiative rests on ("a hand edit of a guideline or a fitness set — it is drift") | Scenario: a text not current with its standard is reported — the Given's "whatever the cause" holds a hand edit; Scenario: a text not current with its standard is made current, whatever the cause — the text that stands afterwards is produced from the standard, not from the edit |
| The checker's tests changed in form so the author cannot run them | the framing's outcome ("the checker's tests, the fitness set's scenarios, can be run by the author first") | Scenario: an author runs the checker's tests on their own draft before the check — the Then's "each test read as Given/When/Then" |
| An author skipping the self-run | the framing's outcome ("can be run by the author first" — the run is the author's option, not a gate) | Scenario: a check screens against the produced text as it did before — the check screens against the checker's text whether or not the author ran it; nothing in the feature makes the self-run a condition of the check |
| A type with no maker's text or no checker's text today | the For whom section ("every artifact type"; "Now: 0 of 22") | Scenario: a type with no maker's text or no checker's text has both once its standard states them; Scenario: a type whose standard states that no text is due has none and is not reported |
| The batch of the other 21 types | the initiative's Appetite ("The other 21 types follow as one batch, a second bet sized after the proof") | Out of scope of this feature: the two batch-case scenarios state what holds for any one such type once its standard states its rules and tests, or states that none is due; converting the 21 is the second bet's work, not this feature's, and its measure is the initiative's target of 1 |
| The measure's instance — the product decision record, 0 to 1 | the For whom section ("Target: 1, the product decision record"); the Appetite (the proof) | Scenario: the product decision record of this initiative's bet is made and checked from one standard |
| The bet's record screened for form only | the initiative's Appetite ("a form-only screen counts as the check's use"); the product decision record type's rule that a record whose decider is the authority is checked for form only | Scenario: the product decision record of this initiative's bet is made and checked from one standard — the Then holds for a form-only screen: the check screened against the checker's text, whatever it screened for |
| A change to the checking processes themselves | the initiative's Appetite (no-go: "the checks are not what this bet changes") | Scenario: a check screens against the produced text as it did before — nothing a check does changes, only what it reads; any change to a check is out of scope, a later request |
| Checking that the standards of different types agree with each other | the initiative's Appetite (no-go: "struck by the authority as not needed here") | Out of scope: every scenario reads one type's texts against that type's standard; no scenario reads two standards against each other |
| A maker's text or a checker's text with no artifact type behind it | the For whom section ("every artifact type" — its boundary: a text that belongs to no type) | Out of scope: the framing is per artifact type; a source for such a text is a question the design decision the initiative rests on lists as not decided there |
| A produced text with no digest, or naming a source that is not its type's typedef | the architect's constraints (C2) | Scenario: a text not current with its standard is reported — the Given's "whatever the cause" holds a text whose digest cannot be matched to its typedef; Scenario: the maker's text and the checker's text for a type come from its one standard — the Then's "names the one standard it is produced from" |
| A production that drops a heading or a type key the checks or the linter read | the architect's constraints (C3); the design decision the initiative rests on ("a renderer that drops one breaks a check without changing it") | Scenario: a check screens against the produced text as it did before — the check finds the checker's text where and as it read it before; a check that cannot is a defect of the production, not of the check |
| A type's rules or tests changed other than by an edit to its typedef with a history row, or a produced text relying on a typedef amendment not yet made | the architect's constraints (C5) | Scenario: a change to the standard reaches the maker's text and the checker's text — the change the texts carry is the typedef's; Scenario: a check screens against the produced text as it did before — a text whose frontmatter its type's typedef does not yet admit is not found by the linter as it read before; whether a typedef's own history is in order is judged by the artifact-typedef typedef's check and the linter, not a behavior of this feature |
| A production whose text differs by who ran it | the architect's constraints (C4) | Scenario: a text not current with its standard is reported — a fresh production that differs from the committed text is the mismatch the check reports, whoever produced either |
| A text made inside a step and not committed, or produced from a typedef not yet approved | the architect's constraints (C6) | Scenario: a check screens against the produced text as it did before — the check reads a committed file where it read before; Scenario: the maker's text and the checker's text for a type come from its one standard — the Given's "standard stands approved"; a production run over a draft typedef is a case for the rendering process's own check, not a behavior of this feature |
| A Bounded Context shop's own guidelines and fitness sets | the architect's constraints (C6); the initiative's Decomposition ("no Bounded Context is touched") | Out of scope: no Bounded Context exists on this branch, and the design decision the initiative rests on binds none — extending the rule to a Bounded Context shop is a guardrail decision, not this feature's |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Authored by the PO role alone in the feature-authoring draft step, from init-typedef-rendering's Framing and For whom sections, with its Appetite as the source of the proof scenario; nine scenarios, all owned by the lead shop per the initiative's Decomposition; interaction types none per its For whom. Scenario hashes stand `@hash:pending`: the authoring session had no shell, so the values — sha256 of the scenario's text (its Scenario line and steps), first twelve hex digits, as in feat-request-routing — are filled by the lead-pm after the draft and before the check, disclosed here. |
| 2 | 2026-09-05 | update | Designer's criteria: none due, at the add-usability step. |
| 3 | 2026-09-05 | update | Architect's constraints C1–C6 at the add-constraints step. |
