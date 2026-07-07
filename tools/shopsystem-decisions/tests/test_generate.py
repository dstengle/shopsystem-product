"""Step 2: generator artifacts, idempotence, prune, determinism, drift gate."""

import os
import shutil
import pytest

from shopsystem_decisions import generate
from conftest import mkdoc


def test_build_writes_artifacts(repo):
    res = generate.build(["adr", "pdr", "briefs"], repo)
    assert any(p.endswith("llms.txt") for p in res["written"])
    for rel in ("decision-refs/llms.txt", "decision-refs/index.json",
                "decision-refs/DECISIONS.md", "decision-refs/manifest.lock",
                "decision-refs/l0/ADR-001.md", "decision-refs/l1/ADR-001.md"):
        assert os.path.exists(os.path.join(repo, rel)), rel


def test_double_build_is_idempotent(repo):
    generate.build(["adr", "pdr", "briefs"], repo)
    second = generate.build(["adr", "pdr", "briefs"], repo)
    assert second["written"] == [] and second["pruned"] == []


def test_check_mode_detects_drift(repo):
    generate.build(["adr", "pdr", "briefs"], repo)
    clean = generate.build(["adr", "pdr", "briefs"], repo, check=True)
    assert clean["drift"] == []
    # hand-edit a projection -> drift
    p = os.path.join(repo, "decision-refs/llms.txt")
    with open(p, "a") as fh:
        fh.write("\nhand edit\n")
    drift = generate.build(["adr", "pdr", "briefs"], repo, check=True)
    assert any("llms.txt" in d for d in drift["drift"])


def test_prune_removes_orphans(repo):
    generate.build(["adr", "pdr", "briefs"], repo)
    # delete a source; its projection must be pruned
    os.remove(os.path.join(repo, "adr", "002-decision-2.md"))
    res = generate.build(["adr", "pdr", "briefs"], repo)
    assert any("ADR-002" in p for p in res["pruned"])
    assert not os.path.exists(os.path.join(repo, "decision-refs/l0/ADR-002.md"))


def test_determinism_across_location(tmp_path):
    # two independent copies of the same corpus -> identical manifest bytes
    a = str(tmp_path / "a")
    b = str(tmp_path / "deep" / "nested" / "b")
    for base in (a, b):
        os.makedirs(base, exist_ok=True)
        mkdoc(base, 1, "adr")
        mkdoc(base, 5, "pdr")
        generate.build(["adr", "pdr", "briefs"], base)
    ma = open(os.path.join(a, "decision-refs/manifest.lock")).read()
    mb = open(os.path.join(b, "decision-refs/manifest.lock")).read()
    assert ma == mb


def test_manifest_has_no_ambient_state(repo):
    generate.build(["adr", "pdr", "briefs"], repo)
    text = open(os.path.join(repo, "decision-refs/manifest.lock")).read()
    assert repo not in text  # no absolute paths leak in


def test_lint_failure_blocks_build(tmp_path):
    base = str(tmp_path)
    from conftest import valid_fm, write_raw
    from shopsystem_decisions import parser
    fm = valid_fm(1, status="Accepted")  # off-enum
    write_raw(base, "adr", 1, parser.render_document(fm, "## Decision\n\nx\n"))
    with pytest.raises(generate.BuildError):
        generate.build(["adr", "pdr", "briefs"], base)
