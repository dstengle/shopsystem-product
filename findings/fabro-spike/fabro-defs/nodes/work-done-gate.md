# node port: `work-done-gate` → `wdg_r` / `wdg_f` (command) + block edge → `emit_blk`

**Source:** `work-done-gate/SKILL.md` · **Realizes 01b nodes:** `wdg_r` (scenario path,
behind reviewer sign-off) and `wdg_f` (flat path). Outcome edges (both): `-> emit_* [label="pass"]`
· `-> emit_blk [label="fail"]`. The block-conversion is expressed as an EDGE (01b §4),
never an in-node silent branch.

**Translation note:** command node → tool-restricted agent node (v0.254.0 DOT has no
native command handler; see `../README.md`). **GATE-FIDELITY NOTE:** 01b §2's node `cmd`
enumerated only C1/C2/C3 (the emit-time subset). The AUTHORITATIVE furniture defines
**FIVE** checks — dropping Checks 4 & 5 would be a defect — so all five are ported here.
(bc-review runs Checks 4 & 5 up front; work-done-gate runs the full sweep at emit time.)
ANY single failure converts the emit to `--status blocked` with NAMED evidence — no
exceptions, no partial passes.

---

## `wdg_r` / `wdg_f` — command node: the five pre-emit checks

**Check 1 — Clean working tree (DELIVERABLE-scope).**
```
git status --porcelain -uall
```
PASS: no modified/staged/untracked/deleted path under a **deliverable** dir (`features/`,
`src/`, `tests/`). The tree MAY carry dirty **non-deliverable** paths and still pass —
harness/config (`.claude/settings.json`, `.claude/canonical/bc-primer.md`) and ambient
carve-outs (`.beads/issues.jsonl`, `.specstory/**`, `.claude/scheduled_tasks.lock` — the
`bc-emit` wrapper's `_CARVE_OUTS`). Deliverable-scope SUBSUMES the carve-out list — do not
add a second carve-out check. (This is why Check 4 closing the plan bead writes the
non-deliverable `.beads/issues.jsonl` and never blocks, dissolving the C1/C4 deadlock.)
FAIL: any dirty path under `features/`/`src/`/`tests/`. Block:
`blocked: dirty deliverable path(s) at emission time. Paths: <named verbatim>`.

**Check 2 — work_id commit reachable from origin/main as a WHOLE token.**
```
git fetch origin
git log origin/main -E --grep="\b<work_id>\b" --oneline
```
PASS: whole-token match in >=1 commit on `origin/main` (a strict PREFIX — `lead-8v` of
`lead-8vwf` — does NOT match; loose substring false-attributes lineage). Fetch FIRST — a
stale local `origin/main` is a false pass. Tags/`git notes` naming exactly the work_id
also qualify. **Idempotent-no-op branch (FLAT MAINTENANCE ONLY):** when the vehicle is
flat maintenance whose intended end-state ALREADY holds with ZERO delta (no commit was
needed), Check 2 passes even with no matching commit. Applies ONLY when BOTH (a) flat
maintenance AND (b) end-state already holds. A scenario-bearing or delta-requiring
dispatch never takes this branch. FAIL: no match. Block:
`blocked: work_id <work_id> not reachable from origin/main (HEAD: <sha>). Run integrating-to-main`.

**Check 3 — Scenario-hash subset (ADR-010).** `work_done.scenario_hashes` must be a
SUBSET of the `@scenario_hash:` tags pinned in `features/`.
```
scenarios hash features/<file>.feature        # 3a: recompute canonically (block-only,
                                               #     ADR-019 — Feature: line NOT hashed).
                                               #     Never trust hashes from memory.
git grep "@scenario_hash:<hash>" features/     # 3b: confirm each reported hash is
                                               #     committed in features/.
```
3c: the reported set (one repeatable `--scenario-hash <h>` per hash) must be a subset of
the hashes found in `features/`. You MAY report fewer (partial delivery is valid); you
MUST NOT report a hash absent from `features/`. FAIL: any hash not found via git grep, or
any recomputed value that does not match. Block:
`blocked: scenario_hash <hash> not found in features/ (searched: features/; origin/main: <sha>)`.

**Check 4 — bd plan sub-issues present, closed, and DURABLE.**
```
bd children <umbrella> --json     # enumerate EVERY reachable sub-issue: status + title
bd dolt push                      # durability: closures reachable on the pushed remote
```
PASS: >=1 RED sub-issue exists (title 'write the failing test for …'), EVERY sub-issue
reachable under the work_id umbrella is CLOSED (enumerate independently — an ORPHANED OPEN
sub-issue the implementer never created/closed STILL blocks), and the decomposition+closure
state is reachable from the pushed bd-dolt remote. FAIL: no sub-issues; any reachable
sub-issue (incl. orphan) OPEN; no RED sub-issue; or state not reachable from the pushed
remote (named specifically as a bd-decomposition-DURABILITY failure, NOT a generic dirty
tree). Block (one of):
`blocked: no bd plan sub-issues for <work_id>` /
`blocked: bd sub-issue(s) not closed for <work_id>: <list incl. orphaned OPEN ids>` /
`blocked: bd decomposition+closures for <work_id> not reachable from the pushed tracker remote`.

**Check 5 — Test-first artifact, GENUINE red (not merely red-before-green).**
```
git log --oneline bc/<work_id>            # test(red) must precede feat(green) per behavior
git checkout <test(red)-sha> --           # or a throwaway worktree
# run ONLY the tests that commit newly added — they MUST fail at the red commit
```
PASS: for every behavior with a `feat(green)`, a `test(red)` for the SAME behavior appears
BEFORE it, AND that red commit's newly-added tests DEMONSTRABLY FAIL at the red commit.
FAIL: a `feat(green)` with no matching `test(red)`; `test(red)` after `feat(green)`; or a
TAUTOLOGICAL red (newly-added tests already PASS at the red commit — order holds but the
test never showed absence of the behavior). Block (one of):
`blocked: no test-first commit sequence for <behavior>` /
`blocked: tautological red for <behavior>: test(red) <sha> newly-added tests pass at the red commit`.

---

## Outcome edges + emit spelling

- **all five PASS → outcome 'pass'.** The graph routes to the emit node, which sends the
  routine sign-off through the **`bc-emit work-done` wrapper** (NOT the bare `shop-msg
  respond work_done` primitive) — the wrapper RE-RUNS these preconditions at emission time
  (incl. `--plan-umbrella <umbrella>` for the Check-4 orphan/durability sweep and the
  block-only scenario-hash match), so a bare-primitive sign-off cannot slip a stale/orphan
  hash through:
  ```
  bc-emit work-done --bc <name> --work-id <work_id> \
    --scenario-hash <h1> [--scenario-hash <h2> ...] \
    --summary "<probes considered + dismissed>"
  ```
  The `--summary` MUST be substantive (NOT `test`/`tbd`/`placeholder`/`wip`/a single
  word/empty — a placeholder MUST NOT be emitted on `--status complete`). The bare
  `shop-msg respond work_done --force` path is the forced-recovery escape valve ONLY.
- **any check FAILS → outcome 'fail' → edge to `emit_blk`**, which sends:
  ```
  shop-msg respond work_done --bc <name> --work-id <work_id> --status blocked \
    --summary "<named evidence from the failing check>"
  ```
  Named evidence = specific paths, the work_id value, the origin/main short SHA, and which
  check failed. Vague evidence is not acceptable. After resolving a block, fix the cause
  and RE-RUN the FULL gate from Check 1 — do not skip previously-passing checks.

- **agent-node realization:** `class="command"`, `permissions="read-write"`,
  `prompt="Run the five checks above IN ORDER for work_id <work_id>. Deterministic, no
  judgment. Emit outcome 'pass' iff ALL five pass; otherwise emit 'fail' and report the
  exact block message for the FIRST failing check. Do not emit --status complete on any
  failure."`
