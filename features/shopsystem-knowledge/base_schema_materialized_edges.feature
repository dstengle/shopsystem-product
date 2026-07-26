@bc:shopsystem-knowledge @origin:lead-qa76u
Feature: shopsystem-knowledge — base-schema materialized bidirectional edges (typed artifacts)

  ADR-067's base schema stores BOTH directions of three relationship pairs in
  frontmatter — supersedes/superseded-by, derives-from/derived-by, and
  references/referenced-by — so the transformation-view graph is traversable from a
  single document's frontmatter alone rather than computed by scanning the corpus
  (the compute-transitively posture ADR-067 D2 replaces). The coherence gate
  maintains both directions and fails on asymmetry: for every forward edge naming a
  target there must be a matching materialized back-edge naming the source, and a
  dangling half-edge is a hard coherence finding, not a warning. The
  supersedes/superseded-by symmetry itself is already pinned in the typed-edge
  feature; this feature pins the two edge pairs ADR-067 adds (derives-from/derived-by,
  references/referenced-by), the N:M joint-supersession case where one predecessor is
  superseded by several successors, and the materialization semantic that back-edges
  are read from frontmatter rather than computed on read. Each finding is reported in
  doctor form — check name + check-id + the offending artifacts by id + a remediation
  — and folds into the one aggregate verdict; a clean corpus exits zero.

  @scenario_hash:c42c3e9b4b327e60
  Scenario Outline: a materialized forward edge with no reciprocal back-edge is flagged
    Given an artifact corpus in which artifact A declares a <forward-field> edge naming artifact B
    And artifact B carries no <back-field> edge back to A
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it reports a <finding> finding naming A and B by id
    And the finding carries its check-id and a remediation to write the <back-field> back-edge on B
    And the aggregate verdict exits non-zero

    Examples:
      | forward-field | back-field    | finding               |
      | derives-from  | derived-by    | asymmetric-derivation |
      | references    | referenced-by | asymmetric-reference  |

  @scenario_hash:b52b179a925b732a
  Scenario Outline: a materialized forward edge whose reciprocal back-edge is present passes
    Given an artifact corpus in which artifact A declares a <forward-field> edge naming artifact B
    And artifact B carries a <back-field> edge back to A
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it reports no <finding> finding for the A and B pair
    And the aggregate verdict exits zero

    Examples:
      | forward-field | back-field    | finding               |
      | derives-from  | derived-by    | asymmetric-derivation |
      | references    | referenced-by | asymmetric-reference  |

  @scenario_hash:d3e55f9b80099eb5
  Scenario: a predecessor jointly superseded by several successors, each carrying its supersedes back-edge, passes
    Given an artifact corpus in which artifact B declares a superseded-by list naming successors A and C
    And artifacts A and C each declare a supersedes edge naming B
    And artifact B's status is superseded
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it reports no asymmetric-supersede finding for the joint supersession of B
    And the aggregate verdict exits zero

  @scenario_hash:bb316e39954e3ce9
  Scenario: a joint superseded-by list missing one successor's supersedes back-edge is flagged
    Given an artifact corpus in which artifact B declares a superseded-by list naming successors A and C
    And artifact A declares a supersedes edge naming B
    And artifact C carries no supersedes edge naming B
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it reports an asymmetric-supersede finding naming B and C by id for the missing back-edge
    And it reports no asymmetric-supersede finding for the resolved B and A pair
    And the aggregate verdict exits non-zero

  @scenario_hash:ebcd6ee47aed6f6d
  Scenario: the referenced-by back-edge is answered from frontmatter and not computed by corpus scan
    Given an artifact corpus in which artifact B carries a materialized referenced-by edge naming artifact A in its frontmatter
    When the knowledge context resolves what references artifact B
    Then it answers from artifact B's own referenced-by frontmatter field
    And it does not compute the answer by scanning the corpus for forward references edges

  @scenario_hash:fd98c4d9e26162f0
  Scenario Outline: a materialized back-edge field pointing to a target absent from the corpus is flagged dangling
    Given an artifact corpus in which an artifact declares a <link-field> edge to a target id that is not present in the corpus
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it reports a dangling-edge finding naming the source artifact and the unresolved target id on its <link-field> edge
    And the finding carries its check-id and a remediation
    And the aggregate verdict exits non-zero

    Examples:
      | link-field    |
      | derived-by    |
      | references    |
      | referenced-by |
