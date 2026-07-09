Feature: shopsystem-knowledge — frontmatter schema conformance (typed artifacts)

  Every product artifact single-sources its machine truth in YAML frontmatter.
  Before a document participates in any projection or coherence check, the
  knowledge context validates its frontmatter against the shared required-field
  set — type, id, title, status, created, updated, authors and description — and
  then against the branch its type selects: the per-type id pattern, the per-type
  status enum, and any fields that type additionally requires. A single "type"
  discriminator ranges over the eight artifact types (intent-record, candidate,
  session-record, prioritization-record, brief, pdr, adr, current-state); there is
  no separate "kind" axis. A conforming document passes; a document that omits a
  required field, carries an out-of-enum status, carries an id that does not match
  its type pattern, or declares an unrecognized type is reported non-conforming
  with a named diagnosis rather than silently accepted. Disclosure level is never
  one of those fields: L0/L1/L2 are projections the tool emits, so a document that
  tries to store its own tier is non-conforming (the tier-collision lesson).

  @scenario_hash:db21cc6c83e49a32
  Scenario: a well-formed artifact passes frontmatter conformance
    Given an artifact whose frontmatter carries type, id, title, status, created, updated, authors and description
    And the id matches the id pattern its type requires
    And the status value is a member of the enum its type recognizes
    And it carries every field its type additionally requires
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as conforming
    And it reports no missing required fields

  @scenario_hash:dcb78f54444f0172
  Scenario: an artifact missing the required description field is reported non-conforming and names it
    Given an artifact whose frontmatter omits the required description field
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming
    And the diagnosis names description as the missing required field

  @scenario_hash:3a2adff5f24f01d1
  Scenario: an artifact missing the required authors field is reported non-conforming and names it
    Given an artifact whose frontmatter omits the required authors field
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming
    And the diagnosis names authors as the missing required field

  @scenario_hash:8d68a9e86023dab6
  Scenario: an artifact missing the required updated field is reported non-conforming and names it
    Given an artifact whose frontmatter carries created but omits the required updated field
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming
    And the diagnosis names updated as the missing required field

  @scenario_hash:c07e8db63b3c1b42
  Scenario: a status value outside the type's recognized enum is reported non-conforming and names the offending value
    Given a candidate artifact whose frontmatter carries a status value of "in-progress"
    And "in-progress" is not a member of the candidate status enum exploring, shaped, briefed, parked or rejected
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming for an unrecognized status
    And the diagnosis names the offending value "in-progress"

  @scenario_hash:b8ed5d4027a77e2f
  Scenario: an id that does not match the type's id pattern is reported non-conforming
    Given a candidate artifact whose id is "candidate-1" rather than the cand-NNN pattern its type requires
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming for an id that does not match its type pattern
    And the diagnosis names the offending id and the expected pattern

  @scenario_hash:6f57407593cf4701
  Scenario: an unrecognized type value is reported non-conforming and names the offending value
    Given an artifact whose frontmatter carries a type value of "roadmap"
    And "roadmap" is not one of the eight recognized artifact types
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming for an unrecognized type
    And the diagnosis names the offending value "roadmap"

  @scenario_hash:2363911877f9f657
  Scenario: an artifact missing a field its type additionally requires is reported non-conforming
    Given a pdr artifact whose frontmatter carries every shared required field but omits the decision-makers field its type additionally requires
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming
    And the diagnosis names decision-makers as the missing type-required field

  @scenario_hash:290cf40f90b418b4
  Scenario: optional fields may be absent and the artifact still conforms
    Given an artifact that carries every required field and a recognized status but omits the optional beads field
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as conforming
    And it does not report the absent beads field as missing

  @scenario_hash:90cd805cff6d9248
  Scenario: disclosure level is a projection and is never a stored frontmatter field
    Given an artifact whose frontmatter carries a stored disclosure-level field pinning its own tier
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming for storing a disclosure-level field
    And the diagnosis states that disclosure level is a projection emitted by the tool and is never a stored frontmatter field
