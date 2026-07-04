@bc:shopsystem-templates @origin:lead-wnps
Feature: bootstrap renders a .env.example scaffold documenting the run credentials — additively layered on the already-pinned top-level .env.example scaffold, this pins that the scaffold explicitly documents the run environment variables the operator must supply, namely the agent-vault master password and the proxy token

  @scenario_hash:f02f9491b3a43753
  Scenario: shop-templates bootstrap generates a .env.example scaffold for the run credentials
    Given an existing git repository at a target directory "<target>"
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "<shop_name>", and target directory "<target>"
    Then the exit code is 0
    And the target directory contains a file ".env.example" documenting the run environment variables including the agent-vault master password and proxy token
