# shopsystem-decisions — progressive-disclosure decision system

A single-source **frontmatter schema**, a **deterministic L0/L1 generator**, and
a runnable **coherence gate** (failure classes FC1–FC4) behind one `decisions`
CLI. Stdlib + PyYAML only; **network- and model-free by construction** (proven by
`tests/test_offline.py`). Mirrors the installed `scenarios` / `shop-msg` CLIs:
argparse verb-noun subcommands, stdin-or-file, exit codes `0`/`1`/`2`.

> The doctrine: every ADR / PDR / brief carries machine truth in YAML
> frontmatter; the human body is rationale. One home per fact (no summary↔full
> drift), one deterministic projection, one gate that refuses to let the docs
> silently diverge from reality.

## What each failure class means

| Class | Name | Detects | Checks |
|-------|------|---------|--------|
| **FC1** | claimed-invariant vs actual delta | a doc *claims* an invariant (e.g. "parity") but the governed scenarios/surface moved underneath it | `COH-CI-000..008` |
| **FC2** | stale forward-looking prose | "NOT YET BUILT / TBD / will ship" prose that is now false, or untagged | `COH-SP-001..003` |
| **FC3** | doc↔reality drift | dangling links, cited hashes that resolve to nothing, feature `@origin` with no decision | `COH-DR-001..005` |
| **FC4** | supersession-graph incoherence | supersedes an active doc, asymmetric edges, cycles, dangling edge targets | `COH-SG-001..009` |

Mechanical **lint** (`COH-LN-001..009`) is the schema-conformance floor and
blocks everywhere (exit 2).

## Install

```bash
pip install -e tools/shopsystem-decisions      # provides the `decisions` binary
```

## CLI

```
decisions new --kind {adr|pdr|brief} --title STR [--tier T] [--supersedes ID]... [--depends-on ID]...
decisions hash                                 # stdin: one invariant (YAML) -> 16-hex
decisions show <id> --level {l0|l1|l2}         # stream one projection; l2 = the source file
decisions list [DIR ...]                       # id<TAB>status<TAB>title, sorted by id
decisions build [--check]                      # generate decision-refs/ ; --check = drift gate
decisions check [DIR ...] [--lint] [--mode {authoring|distribution}]
                [--class {ln|ci|sg|dr|sp}] [--decision ID] [--strict] [--json] [--aggregate]
decisions supersede <old> --by <new>           # ATOMIC: both edges + status flip (only writer of superseded-by)
decisions status <id> <new-status>             # guarded transition (refuses SG-001/002 violations)
decisions graph [--format {dot|json}]          # typed-edge graph (stored + derived edges)
decisions baseline <id> [--rev SHA]            # stamp coherence-lock for governed-delta invariants (FC1)
decisions migrate [PATH ...] [--write] [--report FILE]   # corpus harvester (dry-run by default)
```

**Exit codes** (R10): `0` clean (or advisories only) · `1` blocking finding ·
`2` malformed input / usage / lint failure.

**Mode teeth** (R8): coherence-class *blocking* rows WARN in `--mode authoring`
(the PR surface) and BLOCK in `--mode distribution` (the digest pour /
reconciliation surface). `--strict` promotes advisories and authoring WARNs to
blocking. Lint always blocks.

## Frontmatter (schema)

Normative schema: [`schema/decision.schema.yaml`](schema/decision.schema.yaml);
enforced by `src/shopsystem_decisions/schema.py` (kept in lockstep). Machine
truth lives *only* in frontmatter; `decision:` as a key is **forbidden**
(`COH-LN-006`) — L1 is extracted from the body's `## Decision` section.

```yaml
---
id: ADR-050            # ^(ADR|PDR|BRIEF)-[0-9]{3,}$ ; number matches filename
kind: adr              # adr | pdr | brief ; matches directory
title: Fabro launch-interface parity with bc-container
status: accepted       # draft|proposed|accepted|amended|superseded|rejected|deprecated
date: "2026-07-01"     # quoted ISO date; first authored date only
description: >-        # net-new, human, <=180 chars, no newline — the L0 triage line
  Pins which P1-P20 launch properties fabro keeps vs replaces.
tier: system-global    # OPTIONAL ADR-035 governance tier only (a disclosure level here = COH-LN-007)
edges:                 # supersedes/superseded-by/amends/depends-on/anchored-on/pins/related
  supersedes: []
invariants:            # FC1 payload — each with a typed predicate + a 16-hex claim hash
  - id: launch-interface-parity
    statement: Every P1-P20 property marked KEPT retains bc-container behavior.
    predicate: {kind: property-table, file: adr/050-....md, section: KEPT, expect_hash: 0123456789abcdef}
    hash: a1b2c3d4e5f60718
    status: unverified
pending:               # FC2 payload — tagged forward-looking prose
  - marker: "dependency view NOT YET BUILT"
    predicate: {kind: bead-closed, bead: lead-h2p0}
---
```

### Predicate DSL (8 kinds, all evaluable on the lead artifact surface only — ADR-018-safe)

`scenario-hash` · `path-absent` · `path-present` · `manifest-field` ·
`property-table` · `edge` · `cli` (hard allowlist `{scenarios, shop-msg, bd, git,
test}`) · `governed-delta`. Pending predicates: `scenario-exists` ·
`decision-exists` · `bead-closed` · `file-exists` · `feature-has-tag`.

### Invariant claim hash (`decisions hash`)

Identity covers the **claim** (id + whitespace-collapsed statement + canonical
predicate JSON), never volatile verification state. Rewording without re-hashing
is caught by `COH-CI-007`; re-verifying does not change the hash.

## FC1 mechanism — baseline lock + pure set diff

`decisions baseline <id>` stamps `decision-refs/coherence-lock.yaml` at
acceptance time (governed scenario hashes via the installed `scenarios list`,
plus extracted surface tokens). At check time a `governed-delta` invariant is a
**pure set diff** of the live tree vs the lock — no NLP, no history re-inference:

```
parity           : added | removed | flag-delta | lifecycle-delta nonempty -> CI-001
additive         : (removed − retires) nonempty                            -> CI-002
retire | breaking: removed ⊄ retires, or a retired hash still present      -> CI-003
```

Baseline and check call the *same* extraction function, so the check just
compares two outputs of one deterministic function.

## Generated tree (`decisions build`)

```
decision-refs/
  l0/<id>.md        per-doc L0 card (id, kind, title, status, description, tags, path)
  l1/<id>.md        per-doc L1 extract (edges_out + derived edges_in + invariants + ## Decision body)
  llms.txt          llms.txt-style L0 corpus index
  index.json        machine form of the L0 cards + edges
  DECISIONS.md      L1 digest, ACTIVE partition only (the pour artifact)
  manifest.lock     {generator_version, schema_version, artifacts: {path: sha256}}
  coherence-lock.yaml   FC1 baselines (written only by `decisions baseline`)
```

L2 *is* the source file (`decisions show <id> --level l2`) — no duplicated copy.
Every artifact is a pure function of the corpus: no timestamps/hostnames/absolute
paths. `build` is idempotent (`build && build` writes zero bytes) and
`build --check` is the CI/pre-pour drift gate.

## Wiring on the lead host (Step 4.2)

**One entrypoint** drives all three surfaces so local and CI never diverge
(ADR-053); the advisory/blocking split is ADR-047 D3:

```bash
ci/decisions-gate.sh --mode authoring       # PR / doctor  — leg 3 WARNs (exit 0)
ci/decisions-gate.sh --mode distribution    # pour / release — leg 3 BLOCKS (exit 1)
```

Three legs: **lint** (`--lint`, blocks everywhere, exit 2) → **drift**
(`build --check`, blocks everywhere, exit 1) → **coherence** (`check --mode`,
FC1–FC4; WARN at authoring / BLOCK at distribution).

- **Doctor:** aggregate check `DECISION_COHERENCE` = `ci/decisions-gate.sh --mode authoring`.
- **CI (dagger):** call `ci/decisions-gate.sh --mode authoring` with
  `DECISIONS_ANNOTATION_FILE=coherence.json` — legs 1–2 fail the build, leg 3's
  FC1–FC4 rows are emitted as a non-failing PR annotation.
- **Pour gate:** front the `DECISIONS.md` digest pour with
  `ci/decisions-gate.sh --mode distribution` (aborts on any FC1–FC4 blocking row).

The authoring-time discipline is the [`consult-decision-index`](skill/consult-decision-index/SKILL.md)
skill (canonical source here; wired/registered copy at
`.claude/skills/consult-decision-index/`). Full walkthrough on the real corpus:
[`findings/progressive-disclosure/PRODUCTION-DEMO.md`](../../findings/progressive-disclosure/PRODUCTION-DEMO.md).

## Module map

| Module | Responsibility |
|--------|----------------|
| `parser.py` | frontmatter split + the canonical YAML profile emitter (byte-stable) |
| `schema.py` | schema enforcement + the `COH-LN-*` lint catalog |
| `invhash.py` | invariant claim hashing (`decisions hash`) |
| `corpus.py` | discovery, parsing, the typed-edge graph, L1 extraction |
| `generate.py` | deterministic generator + manifest + drift `--check` |
| `gate.py` | FC1–FC4 checks, predicate oracles, baseline lock |
| `migrate.py` | dual-dialect corpus harvester (Step 5) |
| `cli.py` | the `decisions` entrypoint |

## Tests

```bash
pip install pytest
PYTHONPATH=src python3 -m pytest -q          # from tools/shopsystem-decisions/
```

53 tests: canonical-emitter golden bytes, hash vectors, one fixture per
`COH-LN-*`, generator idempotence/prune/determinism, a firing+non-firing fixture
per FC1–FC4 (FC1 exercises the real `scenarios` oracle and a lock round-trip),
the authoring/distribution mode matrix, an end-to-end CLI smoke, and a
socket-blocked offline proof.
