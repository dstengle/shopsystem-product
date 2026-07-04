@bc:shopsystem-templates @origin:lead-kgrq
Feature: footing's post-compose-up readiness check matches running containers by expanded name
  The readiness grep must use the EXPANDED $OPS_POSTGRES_CONTAINER / $OPS_AGENT_VAULT_CONTAINER
  values (double-quoted), not search for the literal unexpanded variable text.

@scenario_hash:007b386697ae1bef
Scenario: footing's post-compose-up readiness check matches the running slug-scoped containers by expanded name
  Given a rendered "bin/footing" whose ops-coordinates artifact sets "$OPS_POSTGRES_CONTAINER" to "<slug>-postgres" and "$OPS_AGENT_VAULT_CONTAINER" to "<slug>-agent-vault"
  And the slug-scoped "<slug>-postgres" and "<slug>-agent-vault" containers are running after "docker compose up"
  When footing runs its post-compose-up readiness check
  Then the check matches running containers against the expanded values of "$OPS_POSTGRES_CONTAINER" and "$OPS_AGENT_VAULT_CONTAINER", not against the literal text "$OPS_POSTGRES_CONTAINER" / "$OPS_AGENT_VAULT_CONTAINER"
  And footing proceeds past the readiness check without aborting "expected the slug-scoped compose containers ... to be running, but neither was found"
  And a single-quoted readiness pattern that searches for the literal unexpanded variable names fails this check
  And when neither slug-scoped container is running the check still aborts with the "neither was found" diagnostic
