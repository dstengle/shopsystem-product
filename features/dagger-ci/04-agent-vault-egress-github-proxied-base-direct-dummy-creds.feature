@bc:shopsystem-bc-launcher @origin:adr-055
Feature: the dagger build egress routes github release downloads through agent-vault with dummy creds while public base pulls and dagger-infra hosts stay direct

  Agent-vault is the sole credential surface for the dagger build egress — ADR-054 D1
  (dagger secrets carry only dummy values; the agent-vault MITM proxy injects real creds
  on-wire, nothing real in a secret or an image layer), D2 (the privileged engine joined to
  the shopsystem net; BuildKit propagates the daemon proxy env into every RUN with zero
  Dockerfile edits), D3 NEW-A (NO_PROXY needs registry apex forms so the public base pull
  stays direct) and NEW-B (dagger-infra hosts whitelisted so module runtime codegen builds
  direct while github.com stays proxied). EXTENDS ADR-049 (agent-vault sole credential
  surface) from the fabro loop to the build pipeline; carve-out in ADR-055 (build-time
  CA-trust is MITM-local infra). Anchored on ADR-052 (umbrella), ADR-018/PDR-011
  (contract-surface pre-state — the recipe was proven on-host, no BC source
  read/run/git-observed; findings/dagger-spike/*.md are the artifact surface). Evidence:
  findings/dagger-spike/01a-egress.md + 02-dagger-experiment.md (b) NEW-A/NEW-B. Distinct
  from features/fabro-orchestration/02 (agent-vault-only credential injection under fabro,
  the x-api-key-to-OAuth shim) and features/bc-launcher/46 (github credential brokered
  through agent-vault at container runtime) — those pin the runtime credential wire; this
  pins the BUILD-TIME egress routing split; NET-NEW, not a duplicate.
  @scenario_hash:2c13b47417b86d09
  Scenario: a build-time fabro release download routes through agent-vault with a dummy token while the public base pull and dagger-infra hosts stay direct
    Given a privileged dagger engine joined to the shopsystem docker net with HTTP(S)_PROXY set to the agent-vault handle
    And NO_PROXY carrying the registry apex forms and the dagger-infra hosts while github.com is deliberately not listed
    And a dagger secret carrying only a dummy GITHUB_TOKEN value
    When "dagger call build-and-test" builds the fabro install RUN whose egress downloads a fabro release asset from github.com
    Then the fabro release download routes through agent-vault because github.com is proxied, and the proxy injects the real credential on-wire so the dummy token never appears in a secret or an image layer
    And the public base-image pull stays direct because the registry apex forms are in NO_PROXY
    And the dagger module runtime codegen builds direct because the dagger-infra hosts are in NO_PROXY
