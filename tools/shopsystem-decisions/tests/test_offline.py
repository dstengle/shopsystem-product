"""Proves the schema/generator/hash core is network- and model-free: with the
socket layer disabled, parse -> lint -> build -> hash all still succeed."""

import socket
import pytest

from conftest import mkdoc


@pytest.fixture
def no_network(monkeypatch):
    def _blocked(*a, **k):
        raise OSError("network disabled for this test")
    monkeypatch.setattr(socket, "socket", _blocked)
    monkeypatch.setattr(socket, "create_connection", _blocked)


def test_core_pipeline_offline(no_network, tmp_path):
    from shopsystem_decisions import generate
    from shopsystem_decisions.invhash import invariant_hash
    from shopsystem_decisions.corpus import load_corpus
    from shopsystem_decisions.schema import lint_document

    base = str(tmp_path)
    mkdoc(base, 1, "adr")
    mkdoc(base, 2, "adr")

    res = load_corpus(["adr", "pdr", "briefs"], base)
    ids = {d.id: d.path for d in res.docs}
    assert all(not lint_document(d, ids) for d in res.docs)

    result = generate.build(["adr", "pdr", "briefs"], base)
    assert any("index.json" in p for p in result["written"])

    h = invariant_hash({"id": "x", "statement": "s",
                        "predicate": {"kind": "path-absent", "path": "repos/"}})
    assert len(h) == 16
