#!/usr/bin/env python3
"""Produce a framework tool's skill from the tool's own answer.

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

The skill carries `source`, the tool asked, and `source-digest`,
`sha256:` and twelve hex digits over the answer's bytes as written; the
check over the load point re-asks the tool, re-produces, and diffs.

Usage:
  compile_tool.py <tool>                        # ask and validate; print the
                                                # skill's name, path, and digest;
                                                # write nothing
  compile_tool.py <tool> --load-point <dir>     # also write <dir>/<name>/SKILL.md
"""
import hashlib
import json
import pathlib
import re
import subprocess
import sys

import yaml

ROOT = pathlib.Path(__file__).resolve().parent.parent.parent
DATA_TYPE = ROOT / "basis" / "types" / "tool-description.md"
DEFAULT_LOAD_POINT = ".claude/skills"
FLAG = "--describe"


class CannotAnswer(Exception):
    """The tool gave no answer: the reason, one line."""


def one_line(text) -> str:
    return " ".join(str(text).split())


def usage() -> None:
    sys.exit(__doc__.split("Usage:", 1)[1].rstrip())


# --- the contract: the data type's schema block, read from its one home ---

def schema() -> dict:
    try:
        text = DATA_TYPE.read_text()
    except OSError as exc:
        raise CannotAnswer(f"{DATA_TYPE}: cannot be read: {exc}") from exc
    fence = re.search(r"```yaml\n(.*?)```", text, re.S)
    if not fence:
        raise CannotAnswer(f"{DATA_TYPE}: no schema block")
    block = yaml.safe_load(fence.group(1))
    if not isinstance(block, dict) or "schema" not in block:
        raise CannotAnswer(f"{DATA_TYPE}: schema block does not define `schema`")
    return block["schema"]


TYPES = {"object": dict, "array": list, "string": str, "integer": int,
         "boolean": bool}


def validate(node, spec: dict, where: str) -> list:
    """Check an instance against the data-type typedef's compact dialect:
    JSON Schema type names; `fields` required unless `optional: true`;
    `enum` closed; `items` for arrays; `pattern` for strings. Returns
    the violations, each naming its place."""
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
                    out.append(f"{where}: lacks `{name}`")
                continue
            out += validate(node[name], sub, f"{where}.{name}")
    if kind == "array" and "items" in spec:
        for i, item in enumerate(node):
            out += validate(item, spec["items"], f"{where}[{i}]")
    return out


# --- the question ---

def ask(tool: pathlib.Path) -> bytes:
    """Run the tool with the flag; return the answer's bytes as written."""
    if not tool.is_file():
        raise CannotAnswer(f"{tool}: no such tool")
    command = [sys.executable, str(tool), FLAG] if tool.suffix == ".py" else [str(tool), FLAG]
    try:
        run = subprocess.run(command, capture_output=True, timeout=60, check=False)
    except (OSError, subprocess.TimeoutExpired) as exc:
        raise CannotAnswer(f"{tool}: cannot answer: {one_line(exc)}") from exc
    if run.returncode != 0:
        reason = one_line(run.stderr.decode(errors="replace"))[:200] or "no message"
        raise CannotAnswer(f"{tool}: cannot answer: exit status {run.returncode}: {reason}")
    return run.stdout


def answer_of(tool: pathlib.Path):
    raw = ask(tool)
    try:
        answer = json.loads(raw.decode())
    except (UnicodeDecodeError, ValueError) as exc:
        raise CannotAnswer(f"{tool}: cannot answer: output does not parse as JSON: {one_line(exc)}") from exc
    problems = validate(answer, schema(), "answer")
    if problems:
        raise CannotAnswer(f"{tool}: cannot answer: does not parse against "
                           f"tool-description: " + "; ".join(problems[:5]))
    digest = hashlib.sha256(raw).hexdigest()[:12]
    return answer, digest


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


def render(answer: dict, source_rel: str, digest: str) -> str:
    names = ", ".join(f"`{u['name']}`" for u in answer["uses"])
    fm = {
        "name": answer["name"],
        "description": (f"{one_line(answer['description'])} Tool: `{source_rel}`. "
                        f"Uses, each with its exact invocation below: {names}."),
        "type": "skill",
        "id": f"{answer['name']}-skill",
        "generated": True,
        "generated-by": "basis/tools/compile_tool.py",
        "derived-from": answer["name"],
        "source": source_rel,
        "source-digest": f"sha256:{digest}",
    }
    head = [
        "---\n" + yaml.safe_dump(fm, sort_keys=False, allow_unicode=True).rstrip() + "\n---",
        f"# {answer['name']} (produced from the answer of `{source_rel}`)",
        one_line(answer["description"]),
        "Uses: " + ", ".join(f"[{u['name']}](#{u['name']})" for u in answer["uses"]) + ".",
    ]
    return "\n\n".join(head + [use_section(u) for u in answer["uses"]]) + "\n"


def repo_relative(path: pathlib.Path) -> str:
    full = path.resolve()
    return full.relative_to(ROOT).as_posix() if full.is_relative_to(ROOT) else path.as_posix()


def main() -> None:
    args = sys.argv[1:]
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
    tool = pathlib.Path(positional[0])
    try:
        answer, digest = answer_of(tool)
        source_rel = repo_relative(tool)
        text = render(answer, source_rel, digest)
    except CannotAnswer as exc:
        sys.exit(str(exc))
    except Exception as exc:  # noqa: BLE001 — never a traceback
        sys.exit(f"{tool}: does not compile: {type(exc).__name__}: {one_line(exc)}")
    name = answer["name"]
    if load_point is None:
        print(f"{tool}: answers as `{name}` for {DEFAULT_LOAD_POINT}/{name}/SKILL.md (digest {digest})")
        return
    out = load_point / name / "SKILL.md"
    try:
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(text)
    except OSError as exc:
        sys.exit(f"{out}: cannot be written: {one_line(exc)}")
    print(f"{out}: generated from {name} (digest {digest})")


if __name__ == "__main__":
    main()
