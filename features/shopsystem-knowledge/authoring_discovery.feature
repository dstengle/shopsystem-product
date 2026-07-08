Feature: shopsystem-knowledge — authoring-time discovery via adversarial analysis (architecture-decision kind)

  The primary, everyday capability. When a new decision is being authored, the
  knowledge context retrieves the relevant existing neighbours via the L0/L1
  index and runs an adversarial pass that tries to break the draft against each
  neighbour, answering the three questions — covered, contradicts, supersedes —
  with a citation to the neighbour. The pass is prose/judgment-based over the
  relevant neighbours; it requires no pre-encoded invariants and no registered
  baselines. It catches the parity-vs-delta contradiction case by reading the
  neighbour's decision text, not by matching a predicate.

  @scenario_hash:60f070ecddc891e5
  Scenario: the authoring event triggers discovery and surfaces the relevant neighbours via the L0/L1 index
    Given a corpus of existing decisions with generated L0 cards and L1 extracts
    And a draft decision being authored on a topic that overlaps a subset of those decisions
    When the knowledge context runs the authoring-time discovery pass over the draft
    Then it surfaces the subset of existing decisions relevant to the draft, named by id
    And it selects those neighbours from the L0/L1 index rather than loading the whole corpus into the pass

  @scenario_hash:bea7c4aa89633418
  Scenario: the discovery pass answers covered, contradicts and supersedes for each surfaced neighbour with a citation
    Given a draft decision being authored and a set of surfaced neighbours from the L0/L1 index
    When the knowledge context runs the adversarial pass over the draft against those neighbours
    Then for each surfaced neighbour it returns a verdict on whether the draft is covered by, contradicts, or supersedes that neighbour
    And each verdict cites the neighbour it is about by id

  @scenario_hash:3092efb62e739d3a
  Scenario: a draft already decided elsewhere is flagged covered with a citation to the covering decision
    Given an existing accepted decision that already decides a question
    And a draft decision being authored that decides the same question the same way
    When the knowledge context runs the authoring-time discovery pass over the draft
    Then it flags the draft as covered by the existing decision
    And it cites the covering decision by id

  @scenario_hash:f77904953e96124e
  Scenario: a parity claim contradicted by a neighbour's governed change is caught with no pre-encoded invariant
    Given an existing decision whose decision text changes a governed interface
    And a draft decision being authored that claims parity or an unchanged interface over that same surface
    And the corpus carries no registered invariants and no registered baselines
    When the knowledge context runs the adversarial pass over the draft against that neighbour
    Then it flags the draft as contradicting the neighbour on the basis of the neighbour's decision text
    And it cites the contradicted neighbour by id
    And it produces this verdict without requiring any pre-encoded invariant or baseline to be registered

  @scenario_hash:4f85b0b3af16073e
  Scenario: a draft that replaces a prior decision is flagged supersedes and names the supersede edge to write
    Given an existing accepted decision on a question
    And a draft decision being authored that replaces that prior decision
    When the knowledge context runs the authoring-time discovery pass over the draft
    Then it flags the draft as superseding the prior decision
    And it names the typed supersede edge the draft owes to the prior decision by id
