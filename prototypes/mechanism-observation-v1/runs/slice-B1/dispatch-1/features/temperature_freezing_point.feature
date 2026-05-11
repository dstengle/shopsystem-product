Feature: Temperature freezing-point boundary

  @scenario_hash:b29bc3ef82e517f9 @bc:temperature
  Scenario: Freezing point — 0 Celsius is 32 Fahrenheit
    Given a temperature of 0 degrees Celsius
    When I convert it to Fahrenheit
    Then I get 32 degrees Fahrenheit
