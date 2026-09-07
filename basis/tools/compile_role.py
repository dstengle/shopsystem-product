#!/usr/bin/env python3
"""Compile a role definition into its loadable form, and check a load point.

Experiment apparatus, sibling of compile_process.py: this script exists to
prove the role-definition format carries enough data to compile. The
production compiler is a BC deliverable and does not live in the lead repo.

The loadable form of a role definition is a Claude Code subagent file at
the agent's load point, `.claude/agents/<name>.md`:
  - front-matter carrying only the runtime keys the harness honors
    (name, description, tools, maxTurns, and model / permissionMode /
    skills / memory / disallowedTools / color when the definition carries
    them), plus `source` (the definition's repository path) and
    `source-digest` (sha256 of the definition's text, 12 hex digits);
    the shop's identity keys (type, id, owner, status, approved, version,
    created, updated) are stripped;
  - a generated-file notice, then the definition's body with its
    `## Document History` section stripped and every relative markdown
    link resolved so it is correct from the load point, closing with the
    banned line — "Do not use these words: " and the lint's BANNED list,
    loaded from lint_basis.py beside this script.

Only a definition with `status: approved` compiles; any other is refused.
The rendering is a function of the definition and the declared load point
only — where the file is written does not change its content — so a render
into a scratch directory is byte-equal to the one that would stand at the
load point, and the check compares bytes.

Usage:
  compile_role.py <role.md>                        # validate; print the target name
  compile_role.py <role.md> --agent <out.md>       # render the subagent file
  compile_role.py --check [<dir>] [<role.md>...]   # check a load point (default:
                                                   # the declared load point) against
                                                   # the given approved definitions, or
                                                   # against every approved one under
                                                   # --roles when none is given
  compile_role.py --check [<dir>] --findings       # the same, ok rows suppressed
  compile_role.py --describe                       # answer the standard question
                                                   # (DESCRIPTION below) as JSON on
                                                   # standard output, exit 0, before
                                                   # any other action
Options:
  --load-point <dir>   the declared load point links resolve for
                       (default .claude/agents; repo-root-relative)
  --roles <dir>        the role definitions directory (default basis/roles)

Check rows, one per line, kind first (the finding kinds of skill-rendering):
  ok <name> <definition>          byte-equal to a fresh render
  missing <name> <definition>     approved definition, nothing at the load point
  diverged <name> <definition>    stands there but differs from a fresh render
  will-not-compile <definition> <reason>
                                  a given or approved definition that does
                                  not render (a given one that does not stand
                                  approved is refused here); also a listed
                                  path that cannot be read or parsed —
                                  missing, no front-matter, malformed — and
                                  any unexpected failure while checking a
                                  path, reported with that path as subject
A row is one line: a newline in a path or reason is written as `\\n`.
In check mode no failure escapes as a traceback: whatever cannot be
checked is a row, and the exit is nonzero whenever any finding row exists.
Exit 0 when every row is ok; 1 on any finding, refusal, or compile error;
2 on a usage error. Outside check mode a failure is one line on standard
error beginning with its code from the tool-description data type's
closed set — `unreadable`, `unparseable`, `check-failed`, `unwritable`,
`usage` — never a traceback.
"""
import hashlib
import json
import os
import pathlib
import posixpath
import re
import sys

import yaml

TOOL = "basis/tools/compile_role.py"
EXIT = {"usage": 2, "unreadable": 2, "unparseable": 1, "check-failed": 1,
        "unwritable": 1}


def fail(code: str, message: str) -> None:
    """A failure the answer names: its code beside the message, one line on
    standard error, the exit status the answer states for that code."""
    print(f"{code}: {' '.join(str(message).split())}", file=sys.stderr)
    sys.exit(EXIT[code])


DEFINITION_INPUT = {
    "type": "string",
    "description": "the path of the role definition, for example "
                   "basis/roles/lead-pm.md; it must stand approved",
}
LOAD_POINT_INPUT = {
    "type": "string",
    "description": "the load point the rendering's links resolve for, "
                   "repository-root-relative",
    "default": ".claude/agents",
}
ROLES_INPUT = {
    "type": "string",
    "description": "the directory of the role definitions, "
                   "repository-root-relative",
    "default": "basis/roles",
}
UNREADABLE_FAILURE = {
    "code": "unreadable", "exit_status": 2,
    "condition": "no file exists at <definition>, or it cannot be read; one "
                 "line on standard error beginning `unreadable:` names the "
                 "path; nothing is written",
    "next": "give the path of an existing role definition and run the "
            "invocation again",
}
UNPARSEABLE_FAILURE = {
    "code": "unparseable", "exit_status": 1,
    "condition": "the definition has no front-matter, or its front-matter "
                 "does not parse or is not a mapping; one line on standard "
                 "error beginning `unparseable:` names the path and the "
                 "defect; nothing is written",
    "next": "repair the definition's front-matter and run the invocation "
            "again",
}
RENDER_FAILURE = {
    "code": "check-failed", "exit_status": 1,
    "condition": "the definition does not render: its `type` is not "
                 "role-definition, its `status` is not approved (refused), "
                 "it lacks `name`, `description`, `tools`, or `maxTurns`, "
                 "carries a front-matter key that is neither a runtime key "
                 "the harness honors nor an identity key, or its `name` is "
                 "not a subagent name; one line on standard error beginning "
                 "`check-failed:` names the path and the defect; nothing is "
                 "written",
    "next": "repair the definition at the named defect (the "
            "role-definition typedef states the keys) and run the "
            "invocation again",
}
UNWRITABLE_FAILURE = {
    "code": "unwritable", "exit_status": 1,
    "condition": "<out> could not be written; one line on standard error "
                 "beginning `unwritable:` names the path and the reason",
    "next": "give a writable <out> path and run the invocation again",
}
USAGE_FAILURE = {
    "code": "usage", "exit_status": 2,
    "condition": "the arguments are not one of the three invocations this "
                 "tool states — no definition or more than one outside "
                 "check mode, `--agent` together with `--check`, "
                 "`--findings` without `--check`, an option without its "
                 "value, or an unknown option; the usage sheet on standard "
                 "error; nothing is checked or written",
    "next": "run the invocation the use states, as written",
}
# The answer to the standard question (adr-2026-09-07-tool-answer §2): an
# instance of the tool-description data type, basis/types/tool-description.md.
# This tool is its one home; the skill is produced from it, never edited.
DESCRIPTION = {
    "name": "compile-role",
    "description": (
        "Compiles an approved role definition into its loadable form — the "
        "subagent file at the agent's load point, `.claude/agents/<name>.md`: "
        "the runtime keys the harness honors, `source` and `source-digest`, "
        "and the definition's body with its Document History stripped, its "
        "links resolved for the load point, and the banned-words line from "
        "the lint appended — and checks a load point against a fresh render "
        "of each approved definition. Use it after a role definition "
        "changes, to place its rendering, and to confirm every approved "
        "role is available."
    ),
    "uses": [
        {
            "name": "validate",
            "description": (
                "Renders the definition to memory and prints the subagent "
                "name and the path the rendering would take; writes "
                "nothing. Exit 0 means the definition compiles."
            ),
            "invocation": f"python3 {TOOL} <definition> [--load-point <load_point>] [--roles <roles>]",
            "input_schema": {
                "type": "object",
                "properties": {"definition": DEFINITION_INPUT,
                               "load_point": LOAD_POINT_INPUT,
                               "roles": ROLES_INPUT},
                "required": ["definition"],
                "additionalProperties": False,
            },
            "returns": {
                "form": "text",
                "text": "one line on standard output, `<definition>: compiles "
                        "as \`<name>\` for <load_point>/<name>.md (digest "
                        "<12 hex>)`; exit status 0",
            },
            "failures": [UNREADABLE_FAILURE, UNPARSEABLE_FAILURE, RENDER_FAILURE,
                         USAGE_FAILURE],
        },
        {
            "name": "render",
            "description": (
                "Renders the definition and writes the subagent file to "
                "<out>, creating directories, overwriting what stands there "
                "— a hand edit included. The content is a function of the "
                "definition and the declared load point alone, so a render "
                "into a scratch path is byte-equal to the one that would "
                "stand at the load point."
            ),
            "invocation": f"python3 {TOOL} <definition> --agent <out> [--load-point <load_point>] [--roles <roles>]",
            "input_schema": {
                "type": "object",
                "properties": {
                    "definition": DEFINITION_INPUT,
                    "out": {"type": "string",
                            "description": "the path the subagent file is "
                                           "written to: <load_point>/<name>.md "
                                           "to place it, or a scratch path"},
                    "load_point": LOAD_POINT_INPUT,
                    "roles": ROLES_INPUT,
                },
                "required": ["definition", "out"],
                "additionalProperties": False,
            },
            "returns": {
                "form": "text",
                "text": "one line on standard output, `<out>: generated from "
                        "<name> (digest <12 hex>)`; exit status 0; the file "
                        "written at <out>",
            },
            "failures": [UNREADABLE_FAILURE, UNPARSEABLE_FAILURE, RENDER_FAILURE,
                         UNWRITABLE_FAILURE, USAGE_FAILURE],
        },
        {
            "name": "check",
            "description": (
                "Checks a load point against a fresh render of each given "
                "definition — or, when none is given, of every approved "
                "definition under <roles> — and scans every file at the "
                "load point for one that is no rendering of an approved "
                "definition. Prints one row per line, kind first: `ok "
                "<name> <definition>`, `missing <name> <definition>`, "
                "`diverged <name> <definition>`, `will-not-compile "
                "<definition> <reason>`, `stale <source> <file>`, "
                "`unrecognized <file>`. Writes nothing; no failure escapes "
                "as a traceback — whatever cannot be checked is a row."
            ),
            "invocation": f"python3 {TOOL} --check [<dir>] [--roles <roles>] [--findings] [<definition>...]",
            "input_schema": {
                "type": "object",
                "properties": {
                    "dir": {"type": "string",
                            "description": "the load point directory to check",
                            "default": ".claude/agents"},
                    "roles": ROLES_INPUT,
                    "findings": {"type": "boolean",
                                 "description": "suppress the `ok` rows so "
                                                "only findings are printed",
                                 "default": False},
                    "definition": {"type": "array",
                                   "items": {"type": "string"},
                                   "description": "the definitions to check "
                                                  "against, each a path; a "
                                                  "given definition that "
                                                  "does not stand approved "
                                                  "is a will-not-compile row",
                                   "default": []},
                },
                "required": [],
                "additionalProperties": False,
            },
            "returns": {
                "form": "text",
                "text": "the rows on standard output, one per line, kind "
                        "first, every row `ok` (none printed with "
                        "`--findings`); exit status 0",
            },
            "failures": [
                {"code": "check-failed", "exit_status": 1,
                 "condition": "at least one row is a finding — `missing`, "
                              "`diverged`, `will-not-compile`, `stale`, or "
                              "`unrecognized` — or no definition was checked; "
                              "the rows on standard output name each finding "
                              "by kind, name, and path",
                 "next": "act on each row by kind through the role-rendering "
                         "process: re-render a missing or diverged one with "
                         "the `render` use, remove a stale one, escalate an "
                         "unrecognized or will-not-compile one; then run the "
                         "same invocation again until every row is `ok`"},
                USAGE_FAILURE,
            ],
        },
    ],
}

# The banned vocabulary has one home: the lint beside this compiler. It is
# read from there, never copied, so a change to the lint's list changes every
# rendering at the next re-render with no change here.
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from lint_basis import BANNED  # noqa: E402

BANNED_LINE = "Do not use these words: " + ", ".join(BANNED)
GENERATED_BY = "basis/tools/compile_role.py"
DEFAULT_LOAD_POINT = ".claude/agents"
DEFAULT_ROLES = "basis/roles"

# Runtime keys the harness honors, in rendering order (Claude Code
# subagent front-matter). A key outside this list and IDENTITY_KEYS is a
# compile error: a new key is a decision, never a silent pass-through.
HARNESS_KEYS = [
    "name", "description", "tools", "disallowedTools", "model",
    "permissionMode", "maxTurns", "skills", "memory", "color",
]
IDENTITY_KEYS = {"type", "id", "owner", "status", "approved", "version",
                 "created", "updated"}
REQUIRED_KEYS = ["name", "description", "tools", "maxTurns"]
FM_RE = re.compile(r"---\n(.*?)\n---\n", re.S)
LINK_RE = re.compile(r"\]\(([^)\s]+)\)")
HISTORY_HEADING = "## Document History"


class CompileError(Exception):
    """The definition does not render (a will-not-compile finding)."""


class Refused(Exception):
    """The definition does not stand approved."""


def split(path: pathlib.Path):
    try:
        text = path.read_text()
    except (OSError, UnicodeDecodeError) as exc:
        raise CompileError(f"{path}: cannot be read: {exc}")
    m = FM_RE.match(text)
    if not m:
        raise CompileError(f"{path}: no front-matter")
    try:
        front = yaml.safe_load(m.group(1))
    except yaml.YAMLError as exc:
        raise CompileError(f"{path}: front-matter does not parse: {exc}")
    if not isinstance(front, dict):
        raise CompileError(f"{path}: front-matter is not a mapping")
    return text, front, text[m.end():]


def strip_history(body: str) -> str:
    """Drop the Document History section (to the next `## ` heading or EOF)."""
    pattern = re.compile(r"^" + re.escape(HISTORY_HEADING) + r"\s*$.*?(?=^## |\Z)",
                         re.S | re.M)
    return pattern.sub("", body, count=1)


def resolve_links(body: str, source_dir: str, load_point: str) -> str:
    """Rewrite relative links so they resolve from the load point."""
    def one(m):
        target = m.group(1)
        if target.startswith(("http://", "https://", "pkg:", "mailto:", "/", "#")):
            return m.group(0)
        path, sep, anchor = target.partition("#")
        moved = posixpath.relpath(posixpath.normpath(posixpath.join(source_dir, path)),
                                  posixpath.normpath(load_point))
        return f"]({moved}{sep}{anchor})"
    return LINK_RE.sub(one, body)


def repo_relative(path: str) -> str:
    """A repo-root-relative posix path (the run's working directory is the root)."""
    rel = os.path.relpath(os.path.abspath(path), os.getcwd())
    return posixpath.normpath(rel.replace(os.sep, "/"))


def shown_path(path: pathlib.Path) -> str:
    """Repo-relative when under the root; as given when outside it (a scratch dir)."""
    rel = repo_relative(str(path))
    return str(path) if rel.startswith("..") else rel


def render(source: pathlib.Path, roles_dir: str, load_point: str):
    """Return (name, rendered text) for an approved role definition."""
    text, front, body = split(source)
    if front.get("type") != "role-definition":
        raise CompileError(f"{source}: type is `{front.get('type')}`, not role-definition")
    if front.get("status") != "approved":
        raise Refused(f"{source}: refused — status is `{front.get('status')}`; "
                      "only an approved role definition compiles")
    for key in REQUIRED_KEYS:
        if not front.get(key):
            raise CompileError(f"{source}: front-matter lacks `{key}` "
                               "(role-definition typedef §Required frontmatter)")
    unknown = sorted(set(front) - set(HARNESS_KEYS) - IDENTITY_KEYS)
    if unknown:
        raise CompileError(f"{source}: front-matter key(s) {unknown} are neither "
                           "runtime keys the harness honors nor identity keys")
    name = str(front["name"])
    if not re.match(r"^[a-z0-9][a-z0-9-]*$", name):
        raise CompileError(f"{source}: name `{name}` is not a subagent name")
    source_rel = posixpath.join(repo_relative(roles_dir), source.name)
    digest = hashlib.sha256(text.encode()).hexdigest()[:12]
    fm = {key: front[key] for key in HARNESS_KEYS if key in front}
    fm["source"] = source_rel
    fm["source-digest"] = f"sha256:{digest}"
    front_text = yaml.safe_dump(fm, sort_keys=False, allow_unicode=True,
                                width=1_000_000).rstrip()
    notice = (f"<!-- Generated from `{source_rel}` by `{GENERATED_BY}`; do not edit by\n"
              f"hand — edit the role definition and re-render. -->")
    body = resolve_links(strip_history(body), repo_relative(roles_dir), load_point)
    body = body.strip("\n") + "\n\n" + BANNED_LINE
    return name, f"---\n{front_text}\n---\n\n{notice}\n\n{body}\n"


def row(text: str) -> str:
    """One finding row is one line: a newline in a path or reason is written
    as the two characters `\\n`, so a row list stays one row per line."""
    return text.replace("\r", "\\r").replace("\n", "\\n")


def failure(subject: str, exc: BaseException) -> str:
    """The will-not-compile row for a path that could not be checked."""
    reason = str(exc) if isinstance(exc, (CompileError, Refused)) \
        else f"{type(exc).__name__}: {exc}"
    return row(f"will-not-compile {subject} {reason}")


def check_definition(definition: pathlib.Path, shown_def: str, given: bool,
                     load_dir: pathlib.Path, roles_dir: str, load_point: str,
                     fresh: dict):
    """The row for one listed definition, or None for one an unlisted sweep
    skips (not a role definition, or not approved)."""
    _, front, _ = split(definition)
    if not given and (front.get("type") != "role-definition"
                      or front.get("status") != "approved"):
        return None
    name, text = render(definition, roles_dir, load_point)
    fresh[posixpath.join(repo_relative(roles_dir), definition.name)] = name
    target = load_dir / f"{name}.md"
    if not target.is_file():
        return f"missing {name} {shown_def}"
    if target.read_text() != text:
        return f"diverged {name} {shown_def}"
    return f"ok {name} {shown_def}"


def check_rendering(path: pathlib.Path, shown: str, roles_prefix: str, fresh: dict):
    """The row for one file at the load point, or None when it is current."""
    try:
        _, front, _ = split(path)
        source = front.get("source")
    except CompileError:
        source = None
    if not isinstance(source, str) or not source.startswith(roles_prefix):
        return f"unrecognized {shown}"
    if source not in fresh:
        return f"stale {source} {shown}"
    if path.name != f"{fresh[source]}.md":
        return f"unrecognized {shown}"
    return None


def check(load_dir: pathlib.Path, roles_dir: str, load_point: str,
          definitions: list = None) -> list:
    """Rows for a load point. `definitions` is the set to check against — the
    process's enumerated approved list; when None, every approved definition
    under roles_dir. A given definition that does not stand approved is a
    will-not-compile row (the compiler refuses it), never silently admitted.
    A listed path that cannot be read or parsed, and any other failure while
    checking a path, is a will-not-compile row with that path as subject —
    the check continues; nothing escapes it as a traceback."""
    rows, fresh = [], {}
    given = definitions is not None
    if not given:
        definitions = sorted(pathlib.Path(roles_dir).glob("*.md"))
    for definition in (pathlib.Path(d) for d in definitions):
        shown_def = shown_path(definition)
        try:
            found = check_definition(definition, shown_def, given,
                                     load_dir, roles_dir, load_point, fresh)
        except Exception as exc:  # noqa: BLE001 — every failure is a row
            rows.append(failure(shown_def, exc))
            continue
        if found is not None:
            rows.append(row(found))
    roles_prefix = repo_relative(roles_dir) + "/"
    for path in sorted(load_dir.glob("*.md")) if load_dir.is_dir() else []:
        shown = shown_path(path)
        try:
            found = check_rendering(path, shown, roles_prefix, fresh)
        except Exception as exc:  # noqa: BLE001
            rows.append(failure(shown, exc))
            continue
        if found is not None:
            rows.append(row(found))
    return rows


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
    load_point, roles_dir, agent_out, check_dir = DEFAULT_LOAD_POINT, DEFAULT_ROLES, None, None
    findings_only, positional = False, []
    i = 0
    while i < len(args):
        arg = args[i]
        if arg in ("--load-point", "--roles", "--agent") and i + 1 >= len(args):
            usage()
        if arg == "--load-point":
            load_point = args[i + 1]; i += 2
        elif arg == "--roles":
            roles_dir = args[i + 1]; i += 2
        elif arg == "--agent":
            agent_out = pathlib.Path(args[i + 1]); i += 2
        elif arg == "--findings":
            findings_only = True; i += 1
        elif arg == "--check":
            check_dir = load_point
            if i + 1 < len(args) and not args[i + 1].startswith("--"):
                check_dir = args[i + 1]; i += 1
            i += 1
        elif arg.startswith("--"):
            usage()
        else:
            positional.append(arg); i += 1
    if check_dir is not None:
        if agent_out:
            usage()
        try:
            rows = check(pathlib.Path(check_dir), roles_dir, load_point,
                         positional or None)
        except Exception as exc:  # noqa: BLE001 — the path in hand is the load point
            rows = [failure(check_dir, exc)]
        clean = bool(rows) and all(r.startswith("ok ") for r in rows)
        if findings_only:
            rows = [r for r in rows if not r.startswith("ok ")]
        if rows:
            print("\n".join(rows))
        sys.exit(0 if clean else 1)
    if findings_only:
        usage()
    if len(positional) != 1:
        usage()
    source = pathlib.Path(positional[0])
    if roles_dir == DEFAULT_ROLES and repo_relative(str(source.parent)) != DEFAULT_ROLES:
        roles_dir = str(source.parent)
    if not source.is_file():
        fail("unreadable", f"{source}: no such file")
    try:
        name, text = render(source, roles_dir, load_point)
    except (CompileError, Refused) as exc:
        reason = str(exc)
        if "cannot be read" in reason:
            fail("unreadable", reason)
        if "front-matter" in reason and "lacks" not in reason and "key(s)" not in reason:
            fail("unparseable", reason)
        fail("check-failed", reason)
    except Exception as exc:  # noqa: BLE001 — never a traceback
        fail("check-failed", f"{source}: does not render: {type(exc).__name__}: {exc}")
    digest = text.split("source-digest: sha256:", 1)[1].split("\n", 1)[0]
    if agent_out is None:
        print(f"{source}: compiles as `{name}` for {load_point}/{name}.md (digest {digest})")
        return
    try:
        agent_out.parent.mkdir(parents=True, exist_ok=True)
        agent_out.write_text(text)
    except OSError as exc:
        fail("unwritable", f"{agent_out}: cannot be written: {exc}")
    print(f"{agent_out}: generated from {name} (digest {digest})")


if __name__ == "__main__":
    main()
