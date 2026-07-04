@bc:shopsystem-templates @origin:adr-045
Feature: shop-shell delivers the broker root CA as inline PEM content (ADR-045)
  AGENT_VAULT_CA_PEM travels to the launched leaf as the certificate CONTENT in a
  process-env value (-e), not the path string via the file-based --env-file.

@scenario_hash:7ce09202755b0503
Scenario: the rendered shop-owned bringup path delivers the broker root CA to the launched leaf-BC session as inline PEM CONTENT — so the leaf's trust file is a valid certificate, not a path/filename string
  Given a "lead" shop bootstrapped by "shop-templates" with the rendered ops scripts "bin/agent-vault-provision" and "bin/shop-shell"
  And a broker whose "agent-vault ca fetch" emits a multi-line root-CA certificate beginning with the literal "-----BEGIN CERTIFICATE-----"
  When the operator runs the rendered "bin/agent-vault-provision" to source the broker root CA
  And then the rendered "bin/shop-shell" transports the broker credentials into the launched leaf-BC session
  Then the rendered "bin/shop-shell" delivers "AGENT_VAULT_CA_PEM" to the launcher by reading the CA file CONTENT — its body contains the literal substring "$(cat" applied to the broker-CA file — rather than carrying the path string
  And the rendered "bin/shop-shell" passes "AGENT_VAULT_CA_PEM" into the launched session as a process-environment value that can hold real newlines — its body contains the literal substring "-e AGENT_VAULT_CA_PEM" — rather than carrying the "AGENT_VAULT_CA_PEM=" line from ".env" through "grep" into a file-based "--env-file" (which cannot carry a multi-line value)
  And the value of "AGENT_VAULT_CA_PEM" reaching the launched leaf-BC session begins with the literal "-----BEGIN CERTIFICATE-----" — it is the certificate content, not the filename string "agent-vault-ca.pem"
  And the trust file the launched leaf agent materializes from "AGENT_VAULT_CA_PEM" therefore contains a valid "-----BEGIN CERTIFICATE-----" block (the broker root CA), not a path/filename string
