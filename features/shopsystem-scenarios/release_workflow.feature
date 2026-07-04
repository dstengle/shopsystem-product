@bc_internal
Feature: shopsystem-scenarios — release and packaging contracts

  @scenario_hash:f49eaa943ed4fb3b @bc:shopsystem-scenarios
  Scenario: shopsystem-scenarios release workflow declares NO repository_dispatch emit to shopsystem-bc-launcher and references NO BC_LAUNCHER_DISPATCH_TOKEN
    Given the shopsystem-scenarios release workflow at ".github/workflows/release.yml"
    And bc-base rebuilds are driven by shopsystem-bc-launcher's own centralized scheduled poll per ADR-022, not by a per-repo repository_dispatch emit
    When the release workflow's executable body, with YAML comment lines excluded, is inspected on a version-tag release
    Then the executable body declares no step performing a repository_dispatch targeting "dstengle/shopsystem-bc-launcher"
    And the executable body references no secret named "BC_LAUNCHER_DISPATCH_TOKEN"
    And a repository_dispatch target or BC_LAUNCHER_DISPATCH_TOKEN reference present only in a descriptive YAML comment, absent from the executable body, does not fail this guarantee
