@bc:shopsystem-bc-launcher @origin:adr-054
Feature: build-test-and-push produces a dual-tag single-digest over the same shared build core that build-and-test ran, only after the same test tiers are green

  No-divergence is structural, not asserted — ADR-053 D1 (the engineVersion pin + identical
  dagger call shape make local == CI), D2 (build-and-test and build-test-and-push call the
  identical shared build() core; the push tier runs ONLY after the same test tiers are
  green), D3 (dual-tag {version, latest} resolves to ONE content-addressed digest, observed
  not asserted). Anchored on ADR-052 (the module/WRAP this makes non-divergent), ADR-021
  (bc-launcher owns the pipeline both invocations run), lead-5xnd/IS-4 (the GHCR
  image/label/digest identity preserved by the WRAP), ADR-018/PDR-011 (contract-surface
  pre-state — the digest identity was observed on-host, no BC source read/run/git-observed;
  findings/dagger-spike/*.md are the artifact surface). Evidence:
  findings/dagger-spike/02-dagger-experiment.md (c): "dagger call build-test-and-push
  --version=v0.3.48" ran the real-image tier FIRST, then pushed ":v0.3.48" and ":latest"
  to one identical "sha256:a1b927…bad6" ("SAME-DIGEST"). Distinct from
  features/bc-launcher/37 (that "latest" points to the same digest as the version tag on a
  GHCR publish) — this pins the no-divergence property that the SAME build core the local
  gate ran produces that dual-tag single digest, and that the push tier is gated behind the
  same green tests; NET-NEW, not a duplicate of 37.
  @scenario_hash:514d075dbe616f02
  Scenario: build-test-and-push pushes version and latest to one identical digest over the same build core build-and-test ran, only after the same test tiers pass
    Given one engineVersion-pinned dagger module whose build-and-test and build-test-and-push entrypoints call the identical shared build() core
    And the same test tiers that build-and-test runs locally
    When "dagger call build-test-and-push --version=v0.3.48" runs on the CI-shape entrypoint
    Then the push tier runs only after the same test tiers report green
    And the tag "v0.3.48" and the tag "latest" are pushed to one identical content-addressed digest "sha256:a1b927…bad6"
    And the no-divergence property holds structurally because the local and CI entrypoints ran the identical build() core, not because digest identity was separately asserted
