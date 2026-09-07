#!/usr/bin/env python3
"""Render the principle set into a prompt block.

Experiment apparatus, like compile_process.py. Emits a compact rendering
of the principle set — name, slug, and statement per principle — for
inclusion in an agent's generating context. Statements carry the norms;
rationales and implications stay in the source document.

Usage:
  compile_principles.py <principles.md> <out.md>   # render the set to <out.md>
  compile_principles.py --describe                 # answer the standard question
                                                   # (DESCRIPTION below) as JSON on
                                                   # standard output, exit 0, before
                                                   # any other action
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

TOOL = "basis/tools/compile_principles.py"
EXIT = {"usage": 2, "unreadable": 2, "unparseable": 1, "unwritable": 1}


def fail(code: str, message: str) -> None:
    """A failure the answer names: its code beside the message, one line on
    standard error, the exit status the answer states for that code."""
    print(f"{code}: {' '.join(str(message).split())}", file=sys.stderr)
    sys.exit(EXIT[code])


# The answer to the standard question (adr-2026-09-07-tool-answer §2): an
# instance of the tool-description data type, basis/types/tool-description.md.
# This tool is its one home; the skill is produced from it, never edited.
DESCRIPTION = {
    "name": "compile-principles",
    "description": (
        "Renders a principle set into the compact prompt block compiled into "
        "every session: one line per principle carrying its name, slug, and "
        "statement — a bulleted statement kept as one obligation per bullet "
        "— with front-matter naming the set and a digest of its text; "
        "rationales and implications stay in the source. Use it after a "
        "principle set changes, to refresh the rendering the sessions load."
    ),
    "uses": [
        {
            "name": "render",
            "description": (
                "Reads the principle set, parses each `## <name> (`<slug>`)` "
                "section's **Statement**, and writes the rendering to "
                "<out>, overwriting what stands there. Nothing else is "
                "written; the source is not changed."
            ),
            "invocation": f"python3 {TOOL} <principles> <out>",
            "input_schema": {
                "type": "object",
                "properties": {
                    "principles": {"type": "string",
                                   "description": "the path of the principle "
                                                  "set to render, for example "
                                                  "basis/principles.md"},
                    "out": {"type": "string",
                            "description": "the path the rendering is written "
                                           "to, for example "
                                           ".claude/shop/principles.md"},
                },
                "required": ["principles", "out"],
                "additionalProperties": False,
            },
            "returns": {
                "form": "text",
                "text": "one line on standard output, `<out>: rendered <n> "
                        "principles (digest <12 hex>)`; exit status 0; the "
                        "rendering written at <out>",
            },
            "failures": [
                {"code": "unreadable", "exit_status": 2,
                 "condition": "no file exists at <principles>, or it cannot be "
                              "read; one line on standard error beginning "
                              "`unreadable:` names the path",
                 "next": "give the path of an existing principle set and run "
                         "the invocation again"},
                {"code": "unparseable", "exit_status": 1,
                 "condition": "the file has no front-matter, its front-matter "
                              "does not parse or lacks `id`, or no `## <name> "
                              "(`<slug>`)` section with a **Statement** was "
                              "found; one line on standard error beginning "
                              "`unparseable:` names the path and the defect; "
                              "nothing is written",
                 "next": "repair the principle set at the named defect and "
                         "run the invocation again"},
                {"code": "unwritable", "exit_status": 1,
                 "condition": "<out> could not be written; one line on "
                              "standard error beginning `unwritable:` names "
                              "the path and the reason",
                 "next": "give a writable <out> path and run the invocation "
                         "again"},
                {"code": "usage", "exit_status": 2,
                 "condition": "the arguments are not the one invocation this "
                              "tool states; one line on standard error "
                              "beginning `usage:` names it; nothing is "
                              "written",
                 "next": "run the invocation the use states, as written"},
            ],
        },
    ],
}


def main() -> None:
    args = sys.argv[1:]
    # The standard question, answered before any other action; the other
    # arguments are ignored (adr-2026-09-07-tool-answer §2).
    if "--describe" in args:
        sys.stdout.write(json.dumps(DESCRIPTION, indent=2) + "\n")
        sys.exit(0)
    if len(args) != 2 or any(a.startswith("--") for a in args):
        fail("usage", f"python3 {TOOL} <principles> <out> | --describe")
    source = pathlib.Path(args[0])
    out = pathlib.Path(args[1])
    try:
        text = source.read_text()
    except (OSError, UnicodeDecodeError) as exc:
        fail("unreadable", f"{source}: cannot be read: {exc}")
    fm_match = re.match(r"---\n(.*?)\n---\n", text, re.S)
    if not fm_match:
        fail("unparseable", f"{source}: no front-matter")
    try:
        front = yaml.safe_load(fm_match.group(1))
    except yaml.YAMLError as exc:
        fail("unparseable", f"{source}: front-matter does not parse: {exc}")
    if not isinstance(front, dict) or not front.get("id"):
        fail("unparseable", f"{source}: front-matter is not a mapping with `id`")
    digest = hashlib.sha256(text.encode()).hexdigest()[:12]

    principles = re.findall(
        r"^## ([^\n]+?) \(`([^\n`]+)`\)\n\n\*\*Statement\.\*\*\s*(.*?)(?=\n\n\*\*)",
        text,
        re.S | re.M,
    )
    if not principles:
        fail("unparseable", f"{source}: no principles parsed — no `## <name> "
             "(`<slug>`)` section with a **Statement**")

    fm = {
        "type": "principles-rendering",
        "id": f"{front['id']}-rendering",
        "status": front.get("status"),
        "generated": True,
        "generated-by": "basis/tools/compile_principles.py",
        "derived-from": front["id"],
        "source": str(source),
        "source-digest": f"sha256:{digest}",
        "scope": front.get("scope"),
    }
    lines = [
        "---\n" + yaml.safe_dump(fm, sort_keys=False).rstrip() + "\n---",
        "",
        "# Working principles (compiled into every session)",
        "",
        "These statements govern every activity in this shop. The full set —",
        "rationales, implications, fitness screen — is the source document",
        "named in the front-matter; on conflict the source wins.",
        "",
    ]
    for name, slug, statement in principles:
        block = statement.strip()
        if not re.search(r"^\s*- ", block, re.M):
            # prose statement: collapse to one line, as before
            lines.append(f"- **{name}** (`{slug}`): {' '.join(block.split())}")
            continue
        # bulleted statement: one obligation per bullet, nesting preserved
        items, lead = [], []
        for raw in block.splitlines():
            m = re.match(r"^(\s*)- (.*)$", raw)
            if m:
                items.append([len(m.group(1)), m.group(2).strip()])
            elif items:
                items[-1][1] += " " + raw.strip()
            else:
                lead.append(raw.strip())
        head = f"- **{name}** (`{slug}`):"
        if lead:
            head += " " + " ".join(lead)
        lines.append(head)
        for indent, item in items:
            lines.append("  " * (1 + indent // 2) + "- " + item)
    try:
        out.write_text("\n".join(lines) + "\n")
    except OSError as exc:
        fail("unwritable", f"{out}: cannot be written: {exc}")
    print(f"{out}: rendered {len(principles)} principles (digest {digest})")


if __name__ == "__main__":
    main()
