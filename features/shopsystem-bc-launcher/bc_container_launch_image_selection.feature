@bc:shopsystem-bc-launcher @origin:lead-6ze3
Feature: launch image selection — --image flag / BC_IMAGE env override (lead-6ze3)

  Additive tightening of an unpinned, product-locked behaviour. Previously the
  launch image was the hard-coded BC_IMAGE constant with no override path. This
  feature pins image-source resolution with precedence: --image flag overrides
  the BC_IMAGE env var, which overrides the built-in default constant
  (ghcr.io/dstengle/shopsystem-bc-base:latest). A launch can therefore target a
  base image other than the default WITHOUT editing source; absent both flag and
  env, the default is unchanged.

  @scenario_hash:2d6392ab1b01edc8
  Scenario: launch image resolution honours --image flag over BC_IMAGE env over default
    Given the shopsystem-bc-launcher BC is installed
    And the BC_IMAGE environment variable is set to "ghcr.io/acme/custom-bc-base:env"
    When I run bc-container launch with BC name "shopsystem-messaging" and image "ghcr.io/acme/custom-bc-base:flag"
    Then the started container "bc-shopsystem-messaging" is running from image "ghcr.io/acme/custom-bc-base:flag"
    And the started container "bc-shopsystem-messaging" is NOT running from image "ghcr.io/dstengle/shopsystem-bc-base:latest"

  @scenario_hash:a89576365a08e59b
  Scenario: launch image resolution falls back to BC_IMAGE env when no --image flag is given
    Given the shopsystem-bc-launcher BC is installed
    And the BC_IMAGE environment variable is set to "ghcr.io/acme/custom-bc-base:env"
    When I run bc-container launch with BC name "shopsystem-messaging" and no image flag
    Then the started container "bc-shopsystem-messaging" is running from image "ghcr.io/acme/custom-bc-base:env"
    And the started container "bc-shopsystem-messaging" is NOT running from image "ghcr.io/dstengle/shopsystem-bc-base:latest"

  @scenario_hash:68aba4105e28b5aa
  Scenario: launch image resolution defaults to bc-base latest when neither flag nor env is set
    Given the shopsystem-bc-launcher BC is installed
    And the BC_IMAGE environment variable is not set
    When I run bc-container launch with BC name "shopsystem-messaging" and no image flag
    Then the started container "bc-shopsystem-messaging" is running from image "ghcr.io/dstengle/shopsystem-bc-base:latest"
