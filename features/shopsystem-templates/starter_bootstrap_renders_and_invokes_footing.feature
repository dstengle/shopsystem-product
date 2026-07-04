@bc:shopsystem-templates @origin:lead-y4pg
Feature: the starter bin/bootstrap obtains bin/footing by rendering it before invoking it (lead-y4pg)

  The shopsystem-starter forkable repo ships bin/bootstrap but NOT bin/footing
  (the framework — including the footing orchestration — lives only in the
  published image). The adopter's bin/bootstrap must therefore OBTAIN bin/footing
  by rendering it from the templates/ops/footing template (via `shop-templates
  bootstrap` in-container) BEFORE it invokes it, must DELEGATE to the rendered
  footing for the actual footing sequence, and must REFUSE to invoke a footing
  that was never produced rather than blow up with an exit-127 against a missing
  file. (PDR-019 U1/U3, ADR-040.)

  @scenario_hash:b05fff82d0d10f4a
  Scenario: bootstrap renders bin/footing from templates/ops/footing before invoking it
    Given an adopter fork created from the starter that carries "bin/bootstrap" but no "bin/footing"
    When the adopter runs "bin/bootstrap"
    Then bootstrap runs "shop-templates bootstrap" in-container, which renders "bin/footing" from the "templates/ops/footing" template into the fork
    And the rendered "bin/footing" exists and is executable before bootstrap invokes it

  @scenario_hash:3646efa06051fcac
  Scenario: bootstrap delegates to the rendered bin/footing which runs the footing sequence to green
    Given an adopter fork in which bootstrap has already rendered "bin/footing"
    When bootstrap invokes the rendered "bin/footing"
    Then control passes to "bin/footing", which runs the single up-front auth gate, pours the lead structure, creates the "<product>-lead-beads" repository, wires the git and beads remotes, and runs a "bd dolt push" smoke-test
    And "bin/footing" stops at solid footing demonstrated by a successful "git push" and a successful "bd dolt push"

  @scenario_hash:c15aeb90b21357e5
  Scenario: bootstrap refuses to invoke bin/footing when it has not been obtained
    Given an adopter fork that carries "bin/bootstrap" but no "bin/footing"
    And the render step that obtains "bin/footing" did not produce the file
    When the adopter runs "bin/bootstrap"
    Then bootstrap does not execute "bash ./bin/footing" against a missing file
    And bootstrap exits with a diagnostic naming the missing "bin/footing" instead of failing with an exit-127 "No such file or directory"
