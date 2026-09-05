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
     closing with the banned line — "Do not use these words: " and the
     lint's BANNED list, loaded from lint_basis.py beside this script.

Usage:
  compile_process.py <process.md>                    # regenerate the diagram
  compile_process.py <process.md> --skill <out.md>   # also generate the skill
"""
import hashlib
import pathlib
import re
import sys

import yaml

# The banned vocabulary has one home: the lint beside this compiler. It is
# read from there, never copied, so a change to the lint's list changes every
# rendering at the next re-render with no change here.
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from lint_basis import BANNED  # noqa: E402

BANNED_LINE = "Do not use these words: " + ", ".join(BANNED)


def one_line(exc: BaseException) -> str:
    """An exception's message on one line, for a one-line exit reason."""
    return " ".join(str(exc).split()) or type(exc).__name__


def parse(path: pathlib.Path):
    """Read and parse a definition. A definition that cannot be read or
    parsed exits nonzero with a one-line reason on stderr, never a traceback."""
    try:
        text = path.read_text()
    except (OSError, UnicodeDecodeError) as exc:
        sys.exit(f"{path}: cannot be read: {exc}")
    fm_match = re.match(r"---\n(.*?)\n---\n", text, re.S)
    if not fm_match:
        sys.exit(f"{path}: no front-matter")
    try:
        front = yaml.safe_load(fm_match.group(1))
    except yaml.YAMLError as exc:
        sys.exit(f"{path}: front-matter does not parse: {one_line(exc)}")
    if not isinstance(front, dict):
        sys.exit(f"{path}: front-matter is not a mapping")
    spec = {}
    for fence in re.findall(r"```yaml\n(.*?)```", text, re.S):
        try:
            block = yaml.safe_load(fence)
        except yaml.YAMLError as exc:
            sys.exit(f"{path}: a yaml block does not parse: {one_line(exc)}")
        if isinstance(block, dict):
            spec.update(block)
    if "steps" not in spec or "start" not in spec:
        sys.exit(f"{path}: no `steps`/`start` yaml block found")
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
            sys.exit(f"{source}: $ref `{ref}` has no `from:` source "
                     "(process-definition typedef §Data)")
        if src.startswith("pkg:"):
            if not re.match(r"^pkg:[a-z0-9-]+/[a-z0-9_-]+$", src):
                sys.exit(f"{source}: `{src}` is not pkg:<package>/<type>")
            continue
        target = (source.parent / src).resolve()
        if not target.exists():
            sys.exit(f"{source}: from `{src}` does not exist")
        fm_match = re.match(r"---\n(.*?)\n---\n", target.read_text(), re.S)
        if not fm_match or yaml.safe_load(fm_match.group(1)).get("defines") != ref:
            sys.exit(f"{source}: from `{src}` does not define `{ref}`")
    result = spec.get("result")
    if result and result not in spec.get("data", {}):
        sys.exit(f"{source}: result '{result}' is not a declared data value")


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
        sys.exit(f'{path}: no "{FLOW_HEADING}" section to fill')
    path.write_text(new_text)


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
        runner = "an agent in role" if run_by["execution"] == "agent" else "a human holding role"
        lines.append(f"Run by {runner} `{run_by.get('role')}`{fresh}. {fmt_io(step)}.")
        if step.get("asks"):
            roles = ", ".join(f"`{r}`" for r in step["asks"])
            lines.append(f"- may ask: {roles} — return an `ask` (with default and checkpoint) in place of outputs; at most one per run.")
        for check in step.get("checks", []):
            lines.append(f"- check: `{check}`")
        if step.get("next"):
            lines.append(f"- then: `{step['next']}`")
        prompt = step["prompt"].rstrip()
        if run_by["execution"] == "agent":
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
        parts.append(f"Result of a run: `{result}` ({rtype}).")
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
        skill_out.parent.mkdir(parents=True, exist_ok=True)
        skill_out.write_text(
            generate_skill(front, spec, purpose, guiding, diagram, digest, source_rel)
        )
        print(f"{skill_out}: generated from {front['id']} (digest {digest})")


def main() -> None:
    args = sys.argv[1:]
    skill_out = None
    if "--skill" in args:
        i = args.index("--skill")
        if i + 1 >= len(args):
            sys.exit(__doc__.split("Usage:", 1)[1].rstrip())
        skill_out = pathlib.Path(args[i + 1])
        args = args[:i] + args[i + 2:]
    if len(args) != 1:
        sys.exit(__doc__.split("Usage:", 1)[1].rstrip())
    source = pathlib.Path(args[0])
    try:
        compile_definition(source, skill_out)
    except SystemExit:
        raise
    except Exception as exc:  # noqa: BLE001 — a definition that does not
        # compile is a one-line reason on stderr, never a traceback
        sys.exit(f"{source}: does not compile: {type(exc).__name__}: {one_line(exc)}")


if __name__ == "__main__":
    main()
