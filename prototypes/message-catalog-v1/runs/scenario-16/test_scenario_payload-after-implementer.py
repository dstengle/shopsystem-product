"""Schema-level tests for ScenarioPayload's invariants.

Two invariants live on the Pydantic model so every construction site
gets the same guarantee — the lead-side `shop-msg send` CLI, hand-rolled
tests, and any future automation that builds a ScenarioPayload by
reading YAML or instantiating the class directly:

1. The gherkin body must carry a `@bc:<name>` tag-line. Anchoring this
   at the schema instead of the CLI was the lesson from S8 — a CLI flag
   enforces discipline only as long as the CLI is the only entry point,
   which is not a property the catalog can rely on.
2. `hash` must equal the canonical scenario-hash of `gherkin`. Same
   reasoning, applied to the consistency between the embedded hash and
   the body it claims to hash: a CLI-only check left hand-rolled
   payloads free to carry mismatched values.

Scenario hashes carried in module-level comments below correspond to
the hashes the lead recorded for the work that drove each test (lead-016
for the @bc tag check, lead-018 for the hash↔body check).
"""
import pytest
from pydantic import ValidationError

from catalog.schemas import ScenarioPayload, _canonical_scenario_hash


# @scenario_hash:e02b6616fafa3258 @bc:shop-msg
# Scenario: ScenarioPayload with @bc tag in gherkin is accepted
def test_scenario_payload_with_bc_tag_is_accepted() -> None:
    gherkin = (
        "@bc:test\n"
        "Scenario: anything\n"
        "    Given foo\n"
        "    When bar\n"
        "    Then baz\n"
    )
    # The hash field is no longer a free string — lead-018 tightened the
    # schema to require hash == canonical_hash(gherkin). Compute the
    # canonical value here rather than hard-coding it so a future change
    # to the canonicalization rule on the catalog side surfaces inside
    # the catalog suite rather than as a mystery mismatch.
    expected = _canonical_scenario_hash(gherkin)
    payload = ScenarioPayload(hash=expected, tags=["@bc:test"], gherkin=gherkin)
    # Construction succeeds and the gherkin round-trips intact.
    assert payload.gherkin == gherkin
    assert payload.hash == expected


# @scenario_hash:80db3cb3ff18911e @bc:shop-msg
# Scenario: ScenarioPayload without @bc tag in gherkin is rejected
def test_scenario_payload_without_bc_tag_is_rejected() -> None:
    gherkin = (
        "Scenario: anything\n"
        "    Given foo\n"
        "    When bar\n"
        "    Then baz\n"
    )
    # The @bc-tag validator runs before the hash↔body validator (defined
    # first on the class), so a payload missing both invariants surfaces
    # the @bc error specifically. The hash value here is irrelevant to
    # what is being asserted but is the canonical value so that this test
    # cannot accidentally also test the hash check.
    with pytest.raises(ValidationError) as excinfo:
        ScenarioPayload(hash=_canonical_scenario_hash(gherkin), gherkin=gherkin)
    # The error message must identify the missing @bc tag so a caller
    # debugging a hand-rolled payload sees what to add.
    msg = str(excinfo.value)
    assert "@bc" in msg, f"expected error to mention @bc; got:\n{msg}"


def test_bc_tag_anywhere_in_gherkin_is_sufficient() -> None:
    # The constraint is "contains a line matching @bc:<name>" — it does
    # not require the tag to be on a specific line. This test pins that
    # behavior so a future tightening to "must be on the Scenario tag
    # line" surfaces here as a deliberate change rather than silent.
    gherkin = (
        "Scenario: anything\n"
        "    @bc:test\n"
        "    Given foo\n"
        "    When bar\n"
        "    Then baz\n"
    )
    payload = ScenarioPayload(hash=_canonical_scenario_hash(gherkin), gherkin=gherkin)
    assert "@bc:test" in payload.gherkin


def test_bc_tag_must_have_a_name() -> None:
    # "@bc:" with no name is the degenerate case the regex \S+ rejects.
    # Pinning it keeps the regex from accidentally being relaxed to \S*.
    # Hash value is irrelevant — the @bc validator runs first and rejects.
    gherkin = (
        "@bc:\n"
        "Scenario: anything\n"
        "    Given foo\n"
        "    When bar\n"
        "    Then baz\n"
    )
    with pytest.raises(ValidationError):
        ScenarioPayload(hash=_canonical_scenario_hash(gherkin), gherkin=gherkin)


# @scenario_hash:b3d95e2ac7a722e2 @bc:shop-msg
# Scenario: ScenarioPayload with @bc only inside a step text is rejected
def test_bc_tag_inside_step_quoted_content_is_rejected() -> None:
    # Lead-016's Reviewer demonstrated that the prior regex
    # `re.compile(r"@bc:\S+").search(gherkin)` accepted gherkin whose
    # only @bc: occurrence was inside a step's quoted content. The
    # intent of the constraint is "the gherkin carries a tag line that
    # contains @bc:<name>", not "the gherkin contains the substring
    # '@bc:' somewhere". This pins that intent: an @bc: appearing only
    # inside the body of a Given/When/Then step (here, surrounded by
    # quote characters that bind to it as `"@bc:fake"`) must be
    # rejected.
    gherkin = (
        "Feature: payload with @bc only inside step text\n"
        "\n"
        "  @scenario_hash:deadbeef\n"
        "  Scenario: regression\n"
        '    Given the body mentions "@bc:fake" in passing\n'
        "    When I construct a ScenarioPayload from that gherkin\n"
        "    Then Pydantic raises ValidationError\n"
    )
    # As with the other rejection tests, use the canonical hash so the
    # failure is unambiguously attributable to the @bc validator.
    with pytest.raises(ValidationError) as excinfo:
        ScenarioPayload(hash=_canonical_scenario_hash(gherkin), gherkin=gherkin)
    msg = str(excinfo.value)
    assert "@bc" in msg, f"expected error to mention @bc; got:\n{msg}"


# @scenario_hash:4a43ba52eaa6f4f6 @bc:shop-msg
# Scenario: ScenarioPayload with hash matching the gherkin canonicalization
#   is accepted
def test_scenario_payload_with_matching_hash_is_accepted() -> None:
    # lead-018 tightened the schema so that the `hash` field must equal
    # the canonical scenario-hash of the `gherkin` body. The happy path:
    # construct a payload with a body that carries a @bc:<name> tag and
    # a hash that equals canonical(gherkin), confirm construction
    # succeeds and the fields round-trip intact.
    gherkin = (
        "@bc:test\n"
        "Scenario: hash-matches-body happy path\n"
        "    Given a well-formed scenario body\n"
        "    When I hash the body canonically\n"
        "    Then the resulting payload validates\n"
    )
    expected = _canonical_scenario_hash(gherkin)
    payload = ScenarioPayload(hash=expected, gherkin=gherkin)
    assert payload.gherkin == gherkin
    assert payload.hash == expected


# @scenario_hash:fa67a12b4a820e29 @bc:shop-msg
# Scenario: ScenarioPayload with hash not matching the gherkin
#   canonicalization is rejected
def test_scenario_payload_with_mismatched_hash_is_rejected() -> None:
    # The "hand-rolled payload free to carry mismatched values" failure
    # mode lead-018 closes: a consumer constructs a ScenarioPayload with
    # a hash that is not the canonical hash of the body. Pydantic must
    # raise ValidationError, and the error must explain the mismatch so
    # a caller debugging a hand-rolled payload sees which side is wrong.
    gherkin = (
        "@bc:test\n"
        "Scenario: hash-mismatch rejected\n"
        "    Given a well-formed scenario body\n"
        "    When I supply a wrong hash for that body\n"
        "    Then Pydantic raises ValidationError\n"
    )
    wrong_hash = "0000000000000000"
    canonical = _canonical_scenario_hash(gherkin)
    # Sanity: the test would be meaningless if the wrong hash collided
    # with the canonical one; assert non-collision before exercising
    # the rejection path.
    assert wrong_hash != canonical
    with pytest.raises(ValidationError) as excinfo:
        ScenarioPayload(hash=wrong_hash, gherkin=gherkin)
    msg = str(excinfo.value)
    # The error must identify that the hash does not match the body.
    # Substring-check both the hash and a fragment of the message so a
    # future wording tweak that still names the mismatch keeps passing,
    # but a regression that silently drops the diagnostic fails here.
    assert "hash" in msg, f"expected error to mention hash; got:\n{msg}"
    assert wrong_hash in msg, (
        f"expected error to surface the wrong hash {wrong_hash!r}; got:\n{msg}"
    )
    assert canonical in msg, (
        f"expected error to surface the canonical hash {canonical!r}; got:\n{msg}"
    )


def test_canonical_hash_matches_scenarios_package() -> None:
    # The catalog duplicates the canonicalization rule from the
    # scenarios package on purpose (see _canonical_scenario_hash in
    # catalog.schemas for the rationale). The mitigation for that
    # duplication is this test: pin the catalog-side implementation
    # against the known hashes that scenarios/tests/test_hash.py pins on
    # the scenarios side. If either side drifts, both tests fail and
    # the disagreement surfaces immediately rather than as a silent
    # schema-vs-CLI mismatch at runtime.
    s4_body = """Scenario: Boiling water in Fahrenheit
    Given a temperature of 100 degrees Celsius
    When I convert it to Fahrenheit
    Then I get 212 degrees Fahrenheit"""
    # S4's recorded hash; also pinned by scenarios/tests/test_hash.py.
    assert _canonical_scenario_hash(s4_body) == "3f123ba774758ff2"

    s6_body = """Scenario: Reply to lead with a clarify message
    Given an empty BC at a temporary path
    When I run shop-msg respond clarify with work-id "lead-001" and question "What about equality?"
    Then the BC's outbox contains a file named "lead-001-clarify.yaml"
    And the file parses as a valid Clarify with work_id "lead-001" and question "What about equality?\""""
    # S6's recorded hash; also pinned by scenarios/tests/test_hash.py.
    assert _canonical_scenario_hash(s6_body) == "b9ed9c63b8ccb208"

    # And confirm @scenario_hash: lines are ignored on the catalog side
    # the same way the scenarios side ignores them (so an embedded hash
    # tag does not perturb the recomputation that the ScenarioPayload
    # validator does).
    assert _canonical_scenario_hash(
        "@scenario_hash:b9ed9c63b8ccb208\n" + s6_body
    ) == "b9ed9c63b8ccb208"
