import re
from typing import Literal, Union
from pydantic import BaseModel, Field, model_validator


# Matches an "@bc:<name>" token where <name> is one or more non-space
# characters. Used by ScenarioPayload to enforce that every scenario's
# gherkin body declares which BC owns the scenario, regardless of which
# tool constructed the payload (lead CLI, hand-rolled tests, future
# automation).
#
# The token form is anchored (^...$) because we apply it to whitespace-
# split tokens of a single line, not to the gherkin body as a whole.
# An earlier version used `re.compile(r"@bc:\S+").search(gherkin)` over
# the entire string, which accepted gherkin whose only @bc: occurrence
# was inside a step's quoted content (e.g. `Given the file mentions
# "@bc:fake" in passing`). The intent is "the gherkin has a tag-line
# containing @bc:<name>", so we walk lines, split on whitespace, and
# require at least one token to match this anchored pattern. That
# matches how pytest-bdd tag lines are actually shaped — a sequence of
# whitespace-separated `@tag` tokens — without permitting substring
# matches inside step bodies.
_BC_TAG_TOKEN_RE = re.compile(r"^@bc:\S+$")


def _gherkin_has_bc_tag_line(gherkin: str) -> bool:
    """True if some line in `gherkin` contains an @bc:<name> token.

    A "token" here is what you get from `str.split()` on the line — a
    whitespace-bounded run of non-space characters. This rejects @bc:
    appearing inside a quoted step phrase like
    `Given the body contains "@bc:fake"` because the surrounding quote
    characters bind to the token, leaving `"@bc:fake"` rather than the
    bare `@bc:fake` we require.
    """
    for line in gherkin.splitlines():
        for token in line.split():
            if _BC_TAG_TOKEN_RE.match(token):
                return True
    return False


class RequestMaintenance(BaseModel):
    message_type: Literal["request_maintenance"]
    work_id: str
    description: str
    acceptance_criteria: list[str] | None = None
    file_hints: list[str] | None = None


class ScenarioPayload(BaseModel):
    hash: str
    tags: list[str] = Field(default_factory=list)
    gherkin: str

    @model_validator(mode="after")
    def _gherkin_must_carry_bc_tag(self) -> "ScenarioPayload":
        # The @bc:<name> tag identifies which Bounded Context owns the
        # scenario. Previously enforced only by the lead-side CLI's
        # --bc-tag flag, which left a hand-constructed ScenarioPayload
        # free to skip it. Promoting the check to schema level means
        # every construction site (CLI, tests, future tools) gets the
        # same guarantee. The token must appear as a whitespace-bounded
        # tag on some line, not merely as a substring — see
        # `_gherkin_has_bc_tag_line` for why.
        if not _gherkin_has_bc_tag_line(self.gherkin):
            raise ValueError(
                "ScenarioPayload.gherkin must contain a line with a "
                "@bc:<name> tag (e.g. '@bc:shop-msg'); none was found."
            )
        return self


class AssignScenarios(BaseModel):
    message_type: Literal["assign_scenarios"]
    work_id: str
    scenarios: list[ScenarioPayload]


class RequestBugfix(BaseModel):
    message_type: Literal["request_bugfix"]
    work_id: str
    description: str
    scenarios: list[ScenarioPayload] = Field(default_factory=list)


class Clarify(BaseModel):
    message_type: Literal["clarify"]
    # work_id is constrained to a safe identifier shape: alphanumerics and
    # hyphens only, length >= 1. This rejects path separators ("/", ".."),
    # whitespace, and empty strings in one rule, so callers (CLI and any
    # future tools) cannot weaponize the value via crafted arguments.
    work_id: str = Field(min_length=1, pattern=r"^[a-zA-Z0-9-]+$")
    question: str = Field(min_length=1)


class WorkDone(BaseModel):
    message_type: Literal["work_done"]
    work_id: str
    status: Literal["complete", "partial", "blocked"]
    summary: str | None = None
    scenario_hashes: list[str] = Field(default_factory=list)


LeadMessage = Union[RequestMaintenance, AssignScenarios, RequestBugfix]
BCResponse = Union[Clarify, WorkDone]
