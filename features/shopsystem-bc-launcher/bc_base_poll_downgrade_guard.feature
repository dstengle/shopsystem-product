@bc:shopsystem-bc-launcher @origin:lead-bss3
Feature: the centralized bc-base poll resolves latest as semver-max and only bumps on a strictly-forward version, never downgrading and never dying on one bad release (lead-bss3)

  The single centralized scheduled poll (poll-bc-base-deps.yml, check-bump-rebuild
  job) that auto-rebuilds bc-base when a baked dependency changes was BROKEN: it
  mis-resolved shop-templates "latest" as v0.45.0 while the current pin was v0.48.0
  (a DOWNGRADE — latest resolved BELOW the pin), then hit "release not found" and
  exited 1, killing the whole daily poll for every dependency so bc-base was never
  auto-rebuilt on a real dependency bump. This pins the corrected resolve-and-bump
  logic: latest is the semver-max published release, a bump happens only on a
  strictly-greater result, a behind/equal resolution is a no-op (not a downgrade
  and not a failure), and a missing/malformed release for one dependency is skipped
  with a warning rather than aborting the whole poll.

  FIDELITY: per the scenario 4fc67c610cba6227 / 5vyb precedent, live Actions and
  live registry state are OUT-OF-BAND. This scenario binds to the committed poll
  workflow's executable body as a DECLARATIVE ARTIFACT, inspected via the
  comment-stripped executable mapping (_strip_yaml_comments); logic present only in
  a descriptive YAML comment does NOT satisfy the assertions.

  @scenario_hash:9620473690f7ecb5
  Scenario: the poll resolves each baked dependency's latest as the semver-max release and only bumps on a strictly-forward version, never downgrading and never dying on one bad release
    Given the bc-base Dockerfile in shopsystem-bc-launcher pins the baked dependency "shop-templates" at "v0.48.0"
    And the single centralized scheduled bc-launcher poll workflow's "check-bump-rebuild" job resolves each baked dependency's latest published release to decide whether to bump and rebuild bc-base
    When the workflow's executable body, with YAML comment lines excluded, is inspected for how it resolves "latest" and decides whether to bump
    Then the executable body resolves a dependency's latest as the semver-maximum published release rather than an arbitrary or first release-list entry
    And the executable body bumps "docker/bc-base/Dockerfile" and rebuilds bc-base only when the resolved latest is strictly greater than the current pin under semver comparison
    And when the resolved latest for "shop-templates" is "v0.45.0" while the pin is "v0.48.0", the executable body treats the behind-or-equal result as a no-op: it does not rewrite the pin to the lower "v0.45.0" and does not exit non-zero
    And a resolved latest that is below the current pin is handled as a no-bump resolution result, not as a "release not found" hard error that exits the job
    And a missing or malformed latest release for one dependency is skipped with a warning while the remaining baked dependencies are still checked, rather than a hard "exit 1" that aborts the whole poll for every dependency
    And when the resolved latest for a baked dependency is strictly greater than its current pin, the executable body bumps that Dockerfile pin then rebuilds and republishes "ghcr.io/dstengle/shopsystem-bc-base:latest" at the new digest
    And an executable body that rewrote the "shop-templates" pin from "v0.48.0" down to "v0.45.0" or exited non-zero on that behind-resolution would not satisfy this behavior
