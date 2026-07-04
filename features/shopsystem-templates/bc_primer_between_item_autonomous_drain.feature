@bc_internal
Feature: BC primer pins BETWEEN-ITEM autonomous inbox drain

  The canonical bc primer (shop-templates package data, shop type "bc")
  already ships session-drain intent and session-START discipline; what was
  UNPINNED is the BETWEEN-ITEM case — after the BC completes one work item it
  must begin the next ready inbox item WITHOUT pausing to ask its session-lead
  which item to take first. These scenarios pin three between-item assertions
  against the rendered bc primer body through the package's public
  template-access surface, the BC-side analogue of the lead primer's three
  standing rules (end-of-turn continuation, idle-detection, choice-suppression).

  @scenario_hash:b73e3176eeddd58f @bc:shopsystem-templates
  Scenario: the canonical BC primer directs the BC to drain the next pending inbox item after a work_done emit without checking in with its session-lead
    Given the "shop-templates" package ships a canonical "CLAUDE.md" primer template for shop type "bc" through its public template-access surface
    When I ask the package for that canonical primer body for shop type "bc"
    Then a non-empty template body is returned
    And the returned body contains a contiguous block that names completing a work item as the trigger to begin the next ready inbox item rather than a stopping point
    And that block directs the BC to drain the next pending inbox item immediately after a work_done emit
    And that block states the BC does not check in with, ask, or wait on its session-lead before starting that next item

  @scenario_hash:4aa9c618e80c9db0 @bc:shopsystem-templates
  Scenario: the canonical BC primer permits the BC to idle only when shop-msg pending inbox is empty and no in-flight implementer/reviewer task remains
    Given the "shop-templates" package ships a canonical "CLAUDE.md" primer template for shop type "bc" through its public template-access surface
    When I ask the package for that canonical primer body for shop type "bc"
    Then a non-empty template body is returned
    And the returned body contains the literal substring "shop-msg pending inbox" as the named operation the BC runs to check for unprocessed inbox work
    And the returned body contains a contiguous block stating the BC idles only when that pending-inbox check is empty AND no implementer or reviewer task is in flight
    And that block frames idle as a posture earned after the emptiness check rather than a default the BC falls back to after finishing an item

  @scenario_hash:16ad870377ac7514 @bc:shopsystem-templates
  Scenario: the canonical BC primer directs the BC to pick the next inbox item by arrival order or ADR-013 dependency precedence and act, without surfacing the which-item-first choice to its session-lead
    Given the "shop-templates" package ships a canonical "CLAUDE.md" primer template for shop type "bc" through its public template-access surface
    And the BC's inbox holds more than one pending item
    When I ask the package for that canonical primer body for shop type "bc"
    Then a non-empty template body is returned
    And the returned body contains a contiguous block directing the BC to select which pending inbox item to process next by arrival order or by ADR-013 dependency precedence
    And that block states the BC does not surface the which-item-first procedural choice to its session-lead and instead picks by the named default and acts
