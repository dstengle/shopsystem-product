@bc:shopsystem-templates @origin:adr-043
Feature: identity single-source + the ops-coordinates artifact (ADR-043 Phase 1)
  The manifest product: field is the single identity root; bootstrap renders one
  ops-coordinates artifact carrying each derived coordinate exactly once; every ops
  script sources it and re-derives nothing; each coordinate is a literal in one file.

@scenario_hash:38c7cc83fc1bc0f0
Scenario: the manifest "product:" field is the single identity root that the runtime-derived product reconciles to rather than an independent parallel derivation
  Given a forked lead repository whose directory basename is "acme-lead"
  And the bootstrap render injected the product slug "acme" wherever an "{{OPS_SLUG}}" token appeared
  When the footing script runs and writes the product manifest
  Then footing derives the product identity once and records it as "product: acme" in ".shop/product-manifest.yaml"
  And the runtime value footing uses for the product slug is read back from the manifest "product:" field, not independently recomputed a second time from the repository basename
  And when the manifest "product:" field and a basename-derived candidate would disagree, footing reconciles to the manifest "product:" value and emits a diagnostic naming the divergence rather than silently proceeding on the basename-derived value

@scenario_hash:ffb602e62d62c345
Scenario: shop-templates bootstrap renders one canonical ops-coordinates artifact that carries each derived product coordinate exactly once
  Given an existing git repository at a target directory "/tmp/example-lead-shop"
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "acme", and target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And the target directory contains exactly one rendered ops-coordinates artifact under "bin/" that declares the derived product coordinates as shell-sourceable assignments
  And that artifact assigns the product slug "acme" exactly once
  And that artifact assigns the agent-vault container name "acme-agent-vault" exactly once and the postgres container name "acme-postgres" exactly once
  And that artifact assigns the in-network broker address "http://acme-agent-vault:14321" exactly once and the generated host ports exactly once each
  And that artifact assigns the vault name "acme" exactly once and the lead beads repository name "acme-lead-beads" exactly once
  And no derived coordinate carried by the artifact appears as a second independent literal assignment anywhere else in the rendered "bin/" scripts

@scenario_hash:e59b29a6fc34f60a
Scenario: every rendered ops script sources the one ops-coordinates artifact instead of re-deriving the coordinates from the slug
  Given an existing git repository at a target directory "/tmp/example-lead-shop"
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "acme", and target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And each of the rendered scripts "bin/footing", "bin/agent-vault-provision", "bin/agent-vault-check", "bin/agent-vault-approve-claude", and "bin/shop-shell" sources the one rendered ops-coordinates artifact before it uses any product coordinate
  And in each of those scripts the agent-vault container name, the vault name, the docker network name, and the broker address are variable references to values defined by the sourced ops-coordinates artifact
  And none of those scripts re-derives the agent-vault container name by independently concatenating the slug with a "-agent-vault" suffix
  And none of those scripts independently re-spells the broker host literal "http://localhost:14321"

@scenario_hash:b499c9ba63a9ef42
Scenario: a coordinate carried by the ops-coordinates artifact is a literal in exactly one place and a variable reference everywhere else
  Given an existing git repository at a target directory "/tmp/example-lead-shop"
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "acme", and target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And across all rendered "bin/" scripts together the literal string "acme-agent-vault" appears as a defining assignment in exactly one file, the ops-coordinates artifact
  And across all rendered "bin/" scripts together the generated broker host port value appears as a defining assignment in exactly one file, the ops-coordinates artifact
  And across all rendered "bin/" scripts together the lead beads repository name "acme-lead-beads" appears as a defining assignment in exactly one file, the ops-coordinates artifact
  And the rendered ops scaffolding for shop name "dummyco" contains no case-insensitive occurrence of the literal "shopsystem" and no case-insensitive occurrence of the literal "fleet" except where part of a product-neutral framework image reference
