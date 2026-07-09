Feature: shopsystem-knowledge — coherence gate: artifact-lifecycle rules (typed artifacts)

  Beyond the always-on typed-edge floor, the coherence gate runs cross-document
  lifecycle checks that hold the eight-type artifact model self-consistent as work
  moves through discovery, shaping, briefing, sessions and current state. These are
  gate rules 4 through 9: the briefed-candidate must be bidirectionally tied to its
  brief (rule 4); a brief numbered above 015 must name its candidate, with 001–015
  legacy-exempt (rule 5); a closed session-record must link at least one produced or
  revised artifact (rule 6); every accepted pdr or adr must be claimed by some
  current-state incorporates list (rule 7); a document left in an in-flight
  status past an age threshold draws a warning-severity finding (rule 8); and a pdr
  whose derives-from anchor list is empty draws a warning-severity finding, since an
  empty anchor is permitted only for a root decision (rule 9 — the adr side of rule
  9 is a hard schema non-conformance, pinned in the frontmatter-conformance feature).
  Each
  finding is reported in doctor form — check name + check-id + the offending
  artifacts + a remediation — and rides the same advisory/blocking mode split as
  every other check; rule 8 is always warning tier and never blocks. Disclosure
  level L0/L1/L2 is a projection, never a frontmatter field (the tier-collision
  lesson).

  @scenario_hash:eb84c02b2c81c847
  Scenario: a briefed candidate that names no brief is flagged
    Given an artifact corpus containing a candidate whose status is briefed and whose brief field is unset
    When the knowledge context runs the artifact-lifecycle coherence checks over the corpus
    Then it reports a briefed-without-brief finding naming the candidate by id
    And the finding carries its check-id and a remediation to set the candidate's brief field
    And the aggregate verdict exits non-zero

  @scenario_hash:1a994ea90a5ceae9
  Scenario: a briefed candidate whose brief does not point back is flagged
    Given an artifact corpus containing a candidate whose status is briefed and whose brief field names a brief
    And that brief's candidate field does not point back to the candidate
    When the knowledge context runs the artifact-lifecycle coherence checks over the corpus
    Then it reports a briefed-brief-asymmetry finding naming the candidate and the brief by id
    And the finding carries its check-id and a remediation to set the brief's candidate field back to the candidate
    And the aggregate verdict exits non-zero

  @scenario_hash:64c54c7faea88700
  Scenario: a briefed candidate bidirectionally tied to its brief passes
    Given an artifact corpus containing a candidate whose status is briefed and whose brief field names a brief
    And that brief's candidate field names the candidate back
    When the knowledge context runs the artifact-lifecycle coherence checks over the corpus
    Then it reports no briefed-candidate finding for that pair
    And the aggregate verdict exits zero

  @scenario_hash:1371e676816d872b
  Scenario: a brief numbered above 015 that names no candidate is flagged
    Given an artifact corpus containing a brief whose id is brief-042 and whose candidate field is unset
    When the knowledge context runs the artifact-lifecycle coherence checks over the corpus
    Then it reports a brief-without-candidate finding naming the brief by id
    And the finding carries its check-id and a remediation to set the brief's candidate field
    And the aggregate verdict exits non-zero

  @scenario_hash:9814d08eb964bc17
  Scenario: a legacy brief numbered 001 through 015 without a candidate is exempt
    Given an artifact corpus containing a brief whose id is brief-009 and whose candidate field is unset
    When the knowledge context runs the artifact-lifecycle coherence checks over the corpus
    Then it reports no brief-without-candidate finding for that brief
    And the aggregate verdict exits zero

  @scenario_hash:4414a62947cfed47
  Scenario: a closed session-record with both produced and revised empty is flagged
    Given an artifact corpus containing a session-record whose status is closed and whose produced and revised fields are both empty
    When the knowledge context runs the artifact-lifecycle coherence checks over the corpus
    Then it reports an empty-closed-session finding naming the session-record by id
    And the finding carries its check-id and a remediation to link at least one produced or revised artifact
    And the aggregate verdict exits non-zero

  @scenario_hash:a071803a4f753725
  Scenario: a closed session-record linking at least one produced artifact passes
    Given an artifact corpus containing a session-record whose status is closed and whose produced field links one artifact
    When the knowledge context runs the artifact-lifecycle coherence checks over the corpus
    Then it reports no empty-closed-session finding for that session-record
    And the aggregate verdict exits zero

  @scenario_hash:327884ff5d9d2b27
  Scenario: an accepted decision claimed by no current-state incorporates list is flagged
    Given an artifact corpus containing an accepted pdr whose id appears in no current-state incorporates list
    When the knowledge context runs the artifact-lifecycle coherence checks over the corpus
    Then it reports an unincorporated-decision finding naming the pdr by id
    And the finding carries its check-id and a remediation to claim the pdr in a current-state incorporates list
    And the aggregate verdict exits non-zero

  @scenario_hash:2c44d45e430cd221
  Scenario: an accepted decision claimed by a current-state incorporates list passes
    Given an artifact corpus containing an accepted adr whose id appears in a current-state incorporates list
    When the knowledge context runs the artifact-lifecycle coherence checks over the corpus
    Then it reports no unincorporated-decision finding for that adr
    And the aggregate verdict exits zero

  @scenario_hash:5f194c486f438704
  Scenario: an in-flight artifact older than the age threshold draws a warning-severity finding
    Given an artifact corpus containing an artifact whose status is draft and whose updated date is older than the configured age threshold
    When the knowledge context runs the artifact-lifecycle coherence checks over the corpus
    Then it reports a stale-in-flight finding naming the artifact by id at warning severity
    And the finding carries its check-id and a remediation to advance or close the artifact
    And the warning does not by itself drive the aggregate verdict non-zero

  @scenario_hash:fd2624b58e1aedca
  Scenario: a pdr with an empty derives-from anchor draws a root-decision warning
    Given an artifact corpus containing a pdr whose derives-from field is an empty list
    When the knowledge context runs the artifact-lifecycle coherence checks over the corpus
    Then it reports a root-decision-anchor finding naming the pdr by id at warning severity
    And the finding carries its check-id and a remediation to anchor the pdr to an upstream artifact unless it is a root decision
    And the warning does not by itself drive the aggregate verdict non-zero

  @scenario_hash:8f41dbc539994647
  Scenario: a pdr that anchors to at least one upstream artifact draws no root-decision warning
    Given an artifact corpus containing a pdr whose derives-from field names at least one upstream artifact present in the corpus
    When the knowledge context runs the artifact-lifecycle coherence checks over the corpus
    Then it reports no root-decision-anchor finding for that pdr

  @scenario_hash:40c65cfdae28ab98
  Scenario: an in-flight artifact younger than the age threshold draws no warning
    Given an artifact corpus containing an artifact whose status is exploring and whose updated date is within the configured age threshold
    When the knowledge context runs the artifact-lifecycle coherence checks over the corpus
    Then it reports no stale-in-flight finding for that artifact
