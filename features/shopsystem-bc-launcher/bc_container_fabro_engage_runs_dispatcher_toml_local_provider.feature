@bc:shopsystem-bc-launcher @origin:lead-b3f0
Feature: the fabro engage runs "fabro run dispatcher.toml" (applying the local provider) so node execution runs in-process, not a docker sandbox (lead-b3f0, Scenario A)

  ROOT CAUSE CONFIRMED by the lead's in-container empirical verification
  (lead-b3f0, 2026-07-08): the launcher's engage runs "fabro run
  dispatcher.fabro" — the ".fabro" graph def DIRECTLY. Running the ".fabro"
  directly BYPASSES the "[environments.local]" provider config and DEFAULTS to
  a Docker sandbox executor; the bc-base container has no docker daemon, so the
  run fails in 0s ("Failed to connect to Docker daemon: /var/run/docker.sock")
  and the dispatcher process EXITS before it ever watches the inbox, leaving
  the BC offline and unable to process assign_scenarios. The fix pins the
  engage to run "fabro run dispatcher.toml": the ".toml" entrypoint applies
  "provider = local", so the sandbox comes up in-process ("Sandbox: local ready
  in 1ms") and the dispatcher's native nodes execute in-container without any
  docker daemon. This SUPERSEDES the ADR-058 engage argv ("fabro run
  dispatcher.fabro -I BC_NAME=<bc>"); flag ADR-058 for amendment.

  FIDELITY: the step defs bind to the launcher's ACTUAL recorded fabro engage
  argv and the poured fabro def set's "dispatcher.toml" entrypoint content — the
  engage target ("dispatcher.toml", not the bare ".fabro"), the ".toml"'s
  applied "provider = local", and the negative control that the bare ".fabro"
  entrypoint falls to the docker-sandbox executor — read against the fabro-def
  artifact surface and the launcher's engage command, NOT a live container run.
  Runtime in-process execution is BC-proven in-container (lead-b3f0); the
  engage-target + provider-application shape is what this scenario pins on the
  artifact surface.

  @scenario_hash:24d94274b9cbc2b0
  Scenario: the fabro engage invokes "fabro run dispatcher.toml" so the local provider applies and node execution runs in-process, with a negative control that running the bare ".fabro" falls to the docker sandbox
    Given the shopsystem-bc-launcher BC is installed
    And bc-container launch is run for BC name "shopsystem-messaging" on the fabro orchestrator launch path selected by "--orchestrator fabro"
    And the container "bc-shopsystem-messaging" is running with the self-contained fabro def set POURED by shop-templates into "/workspace/.fabro/", including both the "dispatcher.toml" entrypoint and the "dispatcher.fabro" graph def it applies, and the bc-base container has NO docker daemon reachable at "/var/run/docker.sock"
    And the launcher's idempotent readiness barrier composing the messaging DB and the agent-vault broker has passed (scenario 34)
    When the engage the launcher issues and the poured "dispatcher.toml" entrypoint are inspected structurally, without a live docker daemon, a running fabro server, or a reachable agent-vault
    Then AFTER the readiness barrier passes the engage the launcher issues invokes "fabro run dispatcher.toml" — the ".toml" entrypoint, NOT the bare "dispatcher.fabro" graph def — so the run enters through the ".toml" rather than the ".fabro" directly
    And the poured "dispatcher.toml" applies "provider = local" so the fabro sandbox comes up IN-PROCESS in the bc-base container ("Sandbox: local ready") and every native node of the dispatcher graph executes in-process with no docker sandbox and no connection attempt to "/var/run/docker.sock"
    And as the negative control, had the engage instead run the bare "fabro run dispatcher.fabro" (the ".fabro" graph def DIRECTLY), the run would BYPASS the "[environments.local]" provider, DEFAULT to the docker-sandbox executor, and — because the bc-base container has no docker daemon — fail in 0s connecting to "/var/run/docker.sock" and EXIT before the dispatcher ever watches the inbox, which is the exact pre-fix offline failure this ".toml"-entrypoint engage exists to avoid
