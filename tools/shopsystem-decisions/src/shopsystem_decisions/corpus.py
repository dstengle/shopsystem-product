"""Corpus discovery, parsing, the typed-edge graph, and L1 extraction.

This is the shared substrate the generator and the gate both consume: a
deterministic (codepoint-sorted) walk of ``adr/`` ``pdr/`` ``briefs/``, each file
parsed into a :class:`~shopsystem_decisions.model.Document`, plus a
:class:`Graph` that resolves stored edges and *derives* inverse edges at read
time (R6: ``pinned-by``, ``anchored-by``, ``depended-on-by`` are never stored).
"""

from __future__ import annotations

import glob
import os
import re
from dataclasses import dataclass, field

from . import parser
from .model import Document

KIND_FOR_DIR = {"adr": "adr", "pdr": "pdr", "briefs": "brief"}

# stored relation -> derived inverse relation name (R6)
DERIVED_INVERSE = {
    "pins": "pinned-by",
    "anchored-on": "anchored-by",
    "depends-on": "depended-on-by",
}

_L1_HEADING = re.compile(
    r"^##\s+(Decision|The decisions|The decision|Point of intent)\b", re.M)
_H2 = re.compile(r"^##\s+", re.M)


def discover_paths(dirs: list[str], base: str = ".") -> list[str]:
    """Return every ``NNN-*.md`` under the given dirs, codepoint-sorted."""
    paths: list[str] = []
    for d in dirs:
        root = d if os.path.isabs(d) else os.path.join(base, d)
        paths.extend(glob.glob(os.path.join(root, "*.md")))
    return sorted(paths, key=lambda p: p)


def _kind_for_path(path: str) -> str:
    parent = os.path.basename(os.path.dirname(os.path.abspath(path)))
    return KIND_FOR_DIR.get(parent, parent)


def load_document(path: str, base: str = ".") -> Document:
    """Parse one file into a :class:`Document` (raises FrontmatterError)."""
    with open(path, "r", encoding="utf-8") as fh:
        raw = fh.read()
    fm, body = parser.split_frontmatter(raw)
    try:
        rel = os.path.relpath(path, base)
    except ValueError:
        rel = path
    return Document(path=path, relpath=rel, kind=_kind_for_path(path),
                    fm=fm, body=body, raw=raw)


@dataclass
class LoadResult:
    docs: list[Document]
    parse_errors: list[tuple[str, str]] = field(default_factory=list)  # (path, msg)


def load_corpus(dirs: list[str], base: str = ".") -> LoadResult:
    """Discover + parse every doc; unparseable files collected as errors."""
    docs: list[Document] = []
    errors: list[tuple[str, str]] = []
    for path in discover_paths(dirs, base):
        try:
            docs.append(load_document(path, base))
        except parser.FrontmatterError as e:
            errors.append((path, str(e)))
    return LoadResult(docs=docs, parse_errors=errors)


def extract_decision(body: str) -> tuple[str, str] | None:
    """Extract the L1 ``## Decision`` section body (heading, text) or None.

    Uses the fallback chain ``Decision`` -> ``The decisions`` -> ``The decision``
    -> ``Point of intent`` (first match wins). Section runs to the next H2/EOF.
    """
    m = _L1_HEADING.search(body)
    if not m:
        return None
    heading_line_end = body.find("\n", m.start())
    heading = body[m.start():heading_line_end if heading_line_end != -1 else len(body)].strip()
    start = heading_line_end + 1 if heading_line_end != -1 else len(body)
    nxt = _H2.search(body, start)
    end = nxt.start() if nxt else len(body)
    return heading, body[start:end].strip("\n")


@dataclass
class Graph:
    """Resolved typed-edge graph over the corpus."""

    docs: list[Document]
    by_id: dict[str, Document] = field(default_factory=dict)
    incoming_supersedes: dict[str, set[str]] = field(default_factory=dict)
    derived_in: dict[str, dict[str, list[str]]] = field(default_factory=dict)

    def edges_out(self, did: str) -> dict[str, list[str]]:
        d = self.by_id.get(did)
        if not d:
            return {}
        e = d.fm.get("edges") or {}
        return {rel: sorted(vals) for rel, vals in e.items() if vals}

    def edges_in(self, did: str) -> dict[str, list[str]]:
        return {rel: sorted(v) for rel, v in self.derived_in.get(did, {}).items() if v}


def build_graph(docs: list[Document]) -> Graph:
    """Index docs by id, compute incoming supersedes, derive inverse edges."""
    g = Graph(docs=docs)
    for d in docs:
        if d.id:
            g.by_id.setdefault(d.id, d)
    for d in docs:
        did = d.id
        for target in d.edges("supersedes"):
            g.incoming_supersedes.setdefault(target, set()).add(did)
        for rel, inv_name in DERIVED_INVERSE.items():
            for target in d.edges(rel):
                g.derived_in.setdefault(target, {}).setdefault(inv_name, []).append(did)
    # deterministic ordering of derived lists
    for tgt, rels in g.derived_in.items():
        for rel in rels:
            rels[rel] = sorted(set(rels[rel]))
    return g
