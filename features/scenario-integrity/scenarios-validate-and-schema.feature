# NET-NEW under epic lead-vzxd, pinning the shopsystem-scenarios capability
# decided in ADR-056 (rev-2): scenario files conform to a three-dimension
# schema (off-the-shelf @cucumber/gherkin + feature-level @bc owner +
# feature-level @origin provenance + per-scenario @scenario_hash), enforced by
# `scenarios validate`; an --aggregate gate defines DONE; `scenarios hash` is
# reconciled to a single (parser-path, block-only) canonicalization; and a
# conformant create/modify/consolidate helper makes migration hash-safe.
#
# This file DOGFOODS that schema: one Feature: declaration, feature-level
# @bc:shopsystem-scenarios + @origin:adr-056 (inherited by every scenario),
# and a per-scenario @scenario_hash equal to its parser-path block-only hash.
# Provenance root: adr/056-scenario-file-schema-off-the-shelf-gherkin-...md
# and findings/scenario-integrity/00-design.md (rev-2).
@bc:shopsystem-scenarios
@origin:adr-056
Feature: scenarios validate enforces the three-dimension scenario-file schema and one canonicalization

  # ---- Per-file validate: happy path (ADR-056 D4/D5) ----

  @scenario_hash:bc4faf077632e574
  Scenario: A file satisfying all three schema dimensions passes validation with exit code 0
    Given a scenario file that parses under the off-the-shelf @cucumber/gherkin parser
    And the file declares exactly one Feature carrying exactly one @bc naming a known context and exactly one @origin naming a known decision record
    And every scenario in the file carries exactly one @scenario_hash equal to its parser-path block-only hash
    When I run "scenarios validate" against the file
    Then the exit code is 0
    And no violation diagnostic is emitted

  # ---- Per-file validate: off-the-shelf Gherkin parse (ADR-056 D4.1/D5) ----

  @scenario_hash:cee5f6eb2477f007
  Scenario: A file that fails off-the-shelf Gherkin parsing is rejected with E_GHERKIN_PARSE
    Given a scenario file whose text does not parse under the @cucumber/gherkin parser
    When I run "scenarios validate" against the file
    Then the exit code is non-zero
    And the diagnostic names the offending file and the rule code E_GHERKIN_PARSE

  # ---- Per-file validate: exactly one Feature (ADR-056 D4.2) ----

  @scenario_hash:1f34e45aa708df98
  Scenario: A file that declares no Feature is rejected with E_NO_FEATURE
    Given a scenario file that contains one or more scenarios but declares no Feature keyword
    When I run "scenarios validate" against the file
    Then the exit code is non-zero
    And the diagnostic names the offending file and the rule code E_NO_FEATURE

  @scenario_hash:b6cfcc70d4c6e3a2
  Scenario: A file that declares more than one Feature is rejected with E_MULTI_FEATURE
    Given a scenario file that declares two Feature keywords
    When I run "scenarios validate" against the file
    Then the exit code is non-zero
    And the diagnostic names the offending file and the rule code E_MULTI_FEATURE

  # ---- Per-file validate: feature-level @bc owner, exactly one, known (ADR-056 D4.3/D10) ----

  @scenario_hash:9a9737d14bb5669f
  Scenario: A feature missing its @bc owner tag is rejected with E_MISSING_BC
    Given a scenario file whose Feature carries no @bc tag
    When I run "scenarios validate" against the file
    Then the exit code is non-zero
    And the diagnostic names the offending feature and the rule code E_MISSING_BC

  @scenario_hash:b869b8a335639ddd
  Scenario: A feature carrying more than one @bc tag is rejected with E_MULTI_BC
    Given a scenario file whose Feature carries two @bc tags
    When I run "scenarios validate" against the file
    Then the exit code is non-zero
    And the diagnostic names the offending feature and the rule code E_MULTI_BC

  @scenario_hash:75a75ca0b6c99529
  Scenario: A feature whose @bc value is not a known context is rejected with E_UNKNOWN_BC
    Given a scenario file whose Feature carries a @bc value that is absent from the bc-manifest.yaml bcs list and is not the lead product token
    When I run "scenarios validate" against the file
    Then the exit code is non-zero
    And the diagnostic names the offending @bc value and the rule code E_UNKNOWN_BC

  # ---- Per-file validate: feature-level @origin provenance, exactly one, known (ADR-056 D4.4/D2/D10) ----

  @scenario_hash:7eac29945270a1b5
  Scenario: A feature missing its @origin provenance tag is rejected with E_MISSING_ORIGIN
    Given a scenario file whose Feature carries no @origin tag
    When I run "scenarios validate" against the file
    Then the exit code is non-zero
    And the diagnostic names the offending feature and the rule code E_MISSING_ORIGIN

  @scenario_hash:dd1c1ea9904cf7f7
  Scenario: A feature carrying more than one @origin tag is rejected with E_MULTI_ORIGIN
    Given a scenario file whose Feature carries two @origin tags
    When I run "scenarios validate" against the file
    Then the exit code is non-zero
    And the diagnostic names the offending feature and the rule code E_MULTI_ORIGIN

  @scenario_hash:6dcca1590530910b
  Scenario: A feature whose @origin value resolves to no known decision record is rejected with E_UNKNOWN_ORIGIN
    Given a scenario file whose Feature carries an @origin ref that matches no file under adr, pdr, or briefs and no lead bead id
    When I run "scenarios validate" against the file
    Then the exit code is non-zero
    And the diagnostic names the offending @origin value and the rule code E_UNKNOWN_ORIGIN

  # ---- Per-file validate: per-scenario @scenario_hash == parser block-only hash (ADR-056 D4.5/D5) ----

  @scenario_hash:7f0e2a957bbb8d7e
  Scenario: A scenario missing its @scenario_hash tag is rejected with E_MISSING_HASH
    Given a scenario file with a scenario that carries no @scenario_hash tag
    When I run "scenarios validate" against the file
    Then the exit code is non-zero
    And the diagnostic names the offending scenario and the rule code E_MISSING_HASH

  @scenario_hash:b35f46011723a621
  Scenario: A scenario whose @scenario_hash differs from its parser-path block-only hash is rejected with E_HASH_MISMATCH
    Given a scenario whose embedded @scenario_hash value does not equal the block-only hash computed over its body via the parser path
    When I run "scenarios validate" against the file
    Then the exit code is non-zero
    And the diagnostic names the offending scenario together with both the embedded and the recomputed hash and the rule code E_HASH_MISMATCH

  # ---- Per-file validate: optional @service dependency category (ADR-056 D4.5e/D9) ----

  @scenario_hash:25a0a6eadb9ad38a
  Scenario: A conformant feature additionally carrying a known @service tag still passes validation
    Given a conformant scenario file whose Feature also carries a @service value listed in the bc-manifest.yaml services section
    When I run "scenarios validate" against the file
    Then the exit code is 0
    And the optional @service is accepted without substituting for the mandatory @bc owner

  @scenario_hash:2e18817554202ca5
  Scenario: A @service tag does not substitute for the mandatory @bc owner tag
    Given a scenario file whose Feature carries a @service tag but carries no @bc tag
    When I run "scenarios validate" against the file
    Then the exit code is non-zero
    And the diagnostic names the offending feature and the rule code E_MISSING_BC

  # ---- Per-file validate: machine-readable diagnostic (ADR-056 D5, requirement 1f) ----

  @scenario_hash:951bf3f83b7873e5
  Scenario: The JSON diagnostic names the offending file, scenario, and rule for a violation
    Given a scenario file containing exactly one schema violation
    When I run "scenarios validate --json" against the file
    Then the exit code is non-zero
    And stdout is a machine-readable JSON object carrying the file, line, scenario_title, scenario_hash, bc, and origin fields
    And that JSON object carries a violations array containing the stable rule code for the violation

  # ---- Aggregate system-consistency gate (ADR-056 D8, capability 2) ----

  @scenario_hash:6f328acceacee7e0
  Scenario: The aggregate gate fails when any scenario in the corpus is @bc:unassigned
    Given a corpus of scenario files that are each individually schema-valid
    And at least one Feature in the corpus carries @bc:unassigned
    When I run "scenarios validate --aggregate" over the corpus
    Then the exit code is non-zero
    And a diagnostic surfaces the W_BC_UNASSIGNED marker naming the offending feature

  @scenario_hash:14b16ef27d542d81
  Scenario: The aggregate gate fails when any scenario in the corpus is @origin:unresolved
    Given a corpus of scenario files that are each individually schema-valid
    And at least one Feature in the corpus carries @origin:unresolved
    When I run "scenarios validate --aggregate" over the corpus
    Then the exit code is non-zero
    And a diagnostic surfaces the W_ORIGIN_UNRESOLVED marker naming the offending feature

  @scenario_hash:1a2078ddfc50a33f
  Scenario: The aggregate gate fails when any file in the corpus is non-conformant
    Given a corpus in which exactly one file violates the per-file schema
    When I run "scenarios validate --aggregate" over the corpus
    Then the exit code is non-zero
    And the diagnostic names the non-conformant file and the per-file rule code it violated

  @scenario_hash:4983d39ac4a8375f
  Scenario: The aggregate gate passes only when every file is conformant and no transitional markers remain
    Given a corpus in which every file is schema-valid and no Feature carries @bc:unassigned or @origin:unresolved
    When I run "scenarios validate --aggregate" over the corpus
    Then the exit code is 0
    And no violation diagnostic is emitted

  # ---- One canonicalization: raw-stdin hash reconciled to parser block-only (ADR-056 D5/ADR-019, capability 3) ----

  @scenario_hash:910fbb7f03297276
  Scenario: The raw-stdin "scenarios hash" of a scenario equals its parser-path block-only hash
    Given a scenario whose canonical block-only hash under the parser path is H
    When I pipe to "scenarios hash" the scenario body alone and separately the same body wrapped with preceding @-tags, comment lines, and a Feature declaration
    Then both invocations emit the identical 16-hex hash H
    And H is insensitive to the surrounding tags, comment lines, and Feature line

  # ---- Conformant create/modify/consolidate helper (ADR-056 D12, capability 4) ----

  @scenario_hash:7222c8e840f7a0e0
  Scenario: The create helper emits a Feature-headed file that passes "scenarios validate"
    Given one or more scenario bodies together with a target @bc owner and a target @origin
    When I run the scenarios create helper to emit a grouped file
    Then the emitted file declares exactly one Feature carrying the given @bc and @origin
    And every scenario in the emitted file carries exactly one @scenario_hash equal to its parser-path block-only hash
    And running "scenarios validate" against the emitted file exits 0

  @scenario_hash:58765299713ed201
  Scenario: Consolidating bare per-scenario files into one Feature file preserves every @scenario_hash
    Given two bare single-scenario files, each with a known parser-path block-only hash
    When I run the scenarios consolidate helper to merge them into one Feature-headed file with inherited @bc and @origin
    Then the resulting file groups both scenarios under exactly one Feature
    And each scenario's @scenario_hash in the consolidated file equals that scenario's hash before consolidation
