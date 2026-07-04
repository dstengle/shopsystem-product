@bc:shopsystem-templates @origin:adr-043
Feature: the bootstrap-rendered beads remote is single-sourced (ADR-043 D4/D5)
  The product beads remote bootstrap configures as the bd dolt push remote bakes no
  hardcoded org and uses the canonical <product>-lead-beads repository name.

@scenario_hash:cb8fca2c0eb2b920
Scenario: the bootstrap-rendered beads remote does not bake a hardcoded GitHub org
  Given a lead repository forked as "acme-lead" with no GitHub org assumed by the renderer
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "acme-lead", and a target directory
  And bootstrap renders the product beads remote it configures as the bd dolt push remote
  Then the rendered beads remote URL contains no hardcoded "dstengle" org segment
  And the org segment of the rendered beads remote is either an origin-derived placeholder the footing runtime fills or omitted for the footing runtime to supply

@scenario_hash:104df5a6bae51b30
Scenario: the bootstrap-rendered beads remote uses the canonical product-lead-beads repository name
  Given a lead repository forked as "acme-lead" whose derived product slug is "acme"
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "acme-lead", and a target directory
  And bootstrap renders the product beads remote it configures as the bd dolt push remote
  Then the repository name in the rendered beads remote URL is "acme-lead-beads"
  And the rendered beads remote URL does not name the repository "acme-product-beads" or any other non-"-lead-beads" form
