@bc_internal
Feature: BC primer directs re-arming the Monitor watcher and draining the inbox after a work item

  The canonical bc primer (shop-templates package data, shop type "bc")
  already ships session-START Monitor-arm discipline and between-item drain
  intent; what was UNPINNED is the POST-WORK-ITEM re-arm case — after the BC
  completes a work item it must RE-ARM its in-session Monitor watcher on its
  "shop-msg watch --bc" pipeline rather than treating completion as the end of
  its reactive posture, DRAIN its inbox immediately after re-arming, and must
  NOT park at a "how should I proceed?" prompt to its session-lead while that
  re-arm-and-drain step remains undone. This scenario pins those three
  assertions against the rendered bc primer body through the package's public
  template-access surface.

  @scenario_hash:803a735348b139f2 @bc:shopsystem-templates
  Scenario: the canonical BC CLAUDE.md primer directs the BC to re-arm its Monitor watcher and drain its inbox after completing a work item rather than parking at the "how should I proceed?" prompt
    Given the "shop-templates" package ships a canonical "CLAUDE.md" primer template for shop type "bc" through its public template-access surface
    When I ask the package for that canonical primer body for shop type "bc"
    Then a non-empty template body is returned
    And the returned body contains a contiguous block directing the BC that, after completing a work item, it re-arms its in-session Monitor watcher on its "shop-msg watch --bc" pipeline rather than treating completion as the end of its reactive posture
    And that block directs the BC to drain its inbox immediately after re-arming the watcher
    And that block states the BC must not park at, wait on, or ask its session-lead a "how should I proceed?" prompt after completing a work item while the re-arm-and-drain step remains undone
