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

Modes:
  lint_basis.py                     # lint the whole basis tree
  lint_basis.py --brief PATH        # check one decision brief alone by
                                    # check 10's rules (exit 0 on pass)
  lint_basis.py --derive-chain X    # print the derived definition chain
                                    # for artifact type X (definition-chain
                                    # is assembled from references, never
                                    # hand-written)
"""
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


def main():
    if len(sys.argv) > 2 and sys.argv[1] == "--derive-chain":
        print(yaml.safe_dump(derive_chain(sys.argv[2]), sort_keys=False).rstrip())
        return
    if len(sys.argv) > 2 and sys.argv[1] == "--brief":
        errors = lint_brief(pathlib.Path(sys.argv[2]))
    else:
        errors = lint()
    for e in errors:
        print(e)
    print(f"{'FAIL' if errors else 'PASS'}: {len(errors)} violation(s)")
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
