@bc:shopsystem-messaging @origin:brief-006
Feature: Implicit CWD-based shop resolution for shop-msg

  @scenario_hash:bad131a5760ad021
  Scenario: bare "shop-msg prime" resolves a BC shop's identity by walking up from CWD reading .claude/shop/name.md and type.md
  Given a BC shop directory tree containing ".claude/shop/name.md" with literal content "shopsystem-docs" and ".claude/shop/type.md" with literal content "bc"
  And "shopsystem-docs" is registered in the messaging registry as a BC
  And my current working directory is the BC shop directory (or any descendant of it that contains no nearer ".claude/shop/" directory)
  When I run "shop-msg prime" with no addressing flags
  Then the command exits zero
  And the command resolves the invoking shop's identity to canonical name "shopsystem-docs" and shop type "bc"
  And the output is the same orientation output that an explicit "shop-msg prime --bc shopsystem-docs" invocation from outside the shop directory would produce

  @scenario_hash:c8f18b7f8396eea4
  Scenario: bare "shop-msg prime" resolves a lead shop's identity by walking up from CWD reading .claude/shop/name.md and type.md
  Given a lead shop directory tree containing ".claude/shop/name.md" with literal content "shopsystem-product" and ".claude/shop/type.md" with literal content "lead"
  And "shopsystem-product" is registered in the messaging registry as a lead
  And my current working directory is the lead shop directory (or any descendant of it that contains no nearer ".claude/shop/" directory)
  When I run "shop-msg prime" with no addressing flags
  Then the command exits zero
  And the command resolves the invoking shop's identity to canonical name "shopsystem-product" and shop type "lead"
  And the output is the same orientation output that an explicit "shop-msg prime --lead shopsystem-product" invocation from outside the shop directory would produce

  @scenario_hash:6f2c4d22f92ae282
  Scenario: CWD walk-up resolves the nearest .claude/shop/ ancestor when multiple shop directories are nested
  Given a lead shop at "/tmp/example-lead" containing ".claude/shop/name.md" "shopsystem-product" and ".claude/shop/type.md" "lead"
  And a BC shop at "/tmp/example-lead/repos/shopsystem-docs" containing ".claude/shop/name.md" "shopsystem-docs" and ".claude/shop/type.md" "bc"
  And both "shopsystem-product" and "shopsystem-docs" are registered in the messaging registry
  And my current working directory is "/tmp/example-lead/repos/shopsystem-docs" or any descendant of it
  When I run "shop-msg prime" with no addressing flags
  Then the command exits zero
  And the command resolves the invoking shop's identity to canonical name "shopsystem-docs" and shop type "bc"
  And the command does NOT resolve the invoking shop's identity to "shopsystem-product"

  @scenario_hash:e8003198468448cf
  Scenario: bare "shop-msg prime" exits non-zero with a clear diagnostic when CWD has no .claude/shop/ ancestor up to the filesystem root
  Given my current working directory has no ancestor (up to the filesystem root) containing a ".claude/shop/" directory with both "name.md" and "type.md"
  When I run "shop-msg prime" with no addressing flags
  Then the command exits non-zero
  And stderr contains a diagnostic naming that no shop was found by walking up from the current directory
  And stderr names both remediations available to the caller: cd into a shop directory, OR pass an explicit "--bc <name>" or "--lead <name>" flag

  @scenario_hash:bae50ac8b89ef4be
  Scenario: bare "shop-msg prime" exits non-zero when the walk-up finds a .claude/shop/ directory containing only one of name.md or type.md
  Given a directory tree containing ".claude/shop/name.md" but no ".claude/shop/type.md"
  And my current working directory is that directory or a descendant
  When I run "shop-msg prime" with no addressing flags
  Then the command exits non-zero
  And stderr contains a diagnostic naming that the shop marker at the resolved ".claude/shop/" directory is incomplete (missing "type.md")
  And the command does NOT silently treat the partial marker as either shop type

  @scenario_hash:9cd19c8974eeefeb
  Scenario: an explicit "--bc <name>" or "--lead <name>" flag takes precedence over the CWD-implicit lookup
  Given a BC shop directory tree containing ".claude/shop/name.md" with literal content "shopsystem-docs" and ".claude/shop/type.md" with literal content "bc"
  And both "shopsystem-docs" and "shopsystem-messaging" are registered in the messaging registry
  And my current working directory is the "shopsystem-docs" shop directory
  When I run "shop-msg prime --bc shopsystem-messaging"
  Then the command exits zero
  And the command resolves the invoking shop's identity to canonical name "shopsystem-messaging"
  And the command does NOT resolve the invoking shop's identity to "shopsystem-docs"
  And the CWD walk-up does not run (an absent or unreadable ".claude/shop/" directory at and above CWD does not affect this invocation)

  @scenario_hash:e55fbdf82ccc8fa9
  Scenario Outline: bare invocations of "shop-msg pending", "shop-msg read", "shop-msg respond", and "shop-msg watch" resolve the invoking shop from CWD using the same walk-up mechanism as "shop-msg prime"
  Given a "<shop_type>" shop directory tree containing ".claude/shop/name.md" with literal content "<shop_name>" and ".claude/shop/type.md" with literal content "<shop_type>"
  And "<shop_name>" is registered in the messaging registry as a "<shop_type>"
  And my current working directory is the shop directory or a descendant
  When I run "<bare_command>" with no addressing flags
  Then the command resolves the invoking shop's identity to canonical name "<shop_name>" and shop type "<shop_type>"
  And the command behaves identically to "<explicit_command>" invoked from outside the shop directory

  Examples:
    | shop_type | shop_name             | bare_command                                       | explicit_command                                                                          |
    | bc        | shopsystem-docs       | shop-msg pending inbox                             | shop-msg pending inbox --bc shopsystem-docs                                               |
    | bc        | shopsystem-docs       | shop-msg read inbox --work-id lead-100             | shop-msg read inbox --bc shopsystem-docs --work-id lead-100                               |
    | bc        | shopsystem-docs       | shop-msg watch                                     | shop-msg watch --bc shopsystem-docs                                                       |
    | lead      | shopsystem-product    | shop-msg pending inbox                             | shop-msg pending inbox --lead shopsystem-product                                          |
    | lead      | shopsystem-product    | shop-msg read inbox --work-id lead-100             | shop-msg read inbox --lead shopsystem-product --work-id lead-100                          |
    | lead      | shopsystem-product    | shop-msg watch                                     | shop-msg watch --lead shopsystem-product                                                  |

  @scenario_hash:9e2dee7fa6cce3b9
  Scenario: on "shop-msg send", the CWD-implicit lookup resolves the SENDER's identity only; the recipient remains explicitly named via "--bc <name>" or "--lead <name>"
  Given a lead shop directory tree containing ".claude/shop/name.md" with literal content "shopsystem-product" and ".claude/shop/type.md" with literal content "lead"
  And both "shopsystem-product" and "shopsystem-docs" are registered in the messaging registry
  And my current working directory is the "shopsystem-product" lead shop directory
  When I run "shop-msg send assign_scenarios --bc shopsystem-docs" with a valid payload and work-id "lead-200" and no flag naming the sender
  Then the command exits zero
  And the sent message's "from" identity is canonical name "shopsystem-product" (resolved implicitly from CWD)
  And the sent message's "to" identity is canonical name "shopsystem-docs" (named explicitly)
  And the recipient address is NEVER resolved from CWD; running "shop-msg send assign_scenarios" with no "--bc" or "--lead" recipient flag exits non-zero with a diagnostic naming the missing recipient flag
