"""Frontmatter schema (§1.2) + the mechanical lint catalog (``COH-LN-*``, §1.5).

Rather than pull an external JSON-Schema engine (stack is stdlib + PyYAML only),
the normative schema lives in ``schema/decision.schema.yaml`` for documentation
and the enforcement is hand-rolled here so every rule maps to a stable check-id
with a doctor remediation. ``schema/decision.schema.yaml`` and this module are
kept in lockstep.
"""

from __future__ import annotations

import os
import re

from .invhash import invariant_hash
from .model import Finding, SEV_LINT

ID_RE = re.compile(r"^(ADR|PDR|BRIEF)-[0-9]{3,}$")
SLUG_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
BEAD_RE = re.compile(r"^[a-z]+-[a-z0-9]+$")

KIND_ENUM = {"adr", "pdr", "brief"}
STATUS_ENUM = {"draft", "proposed", "accepted", "amended",
               "superseded", "rejected", "deprecated"}
ACTIVE_STATUS = {"draft", "proposed", "accepted", "amended"}
RETIRED_STATUS = {"superseded", "rejected", "deprecated"}
TIER_ENUM = {"framework", "system-global", "bc-local"}
DISCLOSURE_LEVELS = {"l0", "l1", "l2"}
EDGE_RELATIONS = ["supersedes", "superseded-by", "amends",
                  "depends-on", "anchored-on", "pins", "related"]

CLI_ALLOWLIST = {"scenarios", "shop-msg", "bd", "git", "test"}

# predicate kind -> required field names (for LN-005 mechanical shape check)
PREDICATE_KINDS = {
    "scenario-hash": {"feature", "title", "expect"},
    "path-absent": {"path"},
    "path-present": {"path"},
    "manifest-field": {"file", "jsonpath", "expect"},
    "property-table": {"file", "section", "expect_hash"},
    "edge": {"assert", "of"},
    "cli": {"cmd"},
    "governed-delta": {"claim", "features"},
}
PENDING_KINDS = {
    "scenario-exists": {"hash"},
    "decision-exists": {"id"},
    "bead-closed": {"bead"},
    "file-exists": {"path"},
    "feature-has-tag": {"feature", "tag"},
}

L1_HEADINGS_RE = re.compile(
    r"^##\s+(Decision|The decisions|The decision|Point of intent)\b", re.M)

KIND_DIR = {"adr": "adr", "pdr": "pdr", "brief": "briefs"}


def _num_from_filename(path: str) -> str | None:
    m = re.match(r"^0*([0-9]+)", os.path.basename(path))
    return str(int(m.group(1))) if m else None


def _num_from_id(did: str) -> str | None:
    m = re.match(r"^(?:ADR|PDR|BRIEF)-0*([0-9]+)$", did)
    return str(int(m.group(1))) if m else None


def _f(check_id: str, path: str, summary: str, remediation: str,
       line: int | None = None) -> Finding:
    return Finding(check_id=check_id, severity=SEV_LINT, file=path,
                   summary=summary, remediation=remediation, line=line)


def _validate_predicate(pred, path, findings, ctx):
    if not isinstance(pred, dict) or "kind" not in pred:
        findings.append(_f("COH-LN-005", path,
                           f"{ctx}: predicate missing 'kind'",
                           "give the predicate a 'kind' from the 8-kind DSL (§1.2a)"))
        return
    kind = pred["kind"]
    if kind not in PREDICATE_KINDS:
        findings.append(_f("COH-LN-005", path,
                           f"{ctx}: unknown predicate kind '{kind}'",
                           f"use one of: {', '.join(sorted(PREDICATE_KINDS))}"))
        return
    missing = PREDICATE_KINDS[kind] - set(pred.keys())
    if missing:
        findings.append(_f("COH-LN-005", path,
                           f"{ctx}: predicate '{kind}' missing fields {sorted(missing)}",
                           f"add the required fields for kind '{kind}'"))
    if kind == "cli":
        cmd = pred.get("cmd")
        if not isinstance(cmd, list) or not cmd or cmd[0] not in CLI_ALLOWLIST:
            findings.append(_f("COH-LN-005", path,
                               f"{ctx}: cli predicate cmd[0] not in allowlist",
                               f"cmd[0] must be one of {sorted(CLI_ALLOWLIST)}"))
    if kind == "governed-delta":
        claim = pred.get("claim")
        if claim in ("retire", "breaking"):
            retires = pred.get("retires")
            if not retires:
                findings.append(_f("COH-LN-008", path,
                                   f"{ctx}: governed-delta claim '{claim}' with empty 'retires'",
                                   "list the retired 16-hex scenario hashes in 'retires'"))


def lint_document(doc, corpus_ids: dict) -> list[Finding]:
    """Return all ``COH-LN-*`` findings for a single parsed document.

    ``corpus_ids`` maps id -> path for duplicate detection (COH-LN-003).
    """
    findings: list[Finding] = []
    fm = doc.fm
    path = doc.path

    # LN-006: forbidden decision: key
    if "decision" in fm:
        findings.append(_f("COH-LN-006", path,
                           "forbidden 'decision:' frontmatter key present",
                           "delete it; L1 is extracted from the '## Decision' body section (R3)"))

    # required fields
    for req in ("id", "kind", "title", "status", "date", "description"):
        if req not in fm or fm[req] in (None, ""):
            findings.append(_f("COH-LN-001", path,
                               f"required field '{req}' missing",
                               f"add '{req}:' to the frontmatter (schema §1.2)"))

    did = str(fm.get("id", ""))
    if did and not ID_RE.match(did):
        findings.append(_f("COH-LN-001", path,
                           f"id '{did}' fails pattern ^(ADR|PDR|BRIEF)-[0-9]{{3,}}$",
                           "fix the id to match ADR-050 / PDR-024 / BRIEF-015 form"))

    kind = str(fm.get("kind", ""))
    if kind and kind not in KIND_ENUM:
        findings.append(_f("COH-LN-001", path,
                           f"kind '{kind}' not in {sorted(KIND_ENUM)}",
                           "set kind to adr | pdr | brief"))

    status = str(fm.get("status", ""))
    if status and status not in STATUS_ENUM:
        findings.append(_f("COH-LN-001", path,
                           f"status '{status}' off-enum (R5)",
                           "use lowercase: draft|proposed|accepted|amended|superseded|rejected|deprecated"))

    if not str(fm.get("title", "")).strip() and "title" in fm:
        findings.append(_f("COH-LN-001", path, "title is empty",
                           "give the decision a non-empty title (H1 text)"))

    # LN-002: id-number vs filename; kind vs directory
    if did and ID_RE.match(did):
        fn_num, id_num = _num_from_filename(path), _num_from_id(did)
        if fn_num is not None and id_num is not None and fn_num != id_num:
            findings.append(_f("COH-LN-002", path,
                               f"id number {id_num} != filename number {fn_num}",
                               "rename the file or fix the id so the numbers match"))
    if kind in KIND_ENUM:
        parent = os.path.basename(os.path.dirname(os.path.abspath(path)))
        if parent and parent != KIND_DIR[kind]:
            findings.append(_f("COH-LN-002", path,
                               f"kind '{kind}' but containing dir '{parent}' != '{KIND_DIR[kind]}'",
                               f"move the file under '{KIND_DIR[kind]}/' or fix kind"))

    # LN-003: duplicate id
    if did and corpus_ids.get(did) and corpus_ids[did] != path:
        findings.append(_f("COH-LN-003", path,
                           f"duplicate id '{did}' (also in {corpus_ids[did]})",
                           "renumber one of the two documents"))

    # LN-004: description shape
    desc = fm.get("description")
    if isinstance(desc, str):
        if "\n" in desc:
            findings.append(_f("COH-LN-004", path,
                               "description contains a newline",
                               "keep description on one line, <=180 chars"))
        if len(desc) > 180:
            findings.append(_f("COH-LN-004", path,
                               f"description {len(desc)} chars > 180",
                               "trim the L0 triage line to <=180 chars"))

    # LN-007: tier
    tier = fm.get("tier")
    if tier is not None:
        if str(tier) in DISCLOSURE_LEVELS:
            findings.append(_f("COH-LN-007", path,
                               f"tier '{tier}' is a disclosure level, not a governance tier",
                               "tier carries ADR-035 governance only: framework|system-global|bc-local"))
        elif str(tier) not in TIER_ENUM:
            findings.append(_f("COH-LN-007", path,
                               f"tier '{tier}' off-enum",
                               "set tier to framework | system-global | bc-local, or remove it"))

    # LN-005: edges
    edges = fm.get("edges") or {}
    if isinstance(edges, dict):
        for rel, vals in edges.items():
            if rel not in EDGE_RELATIONS:
                findings.append(_f("COH-LN-005", path,
                                   f"unknown edge relation '{rel}'",
                                   f"use one of {EDGE_RELATIONS}"))
                continue
            for v in (vals or []):
                if not ID_RE.match(str(v)):
                    findings.append(_f("COH-LN-005", path,
                                       f"edge {rel} target '{v}' fails id pattern",
                                       "fix the target id"))

    # LN-005: invariants / pending predicate shapes
    for inv in (fm.get("invariants") or []):
        iid = inv.get("id", "?") if isinstance(inv, dict) else "?"
        if not isinstance(inv, dict):
            findings.append(_f("COH-LN-005", path, "invariant is not a mapping",
                               "each invariant needs id/statement/predicate/hash"))
            continue
        if not SLUG_RE.match(str(iid)):
            findings.append(_f("COH-LN-005", path,
                               f"invariant id '{iid}' fails slug pattern",
                               "use a lowercase kebab-case invariant id"))
        _validate_predicate(inv.get("predicate"), path, findings,
                            f"invariant {iid}")
    for p in (fm.get("pending") or []):
        if not isinstance(p, dict) or "marker" not in p or "predicate" not in p:
            findings.append(_f("COH-LN-005", path,
                               "pending entry missing marker/predicate",
                               "each pending needs {marker, predicate}"))
            continue
        pred = p.get("predicate") or {}
        pk = pred.get("kind") if isinstance(pred, dict) else None
        if pk not in PENDING_KINDS:
            findings.append(_f("COH-LN-005", path,
                               f"pending predicate kind '{pk}' unknown",
                               f"use one of {sorted(PENDING_KINDS)}"))

    for bead in (fm.get("beads") or []):
        if not BEAD_RE.match(str(bead)):
            findings.append(_f("COH-LN-005", path,
                               f"bead ref '{bead}' fails pattern",
                               "use a ^[a-z]+-[a-z0-9]+$ bead id"))

    # LN-009: L1 extraction source
    if kind in ("adr", "pdr") and status in ACTIVE_STATUS:
        if not L1_HEADINGS_RE.search(doc.body):
            findings.append(_f("COH-LN-009", path,
                               "no '## Decision' (chain) heading for L1 extraction",
                               "add a '## Decision' section (or one of the fallback headings)"))

    # CI-007 sibling at lint-time: stored hash present but wrong shape
    for inv in (fm.get("invariants") or []):
        if isinstance(inv, dict):
            h = inv.get("hash")
            if h is not None and not re.match(r"^[0-9a-f]{16}$", str(h)):
                findings.append(_f("COH-LN-005", path,
                                   f"invariant {inv.get('id')} hash '{h}' not 16-hex",
                                   "run `decisions hash` and paste the 16-hex value"))

    return findings
