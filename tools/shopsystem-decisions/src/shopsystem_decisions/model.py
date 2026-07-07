"""Shared data model: Finding severities, the Finding record, and the parsed
Document container. Kept dependency-free so every other module can import it.

A *Finding* is the atom of both the lint pass and the coherence gate. It carries
a stable ``check_id`` (e.g. ``COH-SG-001``), a severity, the offending file (and
optional 1-indexed line), a one-line human summary, and a doctor-style
``remediation`` line (PDR-024 format). Findings render either as a doctor block
(:func:`Finding.render`) or as a JSON object (:func:`Finding.as_dict`).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any, Optional

# Severity ladder.  BLOCKING findings drive a nonzero exit; ADVISORY findings are
# WARN-level unless --strict promotes them.  LINT is always blocking (exit 2).
SEV_BLOCKING = "blocking"
SEV_ADVISORY = "advisory"
SEV_LINT = "lint"


@dataclass
class Finding:
    """One coherence/lint finding.

    Attributes:
        check_id: stable identifier, e.g. ``COH-CI-001``.
        severity: one of the ``SEV_*`` constants.
        file: repo-relative (or given) path to the offending document.
        summary: single-line description of what fired.
        remediation: doctor-style "how to fix" line.
        line: optional 1-indexed line the finding anchors to.
        detail: optional list of extra indented lines (e.g. baseline/actual).
        invariant: optional invariant id for FC1 findings.
        baseline: optional machine baseline blob (for --json).
        actual: optional machine actual blob (for --json).
    """

    check_id: str
    severity: str
    file: str
    summary: str
    remediation: str
    line: Optional[int] = None
    detail: list[str] = field(default_factory=list)
    invariant: Optional[str] = None
    baseline: Any = None
    actual: Any = None

    def is_blocking(self, strict: bool = False) -> bool:
        """Whether this finding should drive a nonzero exit under the mode."""
        if self.severity == SEV_LINT:
            return True
        if self.severity == SEV_BLOCKING:
            return True
        if self.severity == SEV_ADVISORY and strict:
            return True
        return False

    def _tag(self, strict: bool = False) -> str:
        if self.severity == SEV_LINT:
            return "FAIL"
        if self.severity == SEV_BLOCKING:
            return "FAIL"
        return "FAIL" if strict else "WARN"

    def render(self, strict: bool = False) -> str:
        """Doctor-style multi-line block (PDR-024)."""
        loc = self.file if self.line is None else f"{self.file}:{self.line}"
        head = f"[{self._tag(strict)}] {self.check_id}  {loc}"
        parts = [head, f"       {self.summary}"]
        for d in self.detail:
            parts.append(f"       {d}")
        parts.append(f"       remediation: {self.remediation}")
        return "\n".join(parts)

    def as_dict(self, strict: bool = False) -> dict:
        """Machine form consumed by ``--json`` and by reconciliation bead filing."""
        return {
            "check_id": self.check_id,
            "severity": "blocking" if self.is_blocking(strict) else "advisory",
            "file": self.file,
            "line": self.line,
            "invariant": self.invariant,
            "summary": self.summary,
            "baseline": self.baseline,
            "actual": self.actual,
            "remediation": self.remediation,
        }


@dataclass
class Document:
    """A parsed decision document: canonical frontmatter dict + verbatim body."""

    path: str            # path as given (used in findings)
    relpath: str         # repo-relative path (used in artifacts)
    kind: str            # adr | pdr | brief (from directory / frontmatter)
    fm: dict             # parsed frontmatter mapping
    body: str            # markdown body below the closing fence
    raw: str             # full original file text

    @property
    def id(self) -> str:
        return str(self.fm.get("id", ""))

    @property
    def status(self) -> str:
        return str(self.fm.get("status", ""))

    def edges(self, relation: str) -> list[str]:
        e = self.fm.get("edges") or {}
        return list(e.get(relation) or [])
