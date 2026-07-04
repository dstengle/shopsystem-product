@bc:shopsystem-templates @origin:adr-028 @service:agent-vault-broker
Feature: ops agent-vault broker render (lead shop) — the bootstrap-rendered compose.yaml names the real agent-vault broker image, wires the master-password env, and publishes slug-derived broker ports, and bootstrap renders a top-level .env.example carrying the broker credential placeholders, both additively to the existing six-file ops-tool set

  @scenario_hash:568e33d4d441069b
  Scenario: the ops "compose.yaml" rendered by bootstrap for a "lead" shop names the real agent-vault broker image, wires the master-password env, and publishes the broker proxy ports — so the rendered agent-vault service can hold credentials and proxy traffic on the documented bootstrap path
    Given an existing git repository at a target directory "/tmp/example-lead-shop"
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "<slug>", and target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And the rendered "compose.yaml" "agent-vault" service image is the broker image the live fleet references, namely "infisical/agent-vault:latest", and is NOT "hashicorp/vault:latest"
    And the rendered "compose.yaml" contains no case-insensitive occurrence of the literal "hashicorp"
    And the rendered "agent-vault" service environment carries an "AGENT_VAULT_MASTER_PASSWORD" entry sourced from the instance environment (e.g. "${AGENT_VAULT_MASTER_PASSWORD}"), so the broker can auto-unseal per ADR-028 D1
    And the rendered "agent-vault" service publishes the broker API port and the broker proxy port, slug-derived and override-able, mirroring the existing postgres host-port derivation (default fleet exposes 14321 and 14322)
    And the broker image reference is product-neutral / parameterized as the live fleet references it, not a "<slug>"-baked literal
    And for a non-default slug such as "dummyco" the rendered "compose.yaml" agent-vault block introduces zero new "shopsystem" literal, leaving any prior slug-genericity pins non-regressing and the change additive
