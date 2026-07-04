@bc:shopsystem-bc-launcher @origin:adr-043
Feature: bc-container product-scoped Docker network naming

  @scenario_hash:c1eac3b07f198049
  Scenario: bc-container launch derives the Docker network name from the product field in bc-manifest.yaml
    Given a bc-manifest.yaml exists containing:
      """
      product: shopsystem product
      bcs:
        - name: shopsystem-messaging
          remote: https://github.com/dstengle/shopsystem-messaging.git
          role: bc
      """
    And no Docker container named "bc-shopsystem-messaging" is running
    And no explicit "--network" flag is provided
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the command exits zero
    And the FakeDockerDriver records that the docker run command for "bc-shopsystem-messaging" includes the flag "--network shopsystem-product"

  @scenario_hash:3c50a40bbc918f8e
  Scenario: network name derivation slugifies the product field by lowercasing and replacing spaces with hyphens
    Given a bc-manifest.yaml exists with product field "My Ecommerce Shop"
    And no Docker container named "bc-shopsystem-messaging" is running
    And no explicit "--network" flag is provided
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the FakeDockerDriver records that the docker run command for "bc-shopsystem-messaging" includes the flag "--network my-ecommerce-shop"

  @scenario_hash:384b6296b6779419
  Scenario: bc-container launch exits non-zero when no bc-manifest.yaml exists and no --network flag is provided
    Given no bc-manifest.yaml exists in the working directory
    And no explicit "--network" flag is provided
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the command exits non-zero
    And stderr includes the text "no network: bc-manifest.yaml not found and --network not provided"

  @scenario_hash:8a26d4aa1da12870
  Scenario: bc-container launch creates the derived network before starting the container when the network does not exist
    Given a bc-manifest.yaml exists with product field "shopsystem product"
    And no Docker network named "shopsystem-product" exists
    And no Docker container named "bc-shopsystem-messaging" is running
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the command exits zero
    And the FakeDockerDriver records that "docker network create shopsystem-product" was called before "docker run"
    And a Docker network named "shopsystem-product" exists

  @scenario_hash:c06b181e342f5191
  Scenario: bc-container launch does not attempt to create the network when it already exists
    Given a bc-manifest.yaml exists with product field "shopsystem product"
    And a Docker network named "shopsystem-product" already exists
    And no Docker container named "bc-shopsystem-messaging" is running
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the command exits zero
    And the FakeDockerDriver records that "docker network create shopsystem-product" was NOT called
    And a Docker container named "bc-shopsystem-messaging" is running

  @scenario_hash:9378f92b158b4ffc
  Scenario: explicit --network flag overrides the network name derived from bc-manifest.yaml
    Given a bc-manifest.yaml exists with product field "shopsystem product"
    And no Docker container named "bc-shopsystem-messaging" is running
    When I run bc-container launch with BC name "shopsystem-messaging" and flag "--network custom-net"
    Then the command exits zero
    And the FakeDockerDriver records that the docker run command for "bc-shopsystem-messaging" includes the flag "--network custom-net"
    And the FakeDockerDriver records that the docker run command does NOT include "--network shopsystem-product"

  @scenario_hash:593d25ed835942ed
  Scenario: explicit --network flag suppresses automatic network creation
    Given a bc-manifest.yaml exists with product field "shopsystem product"
    And no Docker network named "custom-net" exists
    And no Docker container named "bc-shopsystem-messaging" is running
    When I run bc-container launch with BC name "shopsystem-messaging" and flag "--network custom-net"
    Then the command exits zero
    And the FakeDockerDriver records that "docker network create" was NOT called
    And the FakeDockerDriver records that the docker run command for "bc-shopsystem-messaging" includes the flag "--network custom-net"

  @scenario_hash:5e76f9229443bd89
  Scenario: two BC containers launched under the same product are both attached to the same derived network
    Given no Docker container named "bc-shopsystem-messaging" is running
    And no Docker container named "bc-shopsystem-scenarios" is running
    When I run bc-container launch with BC name "shopsystem-messaging"
    And I run bc-container launch with BC name "shopsystem-scenarios"
    Then the command exits zero for both launches
    And the FakeDockerDriver records that the docker run command for "bc-shopsystem-messaging" includes the flag "--network shopsystem-product"
    And the FakeDockerDriver records that the docker run command for "bc-shopsystem-scenarios" includes the flag "--network shopsystem-product"

  @scenario_hash:f70e4ad40470198c
  Scenario: network creation is attempted only once when a second BC is launched under the same product network that already exists
    Given no Docker container named "bc-shopsystem-messaging" is running
    And no Docker container named "bc-shopsystem-scenarios" is running
    And no Docker network named "shopsystem-product" exists
    When I run bc-container launch with BC name "shopsystem-messaging"
    And I run bc-container launch with BC name "shopsystem-scenarios"
    Then the FakeDockerDriver records that "docker network create shopsystem-product" was called exactly once across both launches

  @scenario_hash:5a1fc25a7823b268
  Scenario: bc-container launch resolves the shop docker network from the shop's known on-disk configuration without a per-launch --network flag when bc-manifest.yaml carries no shop-level network field
    Given the shopsystem-bc-launcher BC is installed
    And the shop's on-disk configuration declares the shop docker network name "shopsystem" as the single derived network coordinate (the ADR-043 D2 ops-coordinates derivation root; in the interim the compose.yaml network "shopsystem" and the product slug)
    And the bc-manifest.yaml registers the BC "shopsystem-templates" but carries no shop-level network or product launch field
    And no explicit "--network" flag is provided
    And no Docker container named "bc-shopsystem-templates" is running
    When I run bc-container launch with BC name "shopsystem-templates"
    Then the command exits zero
    And the FakeDockerDriver records that the docker run command for "bc-shopsystem-templates" includes the flag "--network shopsystem"
    And the command does not emit the error "no network: bc-manifest.yaml not found and --network not provided"
