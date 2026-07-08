Feature: shopsystem-knowledge — single-source projections and index (architecture-decision kind)

  The knowledge context single-sources each decision document: machine truth in
  YAML frontmatter, rationale in the body. From that one source it generates the
  L0/L1/L2 projections and a machine+human index for the architecture-decision
  kind. Generation is a pure function of the parsed corpus — byte-stable and
  idempotent — so the projections the authoring-time discovery pass consults can
  never drift from the source. L1 is a verbatim slice gated on a recognized
  decision heading, so a non-conforming document is reported, not silently empty.
  The accessor is parameterized by kind so later kinds register rather than fork.

  @scenario_hash:d121b489919c177e
  Scenario: L0/L1/L2 projections and the index are generated from the single source document
    Given a decision document whose only machine truth lives in its YAML frontmatter and whose body carries a recognized decision section
    When the knowledge context generates the architecture-decision projections from that single source
    Then it emits an L0 card carrying the id, title, status and description drawn from the frontmatter
    And it emits an L1 extract carrying the verbatim text of the recognized decision section
    And it emits an L2 projection that is the source document itself
    And it emits a machine index entry and a human index entry for that document, both derived from the same frontmatter
    And no projection introduces any fact that is not present in the single source

  @scenario_hash:d71b9384bb5d13d9
  Scenario: generation is byte-stable and free of ambient state
    Given a fixed decision corpus as the single source
    When the knowledge context generates the projections and index twice on two different hosts at two different times
    Then the two generated outputs are byte-for-byte identical
    And no output byte carries a timestamp, hostname, or absolute filesystem path

  @scenario_hash:9feadfd3e1a0efad
  Scenario: regeneration over an unchanged source is idempotent and the check mode reports no drift
    Given a decision corpus whose projections and index have already been generated
    When the knowledge context regenerates the projections and index over the unchanged source
    Then the regeneration writes zero changed bytes
    And running the generation in check mode over the unchanged source reports no drift and exits with a success status

  @scenario_hash:dbd9846f04d8e22b
  Scenario: L1 extraction is convention-gated and a document lacking a recognized decision heading is reported non-conforming
    Given a decision document whose body carries none of the recognized decision headings
    When the knowledge context generates the architecture-decision projections
    Then it reports that document as non-conforming for lacking a recognized decision heading
    And it does not emit a silently empty L1 extract for that document

  @scenario_hash:f4b64423b77dd3e2
  Scenario: the accessor is parameterized by kind and refuses an unregistered kind
    Given the knowledge context with the architecture-decision kind registered and no other kind registered
    When a caller requests projections for kind "architecture-decision"
    Then the accessor returns the architecture-decision corpus projections
    When a caller requests projections for kind "development-principle"
    Then the accessor returns a definite kind-not-registered result rather than defaulting to the architecture-decision corpus
