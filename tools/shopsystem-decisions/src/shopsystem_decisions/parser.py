"""Frontmatter parsing and the *canonical YAML profile* emitter (R2/§1.3).

The determinism doctrine here is load-bearing: every tool that rewrites
frontmatter (``new``, ``migrate``, ``supersede``, ``status``) and every generated
artifact goes through :func:`render_document` / :func:`emit_frontmatter`, so byte
output is a pure function of the parsed data. Rules enforced:

* parse with ``yaml.safe_load`` only; every string NFC-normalized at the boundary;
* fixed top-level key order (§1.2); edge relations in the §1.2 order;
* dates/timestamps always emitted as *quoted* strings (no implicit datetime);
* id-lists (edges, beads) sorted by Unicode codepoint (C locale);
* LF newlines only, no trailing whitespace, exactly one trailing ``\\n``;
* empty optional keys omitted (edge sub-keys kept present for stability);
* the body below the closing ``---`` is byte-preserved.
"""

from __future__ import annotations

import re
import unicodedata
from typing import Any

import yaml

FENCE = "---"

# Canonical top-level key order.
KEY_ORDER = [
    "id", "kind", "title", "status", "date", "description",
    "authors", "tier", "tags", "beads", "edges", "invariants", "pending",
]
# Canonical edge-relation order (§1.2 / R6).
EDGE_ORDER = [
    "supersedes", "superseded-by", "amends",
    "depends-on", "anchored-on", "pins", "related",
]

_DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}(T[0-9:.+Z-]+)?$")


class FrontmatterError(ValueError):
    """Raised when a file has no parseable ``---`` frontmatter fence."""


def nfc(s: str) -> str:
    """NFC-normalize a string (idempotent)."""
    return unicodedata.normalize("NFC", s)


def normalize_body(body: str) -> str:
    """CRLF->LF, strip per-line trailing whitespace, NFC. Trailing newline left
    to the caller (body byte-preservation is handled by the split)."""
    body = body.replace("\r\n", "\n").replace("\r", "\n")
    body = "\n".join(line.rstrip() for line in body.split("\n"))
    return nfc(body)


def _nfc_tree(v: Any) -> Any:
    if isinstance(v, str):
        return nfc(v)
    if isinstance(v, list):
        return [_nfc_tree(x) for x in v]
    if isinstance(v, dict):
        return {(_nfc_tree(k) if isinstance(k, str) else k): _nfc_tree(x)
                for k, x in v.items()}
    return v


def split_frontmatter(text: str) -> tuple[dict, str]:
    """Split a document into (frontmatter dict, body string).

    Raises :class:`FrontmatterError` if the text does not open with a ``---``
    fence or the closing fence is missing.
    """
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    if not text.startswith(FENCE + "\n") and text.rstrip("\n") != FENCE:
        raise FrontmatterError("document does not begin with a '---' fence")
    lines = text.split("\n")
    if lines[0].strip() != FENCE:
        raise FrontmatterError("document does not begin with a '---' fence")
    # find closing fence
    close = None
    for i in range(1, len(lines)):
        if lines[i].strip() == FENCE:
            close = i
            break
    if close is None:
        raise FrontmatterError("frontmatter closing '---' fence not found")
    fm_text = "\n".join(lines[1:close])
    body = "\n".join(lines[close + 1:])
    data = yaml.safe_load(fm_text) if fm_text.strip() else {}
    if data is None:
        data = {}
    if not isinstance(data, dict):
        raise FrontmatterError("frontmatter is not a mapping")
    return _nfc_tree(data), body


def has_frontmatter(text: str) -> bool:
    """True if the text opens with a ``---`` frontmatter fence."""
    return text.replace("\r\n", "\n").startswith(FENCE + "\n")


# --------------------------------------------------------------------------- #
# Canonical emitter
# --------------------------------------------------------------------------- #

def _needs_quote(s: str) -> bool:
    if s == "":
        return True
    if _DATE_RE.match(s):
        return True
    # yaml-significant leading chars or ambiguous scalars
    if s[0] in "!&*?|>%@`\"'#,[]{}:-" or s.strip() != s:
        return True
    if ": " in s or s.endswith(":") or " #" in s or "\t" in s:
        return True
    if s.lower() in ("true", "false", "null", "yes", "no", "on", "off", "~"):
        return True
    if re.match(r"^[+-]?(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?$", s):
        return True
    return False


def _scalar(v: Any) -> str:
    if v is True:
        return "true"
    if v is False:
        return "false"
    if v is None:
        return "null"
    if isinstance(v, (int, float)):
        return str(v)
    s = nfc(str(v))
    if _needs_quote(s):
        return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'
    return s


def _emit_entry(prefix: str, key: str, v: Any, indent: int, out: list[str]) -> None:
    """Emit one ``key: value`` entry. ``prefix`` is the literal string before the
    key (carries any ``- `` seq marker); ``indent`` is the key's column, so nested
    children go at ``indent + 2``."""
    if isinstance(v, dict):
        if not v:
            out.append(f"{prefix}{key}: {{}}")
            return
        out.append(f"{prefix}{key}:")
        _emit_map(v, indent + 2, out)
    elif isinstance(v, list):
        # inline flow for lists of scalars keeps predicates compact & stable
        if all(not isinstance(x, (dict, list)) for x in v):
            inner = ", ".join(_scalar(x) for x in v)
            out.append(f"{prefix}{key}: [{inner}]")
        else:
            out.append(f"{prefix}{key}:")
            for x in v:
                _emit_seq_item(x, indent + 2, out)
    else:
        out.append(f"{prefix}{key}: {_scalar(v)}")


def _emit_seq_item(it: Any, indent: int, out: list[str]) -> None:
    """Emit one sequence item. ``indent`` is the column of the ``- `` marker."""
    pad = " " * indent
    if isinstance(it, dict):
        keys = list(it.keys())
        for i, k in enumerate(keys):
            prefix = f"{pad}- " if i == 0 else f"{pad}  "
            _emit_entry(prefix, k, it[k], indent + 2, out)
    else:
        out.append(f"{pad}- {_scalar(it)}")


def _emit_map(d: dict, indent: int, out: list[str]) -> None:
    pad = " " * indent
    for k in d:
        _emit_entry(pad, k, d[k], indent, out)


def _sorted_ids(v: Any) -> list:
    return sorted((x for x in (v or [])), key=lambda s: str(s))


def _canon_predicate(pred: Any) -> Any:
    """Recursively sort nested dict keys so predicate emission is stable
    (identity hashing uses json separately; this is cosmetic determinism)."""
    if isinstance(pred, dict):
        return {k: _canon_predicate(pred[k]) for k in sorted(pred.keys())}
    if isinstance(pred, list):
        return [_canon_predicate(x) for x in pred]
    return pred


def emit_frontmatter(fm: dict) -> str:
    """Render the frontmatter block (without fences) per the canonical profile."""
    out: list[str] = []
    for key in KEY_ORDER:
        if key not in fm or fm[key] is None:
            continue
        v = fm[key]
        if key == "edges":
            edges = v or {}
            # keep all relations present, in canonical order, sorted id-lists
            out.append("edges:")
            for rel in EDGE_ORDER:
                vals = _sorted_ids(edges.get(rel))
                inner = ", ".join(_scalar(x) for x in vals)
                out.append(f"  {rel}: [{inner}]")
            continue
        if key in ("authors", "tags"):
            if not v:
                continue
            inner = ", ".join(_scalar(x) for x in v)
            out.append(f"{key}: [{inner}]")
            continue
        if key == "beads":
            if not v:
                continue
            inner = ", ".join(_scalar(x) for x in _sorted_ids(v))
            out.append(f"{key}: [{inner}]")
            continue
        if key == "invariants":
            if not v:
                continue
            out.append("invariants:")
            for inv in v:
                inv = dict(inv)
                if "predicate" in inv:
                    inv["predicate"] = _canon_predicate(inv["predicate"])
                _emit_seq_item(inv, 2, out)
            continue
        if key == "pending":
            if not v:
                continue
            out.append("pending:")
            for p in v:
                p = dict(p)
                if "predicate" in p:
                    p["predicate"] = _canon_predicate(p["predicate"])
                _emit_seq_item(p, 2, out)
            continue
        # plain scalars
        out.append(f"{key}: {_scalar(v)}")
    return "\n".join(out) + "\n"


def render_document(fm: dict, body: str) -> str:
    """Reassemble a full document: fenced canonical frontmatter + verbatim body.

    The body is emitted byte-for-byte as given (callers pass the preserved body).
    Guarantees exactly one trailing newline at EOF.
    """
    block = emit_frontmatter(fm)
    doc = f"{FENCE}\n{block}{FENCE}\n{body}"
    doc = doc.replace("\r\n", "\n")
    if not doc.endswith("\n"):
        doc += "\n"
    # collapse a run of trailing newlines to exactly one
    doc = doc.rstrip("\n") + "\n"
    return doc
