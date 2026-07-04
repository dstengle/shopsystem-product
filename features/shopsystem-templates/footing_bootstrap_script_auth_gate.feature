@bc:shopsystem-templates @origin:lead-qb0h
Feature: the footing bootstrap script consolidates all human authentication into one up-front gate

  @scenario_hash:fec7842e905761c8
  Scenario: the bootstrap script consolidates all human authentication into one up-front gate
    Given the bootstrap script is run for a product whose broker holds no credentials yet
    When the script reaches its authentication step
    Then it collects the owner password, the GitHub PAT, and the Claude OAuth credential in a single up-front gate before any later step
    And it captures the Claude OAuth credential in-script by creating an "agent-vault vault proposal" of type oauth and having the human approve it, with no agent-vault dashboard route
    And no later step in the script prompts the human for a credential again
