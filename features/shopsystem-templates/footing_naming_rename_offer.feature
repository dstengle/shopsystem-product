@bc:shopsystem-templates @origin:lead-9bvd
Feature: the footing bootstrap script offers a gh repo rename when the lead repo name does not match the *-lead shape

  @scenario_hash:7c6797430afa1749
  Scenario: a lead repo name not matching the *-lead shape is offered a gh repo rename rather than a re-fork
    Given the forked lead repository is named "acme" which does not match the "*-lead" shape
    When the bootstrap script validates the repository name
    Then it reports the name does not match the "*-lead" shape
    And it offers to run "gh repo rename" to rename the existing repository to "acme-lead" in place
    And it does not require the human to re-fork the starter template
