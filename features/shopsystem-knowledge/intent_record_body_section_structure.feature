@bc:shopsystem-knowledge @origin:cand-005
Feature: shopsystem-knowledge — intent-record typedef declares its real 8-section body structure

  intent-record ships with zero governing scenarios for its body structure (cand-005
  Phase 1 feasibility finding, 2026-07-16): the currently generated template declares
  only two placeholder sections, "Intent" and "Signals of success", that no real
  instance has ever used. Seven independently-authored intent-record instances
  (intent-001 through intent-007, spanning 2026-07-09 through 2026-07-16, each
  authored in a separate PM-mode discovery session) converge without exception on the
  same eight sections in the same order: Verbatim anchors, The goal behind the ask,
  Who it serves, Constraints, Non-goals, Appetite signal, Failure conditions, Open
  threads. This feature pins that real, repeatedly-independently-converged-on
  structure as the intent-record typedef's required body-section set, positioned the
  same way candidate's Verbatim anchors section is positioned (immediately after the
  title, before the first narrative section) per the established
  candidate_verbatim_anchors_section.feature pattern. Behavior altitude: the typedef
  declaration, the generated template's section shape and order, and the conformance
  check — not the PM-session discipline of which prose goes in each section, which is
  authoring behavior outside the knowledge BC's shape-and-integrity domain. Traces to
  intent-007 (the precondition-chain intent) and cand-005 Phase 1 (the committed,
  full-chain candidate that funds this fix).

  @scenario_hash:896573b341f5b713
  Scenario Outline: the intent-record typedef requires each of the 8 real-practice body sections
    Given the intent-record typedef, whose generated template today declares only "Intent" and "Signals of success", sections no real instance has ever used
    And 7 independently-authored intent-record instances (intent-001 through intent-007) that instead consistently carry "<section>" as a body section
    When the knowledge context runs the format generator over the intent-record typedef
    Then the generated intent-record template declares "<section>" as a required body section

    Examples:
      | section                  |
      | Verbatim anchors         |
      | The goal behind the ask  |
      | Who it serves            |
      | Constraints               |
      | Non-goals                |
      | Appetite signal          |
      | Failure conditions       |
      | Open threads             |

  @scenario_hash:e44127dc5d9b6214
  Scenario: the intent-record typedef positions Verbatim anchors first, immediately after the title
    Given the intent-record typedef's real-practice section order: Verbatim anchors, The goal behind the ask, Who it serves, Constraints, Non-goals, Appetite signal, Failure conditions, Open threads
    When the knowledge context runs the format generator over the intent-record typedef
    Then the generated intent-record template positions Verbatim anchors immediately after the title and before The goal behind the ask
    And the remaining sections appear in the order Who it serves, Constraints, Non-goals, Appetite signal, Failure conditions, Open threads

  @scenario_hash:4749e223aa6191fe
  Scenario: an intent-record document missing a required section is reported non-conforming and names it
    Given an intent-record document whose body carries every section in its type's required-section set except Failure conditions
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as non-conforming for a missing required section
    And the diagnosis names Failure conditions as the missing section

  @scenario_hash:53855e6890abe8f6
  Scenario: an intent-record document carrying its type's full 8-section required set passes
    Given an intent-record document whose body carries Verbatim anchors, The goal behind the ask, Who it serves, Constraints, Non-goals, Appetite signal, Failure conditions and Open threads
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as conforming on body structure
    And it names no missing required section
