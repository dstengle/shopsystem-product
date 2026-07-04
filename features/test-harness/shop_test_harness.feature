@bc:shopsystem-test-harness @origin:adr-002
Feature: shop-test-harness bootstrap, freeze, and verify (harness BC — ADR-002)

  @scenario_hash:3d0a20bb39078f32
  Scenario: shop-test-harness bootstrap creates an isolated lead-shop directory ready for inter-shop messaging
    Given an empty target directory for an experiment
    When I run "shop-test-harness bootstrap --target <dir> --lead-shop lead --bc-shop bc-foo"
    Then the exit code is 0
    And a "lead/" subdirectory exists under <dir> with empty "inbox/" and "outbox/" subdirectories
    And a "lead/.beads/" subdirectory exists with beads metadata sufficient for "bd list" to run cleanly (issue prefix matches the lead-shop name)
    And stderr is empty

  @scenario_hash:e4f49b10f8231282
  Scenario: shop-test-harness bootstrap creates an isolated BC-shop directory alongside the lead-shop
    Given an empty target directory for an experiment
    When I run "shop-test-harness bootstrap --target <dir> --lead-shop lead --bc-shop bc-foo"
    Then the exit code is 0
    And a "bc-foo/" subdirectory exists under <dir> with empty "inbox/" and "outbox/" subdirectories
    And a "bc-foo/.beads/" subdirectory exists with beads metadata (issue prefix matches the BC-shop name)
    And "shop-msg send request_maintenance --bc-root <dir>/bc-foo --work-id w-001 --description 'sanity check'" succeeds and writes "<dir>/bc-foo/inbox/w-001.yaml"

  @scenario_hash:11f2115ec1e43ef5
  Scenario: shop-test-harness freeze copies the live topology into an evidence directory under runs/N/
    Given an experiment target directory <dir> populated by a prior bootstrap (lead-shop + one BC-shop, with at least one inbox YAML and one outbox YAML present in the BC-shop's mailboxes)
    And an evidence root directory <evidence>
    When I run "shop-test-harness freeze --target <dir> --evidence <evidence>"
    Then the exit code is 0
    And a numbered subdirectory "<evidence>/runs/1/" exists (numbering is the next free integer)
    And every file under "<dir>/lead/" and "<dir>/bc-foo/" is present under the corresponding path inside "<evidence>/runs/1/", byte-for-byte
    And the evidence directory is a complete, self-contained copy of the topology at the moment freeze was called

  @scenario_hash:f174a0e5c59224a4
  Scenario: shop-test-harness verify exits 0 when the set of scenario hashes echoed in work_done matches the assigned set
    Given an experiment target directory <dir> with a BC-shop whose outbox contains a valid "<work-id>-work_done.yaml" carrying scenario_hashes [H1, H2, H3]
    And an "expected hashes" file at path <expected> listing the same three hashes, one per line, in any order
    When I run "shop-test-harness verify --target <dir> --bc bc-foo --work-id <work-id> --expected <expected>"
    Then the exit code is 0
    And stdout reports "verify: 3 hashes match"
    And stderr is empty

  @scenario_hash:e2a3c9695dd876b6
  Scenario: shop-test-harness verify exits non-zero with a diagnostic naming the divergence when the hash sets do not match
    Given an experiment target directory <dir> with a BC-shop whose outbox contains a valid "<work-id>-work_done.yaml" carrying scenario_hashes [H1, H2]
    And an "expected hashes" file at path <expected> listing [H1, H3] (H1 in common, H2 unexpected, H3 missing)
    When I run "shop-test-harness verify --target <dir> --bc bc-foo --work-id <work-id> --expected <expected>"
    Then the exit code is non-zero
    And stderr names H3 as a hash that was expected but not echoed back (forward-conformance gap)
    And stderr names H2 as a hash that was echoed back but not assigned (reverse-conformance gap)
    And stdout is empty
