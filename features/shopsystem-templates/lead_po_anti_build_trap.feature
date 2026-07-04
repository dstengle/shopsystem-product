@bc_internal
Feature: lead-po template — anti-build-trap structural gate

  @scenario_hash:c96e0d7e37de2079 @bc:shopsystem-templates
  Scenario: lead-po template carries the anti-build-trap structural gate as the failure mode the role exists to prevent
    When I read the lead-po template via "shop-templates show lead-po"
    Then the content names the build trap — measuring output or shipping features nobody needed — as the structural failure mode the empowered-PM role exists to prevent
    And the content states that because the build is effectively free and the fleet executes exactly what is specified, the build trap is more dangerous in this system, not less
    And the content states a sufficiency criterion that the PM can and does say "no" or "not yet" with a recorded reason
    And the content states that output volume — such as scenarios authored or features shipped — is never a success measure
    And this gate is stated as a sufficiency criterion on the role, not as bare advisory prose with no criterion
