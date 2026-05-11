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

from pydantic import ValidationError

from catalog.schemas import (
    AssignScenarios,
    Clarify,
    RequestBugfix,
    RequestMaintenance,
    ScenarioPayload,
    WorkDone,
)


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
    # lead-018 tightened the ScenarioPayload schema so that
    # `hash == canonical_scenario_hash(gherkin)`. Pydantic raises
    # ValidationError on a mismatch — so reaching this line at all means
    # the schema-level invariant is satisfied. The historical wording
    # "hash equals the scenarios-hash of the body" in the feature file
    # captures the same intent in plain English: the payload's hash is
    # the canonical scenario-hash of the body the payload carries. We
    # also pin that the embedded body text is still present in the
    # gherkin field, so a future regression that drops the body from the
    # gherkin (and trivially passes the schema check via an empty body)
    # surfaces here.
    path: Path = context["inbox_file"]
    with path.open() as f:
        data = yaml.safe_load(f)
    msg = AssignScenarios(**data)
    assert msg.work_id == work_id
    assert len(msg.scenarios) == 1, (
        f"expected exactly one scenario in payload; got {len(msg.scenarios)}"
    )
    body = context["scenario_body_files"][0]["body"]
    actual_hash = msg.scenarios[0].hash
    gherkin = msg.scenarios[0].gherkin
    # Body must still appear in the emitted gherkin; otherwise the
    # round-trip is silently dropping content.
    first_body_line = next(
        (l for l in body.splitlines() if l.strip()), ""
    )
    assert first_body_line in gherkin, (
        f"expected the body's first non-blank line {first_body_line!r} "
        f"to appear in the gherkin; got gherkin:\n{gherkin}"
    )
    # The schema-level invariant: `hash == canonical(gherkin)`. Recompute
    # via the same CLI boundary `_compute_scenario_hash` uses in
    # production code, so a drift on either side of that boundary
    # surfaces here.
    expected_hash = _scenario_hash_via_cli(gherkin)
    assert actual_hash == expected_hash, (
        f"scenario hash mismatch: CLI emitted {actual_hash!r}, "
        f"`scenarios hash` of gherkin produces {expected_hash!r}"
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


@when(
    parsers.re(
        r'I run shop-msg send request_bugfix with work-id "(?P<work_id>[^"]*)" '
        r'and description "(?P<description>[^"]*)"$'
    )
)
def run_send_request_bugfix_description_only(
    bc_root: Path, work_id: str, description: str, context: dict
) -> None:
    result = subprocess.run(
        [
            "shop-msg",
            "send",
            "request_bugfix",
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
        r'I run shop-msg send request_bugfix with work-id "(?P<work_id>[^"]*)", '
        r'description "(?P<description>[^"]*)", '
        r'feature-title "(?P<feature_title>[^"]*)", '
        r'bc-tag "(?P<bc_tag>[^"]*)", '
        r'and that scenario file$'
    )
)
def run_send_request_bugfix_with_one_scenario(
    bc_root: Path,
    work_id: str,
    description: str,
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
        "request_bugfix",
        "--bc-root",
        str(bc_root),
        "--work-id",
        work_id,
        "--description",
        description,
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


@then(
    parsers.parse(
        'the file parses as a valid RequestBugfix with work_id "{work_id}", '
        'description "{description}", and no scenarios'
    )
)
def file_parses_as_request_bugfix_no_scenarios(
    context: dict, work_id: str, description: str
) -> None:
    path: Path = context["inbox_file"]
    with path.open() as f:
        data = yaml.safe_load(f)
    msg = RequestBugfix(**data)
    assert msg.work_id == work_id
    assert msg.description == description
    assert msg.scenarios == [], (
        f"expected no scenarios; got {len(msg.scenarios)}"
    )


@given(
    parsers.re(
        r'shop-msg respond work_done was previously used to write '
        r'"(?P<filename>[^"]*)" with status "(?P<status>[^"]*)" '
        r'and scenario-hash "(?P<scenario_hash>[^"]*)"'
    )
)
def given_prior_work_done(
    bc_root: Path,
    filename: str,
    status: str,
    scenario_hash: str,
) -> None:
    # Filename of the form "<work_id>-work_done.yaml"; recover work_id by
    # stripping the suffix the CLI deterministically appends.
    suffix = "-work_done.yaml"
    assert filename.endswith(suffix), (
        f"expected work_done filename to end with {suffix!r}; got {filename!r}"
    )
    work_id = filename[: -len(suffix)]
    # Drive the same CLI surface production uses; ignore the result here
    # because this is setup, not the assertion under test.
    subprocess.run(
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
        check=True,
    )


@given(
    parsers.re(
        r'shop-msg respond clarify was previously used to write '
        r'"(?P<filename>[^"]*)" with question "(?P<question>[^"]*)"'
    )
)
def given_prior_clarify(bc_root: Path, filename: str, question: str) -> None:
    suffix = "-clarify.yaml"
    assert filename.endswith(suffix), (
        f"expected clarify filename to end with {suffix!r}; got {filename!r}"
    )
    work_id = filename[: -len(suffix)]
    subprocess.run(
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
        check=True,
    )


@when(
    parsers.re(
        r'I run shop-msg read outbox with work-id "(?P<work_id>[^"]*)"$'
    )
)
def run_read_outbox(bc_root: Path, work_id: str, context: dict) -> None:
    result = subprocess.run(
        [
            "shop-msg",
            "read",
            "outbox",
            "--bc-root",
            str(bc_root),
            "--work-id",
            work_id,
        ],
        capture_output=True,
        text=True,
    )
    context["cli_returncode"] = result.returncode
    context["cli_stdout"] = result.stdout
    context["cli_stderr"] = result.stderr


@then("the command exits zero")
def command_exits_zero(context: dict) -> None:
    rc = context["cli_returncode"]
    assert rc == 0, (
        f"expected zero exit; got {rc}; stderr:\n{context.get('cli_stderr', '')}"
    )


@then(
    parsers.re(
        r'stdout includes message_type "(?P<message_type>[^"]*)" '
        r'and work_id "(?P<work_id>[^"]*)" '
        r'and status "(?P<status>[^"]*)"$'
    )
)
def stdout_includes_message_type_work_id_status(
    context: dict, message_type: str, work_id: str, status: str
) -> None:
    stdout = context.get("cli_stdout", "")
    for token in (message_type, work_id, status):
        assert token in stdout, (
            f"expected stdout to contain {token!r}; full stdout:\n{stdout}"
        )


@then(
    parsers.re(
        r'stdout includes message_type "(?P<message_type>[^"]*)" '
        r'and work_id "(?P<work_id>[^"]*)"$'
    )
)
def stdout_includes_message_type_and_work_id(
    context: dict, message_type: str, work_id: str
) -> None:
    stdout = context.get("cli_stdout", "")
    for token in (message_type, work_id):
        assert token in stdout, (
            f"expected stdout to contain {token!r}; full stdout:\n{stdout}"
        )


@then("stderr explains no outbox response was found")
def stderr_explains_no_outbox_response(context: dict) -> None:
    stderr = context.get("cli_stderr", "")
    # Substring-check on the salient phrase the CLI uses on miss; keeps
    # the assertion stable against incidental wording changes elsewhere
    # in the message.
    assert "no outbox response" in stderr, (
        f"expected stderr to explain no outbox response was found; got:\n{stderr}"
    )


@given(
    parsers.parse(
        'the BC\'s outbox already contains a file named "{filename}" with content '
        'that is valid YAML but does not match the BCResponse schema'
    )
)
def outbox_preexisting_invalid_response(
    bc_root: Path, filename: str, context: dict
) -> None:
    # Valid YAML (parses to a dict) but the message_type is not one of the
    # discriminated-union branches in BCResponse, so pydantic validation
    # fails. This pins the read-outbox schema-validation path without
    # depending on a specific missing/extra field — any BCResponse rejection
    # routes through the same try/except.
    path = bc_root / "outbox" / filename
    path.write_text(
        "message_type: not_a_real_type\n"
        "work_id: lead-099\n"
        "question: this payload is structurally valid YAML\n"
    )


@then("stderr explains schema validation failed")
def stderr_explains_schema_validation_failed(context: dict) -> None:
    stderr = context.get("cli_stderr", "")
    # Substring-check on the salient phrase the CLI uses when the outbox
    # YAML parses but fails the BCResponse schema.
    assert "validation failed" in stderr, (
        f"expected stderr to explain schema validation failed; got:\n{stderr}"
    )


@then(
    parsers.parse(
        'the BC\'s inbox file contains a gherkin string with a line '
        'containing "{needle}"'
    )
)
def inbox_file_gherkin_contains(bc_root: Path, needle: str, context: dict) -> None:
    # The CLI must have succeeded; the inbox should now hold a single
    # YAML file produced by the send command. Asserting CLI success here
    # keeps this Then usable as the only post-send assertion (no separate
    # "inbox contains a file named" step needed in this scenario).
    rc = context.get("cli_returncode")
    assert rc == 0, (
        f"shop-msg exited {rc}; stderr:\n{context.get('cli_stderr', '')}"
    )
    inbox = bc_root / "inbox"
    yaml_files = list(inbox.glob("*.yaml"))
    assert len(yaml_files) == 1, (
        f"expected exactly one inbox yaml after send; found {[p.name for p in yaml_files]}"
    )
    with yaml_files[0].open() as f:
        data = yaml.safe_load(f)
    scenarios_field = data.get("scenarios") or []
    assert scenarios_field, (
        f"expected the inbox payload to carry at least one scenario; got {data!r}"
    )
    # The "line containing" wording matches the historical gherkin tag
    # convention (tags live on their own line). Splitting on newlines
    # makes the assertion match that intent literally rather than a
    # naive substring search that would tolerate the tag accidentally
    # being concatenated mid-step.
    found = False
    for sp in scenarios_field:
        gherkin = sp.get("gherkin", "")
        for line in gherkin.splitlines():
            if needle in line:
                found = True
                break
        if found:
            break
    assert found, (
        f"expected some scenario's gherkin to contain a line with {needle!r}; "
        f"scenarios: {scenarios_field!r}"
    )


@then(
    parsers.re(
        r'the BC\'s inbox file "(?P<filename>[^"]*)" parses as a valid '
        r'RequestBugfix with description "(?P<description>[^"]*)" '
        r'and one scenario whose hash equals the scenarios-hash of the body$'
    )
)
def inbox_file_parses_as_request_bugfix_one_scenario(
    bc_root: Path, filename: str, description: str, context: dict
) -> None:
    # This Then combines "inbox contains the file" and "file parses as ..."
    # into a single step (the lead-013 scenario phrases it that way), so it
    # has to assert CLI success itself rather than rely on the standalone
    # "inbox contains a file named" step.
    rc = context.get("cli_returncode")
    assert rc == 0, (
        f"shop-msg exited {rc}; stderr:\n{context.get('cli_stderr', '')}"
    )
    path = bc_root / "inbox" / filename
    assert path.exists(), (
        f"expected {path} to exist; inbox contents: {list((bc_root / 'inbox').iterdir())}"
    )
    with path.open() as f:
        data = yaml.safe_load(f)
    # Reaching RequestBugfix(**data) without raising means each embedded
    # ScenarioPayload satisfies the schema-level
    # `hash == canonical_scenario_hash(gherkin)` invariant lead-018 added.
    msg = RequestBugfix(**data)
    assert msg.description == description
    assert len(msg.scenarios) == 1, (
        f"expected exactly one scenario in payload; got {len(msg.scenarios)}"
    )
    body = context["scenario_body_files"][0]["body"]
    actual_hash = msg.scenarios[0].hash
    gherkin = msg.scenarios[0].gherkin
    # Body must still appear in the emitted gherkin; same reasoning as
    # the assign_scenarios Then-step above.
    first_body_line = next(
        (l for l in body.splitlines() if l.strip()), ""
    )
    assert first_body_line in gherkin, (
        f"expected the body's first non-blank line {first_body_line!r} "
        f"to appear in the gherkin; got gherkin:\n{gherkin}"
    )
    expected_hash = _scenario_hash_via_cli(gherkin)
    assert actual_hash == expected_hash, (
        f"scenario hash mismatch: CLI emitted {actual_hash!r}, "
        f"`scenarios hash` of gherkin produces {expected_hash!r}"
    )


# -----------------------------------------------------------------------
# lead-018: hash↔body schema invariant
# -----------------------------------------------------------------------
#
# The three scenarios below exercise the schema-level invariant that
# `ScenarioPayload.hash == canonical_scenario_hash(gherkin)`. The first
# two go directly through the Pydantic constructor (catalog package);
# the third drives the same invariant end-to-end through the `shop-msg
# send assign_scenarios` CLI to confirm the producer remains internally
# consistent with the schema.


@given(
    parsers.parse(
        'a gherkin body that contains a "{bc_token}" tag line'
    ),
    target_fixture="gherkin_body",
)
def given_gherkin_body_with_bc_tag(bc_token: str) -> str:
    # Construct a small but well-formed gherkin body whose first line is
    # the requested @bc tag token. The body shape mirrors what the rest
    # of the suite uses so any future scenario referencing this Given
    # gets a recognizable shape.
    return (
        f"{bc_token}\n"
        f"Scenario: hash-matches-body construction\n"
        f"    Given a well-formed scenario body\n"
        f"    When I hash the body canonically\n"
        f"    Then the resulting payload validates\n"
    )


@given(
    "a hash value equal to the canonical scenario-hash of that gherkin",
    target_fixture="hash_value",
)
def given_matching_hash(gherkin_body: str) -> str:
    # Compute the hash via the same CLI boundary the production code
    # uses (subprocess to `scenarios hash`). This deliberately exercises
    # the cross-package canonicalization rule rather than recomputing
    # via the catalog's internal duplicate, so a drift on either side
    # surfaces here.
    return _scenario_hash_via_cli(gherkin_body)


@given(
    "a hash value that does not equal the canonical scenario-hash of that gherkin",
    target_fixture="hash_value",
)
def given_mismatched_hash(gherkin_body: str) -> str:
    # A fixed all-zeros hash is guaranteed non-colliding with any
    # sha256-derived 16-hex-char output for realistic bodies (and the
    # scenario_payload tests sanity-check this assumption).
    wrong = "0000000000000000"
    canonical = _scenario_hash_via_cli(gherkin_body)
    assert wrong != canonical, (
        f"wrong hash {wrong!r} collided with canonical hash; pick another"
    )
    return wrong


@when(
    "I construct a ScenarioPayload with that hash and that gherkin",
)
def when_construct_scenario_payload(
    gherkin_body: str, hash_value: str, context: dict
) -> None:
    # Happy-path construction: no expectation of ValidationError, so
    # let any pydantic exception propagate and fail the test loudly.
    payload = ScenarioPayload(hash=hash_value, gherkin=gherkin_body)
    context["scenario_payload"] = payload


@when(
    "I construct a ScenarioPayload with that hash and that gherkin via Pydantic",
)
def when_construct_scenario_payload_expecting_error(
    gherkin_body: str, hash_value: str, context: dict
) -> None:
    # Sad-path construction: capture the ValidationError so the Then
    # steps can inspect it. Not raising here would make the rejection
    # check silently incorrect; we assert the raise explicitly in the
    # Then-step below.
    try:
        ScenarioPayload(hash=hash_value, gherkin=gherkin_body)
    except ValidationError as exc:
        context["validation_error"] = exc
        return
    context["validation_error"] = None


@then(
    "construction succeeds and the parsed model has the gherkin and hash intact",
)
def then_construction_succeeds(
    gherkin_body: str, hash_value: str, context: dict
) -> None:
    payload: ScenarioPayload = context["scenario_payload"]
    assert payload.gherkin == gherkin_body
    assert payload.hash == hash_value


@then("Pydantic raises ValidationError")
def then_pydantic_raises_validation_error(context: dict) -> None:
    exc = context.get("validation_error")
    assert exc is not None, (
        "expected ScenarioPayload(...) to raise ValidationError; "
        "construction returned successfully"
    )
    assert isinstance(exc, ValidationError), (
        f"expected ValidationError; got {type(exc).__name__}: {exc!r}"
    )


@then(
    "the error message identifies that the hash does not match the gherkin body",
)
def then_error_identifies_hash_mismatch(context: dict) -> None:
    exc: ValidationError = context["validation_error"]
    msg = str(exc)
    # The diagnostic must name the field-name "hash" so a caller
    # debugging a hand-rolled payload sees which side is wrong, and
    # mention the canonical-mismatch wording so the cause is clear.
    assert "hash" in msg, f"expected error to mention hash; got:\n{msg}"
    assert "canonical" in msg or "does not match" in msg, (
        f"expected error to explain the mismatch; got:\n{msg}"
    )


@given(
    "a scenario body file containing well-formed Gherkin steps",
    target_fixture="bc_root_and_body_path",
)
def given_scenario_body_file_for_cli(tmp_path: Path) -> tuple[Path, Path]:
    # The scenario-3 round-trip needs both a BC root (where shop-msg
    # send writes the inbox YAML) and a scenario body file (the input).
    # Returning both via one target fixture keeps the subsequent steps
    # decoupled from the empty_bc / scenario_body_files context the
    # other CLI-driven scenarios share.
    bc_root = tmp_path / "bc"
    (bc_root / "inbox").mkdir(parents=True)
    (bc_root / "outbox").mkdir()
    body = (
        "Scenario: hash-matches-body round-trip\n"
        "    Given a well-formed scenario body\n"
        "    When I send it through shop-msg send assign_scenarios\n"
        "    Then the resulting payload validates against the schema\n"
    )
    body_path = tmp_path / "body.txt"
    body_path.write_text(body)
    return bc_root, body_path


@when(
    parsers.parse(
        'I invoke "{cli_phrase}" with that scenario file'
    )
)
def when_invoke_shopmsg_send_assign_scenarios(
    cli_phrase: str, bc_root_and_body_path: tuple[Path, Path], context: dict
) -> None:
    # cli_phrase is the quoted CLI invocation from the feature step. We
    # pin it to "shop-msg send assign_scenarios" so an accidental edit
    # of the feature text to invoke a different command would surface
    # here rather than silently exercising the wrong CLI path.
    assert cli_phrase == "shop-msg send assign_scenarios", (
        f"this step only handles 'shop-msg send assign_scenarios'; got {cli_phrase!r}"
    )
    bc_root, body_path = bc_root_and_body_path
    result = subprocess.run(
        [
            "shop-msg",
            "send",
            "assign_scenarios",
            "--bc-root",
            str(bc_root),
            "--work-id",
            "lead-018-roundtrip",
            "--feature-title",
            "hash matches body round-trip",
            "--bc-tag",
            "shop-msg",
            "--scenario-file",
            str(body_path),
        ],
        capture_output=True,
        text=True,
    )
    context["cli_returncode"] = result.returncode
    context["cli_stdout"] = result.stdout
    context["cli_stderr"] = result.stderr
    context["bc_root_roundtrip"] = bc_root


@then("the resulting inbox YAML deserializes into an AssignScenarios message")
def then_inbox_yaml_deserializes(context: dict) -> None:
    rc = context["cli_returncode"]
    assert rc == 0, (
        f"shop-msg exited {rc}; stderr:\n{context['cli_stderr']}"
    )
    bc_root: Path = context["bc_root_roundtrip"]
    inbox_path = bc_root / "inbox" / "lead-018-roundtrip.yaml"
    assert inbox_path.exists(), (
        f"expected {inbox_path} to exist; inbox: {list((bc_root / 'inbox').iterdir())}"
    )
    with inbox_path.open() as f:
        data = yaml.safe_load(f)
    # AssignScenarios(**data) re-validates the entire payload through
    # the Pydantic schema, which means every embedded ScenarioPayload
    # re-runs the hash↔body invariant. A drift would raise here.
    msg = AssignScenarios(**data)
    context["roundtrip_message"] = msg


@then(
    "each ScenarioPayload in that message satisfies the schema-level "
    "hash-matches-body invariant"
)
def then_each_payload_satisfies_invariant(context: dict) -> None:
    msg: AssignScenarios = context["roundtrip_message"]
    assert msg.scenarios, "expected at least one scenario in the round-trip message"
    for sp in msg.scenarios:
        # Reaching this point already implies pydantic accepted the
        # payload (the AssignScenarios re-validation in the previous
        # Then). Re-run the canonical hash via the CLI boundary to pin
        # the equality explicitly — a regression in the producer that
        # somehow bypassed the schema (e.g. constructing via
        # model_construct) would surface here.
        expected = _scenario_hash_via_cli(sp.gherkin)
        assert sp.hash == expected, (
            f"round-trip payload violates hash↔body invariant: "
            f"hash={sp.hash!r}, canonical(gherkin)={expected!r}"
        )
