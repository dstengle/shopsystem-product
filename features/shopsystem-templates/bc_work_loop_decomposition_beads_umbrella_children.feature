@bc:shopsystem-templates @origin:lead-bnbxv
Feature: BC work-loop TDD decomposition beads are true bd-children of the work_id umbrella so work-done-gate Check 4 enumerates them

  Convention (a), decided by the product authority (lead-bnbxv): the BC
  implementer's TDD decomposition beads MUST be created as true bd parent/child
  CHILDREN of the work_id umbrella bead — not as flat top-level beads carrying
  the work_id only in their title or metadata. This makes the bc-emit
  work-done-gate Check 4 "bd children <umbrella>" enumeration see them, so the
  flat-bead false-refuse (no-decomposition-found) that previously forced
  "shop-msg respond work_done --force" cannot recur. Additive to the Check 4
  enumeration/durability scenarios in
  bc_emit_work_done_plan_decomposition_durability.feature, which assume the
  sub-issues are already reachable under the umbrella; this pins the creation
  convention that establishes that reachability, and the mis-parent surfacing.

  @scenario_hash:ea2e2df83bf4c6d6
  Scenario: the BC implementer's TDD decomposition pass creates each decomposition bead as a bd child of the work_id umbrella bead
    Given a dispatched work_id whose umbrella bead the BC implementer decomposes into TDD sub-issues
    When the implementer's decomposition pass creates the TDD decomposition beads for that work_id
    Then each decomposition bead is created as a bd parent/child child of the work_id umbrella bead
    And "bd children <umbrella>" enumerates every decomposition bead the pass created
    And no decomposition bead is created as a flat top-level bead carrying the work_id only in its title or metadata

  @scenario_hash:22ce240e88353c39
  Scenario: work-done-gate Check 4 enumerates the umbrella's bd-children and passes on a green fully-closed decomposition tree without forcing --force
    Given a dispatched work_id whose TDD decomposition beads were created as bd children of the work_id umbrella bead
    And every such child decomposition bead is closed on a green tree
    When the BC invokes the "bc-emit work-done" wrapper for that work_id
    Then Check 4 enumerates the decomposition beads via "bd children <umbrella>" and finds every enumerated child closed
    And Check 4 passes and the emit proceeds without requiring "shop-msg respond work_done --force"

  @scenario_hash:1c8df3ca5d6967c2
  Scenario: work-done-gate Check 4 surfaces a decomposition bead that is NOT parented under the work_id umbrella instead of false-refusing as no-decomposition-found
    Given a dispatched work_id one of whose intended TDD decomposition beads was created as a flat top-level bead carrying the work_id only in its title or metadata, so it is not a bd child of the work_id umbrella bead
    When the BC invokes the "bc-emit work-done" wrapper for that work_id
    Then Check 4's "bd children <umbrella>" enumeration surfaces the mis-parented decomposition bead and the wrapper REFUSES the emit — exits non-zero and does not invoke "shop-msg respond work_done" — naming that bead's bd id and the not-a-bd-child-of-the-umbrella mis-parent as the cause, and directs the operator to re-parent that bead under the work_id umbrella and re-emit
    And this refusal is a true named-cause refuse over the mis-parented bead, NOT a name-and-pass and NOT the uninformative no-decomposition-found false-refuse that previously forced "shop-msg respond work_done --force"; the gate neither silently treats the umbrella as having no decomposition nor passes the emit while a decomposition bead remains mis-parented
