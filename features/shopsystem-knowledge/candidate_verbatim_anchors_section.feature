@bc:shopsystem-knowledge @origin:brief-018
Feature: shopsystem-knowledge — candidate typedef carries a Verbatim anchors section

  Candidate-shaping sessions surface stakeholder statements that materially
  change the candidate's shape after the intent record has already closed —
  cand-002 is the motivating case: a "literal per-provider model IDs would
  defeat the candidate's purpose" objection and a "how would a feasibility
  probe run, zero filesystem footprint" demand, both voiced mid-session,
  survive today only as the PM's own paraphrase inside the candidate's
  Evidence/Changelog prose ("product authority flagged...", "product
  authority caught..."). intent-record already solves this class of problem
  with a `Verbatim anchors` section: a dated, append-in-place list of
  verbatim stakeholder quotes, positioned immediately after the title and
  before the record's first narrative section, added to as the discovery
  session progresses rather than reconstructed afterward. The candidate
  typedef lacks the equivalent section, so a candidate's post-intent
  stakeholder statements have no citable, verbatim home — only synthesized
  prose. This feature pins that the candidate typedef declares a `Verbatim
  anchors` body section, structurally equivalent in shape and generator
  treatment to intent-record's, and that the body-section-conformance check
  enforces it on candidate documents the same way it already enforces every
  other required section (per body_section_conformance.feature's
  established pattern). Behavior altitude: the typedef declaration, the
  generated template's section shape and placement, and the conformance
  check — not the PM-session discipline of appending live versus
  synthesizing after the fact, which is authoring behavior outside the
  knowledge BC's shape-and-integrity domain.

  @scenario_hash:df3a4e715fad03a8
  Scenario: the candidate typedef declares a Verbatim anchors section shaped like intent-record's
    Given the intent-record typedef, whose Verbatim anchors section is a dated, append-in-place list of verbatim stakeholder quotes
    And the candidate typedef, which today has no Verbatim anchors section
    When the knowledge context runs the format generator over the candidate typedef
    Then the candidate typedef declares a Verbatim anchors required body section
    And the generated candidate template's Verbatim anchors section carries the same dated, verbatim, append-in-place shape as the generated intent-record template's Verbatim anchors section
    And the generated candidate template positions Verbatim anchors immediately after the title and before the Problem section, mirroring intent-record's placement before its first narrative section

  @scenario_hash:2e7f311162e627bc
  Scenario: a candidate document missing the Verbatim anchors section is reported non-conforming
    Given a candidate document whose body omits the Verbatim anchors section its type's required-section set now demands
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as non-conforming for a missing required section
    And the diagnosis names Verbatim anchors as the missing section

  @scenario_hash:917da713e6101b0d
  Scenario: a candidate document carrying Verbatim anchors alongside its other required sections passes conformance
    Given a candidate document whose body carries Verbatim anchors plus every other section in its type's required-section set
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as conforming on body structure
    And it names no missing required section
