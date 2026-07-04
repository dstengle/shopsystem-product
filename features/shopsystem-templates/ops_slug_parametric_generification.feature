@bc:shopsystem-templates @origin:lead-r9r5
Feature: ops scaffolding is slug-parametric (lead shop) — compose/shop-shell/Dockerfile derive every product literal from the shop slug, with collision-free host ports and a broker-wired shop-shell, leaving no default-product name in a non-default render

  @scenario_hash:8fcf898fdeebc6be
  Scenario Outline: bootstrap of a "lead" shop named "<slug>" writes a top-level "compose.yaml" whose docker network, postgres container, agent-vault container, and agent-vault data volume are all derived from the shop slug "<slug>" (superseding the literal-"shopsystem" assertion of scenario 133) — so a non-default product slug renders a fully <slug>-scoped compose with no "shopsystem" name leaking through
    Given an existing git repository at a target directory "/tmp/example-lead-shop" with no top-level "compose.yaml" file
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "<slug>", and target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation the file at "compose.yaml" in the target directory parses as valid YAML
    And the parsed YAML contains a top-level key "networks" whose value is a mapping containing exactly the key "<slug>" and no key literally named "shopsystem" unless "<slug>" is itself "shopsystem"
    And the parsed YAML "services" mapping contains a key whose value carries a "container_name" equal to "<slug>-postgres"
    And the parsed YAML "services" mapping contains a key whose value carries a "container_name" equal to "<slug>-agent-vault"
    And the parsed YAML contains a top-level key "volumes" whose value is a mapping containing the key "<slug>-agent-vault-data"
    And every service entry under "services" attaches only to the "<slug>" network and to no network literally named "shopsystem" unless "<slug>" is itself "shopsystem"

    Examples:
      | slug       |
      | shopsystem |
      | dummyco    |

  @scenario_hash:9c8b8b40ee9ffde4
  Scenario Outline: the postgres "pgdata" volume source string in the bootstrap-rendered "compose.yaml" for a "lead" shop named "<slug>" is derived from the slug-parametric "<SLUG_UPPER>_DATA" environment variable (tightening scenario 138, which named only "SHOPSYSTEM_DATA") with a "${HOME}/.local/share/<slug>" default — so the env var name itself tracks the slug, the path is never under the repo, and an operator may override the data root per product
    Given an existing git repository at a target directory "/tmp/example-lead-shop"
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "<slug>", and target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation the file at "compose.yaml" in the target directory parses as valid YAML
    And the source string of the volume mount on the postgres service whose target is "/var/lib/postgresql/data" contains the literal substring "<SLUG_UPPER>_DATA"
    And that source string expresses a default whose literal substring is "${HOME}/.local/share/<slug>" or "$HOME/.local/share/<slug>"
    And that source string does not contain the literal substring "/tmp/example-lead-shop"
    And the body of "compose.yaml" in the target directory contains no path beginning with the literal "./pgdata" or "pgdata:"

    Examples:
      | slug       | SLUG_UPPER |
      | shopsystem | SHOPSYSTEM |
      | dummyco    | DUMMYCO    |

  @scenario_hash:abe57dcb4d6f6554
  Scenario Outline: the postgres host port published by the bootstrap-rendered "compose.yaml" for a "lead" shop named "<slug>" is collision-free per slug — it is "5432 + crc32(<slug>) % 1000" and is overridable by the slug-parametric "<SLUG_UPPER>_POSTGRES_PORT" environment variable — so two distinct products bootstrapped on one host bind distinct host ports by default while each remains operator-overridable
    Given an existing git repository at a target directory "/tmp/example-lead-shop"
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "<slug>", and target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation the file at "compose.yaml" in the target directory parses as valid YAML
    And the postgres service's "ports" entry maps a host port whose default value equals "<computed_port>", which is "5432 + crc32(<slug>) % 1000"
    And that "ports" entry expresses the host port through the "<SLUG_UPPER>_POSTGRES_PORT" environment variable with "<computed_port>" as its default
    And the rendered host port "<computed_port>" differs from the host port that the same rule yields for any other product slug, so concurrently bootstrapped products do not collide on the postgres host port

    Examples:
      | slug       | SLUG_UPPER | computed_port |
      | shopsystem | SHOPSYSTEM | 5829          |
      | dummyco    | DUMMYCO    | 5714          |
