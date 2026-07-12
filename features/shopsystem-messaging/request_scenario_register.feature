@bc:shopsystem-messaging @origin:brief-014
Feature: request_scenario_register — request and response message types

  A request_scenario_register asks a target bounded context for its scenario
  register: each pinned scenario's block-only canonical hash, title and step
  text, features/ file location, and live-or-retired status. The request names
  the target BC and may optionally narrow to a feature-area surface or an
  explicit set of hashes; the response carries the full per-entry register
  back, unlike the bare-hash completion journal.

  @scenario_hash:5b13b13d2205459b
  Scenario: A minimal valid request_scenario_register request names the target bounded context and omits narrowing to request that BC's full register
    Given the RequestScenarioRegister request schema from the shop-msg catalog
    When I construct a RequestScenarioRegister request instance supplying only the fields the schema marks as required, naming the target bounded context whose scenario register is sought, and supplying no narrowing selector
    Then construction succeeds
    And no schema validation error is raised
    And the constructed request carries the named target bounded context and no register entry of its own
    And the omitted narrowing selector denotes the target bounded context's full register rather than any subset
    And the schema also permits an optional narrowing selector that confines the request to a named feature-area surface or to an explicit set of block-only canonical hashes

  @scenario_hash:9b12f88736c6964f
  Scenario: A request_scenario_register response carries each register entry's hash, title and text, features/ file location, and live-or-retired status, unlike the bare-hash completion journal
    Given the RequestScenarioRegister response schema from the shop-msg catalog
    When I construct a RequestScenarioRegister response instance whose register-entries field holds two entries, each carrying a block-only canonical hash, the scenario's title and step text, the scenario's file location within the target bounded context's features/ tree, and a status of either live or retired/superseded
    Then construction succeeds
    And no schema validation error is raised
    And the constructed response carries, for each register entry, its block-only canonical hash together with its scenario title and step text, its features/ file location, and its live-or-retired/superseded status
    And these per-entry fields let the requester locate, import, or supersede the pinned scenario from the response alone
    And a register entry supplying only a bare block-only canonical hash, with no title, step text, file location, or status, is rejected as schema-invalid

  @scenario_hash:2c8501835cf1f5f8
  Scenario: responding to a request_scenario_register carries each register entry back over the wire to the requester
    Given an inbox holding an unprocessed request_scenario_register request for work_id "lead-402" naming target bounded context "shopsystem-templates"
    When shop-msg responds to request_scenario_register for work_id "lead-402" with two register entries, each carrying a block-only canonical scenario hash, the scenario's title and step text, the scenario's features/ file location, and a status of either live or retired
    Then the requester can read a request_scenario_register response for work_id "lead-402" whose register-entries field reproduces those two entries, each carrying its block-only canonical hash together with its scenario title and step text, its features/ file location, and its live-or-retired status
    And that response validates against the RequestScenarioRegister response schema
