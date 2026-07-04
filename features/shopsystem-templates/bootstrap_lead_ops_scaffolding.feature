@bc:shopsystem-templates @origin:lead-8hxz
Feature: bootstrap renders ops scaffolding (lead-shop only): compose.yaml, bin/shop-shell, Dockerfile.shopsystem-shell

  @scenario_hash:721a626cd0146f86
  Scenario: bootstrap of a "lead" shop writes a top-level "compose.yaml" defining a postgres service on the "shopsystem" docker network with the pgdata bind mounted from "${SHOPSYSTEM_DATA:-${HOME}/.local/share/shopsystem}/pgdata", so the rendered file matches the prototype that the operator runs with "docker compose up -d postgres" via "./bin/shop-shell"
  Given an existing git repository at a target directory "/tmp/example-lead-shop" with no top-level "compose.yaml" file
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And after the invocation the target directory contains a top-level file named "compose.yaml"
  And the file at "compose.yaml" in the target directory parses as valid YAML
  And the parsed YAML contains a top-level key "services" whose value is a mapping containing a key "postgres"
  And the "services.postgres" mapping has an "image" value whose string form begins with the literal "postgres:"
  And the "services.postgres" mapping has a "networks" entry naming the "shopsystem" network
  And the "services.postgres" mapping has a "volumes" entry whose source string contains the literal substring "${SHOPSYSTEM_DATA:-${HOME}/.local/share/shopsystem}/pgdata" and whose target string is exactly "/var/lib/postgresql/data"
  And the parsed YAML contains a top-level key "networks" whose value is a mapping containing a key "shopsystem"
  And no service entry under "services" mounts a volume whose source path resolves underneath "/tmp/example-lead-shop"

  @scenario_hash:0c7b91617e93d78f
  Scenario: bootstrap of a "bc" shop does not write the lead-shop ops scaffolding (no "compose.yaml", no "bin/shop-shell", no "Dockerfile.shopsystem-shell") because a BC runs inside a bc-launcher container and never owns its own postgres or shell image
  Given an existing git repository at a target directory "/tmp/example-bc-shop" with no top-level "compose.yaml", no "bin/" subdirectory, and no top-level "Dockerfile.shopsystem-shell"
  When I invoke the "shop-templates" bootstrap entry point with shop type "bc", shop name "shopsystem-messaging", and target directory "/tmp/example-bc-shop"
  Then the exit code is 0
  And after the invocation the target directory contains no top-level file named "compose.yaml"
  And after the invocation the target directory contains no file at "bin/shop-shell"
  And after the invocation the target directory contains no top-level file named "Dockerfile.shopsystem-shell"

  @scenario_hash:f39b2e176b954197
  Scenario: the postgres "pgdata" volume source string in the bootstrap-rendered "compose.yaml" for a "lead" shop is derived from the "SHOPSYSTEM_DATA" environment variable with a "$HOME/.local/share/shopsystem" default, and never resolves to a path underneath the target shop's own repository — so an operator who runs "docker compose up -d postgres" from a freshly bootstrapped shop does not pollute the repo with a "pgdata/" directory
  Given an existing git repository at a target directory "/tmp/example-lead-shop"
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And after the invocation the file at "compose.yaml" in the target directory parses as valid YAML
  And the source string of the volume mount on "services.postgres" whose target is "/var/lib/postgresql/data" contains the literal substring "SHOPSYSTEM_DATA"
  And the source string of that volume mount expresses a default whose literal substring is "${HOME}/.local/share/shopsystem" or "$HOME/.local/share/shopsystem"
  And the source string of that volume mount does not contain the literal substring "/tmp/example-lead-shop"
  And the body of "compose.yaml" in the target directory contains no path beginning with the literal "./pgdata" or "pgdata:"
