@bc:shopsystem-templates @origin:lead-nhr2
Feature: post-approve footing fixes (host-reachable broker port, beads sync.remote)
  footing discovers the broker's docker-mapped host port and records a host-reachable
  address distinct from the in-network one; and rewrites .beads/config.yaml sync.remote
  to the derived-org <product>-lead-beads repo it wired for dolt.

@scenario_hash:f340689bb81413dc
Scenario: footing discovers the broker's actual docker-mapped host port and records a host-reachable broker address distinct from the in-network one
  Given footing has brought up the compose services for product slug "<slug>" so the "<slug>-agent-vault" broker container is running
  And footing has written the in-network "AGENT_VAULT_ADDR=http://<slug>-agent-vault:14321" to the run ".env" for in-network containers
  When footing discovers the broker's host-mapped API port by running "docker port <slug>-agent-vault 14321" rather than assuming the container port 14321
  Then footing records a host-reachable broker address whose host is "localhost" and whose port is the discovered docker-mapped host port into the run ".env" as a host-facing variable distinct from "AGENT_VAULT_ADDR"
  And the recorded host-reachable broker address port equals the value reported by "docker port <slug>-agent-vault 14321", which matches the generated or env-overridden "OPS_VAULT_API_PORT" and is not hardcoded to 14321
  And the in-network "AGENT_VAULT_ADDR" still resolves to "http://<slug>-agent-vault:14321" unchanged for in-network containers

@scenario_hash:c1b769fb49c6ebfb
Scenario: footing rewrites .beads/config.yaml sync.remote to the derived-org product-lead-beads repo it wires for dolt
  Given a forked lead repository whose git origin owner is "<owner>" and whose derived product slug is "<product>"
  And "shop-templates bootstrap" scaffolded ".beads/config.yaml" with a "sync.remote" pointing at a hardcoded "dstengle" org and a "<product>-product-beads" repository name
  And footing has created the "<product>-lead-beads" beads repository and wired its bd dolt remote "BEADS_REMOTE" to that repository under owner "<owner>"
  When footing reconciles the ".beads/config.yaml" "sync.remote" at runtime
  Then the rewritten "sync.remote" owner equals the git origin owner "<owner>" and is not the hardcoded "dstengle"
  And the rewritten "sync.remote" repository name equals "<product>-lead-beads" and is not "<product>-product-beads"
  And the rewritten "sync.remote" names the same beads repository footing wired its bd dolt remote "BEADS_REMOTE" to
