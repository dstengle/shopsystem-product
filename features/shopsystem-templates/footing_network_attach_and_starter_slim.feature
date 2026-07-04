@bc:shopsystem-templates @origin:lead-rs0i
Feature: finish the footing bootstrap path — footing network self-attach + slimmed starter
  footing self-attaches its own container to the product network after compose-up and
  before its first local-first agent-vault --address call (so the in-network broker name
  resolves), idempotently; and the starter is slimmed to README + bin/bootstrap with
  compose.yaml / .env.example rendered in-container by bin/bootstrap.

@scenario_hash:8b975a4bcec38b56
Scenario: footing attaches its own container to the product network after infra-up so its in-network broker calls resolve
    Given the footing script runs inside a container started without "--network" so it begins on Docker's default bridge
    And the footing container has the host docker socket mounted at "/var/run/docker.sock"
    When footing brings the compose services up with "docker compose up -d postgres agent-vault", which creates the user-defined "<product>" network carrying the "<product>-agent-vault" broker
    Then before footing issues its first local-first "agent-vault" call carrying "--address http://<product>-agent-vault:14321", footing connects its own running container to the "<product>" network via "docker network connect <product>" against its own container
    And from inside the footing container the broker name "<product>-agent-vault" then resolves and the broker API port 14321 is reachable
    And footing's local-first "agent-vault auth", "vault token", and "vault proposal" calls reach the broker at "http://<product>-agent-vault:14321" rather than failing to resolve the in-network broker name

@scenario_hash:4caa8193b16683ba
Scenario: footing's self-attach to the product network is idempotent and safe when the container is already a member
    Given footing has already connected its own container to the "<product>" network earlier in the same run or a prior re-run
    When footing reaches the network self-attach step again
    Then the self-attach step completes without aborting the footing run on an "already exists in network" error from "docker network connect"
    And after the step footing's own container is a member of the "<product>" network exactly once
    And footing proceeds to its local-first "agent-vault" calls against "http://<product>-agent-vault:14321" with the broker name still resolving from inside the footing container

@scenario_hash:0f8ed9f13b5f5947
Scenario: the slimmed starter template carries only README.md and bin/bootstrap
  Given the starter template directory "src/shop_templates/templates/starter"
  When the starter template tree is enumerated
  Then the starter template contains a top-level file named "README.md"
  And the starter template contains a file at "bin/bootstrap"
  And the starter template contains no top-level file named "compose.yaml"
  And the starter template contains no top-level file named ".env.example"

@scenario_hash:e12e1cf4c99c1cc6
Scenario: the adopter still receives compose.yaml and .env.example from the bootstrap render even though the starter no longer carries them
  Given an adopter fork created from the slimmed starter that carries "README.md" and "bin/bootstrap" but no "compose.yaml" and no ".env.example"
  When the adopter runs "bin/bootstrap" and its render step runs "shop-templates bootstrap" in-container for shop type "lead"
  Then after the render step the adopter fork contains a top-level file named "compose.yaml" produced by the bootstrap render
  And after the render step the adopter fork contains a file named ".env.example" produced by the bootstrap render
  And the rendered "compose.yaml" and ".env.example" are versioned with the published image rather than copied from any file pre-existing in the starter

@scenario_hash:05f5633eba7ce12c
Scenario: bin/bootstrap reaches the render step without depending on a pre-existing compose.yaml or .env.example in the starter
  Given an adopter fork created from the slimmed starter that carries "README.md" and "bin/bootstrap" but no "compose.yaml" and no ".env.example"
  When the adopter runs "bin/bootstrap"
  Then bootstrap does not read or require a pre-existing "compose.yaml" before its render step
  And bootstrap does not read or require a pre-existing ".env.example" before its render step
  And bootstrap proceeds to run "shop-templates bootstrap" in-container, which renders the lead structure including "compose.yaml" and ".env.example" into the fork
