from typing import Literal, Union
from pydantic import BaseModel, Field


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
