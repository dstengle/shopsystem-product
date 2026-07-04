@bc:shopsystem-bc-launcher @origin:lead-f6xs
Feature: bc-base interactive bootstrap entrypoint mode (lead-f6xs)

  The bc-base image carries an INTERACTIVE BOOTSTRAP entrypoint MODE — a mode of
  the EXISTING bc-base lineage image, not a separate purpose-built image — that
  performs the one-time HUMAN authentication beat: it invokes `claude` and
  `gh auth login` interactively attached to the host TTY so a human
  authenticates directly (NOT wrapped as `agent-vault run -- claude`, the
  brokered steady-state placeholder wrap) and places NO "__PLACEHOLDER__"
  credential as the Claude or GitHub credential. Because it ships in the same
  image, the baked framework CLIs resolve on PATH exactly as for a brokered run.

  These scenarios inspect COMMITTED Dockerfile / bootstrap-entrypoint script
  content (docker build is NOT run — docker is unavailable in this environment),
  the same structural-inspection idiom as the bc-base CA-trust / CLI-pin tests.

  @scenario_hash:20b7a66364a26404
  Scenario: bootstrap entrypoint mode runs an interactive claude and gh auth beat with a TTY instead of the brokered placeholder wrap
    Given the published bc-base image is run with the interactive bootstrap entrypoint mode selected
    And the agent-vault broker holds no Claude or GitHub credential for this product yet
    When the bootstrap entrypoint executes its authentication beat
    Then the entrypoint invokes "claude" interactively attached to the host TTY for the human to authenticate, not wrapped as "agent-vault run -- claude"
    And the entrypoint invokes "gh auth login" interactively attached to the host TTY for the human to authenticate
    And the entrypoint does not place a "__PLACEHOLDER__" credential as the Claude or GitHub credential for this beat

  @scenario_hash:938342272de4e38a
  Scenario: the bootstrap mode is a mode of the existing bc-base image and resolves to the same baked framework CLIs as a brokered run
    Given the published bc-base image is run with the interactive bootstrap entrypoint mode selected
    When the bootstrap entrypoint starts
    Then the image is the existing bc-base lineage image and not a separate purpose-built bootstrap image
    And the framework CLIs "shop-templates", "shop-msg", "bc-container", and "agent-vault" resolve on PATH inside the running container exactly as they do for a brokered steady-state run
