Feature: shopsystem-knowledge — L1 distribution boundary (typed artifacts)

  The knowledge context distributes only the L1 decision digest to BCs; L2 full
  documents stay lead-only. The pour is gated: the L1 digest crosses to BCs only
  when the distribution-mode coherence check passes. When the distribution check
  surfaces a blocking-severity finding the pour is refused and no digest is
  delivered, so an incoherent digest is never poured to conforming BCs. This
  feature pins the boundary itself — what crosses (L0/L1) and what does not (L2)
  and that a blocking finding stops the pour; the advisory/blocking semantics of
  the check are pinned in the coherence-gate mode-split feature. L0/L1/L2 are
  projection tiers the tool emits, never frontmatter fields (the tier-collision
  lesson).

  @scenario_hash:218fa351bb1d48b5
  Scenario: a coherent corpus pours its L1 digest to BCs
    Given an artifact corpus whose distribution-mode coherence check passes with no blocking finding
    When the knowledge context runs the L1 distribution
    Then it delivers the L1 decision digest to the BC channel

  @scenario_hash:353190f53fe739d2
  Scenario: a blocking-severity finding refuses the pour
    Given an artifact corpus whose distribution-mode coherence check surfaces a blocking-severity finding
    When the knowledge context runs the L1 distribution
    Then it refuses to pour the L1 decision digest and delivers no digest to any BC
    And it reports the blocking finding that refused the pour

  @scenario_hash:88f923b94cdebd0d
  Scenario: L2 full documents never cross the distribution boundary
    Given an artifact corpus and a BC that consumes distributed knowledge
    When the knowledge context runs the L1 distribution
    Then only L0 and L1 projections cross to the BC channel
    And no L2 full document is delivered to any BC
