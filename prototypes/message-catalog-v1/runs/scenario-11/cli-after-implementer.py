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
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

import yaml

from catalog.schemas import Clarify, RequestMaintenance, WorkDone


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

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
