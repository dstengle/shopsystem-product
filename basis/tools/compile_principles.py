#!/usr/bin/env python3
"""Render the principle set into a prompt block.

Experiment apparatus, like compile_process.py. Emits a compact rendering
of the principle set — name, slug, and statement per principle — for
inclusion in an agent's generating context. Statements carry the norms;
rationales and implications stay in the source document.

Usage:
  compile_principles.py <principles.md> <out.md>
"""
import hashlib
import pathlib
import re
import sys

import yaml


def main() -> None:
    source = pathlib.Path(sys.argv[1])
    out = pathlib.Path(sys.argv[2])
    text = source.read_text()
    fm_match = re.match(r"---\n(.*?)\n---\n", text, re.S)
    front = yaml.safe_load(fm_match.group(1))
    digest = hashlib.sha256(text.encode()).hexdigest()[:12]

    principles = re.findall(
        r"^## ([^\n]+?) \(`([^\n`]+)`\)\n\n\*\*Statement\.\*\*\s*(.*?)(?=\n\n\*\*)",
        text,
        re.S | re.M,
    )
    if not principles:
        sys.exit(f"{source}: no principles parsed")

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
    out.write_text("\n".join(lines) + "\n")
    print(f"{out}: rendered {len(principles)} principles (digest {digest})")


if __name__ == "__main__":
    main()
