@bc:shopsystem-templates @origin:lead-2mha
Feature: bootstrap configures the real bd dolt push remote and issue prefix

  Bootstrap initializes .beads/ via a `bd init` subprocess. On top of that it
  configures the new shop's bd tracker the way bd actually reads it: the bd
  dolt push remote is a DB-side remote added via `bd dolt remote add <name>
  <url>` (listed by `bd dolt remote list`), and the issue prefix is set via
  `bd init --prefix <prefix>` and read via the hyphenated config key
  `bd config get issue-prefix`. (Supersedes the cosmetic
  sync.remote/issue_prefix YAML keys of the retired scenario
  9e15d8cfd55b9541 — bd does not read those keys.) So a freshly bootstrapped
  shop's tracker syncs to the right remote and stamps issues with the right
  prefix without a manual follow-up step. (tmpl-am6 / PDR-019 U5 / ADR-040.)

  @scenario_hash:0636fba2c1445f9f
  Scenario: shop-templates bootstrap configures the bd dolt push remote and issue prefix
    Given an existing git repository at a target directory "<target>"
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "<shop_name>", and target directory "<target>"
    Then the exit code is 0
    And "bd dolt remote list" in the target directory lists a dolt push remote whose URL is the product beads remote
    And "bd config get issue-prefix" in the target directory returns the product-derived prefix
