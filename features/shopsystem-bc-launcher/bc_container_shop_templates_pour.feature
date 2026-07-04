@bc:shopsystem-bc-launcher @origin:lead-dlrx
Feature: bc-container launch pours the shop-templates skill-group into the launched BC shop (lead-dlrx)

  After cloning the BC repository, bc-container launch runs a shop-templates
  "pour" inside the container's workspace directory, populating the
  workspace's ".claude/skills/" directory with the shop-templates
  skill-group by the time launch completes.  The pour runs as an explicit
  launch step after the clone (and the beads/readiness setup steps), and is
  modelled behaviourally through the DockerDriver seam.

  @scenario_hash:75ae95be0ecf1640
  Scenario: bc-container launch pours the shop-templates skill-group into the launched BC shop after cloning
    Given the shopsystem-bc-launcher BC is installed
    And a BC named "shopsystem-messaging" with a valid repo URL is configured
    And the bc-base image carries the shop-templates binary
    When I run bc-container launch with BC name "shopsystem-messaging"
    And the container has cloned the repository
    Then the shop-templates pour has been run inside the container's workspace directory
    And the workspace's ".claude/skills/" directory is populated with the shop-templates skill-group after launch completes
