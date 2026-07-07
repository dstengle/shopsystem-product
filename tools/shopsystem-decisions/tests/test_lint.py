"""Step 1: one fixture per COH-LN-* lint check + a clean-corpus pass."""

import os
import pytest

from shopsystem_decisions import parser
from shopsystem_decisions.corpus import load_corpus, load_document
from shopsystem_decisions.schema import lint_document
from conftest import mkdoc, valid_fm, write_raw, DEFAULT_BODY


def _lint_one(base, path):
    res = load_corpus(["adr", "pdr", "briefs"], base)
    ids = {}
    for d in res.docs:
        ids.setdefault(d.id, d.path)
    doc = load_document(path, base)
    return {f.check_id for f in lint_document(doc, ids)}


def _write(base, kind, num, fm, body=DEFAULT_BODY):
    return write_raw(base, kind, num, parser.render_document(fm, body))


def test_clean_corpus_no_lint(repo):
    res = load_corpus(["adr", "pdr", "briefs"], repo)
    ids = {}
    for d in res.docs:
        ids.setdefault(d.id, d.path)
    all_findings = []
    for d in res.docs:
        all_findings += lint_document(d, ids)
    assert all_findings == []


def test_ln001_off_enum_status(tmp_path):
    base = str(tmp_path)
    fm = valid_fm(1, status="Accepted")
    p = _write(base, "adr", 1, fm)
    assert "COH-LN-001" in _lint_one(base, p)


def test_ln002_id_filename_mismatch(tmp_path):
    base = str(tmp_path)
    fm = valid_fm(1)
    fm["id"] = "ADR-999"
    p = _write(base, "adr", 1, fm)
    assert "COH-LN-002" in _lint_one(base, p)


def test_ln002_kind_directory_mismatch(tmp_path):
    base = str(tmp_path)
    fm = valid_fm(1, kind="pdr")   # kind pdr but placed under adr/
    p = write_raw(base, "adr", 1, parser.render_document(fm, DEFAULT_BODY))
    assert "COH-LN-002" in _lint_one(base, p)


def test_ln003_duplicate_id(tmp_path):
    base = str(tmp_path)
    mkdoc(base, 1, "adr")
    fm = valid_fm(2)
    fm["id"] = "ADR-001"           # duplicate of doc 1
    p = _write(base, "adr", 2, fm)
    assert "COH-LN-003" in _lint_one(base, p)


def test_ln004_description_too_long(tmp_path):
    base = str(tmp_path)
    fm = valid_fm(1, description="x" * 200)
    p = _write(base, "adr", 1, fm)
    assert "COH-LN-004" in _lint_one(base, p)


def test_ln005_bad_edge_and_cli_allowlist(tmp_path):
    base = str(tmp_path)
    fm = valid_fm(1, edges={"supersedes": ["not-an-id"]},
                  invariants=[{"id": "x", "statement": "s",
                               "predicate": {"kind": "cli", "cmd": ["rm", "-rf"]},
                               "hash": "0000000000000000"}])
    p = _write(base, "adr", 1, fm)
    assert "COH-LN-005" in _lint_one(base, p)


def test_ln006_forbidden_decision_key(tmp_path):
    base = str(tmp_path)
    # the canonical emitter drops unknown keys, so hand-write the raw doc with a
    # forbidden `decision:` field to prove the lint catches it.
    raw = ("---\n"
           "id: ADR-001\n"
           "kind: adr\n"
           "title: T\n"
           "status: accepted\n"
           'date: "2026-07-01"\n'
           "description: d\n"
           "decision: we chose X\n"
           "---\n" + DEFAULT_BODY)
    p = write_raw(base, "adr", 1, raw)
    assert "COH-LN-006" in _lint_one(base, p)


def test_ln007_tier_disclosure_level(tmp_path):
    base = str(tmp_path)
    fm = valid_fm(1, tier="l1")
    p = _write(base, "adr", 1, fm)
    assert "COH-LN-007" in _lint_one(base, p)


def test_ln008_governed_delta_retire_without_retires(tmp_path):
    base = str(tmp_path)
    fm = valid_fm(1, invariants=[{
        "id": "x", "statement": "s",
        "predicate": {"kind": "governed-delta", "claim": "retire",
                      "features": ["features/x.feature"]},
        "hash": "0000000000000000"}])
    p = _write(base, "adr", 1, fm)
    assert "COH-LN-008" in _lint_one(base, p)


def test_ln009_missing_decision_heading(tmp_path):
    base = str(tmp_path)
    fm = valid_fm(1)
    p = _write(base, "adr", 1, fm, body="## Context\n\nNo decision heading here.\n")
    assert "COH-LN-009" in _lint_one(base, p)
