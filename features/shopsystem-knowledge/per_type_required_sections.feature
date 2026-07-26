Feature: shopsystem-knowledge — per-type required body sections (ADR-069 additive deltas)

  ADR-069 adds a required body-section set per artifact kind, on top of ADR-067's
  base schema. The body-section conformance MECHANISM — a document missing a
  required section is reported non-conforming with the section named, a document
  carrying its type's full set passes, and the set is resolved per type — is
  already pinned in body_section_conformance.feature and is not restated here. The
  intent-record, candidate and session-record required-section sets are already
  pinned in their own per-type features. This feature pins only the net-new
  required-section sets ADR-069 states for the three kinds no scenario pins yet:
  adr requires Context, Decision and Consequences (D1); brief requires Summary and
  Scope (D3); and prioritization-record requires Ranking and Rationale (D8). The
  pdr required-section set is already exercised by body_section_conformance.feature
  and is deliberately not restated here — ADR-069 D2's pdr section list is flagged
  for the architect to reconcile against that feature's existing narrative (see the
  authoring report). Behavior altitude: the structural body-heading check against
  the type's required-section set, not prose quality.

  Scenario Outline: a document of its kind missing a required body section is reported non-conforming and names the section
    Given a <kind> document whose body omits the <section> section its type's required-section set demands
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as non-conforming for a missing required section
    And the diagnosis names <section> as the missing section

    Examples:
      | kind                  | section      |
      | adr                   | Context      |
      | adr                   | Decision     |
      | adr                   | Consequences |
      | brief                 | Summary      |
      | brief                 | Scope        |
      | prioritization-record | Ranking      |
      | prioritization-record | Rationale    |

  Scenario Outline: a document carrying its kind's full net-new required-section set passes
    Given a <kind> document whose body carries <sections>
    When the knowledge context checks the document's body against its type's required-section set
    Then it reports the document as conforming on body structure
    And it names no missing required section

    Examples:
      | kind                  | sections                          |
      | adr                   | Context, Decision and Consequences |
      | brief                 | Summary and Scope                 |
      | prioritization-record | Ranking and Rationale             |
