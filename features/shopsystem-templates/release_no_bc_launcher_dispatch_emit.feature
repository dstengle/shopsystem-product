@bc:shopsystem-templates @origin:adr-022
Feature: the surviving templates release.yml emits nothing downstream while retaining its version-hygiene guard

  Per ADR-022 the cross-repo repository_dispatch fan-in that previously
  notified the bc-launcher on each release was RETIRED with no successor
  (the prior scenario 26ca8a14e01db50c was retired by lead-zgrk). The
  release.yml file is NOT deleted: it retains its release-guard
  version-hygiene job (scenario-192). This scenario PINS that surviving
  no-emit shape as a registered, hashed behavior — register parity with
  shopsystem-scenarios (lead-vusv) and shopsystem-messaging (lead-0udp).

  @scenario_hash:846e4e663198ce78
  Scenario: the surviving templates release.yml declares no repository_dispatch emit to bc-launcher and references no BC_LAUNCHER_DISPATCH_TOKEN, while its version-hygiene guard remains intact
    Given the shopsystem-templates repository carries a ".github/workflows/release.yml" workflow file
    And that workflow retains its version-hygiene "release-guard" job that enforces the scenario-192 release-tag-equals-pyproject-version invariant
    When the workflow's executable body is read with YAML comment lines excluded
    Then the executable body declares no "repository_dispatch" step or job that targets "dstengle/shopsystem-bc-launcher"
    And the executable body references no "BC_LAUNCHER_DISPATCH_TOKEN" secret or any other cross-repo dispatch credential
    And a "repository_dispatch" target or a "BC_LAUNCHER_DISPATCH_TOKEN" reference appearing only in a descriptive YAML comment, absent from the executable body, does not cause this scenario to fail
    And the "release-guard" version-hygiene job and its scenario-192 assertions remain present and undisturbed in the executable body
