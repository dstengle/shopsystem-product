@bc:shopsystem-knowledge @origin:lead-4vvdo
Feature: shopsystem-knowledge — per-type typedefs state deltas only, never re-declaring base fields (ADR-069 D9)

  ADR-069 D9 makes the additive discipline checkable: each per-type typedef states
  ONLY its own delta over ADR-067's base schema — its required body sections, its
  status enum, and its edge participation — and never re-declares a base shared
  field. The base frontmatter (type, id, title, status, created, updated, authors,
  description), the three materialized edge pairs, and the tags / distribution /
  external-references fields are inherited from the base schema and single-sourced
  there; a per-type typedef that re-declares any of them is a defect, because it
  installs a second source for a base field that can drift from ADR-067. This
  feature pins that a per-type typedef re-declaring a base shared field is reported
  as a defect, and that a typedef stating only its per-type deltas passes. Behavior
  altitude: the per-type typedef / generator drift surface, not the generator's
  internal emission logic. Enforcement-host note: ADR-069 asserts the re-declaration
  is a defect but names no specific check host — the discriminator against the
  knowledge BC's pre-state is the architect's at dispatch (see authoring report).

  @scenario_hash:e4d8b3c856424c18
  Scenario: a per-type typedef re-declaring a base shared field is reported as a defect
    Given a per-type typedef that, beyond its per-type deltas, re-declares the base shared field distribution the base schema already governs
    When the knowledge context runs the additive-discipline check over the per-type typedefs
    Then it reports a base-field-redeclaration defect naming the typedef and the re-declared field distribution
    And the finding carries its check-id and a remediation to remove the re-declared base field and inherit it from the base schema
    And the aggregate verdict exits non-zero

  @scenario_hash:d5e1af8a4c00ffda
  Scenario: a per-type typedef stating only its per-type deltas and re-declaring no base field passes
    Given a per-type typedef that declares only its required body sections, its status enum and its edge participation, re-declaring no base shared field
    When the knowledge context runs the additive-discipline check over the per-type typedefs
    Then it reports no base-field-redeclaration defect for that typedef
    And the aggregate verdict exits zero
