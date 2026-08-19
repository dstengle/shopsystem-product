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
     the step prompts, copied verbatim.

Usage:
  compile_process.py <process.md>                    # regenerate the diagram
  compile_process.py <process.md> --skill <out.md>   # also generate the skill
"""
import hashlib
import pathlib
import re
import sys

import yaml


def parse(path: pathlib.Path):
    text = path.read_text()
    fm_match = re.match(r"---\n(.*?)\n---\n", text, re.S)
    if not fm_match:
        sys.exit(f"{path}: no front-matter")
    front = yaml.safe_load(fm_match.group(1))
    spec = {}
    for fence in re.findall(r"```yaml\n(.*?)```", text, re.S):
        block = yaml.safe_load(fence)
        if isinstance(block, dict):
            spec.update(block)
    if "steps" not in spec or "start" not in spec:
        sys.exit(f"{path}: no `steps`/`start` yaml block found")
    purpose_match = re.search(r"\*\*Purpose:\*\*\s*(.*?)\n\n", text, re.S)
    purpose = " ".join(purpose_match.group(1).split()) if purpose_match else ""
    guiding_match = re.search(r"\*\*Guiding statement:\*\*\s*(.*?)\n\n", text, re.S)
    guiding = " ".join(guiding_match.group(1).split()) if guiding_match else ""
    return text, front, spec, purpose, guiding


def node_id(step_id: str) -> str:
    return "__end" if step_id == "end" else step_id.replace("-", "_")


def branch_target(branch: dict) -> str:
    return branch["else"] if "else" in branch else branch["next"]


def branch_label(branch: dict) -> str:
    if "else" in branch:
        return "else"
    return branch.get("label", "")


def mermaid(spec: dict) -> str:
    nodes, edges = ["flowchart TD"], []
    edges.append(f'  __start(("start")) --> {node_id(spec["start"])}')
    for step in spec["steps"]:
        sid = node_id(step["id"])
        run_by = step.get("run-by", {})
        if "branches" in step:
            nodes.append(f'  {sid}{{"{step["name"]}"}}')
            for branch in step["branches"]:
                target = node_id(branch_target(branch))
                label = branch_label(branch)
                arrow = f"-->|{label}|" if label else "-->"
                edges.append(f"  {sid} {arrow} {target}")
        else:
            if run_by.get("execution") == "agent":
                role = run_by.get("role", "agent")
                nodes.append(f'  {sid}(["{step["name"]} — agent: {role}"])')
            else:
                nodes.append(f'  {sid}["{step["name"]} — runtime"]')
            if step.get("next"):
                edges.append(f'  {sid} --> {node_id(step["next"])}')
    nodes.append('  __end(("end"))')
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
    writes = ", ".join(step.get("outputs", [])) or "—"
    return f"reads: {reads} · writes: {writes}"


def skill_step_section(step: dict) -> str:
    lines = [f"## {step['id']} — {step['name']}", ""]
    run_by = step.get("run-by", {})
    if run_by.get("execution") == "agent":
        fresh = " (fresh context every run)" if run_by.get("fresh-context") else ""
        lines.append(f"Run by agent in role `{run_by.get('role')}`{fresh}. {fmt_io(step)}.")
        for check in step.get("checks", []):
            lines.append(f"- check: `{check}`")
        if step.get("next"):
            lines.append(f"- then: `{step['next']}`")
        lines += ["", "Prompt:", "", "```text", step["prompt"].rstrip(), "```"]
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
        description += f" Use {cc['use-when']}."
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
    parts.append(f"```mermaid\n{diagram}\n```")
    parts += [skill_step_section(step) for step in spec["steps"]]
    return "\n\n".join(parts) + "\n"


def main() -> None:
    args = sys.argv[1:]
    skill_out = None
    if "--skill" in args:
        i = args.index("--skill")
        skill_out = pathlib.Path(args[i + 1])
        args = args[:i] + args[i + 2:]
    source = pathlib.Path(args[0])
    text, front, spec, purpose, guiding = parse(source)
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


if __name__ == "__main__":
    main()
