@bc:shopsystem-templates @origin:lead-9bvd
Feature: the footing bootstrap script forces every tooling-created repository under the derived product slug

  @scenario_hash:db2131f49c170bc8
  Scenario: every tooling-created repository is forced under the derived product slug
    Given the bootstrap script has derived the product slug "acme"
    When the script creates the beads repository and any BC repository for the product
    Then the beads repository is named "acme-lead-beads"
    And any BC repository named "<bc>" is created as "acme-<bc>" with its beads repository "acme-<bc>-beads"
    And no tooling-created repository can be named outside the "acme-*" shape
