@origin:lead-2lxya
Feature: shopsystem-templates — BLOCKING enforcement that every recognized kind has a valid per-kind writing skill (adr-071)

  ADR-071 (slice #4, enforcement half) decides that shop-templates enforces,
  BLOCKING, two checks over the per-kind writing skills that adr-070 structures:
  (D1) a COVERAGE check — every recognized artifact kind in the machine-
  enumerable kind set (the kinds for which "shop-knowledge template <kind>"
  succeeds) must have a per-kind writing skill at ".claude/skills/write-<kind>/";
  and (D2) a VALIDITY check — each writing skill's content must point at the
  live "shop-knowledge template / schema / validate" surface rather than embed a
  frozen copy (adr-070's reuse-not-copy invariant), and must cover the kind's
  required sections, correct starting status, and provenance-edge participation
  per adr-069. Advisory-only is rejected (D4): both checks BLOCK. The enforcement
  rides shop-templates' existing pour/render authority and is surfaced through
  the existing knowledge-artifact blocking gate with a bin/doctor-style verdict:
  one NAMED "[PASS]"/"[FAIL]" line per recognized kind, an aggregate verdict that
  passes only if every kind passes, and a non-zero exit naming the offending
  kind(s) on any miss. This feature pins that observable enforcement behavior at
  behavior altitude — pass/fail per kind, aggregate exit, and blocking-not-
  advisory. It does NOT pin the gate code, the skill structure itself (adr-070,
  writing_skill_template_structure.feature), or the deeper prose-quality validity
  fork flagged below.

  Scenario: every recognized kind has a valid writing skill so the enforcement passes with a per-kind PASS line and exit 0
    Given a shop where every recognized artifact kind has a per-kind writing skill at ".claude/skills/write-<kind>/" that references the live "shop-knowledge template / schema / validate" surface and covers its kind's required sections
    When "shop-templates" runs the writing-skill coverage and validity enforcement over the recognized kind set
    Then the enforcement emits one named "[PASS]" line per recognized kind
    And the aggregate verdict is an overall pass
    And the enforcement exits with code 0

  Scenario: a recognized kind with no writing skill fails the coverage check with a named FAIL line and a non-zero exit
    Given a shop where the recognized kind "candidate" has no writing skill directory at ".claude/skills/write-candidate/"
    When "shop-templates" runs the writing-skill coverage enforcement over the recognized kind set
    Then the enforcement emits a "[FAIL]" line named for the kind "candidate" reporting that its writing skill is missing
    And the aggregate verdict is an overall fail that names "candidate" as the offending kind
    And the enforcement exits non-zero

  Scenario: a writing skill that embeds a frozen copy of the template instead of the live reference fails the validity check with a named FAIL line and a non-zero exit
    Given a shop where the writing skill at ".claude/skills/write-adr/SKILL.md" inlines a verbatim copy of the "adr" template body rather than referencing "shop-knowledge template adr"
    When "shop-templates" runs the writing-skill validity enforcement over the recognized kind set
    Then the enforcement emits a "[FAIL]" line named for the kind "adr" reporting that its writing skill embeds a frozen copy instead of pointing at the live template/schema surface
    And the aggregate verdict is an overall fail that names "adr" as the offending kind
    And the enforcement exits non-zero

  Scenario: a writing skill that omits a required section for its kind fails the validity check with a named FAIL line and a non-zero exit
    Given a shop where the writing skill at ".claude/skills/write-adr/SKILL.md" omits a section that "shop-knowledge schema adr" reports as required for the "adr" kind
    When "shop-templates" runs the writing-skill validity enforcement over the recognized kind set
    Then the enforcement emits a "[FAIL]" line named for the kind "adr" reporting that its writing skill does not cover a required section for the kind
    And the aggregate verdict is an overall fail that names "adr" as the offending kind
    And the enforcement exits non-zero

  Scenario: the writing-skill enforcement is blocking not advisory — a failing kind blocks with no warn-tier downgrade
    Given a shop where at least one recognized kind lacks a valid writing skill
    When "shop-templates" runs the writing-skill enforcement in its distribution / blocking gate posture
    Then the failing kind produces a blocking failure that forces a non-zero exit rather than an advisory warning that still exits 0
    And no recognized kind is grandfathered into a warn tier, because the per-kind writing skills are net-new and carry no pre-existing legacy debt to exempt
