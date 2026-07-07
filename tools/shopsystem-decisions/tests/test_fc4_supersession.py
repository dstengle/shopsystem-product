"""FC4 — typed-edge / supersession graph coherence (COH-SG-*)."""

import pytest

from shopsystem_decisions.corpus import build_graph, load_corpus
from shopsystem_decisions.gate import run_gate
from conftest import mkdoc


def _sg(base):
    res = load_corpus(["adr", "pdr", "briefs"], base)
    graph = build_graph(res.docs)
    return {f.check_id for f in run_gate(res.docs, graph, base, ["sg"], {})}


def test_sg001_supersedes_active_target(tmp_path):
    base = str(tmp_path)
    mkdoc(base, 1, "adr", edges={"supersedes": ["ADR-002"]})
    mkdoc(base, 2, "adr", status="accepted")   # still active
    assert "COH-SG-001" in _sg(base)


def test_sg003_asymmetric_pair(tmp_path):
    base = str(tmp_path)
    mkdoc(base, 1, "adr", edges={"supersedes": ["ADR-002"]})
    mkdoc(base, 2, "adr", status="superseded")  # no superseded-by back-edge
    assert "COH-SG-003" in _sg(base)


def test_sg005_dangling_edge_target(tmp_path):
    base = str(tmp_path)
    mkdoc(base, 1, "adr", edges={"depends-on": ["ADR-777"]})
    assert "COH-SG-005" in _sg(base)


def test_sg004_supersede_cycle(tmp_path):
    base = str(tmp_path)
    mkdoc(base, 1, "adr", status="superseded",
          edges={"supersedes": ["ADR-002"], "superseded-by": ["ADR-002"]})
    mkdoc(base, 2, "adr", status="superseded",
          edges={"supersedes": ["ADR-001"], "superseded-by": ["ADR-001"]})
    assert "COH-SG-004" in _sg(base)


def test_sg006_amends_and_supersedes_same_pair(tmp_path):
    base = str(tmp_path)
    mkdoc(base, 1, "adr", edges={"supersedes": ["ADR-002"], "amends": ["ADR-002"]})
    mkdoc(base, 2, "adr", status="superseded", edges={"superseded-by": ["ADR-001"]})
    assert "COH-SG-006" in _sg(base)


def test_sg007_active_depends_on_retired(tmp_path):
    base = str(tmp_path)
    mkdoc(base, 1, "adr", status="accepted", edges={"depends-on": ["ADR-002"]})
    mkdoc(base, 2, "adr", status="superseded", edges={"superseded-by": ["ADR-003"]})
    mkdoc(base, 3, "adr", edges={"supersedes": ["ADR-002"]})
    assert "COH-SG-007" in _sg(base)


def test_clean_supersession_no_sg(tmp_path):
    base = str(tmp_path)
    mkdoc(base, 1, "adr", edges={"supersedes": ["ADR-002"]})
    mkdoc(base, 2, "adr", status="superseded", edges={"superseded-by": ["ADR-001"]})
    assert _sg(base) == set()
