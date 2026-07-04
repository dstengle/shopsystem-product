@bc:shopsystem-bc-launcher @origin:lead-yk3o
Feature: launch resolves the bc-base latest digest before running (lead-yy30 / lead-yk3o)

  Per the architect ruling on lead-yk3o, scenario 39 is NOT infra/CI — it is
  in-process launch BEHAVIOR pinned behaviorally.  launch gains an explicit
  digest-resolution step before container start, injected via a RegistryDriver
  protocol fakeable in tests; the fake simulates the registry resolving
  "latest" -> D_new and the test asserts launch resolves, uses D_new, and the
  started container runs from D_new rather than the cached D_old.

  @scenario_hash:af2f03d3ac519cb5
  Scenario: launch resolves the current registry digest of bc-base latest before running, so a republished image reaches the new container
    Given the shopsystem-bc-launcher BC is installed
    And the local Docker cache holds the bc-base "latest" tag at an older digest "D_old"
    And the registry "ghcr.io/dstengle/shopsystem-bc-base" now publishes the "latest" tag at a newer digest "D_new"
    When I run bc-container launch with BC name "shopsystem-messaging" and a valid repo URL
    Then launch resolves the bc-base "latest" tag against the registry and pulls digest "D_new" before starting the container
    And the started container "bc-shopsystem-messaging" is running from image digest "D_new" rather than the cached "D_old"
