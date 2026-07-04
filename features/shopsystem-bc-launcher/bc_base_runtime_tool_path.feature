@bc:shopsystem-bc-launcher @origin:lead-h755
Feature: a launched bc-base BC has gh and agent-vault resolvable on PATH at runtime (lead-h755)

  Regression guard pinning a present-but-unpinned runtime invariant: a launched
  bc-base BC ALREADY has gh and agent-vault resolvable on PATH inside the
  running container ("command -v gh" / "command -v agent-vault" exit zero and
  print an executable path). gh is present incidentally from the upstream base
  image (could regress); agent-vault is installed but only incidentally
  asserted. This scenario pins the runtime-PATH regression guard so a future
  regression (e.g. gh dropping out of the upstream base image) is caught.

  Scope exclusion (load-bearing): docker is EXPLICITLY EXCLUDED. bc-base carries
  no docker CLI by design (PDR-020 Addendum II; docker is bc-LEAD-only). This
  guard covers gh and agent-vault ONLY and must NOT require docker on PATH.

  docker is unavailable in this environment, so the running-container runtime
  observable is modelled through the FakeDockerDriver's in-container exec model
  (the same way other launched-container runtime scenarios are tested); the real
  runtime observable is the lead's pull verification for the published image.

  @scenario_hash:04f2c7501273705c
  Scenario: a launched bc-base BC has gh and agent-vault resolvable on PATH
    Given the shopsystem-bc-launcher BC is installed
    And bc-container launch is run with BC name "shopsystem-messaging"
    And the container "bc-shopsystem-messaging" is running on the pinned bc-base image
    When "command -v gh" and "command -v agent-vault" are executed inside that running container
    Then each command exits zero and prints an executable path for "gh" and for "agent-vault" respectively
