@bc:shopsystem-templates @origin:brief-003
Feature: canonical claude_settings templates conform to Claude Code hook-schema wrapper shape

  # ---------------------------------------------------------------------
  # brief-003 realization revision (lead-pn9 / parent lead-o00):
  # scenario 70 (hash f2a7de49d80332c1) assumed every shop-type's
  # variant declares at least one "SessionStart" entry. After the
  # revision, the bc variant ships with no SessionStart entries at
  # all; scenario 70's antecedent no longer holds. The
  # schema-conformance intent is restated below conditionally: IF a
  # variant declares SessionStart entries at all, they must conform
  # to Claude Code's matcher+hooks wrapper schema; the bc variant's
  # empty case is vacuously satisfied. Scenario 70 was retired in
  # this round.
  # ---------------------------------------------------------------------

  @scenario_hash:508d38a0bf9f5510
  Scenario Outline: the canonical ".claude/settings.json" template for each shop type parses as a JSON object whose top-level "hooks" key maps to a JSON object; and IF the "hooks" object declares a "SessionStart" array with one or more entries, every such entry conforms to Claude Code's matcher+hooks wrapper schema (every entry is an object with a string "matcher" key and a "hooks" array whose every element is an object with string "type" and string "command" keys), so the file is accepted at session start instead of rejected with a schema-validation error
    When I ask the "shop-templates" package for the canonical ".claude/settings.json" template for shop type "<shop_type>" through its public template-access surface
    And the returned body is parsed as JSON
    Then the parsed value at top-level key "hooks" is a JSON object
    And if the "hooks" object has a "SessionStart" key, then the value at "hooks.SessionStart" is a JSON array
    And every element of "hooks.SessionStart" (if any) is a JSON object with a "matcher" key whose value is a string
    And every element of "hooks.SessionStart" (if any) is a JSON object with a "hooks" key whose value is a JSON array of length at least 1
    And every element of every inner "hooks" array under "hooks.SessionStart" (if any) is a JSON object with a "type" key whose value is a string
    And every element of every inner "hooks" array under "hooks.SessionStart" (if any) is a JSON object with a "command" key whose value is a string

    Examples:
      | shop_type |
      | bc        |
      | lead      |
