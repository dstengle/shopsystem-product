@bc:shopsystem-templates @origin:lead-dui6 @service:agent-vault-broker
Feature: the scripted approve-claude step inside bin/agent-vault-provision captures the issued Claude token and writes a NON-EMPTY CLAUDE_OAUTH credential back into the vault — never a blank writeback (bugfix lead-dui6)
  The approve-claude capture/writeback logic lives INSIDE the rendered
  bin/agent-vault-provision, not a separate script. When the operator supplies
  the issued Claude token at approve-time the step writes CLAUDE_OAUTH back
  equal to the captured token; when token capture yields an empty value the step
  aborts with a diagnostic rather than writing a blank back over the issued
  credential. Additive — preserves the env-driven inputs + single approval
  handoff (broker/13) and the no-automated-real-credential-transport rule
  (broker/11): the token is captured only at approve-time, never automated.

  @scenario_hash:1c054dfdc468860a
  Scenario: the scripted approve-claude step in the rendered provisioning path captures the issued token and writes a NON-EMPTY Claude credential value, never a blank writeback
    Given a "lead" shop bootstrapped by "shop-templates" with the rendered ops script "bin/agent-vault-provision" whose approve-claude logic lives inside that script and not a separate script
    And an approve-claude approval that issues a valid NON-EMPTY Claude token — the same approval performed manually through the broker web interface stores a non-empty credential, proving upstream issuance is correct
    When the rendered "bin/agent-vault-provision" approve-claude step captures the issued token and writes the "CLAUDE_OAUTH" credential back into the vault
    Then the "CLAUDE_OAUTH" credential value stored in the vault is NON-EMPTY and equals the issued token — the scripted writeback carries the captured token material, not a blank value
    And the approve-claude step never writes a blank/empty "CLAUDE_OAUTH" credential: when token capture yields an empty value it aborts with a diagnostic rather than writing the blank back over the issued credential
