@bc:shopsystem-bc-launcher @origin:lead-wdvx
Feature: bc-container docker-dependent subcommands surface a docker config fault distinctly from an empty result

  @scenario_hash:510d02951321628e
  Scenario: bc-container list reports a docker-unreachable diagnostic instead of an empty success when the socket is permission-denied
    Given the shopsystem-bc-launcher BC is installed
    And the Docker socket is mounted but the calling user is denied access to it so docker calls fail with a permission-denied error
    When I run bc-container list
    Then the command exits non-zero
    And stderr names the cause as the Docker daemon being unreachable due to the socket being permission-denied or not mounted
    And stdout does not include "No BC containers found."

  @scenario_hash:2123096c12854ff1
  Scenario Outline: a bc-container subcommand that depends on Docker surfaces a docker-unreachable config error distinctly from a legitimate empty-or-absent result
    Given the shopsystem-bc-launcher BC is installed
    And the Docker daemon cannot be reached because <docker_fault>
    When I run the Docker-dependent bc-container subcommand "<subcommand>"
    Then the command exits non-zero
    And stderr names the cause as the Docker daemon being unreachable
    And the output is distinguishable from the legitimate result the subcommand would print when Docker is reachable but the queried container is absent or the list is empty

    Examples:
      | subcommand | docker_fault                                                  |
      | list       | the socket is permission-denied to the calling user            |
      | list       | the socket is not mounted into the calling environment         |
      | status     | the socket is permission-denied to the calling user            |
