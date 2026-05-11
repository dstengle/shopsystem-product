Feature: Temperature comparison

  @scenario_hash:2b0a32d9d2d7c63d @bc:temperature
  Scenario: First is hotter than second
    Given a temperature of 100 degrees Celsius
    And another temperature of 50 degrees Celsius
    When I compare the first to the second
    Then the first is hotter than the second
