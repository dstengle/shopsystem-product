@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg send — full RequestMaintenance flag coverage

  @scenario_hash:d57e1ed181a81e7e
  Scenario: Send request_maintenance with one acceptance criterion and one file hint
    Given an empty BC at a temporary path
    When I run shop-msg send request_maintenance with work-id "lead-A" and description "Add X." and acceptance-criterion "It works." and file-hint "src/x.py"
    Then the BC's inbox contains a file named "lead-A.yaml"
    And the file parses as a valid RequestMaintenance with work_id "lead-A", description "Add X.", acceptance_criteria ["It works."], and file_hints ["src/x.py"]

  @scenario_hash:c68d62ccae4fc40d
  Scenario: Acceptance criteria are repeatable on the command line
    Given an empty BC at a temporary path
    When I run shop-msg send request_maintenance with work-id "lead-B" and description "Multi-criterion work." and acceptance-criterion "First." and acceptance-criterion "Second."
    Then the BC's inbox contains a file named "lead-B.yaml"
    And the file parses as a valid RequestMaintenance with work_id "lead-B" and acceptance_criteria ["First.", "Second."]
