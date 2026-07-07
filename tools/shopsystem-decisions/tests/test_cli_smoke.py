"""Step 4: end-to-end CLI smoke — new -> build -> show -> supersede clears SG."""

import io
import os
import pytest

from shopsystem_decisions import cli


def test_hash_from_stdin(capsys, monkeypatch):
    inv = ("id: x\n"
           "statement: a claim\n"
           "predicate: {kind: path-absent, path: repos/}\n")
    monkeypatch.setattr("sys.stdin", io.StringIO(inv))
    assert cli.main(["hash"]) == 0
    out = capsys.readouterr().out.strip()
    assert len(out) == 16


def test_new_build_show_supersede_flow(tmp_path, capsys):
    base = str(tmp_path)
    assert cli.main(["--base", base, "new", "--kind", "adr", "--title", "First"]) == 0
    assert cli.main(["--base", base, "new", "--kind", "adr", "--title", "Second"]) == 0
    capsys.readouterr()

    # both draft docs; scaffold body has '## Decision' -> lint clean
    assert cli.main(["--base", base, "check", "adr", "--lint"]) == 0
    capsys.readouterr()

    # build produces artifacts
    assert cli.main(["--base", base, "build"]) == 0
    assert os.path.exists(os.path.join(base, "decision-refs/index.json"))
    capsys.readouterr()

    # show l2 streams the source file
    assert cli.main(["--base", base, "show", "ADR-001", "--level", "l2"]) == 0
    l2 = capsys.readouterr().out
    assert l2 == open(os.path.join(base, "adr", "001-first.md")).read()

    # show l0 is byte-identical to the built l0 card
    cli.main(["--base", base, "show", "ADR-001", "--level", "l0"])
    shown = capsys.readouterr().out
    built = open(os.path.join(base, "decision-refs/l0/ADR-001.md")).read()
    assert shown == built

    # supersede: ADR-002 by ADR-001, atomic both-edges + status flip
    assert cli.main(["--base", base, "supersede", "ADR-002", "--by", "ADR-001"]) == 0
    capsys.readouterr()
    assert cli.main(["--base", base, "check", "adr", "--class", "sg",
                     "--mode", "distribution"]) == 0


def test_status_guard_refuses_bad_transition(tmp_path):
    base = str(tmp_path)
    cli.main(["--base", base, "new", "--kind", "adr", "--title", "Solo"])
    # no incoming supersedes -> refuse superseded
    assert cli.main(["--base", base, "status", "ADR-001", "superseded"]) == 2


def test_graph_dot_output(tmp_path, capsys):
    base = str(tmp_path)
    cli.main(["--base", base, "new", "--kind", "adr", "--title", "A"])
    cli.main(["--base", base, "new", "--kind", "adr", "--title", "B",
              "--depends-on", "ADR-001"])
    capsys.readouterr()
    assert cli.main(["--base", base, "graph", "--format", "dot"]) == 0
    out = capsys.readouterr().out
    assert "digraph decisions" in out and "depends-on" in out
