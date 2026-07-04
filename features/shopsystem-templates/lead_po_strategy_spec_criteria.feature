@bc_internal
Feature: lead-po template — strategy-before-backlog and specification-as-contract sufficiency criteria

  @scenario_hash:6773a984439f2a9e @bc:shopsystem-templates
  Scenario: lead-po template carries a testable sufficiency criterion for the strategy-before-backlog and specification-as-contract disciplines
    When I read the lead-po template via "shop-templates show lead-po"
    Then the strategy before backlog discipline block states a sufficiency criterion that requires every PDR or scenario set to trace up to a strategic bet recorded in the brief, with no orphan features
    And the specification as the contract discipline block states that scenarios are the contract and that an AI fleet builds exactly what is specified, so ambiguity is the enemy
    And the specification as the contract discipline block states a sufficiency criterion that requires scenarios to be behavior-focused and example-driven, each tracing back to a problem and forward to a testable behavior
    And the specification as the contract discipline block does not replace or weaken the existing "Sufficiency check — authoring a scenario" section, but feeds well-formed scenarios into it
