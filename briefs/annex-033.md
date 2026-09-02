---
type: annex
id: annex-033
brief: brief-033
date: 2026-09-02
---

# Annex 033: source material for brief 033

## The chain (all six links, status draft pending ask 1)

- Typedef: [basis/artifacts/adr.md](../basis/artifacts/adr.md)
- Fitness set: [basis/fitness/adr.fitness.md](../basis/fitness/adr.fitness.md)
- Guideline: [basis/guidelines/adr.md](../basis/guidelines/adr.md)
- Authoring process: [basis/processes/adr-authoring.md](../basis/processes/adr-authoring.md)
- Rendered skill: [.claude/skills/adr-authoring/SKILL.md](../.claude/skills/adr-authoring/SKILL.md)
  (generated, digest-stamped)
- Glossary term: [basis/glossary.md](../basis/glossary.md) v20 —
  *architecture decision record (adr)*

Derived chain (`lint_basis.py --derive-chain adr`): typedef
`adr-typedef`, guideline `adr-guideline`, fitness `adr-fitness`,
process `adr-authoring-process`, roles cold-reviewer / lead-pm /
lead-solutions-architect, skill `adr-authoring-skill`; status `draft`
(flips to `approved` when every link is stamped). Lint: PASS, 0
violations.

## The exemplar

[decisions/adr-2026-09-02-cel-condition-language.md](../decisions/adr-2026-09-02-cel-condition-language.md)
— authored through the drafted adr-authoring process; owner-directed
deviation from the process's median-keeper instruction: a local
decision was recorded instead of a `main` keeper, per the ruling that
nothing is pulled from `main` before the chain stands.

Screen (round 1): verdict **clean**; judge stamp claude-fable-5 /
adr-screen prompt v1; all six fitness criteria plus the `principles`
criterion passed, every finding-check decided confident. The judge
separately weighed the record's retroactive authoring against
`bidirectional-conformance` and cleared it: the choice stood in the
approved process-definition typedef — design, not silent drift; only
the reasons were unrecorded.

## Friction log (chain points the exemplar surfaced)

1. **Instance home undecided** — neither decision-record typedef
   names where instances live; `decisions/` is convention (brief ask
   4).
2. **`derive_chain` skill path stale** — `basis/tools/lint_basis.py`
   still read `basis/skills/`, retired by skill-rendering's first
   run; repaired to `.claude/skills/` this run (informational in the
   brief).
3. **Draft-sourced rendering at the load point** — the adr-authoring
   skill is generated from a draft definition until approval; the
   skill-rendering consistency check would flag it. Window closes at
   approval + next check (informational in the brief).
4. **Principles-screen placement** — the typedef requires the
   statement but names no section; the exemplar carries it at the end
   of Context. Acceptable as a guideline matter; no ask.
5. **ADR/PDR boundary** — assigned to this review by the migration
   plan (brief ask 3).

## Autopsy notes (source for the typedef's rules)

Keepers on `main`: 69 adrs. Best-formed: adr-006 (registry design),
adr-027 (respond-direction ruling) — tight evidenced context,
options inline, provenance edges. Worst: adr-066 — paragraph-length
title, numbered sub-decisions, broken `authors` frontmatter;
adr-058 — 1,521 lines. These sourced the one-decision rule, the
one-line-title rule, and the derives-from-kept /
derived-by-dropped ruling.

## Scope of this run

Per owner direction: build-chain → derive → exemplar → review →
approve only. The rewrite-keepers step (87 keep-rewrite decision
records, lane A) and queue-demoted (21 retire) are deferred to
demand-pull migration; the migration gate — ADR definitions before
imports from `main` — is what this run closes.
