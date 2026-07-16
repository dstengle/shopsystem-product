@bc:shopsystem-knowledge @origin:cand-005
Feature: shopsystem-knowledge — candidate typedef declares its real narrative body structure beyond Verbatim anchors

  candidate_verbatim_anchors_section.feature (brief-018) already pins that the
  candidate typedef declares a Verbatim anchors section, structurally equivalent to
  intent-record's. This feature is additive to that one: it pins the rest of the
  candidate typedef's real body structure, which today's generated template does not
  declare at all (it declares only two placeholder sections, "Context" and "Open
  questions", matching no real instance). Five independently-authored candidate
  instances (cand-001 through cand-005, spanning 2026-07-09 through 2026-07-16) —
  including cand-005, which produced this very fix — converge without exception on
  the same eight narrative sections in the same order, following Verbatim anchors:
  Problem, Appetite, Solution sketch, Rabbit holes, No-gos, Evidence / experiments,
  Resolution, Changelog (cand-005 Phase 1 feasibility finding, 2026-07-16). This
  feature pins that real, repeatedly-independently-converged-on structure as the
  candidate typedef's remaining required body sections. Behavior altitude: the
  typedef declaration, the generated template's section shape and order, and the
  conformance check — not the PM-session discipline of which prose goes in each
  section. Does not touch or restate candidate_verbatim_anchors_section.feature's own
  three pinned scenarios. Traces to intent-007 (the precondition-chain intent) and
  cand-005 Phase 1 (the committed, full-chain candidate that funds this fix).

  @scenario_hash:55093832fe7b6018
  Scenario Outline: the candidate typedef requires each of the real-practice narrative body sections beyond Verbatim anchors
    Given the candidate typedef, whose generated template today declares only "Context" and "Open questions", sections no real instance has ever used
    And 5 independently-authored candidate instances (cand-001 through cand-005) that instead consistently carry "<section>" as a body section
    When the knowledge context runs the format generator over the candidate typedef
    Then the generated candidate template declares "<section>" as a required body section

    Examples:
      | section                 |
      | Problem                 |
      | Appetite                |
      | Solution sketch         |
      | Rabbit holes            |
      | No-gos                  |
      | Evidence / experiments  |
      | Resolution               |
      | Changelog               |

  @scenario_hash:9d1e859d505c3417
  Scenario: the candidate typedef's narrative sections follow real practice's order, immediately after Verbatim anchors
    Given the candidate typedef's real-practice section order: Verbatim anchors, Problem, Appetite, Solution sketch, Rabbit holes, No-gos, Evidence / experiments, Resolution, Changelog
    When the knowledge context runs the format generator over the candidate typedef
    Then the generated candidate template positions Problem immediately after Verbatim anchors
    And the remaining sections appear in the order Appetite, Solution sketch, Rabbit holes, No-gos, Evidence / experiments, Resolution, Changelog

  @scenario_hash:a07781fd6a8be6fa
  Scenario: a candidate document missing the Resolution section is reported non-conforming and names it
    Given a candidate document whose body carries Verbatim anchors, Problem, Appetite, Solution sketch, Rabbit holes, No-gos and Evidence / experiments but omits Resolution
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as non-conforming for a missing required section
    And the diagnosis names Resolution as the missing section

  @scenario_hash:cd1c9fca88308b79
  Scenario: a candidate document carrying its full 9-section required set passes
    Given a candidate document whose body carries Verbatim anchors, Problem, Appetite, Solution sketch, Rabbit holes, No-gos, Evidence / experiments, Resolution and Changelog
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as conforming on body structure
    And it names no missing required section
