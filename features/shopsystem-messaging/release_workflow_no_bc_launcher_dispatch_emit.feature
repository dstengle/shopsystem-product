@bc:shopsystem-messaging @origin:adr-022
Feature: shopsystem-messaging release workflow declares NO repository_dispatch emit to bc-launcher (ADR-022)

  Register parity with shopsystem-scenarios: the no-emit guarantee that
  lead-k6xq made true (release.yml deleted, pytest guard
  tests/test_release_dispatch_retired.py added) is pinned here as a tagged
  scenario_hash BDD scenario. The hash is computed scenario-block-only and
  canonical (ADR-019), so the tag line is followed IMMEDIATELY by the
  scenario keyword with NO comment lines inside the hashed block; any
  provenance note lives here in this Feature-level description, outside the
  hashed block. (work_id lead-0udp supersedes lead-n8pf, whose embedded
  comment block contaminated the hash to the wrong 974ee value; the correct
  clean-block register value is fd28deb48a7c75f4.)

  @scenario_hash:fd28deb48a7c75f4
  Scenario: shopsystem-messaging release workflow declares NO repository_dispatch emit to shopsystem-bc-launcher and references NO BC_LAUNCHER_DISPATCH_TOKEN
    Given the shopsystem-messaging release workflow at ".github/workflows/release.yml"
    And bc-base rebuilds are driven by shopsystem-bc-launcher's own centralized scheduled poll per ADR-022, not by a per-repo repository_dispatch emit
    When the release workflow's executable body, with YAML comment lines excluded, is inspected on a version-tag release
    Then the executable body declares no "dispatch-bc-launcher-build" job and no step performing a repository_dispatch targeting "dstengle/shopsystem-bc-launcher"
    And the executable body declares no repository_dispatch with event_type "framework-utility-release"
    And the executable body references no secret named "BC_LAUNCHER_DISPATCH_TOKEN"
    And a repository_dispatch target or BC_LAUNCHER_DISPATCH_TOKEN reference present only in a descriptive YAML comment, absent from the executable body, does not fail this guarantee
