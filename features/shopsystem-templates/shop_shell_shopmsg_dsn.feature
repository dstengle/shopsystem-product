@bc:shopsystem-templates @origin:lead-j8so @service:postgres
Feature: shop-shell delivers a non-empty DB-reachable SHOPMSG_DSN into the launched lead-shell session (lead-j8so)
  The rendered bin/shop-shell derives SHOPMSG_DSN at runtime from the sourced
  ops-coordinates postgres coordinates (OPS_POSTGRES_CONTAINER / OPS_POSTGRES_PORT
  on the shop docker network) and passes it into the launched lead-shell session
  via the "-e SHOPMSG_DSN" process-env form — the same transport vehicle scenario
  200 uses for AGENT_VAULT_CA_PEM (a runtime-derived value belongs on the process-env
  path, not the static --env-file). So a freshly-launched lead agent can run shop-msg
  against the product postgres on first use without a manual operator export.
  ADDITIVE to scenarios 200 (7ce09202755b0503, -e AGENT_VAULT_CA_PEM), 201
  (0789db8bb7f3bc73, .env-path GH_TOKEN), and 211 (0a3a8267109b5792, the
  ops-coordinates the DSN derives from): SHOPMSG_DSN joins the CA/GH_TOKEN
  transports, retiring no @scenario_hash.

@scenario_hash:a0342b1700fe27e7
Scenario: the rendered shop-owned bringup path delivers a non-empty SHOPMSG_DSN into the launched lead-shell session so shop-msg reaches the product postgres on first use without a manual operator or agent export
  Given a "lead" shop bootstrapped by "shop-templates" with the rendered ops script "bin/shop-shell" and the rendered single ops-coordinates artifact "bin/ops-coordinates" carrying the product postgres coordinates (OPS_POSTGRES_CONTAINER, OPS_POSTGRES_PORT, OPS_NETWORK)
  And the product postgres service is up and reachable on the shop docker network at those coordinates
  When the operator runs the rendered "bin/shop-shell" to launch the lead-shell session
  Then the rendered "bin/shop-shell" delivers a non-empty "SHOPMSG_DSN" into the launched lead-shell session environment — its body passes "SHOPMSG_DSN" set to a non-empty value into the launch (the body contains the literal substring "-e SHOPMSG_DSN") rather than leaving "SHOPMSG_DSN" unset
  And the "SHOPMSG_DSN" value reaching the launched session is derived from the sourced ops-coordinates postgres coordinates (the product postgres container and port on the shop docker network), not an empty or placeholder address
  And a freshly-launched lead-shell agent can therefore run "shop-msg" against the product postgres on first use — the first invocation reaches the database rather than exiting non-zero on an unset or unreachable "SHOPMSG_DSN" — without the agent first self-diagnosing or the operator first running "export SHOPMSG_DSN=..." by hand
