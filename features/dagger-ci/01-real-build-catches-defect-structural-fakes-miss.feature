@bc:shopsystem-bc-launcher @origin:adr-052
Feature: the dagger build-and-test gate REDs on a real fabro asset-sidecar 404 that the structural pytest suite stays GREEN on

  Dagger closes the empty middle the structural-only fakes never cover — ADR-052 D1/D3
  (the real-image tier is the value the structural fakes lack), ADR-053 D2 (no-divergence:
  build-and-test and build-test-and-push share one build core so the local gate exercises
  the shipped download). Anchored on ADR-021 (bc-launcher owns the bc-base image dagger
  WRAPS), ADR-018/PDR-011 (contract-surface pre-state — the split was observed on-host, no
  BC source read/run/git-observed; findings/dagger-spike/*.md are the artifact surface).
  Evidence: findings/dagger-spike/02-dagger-experiment.md (a) Split 1 + 02a-experiment.md.
  The defect is a realistic bead-0fz SIBLING: the fabro release main tarball name stays
  correct ("fabro-x86_64-unknown-linux-gnu.tar.gz"), only the checksum sidecar URL changes
  from ".sha256" to ".sha256sum". The structural gate (the fabro-leg assertion battery
  extracted verbatim from the public tests/conftest.py; fabro --version runs against
  FakeDockerDriver returning canned exit-0) has no text-pin for the sidecar extension and
  stays GREEN. The lesson pinned: text-pins are REACTIVE — they only catch the exact
  regression someone already wrote a string for; the sidecar sibling slips a reactive
  text-pin but not a real download. Distinct from features/bc-launcher/37 (GHCR publish
  contract) and /58-59 (dependency-poll pin bump) — those pin publish/pin surfaces, not
  the build-time real-download gate; this NET-NEW pin does not duplicate them.
  @scenario_hash:2c66a1b1d1b6f092
  Scenario: build-and-test REDs on a checksum-sidecar 404 locally before any tag while the structural pytest suite stays GREEN
    Given the real bc-base Dockerfile whose fabro install RUN downloads the release main tarball "fabro-x86_64-unknown-linux-gnu.tar.gz" and its checksum sidecar
    And the checksum sidecar URL carries the extension ".sha256sum" instead of the correct ".sha256" while the main tarball name is unchanged
    And the current structural pytest suite whose fabro --version leg runs against FakeDockerDriver and whose asserts carry no text-pin for the sidecar extension
    When "dagger call build-and-test" builds the fabro install RUN through the agent-vault egress engine locally, before any version tag is pushed
    And the same structural pytest suite is run against the same Dockerfile
    Then the dagger build-and-test gate goes RED because the sidecar "curl -fsSL …fabro-x86_64-unknown-linux-gnu.tar.gz.sha256sum" returns "curl: (22)" on a 404 while the main tarball downloaded through agent-vault
    And the structural pytest suite stays GREEN because no assert covers the sidecar extension and FakeDockerDriver returns a canned exit-0
