@bc:unassigned @origin:brief-017
Feature: shopsystem-bc-launcher selects Anthropic or OpenRouter as the active fabro LLM provider via a launch-time operator override, and resolves poured node-class placeholders to literal model IDs (brief-017)

  cand-002 / intent-002: an operator-settable, LAUNCH-TIME override for
  fabro's LLM provider/model choice, proven end-to-end via OpenRouter as a
  second provider alongside the existing Anthropic-subscription path. "No
  software release" is satisfied by a BC RELAUNCH picking up a new
  operator-set value — the same launch-time-wins-over-default shape as
  bc_container_runtime_proxy.feature's "--agent-vault-broker" precedence and
  ADR-043's ops-coordinates rendered-default-with-override pattern. No
  hot-reload / in-flight mutation is introduced.

  Two elements, both on this BC (cand-002 solution sketch): (a) provider
  selection — an "--llm-provider" / "BCLAUNCHER_LLM_PROVIDER" launch-time
  operator value selects "anthropic" (default) or "openrouter", riding a NEW
  agent-vault-brokered OpenRouter credential (dummy-on-node, real-on-wire, NO
  header-reshaping shim needed — the ADR-049 D3 GITHUB_TOKEN shape, not the
  D2 Anthropic-oauth-shim shape); (b) model resolution — bc-launcher resolves
  the poured abstract node-class placeholders (MODEL_CODING, MODEL_REVIEW,
  MODEL_DEFAULT — see the companion shopsystem-templates feature) into
  literal, provider-specific model IDs by supplying them as fabro run
  "-I KEY=VALUE" inputs, looked up from a fleet-wide, provider-keyed mapping
  table (table ownership/pinning location is an open question for the
  Architect, not settled here).

  OPEN RISK, named not resolved here (cand-002 Rabbit holes): whether
  registering the new OpenRouter agent-vault credential key is
  lead-dispatchable or requires a one-time operator action outside the
  shop-msg model. The scenarios below presuppose the credential SERVICE
  already exists on the broker ("Given ... a registered OpenRouter credential
  service is running") — provisioning that service is out of scope for these
  scenarios and is an Architect pre-state verification question.

  @scenario_hash:1d9d3777e3c3d8f5
  Scenario: a plain launch with no operator-supplied provider override keeps the Anthropic-subscription path as the active LLM provider
    Given the shopsystem-bc-launcher BC is installed
    And no launch-time "--llm-provider" or "BCLAUNCHER_LLM_PROVIDER" override is supplied
    When bc-container launch is run for BC name "shopsystem-messaging"
    Then the container's fabro run is launched with the active LLM provider set to "anthropic"
    And no OpenRouter agent-vault credential is requested for this launch

  @scenario_hash:b3054f5439369fa8
  Scenario: an explicit launch-time provider override selects OpenRouter, winning over the Anthropic default
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies a launch-time LLM provider override of "openrouter" via "--llm-provider openrouter" (or "BCLAUNCHER_LLM_PROVIDER=openrouter")
    When bc-container launch is run for BC name "shopsystem-messaging" with the operator-supplied provider override
    Then the container's fabro run is launched with the active LLM provider set to "openrouter"
    And the Anthropic anthropic-oauth-shim path is not engaged for this launch

  @scenario_hash:14290420156c5ee0
  Scenario: the OpenRouter credential rides a new agent-vault-brokered credential with no header-reshaping shim, matching the GITHUB_TOKEN no-shim pattern rather than the Anthropic oauth-shim pattern
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies a launch-time LLM provider override of "openrouter"
    And an agent-vault broker with a registered OpenRouter credential service is running on the shopsystem network and is reachable
    When bc-container launch starts the agent for BC name "shopsystem-messaging" with the OpenRouter provider override
    Then the node-side "OPENROUTER_API_KEY" value is the literal placeholder "__PLACEHOLDER__", with no header-reshaping shim process launched for the OpenRouter path
    And the agent-vault broker's MITM proxy substitutes the real OpenRouter API key onto the outbound "Authorization: Bearer" header only on the wire
    And the real OpenRouter API key is not present in the container's filesystem or process environment

  @scenario_hash:22f2a5bda5c29044
  Scenario: bc-launcher resolves each poured node-class placeholder to a literal model ID via fabro run "-I" inputs, sourced from the provider-keyed mapping table for the active provider
    Given the shopsystem-bc-launcher BC is installed
    And the poured "/workspace/.fabro/workflow.fabro" model_stylesheet carries the node-class input placeholders "MODEL_CODING", "MODEL_REVIEW", and "MODEL_DEFAULT"
    And the fleet-wide provider-keyed model mapping table has an OpenRouter row and an Anthropic row, each naming a literal model ID for the "coding", "review", and "default" node-class tiers
    And the operator supplies a launch-time LLM provider override of "openrouter"
    When bc-container launch runs the container's fabro workflow for BC name "shopsystem-messaging" with the OpenRouter provider override
    Then the fabro run command line supplies three "-I" inputs — MODEL_CODING, MODEL_REVIEW, and MODEL_DEFAULT — each set to the literal model ID recorded in the mapping table's OpenRouter row for that node-class
    And when the same launch is run with no provider override, the same three inputs instead carry the literal model IDs recorded in the mapping table's Anthropic row

  @scenario_hash:c99e79ac24f56f5c
  Scenario: a real dispatch completes end-to-end on a BC launched with the OpenRouter override, with no software release required
    Given the shopsystem-bc-launcher BC is installed
    And an agent-vault broker with a registered OpenRouter credential service is running on the shopsystem network and is reachable
    And the operator supplies a launch-time LLM provider override of "openrouter"
    When bc-container launch is run for a BC with the OpenRouter provider override and a substantive assign_scenarios dispatch is delivered to it
    Then the dispatched work reaches a gated work_done, having executed through at least one non-trivial node-class, such as ".coding", whose model resolved to a literal OpenRouter model ID
    And no software release, BC-base image rebuild, or template re-pour was required to reach this outcome — only the launch-time provider override and a container relaunch
