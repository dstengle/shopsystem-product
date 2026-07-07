"""FC3 — reference / doc<->reality drift resolution (COH-DR-*)."""

import pytest

from shopsystem_decisions.corpus import build_graph, load_corpus
from shopsystem_decisions.gate import run_gate
from conftest import mkdoc, write_feature


def _dr(base):
    res = load_corpus(["adr", "pdr", "briefs"], base)
    graph = build_graph(res.docs)
    return {f.check_id for f in run_gate(res.docs, graph, base, ["dr"], {})}


def test_dr001_dangling_relative_link(tmp_path):
    base = str(tmp_path)
    body = ("## Decision\n\nSee [the template]"
            "(../features/templates/missing.gherkin) for details.\n")
    mkdoc(base, 25, "adr", body=body)
    assert "COH-DR-001" in _dr(base)


def test_dr002_unresolvable_hash(tmp_path):
    base = str(tmp_path)
    body = "## Decision\n\nWe pin scenario deadbeefcafe0001 forever.\n"
    mkdoc(base, 10, "adr", body=body)
    assert "COH-DR-002" in _dr(base)


def test_dr002_ok_when_hash_in_feature(tmp_path):
    base = str(tmp_path)
    write_feature(base, "features/x/a.feature",
                  [("deadbeefcafe0001", "s", "Given x\nThen y")])
    body = "## Decision\n\nWe pin scenario deadbeefcafe0001 forever.\n"
    mkdoc(base, 10, "adr", body=body)
    assert "COH-DR-002" not in _dr(base)


def test_dr004_feature_origin_without_decision(tmp_path):
    base = str(tmp_path)
    mkdoc(base, 1, "adr")
    # feature cites @origin:adr-999 which has no doc
    import os
    p = os.path.join(base, "features/y/o.feature")
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, "w").write("@origin:adr-999\nFeature: f\n\n  Scenario: s\n    Then x\n")
    assert "COH-DR-004" in _dr(base)


def test_retired_docs_exempt_from_dr(tmp_path):
    base = str(tmp_path)
    body = "## Decision\n\nDangling [x](../nope/none.md) and hash deadbeefcafe9999.\n"
    mkdoc(base, 30, "adr", status="superseded",
          edges={"superseded-by": ["ADR-031"]}, body=body)
    mkdoc(base, 31, "adr", edges={"supersedes": ["ADR-030"]})
    ids = _dr(base)
    assert "COH-DR-001" not in ids and "COH-DR-002" not in ids
