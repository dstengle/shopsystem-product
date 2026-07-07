"""The coherence gate (``decisions check``, Step 3).

One deterministic pass over the parsed corpus implementing the four failure
classes, ordered SG -> CI -> DR -> SP (SG statuses gate DR/SP exemptions):

* **FC4 / COH-SG-*** — supersession & typed-edge graph coherence.
* **FC1 / COH-CI-*** — claimed invariant vs actual delta (baseline lock diff).
* **FC3 / COH-DR-*** — reference / doc<->reality drift resolution.
* **FC2 / COH-SP-*** — pending / stale forward-looking prose.

Every finding carries a stable check-id, a severity (B blocking-row / A
advisory-row), and a doctor-style remediation. Mode teeth (R8): B rows BLOCK in
``distribution`` and WARN in ``authoring``; ``--strict`` promotes advisories and
authoring WARNs to blocking.
"""

from __future__ import annotations

import glob
import os
import re
import subprocess
import unicodedata

import yaml

from .corpus import Graph
from .invhash import invariant_hash
from .model import Finding, SEV_ADVISORY, SEV_BLOCKING, SEV_LINT
from .schema import ACTIVE_STATUS, CLI_ALLOWLIST, RETIRED_STATUS

REFS_DIR = "decision-refs"
LOCK_NAME = "coherence-lock.yaml"

HEX16 = re.compile(r"\b[0-9a-f]{16}\b")
FLAG_RE = re.compile(r"(?<=\s)--[a-z][a-z0-9-]*")
ONESHOT_RE = re.compile(
    r"(?i)(one-?shot|exactly one .* deposit|exits after (depositing|emitting))")
FORWARD_RE = re.compile(
    r"(?i)\b("
    r"NOT YET BUILT|TBD|deferred|follow-?up|will (?:be|ship|land)|pending"
    # present-state "not yet ..." claims (e.g. "not yet an owned BC",
    # "not yet productionized") — the real FC2 phrasing the keyword list missed.
    r"|not yet\b"
    r")")
MD_LINK_RE = re.compile(r"\]\(([^)]+)\)")
# Any RFC-3986-style scheme prefix (http:, mailto:, beads:, bd:, ...). A link
# carrying one is not a relative filesystem path, so DR-001 must skip it.
URI_SCHEME_RE = re.compile(r"^[a-z][a-z0-9+.-]*:")


# --------------------------------------------------------------------------- #
# Oracles (lead-artifact surface only; never runs BC code — ADR-018)
# --------------------------------------------------------------------------- #

def scenarios_list(feature_path: str) -> dict[str, str]:
    """Return ``{title: hash}`` from ``scenarios list <feature>``. Empty on error."""
    try:
        out = subprocess.run(["scenarios", "list", feature_path],
                             capture_output=True, text=True, timeout=30)
    except (OSError, subprocess.SubprocessError):
        return {}
    result: dict[str, str] = {}
    for line in out.stdout.splitlines():
        if "\t" in line:
            h, title = line.split("\t", 1)
            result[title.strip()] = h.strip()
    return result


def feature_hashes(features: list[str], base: str) -> set[str]:
    hs: set[str] = set()
    for f in features:
        path = f if os.path.isabs(f) else os.path.join(base, f)
        hs.update(scenarios_list(path).values())
    return hs


def extract_tokens(features: list[str], surface: str | None, base: str) -> dict:
    """Extract surface tokens (flags + lifecycle) — the SAME function baseline
    stamping and check-time evaluation both call (§3.3)."""
    flags: set[str] = set()
    lifecycle: set[str] = set()
    words = []
    if surface:
        words = [w for w in re.split(r"[:\s]+", surface) if w and not w.startswith("cli")]
    for f in features:
        path = f if os.path.isabs(f) else os.path.join(base, f)
        if not os.path.exists(path):
            continue
        text = open(path, "r", encoding="utf-8").read()
        for line in text.splitlines():
            stripped = line.strip()
            if surface and words and not any(w in line for w in words):
                pass_line = False
            else:
                pass_line = True
            if pass_line:
                flags.update(FLAG_RE.findall(line))
            if stripped.startswith("Then") and ONESHOT_RE.search(line):
                lifecycle.add("one-shot")
    return {"flags": sorted(flags), "lifecycle": sorted(lifecycle)}


def _feature_files(base: str) -> list[str]:
    out = []
    for root in ("features", "features-provisional"):
        out.extend(glob.glob(os.path.join(base, root, "**", "*.feature"),
                             recursive=True))
    return sorted(out)


def _all_scenario_hashes(base: str) -> set[str]:
    hs: set[str] = set()
    for f in _feature_files(base):
        for m in re.finditer(r"@scenario_hash:([0-9a-f]{16})", open(f).read()):
            hs.add(m.group(1))
    return hs


def _all_origins(base: str) -> set[str]:
    origins: set[str] = set()
    for f in _feature_files(base):
        for m in re.finditer(r"@origin:([A-Za-z]+-[0-9]+)", open(f).read()):
            origins.add(m.group(1).upper())
    return origins


def canonicalize_table(text: str, section: str) -> str | None:
    """Return the sha256[:16] of the markdown table under heading ``section``.

    Canonicalization: NFC, LF, collapse intra-cell whitespace, drop the
    alignment (``---|---``) row. Returns None if the section/table is absent.
    """
    text = unicodedata.normalize("NFC", text).replace("\r\n", "\n")
    lines = text.split("\n")
    start = None
    for i, ln in enumerate(lines):
        if re.match(r"^#{1,6}\s+" + re.escape(section) + r"\b", ln):
            start = i + 1
            break
    if start is None:
        return None
    rows = []
    for ln in lines[start:]:
        if ln.strip().startswith("|"):
            if re.match(r"^\s*\|?[\s:|-]+\|?\s*$", ln) and set(ln) <= set(" |:-"):
                continue  # alignment row
            cells = [re.sub(r"\s+", " ", c.strip()) for c in ln.strip().strip("|").split("|")]
            rows.append("|".join(cells))
        elif rows:
            break
    if not rows:
        return None
    import hashlib
    return hashlib.sha256("\n".join(rows).encode("utf-8")).hexdigest()[:16]


# --------------------------------------------------------------------------- #
# Predicate evaluation (non governed-delta)
# --------------------------------------------------------------------------- #

def eval_predicate(pred: dict, doc, graph: Graph, base: str) -> tuple[str, str]:
    """Return (verdict, reason). verdict ∈ {holds, violated, unverified, missing}."""
    kind = pred.get("kind")
    if kind == "path-absent":
        p = os.path.join(base, pred["path"])
        return ("holds", "") if not os.path.exists(p) else ("violated", f"path {pred['path']} present")
    if kind == "path-present":
        p = os.path.join(base, pred["path"])
        return ("holds", "") if os.path.exists(p) else ("violated", f"path {pred['path']} absent")
    if kind == "scenario-hash":
        fpath = os.path.join(base, pred["feature"])
        if not os.path.exists(fpath):
            return ("missing", f"feature {pred['feature']} absent")
        table = scenarios_list(fpath)
        if pred["title"] not in table:
            return ("missing", f"scenario '{pred['title']}' not found")
        return ("holds", "") if table[pred["title"]] == pred["expect"] else \
               ("violated", f"hash {table[pred['title']]} != {pred['expect']}")
    if kind == "manifest-field":
        fpath = os.path.join(base, pred["file"])
        if not os.path.exists(fpath):
            return ("missing", f"file {pred['file']} absent")
        data = yaml.safe_load(open(fpath))
        cur = data
        for part in str(pred["jsonpath"]).split("."):
            if isinstance(cur, dict) and part in cur:
                cur = cur[part]
            else:
                return ("missing", f"jsonpath {pred['jsonpath']} unresolved")
        return ("holds", "") if cur == pred["expect"] else \
               ("violated", f"{pred['jsonpath']}={cur!r} != {pred['expect']!r}")
    if kind == "property-table":
        fpath = os.path.join(base, pred["file"])
        if not os.path.exists(fpath):
            return ("missing", f"file {pred['file']} absent")
        h = canonicalize_table(open(fpath).read(), pred["section"])
        if h is None:
            return ("missing", f"table section '{pred['section']}' absent")
        return ("holds", "") if h == pred["expect_hash"] else \
               ("violated", f"table hash {h} != {pred['expect_hash']}")
    if kind == "edge":
        rel, of = pred["assert"], pred["of"]
        return ("holds", "") if of in doc.edges(rel) else \
               ("violated", f"edge {rel}->{of} absent")
    if kind == "cli":
        cmd = pred.get("cmd") or []
        if not cmd or cmd[0] not in CLI_ALLOWLIST:
            return ("unverified", "forbidden-oracle")
        try:
            r = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        except (OSError, subprocess.SubprocessError):
            return ("unverified", "oracle-unavailable")
        exp = pred.get("expect_exit", 0)
        return ("holds", "") if r.returncode == exp else \
               ("violated", f"exit {r.returncode} != {exp}")
    return ("unverified", f"unknown-kind:{kind}")


# --------------------------------------------------------------------------- #
# Lock (coherence-lock.yaml) — FC1 baseline
# --------------------------------------------------------------------------- #

def load_lock(base: str) -> dict:
    p = os.path.join(base, REFS_DIR, LOCK_NAME)
    if not os.path.exists(p):
        return {}
    return yaml.safe_load(open(p)) or {}


def stamp_baseline(doc, base: str, rev: str) -> dict:
    """Compute the lock entry for all governed-delta invariants of ``doc``."""
    invs = {}
    for inv in (doc.fm.get("invariants") or []):
        pred = inv.get("predicate") or {}
        if pred.get("kind") != "governed-delta":
            continue
        feats = pred.get("features") or []
        governed = {}
        for f in feats:
            fpath = os.path.join(base, f)
            governed[f] = sorted(scenarios_list(fpath).values())
        invs[inv["id"]] = {
            "claim_hash": invariant_hash(inv),
            "governed_hashes": governed,
            "surface_tokens": extract_tokens(feats, pred.get("surface"), base),
        }
    return {"accepted_rev": rev, "invariants": invs}


# --------------------------------------------------------------------------- #
# FC4 — supersession / edge graph (COH-SG-*)
# --------------------------------------------------------------------------- #

SUP_REM = "run: decisions supersede <old> --by <new>"


def check_sg(docs, graph: Graph, base: str) -> list[Finding]:
    f: list[Finding] = []
    ids = set(graph.by_id)

    for d in docs:
        # SG-005: dangling edge targets (all 7 relations)
        for rel in ("supersedes", "superseded-by", "amends", "depends-on",
                    "anchored-on", "pins", "related"):
            for t in d.edges(rel):
                if t not in ids:
                    f.append(Finding("COH-SG-005", SEV_BLOCKING, d.path,
                                     f"edge {rel} -> {t} has no document on disk",
                                     "fix the id or author the missing doc"))
        # SG-001: supersedes a still-active target
        for t in d.edges("supersedes"):
            tgt = graph.by_id.get(t)
            if tgt and tgt.status not in ("superseded", "deprecated"):
                f.append(Finding("COH-SG-001", SEV_BLOCKING, d.path,
                                 f"{d.id} supersedes {t} but {t}.status={tgt.status}",
                                 f"run: decisions supersede {t} --by {d.id}"))
        # SG-003: asymmetric pair
        for t in d.edges("supersedes"):
            tgt = graph.by_id.get(t)
            if tgt and d.id not in tgt.edges("superseded-by"):
                f.append(Finding("COH-SG-003", SEV_BLOCKING, d.path,
                                 f"{d.id} supersedes {t} but {t} lacks superseded-by:{d.id}",
                                 SUP_REM))
        # SG-006: amends and supersedes between same ordered pair
        both = set(d.edges("amends")) & set(d.edges("supersedes"))
        for t in both:
            f.append(Finding("COH-SG-006", SEV_BLOCKING, d.path,
                             f"{d.id} both amends and supersedes {t}",
                             "pick one: amends (doc stays live) or supersedes (doc retires)"))
        # SG-007: active doc depends-on/anchored-on a retired doc
        if d.status in ACTIVE_STATUS:
            for rel in ("depends-on", "anchored-on"):
                for t in d.edges(rel):
                    tgt = graph.by_id.get(t)
                    if tgt and tgt.status in RETIRED_STATUS:
                        succ = ", ".join(tgt.edges("superseded-by")) or "the superseding doc"
                        f.append(Finding("COH-SG-007", SEV_BLOCKING, d.path,
                                         f"active {d.id} {rel} retired {t} ({tgt.status})",
                                         f"re-anchor on the superseding doc: {succ}"))

    # SG-002: retired-by-status but incoming supersedes set mismatched
    for d in docs:
        if d.status == "superseded":
            incoming = graph.incoming_supersedes.get(d.id, set())
            declared = set(d.edges("superseded-by"))
            if not incoming:
                f.append(Finding("COH-SG-002", SEV_BLOCKING, d.path,
                                 f"{d.id} is superseded but no doc carries supersedes->{d.id}",
                                 SUP_REM))
            elif incoming != declared:
                f.append(Finding("COH-SG-002", SEV_BLOCKING, d.path,
                                 f"{d.id}.superseded-by {sorted(declared)} != actual incoming {sorted(incoming)}",
                                 SUP_REM))

    # SG-004: cycle in supersedes ∪ amends
    cyc = _find_cycle(docs, ("supersedes", "amends"))
    if cyc:
        f.append(Finding("COH-SG-004", SEV_BLOCKING, cyc[0] + " (and others)",
                         f"cycle in supersedes∪amends: {' -> '.join(cyc)}",
                         "break the cycle; supersession is acyclic"))
    # SG-008: cycle in depends-on ∪ anchored-on
    cyc2 = _find_cycle(docs, ("depends-on", "anchored-on"))
    if cyc2:
        f.append(Finding("COH-SG-008", SEV_BLOCKING, cyc2[0] + " (and others)",
                         f"cycle in depends-on∪anchored-on: {' -> '.join(cyc2)}",
                         "break the dependency cycle"))

    # SG-009: two active docs supersede the same target w/o edge between them (A)
    for tgt, sources in graph.incoming_supersedes.items():
        actives = [s for s in sources if graph.by_id.get(s)
                   and graph.by_id[s].status in ACTIVE_STATUS]
        if len(actives) > 1:
            a, b = sorted(actives)[:2]
            da = graph.by_id[a]
            related = set(da.edges("supersedes")) | set(da.edges("amends")) | \
                set(da.edges("related")) | set(da.edges("depends-on"))
            if b not in related:
                f.append(Finding("COH-SG-009", SEV_ADVISORY,
                                 graph.by_id[a].path,
                                 f"{sorted(actives)} both supersede {tgt} with no edge between them",
                                 "order the successors or merge"))
    return f


def _find_cycle(docs, relations) -> list[str] | None:
    adj: dict[str, list[str]] = {}
    for d in docs:
        outs = []
        for rel in relations:
            outs.extend(d.edges(rel))
        adj[d.id] = outs
    WHITE, GRAY, BLACK = 0, 1, 2
    color = {d.id: WHITE for d in docs}
    stack: list[str] = []

    def dfs(u):
        color[u] = GRAY
        stack.append(u)
        for v in adj.get(u, []):
            if v not in color:
                continue
            if color[v] == GRAY:
                return stack[stack.index(v):] + [v]
            if color[v] == WHITE:
                r = dfs(v)
                if r:
                    return r
        color[u] = BLACK
        stack.pop()
        return None

    for d in docs:
        if color[d.id] == WHITE:
            r = dfs(d.id)
            if r:
                return r
    return None


# --------------------------------------------------------------------------- #
# FC1 — claimed invariant vs actual delta (COH-CI-*)
# --------------------------------------------------------------------------- #

def check_ci(docs, graph: Graph, base: str, lock: dict) -> list[Finding]:
    f: list[Finding] = []
    for d in docs:
        invs = d.fm.get("invariants") or []
        if d.kind in ("adr", "pdr") and d.status == "accepted" and not invs:
            f.append(Finding("COH-CI-000", SEV_ADVISORY, d.path,
                             f"{d.id} accepted with empty invariants[] (claims unverifiable)",
                             "author invariants[] or accept the CI-000 nag"))
            continue
        for inv in invs:
            iid = inv.get("id")
            # CI-007: stored hash vs recomputed
            stored = inv.get("hash")
            recomputed = invariant_hash(inv)
            if stored and stored != recomputed:
                f.append(Finding("COH-CI-007", SEV_BLOCKING, d.path,
                                 f"invariant {iid}: stored hash {stored} != recomputed {recomputed}",
                                 "claim reworded without re-hashing: run `decisions hash` and paste it",
                                 invariant=iid))
            pred = inv.get("predicate") or {}
            if pred.get("kind") == "governed-delta":
                f.extend(_check_governed_delta(d, inv, pred, base, lock))
            else:
                verdict, reason = eval_predicate(pred, d, graph, base)
                if verdict == "violated":
                    f.append(Finding("COH-CI-006", SEV_BLOCKING, d.path,
                                     f"invariant {iid} ({pred.get('kind')}) violated: {reason}",
                                     "the claim no longer holds against the artifact surface — amend or fix",
                                     invariant=iid))
                elif verdict == "missing":
                    f.append(Finding("COH-CI-004", SEV_BLOCKING, d.path,
                                     f"invariant {iid} predicate target missing: {reason}",
                                     "restore the target or correct the predicate",
                                     invariant=iid))
                elif verdict == "unverified":
                    f.append(Finding("COH-CI-008", SEV_ADVISORY, d.path,
                                     f"invariant {iid} unverified: {reason}",
                                     "resolve the oracle; --strict treats this as blocking",
                                     invariant=iid))
    return f


def _check_governed_delta(d, inv, pred, base, lock) -> list[Finding]:
    iid = inv.get("id")
    doc_lock = lock.get(d.id) or {}
    # accepted_rev is stamped at doc level by stamp_baseline(), not per-invariant.
    accepted_rev = doc_lock.get("accepted_rev")
    entry = doc_lock.get("invariants", {}).get(iid)
    if not entry:
        return [Finding("COH-CI-005", SEV_ADVISORY, d.path,
                        f"no lock entry for {d.id}/{iid}",
                        f"run: decisions baseline {d.id}", invariant=iid)]
    feats = pred.get("features") or []
    for fp in feats:
        if not os.path.exists(os.path.join(base, fp)):
            return [Finding("COH-CI-004", SEV_BLOCKING, d.path,
                            f"invariant {iid}: governed feature {fp} absent",
                            "restore the feature path or correct the predicate",
                            invariant=iid)]
    cur = feature_hashes(feats, base)
    lock_hashes = set()
    for hs in (entry.get("governed_hashes") or {}).values():
        lock_hashes.update(hs)
    added = cur - lock_hashes
    removed = lock_hashes - cur
    claim = pred.get("claim")
    retires = set(pred.get("retires") or [])
    cur_tok = extract_tokens(feats, pred.get("surface"), base)
    lock_tok = entry.get("surface_tokens") or {"flags": [], "lifecycle": []}
    flag_delta = set(cur_tok["flags"]) ^ set(lock_tok.get("flags") or [])
    life_delta = set(cur_tok["lifecycle"]) ^ set(lock_tok.get("lifecycle") or [])

    def detail():
        return [
            f"baseline : {d.id} @ {accepted_rev or '?'} — "
            f"{len(lock_hashes)} pin(s), flags {sorted(set(lock_tok.get('flags') or []))}",
            f"actual   : +{sorted(added)} -{sorted(removed)} "
            f"flag±{sorted(flag_delta)} lifecycle±{sorted(life_delta)}",
        ]

    findings: list[Finding] = []
    base_kw = dict(file=d.path, invariant=iid,
                   baseline={"rev": accepted_rev,
                             "hashes": sorted(lock_hashes),
                             "surface_tokens": lock_tok},
                   actual={"hashes": sorted(cur),
                           "added": sorted(added), "removed": sorted(removed),
                           "surface_tokens": cur_tok})
    if claim == "parity":
        if added or removed or flag_delta or life_delta:
            findings.append(Finding(
                "COH-CI-001", SEV_BLOCKING,
                summary=f"invariant {iid} (parity) governed delta nonempty",
                remediation="re-claim as `additive` listing the new hash(es), OR retire the new "
                            "pin if parity was intended; then `decisions hash` + `decisions baseline`.",
                detail=detail(), **base_kw))
    elif claim == "additive":
        undeclared = removed - retires
        if undeclared:
            findings.append(Finding(
                "COH-CI-002", SEV_BLOCKING,
                summary=f"invariant {iid} (additive) removed non-retired hash(es) {sorted(undeclared)}",
                remediation="list the removed hashes in `retires` or restore them",
                detail=detail(), **base_kw))
    elif claim in ("retire", "breaking"):
        undeclared = removed - retires
        still_present = retires & cur
        if undeclared:
            findings.append(Finding(
                "COH-CI-003", SEV_BLOCKING,
                summary=f"invariant {iid} ({claim}) undeclared retirement {sorted(undeclared)}",
                remediation="add the removed hashes to `retires`",
                detail=detail(), **base_kw))
        if still_present:
            findings.append(Finding(
                "COH-CI-003", SEV_BLOCKING,
                summary=f"invariant {iid} ({claim}) declared-retired but still present {sorted(still_present)}",
                remediation="actually retire the scenario, or drop it from `retires`",
                detail=detail(), **base_kw))
    return findings


# --------------------------------------------------------------------------- #
# FC3 — reference resolution (COH-DR-*), over non-retired docs
# --------------------------------------------------------------------------- #

def check_dr(docs, graph: Graph, base: str) -> list[Finding]:
    f: list[Finding] = []
    all_hashes = _all_scenario_hashes(base)
    all_retires = set()
    for d in docs:
        for inv in (d.fm.get("invariants") or []):
            all_retires.update((inv.get("predicate") or {}).get("retires") or [])
    corpus_ids = set(graph.by_id)

    for d in docs:
        if d.status in RETIRED_STATUS:
            continue
        doc_dir = os.path.dirname(d.path)
        own_hashes = {inv.get("hash") for inv in (d.fm.get("invariants") or [])}
        # DR-001: relative markdown links resolve
        for m in MD_LINK_RE.finditer(d.body):
            link = m.group(1).split()[0]
            # Skip in-page anchors and any URI with a scheme (http://, mailto:,
            # beads:, bd:, ...): a scheme prefix means "not a relative filesystem
            # path", so it is out of DR-001's scope. Custom schemes like
            # `beads:lead-mxy` are still covered by advisory DR-005, not blocking.
            if (link.startswith("#") or link == "#"
                    or URI_SCHEME_RE.match(link)):
                continue
            target = link.split("#")[0]
            if not target:
                continue
            resolved = os.path.normpath(os.path.join(doc_dir, target))
            if not os.path.exists(resolved):
                line = d.body[:m.start()].count("\n") + 1
                f.append(Finding("COH-DR-001", SEV_BLOCKING, d.path,
                                 f"relative link '{target}' does not resolve on disk",
                                 "fix the path or author the missing target", line=line))
            if target.startswith("features/") or target.startswith("features-provisional/"):
                fp = os.path.join(base, target)
                if not os.path.exists(fp):
                    line = d.body[:m.start()].count("\n") + 1
                    f.append(Finding("COH-DR-003", SEV_BLOCKING, d.path,
                                     f"cited feature path '{target}' absent",
                                     "fix the feature path or generate it", line=line))
        # DR-002: cited 16-hex hash resolves to a scenario or a retires list
        for m in HEX16.finditer(d.body):
            h = m.group(0)
            if h in own_hashes or h in all_hashes or h in all_retires:
                continue
            line = d.body[:m.start()].count("\n") + 1
            f.append(Finding("COH-DR-002", SEV_BLOCKING, d.path,
                             f"cited hash {h} matches no @scenario_hash and no retires list",
                             "fix the hash or add it to a retires[] declaration", line=line))
        # DR-005: lead-* bead refs (advisory; registry may be offline)
        for m in re.finditer(r"\b(lead-[a-z0-9]+)\b", d.body):
            bead = m.group(1)
            if not _bead_resolves(bead):
                line = d.body[:m.start()].count("\n") + 1
                f.append(Finding("COH-DR-005", SEV_ADVISORY, d.path,
                                 f"bead ref {bead} unresolvable via bd show",
                                 "confirm the bead id (registry may be offline)", line=line))

    # DR-004: feature @origin decision-id absent from the corpus
    for origin in sorted(_all_origins(base)):
        if origin not in corpus_ids:
            f.append(Finding("COH-DR-004", SEV_BLOCKING, "features/",
                             f"feature @origin:{origin} has no decision in the corpus",
                             "author the origin decision or fix the @origin tag"))
    return f


_BEAD_CACHE: dict[str, bool] = {}


def _bead_resolves(bead: str) -> bool:
    if bead in _BEAD_CACHE:
        return _BEAD_CACHE[bead]
    try:
        r = subprocess.run(["bd", "show", bead], capture_output=True,
                           text=True, timeout=10)
        ok = r.returncode == 0
    except (OSError, subprocess.SubprocessError):
        ok = True  # offline registry ⇒ advisory-not-error: treat as resolvable
    _BEAD_CACHE[bead] = ok
    return ok


# --------------------------------------------------------------------------- #
# FC2 — pending / stale forward-looking prose (COH-SP-*), over accepted docs
# --------------------------------------------------------------------------- #

def check_sp(docs, graph: Graph, base: str) -> list[Finding]:
    f: list[Finding] = []
    for d in docs:
        if d.status != "accepted":
            continue
        pending = d.fm.get("pending") or []
        markers = [p.get("marker", "") for p in pending]
        # SP-001: untagged forward-looking prose
        for i, line in enumerate(d.body.split("\n"), 1):
            if FORWARD_RE.search(line):
                if not any(mk and mk in line for mk in markers):
                    f.append(Finding("COH-SP-001", SEV_ADVISORY, d.path,
                                     f"untagged forward-looking prose: {line.strip()[:80]!r}",
                                     "add a pending: [{marker, predicate}] entry covering this line",
                                     line=i))
        # SP-002 / SP-003: pending predicate evaluation
        for p in pending:
            marker = p.get("marker", "")
            pred = p.get("predicate") or {}
            if marker and marker not in d.body:
                f.append(Finding("COH-SP-003", SEV_BLOCKING, d.path,
                                 f"pending marker '{marker[:50]}' no longer appears in the body",
                                 "remove the stale pending entry or restore the prose"))
                continue
            verdict, reason = _eval_pending(pred, base)
            if verdict == "true":
                f.append(Finding("COH-SP-002", SEV_BLOCKING, d.path,
                                 f"pending predicate satisfied ({reason}): 'not yet' prose now contradicts state",
                                 "the awaited thing landed — amend/supersede this doc and drop the pending"))
            elif verdict == "unresolvable":
                f.append(Finding("COH-SP-003", SEV_BLOCKING, d.path,
                                 f"pending predicate unresolvable: {reason}",
                                 "fix the pending predicate (bad hash/decision/path)"))
    return f


def _eval_pending(pred: dict, base: str) -> tuple[str, str]:
    """Return (verdict, reason). verdict ∈ {true, false, unresolvable}.
    ``true`` means the awaited thing LANDED (so 'not yet' prose is now stale)."""
    kind = pred.get("kind")
    if kind == "scenario-exists":
        h = pred.get("hash")
        return ("true", f"hash {h} present") if h in _all_scenario_hashes(base) else ("false", "")
    if kind == "decision-exists":
        did = pred.get("id")
        num = re.sub(r"^(ADR|PDR|BRIEF)-0*", "", str(did))
        for sub in ("adr", "pdr", "briefs"):
            if glob.glob(os.path.join(base, sub, f"{int(num):03d}-*.md")) if num.isdigit() else []:
                return ("true", f"{did} exists")
        return ("false", "")
    if kind == "file-exists":
        p = os.path.join(base, pred.get("path", ""))
        return ("true", f"{pred.get('path')} exists") if os.path.exists(p) else ("false", "")
    if kind == "feature-has-tag":
        fp = os.path.join(base, pred.get("feature", ""))
        if not os.path.exists(fp):
            return ("unresolvable", f"feature {pred.get('feature')} absent")
        tag = pred.get("tag", "")
        return ("true", f"tag {tag} present") if tag in open(fp).read() else ("false", "")
    if kind == "bead-closed":
        bead = pred.get("bead", "")
        try:
            r = subprocess.run(["bd", "show", "--json", bead],
                               capture_output=True, text=True, timeout=10)
            if r.returncode != 0:
                return ("false", "")  # unresolvable registry ⇒ advisory-not-error
            import json as _json
            data = _json.loads(r.stdout or "{}")
            status = data.get("status") if isinstance(data, dict) else None
            return ("true", f"{bead} closed") if status == "closed" else ("false", "")
        except Exception:
            return ("false", "")  # offline ⇒ treat as not-yet-landed
    return ("unresolvable", f"unknown-pending-kind:{kind}")


# --------------------------------------------------------------------------- #
# Orchestration
# --------------------------------------------------------------------------- #

CLASS_FN = {"sg": check_sg, "ci": None, "dr": check_dr, "sp": check_sp}


def run_gate(docs, graph, base, classes, lock, decision_filter=None):
    """Run the enabled check classes in canonical order (SG->CI->DR->SP)."""
    findings: list[Finding] = []
    if "sg" in classes:
        findings.extend(check_sg(docs, graph, base))
    if "ci" in classes:
        findings.extend(check_ci(docs, graph, base, lock))
    if "dr" in classes:
        findings.extend(check_dr(docs, graph, base))
    if "sp" in classes:
        findings.extend(check_sp(docs, graph, base))
    if decision_filter:
        findings = [f for f in findings if decision_filter in (f.file or "")
                    or _id_in_path(f.file, decision_filter)]
    return findings


def _id_in_path(path: str, did: str) -> bool:
    num = re.sub(r"^(ADR|PDR|BRIEF)-0*", "", did)
    return bool(num.isdigit() and re.search(rf"/0*{int(num):03d}-", path or ""))


def effective_exit(finding: Finding, mode: str, strict: bool) -> int:
    """Resolve a finding to an exit contribution given mode + strict (R8/R10)."""
    if finding.severity == SEV_LINT:
        return 2
    if finding.severity == SEV_BLOCKING:
        return 1 if (mode == "distribution" or strict) else 0
    if finding.severity == SEV_ADVISORY:
        return 1 if strict else 0
    return 0
