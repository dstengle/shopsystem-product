# RETIRED-scenario provenance & narrative (relocated to file header on
# lead-import so canonical block-only hashes match the shopsystem-templates
# canonical; scenario bodies and @scenario_hash pins are byte-identical):
#   Feature: skills provenance marker (PDR-023) — the pour decides what to
#   overwrite from a per-skill ".provenance" marker, not by directory name.
#
#   This scenario pins the core decision (PDR-023 point 1): on a re-pour, a skill
#   whose ".provenance" marker declares CANONICAL is re-poured byte-for-byte from
#   package data, while a skill whose marker declares LOCAL survives untouched.
#   It also pins that a poured canonical skill carries a discoverable CANONICAL
#   marker (the discoverability gap named in the empirical pre-state).
#
#   Supersedes the by-name classification in scenario 159 (9a064e8f6ed915e3):
#   membership is now read from the marker, not from the directory name set.
#   Feature: skills provenance marker (PDR-023) — the by-name fragility fix.
#
#   Under the superseded by-name test (scenario 159 / 9a064e8f6ed915e3), a local
#   skill that shares a name with a canonical member is classified canonical and
#   CLOBBERED on the next pour. This scenario pins that an explicit LOCAL marker
#   OVERRIDES the name and protects the skill: the pour decides from the marker,
#   not the name (PDR-023 points 1 and 2). This is the silent hole the marker
#   closes.
#   Feature: skills provenance marker (PDR-023) — the EXPERIMENT lifecycle.
#
#   PDR-023 point 3 (EXPERIMENT): drop a LOCAL skill into .claude/skills/ and it
#   persists across every re-pour with no further ceremony. This is the exact
#   lifecycle of the PM discovery skills that were collaterally deleted twice
#   (v0.13.0 re-pour b573851 + 84df061 sweep). This scenario pins that such a
#   skill — LOCAL-marked and absent from canonical package data — survives.
#   Feature: skills provenance marker (PDR-023) — the MIGRATION PATH.
#
#   PDR-023 point 3 (MIGRATION): a proven LOCAL skill graduates to CANONICAL by
#   (a) adding its body to canonical templates package data and (b) flipping its
#   ".provenance" marker to CANONICAL. After the flip the pour MANAGES it like any
#   other canonical member — subsequent update re-pours it from package data. This
#   makes the PDR-014 graduation path executable at the marker level.
#   Feature: skills provenance marker (PDR-023) — canonical members ship a
#   discoverable CANONICAL marker.
#
#   The empirical pre-state (templates HEAD ece0dca, cli.py _mirror_skills L506)
#   has NO provenance marker on disk: the canonical/local distinction lives only
#   as a name set inside cli.py, invisible at the artifact surface. PDR-023 makes
#   the distinction DISCOVERABLE. A named deliverable is shipping the canonical
#   ".provenance" marker for the two canonical members, bring-up-bc and create-bc,
#   so the pour (and any agent/human) can read provenance at the skill directory.
@bc:shopsystem-templates @origin:pdr-023
Feature: skills provenance marker (PDR-023) — the pour decides what to overwrite
  from a per-skill .provenance marker, not by directory name. CANONICAL is re-poured
  from package data; LOCAL is preserved byte-for-byte, even on a name collision.

@scenario_hash:33e542727a5fc32d
Scenario: shop-templates update re-pours a CANONICAL-marked skill from package data and preserves a LOCAL-marked skill byte-for-byte
  Given an existing git repository at a target directory "/tmp/example-lead-shop" previously bootstrapped as a "lead" shop
  And the target contains a skill directory ".claude/skills/bring-up-bc/" whose ".provenance" marker declares the skill CANONICAL and whose "SKILL.md" holds an older version of the canonical "bring-up-bc" body that differs from current package data
  And the target contains a skill directory ".claude/skills/jobs-to-be-done/" whose ".provenance" marker declares the skill LOCAL and whose "SKILL.md" is not present in canonical package data
  When I invoke the "shop-templates" update entry point against the target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And after the invocation ".claude/skills/bring-up-bc/SKILL.md" equals the current canonical "bring-up-bc" lead-skill package-data contents byte-for-byte
  And after the invocation ".claude/skills/bring-up-bc/.provenance" declares the skill CANONICAL
  And after the invocation ".claude/skills/jobs-to-be-done/SKILL.md" and its ".provenance" marker are still present with their pre-invocation contents preserved byte-for-byte

@scenario_hash:c0645464d9a04a5a
Scenario: a LOCAL-marked skill whose directory name collides with a canonical member survives a re-pour byte-for-byte
  Given an existing git repository at a target directory "/tmp/example-lead-shop" previously bootstrapped as a "lead" shop
  And "bring-up-bc" is a canonical lead skill-group member shipped in package data
  And the target contains a skill directory ".claude/skills/bring-up-bc/" whose ".provenance" marker declares the skill LOCAL and whose "SKILL.md" holds operator-localized content that differs from the canonical "bring-up-bc" package-data body
  When I invoke the "shop-templates" update entry point against the target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And after the invocation ".claude/skills/bring-up-bc/SKILL.md" still holds the operator-localized content preserved byte-for-byte
  And after the invocation ".claude/skills/bring-up-bc/.provenance" still declares the skill LOCAL
  And the invocation does not overwrite the directory ".claude/skills/bring-up-bc/" from canonical package data despite its name matching a canonical member

@scenario_hash:ff8d5c94f42a5f73
Scenario: an experiment skill that is LOCAL-marked and absent from canonical package data persists byte-for-byte across a re-pour
  Given an existing git repository at a target directory "/tmp/example-lead-shop" previously bootstrapped as a "lead" shop
  And the target contains a skill directory ".claude/skills/opportunity-solution-tree/" whose ".provenance" marker declares the skill LOCAL
  And no skill named "opportunity-solution-tree" exists in canonical lead skill-group package data
  When I invoke the "shop-templates" update entry point against the target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And after the invocation ".claude/skills/opportunity-solution-tree/" and its "SKILL.md" and its ".provenance" marker are all still present with their pre-invocation contents preserved byte-for-byte
  And the invocation does not prune or modify any skill directory whose ".provenance" marker declares it LOCAL

@scenario_hash:0d4d39cedacaff0b
Scenario: a LOCAL skill graduated by adding it to package data and flipping its marker to CANONICAL is thereafter re-poured and managed by update
  Given an existing git repository at a target directory "/tmp/example-lead-shop" previously bootstrapped as a "lead" shop
  And the skill "work-splitting" has been added to the canonical lead skill-group package data with a canonical "SKILL.md" body
  And the target contains a skill directory ".claude/skills/work-splitting/" whose ".provenance" marker has been flipped to declare the skill CANONICAL and whose "SKILL.md" holds an older body that differs from the canonical package-data body
  When I invoke the "shop-templates" update entry point against the target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And after the invocation ".claude/skills/work-splitting/SKILL.md" equals the current canonical "work-splitting" lead-skill package-data contents byte-for-byte
  And after the invocation ".claude/skills/work-splitting/.provenance" declares the skill CANONICAL
  And a subsequent update invocation against the same target leaves ".claude/skills/work-splitting/" equal to canonical package data byte-for-byte

@scenario_hash:01cbebfa7539f845
Scenario Outline: bootstrap pours each canonical lead skill-group member with a discoverable ".provenance" marker declaring it CANONICAL
  Given an existing git repository at a target directory "/tmp/example-lead-shop" with no ".claude/skills/" directory
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And the target contains a file at ".claude/skills/<skill>/SKILL.md"
  And the target contains a provenance marker at ".claude/skills/<skill>/.provenance" that declares the skill CANONICAL

  Examples:
    | skill       |
    | bring-up-bc |
    | create-bc   |
