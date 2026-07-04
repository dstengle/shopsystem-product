@bc:shopsystem-templates @origin:lead-9bvd
Feature: the footing bootstrap script validates the lead repo name and derives the product slug into the manifest

  @scenario_hash:2f9f7bab6fb3e36f
  Scenario: a lead repo name matching the *-lead shape is accepted and its product slug is derived into the manifest
    Given the forked lead repository is named "acme-lead"
    When the bootstrap script validates the repository name
    Then it accepts the name as matching the "*-lead" shape
    And it derives the product slug "acme" by stripping the "-lead" suffix
    And it writes "product: acme" into the manifest as the declared product identity
