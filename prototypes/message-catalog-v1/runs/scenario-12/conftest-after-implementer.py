"""Shared fixture and import setup for pytest-bdd in shop-msg-bc.

Step definitions themselves are written by the Implementer as part of
the work for each `assign_scenarios` message — new phrasings produce
new step definitions here. Schemas come from the installed `catalog`
package; the CLI is invoked via the installed `shop-msg` console script.
"""
import subprocess
from pathlib import Path

import pytest
import yaml
from pytest_bdd import given, parsers, then, when

from catalog.schemas import AssignScenarios, Clarify, RequestMaintenance, WorkDone


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
    result = subprocess.run(
        [
            "shop-msg",
            "respond",
            "clarify",
            "--bc-root",
            str(bc_root),
            "--work-id",
            work_id,
            "--question",
            question,
        ],
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
    result = subprocess.run(
        [
            "shop-msg",
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
    result = subprocess.run(
        [
            "shop-msg",
            "respond",
            "work_done",
            "--bc-root",
            str(bc_root),
            "--work-id",
            work_id,
            "--status",
            status,
        ],
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


@given(parsers.parse('the BC\'s inbox already contains a file named "{filename}"'))
def inbox_preexisting_file(bc_root: Path, filename: str, context: dict) -> None:
    path = bc_root / "inbox" / filename
    path.write_text("preexisting: true\n")
    # Capture original bytes so the unchanged-check can compare exactly.
    context["preexisting_inbox_files"] = context.get("preexisting_inbox_files", {})
    context["preexisting_inbox_files"][filename] = path.read_bytes()


@when(
    parsers.re(
        r'I run shop-msg send request_maintenance with work-id "(?P<work_id>[^"]*)" '
        r'and description "(?P<description>[^"]*)"$'
    )
)
def run_send_request_maintenance(
    bc_root: Path, work_id: str, description: str, context: dict
) -> None:
    result = subprocess.run(
        [
            "shop-msg",
            "send",
            "request_maintenance",
            "--bc-root",
            str(bc_root),
            "--work-id",
            work_id,
            "--description",
            description,
        ],
        capture_output=True,
        text=True,
    )
    context["cli_returncode"] = result.returncode
    context["cli_stdout"] = result.stdout
    context["cli_stderr"] = result.stderr


@when(
    parsers.re(
        r'I run shop-msg send request_maintenance with work-id "(?P<work_id>[^"]*)" '
        r'and description "(?P<description>[^"]*)" '
        r'and acceptance-criterion "(?P<criterion>[^"]*)" '
        r'and file-hint "(?P<file_hint>[^"]*)"$'
    )
)
def run_send_request_maintenance_with_criterion_and_hint(
    bc_root: Path,
    work_id: str,
    description: str,
    criterion: str,
    file_hint: str,
    context: dict,
) -> None:
    result = subprocess.run(
        [
            "shop-msg",
            "send",
            "request_maintenance",
            "--bc-root",
            str(bc_root),
            "--work-id",
            work_id,
            "--description",
            description,
            "--acceptance-criterion",
            criterion,
            "--file-hint",
            file_hint,
        ],
        capture_output=True,
        text=True,
    )
    context["cli_returncode"] = result.returncode
    context["cli_stdout"] = result.stdout
    context["cli_stderr"] = result.stderr


@when(
    parsers.re(
        r'I run shop-msg send request_maintenance with work-id "(?P<work_id>[^"]*)" '
        r'and description "(?P<description>[^"]*)" '
        r'and acceptance-criterion "(?P<criterion1>[^"]*)" '
        r'and acceptance-criterion "(?P<criterion2>[^"]*)"$'
    )
)
def run_send_request_maintenance_with_two_criteria(
    bc_root: Path,
    work_id: str,
    description: str,
    criterion1: str,
    criterion2: str,
    context: dict,
) -> None:
    result = subprocess.run(
        [
            "shop-msg",
            "send",
            "request_maintenance",
            "--bc-root",
            str(bc_root),
            "--work-id",
            work_id,
            "--description",
            description,
            "--acceptance-criterion",
            criterion1,
            "--acceptance-criterion",
            criterion2,
        ],
        capture_output=True,
        text=True,
    )
    context["cli_returncode"] = result.returncode
    context["cli_stdout"] = result.stdout
    context["cli_stderr"] = result.stderr


@then(parsers.parse('the BC\'s inbox contains a file named "{filename}"'))
def inbox_contains_file(bc_root: Path, filename: str, context: dict) -> None:
    rc = context.get("cli_returncode")
    assert rc == 0, (
        f"shop-msg exited {rc}; stderr:\n{context.get('cli_stderr', '')}"
    )
    path = bc_root / "inbox" / filename
    assert path.exists(), (
        f"expected {path} to exist; inbox contents: {list((bc_root / 'inbox').iterdir())}"
    )
    context["inbox_file"] = path


@then(
    parsers.parse(
        'the file parses as a valid RequestMaintenance with work_id "{work_id}" '
        'and description "{description}"'
    )
)
def file_parses_as_request_maintenance(
    context: dict, work_id: str, description: str
) -> None:
    path: Path = context["inbox_file"]
    with path.open() as f:
        data = yaml.safe_load(f)
    msg = RequestMaintenance(**data)
    assert msg.work_id == work_id
    assert msg.description == description


def _parse_quoted_list(raw: str) -> list[str]:
    """Parse a Then-step list literal like '["a", "b"]' into ['a', 'b'].

    Tolerates the simple shape used by these scenarios: bracket-delimited,
    comma-separated, double-quoted strings.
    """
    import re as _re
    return _re.findall(r'"([^"]*)"', raw)


@then(
    parsers.re(
        r'the file parses as a valid RequestMaintenance with work_id "(?P<work_id>[^"]*)", '
        r'description "(?P<description>[^"]*)", '
        r'acceptance_criteria (?P<criteria>\[[^\]]*\]), '
        r'and file_hints (?P<hints>\[[^\]]*\])$'
    )
)
def file_parses_as_request_maintenance_full(
    context: dict,
    work_id: str,
    description: str,
    criteria: str,
    hints: str,
) -> None:
    path: Path = context["inbox_file"]
    with path.open() as f:
        data = yaml.safe_load(f)
    msg = RequestMaintenance(**data)
    assert msg.work_id == work_id
    assert msg.description == description
    assert msg.acceptance_criteria == _parse_quoted_list(criteria)
    assert msg.file_hints == _parse_quoted_list(hints)


@then(
    parsers.re(
        r'the file parses as a valid RequestMaintenance with work_id "(?P<work_id>[^"]*)" '
        r'and acceptance_criteria (?P<criteria>\[[^\]]*\])$'
    )
)
def file_parses_as_request_maintenance_with_criteria(
    context: dict,
    work_id: str,
    criteria: str,
) -> None:
    path: Path = context["inbox_file"]
    with path.open() as f:
        data = yaml.safe_load(f)
    msg = RequestMaintenance(**data)
    assert msg.work_id == work_id
    assert msg.acceptance_criteria == _parse_quoted_list(criteria)


@then(parsers.parse('the BC\'s inbox file "{filename}" is unchanged'))
def inbox_file_unchanged(bc_root: Path, filename: str, context: dict) -> None:
    path = bc_root / "inbox" / filename
    assert path.exists(), (
        f"expected {path} to still exist; inbox contents: {list((bc_root / 'inbox').iterdir())}"
    )
    original = context["preexisting_inbox_files"][filename]
    actual = path.read_bytes()
    assert actual == original, (
        f"expected {filename} to be byte-identical to its preexisting contents; "
        f"original={original!r} actual={actual!r}"
    )


def _scenario_hash_via_cli(body: str) -> str:
    """Invoke the `scenarios hash` CLI to compute the canonical hash.

    Tests deliberately go through the same CLI boundary the production
    code uses, so a regression in either side surfaces here.
    """
    result = subprocess.run(
        ["scenarios", "hash"],
        input=body,
        capture_output=True,
        text=True,
        check=True,
    )
    return result.stdout.strip()


def _write_scenario_body_file(tmp_path: Path, context: dict, raw_text: str) -> Path:
    """Materialize a scenario body to a file under tmp_path.

    The Gherkin step text encodes newlines as the literal two-character
    escape ``\\n``; this helper converts them back to real newlines so
    the file mirrors what a user would author by hand.
    """
    body = raw_text.replace("\\n", "\n")
    files = context.setdefault("scenario_body_files", [])
    files.append({"body": body})
    idx = len(files) - 1
    path = tmp_path / f"scenario_body_{idx}.txt"
    path.write_text(body)
    files[idx]["path"] = path
    return path


@given(
    parsers.parse('a scenario body file containing the text "{raw_text}"')
)
def given_scenario_body_file(tmp_path: Path, context: dict, raw_text: str) -> None:
    _write_scenario_body_file(tmp_path, context, raw_text)


@given(
    parsers.parse('another scenario body file containing the text "{raw_text}"')
)
def given_another_scenario_body_file(
    tmp_path: Path, context: dict, raw_text: str
) -> None:
    _write_scenario_body_file(tmp_path, context, raw_text)


@when(
    parsers.re(
        r'I run shop-msg send assign_scenarios with work-id "(?P<work_id>[^"]*)" '
        r'and feature-title "(?P<feature_title>[^"]*)" '
        r'and bc-tag "(?P<bc_tag>[^"]*)" '
        r'and that scenario file$'
    )
)
def run_send_assign_scenarios_one_file(
    bc_root: Path,
    work_id: str,
    feature_title: str,
    bc_tag: str,
    context: dict,
) -> None:
    files = context["scenario_body_files"]
    assert len(files) == 1, (
        f"'that scenario file' expects exactly one scenario body file; got {len(files)}"
    )
    cmd = [
        "shop-msg",
        "send",
        "assign_scenarios",
        "--bc-root",
        str(bc_root),
        "--work-id",
        work_id,
        "--feature-title",
        feature_title,
        "--bc-tag",
        bc_tag,
        "--scenario-file",
        str(files[0]["path"]),
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    context["cli_returncode"] = result.returncode
    context["cli_stdout"] = result.stdout
    context["cli_stderr"] = result.stderr


@when(
    parsers.re(
        r'I run shop-msg send assign_scenarios with work-id "(?P<work_id>[^"]*)" '
        r'and feature-title "(?P<feature_title>[^"]*)" '
        r'and bc-tag "(?P<bc_tag>[^"]*)" '
        r'and both scenario files$'
    )
)
def run_send_assign_scenarios_both_files(
    bc_root: Path,
    work_id: str,
    feature_title: str,
    bc_tag: str,
    context: dict,
) -> None:
    files = context["scenario_body_files"]
    assert len(files) == 2, (
        f"'both scenario files' expects exactly two scenario body files; got {len(files)}"
    )
    cmd = [
        "shop-msg",
        "send",
        "assign_scenarios",
        "--bc-root",
        str(bc_root),
        "--work-id",
        work_id,
        "--feature-title",
        feature_title,
        "--bc-tag",
        bc_tag,
    ]
    for entry in files:
        cmd.extend(["--scenario-file", str(entry["path"])])
    result = subprocess.run(cmd, capture_output=True, text=True)
    context["cli_returncode"] = result.returncode
    context["cli_stdout"] = result.stdout
    context["cli_stderr"] = result.stderr


@then(
    parsers.parse(
        'the file parses as a valid AssignScenarios with work_id "{work_id}" '
        'and one scenario whose hash equals the scenarios-hash of the body'
    )
)
def file_parses_as_assign_scenarios_one_with_hash_match(
    context: dict, work_id: str
) -> None:
    path: Path = context["inbox_file"]
    with path.open() as f:
        data = yaml.safe_load(f)
    msg = AssignScenarios(**data)
    assert msg.work_id == work_id
    assert len(msg.scenarios) == 1, (
        f"expected exactly one scenario in payload; got {len(msg.scenarios)}"
    )
    body = context["scenario_body_files"][0]["body"]
    expected_hash = _scenario_hash_via_cli(body)
    actual_hash = msg.scenarios[0].hash
    assert actual_hash == expected_hash, (
        f"scenario hash mismatch: CLI emitted {actual_hash!r}, "
        f"`scenarios hash` of body produces {expected_hash!r}"
    )


@then(
    parsers.parse(
        'the file parses as a valid AssignScenarios with work_id "{work_id}" '
        'and two scenarios whose hashes are distinct'
    )
)
def file_parses_as_assign_scenarios_two_distinct(
    context: dict, work_id: str
) -> None:
    path: Path = context["inbox_file"]
    with path.open() as f:
        data = yaml.safe_load(f)
    msg = AssignScenarios(**data)
    assert msg.work_id == work_id
    assert len(msg.scenarios) == 2, (
        f"expected exactly two scenarios in payload; got {len(msg.scenarios)}"
    )
    h0, h1 = msg.scenarios[0].hash, msg.scenarios[1].hash
    assert h0 != h1, f"expected distinct hashes; both were {h0!r}"
