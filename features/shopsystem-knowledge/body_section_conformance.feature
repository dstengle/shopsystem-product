Feature: shopsystem-knowledge — body-section conformance (x-required-sections)

  Beyond frontmatter validation, each artifact type declares a required body-section
  set — the x-required-sections list its typedef generates (for a pdr: The question,
  Context, Options considered, Decision, Consequences, Changelog). The knowledge
  context checks a document's body headings against its type's required-section set:
  a document missing a required section is reported non-conforming with the missing
  section named; a document carrying its type's full section set passes. The check is
  structural — it inspects the document's headings, not prose quality — and it is
  type-general: each type is checked against its own section set, so a section
  required for one type is not imposed on another. This is the body-structure
  companion to the frontmatter schema check and to the convention-gated L1
  extraction; disclosure level L0/L1/L2 remains a projection the tool emits, never a
  stored frontmatter field (the tier-collision lesson).

  @scenario_hash:13d1e7a3a4098b20
  Scenario: a document missing a required body section is reported non-conforming and names the section
    Given a pdr document whose body omits the Options considered section its type's required-section set demands
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as non-conforming for a missing required section
    And the diagnosis names Options considered as the missing section

  @scenario_hash:35ab526df01673b5
  Scenario: a document carrying its type's full required-section set passes
    Given a pdr document whose body carries every section in its type's required-section set
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as conforming on body structure
    And it names no missing required section

  @scenario_hash:f7aed937f67018da
  Scenario: the required-section set is resolved per type
    Given an intent-record document whose body omits a section that the pdr required-section set demands but that the intent-record required-section set does not
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the intent-record as conforming on body structure
    And it does not impose the pdr section set on the intent-record
