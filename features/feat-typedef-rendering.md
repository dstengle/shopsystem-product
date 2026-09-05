---
type: feature
id: feat-typedef-rendering
name: Typedef rendering
status: draft
version: 1
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

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Authored by the PO role alone in the feature-authoring draft step, from init-typedef-rendering's Framing and For whom sections, with its Appetite as the source of the proof scenario; nine scenarios, all owned by the lead shop per the initiative's Decomposition; interaction types none per its For whom. Scenario hashes stand `@hash:pending`: the authoring session had no shell, so the values — sha256 of the scenario's text (its Scenario line and steps), first twelve hex digits, as in feat-request-routing — are filled by the lead-pm after the draft and before the check, disclosed here. |
