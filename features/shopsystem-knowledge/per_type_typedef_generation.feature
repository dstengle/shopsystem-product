@bc:shopsystem-knowledge @origin:lead-mfnt
Feature: shopsystem-knowledge — per-type typedef single-sources every artifact type

  ADR-059 makes each artifact FORMAT a generated projection of one source: a
  per-type typedef. PDR-032 item 2 fixes the type system at exactly eight artifact
  types — intent-record, candidate, session-record, prioritization-record, brief,
  pdr, adr and current-state. This feature pins that the type system is complete:
  every one of the eight types is single-sourced by its own typedef, and each
  typedef drives the ADR-059 generator to emit that type's authoring template and
  schema fragment, both marked generated and read-only under the same drift check.
  The generic drift-gate behavior (matches passes, hand-edit fails, regeneration is
  byte-stable) is pinned once in the typedef drift-check feature; this feature pins
  the per-type coverage — that no type is missing a typedef and no extra typedef
  models a type outside the recognized eight. The shape is type-general with one
  documented exception: current-state is a single living document stewarded in
  place (its incorporates list is what the accepted-decision lifecycle rule keys
  on), not an append-only numbered-series instance like the record and decision
  types — so its generated template reflects the living-document shape while still
  riding the same generated/read-only/drift-gated discipline. Every generated
  schema fragment requires the shared field set including description (the ADR-059
  reconciliation that keeps the L0 card projection's fields present). Behavior
  altitude: per-type typedef existence, generated template and schema fragment, and
  drift-gate coverage — not the generator's internal emission logic.

  @scenario_hash:1afdfb1b5cfcbe71
  Scenario Outline: each artifact type is single-sourced by its own typedef that drives the generator
    Given the knowledge context's set of per-type artifact typedefs
    When the knowledge context runs the format generator over that typedef set
    Then the set contains a typedef for the "<type>" artifact type
    And the generator emits a template and a schema fragment for "<type>" from its typedef
    And the generated template and schema fragment for "<type>" are marked generated and read-only
    And the drift check covers the generated template and schema fragment for "<type>"

    Examples:
      | type                  |
      | intent-record         |
      | candidate             |
      | session-record        |
      | prioritization-record |
      | brief                 |
      | pdr                   |
      | adr                   |
      | current-state         |

  @scenario_hash:1a1b80bd796ead01
  Scenario: the typedef set covers exactly the eight artifact types
    Given the knowledge context's set of per-type artifact typedefs
    When the knowledge context enumerates the artifact types that have a typedef
    Then the enumerated set is exactly intent-record, candidate, session-record, prioritization-record, brief, pdr, adr and current-state
    And no recognized artifact type lacks a typedef
    And no typedef declares a type outside the eight recognized artifact types

  @scenario_hash:d038584b238f2fee
  Scenario: the current-state typedef generates a living stewarded document rather than an append-only instance
    Given the current-state typedef, which declares a single living document stewarded in place with an incorporates list rather than an append-only numbered-series record
    When the knowledge context runs the format generator over the current-state typedef
    Then it emits a current-state template shaped as a single stewarded living document carrying an incorporates list
    And it emits a schema fragment for current-state from the same typedef
    And the generated current-state template and schema fragment are marked generated and read-only under the same drift check as every other type

  @scenario_hash:3bcea617f9a026d9
  Scenario: every type's generated schema fragment requires the shared field set including description
    Given the knowledge context's set of per-type artifact typedefs
    When the knowledge context runs the format generator over the typedef set
    Then every generated schema fragment requires the shared field set type, id, title, description, status, created, updated and authors
    And no generated schema fragment omits description from its required set
