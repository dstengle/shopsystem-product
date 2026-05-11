"""Schema-level tests for ScenarioPayload's @bc:<name> tag constraint.

The check lives on the Pydantic model so every construction site gets
the same guarantee: the lead-side `shop-msg send` CLI, hand-rolled
tests, and any future automation that builds a ScenarioPayload by
reading YAML or instantiating the class directly. Anchoring at the
schema instead of the CLI was the lesson from S8 — a CLI flag enforces
discipline only as long as the CLI is the only entry point, which is
not a property the catalog can rely on.

Scenario hashes carried in module-level comments below correspond to
the hashes the lead recorded in `runs/scenario-15/inbox.yaml` (the
lead-016 request_bugfix that drove this work).
"""
import pytest
from pydantic import ValidationError

from catalog.schemas import ScenarioPayload


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
    payload = ScenarioPayload(hash="abc", tags=["@bc:test"], gherkin=gherkin)
    # Construction succeeds and the gherkin round-trips intact.
    assert payload.gherkin == gherkin


# @scenario_hash:80db3cb3ff18911e @bc:shop-msg
# Scenario: ScenarioPayload without @bc tag in gherkin is rejected
def test_scenario_payload_without_bc_tag_is_rejected() -> None:
    gherkin = (
        "Scenario: anything\n"
        "    Given foo\n"
        "    When bar\n"
        "    Then baz\n"
    )
    with pytest.raises(ValidationError) as excinfo:
        ScenarioPayload(hash="abc", gherkin=gherkin)
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
    payload = ScenarioPayload(hash="abc", gherkin=gherkin)
    assert "@bc:test" in payload.gherkin


def test_bc_tag_must_have_a_name() -> None:
    # "@bc:" with no name is the degenerate case the regex \S+ rejects.
    # Pinning it keeps the regex from accidentally being relaxed to \S*.
    gherkin = (
        "@bc:\n"
        "Scenario: anything\n"
        "    Given foo\n"
        "    When bar\n"
        "    Then baz\n"
    )
    with pytest.raises(ValidationError):
        ScenarioPayload(hash="abc", gherkin=gherkin)


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
    with pytest.raises(ValidationError) as excinfo:
        ScenarioPayload(hash="abc", gherkin=gherkin)
    msg = str(excinfo.value)
    assert "@bc" in msg, f"expected error to mention @bc; got:\n{msg}"
