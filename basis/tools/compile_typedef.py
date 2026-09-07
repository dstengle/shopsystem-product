#!/usr/bin/env python3
"""Compile an artifact typedef into its guideline and its fitness set.

Interim tooling, sibling of compile_process.py and compile_role.py: the
lead shop renders its own definitions while it still has them to render.

A typedef that carries a `## Writing rules` section and a `## Fitness
scenarios` section (artifact-typedef typedef §Required sections 6–7) is
the one hand-edited document of its type's standard; this script produces
the two texts the checks read from those sections:
  - the guideline, at basis/guidelines/<type>.md — the Writing rules
    section copied verbatim, third-level headings raised to second level;
  - the fitness set, at basis/fitness/<type>.fitness.md — the Fitness
    scenarios section copied the same way.
Each carries the frontmatter its own typedef requires — type, id
(<type>-guideline, <type>-fitness), target-type, owner, status, approved,
version, created, updated from the typedef; judged/executable/judged-by
for the fitness set, the judge read from the section's `**Judged by:**`
line — plus `generated: true`, `generated-by`, `source` (the typedef's
path), and `source-digest` (sha256 of the typedef's text, twelve hex
digits). A produced text carries no Document History: the typedef's is
its history. Relative links are rewritten to resolve from the produced
file's directory. Only a typedef with `status: approved` compiles.

The rendering is a function of the typedef's text alone, so a second run
yields the same bytes, and the check compares bytes.

Usage:
  compile_typedef.py <typedef.md> [--guideline <out.md>] [--fitness <out.md>]
                                     # write both texts (defaults above)
  compile_typedef.py <typedef.md> --check [--guideline <path>] [--fitness <path>]
                                     # render afresh, compare with what stands
  compile_typedef.py --describe      # answer the standard question (DESCRIPTION
                                     # below) as JSON on standard output, exit 0,
                                     # before any other action

Check rows, one per line, kind first; nothing printed when both are current:
  missing <id>                       nothing stands at the text's path
  diverged <id>                      stands there but differs from a fresh render
  will-not-compile <typedef> <reason>
                                     the typedef cannot be read, parsed, or
                                     rendered — the one case that exits nonzero
Exit 0 in every other check outcome; 1 on will-not-compile; 2 on a usage
error. A newline in a reason is written as `\\n` so a row stays one line.
The will-not-compile row's reason begins with the failure's code from the
tool-description data type's closed set — `unreadable`, `unparseable`, or
`check-failed` — the code this tool's answer names for it.
"""
import hashlib
import json
import pathlib
import posixpath
import re
import sys

import yaml

TOOL = "basis/tools/compile_typedef.py"
TYPEDEF_INPUT = {
    "type": "string",
    "description": "the path of the artifact typedef, for example "
                   "basis/artifacts/feature.md; it must stand approved and "
                   "carry `## Writing rules` and `## Fitness scenarios`",
}
GUIDELINE_INPUT = {
    "type": "string",
    "description": "the guideline's path",
    "default": "basis/guidelines/<type>.md, <type> the typedef's `defines`",
}
FITNESS_INPUT = {
    "type": "string",
    "description": "the fitness set's path",
    "default": "basis/fitness/<type>.fitness.md, <type> the typedef's `defines`",
}
WILL_NOT_COMPILE = ("one row on standard output, `will-not-compile <typedef> "
                    "<code>: <reason>`, exit status 1; nothing is written")
COMPILE_FAILURES = [
    {"code": "unreadable", "exit_status": 1,
     "condition": "no file exists at <typedef>, or it cannot be read: "
                  + WILL_NOT_COMPILE,
     "next": "give the path of an existing typedef and run the invocation "
             "again"},
    {"code": "unparseable", "exit_status": 1,
     "condition": "the typedef has no front-matter, or its front-matter "
                  "does not parse or is not a mapping: " + WILL_NOT_COMPILE,
     "next": "repair the typedef's front-matter and run the invocation "
             "again"},
    {"code": "check-failed", "exit_status": 1,
     "condition": "the typedef does not qualify or does not render: its "
                  "`type` is not artifact-typedef, its `status` is not "
                  "approved (refused), it lacks an identity key, a `## "
                  "Writing rules` or `## Fitness scenarios` section, or a "
                  "`**Judged by:**` line, or a produced text lacks a mark "
                  "its reader requires: " + WILL_NOT_COMPILE,
     "next": "repair the typedef at the named defect (the artifact-typedef "
             "typedef states the sections) and run the invocation again"},
    {"code": "usage", "exit_status": 2,
     "condition": "the arguments are not one of the two invocations this "
                  "tool states — no typedef, more than one, an option "
                  "without its path, or an unknown option; the usage sheet "
                  "on standard error; nothing is written",
     "next": "run the invocation the use states, as written"},
]
# The answer to the standard question (adr-2026-09-07-tool-answer §2): an
# instance of the tool-description data type, basis/types/tool-description.md.
# This tool is its one home; the skill is produced from it, never edited.
DESCRIPTION = {
    "name": "compile-typedef",
    "description": (
        "Produces an artifact typedef's two texts — its guideline from the "
        "`## Writing rules` section and its fitness set from the `## Fitness "
        "scenarios` section — at the paths the checks read, each stamped "
        "`generated`, `source`, and `source-digest`, and checks whether the "
        "texts that stand are current with the typedef. Only an approved "
        "typedef compiles. Use it after such a typedef changes, and to "
        "confirm that its guideline and fitness set are current."
    ),
    "uses": [
        {
            "name": "produce",
            "description": (
                "Renders both texts from the typedef and writes them, "
                "creating directories, overwriting what stands at each path "
                "— a hand edit included. The typedef itself is not changed."
            ),
            "invocation": f"python3 {TOOL} <typedef> [--guideline <guideline>] [--fitness <fitness>]",
            "input_schema": {
                "type": "object",
                "properties": {"typedef": TYPEDEF_INPUT,
                               "guideline": GUIDELINE_INPUT,
                               "fitness": FITNESS_INPUT},
                "required": ["typedef"],
                "additionalProperties": False,
            },
            "returns": {
                "form": "text",
                "text": "two lines on standard output, `<guideline>: produced "
                        "from basis/artifacts/<file>` then `<fitness>: "
                        "produced from basis/artifacts/<file>`; exit status "
                        "0; both texts written",
            },
            "failures": COMPILE_FAILURES,
        },
        {
            "name": "check",
            "description": (
                "Renders both texts afresh to memory and compares each with "
                "what stands at its path; prints one row per text that is "
                "not current and nothing when both are. Writes nothing."
            ),
            "invocation": f"python3 {TOOL} <typedef> --check [--guideline <guideline>] [--fitness <fitness>]",
            "input_schema": {
                "type": "object",
                "properties": {"typedef": TYPEDEF_INPUT,
                               "guideline": GUIDELINE_INPUT,
                               "fitness": FITNESS_INPUT},
                "required": ["typedef"],
                "additionalProperties": False,
            },
            "returns": {
                "form": "text",
                "text": "on standard output, zero, one, or two rows, one per "
                        "line: `missing <type>-guideline` or `missing "
                        "<type>-fitness` when nothing stands at the text's "
                        "path, `diverged <type>-guideline` or `diverged "
                        "<type>-fitness` when what stands differs from a "
                        "fresh render; nothing printed when both are "
                        "current; exit status 0 in each of these outcomes — "
                        "a missing or diverged row is a result, not a "
                        "failure",
            },
            "failures": COMPILE_FAILURES,
        },
    ],
}

GENERATED_BY = "basis/tools/compile_typedef.py"
FM_RE = re.compile(r"---\n(.*?)\n---\n", re.S)
LINK_RE = re.compile(r"\]\(([^)\s]+)\)")
JUDGED_BY_RE = re.compile(r"\*\*Judged by:\*\*\s*`?([a-z0-9-]+)`?")
WRITING_RULES = "Writing rules"
FITNESS_SCENARIOS = "Fitness scenarios"
# What each reader requires of the produced text (C3: a production that
# drops one is a defect of the production, not a reason to change the reader).
GUIDELINE_MARKS = ["**Voice principle", "**Highlights", "**Layers", "\n## Rules"]
FITNESS_MARKS = ["\n## Scenarios", "\n## Compile mapping"]


class CompileError(Exception):
    """The typedef does not render (a will-not-compile finding)."""


def one_line(text) -> str:
    return str(text).replace("\r", "\\r").replace("\n", "\\n")


def split(path: pathlib.Path):
    try:
        text = path.read_text()
    except (OSError, UnicodeDecodeError) as exc:
        raise CompileError(f"unreadable: cannot be read: {exc}")
    m = FM_RE.match(text)
    if not m:
        raise CompileError("unparseable: no front-matter")
    try:
        front = yaml.safe_load(m.group(1))
    except yaml.YAMLError as exc:
        raise CompileError(f"unparseable: front-matter does not parse: {exc}")
    if not isinstance(front, dict):
        raise CompileError("unparseable: front-matter is not a mapping")
    return text, front, text[m.end():]


def section(body: str, heading: str) -> str:
    """The body of one second-level section (to the next `## ` or EOF)."""
    m = re.search(r"^## " + re.escape(heading) + r"\s*$(.*?)(?=^## |\Z)",
                  body, re.S | re.M)
    if not m:
        raise CompileError(f"no `## {heading}` section "
                           "(artifact-typedef typedef §Required sections 6–7)")
    return m.group(1).strip("\n")


def raise_headings(text: str) -> str:
    return re.sub(r"^### ", "## ", text, flags=re.M)


def resolve_links(body: str, source_dir: str, out_dir: str) -> str:
    """Rewrite relative links so they resolve from the produced file's directory."""
    def one(m):
        target = m.group(1)
        if target.startswith(("http://", "https://", "pkg:", "mailto:", "/", "#")):
            return m.group(0)
        path, sep, anchor = target.partition("#")
        moved = posixpath.relpath(posixpath.normpath(posixpath.join(source_dir, path)),
                                  posixpath.normpath(out_dir))
        return f"]({moved}{sep}{anchor})"
    return LINK_RE.sub(one, body)


def source_path(typedef: pathlib.Path) -> str:
    """The typedef's path as the corpus names it: basis/artifacts/<file>."""
    parts = typedef.resolve().parts
    return posixpath.join(*parts[-3:]) if len(parts) >= 3 else typedef.name


def identity(front: dict, key: str):
    if key not in front:
        raise CompileError(f"front-matter lacks `{key}` "
                           "(artifact-typedef typedef §Required frontmatter)")
    return front[key]


def front_text(fm: dict) -> str:
    return yaml.safe_dump(fm, sort_keys=False, allow_unicode=True,
                          width=1_000_000).rstrip()


def render(typedef: pathlib.Path):
    """Return (type name, guideline text, fitness text) for an approved typedef."""
    text, front, body = split(typedef)
    if front.get("type") != "artifact-typedef":
        raise CompileError(f"type is `{front.get('type')}`, not artifact-typedef")
    if front.get("status") != "approved":
        raise CompileError(f"refused — status is `{front.get('status')}`; "
                           "only an approved typedef compiles")
    type_name = identity(front, "defines")
    rules = section(body, WRITING_RULES)
    scenarios = section(body, FITNESS_SCENARIOS)
    judge = JUDGED_BY_RE.search(scenarios)
    if not judge:
        raise CompileError("Fitness scenarios names no judge (a `**Judged by:**` line; "
                           "fitness-set typedef §Required frontmatter)")
    src = source_path(typedef)
    src_dir = posixpath.dirname(src)
    digest = f"sha256:{hashlib.sha256(text.encode()).hexdigest()[:12]}"
    base = {key: identity(front, key)
            for key in ("owner", "status", "approved", "version", "created", "updated")}
    stamp = {"generated": True, "generated-by": GENERATED_BY,
             "source": src, "source-digest": digest}
    title = type_name.replace("-", " ")

    def produce(kind: str, fm: dict, heading: str, content: str, out_dir: str,
                marks: list) -> str:
        notice = (f"<!-- Generated from `{src}` (its {heading} section) by "
                  f"`{GENERATED_BY}`; do not edit by hand — edit the typedef and "
                  f"re-render. -->")
        content = resolve_links(raise_headings(content), src_dir, out_dir)
        out = (f"---\n{front_text(fm)}\n---\n\n{notice}\n\n# {kind}: {title}\n\n"
               f"{content}\n")
        for mark in marks:
            if mark not in out:
                raise CompileError(f"the produced {kind.lower()} lacks `{mark.strip()}` "
                                   f"({fm['type']} typedef §Required sections)")
        return out

    guideline = produce(
        "Guideline",
        {"type": "quality-guideline", "id": f"{type_name}-guideline",
         "target-type": type_name, **base, **stamp},
        WRITING_RULES, rules, posixpath.join(posixpath.dirname(src_dir), "guidelines"),
        GUIDELINE_MARKS)
    fitness = produce(
        "Fitness set",
        {"type": "fitness-set", "id": f"{type_name}-fitness",
         "target-type": type_name, "judged": True, "executable": False,
         "judged-by": judge.group(1), **base, **stamp},
        FITNESS_SCENARIOS, scenarios, posixpath.join(posixpath.dirname(src_dir), "fitness"),
        FITNESS_MARKS)
    return type_name, guideline, fitness


def shown_path(path: pathlib.Path) -> str:
    """Relative to the working directory when under it; as given otherwise."""
    try:
        return str(path.resolve().relative_to(pathlib.Path.cwd()))
    except ValueError:
        return str(path)


def default_paths(typedef: pathlib.Path, type_name: str):
    basis = typedef.resolve().parent.parent
    return (basis / "guidelines" / f"{type_name}.md",
            basis / "fitness" / f"{type_name}.fitness.md")


def check(typedef: pathlib.Path, guideline_out, fitness_out) -> list:
    """Rows for the two texts against a fresh render; empty when both are current."""
    type_name, guideline, fitness = render(typedef)
    g_default, f_default = default_paths(typedef, type_name)
    rows = []
    for text, path, ident in ((guideline, guideline_out or g_default, f"{type_name}-guideline"),
                              (fitness, fitness_out or f_default, f"{type_name}-fitness")):
        if not path.is_file():
            rows.append(f"missing {ident}")
        elif path.read_text() != text:
            rows.append(f"diverged {ident}")
    return rows


def write(typedef: pathlib.Path, guideline_out, fitness_out) -> None:
    type_name, guideline, fitness = render(typedef)
    g_default, f_default = default_paths(typedef, type_name)
    for text, path in ((guideline, guideline_out or g_default),
                       (fitness, fitness_out or f_default)):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)
        print(f"{shown_path(path)}: produced from {source_path(typedef)}")


def usage(code: int = 2) -> None:
    sys.stderr.write(__doc__.split("Usage:", 1)[1].split("Check rows", 1)[0])
    sys.exit(code)


def main() -> None:
    args = sys.argv[1:]
    # The standard question, answered before any other action; the other
    # arguments are ignored (adr-2026-09-07-tool-answer §2).
    if "--describe" in args:
        sys.stdout.write(json.dumps(DESCRIPTION, indent=2) + "\n")
        sys.exit(0)
    guideline_out = fitness_out = None
    do_check, positional = False, []
    i = 0
    while i < len(args):
        arg = args[i]
        if arg in ("--guideline", "--fitness"):
            if i + 1 >= len(args):
                usage()
            if arg == "--guideline":
                guideline_out = pathlib.Path(args[i + 1])
            else:
                fitness_out = pathlib.Path(args[i + 1])
            i += 2
        elif arg == "--check":
            do_check = True; i += 1
        elif arg.startswith("--"):
            usage()
        else:
            positional.append(arg); i += 1
    if len(positional) != 1:
        usage()
    typedef = pathlib.Path(positional[0])
    try:
        if do_check:
            for row in check(typedef, guideline_out, fitness_out):
                print(row)
        else:
            write(typedef, guideline_out, fitness_out)
    except Exception as exc:  # noqa: BLE001 — a typedef that does not compile
        # is one row, never a traceback; the reason begins with the
        # failure's code (unreadable, unparseable, or check-failed)
        reason = str(exc) if isinstance(exc, CompileError) else f"{type(exc).__name__}: {exc}"
        if not reason.startswith(("unreadable: ", "unparseable: ")):
            reason = "check-failed: " + reason
        print(f"will-not-compile {typedef} {one_line(reason)}")
        sys.exit(1)


if __name__ == "__main__":
    main()
