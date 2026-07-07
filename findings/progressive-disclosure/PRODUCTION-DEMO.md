# Progressive-Disclosure Decision System — Production Demo

**A concrete, reproducible walkthrough of the shipped system on the real
`shopsystem-product` corpus.** Branch `pd-consistency-experiments`. Tool:
`tools/shopsystem-decisions/` (the `decisions` CLI). Stdlib + PyYAML only;
network- and model-free by construction.

The thesis in one line: **every ADR / PDR / brief carries its machine truth in
YAML frontmatter (one home per fact); everything else — the L0 index, the L1
digest, the pour artifact — is a pure projection of that source; and a runnable
gate refuses to let the docs silently diverge from reality.** The failure it
exists to stop is the one that actually happened here: the fabro **"parity"**
ADR-050, whose launch interface was quietly *replaced* (tmux watcher-loop →
fabro one-shot) while the doc still claimed parity, and which was never
registered as a change.

---

## 0. One-time setup (reproduce from repo root)

```bash
cd tools/shopsystem-decisions && pip install -e . && cd -   # provides the `decisions` binary
decisions --help                                            # sanity
PYTHONPATH=tools/shopsystem-decisions/src python3 -m pytest tools/shopsystem-decisions/tests -q
#  -> 53 passed
```

The corpus is **97 documents** (82 `adr/` + `pdr/`, 15 `briefs/`), already
migrated to frontmatter (`decisions migrate --write`, commit `7c1c356`).

---

## Part (a) — One source, three projections + an index, all generated

Every fact lives once, in the doc's frontmatter + its `## Decision` body. The
generator emits every derived view; **nothing under `decision-refs/` is
hand-written.**

```bash
decisions build                 # (re)generate decision-refs/ from the corpus
decisions build --check         # CI/pre-pour drift gate — must be clean
#  -> clean: decision-refs/ matches the source corpus
```

`build` is a **pure, idempotent function of the corpus** — no timestamps, no
hostnames, no absolute paths; `build && build` writes zero bytes. The generated
tree:

```
decision-refs/
  l0/<id>.md            97 cards   (id, kind, title, status, description, tags, path)
  l1/<id>.md            97 extracts(edges_out + derived edges_in + invariants + ## Decision body)
  llms.txt              L0 corpus index (llms.txt style)
  index.json            97 machine cards + typed edges
  DECISIONS.md          L1 digest, ACTIVE partition only (the pour artifact)
  manifest.lock         {generator_version, schema_version, artifacts:{path: sha256}}
  coherence-lock.yaml   FC1 baselines (written only by `decisions baseline`)
```

### The same decision at each level — ADR-050 (the fabro "parity" ADR)

**L0** (`decision-refs/l0/ADR-050.md`) — the triage card an agent reads first:

```yaml
id: ADR-050
kind: adr
title: "Fabro launch-interface parity with bc-container: which of the P1–P20 launch properties are KEPT vs REPLACED, the readiness-barrier seam, and the engage-tier replacement"
status: accepted
description: Pins which P1-P20 launch properties fabro KEEPS vs REPLACES, the readiness-barrier seam, and the engage-tier replacement.
tags: []
path: adr/050-fabro-launch-interface-parity-with-bc-container.md
```

**L1** (`decisions show ADR-050 --level l1`) — edges + invariants + the
`## Decision` body, no rationale prose:

```yaml
id: ADR-050
status: accepted
date: "2026-07-01"
edges_out:
  anchored-on: [ADR-018, ADR-020, ADR-021, ADR-029, ADR-032, ADR-048, PDR-011, PDR-016, PDR-020]
edges_in:
  anchored-by: [ADR-051]              # <- DERIVED (nobody wrote this; the generator inverts the edge)
invariants:
  - id: launch-interface-parity-pin
    statement: The Slice-1 launch-interface-parity boot scenario is pinned as a fabro-orchestration feature.
    hash: 6609cf101f8c982e
    status: unverified
## Decision
### D1 -- Parity is a drop-in alternate launch PATH ...
```

**L2** (`decisions show ADR-050 --level l2`) — *is* the source file itself. There
is no duplicated copy to drift; L2 is the ground truth L0/L1 are projected from.

**Index** (`decision-refs/index.json`, one of 97 entries) — machine form, with
both stored and derived edges:

```json
{
  "id": "ADR-050", "kind": "adr", "status": "accepted",
  "description": "Pins which P1-P20 launch properties fabro KEEPS vs REPLACES, ...",
  "path": "adr/050-fabro-launch-interface-parity-with-bc-container.md",
  "edges_out": {"anchored-on": ["ADR-018","ADR-020","ADR-021","ADR-029","ADR-032","ADR-048","PDR-011","PDR-016","PDR-020"]},
  "edges_in":  {"anchored-by": ["ADR-051"]}
}
```

**Why this matters:** the old failure mode was a hand-written summary drifting
from the full doc. Here the summary *cannot* drift — it is `build`-generated and
`build --check` blocks any divergence in CI.

---

## Part (b) — The coherence gate catching FC1–FC4 on the REAL corpus

One command runs the whole gate; the **mode** sets the teeth (ADR-047 D3):

```bash
decisions check adr pdr briefs --mode authoring    --aggregate   # PR/dev surface: WARN
decisions check adr pdr briefs --mode distribution --aggregate   # pour surface:   BLOCK
```

Real-corpus result today:

| Surface | Command | Result |
|---|---|---|
| **Authoring** (PR / doctor) | `--mode authoring --aggregate` | `PASS — 0 blocking → exit 0` (coherence rows are WARNs) |
| **Distribution** (DECISIONS.md pour / release) | `--mode distribution --aggregate` | `FAIL — 230 blocking → exit 1` |

Composition of the 230 blocking rows (per-class, run each with `--class <c>`):

| Class | Failure class | Blocking | Advisory | What it is |
|---|---|---|---|---|
| `ln` | schema floor | 0 | 0 | lint clean |
| `ci` | **FC1** claimed-invariant vs reality | **1** (CI-006) | 56 (CI-000) | ADR-050's pinned parity feature is absent |
| `sg` | **FC4** supersession graph | **7** (SG-001×3, SG-003×3, SG-008×1) | 0 | ADR-025 supersedes active docs; a dependency cycle |
| `dr` | **FC3** doc↔reality drift | **222** (DR-001×74, DR-002×135, DR-004×13) | 751 (DR-005) | dangling links, cited hashes that resolve to nothing, `@origin` with no decision |
| `sp` | **FC2** stale forward-looking prose | 0 | 223 (SP-001) | untagged "not yet / deferred / follow-up" prose |

> Always pass the **full** corpus (`adr pdr briefs`). Running one dir alone makes
> edges into the omitted dirs look dangling and inflates SG falsely.

Below, one **actual diagnostic** per class — copy-pasteable command, verbatim
output.

### FC4 — supersession-graph incoherence (the cleanest catch)

```bash
decisions check adr --class sg --decision ADR-025 --mode distribution
```
```
[FAIL] COH-SG-001  ./adr/025-...-messaging-home-retired.md
       ADR-025 supersedes ADR-023 but ADR-023.status=proposed
       remediation: run: decisions supersede ADR-023 --by ADR-025
[FAIL] COH-SG-001  ./adr/025-...-messaging-home-retired.md
       ADR-025 supersedes ADR-024 but ADR-024.status=accepted
       remediation: run: decisions supersede ADR-024 --by ADR-025
[FAIL] COH-SG-003  ./adr/025-...-messaging-home-retired.md
       ADR-025 supersedes ADR-023 but ADR-023 lacks superseded-by:ADR-025
       remediation: run: decisions supersede <old> --by <new>
[FAIL] COH-SG-003  ./adr/025-...-messaging-home-retired.md
       ADR-025 supersedes ADR-024 but ADR-024 lacks superseded-by:ADR-025
       remediation: run: decisions supersede <old> --by <new>
OK — · FAIL 4 (blocking) · WARN 0 → exit 1
```

ADR-025 says it supersedes ADR-023 and ADR-024, but both are still active and
neither carries the back-edge. **Mode teeth** — the same command, authoring mode,
does not fail the build:

```bash
decisions check adr --class sg --decision ADR-025 --mode authoring   # -> WARN 4, exit 0
```

A whole-corpus SG run also surfaces `COH-SG-008` — a real dependency **cycle**
`ADR-053 → ADR-054 → ADR-053` (the two dagger-credential ADRs anchor on each
other).

### FC1 — claimed-invariant vs reality (the fabro "parity" class)

On the real corpus, ADR-050 authored a `path-present` invariant pinning its
parity boot scenario; the file does not exist:

```bash
decisions check adr --class ci --decision ADR-050 --mode distribution
```
```
[FAIL] COH-CI-006  ./adr/050-fabro-launch-interface-parity-with-bc-container.md
       invariant launch-interface-parity-pin (path-present) violated: path
       features/fabro-orchestration/01-launch-interface-parity-boot.gherkin absent
       remediation: the claim no longer holds against the artifact surface — amend or fix
```

The **governed-delta** flavor of FC1 is the one that would have caught the
original parity regression directly: baseline the governed scenario-set at
acceptance, and any later `added / removed / flag-delta / lifecycle-delta`
against a `claim: parity` invariant fires `COH-CI-001` with the exact delta. The
shipped test exercises this end-to-end against the *real* `scenarios` oracle
(`tools/shopsystem-decisions/tests/test_fc1_delta.py`, `test_parity_clean_then_delta_fires`).
The diagnostic (reproduced from that fixture) names the intruding scenario hash
and flag:

```
[FAIL] COH-CI-001  invariant send-vehicle-parity
    baseline : ADR-060 @ e57aba1 — 1 pin(s), flags ['--bc']
    actual   : +['da255854d5d933f5'] -[] flag±['--hash'] lifecycle±[]
```

Read against fabro: a `parity`-claimed ADR-050 whose engage scenario changed to
the one-shot `-I WORK_ID` form (`68e14cdcd8b7c145`) would show that hash in
`added` and block the pour — the change would have to be *re-claimed* as
`additive`/`retire` (registering it) before it could ship. That is the whole
point: parity claims become machine-checkable, not prose anyone can quietly
falsify.

### FC3 — doc↔reality drift (dangling reference)

```bash
decisions check adr --class dr --decision ADR-004 --mode distribution   # DR-002 row:
```
```
[FAIL] COH-DR-002  ./adr/004-bc-launcher-as-new-bc.md:94
       cited hash dd52b41c28f2ab14 matches no @scenario_hash and no retires list
       remediation: fix the hash or add it to a retires[] declaration
```

Independently verifiable: `grep -rl dd52b41c28f2ab14 features/` returns nothing —
ADR-004 cites a `watch.feature` scenario hash that exists in **no** feature file.
Genuine drift, correct citing artifact, correct line.

### FC2 — stale forward-looking prose (the "not yet an owned BC" claim)

```bash
decisions check adr --class sp --decision ADR-048 --mode authoring   # (advisory)
```
```
[WARN] COH-SP-001  ./adr/048-...-substrate.md:197
       untagged forward-looking prose: 'fabro in-container orchestration is not yet an owned BC, so the graduation'
       remediation: add a pending: [{marker, predicate}] entry covering this line
```

ADR-048 line 197 still says fabro "is **not yet an owned BC** … not
`assign_scenarios`-dispatchable today" — while `features/shopsystem-bc-launcher/`
carries 4+ fabro feature files, a shipped 15-file fabro-def bundle, and a real
`bc-container launch --orchestrator fabro` flag. The prose is stale-as-current.
**Honest scope of this catch (see §remaining):** FC2 flags this at **advisory**
severity today; its blocking `COH-SP-002` teeth engage only once the line is
tagged with a `pending: {predicate}` entry — which the corpus migration did not
synthesize. This demo ships the regex fix that makes SP-001 *see* the sentence;
turning it into a blocking catch is the tracked follow-up below.

---

## Part (c) — How this changes day-to-day work

**Before.** A decision doc was a prose artifact. "Parity" was a word. When the
fabro launch path was replaced (tmux reactive-persistent watcher → fabro one-shot
`-I WORK_ID`), ADR-050 kept saying *parity*, the change was never registered, and
nothing — no reviewer, no CI leg — mechanically contradicted the stale claim. The
divergence surfaced only later, by hand, in a bead post-mortem.

**After.** The claim is machine truth, and there are two gates:

1. **Authoring gate (agent discipline + advisory CI).** Before writing or
   amending any decision, the [`consult-decision-index`](../../.claude/skills/consult-decision-index/SKILL.md)
   skill fires: triage L0 for a conflicting/duplicate decision, read neighbours
   at L1, write supersede edges via the tool (never by hand), author frontmatter
   with a `description` + any `invariants[]`, then run the gate. A "parity" claim
   *requires* an `invariants[]` entry + a `decisions baseline` stamp — so the
   claim is registered against the actual scenario-set the day it is made.

2. **Distribution gate (blocking CI / pour).** The DECISIONS.md pour and release
   reconciliation run `--mode distribution`; a stale parity claim, a dangling
   supersede, or a cited-but-absent hash **aborts the pour (exit 1)**. The fabro
   'parity' ADR could not have reached a release digest while its governed
   scenario-set had moved underneath it — it would fail `COH-CI-001` with the
   intruding scenario hash named, and the author would have to re-claim the change
   as `additive`/`retire` (i.e., *register it*) first.

Net effect: the class of mistake that motivated this whole initiative — a
decision doc asserting a reality that the artifact surface no longer supports —
moves from "caught eventually, by a human, in a post-mortem" to "caught
mechanically, at the PR as a WARN and at the pour as a hard block, with a
specific diagnostic and a remediation command."

---

## How the gate runs in CI

One entrypoint, run identically on the lead host and in the dagger build
(ADR-053: same definition local and CI; ADR-047 D3: advisory at authoring,
blocking at distribution):

```bash
# Authoring / PR / doctor — advisory. Legs 1-2 hard-fail; leg 3 WARNs.
DECISIONS_ANNOTATION_FILE=coherence.json \
  tools/shopsystem-decisions/ci/decisions-gate.sh --mode authoring

# Distribution / DECISIONS.md pour / release — blocking. Any FC1-FC4 row aborts.
tools/shopsystem-decisions/ci/decisions-gate.sh --mode distribution
```

The three legs (see `ci/decisions-gate.sh`):

1. **Lint** `decisions check --lint` — schema floor, blocks in **every** mode (exit 2).
2. **Drift** `decisions build --check` — `decision-refs/` must be a pure function
   of the source, blocks in every mode (exit 1).
3. **Coherence** `decisions check --mode $MODE` — FC1–FC4. In `authoring` the
   blocking rows are captured as a PR annotation (JSON via
   `DECISIONS_ANNOTATION_FILE`) and never fail the build; in `distribution` they
   abort.

Verified on this corpus, authoring mode:

```
== decisions-gate: mode=authoring dirs=[adr pdr briefs] base=. ==
-- leg 1/3: lint (schema floor, blocking everywhere)
OK — · FAIL 0 (blocking) · WARN 0 → exit 0
-- leg 2/3: build --check (projection drift, blocking everywhere)
clean: decision-refs/ matches the source corpus
-- leg 3/3: coherence check (mode=authoring)     -> PASS (exit 0)
```

Doctor wires the same authoring line as an aggregate check `DECISION_COHERENCE`;
the dagger CI job wraps it (lint + drift blocking; `check --mode authoring --json`
as a non-failing PR annotation). The pour gate fronts the DECISIONS.md pour with
`--mode distribution || abort`.

---

## Exact commands to reproduce everything

```bash
# from the repo root, on branch pd-consistency-experiments
cd tools/shopsystem-decisions && pip install -e . && cd -

# tests (53)
PYTHONPATH=tools/shopsystem-decisions/src python3 -m pytest tools/shopsystem-decisions/tests -q

# Part (a): single source -> projections + index
decisions build && decisions build --check          # idempotent; clean
decisions show ADR-050 --level l0                    # card
decisions show ADR-050 --level l1                    # extract (edges+invariants+Decision)
decisions show ADR-050 --level l2                    # the source file itself
sed -n '1,20p' decision-refs/DECISIONS.md            # the pour artifact
python3 -c "import json;print([x for x in json.load(open('decision-refs/index.json')) if x['id']=='ADR-050'][0])"

# Part (b): the gate catching FC1-FC4 (per-class diagnostics)
decisions check adr --class sg --decision ADR-025 --mode distribution   # FC4
decisions check adr --class ci --decision ADR-050 --mode distribution   # FC1
decisions check adr --class dr --decision ADR-004 --mode distribution   # FC3
decisions check adr --class sp --decision ADR-048 --mode authoring      # FC2 (advisory)

# whole-corpus, both surfaces (distribution DR leg is slow: it resolves bead refs)
decisions check adr pdr briefs --mode authoring    --aggregate          # PASS, exit 0
decisions check adr pdr briefs --mode distribution --aggregate          # FAIL 230 blocking, exit 1

# Part (c) wiring: the CI entrypoint (both surfaces)
tools/shopsystem-decisions/ci/decisions-gate.sh --mode authoring
tools/shopsystem-decisions/ci/decisions-gate.sh --mode distribution

# FC1 governed-delta "parity" mechanism, end-to-end against the real scenarios oracle:
PYTHONPATH=tools/shopsystem-decisions/src python3 -m pytest \
  tools/shopsystem-decisions/tests/test_fc1_delta.py -v
```

---

## Production-complete vs. remaining — an honest reviewer's ledger

**What is production-complete (verified, this branch):**

- **Single-source schema + deterministic generator.** 97 docs → L0/L1/L2 + index
  + llms.txt + DECISIONS.md; `build` idempotent; `build --check` is a clean drift
  gate. 53 tests pass, including a socket-blocked offline proof.
- **The gate catches FC1, FC3, FC4 on the real corpus with correct, specific,
  blocking diagnostics** (verified adversarially, near-miss batteries):
  - **FC4** — CONFIRMED. ADR-025 SG-001/SG-003, the 053↔054 cycle; near-miss
    matrix (8 variants) discriminates correctly; mode teeth correct.
  - **FC3** — CONFIRMED. ADR-004 DR-002 (independently grep-verified dangling);
    12-case near-miss matrix; the `beads:`-URI false-positive **fixed this pass**
    (DR-001 dropped 143 → 74; 69 spurious blocking rows removed).
  - **FC1** — CONFIRMED. Governed-delta parity diff catches the intruding scenario
    hash + flag; the baseline-rev diagnostic bug (`@ ?`) **fixed this pass** (now
    `@ e57aba1`); real-corpus CI-006 blocks on ADR-050's absent parity feature.
- **Mode teeth** (ADR-047 D3): authoring WARN/exit 0, distribution BLOCK/exit 1;
  lint + drift block in both. **One CI entrypoint** (`ci/decisions-gate.sh`)
  wired for both surfaces; authoring run verified green on this corpus.
- **Authoring discipline wired** as an agent skill at
  `.claude/skills/consult-decision-index/` (provenance `LOCAL`), registered in the
  skills README, canonical source in the tool.

**What a reviewer must know is NOT fully closed:**

1. **FC2 is the weak class.** The **REFUTE** from verification stands in spirit:
   on the real corpus FC2 catches stale "not yet" prose only at **advisory**
   severity. This pass broadened `FORWARD_RE` so SP-001 now *sees* the exact FC2
   sentence (ADR-048:197 "not yet an owned BC" — previously invisible), but the
   **blocking** `COH-SP-002` teeth require a `pending: {predicate}` frontmatter
   entry that the corpus migration synthesized **zero** of. Until `migrate.py`
   emits `pending:` entries (or the gate detects present-tense state claims
   contradicted by the artifact surface, not just a keyword list), FC2's real
   catch of the fabro "not yet a BC" contradiction is advisory-only. **This is the
   top follow-up.** (SP-001 is also noisy — it matches the word "pending" in
   ordinary prose; the advisory net wants tightening.)
2. **FC1 governed-delta is opt-in.** It catches a stale parity claim only when the
   claim is machine-encoded (`invariants[]` + `decisions baseline`). The migrated
   corpus gave ADR-050 a `path-present` pin, not a `governed-delta` parity
   baseline, so the *direct* parity-regression catch is proven by the shipped test
   and the reconstruction, not yet by a live baseline on ADR-050. Authoring
   ADR-050's governed-delta baseline against the real engage feature is a small,
   well-understood next step.
3. **FC4 models supersession as whole-document.** ADR-025's real supersession is
   *partial* (it supersedes ADR-023 D2/D3 + ADR-024's messaging parts; other
   clauses remain in force). The gate correctly detects the incoherence, but the
   emitted `decisions supersede` remediation would mark the targets *fully*
   superseded — trading FC4 for a new status-vs-prose contradiction. No check-id
   models clause-level supersession yet.
4. **Diagnostic-specificity gaps (detection intact).** FC1's lifecycle
   sub-oracle (`ONESHOT_RE`) is tuned to fixture phrasing and does not *name* the
   one-shot/WORK_ID half of the real fabro delta (`lifecycle±[]`); detection rides
   on the hash delta, which is correct, but the diagnostic is less specific than it
   could be. The `FLAG_RE` prose false-positive noted in FC1 verification is
   fixture-only on today's corpus (no live `governed-delta` invariant with a
   `surface` exists), so it cannot mis-fire here — but it should get scenario-block
   awareness before a governed-delta baseline ships.
5. **Not pushed / not merged.** This lives on `pd-consistency-experiments` in a
   worktree; it is an experiment pending David's review, not merged to `main`. The
   distribution gate currently reports **230 real blocking findings** — that is the
   gate working (the corpus genuinely has that much drift), not a defect; triaging
   those 230 into fix-vs-accept is the adoption work, not a tool gap.

**Bottom line for the reviewer:** the machinery — single source, deterministic
projections, the FC1/FC3/FC4 blocking catches, mode teeth, the CI entrypoint, the
authoring skill — is production-shaped and demonstrated on the real corpus. FC2's
blocking teeth and FC1's live parity baseline on ADR-050 are the two honest gaps
between "the demo catches it" and "the corpus is fully wired to catch it going
forward."
