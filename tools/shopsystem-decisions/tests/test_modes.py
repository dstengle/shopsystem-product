"""Step 3: authoring/distribution mode matrix + exit-code contract (R8/R10)."""

import io
import pytest

from shopsystem_decisions import cli
from conftest import mkdoc


def _corpus_with_blocking(base):
    # SG-001: active doc supersedes a still-active target -> a B-row finding
    mkdoc(base, 1, "adr", edges={"supersedes": ["ADR-002"]})
    mkdoc(base, 2, "adr", status="accepted")


def test_authoring_warns_distribution_blocks(tmp_path):
    base = str(tmp_path)
    _corpus_with_blocking(base)
    assert cli.main(["--base", base, "check", "adr", "--mode", "authoring"]) == 0
    assert cli.main(["--base", base, "check", "adr", "--mode", "distribution"]) == 1


def test_strict_promotes_authoring_warn_to_block(tmp_path):
    base = str(tmp_path)
    _corpus_with_blocking(base)
    assert cli.main(["--base", base, "check", "adr", "--mode", "authoring", "--strict"]) == 1


def test_lint_failure_is_exit_2_in_both_modes(tmp_path):
    base = str(tmp_path)
    from conftest import valid_fm, write_raw
    from shopsystem_decisions import parser
    write_raw(base, "adr", 1, parser.render_document(
        valid_fm(1, status="Accepted"), "## Decision\n\nx\n"))
    assert cli.main(["--base", base, "check", "adr", "--lint"]) == 2
    assert cli.main(["--base", base, "check", "adr", "--mode", "distribution"]) == 2


def test_clean_corpus_exits_zero(tmp_path):
    base = str(tmp_path)
    mkdoc(base, 1, "adr", invariants=[])
    # accepted with empty invariants -> only CI-000 advisory -> exit 0 in authoring
    assert cli.main(["--base", base, "check", "adr", "--mode", "authoring"]) == 0


def test_aggregate_summary_and_exit(tmp_path, capsys):
    base = str(tmp_path)
    _corpus_with_blocking(base)
    code = cli.main(["--base", base, "check", "adr",
                     "--mode", "distribution", "--aggregate"])
    out = capsys.readouterr().out
    assert code == 1
    assert "DECISION_COHERENCE:" in out and "exit 1" in out
