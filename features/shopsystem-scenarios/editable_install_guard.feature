@bc_internal
Feature: shopsystem-scenarios — conftest editable-install guard

  @scenario_hash:1db84538be1f0878 @bc:shopsystem-scenarios
  Scenario: collection fails fast when a stale non-editable wheel shadows the workspace scenarios package
    Given a clean checkout whose "scenarios" package is importable from the workspace "src/scenarios/"
    And a non-editable "scenarios" wheel under site-packages that shadows "src/scenarios/" and lacks modules present in "src/scenarios/"
    When pytest collection runs the conftest editable-install guard
    Then collection fails before any test runs
    And the failure message names the "scenarios" package and its resolved site-packages path
    And the failure message states the workspace "src/" path the package was expected to resolve under
    And the failure message includes the remediation "pip install -e ."

  @scenario_hash:4ba1ddd8fc25a2eb @bc:shopsystem-scenarios
  Scenario: collection proceeds normally under a correct editable install of the scenarios package
    Given a clean checkout whose "scenarios" package resolves from the workspace "src/scenarios/" editable install
    And no non-editable site-packages copy shadows "src/scenarios/"
    When pytest collection runs the conftest editable-install guard
    Then the guard raises no error
    And collection proceeds and the test suite runs against "src/scenarios/"
