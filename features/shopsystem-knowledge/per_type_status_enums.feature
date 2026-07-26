Feature: shopsystem-knowledge — per-type status enums (ADR-069 additive deltas)

  ADR-069 states each artifact kind's status enum as a per-type delta on ADR-067's
  base schema — the base schema carries the status FIELD, each kind constrains its
  VALUES. The generic enum-checking mechanism (an out-of-enum status is reported
  non-conforming and the offending value named) is already pinned in
  frontmatter_schema_conformance.feature using the candidate example, and is not
  restated here. This feature pins the specific per-type enum membership ADR-069
  states for the kinds whose enum no scenario pins yet: adr and pdr share the
  decision lifecycle proposed | accepted | superseded | rejected (D1/D2); brief
  carries the distinct delivery lifecycle draft | ready | delivered | withdrawn
  (D3); session-record carries open | closed (D6); and prioritization-record
  carries draft | active | superseded (D8). The candidate enum (committed) and the
  intent-record enum (recorded) are already reconciled in their own per-type
  features and are deliberately not restated. The current-state versioned enum
  (current | superseded, D7) is pinned in current_state_versioned_schema.feature.
  Behavior altitude: frontmatter validation against the per-type status enum, not
  the lifecycle semantics of who moves a document between statuses.

  Scenario Outline: a status value inside its kind's enum conforms
    Given a <kind> artifact whose frontmatter carries a status value of "<status>"
    And "<status>" is a member of the <kind> status enum
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as conforming
    And it does not report an unrecognized-status diagnosis

    Examples:
      | kind                  | status     |
      | adr                   | proposed   |
      | adr                   | accepted   |
      | adr                   | superseded |
      | adr                   | rejected   |
      | pdr                   | proposed   |
      | pdr                   | accepted   |
      | pdr                   | superseded |
      | pdr                   | rejected   |
      | brief                 | draft      |
      | brief                 | ready      |
      | brief                 | delivered  |
      | brief                 | withdrawn  |
      | session-record        | open       |
      | session-record        | closed     |
      | prioritization-record | draft      |
      | prioritization-record | active     |
      | prioritization-record | superseded |

  Scenario Outline: a status value outside its kind's enum is reported non-conforming and names the offending value
    Given a <kind> artifact whose frontmatter carries a status value of "<status>"
    And "<status>" is not a member of the <kind> status enum
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming for an unrecognized status
    And the diagnosis names the offending value "<status>"

    Examples:
      | kind                  | status    |
      | adr                   | committed |
      | pdr                   | briefed   |
      | brief                 | accepted  |
      | session-record        | recorded  |
      | prioritization-record | accepted  |
