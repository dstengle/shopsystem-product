Feature: shopsystem-knowledge — typedef drift-check gate (generated artifacts)

  Each artifact type is single-sourced in a typedef; the generator emits that type's
  authoring template and schema fragment from the typedef, and those generated files
  are read-only downstream products — the typedef is the sole source of truth. A
  check mode regenerates from the typedef and compares against the committed
  generated set: a set that still matches the typedef passes and exits zero; a
  generated file that has been hand-edited so it no longer matches what the typedef
  would emit is caught as drift and the check exits non-zero, naming the drifted
  output. Generation is a pure function of the typedef, so regenerating over an
  unchanged typedef reproduces the generated set byte-for-byte. This feature pins the
  read-only-generated-files discipline and the deterministic drift gate at behavior
  altitude; the generator's internal emission logic is not pinned here.

  @scenario_hash:ad20e320470be043
  Scenario: a generated set that matches its typedef passes the drift check
    Given a typedef together with a template and schema fragment that were emitted from that typedef and are unchanged
    When the knowledge context runs the drift check over the typedef and its generated set
    Then it reports no drift
    And the check exits zero

  @scenario_hash:a5c1fe90339df4ed
  Scenario: a hand-edited generated file is caught as drift and fails the check
    Given a typedef whose generated template or schema fragment has been hand-edited so it no longer matches what the typedef would emit
    When the knowledge context runs the drift check over the typedef and its generated set
    Then it reports drift naming the generated file that no longer matches the typedef
    And the check exits non-zero

  @scenario_hash:f8e379db80066582
  Scenario: regenerating over an unchanged typedef reproduces the generated set byte-for-byte
    Given a typedef whose template and schema fragment have already been generated
    When the knowledge context regenerates the template and schema fragment from the unchanged typedef
    Then the regenerated files are byte-for-byte identical to the committed generated set
    And the regeneration writes zero changed bytes
