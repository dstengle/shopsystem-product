@bc:shopsystem-templates @origin:lead-pdsd
Feature: post-broker footing/approve-claude fixes (oauth tokens, org, PAT store, data-root ownership)
  approve-claude sources both Claude OAuth tokens from the host credentials.json; footing
  derives the GitHub org from the lead repo origin, stores the collected PAT in the vault,
  and owns the created data root + pgdata as the invoking host user.

@scenario_hash:74d0086b73d4e477
Scenario: agent-vault-approve-claude sources both Claude OAuth tokens from the host credentials.json by default
  Given a host whose "~/.claude/.credentials.json" holds a "claudeAiOauth" object carrying an "accessToken", a "refreshToken", and an "expiresAt"
  And the operator runs "agent-vault-approve-claude" with no positional token argument
  When the script approves the "CLAUDE_OAUTH" agent-vault vault proposal of credential type oauth
  Then the script reads the Claude OAuth secret from the host's "~/.claude/.credentials.json" "claudeAiOauth" object by default rather than requiring a single positional token
  And it attaches BOTH the access token and the refresh token, together with the expiry, to the "CLAUDE_OAUTH" oauth credential in the KEY=VALUE form that agent-vault's oauth credential type expects, so the broker can refresh the credential
  And after approval the "CLAUDE_OAUTH" credential carries both the access and refresh tokens rather than a single opaque value
  And a manual override path that supplies the OAuth secret explicitly remains available
  And when "~/.claude/.credentials.json" is missing or unreadable the script exits non-zero with a diagnostic naming the unreadable credentials file

@scenario_hash:da11e122c275a344
Scenario Outline: footing derives the GitHub org from the cloned lead repo origin remote instead of a hardcoded default
  Given a cloned "<product>-lead" repository whose git "origin" remote URL names the owner "<origin_owner>"
  And no "GITHUB_ORG" value is exported into the environment
  When the footing script runs its repository-and-remote wiring step
  Then footing parses the owner from "git remote get-url origin" and uses "<origin_owner>" as the GitHub org rather than a hardcoded default owner
  And footing creates the "<slug>-lead-beads" repository under "<origin_owner>"
  And footing wires the git origin remote and the bd dolt remote under "<origin_owner>"
  And the rendered footing script carries no hardcoded "dstengle" org default

  Examples:
    | origin_owner |
    | dstengle     |
    | acme-corp    |

