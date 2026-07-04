@bc_internal
Feature: Inter-shop messaging encapsulation: templates use shop-msg CLI exclusively and do not require bd as a precondition for messaging

  @scenario_hash:877f081905c08af8 @bc:shopsystem-templates
  Scenario: bc-implementer template directs the implementer to shop-msg CLI subcommands for inbox discovery and reading, never to direct filesystem inspection
    When I read the bc-implementer template via "shop-templates show bc-implementer"
    Then the content contains the literal substring "shop-msg pending inbox"
    And the content contains the literal substring "shop-msg read inbox"
    And the content does not contain the literal substring "ls inbox"
    And the content does not contain the literal substring "ls outbox"
    And the content does not contain the literal substring "grep message_type"
    And the content does not contain the literal substring "<BC root>/inbox/"
    And the content does not contain the literal substring "<BC root>/outbox/"
    And the content does not instruct the reader to "read the file directly" or "read the YAML directly" with respect to the inbox or outbox

  @scenario_hash:eab2808bbaed0061 @bc:shopsystem-templates
  Scenario: bc-reviewer template directs the reviewer to shop-msg CLI subcommands for reading the assigned scenarios, never to direct filesystem inspection of the inbox
    When I read the bc-reviewer template via "shop-templates show bc-reviewer"
    Then the content contains the literal substring "shop-msg read inbox"
    And the content does not contain the literal substring "ls inbox"
    And the content does not contain the literal substring "ls outbox"
    And the content does not contain the literal substring "<BC root>/inbox/"
    And the content does not contain the literal substring "<BC root>/outbox/"
    And the content does not instruct the reader to read the inbox YAML file directly or by any non-shop-msg means

  # @scenario_hash:f279d66b8313e3fc RETIRED (lead-eqn)
  # Asserted lead-po template contains literal substring "shop-msg read outbox".
  # Superseded by lead-eqn: Brief 006 replaced read outbox with read inbox --lead;
  # lead-po CLI mechanics now uses "shop-msg read inbox --lead <name> --work-id <work_id>".

  @scenario_hash:89e1b683839c9179 @bc:shopsystem-templates
  Scenario: lead-po template directs the PO to read an inbound clarify via the shop-msg CLI using lead inbox, never by reading mailbox YAML directly
    When I read the lead-po template via "shop-templates show lead-po"
    Then the content contains the literal substring "shop-msg read inbox"
    And the content does not contain the literal substring "shop-msg read outbox"
    And the content does not contain the literal substring "read the file directly"
    And the content does not contain the literal substring "ls inbox"
    And the content does not contain the literal substring "ls outbox"
    And the content does not instruct the PO to open, cat, or otherwise inspect any path under "inbox/" or "outbox/" by any non-shop-msg means

  @scenario_hash:6f0511d2197b1536 @bc:shopsystem-templates
  Scenario: lead-architect template directs the architect to shop-msg CLI subcommands for inspecting BC outboxes and verifying dispatch, never to filename-convention reasoning or direct filesystem inspection
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then the content contains the literal substring "shop-msg pending outbox"
    And the content contains the literal substring "shop-msg read"
    And the content does not contain the literal substring "Inbox filename convention"
    And the content does not contain the literal substring "<work_id>.yaml"
    And the content does not contain the literal substring "<work_id>-"
    And the content does not contain the literal substring "ls inbox"
    And the content does not contain the literal substring "ls outbox"
    And the content does not instruct the architect to open, cat, or otherwise inspect any path under a BC's "inbox/" or "outbox/" directory by any non-shop-msg means

  @scenario_hash:7cd64a2508f3a829 @bc:shopsystem-templates
  Scenario: shopsystem-templates BC CLAUDE.md instructs the router to discover and read unprocessed inbox work via shop-msg CLI subcommands, not via direct filesystem inspection or filename conventions
    Given the file at "repos/shopsystem-templates/CLAUDE.md" exists and is the canonical CLAUDE.md for the shopsystem-templates BC shop
    When I read that file
    Then the file contains the literal substring "shop-msg pending inbox" as the named operation for identifying unprocessed work
    And the file contains the literal substring "shop-msg read inbox" as the named operation for reading a specific inbox message
    And the file does not contain the literal substring "ls inbox"
    And the file does not contain the literal substring "ls outbox"
    And the file does not contain any sentence asserting that "a message is unprocessed when there is no outbox file" or any other set-difference-on-filenames characterization of unprocessed state
    And the file does not contain the literal substring "<work_id>.yaml"
    And the file does not contain the literal substring "<work_id>-<response_type>.yaml"
    And the file does not instruct the router to open, cat, ls, or otherwise inspect any path under "inbox/" or "outbox/" by any non-shop-msg means

  @scenario_hash:3feba3b4b24d3270 @bc:shopsystem-templates
  Scenario: lead-shop CLAUDE.md describes dispatch and BC-mailbox inspection exclusively through shop-msg CLI subcommands, never through direct mailbox paths or filename conventions
    Given the file at "CLAUDE.md" exists at the lead shop's repository root and describes the lead shop's router behavior and feature-request handling
    When I read that file
    Then every step or sentence that describes dispatching work to a BC names "shop-msg send" as the dispatch operation
    And every step or sentence that describes inspecting a BC's outbox state names a "shop-msg" subcommand (for example "shop-msg pending outbox" or "shop-msg read outbox") as the inspection operation
    And the file does not contain the literal substring "ls inbox"
    And the file does not contain the literal substring "ls outbox"
    And the file does not contain the literal substring "<work_id>.yaml"
    And the file does not contain the literal substring "<work_id>-<response_type>.yaml"
    And the file does not instruct the router to open, cat, ls, or otherwise inspect any path under "repos/<bc>/inbox/" or "repos/<bc>/outbox/" by any non-shop-msg means

  @scenario_hash:b2d1036514610f30 @bc:shopsystem-templates
  Scenario: bc-implementer template's mechanism-observation guidance does not make a beads issue a precondition for emitting the wire message, and names the renamed provenance-ref flag rather than the removed bd-ref flag
    When I read the bc-implementer template via "shop-templates show bc-implementer"
    Then the "Surfacing mechanism observations" section does not contain the literal substring "bd create"
    And the section does not contain the literal substring "--bd-ref"
    And the section does not contain language of the form "Create a beads issue" or "create a beads issue" or "create a bd issue" as a numbered or otherwise-ordered step that precedes the shop-msg respond mechanism_observation step
    And every shop-msg respond mechanism_observation invocation example in the section is composable without referring to any flag whose name contains the substring "bd"
    And if the section mentions a provenance pointer at all it names it via the optional flag "--provenance-ref"
    And the section contains an explicit statement that emitting the mechanism_observation does not require the BC to use bd or to create a bd issue

  @scenario_hash:885cbc86cf3e18d6 @bc:shopsystem-templates
  Scenario Outline: no canonical role template makes creating or updating a bd issue a precondition for invoking a shop-msg subcommand
    When I read the <template> template via "shop-templates show <template>"
    Then the content does not contain any sentence, list item, or numbered step that instructs the reader to create, claim, or update a bd issue as a precondition for invoking any "shop-msg send" or "shop-msg respond" subcommand
    And every "shop-msg send" invocation example in the content is composable without the reader first running a "bd" subcommand
    And every "shop-msg respond" invocation example in the content is composable without the reader first running a "bd" subcommand
    And the content does not contain the literal substring "--bd-ref"

    Examples:
      | template         |
      | bc-implementer   |
      | bc-reviewer      |
      | lead-po          |
      | lead-architect   |

  @scenario_hash:3858bb1500434c2f @bc:shopsystem-templates
  Scenario Outline: no shop's CLAUDE.md instructs creating or updating a bd issue as a precondition for invoking a shop-msg subcommand
    Given the file at <path> exists and is the canonical CLAUDE.md for the named shop
    When I read that file
    Then the file does not contain any sentence, list item, or numbered step that instructs the reader to create, claim, or update a bd issue as a precondition for invoking any "shop-msg send" or "shop-msg respond" subcommand
    And every "shop-msg send" invocation example in the file is composable without the reader first running a "bd" subcommand
    And every "shop-msg respond" invocation example in the file is composable without the reader first running a "bd" subcommand
    And the file does not contain the literal substring "--bd-ref"

    Examples:
      | path                                                         | shop                  |
      | CLAUDE.md                                                    | lead shop             |
      | repos/shopsystem-templates/CLAUDE.md                         | shopsystem-templates  |
