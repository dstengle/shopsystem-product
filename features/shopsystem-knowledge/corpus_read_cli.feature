@bc:shopsystem-knowledge @origin:adr-068
Feature: shopsystem-knowledge — read-only corpus-access CLI over the frontmatter graph (navigate, render, query)

  ADR-068 is the read-side mechanism for the corpus: one strictly read-only
  CLI surface over the artifact frontmatter graph, carrying three verbs —
  navigate, render, and query — added to the already-installed
  "shop-knowledge" CLI whose only verbs today are template, schema, and
  validate (ADR-068 finding 1). Every invocation loads the corpus once
  through the knowledge BC's existing load_corpus loader (never a second
  graph reader), traverses ADR-067's materialized bidirectional edge pairs
  (supersedes/superseded-by, derives-from/derived-by,
  references/referenced-by, already built), and reuses the projections
  section-parsing substrate for rendering.

  navigate takes a document id and returns that document's edge-neighbourhood
  — the edges incident on it plus each neighbour's id/type/status/title —
  answered from frontmatter, with a direction filter (forward, back, or
  both). render takes a document id and a view selector on the status axis:
  the current-system view emits only the accepted content sections and DROPS
  the changelog and superseded/supersede-chain transformation material, while
  the transformation view emits the full document including the changelog and
  supersede-chain material. query selects documents by frontmatter facet
  (type, status, tag, distribution) or by edge participation, returning either
  a compact id/title/status list or the matching documents rendered under the
  same view filter. All three verbs are read-only — they never mutate an
  artifact or an edge — and all support md/json/yaml output through one shared
  serializer.

  The single most correctness-sensitive property, pinned by the negative
  scenario below, is that the current-system render DROPS changelog and
  transformation material rather than merely hiding a status value: leaking
  transformation material into the current-system view defeats the
  self-containment requirement (PDR-035) the whole slice exists to serve.

  Behavior altitude: the CLI's observable input/output contract over the
  loaded corpus, not the loader's, edge-resolver's, or projection module's
  internal implementation, which is pinned elsewhere in this directory.

  @scenario_hash:6197383392195e90
  Scenario: navigate returns the edge-neighbourhood of a document from its materialized frontmatter edges
    Given a corpus whose document "adr-068" carries materialized edges to several neighbours across the three edge pairs
    When I run the navigate verb on document id "adr-068"
    Then the output lists each edge incident on "adr-068" as a link-field, target id, and resolved flag
    And each listed neighbour carries its id, type, status, and title
    And the neighbourhood is answered from "adr-068"'s own frontmatter without scanning the corpus for inbound edges

  @scenario_hash:8cb7314c14694005
  Scenario Outline: navigate's direction filter selects which half of the edge pairs the neighbourhood returns
    Given a corpus whose document "adr-068" carries both forward edges and materialized back-edges
    When I run the navigate verb on document id "adr-068" with a direction filter of "<direction>"
    Then the neighbourhood includes the "<included>" edges
    And the neighbourhood excludes the "<excluded>" edges

    Examples:
      | direction | included         | excluded         |
      | forward   | forward          | back             |
      | back      | back             | forward          |
      | both      | forward and back |                  |

  @scenario_hash:cb9dab0549acdf38
  Scenario: navigate surfaces an unresolved or legacy-target edge faithfully rather than hiding it
    Given a corpus whose document "adr-068" carries an edge to a target whose resolution is false or whose target is a legacy artifact
    When I run the navigate verb on document id "adr-068"
    Then the neighbourhood includes that edge with its resolved flag reported as false
    And the CLI does not silently drop the unresolved edge from the neighbourhood

  @scenario_hash:74bdefca5008a645
  Scenario: navigate on an unknown document id fails and names the offending id
    Given a corpus that contains no document with id "adr-999"
    When I run the navigate verb on document id "adr-999"
    Then the exit code is non-zero
    And stderr names "adr-999" as a document id not present in the corpus

  @scenario_hash:3150738158b1dc32
  Scenario Outline: navigate emits its neighbourhood in the selected output format
    Given a corpus whose document "adr-068" carries materialized edges to several neighbours
    When I run the navigate verb on document id "adr-068" requesting "<format>" output
    Then the exit code is 0
    And the neighbourhood is emitted as a well-formed "<format>" document carrying the incident edges and neighbour facets

    Examples:
      | format |
      | md     |
      | json   |
      | yaml   |

  @scenario_hash:4cd6d3d6dc4fcd33
  Scenario: render current-system view emits only the accepted content sections of a document
    Given a corpus whose document "adr-068" has status "accepted" and carries content sections plus a changelog section
    When I run the render verb on document id "adr-068" in the current-system view
    Then the exit code is 0
    And the rendered output contains the document's accepted content sections

  @scenario_hash:3f752398f17674a4
  Scenario: render current-system view DROPS the changelog and supersede-chain transformation material and does not leak it
    Given a corpus whose document "adr-068" has status "accepted", carries a changelog section naming a superseded predecessor, and carries supersede-chain transformation material
    When I run the render verb on document id "adr-068" in the current-system view
    Then the rendered output does not contain the changelog section
    And the rendered output does not contain the named superseded predecessor reference
    And the rendered output does not contain the supersede-chain transformation material

  @scenario_hash:335eb88e9c9fb357
  Scenario: render transformation view emits the full document including changelog and supersede-chain material
    Given a corpus whose document "adr-068" has status "accepted", carries a changelog section, and carries supersede-chain transformation material
    When I run the render verb on document id "adr-068" in the transformation view
    Then the exit code is 0
    And the rendered output contains the document's content sections
    And the rendered output contains the changelog section
    And the rendered output contains the supersede-chain transformation material

  @scenario_hash:7583e99ef2647bd4
  Scenario: render current-system view has no rendering for a document whose status is not accepted
    Given a corpus whose document "adr-034" has status "superseded"
    When I run the render verb on document id "adr-034" in the current-system view
    Then the CLI reports that "adr-034" has no current-system rendering because it is not in the accepted set
    And no accepted content is emitted for "adr-034"

  @scenario_hash:d98873c76ac4b175
  Scenario Outline: render emits either document markdown or a structured envelope carrying the rendered body and frontmatter facets
    Given a corpus whose document "adr-068" has status "accepted"
    When I run the render verb on document id "adr-068" in the current-system view requesting "<format>" output
    Then the exit code is 0
    And the output is "<shape>"

    Examples:
      | format | shape                                                              |
      | md     | the rendered document markdown body                                |
      | json   | a json envelope wrapping the rendered body plus the frontmatter facets |
      | yaml   | a yaml envelope wrapping the rendered body plus the frontmatter facets |

  @scenario_hash:7706494f82e8ee1c
  Scenario Outline: query selects documents by a single frontmatter facet and returns a compact list
    Given a corpus containing documents that vary by type, status, tag, and distribution
    When I run the query verb selecting documents whose "<facet>" equals "<value>" requesting a compact list
    Then the exit code is 0
    And every returned record carries the matched document's id, title, and status
    And every returned document has "<facet>" equal to "<value>"

    Examples:
      | facet        | value         |
      | type         | adr           |
      | status       | accepted      |
      | tag          | restructuring |
      | distribution | product-wide  |

  @scenario_hash:d8899babf8bbc0aa
  Scenario Outline: query selects documents by edge participation
    Given a corpus in which some documents participate in the materialized "<edge>" relationship and some do not
    When I run the query verb selecting documents that participate in the "<edge>" edge
    Then the exit code is 0
    And every returned document carries a non-empty "<edge>" frontmatter edge
    And no returned document lacks the "<edge>" edge

    Examples:
      | edge          |
      | superseded-by |
      | references    |
      | referenced-by |

  @scenario_hash:876d46bdef2f8311
  Scenario: query with rendered output emits matching documents under the same current-system view filter as render
    Given a corpus containing accepted documents that carry changelog sections and match a query facet
    When I run the query verb selecting those documents requesting rendered output in the current-system view
    Then the exit code is 0
    And each matching document is rendered with its accepted content sections
    And no rendered match contains its changelog section or supersede-chain transformation material

  @scenario_hash:a374f3f98e20bb25
  Scenario: query whose facet matches no document returns an empty result rather than an error
    Given a corpus that contains no document whose tag equals "nonexistent-tag"
    When I run the query verb selecting documents whose tag equals "nonexistent-tag"
    Then the exit code is 0
    And the result is an empty list
    And the CLI does not report the empty match as an error

  @scenario_hash:02e612708e0de104
  Scenario Outline: every read verb leaves the corpus artifacts and edges unchanged
    Given a corpus whose artifact files and materialized frontmatter edges are recorded before the run
    When I run the "<verb>" verb over that corpus
    Then the exit code is 0
    And every artifact file on disk is byte-for-byte unchanged after the run
    And no materialized frontmatter edge has been added, removed, or altered

    Examples:
      | verb     |
      | navigate |
      | render   |
      | query    |
