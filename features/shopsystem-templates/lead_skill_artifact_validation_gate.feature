@bc:unassigned @origin:brief-019
Feature: shopsystem-templates — artifact-producing PM skills fetch the canonical schema and validate before closing

  Six PDR-033 lead_skills terminate in a typed, schema-governed artifact:
  discovery-dialogue (intent-record), shaping (candidate), option-tradeoff
  (pdr or candidate), prioritization (prioritization-record), and
  product-narrative (whose closing branches are README, site, or a
  current-state revision — only the current-state branch is schema-governed;
  see below). A sixth skill, problem-space-mapping, terminates in a
  problem-space map revision, which the knowledge BC's eight-type typedef
  set does NOT recognize as an artifact type — verified empirically against
  per_type_typedef_generation.feature's "exactly the eight artifact types"
  pin, none of which is "problem-space-map." None of the schema-governed
  skills' SKILL.md bodies reference the canonical schema at all today
  (verified by inspecting the installed package: no `template`, `schema`,
  `typedef`, `canonical`, or `knowledge` pointer language, and no bundled
  `resources/` template file) — a PM has no way to know an artifact's real
  shape except by copying a pre-existing (and possibly already-drifted)
  file, and no way to check its own output before closing the session. This
  feature pins that each schema-governed skill (a) names fetching the
  canonical template for the type it produces via the new `shop-knowledge`
  CLI before or while producing the artifact, and (b) names running
  `shop-knowledge validate` against the produced document and surfacing a
  failure to the product authority rather than closing silently. It also
  pins the two carve-outs explicitly, so the gate is never over-applied to
  an artifact family the knowledge BC does not govern: product-narrative's
  README/site branches, and problem-space-mapping entirely.

  @scenario_hash:107bb9e2d7ddb530
  Scenario Outline: the poured "<skill>" skill names fetching the "<type>" canonical template and validating its produced artifact via shop-knowledge before closing
    Given an existing git repository at a target directory "<target>" with no ".claude/skills/" directory
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "<target>"
    Then the exit code is 0
    And the target directory contains a file at ".claude/skills/<skill>/SKILL.md"
    And the content of ".claude/skills/<skill>/SKILL.md" names fetching the canonical "<type>" template via "shop-knowledge template <type>" before or while producing the artifact
    And the content of ".claude/skills/<skill>/SKILL.md" names running "shop-knowledge validate" against the produced "<type>" document before the session closes
    And the content of ".claude/skills/<skill>/SKILL.md" names surfacing a validation failure to the product authority rather than closing the session silently

    Examples:
      | skill               | type                   | target                  |
      | discovery-dialogue  | intent-record          | /tmp/example-lead-shop  |
      | shaping             | candidate              | /tmp/example-lead-shop  |
      | option-tradeoff     | pdr                    | /tmp/example-lead-shop  |
      | option-tradeoff     | candidate              | /tmp/example-lead-shop  |
      | prioritization      | prioritization-record  | /tmp/example-lead-shop  |
      | product-narrative   | current-state          | /tmp/example-lead-shop  |

  @scenario_hash:cfdf2213b1c77bfb
  Scenario: product-narrative's README and site renderings are not gated by shop-knowledge validation because no typedef governs them
    Given an existing git repository at a target directory "/tmp/example-lead-shop" with no ".claude/skills/" directory
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And the content of ".claude/skills/product-narrative/SKILL.md" names that its README and site closing branches do not require "shop-knowledge validate", because README and site are not among the knowledge BC's eight recognized artifact types
    And the content of ".claude/skills/product-narrative/SKILL.md" names that only its current-state-revision closing branch requires "shop-knowledge validate"

  @scenario_hash:c0c636fb86c5579c
  Scenario: problem-space-mapping is not gated by shop-knowledge validation because no typedef exists for a problem-space-map artifact type
    Given an existing git repository at a target directory "/tmp/example-lead-shop" with no ".claude/skills/" directory
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And the target directory contains a file at ".claude/skills/problem-space-mapping/SKILL.md"
    And the content of ".claude/skills/problem-space-mapping/SKILL.md" does not name "shop-knowledge validate" or "shop-knowledge template" as a required closing step

  @scenario_hash:c47a92f5486ea893
  Scenario Outline: each gated PM skill's closing protocol step names "shop-knowledge validate" literally, never a bare description, when describing the validation gate
    Given the poured "<skill>" SKILL.md's closing protocol step
    When I locate the step describing validating the produced artifact against its schema
    Then that step names the literal substring "shop-knowledge validate" on the same step
    And that step does not describe the validation using a bare verb — "check", "verify", "confirm", or "ensure" — without naming the literal substring "shop-knowledge validate" on the same step

    Examples:
      | skill              |
      | discovery-dialogue |
      | shaping            |
      | option-tradeoff    |
      | prioritization     |
      | product-narrative  |
