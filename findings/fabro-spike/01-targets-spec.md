# Slice 1 — Targets spec (synthesis): what a fabro launcher + loop must satisfy end-to-end

**Epic:** lead-6k1r (Fabro spike) · **Slice:** 1 (design-only, artifact surface) ·
**Branch:** `fabro-spike` · **Date:** 2026-07-01

This is the Slice 1 synthesis. It ties the two target-spec legs into one end-to-end
picture and hands Slice 2 a concrete build list. The two legs:

- **Target A — launch-interface parity:** [`01a-target-launch-parity.md`](01a-target-launch-parity.md)
  — the `bc-container launch` contract (20 observable properties P1–P20) as the drop-in
  interface a fabro in-container launcher must satisfy, each mapped to its fabro analog
  under `provider='local'`.
- **Target B — loop + gated `work_done`:** [`01b-target-loop-workdone.md`](01b-target-loop-workdone.md)
  — the minimal Implementer→Reviewer loop and its gated `work_done` emission as a fabro
  DOT graph (`workflow.fabro` + `workflow.toml`), with outcome-conditional edges so a
  FAILED node cannot reach Exit:SUCCEEDED.

Grounding for both (facts taken as given, not re-derived):
[00-fabro-recon.md](00-fabro-recon.md) · [00a-fabro-tool.md](00a-fabro-tool.md) ·
[00b-f6ta-seams.md](00b-f6ta-seams.md) · [00c-bcshop-loop.md](00c-bcshop-loop.md).

**Design-only.** `bc-base` is un-rebuildable (ADR-022), so no live boot happened in
Slice 1. Every "PROVEN" claim is inherited from Slice 0; every acceptance criterion is a
Slice 3 (parity) or Slice 4 (loop) observation, not a Slice 1 one.

---

## 1. The end-to-end picture — launch half meets loop half

The goal (plan.md) is: **a BC comes up orchestrated by an ephemeral, in-container fabro
server and handles an `assign_scenarios` dispatch end-to-end (build → review →
`work_done`), with the same launch interface as `bc-container`.** The two targets are the
two halves of that sentence, and they meet at exactly one seam:

```
  ┌─────────────────────── Target A: launch parity (01a) ───────────────────────┐
  bc-container launch (KEPT):  boot bc-<bc> · clone /workspace · bd dolt pull ·
      pour shop-templates skills · mounts/isolation · SHOPMSG_DSN · network shopsystem
                                    │
                    fabro REPLACES the tmux `agent` engage:
        ephemeral headless `fabro server start --foreground --no-web --bind <sock>`
                                    │
        [run.prepare] readiness barrier  ── postgres(SHOPMSG_DSN) + agent-vault broker
        (P6, fail-closed, idempotent)      PASS ──▼            FAIL ──► Exit-blocked
  └──────────────────────────────────────────────┼──────────────────────────────┘
                                    │  ◄── THE SEAM: barrier PASS starts `fabro run`
  ┌──────────────────────────── Target B: the loop (01b) ───────────────────────┐
  `fabro run` of workflow.fabro:  prime → health → arm → classify
      → [scenario path] suff → worktree → plan → impl → redgate → integ → review
        → wdg_r → emit_r (SOLE work_done emitter) → done
      → [flat path]     impl_f → wdg_f → emit_f → done
      → [report]        emit_clar / emit_blk → reported     [infra fail] → halt
                                    │
        work_done emitted via bc-emit/shop-msg (pydantic-validated WorkDone)
  └──────────────────────────────────────────────┼──────────────────────────────┘
                                    │  ◄── lead harvests HERE, invariant surface
        lead: shop-msg read outbox + scenarios hash  (ADR-018 — NEVER fabro outputs)
```

**The seam is a single fact:** the readiness barrier (Target A, P6) is the *first
`[run.prepare]`/command node* of the fabro run whose graph *is* Target B. Target A's
"engage tier" replacement and Target B's `prime`/`health`/`arm` session-start nodes are
the same physical nodes viewed from two sides — A specifies that they must exist and
fail-closed; B specifies their graph wiring and outcome edges. Slice 2 builds them once.

**The three-tier framing that makes the spike tractable** (from 01a): the
`bc-container` contract splits into a **Container tier** (P1–P4, P7, P10–P17 — KEPT with
bc-container's docker invocation because `provider='local'` means fabro runs *inside* an
already-booted container, it does not boot one), an **Engage tier** (P5, P6, P8, P9, P18
— what fabro REPLACES: the tmux `agent` claude TUI becomes the headless `fabro run`), and
a **Credential tier** (P11–P13 — the PROVEN agent-vault vault-placeholder + `HTTPS_PROXY`
path). Fabro touches only the Engage tier and rides the other two.

**The one invariant that spans both halves:** credentials via **agent-vault, not fabro
secrets** (plan.md §2). Target A pins the mechanism (agent wrapped `agent-vault run --
claude`, `.credentials.json` = read-only `__PLACEHOLDER__`, fabro vault holds only
dummies, `HTTPS_PROXY` inherited by node exec env under `provider='local'`); Target B
consumes it (every agent/command node inherits `HTTPS_PROXY`; the model/provider key
never lives in fabro as a real value). The single sharpest open risk — **does a
non-dry-run agent node's own LLM/tool calls actually inherit `HTTPS_PROXY`** — is the
same risk on both sides (01a AC6 = 01b AC9).

---

## 2. Parity acceptance criteria (Slice 3) — the launch half

Verbatim anchor: 01a §3 (AC1–AC11). Slice 3 boots the in-container fabro server and
brings a BC up "with the same launch interface as bc-container"; parity is proven when
all of these are OBSERVED (gated on the standing blocker — `bc-base` must first be made
rebuildable, ADR-022).

| AC | Proves | Property |
|----|--------|----------|
| **AC1** | `docker ps` shows `bc-<bc>` from pinned `bc-base` | P1 |
| **AC2** | `/workspace` holds the clone; `bd ready` exits 0 (beads functional) | P2/P3 |
| **AC3** | `.claude/skills/` holds the poured `shop-templates` group | P4 |
| **AC4** | ephemeral headless fabro server running; a `fabro run` of Target B is startable | engage tier |
| **AC5** | **readiness barrier fail-closed + idempotent** — postgres down → FAIL naming `SHOPMSG_DSN`, run does NOT reach router; broker down → FAIL naming broker addr; both up → PASS; re-run = no-op ready (checkpoint/resume replay). **The make-or-break parity observation.** | P6 |
| **AC6** | **non-dry-run** agent node makes an outbound call that succeeds via `HTTPS_PROXY` injection, with fabro vault holding ONLY dummies — proves the proxy reaches the *agent's own* calls, not just fabro's GitHub ops | P12 (**the OPEN risk**) |
| **AC7** | `docker inspect` — BC repo is the only bind mount; no host `~/.claude`/`~/.config/gh`/`~/.gitconfig`/sibling mount; `.credentials.json` = read-only `__PLACEHOLDER__` | P10/P11/P12 |
| **AC8** | container on network `shopsystem` resolved WITHOUT `--network`; `SHOPMSG_DSN` reaches host postgres; coordinates trace to `ops/ops-coordinates` | P14/P15/P16 |
| **AC9** | `shop-msg bc-status` reaches `online` (ADR-014 heartbeat) + BC accepts a ping — established WITHOUT reading fabro outputs (ADR-018 invariant) | P18 |
| **AC10** | after barrier PASS, `fabro run` begins autonomous work with no keystroke, no interactive option screen — the observable the two-send-keys/Escape discipline guaranteed | P8/P9 (obsolescence) |
| **AC11** | the loop terminates in a `work_done`/`clarify` through `shop-msg`/`bc-emit`; lead harvests via `shop-msg read outbox` + `scenarios hash` only — **ties into Target B** | invariant |

AC5 and AC6 are the two that carry spike risk; the rest are parity book-keeping.

---

## 3. Loop acceptance criteria (Slice 4) — the goal

Verbatim anchor: 01b §6 (1–10). Slice 4 is green when a lead `assign_scenarios` dispatch
to a throwaway minimal BC orchestrated by an in-container fabro server running Target B's
workflow produces a valid `work_done`, verified ONLY on the artifact/mailbox surface:

1. **Dispatch** — lead sends `assign_scenarios` (scenarios carry `@scenario_hash:` tags).
2. **Path taken** — the run traverses
   `arm→classify(scenario)→suff(proceed)→worktree→plan→impl→redgate(pass)→integ→review(signoff)→wdg_r(pass)→emit_r→done`.
3. **RED-before-GREEN held** — `redgate` passed: a watched-fail `test(red)` precedes each
   `feat(green)` in work-branch history.
4. **Reviewer is the SOLE emitter** — `work_done complete` came from `emit_r` via
   sign-off, not the implementer, not hand-written.
5. **Valid `work_done` on the wire** — `shop-msg read outbox` returns a
   `catalog.schemas.WorkDone` with `status="complete"`, a substantive summary, and
   `scenario_hashes` a subset of committed tags.
6. **The three gate checks verifiably held** — clean deliverable tree; `work_id`
   reachable from `origin/main` as a whole token; every hash recomputes equal via
   `scenarios hash` (block-only, ADR-019) and is present under `features/`.
7. **Lead harvests via the invariant surface only** — `shop-msg read outbox` +
   `scenarios hash`, never fabro run outputs (ADR-018).
8. **Silent-failure guard proven, not just present** — inject one failure (force
   `redgate` fail, or dirty a deliverable path before `wdg_r`) and confirm the run
   reaches `reported` with `work_done status=blocked` + named evidence, and does NOT reach
   `done`/SUCCEEDED. Direct exercise of the Slice-0 §d hazard.
9. **Credentials rode agent-vault, not fabro secrets** — fabro vault held only dummies;
   nodes inherited `HTTPS_PROXY`; provider key never a real fabro value. (Same non-dry-run
   confirmation as AC6.)
10. **bd stayed authoritative; no phantom row** — outbox holds exactly one `work_done`
    row; ADR-012 `UNIQUE(work_id,direction,shop)` + bd-first sweeper present; a
    between-node kill/resume replays without re-depositing.

Criteria 8–10 are the ones Slice 0 explicitly deferred; Target B pins them as pass/fail.

---

## 4. Consolidated furniture to port in Slice 2

Slice 2 translates `shop-templates` furniture into fabro's format — skill prose inlined
into `prompt=`, or invoked via fabro's skill primitive; subagent fan-out via a fabro
`parallel=true` node; deterministic tooling realized as `shape=box`/`cmd=` command nodes.
This is the union of 01a's "keep the tool, shell it from a node" list and 01b §5's
node-by-node port table.

### 4a. Skills / role shims → fabro nodes (Target B loop)

| Furniture (source) | Kind | Realizes node(s) |
|---|---|---|
| `bc-router/SKILL.md` (classification table, session-start protocol) | skill → graph shape + `classify` | `prime`, `health`, `arm`, `classify` |
| `bc-sufficiency-check/SKILL.md` | skill → agent prompt | `suff` |
| `writing-plans-bdd/SKILL.md` | skill → agent prompt | `plan` |
| `subagent-driven-development/SKILL.md` | skill → parallel fan-out | `impl` (`parallel=true`) + `redgate` |
| `test-driven-development/SKILL.md` (+ `testing-anti-patterns.md`) | skill → agent prompt (RED→GREEN→REFACTOR) | inside `impl`; asserted by `redgate` |
| `using-git-worktrees/SKILL.md` | skill → command | `worktree` |
| `integrating-to-main/SKILL.md` | skill → command | `integ` |
| `bc-review/SKILL.md` | skill → agent prompt | `review` |
| `work-done-gate/SKILL.md` (3 checks + block-conversion) | skill → command | `wdg_r`, `wdg_f`; block edge → `emit_blk` |
| `bc-implementer.md` (role shim) | subagent template → `class="coding"` | `impl`, `impl_f` |
| `bc-reviewer.md` (role shim) | subagent template → `class="review"` | `review` |

### 4b. CLIs that must be on PATH inside the fabro sandbox (both targets)

Baked into the fabro-launcher image (Target A) / inherited under `provider='local'`:
`bc-emit` (the `work-done` wrapper that re-runs the gate), `shop-msg` (prime / watch /
pending / read / respond / send / bc-status), **`scenarios hash`** (block-only, ADR-019),
`bd` (dolt pull / ready / create), `git` (worktree / log / grep), `gh`, `agent-vault`,
`shop-templates` (the skills-pour binary). **`scenarios hash` absence is exactly the
ADR-022 bc-base gap** — its presence is a hard Slice-4 prerequisite.

### 4c. Support pieces that cross over

- `claude_settings/bc.json` SessionStart hooks (`bd prime`, `shop-msg prime`) → the
  `prime`/`health` command nodes (01b §5).
- The `[run.prepare]` command nodes that shell `bd dolt pull` + `bd ready` smoke (P3) and
  the `shop-templates` skills pour (P4) — no fabro-native primitive; keep the tools.
- The readiness-barrier command node (P6 = the seam) wired with outcome-conditional edges.

### 4d. Explicitly NOT ported (invariant surfaces — stay outside fabro)

- `shop-msg watch` LISTEN/NOTIFY event source — Seam(b) is PARTIAL; fabro wraps the loop
  but cannot BE the event source, so `shop-msg watch` stays a command node (`arm`).
- **bd as the state authority** — fabro SlateDB checkpoint demoted to resume-only
  (PDR-010); must NOT become a competing beads authority.
- **Addressing / coordinates** — `ops/ops-coordinates` stays single source; fabro invents
  no addressing analog (ADR-006/020/043).
- **Lead-side harvest** — `shop-msg read outbox` + `scenarios hash` (ADR-018); fabro
  outputs are never the lead's evidence.
- **Real credentials** — agent-vault; fabro's vault holds only `__PLACEHOLDER__`/dummy.
- fabro native `[run.pull_request]` — **disable it** (`enabled = false`); leaving it on
  makes a second integration authority competing with `integrating-to-main`.

### 4e. Deliverables Slice 2 produces

- `workflow.fabro` (the DOT graph of §2 of 01b, ready for `fabro validate`).
- `workflow.toml` (`[environments.local] provider='local'`; `[run.retry.nodes]` on
  emit/infra nodes; `[run.pull_request] enabled=false`).
- `.fabro/project.toml` / vault scaffold with only dummy placeholders.
- The ported prompt bodies (skill prose inlined) + the `cmd=` command-node scripts.
- `findings/fabro-spike/02-translation.md` documenting the translation + the resolution
  of the command-node-attribute open question (via `fabro validate`).

---

## 5. Risks carried into Slices 2–4

1. **Standing blocker — `bc-base` un-rebuildable (ADR-022).** The `scenarios` CLI is not
   baked and the pdr/002 pin 404s. No live boot was possible in Slice 1, and the
   `scenarios hash` dependency (§4b) makes this a **hard Slice-4 prerequisite**. Must be
   resolved before any AC that boots a real container (AC1–AC11) or the Slice-4 demo.
2. **`HTTPS_PROXY` inheritance into an agent node's own calls (AC6 / Slice-4 AC9 — the
   sharpest open risk).** Proven for fabro's own GitHub ops (00a §4.3); NOT yet proven for
   an agent node's own LLM/tool calls. `provider='local'` should inherit the parent env
   for free, but only a **non-dry-run** agent-node run confirms it. Open sub-question:
   can the LLM provider key itself ride agent-vault (dummy `ANTHROPIC_API_KEY` + proxy
   injection to `api.anthropic.com`), same pattern as the GitHub bypass?
3. **postgres LISTEN/NOTIFY block-and-wait unconfirmed (Seam(b) PARTIAL).** A fabro node
   can *poll* `shop-msg pending`, but block-and-wait on postgres LISTEN/NOTIFY is
   unconfirmed; the `arm` node models a drain, not a live block-wait. Confirm whether the
   in-container-only scope fully dissolves Seam(b) or leaves a poll loop.
4. **Command-node attribute not pinned (Slice-2 first check).** fabro's exact non-LLM
   command/exec node attribute was not confirmed in Slice 0 — native `cmd=`/`run=` vs. a
   tool-restricted agent node. Graph shape, outcome edges, and furniture mapping are
   unchanged either way; confirm via `fabro validate` in Slice 2.
5. **SlateDB-vs-bd authority collision at the emit boundary (ADR-012 ordering hazard).**
   fabro checkpoints every node; the node running `shop-msg respond` collides with a
   checkpoint-commit. Mitigation (outcome-conditional edges + ADR-012
   `UNIQUE(work_id,direction,shop)` + bd-first sweeper) is a Target B / Slice 4 concern
   and remains mandatory; it does not weaken the shop-msg-authoritative harvest stance.
6. **Architecture choice deferred to Slice 3.** Pure `provider='local'` with the existing
   `bc-container` doing the docker boot (fabro rides inside) vs. a thin fabro-launcher
   that shells `bc-container launch` then execs `fabro run` — both preserve parity;
   picking one is a Slice 3 call.
7. **Launcher-internal unknowns out of artifact-surface scope (ADR-018).** Exact
   `bc-base` tag/digest, full `docker run` argv/env/mounts, readiness-barrier internals,
   the concrete tmux Escape token, and whether `shop-msg bc-status online` + ADR-014
   heartbeat + E2E launch are currently GREEN — all are Slice 3 empirical inputs
   (`bring-up-bc` flags the path as still-hardening).

---

## Sources

Both legs and their grounding: [01a-target-launch-parity.md](01a-target-launch-parity.md),
[01b-target-loop-workdone.md](01b-target-loop-workdone.md),
[00-fabro-recon.md](00-fabro-recon.md), [00a-fabro-tool.md](00a-fabro-tool.md),
[00b-f6ta-seams.md](00b-f6ta-seams.md), [00c-bcshop-loop.md](00c-bcshop-loop.md),
[plan.md](plan.md); ADR-004/006/010/012/014/018/019/020/021/022/040/043,
PDR-004/010/017/019/020/030.
