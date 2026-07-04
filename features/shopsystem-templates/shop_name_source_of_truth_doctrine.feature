@bc:shopsystem-templates @origin:adr-018
Feature: shop name source-of-truth doctrine: name.md carries canonical slug; display form lives in primer.md

  @scenario_hash:4e99a6abbc57b884
  Scenario: shop-templates bootstrap requires the "--shop-name" value to be the canonical slug form (lowercase letters, digits, and hyphens only; no whitespace) — the slug written into ".claude/shop/name.md" is the single source of truth for shop identity, and a display-form variant has no place in name.md
  Given an existing git repository at a target directory "/tmp/example-bootstrap-target" with no ".claude/shop/" subdirectory
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem product" (with a literal space), and target directory "/tmp/example-bootstrap-target"
  Then the exit code is non-zero
  And stderr contains a diagnostic naming that "--shop-name" must be a canonical slug (lowercase letters, digits, and hyphens only) and that the input "shopsystem product" contains a disallowed character (whitespace)
  And the target directory does not contain a file at ".claude/shop/name.md"
  And the target directory does not contain a top-level "CLAUDE.md"
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "/tmp/example-bootstrap-target"
  Then the exit code is 0
  And the byte contents of ".claude/shop/name.md" in the target directory are exactly the literal string "shopsystem-product" with a single trailing newline and no other content

  @scenario_hash:aa174b4e6622a71b
  Scenario: name.md carries only the canonical slug; any human-readable display form of the shop name lives in the shop-owned ".claude/shop/primer.md", not in name.md
  Given an existing git repository at a target directory "/tmp/example-display-form-target" with no ".claude/shop/" subdirectory
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "/tmp/example-display-form-target"
  Then the exit code is 0
  And the byte contents of ".claude/shop/name.md" in the target directory are exactly the literal string "shopsystem-product" with a single trailing newline and no other content
  And the file at ".claude/shop/name.md" contains no whitespace character other than the single trailing newline
  And the bootstrap-written ".claude/shop/primer.md" in the target directory is a shop-owned placeholder whose body may contain prose using either the slug or a display variant; that file is not canonical-managed and its content is the shop's to evolve
  And no other bootstrap-written file under the target directory contains a display variant of the shop name (i.e. the literal string "shopsystem product" with a space) introduced by the templates package

  @scenario_hash:12029f0af5e054f3
  Scenario: shop-templates update reports an advisory (without modifying ".claude/shop/name.md") when the on-disk name.md content does not match the canonical slug shape — surfacing legacy display-form name.md drift to the operator without violating the shop-owned-file rule
  Given an existing git repository at a target directory "/tmp/example-update-target" that was previously bootstrapped as a "lead" shop
  And the file at ".claude/shop/name.md" in the target directory has been edited so that its byte contents are exactly the literal string "shopsystem product" with a single trailing newline (a display form containing a literal space, not a canonical slug)
  And I record the byte contents of the file at ".claude/shop/name.md" in the target directory before the invocation
  When I invoke the "shop-templates" update entry point against the target directory "/tmp/example-update-target"
  Then the exit code is 0
  And after the invocation the file at ".claude/shop/name.md" in the target directory has byte-for-byte the same on-disk contents as before the invocation
  And stderr contains an advisory naming the file ".claude/shop/name.md", the on-disk value "shopsystem product", the suggested canonical slug "shopsystem-product", and the instruction to edit name.md to the slug form
  And the advisory explicitly notes that "shop-templates update" did not modify the shop-owned file
