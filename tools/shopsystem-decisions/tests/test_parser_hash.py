"""Step 1 unit tests: canonical emitter byte-stability + invariant hash vectors."""

from shopsystem_decisions import parser
from shopsystem_decisions.invhash import invariant_hash


def test_emitter_golden_bytes():
    fm = {
        "id": "ADR-050", "kind": "adr", "title": "Fabro parity",
        "status": "accepted", "date": "2026-07-01", "description": "Pins P1-P20.",
        "authors": ["dstengle"], "tier": "system-global",
        "tags": ["fabro", "parity"], "beads": ["lead-6k1r"],
        "edges": {"supersedes": ["ADR-048", "ADR-002"], "pins": ["PDR-011"]},
    }
    out = parser.emit_frontmatter(fm)
    expected = (
        "id: ADR-050\n"
        "kind: adr\n"
        "title: Fabro parity\n"
        "status: accepted\n"
        'date: "2026-07-01"\n'
        "description: Pins P1-P20.\n"
        "authors: [dstengle]\n"
        "tier: system-global\n"
        "tags: [fabro, parity]\n"
        "beads: [lead-6k1r]\n"
        "edges:\n"
        "  supersedes: [ADR-002, ADR-048]\n"   # sorted by codepoint
        "  superseded-by: []\n"
        "  amends: []\n"
        "  depends-on: []\n"
        "  anchored-on: []\n"
        "  pins: [PDR-011]\n"
        "  related: []\n"
    )
    assert out == expected


def test_dates_always_quoted():
    fm = {"id": "ADR-001", "kind": "adr", "title": "T", "status": "draft",
          "date": "2026-01-02", "description": "d"}
    assert 'date: "2026-01-02"' in parser.emit_frontmatter(fm)


def test_render_roundtrip_preserves_body():
    fm = {"id": "ADR-001", "kind": "adr", "title": "T", "status": "draft",
          "date": "2026-01-02", "description": "d"}
    body = "## Decision\n\nBody with trailing spaces kept? no.\n"
    doc = parser.render_document(fm, body)
    parsed, back = parser.split_frontmatter(doc)
    assert parsed["id"] == "ADR-001"
    assert "## Decision" in back
    assert doc.endswith("\n") and not doc.endswith("\n\n")


def test_emitter_idempotent():
    fm = {"id": "ADR-001", "kind": "adr", "title": "T", "status": "draft",
          "date": "2026-01-02", "description": "d",
          "edges": {"supersedes": ["ADR-003", "ADR-002"]}}
    once = parser.render_document(fm, "b\n")
    p, b = parser.split_frontmatter(once)
    twice = parser.render_document(p, b)
    assert once == twice


def test_invariant_hash_vector():
    inv = {"id": "launch-parity",
           "statement": "Every  P1-P20   property KEPT retains behavior.",
           "predicate": {"kind": "path-absent", "path": "repos/"}}
    h = invariant_hash(inv)
    assert len(h) == 16 and all(c in "0123456789abcdef" for c in h)
    # whitespace-collapse + volatile-exclusion: reword whitespace / add status -> same hash
    inv2 = dict(inv, status="holds", verified_at="2026-07-06T00:00:00Z",
                statement="Every P1-P20 property KEPT retains behavior.")
    assert invariant_hash(inv2) == h
    # moving the oracle changes the hash
    inv3 = dict(inv, predicate={"kind": "path-present", "path": "repos/"})
    assert invariant_hash(inv3) != h
