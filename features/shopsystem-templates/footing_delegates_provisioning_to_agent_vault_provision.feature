@bc:shopsystem-templates @origin:pdr-022 @service:agent-vault-broker
Feature: footing delegates broker provisioning to bin/agent-vault-provision (PDR-022 Phase A) — at its provisioning step the rendered bin/footing INVOKES the rendered bin/agent-vault-provision instead of inlining vault-create or the broker-local GitHub PAT store, the delegated path carries the fleet-agent-token mint + service wiring + a non-empty AGENT_VAULT .env writeback, and bin/agent-vault-provision performs the broker-local docker-exec vault-create (no --address, lead-4sg9) and the broker-local docker-exec GITHUB_TOKEN credential store (never an owner remote vault-scoped session, lead-0j60 / PDR-022 D3), sourcing the single bin/ops-coordinates artifact (ADR-043). The two prior footing-inlined guarantees (hash a3242f1f65e52caf, footing-inlined vault-create; and hash 7c96f830aa7c0a50, footing-inlined GitHub PAT store) are SUPERSEDED by 229.1/230.1/230.2 and retired — they are already absent as live tags. The final broker round-trip Thens of 230.1/230.2 ("the <slug> vault exists in the broker" / "the GITHUB_TOKEN credential is present in the <slug> vault") are LEAD live-verify against a real broker, not part of the BC's script-shape demonstration.

  @scenario_hash:b3a0a0b6b1fbd217
  Scenario: at its provisioning step the footing runway invokes bin/agent-vault-provision and no longer inlines vault-create or the GitHub PAT store
    Given a "lead" shop whose rendered "bin/footing" runway has reached its provisioning step with the broker ready, the owner password generated, and the GitHub PAT collected
    When "bin/footing" runs through its provisioning step
    Then it invokes the rendered "bin/agent-vault-provision", passing the owner password and the GitHub PAT, to perform owner registration, vault creation, the GitHub credential set, service wiring, the fleet-agent-token mint, the CA fetch, and the ".env" writeback
    And "bin/footing" itself performs no inlined "vault create" and no inlined broker-local GitHub PAT "credential set" — those provisioning operations exist only inside "bin/agent-vault-provision"

  @scenario_hash:5ee9de8b3f9ab137
  Scenario: after delegating to provision the footing path carries the fleet-agent-token, the service wiring, and the AGENT_VAULT .env writeback that downstream launches need
    Given a "lead" shop whose rendered "bin/footing" has invoked "bin/agent-vault-provision" at its provisioning step
    When "bin/agent-vault-provision" returns control to "bin/footing"
    Then the product slug's fleet agent-token has been minted and the github-git, github-api, and claude services are wired in the broker
    And the run's ".env" carries non-empty "AGENT_VAULT_TOKEN", "AGENT_VAULT_VAULT", and "AGENT_VAULT_CA_PEM" values, so that "bin/shop-shell" and the subsequent BC launches read them rather than finding them absent

  @scenario_hash:fc35c1cd8a891dff
  Scenario: bin/agent-vault-provision creates the product-slug vault broker-locally as part of its provisioning sequence
    Given a running agent-vault broker that holds no vault for the product slug
    And the rendered "bin/agent-vault-provision" sourcing the single "bin/ops-coordinates" artifact for the slug, broker container, and vault name rather than re-deriving them
    When the lead or "bin/footing" runs "bin/agent-vault-provision"
    Then it creates the "<slug>" vault via a broker-local "docker exec" "vault create" that passes no "--address" flag
    And after the run the "<slug>" vault exists in the broker — the vault-create guarantee moved out of the now-removed footing-inlined vault-create

  @scenario_hash:c3381f4763c74361
  Scenario: bin/agent-vault-provision sets the GITHUB_TOKEN credential broker-locally via docker exec
    Given a running agent-vault broker with the "<slug>" vault created and the GitHub username and PAT supplied to provision via environment or arguments
    And the rendered "bin/agent-vault-provision" sourcing the single "bin/ops-coordinates" artifact for the broker container name rather than re-deriving it
    When "bin/agent-vault-provision" runs its GitHub credential step
    Then it stores the GitHub PAT as the "GITHUB_TOKEN" credential through a broker-local "docker exec" into the broker container, never through an owner remote vault-scoped session
    And after the run the "GITHUB_TOKEN" credential is present in the "<slug>" vault — the credential-set guarantee moved out of the now-removed footing-inlined PAT store
