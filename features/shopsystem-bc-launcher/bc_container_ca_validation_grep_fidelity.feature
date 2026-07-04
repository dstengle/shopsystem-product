@bc:shopsystem-bc-launcher @origin:lead-eqao @service:agent-vault-broker
Feature: bc-container CA-validation grep fidelity (lead-eqao, 3rd F3 cycle)

  Additive companion pin to the CA end-state scenario (@scenario_hash:09f871cf8b99a34b):
  binds the REAL shipped CA validation step the launch performs, exercised exactly as
  the launch invokes it, so a validation-internal grep-option defect that misjudges a
  VALID cert RED-tests instead of shipping silently.

  @scenario_hash:3222fe1396f1ff53
  Scenario Outline: on a real no-flag bc-container launch, the committed agent-vault-ca.sh validation step exercised exactly as the launch invokes it classifies the materialized CA by the real BEGIN-CERTIFICATE marker, so a valid cert is accepted and the clone proceeds while a genuinely marker-less cert is rejected, and no validation-internal error misjudges a valid cert
    Given the shopsystem-bc-launcher BC is installed
    And the launched BC routes outbound HTTPS through the agent-vault MITM proxy via "HTTPS_PROXY", so the clone requires the broker root CA to verify TLS
    And the CA validation under observation is the one the real launch performs by invoking the committed "agent-vault-ca.sh", exercised exactly as the launch invokes it on the no-flag manifest-resolution path, and not a reimplemented, modeled, or stand-in check that re-derives the BEGIN-CERTIFICATE test differently from the shipped script
    And the agent-vault broker materializes the container CA bundle so that its on-disk content is <ca_content>
    When bc-container launch is run with BC name "shopsystem-test-harness" via the no-flag manifest-resolution clone path and the launch reaches its CA validation step
    Then the committed agent-vault-ca.sh validation step <validation_result>, with no "grep: unrecognized option" error and no other validation-internal error causing a valid cert to be misjudged
    And the launch <git_and_clone_outcome>

    Examples:
      | ca_content | validation_result | git_and_clone_outcome |
      | a real PEM certificate whose first line is exactly "-----BEGIN CERTIFICATE-----" | accepts the materialized CA and exits success, emitting no "agent-vault CA file missing BEGIN CERTIFICATE" diagnostic | points git at that CA file and the proxied clone of "shopsystem-test-harness" proceeds and completes its TLS handshake with no "error setting certificate file" error |
      | bytes that genuinely contain no "-----BEGIN CERTIFICATE-----" marker line anywhere | rejects the materialized CA and fails loud, naming the missing BEGIN CERTIFICATE marker | refuses to point git at the CA and the proxied clone does not run |
