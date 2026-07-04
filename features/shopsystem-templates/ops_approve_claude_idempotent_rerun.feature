@bc:shopsystem-templates @origin:lead-m1dc @service:agent-vault-broker
Feature: the rendered bin/agent-vault-approve-claude is idempotent — a re-run after a failed or successful prior attempt lands the populated refreshing CLAUDE_OAUTH credential regardless of partial prior state (robustness, lead-m1dc)
  The first cut required a PENDING CLAUDE_OAUTH proposal and aborted ("no pending
  proposal found") on a re-run after the proposal was already approved — so an
  interrupted run could not be safely retried. This pins idempotency: ensuring
  the CLAUDE_OAUTH proposal/slot is a create-OR-reuse, so a re-run after a failed
  or a successful prior attempt completes cleanly and lands a populated,
  refreshing credential regardless of whatever partial state the prior attempt
  left behind. Additive over the preserved proposal-approve + oauth-tokens
  populate flow (lead-al1r); retires no pin.

  @scenario_hash:9aa82d211517155d
  Scenario: the rendered "bin/agent-vault-approve-claude" is idempotent — a re-run after a failed OR a successful prior attempt completes cleanly and lands the populated refreshing CLAUDE_OAUTH credential regardless of any partial prior state
    Given a "lead" shop bootstrapped by "shop-templates" with the rendered ops script "bin/agent-vault-approve-claude"
    And a vault left in a partial state by a prior interrupted run — for example a CLAUDE_OAUTH proposal/slot was already created but the "POST /v1/credentials/oauth/tokens" token writeback never completed — or a vault already carrying a fully populated CLAUDE_OAUTH credential from a prior successful run
    When the operator re-runs "bin/agent-vault-approve-claude" with all required inputs present
    Then the re-run completes successfully rather than erroring on the pre-existing partial or prior state — it ensures (creates-or-reuses) the CLAUDE_OAUTH proposal/slot rather than aborting because one already exists
    And the end state after the re-run is a populated, refreshing CLAUDE_OAUTH credential — non-empty token material, refresh token present, connected — regardless of whatever partial state the prior attempt left behind
