Feature: shopsystem-knowledge — active-only L1 decision digest (typed artifacts)

  Distinct from the L0 index that triages the whole corpus, the L1 digest is the
  active-only decision pour a BC consumes to conform. The knowledge context
  generates it from the same single source as every other projection. The digest
  contains exactly the accepted decisions — pdr and adr artifacts whose status is
  accepted; decisions that are proposed, rejected or superseded are excluded, so a
  BC that reads the digest never conforms to a decision that is not yet accepted or
  has been retired. Each entry is self-contained: it carries its own id, status,
  its supersede edges, and the verbatim L1 decision extract, so a reader of one
  entry needs nothing outside it. Like every projection the digest is a pure
  function of the source — byte-stable and idempotent.

  @scenario_hash:1e54b6db4a552943
  Scenario: the digest contains exactly the accepted decisions and excludes the rest
    Given an artifact corpus containing accepted decisions and decisions whose status is proposed, rejected or superseded
    When the knowledge context generates the L1 decision digest over the corpus
    Then the digest contains an entry for every accepted decision
    And the digest contains no entry for any proposed, rejected or superseded decision

  @scenario_hash:203bebfdad68329c
  Scenario: each digest entry is self-contained
    Given an artifact corpus containing an accepted decision that supersedes a prior decision
    When the knowledge context generates the L1 decision digest over the corpus
    Then the entry for that accepted decision carries its own id, its status, its supersede edges and the verbatim L1 decision extract
    And a reader of that single entry can determine the decision, its status and what it supersedes without consulting any other entry or the source document

  @scenario_hash:f74c632acd68f308
  Scenario: the digest is derived from the single source and regeneration is idempotent
    Given an artifact corpus whose L1 decision digest has already been generated
    When the knowledge context regenerates the L1 decision digest over the unchanged source
    Then the regeneration writes zero changed bytes
    And no digest entry carries any fact absent from the single source
