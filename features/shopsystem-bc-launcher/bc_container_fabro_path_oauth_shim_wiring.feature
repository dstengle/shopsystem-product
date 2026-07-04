@bc:shopsystem-bc-launcher @origin:adr-049
Feature: the fabro orchestrator launch path starts the anthropic-oauth-shim and points fabro's anthropic provider at it (lead-vwib)

  LAUNCHER WIRING ONLY. The anthropic-oauth-shim is lead-so2h's owned
  artifact — a REAL stdlib ThreadingHTTPServer reverse proxy baked into
  bc-base at /usr/local/bin/anthropic-oauth-shim (v0.3.44): it BINDS +
  LISTENS on 127.0.0.1:8788, strips x-api-key, adds Authorization: Bearer
  <dummy> + anthropic-beta: oauth-2025-04-20, and forwards via HTTPS_PROXY so
  agent-vault injects the real credential on the wire. This scenario pins the
  LAUNCHER WIRING for the fabro orchestrator launch path only: the launcher
  starts that baked shim in-container on 127.0.0.1:8788 and writes fabro's
  effective settings so [llm.providers.anthropic] base_url points at the shim
  with adapter "anthropic" (native format, no translation — ADR-049 D2),
  while the native fabro vault stays __PLACEHOLDER__-only (ADR-049 D1).

  FIDELITY (test-fidelity-for-image-layer-container-runtime-scenarios): the
  listener leg EXECUTES the REAL committed so2h shim
  (`anthropic-oauth-shim --host 127.0.0.1 --port 8788`) and confirms it
  genuinely BINDS + listens on 127.0.0.1:8788 (a TCP connect succeeds), then
  stops it; AND asserts the launcher's fabro-path start argv targets that
  mode + host + port. The base_url + vault legs parse the REAL fabro settings
  the launcher writes and the committed def's __PLACEHOLDER__-only vault. The
  live dummy-x-api-key -> shim -> HTTPS_PROXY -> agent-vault -> real-OAuth-200
  round-trip (fabro-orchestration/02, @scenario_hash:9c7b4e8280665239) is the
  lead's E2E and is NOT this scenario's in-container checkable core.

  @scenario_hash:8b5a1b9e5499293b
  Scenario: launching a BC on the fabro orchestrator path starts the in-container anthropic-oauth-shim and points fabro's anthropic provider base_url at it while the native fabro vault holds only placeholders
    Given the shopsystem-bc-launcher BC is installed
    And bc-container launch is run for BC name "shopsystem-messaging" on the fabro orchestrator launch path
    And the container "bc-shopsystem-messaging" is running on the pinned bc-base image that carries the baked anthropic-oauth-shim at "/usr/local/bin/anthropic-oauth-shim" (scenario 73, @scenario_hash:a3512aedb8763150) and the self-contained fabro def whose native vault holds only "__PLACEHOLDER__" (scenario 75, @scenario_hash:2dfefe2ba81e418d)
    When the fabro credential wiring the launcher established in that running container is inspected structurally, without requiring a reachable agent-vault or any live LLM call
    Then the baked anthropic-oauth-shim has been started in-container by the launcher and is listening on "127.0.0.1:8788", so an in-container agent's Anthropic traffic has a local endpoint to send its dummy x-api-key to
    And fabro's effective settings carry "[llm.providers.anthropic]" with "base_url" set to "http://127.0.0.1:8788/v1" pointing the built-in anthropic provider at that shim, with the adapter left as "anthropic" so the shim speaks native Anthropic Messages format in both directions and no OpenAI-to-Anthropic format translation is introduced (ADR-049 D2)
    And the def's native fabro vault still holds only the literal value "__PLACEHOLDER__" for every provider-key and token slot it declares, with no real credential written into fabro's native secret store on this launch path (ADR-049 D1)
    And the real Anthropic credential is nowhere in fabro's native vault or the shim's own configuration on this launch path: it rides only the agent-vault surface on the wire via the container HTTPS_PROXY (the dummy x-api-key to in-container shim to HTTPS_PROXY to agent-vault to real OAuth 200 round-trip that fabro-orchestration/02, @scenario_hash:9c7b4e8280665239, pins is exercised live at the lead end-to-end and is not part of this scenario's in-container checkable core)
