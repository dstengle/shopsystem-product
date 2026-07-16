@bc:shopsystem-knowledge @origin:cand-005
Feature: shopsystem-knowledge — session-record id pattern and body-section structure reflect real practice

  session-record ships with zero governing scenarios for its id shape or its body
  structure (cand-005 Phase 1 feasibility finding, 2026-07-16). The currently
  generated typedef uses a sequential id pattern, session-NNN (e.g. session-001), and
  a two-section template of "Summary" and "Outcomes" — neither of which any real
  instance has ever used. Five independently-authored session-record instances
  (sess-2026-07-09-a, sess-2026-07-14-a, sess-2026-07-14-b, sess-2026-07-15-a,
  sess-2026-07-16-a) instead consistently use a chronological, human-readable id
  pattern, sess-YYYY-MM-DD-x (a date plus a same-day disambiguating letter suffix, so
  a second session opened the same calendar day becomes sess-YYYY-MM-DD-b rather than
  colliding), and a two-section body of "Outcome" and "Open threads". This feature
  pins both real-practice facts: the corrected id pattern, and the corrected
  body-section set. Behavior altitude: the typedef declaration, the generated
  template and id-pattern shape, and the conformance checks — not the PM-session
  discipline of what prose goes in each section. Traces to intent-007 (the
  precondition-chain intent) and cand-005 Phase 1 (the committed, full-chain
  candidate that funds this fix).

  @scenario_hash:ff935d77ed96b4ae
  Scenario: the session-record id pattern matches real practice's chronological, human-readable shape
    Given the session-record typedef, whose currently generated id pattern is session-\d{3,} (e.g. "session-001"), a shape no real instance has ever used
    And 5 independently-authored session-record instances (sess-2026-07-09-a through sess-2026-07-16-a), each using the chronological id pattern sess-YYYY-MM-DD-x
    When the knowledge context runs the format generator over the session-record typedef
    Then the generated session-record id pattern matches a date plus a same-day disambiguating letter suffix, of the shape sess-YYYY-MM-DD-x
    And a real id such as "sess-2026-07-16-a" matches the generated pattern
    And "session-001" no longer matches the generated pattern

  @scenario_hash:588f3f52e2bdf3d4
  Scenario: the session-record typedef requires an Outcome section and an Open threads section, not Summary and Outcomes
    Given the session-record typedef, whose currently generated template declares "Summary" and "Outcomes" as its two body sections, headings no real instance has ever used
    And 5 independently-authored session-record instances that instead consistently carry "Outcome" and "Open threads" as their two body sections
    When the knowledge context runs the format generator over the session-record typedef
    Then the generated session-record template declares Outcome and Open threads as its required body sections
    And it does not declare Summary or Outcomes as required body sections

  @scenario_hash:e65c1fd4c1159391
  Scenario: a session-record document missing the Open threads section is reported non-conforming and names it
    Given a session-record document whose body carries Outcome but omits the Open threads section its type's required-section set now demands
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as non-conforming for a missing required section
    And the diagnosis names Open threads as the missing section

  @scenario_hash:2ac5541d6c0ad3f6
  Scenario: a session-record document carrying Outcome and Open threads passes conformance
    Given a session-record document whose body carries Outcome and Open threads, its type's full required-section set
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as conforming on body structure
    And it names no missing required section

  @scenario_hash:06597f5e411a4bd9
  Scenario: a session-record id in the old session-NNN shape is reported non-conforming against the corrected pattern
    Given a session-record artifact whose id is "session-001" rather than the sess-YYYY-MM-DD-x pattern its type requires
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as non-conforming for an id that does not match its type pattern
    And the diagnosis names the offending id and the expected pattern
