@bc:unassigned @origin:brief-019
Feature: shopsystem-knowledge — artifact schema and validation exposed as an installable CLI

  PDR-032 makes shopsystem-knowledge the sole owner of the artifact type
  system, and ADR-059 makes each of the eight artifact types' template and
  JSON Schema fragment a generated, drift-gated projection of one typedef.
  Both decisions are already realized as INTERNAL knowledge-context
  behavior — per_type_typedef_generation.feature, frontmatter_schema_
  conformance.feature, and body_section_conformance.feature all pin that
  the knowledge context itself can generate a type's format and check a
  document's frontmatter and body against it. Nothing outside the knowledge
  context can reach that behavior today: there is no installed CLI, so a
  skill author who wants to know an artifact type's real shape, or wants to
  check a produced document against it, has no way to do either except by
  copying a pre-existing file in the consuming repo — which is exactly how
  this repo's PM artifacts (`intent/`, `candidates/`) drifted from the real
  schema (confirmed empirically via the `lead-ptr7a` clarify exchange: this
  repo's candidate/intent-record shapes do not match shopsystem-knowledge's
  actual `required_sections`). This feature exposes the existing internal
  capability as an installable CLI, `shop-knowledge`, following the
  `shop-msg`/`shop-templates` naming convention already established for
  this fleet's other installed contract tools (ADR-018 D2: a contract tool
  takes contract text as input and returns a contract fact — the same
  category `scenarios hash` occupies). `shop-knowledge template <type>` and
  `shop-knowledge schema <type>` return the type's generated template and
  schema fragment; `shop-knowledge validate <path>` checks a document
  against both its frontmatter schema and its body-section requirement set,
  reporting every violation found — never flattened to a bare pass/fail.
  Behavior altitude: the CLI's observable input/output contract, not the
  generator's or validator's internal implementation, which is already
  pinned elsewhere in this feature directory.

  @scenario_hash:f4f5ed358bd8cb05
  Scenario Outline: "shop-knowledge template" prints the canonical authoring template for a recognized artifact type
    Given the installed "shop-knowledge" distribution
    When I run "shop-knowledge template <type>"
    Then the exit code is 0
    And stdout is the "<type>" typedef's generated template byte-for-byte
    And stderr is empty

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

  @scenario_hash:5b4249797a787e87
  Scenario Outline: "shop-knowledge schema" prints the canonical JSON Schema fragment for a recognized artifact type
    Given the installed "shop-knowledge" distribution
    When I run "shop-knowledge schema <type>"
    Then the exit code is 0
    And stdout is the "<type>" typedef's generated schema fragment byte-for-byte
    And stderr is empty

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

  @scenario_hash:89a5c44117688941
  Scenario Outline: "shop-knowledge template" and "shop-knowledge schema" both reject an unrecognized artifact type and name the offending value
    Given the installed "shop-knowledge" distribution
    When I run "shop-knowledge <subcommand> roadmap"
    Then the exit code is non-zero
    And stderr names "roadmap" as an unrecognized artifact type
    And stderr lists the eight recognized artifact types

    Examples:
      | subcommand |
      | template   |
      | schema     |

  @scenario_hash:a640a9d897c0b144
  Scenario: "shop-knowledge validate" reports a conforming document as conforming
    Given a document on disk at "/tmp/example-artifact.md" whose frontmatter declares a recognized "type" and satisfies every frontmatter-required field, id pattern, and status enum for that type
    And the document's body carries every section its type's required-section set demands
    When I run "shop-knowledge validate /tmp/example-artifact.md"
    Then the exit code is 0
    And stdout reports the document as conforming
    And stdout names no violation

  @scenario_hash:a72ff18b65420b35
  Scenario: "shop-knowledge validate" on a document missing a required frontmatter field reports the same named diagnosis the internal frontmatter check produces
    Given a document on disk at "/tmp/example-artifact.md" whose frontmatter omits a field its recognized type requires
    When I run "shop-knowledge validate /tmp/example-artifact.md"
    Then the exit code is non-zero
    And stdout reports the document as non-conforming
    And stdout names the missing required field by its field name

  @scenario_hash:9bfae1a9bd3103c9
  Scenario: "shop-knowledge validate" on a document missing a required body section reports the same named diagnosis the internal body-section check produces
    Given a document on disk at "/tmp/example-artifact.md" whose recognized type's frontmatter is otherwise conforming but whose body omits a section that type's required-section set demands
    When I run "shop-knowledge validate /tmp/example-artifact.md"
    Then the exit code is non-zero
    And stdout reports the document as non-conforming
    And stdout names the missing required section by its section heading

  @scenario_hash:60ba623cc4f6f4b0
  Scenario: "shop-knowledge validate" reports every violation on a document that carries more than one, not only the first
    Given a document on disk at "/tmp/example-artifact.md" whose frontmatter omits a required field AND whose body separately omits a required section, both for its recognized type
    When I run "shop-knowledge validate /tmp/example-artifact.md"
    Then the exit code is non-zero
    And stdout names the missing required field by its field name
    And stdout also names the missing required section by its section heading
    And stdout does not stop at the first violation found

  @scenario_hash:3c0e3cd8259c8698
  Scenario: "shop-knowledge validate" on a document whose frontmatter omits or misdeclares the type field reports that specific diagnosis rather than skipping validation
    Given a document on disk at "/tmp/example-artifact.md" whose frontmatter omits the "type" field, or declares a "type" value outside the eight recognized artifact types
    When I run "shop-knowledge validate /tmp/example-artifact.md"
    Then the exit code is non-zero
    And stdout reports the document as non-conforming for a missing or unrecognized type
    And stdout does not silently skip validation for lack of a determinable type
