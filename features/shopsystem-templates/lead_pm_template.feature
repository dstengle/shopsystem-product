@bc_internal
Feature: lead-pm template — main-session PM mode behavior (PDR-033 / P02)

  # PDR-033 adopts Option C: the PM is a main-session mode, not a subagent,
  # because interactivity is a position in the execution topology and only the
  # main session holds it. The lead-pm mode owns the why (intent -> candidate),
  # problem-space stewardship, prioritization, current-state stewardship, and
  # product narrative; the lead-po owns the commitment. These scenarios pin the
  # load-bearing behaviors of the lead-pm template against the public
  # template-access surface. Each pins one behavior. Grounded in
  # pdr/033-pm-as-main-session-mode.md and the P02 lead-pm template.

  @scenario_hash:90090bb7f38b9777 @bc:shopsystem-templates
  Scenario: lead-pm template names its identity as the main-session PM mode and the only interactive role
    When I read the lead-pm template via "shop-templates show lead-pm"
    Then the content names the lead-pm as the Product Manager mode of the main session — the stakeholder's front door — and states it is NOT a subagent
    And the content states the lead-pm holds open, interactive dialogue with the product authority and is the only role that does
    And the content states the lead-po and lead-architect are back-office to the stakeholder while the lead-pm is the interface
    And the content grounds this on interactivity being a position in the execution topology that only the main session holds

  @scenario_hash:d132172b8d4659ed @bc:shopsystem-templates
  Scenario: lead-pm template scopes the role to discovery, shaping, and product communication, with market-facing GTM disciplines out of scope per PDR-033 amendment-c
    When I read the lead-pm template via "shop-templates show lead-pm"
    Then the content states the role scope is the discovery-and-shaping slice of product management plus product communication
    And the content names market research, personas, segmentation, positioning, pricing, and growth metrics as explicitly OUT of scope
    And the content cites PDR-033 amendment-c as the narrowing that parks those market-facing competencies while keeping product-communication competencies in scope

  @scenario_hash:38bb3a0ef6905784 @bc:shopsystem-templates
  Scenario: lead-pm template states the mode is entered on directional, exploratory, ambiguous, or multi-option input
    When I read the lead-pm template via "shop-templates show lead-pm"
    Then the content states the lead-pm mode is entered when input is directional, exploratory, ambiguous, or multi-option — anything whose outcome is direction rather than a contract or a dispatch
    And the content distinguishes this from committed contract input, which routes to the lead-po, and technical or dispatch input, which routes to the existing routes

  @scenario_hash:16709fc0931d000b @bc:shopsystem-templates
  Scenario: lead-pm template pins the close-with-artifact gate — a session closes only by a session record listing at least one produced or revised artifact
    When I read the lead-pm template via "shop-templates show lead-pm"
    Then the content states the lead-pm mode exits ONLY by closing a session record whose produced or revised list names at least one artifact
    And the content states that no session closes without an artifact
    And the content directs that a session which produced nothing durable is recorded as idle chat or a mis-routed PO/Architect task and routed accordingly, rather than closed empty

  @scenario_hash:58381551b5029cb8 @bc:shopsystem-templates
  Scenario: lead-pm template pins the unconditional session-opening rule to ground shaping in current state
    When I read the lead-pm template via "shop-templates show lead-pm"
    Then the content states that before any substantive turn the lead-pm reads the current-state doc and the completion journal
    And the content states that every problem statement the lead-pm writes must cite the current-state entry or gap it addresses, because shaping ungrounded in what exists is fantasy

  @scenario_hash:ffc4c880440d0ad0 @bc:shopsystem-templates
  Scenario: lead-pm template pins the altitude rule confining the mode to the problem space
    When I read the lead-pm template via "shop-templates show lead-pm"
    Then the content states the lead-pm works the problem space and sketches candidates at capability level, with no env var names, no schemas, and no CLI flags
    And the content states that a technical claim below that altitude is a request for Architect pre-state verification, not a fact the lead-pm writes down
    And the content states the lead-pm may request a bounded feasibility probe from the Architect before converging a shape and links its finding in the candidate's Evidence section

  @scenario_hash:96abd54a2c8dac75 @bc:shopsystem-templates
  Scenario: lead-pm template pins the vs-PO boundary and the block-and-reopen rule
    When I read the lead-pm template via "shop-templates show lead-pm"
    Then the content states the lead-pm owns the why (intent -> candidate) and the lead-po owns the commitment (brief -> scenarios), and that the lead-pm never writes scenarios or briefs
    And the content states that when the lead-po blocks a brief on a why-problem the candidate reopens with the lead-pm
    And the content states the lead-pm never lets the lead-po patch the why inside a brief and never patches boundaries inside a candidate

  @scenario_hash:a354959486530d40 @bc:shopsystem-templates
  Scenario: lead-pm template pins the vs-Architect boundary as problem space versus solution space
    When I read the lead-pm template via "shop-templates show lead-pm"
    Then the content states the lead-pm holds the problem space and the Architect holds the solution space
    And the content states the lead-pm's prioritization records order the dispatch queue while the Architect's pre-state verification gates what dispatches

  @scenario_hash:4dbfb0ae8790c776 @bc:shopsystem-templates
  Scenario: lead-pm template pins the vs-product-authority boundary — the PM drafts direction PDRs but never ratifies
    When I read the lead-pm template via "shop-templates show lead-pm"
    Then the content states the lead-pm drafts direction PDRs and facilitates the product authority's decision
    And the content states ratification belongs to the product authority and the lead-pm never ratifies

  @scenario_hash:72ae7fd0e41a01e3 @bc:shopsystem-templates
  Scenario: lead-pm template names the artifacts the mode owns — append-only records and stewarded living docs
    When I read the lead-pm template via "shop-templates show lead-pm"
    Then the content names the append-only artifacts the lead-pm owns: intent records, candidates, prioritization records, session records, and PDR drafts for converged direction decisions
    And the content names the living documents the lead-pm stewards: the problem-space map, the current-state doc, and the README and site as outward renderings
    And the content states that every capability claim in the README or site traces to a current-state entry

  @scenario_hash:657c435fa34ba18c @bc:shopsystem-templates
  Scenario: lead-pm template maps each session mode to its skill and terminal artifact
    When I read the lead-pm template via "shop-templates show lead-pm"
    Then the content maps the discovery mode to the discovery-dialogue skill terminating in an intent record
    And the content maps the shaping mode to the shaping skill terminating in a candidate driven to shaped
    And the content maps the deciding mode to the option-tradeoff skill terminating in a PDR draft or candidate fork
    And the content maps the sequencing mode to the prioritization skill terminating in a prioritization record
    And the content maps the continuous problem-space-mapping skill terminating in a problem-space map revision
    And the content maps the communicating mode to the product-narrative skill terminating in a README, site, or current-state revision
    And the content states every session declares its mode in the session record
