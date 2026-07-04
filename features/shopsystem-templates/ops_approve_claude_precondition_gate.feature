@bc:shopsystem-templates @origin:lead-m1dc @service:agent-vault-broker
Feature: the rendered bin/agent-vault-approve-claude verifies every required input and endpoint reachability BEFORE any mutating step and makes zero partial changes on a missing precondition (robustness, lead-m1dc)
  The v0.47.0 login -> /v1/credentials/oauth/tokens populate path added an owner
  (member-role) login requirement the predecessor proposal-approve path never
  needed. Without a verify-all-before-mutate gate a missing owner password (or
  any other required input / unreachable endpoint) breaks AFTER the proposal/slot
  was ensured, leaving partial vault state. This pins the full-process-or-zero
  contract: every required input and every endpoint reachability is verified
  before the owner login, before ensuring the proposal/slot, and before the
  oauth/tokens writeback; on any gap the script exits non-zero naming the
  specific missing precondition and makes zero partial changes. Additive over the
  preserved proposal-approve + oauth-tokens-populate flow (lead-al1r); retires no
  pin.

  @scenario_hash:3b7e07095a354e0a
  Scenario: the rendered "bin/agent-vault-approve-claude" verifies every required input and endpoint reachability BEFORE any mutating step, and on a missing precondition fails fast with an actionable diagnostic while making ZERO partial changes
    Given a "lead" shop bootstrapped by "shop-templates" with the rendered ops script "bin/agent-vault-approve-claude" whose token-seed path resolves the ops-coordinates, performs an owner "POST /v1/auth/login", ensures the CLAUDE_OAUTH proposal/slot, and performs "POST /v1/credentials/oauth/tokens" with the access and refresh tokens
    When the operator runs "bin/agent-vault-approve-claude" in a session missing one or more required inputs — the Claude credential/token source, the owner login credentials, the broker address, or the resolvable ops-coordinates — or where a required broker endpoint is unreachable
    Then "bin/agent-vault-approve-claude" verifies every required input is present and every endpoint it will call is reachable BEFORE performing any mutating step (before the owner login, before ensuring the proposal/slot, before the oauth/tokens writeback)
    And on any missing input or unreachable endpoint it exits non-zero with a clear, actionable diagnostic naming the specific missing precondition, rather than failing partway through with an opaque message that tells the operator only to retry
    And it makes ZERO partial changes when a precondition fails — no proposal/slot is created or mutated and no token writeback is attempted — so the vault is left in exactly its pre-run state
