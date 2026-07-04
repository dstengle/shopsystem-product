@bc_internal
Feature: shopsystem-templates — CLI surface and role-discipline structure

  @scenario_hash:9e64f87f136bb41f @bc:shopsystem-templates
  Scenario: lead-architect template carries the structural sections that architecture and message-type discipline depend on
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then the content contains a "## Your default posture: PRE-STATE DETERMINES VEHICLE — VERIFIED EMPIRICALLY" section header
    And the content contains a "## Sufficiency check — message-type selection" section header
    And the content contains a "## Sufficiency check — `assign_scenarios`" section header
    And the content contains a "## Sufficiency check — `request_bugfix`" section header
    And the content contains a "## Sufficiency check — `request_maintenance`" section header
    And the content contains a "## Anti-rationalization" section header
    And the content contains a "## Reporting back" section header
