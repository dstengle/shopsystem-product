@bc:shopsystem-knowledge @origin:cand-005
Feature: shopsystem-knowledge — intent-record status enum reflects real single-state practice, not the unused draft/active/fulfilled/abandoned lifecycle

  The currently generated intent-record status enum is draft, active, fulfilled or
  abandoned — a four-value lifecycle that zero of the seven independently-authored
  intent-record instances (intent-001 through intent-007, 2026-07-09 through
  2026-07-16) has ever used. Every one of the seven instead carries status: recorded,
  a value absent from the generated enum, with no exception across any of them (cand-005
  Phase 1 feasibility finding, 2026-07-16). This is not drift toward one value among
  several live ones — it is total, unanimous non-use of the generated enum's entire
  vocabulary. The workflow explains why: an intent record is authored complete, in a
  single PM-mode discovery session, from a closed session record — it is never
  persisted mid-draft, then separately "activated," then later marked "fulfilled" or
  "abandoned" on disk. Its eventual disposition (superseded by a later intent, folded
  into another) is tracked by the typedef's own superseded-by link field, not by a
  status transition. Grounded in that unanimous evidence, this feature pins the full
  corrected enum as exactly one value, "recorded" — replacing the four-value fiction
  entirely rather than adding "recorded" as a fifth option alongside values no real
  instance has ever needed. Should real practice ever need a second status value, that
  will be new evidence to pin then, not something to guess into the enum now. Traces
  to intent-007 (the precondition-chain intent) and cand-005 Phase 1 (the committed,
  full-chain candidate that funds this fix).

  @scenario_hash:80695d5c7a12fa63
  Scenario: "recorded" is a valid intent-record status value, matching every real instance
    Given an intent-record artifact whose frontmatter carries a status value of "recorded"
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as conforming
    And it does not report an unrecognized-status diagnosis

  @scenario_hash:74c0d72d8fe0a44a
  Scenario: the intent-record status enum is exactly the single real-practice value "recorded"
    Given the intent-record typedef, whose currently generated status enum is draft, active, fulfilled or abandoned — a set no real intent-record instance has ever used
    And 7 independently-authored intent-record instances (intent-001 through intent-007), each carrying status "recorded" and none carrying draft, active, fulfilled or abandoned
    When the knowledge context runs the format generator over the intent-record typedef
    Then the generated schema fragment's status enum for intent-record contains exactly one value, "recorded"
    And none of "draft", "active", "fulfilled" or "abandoned" is a member of the generated status enum

  @scenario_hash:b0f51c6fb7900093
  Scenario: an intent-record artifact carrying a status value outside the real enum is reported non-conforming and names the offending value
    Given an intent-record artifact whose frontmatter carries a status value of "draft"
    And "draft" is not a member of the intent-record status enum recorded
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming for an unrecognized status
    And the diagnosis names the offending value "draft"
