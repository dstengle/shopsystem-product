@bc:shopsystem-bc-launcher @origin:brief-004
Feature: bc-container launch workspace-mount and opt-in docker-socket mount

  @scenario_hash:0bc8e4532c04bf72
  Scenario: launch with a workspace-mount bind-mounts the host tree as /workspace and skips the clone
    Given the shopsystem-bc-launcher BC is installed
    And an existing host working tree at a path "/host/lead-repo" containing a git repository
    When I run bc-container launch with the workspace-mount option set to "/host/lead-repo" and no repo URL
    And the container starts
    Then the container has a bind mount whose source is the host path "/host/lead-repo" and whose target is "/workspace"
    And no git clone is performed for the launch
    And the container's /workspace is the host tree presented unchanged

  @scenario_hash:9fc84c8424b2a223
  Scenario: launch with a workspace-mount does not re-run clone-path provisioning on the live tree
    Given the shopsystem-bc-launcher BC is installed
    And an existing host working tree at a path "/host/lead-repo" with a committed ".beads" registry and poured ".claude/skills"
    When I run bc-container launch with the workspace-mount option set to "/host/lead-repo" and no repo URL
    And the container starts
    Then no bd bootstrap is run against the mounted /workspace
    And no shop-templates re-pour overwrites the mounted ".claude/skills"
    And the mounted /workspace ".beads" registry and ".claude/skills" are byte-unchanged from the host tree after launch

  @scenario_hash:ff370a4e7e9dac5e
  Scenario: launch mounts the host docker socket only when the opt-in lead-only flag is given
    Given the shopsystem-bc-launcher BC is installed
    When I run bc-container launch with the docker-socket opt-in flag enabled
    And the container starts
    Then the container has a bind mount whose source is the host docker socket "/var/run/docker.sock"
    And docker inspect of the container shows the docker socket mount present

  @scenario_hash:e177655ba09a73fa
  Scenario: launch mounts no docker socket by default when the opt-in flag is absent
    Given the shopsystem-bc-launcher BC is installed
    When I run bc-container launch without the docker-socket opt-in flag
    And the container starts
    Then the container has no bind mount whose source is the host docker socket "/var/run/docker.sock"
    And docker inspect of the container shows no docker socket mount present

  @scenario_hash:c63857720446813b
  Scenario: launch with the docker-socket opt-in flag grants the launched container's non-root user usable access to the mounted socket
    Given the shopsystem-bc-launcher BC is installed
    And the host docker socket "/var/run/docker.sock" is owned by group id "984"
    When I run bc-container launch with the docker-socket opt-in flag enabled
    And the container starts
    Then the container has a bind mount whose source is the host docker socket "/var/run/docker.sock"
    And docker inspect of the container shows the host docker socket group id "984" present in the container's supplementary groups
    And a docker call made by the container's non-root default user is not rejected with a permission-denied error against the docker socket

  @scenario_hash:f49c7fd3c38ac741
  Scenario: launch without the docker-socket opt-in flag adds no docker-socket group to the launched container
    Given the shopsystem-bc-launcher BC is installed
    And the host docker socket "/var/run/docker.sock" is owned by group id "984"
    When I run bc-container launch without the docker-socket opt-in flag
    And the container starts
    Then the container has no bind mount whose source is the host docker socket "/var/run/docker.sock"
    And docker inspect of the container shows the host docker socket group id "984" absent from the container's supplementary groups
