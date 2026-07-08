@bc:shopsystem-bc-launcher @origin:adr-058
Feature: the fabro engage BOOTSTRAPS on the fresh clone path — provisions the ~/.fabro server config and runs fabro from /workspace/.fabro so the engage actually starts (lead-l4iw, bundled into lead-odd9)

  ADR-058 "Bundled fix — clone-path fabro-engage bootstrap + cwd" (lead-l4iw,
  David 2026-07-07) records that the reactive dispatcher engage (dispatcher
  contract bf9f8c9d7f2865e3 in
  bc_container_fabro_reactive_dispatcher_engage.feature; engage-tier selection
  30fd5f2079f1c433) is MOOT unless the fabro SERVER actually
  bootstraps in a FRESH CLONE-PATH container — which it currently does NOT.
  Two clone-path defects crash the engage: (a) the launcher writes only
  "/workspace/.fabro/settings.toml" (the PROJECT LLM settings) and never
  provisions "~/.fabro/settings.toml" — the file "fabro server start" reads —
  so the server dies at "server.auth.methods: field is required"; (b) the
  engage runs "fabro run" from "/workspace" not "/workspace/.fabro", so fabro
  fails "workflow not found: /workspace/workflow.fabro". This feature pins the
  bundled fix: on the "--orchestrator fabro" engage the launcher provisions a
  VALID server config at "~/.fabro/settings.toml" ("[server.auth]" methods +
  a 64-hex "SESSION_SECRET" + a "FABRO_DEV_TOKEN" of form "fabro_dev_"+64hex,
  e.g. via "fabro install --non-interactive --skip-llm --github-strategy
  token", proven in wf_10649334-946) AND runs the "fabro run" engage from the
  project dir "/workspace/.fabro" — so a fresh clone-path launch REACHES the
  fabro engage (server up, "fabro run" resolves the poured def) instead of
  crashing. Never caught before because the only working fabro runs used
  "--workspace-mount" on a host with "~/.fabro" pre-configured interactively;
  the clone path was never exercised e2e.

  FIDELITY (test-fidelity-for-image-layer-container-runtime-scenarios): docker
  and a live fabro server may be unavailable in-test, so the step defs bind to
  the launcher's ACTUAL recorded engage behavior on the artifact surface — the
  server-config file it provisions at "~/.fabro/settings.toml" and that file's
  contents ("[server.auth]" methods, the 64-hex "SESSION_SECRET", the
  "fabro_dev_"+64hex "FABRO_DEV_TOKEN"), the "fabro server start" argv, and the
  working directory of the recorded "fabro run" engage call — never to a live
  server round-trip and never to a model. The server-config provisioning was
  proven to yield a startable server in-container (ADR-058 Open Q1 RESOLVED,
  real fabro 0.254.0, wf_10649334-946); the argv + config-writing shape is what
  this scenario pins on the artifact surface, exactly as the sibling fabro
  engage scenarios do.

  @scenario_hash:e23ded356508180a
  Scenario: a fresh clone-path --orchestrator fabro launch provisions the ~/.fabro server config and runs fabro from /workspace/.fabro, so the fabro engage bootstraps successfully instead of crashing at server auth or def resolution
    Given the shopsystem-bc-launcher BC is installed
    And bc-container launch is run for BC name "shopsystem-messaging" on the fabro orchestrator launch path selected by "--orchestrator fabro" in a FRESH CLONE-PATH container with NO host-home "~/.fabro" mount and no interactively pre-configured fabro home
    And the container "bc-shopsystem-messaging" has cloned the repo and shop-templates has POURED "/workspace/.fabro/" including "dispatcher.fabro" and the UNCHANGED ADR-051 "workflow.fabro" child def
    And the launcher's idempotent readiness barrier composing the messaging DB and the agent-vault broker has passed (scenario 34)
    When the launcher's recorded fabro engage steps — the server config it provisions, the "fabro server start" argv, and the working directory of the "fabro run" engage — are inspected structurally, without a live docker daemon, a running fabro server, or a reachable agent-vault
    Then BEFORE starting the server the launcher provisions a VALID server config at "~/.fabro/settings.toml" (the file "fabro server start" reads), e.g. by running "fabro install --non-interactive --skip-llm --github-strategy token", and that file contains a "[server.auth]" table with "methods" set, a "SESSION_SECRET" of exactly 64 hexadecimal characters, and a "FABRO_DEV_TOKEN" of the form "fabro_dev_" followed by 64 hexadecimal characters (NOT a bare hex token), so "fabro server start --foreground --no-web" starts successfully rather than dying at "server.auth.methods: field is required"
    And this provisioned "~/.fabro/settings.toml" server config is DISTINCT from "/workspace/.fabro/settings.toml", the PROJECT LLM settings the launcher already writes — the project settings are NOT the server config and do not by themselves satisfy "fabro server start", so the launcher writes BOTH the project "/workspace/.fabro/settings.toml" and the server "~/.fabro/settings.toml"
    And the launcher issues the persistent "fabro run dispatcher.toml" engage with its working directory set to the project dir "/workspace/.fabro", NOT "/workspace", so fabro resolves the poured "dispatcher.toml" (and its sibling "workflow.fabro") rather than failing "workflow not found: /workspace/workflow.fabro"
    And as the observable result a fresh clone-path "--orchestrator fabro" launch REACHES the fabro engage successfully — the in-container fabro server comes up and the "fabro run" engage resolves the poured def — instead of crashing at server auth bootstrap or def resolution as the un-provisioned clone path currently does (ADR-058 bundled fix, lead-l4iw)
