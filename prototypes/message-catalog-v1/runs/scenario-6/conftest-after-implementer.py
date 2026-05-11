"""Shared fixture and import setup for pytest-bdd in shop-msg-bc.

Step definitions themselves are written by the Implementer as part of
the work for each `assign_scenarios` message — new phrasings produce
new step definitions here. Importing the prototype's shared schemas
module requires adding the prototype root to sys.path; the schemas
module is at <prototype root>/schemas.py.
"""
import subprocess
import sys
from pathlib import Path

import pytest
import yaml
from pytest_bdd import given, parsers, then, when

# BC's own src/ on path so step defs can import shop_msg.*
sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))

# Prototype root on path so step defs can import shared `schemas`
sys.path.insert(0, str(Path(__file__).resolve().parent.parent.parent))

from schemas import Clarify  # noqa: E402


@pytest.fixture
def context() -> dict:
    return {}


@given("an empty BC at a temporary path", target_fixture="bc_root")
def empty_bc(tmp_path: Path) -> Path:
    (tmp_path / "inbox").mkdir()
    (tmp_path / "outbox").mkdir()
    return tmp_path


@when(
    parsers.parse(
        'I run shop-msg respond clarify with work-id "{work_id}" and question "{question}"'
    )
)
def run_respond_clarify(bc_root: Path, work_id: str, question: str, context: dict) -> None:
    src_dir = Path(__file__).resolve().parent.parent / "src"
    proto_root = Path(__file__).resolve().parent.parent.parent
    env_pythonpath = f"{src_dir}:{proto_root}"
    result = subprocess.run(
        [
            sys.executable,
            "-m",
            "shop_msg",
            "respond",
            "clarify",
            "--bc-root",
            str(bc_root),
            "--work-id",
            work_id,
            "--question",
            question,
        ],
        env={"PYTHONPATH": env_pythonpath, "PATH": "/usr/bin:/bin"},
        capture_output=True,
        text=True,
    )
    context["cli_returncode"] = result.returncode
    context["cli_stdout"] = result.stdout
    context["cli_stderr"] = result.stderr
    assert result.returncode == 0, (
        f"shop-msg exited {result.returncode}; stderr:\n{result.stderr}"
    )


@then(parsers.parse('the BC\'s outbox contains a file named "{filename}"'))
def outbox_contains_file(bc_root: Path, filename: str, context: dict) -> None:
    path = bc_root / "outbox" / filename
    assert path.exists(), f"expected {path} to exist; outbox contents: {list((bc_root / 'outbox').iterdir())}"
    context["outbox_file"] = path


@then(
    parsers.parse(
        'the file parses as a valid Clarify with work_id "{work_id}" and question "{question}"'
    )
)
def file_parses_as_clarify(context: dict, work_id: str, question: str) -> None:
    path: Path = context["outbox_file"]
    with path.open() as f:
        data = yaml.safe_load(f)
    msg = Clarify(**data)
    assert msg.work_id == work_id
    assert msg.question == question
