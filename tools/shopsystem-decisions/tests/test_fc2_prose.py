"""FC2 — pending / stale forward-looking prose (COH-SP-*)."""

import os
import pytest

from shopsystem_decisions.corpus import build_graph, load_corpus
from shopsystem_decisions.gate import run_gate
from conftest import mkdoc


def _sp(base):
    res = load_corpus(["adr", "pdr", "briefs"], base)
    graph = build_graph(res.docs)
    return {f.check_id for f in run_gate(res.docs, graph, base, ["sp"], {})}


def test_sp001_untagged_forward_looking_prose(tmp_path):
    base = str(tmp_path)
    body = ("## Decision\n\nThe inter-component dependency view is "
            "NOT YET BUILT; it will land later.\n")
    mkdoc(base, 47, "adr", body=body)
    assert "COH-SP-001" in _sp(base)


def test_sp001_suppressed_when_pending_tagged(tmp_path):
    base = str(tmp_path)
    body = ("## Decision\n\nThe dependency view is NOT YET BUILT.\n")
    mkdoc(base, 47, "adr", body=body, pending=[{
        "marker": "dependency view",
        "predicate": {"kind": "file-exists", "path": "does/not/exist.md"},
    }])
    assert "COH-SP-001" not in _sp(base)


def test_sp002_pending_predicate_landed_blocks(tmp_path):
    base = str(tmp_path)
    # the awaited file now exists -> the 'not yet' prose is stale
    os.makedirs(os.path.join(base, "built"), exist_ok=True)
    open(os.path.join(base, "built", "view.md"), "w").write("done\n")
    body = "## Decision\n\nThe dependency view is NOT YET BUILT.\n"
    mkdoc(base, 47, "adr", body=body, pending=[{
        "marker": "dependency view",
        "predicate": {"kind": "file-exists", "path": "built/view.md"},
    }])
    assert "COH-SP-002" in _sp(base)


def test_sp003_marker_no_longer_in_body(tmp_path):
    base = str(tmp_path)
    body = "## Decision\n\nEverything is fully built now.\n"
    mkdoc(base, 47, "adr", body=body, pending=[{
        "marker": "dependency view NOT YET BUILT",
        "predicate": {"kind": "file-exists", "path": "nope.md"},
    }])
    assert "COH-SP-003" in _sp(base)
