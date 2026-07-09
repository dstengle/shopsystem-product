Feature: shopsystem-knowledge — coherence gate: advisory/blocking mode split (typed artifacts)

  The coherence gate runs in two modes with the ADR-047-D3 advisory/blocking
  shape. In authoring mode it reports findings as warnings and always exits zero —
  it never inverts the author's authorship or blocks an artifact from being
  written, because at authoring time the human judgment is the authority. In
  distribution mode it vetoes: a blocking-severity finding drives a non-zero exit
  and stops the pour, while an advisory-severity finding still only warns and does
  not by itself fail the run. Every finding is reported in doctor form —
  name (check-id) + severity status + remediation. This split is type-general: it
  governs every check over every one of the eight artifact types, not one kind.

  @scenario_hash:2f25bbade70105b5
  Scenario: authoring mode warns and never blocks
    Given an artifact corpus that carries a coherence finding
    When the knowledge context runs the coherence gate with mode authoring
    Then it reports the finding as a warning
    And it exits zero
    And it does not prevent the author from committing the artifact

  @scenario_hash:ece5e70d4ff79e36
  Scenario: distribution mode vetoes a blocking-severity finding
    Given an artifact corpus whose coherence finding is classified as blocking severity
    When the knowledge context runs the coherence gate with mode distribution
    Then it reports the blocking finding
    And it exits non-zero

  @scenario_hash:3ddf434d9ad17704
  Scenario: distribution mode only warns on an advisory-severity finding
    Given an artifact corpus whose only coherence finding is classified as advisory severity
    When the knowledge context runs the coherence gate with mode distribution
    Then it reports the advisory finding as a warning
    And it exits zero

  @scenario_hash:581c3fee5a163491
  Scenario: every finding is reported in doctor form
    Given an artifact corpus that carries a coherence finding
    When the knowledge context runs the coherence gate with mode authoring
    Then the reported finding carries its check name and check-id, a severity status, and a remediation
