"""FC1 — claimed-invariant vs actual delta (COH-CI-*), baseline lock round-trip.

Uses the real installed ``scenarios`` CLI as the oracle over a fixture feature:
baseline stamps the governed hash-set; mutating the feature makes the check fire
with the exact delta.
"""

import os
import yaml
import pytest

from shopsystem_decisions.corpus import build_graph, load_corpus, load_document
from shopsystem_decisions.gate import (REFS_DIR, LOCK_NAME, load_lock, run_gate,
                                       stamp_baseline)
from shopsystem_decisions.invhash import invariant_hash
from conftest import mkdoc, write_feature

FEAT = "features/msg/send.feature"


def _adr_with_governed_delta(base, claim="parity", retires=None):
    inv = {
        "id": "send-vehicle-parity",
        "statement": "shop-msg send request_scenario_register pins exactly one scenario.",
        "predicate": {"kind": "governed-delta", "claim": claim,
                      "features": [FEAT],
                      "surface": "cli:shop-msg send request_scenario_register"},
        "hash": "0000000000000000",
    }
    if retires is not None:
        inv["predicate"]["retires"] = retires
    inv["hash"] = invariant_hash(inv)
    return mkdoc(base, 60, "adr", status="accepted", invariants=[inv])


def _baseline(base, doc_id):
    doc = load_document(_find(base, doc_id), base)
    entry = stamp_baseline(doc, base, "e57aba1")
    lock = load_lock(base)
    lock[doc_id] = entry
    p = os.path.join(base, REFS_DIR, LOCK_NAME)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, "w") as fh:
        yaml.safe_dump(lock, fh, sort_keys=True)


def _find(base, doc_id):
    import glob
    num = int(doc_id.split("-")[1])
    return glob.glob(os.path.join(base, "adr", f"{num:03d}-*.md"))[0]


def _ci(base, decision=None):
    res = load_corpus(["adr", "pdr", "briefs"], base)
    graph = build_graph(res.docs)
    lock = load_lock(base)
    return run_gate(res.docs, graph, base, ["ci"], lock, decision_filter=decision)


def test_parity_clean_then_delta_fires(tmp_path):
    base = str(tmp_path)
    write_feature(base, FEAT, [
        ("aaaa000011112222", "register pins one scenario",
         "Given a request\nWhen shop-msg send request_scenario_register --bc runs\nThen exactly one deposit is written"),
    ])
    _adr_with_governed_delta(base, "parity")
    _baseline(base, "ADR-060")

    # clean: no CI-001
    ids = {f.check_id for f in _ci(base)}
    assert "COH-CI-001" not in ids

    # mutate the governed feature: add a pin + a new flag -> parity delta
    with open(os.path.join(base, FEAT), "a") as fh:
        fh.write("\n  @scenario_hash:da255854d5d933f5\n"
                 "  Scenario: register now also takes --hash\n"
                 "    Given a request\n"
                 "    When shop-msg send request_scenario_register --hash runs\n"
                 "    Then exactly one deposit is written\n")
    findings = _ci(base)
    ci = [f for f in findings if f.check_id == "COH-CI-001"]
    assert ci, "CI-001 should fire after the governed feature grew a pin"
    # the exact delta is surfaced
    assert "da255854d5d933f5" in ci[0].actual["added"]
    assert "--hash" in ci[0].actual["surface_tokens"]["flags"]


def test_additive_declared_removal_ok_but_undeclared_fires(tmp_path):
    base = str(tmp_path)
    write_feature(base, FEAT, [
        ("aaaa000011112222", "one", "Given x\nThen y"),
        ("bbbb000011112222", "two", "Given x\nThen y"),
    ])
    # additive claim retiring bbbb...
    _adr_with_governed_delta(base, "additive", retires=["bbbb000011112222"])
    _baseline(base, "ADR-060")
    # remove bbbb (declared in retires) -> additive tolerates it
    write_feature(base, FEAT, [("aaaa000011112222", "one", "Given x\nThen y")])
    assert "COH-CI-002" not in {f.check_id for f in _ci(base)}
    # now remove aaaa too (undeclared) -> CI-002
    write_feature(base, FEAT, [("cccc000011112222", "three", "Given x\nThen y")])
    assert "COH-CI-002" in {f.check_id for f in _ci(base)}


def test_ci007_reworded_claim_without_rehash(tmp_path):
    base = str(tmp_path)
    write_feature(base, FEAT, [("aaaa000011112222", "one", "Given x\nThen y")])
    path = _adr_with_governed_delta(base, "parity")
    # corrupt the stored hash to simulate reword-without-rehash
    doc = load_document(path, base)
    doc.fm["invariants"][0]["hash"] = "ffffffffffffffff"
    from shopsystem_decisions import parser
    open(path, "w").write(parser.render_document(doc.fm, doc.body + "\n"))
    assert "COH-CI-007" in {f.check_id for f in _ci(base)}


def test_ci005_missing_lock_entry(tmp_path):
    base = str(tmp_path)
    write_feature(base, FEAT, [("aaaa000011112222", "one", "Given x\nThen y")])
    _adr_with_governed_delta(base, "parity")
    # no baseline stamped -> CI-005 advisory
    assert "COH-CI-005" in {f.check_id for f in _ci(base)}
