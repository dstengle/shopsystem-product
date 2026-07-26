@bc:shopsystem-knowledge @origin:lead-qa76u
Feature: shopsystem-knowledge — base-schema distribution scope and shared fields (typed artifacts)

  ADR-067's base schema adds three shared frontmatter fields the single-source
  typedef governs. The distribution field records the artifact's within-product
  scope, enum-constrained to product-lead (the lead shop's own decisions),
  product-wide (every BC must honor it) or bc-local (one BC's internal decision,
  living in the BC repo); it replaces the retired ADR-034/035 tier model wholesale.
  A value outside that enum is a schema non-conformance, named like any other
  out-of-enum value. Because a lead-host artifact is by definition never one BC's
  internal decision, the coherence gate additionally treats a lead-resident instance
  carrying distribution bc-local as misfiled. The tags field carries a free-form list
  of retrieval labels — an aid to query, never authoritative for ownership or the
  two-views separation — and the external-references field lists sources OUTSIDE the
  corpus (URLs, citations); unlike the references/referenced-by intra-corpus edge
  pair it carries no back-edge and is never gate-symmetry-checked or resolved as a
  graph edge. Both tags and external-references are optional and may be empty.
  Disclosure level remains a projection, never a stored frontmatter field.

  @scenario_hash:617cf4f60d8ddb01
  Scenario Outline: a distribution value inside the enum conforms
    Given an artifact whose frontmatter carries a distribution value of "<value>"
    And "<value>" is a member of the distribution enum product-lead, product-wide or bc-local
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as conforming
    And it does not report distribution as an unrecognized value

    Examples:
      | value        |
      | product-lead |
      | product-wide |
      | bc-local     |

  @scenario_hash:283fc6f5733ffac6
  Scenario: a distribution value outside the enum is reported non-conforming and names the offending value
    Given an artifact whose frontmatter carries a distribution value of "system-wide"
    And "system-wide" is not a member of the distribution enum product-lead, product-wide or bc-local
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming for an unrecognized distribution value
    And the diagnosis names the offending value "system-wide"

  @scenario_hash:e15914fade4a5406
  Scenario: a lead-host artifact carrying distribution bc-local is flagged as misfiled
    Given an artifact corpus resident on the lead host in which an artifact carries a distribution value of bc-local
    When the knowledge context runs the distribution-scope coherence check over the corpus
    Then it reports a misfiled-bc-local finding naming the artifact by id
    And the finding carries its check-id and a remediation to relocate the artifact to its BC repo or correct its distribution scope
    And the aggregate verdict exits non-zero

  @scenario_hash:9cbc6bee113e1f52
  Scenario: an artifact carrying a tags list conforms
    Given an artifact whose frontmatter carries a tags field holding a list of retrieval labels
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as conforming
    And it does not report the tags field as an unrecognized field

  @scenario_hash:64bf2fe14d80e4eb
  Scenario: an artifact omitting the optional tags field still conforms
    Given an artifact that carries every required field and a recognized status but omits the optional tags field
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as conforming
    And it does not report the absent tags field as missing

  @scenario_hash:197a67281976456c
  Scenario: an artifact carrying an external-references list conforms
    Given an artifact whose frontmatter carries an external-references field holding a list of sources outside the corpus
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as conforming
    And it does not report the external-references field as an unrecognized field

  @scenario_hash:19b25035e0a2e0ae
  Scenario: an external-references entry forms no intra-corpus edge and draws no dangling-edge finding
    Given an artifact corpus in which an artifact's external-references field lists a source outside the corpus that is not an artifact id
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it forms no intra-corpus edge from the external-references entry
    And it reports no dangling-edge finding arising from the external reference
    And the aggregate verdict exits zero
