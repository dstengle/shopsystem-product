@bc:shopsystem-bc-launcher @origin:lead-ieph @service:postgres
Feature: bc-container health status reflects beads usability and messaging reachability

  @scenario_hash:f5925c7103e5c9c6
  Scenario: a BC container with beads usable and the messaging database reachable reports healthy
    Given a BC container named "bc-shopsystem-messaging" is running
    And beads is functionally usable inside the container and the messaging database at SHOPMSG_DSN is reachable
    When I inspect the container's health status via docker inspect
    Then the container's reported health status is "healthy"

  @scenario_hash:1d2ca4ee3d7676a6
  Scenario: a BC container whose messaging database is unreachable reports unhealthy despite the process being alive
    Given a BC container named "bc-shopsystem-messaging" is running with its agent process alive
    And the messaging database at SHOPMSG_DSN is not reachable
    When I inspect the container's health status via docker inspect
    Then the container's reported health status is "unhealthy"

  @scenario_hash:eeb628e1df7ed005
  Scenario: a BC container whose beads is not functionally usable reports unhealthy despite the process being alive
    Given a BC container named "bc-shopsystem-messaging" is running with its agent process alive
    And bd create run inside the container's workspace directory exits non-zero
    When I inspect the container's health status via docker inspect
    Then the container's reported health status is "unhealthy"
