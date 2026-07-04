@bc:shopsystem-bc-launcher @origin:lead-53y0
Feature: bc-container launch resolves and injects SHOPMSG_SYSTEM_SLUG into the launched container

  bc-launcher RESOLVES the product slug (SHOPMSG_SYSTEM_SLUG env on the launcher
  invocation > manifest product: > default 'shopsystem') and INJECTS it into the
  launched BC container's docker run as -e SHOPMSG_SYSTEM_SLUG=<resolved>,
  mirroring the existing SHOPMSG_DSN injection. bc-launcher never reads or
  consumes SHOPMSG_SYSTEM_SLUG itself; the consumer is the BC's own shop-msg at
  runtime. The injected slug, the docker network name, and the BC-name-shape
  prefix all derive from the ONE manifest product: resolver (lead-53y0).

  @scenario_hash:1fcba5b74c7c2541
  Scenario: launch injects -e SHOPMSG_SYSTEM_SLUG from the manifest product field when no env override
    Given a bc-manifest.yaml exists with product field "dummyco"
    And no SHOPMSG_SYSTEM_SLUG override is set on the launcher invocation
    And no explicit "--network" flag is provided
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the command exits zero
    And the FakeDockerDriver records that the docker run command for "bc-shopsystem-messaging" includes the flag "-e SHOPMSG_SYSTEM_SLUG=dummyco"

  @scenario_hash:cefb043d0b16399f
  Scenario: a SHOPMSG_SYSTEM_SLUG env override on the launcher invocation wins over manifest product
    Given a bc-manifest.yaml exists with product field "dummyco"
    And a SHOPMSG_SYSTEM_SLUG override "overrideco" is set on the launcher invocation
    And no explicit "--network" flag is provided
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the command exits zero
    And the FakeDockerDriver records that the docker run command for "bc-shopsystem-messaging" includes the flag "-e SHOPMSG_SYSTEM_SLUG=overrideco"
    And the FakeDockerDriver records that the docker run command does NOT include "-e SHOPMSG_SYSTEM_SLUG=dummyco"

  @scenario_hash:efba53a27679b509
  Scenario: under the default product slug launch injects -e SHOPMSG_SYSTEM_SLUG=shopsystem without regressing behavior
    Given a bc-manifest.yaml exists with product field "shopsystem"
    And no SHOPMSG_SYSTEM_SLUG override is set on the launcher invocation
    And no explicit "--network" flag is provided
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the command exits zero
    And the FakeDockerDriver records that the docker run command for "bc-shopsystem-messaging" includes the flag "-e SHOPMSG_SYSTEM_SLUG=shopsystem"

  @scenario_hash:11c8e7f995a6f142
  Scenario: the docker network name and the BC-name-shape prefix both derive from the same manifest product slug
    Given a bc-manifest.yaml exists with product field "dummyco"
    And no SHOPMSG_SYSTEM_SLUG override is set on the launcher invocation
    And no explicit "--network" flag is provided
    When I run bc-container launch with BC name "dummyco-messaging"
    Then the command exits zero
    And the FakeDockerDriver records that the docker run command for "bc-dummyco-messaging" includes the flag "--network dummyco"
    And the FakeDockerDriver records that the docker run command for "bc-dummyco-messaging" includes the flag "-e SHOPMSG_SYSTEM_SLUG=dummyco"
    And a manifest file with product field "dummyco" containing a single BC entry named "dummyco-widget" with a valid GitHub remote URL and role label "bc" validates ok with the manifest product slug
    And a manifest file with product field "dummyco" containing a single BC entry named "shopsystem-messaging" with a valid GitHub remote URL and role label "bc" is rejected as not matching the manifest product slug
