@bc_internal
Feature: bc-emit work-done retirement-removal precondition
  Sibling to the bc-emit work-done wrapper: the emit is refused while any
  scenario hash the consumed dispatch named for retirement is still reachable
  under the as-committed features/ tree, and is satisfied once every such hash
  is absent — independently of any newly added blocks carrying fresh hashes.

  @scenario_hash:777dcc6bfe4bdd03 @bc:shopsystem-templates
  Scenario: bc-emit work-done refuses the emit when a scenario block whose @scenario_hash the consumed dispatch named for retirement is still reachable under the as-committed features/ tree, naming the work_id and the un-removed retired hash
    Given a dispatched work_id whose consumed dispatch named one or more "@scenario_hash:<hex>" values for retirement
    And at least one named-for-retirement hash is still carried by a scenario block reachable under the BC's as-committed "features/" tree, whether on the old retired block left in place or duplicated onto a newly added block
    When the BC invokes the "bc-emit work-done" wrapper for that work_id
    Then the wrapper exits non-zero and does not invoke "shop-msg respond work_done"
    And the wrapper's error names the retirement-removal precondition as the cause and names both the dispatched work_id and each un-removed named-for-retirement hash value still reachable under "features/"
    And adding a new scenario block carrying a fresh body and hash does NOT satisfy the precondition while the named-for-retirement hash remains reachable, so the stale-hash and orphan checks passing on the surviving blocks does not exempt this refusal

  @scenario_hash:800e7f9317a1b884 @bc:shopsystem-templates
  Scenario: bc-emit work-done treats the retirement-removal precondition as satisfied when every @scenario_hash the consumed dispatch named for retirement is absent from the as-committed features/ tree
    Given a dispatched work_id whose consumed dispatch named one or more "@scenario_hash:<hex>" values for retirement
    And no named-for-retirement hash is carried by any scenario block reachable under the BC's as-committed "features/" tree
    When the BC invokes the "bc-emit work-done" wrapper for that work_id
    Then the wrapper treats the retirement-removal precondition as satisfied and does NOT refuse the emit on the ground that a named-for-retirement hash is still reachable
    And the satisfaction is established by the absence of every named-for-retirement hash from "features/", independently of whether the dispatch also added new scenario blocks carrying their own fresh hashes
