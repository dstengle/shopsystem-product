@bc:shopsystem-templates @origin:lead-2lxya
Feature: shopsystem-templates — per-kind writing skills follow one common structure, generated read-only and referencing the live template/schema surface (adr-070)

  ADR-070 (slice #4, authoring-guidance lane) decides that every one of the
  eight recognized artifact kinds gets its own discrete per-kind writing skill
  (a Claude Code skill directory at ".claude/skills/write-<kind>/SKILL.md"),
  and that the eight are GENERATED read-only from one common structure plus each
  kind's per-type typedef — the same ADR-059 typedef->generator single source
  that already emits "shop-knowledge template <kind>" and "shop-knowledge schema
  <kind>". The common structure carries five required parts: a per-kind
  frontmatter trigger; a template-fetch part that references the live template
  by "shop-knowledge template <kind>"; a schema-check part that references
  "shop-knowledge validate" / "shop-knowledge schema <kind>"; a lifecycle walk
  (correct starting status, provenance-edge participation, required sections per
  adr-069); and an explicit reuse-discipline note. The load-bearing structural
  invariant is reuse-BY-REFERENCE: a writing skill points at the live
  shop-knowledge surface and never embeds a frozen copy of a template or schema
  body. This feature pins that structure at behavior altitude — what parts a
  generated writing skill carries, that it references (not copies) the live
  surface, and that the eight are generated consistently from one structure. It
  does NOT pin skill prose bodies, the generator's internal emission logic, or
  the blocking enforcement (that is adr-071, pinned in
  writing_skill_enforcement.feature).

  @scenario_hash:210aafd52ca34318
  Scenario Outline: a poured per-kind "write-<kind>" writing skill carries the five required parts of the common structure
    Given an existing git repository at a target directory "<target>" with no ".claude/skills/" directory
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "<target>"
    Then the exit code is 0
    And the target directory contains a file at ".claude/skills/write-<kind>/SKILL.md"
    And the content of ".claude/skills/write-<kind>/SKILL.md" carries a frontmatter trigger whose "name" is "write-<kind>" and whose "description" triggers on the author creating a "<kind>"
    And the content names fetching the kind's shape from the live template via "shop-knowledge template <kind>"
    And the content names checking the drafted file with "shop-knowledge validate" and names the kind's schema surface via "shop-knowledge schema <kind>"
    And the content walks the kind's lifecycle by naming the correct starting status, the provenance-edge participation, and the required sections that "shop-knowledge schema <kind>" reports for "<kind>"
    And the content carries a reuse-discipline note stating the template and schema are referenced live and never copied

    Examples:
      | kind                  | target                 |
      | adr                   | /tmp/example-lead-shop |
      | pdr                   | /tmp/example-lead-shop |
      | brief                 | /tmp/example-lead-shop |
      | intent-record         | /tmp/example-lead-shop |
      | candidate             | /tmp/example-lead-shop |
      | session-record        | /tmp/example-lead-shop |
      | current-state         | /tmp/example-lead-shop |
      | prioritization-record | /tmp/example-lead-shop |

  @scenario_hash:617923c8aa748acb
  Scenario: a poured "write-<kind>" skill references the live shop-knowledge template and schema surface rather than embedding a frozen copy
    Given a "lead" shop bootstrapped by "shop-templates" that has poured the per-kind writing skill at ".claude/skills/write-adr/SKILL.md"
    When I inspect how the "write-adr" skill obtains the "adr" template and schema
    Then the skill names the live commands "shop-knowledge template adr" and "shop-knowledge schema adr" as the source of the kind's shape
    And the skill does not inline a verbatim copy of the "adr" template body or schema body in its own SKILL.md
    And a change to the "adr" typedef that alters the live "shop-knowledge template adr" output flows into the skill's guidance without a second hand-edit of the skill

  @scenario_hash:718c0cd3edd23d91
  Scenario: the eight per-kind writing skills are generated read-only from one common structure so they are consistent and cannot drift
    Given a "lead" shop bootstrapped by "shop-templates" that pours the per-kind writing skills for the eight recognized artifact kinds
    When I compare the poured "write-<kind>" skills across the eight kinds
    Then every "write-<kind>" skill exhibits the same five-part common structure, differing only in the per-kind facts read from that kind's typedef
    And each "write-<kind>" skill is marked generated and read-only, not hand-authored per repo
    And regenerating the writing skills from the common structure plus the kinds' typedefs is byte-stable, and a hand-edit to a generated "write-<kind>" skill is caught by the same drift check that guards the generated templates and schemas
