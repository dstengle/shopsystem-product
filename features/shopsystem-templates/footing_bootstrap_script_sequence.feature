@bc:shopsystem-templates @origin:lead-qb0h
Feature: the lead-shop footing bootstrap script runs the footing sequence and stops at solid footing

  @scenario_hash:e69c18dd25104b5e
  Scenario: the bootstrap script runs the footing sequence and stops at solid footing
    Given a freshly forked "<product>-lead" repository with the starter compose, script, and ".env.example" but no framework code
    And the only human interaction is the single up-front auth gate
    When the bootstrap script is run to completion
    Then it brings up the postgres and agent-vault services, pours the lead structure via "shop-templates bootstrap", creates the "<product>-lead-beads" repository, and wires the git and beads remotes
    And it reaches solid footing demonstrated by a successful "git push" and a successful "bd dolt push"
    And it stops at that footing without entering product Discovery or creating any BC
