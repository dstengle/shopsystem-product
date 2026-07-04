@bc_internal
Feature: shopsystem-templates — CLI surface and role-discipline structure

  @scenario_hash:22d9b763d334f41e @bc:shopsystem-templates
  Scenario: bc-reviewer template carries the structural sections that adversarial-review discipline depends on
    When I read the bc-reviewer template via "shop-templates show bc-reviewer"
    Then the content contains a "## What you read" section header
    And the content contains a "## What you do" section header
    And the content contains a "## Outcomes" section header
    And the content contains a "## Anti-rationalization" section header
    And the content contains a "## Reporting back" section header
