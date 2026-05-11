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

from schemas import Clarify, WorkDone  # noqa: E402


@pytest.fixture
def context() -> dict:
    return {}


@given("an empty BC at a temporary path", target_fixture="bc_root")
def empty_bc(tmp_path: Path) -> Path:
    (tmp_path / "inbox").mkdir()
    (tmp_path / "outbox").mkdir()
    return tmp_path


@given(parsers.parse('the BC\'s outbox already contains a file named "{filename}"'))
def outbox_preexisting_file(bc_root: Path, filename: str, context: dict) -> None:
    path = bc_root / "outbox" / filename
    path.write_text("preexisting: true\n")
    # Capture original bytes so the unchanged-check can compare exactly.
    context["preexisting_files"] = context.get("preexisting_files", {})
    context["preexisting_files"][filename] = path.read_bytes()


@when(
    parsers.re(
        r'I run shop-msg respond clarify with work-id "(?P<work_id>[^"]*)" '
        r'and question "(?P<question>[^"]*)"'
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


@then("the command exits non-zero")
def command_exits_nonzero(context: dict) -> None:
    rc = context["cli_returncode"]
    assert rc != 0, f"expected non-zero exit; got {rc}; stderr:\n{context.get('cli_stderr', '')}"


@then(parsers.parse('the BC\'s outbox contains a file named "{filename}"'))
def outbox_contains_file(bc_root: Path, filename: str, context: dict) -> None:
    # The happy-path scenario expects the CLI to have succeeded; assert here
    # rather than inline in the When step so the collision scenario can
    # share the same When phrasing.
    rc = context.get("cli_returncode")
    assert rc == 0, (
        f"shop-msg exited {rc}; stderr:\n{context.get('cli_stderr', '')}"
    )
    path = bc_root / "outbox" / filename
    assert path.exists(), f"expected {path} to exist; outbox contents: {list((bc_root / 'outbox').iterdir())}"
    context["outbox_file"] = path


@then(parsers.parse('the BC\'s outbox file "{filename}" is unchanged'))
def outbox_file_unchanged(bc_root: Path, filename: str, context: dict) -> None:
    path = bc_root / "outbox" / filename
    assert path.exists(), f"expected {path} to still exist; outbox contents: {list((bc_root / 'outbox').iterdir())}"
    original = context["preexisting_files"][filename]
    actual = path.read_bytes()
    assert actual == original, (
        f"expected {filename} to be byte-identical to its preexisting contents; "
        f"original={original!r} actual={actual!r}"
    )


@then("the BC's outbox is empty")
def outbox_is_empty(bc_root: Path) -> None:
    outbox = bc_root / "outbox"
    contents = list(outbox.iterdir()) if outbox.exists() else []
    assert contents == [], (
        f"expected outbox to be empty; found: {[p.name for p in contents]}"
    )


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


@when(
    parsers.re(
        r'I run shop-msg respond work_done with work-id "(?P<work_id>[^"]*)" '
        r'and status "(?P<status>[^"]*)" and scenario-hash "(?P<scenario_hash>[^"]*)"'
    )
)
def run_respond_work_done_with_hash(
    bc_root: Path, work_id: str, status: str, scenario_hash: str, context: dict
) -> None:
    src_dir = Path(__file__).resolve().parent.parent / "src"
    proto_root = Path(__file__).resolve().parent.parent.parent
    env_pythonpath = f"{src_dir}:{proto_root}"
    result = subprocess.run(
        [
            sys.executable,
            "-m",
            "shop_msg",
            "respond",
            "work_done",
            "--bc-root",
            str(bc_root),
            "--work-id",
            work_id,
            "--status",
            status,
            "--scenario-hash",
            scenario_hash,
        ],
        env={"PYTHONPATH": env_pythonpath, "PATH": "/usr/bin:/bin"},
        capture_output=True,
        text=True,
    )
    context["cli_returncode"] = result.returncode
    context["cli_stdout"] = result.stdout
    context["cli_stderr"] = result.stderr


@when(
    parsers.re(
        r'I run shop-msg respond work_done with work-id "(?P<work_id>[^"]*)" '
        r'and status "(?P<status>[^"]*)"$'
    )
)
def run_respond_work_done_no_hash(
    bc_root: Path, work_id: str, status: str, context: dict
) -> None:
    src_dir = Path(__file__).resolve().parent.parent / "src"
    proto_root = Path(__file__).resolve().parent.parent.parent
    env_pythonpath = f"{src_dir}:{proto_root}"
    result = subprocess.run(
        [
            sys.executable,
            "-m",
            "shop_msg",
            "respond",
            "work_done",
            "--bc-root",
            str(bc_root),
            "--work-id",
            work_id,
            "--status",
            status,
        ],
        env={"PYTHONPATH": env_pythonpath, "PATH": "/usr/bin:/bin"},
        capture_output=True,
        text=True,
    )
    context["cli_returncode"] = result.returncode
    context["cli_stdout"] = result.stdout
    context["cli_stderr"] = result.stderr


@then(
    parsers.parse(
        'the file parses as a valid WorkDone with work_id "{work_id}" and status "{status}"'
    )
)
def file_parses_as_work_done(context: dict, work_id: str, status: str) -> None:
    path: Path = context["outbox_file"]
    with path.open() as f:
        data = yaml.safe_load(f)
    msg = WorkDone(**data)
    assert msg.work_id == work_id
    assert msg.status == status
