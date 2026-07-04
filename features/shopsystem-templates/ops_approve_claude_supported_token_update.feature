@bc:shopsystem-templates @origin:lead-m1dc @service:agent-vault-broker
Feature: the rendered bin/agent-vault-approve-claude supports updating the CLAUDE_OAUTH tokens after the fact — a later re-run re-POSTs fresh token material as a supported, non-error path (robustness, lead-m1dc)
  Refreshing OAuth tokens rotate, so an operator must be able to push fresh Claude
  token material into an already-populated CLAUDE_OAUTH credential without tearing
  it down. The oauth/tokens endpoint validates the refresh token via a
  refresh-grant against token_url before persisting, so re-POSTing fresh material
  is a supported update path. This pins that contract: a later re-run with newer
  tokens performs the owner login and re-POSTs the new access+refresh tokens as a
  recognised UPDATE of the existing credential rather than erroring because the
  credential already exists. Additive over the preserved proposal-approve +
  oauth-tokens populate flow (lead-al1r); retires no pin.

  @scenario_hash:45dc18d4b0d1730e
  Scenario: the rendered "bin/agent-vault-approve-claude" supports updating the CLAUDE_OAUTH tokens after the fact — a later re-run re-POSTs fresh token material to the oauth-tokens endpoint as a supported, non-error path
    Given a "lead" shop bootstrapped by "shop-templates" with the rendered ops script "bin/agent-vault-approve-claude" and an already-populated, refreshing CLAUDE_OAUTH credential from a prior successful run
    When the operator later re-runs "bin/agent-vault-approve-claude" with newer Claude token material to refresh the stored credential
    Then "bin/agent-vault-approve-claude" treats updating an already-populated CLAUDE_OAUTH credential as a supported path — it performs the owner login and re-POSTs the new access and refresh tokens to "POST /v1/credentials/oauth/tokens" rather than erroring because the credential already exists
    And after the update the CLAUDE_OAUTH credential carries the newly supplied token material and remains in a refreshing/connected state
