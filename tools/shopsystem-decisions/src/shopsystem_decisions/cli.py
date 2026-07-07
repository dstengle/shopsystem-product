"""Single CLI entrypoint: ``decisions <verb> ...`` (Step 4).

Mirrors the installed ``scenarios`` / ``shop-msg`` conventions: argparse
verb-noun subcommands, stdin-or-file (``-`` = stdin), exit codes ``0`` clean /
``1`` blocking finding / ``2`` malformed input or usage or lint failure (R10).
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys

import yaml

from . import generate, migrate as migrate_mod, parser as P
from .corpus import build_graph, discover_paths, load_corpus, load_document
from .gate import (LOCK_NAME, REFS_DIR, effective_exit, load_lock, run_gate,
                   stamp_baseline)
from .invhash import invariant_hash
from .model import SEV_LINT
from .schema import ACTIVE_STATUS, KIND_DIR, lint_document

DEFAULT_DIRS = ["adr", "pdr", "briefs"]
ALL_CLASSES = ["ln", "sg", "ci", "dr", "sp"]


# --------------------------------------------------------------------------- #
# helpers
# --------------------------------------------------------------------------- #

def _lint_corpus(res, ids):
    findings = []
    from .model import Finding
    for path, msg in res.parse_errors:
        findings.append(Finding("COH-LN-001", SEV_LINT, path,
                                f"unparseable frontmatter: {msg}",
                                "add a valid '---' frontmatter fence"))
    for d in res.docs:
        findings.extend(lint_document(d, ids))
    return findings


def _id_map(docs):
    ids = {}
    for d in docs:
        if d.id and d.id not in ids:
            ids[d.id] = d.path
    return ids


def _find_doc(did, base):
    num = re.sub(r"^(ADR|PDR|BRIEF)-0*", "", did.upper())
    for sub in DEFAULT_DIRS:
        for p in discover_paths([sub], base):
            m = re.match(r"^0*([0-9]+)", os.path.basename(p))
            if m and num.isdigit() and int(m.group(1)) == int(num):
                try:
                    d = load_document(p, base)
                    if d.id.upper() == did.upper():
                        return d
                except P.FrontmatterError:
                    continue
    return None


def _emit_findings(findings, mode, strict, as_json):
    worst = 0
    ok = fail = warn = 0
    for f in findings:
        code = effective_exit(f, mode, strict)
        worst = max(worst, code)
    if as_json:
        print(json.dumps([f.as_dict(strict) for f in findings], indent=2))
    else:
        for f in findings:
            code = effective_exit(f, mode, strict)
            if code:
                fail += 1
            else:
                warn += 1
            print(f.render(strict))
        total_docs_ok = "—"
        blocking = sum(1 for f in findings if effective_exit(f, mode, strict))
        warns = len(findings) - blocking
        print(f"OK {total_docs_ok} · FAIL {blocking} (blocking) · WARN {warns} → exit {worst}")
    return worst


# --------------------------------------------------------------------------- #
# subcommands
# --------------------------------------------------------------------------- #

def cmd_hash(args):
    text = sys.stdin.read()
    try:
        inv = yaml.safe_load(text)
    except yaml.YAMLError as e:
        print(f"error: invalid YAML: {e}", file=sys.stderr)
        return 2
    if not isinstance(inv, dict) or "predicate" not in inv:
        print("error: stdin must be one invariant mapping with a predicate",
              file=sys.stderr)
        return 2
    print(invariant_hash(inv))
    return 0


def cmd_list(args):
    dirs = args.dirs or DEFAULT_DIRS
    res = load_corpus(dirs, args.base)
    rows = sorted(res.docs, key=lambda d: d.id)
    for d in rows:
        print(f"{d.id}\t{d.status}\t{d.fm.get('title','')}")
    return 0


def cmd_build(args):
    try:
        result = generate.build(args.dirs or DEFAULT_DIRS, args.base, check=args.check)
    except generate.BuildError as e:
        for f in e.findings:
            print(f.render())
        print(f"lint failures block the build → exit 2", file=sys.stderr)
        return 2
    if args.check:
        drift = result["drift"]
        if drift:
            print("DRIFT — regenerate with `decisions build`:")
            for p in drift:
                print(f"  {p}")
            return 1
        print("clean: decision-refs/ matches the source corpus")
        return 0
    for p in result["written"]:
        print(f"wrote {p}")
    for p in result["pruned"]:
        print(f"pruned {p}")
    if not result["written"] and not result["pruned"]:
        print("clean: nothing to write")
    return 0


def cmd_check(args):
    dirs = args.dirs or DEFAULT_DIRS
    res = load_corpus(dirs, args.base)
    ids = _id_map(res.docs)
    lint = _lint_corpus(res, ids)
    if args.lint or args.cls == "ln":
        return _emit_findings(lint, args.mode, args.strict, args.json)
    # gate classes
    graph = build_graph(res.docs)
    lock = load_lock(args.base)
    classes = [args.cls] if args.cls else ["sg", "ci", "dr", "sp"]
    gate = run_gate(res.docs, graph, args.base, classes, lock,
                    decision_filter=args.decision)
    findings = lint + gate
    if args.aggregate:
        worst = 0
        for f in findings:
            worst = max(worst, effective_exit(f, args.mode, args.strict))
        blocking = sum(1 for f in findings if effective_exit(f, args.mode, args.strict))
        verdict = "PASS" if worst == 0 else ("LINT-FAIL" if worst == 2 else "FAIL")
        if args.json:
            print(json.dumps({"verdict": verdict, "exit": worst,
                              "findings": [f.as_dict(args.strict) for f in findings]},
                             indent=2))
        else:
            for f in findings:
                print(f.render(args.strict))
            print(f"DECISION_COHERENCE: {verdict} — {len(findings)} finding(s), "
                  f"{blocking} blocking → exit {worst}")
        return worst
    return _emit_findings(findings, args.mode, args.strict, args.json)


def cmd_show(args):
    d = _find_doc(args.id, args.base)
    if not d:
        print(f"error: no decision {args.id}", file=sys.stderr)
        return 2
    if args.level == "l2":
        sys.stdout.write(d.raw)
        return 0
    graph = build_graph(load_corpus(DEFAULT_DIRS, args.base).docs)
    if args.level == "l0":
        sys.stdout.write(generate._l0_card(d))
    else:
        sys.stdout.write(generate._l1_extract(d, graph))
    return 0


def cmd_supersede(args):
    old = _find_doc(args.old, args.base)
    new = _find_doc(args.by, args.base)
    if not old or not new:
        print("error: old or --by decision not found", file=sys.stderr)
        return 2
    ne = new.fm.setdefault("edges", {})
    ne.setdefault("supersedes", [])
    if old.id not in ne["supersedes"]:
        ne["supersedes"].append(old.id)
    oe = old.fm.setdefault("edges", {})
    oe.setdefault("superseded-by", [])
    if new.id not in oe["superseded-by"]:
        oe["superseded-by"].append(new.id)
    old.fm["status"] = "superseded"
    _rewrite(new)
    _rewrite(old)
    print(f"{new.id} supersedes {old.id}; {old.id} -> superseded")
    return 0


def cmd_status(args):
    d = _find_doc(args.id, args.base)
    if not d:
        print(f"error: no decision {args.id}", file=sys.stderr)
        return 2
    graph = build_graph(load_corpus(DEFAULT_DIRS, args.base).docs)
    new = args.new_status
    incoming = graph.incoming_supersedes.get(d.id, set())
    if new == "superseded" and not incoming:
        print(f"refused: setting {d.id} superseded with no incoming supersedes "
              f"would violate SG-002; use `decisions supersede`", file=sys.stderr)
        return 2
    if new in ACTIVE_STATUS and incoming:
        print(f"refused: {d.id} has incoming supersedes {sorted(incoming)}; "
              f"reactivating would violate SG-001", file=sys.stderr)
        return 2
    d.fm["status"] = new
    _rewrite(d)
    print(f"{d.id} -> {new}")
    return 0


def cmd_graph(args):
    res = load_corpus(DEFAULT_DIRS, args.base)
    graph = build_graph(res.docs)
    if args.format == "json":
        obj = {d.id: {"out": graph.edges_out(d.id), "in": graph.edges_in(d.id)}
               for d in sorted(res.docs, key=lambda x: x.id)}
        print(json.dumps(obj, indent=2))
    else:
        print("digraph decisions {")
        for d in sorted(res.docs, key=lambda x: x.id):
            for rel, targets in graph.edges_out(d.id).items():
                for t in targets:
                    print(f'  "{d.id}" -> "{t}" [label="{rel}"];')
        print("}")
    return 0


def cmd_baseline(args):
    d = _find_doc(args.id, args.base)
    if not d:
        print(f"error: no decision {args.id}", file=sys.stderr)
        return 2
    ids = _id_map(load_corpus(DEFAULT_DIRS, args.base).docs)
    lint = lint_document(d, ids)
    if lint:
        for f in lint:
            print(f.render(), file=sys.stderr)
        print("refused: lint must pass before baselining", file=sys.stderr)
        return 2
    entry = stamp_baseline(d, args.base, args.rev or "HEAD")
    lock = load_lock(args.base)
    lock[d.id] = entry
    lock_path = os.path.join(args.base, REFS_DIR, LOCK_NAME)
    os.makedirs(os.path.dirname(lock_path), exist_ok=True)
    with open(lock_path, "w", encoding="utf-8") as fh:
        yaml.safe_dump(lock, fh, sort_keys=True, default_flow_style=False)
    n = len(entry["invariants"])
    print(f"baselined {d.id}: {n} governed-delta invariant(s) stamped @ {entry['accepted_rev']}")
    return 0


def cmd_new(args):
    kdir = KIND_DIR[args.kind]
    d = os.path.join(args.base, kdir)
    os.makedirs(d, exist_ok=True)
    nums = []
    for p in discover_paths([kdir], args.base):
        m = re.match(r"^0*([0-9]+)", os.path.basename(p))
        if m:
            nums.append(int(m.group(1)))
    nxt = (max(nums) + 1) if nums else 1
    prefix = {"adr": "ADR", "pdr": "PDR", "brief": "BRIEF"}[args.kind]
    did = f"{prefix}-{nxt:03d}"
    slug = re.sub(r"[^a-z0-9]+", "-", args.title.lower()).strip("-")
    fname = os.path.join(d, f"{nxt:03d}-{slug}.md")
    fm = {
        "id": did, "kind": args.kind, "title": args.title,
        "status": "draft", "date": "1970-01-01",
        "description": "TODO: one-line L0 triage sentence",
        "edges": {},
    }
    if args.tier:
        fm["tier"] = args.tier
    if args.supersedes:
        fm["edges"]["supersedes"] = list(args.supersedes)
    if args.depends_on:
        fm["edges"]["depends-on"] = list(args.depends_on)
    body = "## Context\n\nTODO\n\n## Decision\n\nTODO\n"
    with open(fname, "w", encoding="utf-8") as fh:
        fh.write(P.render_document(fm, body))
    print(f"created {os.path.relpath(fname, args.base)}")
    # route supersessions through the atomic writer
    for old in (args.supersedes or []):
        od = _find_doc(old, args.base)
        if od:
            oe = od.fm.setdefault("edges", {})
            oe.setdefault("superseded-by", [])
            if did not in oe["superseded-by"]:
                oe["superseded-by"].append(did)
            od.fm["status"] = "superseded"
            _rewrite(od)
    return 0


def cmd_migrate(args):
    r = migrate_mod.migrate(args.paths, write=args.write,
                            report_path=args.report, base=args.base)
    if not args.write:
        print(f"DRY-RUN: {len(r['files'])} file(s) would be migrated; "
              f"{len(r['flags'])} flag(s). Use --write to apply.")
    else:
        print(f"migrated {len(r['written'])} file(s); {len(r['flags'])} flag(s).")
    for row in r["flags"][:200]:
        print("  FLAG " + "\t".join(str(x) for x in row))
    return 0


def _rewrite(doc):
    body = doc.body if doc.body.endswith("\n") else doc.body + "\n"
    with open(doc.path, "w", encoding="utf-8") as fh:
        fh.write(P.render_document(doc.fm, body))


# --------------------------------------------------------------------------- #
# parser
# --------------------------------------------------------------------------- #

def build_parser():
    p = argparse.ArgumentParser(prog="decisions",
                                description="Progressive-disclosure decision system.")
    p.add_argument("--base", default=".", help=argparse.SUPPRESS)
    sub = p.add_subparsers(dest="cmd", required=True)

    sub.add_parser("hash", help="canonicalize one invariant (stdin YAML) -> 16-hex")

    lp = sub.add_parser("list", help="id<TAB>status<TAB>title, sorted by id")
    lp.add_argument("dirs", nargs="*")

    bp = sub.add_parser("build", help="generate decision-refs/ (Step 2)")
    bp.add_argument("dirs", nargs="*")
    bp.add_argument("--check", action="store_true", help="drift gate (exit 1 on diff)")

    cp = sub.add_parser("check", help="coherence gate (Step 3)")
    cp.add_argument("dirs", nargs="*")
    cp.add_argument("--lint", action="store_true", help="LN class only")
    cp.add_argument("--mode", choices=["authoring", "distribution"], default="authoring")
    cp.add_argument("--class", dest="cls", choices=ALL_CLASSES)
    cp.add_argument("--decision")
    cp.add_argument("--strict", action="store_true")
    cp.add_argument("--json", action="store_true")
    cp.add_argument("--aggregate", action="store_true")

    sp = sub.add_parser("show", help="stream one projection (l0/l1/l2)")
    sp.add_argument("id")
    sp.add_argument("--level", choices=["l0", "l1", "l2"], default="l1")

    su = sub.add_parser("supersede", help="atomic supersede writer (both edges)")
    su.add_argument("old")
    su.add_argument("--by", required=True)

    st = sub.add_parser("status", help="guarded status transition")
    st.add_argument("id")
    st.add_argument("new_status")

    gp = sub.add_parser("graph", help="typed-edge graph")
    gp.add_argument("--format", choices=["dot", "json"], default="dot")

    bl = sub.add_parser("baseline", help="stamp coherence-lock entry (FC1)")
    bl.add_argument("id")
    bl.add_argument("--rev")

    npc = sub.add_parser("new", help="scaffold a new decision doc")
    npc.add_argument("--kind", required=True, choices=["adr", "pdr", "brief"])
    npc.add_argument("--title", required=True)
    npc.add_argument("--tier")
    npc.add_argument("--supersedes", action="append")
    npc.add_argument("--depends-on", dest="depends_on", action="append")

    mp = sub.add_parser("migrate", help="corpus frontmatter harvester (Step 5)")
    mp.add_argument("paths", nargs="*")
    mp.add_argument("--write", action="store_true")
    mp.add_argument("--report")
    return p


DISPATCH = {
    "hash": cmd_hash, "list": cmd_list, "build": cmd_build, "check": cmd_check,
    "show": cmd_show, "supersede": cmd_supersede, "status": cmd_status,
    "graph": cmd_graph, "baseline": cmd_baseline, "new": cmd_new,
    "migrate": cmd_migrate,
}


def main(argv=None):
    args = build_parser().parse_args(argv)
    return DISPATCH[args.cmd](args)


if __name__ == "__main__":
    sys.exit(main())
