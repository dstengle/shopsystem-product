@bc:shopsystem-templates @origin:lead-i8u
Feature: Bootstrap is idempotent over an already-initialized ".beads/" (lead-i8u)

  When the target already carries an initialized ".beads/" directory (the
  "wrap an existing beads workspace" case, brief 002), `bd init` aborts with
  "Found existing Dolt database... Aborting" and a naive shell-out would
  fail the whole bootstrap. Per architect option (a), bootstrap DETECTS the
  already-initialized ".beads/" and SKIPS the `bd init` subprocess entirely,
  preserving the existing ".beads/" contents byte-for-byte while still
  writing the rest of the canonical scaffold; exit 0. This is purely
  additive — scenarios 2277308ce4fb92d2 / 31a044e7d2eceaf4 pin the
  no-".beads/" init path and are precondition-disjoint, so they continue to
  hold.

  @scenario_hash:5786b555ee0732bf
  Scenario Outline: bootstrap on a target whose ".beads/" directory is already initialized skips the "bd init" subprocess and preserves the existing ".beads/" contents, so wrapping an existing beads workspace is idempotent rather than aborting
    Given an existing git repository at a target directory "<target>" with an already-initialized ".beads/" directory whose contents are recorded before the invocation
    When I invoke the "shop-templates" bootstrap entry point with shop type "<shop_type>", shop name "<shop_name>", and target directory "<target>"
    Then the exit code is 0
    And during the invocation no subprocess named "bd" was executed with first argument "init"
    And after the invocation the contents of the ".beads/" directory are byte-for-byte identical to the contents recorded before the invocation
    And the remainder of the canonical scaffold for shop type "<shop_type>" is written to the target directory by the same invocation

    Examples:
      | shop_type | shop_name                  | target                       |
      | bc        | shopsystem-test-harness    | /tmp/example-existing-bc     |
      | lead      | shopsystem-product         | /tmp/example-existing-lead   |
