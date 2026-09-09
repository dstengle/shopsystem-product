#!/usr/bin/env python3
"""Sum an initiative's run cost, on request.

Sibling of write_cost_rows.py, for adr-2026-09-08-run-cost-artifact and
adr-2026-09-08-run-cost-initiative-scope (D1, D2): reads no execution
of its own, writes nothing, and runs only when invoked by hand or
through this invocation — never a process step. A leaf initiative (one
no other initiative names as `parent`) sums the rows of every run-cost
artifact under `sessions/` whose bead names it, read from the bead's
own `start` comment, beside the process id write_cost_rows.py already
reads there — never from run-cost's own frontmatter. A parent
initiative (one or more other initiatives name it as `parent`) sums
its children's own rollups, computed the same way, never re-reading a
child's raw rows. No model computes a figure; a column no contributing
row supplied is left blank.

Usage:
  rollup_cost.py <initiative_id>    # print the rollup for the named
                                    # initiative (its id, e.g.
                                    # init-run-measurement); leaf or
                                    # parent decided from the corpus
  rollup_cost.py --describe        # answer the standard question
                                    # (DESCRIPTION below) as JSON on
                                    # standard output, exit 0, before
                                    # any other action

On success: one line, the sum. Every failure is one line on standard
error beginning with its code from the tool-description data type's
closed set, never a traceback.
"""
import json
import pathlib
import re
import subprocess
import sys

import yaml

TOOL = "basis/tools/rollup_cost.py"
REPO = pathlib.Path(__file__).resolve().parent.parent.parent
EXIT = {"usage": 2, "unreadable": 2, "unparseable": 1}

FIELDS = ["minutes", "tokens", "tool_uses"]
COLUMNS = {"minutes": "Minutes", "tokens": "Tokens", "tool_uses": "Tool uses"}


def fail(code: str, message: str) -> None:
    print(f"{code}: {' '.join(str(message).split())}", file=sys.stderr)
    sys.exit(EXIT[code])


DESCRIPTION = {
    "name": "rollup-cost",
    "description": (
        "Sums one initiative's run cost on request: a leaf initiative "
        "from the run-cost rows of every session whose bead names it, "
        "a parent initiative from its children's own rollups. No model "
        "computes a figure; never runs as a process step."
    ),
    "uses": [
        {
            "name": "sum",
            "description": (
                "Reads the named initiative's children from every "
                "initiative's `parent` field (a parent), or every "
                "run-cost artifact under sessions/ whose bead's start "
                "comment names it (a leaf), and prints the sum. Writes "
                "nothing; a column no contributing row supplied is left "
                "blank."
            ),
            "invocation": "python3 basis/tools/rollup_cost.py <initiative_id>",
            "input_schema": {
                "type": "object",
                "properties": {
                    "initiative_id": {
                        "type": "string",
                        "description": (
                            "the initiative's own id, e.g. "
                            "init-run-measurement; its file is "
                            "initiatives/<initiative_id>.md"
                        ),
                    },
                },
                "required": ["initiative_id"],
                "additionalProperties": False,
            },
            "returns": {
                "form": "text",
                "text": (
                    "one line, `<id> (<kind>): minutes=<n> tokens=<n> "
                    "tool_uses=<n> sources=<n>` — <kind> is leaf or "
                    "parent, <n> for a field blank when no contributing "
                    "row supplied it, sources the session count (leaf) "
                    "or child count (parent); exit status 0"
                ),
            },
            "failures": [
                {
                    "code": "unreadable",
                    "exit_status": 2,
                    "condition": (
                        "no initiatives/<initiative_id>.md exists, or a "
                        "run-cost artifact's bead could not be read "
                        "(`bd comments <anchor> --json` failed); one "
                        "line on standard error beginning "
                        "`unreadable:` names what could not be read; "
                        "nothing is printed"
                    ),
                    "next": (
                        "give the id of an initiative under initiatives/, "
                        "or repair the named bead, and run the "
                        "invocation again"
                    ),
                },
                {
                    "code": "unparseable",
                    "exit_status": 1,
                    "condition": (
                        "an initiative's frontmatter, a run-cost "
                        "artifact's Rows table, or a bead's answer does "
                        "not parse; one line on standard error beginning "
                        "`unparseable:` names the file and the defect; "
                        "nothing is printed"
                    ),
                    "next": (
                        "repair the named file and run the invocation "
                        "again"
                    ),
                },
                {
                    "code": "usage",
                    "exit_status": 2,
                    "condition": (
                        "the arguments are not one of the two "
                        "invocations this tool states; one line on "
                        "standard error beginning `usage:` names them; "
                        "nothing is printed"
                    ),
                    "next": "run the invocation the use states, as written",
                },
            ],
        }
    ],
}

ROW_RE = re.compile(r"^\|(.+)\|\s*$")
SEP_RE = re.compile(r"^\|[\s:|-]+\|\s*$")
INITIATIVE_LINE_RE = re.compile(r"^\s*initiative:\s*(\S.*?)\s*$", re.M)


def frontmatter(path: pathlib.Path) -> dict:
    text = path.read_text()
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not m:
        fail("unparseable", f"{path}: no frontmatter block")
    try:
        fm = yaml.safe_load(m.group(1))
    except yaml.YAMLError as exc:
        fail("unparseable", f"{path}: frontmatter does not parse: {exc}")
    if not isinstance(fm, dict):
        fail("unparseable", f"{path}: frontmatter is not a mapping")
    return fm


def to_number(cell: str, as_float: bool):
    cell = cell.strip()
    if not cell:
        return None
    return float(cell) if as_float else int(cell)


def parse_rows(path: pathlib.Path) -> list:
    """Rows read by the run-cost typedef's own column names (v5) — never
    by position: a header naming `Tokens` and `Tool uses` may sit at any
    position the typedef's Rows table carries them at."""
    text = path.read_text()
    section = text.split("## Rows", 1)
    if len(section) != 2:
        fail("unparseable", f"{path}: no `## Rows` section")
    rows = []
    header = None
    col_index = {}
    for line in section[1].splitlines():
        if not ROW_RE.match(line):
            if header is not None:
                break
            continue
        if header is None:
            header = [c.strip() for c in line.strip().strip("|").split("|")]
            for field, column in COLUMNS.items():
                if column not in header:
                    fail(
                        "unparseable",
                        f"{path}: Rows table carries no {column!r} column",
                    )
                col_index[field] = header.index(column)
            continue
        if SEP_RE.match(line):
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) != len(header):
            fail(
                "unparseable",
                f"{path}: row does not carry {len(header)} columns: {line!r}",
            )
        rows.append({
            field: to_number(cells[idx], field == "minutes")
            for field, idx in col_index.items()
        })
    return rows


def anchor_initiative(anchor_id: str) -> str:
    """The id the anchor's start comment names as its initiative, or
    "" when it names none."""
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
    events = sorted(comments, key=lambda c: c["created_at"])
    start_text = events[0]["text"]
    m = INITIATIVE_LINE_RE.search(start_text)
    if not m:
        return ""
    return pathlib.Path(m.group(1)).stem


def children_of(initiative_id: str) -> list:
    out = []
    for path in sorted((REPO / "initiatives").glob("*.md")):
        fm = frontmatter(path)
        if fm.get("parent") == initiative_id:
            out.append(fm.get("id") or path.stem)
    return out


def leaf_totals(initiative_id: str):
    total = {f: 0 for f in FIELDS}
    present = {f: False for f in FIELDS}
    sources = []
    for cost_path in sorted((REPO / "sessions").glob("*-cost.md")):
        fm = frontmatter(cost_path)
        anchor = fm.get("anchor") or ""
        if not anchor:
            continue
        if anchor_initiative(anchor) != initiative_id:
            continue
        sources.append(cost_path.name)
        for row in parse_rows(cost_path):
            for f in FIELDS:
                if row[f] is not None:
                    total[f] += row[f]
                    present[f] = True
    return total, present, sources


def rollup(initiative_id: str):
    if not (REPO / "initiatives" / f"{initiative_id}.md").exists():
        fail("unreadable", f"initiatives/{initiative_id}.md does not exist")
    kids = children_of(initiative_id)
    if kids:
        total = {f: 0 for f in FIELDS}
        present = {f: False for f in FIELDS}
        for kid in kids:
            ctotal, cpresent, _, _ = rollup(kid)
            for f in FIELDS:
                if cpresent[f]:
                    total[f] += ctotal[f]
                    present[f] = True
        return total, present, "parent", kids
    total, present, sources = leaf_totals(initiative_id)
    return total, present, "leaf", sources


def blank(present: bool, value):
    if not present:
        return ""
    return round(value, 1) if isinstance(value, float) else value


def main(argv):
    if argv[:1] == ["--describe"]:
        print(json.dumps(DESCRIPTION, indent=2))
        return 0
    if len(argv) != 1:
        fail("usage", f"{TOOL} <initiative_id> | --describe")
    initiative_id = argv[0]
    total, present, kind, sources = rollup(initiative_id)
    parts = [f"{f}={blank(present[f], total[f])}" for f in FIELDS]
    print(
        f"{initiative_id} ({kind}): {' '.join(parts)} sources={len(sources)}"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
