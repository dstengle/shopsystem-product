@bc:shopsystem-knowledge @origin:cand-005
Feature: shopsystem-knowledge — candidate typedef's status enum is reconciled to include committed, the ratification value every committed candidate uses

  The candidate typedef's currently generated status enum is exploring, shaped,
  briefed, parked or rejected. cand-005 — the committed, full-chain candidate that
  itself funds this fix — carries status: committed, a value absent from that enum,
  so cand-005's own frontmatter fails validation today (cand-005 Phase 1 feasibility
  finding, 2026-07-16). Real practice shows exactly two status values ever used
  across five independently-authored candidates (cand-001 through cand-005): shaped
  (cand-001 through cand-004, while a candidate is drafted and awaiting ratification)
  and committed (cand-005, once the product authority ratifies it). No real candidate
  has ever used exploring, briefed, parked or rejected as its literal status value —
  notably, cand-004 is narratively "parked" pending cand-005's earlier phases, but its
  status field still reads shaped; the parking is instead captured by the typedef's
  separate parked-until frontmatter field. This feature is deliberately additive and
  narrow: it pins the one demonstrated defect (committed is missing, and blocks a real
  document today) without removing exploring, briefed, parked or rejected from the
  enum — no real document is broken by their presence, and stripping unused-but-
  plausible future lifecycle values would redesign lifecycle semantics beyond what
  any observed defect requires, which cand-005's own No-gos rules out ("Phase 1
  reconciles, it does not redesign"). The parked-vs-parked-until inconsistency is
  named here for a future PM/Architect decision, not resolved by this feature. Traces
  to intent-007 (the precondition-chain intent) and cand-005 Phase 1 (the committed,
  full-chain candidate that funds this fix).

  @scenario_hash:ec33b8afc2f6bb2c
  Scenario: the candidate typedef's generated status enum includes committed, the value cand-005 uses
    Given the candidate typedef, whose currently generated status enum is exploring, shaped, briefed, parked or rejected — a set that omits committed, the value cand-005's ratification uses
    And 5 independently-authored candidate instances, four (cand-001 through cand-004) carrying status shaped and one (cand-005) carrying status committed once the product authority ratified it
    When the knowledge context runs the format generator over the candidate typedef
    Then the generated schema fragment's status enum for candidate is exploring, shaped, briefed, committed, parked and rejected
    And committed is a member of the generated status enum

  @scenario_hash:6a24c1f3209bc924
  Scenario: a candidate artifact carrying status committed passes frontmatter conformance
    Given a candidate artifact whose frontmatter carries a status value of "committed"
    When the knowledge context validates the artifact's frontmatter against the schema
    Then it reports the artifact as conforming
    And it does not report an unrecognized-status diagnosis
