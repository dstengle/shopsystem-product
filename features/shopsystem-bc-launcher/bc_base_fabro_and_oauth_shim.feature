# RETIRED-scenario provenance (brief-021 §3 follow-on / lead-ifye3.7, 2026-07-15
# — request_bugfix dispatch; bodies below are byte-identical to what was
# retired, for hash-provenance only):
#   @scenario_hash:a3512aedb8763150 RETIRED (brief-021 §3 follow-on)
#   Asserted the baked fabro binary reports version "v0.254.0". brief-021 §3
#   named `>= v0.267.0-nightly.0` as the required fabro version for the
#   OpenRouter fix (native `[llm.providers.openai].base_url` support,
#   confirmed absent on v0.254.0) — an accepted infrastructure tradeoff,
#   confirmed accepted by product authority. The bc-launcher BC
#   (lead-ifye3.7, dispatched to bump `docker/bc-base/Dockerfile`'s
#   `ARG FABRO_VERSION`) independently re-verified against fabro-sh/fabro's
#   own source at tag v0.267.0-nightly.0 that both required capabilities
#   are present there (`ProviderSettings.base_url` in
#   lib/crates/fabro-config/src/layers/llm.rs, and
#   lib/crates/fabro-model/src/catalog/providers/openrouter.toml), and
#   reported this scenario's literal "v0.254.0" assertion FAILS the moment
#   FABRO_VERSION is bumped — a genuine cross-scenario conflict this lead
#   shop owns (ADR-010 pin authority), not a defect in the BC's bump. Since
#   there is no per-BC/per-path FABRO_VERSION override (ADR-021 D4,
#   confirmed still deferred) every BC container floats to the single
#   bc-base:latest fabro binary, so this scenario's baked-version assertion
#   must move in lockstep with the OpenRouter fix's precondition. Superseded
#   by the new scenario below asserting "v0.267.0-nightly.0".
#   Original body:
#     Given the shopsystem-bc-launcher BC is installed
#     And bc-container launch is run with BC name "shopsystem-messaging"
#     And the container "bc-shopsystem-messaging" is running on the pinned bc-base image
#     When "fabro --version" is executed inside that running container
#     Then it exits zero and reports the fabro version "v0.254.0"
#     And the anthropic-oauth-shim is resolvable inside the container as a baked launcher, and invoking that launcher with its usage/help flag exits zero using the python standard library alone with no third-party import required
#     And both fabro and the anthropic-oauth-shim are real baked artifacts present in the running container, not placeholders and not merely declared in the image manifest
#   @scenario_hash:4fc67c610cba6227 RETIRED (brief-021 §3 follow-on)
#   Asserted the baked fabro pin the centralized poll's bump-rebuild
#   mechanism compares against is the literal "v0.254.0". Same root cause as
#   above: the pin this mechanism reads and mutates is the single fleet-wide
#   FABRO_VERSION, now moving to "v0.267.0-nightly.0" per brief-021 §3. The
#   bump-rebuild MECHANISM itself (compare resolved latest release against
#   the baked pin; mutate the Dockerfile; rebuild; republish) is unchanged —
#   only the literal pin value the mechanism starts from changes. Superseded
#   by the new scenario below.
#   Original body:
#     Given the bc-base Dockerfile in shopsystem-bc-launcher bakes fabro at pin "v0.254.0" as a baked dependency alongside shop-templates, shop-msg, scenarios, and beads
#     And the single centralized scheduled bc-launcher workflow is the one poll that check-bump-rebuilds bc-base for its baked dependencies
#     When the workflow's dependency check runs and its executable body, with YAML comment lines excluded, is inspected
#     Then the executable body enumerates "fabro" mapped to its canonical public release source "fabro-sh/fabro"
#     And a "fabro" to "fabro-sh/fabro" mapping present only in a descriptive YAML comment, absent from the executable body, does not satisfy this enrollment
#     And the fabro latest-release lookup reads the public "fabro-sh/fabro" releases using the workflow's own "GITHUB_TOKEN" and references no "BC_LAUNCHER_DISPATCH_TOKEN" or any other cross-repo dispatch credential
#     And when the resolved latest fabro release tag differs from the baked "v0.254.0" pin, the workflow first mutates the Dockerfile fabro pin to the resolved tag, then rebuilds bc-base and republishes "ghcr.io/dstengle/shopsystem-bc-base:latest" at the new digest
#     And a bare rebuild that left the Dockerfile fabro pin at "v0.254.0" would not satisfy this behavior
@bc:shopsystem-bc-launcher @origin:adr-049
Feature: bc-base bakes fabro v0.267.0-nightly.0 and the anthropic-oauth-shim, and the centralized poll enrolls fabro (lead-ckq5, version corrected brief-021 §3 / lead-ifye3.7)

  bc-base bakes the fabro binary (pinned v0.267.0-nightly.0 from
  fabro-sh/fabro) and a real stdlib-only anthropic-oauth-shim launcher, both
  present + launchable in the running container; and the single centralized
  scheduled poll enrolls fabro as a 6th baked dependency against
  fabro-sh/fabro, resolving with the workflow's own GITHUB_TOKEN and
  bump-then-rebuilding :latest on a newer release.

  BUGFIX (brief-021 §3 follow-on, lead-ifye3.7, 2026-07-15): the fabro
  version this feature pins moved from "v0.254.0" (fabro's then-current
  stable release) to "v0.267.0-nightly.0" — a nightly pre-release, accepted
  as an explicit infrastructure tradeoff — because brief-021 §3's OpenRouter
  fix requires native `[llm.providers.openai].base_url` override support,
  confirmed absent on v0.254.0. There is no per-BC/per-path FABRO_VERSION
  override (ADR-021 D4, still deferred), so every BC container floats to the
  single fleet-wide bc-base:latest fabro binary — this feature's
  baked-version assertion and the OpenRouter fix's precondition are the same
  fleet-wide pin and must move together. See the RETIRED-scenario provenance
  header above for the two superseded hashes' full disposition.

  FIDELITY: docker is unavailable in this environment. fabro is a binary that
  cannot run in-env, so scenario acc72693771d8c6b's fabro leg binds to the
  docker/bc-base/Dockerfile install (pinned v0.267.0-nightly.0 from
  fabro-sh/fabro onto PATH, a real download RUN — comment-stripped
  detection); the live `fabro --version` is the lead's pull verification,
  also gated by the build-time self-check. The anthropic-oauth-shim is a REAL
  committed file, so the test EXECUTES the actual committed shim
  (`python3 <shim> --help`) and asserts exit 0 AND that it imports no
  third-party module (stdlib-only). The poll scenario ea139400f8efb546 binds
  to the committed poll workflow's executable body via _strip_yaml_comments
  (comment-only mapping does NOT satisfy — the 5vyb pattern).

  @scenario_hash:acc72693771d8c6b
  Scenario: a launched bc-base BC has fabro v0.267.0-nightly.0 and the anthropic-oauth-shim present and launchable
    Given the shopsystem-bc-launcher BC is installed
    And bc-container launch is run with BC name "shopsystem-messaging"
    And the container "bc-shopsystem-messaging" is running on the pinned bc-base image
    When "fabro --version" is executed inside that running container
    Then it exits zero and reports the fabro version "v0.267.0-nightly.0"
    And the anthropic-oauth-shim is resolvable inside the container as a baked launcher, and invoking that launcher with its usage/help flag exits zero using the python standard library alone with no third-party import required
    And both fabro and the anthropic-oauth-shim are real baked artifacts present in the running container, not placeholders and not merely declared in the image manifest

  @scenario_hash:ea139400f8efb546
  Scenario: the centralized poll enrolls fabro as a baked dependency against fabro-sh/fabro and bump-rebuilds :latest on a newer release
    Given the bc-base Dockerfile in shopsystem-bc-launcher bakes fabro at pin "v0.267.0-nightly.0" as a baked dependency alongside shop-templates, shop-msg, scenarios, and beads
    And the single centralized scheduled bc-launcher workflow is the one poll that check-bump-rebuilds bc-base for its baked dependencies
    When the workflow's dependency check runs and its executable body, with YAML comment lines excluded, is inspected
    Then the executable body enumerates "fabro" mapped to its canonical public release source "fabro-sh/fabro"
    And a "fabro" to "fabro-sh/fabro" mapping present only in a descriptive YAML comment, absent from the executable body, does not satisfy this enrollment
    And the fabro latest-release lookup reads the public "fabro-sh/fabro" releases using the workflow's own "GITHUB_TOKEN" and references no "BC_LAUNCHER_DISPATCH_TOKEN" or any other cross-repo dispatch credential
    And when the resolved latest fabro release tag differs from the baked "v0.267.0-nightly.0" pin, the workflow first mutates the Dockerfile fabro pin to the resolved tag, then rebuilds bc-base and republishes "ghcr.io/dstengle/shopsystem-bc-base:latest" at the new digest
    And a bare rebuild that left the Dockerfile fabro pin at "v0.267.0-nightly.0" would not satisfy this behavior
