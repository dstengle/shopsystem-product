@bc:shopsystem-scenarios @origin:brief-009
Feature: scenarios completed-entries read returns the block-only canonical hashes present in a journal file

  The scenarios completed-entries read serves the request_completion_journal
  pull: given a journal file on disk (one block-only canonical hash per line,
  nothing else), it returns the SET of block-only canonical hashes present in
  that file. The returned set is keyed solely on the block-only canonical hash
  — it carries no bead id, scenario title, dispatch record, or message-bus row.
  An empty journal is a definite, successful empty answer, not an error.

  @scenario_hash:60403e1ba2035031
  Scenario: the scenarios completed-entries read returns exactly the block-only canonical hashes present in the journal file
    Given a scenario journal stored as a file on disk under the shopsystem-scenarios bounded context
    And the journal file records the block-only canonical hashes "h1" and "h2" as its present entries
    When the scenarios completed-entries read is run against that journal file to serve the request_completion_journal pull
    Then the read returns exactly the set of block-only canonical hashes "h1" and "h2"
    And the returned set is keyed solely on the block-only canonical hash, carrying no bead id, scenario title, dispatch record, or message-bus row

  @scenario_hash:79acbeb40154dfed
  Scenario: the scenarios completed-entries read returns an empty set for a journal file with no present entries
    Given a scenario journal stored as a file on disk under the shopsystem-scenarios bounded context
    And the journal file records no present entries
    When the scenarios completed-entries read is run against that journal file to serve the request_completion_journal pull
    Then the read returns the empty set of block-only canonical hashes
    And the read exits with a success status rather than treating the empty journal as an error
