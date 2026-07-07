"""Shared fixtures: a factory for valid decision docs and feature files, and a
minimal on-disk corpus under a temp dir."""

import os
import pytest

from shopsystem_decisions import parser

KIND_DIR = {"adr": "adr", "pdr": "pdr", "brief": "briefs"}
PREFIX = {"adr": "ADR", "pdr": "PDR", "brief": "BRIEF"}

DEFAULT_BODY = "## Context\n\nSome rationale.\n\n## Decision\n\nWe decide to do X.\n"


def valid_fm(num=1, kind="adr", **kw):
    fm = {
        "id": f"{PREFIX[kind]}-{num:03d}",
        "kind": kind,
        "title": f"Decision {num}",
        "status": "accepted",
        "date": "2026-07-01",
        "description": f"L0 triage line for decision {num}",
        "edges": {},
    }
    fm.update(kw)
    return fm


def mkdoc(base, num=1, kind="adr", body=None, **kw):
    fm = valid_fm(num, kind, **kw)
    d = os.path.join(base, KIND_DIR[kind])
    os.makedirs(d, exist_ok=True)
    path = os.path.join(d, f"{num:03d}-decision-{num}.md")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(parser.render_document(fm, body if body is not None else DEFAULT_BODY))
    return path


def write_raw(base, kind, num, text):
    d = os.path.join(base, KIND_DIR[kind])
    os.makedirs(d, exist_ok=True)
    path = os.path.join(d, f"{num:03d}-decision-{num}.md")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(text)
    return path


def write_feature(base, relpath, scenarios):
    """scenarios: list of (hash16, title, steps_text)."""
    path = os.path.join(base, relpath)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    lines = ["Feature: generated fixture", ""]
    for h, title, steps in scenarios:
        lines.append(f"  @scenario_hash:{h}")
        lines.append(f"  Scenario: {title}")
        for s in steps.split("\n"):
            lines.append(f"    {s}")
        lines.append("")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write("\n".join(lines))
    return path


@pytest.fixture
def repo(tmp_path):
    """A minimal valid corpus: two active ADRs, one active PDR."""
    base = str(tmp_path)
    mkdoc(base, 1, "adr")
    mkdoc(base, 2, "adr")
    mkdoc(base, 1, "pdr")
    return base
