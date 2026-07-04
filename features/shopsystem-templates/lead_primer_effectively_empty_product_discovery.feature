@bc:shopsystem-templates @origin:lead-vglj
Feature: Lead primer drives effectively-empty detection and proactive product discovery

  The canonical lead primer (shop-templates package data, shop type "lead",
  served through read_claude_md_primer("lead")) must teach the router how to
  recognise a brand-new shop that has no product defined yet, and what to do
  about it: proactively open a product-discovery conversation with the product
  authority rather than declaring idle, re-firing the nudge idempotently each
  session until the product surface is non-empty, and running that discovery
  as a brainstorming opener that branches into one router-selected structured
  discovery skill. Each scenario pins one contiguous block of that guidance
  against the rendered lead primer body through the package's public
  template-access surface.

  @scenario_hash:00bdd6985ab94756
  Scenario: the canonical lead primer defines the effectively-empty / no-product-defined detection signal as a two-signal test requiring no product-bearing bead AND no product-bearing features/ scenario
    Given the "shop-templates" package ships a canonical "CLAUDE.md" primer template for shop type "lead" through its public template-access surface
    When I ask the package for that canonical primer body for shop type "lead"
    Then a non-empty template body is returned
    And the returned body contains a contiguous block defining an effectively-empty / no-product-defined repo state as a two-signal test requiring BOTH signals to hold
    And that block names the first signal as the beads registry carrying no product-bearing bead and the second signal as the "features/" tree carrying no product-bearing scenario
    And that block states the bootstrap scaffold — the canonical-managed files, "CLAUDE.md", the typed ".claude/" files, the role templates, the placeholder shop primer, and the initialized-but-empty beads registry — is ignored by the test and does not by itself defeat either signal

  @scenario_hash:32b4fd22cfcf55d2
  Scenario: the canonical lead primer directs the router, on the effectively-empty state at session start or the idle-detection checkpoint, to proactively open a product-discovery conversation rather than declare idle
    Given the "shop-templates" package ships a canonical "CLAUDE.md" primer template for shop type "lead" through its public template-access surface
    When I ask the package for that canonical primer body for shop type "lead"
    Then a non-empty template body is returned
    And the returned body contains a contiguous block directing the router, on detecting the effectively-empty / no-product-defined state at session start or during the idle-detection checklist, to proactively open a product-discovery conversation with the product authority rather than declaring idle
    And that block states the discovery conversation is conducted at the main-agent / router level — consistent with the product-authority discovery gate — and is not delegated to a non-interactive discovery subagent

  @scenario_hash:bdba904f4f64f4a2
  Scenario: the canonical lead primer directs the router to re-fire the product-discovery prompt on each session while the effectively-empty state holds, and to suppress it only once the product surface is non-empty
    Given the "shop-templates" package ships a canonical "CLAUDE.md" primer template for shop type "lead" through its public template-access surface
    When I ask the package for that canonical primer body for shop type "lead"
    Then a non-empty template body is returned
    And the returned body contains a contiguous block directing the router to re-fire the product-discovery prompt on each session while the effectively-empty / no-product-defined state still holds
    And that block states the nudge is idempotent so that a previously dismissed prompt is re-issued the next session rather than fired only once
    And that block states the router suppresses the prompt only once the product surface becomes non-empty — that is, once either signal of the two-signal detection test no longer holds

  @scenario_hash:46afaafc507e7d6f
  Scenario: the canonical lead primer directs the router to open product discovery as a general brainstorming conversation first, then branch into one router-selected structured discovery skill based on what surfaces
    Given the "shop-templates" package ships a canonical "CLAUDE.md" primer template for shop type "lead" through its public template-access surface
    When I ask the package for that canonical primer body for shop type "lead"
    Then a non-empty template body is returned
    And the returned body contains a contiguous block directing the router to open the product-discovery conversation as a general brainstorming conversation first, before committing to any single structured discovery skill
    And that block directs the router to then branch into one structured discovery skill — selected from jobs-to-be-done, problem-framing-canvas, opportunity-solution-tree, or customer-journey-map — based on what surfaces in the brainstorming conversation
    And that block states the router performs that skill selection itself, at the router / main-agent level, as the triage step that follows the brainstorming opener
