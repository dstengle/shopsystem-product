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
2 on a usage error.
"""
import hashlib
import os
import pathlib
import posixpath
import re
import sys

import yaml

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
    load_point, roles_dir, agent_out, check_dir = DEFAULT_LOAD_POINT, DEFAULT_ROLES, None, None
    findings_only, positional = False, []
    i = 0
    while i < len(args):
        arg = args[i]
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
    try:
        name, text = render(source, roles_dir, load_point)
    except (CompileError, Refused) as exc:
        sys.exit(str(exc))
    digest = text.split("source-digest: sha256:", 1)[1].split("\n", 1)[0]
    if agent_out is None:
        print(f"{source}: compiles as `{name}` for {load_point}/{name}.md (digest {digest})")
        return
    agent_out.parent.mkdir(parents=True, exist_ok=True)
    agent_out.write_text(text)
    print(f"{agent_out}: generated from {name} (digest {digest})")


if __name__ == "__main__":
    main()
