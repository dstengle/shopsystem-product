@bc:shopsystem-templates @origin:lead-9s46
Feature: cold-INSTALL adopter fixes — bd init --non-interactive + bin/agent-vault-approve-claude
  Two WS-2 cold-INSTALL fixes: bootstrap invokes bd init with the explicit
  --non-interactive flag (the env var alone hangs on a TTY), and a lead bootstrap
  renders an executable bin/agent-vault-approve-claude that auto-resolves the
  broker/vault/proposal and approves the pending CLAUDE_OAUTH proposal from just
  the supplied token.

@scenario_hash:584e2f7352dc2a24
Scenario Outline: bootstrap invokes "bd init" with the explicit "--non-interactive" flag so bd init cannot block on an interactive prompt during scaffolding
  Given an existing git repository at a target directory "<target>" with no ".beads/" directory
  And no terminal is attached to the bootstrap invocation's standard input
  When I invoke the "shop-templates" bootstrap entry point with shop type "<shop_type>", shop name "<shop_name>", and target directory "<target>"
  Then the exit code is 0
  And during the invocation a subprocess named "bd" was executed with first argument "init"
  And the argument list passed to that "bd" subprocess contains the exact token "--non-interactive"
  And the argument list passed to that "bd" subprocess contains the exact token "--skip-agents"
  And that "bd" subprocess completed without blocking on standard input or a controlling terminal
  And after the invocation the target directory contains a ".beads/" directory

  Examples:
    | shop_type | shop_name            | target                 |
    | bc        | shopsystem-messaging | /tmp/example-bc-shop   |
    | lead      | shopsystem-product   | /tmp/example-lead-shop |

@scenario_hash:f726726dba85ac88
Scenario Outline: bootstrap of a "lead" shop named "<slug>" renders an executable "bin/agent-vault-approve-claude" alongside the existing bin/ ops tools, taking the Claude token as a positional argument so the adopter approves the Claude-OAuth proposal without hand-editing a docker exec command
  Given an existing git repository at a target directory "/tmp/example-lead-shop" with no "bin/" subdirectory
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "<slug>", and target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And after the invocation the target directory contains a file at "bin/agent-vault-approve-claude" whose owner-execute permission bit is set
  And the first line of the file at "bin/agent-vault-approve-claude" is exactly "#!/usr/bin/env bash"
  And after the invocation the target directory contains a file at "bin/agent-vault-provision"
  And after the invocation the target directory contains a file at "bin/agent-vault-check"
  And after the invocation the target directory contains a file at "bin/shop-shell"
  And the body of "bin/agent-vault-approve-claude" reads the Claude token from its first positional argument and exits non-zero with a usage diagnostic naming the script when that argument is absent

  Examples:
    | slug       |
    | shopsystem |
    | dummyco    |

@scenario_hash:51969d82e2d951c3
Scenario: bin/agent-vault-approve-claude auto-resolves the broker container, vault slug, and pending proposal number, mints a vault-scoped session internally, and runs the scoped proposal approve carrying the supplied token, so the adopter only runs "bin/agent-vault-approve-claude <claude-token>"
  Given a running agent-vault broker brought up by the bootstrap-rendered compose.yaml with a pending CLAUDE_OAUTH credential-slot proposal created by bin/agent-vault-provision
  When the adopter runs "bin/agent-vault-approve-claude" passing a Claude token as the sole positional argument
  Then the script resolves the broker container, the vault slug, and the pending proposal number from the same slug-derived coordinates bin/agent-vault-provision uses, without the adopter supplying them
  And the script mints a vault-scoped "av_sess_" session against the resolved broker and vault without the adopter editing a command
  And the script runs "vault proposal approve" against the resolved proposal number under that vault-scoped session, attaching the supplied token as the "CLAUDE_OAUTH" credential value with "--yes" and the resolved vault selector
  And the supplied Claude token is the value approved into the CLAUDE_OAUTH credential and is never written to standard output or to a repository file
  And on success the script reports that the CLAUDE_OAUTH credential is approved for the resolved vault and exits 0
