@bc:shopsystem-bc-launcher @origin:lead-czwo
Feature: centralized scheduled bc-base dependency check-bump-rebuild (lead-czwo)

  A single scheduled workflow in shopsystem-bc-launcher polls every baked
  bc-base dependency for its latest canonical release, bumps the
  docker/bc-base/Dockerfile pin when one is newer, commits the bumped
  Dockerfile, then rebuilds bc-base and republishes :latest. This REPLACES the
  per-repo repository_dispatch fan-in (the retired scenarios 365be56194c892b9 +
  edd2c813688ab768; ADR-022). Per the scenario-40 declarative-artifact
  precedent, live Actions / live registry state is OUT-OF-BAND: these scenarios
  pin the committed workflow + Dockerfile YAML/text as DECLARATIVE ARTIFACTS via
  structural inspection.

  @scenario_hash:930a6a6579e2a859
  Scenario: the bc-base rebuild trigger is one scheduled workflow owned by shopsystem-bc-launcher
    Given the shopsystem-bc-launcher BC repository owns the bc-base Dockerfile and its publish CI
    When the workflow that triggers the bc-base check-bump-rebuild cycle is inspected
    Then there is exactly one workflow in shopsystem-bc-launcher that runs that cycle
    And that workflow declares a cron "schedule:" trigger so the check runs on a recurring schedule without an external event
    And the workflow's executable body, with YAML comment lines excluded, handles all baked dependencies rather than one workflow per dependency
    And a dependency enumerated only in a descriptive YAML comment, absent from the executable body, does not satisfy "handles all baked dependencies"
    And no inbound cross-repo "repository_dispatch" event is required to start the cycle

  @scenario_hash:0f386f31857fbeb1
  Scenario Outline: the poll resolves each baked dependency's latest release tag using bc-launcher's own GITHUB_TOKEN
    Given the centralized scheduled workflow in shopsystem-bc-launcher runs its dependency check
    And the baked dependency "<dependency>" is resolved against its canonical repository "<canonical_repo>"
    When the workflow looks up the latest release tag for "<dependency>"
    Then the workflow's executable body, with YAML comment lines excluded, enumerates "<dependency>" mapped to its canonical repository "<canonical_repo>"
    And a "<dependency>" to "<canonical_repo>" mapping present only in a descriptive YAML comment, absent from the executable body, does not satisfy this lookup
    And the lookup reads the public "<canonical_repo>" releases using the workflow's own "GITHUB_TOKEN"
    And the lookup does not reference a "BC_LAUNCHER_DISPATCH_TOKEN" or any other cross-repo dispatch credential
    And the resolved latest release tag for "<dependency>" is what the workflow compares against the current bc-base Dockerfile pin

    Examples:
      | dependency     | canonical_repo                  |
      | shop-templates | dstengle/shopsystem-templates   |
      | shop-msg       | dstengle/shopsystem-messaging   |
      | scenarios      | dstengle/shopsystem-scenarios   |
      | beads          | steveyegge/beads                |

  @scenario_hash:5b6a931a493971a6
  Scenario: when a dependency's latest release is newer than the Dockerfile pin, the workflow bumps the pin then rebuilds and republishes :latest
    Given the bc-base Dockerfile in shopsystem-bc-launcher pins a baked dependency at "@v1.0.0"
    And the centralized scheduled workflow resolves that dependency's latest release tag as "@v1.1.0"
    When the workflow runs its check-bump-rebuild cycle for that dependency
    Then the workflow first mutates "docker/bc-base/Dockerfile" so the dependency pin reads "@v1.1.0" rather than "@v1.0.0"
    And only after the pin is bumped does the workflow run the bc-base image build
    And the workflow republishes "ghcr.io/dstengle/shopsystem-bc-base:latest" at the new digest built from the bumped Dockerfile
    And a bare rebuild that left the Dockerfile pin at "@v1.0.0" would not satisfy this behavior

  @scenario_hash:cf8625dbac93cfdc
  Scenario: a scheduled run where every dependency's latest release already equals its Dockerfile pin makes no change
    Given the bc-base Dockerfile in shopsystem-bc-launcher pins every baked dependency at its current "@vX.Y.Z"
    And for every baked dependency the resolved latest release tag equals the tag already pinned in the Dockerfile
    When the centralized scheduled workflow runs its check-bump-rebuild cycle
    Then the workflow leaves "docker/bc-base/Dockerfile" unchanged with no pin bumped
    And the workflow does not run a bc-base image build
    And the workflow does not republish "ghcr.io/dstengle/shopsystem-bc-base:latest" with a new digest

  @scenario_hash:59c0f539187eabbb
  Scenario: an operator manually starts the workflow via workflow_dispatch and it runs the same check-bump-rebuild path
    Given the centralized bc-base rebuild workflow in shopsystem-bc-launcher declares a "workflow_dispatch" trigger
    And a baked dependency's latest release tag is newer than the tag pinned in "docker/bc-base/Dockerfile"
    When an operator starts the workflow via "workflow_dispatch" from the Actions UI or "gh workflow run"
    Then the manually started run resolves each baked dependency's latest release tag the same way the scheduled run does
    And the run bumps the stale Dockerfile pin then rebuilds and republishes "ghcr.io/dstengle/shopsystem-bc-base:latest"
    And starting the workflow this way requires no source-code change and no raw "gh api .../dispatches" call

  @scenario_hash:f8a8b52a2a22bb66
  Scenario: when the workflow bumps a pin and rebuilds, it commits the bumped Dockerfile recording the triggering dependency version
    Given the centralized scheduled workflow bumps a baked dependency pin in "docker/bc-base/Dockerfile" from "@v1.0.0" to "@v1.1.0"
    When the workflow rebuilds bc-base and republishes "ghcr.io/dstengle/shopsystem-bc-base:latest" from that bumped Dockerfile
    Then the bumped "docker/bc-base/Dockerfile" is committed back to the shopsystem-bc-launcher repository
    And the committed Dockerfile records the dependency pinned at "@v1.1.0" that the republished bc-base:latest was built from
    And the build was not produced from an uncommitted working-tree-only pin edit

  @scenario_hash:c9b11efa456f9f00
  # RETIREMENT (ADR-022, work_id lead-czwo): this re-authored scenario SUPERSEDES the
  # BC-pinned @scenario_hash:edd2c813688ab768 (the prior 53, dispatch-client_payload
  # path) -- retire that hash from the bc-launcher register and re-pin this block's
  # hash in its place. Sibling @scenario_hash:c9b11efa456f9f00 (the prior 52,
  # repository_dispatch-receiver topology) is RETIRED WITH NO SUCCESSOR: the
  # centralized poll (scenarios 57-62) replaces the per-repo repository_dispatch
  # fan-in entirely, so drop 365be56194c892b9 from the register and re-run BC-side
  # supersede-enumeration. Both retired hashes were confirmed BC-pinned via the
  # lead-pwa2 / lead-aw1b work_done; this is an explicit BC-register retirement, not
  # a lead-side-only supersession.
  Scenario: after the centralized poll propagates a newer dependency release, bc-base:latest carries the released version
    Given the published "bc-base:latest" image carries an installed baked dependency at version "vDep_old"
    And the dependency's canonical repository publishes a newer release tag "vDep_new" distinct from "vDep_old"
    And the centralized scheduled bc-launcher workflow resolves "vDep_new" as that dependency's latest release
    When the workflow bumps the Dockerfile pin to "vDep_new", rebuilds bc-base, and republishes the "latest" tag
    Then pulling "ghcr.io/dstengle/shopsystem-bc-base:latest" yields an image whose installed dependency reports version "vDep_new"
    And the installed dependency version is no longer the previously hard-pinned "vDep_old"
