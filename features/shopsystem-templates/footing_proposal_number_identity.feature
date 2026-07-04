@bc:shopsystem-templates @origin:lead-21uk
Feature: approve-claude approves the CLAUDE_OAUTH proposal by its identity number
  The proposal-number parse must take the proposal's '#' identity column, not the
  trailing CREATED-timestamp minutes. footing persists the create-time number into
  .env; approve-claude reads it, and both list-parse fallbacks take the '#' column.

@scenario_hash:d8422606299d8819
Scenario: approve-claude approves the pending CLAUDE_OAUTH proposal by its identity number not a timestamp digit
  Given the footing script has created exactly one pending CLAUDE_OAUTH proposal whose identity number is "1"
  And the broker's "proposal create --json" output reports that proposal's number as "1"
  And the broker's "proposal list --status pending" output is an ANSI table whose data row shows "1" in the leading "#" column and a CREATED timestamp of "2026-06-26 16:58" whose trailing minutes are "58"
  When footing records the created proposal's identity number
  And the operator runs "bin/agent-vault-approve-claude" with the Claude OAuth secret
  Then footing persists the create-time identity number "1" into ".env" as "CLAUDE_OAUTH_PROPOSAL_NUM"
  And approve-claude resolves the proposal number to "1" by reading the persisted "CLAUDE_OAUTH_PROPOSAL_NUM" from ".env"
  And when approve-claude instead falls back to parsing "proposal list" it takes the leading "#" column value "1" and never the CREATED-timestamp trailing digits "58"
  And footing's own "proposal list" fallback likewise resolves "1" and never "58"
  And approve-claude runs "proposal approve 1" and reports success approving the CLAUDE_OAUTH credential
  And approve-claude never runs "proposal approve 58" and never reports "Proposal #58 not found"
