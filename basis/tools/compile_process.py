#!/usr/bin/env python3
"""Compile a process definition into its derived outputs.

Experiment apparatus: this script exists to prove the process-definition
format carries enough data to compile. The production compiler is a BC
deliverable and does not live in the lead repo.

Outputs:
  1. The flow diagram — a Mermaid flowchart generated from the steps,
     written back into the definition's "## Flow (compiled)" section.
  2. The skill (optional, --skill <path>) — a SKILL.md generated from the
     front-matter, purpose, data, and steps. The only prose it contains is
     the step prompts, copied verbatim, each agent-run step's prompt block
     closing with the outputs line — the step's declared outputs named as
     the form its return takes, one `<name>: <value>` line per output, an
     ask in place of them where the step may ask — and then the banned
     line — "Do not use these words: " and the lint's BANNED list, loaded
     from lint_basis.py beside this script.

Usage:
  compile_process.py <process.md>                    # regenerate the diagram
  compile_process.py <process.md> --skill <out.md>   # also generate the skill
  compile_process.py --describe                      # answer the standard
                                                     # question (DESCRIPTION
                                                     # below) as JSON on standard
                                                     # output, exit 0, before any
                                                     # other action
Any other arguments are a usage failure: one line on standard error
beginning `usage:`, exit status 2. Every failure is one line on standard
error beginning with its code from the tool-description data type's
closed set, never a traceback.
"""
import hashlib
import json
import pathlib
import re
import sys

import yaml

TOOL = "basis/tools/compile_process.py"
EXIT = {"usage": 2, "unreadable": 2, "unparseable": 1, "check-failed": 1,
        "unwritable": 1}


def fail(code: str, message: str) -> None:
    """A failure the answer names: its code beside the message, one line on
    standard error, the exit status the answer states for that code."""
    print(f"{code}: {' '.join(str(message).split())}", file=sys.stderr)
    sys.exit(EXIT[code])


UNREADABLE_FAILURE = {
    "code": "unreadable", "exit_status": 2,
    "condition": "no file exists at <definition>, or it cannot be read; one "
                 "line on standard error beginning `unreadable:` names the "
                 "path; nothing is written",
    "next": "give the path of an existing process definition and run the "
            "invocation again",
}
UNPARSEABLE_FAILURE = {
    "code": "unparseable", "exit_status": 1,
    "condition": "the definition has no front-matter, its front-matter or a "
                 "yaml block does not parse, or no yaml block carries "
                 "`steps` and `start`; one line on standard error beginning "
                 "`unparseable:` names the path and the defect; nothing is "
                 "written",
    "next": "repair the definition at the named defect and run the "
            "invocation again",
}
CHECK_FAILURE = {
    "code": "check-failed", "exit_status": 1,
    "condition": "the definition does not compile: a `$ref` without a "
                 "`from:` source, a source that does not exist or does not "
                 "define the type, a `result` that is not a declared data "
                 "value, no `## Flow (compiled)` section to fill, or a step "
                 "the renderer cannot render; one line on standard error "
                 "beginning `check-failed:` names the path and the defect; "
                 "nothing is written",
    "next": "repair the definition at the named defect (the "
            "process-definition typedef states the rules) and run the "
            "invocation again",
}
UNWRITABLE_FAILURE = {
    "code": "unwritable", "exit_status": 1,
    "condition": "the definition, or the skill at <out>, could not be "
                 "written; one line on standard error beginning "
                 "`unwritable:` names the path and the reason",
    "next": "make the path writable, or give one that is, and run the "
            "invocation again",
}
USAGE_FAILURE = {
    "code": "usage", "exit_status": 2,
    "condition": "the arguments are not one of the two invocations this "
                 "tool states — no definition, more than one, `--skill` "
                 "without a path, or an unknown option; one line on "
                 "standard error beginning `usage:` names them; nothing is "
                 "written",
    "next": "run the invocation the use states, as written",
}
DEFINITION_INPUT = {
    "type": "string",
    "description": "the path of the process definition, for example "
                   "basis/processes/skill-rendering.md; its `$ref` sources "
                   "resolve relative to that path",
}
# The answer to the standard question (adr-2026-09-07-tool-answer §2): an
# instance of the tool-description data type, basis/types/tool-description.md.
# This tool is its one home; the skill is produced from it, never edited.
DESCRIPTION = {
    "name": "compile-process",
    "description": (
        "Compiles a process definition: checks that every `$ref` in its "
        "data block has a source that defines the type, regenerates the "
        "Mermaid flow diagram in the definition's `## Flow (compiled)` "
        "section, and — on request — renders the definition's loadable "
        "skill, whose only prose is the step prompts, verbatim, each "
        "agent-run step closing with the line naming its declared outputs "
        "as the form its return takes and with the banned-words line read "
        "from the lint. Use it after a process definition changes, and to "
        "place or refresh the definition's skill at the agent's load point."
    ),
    "uses": [
        {
            "name": "compile",
            "description": (
                "Checks the definition's `$ref` sources and `result`, "
                "regenerates the flow diagram, and writes it back into the "
                "definition's `## Flow (compiled)` section in place — the "
                "one write; nothing else in the definition changes and no "
                "skill is written."
            ),
            "invocation": f"python3 {TOOL} <definition>",
            "input_schema": {
                "type": "object",
                "properties": {"definition": DEFINITION_INPUT},
                "required": ["definition"],
                "additionalProperties": False,
            },
            "returns": {
                "form": "text",
                "text": "one line on standard output, `<definition>: flow "
                        "diagram regenerated (<n> steps)`; exit status 0; "
                        "the diagram written into the definition",
            },
            "failures": [UNREADABLE_FAILURE, UNPARSEABLE_FAILURE, CHECK_FAILURE,
                         UNWRITABLE_FAILURE, USAGE_FAILURE],
        },
        {
            "name": "compile-skill",
            "description": (
                "Does what `compile` does, then renders the definition's "
                "skill — front-matter with `generated: true`, `source`, and "
                "`source-digest` over the definition's text, its `ask-cap` "
                "and `hold-after` where the definition carries them, the purpose, "
                "guiding statement, diagram, and every step with its prompt "
                "verbatim, each agent-run step's prompt closing with its "
                "outputs line and the banned-words line — and writes it to "
                "<out>, creating the "
                "directories, overwriting what stands there, a hand edit "
                "included."
            ),
            "invocation": f"python3 {TOOL} <definition> --skill <out>",
            "input_schema": {
                "type": "object",
                "properties": {
                    "definition": DEFINITION_INPUT,
                    "out": {"type": "string",
                            "description": "the path the skill is written to: "
                                           ".claude/skills/<name>/SKILL.md at "
                                           "the agent's load point, <name> "
                                           "the definition's carried-by id "
                                           "without `-skill`; or a scratch "
                                           "path to render without placing"},
                },
                "required": ["definition", "out"],
                "additionalProperties": False,
            },
            "returns": {
                "form": "text",
                "text": "two lines on standard output, `<definition>: flow "
                        "diagram regenerated (<n> steps)` then `<out>: "
                        "generated from <id> (digest <12 hex>)`; exit status "
                        "0; the diagram written into the definition and the "
                        "skill at <out>",
            },
            "failures": [UNREADABLE_FAILURE, UNPARSEABLE_FAILURE, CHECK_FAILURE,
                         UNWRITABLE_FAILURE, USAGE_FAILURE],
        },
    ],
}

# The banned vocabulary has one home: the lint beside this compiler. It is
# read from there, never copied, so a change to the lint's list changes every
# rendering at the next re-render with no change here.
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from lint_basis import BANNED  # noqa: E402

BANNED_LINE = "Do not use these words: " + ", ".join(BANNED)


def outputs_line(step: dict) -> str:
    """The line closing an agent-run step's prompt that names the step's
    declared outputs as the form its return takes, so a router reads each
    output by name (adr-2026-09-07-coordinator-role §3: agent outputs become
    parseable). Empty for a step that declares no outputs and may not ask."""
    parts = []
    if step.get("outputs"):
        names = ", ".join(step["outputs"])
        parts.append(
            "Return each declared output on its own line as `<name>: <value>` "
            f"— {names} — a list as a JSON array, a value with line breaks as "
            "a JSON string; these lines close your reply."
        )
    if step.get("asks"):
        parts.append(
            "In place of the outputs, an ask: a line `ask:` then, each on its "
            "own line, `to`, `kind`, `question`, `default`, and `checkpoint` "
            "as `<field>: <value>`."
        )
    return " ".join(parts)


def one_line(exc: BaseException) -> str:
    """An exception's message on one line, for a one-line exit reason."""
    return " ".join(str(exc).split()) or type(exc).__name__


def parse(path: pathlib.Path):
    """Read and parse a definition. A definition that cannot be read or
    parsed exits nonzero with a one-line reason on stderr, never a traceback."""
    try:
        text = path.read_text()
    except (OSError, UnicodeDecodeError) as exc:
        fail("unreadable", f"{path}: cannot be read: {exc}")
    fm_match = re.match(r"---\n(.*?)\n---\n", text, re.S)
    if not fm_match:
        fail("unparseable", f"{path}: no front-matter")
    try:
        front = yaml.safe_load(fm_match.group(1))
    except yaml.YAMLError as exc:
        fail("unparseable", f"{path}: front-matter does not parse: {one_line(exc)}")
    if not isinstance(front, dict):
        fail("unparseable", f"{path}: front-matter is not a mapping")
    spec = {}
    for fence in re.findall(r"```yaml\n(.*?)```", text, re.S):
        try:
            block = yaml.safe_load(fence)
        except yaml.YAMLError as exc:
            fail("unparseable", f"{path}: a yaml block does not parse: {one_line(exc)}")
        if isinstance(block, dict):
            spec.update(block)
    if "steps" not in spec or "start" not in spec:
        fail("unparseable", f"{path}: no `steps`/`start` yaml block found")
    purpose_match = re.search(r"\*\*Purpose:\*\*\s*(.*?)\n\n", text, re.S)
    purpose = " ".join(purpose_match.group(1).split()) if purpose_match else ""
    guiding_match = re.search(r"\*\*Guiding statement:\*\*\s*(.*?)\n\n", text, re.S)
    guiding = " ".join(guiding_match.group(1).split()) if guiding_match else ""
    return text, front, spec, purpose, guiding


def collect_ref_sources(node, refs: set, sourced: dict) -> None:
    if isinstance(node, dict):
        if "$ref" in node:
            refs.add(node["$ref"])
            if node.get("from"):
                sourced[node["$ref"]] = node["from"]
        for value in node.values():
            collect_ref_sources(value, refs, sourced)
    elif isinstance(node, list):
        for item in node:
            collect_ref_sources(item, refs, sourced)


def check_refs(source: pathlib.Path, front: dict, spec: dict) -> None:
    refs, sourced = set(), {}
    collect_ref_sources(spec.get("data", {}), refs, sourced)
    for ref in sorted(refs):
        src = sourced.get(ref)
        if not src:
            fail("check-failed", f"{source}: $ref `{ref}` has no `from:` source "
                 "(process-definition typedef §Data)")
        if src.startswith("pkg:"):
            if not re.match(r"^pkg:[a-z0-9-]+/[a-z0-9_-]+$", src):
                fail("check-failed", f"{source}: `{src}` is not pkg:<package>/<type>")
            continue
        target = (source.parent / src).resolve()
        if not target.exists():
            fail("check-failed", f"{source}: from `{src}` does not exist")
        fm_match = re.match(r"---\n(.*?)\n---\n", target.read_text(), re.S)
        if not fm_match or yaml.safe_load(fm_match.group(1)).get("defines") != ref:
            fail("check-failed", f"{source}: from `{src}` does not define `{ref}`")
    result = spec.get("result")
    if result and result not in spec.get("data", {}):
        fail("check-failed", f"{source}: result '{result}' is not a declared data value")


def node_id(step_id: str) -> str:
    return "__end" if step_id == "end" else step_id.replace("-", "_")


def branch_target(branch: dict) -> str:
    return branch["else"] if "else" in branch else branch["next"]


def branch_label(branch: dict) -> str:
    if "else" in branch:
        return "else"
    return branch.get("label", "")


def display_type(data: dict, name: str) -> str:
    entry = data.get(name, {})
    if "$ref" in entry:
        return entry["$ref"]
    dtype = entry.get("type", "?")
    if dtype == "array":
        items = entry.get("items", {})
        inner = items.get("$ref") or items.get("type", "?")
        return f"{inner}[]"
    return dtype


def io_lines(step: dict, data: dict) -> list:
    def one(name):
        if "." in name:
            base = name.split(".", 1)[0]
            return f"{name}: field of {display_type(data, base)}"
        return f"{name}: {display_type(data, name)}"

    def typed(names):
        return ", ".join(one(n) for n in names)

    lines = []
    if step.get("inputs"):
        lines.append(f"in — {typed(step['inputs'])}")
    if step.get("outputs"):
        lines.append(f"out — {typed(step['outputs'])}")
    if step.get("set"):
        lines.append(f"sets — {typed(step['set'].keys())}")
    return lines


def mermaid(spec: dict) -> str:
    data = spec.get("data", {})
    nodes, edges = ["flowchart TD"], []
    edges.append(f'  __start(("start")) --> {node_id(spec["start"])}')
    for step in spec["steps"]:
        sid = node_id(step["id"])
        run_by = step.get("run-by", {})
        io = io_lines(step, data)
        if "branches" in step:
            label = "<br/>".join([step["name"]] + io)
            nodes.append(f'  {sid}{{"{label}"}}')
            for branch in step["branches"]:
                target = node_id(branch_target(branch))
                blabel = branch_label(branch)
                arrow = f"-->|{blabel}|" if blabel else "-->"
                edges.append(f"  {sid} {arrow} {target}")
        else:
            execution = run_by.get("execution", "runtime")
            if execution in ("agent", "human"):
                head = f"{step['name']} — {execution}: {run_by.get('role', execution)}"
            elif execution == "sub-process":
                head = f"{step['name']} — sub-process: {run_by.get('process')}"
            else:
                head = f"{step['name']} — runtime"
            label = "<br/>".join([head] + io)
            if execution == "agent":
                shape = f'(["{label}"])'
            elif execution == "human":
                shape = f'[["{label}"]]'
            elif execution == "sub-process":
                shape = f'{{{{"{label}"}}}}'
            else:
                shape = f'["{label}"]'
            nodes.append(f"  {sid}{shape}")
            if step.get("next"):
                edges.append(f'  {sid} --> {node_id(step["next"])}')
    result = spec.get("result")
    if result:
        end_label = f"end<br/>result — {result}: {display_type(data, result)}"
    else:
        end_label = "end"
    nodes.append(f'  __end(("{end_label}"))')
    return "\n".join(nodes + edges)


FLOW_HEADING = "## Flow (compiled)"


def write_flow(path: pathlib.Path, text: str, diagram: str) -> None:
    block = (
        f"{FLOW_HEADING}\n\n"
        "Generated from the steps below by `tools/compile_process.py`; do not\n"
        "edit by hand.\n\n"
        f"```mermaid\n{diagram}\n```\n\n"
    )
    new_text, count = re.subn(
        re.escape(FLOW_HEADING) + r"\n.*?(?=\n## )", block, text, count=1, flags=re.S
    )
    if count != 1:
        fail("check-failed", f'{path}: no "{FLOW_HEADING}" section to fill')
    try:
        path.write_text(new_text)
    except OSError as exc:
        fail("unwritable", f"{path}: cannot be written: {one_line(exc)}")


def fmt_io(step: dict) -> str:
    reads = ", ".join(step.get("inputs", [])) or "—"
    written = step.get("outputs", []) or list(step.get("set", {}).keys())
    writes = ", ".join(written) or "—"
    return f"reads: {reads} · writes: {writes}"


def skill_step_section(step: dict) -> str:
    lines = [f"## {step['id']} — {step['name']}", ""]
    run_by = step.get("run-by", {})
    if run_by.get("execution") in ("agent", "human"):
        fresh = " (fresh context every run)" if run_by.get("fresh-context") else ""
        actor = "an agent in role" if run_by["execution"] == "agent" else "a human holding role"
        lines.append(f"Run by {actor} `{run_by.get('role')}`{fresh}. {fmt_io(step)}.")
        if step.get("asks"):
            roles = ", ".join(f"`{r}`" for r in step["asks"])
            lines.append(f"- may ask: {roles} — return an `ask` (with default and checkpoint) in place of outputs; at most one per run.")
        for check in step.get("checks", []):
            lines.append(f"- check: `{check}`")
        if step.get("next"):
            lines.append(f"- then: `{step['next']}`")
        prompt = step["prompt"].rstrip()
        if run_by["execution"] == "agent":
            line = outputs_line(step)
            if line:
                prompt += "\n\n" + line
            prompt += "\n\n" + BANNED_LINE
        lines += ["", "Prompt:", "", "```text", prompt, "```"]
    else:
        lines.append(f"Run by the runtime — no agent, no prose. {fmt_io(step)}.")
        machine = {
            key: step[key] for key in ("set", "run", "branches", "atomic") if key in step
        }
        if step.get("next"):
            machine["next"] = step["next"]
        lines += ["", "```yaml", yaml.safe_dump(machine, sort_keys=False).rstrip(), "```"]
    return "\n".join(lines)


def generate_skill(front: dict, spec: dict, purpose: str, guiding: str, diagram: str,
                   digest: str, source_rel: str) -> str:
    cc = (front.get("annotations") or {}).get("claude-code", {})
    description = purpose
    if cc.get("use-when"):
        description += f" Use when {cc['use-when']}."
    fm = {
        "name": front["carried-by"].removesuffix("-skill"),
        "description": description,
        "type": "skill",
        "id": front["carried-by"],
        "status": front.get("status", "experiment"),
        "created": front.get("created"),
        "updated": front.get("updated"),
        "generated": True,
        "generated-by": "basis/tools/compile_process.py",
        "derived-from": front["id"],
        "source": source_rel,
        "source-digest": f"sha256:{digest}",
    }
    for key in ("activation", "promotion"):
        if key in cc:
            fm[key] = cc[key]
    # The execution lifecycle's two windows travel with the rendering, so a router
    # running from it knows a process's ask-cap and hold-after.
    for key in ("ask-cap", "hold-after"):
        if key in front:
            fm[key] = front[key]
    title = front["carried-by"].removesuffix("-skill").replace("-", " ").capitalize()
    parts = [
        "---\n" + yaml.safe_dump(fm, sort_keys=False).rstrip() + "\n---",
        f"# {title} (compiled from `{front['id']}`)",
        purpose,
    ]
    if guiding:
        parts.append(f"**{guiding}**")
    result = spec.get("result")
    if result:
        rtype = display_type(spec.get("data", {}), result)
        parts.append(f"Result of an execution: `{result}` ({rtype}).")
    parts.append(f"```mermaid\n{diagram}\n```")
    parts += [skill_step_section(step) for step in spec["steps"]]
    return "\n\n".join(parts) + "\n"


def compile_definition(source: pathlib.Path, skill_out) -> None:
    text, front, spec, purpose, guiding = parse(source)
    check_refs(source, front, spec)
    diagram = mermaid(spec)
    write_flow(source, text, diagram)
    print(f"{source}: flow diagram regenerated ({len(spec['steps'])} steps)")
    if skill_out:
        digest = hashlib.sha256(source.read_text().encode()).hexdigest()[:12]
        source_rel = f"basis/processes/{source.name}"
        try:
            skill_out.parent.mkdir(parents=True, exist_ok=True)
            skill_out.write_text(
                generate_skill(front, spec, purpose, guiding, diagram, digest, source_rel)
            )
        except OSError as exc:
            fail("unwritable", f"{skill_out}: cannot be written: {one_line(exc)}")
        print(f"{skill_out}: generated from {front['id']} (digest {digest})")


def usage() -> None:
    fail("usage", f"python3 {TOOL} <definition> [--skill <out>] | --describe")


def main() -> None:
    args = sys.argv[1:]
    # The standard question, answered before any other action; the other
    # arguments are ignored (adr-2026-09-07-tool-answer §2).
    if "--describe" in args:
        sys.stdout.write(json.dumps(DESCRIPTION, indent=2) + "\n")
        sys.exit(0)
    skill_out = None
    if "--skill" in args:
        i = args.index("--skill")
        if i + 1 >= len(args):
            usage()
        skill_out = pathlib.Path(args[i + 1])
        args = args[:i] + args[i + 2:]
    if len(args) != 1 or args[0].startswith("--"):
        usage()
    source = pathlib.Path(args[0])
    try:
        compile_definition(source, skill_out)
    except SystemExit:
        raise
    except Exception as exc:  # noqa: BLE001 — a definition that does not
        # compile is a one-line reason on stderr, never a traceback
        fail("check-failed", f"{source}: does not compile: {type(exc).__name__}: {one_line(exc)}")


if __name__ == "__main__":
    main()
