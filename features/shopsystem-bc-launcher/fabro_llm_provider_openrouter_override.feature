# RETIRED-scenario provenance (brief-020 / lead-ifye3.2 follow-on, 2026-07-15 —
# request_bugfix dispatch; bodies below are byte-identical to what was
# retired, for hash-provenance only):
#   @scenario_hash:b3054f5439369fa8 RETIRED (brief-020)
#   Asserted the OpenRouter override registers a NEW custom fabro provider
#   literally named "openrouter". A real end-to-end scout (brief-020) proved
#   this collides with fabro's catalog auto-routing: fabro's built-in model
#   catalog resolves any "anthropic/..."-prefixed model string to the
#   BUILT-IN "anthropic" provider before the custom "openrouter" provider is
#   ever considered, so "Provider 'anthropic' not registered" is the
#   reproducible failure, every time. Superseded by
#   @scenario_hash:4c9f5b265c5098b7 below (native "openai" provider identity
#   + base_url override).
#   Original body:
#     Given the shopsystem-bc-launcher BC is installed
#     And the operator supplies a launch-time LLM provider override of "openrouter" via "--llm-provider openrouter" (or "BCLAUNCHER_LLM_PROVIDER=openrouter")
#     When bc-container launch is run for BC name "shopsystem-messaging" with the operator-supplied provider override
#     Then the container's fabro run is launched with the active LLM provider set to "openrouter"
#     And the Anthropic anthropic-oauth-shim path is not engaged for this launch
#   @scenario_hash:14290420156c5ee0 RETIRED (brief-020)
#   Asserted the node-side dummy credential env var is "OPENROUTER_API_KEY".
#   Once the provider registration moves to fabro's native "openai" identity
#   (brief-020), the credential must ride fabro's own recognized env var,
#   "OPENAI_API_KEY" — fabro's startup precondition check
#   (fabro-workflow/src/pipeline/initialize.rs) only recognizes
#   ANTHROPIC_API_KEY / OPENAI_API_KEY, never an arbitrary custom-provider
#   var, so a custom "OPENROUTER_API_KEY" never reaches that check at all.
#   Superseded by @scenario_hash:98b956adece2b7e0 below.
#   Original body:
#     Given the shopsystem-bc-launcher BC is installed
#     And the operator supplies a launch-time LLM provider override of "openrouter"
#     And an agent-vault broker with a registered OpenRouter credential service is running on the shopsystem network and is reachable
#     When bc-container launch starts the agent for BC name "shopsystem-messaging" with the OpenRouter provider override
#     Then the node-side "OPENROUTER_API_KEY" value is the literal placeholder "__PLACEHOLDER__", with no header-reshaping shim process launched for the OpenRouter path
#     And the agent-vault broker's MITM proxy substitutes the real OpenRouter API key onto the outbound "Authorization: Bearer" header only on the wire
#     And the real OpenRouter API key is not present in the container's filesystem or process environment
#
# RETIRED-scenario provenance (brief-021 / lead-ifye3.2 second follow-on,
# 2026-07-15 — request_bugfix dispatch; bodies below are byte-identical to
# what was retired, for hash-provenance only):
#   @scenario_hash:4c9f5b265c5098b7 RETIRED (brief-021)
#   Asserted the native "openai" provider identity's "base_url" is set
#   DIRECTLY to "https://openrouter.ai/api/v1", with the sandboxed node
#   itself reaching that host over "HTTPS_PROXY" for the real agent-vault
#   credential substitution. A real end-to-end scout (brief-021), reading
#   fabro's own source (lib/crates/fabro-sandbox/src/local.rs) and proving it
#   with a deliberately-broken unreachable proxy hostname (byte-identical
#   error to the real proxy), found the sandboxed agent-node execution path
#   calls ".env_clear()" before spawning and never routes its LLM call
#   through "HTTPS_PROXY" at all, regardless of configuration — this is
#   fabro's own deliberate sandbox security boundary, not a config mistake,
#   and no credential-source trick fixes it from inside the sandbox.
#   Superseded by @scenario_hash:af07c326a031fafe below (base_url points at
#   a local, unsandboxed "openrouter-shim" process instead of OpenRouter's
#   own host directly).
#   Original body:
#     Given the shopsystem-bc-launcher BC is installed
#     And the operator supplies a launch-time LLM provider override of "openrouter" via "--llm-provider openrouter" (or "BCLAUNCHER_LLM_PROVIDER=openrouter")
#     When bc-container launch is run for BC name "shopsystem-messaging" with the operator-supplied provider override
#     Then the container's fabro settings register the override under fabro's NATIVE "openai" provider identity, with its "base_url" set to "https://openrouter.ai/api/v1" — no new custom "openrouter" fabro provider is registered
#     And fabro's catalog auto-routing for OpenRouter-catalog-qualified model strings such as "anthropic/claude-sonnet-4.5" resolves unambiguously to the "openai" provider, with no collision against fabro's built-in "anthropic" catalog entry
#     And the Anthropic anthropic-oauth-shim path is not engaged for this launch
#   @scenario_hash:98b956adece2b7e0 RETIRED (brief-021)
#   Asserted the OpenRouter credential rides "OPENAI_API_KEY" with "no
#   header-reshaping shim process launched for the OpenRouter path" and the
#   agent-vault broker's MITM proxy substituting the real key directly on
#   the sandboxed node's own outbound wire hop. Proven wrong by the same
#   env_clear()/no-HTTPS_PROXY-in-sandbox finding as above: there is no
#   sandboxed-node outbound wire hop that a MITM proxy can intercept at all.
#   A real scout hit "Missing Authentication header" reproducibly with this
#   shape, even with the real credential and real broker live. Superseded by
#   @scenario_hash:05638241a033ef0c below (credential substitution moves to
#   the "openrouter-shim" process's own, unsandboxed outbound hop — a shim
#   IS needed for OpenRouter after all, contrary to brief-020's assumption,
#   though unlike "anthropic-oauth-shim" it needs no header reshaping).
#   Original body:
#     Given the shopsystem-bc-launcher BC is installed
#     And the operator supplies a launch-time LLM provider override of "openrouter"
#     And an agent-vault broker with a registered OpenRouter-host credential service is running on the shopsystem network and is reachable
#     When bc-container launch starts the agent for BC name "shopsystem-messaging" with the OpenRouter provider override
#     Then the node-side "OPENAI_API_KEY" value is the literal placeholder "__PLACEHOLDER__", with no header-reshaping shim process launched for the OpenRouter path
#     And the agent-vault broker's MITM proxy substitutes the real OpenRouter API key onto the outbound "Authorization: Bearer" header only on the wire, scoped to requests directed at the OpenRouter host
#     And the real OpenRouter API key is not present in the container's filesystem or process environment
#   @scenario_hash:22f2a5bda5c29044 RETIRED (brief-021)
#   Asserted per-node-class model resolution via three "-I" inputs
#   (MODEL_CODING / MODEL_REVIEW / MODEL_DEFAULT), sourced from the
#   provider-keyed mapping table, applied on top of the poured
#   "model_stylesheet" placeholder skeleton (brief-017 / lead-ifye3.1). The
#   fabro version this OpenRouter fix requires (>= v0.267.0-nightly.0, for
#   native "[llm.providers.openai]" base_url support) removes
#   "model_stylesheet" templating entirely (fabro commit 911e080f3, "Limit
#   DOT templates to prompt + goal") — "{{ inputs.X }}" becomes literal,
#   unparseable text on that fabro version, so this placeholder-pour
#   mechanism cannot work on it. Per explicit product-authority direction
#   (brief-021), per-node-class model differentiation is deprioritized (not
#   permanently dropped) in favor of a proven run-wide "--model"/"--provider"
#   pair on the dispatcher's per-child "fabro run" command line. Superseded
#   by @scenario_hash:a3b2b6bebcee78f5 below. Whether lead-ifye3.1's
#   templates-side "model_stylesheet" placeholder-pour work
#   (fabro_model_stylesheet_tier_labels.feature) should itself be retired or
#   scoped down is an OPEN QUESTION for the Architect (brief-021 §7) — not
#   decided or touched by this retirement, which concerns only this
#   feature's own resolution-mechanism scenario.
#   Original body:
#     Given the shopsystem-bc-launcher BC is installed
#     And the poured "/workspace/.fabro/workflow.fabro" model_stylesheet carries the node-class input placeholders "MODEL_CODING", "MODEL_REVIEW", and "MODEL_DEFAULT"
#     And the fleet-wide provider-keyed model mapping table has an OpenRouter row and an Anthropic row, each naming a literal model ID for the "coding", "review", and "default" node-class tiers
#     And the operator supplies a launch-time LLM provider override of "openrouter"
#     When bc-container launch runs the container's fabro workflow for BC name "shopsystem-messaging" with the OpenRouter provider override
#     Then the fabro run command line supplies three "-I" inputs — MODEL_CODING, MODEL_REVIEW, and MODEL_DEFAULT — each set to the literal model ID recorded in the mapping table's OpenRouter row for that node-class
#     And when the same launch is run with no provider override, the same three inputs instead carry the literal model IDs recorded in the mapping table's Anthropic row
#   @scenario_hash:c99e79ac24f56f5c RETIRED (brief-021)
#   Asserted a real end-to-end dispatch completes with "no software release,
#   BC-base image rebuild, or template re-pour ... required to reach this
#   outcome". This fix's fabro-version requirement (>= v0.267.0-nightly.0)
#   genuinely DOES require a one-time bc-base image rebuild
#   (docker/bc-base/Dockerfile's "ARG FABRO_VERSION") to bake in both the
#   newer fabro and the new "openrouter-shim" process — so the original
#   "no ... image rebuild" clause is no longer accurate as an unconditional
#   claim. Superseded by @scenario_hash:76badc67216f0d91 below, which scopes
#   the "no further release" claim correctly: to the operator's per-launch
#   provider-override action, given the one-time image-level FABRO_VERSION
#   precondition already satisfied beforehand. The underlying acceptance bar
#   (gated work_done, real OpenRouter model resolved) is unchanged.
#   Original body:
#     Given the shopsystem-bc-launcher BC is installed
#     And an agent-vault broker with a registered OpenRouter credential service is running on the shopsystem network and is reachable
#     And the operator supplies a launch-time LLM provider override of "openrouter"
#     When bc-container launch is run for a BC with the OpenRouter provider override and a substantive assign_scenarios dispatch is delivered to it
#     Then the dispatched work reaches a gated work_done, having executed through at least one non-trivial node-class, such as ".coding", whose model resolved to a literal OpenRouter model ID
#     And no software release, BC-base image rebuild, or template re-pour was required to reach this outcome — only the launch-time provider override and a container relaunch
#
# RETIRED-scenario provenance (brief-021 §12 addendum / lead-85s41 live-proof
# attempt, 2026-07-15 — request_maintenance follow-on; body below is
# byte-identical to what was retired, for hash-provenance only):
#   @scenario_hash:76badc67216f0d91 RETIRED (brief-021 §12)
#   Asserted "no further software release, BC-base image rebuild, or template
#   re-pour beyond the already-satisfied FABRO_VERSION image precondition was
#   required" to reach a gated work_done for this scenario's own When-clause
#   (a nested "bc-container launch" the shopsystem-bc-launcher BC performs
#   against a target BC as part of its own dispatched work). A live end-to-end
#   proof attempt this session (lead-85s41), followed by a router-run
#   Architect dispatch that inspected the bc-base image directly (throwaway
#   "docker run --entrypoint /bin/bash" against the same confirmed image
#   digest), found this false: the image bakes in NO docker binary at all,
#   and on this image's Debian trixie base, "docker.io" installs only the
#   daemon ("dockerd") — the separate "docker-cli" apt package (client-only)
#   is required for the nested launch's own "docker" command to exist, and it
#   is not currently baked into the "bc-base" image build. A SECOND one-time
#   image-build change (baking "docker-cli" into "bc-base", on top of the
#   already-satisfied FABRO_VERSION precondition) is genuinely required
#   before this scenario's Then-clause can be satisfied for real — the
#   nested-launch requirement is not incidental to the test; it is literally
#   what the When-clause names as the trigger under test, matching sibling
#   scenario L1's pattern of naming a downstream target BC by name. Superseded
#   by @scenario_hash:1cee6978cbf9ac53 below, which corrects the "no further
#   ... image rebuild" claim to name the one additional image precondition
#   accurately instead of asserting zero. See brief-021 §12 for full
#   disposition.
#   Original body:
#     Given the shopsystem-bc-launcher BC's container image was already built from a bc-base image pinned to a FABRO_VERSION carrying native "[llm.providers.openai]" support, satisfied once, prior to and independent of this launch
#     And the "openrouter-shim" process is part of that same already-built image
#     And an agent-vault broker with a registered OpenRouter-host credential service is running on the shopsystem network and is reachable
#     And the operator supplies a launch-time LLM provider override of "openrouter"
#     When bc-container launch is run for a BC with the OpenRouter provider override and a substantive assign_scenarios dispatch is delivered to it
#     Then the dispatched work reaches a gated work_done, having executed through at least one non-trivial node-class, such as ".coding", whose model resolved to a literal OpenRouter model ID via the "openrouter-shim"
#     And no further software release, BC-base image rebuild, or template re-pour beyond the already-satisfied FABRO_VERSION image precondition was required to reach this outcome — only the launch-time provider override and a container relaunch
#
# RETIRED-scenario provenance (brief-021 §13 addendum / lead-lp4us live-proof
# retry, 2026-07-15 — request_bugfix follow-on; body below is byte-identical
# to what was retired, for hash-provenance only):
#   @scenario_hash:1cee6978cbf9ac53 RETIRED (brief-021 §13)
#   Asserted "no further software release was required beyond the
#   already-satisfied FABRO_VERSION and bc-base 'docker-cli' image
#   preconditions" to reach a gated work_done for this scenario's own
#   When-clause. A live end-to-end proof retry this session (lead-lp4us),
#   run with BOTH the FABRO_VERSION and docker-cli preconditions genuinely
#   satisfied for the first time (a real nested bc-container launch
#   succeeded and reached the openrouter-shim, producing 11 real HTTP-200
#   OpenRouter completions), found this false a second/third time in this
#   lineage: TWO further software-level fixes — not zero — are required
#   before a real dispatch reaches gated work_done. (A) shopsystem-templates'
#   pour of templates/fabro/workflow.fabro still ships the retired
#   "{{ inputs.X }}" model_stylesheet placeholder shape, which fabro
#   >= v0.267.0-nightly.0 hard-parse-errors on (dispatched as lead-ifye3.6).
#   (B) shopsystem-bc-launcher's own engage.py:183 passes the active-provider
#   NAME ("openrouter") to "fabro run --provider", but fabro is registered
#   under the native identity "openai" — a call-site bug proven live: an
#   identical run with "--provider openai" substituted cleared the
#   precondition and executed real nodes against real OpenRouter (dispatched
#   as lead-ifye3.10). Superseded by @scenario_hash:5d49031bab379ba6 below,
#   which corrects the "no further release" claim to name both additional
#   preconditions explicitly instead of asserting zero. The underlying
#   behavioral claim (a real dispatch reaches gated work_done through a
#   launched BC with the OpenRouter override, resolving to a literal
#   OpenRouter model ID via the openrouter-shim) is unchanged. See brief-021
#   §13 for full disposition.
#   Original body:
#     Given the shopsystem-bc-launcher BC's container image was already built from a bc-base image pinned to a FABRO_VERSION carrying native "[llm.providers.openai]" support, satisfied once, prior to and independent of this launch
#     And the "openrouter-shim" process is part of that same already-built image
#     And that same bc-base image also bakes in the "docker-cli" apt package (the docker CLI client binary — not satisfied by "docker.io" alone, which on this image's Debian trixie base installs only the "dockerd" daemon, no client), satisfied once, prior to and independent of this launch, so the launched container can perform the nested "bc-container launch" its own dispatched work requires
#     And the container is launched with the "--mount-docker-socket" operator flag, so the baked "docker-cli" client has a socket to reach
#     And an agent-vault broker with a registered OpenRouter-host credential service is running on the shopsystem network and is reachable
#     And the operator supplies a launch-time LLM provider override of "openrouter"
#     When bc-container launch is run for a BC with the OpenRouter provider override and a substantive assign_scenarios dispatch is delivered to it
#     Then the dispatched work reaches a gated work_done, having executed through at least one non-trivial node-class, such as ".coding", whose model resolved to a literal OpenRouter model ID via the "openrouter-shim"
#     And no further software release was required beyond the already-satisfied FABRO_VERSION and bc-base "docker-cli" image preconditions — only the launch-time provider override, the "--mount-docker-socket" flag, and a container relaunch
#
# RETIRED-scenario provenance (fabro provider-identity call-site bugfix /
# lead-ifye3.10 correction, 2026-07-15 — request_bugfix follow-on; body below
# is byte-identical to what was retired, for hash-provenance only):
#   @scenario_hash:a3b2b6bebcee78f5 RETIRED (lead-ifye3.10)
#   Asserted the dispatcher's per-child "fabro run" command line carries
#   "--model <literal-model-id> --provider openrouter" — the active-provider
#   NAME, not fabro's registered native identity. lead-ifye3.10's live fix
#   (dispatched per brief-021 §13, proven this session: an identical run
#   with "--provider openai" substituted cleared the sandboxed worker's
#   startup precondition and executed real nodes against real OpenRouter,
#   11 real HTTP-200 completions) turned this exact clause RED against the
#   fix, correctly — fabro registers the OpenRouter override under its
#   NATIVE "openai" provider identity (constants.py's
#   FABRO_OPENROUTER_PROVIDER_IDENTITY = "openai", the same identity
#   af07c326a031fafe already pins), and fabro's own provider lookup is
#   literal: "--provider openrouter" names a provider that, per
#   af07c326a031fafe's own text, is never registered, so it cannot resolve.
#   L5's own current live scenario (5d49031bab379ba6) already assumes this
#   call-site fix as a satisfied Given precondition — this L4 scenario had
#   fallen out of lockstep with that assumption, the same
#   correction-discovered-by-a-live-fix shape as §11/§12/§13 in brief-021's
#   addendum record. Superseded by @scenario_hash:bb4f75cea78091c0 below,
#   which separates model-sourcing (still the mapping table) from
#   provider-sourcing (now correctly fabro's registered native identity,
#   never the operator-facing provider name) — the conflated "sourced from
#   the mapping table" phrasing covering both was itself part of the
#   imprecision that let this bug ship unpinned.
#   Original body:
#     Given the shopsystem-bc-launcher BC is installed
#     And the operator supplies a launch-time LLM provider override of "openrouter"
#     And the fleet-wide provider-keyed model mapping table names a literal model ID for the active provider
#     When bc-container launch's dispatcher spawns a child "fabro run" for BC name "shopsystem-messaging" with the OpenRouter provider override
#     Then the child "fabro run" command line carries "--model <literal-model-id> --provider openrouter", sourced from the mapping table for the active provider
#     And the command line carries no "-I MODEL_CODING=", "-I MODEL_REVIEW=", or "-I MODEL_DEFAULT=" input for this launch
#     And every node in the workflow, regardless of its ".coding"/".review"/"*" node-class, resolves to that same single run-wide model — per-node-class model differentiation is not supplied by this launch
#
@bc:shopsystem-bc-launcher @origin:brief-017
Feature: shopsystem-bc-launcher selects Anthropic or OpenRouter as the active fabro LLM provider via a launch-time operator override, resolving via a run-wide model/provider pair (brief-017, corrected brief-020, corrected again brief-021)

  cand-002 / intent-002: an operator-settable, LAUNCH-TIME override for
  fabro's LLM provider/model choice, proven end-to-end via OpenRouter as a
  second provider alongside the existing Anthropic-subscription path. "No
  software release" is satisfied by a BC RELAUNCH picking up a new
  operator-set value — the same launch-time-wins-over-default shape as
  bc_container_runtime_proxy.feature's "--agent-vault-broker" precedence and
  ADR-043's ops-coordinates rendered-default-with-override pattern. No
  hot-reload / in-flight mutation is introduced.

  BUGFIX (brief-020, 2026-07-15): a real end-to-end scout proved the
  originally-shipped provider-REGISTRATION shape (a NEW custom fabro
  provider literally named "openrouter") never actually completes a real
  dispatch — see the first RETIRED-scenario provenance header above. The
  brief-020 fix registered the override under fabro's NATIVE "openai"
  provider identity with "base_url" pointed DIRECTLY at OpenRouter's own
  host, credential riding "OPENAI_API_KEY".

  BUGFIX (brief-021, 2026-07-15): a second real end-to-end scout — this
  time with a live agent-vault broker and a real credential — proved
  brief-020's fix ALSO never completes a real dispatch, for a structurally
  different reason than brief-020's own bug: fabro's sandboxed agent-node
  execution path (verified directly in fabro's own source,
  lib/crates/fabro-sandbox/src/local.rs) calls ".env_clear()" before
  spawning and never routes its own LLM call through "HTTPS_PROXY" at all —
  confirmed with a deliberately-broken, unreachable proxy hostname producing
  a byte-identical error to the real proxy. This is fabro's own deliberate
  sandbox security boundary, not a config mistake; no credential-source
  trick (env, vault, custom or native provider) fixes it from inside the
  sandbox — the request structurally never reaches agent-vault. The
  corrected fix (this feature's current pinned scenarios, below) introduces
  a LOCAL reverse-proxy shim, "openrouter-shim" — architecturally identical
  in role to the already-shipped "anthropic-oauth-shim" (an UNSANDBOXED,
  container-level process the sandboxed node talks to over plain loopback;
  the shim itself makes the real outbound call through the real
  "HTTPS_PROXY", where agent-vault substitutes the real credential) — but
  needing NO header reshaping, since OpenRouter already speaks plain Bearer
  auth matching what agent-vault substitutes. Reference implementation
  (proven working spike, ~70 lines, stdlib-only "http.server" + "urllib"):
  see brief-021 for the path. brief-021 also corrects the model-resolution
  mechanism: the fabro version this fix requires (>= v0.267.0-nightly.0, for
  native "[llm.providers.openai]" "base_url" support — the "Latest" stable
  release, v0.254.0, has no such support at all) ALSO removes
  "model_stylesheet" templating entirely, invalidating lead-ifye3.1's
  per-node-class "-I MODEL_CODING"/"MODEL_REVIEW"/"MODEL_DEFAULT" mechanism
  outright. Per explicit product-authority direction, per-node-class model
  differentiation is deprioritized (not permanently dropped) in favor of a
  proven run-wide "--model"/"--provider" pair on the dispatcher's per-child
  "fabro run" command line. See the second RETIRED-scenario provenance
  header above for full disposition of each superseded hash. The "no
  override" default path (L1, "1d9d3777e3c3d8f5") is UNAFFECTED by either
  bugfix and is not retired.

  BUGFIX (brief-021 §12 addendum, 2026-07-15): a live end-to-end proof
  attempt (lead-85s41) of the L5 end-to-end scenario found its own "no
  further ... image rebuild" claim false: the scenario's When-clause
  requires the shopsystem-bc-launcher BC's own running container to perform
  a NESTED "bc-container launch", and the bc-base image bakes in no docker
  binary at all — "docker.io" on this image's Debian trixie base installs
  only the daemon, not the client; the separate "docker-cli" apt package is
  required and is not yet baked into the image build. A SECOND, additional
  one-time bc-base image-build change is genuinely required, on top of the
  already-satisfied FABRO_VERSION precondition — not zero further image
  changes, as L5 previously asserted. See the third RETIRED-scenario
  provenance header above for full disposition.

  BUGFIX (brief-021 §13 addendum, 2026-07-15): a live end-to-end proof retry
  (lead-lp4us), run with BOTH the FABRO_VERSION and "docker-cli" image
  preconditions genuinely satisfied for the first time, confirmed the
  underlying nested-launch-to-openrouter-shim mechanism works (11 real
  HTTP-200 OpenRouter completions) but found L5's own "no further release"
  claim false a second time: TWO further software fixes, not zero, are
  required before a real dispatch reaches gated work_done — a stale
  shopsystem-templates pour of "model_stylesheet" (lead-ifye3.6) and a
  shopsystem-bc-launcher call-site bug passing the active-provider NAME
  instead of the registered fabro identity to "fabro run --provider"
  (lead-ifye3.10). See the fourth RETIRED-scenario provenance header above
  for full disposition.

  BUGFIX (brief-021 §14 addendum, lead-ifye3.10, 2026-07-15): `lead-ifye3.10`
  (dispatched by the §13 addendum to fix "engage.py"'s active-provider-NAME
  call-site bug) came back "status: blocked", correctly — its own fix,
  proven correct live (11 real HTTP-200 OpenRouter completions with
  "--provider openai" substituted), turns THIS feature's own L4 scenario
  ("a3b2b6bebcee78f5", the run-wide "--model"/"--provider" flags scenario)
  RED: that scenario's own Then-clause still asserted the pre-fix, buggy
  value, "--provider openrouter", which independently contradicts both
  "af07c326a031fafe" (no custom "openrouter" fabro provider is ever
  registered) and "5d49031bab379ba6" (which already assumes the call-site
  fix as a satisfied Given precondition). See the fifth RETIRED-scenario
  provenance header above for full disposition. "a3b2b6bebcee78f5" is
  RETIRED, superseded by "bb4f75cea78091c0", which corrects the Then-clause
  to "--provider openai" and separates model-sourcing (mapping table) from
  provider-sourcing (fabro's registered native identity) — the conflated
  phrasing that let this bug ship unpinned in the first place.

  @scenario_hash:1d9d3777e3c3d8f5
  Scenario: a plain launch with no operator-supplied provider override keeps the Anthropic-subscription path as the active LLM provider
    Given the shopsystem-bc-launcher BC is installed
    And no launch-time "--llm-provider" or "BCLAUNCHER_LLM_PROVIDER" override is supplied
    When bc-container launch is run for BC name "shopsystem-messaging"
    Then the container's fabro run is launched with the active LLM provider set to "anthropic"
    And no OpenRouter agent-vault credential is requested for this launch

  @scenario_hash:af07c326a031fafe
  Scenario: an explicit launch-time provider override registers fabro's NATIVE "openai" provider identity with its "base_url" pointed at the LOCAL "openrouter-shim" loopback endpoint, not directly at OpenRouter's own host
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies a launch-time LLM provider override of "openrouter" via "--llm-provider openrouter" (or "BCLAUNCHER_LLM_PROVIDER=openrouter")
    When bc-container launch is run for BC name "shopsystem-messaging" with the operator-supplied provider override
    Then the container's fabro settings register the override under fabro's NATIVE "openai" provider identity, with its "base_url" set to the local "openrouter-shim" process's loopback address — not "https://openrouter.ai" directly and no new custom "openrouter" fabro provider is registered
    And the "openrouter-shim" process is launched as an unsandboxed, container-level process alongside the fabro sandboxed run, the same launch-lifecycle shape the existing "anthropic-oauth-shim" already uses
    And the Anthropic anthropic-oauth-shim path is not engaged for this launch

  @scenario_hash:a28018af66182e33
  Scenario: registering any override beyond "base_url" on the openai provider entry breaks fabro's startup precondition gate — only "base_url" may be touched
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies a launch-time LLM provider override of "openrouter"
    When the container's fabro settings register the "openai" provider override with ONLY "base_url" overridden and no other key changed
    Then the sandboxed worker's startup precondition check passes cleanly and the run proceeds to its first node
    But when an explicit "adapter" or "auth" override is added on top of "base_url" — even a value that would logically merge with the built-in catalog default — the same precondition check instead fails immediately with "No LLM providers configured, set ANTHROPIC_API_KEY or OPENAI_API_KEY", before any node runs

  @scenario_hash:7f55b8ee9e092692
  Scenario: the "openrouter-shim" is an unsandboxed, container-level reverse proxy that forwards the sandboxed node's request unchanged to OpenRouter's real API host, with no header reshaping
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies a launch-time LLM provider override of "openrouter"
    And the "openrouter-shim" process is running, listening on a loopback address only
    When the sandboxed fabro node issues its LLM call to the "openai"-identified provider's configured "base_url"
    Then the request reaches the "openrouter-shim" process over plain loopback, with no "HTTPS_PROXY" needed for that hop
    And the shim forwards the request to "https://openrouter.ai/api" plus the incoming request path, unchanged, with no header reshaping — unlike the "anthropic-oauth-shim", which does reshape headers
    And the shim streams the upstream response back to the sandboxed node unchanged

  @scenario_hash:05638241a033ef0c
  Scenario: the real OpenRouter credential is substituted on the shim's own outbound hop by agent-vault, matching the GITHUB_TOKEN no-shim pattern moved one hop out — never present in the sandboxed node's filesystem or process environment
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies a launch-time LLM provider override of "openrouter"
    And an agent-vault broker with a registered OpenRouter-host credential service is running on the shopsystem network and is reachable
    When bc-container launch starts the agent for BC name "shopsystem-messaging" with the OpenRouter provider override
    Then the sandboxed node's "OPENAI_API_KEY" value is the literal placeholder "__PLACEHOLDER__", carried unchanged onto the "Authorization: Bearer" header the node sends to the "openrouter-shim"
    And the "openrouter-shim" process's own environment (not the sandboxed node's) carries the real "HTTPS_PROXY", through which the agent-vault broker's MITM proxy substitutes the real OpenRouter API key onto that same "Authorization: Bearer" header only on the shim's outbound wire hop, scoped to requests directed at the OpenRouter host
    And the real OpenRouter API key is not present in the sandboxed node's filesystem or process environment at any point, including via "[run.environment.env]" overlays, because fabro's sandboxed execution path clears and filters credential-shaped environment variables before spawning

  @scenario_hash:bb4f75cea78091c0
  Scenario: the dispatcher's per-child "fabro run" command line carries run-wide "--model"/"--provider" flags, replacing the retired per-node-class "-I MODEL_CODING"/"MODEL_REVIEW"/"MODEL_DEFAULT" inputs
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies a launch-time LLM provider override of "openrouter"
    And the fleet-wide provider-keyed model mapping table names a literal model ID for the active provider
    When bc-container launch's dispatcher spawns a child "fabro run" for BC name "shopsystem-messaging" with the OpenRouter provider override
    Then the child "fabro run" command line carries "--model <literal-model-id> --provider openai", the model sourced from the mapping table for the active provider and the provider naming fabro's REGISTERED native identity — the "[llm.providers.openai]" entry the override registers — never the operator-facing "openrouter" provider name, which fabro's literal provider lookup cannot resolve
    And the command line carries no "-I MODEL_CODING=", "-I MODEL_REVIEW=", or "-I MODEL_DEFAULT=" input for this launch
    And every node in the workflow, regardless of its ".coding"/".review"/"*" node-class, resolves to that same single run-wide model — per-node-class model differentiation is not supplied by this launch

  @scenario_hash:5d49031bab379ba6
  Scenario: a real dispatch completes end-to-end on a BC launched with the OpenRouter override, given already-satisfied FABRO_VERSION, bc-base "docker-cli", shop-templates model_stylesheet pour, and bc-launcher provider-identity call-site preconditions, with no further software release required
    Given the shopsystem-bc-launcher BC's container image was already built from a bc-base image pinned to a FABRO_VERSION carrying native "[llm.providers.openai]" support, satisfied once, prior to and independent of this launch
    And the "openrouter-shim" process is part of that same already-built image
    And that same bc-base image also bakes in the "docker-cli" apt package (the docker CLI client binary — not satisfied by "docker.io" alone, which on this image's Debian trixie base installs only the "dockerd" daemon, no client), satisfied once, prior to and independent of this launch, so the launched container can perform the nested "bc-container launch" its own dispatched work requires
    And the container is launched with the "--mount-docker-socket" operator flag, so the baked "docker-cli" client has a socket to reach
    And shopsystem-templates' poured "templates/fabro/workflow.fabro" no longer carries the retired "model_stylesheet" "{{ inputs.X }}" placeholder shape, which fabro >= v0.267.0-nightly.0 hard-parse-errors on, satisfied once, prior to and independent of this launch
    And the shopsystem-bc-launcher dispatcher's per-child "fabro run --provider" construction passes the REGISTERED fabro provider identity ("openai"), not the active-provider name ("openrouter"), satisfied once, prior to and independent of this launch
    And an agent-vault broker with a registered OpenRouter-host credential service is running on the shopsystem network and is reachable
    And the operator supplies a launch-time LLM provider override of "openrouter"
    When bc-container launch is run for a BC with the OpenRouter provider override and a substantive assign_scenarios dispatch is delivered to it
    Then the dispatched work reaches a gated work_done, having executed through at least one non-trivial node-class, such as ".coding", whose model resolved to a literal OpenRouter model ID via the "openrouter-shim"
    And no further software release was required beyond the already-satisfied FABRO_VERSION, bc-base "docker-cli", shop-templates model_stylesheet pour-fix, and bc-launcher provider-identity call-site-fix preconditions — only the launch-time provider override, the "--mount-docker-socket" flag, and a container relaunch
