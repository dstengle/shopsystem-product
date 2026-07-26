Feature: shopsystem-knowledge — current-state is a versioned, supersede-able instance (ADR-069 D7)

  ADR-069 D7 resolves the standing three-way current-state conflict by deciding
  current-state is VERSIONED: a numbered, supersede-able instance, not a single
  living document rewritten in place. This flips the typedef's document_shape from
  living to instance so the model finally agrees with the versioned id pattern
  current-state-NNN and the status enum current | superseded the same typedef
  already carries. This feature pins those per-type schema facts: the versioned id
  pattern, the current | superseded status enum (replacing the singleton's
  out-of-enum status: live), the required sections Current decisions and
  Stewardship, and the required incorporates edge (the list of accepted PDR/ADR ids
  the snapshot reflects). It DIRECTLY SUPERSEDES the living-document model pinned in
  per_type_typedef_generation.feature — the scenario "the current-state typedef
  generates a living stewarded document rather than an append-only instance" is
  contradicted by this feature and is named for retirement at dispatch. Scope note:
  this feature pins the SCHEMA/conformance model only; ADR-069 explicitly defers the
  migration of the live singleton current-state.md (id current-state, status live)
  into current-state-001 (status current) as a scoped follow-on, and that migration
  is NOT pinned here.

  Scenario: a versioned current-state instance with a current-state-NNN id and status current conforms
    Given a current-state artifact whose id is "current-state-001" and whose status is "current"
    And it carries an incorporates list naming the accepted decisions the snapshot reflects
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as conforming
    And it does not report an unrecognized-status diagnosis

  Scenario Outline: each value of the current-state versioned status enum conforms
    Given a current-state artifact whose frontmatter carries a status value of "<status>"
    And "<status>" is a member of the current-state status enum current or superseded
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as conforming
    And it does not report an unrecognized-status diagnosis

    Examples:
      | status     |
      | current    |
      | superseded |

  Scenario: the singleton status live is reported non-conforming against the versioned current or superseded enum
    Given a current-state artifact whose frontmatter carries a status value of "live"
    And "live" is not a member of the current-state status enum current or superseded
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming for an unrecognized status
    And the diagnosis names the offending value "live"

  Scenario: a bare current-state id is reported non-conforming against the versioned current-state-NNN pattern
    Given a current-state artifact whose id is "current-state" rather than the current-state-NNN pattern its type now requires
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming for an id that does not match its type pattern
    And the diagnosis names the offending id and the expected current-state-NNN pattern

  Scenario: a current-state document carrying Current decisions and Stewardship passes body conformance
    Given a current-state document whose body carries Current decisions and Stewardship, its type's required-section set
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as conforming on body structure
    And it names no missing required section

  Scenario: a current-state document missing the Stewardship section is reported non-conforming and names it
    Given a current-state document whose body carries Current decisions but omits the Stewardship section its type's required-section set demands
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as non-conforming for a missing required section
    And the diagnosis names Stewardship as the missing section

  Scenario: a current-state artifact omitting the required incorporates field is reported non-conforming and names it
    Given a current-state artifact whose frontmatter carries every shared required field but omits the incorporates field its type additionally requires
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming
    And the diagnosis names incorporates as the missing type-required field
