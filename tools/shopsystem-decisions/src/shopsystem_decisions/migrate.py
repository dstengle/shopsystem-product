"""Corpus migration harvester (``decisions migrate``, Step 5).

Idempotent, dual-dialect (list-style ADR-050+ vs bold-style ADR-001..049),
hazard-hardened: block-aware edge harvesting, a "does not supersede" negation
guard, and parenthetical-label boundary tolerance. Dry-run by default; ``--write``
prepends canonical frontmatter with the body byte-identical below the fence.
Every harvested edge and every net-new ``description`` is FLAGGED for the human
review phase — nothing is script-and-forget.
"""

from __future__ import annotations

import os
import re

from . import parser

STATUS_MAP = {
    "accepted": "accepted", "decided": "accepted", "ready": ("accepted", "ready-flagged"),
    "draft": "draft", "proposed": "proposed", "amended": "amended",
    "superseded": "superseded", "rejected": "rejected", "deprecated": "deprecated",
}
KIND_FOR_DIR = {"adr": "adr", "pdr": "pdr", "briefs": "brief"}
LABEL_TO_REL = {
    "supersedes": "supersedes", "amends": "amends", "pins": "pins",
    "anchored to": "anchored-on", "anchored on": "anchored-on",
    "implements": "anchored-on", "depends": "depends-on", "depends on": "depends-on",
}
_ID_IN_TEXT = re.compile(r"\b(ADR|PDR|BRIEF)-([0-9]{3,})\b", re.I)
_DATE = re.compile(r"\b(\d{4}-\d{2}-\d{2})\b")
_LABEL_BOUNDARY = re.compile(r"^(?:\*\*[^*]+:\*\*|\s*-\s*[A-Z][^:]*:)")


def _kind(path):
    return KIND_FOR_DIR.get(os.path.basename(os.path.dirname(os.path.abspath(path))),
                            "adr")


def _split_h1_body(text):
    lines = text.split("\n")
    h1 = ""
    hdr_end = len(lines)
    for i, ln in enumerate(lines):
        if ln.startswith("# "):
            h1 = ln[2:].strip()
            for j in range(i + 1, len(lines)):
                if lines[j].startswith("## "):
                    hdr_end = j
                    break
            return h1, lines[i + 1:hdr_end], i
    return h1, [], 0


def _parse_title(h1):
    m = re.match(r"^((?:ADR|PDR|BRIEF)-[0-9]+)\s*(?:—|--|-|:)\s*(.+)$", h1, re.I)
    if m:
        return m.group(1).upper(), m.group(2).strip()
    return None, h1.strip()


def _harvest_edges(header_lines):
    """Block-aware edge harvest with negation guard. Returns (edges, flags)."""
    edges: dict[str, list[str]] = {}
    flags = []
    cur_rel = None
    for raw in header_lines:
        line = raw.strip()
        low = line.lower()
        boundary = _LABEL_BOUNDARY.match(raw) or _LABEL_BOUNDARY.match(line)
        if boundary:
            cur_rel = None
            label_txt = re.sub(r"[*\-]", "", line.split(":")[0]).strip().lower()
            label_txt = re.sub(r"\s*\(.*", "", label_txt)  # drop parenthetical
            for lbl, rel in LABEL_TO_REL.items():
                if label_txt.startswith(lbl):
                    cur_rel = rel
                    break
        if cur_rel is None:
            continue
        if "does not supersede" in low or "not re-decided" in low or "not re-litigated" in low:
            continue  # negation guard
        for m in _ID_IN_TEXT.finditer(line):
            did = f"{m.group(1).upper()}-{int(m.group(2)):03d}"
            edges.setdefault(cur_rel, [])
            if cur_rel == "superseded-by":
                continue  # never harvested
            if did not in edges[cur_rel]:
                edges[cur_rel].append(did)
                flags.append(("edge-harvested-confirm", cur_rel, did))
    return edges, flags


def _harvest_status(header_lines):
    for ln in header_lines:
        m = re.search(r"(?i)status[:\s*]+\**\s*([A-Za-z]+)", ln)
        if m:
            tok = m.group(1).casefold()
            mapped = STATUS_MAP.get(tok, ("draft", f"status-unknown:{tok}"))
            if isinstance(mapped, tuple):
                return mapped[0], mapped[1]
            return mapped, None
    return "draft", "status-missing"


def harvest(path: str) -> tuple[dict, str, list]:
    """Harvest one file into (frontmatter, body, flags). Reconcile-only if it
    already has frontmatter."""
    text = open(path, "r", encoding="utf-8").read()
    if parser.has_frontmatter(text):
        fm, body = parser.split_frontmatter(text)
        # reconcile: recompute invariant hashes
        from .invhash import invariant_hash
        for inv in (fm.get("invariants") or []):
            inv["hash"] = invariant_hash(inv)
        return fm, body, [("reconcile-only",)]

    flags = []
    h1, header_lines, h1_idx = _split_h1_body(text)
    kind = _kind(path)
    did, title = _parse_title(h1)
    fn_num = re.match(r"^0*([0-9]+)", os.path.basename(path))
    if did is None and fn_num:
        did = f"{kind.upper() if kind != 'brief' else 'BRIEF'}-{int(fn_num.group(1)):03d}"
        flags.append(("id-derived-from-filename", did))
    elif did and fn_num and re.sub(r"\D", "", did.split("-")[1]).lstrip("0") != fn_num.group(1).lstrip("0"):
        flags.append(("id-filename-mismatch", did, fn_num.group(1)))

    status, sflag = _harvest_status(header_lines)
    if sflag:
        flags.append(("status", sflag))
    date = None
    for ln in header_lines:
        m = _DATE.search(ln)
        if m:
            date = m.group(1)
            break
    if not date:
        flags.append(("date-missing",))
        date = "1970-01-01"

    edges, eflags = _harvest_edges(header_lines)
    flags.extend(eflags)

    beads = sorted(set(re.findall(r"\b(lead-[a-z0-9]+)\b", "\n".join(header_lines))))
    invariants = []
    for ln in header_lines:
        m = re.search(r"hard-invariant #(\d+)", ln)
        if m:
            invariants.append({
                "id": f"hard-invariant-{m.group(1)}",
                "statement": "TODO: backfill from prose",
                "predicate": {"kind": "path-present", "path": "TODO"},
                "hash": "0000000000000000",
                "status": "unverified",
            })
            flags.append(("invariant-backfill", f"#{m.group(1)}"))

    fm = {
        "id": did, "kind": kind, "title": title, "status": status,
        "date": date, "description": "TODO: net-new human-authored L0 line",
    }
    flags.append(("description-net-new-required",))
    if beads:
        fm["beads"] = beads
    fm["edges"] = edges
    if invariants:
        fm["invariants"] = invariants

    # body is everything from the H1 line onward, byte-identical
    body = "\n".join(text.split("\n")[h1_idx:])
    return fm, body, flags


def migrate(paths: list[str], write: bool = False, report_path: str | None = None,
            base: str = ".") -> dict:
    """Run the harvester over paths. Returns {files, flags, written}."""
    from .corpus import discover_paths
    if not paths:
        paths = ["adr", "pdr", "briefs"]
    files = []
    for p in paths:
        full = p if os.path.isabs(p) else os.path.join(base, p)
        if os.path.isdir(full):
            files.extend(discover_paths([p], base))
        else:
            files.append(full)
    all_flags = []
    written = []
    for f in sorted(set(files)):
        fm, body, flags = harvest(f)
        for fl in flags:
            all_flags.append((os.path.relpath(f, base), *fl))
        if write:
            out = parser.render_document(fm, body if body.endswith("\n") else body + "\n")
            with open(f, "w", encoding="utf-8") as fh:
                fh.write(out)
            written.append(os.path.relpath(f, base))
    report = "\n".join("\t".join(str(x) for x in row) for row in all_flags) + "\n"
    if report_path:
        with open(report_path, "w", encoding="utf-8") as fh:
            fh.write(report)
    return {"files": [os.path.relpath(f, base) for f in files],
            "flags": all_flags, "written": written, "report": report}
