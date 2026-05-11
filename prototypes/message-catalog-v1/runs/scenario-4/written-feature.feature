Feature: Temperature conversion

  @scenario_hash:3f123ba774758ff2 @bc:temperature
  Scenario: Boiling water in Fahrenheit
    Given a temperature of 100 degrees Celsius
    When I convert it to Fahrenheit
    Then I get 212 degrees Fahrenheit
