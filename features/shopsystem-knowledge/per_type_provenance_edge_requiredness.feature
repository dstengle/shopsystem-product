Feature: shopsystem-knowledge — derives-from requiredness is a per-type constraint (ADR-069 finding 2)

  ADR-069 finding 2 establishes that derives-from requiredness is a PER-TYPE
  constraint, not a base-schema one: it appears in type_required_fields for adr,
  pdr and brief only, and is non_empty only for adr. The REQUIRED side is already
  pinned in frontmatter_schema_conformance.feature — an adr requires a non-empty
  derives-from, and a pdr requires the field with an empty list permitted (the
  empty-pdr case being a lifecycle warning, not a schema failure). This feature
  pins the net-new NEGATIVE side: the kinds ADR-069 states do NOT schema-require
  derives-from conform when it is absent — intent-record as the head of the
  provenance spine (D4), candidate whose derives-from to its intent is carried in
  instances but not schema-required non-empty (D5), and prioritization-record for
  which derives-from is explicitly optional (D8). brief's derives-from→candidate
  requirement is carried by the already-pinned briefed-candidate lifecycle rule
  (coherence_gate_lifecycle_rules.feature) and is not re-pinned here; the
  field-name model shift ADR-069 D3 makes (candidate → derives-from) is flagged for
  the architect (see authoring report). Behavior altitude: frontmatter validation
  against the per-type required-field set.

  Scenario Outline: a kind that does not schema-require derives-from conforms when the field is absent
    Given a <kind> artifact that carries every field its type additionally requires but carries no derives-from field
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as conforming
    And it does not report derives-from as a missing required field

    Examples:
      | kind                  |
      | intent-record         |
      | candidate             |
      | prioritization-record |
