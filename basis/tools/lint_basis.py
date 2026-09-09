#!/usr/bin/env python3
"""Lint the basis corpus: structure, references, vocabulary.

Experiment apparatus; the production linter is a BC deliverable
(shopsystem-knowledge owns the type system). Each check cites the clause
it projects, per the cite-or-delete rule.

Checks:
  1. Front-matter parses and carries the identity base
     (definition typedef §Required frontmatter).
  2. `defines` values are unique across the registry
     (artifact-typedef + data-type typedefs: defines is what $ref resolves).
  3. Every distinct `$ref` in a process data block carries a `from:`
     source at least once — a relative link to the defining file, or a
     `pkg:<package>/<type>` reference to another package
     (process-definition typedef §Data). Local sources must exist and
     their `defines` must match.
  4. Relative markdown links resolve to existing files.
  5. Required headings per type are present
     (each type's typedef §Required sections).
  6. Banned vocabulary does not reappear
     (use-defined-terms: the losing term is removed everywhere).
  7. `version` present and `Document History` is the last section
     (definition typedef §Required frontmatter, §Required sections 3);
     generated renderings are exempt.
  8. No numbered-decision reference (review-record typedef §Commitment:
     decisions live as changes in the artifacts they affect).
  9. Each received request in `requests/` at the repository root — the
     directory may not exist yet — carries the frontmatter of a received
     ask: `type: request`, `id`, `status` in {recorded, routed, declined,
     done}, `version`, `date`, `reader`, `owner`, `originator`,
     `received-through`, `route` in {awaiting, discovery, small-change,
     declined}, `route-reason`; a `routed-to` link, when present,
     resolves before any `#` fragment — the request's own path is
     accepted, the small-change lane's result being the request's
     Result section by fragment (request typedef §Required
     frontmatter). Checks 1-8 walk
     basis/ as before; --derive-chain reads .claude/skills/ as before.
 10. Each decision brief in `briefs/` at the repository root — the
     directory may not exist yet; a brief is a file whose `type` is
     `decision-brief`, and the annexes beside it (a brief's linked full
     material, of no fixed frontmatter) are not briefs and are not
     walked — carries the decision-brief typedef's closed field set and
     nothing outside it: `type: decision-brief`, `id`, `status` in {draft, delivered,
     decided}, `version`, `date`, `reader`, `decisions-requested`,
     `annex`, and the optional `relates-to` — a list of one or more
     paths, each resolving from the repository root (decision-brief
     typedef §Required frontmatter). `--brief <path>` runs the same
     rules on that one file alone. Checks 1-9 as before.
 11. Every repository tool path a process definition under
     `basis/processes/` names — `basis/tools/<name>.py`, written in a
     step's `run:` template or held as the `initial:` value of a data
     value or parameter that a template interpolates (`${compiler}` and
     its kind) — exists in the repository; each that does not is
     reported naming the definition and the missing path
     (process-definition typedef §Commitment: a process is not approved
     while a step names a tool the repository lacks — the tool is a
     request, routed before the process runs, never built mid-process).
     `bd`, `python3`, and the sh utilities are the environment and are
     not checked. `--process <path>` runs the same check on the one
     process definition at that path, wherever it lives. Checks 1-10 as
     before.
 12. Each implementation guidance record in `guidance/` at the
     repository root — the directory may not exist yet: no records, no
     violations — carries the implementation-guidance typedef's
     required frontmatter: `type: implementation-guidance`, `id`,
     `status`, `version`, `initiative`, `feature`, `context`,
     `scenarios`, `owner`, `created`, `updated`; each missing key is
     reported by name (implementation-guidance typedef §Required
     frontmatter). Checks 1-11 as before.
 13. Each initiative in `initiatives/` at the repository root — the
     directory may not exist yet: no initiatives, no violations — whose
     `parent` names another initiative is listed in that parent's
     `Sub-initiatives` section, and that section lists nothing else:
     the parent's list is derived from the children's `parent` fields
     and held to them here (initiative typedef §Required sections 7).
     A `parent` naming no initiative in the directory, a parent with
     no `Sub-initiatives` section, a child missing from the list, and
     an entry in the list that names no child are each reported.
     Checks 1-12 as before.
 14. Old-term vocabulary measure (req-2026-09-08-definition-vs-instance;
     feat-execution-vocabulary §the corpus measure reaches its target):
     every file under `basis/` (`.md` and `basis/tools/*.py`) and every
     delivered feature in `features/` at the repository root, outside
     the superseded set (a feature this feature's scenarios restate:
     `feat-process-runner.md`, `feat-request-routing.md`,
     `feat-initiative-cost-rollup.md`, `feat-flow-simplification.md`,
     `feat-plain-voice.md`, `feat-run-measurement.md`), reported once
     if it still uses `run` as a noun for a process instance or
     `anchor` to name the work register's identifier — a file's
     `Document History` section is excluded, never edited in place.
     Heuristic and line-pattern based, like check 6; reports files, not
     a line total. Checks 1-13 as before.

Modes:
  lint_basis.py                     # lint the whole basis tree
  lint_basis.py --brief PATH        # check one decision brief alone by
                                    # check 10's rules (exit 0 on pass)
  lint_basis.py --process PATH      # check one process definition alone
                                    # by check 11's rule (exit 0 on pass)
  lint_basis.py --derive-chain X    # print the derived definition chain
                                    # for artifact type X (definition-chain
                                    # is assembled from references, never
                                    # hand-written)
  lint_basis.py --describe          # answer the standard question: write
                                    # this tool's description — DESCRIPTION
                                    # below, an instance of the
                                    # tool-description data type — as JSON
                                    # to standard output and exit 0 before
                                    # any other action, other arguments
                                    # ignored (adr-2026-09-07-tool-answer
                                    # §2); the skill at the agent's load
                                    # point is produced from this answer
                                    # by compile_tool.py and from nothing
                                    # else

Any other arguments are a usage failure: one line on standard error
beginning `usage:`, exit status 2. A --brief or --process path that does
not exist or cannot be read is an unreadable failure: one line on
standard error beginning `unreadable:`, exit status 2.
"""
import json
import pathlib
import re
import sys

import yaml

BASIS = pathlib.Path(__file__).resolve().parent.parent

IDENTITY_BASE = ["type", "id", "status", "created", "updated"]
OWNER_EXEMPT = {"experiment-index", "skill", "principles-rendering", "review-record"}
REQUIRED_HEADINGS = {
    # artifact-typedef §Required sections 1-6
    "artifact-typedef": ["Identity and ancestry", "Required frontmatter",
                         "Required sections", "Commitment (Definition of Done)",
                         "Sources", "Derived review checklist"],
    # process-definition typedef §Required sections 5-8
    "process-definition": ["Flow (compiled)", "Data", "Steps", "Derived checks"],
    # data-type typedef §Required sections 1-2
    "data-type": ["Purpose", "Schema"],
    # fitness-set typedef §Required sections 1-2
    "fitness-set": ["Scenarios", "Compile mapping"],
    # glossary typedef §Required sections 1-2
    "glossary": ["How the list combines", "Terms"],
    # review-record typedef §Required sections 1-3
    "review-record": ["Material", "Outcomes", "State"],
}
# review-record typedef §Commitment: no live document cites a numbered
# decision (Rn) — decisions live as changes in the artifacts they affect.
DECISION_REF = re.compile(r"\bR\d{1,3}\b")
BANNED = ["ratif", "disposition", "rebaseline bill", "surface", "seat"]
PKG_RE = re.compile(r"^pkg:[a-z0-9-]+/[a-z0-9_-]+$")

# 14. old-term vocabulary measure (req-2026-09-08-definition-vs-instance /
# feat-execution-vocabulary): the superseded set this feature's scenarios
# restate — never edited under this measure.
VOCAB_SUPERSEDED_FEATURES = {
    "feat-process-runner.md", "feat-request-routing.md",
    "feat-initiative-cost-rollup.md", "feat-flow-simplification.md",
    "feat-plain-voice.md", "feat-run-measurement.md",
}
RUN_NOUN_RE = re.compile(r"\b(a|the|this|one|another|each|no|any)\s+runs?\b|\brun's\b", re.I)
ANCHOR_ID_RE = re.compile(r"--anchor\b|\banchor_id\b|\brun_anchor\b", re.I)

# 9. received requests (request typedef §Required frontmatter)
REQUESTS = BASIS.parent / "requests"
REQUEST_KEYS = ["type", "id", "status", "version", "date", "reader", "owner",
                "originator", "received-through", "route", "route-reason"]
REQUEST_STATUS = {"recorded", "routed", "declined", "done"}
REQUEST_ROUTE = {"awaiting", "discovery", "small-change", "declined"}

# 10. decision briefs (decision-brief typedef §Required frontmatter)
BRIEFS = BASIS.parent / "briefs"
BRIEF_KEYS = ["type", "id", "status", "version", "date", "reader",
              "decisions-requested", "annex"]
BRIEF_OPTIONAL = {"relates-to"}
BRIEF_STATUS = {"draft", "delivered", "decided"}

# 11. tools a process names (process-definition typedef §Commitment)
PROCESSES = BASIS / "processes"
TOOL_PATH = re.compile(r"basis/tools/[A-Za-z0-9_.-]+\.py")

# 12. implementation guidance records (implementation-guidance typedef
#     §Required frontmatter)
GUIDANCE = BASIS.parent / "guidance"
GUIDANCE_KEYS = ["type", "id", "status", "version", "initiative", "feature",
                 "context", "scenarios", "owner", "created", "updated"]

# 13. sub-initiatives (initiative typedef §Required sections 7)
INITIATIVES = BASIS.parent / "initiatives"
SUB_HEADING = re.compile(r"^#{2,3} (?:\d+\.\s*)?Sub-initiatives\s*$", re.M)

TOOL = "basis/tools/lint_basis.py"
USAGE_FAILURE = {
    "code": "usage",
    "exit_status": 2,
    "condition": "the arguments are not one of the four invocations this "
                 "tool states; one line on standard error beginning "
                 "`usage:` names them; nothing is checked",
    "next": "run the invocation the use states, as written",
}
CHECK_FAILURE = {
    "code": "check-failed",
    "exit_status": 1,
    "condition": "the check found violations: one line per violation on "
                 "standard output, `<path>[:<line>]: <what> (<clause>)`, "
                 "then the last line `FAIL: <n> violation(s)`",
    "next": "repair each named file at the named clause, then run the "
            "same invocation again until its last line reads "
            "`PASS: 0 violation(s)`",
}
UNREADABLE_FAILURE = {
    "code": "unreadable",
    "exit_status": 2,
    "condition": "no file exists at <path>, or it cannot be read; one line "
                 "on standard error beginning `unreadable:` names the path",
    "next": "give the path of an existing file, relative to the current "
            "directory or absolute, and run the invocation again",
}
PASS_TEXT = ("the last line `PASS: 0 violation(s)` on standard output, "
             "nothing before it; exit status 0")
# The answer to the standard question (adr-2026-09-07-tool-answer §2): an
# instance of the tool-description data type, basis/types/tool-description.md.
# This tool is its one home; the skill is produced from it, never edited.
DESCRIPTION = {
    "name": "lint-basis",
    "description": (
        "The lint over the lead shop's definition corpus: checks the basis "
        "tree and the request, brief, and guidance records at the repository "
        "root against their typedefs' rules, derives an artifact type's "
        "definition chain from the references its documents carry, and "
        "checks one decision brief or one process definition alone. Use it "
        "before reporting any change to the tree, after editing a "
        "definition, brief, request, or guidance record, when a process "
        "definition names a tool, and when an artifact type's chain is "
        "wanted; it changes no file."
    ),
    "uses": [
        {
            "name": "lint",
            "description": (
                "Runs checks 1-14 over every markdown file under basis/ and "
                "over requests/, briefs/, guidance/, and initiatives/ at the "
                "repository root: frontmatter identity, unique `defines`, "
                "`$ref` sources, resolvable links, required headings, banned "
                "vocabulary, version and Document History, no "
                "numbered-decision reference, request frontmatter, brief "
                "frontmatter, tools named by process definitions, guidance "
                "frontmatter, each parent initiative's Sub-initiatives "
                "list held to its children's `parent` fields, and the "
                "old-term vocabulary measure (run as a noun, anchor for the "
                "identifier) outside the superseded set. Reads only; "
                "writes and changes "
                "nothing. The tree is found from the tool's own location, "
                "so the current directory does not matter."
            ),
            "invocation": f"python3 {TOOL}",
            "input_schema": {"type": "object", "properties": {},
                             "additionalProperties": False},
            "returns": {"form": "text", "text": PASS_TEXT},
            "failures": [CHECK_FAILURE, USAGE_FAILURE],
        },
        {
            "name": "check-brief",
            "description": (
                "Checks one decision brief alone by check 10's rules: the "
                "decision-brief typedef's closed frontmatter field set, its "
                "status vocabulary, and that every `relates-to` path "
                "resolves from the repository root. Reads only; the rest of "
                "the tree is not checked."
            ),
            "invocation": f"python3 {TOOL} --brief <path>",
            "input_schema": {
                "type": "object",
                "properties": {"path": {
                    "type": "string",
                    "description": "the path of the decision brief to check, "
                                   "relative to the current directory or "
                                   "absolute"}},
                "required": ["path"],
                "additionalProperties": False,
            },
            "returns": {"form": "text", "text": PASS_TEXT},
            "failures": [CHECK_FAILURE, UNREADABLE_FAILURE, USAGE_FAILURE],
        },
        {
            "name": "check-process",
            "description": (
                "Checks one process definition alone by check 11's rule: "
                "every repository tool path it names — `basis/tools/<name>.py` "
                "in a step's `run:` template or an `initial:` value — exists "
                "in the repository. Reads only; the rest of the tree is not "
                "checked."
            ),
            "invocation": f"python3 {TOOL} --process <path>",
            "input_schema": {
                "type": "object",
                "properties": {"path": {
                    "type": "string",
                    "description": "the path of the process definition to "
                                   "check, relative to the current directory "
                                   "or absolute"}},
                "required": ["path"],
                "additionalProperties": False,
            },
            "returns": {"form": "text", "text": PASS_TEXT},
            "failures": [CHECK_FAILURE, UNREADABLE_FAILURE, USAGE_FAILURE],
        },
        {
            "name": "derive-chain",
            "description": (
                "Derives the definition chain of one artifact type from the "
                "references the documents under basis/ and the skills at "
                ".claude/skills/ carry — the typedef by `defines`, the "
                "guideline and fitness set by `target-type`, the process by "
                "`produces`, its roles from the steps, the skill by "
                "`derived-from` — and prints it. Never hand-written. An "
                "artifact type no typedef defines yields a chain with every "
                "link empty and status draft: that is a result, not a "
                "failure. Reads only."
            ),
            "invocation": f"python3 {TOOL} --derive-chain <artifact_type>",
            "input_schema": {
                "type": "object",
                "properties": {"artifact_type": {
                    "type": "string",
                    "description": "the artifact type whose chain to derive: "
                                   "the `defines` value of its typedef, for "
                                   "example `feature`"}},
                "required": ["artifact_type"],
                "additionalProperties": False,
            },
            "returns": {
                "form": "yaml",
                "output_schema": {
                    "type": "object",
                    "description": "the definition-chain data type, "
                                   "basis/types/definition-chain.md: each "
                                   "link is the id of the document found, or "
                                   "empty when none is; status is approved "
                                   "only when every link is found and "
                                   "approved",
                    "properties": {
                        "artifact_type": {"type": "string"},
                        "typedef": {"type": "string"},
                        "guideline": {"type": "string"},
                        "fitness": {"type": "string"},
                        "process": {"type": "string"},
                        "roles": {"type": "array", "items": {"type": "string"}},
                        "skill": {"type": "string"},
                        "status": {"type": "string", "enum": ["draft", "approved"]},
                    },
                    "required": ["artifact_type", "typedef", "guideline",
                                 "fitness", "process", "roles", "skill",
                                 "status"],
                },
            },
            "failures": [USAGE_FAILURE],
        },
    ],
}


def front_matter(path):
    text = path.read_text()
    m = re.match(r"---\n(.*?)\n---\n", text, re.S)
    if not m:
        return None, text
    try:
        return yaml.safe_load(m.group(1)), text
    except yaml.YAMLError:
        return None, text


def yaml_blocks(text):
    out = {}
    for fence in re.findall(r"```yaml\n(.*?)```", text, re.S):
        block = yaml.safe_load(fence)
        if isinstance(block, dict):
            out.update(block)
    return out


def collect_refs(node):
    refs = set()
    if isinstance(node, dict):
        for k, v in node.items():
            if k == "$ref":
                refs.add(v)
            else:
                refs |= collect_refs(v)
    elif isinstance(node, list):
        for item in node:
            refs |= collect_refs(item)
    return refs


def registry():
    reg = {}
    for tree in ("artifacts", "types"):
        for path in (BASIS / tree).glob("*.md"):
            fm, _ = front_matter(path)
            if fm and fm.get("defines"):
                reg[fm["defines"]] = path
    return reg


def lint():
    errors = []
    reg = registry()

    seen_defines = {}
    for path in sorted(BASIS.rglob("*.md")):
        rel = path.relative_to(BASIS)
        fm, text = front_matter(path)

        # 1. identity base
        if fm is None:
            errors.append(f"{rel}: front-matter missing or unparseable (definition §Required frontmatter)")
            continue
        for field in IDENTITY_BASE:
            if field not in fm:
                errors.append(f"{rel}: front-matter lacks `{field}` (definition §Required frontmatter)")
        if fm.get("type") not in OWNER_EXEMPT and "owner" not in fm:
            errors.append(f"{rel}: front-matter lacks `owner` (definition §Required frontmatter)")

        # 7. version + Document History (definition §Required frontmatter,
        #    §Required sections 3); generated renderings are exempt.
        if not fm.get("generated"):
            if "version" not in fm:
                errors.append(f"{rel}: front-matter lacks `version` (definition §Required frontmatter)")
            h2s = re.findall(r"^## (.+)$", text, re.M)
            if not h2s or h2s[-1].strip() != "Document History":
                errors.append(f"{rel}: `Document History` is not the last section (definition §Required sections 3)")
            if "verified-by" in fm:
                errors.append(f"{rel}: review-log frontmatter `verified-by` is ruled out (definition §Required sections 3)")

        # 2. defines uniqueness
        if fm.get("defines"):
            if fm["defines"] in seen_defines:
                errors.append(f"{rel}: duplicate defines `{fm['defines']}` (also {seen_defines[fm['defines']]})")
            seen_defines[fm["defines"]] = rel

        # 4. relative links resolve
        for target in re.findall(r"\]\(([^)#\s]+)\)", text):
            if target.startswith(("http://", "https://", "pkg:")):
                continue
            if not (path.parent / target).exists():
                errors.append(f"{rel}: broken link `{target}`")

        # 5. required headings
        headings = re.findall(r"^#{1,3} (.+)$", text, re.M)
        for req in REQUIRED_HEADINGS.get(fm.get("type"), []):
            if not any(h.strip().startswith(req) for h in headings):
                errors.append(f"{rel}: missing required heading `{req}` ({fm.get('type')} typedef §Required sections)")

        # 8. no numbered-decision references (review-record §Commitment)
        for i, line in enumerate(text.splitlines(), 1):
            if DECISION_REF.search(line):
                errors.append(f"{rel}:{i}: numbered-decision reference (decisions live as changes in the artifacts they affect)")

        # 6. banned vocabulary
        if rel.name != "README.md" and rel.name != "base-writing-style.md":
            for i, line in enumerate(text.splitlines(), 1):
                if "Replaces" in line or line.lstrip().startswith(("approved:", "ratified:")):
                    continue
                for term in BANNED:
                    if term in line.lower():
                        errors.append(f"{rel}:{i}: banned term `{term}` (use-defined-terms; see glossary)")

        # 3. $ref sources in process data blocks
        if fm.get("type") == "process-definition":
            spec = yaml_blocks(text)
            data = spec.get("data", {})
            refs = collect_refs(data)
            sourced = {}
            def walk(node):
                if isinstance(node, dict):
                    if "$ref" in node and node.get("from"):
                        sourced[node["$ref"]] = node["from"]
                    for v in node.values():
                        walk(v)
                elif isinstance(node, list):
                    for i in node:
                        walk(i)
            walk(data)
            for ref in sorted(refs):
                src = sourced.get(ref)
                if not src:
                    errors.append(f"{rel}: $ref `{ref}` has no `from:` source (process-definition §Data)")
                elif src.startswith("pkg:"):
                    if not PKG_RE.match(src):
                        errors.append(f"{rel}: `{src}` is not pkg:<package>/<type> (process-definition §Data)")
                else:
                    target = (path.parent / src).resolve()
                    if not target.exists():
                        errors.append(f"{rel}: from `{src}` does not exist")
                    else:
                        tfm, _ = front_matter(target)
                        if not tfm or tfm.get("defines") != ref:
                            errors.append(f"{rel}: from `{src}` does not define `{ref}`")
    errors += lint_requests()
    errors += lint_briefs()
    for path in sorted(PROCESSES.glob("*.md")):
        fm, _ = front_matter(path)
        if fm is not None and fm.get("type") == "process-definition":
            errors += lint_process_tools(path)
    errors += lint_guidance()
    errors += lint_sub_initiatives()
    return errors


def lint_requests():
    """9. Each received request in requests/ carries the frontmatter of a
    received ask (request typedef §Required frontmatter). The directory
    may not exist yet: no requests, no violations."""
    errors = []
    if not REQUESTS.is_dir():
        return errors
    clause = "(request typedef §Required frontmatter)"
    for path in sorted(REQUESTS.glob("*.md")):
        rel = path.relative_to(BASIS.parent)
        fm, _ = front_matter(path)
        if fm is None:
            errors.append(f"{rel}: front-matter missing or unparseable {clause}")
            continue
        for key in REQUEST_KEYS:
            if key not in fm:
                errors.append(f"{rel}: front-matter lacks `{key}` {clause}")
        if "type" in fm and fm["type"] != "request":
            errors.append(f"{rel}: `type` is `{fm['type']}`, not `request` {clause}")
        if "status" in fm and fm["status"] not in REQUEST_STATUS:
            errors.append(f"{rel}: `status` `{fm['status']}` not in {sorted(REQUEST_STATUS)} {clause}")
        if "route" in fm and fm["route"] not in REQUEST_ROUTE:
            errors.append(f"{rel}: `route` `{fm['route']}` not in {sorted(REQUEST_ROUTE)} {clause}")
        target = fm.get("routed-to")
        if target:
            if not isinstance(target, str):
                errors.append(f"{rel}: `routed-to` is not a link {clause}")
            else:
                # Resolve the part before any `#` fragment, as check 4 does
                # for markdown links; the small-change lane's result is the
                # request's own Result section by fragment, so the request's
                # own repository-root path is accepted.
                link = target.split("#", 1)[0]
                if not link.startswith(("http://", "https://", "pkg:")) \
                        and link != rel.as_posix() \
                        and not (path.parent / link).exists():
                    errors.append(f"{rel}: broken link `{target}` in `routed-to` {clause}")
    return errors


def lint_briefs():
    """10. Each decision brief in briefs/ carries the decision-brief
    typedef's closed field set and nothing outside it, and every
    relates-to path resolves from the repository root. The directory may
    not exist yet: no briefs, no violations. A brief is a file whose type
    is decision-brief; the annexes beside it — a brief's linked full
    material, of no fixed frontmatter — are not briefs and are not
    walked."""
    errors = []
    if not BRIEFS.is_dir():
        return errors
    for path in sorted(BRIEFS.glob("*.md")):
        fm, _ = front_matter(path)
        if fm is not None and fm.get("type") == "decision-brief":
            errors += lint_brief(path)
    return errors


def lint_brief(path):
    """Check one decision brief by check 10's rules (decision-brief
    typedef §Required frontmatter); the same rules for the tree walk
    and for --brief. Paths under relates-to resolve from the repository
    root, wherever the brief file lives."""
    errors = []
    clause = "(decision-brief typedef §Required frontmatter)"
    root = BASIS.parent
    full = path.resolve()
    rel = full.relative_to(root) if full.is_relative_to(root) else path
    fm, _ = front_matter(path)
    if fm is None:
        errors.append(f"{rel}: front-matter missing or unparseable {clause}")
        return errors
    for key in BRIEF_KEYS:
        if key not in fm:
            errors.append(f"{rel}: front-matter lacks `{key}` {clause}")
    for key in fm:
        if key not in BRIEF_KEYS and key not in BRIEF_OPTIONAL:
            errors.append(f"{rel}: unknown front-matter key `{key}` — the field set is closed {clause}")
    if "type" in fm and fm["type"] != "decision-brief":
        errors.append(f"{rel}: `type` is `{fm['type']}`, not `decision-brief` {clause}")
    if "status" in fm and fm["status"] not in BRIEF_STATUS:
        errors.append(f"{rel}: `status` `{fm['status']}` not in {sorted(BRIEF_STATUS)} {clause}")
    if "relates-to" in fm:
        targets = fm["relates-to"]
        if not isinstance(targets, list) or not targets:
            errors.append(f"{rel}: `relates-to` is not a list of one or more paths {clause}")
        else:
            for target in targets:
                if not isinstance(target, str) or not target:
                    errors.append(f"{rel}: `relates-to` entry `{target}` is not a path {clause}")
                elif not (root / target).is_file():
                    errors.append(f"{rel}: `relates-to` path `{target}` does not resolve from the repository root {clause}")
    return errors


def lint_process_tools(path):
    """11. Every repository tool path one process definition names exists
    (process-definition typedef §Commitment: a process is not approved
    while a step names a tool the repository lacks — the tool is a
    request, routed before the process runs, never built mid-process).
    A tool path is `basis/tools/<name>.py`, written in a step's `run:`
    template or held as the `initial:` value of a data value or
    parameter a template interpolates; it resolves from the repository
    root. `bd`, `python3`, and the sh utilities are the environment and
    are not checked. The same rule for the tree walk and for --process."""
    errors = []
    clause = "(process-definition typedef §Commitment)"
    root = BASIS.parent
    full = path.resolve()
    rel = full.relative_to(root) if full.is_relative_to(root) else path
    fm, text = front_matter(path)
    if fm is None:
        errors.append(f"{rel}: front-matter missing or unparseable {clause}")
        return errors
    spec = yaml_blocks(text)
    sites = []  # (where the path is named, text to scan)
    for block in ("data", "parameters"):
        values = spec.get(block)
        if isinstance(values, dict):
            for name, decl in values.items():
                if isinstance(decl, dict) and isinstance(decl.get("initial"), str):
                    sites.append((f"`{block}.{name}` initial", decl["initial"]))
    for step in spec.get("steps") or []:
        if isinstance(step, dict) and isinstance(step.get("run"), str):
            sites.append((f"step `{step.get('id', '?')}` run", step["run"]))
    seen = set()
    for where, scanned in sites:
        for tool in TOOL_PATH.findall(scanned):
            if (where, tool) in seen:
                continue
            seen.add((where, tool))
            if not (root / tool).is_file():
                errors.append(f"{rel}: {where} names `{tool}`, which does not exist in the repository {clause}")
    return errors


def lint_guidance():
    """12. Each implementation guidance record in guidance/ at the
    repository root carries the implementation-guidance typedef's
    required frontmatter (implementation-guidance typedef §Required
    frontmatter); each missing key is reported by name. The directory
    may not exist yet: no records, no violations."""
    errors = []
    if not GUIDANCE.is_dir():
        return errors
    clause = "(implementation-guidance typedef §Required frontmatter)"
    for path in sorted(GUIDANCE.glob("*.md")):
        rel = path.relative_to(BASIS.parent)
        fm, _ = front_matter(path)
        if fm is None:
            errors.append(f"{rel}: front-matter missing or unparseable {clause}")
            continue
        for key in GUIDANCE_KEYS:
            if key not in fm:
                errors.append(f"{rel}: front-matter lacks `{key}` {clause}")
        if "type" in fm and fm["type"] != "implementation-guidance":
            errors.append(f"{rel}: `type` is `{fm['type']}`, not `implementation-guidance` {clause}")
    return errors


def lint_sub_initiatives():
    """13. Each parent initiative's Sub-initiatives section lists exactly
    the initiatives whose `parent` names it (initiative typedef §Required
    sections 7): the list is derived from the children's `parent` fields
    and held to them here. The directory may not exist yet: no
    initiatives, no violations."""
    errors = []
    if not INITIATIVES.is_dir():
        return errors
    clause = "(initiative typedef §Required sections 7)"
    root = BASIS.parent
    docs = {}  # id -> (rel, text)
    for path in sorted(INITIATIVES.glob("*.md")):
        fm, text = front_matter(path)
        if fm is None or fm.get("type") != "initiative" or not fm.get("id"):
            continue
        docs[fm["id"]] = (path.relative_to(root), fm, text)
    children = {}  # parent id -> set of child ids
    for cid, (rel, fm, _) in docs.items():
        parent = fm.get("parent")
        if parent is None:
            continue
        if not isinstance(parent, str) or parent not in docs:
            errors.append(f"{rel}: `parent` `{parent}` names no initiative in initiatives/ {clause}")
            continue
        children.setdefault(parent, set()).add(cid)
    for pid, (rel, _, text) in docs.items():
        m = SUB_HEADING.search(text)
        listed = set()
        if m:
            section = text[m.end():]
            nxt = re.search(r"^#{1,3} ", section, re.M)
            if nxt:
                section = section[:nxt.start()]
            for cid in docs:
                if re.search(r"(?<![\w-])" + re.escape(cid) + r"(?![\w-])", section):
                    listed.add(cid)
            for target in re.findall(r"\]\(([^)#\s]+)\)", section):
                stem = pathlib.Path(target).stem
                if stem not in listed:
                    listed.add(stem)
        expected = children.get(pid, set())
        if m is None and expected:
            errors.append(f"{rel}: named as `parent` by {', '.join(sorted(expected))} but has no `Sub-initiatives` section {clause}")
            continue
        for cid in sorted(expected - listed):
            errors.append(f"{rel}: `Sub-initiatives` omits `{cid}`, whose `parent` names it {clause}")
        for cid in sorted(listed - expected):
            errors.append(f"{rel}: `Sub-initiatives` lists `{cid}`, whose `parent` does not name it {clause}")
    return errors


def lint_vocabulary():
    """14. Counts, once per file, every basis file (`.md` and
    `basis/tools/*.py`) and every delivered feature outside the
    superseded set that still uses `run` as a noun for a process
    instance or `anchor` to name the work register's identifier
    (req-2026-09-08-definition-vs-instance; feat-execution-vocabulary
    §the corpus measure reaches its target). A file's `Document
    History` section is excluded — history is never edited in place.
    Heuristic and line-pattern based, like check 6. Report-only: never
    added to the violation count, since legitimate residue (example
    prose, protected field names, the check's own source) would
    otherwise fail every tree permanently; printed as its own line."""
    errors = []
    clause = "(req-2026-09-08-definition-vs-instance; feat-execution-vocabulary)"
    paths = sorted(BASIS.rglob("*.md")) + sorted(BASIS.glob("tools/*.py"))
    features_dir = BASIS.parent / "features"
    if features_dir.is_dir():
        for path in sorted(features_dir.glob("*.md")):
            if path.name in VOCAB_SUPERSEDED_FEATURES:
                continue
            fm, _ = front_matter(path)
            if fm and fm.get("status") == "delivered":
                paths.append(path)
    for path in paths:
        rel = path.relative_to(BASIS.parent)
        text = path.read_text()
        body = text.split("## Document History")[0]
        if RUN_NOUN_RE.search(body) or ANCHOR_ID_RE.search(body):
            errors.append(f"{rel}: still uses `run` as a noun or `anchor` for the identifier {clause}")
    return errors


def derive_chain(artifact_type):
    """definition-chain is derived from document references, never authored:
    typedef by `defines`, guideline and fitness by `target-type`, process by
    `produces`, roles from the process steps, skill by `derived-from`."""
    chain = {"artifact_type": artifact_type, "typedef": "", "guideline": "",
             "fitness": "", "process": "", "roles": [], "skill": "", "status": "draft"}
    docs = []
    process_id = None
    for path in sorted(BASIS.rglob("*.md")):
        fm, text = front_matter(path)
        if not fm:
            continue
        t = fm.get("type")
        if t == "artifact-typedef" and fm.get("defines") == artifact_type:
            chain["typedef"] = fm["id"]; docs.append(fm)
        elif t == "quality-guideline" and fm.get("target-type") == artifact_type:
            chain["guideline"] = fm["id"]; docs.append(fm)
        elif t == "fitness-set" and fm.get("target-type") == artifact_type:
            chain["fitness"] = fm["id"]; docs.append(fm)
        elif t == "process-definition" and artifact_type in (fm.get("produces") or []):
            chain["process"] = fm["id"]; process_id = fm["id"]; docs.append(fm)
            spec = yaml_blocks(text)
            roles = {s["run-by"]["role"] for s in spec.get("steps", [])
                     if s.get("run-by", {}).get("role")}
            chain["roles"] = sorted(roles)
    if process_id:
        for path in (BASIS.parent / ".claude" / "skills").rglob("SKILL.md"):
            fm, _ = front_matter(path)
            if fm and fm.get("derived-from") == process_id:
                chain["skill"] = fm["id"]; docs.append(fm)
    if docs and all(d.get("status") == "approved" for d in docs) and \
       all(chain[k] for k in ("typedef", "guideline", "fitness", "process", "skill")):
        chain["status"] = "approved"
    return chain


USAGE = ("python3 basis/tools/lint_basis.py | --brief <path> | "
         "--process <path> | --derive-chain <artifact_type> | --describe")


def fail(code, message):
    """A failure the answer names: its code beside the message, one line on
    standard error, the exit status the answer states for that code."""
    print(f"{code}: {message}", file=sys.stderr)
    sys.exit({"usage": 2, "unreadable": 2}[code])


def readable(arg):
    path = pathlib.Path(arg)
    if not path.is_file():
        fail("unreadable", f"{arg}: no such file")
    try:
        path.read_bytes()
    except OSError as exc:
        fail("unreadable", f"{arg}: cannot be read: {exc}")
    return path


def main():
    args = sys.argv[1:]
    # The standard question, answered before any other action; the other
    # arguments are ignored (adr-2026-09-07-tool-answer §2).
    if "--describe" in args:
        sys.stdout.write(json.dumps(DESCRIPTION, indent=2) + "\n")
        sys.exit(0)
    if len(args) == 2 and args[0] == "--derive-chain":
        print(yaml.safe_dump(derive_chain(args[1]), sort_keys=False).rstrip())
        return
    if len(args) == 2 and args[0] == "--brief":
        errors = lint_brief(readable(args[1]))
    elif len(args) == 2 and args[0] == "--process":
        errors = lint_process_tools(readable(args[1]))
    elif not args:
        errors = lint()
    else:
        fail("usage", USAGE)
    for e in errors:
        print(e)
    if not args:
        print(f"vocabulary residue: {len(lint_vocabulary())} files")
    print(f"{'FAIL' if errors else 'PASS'}: {len(errors)} violation(s)")
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
