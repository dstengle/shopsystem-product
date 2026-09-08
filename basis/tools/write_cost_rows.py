#!/usr/bin/env python3
"""Write the cost rows for one session's close.

Sibling of compile_process.py and the other interim tools: the lead
shop's own tool for adr-2026-09-08-run-cost-artifact. Reads a run's
anchor — a `bd` work item — and writes one row per agent run beside
the session record it closes, without a model.

A row is written only for a step the anchor records whose process
definition names it `execution: agent` or `execution: human`, and for
the router's own top-level turns between such steps (the anchor's
`context` comments, the harness's own usage report). A runtime step,
and a sub-process step (it opens its own anchor), get no row. Minutes
is the wall-clock span between a step's own anchor event and the
event immediately before it. A field the harness's usage report does
not expose for a run is left blank, never estimated.

No anchor is not an error: a session no process definition moved
through the router has none to key a row on (out of scope, per
feat-run-measurement's Edges), and this tool writes nothing.

Usage:
  write_cost_rows.py <session_id> --anchor <anchor_id>
                                     # write sessions/<session_id>-cost.md
                                     # from the anchor's `bd` comments;
                                     # <anchor_id> "" (or omitted) writes
                                     # nothing, prints nothing, exit 0
  write_cost_rows.py --describe     # answer the standard question
                                     # (DESCRIPTION below) as JSON on
                                     # standard output, exit 0, before
                                     # any other action

On success: nothing printed for an empty anchor; otherwise one line,
the path written. Every failure is one line on standard error
beginning with its code from the tool-description data type's closed
set, never a traceback.
"""
import json
import pathlib
import re
import subprocess
import sys
from datetime import datetime, timezone

import yaml

TOOL = "basis/tools/write_cost_rows.py"
REPO = pathlib.Path(__file__).resolve().parent.parent.parent
EXIT = {"usage": 2, "unreadable": 2, "unparseable": 1, "unwritable": 1}


def fail(code: str, message: str) -> None:
    print(f"{code}: {' '.join(str(message).split())}", file=sys.stderr)
    sys.exit(EXIT[code])


DESCRIPTION = {
    "name": "write-cost-rows",
    "description": (
        "Reads one run's anchor (a `bd` work item) and the harness's own "
        "usage report recorded on it, and writes the cost rows for that "
        "session's close beside the session record: one row per agent or "
        "human step and per top-level router turn, naming its step, role, "
        "wall-clock minutes, context tokens, output tokens, and tool uses "
        "— a field the usage report does not expose left blank, never "
        "estimated. No model computes a row. Use it from "
        "session-handoff-process's write-cost-rows step; an empty anchor "
        "writes nothing."
    ),
    "uses": [
        {
            "name": "produce",
            "description": (
                "Reads the anchor's comments and, for each step they "
                "record, the role and execution the named process "
                "definition gives that step; writes "
                "sessions/<session_id>-cost.md, creating the directory, "
                "overwriting what stands there. An empty or absent anchor "
                "writes nothing and prints nothing."
            ),
            "invocation": (
                "python3 basis/tools/write_cost_rows.py <session_id> "
                "--anchor <anchor_id>"
            ),
            "input_schema": {
                "type": "object",
                "properties": {
                    "session_id": {
                        "type": "string",
                        "description": (
                            "the session record's own id, e.g. "
                            "sess-2026-09-08-a; the cost file pairs with "
                            "sessions/<session_id>.md"
                        ),
                    },
                    "anchor_id": {
                        "type": "string",
                        "description": (
                            "the bd work item id the run passed through "
                            "the router on; empty (the default) means no "
                            "anchor exists for this session"
                        ),
                        "default": "",
                    },
                },
                "required": ["session_id"],
                "additionalProperties": False,
            },
            "returns": {
                "form": "text",
                "text": (
                    "one line, the path written "
                    "(sessions/<session_id>-cost.md), on a non-empty "
                    "anchor; nothing on an empty one; exit status 0"
                ),
            },
            "failures": [
                {
                    "code": "unreadable",
                    "exit_status": 2,
                    "condition": (
                        "`bd comments <anchor_id> --json` failed — no such "
                        "work item, or bd itself errored; one line on "
                        "standard error beginning `unreadable:` names the "
                        "anchor and bd's own message; nothing is written"
                    ),
                    "next": (
                        "give the id of an anchor bd holds, or omit "
                        "--anchor, and run the invocation again"
                    ),
                },
                {
                    "code": "unparseable",
                    "exit_status": 1,
                    "condition": (
                        "the anchor's first comment names no process id "
                        "ending `-process`, or no file under "
                        "basis/processes/ carries that id, or that "
                        "definition's Steps yaml block does not parse; one "
                        "line on standard error beginning `unparseable:` "
                        "names the anchor and the defect; nothing is "
                        "written"
                    ),
                    "next": (
                        "repair the anchor's start comment or the named "
                        "process definition, and run the invocation again"
                    ),
                },
                {
                    "code": "unwritable",
                    "exit_status": 1,
                    "condition": (
                        "sessions/<session_id>-cost.md could not be "
                        "written; one line on standard error beginning "
                        "`unwritable:` names the path and the reason"
                    ),
                    "next": "make the path writable and run the invocation again",
                },
                {
                    "code": "usage",
                    "exit_status": 2,
                    "condition": (
                        "the arguments are not one of the two invocations "
                        "this tool states; one line on standard error "
                        "beginning `usage:` names them; nothing is written"
                    ),
                    "next": "run the invocation the use states, as written",
                },
            ],
        }
    ],
}

STEP_RE = re.compile(r"^step\s+(\S+)")
PROCESS_RE = re.compile(r"\b([a-z][a-z0-9-]*-process)\b")
QUAD_RE = re.compile(
    r"input\s+(\d+),\s*cache-creation\s+(\d+),\s*cache-read\s+(\d+),"
    r"\s*output\s+(\d+)"
)


def parse_ts(value: str) -> datetime:
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def step_map(process_id: str) -> dict:
    """id -> {role, execution} for every step of the named process, read
    from its Steps yaml block. `unparseable` on any defect."""
    for path in sorted((REPO / "basis" / "processes").glob("*.md")):
        text = path.read_text()
        m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
        if not m:
            continue
        try:
            fm = yaml.safe_load(m.group(1))
        except yaml.YAMLError:
            continue
        if not isinstance(fm, dict) or fm.get("id") != process_id:
            continue
        steps_section = text.split("## Steps", 1)
        if len(steps_section) != 2:
            fail("unparseable", f"{path}: no `## Steps` section")
        block = re.search(r"```yaml\n(.*?)\n```", steps_section[1], re.S)
        if not block:
            fail("unparseable", f"{path}: no yaml block under `## Steps`")
        try:
            data = yaml.safe_load(block.group(1))
        except yaml.YAMLError as exc:
            fail("unparseable", f"{path}: Steps yaml does not parse: {exc}")
        out = {}
        for step in data.get("steps", []):
            run_by = step.get("run-by", {})
            out[step["id"]] = {
                "role": run_by.get("role", run_by.get("execution", "")),
                "execution": run_by.get("execution", ""),
            }
        return out
    fail("unparseable", f"no basis/processes/*.md carries id {process_id}")


def blank(n):
    return "" if n is None else str(n)


def produce(session_id: str, anchor_id: str) -> None:
    if not anchor_id:
        return  # no anchor: nothing to read, nothing written (out of scope)

    proc = subprocess.run(
        ["bd", "comments", anchor_id, "--json"],
        capture_output=True, text=True, cwd=REPO,
    )
    if proc.returncode != 0:
        fail("unreadable", f"{anchor_id}: {proc.stderr.strip() or 'bd comments failed'}")
    try:
        comments = json.loads(proc.stdout)
    except json.JSONDecodeError as exc:
        fail("unreadable", f"{anchor_id}: bd's answer does not parse as json: {exc}")
    if not comments:
        fail("unreadable", f"{anchor_id}: no comments on the anchor")

    events = [(parse_ts(c["created_at"]), c["text"]) for c in comments]
    events.sort(key=lambda e: e[0])

    start_text = events[0][1]
    pm = PROCESS_RE.search(start_text)
    if not pm:
        fail("unparseable", f"{anchor_id}: the start comment names no *-process id")
    steps = step_map(pm.group(1))

    rows = []  # each: [step, role, minutes, ctx, out, tools]
    row_by_step_id = {}
    segment_start = events[0][0]

    for i, (ts, text) in enumerate(events):
        first_line = text.splitlines()[0].strip()
        sm = STEP_RE.match(first_line)
        if sm:
            step_id = sm.group(1)
            defn = steps.get(step_id)
            if defn and defn["execution"] in ("agent", "human"):
                minutes = round((ts - events[i - 1][0]).total_seconds() / 60, 1)
                row = [step_id, defn["role"] or defn["execution"], minutes, None, None, None]
                rows.append(row)
                row_by_step_id.setdefault(step_id, []).append((ts, row))
            continue
        if first_line.startswith("context"):
            quads = QUAD_RE.findall(text)
            label_m = re.search(r"context \(([^)]*)\)", text)
            label = f"router: {label_m.group(1)}" if label_m else "router turn"
            router_in, router_cc, router_cr, router_out = (int(x) for x in quads[0])
            minutes = round((ts - segment_start).total_seconds() / 60, 1)
            rows.append([
                label, "router", minutes,
                router_in + router_cc + router_cr, router_out, None,
            ])
            if len(quads) > 1:
                agent_rows_here = [
                    r for (rts, r) in [
                        (rts, r) for step_rows in row_by_step_id.values()
                        for (rts, r) in step_rows
                    ]
                    if segment_start <= rts <= ts and steps.get(r[0], {}).get("execution") == "agent"
                ]
                if len(agent_rows_here) == 1:
                    sub_in, sub_cc, sub_cr, sub_out = (int(x) for x in quads[1])
                    agent_rows_here[0][3] = sub_in + sub_cc + sub_cr
                    agent_rows_here[0][4] = sub_out
            segment_start = ts

    out_path = REPO / "sessions" / f"{session_id}-cost.md"
    lines = [
        "---",
        "type: run-cost",
        f"id: {session_id}-cost",
        f"session: sessions/{session_id}.md",
        f"anchor: {anchor_id}",
        f"created: {datetime.now(timezone.utc).date()}",
        f"updated: {datetime.now(timezone.utc).date()}",
        "---",
        "",
        f"# Run cost: {session_id}",
        "",
        "Cost rows for the agent runs recorded on the anchor above, read "
        "without a model. A blank field is one the harness's usage report "
        "did not expose for that run.",
        "",
        "## Rows",
        "",
        "| Step | Role | Minutes | Context tokens | Output tokens | Tool uses |",
        "|---|---|---|---|---|---|",
    ]
    for step, role, minutes, ctx, outp, tools in rows:
        lines.append(f"| {step} | {role} | {minutes} | {blank(ctx)} | {blank(outp)} | {blank(tools)} |")
    lines.append("")
    try:
        out_path.parent.mkdir(parents=True, exist_ok=True)
        out_path.write_text("\n".join(lines))
    except OSError as exc:
        fail("unwritable", f"{out_path}: {exc}")
    print(f"sessions/{session_id}-cost.md")


def main(argv):
    if argv[:1] == ["--describe"]:
        print(json.dumps(DESCRIPTION, indent=2))
        return 0
    args = list(argv)
    anchor = ""
    positional = []
    i = 0
    while i < len(args):
        if args[i] == "--anchor":
            if i + 1 >= len(args):
                fail("usage", "--anchor needs a value")
            anchor = args[i + 1]
            i += 2
            continue
        positional.append(args[i])
        i += 1
    if len(positional) != 1:
        fail("usage", f"{TOOL} <session_id> [--anchor <anchor_id>] | --describe")
    produce(positional[0], anchor)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
