@bc:shopsystem-bc-launcher @origin:lead-pixf
Feature: bc-container agent-presence reporting and infra-failure surfacing (lead-pixf / lead-8aqh)

  @scenario_hash:f2ddd6c75425573e
  Scenario: bc-container status reports the BC online when its agent is live
    Given the shopsystem-bc-launcher BC is installed
    And a Docker container named "bc-shopsystem-messaging" is running
    And a tmux session named "agent" exists inside the container with a live claude agent process whose "shop-msg watch" is armed
    When I run bc-container status with BC name "shopsystem-messaging"
    Then the command exits zero
    And stdout includes the BC name "shopsystem-messaging"
    And stdout includes the container state "running"
    And stdout reports the agent presence as "online"

  @scenario_hash:010e776c8e98d0e6
  Scenario: bc-container list errors non-zero when the docker socket is unreachable
    Given the shopsystem-bc-launcher BC is installed
    And the docker socket is unreachable so container inspection is denied
    When I run bc-container list
    Then the command exits non-zero
    And stderr reports that the docker socket could not be reached
    And stdout does not report "No BC containers found"

  @scenario_hash:aeebb281bfe68ae5
  Scenario: bc-container start-agent detects an existing live agent and no-ops instead of hanging on the readiness probe
    Given the shopsystem-bc-launcher BC is installed
    And a Docker container named "bc-shopsystem-messaging" is running
    And a tmux session named "agent" exists inside the container with a live claude agent process already at the input-ready marker "bypass permissions on"
    When I run bc-container start-agent with BC name "shopsystem-messaging"
    Then the command exits zero
    And stdout reports that "bc-shopsystem-messaging" already has a live agent and is online
    And the command does not wait on the readiness-marker probe until the readiness timeout
    And no second claude agent process is started in the tmux session named "agent"
