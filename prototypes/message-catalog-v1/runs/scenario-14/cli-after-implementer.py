"""shop-msg CLI entry point.

Subcommands:
    respond clarify --bc-root PATH --work-id ID --question TEXT
        Writes <bc-root>/outbox/<work_id>-clarify.yaml as a valid
        Clarify message (schema from the prototype's shared schemas
        module).
    respond work_done --bc-root PATH --work-id ID --status STATUS
                      [--scenario-hash HASH ...] [--summary TEXT]
        Writes <bc-root>/outbox/<work_id>-work_done.yaml as a valid
        WorkDone message.
    send request_maintenance --bc-root PATH --work-id ID --description TEXT
                             [--acceptance-criterion TEXT ...]
                             [--file-hint TEXT ...]
        Writes <bc-root>/inbox/<work_id>.yaml as a valid
        RequestMaintenance message.
    send assign_scenarios --bc-root PATH --work-id ID --feature-title TEXT
                          --bc-tag NAME --scenario-file PATH ...
        Writes <bc-root>/inbox/<work_id>.yaml as a valid
        AssignScenarios message. Each --scenario-file becomes one
        ScenarioPayload. The hash for each scenario is computed by
        shelling out to the `scenarios hash` CLI (the canonicalization
        rule lives in the scenarios package, not here).
    send request_bugfix --bc-root PATH --work-id ID --description TEXT
                        [--feature-title TEXT --bc-tag NAME
                         --scenario-file PATH ...]
        Writes <bc-root>/inbox/<work_id>.yaml as a valid
        RequestBugfix message. Scenarios are optional: with none the
        message carries description-only fix instructions. If any
        --scenario-file is supplied, --feature-title and --bc-tag
        become required (they wrap each scenario body the same way
        assign_scenarios does).
    read outbox --bc-root PATH --work-id ID
        Reads the latest <bc-root>/outbox/<work_id>-*.yaml, validates it
        against the BCResponse union, and dumps the canonical YAML to
        stdout. Exits non-zero (with a stderr message) when no outbox
        file matches the work_id or validation fails.
"""
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

import yaml

from pydantic import TypeAdapter, ValidationError

from catalog.schemas import (
    AssignScenarios,
    BCResponse,
    Clarify,
    RequestBugfix,
    RequestMaintenance,
    ScenarioPayload,
    WorkDone,
)

_response_adapter = TypeAdapter(BCResponse)


def _compute_scenario_hash(gherkin_body: str) -> str:
    """Shell out to `scenarios hash` to canonicalize and hash a scenario body.

    The package boundary is intentional: the canonicalization rule belongs
    to the scenarios package, and shop-msg composes it as an external tool
    just like any other consumer would.
    """
    result = subprocess.run(
        ["scenarios", "hash"],
        input=gherkin_body,
        capture_output=True,
        text=True,
        check=True,
    )
    return result.stdout.strip()


def _cmd_respond_clarify(args: argparse.Namespace) -> int:
    bc_root = Path(args.bc_root)
    outbox = bc_root / "outbox"
    outbox.mkdir(parents=True, exist_ok=True)

    out_path = outbox / f"{args.work_id}-clarify.yaml"
    if out_path.exists():
        # Refuse to overwrite an existing outbox file for this work_id.
        # The §4.4 loop (BC clarify -> lead request_bugfix -> BC may
        # clarify again on the same work_id) recurs at exactly this
        # boundary; silent overwrite would destroy the prior clarify.
        print(
            f"shop-msg respond clarify: refusing to overwrite existing outbox file: {out_path}",
            file=sys.stderr,
        )
        return 1

    message = Clarify(
        message_type="clarify",
        work_id=args.work_id,
        question=args.question,
    )

    with out_path.open("w") as f:
        yaml.safe_dump(message.model_dump(), f, sort_keys=False)
    return 0


def _cmd_respond_work_done(args: argparse.Namespace) -> int:
    bc_root = Path(args.bc_root)
    outbox = bc_root / "outbox"
    outbox.mkdir(parents=True, exist_ok=True)

    out_path = outbox / f"{args.work_id}-work_done.yaml"
    if out_path.exists():
        # Refuse to overwrite an existing work_done file for this work_id.
        # Same reasoning as the clarify collision check: silently
        # clobbering a prior reply destroys the lead's reconciliation
        # record for that work_id.
        print(
            f"shop-msg respond work_done: refusing to overwrite existing outbox file: {out_path}",
            file=sys.stderr,
        )
        return 1

    message = WorkDone(
        message_type="work_done",
        work_id=args.work_id,
        status=args.status,
        summary=args.summary,
        scenario_hashes=list(args.scenario_hash or []),
    )

    with out_path.open("w") as f:
        yaml.safe_dump(message.model_dump(), f, sort_keys=False)
    return 0


def _cmd_send_request_maintenance(args: argparse.Namespace) -> int:
    bc_root = Path(args.bc_root)
    inbox = bc_root / "inbox"
    inbox.mkdir(parents=True, exist_ok=True)

    out_path = inbox / f"{args.work_id}.yaml"
    if out_path.exists():
        # Refuse to overwrite an existing inbox file for this work_id.
        # Same reasoning as the outbox collision checks: the lead sends one
        # message per work_id, and silently clobbering a prior message
        # destroys the BC's record of what was asked.
        print(
            f"shop-msg send request_maintenance: refusing to overwrite existing inbox file: {out_path}",
            file=sys.stderr,
        )
        return 1

    acceptance_criteria = list(args.acceptance_criterion or []) or None
    file_hints = list(args.file_hint or []) or None

    message = RequestMaintenance(
        message_type="request_maintenance",
        work_id=args.work_id,
        description=args.description,
        acceptance_criteria=acceptance_criteria,
        file_hints=file_hints,
    )

    with out_path.open("w") as f:
        yaml.safe_dump(message.model_dump(exclude_none=True), f, sort_keys=False)
    return 0


def _build_scenario_payload(
    path_str: str, feature_title: str, bc_tag: str
) -> ScenarioPayload:
    """Read a scenario body file, hash it, and wrap it with the standard
    Feature header and tags. Shared between assign_scenarios and
    request_bugfix because both messages embed the same ScenarioPayload
    shape.
    """
    body = Path(path_str).read_text()
    scen_hash = _compute_scenario_hash(body)
    tags = [f"@scenario_hash:{scen_hash}", f"@bc:{bc_tag}"]
    tagged = (
        f"Feature: {feature_title}\n"
        f"\n"
        f"  {' '.join(tags)}\n"
        f"  {body}\n"
    )
    return ScenarioPayload(hash=scen_hash, tags=tags, gherkin=tagged)


def _cmd_send_request_bugfix(args: argparse.Namespace) -> int:
    bc_root = Path(args.bc_root)
    inbox = bc_root / "inbox"
    inbox.mkdir(parents=True, exist_ok=True)

    out_path = inbox / f"{args.work_id}.yaml"
    if out_path.exists():
        # Refuse to overwrite an existing inbox file for this work_id.
        # Same reasoning as the other send-collision checks: silent
        # clobber would destroy the BC's record of what was asked.
        print(
            f"shop-msg send request_bugfix: refusing to overwrite existing inbox file: {out_path}",
            file=sys.stderr,
        )
        return 1

    scenario_files = list(args.scenario_file or [])
    # --feature-title and --bc-tag are conditionally required: only when
    # at least one --scenario-file is supplied. argparse cannot express
    # "required iff" directly, so enforce post-parse here.
    if scenario_files and (args.feature_title is None or args.bc_tag is None):
        print(
            "shop-msg send request_bugfix: --feature-title and --bc-tag are "
            "required when --scenario-file is supplied",
            file=sys.stderr,
        )
        return 2

    scenarios_payload: list[ScenarioPayload] = [
        _build_scenario_payload(path_str, args.feature_title, args.bc_tag)
        for path_str in scenario_files
    ]

    message = RequestBugfix(
        message_type="request_bugfix",
        work_id=args.work_id,
        description=args.description,
        scenarios=scenarios_payload,
    )

    with out_path.open("w") as f:
        yaml.safe_dump(message.model_dump(), f, sort_keys=False)
    return 0


def _cmd_send_assign_scenarios(args: argparse.Namespace) -> int:
    bc_root = Path(args.bc_root)
    inbox = bc_root / "inbox"
    inbox.mkdir(parents=True, exist_ok=True)

    out_path = inbox / f"{args.work_id}.yaml"
    if out_path.exists():
        # Refuse to overwrite an existing inbox file for this work_id.
        # Same reasoning as the request_maintenance collision check: the
        # lead sends one message per work_id; silent clobber would
        # destroy the BC's record of what was asked.
        print(
            f"shop-msg send assign_scenarios: refusing to overwrite existing inbox file: {out_path}",
            file=sys.stderr,
        )
        return 1

    scenario_files = list(args.scenario_file or [])
    scenarios_payload: list[ScenarioPayload] = [
        _build_scenario_payload(path_str, args.feature_title, args.bc_tag)
        for path_str in scenario_files
    ]

    message = AssignScenarios(
        message_type="assign_scenarios",
        work_id=args.work_id,
        scenarios=scenarios_payload,
    )

    with out_path.open("w") as f:
        yaml.safe_dump(message.model_dump(), f, sort_keys=False)
    return 0


def _cmd_read_outbox(args: argparse.Namespace) -> int:
    bc_root = Path(args.bc_root)
    outbox = bc_root / "outbox"
    candidates = sorted(outbox.glob(f"{args.work_id}-*.yaml"))
    if not candidates:
        print(
            f"shop-msg read outbox: no outbox response found for "
            f"work_id={args.work_id!r} in {outbox}",
            file=sys.stderr,
        )
        return 1
    path = candidates[-1]
    raw = yaml.safe_load(path.read_text())
    try:
        message = _response_adapter.validate_python(raw)
    except ValidationError as e:
        print(
            f"shop-msg read outbox: validation failed for {path.name}:\n{e}",
            file=sys.stderr,
        )
        return 1
    print(f"valid {message.message_type} from {path.name}:")
    print(yaml.safe_dump(message.model_dump(exclude_none=True), sort_keys=False))
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="shop-msg")
    sub = parser.add_subparsers(dest="command", required=True)

    respond = sub.add_parser("respond", help="write a BC response message")
    respond_sub = respond.add_subparsers(dest="response_type", required=True)

    clarify = respond_sub.add_parser("clarify", help="write a clarify response")
    clarify.add_argument("--bc-root", required=True, help="BC root directory")
    clarify.add_argument("--work-id", required=True, help="work_id from the lead message")
    clarify.add_argument("--question", required=True, help="clarifying question text")
    clarify.set_defaults(func=_cmd_respond_clarify)

    work_done = respond_sub.add_parser("work_done", help="write a work_done response")
    work_done.add_argument("--bc-root", required=True, help="BC root directory")
    work_done.add_argument("--work-id", required=True, help="work_id from the lead message")
    work_done.add_argument(
        "--status",
        required=True,
        choices=["complete", "partial", "blocked"],
        help="work_done status",
    )
    work_done.add_argument(
        "--scenario-hash",
        action="append",
        default=None,
        help="scenario hash echoed back to the lead (repeatable)",
    )
    work_done.add_argument(
        "--summary",
        default=None,
        help="optional free-form summary of what was done",
    )
    work_done.set_defaults(func=_cmd_respond_work_done)

    send = sub.add_parser("send", help="write a lead-to-BC message into a BC's inbox")
    send_sub = send.add_subparsers(dest="message_type", required=True)

    request_maintenance = send_sub.add_parser(
        "request_maintenance", help="write a request_maintenance message"
    )
    request_maintenance.add_argument("--bc-root", required=True, help="BC root directory")
    request_maintenance.add_argument(
        "--work-id", required=True, help="work_id identifying this assignment"
    )
    request_maintenance.add_argument(
        "--description", required=True, help="description of the work being requested"
    )
    request_maintenance.add_argument(
        "--acceptance-criterion",
        action="append",
        default=None,
        help="measurable acceptance criterion (repeatable)",
    )
    request_maintenance.add_argument(
        "--file-hint",
        action="append",
        default=None,
        help="file path hint relevant to the work (repeatable)",
    )
    request_maintenance.set_defaults(func=_cmd_send_request_maintenance)

    assign_scenarios = send_sub.add_parser(
        "assign_scenarios", help="write an assign_scenarios message"
    )
    assign_scenarios.add_argument("--bc-root", required=True, help="BC root directory")
    assign_scenarios.add_argument(
        "--work-id", required=True, help="work_id identifying this assignment"
    )
    assign_scenarios.add_argument(
        "--feature-title",
        required=True,
        help="title used in the wrapping `Feature:` line for each scenario",
    )
    assign_scenarios.add_argument(
        "--bc-tag",
        required=True,
        help="BC name used in the @bc:<name> scenario tag",
    )
    assign_scenarios.add_argument(
        "--scenario-file",
        action="append",
        default=None,
        required=True,
        help="path to a file containing one scenario body (repeatable)",
    )
    assign_scenarios.set_defaults(func=_cmd_send_assign_scenarios)

    request_bugfix = send_sub.add_parser(
        "request_bugfix", help="write a request_bugfix message"
    )
    request_bugfix.add_argument("--bc-root", required=True, help="BC root directory")
    request_bugfix.add_argument(
        "--work-id", required=True, help="work_id identifying this assignment"
    )
    request_bugfix.add_argument(
        "--description",
        required=True,
        help="plain-language description of the fix",
    )
    request_bugfix.add_argument(
        "--feature-title",
        default=None,
        help=(
            "title used in the wrapping `Feature:` line for each scenario; "
            "required iff at least one --scenario-file is supplied"
        ),
    )
    request_bugfix.add_argument(
        "--bc-tag",
        default=None,
        help=(
            "BC name used in the @bc:<name> scenario tag; required iff "
            "at least one --scenario-file is supplied"
        ),
    )
    request_bugfix.add_argument(
        "--scenario-file",
        action="append",
        default=None,
        help="path to a file containing one scenario body (repeatable, optional)",
    )
    request_bugfix.set_defaults(func=_cmd_send_request_bugfix)

    read = sub.add_parser("read", help="read a message from a BC's mailboxes")
    read_sub = read.add_subparsers(dest="read_target", required=True)

    read_outbox = read_sub.add_parser(
        "outbox", help="read and validate a BC response from its outbox"
    )
    read_outbox.add_argument("--bc-root", required=True, help="BC root directory")
    read_outbox.add_argument(
        "--work-id", required=True, help="work_id whose response to read"
    )
    read_outbox.set_defaults(func=_cmd_read_outbox)

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
