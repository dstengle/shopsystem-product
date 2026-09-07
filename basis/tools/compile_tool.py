#!/usr/bin/env python3
"""Produce a framework tool's skill from what the tool says about itself.

The compiler on the compile_process.py pattern for the third source kind:
a framework tool. It asks the tool the standard question — runs it with
`--describe` — and from the answer and nothing else writes the skill at
the agent's load point (adr-2026-09-07-tool-answer §2, §3). It never
reads the tool's source or its help; how the tool composes its answer is
the tool's own.

An answer counts only when the tool exits 0 and its standard output
parses against the tool-description data type
(basis/types/tool-description.md, the versioned contract; its schema
block is read from that file — the shape has one home). Anything else
— a nonzero exit, a traceback, a usage sheet, output that does not
parse — is "cannot answer": one line on standard error, exit 1, no
skill written.

A tool that cannot answer is used through a description beside it: a
JSON file at basis/tools/descriptions/<name>.json — the home the data
type names — written by the shop that runs the tool as an instance of
the same shape, carrying `stands_beside` (the tool as the check invokes
it) and `tool_owner` (the shop that owns that tool). The skill is
produced from the file's bytes and nothing else, and the description is
the source only until the tool answers (the data type's stand-in part).
A description lacking a part yields no skill and a report naming the
tool and the part.

The skill carries `source` — the tool asked, or the description file —
and `source-digest`, `sha256:` and twelve hex digits over the source's
bytes as written; a description-sourced skill also carries
`stands-beside` and `tool-owner`. The check over the load point re-asks
the tool or re-reads the file, re-produces, and diffs.

Usage:
  compile_tool.py <source>                      # ask the tool, or read the
                                                # description, and validate;
                                                # print the skill's name, path,
                                                # and digest; write nothing
  compile_tool.py <source> --load-point <dir>   # also write <dir>/<name>/SKILL.md
  compile_tool.py --describe                    # answer the standard question
                                                # (DESCRIPTION below) as JSON on
                                                # standard output, exit 0, before
                                                # any other action
<source> is a tool — a path, or a command name found on PATH — or a
description at basis/tools/descriptions/<name>.json.
"""
import hashlib
import json
import pathlib
import re
import shutil
import subprocess
import sys

import yaml

ROOT = pathlib.Path(__file__).resolve().parent.parent.parent
DATA_TYPE = ROOT / "basis" / "types" / "tool-description.md"
DESCRIPTIONS = ROOT / "basis" / "tools" / "descriptions"
DESCRIPTIONS_REL = "basis/tools/descriptions"
DEFAULT_LOAD_POINT = ".claude/skills"
FLAG = "--describe"
TOOL = "basis/tools/compile_tool.py"

# The part each field of the shape carries, in the vocabulary's words
# (basis/experience/vocabulary.md), for a report a description's writer
# reads: the field name the data type fixes, then the part.
PARTS = {
    "name": "the name", "description": "what it does", "uses": "the uses",
    "invocation": "the exact invocation", "input_schema": "what it takes",
    "returns": "what it returns", "form": "the form of what it returns",
    "output_schema": "the shape of what it returns",
    "text": "the stated text form of what it returns",
    "failures": "how it fails", "code": "a failure's stable code",
    "exit_status": "a failure's exit status",
    "condition": "a failure's condition", "next": "a failure's next step",
    "stands_beside": "the tool it stands beside",
    "tool_owner": "the shop that owns the tool",
}

EXIT = {"usage": 2, "unreadable": 2, "no-answer": 1, "unparseable": 1,
        "unwritable": 1}


class Failure(Exception):
    """A failure the answer names: its code and a one-line message."""

    def __init__(self, code: str, message: str):
        super().__init__(message)
        self.code = code


def one_line(text) -> str:
    return " ".join(str(text).split())


def fail(code: str, message: str) -> None:
    print(f"{code}: {one_line(message)}", file=sys.stderr)
    sys.exit(EXIT[code])


# --- the answer to the standard question (adr-2026-09-07-tool-answer §2) ---

USAGE_FAILURE = {
    "code": "usage",
    "exit_status": 2,
    "condition": "the arguments are not one of the two invocations this "
                 "tool states — no source, more than one, an unknown "
                 "option, `--load-point` without a directory, or a "
                 "description path outside basis/tools/descriptions/; one "
                 "line on standard error beginning `usage:` names the "
                 "invocations; nothing is asked and nothing is written",
    "next": "run the invocation the use states, as written",
}
UNREADABLE_FAILURE = {
    "code": "unreadable",
    "exit_status": 2,
    "condition": "the source does not exist: no file at the tool's path, no "
                 "command of that name on PATH, or no description file at "
                 "the path; one line on standard error beginning "
                 "`unreadable:` names it",
    "next": "give the tool's path or command name, or the description's "
            "path under basis/tools/descriptions/, and run the invocation "
            "again",
}
NO_ANSWER_FAILURE = {
    "code": "no-answer",
    "exit_status": 1,
    "condition": "the tool gave no answer to `--describe`: it exited with "
                 "a status other than 0, did not finish within 60 seconds, "
                 "wrote output that is not JSON, or wrote JSON that does "
                 "not parse against the tool-description data type; one "
                 "line on standard error beginning `no-answer:` names the "
                 "tool and the reason — for a shape lack, the field and the "
                 "part it carries; no skill is written",
    "next": "a tool of the lead shop: make its answer parse against "
            "basis/types/tool-description.md and run the invocation "
            "again; a tool of another shop: use it through a description "
            "beside it at basis/tools/descriptions/<name>.json and record "
            "the gap to its owner",
}
UNPARSEABLE_FAILURE = {
    "code": "unparseable",
    "exit_status": 1,
    "condition": "the description is not in the answer's shape: the file "
                 "is not JSON, its `name` is not the file's stem, it lacks "
                 "`stands_beside` or `tool_owner`, or a use entry lacks a "
                 "part; one line on standard error beginning "
                 "`unparseable:` names the file, the tool it stands beside "
                 "where the file names one, the place (`uses[<i>]` and the "
                 "field), and the part that field carries; no skill is "
                 "written",
    "next": "add or repair the named part in the description — never in a "
            "skill — and run the same invocation again",
}
UNWRITABLE_FAILURE = {
    "code": "unwritable",
    "exit_status": 1,
    "condition": "the skill's directory or file under the load point could "
                 "not be created or written; one line on standard error "
                 "beginning `unwritable:` names the path and the reason",
    "next": "make the load point writable, or give one that is, and run "
            "the invocation again",
}
SOURCE_INPUT = {
    "type": "string",
    "description": "the tool to ask — the path of a tool under "
                   "basis/tools/, or the name of a command on PATH — or "
                   "the path of a description beside a tool that cannot "
                   "answer, basis/tools/descriptions/<name>.json",
}
DESCRIPTION = {
    "name": "compile-tool",
    "description": (
        "The producer of tool skills: asks a framework tool the standard "
        "question — runs it with `--describe` — or reads the description "
        "beside a tool that cannot answer, validates what it got against "
        "the tool-description data type, and produces the tool's skill at "
        "the agent's load point from that and from nothing else, stamped "
        "with a digest of the source's bytes. Use it to place or refresh a "
        "tool's skill, to check whether a tool answers or a description is "
        "in the shape, and — from the check over the load point — to ask a "
        "tool the question with the flag alone."
    ),
    "uses": [
        {
            "name": "ask",
            "description": (
                "Asks the tool `--describe` and nothing else — or reads the "
                "description file — and validates the result against the "
                "data type; prints the skill's name, the path it would take "
                "at the default load point, and the digest. Writes nothing; "
                "the tool is run for nothing but the question. Exit 0 means "
                "the tool answers, or the description is in the shape."
            ),
            "invocation": f"python3 {TOOL} <source>",
            "input_schema": {
                "type": "object",
                "properties": {"source": SOURCE_INPUT},
                "required": ["source"],
                "additionalProperties": False,
            },
            "returns": {
                "form": "text",
                "text": "one line on standard output: for a tool, "
                        "`<source>: answers as \\`<name>\\` for "
                        ".claude/skills/<name>/SKILL.md (digest <12 hex>)`; "
                        "for a description, `<source>: describes "
                        "\\`<name>\\` beside \\`<tool>\\` for "
                        ".claude/skills/<name>/SKILL.md (digest <12 hex>)`; "
                        "exit status 0",
            },
            "failures": [NO_ANSWER_FAILURE, UNPARSEABLE_FAILURE,
                         UNREADABLE_FAILURE, USAGE_FAILURE],
        },
        {
            "name": "produce",
            "description": (
                "Does what `ask` does, then writes the skill to "
                "<dir>/<name>/SKILL.md, creating the directories, "
                "overwriting whatever stands there — a hand edit included. "
                "The skill is a rendering of the answer or the description "
                "alone: front-matter with `source` and `source-digest` (and "
                "`stands-beside`, `tool-owner` for a description), then "
                "one section per use with its invocation, inputs, return, "
                "and failure table."
            ),
            "invocation": f"python3 {TOOL} <source> --load-point <dir>",
            "input_schema": {
                "type": "object",
                "properties": {
                    "source": SOURCE_INPUT,
                    "dir": {"type": "string",
                            "description": "the load point to write under: "
                                           ".claude/skills for the agent's "
                                           "load point, or a scratch "
                                           "directory to produce without "
                                           "placing"},
                },
                "required": ["source", "dir"],
                "additionalProperties": False,
            },
            "returns": {
                "form": "text",
                "text": "one line on standard output, `<dir>/<name>/SKILL.md: "
                        "generated from <name> (digest <12 hex>)`; exit "
                        "status 0; the skill written at that path",
            },
            "failures": [NO_ANSWER_FAILURE, UNPARSEABLE_FAILURE,
                         UNREADABLE_FAILURE, UNWRITABLE_FAILURE,
                         USAGE_FAILURE],
        },
    ],
}


def usage() -> None:
    fail("usage", f"python3 {TOOL} <source> [--load-point <dir>] | --describe")


# --- the contract: the data type's schema block, read from its one home ---

def schema() -> dict:
    try:
        text = DATA_TYPE.read_text()
    except OSError as exc:
        raise Failure("unreadable", f"{DATA_TYPE}: cannot be read: {exc}") from exc
    fence = re.search(r"```yaml\n(.*?)```", text, re.S)
    if not fence:
        raise Failure("unparseable", f"{DATA_TYPE}: no schema block")
    block = yaml.safe_load(fence.group(1))
    if not isinstance(block, dict) or "schema" not in block:
        raise Failure("unparseable", f"{DATA_TYPE}: schema block does not define `schema`")
    return block["schema"]


TYPES = {"object": dict, "array": list, "string": str, "integer": int,
         "boolean": bool}


def validate(node, spec: dict, where: str) -> list:
    """Check an instance against the data-type typedef's compact dialect:
    JSON Schema type names; `fields` required unless `optional: true`;
    `enum` closed; `items` for arrays; `pattern` for strings. Returns
    the violations, each naming its place and, for a lack, the part."""
    out = []
    kind = spec.get("type")
    if kind in TYPES and not isinstance(node, TYPES[kind]) \
            or (kind == "integer" and isinstance(node, bool)):
        return [f"{where}: is not {kind}"]
    if "enum" in spec and node not in spec["enum"]:
        out.append(f"{where}: `{node}` not in {spec['enum']}")
    if "pattern" in spec and isinstance(node, str) and not re.match(spec["pattern"], node):
        out.append(f"{where}: `{node}` does not match {spec['pattern']}")
    if kind == "object" and "fields" in spec:
        for name, sub in spec["fields"].items():
            if name not in node:
                if not (isinstance(sub, dict) and sub.get("optional")):
                    part = f" ({PARTS[name]})" if name in PARTS else ""
                    out.append(f"{where} lacks `{name}`{part}")
                continue
            out += validate(node[name], sub, f"{where}.{name}")
    if kind == "array" and "items" in spec:
        for i, item in enumerate(node):
            out += validate(item, spec["items"], f"{where}[{i}]")
    return out


def shape_problems(instance, top: str) -> list:
    problems = validate(instance, schema(), top)
    # The two fields the data type reserves for a description are a
    # description's shape: required of that kind, never of an answer.
    if top == "description":
        for name in ("stands_beside", "tool_owner"):
            value = instance.get(name) if isinstance(instance, dict) else None
            if not isinstance(value, str) or not value.strip():
                problems.append(f"description lacks `{name}` ({PARTS[name]})")
    return problems


# --- the first source kind: the tool's answer ---

def resolve_tool(given: str) -> pathlib.Path:
    path = pathlib.Path(given)
    if "/" in given or path.suffix == ".py":
        if not path.is_file():
            raise Failure("unreadable", f"{given}: no such tool")
        return path
    found = shutil.which(given)
    if not found:
        raise Failure("unreadable", f"{given}: no such tool on PATH")
    return pathlib.Path(found)


def ask(tool: pathlib.Path, shown: str) -> bytes:
    """Run the tool with the flag alone; return the answer's bytes as written."""
    command = [sys.executable, str(tool), FLAG] if tool.suffix == ".py" else [str(tool), FLAG]
    try:
        run = subprocess.run(command, capture_output=True, timeout=60, check=False)
    except (OSError, subprocess.TimeoutExpired) as exc:
        raise Failure("no-answer", f"{shown}: cannot answer: {one_line(exc)}") from exc
    if run.returncode != 0:
        reason = one_line(run.stderr.decode(errors="replace"))[:200] or "no message"
        raise Failure("no-answer", f"{shown}: cannot answer: exit status {run.returncode}: {reason}")
    return run.stdout


def answer_of(given: str):
    tool = resolve_tool(given)
    shown = repo_relative(tool) if "/" in given or tool.suffix == ".py" else given
    raw = ask(tool, shown)
    try:
        answer = json.loads(raw.decode())
    except (UnicodeDecodeError, ValueError) as exc:
        raise Failure("no-answer", f"{shown}: cannot answer: output does not parse as JSON: {one_line(exc)}") from exc
    problems = shape_problems(answer, "answer")
    if problems:
        raise Failure("no-answer", f"{shown}: cannot answer: does not parse against "
                      f"tool-description: " + "; ".join(problems[:5]))
    return answer, hashlib.sha256(raw).hexdigest()[:12], shown


# --- the second source kind: the description beside a tool that cannot answer ---

def is_description(given: str) -> bool:
    return given.endswith(".json")


def description_of(given: str):
    path = pathlib.Path(given)
    if path.resolve().parent != DESCRIPTIONS:
        raise Failure("usage", f"{given}: a description is read from "
                      f"{DESCRIPTIONS_REL}/<name>.json only")
    if not path.is_file():
        raise Failure("unreadable", f"{given}: no such description")
    shown = repo_relative(path)
    try:
        raw = path.read_bytes()
    except OSError as exc:
        raise Failure("unreadable", f"{shown}: cannot be read: {one_line(exc)}") from exc
    try:
        instance = json.loads(raw.decode())
    except (UnicodeDecodeError, ValueError) as exc:
        raise Failure("unparseable", f"{shown}: the description is not JSON: {one_line(exc)}") from exc
    beside = instance.get("stands_beside") if isinstance(instance, dict) else None
    beside_text = f" beside `{beside}`" if isinstance(beside, str) and beside.strip() else ""
    problems = shape_problems(instance, "description")
    if not problems and instance["name"] != path.stem:
        problems.append(f"description.name `{instance['name']}` is not the file's stem "
                        f"`{path.stem}` ({PARTS['name']})")
    if problems:
        raise Failure("unparseable", f"{shown}: the description{beside_text} is not in "
                      f"the answer's shape: " + "; ".join(problems[:5]))
    return instance, hashlib.sha256(raw).hexdigest()[:12], shown


# --- the rendering ---

def code_block(text: str, lang: str = "") -> str:
    return f"```{lang}\n{text.rstrip()}\n```"


def takes(input_schema: dict) -> list:
    props = input_schema.get("properties") or {}
    if not props:
        return ["Takes: nothing — the use has no input."]
    required = set(input_schema.get("required") or [])
    lines = ["Takes:"]
    for name, prop in props.items():
        meaning = one_line(prop.get("description", "")) if isinstance(prop, dict) else ""
        if name in required:
            omitted = "required"
        elif isinstance(prop, dict) and "default" in prop:
            omitted = f"omitted: `{json.dumps(prop['default'])}` is taken"
        else:
            omitted = "optional"
        lines.append(f"- `<{name}>` — {meaning} ({omitted})")
    return lines


def returns(spec: dict) -> list:
    form = spec.get("form")
    if form == "text":
        return [f"Returns (text): {one_line(spec.get('text', ''))}"]
    dumped = yaml.safe_dump(spec.get("output_schema", {}), sort_keys=False).rstrip()
    return [f"Returns ({form} on standard output), the shape:", "",
            code_block(dumped, "yaml")]


def fails(entries: list) -> list:
    lines = ["Fails:", "", "| code | exit status | condition | next step |", "|---|---|---|---|"]
    for f in entries:
        lines.append(f"| `{f['code']}` | {f['exit_status']} | {one_line(f['condition'])} | {one_line(f['next'])} |")
    return lines


def use_section(use: dict) -> str:
    parts = [f"## {use['name']}", "", one_line(use["description"]), "",
             "Invocation:", "", code_block(use["invocation"], "sh"), ""]
    parts += takes(use.get("input_schema") or {}) + [""]
    parts += returns(use.get("returns") or {}) + [""]
    parts += fails(use.get("failures") or [])
    return "\n".join(parts)


def render(instance: dict, source_rel: str, digest: str, description: bool) -> str:
    names = ", ".join(f"`{u['name']}`" for u in instance["uses"])
    name = instance["name"]
    if description:
        beside, owner = instance["stands_beside"], instance["tool_owner"]
        tool_text = (f"Tool: `{beside}`, owned by {owner}; it does not answer the "
                     f"standard question, so this skill is produced from the "
                     f"description beside it, `{source_rel}`.")
        title = f"# {name} (produced from the description beside `{beside}`, `{source_rel}`)"
    else:
        tool_text = f"Tool: `{source_rel}`."
        title = f"# {name} (produced from the answer of `{source_rel}`)"
    fm = {
        "name": name,
        "description": (f"{one_line(instance['description'])} {tool_text} "
                        f"Uses, each with its exact invocation below: {names}."),
        "type": "skill",
        "id": f"{name}-skill",
        "generated": True,
        "generated-by": TOOL,
        "derived-from": name,
        "source": source_rel,
        "source-digest": f"sha256:{digest}",
    }
    if description:
        fm["stands-beside"] = instance["stands_beside"]
        fm["tool-owner"] = instance["tool_owner"]
    head = [
        "---\n" + yaml.safe_dump(fm, sort_keys=False, allow_unicode=True).rstrip() + "\n---",
        title,
        one_line(instance["description"]),
        "Uses: " + ", ".join(f"[{u['name']}](#{u['name']})" for u in instance["uses"]) + ".",
    ]
    return "\n\n".join(head + [use_section(u) for u in instance["uses"]]) + "\n"


def repo_relative(path: pathlib.Path) -> str:
    full = path.resolve()
    return full.relative_to(ROOT).as_posix() if full.is_relative_to(ROOT) else path.as_posix()


def main() -> None:
    args = sys.argv[1:]
    # The standard question, answered before any other action; the other
    # arguments are ignored (adr-2026-09-07-tool-answer §2).
    if FLAG in args:
        sys.stdout.write(json.dumps(DESCRIPTION, indent=2) + "\n")
        sys.exit(0)
    load_point, positional = None, []
    i = 0
    while i < len(args):
        if args[i] == "--load-point":
            if i + 1 >= len(args):
                usage()
            load_point = pathlib.Path(args[i + 1]); i += 2
        elif args[i].startswith("--"):
            usage()
        else:
            positional.append(args[i]); i += 1
    if len(positional) != 1:
        usage()
    given = positional[0]
    try:
        description = is_description(given)
        if description:
            instance, digest, shown = description_of(given)
        else:
            instance, digest, shown = answer_of(given)
        text = render(instance, shown, digest, description)
    except Failure as exc:
        fail(exc.code, str(exc))
    except Exception as exc:  # noqa: BLE001 — never a traceback
        fail("no-answer" if not is_description(given) else "unparseable",
             f"{given}: does not compile: {type(exc).__name__}: {one_line(exc)}")
    name = instance["name"]
    if load_point is None:
        if description:
            print(f"{shown}: describes `{name}` beside `{instance['stands_beside']}` "
                  f"for {DEFAULT_LOAD_POINT}/{name}/SKILL.md (digest {digest})")
        else:
            print(f"{shown}: answers as `{name}` for {DEFAULT_LOAD_POINT}/{name}/SKILL.md (digest {digest})")
        return
    out = load_point / name / "SKILL.md"
    try:
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(text)
    except OSError as exc:
        fail("unwritable", f"{out}: cannot be written: {exc}")
    print(f"{out}: generated from {name} (digest {digest})")


if __name__ == "__main__":
    main()
