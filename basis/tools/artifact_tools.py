#!/usr/bin/env python3
"""Read and write an artifact by the part it needs; render a calculated
field fresh from the corpus; fill a scenario's hash and a bead's initiative.

One tool, six uses, on the pattern of the other framework tools beside it
(compile_process.py, compile_tool.py): every failure exits nonzero with one
line on standard error beginning with its code from the tool-description
data type's closed set, never a traceback. `--describe` answers the
standard question (DESCRIPTION below) as JSON on standard output, exit 0,
before any other action.

An artifact's addressable parts are its frontmatter keys and its level-2
(`## `) sections; a section whose heading reads "name — rest" is addressed
by "name" alone (a process skill's step heading), the full heading text
otherwise (an artifact typedef's section name). `read` returns one part's
text; `write` replaces one existing part's text in place, in the
frontmatter or the body, restating nothing else. `children` and
`references` render, fresh from the corpus on every call and never from a
stored field, the artifacts whose `parent` names this one's `id`, and the
artifacts that link to this one's path. `fill-hash` computes a scenario's
`@hash:` from its own text; `fill-initiative` reads the initiative an
anchor artifact already names and writes it onto a bead through `bd
comment` — the initiative is never taken as a hand-typed value.

Usage:
  artifact_tools.py read <path> --section <name>
  artifact_tools.py write <path> --part <name> --content <text>
  artifact_tools.py children <path>
  artifact_tools.py references <path>
  artifact_tools.py fill-hash <feature> --scenario <name>
  artifact_tools.py fill-initiative <bead> --anchor <path>
  artifact_tools.py --describe
"""
import hashlib
import pathlib
import re
import subprocess
import sys

import yaml

ROOT = pathlib.Path(__file__).resolve().parent.parent.parent
TOOL = "basis/tools/artifact_tools.py"
FLAG = "--describe"
FM_RE = re.compile(r"^---\n(.*?)\n---\n", re.S)
HEADING_RE = re.compile(r"^## (.+)$", re.M)
EXIT = {"usage": 2, "unreadable": 2, "unparseable": 1, "unwritable": 1}


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


def repo_relative(path: pathlib.Path) -> str:
    full = path.resolve()
    return full.relative_to(ROOT).as_posix() if full.is_relative_to(ROOT) else path.as_posix()


# --- reading and addressing an artifact's parts ---

def read_text(path: pathlib.Path) -> str:
    try:
        return path.read_text()
    except OSError as exc:
        raise Failure("unreadable", f"{path}: cannot be read: {exc}") from exc


def frontmatter(text: str, shown: str):
    """The parsed frontmatter mapping and its raw block, or a failure."""
    match = FM_RE.match(text)
    if not match:
        raise Failure("unparseable", f"{shown}: no frontmatter")
    try:
        data = yaml.safe_load(match.group(1))
    except yaml.YAMLError as exc:
        raise Failure("unparseable", f"{shown}: frontmatter does not parse: {one_line(exc)}") from exc
    if not isinstance(data, dict):
        raise Failure("unparseable", f"{shown}: frontmatter is not a mapping")
    return data, match


def sections(text: str) -> list:
    """Each level-2 section as (key, heading_text, start, end) over the
    body past frontmatter. `key` is the text before " — " when the
    heading carries one (a process skill's step), the whole heading
    otherwise (an artifact typedef's section name)."""
    fm = FM_RE.match(text)
    body_start = fm.end() if fm else 0
    heads = list(HEADING_RE.finditer(text, body_start))
    out = []
    for i, head in enumerate(heads):
        end = heads[i + 1].start() if i + 1 < len(heads) else len(text)
        heading = head.group(1).strip()
        key = heading.split(" — ", 1)[0].strip() if " — " in heading else heading
        out.append((key, heading, head.start(), end))
    return out


def available_parts(fm: dict, secs: list) -> str:
    names = list(fm.keys()) + [key for key, *_ in secs]
    return ", ".join(f"`{n}`" for n in names) if names else "none"


def find_section(secs: list, name: str):
    for key, heading, start, end in secs:
        if key.lower() == name.lower():
            return heading, start, end
    return None


# --- read ---

def do_read(path_arg: str, section: str) -> str:
    path = pathlib.Path(path_arg)
    if not path.is_file():
        raise Failure("unreadable", f"{path_arg}: no such artifact")
    shown = repo_relative(path)
    text = read_text(path)
    fm, fm_match = frontmatter(text, shown)
    if section in fm:
        return f"{section}: {fm[section]}"
    secs = sections(text)
    found = find_section(secs, section)
    if found is None:
        raise Failure("unreadable", f"{shown}: no section or field named `{section}`; "
                      f"has: {available_parts(fm, secs)}")
    heading, start, end = found
    return text[start:end].rstrip("\n")


# --- write ---

def shape_ok(part: str, content: str) -> str:
    """The reason content does not fit the part's shape, or "" if it does."""
    if not content.strip():
        return "content is empty"
    if part == "version":
        try:
            int(content.strip())
        except ValueError:
            return "version must be an integer"
    return ""


def do_write(path_arg: str, part: str, content: str) -> str:
    path = pathlib.Path(path_arg)
    if not path.is_file():
        raise Failure("unreadable", f"{path_arg}: no such artifact")
    shown = repo_relative(path)
    text = read_text(path)
    fm, fm_match = frontmatter(text, shown)
    secs = sections(text)
    if part not in fm and find_section(secs, part) is None:
        raise Failure("unreadable", f"{shown}: no part named `{part}`; "
                      f"has: {available_parts(fm, secs)}")
    problem = shape_ok(part, content)
    if problem:
        raise Failure("unparseable", f"{shown}: `{part}` does not fit — {problem}; "
                      f"supply non-empty content of the shape `{part}` takes")
    if part in fm:
        value = content.strip()
        if part == "version":
            value = int(value)
        fm[part] = value
        block = yaml.safe_dump(fm, sort_keys=False, allow_unicode=True).rstrip()
        new_text = text[:fm_match.start()] + "---\n" + block + "\n---\n" + text[fm_match.end():]
    else:
        heading, start, end = find_section(secs, part)
        body = "\n" + content.strip() + "\n\n" if end != len(text) else "\n" + content.strip() + "\n"
        heading_line_end = text.index("\n", start) + 1
        new_text = text[:heading_line_end] + body + text[end:]
    try:
        path.write_text(new_text)
    except OSError as exc:
        raise Failure("unwritable", f"{shown}: cannot be written: {exc}") from exc
    return f"{shown}: `{part}` written"


# --- children / references (rendered fresh, never stored) ---

def corpus_files():
    for path in ROOT.rglob("*.md"):
        rel = path.relative_to(ROOT).as_posix()
        if rel.startswith(".git/") or "__pycache__" in rel or rel.startswith(".claude/skills/") \
                or rel.startswith(".claude/agents/"):
            continue
        yield path


def do_children(path_arg: str) -> list:
    path = pathlib.Path(path_arg)
    if not path.is_file():
        raise Failure("unreadable", f"{path_arg}: no such artifact")
    shown = repo_relative(path)
    fm, _ = frontmatter(read_text(path), shown)
    target_id = fm.get("id")
    if not target_id:
        raise Failure("unreadable", f"{shown}: carries no `id` to match a child's `parent` against")
    out = []
    for other in corpus_files():
        if other.resolve() == path.resolve():
            continue
        try:
            other_fm, _ = frontmatter(read_text(other), repo_relative(other))
        except Failure:
            continue
        if other_fm.get("parent") == target_id:
            out.append(repo_relative(other))
    return sorted(out)


LINK_RE = re.compile(r"\]\(([^)\s]+)\)")


def do_references(path_arg: str) -> list:
    path = pathlib.Path(path_arg)
    if not path.is_file():
        raise Failure("unreadable", f"{path_arg}: no such artifact")
    target = path.resolve()
    out = []
    for other in corpus_files():
        if other.resolve() == target:
            continue
        try:
            text = other.read_text()
        except OSError:
            continue
        found = False
        for link in LINK_RE.findall(text):
            if link.startswith(("http:", "https:", "#")):
                continue
            candidate = (other.parent / link.split("#", 1)[0]).resolve()
            if candidate == target:
                found = True
                break
        if not found:
            try:
                fm, _ = frontmatter(text, repo_relative(other))
            except Failure:
                fm = {}
            for value in fm.values():
                if isinstance(value, str) and value.endswith(".md"):
                    candidate = (other.parent / value).resolve()
                    if candidate == target:
                        found = True
                        break
        if found:
            out.append(repo_relative(other))
    return sorted(out)


# --- fill-hash ---

GHERKIN_RE = re.compile(r"```gherkin\n(.*?)```", re.S)
TAG_RE = re.compile(r"^( *)((?:@\S+\s*)+)$", re.M)
SCENARIO_RE = re.compile(r"^ *Scenario: (.+)$", re.M)
STEP_RE = re.compile(r"^ *(?:Scenario:|Given|When|Then|And|But) .*$", re.M)


def do_fill_hash(feature_arg: str, scenario_name: str) -> str:
    path = pathlib.Path(feature_arg)
    if not path.is_file():
        raise Failure("unreadable", f"{feature_arg}: no such feature")
    shown = repo_relative(path)
    text = read_text(path)
    fence = GHERKIN_RE.search(text)
    if not fence:
        raise Failure("unparseable", f"{shown}: no gherkin block")
    block = fence.group(1)
    scenario_starts = [(m.start(), m.group(1).strip()) for m in SCENARIO_RE.finditer(block)]
    match = next((s for s in scenario_starts if s[1] == scenario_name), None)
    if match is None:
        names = ", ".join(f"`{n}`" for _, n in scenario_starts) or "none"
        raise Failure("unreadable", f"{shown}: no scenario named `{scenario_name}`; has: {names}")
    start = match[0]
    idx = scenario_starts.index(match)
    end = scenario_starts[idx + 1][0] if idx + 1 < len(scenario_starts) else len(block)
    body = block[start:end]
    steps = [m.group(0).strip() for m in STEP_RE.finditer(body)]
    if len(steps) < 3:
        raise Failure("unparseable", f"{shown}: scenario `{scenario_name}` has no "
                      "Given/When/Then text to hash")
    digest = hashlib.sha256("\n".join(steps).encode()).hexdigest()[:12]
    # The tag line stands immediately above the scenario, in the file at large
    # (the block is a slice of text, offsets carried over via the fence match).
    abs_start = fence.start(1) + start
    line_start = text.rfind("\n", 0, abs_start) + 1
    prev_line_start = text.rfind("\n", 0, line_start - 1) + 1
    tag_line = text[prev_line_start:line_start - 1]
    if "@hash:" not in tag_line:
        raise Failure("unparseable", f"{shown}: scenario `{scenario_name}` carries no "
                      "`@hash:` tag to fill")
    new_tag_line = re.sub(r"@hash:\S+", f"@hash:{digest}", tag_line)
    new_text = text[:prev_line_start] + new_tag_line + text[line_start - 1:]
    try:
        path.write_text(new_text)
    except OSError as exc:
        raise Failure("unwritable", f"{shown}: cannot be written: {exc}") from exc
    return f"{shown}: scenario `{scenario_name}` @hash: {digest}"


# --- fill-initiative ---

def do_fill_initiative(bead: str, anchor_arg: str) -> str:
    anchor_path = pathlib.Path(anchor_arg)
    if not anchor_path.is_file():
        raise Failure("unreadable", f"{anchor_arg}: no such anchor artifact")
    shown = repo_relative(anchor_path)
    fm, _ = frontmatter(read_text(anchor_path), shown)
    initiative = fm.get("initiative")
    if not initiative:
        raise Failure("unreadable", f"{shown}: carries no `initiative` field to read")
    resolved = (anchor_path.parent / initiative).resolve()
    if not resolved.is_file():
        raise Failure("unreadable", f"{shown}: names initiative `{initiative}`, "
                      f"which does not resolve to a file")
    initiative_rel = repo_relative(resolved)
    comment = f"initiative: {initiative_rel}"
    try:
        run = subprocess.run(["bd", "comment", bead, comment], capture_output=True,
                              timeout=60, check=False)
    except (OSError, subprocess.TimeoutExpired) as exc:
        raise Failure("unwritable", f"bd comment {bead}: cannot run: {one_line(exc)}") from exc
    if run.returncode != 0:
        reason = one_line(run.stderr.decode(errors="replace"))[:200] or "no message"
        code = "unreadable" if "no issue found" in reason else "unwritable"
        raise Failure(code, f"bead `{bead}`: {reason}")
    return f"{bead}: initiative {initiative_rel} written"


# --- the answer to the standard question (adr-2026-09-07-tool-answer §2) ---

PATH_INPUT = {"type": "string", "description": "the artifact's path, "
              "repository-relative or absolute"}
USAGE_FAILURE = {
    "code": "usage", "exit_status": 2,
    "condition": "the arguments are not one of the six invocations this tool "
                 "states — no path, a missing required flag, an unknown "
                 "flag, or a flag without its value; one line on standard "
                 "error beginning `usage:` names the invocations; nothing "
                 "is read or written",
    "next": "run the invocation the use states, as written",
}

DESCRIPTION = {
    "name": "artifact-tools",
    "description": (
        "Reads and writes an artifact by the part it needs (a frontmatter "
        "field or a level-2 section), renders a parent's children and "
        "what references an artifact fresh from the corpus on every call, "
        "and fills a scenario's `@hash:` and a bead's initiative from what "
        "the corpus already states. Use it instead of loading or quoting "
        "a whole artifact, and wherever a calculated field or a filled "
        "value would otherwise be typed by hand."
    ),
    "uses": [
        {
            "name": "read",
            "description": "Returns the text of one named part of an "
                           "artifact — a frontmatter field or a level-2 "
                           "section — and nothing else: the artifact's "
                           "other sections and its history are left out "
                           "unless that part is the one asked for.",
            "invocation": f"python3 {TOOL} read <path> --section <section>",
            "input_schema": {
                "type": "object",
                "properties": {
                    "path": PATH_INPUT,
                    "section": {"type": "string", "description": "the "
                                "frontmatter field name, or the section's "
                                "heading (a step's name before ` — `, "
                                "where its heading carries one)"},
                },
                "required": ["path", "section"],
                "additionalProperties": False,
            },
            "returns": {"form": "text", "text": "the named part's text on "
                        "standard output, unmodified; exit status 0"},
            "failures": [{
                "code": "unreadable", "exit_status": 2,
                "condition": "the path does not exist, or names no "
                             "frontmatter field or section matching "
                             "<section>; one line on standard error "
                             "beginning `unreadable:` names the artifact, "
                             "the section asked for, and the section and "
                             "field names that do exist; nothing is "
                             "returned",
                "next": "give an existing path and one of the names "
                        "listed, then run again",
            }, USAGE_FAILURE],
        },
        {
            "name": "write",
            "description": "Replaces one existing part's text — a "
                           "frontmatter field or a level-2 section's body "
                           "— with the given content, in place; every "
                           "other part of the artifact is left unchanged "
                           "and unread by the caller.",
            "invocation": f"python3 {TOOL} write <path> --part <part> "
                          "--content <content>",
            "input_schema": {
                "type": "object",
                "properties": {
                    "path": PATH_INPUT,
                    "part": {"type": "string", "description": "the "
                             "frontmatter field name, or the section's "
                             "heading key, to replace"},
                    "content": {"type": "string", "description": "the "
                                "part's new text — the whole replacement, "
                                "never a diff against the old"},
                },
                "required": ["path", "part", "content"],
                "additionalProperties": False,
            },
            "returns": {"form": "text", "text": "one line on standard "
                        "output, `<path>: \\`<part>\\` written`; exit "
                        "status 0; the part written in place"},
            "failures": [{
                "code": "unreadable", "exit_status": 2,
                "condition": "the path does not exist, or names no "
                             "frontmatter field or section matching "
                             "<part>; one line on standard error beginning "
                             "`unreadable:` names the artifact, the part, "
                             "and the part names that do exist; nothing is "
                             "written",
                "next": "give an existing path and one of the part names "
                        "listed, then run again",
            }, {
                "code": "unparseable", "exit_status": 1,
                "condition": "<content> is empty, or does not fit the "
                             "named part's shape (for example, `version` "
                             "is not an integer); one line on standard "
                             "error beginning `unparseable:` names the "
                             "artifact, the part, and what to supply "
                             "instead; nothing is written",
                "next": "supply content of the shape the part takes and "
                        "run again",
            }, USAGE_FAILURE, {
                "code": "unwritable", "exit_status": 1,
                "condition": "the artifact could not be written; one line "
                             "on standard error beginning `unwritable:` "
                             "names the path and the reason",
                "next": "make the path writable, or give one that is, and "
                        "run the invocation again",
            }],
        },
        {
            "name": "children",
            "description": "Renders the list of artifacts whose `parent` "
                           "names this artifact's `id`, read fresh from "
                           "every file in the corpus on this call — never "
                           "a field stored on the parent.",
            "invocation": f"python3 {TOOL} children <path>",
            "input_schema": {
                "type": "object",
                "properties": {"path": PATH_INPUT},
                "required": ["path"],
                "additionalProperties": False,
            },
            "returns": {"form": "json", "output_schema": {
                "type": "array", "items": {"type": "string"}}},
            "failures": [{
                "code": "unreadable", "exit_status": 2,
                "condition": "the path does not exist, or its frontmatter "
                             "carries no `id`; one line on standard error "
                             "beginning `unreadable:` names the artifact; "
                             "nothing is returned",
                "next": "give the path of an artifact whose frontmatter "
                        "carries an `id` and run again",
            }, USAGE_FAILURE],
        },
        {
            "name": "references",
            "description": "Renders the list of artifacts that link to "
                           "this artifact's path or name it in a "
                           "frontmatter field, read fresh from every file "
                           "in the corpus on this call — never a field "
                           "stored on the artifact.",
            "invocation": f"python3 {TOOL} references <path>",
            "input_schema": {
                "type": "object",
                "properties": {"path": PATH_INPUT},
                "required": ["path"],
                "additionalProperties": False,
            },
            "returns": {"form": "json", "output_schema": {
                "type": "array", "items": {"type": "string"}}},
            "failures": [{
                "code": "unreadable", "exit_status": 2,
                "condition": "the path does not exist; one line on "
                             "standard error beginning `unreadable:` names "
                             "it; nothing is returned",
                "next": "give an existing path and run again",
            }, USAGE_FAILURE],
        },
        {
            "name": "fill-hash",
            "description": "Computes a scenario's `@hash:` — sha256 of "
                           "its `Scenario:`/`Given`/`When`/`Then` (and "
                           "`And`/`But`) lines, trimmed and "
                           "newline-joined, first twelve hex digits — and "
                           "writes it onto the scenario's tag line; the "
                           "caller never supplies the hash.",
            "invocation": f"python3 {TOOL} fill-hash <feature> --scenario "
                          "<name>",
            "input_schema": {
                "type": "object",
                "properties": {
                    "feature": {"type": "string", "description": "the "
                                "feature file's path"},
                    "scenario": {"type": "string", "description": "the "
                                 "scenario's name, exactly as its "
                                 "`Scenario:` line reads"},
                },
                "required": ["feature", "scenario"],
                "additionalProperties": False,
            },
            "returns": {"form": "text", "text": "one line on standard "
                        "output, `<feature>: scenario \\`<name>\\` "
                        "@hash: <12 hex>`; exit status 0; the tag line "
                        "written in place"},
            "failures": [{
                "code": "unreadable", "exit_status": 2,
                "condition": "the feature does not exist, or names no "
                             "scenario matching <scenario>; one line on "
                             "standard error beginning `unreadable:` names "
                             "the feature, the scenario asked for, and the "
                             "scenario names that do exist; nothing is "
                             "written",
                "next": "give an existing feature path and one of the "
                        "scenario names listed, then run again",
            }, {
                "code": "unparseable", "exit_status": 1,
                "condition": "the feature has no gherkin block, the named "
                             "scenario has no Given/When/Then text, or its "
                             "tag line carries no `@hash:` to fill; one "
                             "line on standard error beginning "
                             "`unparseable:` names the feature and the "
                             "scenario, and what is wrong with its text; "
                             "nothing is written",
                "next": "repair the scenario's text or tag line and run "
                        "again",
            }, USAGE_FAILURE, {
                "code": "unwritable", "exit_status": 1,
                "condition": "the feature could not be written; one line "
                             "on standard error beginning `unwritable:` "
                             "names the path and the reason",
                "next": "make the path writable, or give one that is, and "
                        "run the invocation again",
            }],
        },
        {
            "name": "fill-initiative",
            "description": "Reads the initiative an anchor artifact "
                           "already names in its `initiative` frontmatter "
                           "field, resolved fresh from the corpus, and "
                           "writes it onto the bead through `bd comment` "
                           "— `bd`'s only narrative-write action; the "
                           "caller never supplies the initiative value.",
            "invocation": f"python3 {TOOL} fill-initiative <bead> --anchor "
                          "<path>",
            "input_schema": {
                "type": "object",
                "properties": {
                    "bead": {"type": "string", "description": "the work "
                             "item's id, for example lead-176ti"},
                    "anchor": {"type": "string", "description": "the path "
                               "of the artifact the execution is anchored "
                               "to, carrying the `initiative` field to "
                               "read"},
                },
                "required": ["bead", "anchor"],
                "additionalProperties": False,
            },
            "returns": {"form": "text", "text": "one line on standard "
                        "output, `<bead>: initiative <path> written`; "
                        "exit status 0; a comment added to the bead "
                        "through `bd comment`"},
            "failures": [{
                "code": "unreadable", "exit_status": 2,
                "condition": "the anchor does not exist, carries no "
                             "`initiative` field, that field does not "
                             "resolve to a file, or no bead with <bead> "
                             "exists in the register; one line on "
                             "standard error names which one and what to "
                             "check; nothing is written",
                "next": "give an anchor whose `initiative` field resolves, "
                        "and the id of an existing bead, then run again",
            }, USAGE_FAILURE, {
                "code": "unwritable", "exit_status": 1,
                "condition": "`bd comment` failed for a reason other than "
                             "the bead not being found; one line on "
                             "standard error beginning `unwritable:` "
                             "carries `bd`'s own message",
                "next": "act on `bd`'s message and run the invocation "
                        "again",
            }],
        },
    ],
}


def main() -> None:
    args = sys.argv[1:]
    if FLAG in args:
        import json
        sys.stdout.write(json.dumps(DESCRIPTION, indent=2) + "\n")
        sys.exit(0)
    if not args:
        fail("usage", f"python3 {TOOL} read|write|children|references|"
             "fill-hash|fill-initiative <path> [flags] | --describe")
    action, rest = args[0], args[1:]
    flags, positional = {}, []
    i = 0
    while i < len(rest):
        if rest[i].startswith("--"):
            key = rest[i][2:]
            if i + 1 >= len(rest):
                fail("usage", f"--{key} needs a value")
            flags[key] = rest[i + 1]; i += 2
        else:
            positional.append(rest[i]); i += 1
    try:
        if action == "read" and len(positional) == 1 and "section" in flags:
            print(do_read(positional[0], flags["section"]))
        elif action == "write" and len(positional) == 1 and {"part", "content"} <= flags.keys():
            print(do_write(positional[0], flags["part"], flags["content"]))
        elif action == "children" and len(positional) == 1:
            import json
            print(json.dumps(do_children(positional[0])))
        elif action == "references" and len(positional) == 1:
            import json
            print(json.dumps(do_references(positional[0])))
        elif action == "fill-hash" and len(positional) == 1 and "scenario" in flags:
            print(do_fill_hash(positional[0], flags["scenario"]))
        elif action == "fill-initiative" and len(positional) == 1 and "anchor" in flags:
            print(do_fill_initiative(positional[0], flags["anchor"]))
        else:
            fail("usage", f"not a stated invocation of `{action}`")
    except Failure as exc:
        fail(exc.code, str(exc))


if __name__ == "__main__":
    main()
