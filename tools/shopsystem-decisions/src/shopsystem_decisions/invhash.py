"""Invariant claim hashing (§1.4), mirroring ``scenarios hash`` / ADR-019.

The identity of an invariant covers the *claim* — its id, its statement (with
whitespace collapsed and NFC-normalized), and its predicate (canonical JSON) —
never the volatile verification state (``status``, ``verified_at``). Rewording a
claim or moving its oracle changes the hash (caught by ``COH-CI-007``);
re-verifying does not.
"""

from __future__ import annotations

import hashlib
import json
import unicodedata


def invariant_hash(inv: dict) -> str:
    """Return the 16-hex canonical hash of one invariant object."""
    statement = unicodedata.normalize("NFC", str(inv.get("statement", "")))
    canon = "\n".join([
        "id:" + str(inv.get("id", "")).strip(),
        "claim:" + " ".join(statement.split()),
        "predicate:" + json.dumps(
            inv.get("predicate", {}), sort_keys=True, separators=(",", ":")
        ),
    ])
    return hashlib.sha256(canon.encode("utf-8")).hexdigest()[:16]
