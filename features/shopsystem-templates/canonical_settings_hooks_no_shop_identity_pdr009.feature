@bc:shopsystem-templates @origin:pdr-009
Feature: Canonical .claude/settings.json hooks must not embed shop identity (PDR-009)

  # ---------------------------------------------------------------------
  # lead-33r / PDR-009 (decided 2026-05-27): shop identity is never
  # embedded in canonical content; "shop-msg" resolves the invoking
  # shop's identity from CWD by walking up looking for
  # ".claude/shop/name.md" and ".claude/shop/type.md". This eliminates
  # any architectural reason for a canonical hook command to embed shop
  # identity via placeholder substitution. The scenarios below pin the
  # tightening at the canonical level (no "{{...}}" substrings, bare
  # "shop-msg prime", "bd prime" retained alongside) and at the
  # consumer level (post-init / post-update poured file is also
  # placeholder-free, and a stale placeholder-bearing hook command is
  # replaced on update).
  #
  # @scenario_hash:71797e9017c95fed RETIRED (lead-33r, superseded by
  # @scenario_hash:9317b34e56712c7c and @scenario_hash:d3cc63377ac86cce).
  # Asserted "bd prime" was the SOLE inner-hook command under
  # SessionStart for the lead canonical. Under PDR-009, "shop-msg prime"
  # is a second short-lived, cleanly-terminating SessionStart hook that
  # belongs alongside "bd prime"; the "sole" qualifier is retired.
  # ---------------------------------------------------------------------

  @scenario_hash:d8ee45f9f7c3b27c
  Scenario Outline: every inner-hook "command" string in the canonical ".claude/settings.json" template for "<shop_type>" contains no occurrence of the substring "{{" and no occurrence of the substring "}}"
    When I ask the "shop-templates" package for the canonical ".claude/settings.json" template for shop type "<shop_type>" through its public template-access surface
    And the returned body is parsed as JSON
    Then for every top-level hook-event key under "hooks", and for every element of that hook-event's array, and for every entry of that element's inner "hooks" array, the entry's "command" string contains no occurrence of the substring "{{" and no occurrence of the substring "}}"

    Examples:
      | shop_type |
      | bc        |
      | lead      |

  @scenario_hash:98c31cc7077a7be2
  Scenario Outline: exactly one inner-hook "command" entry under "hooks.SessionStart" in the canonical ".claude/settings.json" for "<shop_type>" equals the literal string "shop-msg prime"
    When I ask the "shop-templates" package for the canonical ".claude/settings.json" template for shop type "<shop_type>" through its public template-access surface
    And the returned body is parsed as JSON
    Then the parsed value at "hooks.SessionStart" is a JSON array of length at least 1
    And exactly one inner-hook entry under "hooks.SessionStart" has a "command" string equal to the literal value "shop-msg prime"
    And no inner-hook entry under "hooks.SessionStart" has a "command" string that starts with "shop-msg prime " followed by additional characters
    And no inner-hook entry under "hooks.SessionStart" has a "command" string containing the substring "--bc"
    And no inner-hook entry under "hooks.SessionStart" has a "command" string containing the substring "--lead"
    And no inner-hook entry under "hooks.SessionStart" has a "command" string containing the substring "--bc-root"
    And no inner-hook entry under "hooks.SessionStart" has a "command" string containing the substring "--lead-root"

    Examples:
      | shop_type |
      | bc        |
      | lead      |

  @scenario_hash:b287bd566e621a1c
  Scenario Outline: the canonical ".claude/settings.json" for "<shop_type>" has exactly one inner-hook "command" entry equal to "bd prime" AND exactly one inner-hook "command" entry equal to "shop-msg prime" under "hooks.SessionStart"
    When I ask the "shop-templates" package for the canonical ".claude/settings.json" template for shop type "<shop_type>" through its public template-access surface
    And the returned body is parsed as JSON
    Then exactly one inner-hook entry under "hooks.SessionStart" has a "command" string equal to the literal value "bd prime"
    And exactly one inner-hook entry under "hooks.SessionStart" has a "command" string equal to the literal value "shop-msg prime"
    And those two inner-hook entries are distinct entries

    Examples:
      | shop_type |
      | bc        |
      | lead      |

  @scenario_hash:955d26b13b8f8a8d
  Scenario Outline: after "shop-templates init" or "shop-templates update" pours ".claude/settings.json" into a target shop of type "<shop_type>", the poured file contains no occurrence of the substring "{{" and no occurrence of the substring "}}"
    Given an existing git repository at a target directory "<target>"
    When I invoke the "shop-templates" "<entry_point>" against target "<target>" with shop type "<shop_type>" and shop name "<shop_name>"
    Then the exit code is 0
    And the file at "<target>/.claude/settings.json" exists
    And the contents of "<target>/.claude/settings.json" contain no occurrence of the substring "{{"
    And the contents of "<target>/.claude/settings.json" contain no occurrence of the substring "}}"

    Examples:
      | entry_point | shop_type | shop_name              | target                     |
      | init        | bc        | shopsystem-docs        | /tmp/example-bc-shop       |
      | init        | lead      | shopsystem-product     | /tmp/example-lead-shop     |
      | update      | bc        | shopsystem-docs        | /tmp/example-bc-shop       |
      | update      | lead      | shopsystem-product     | /tmp/example-lead-shop     |

  @scenario_hash:03dc4a5a14f89100
  Scenario Outline: "shop-templates update" against a target shop whose ".claude/settings.json" carries a stale placeholder-bearing hook command replaces that command with the current canonical bare "shop-msg prime"
    Given an existing git repository at a target directory "<target>" that was previously bootstrapped as a "<shop_type>" shop named "<shop_name>"
    And the file at "<target>/.claude/settings.json" contains an inner-hook entry under "hooks.SessionStart" whose "command" string is the stale literal "shop-msg prime --bc {{SHOP_NAME}}"
    When I invoke the "shop-templates" update entry point against target "<target>"
    Then the exit code is 0
    And after the invocation no inner-hook entry under "hooks.SessionStart" in "<target>/.claude/settings.json" has a "command" string containing the substring "{{SHOP_NAME}}"
    And after the invocation exactly one inner-hook entry under "hooks.SessionStart" in "<target>/.claude/settings.json" has a "command" string equal to the literal value "shop-msg prime"
    And after the invocation "<target>/.claude/settings.json" equals the current canonical ".claude/settings.json" template for shop type "<shop_type>" byte-for-byte

    Examples:
      | shop_type | shop_name              | target                       |
      | bc        | shopsystem-docs        | /tmp/example-bc-shop         |
      | lead      | shopsystem-product     | /tmp/example-lead-shop       |
