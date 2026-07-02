# 10 — FINAL CLEAN END-TO-END: `bc-container launch --orchestrator fabro` on v0.3.48

**Epic** lead-6k1r (fabro launch-path productionization) · **Date** 2026-07-02
· fabro **0.254.0** (497aaba) · bc-container / shopsystem-bc-launcher **0.3.48**
· bc-base `ghcr.io/dstengle/shopsystem-bc-base:latest` = image digest
**`sha256:40ce05207fad9db8791121237e99f834cb47e37f7c735edad86cbd908c9d679c`**,
label `org.opencontainers.image.version=v0.3.48` (fabro 0.254.0, bc-launcher
0.3.48 baked). THROWAWAY BC `fabro-e2e-final`; work_ids `fabro-final-1` (S5
automatic), `fabro-final-2` (S5 haiku full-path), `fabro-final-s6` (S6). No real
infra BC touched; no outward-facing action (local `file://` origin, local
registry entry). Follow-on to `09-launcher-e2e-v0347.md`.

**NO manual wiring was applied before the automated verdict.** The launch was run
exactly as an operator would; it succeeded end-to-end and emitted a valid
work_done with ZERO hand-wiring. A second, clearly-labelled controlled run then
overrode ONLY the loop's model stylesheet (haiku everywhere) to bypass the
EXTERNAL sonnet-4-5 rate-limit and exercise the full happy-path loop — an
authorized model override on the *placed throwaway def*, not on the launcher's
baked BC source.

---

## FINAL verdict: **GREEN for the launcher** — fully automatic launch → VALID work_done, NO hand-wiring. Defect D FIXED.

`bc-container launch fabro-e2e-final --orchestrator fabro --workspace-mount <tree>`
on v0.3.48 **boots, wires, and engages the fabro loop fully automatically and
emits a VALID work_done — with zero manual intervention.** The v0.3.47 blocker
**Defect D is FIXED**: the engage now exports `ANTHROPIC_API_KEY` +
`SSL_CERT_FILE` + `ANTHROPIC_BASE_URL` **before** `fabro install`, so the
install-spawned serving daemon (pid 277) inherits the dummy key; `fabro run`
preflight **passes** (no more `No LLM providers configured`) and the loop
executes to a gated `emit_*`.

**`status=complete` was NOT reached — for two independent NON-launcher reasons**
(captured precisely below, not papered over):
1. **Automatic path (`fabro-final-1`)** → `blocked`: the shipped def's `classify`
   node is `class="coding"` → **`claude-sonnet-4-5`**, which hit **`Rate limited
   by anthropic`** (429) across 3 retries — the same EXTERNAL agent-vault-account
   rate-limit as v0.3.47. Loop correctly took its failsafe edge `classify →
   emit_blk`.
2. **Haiku full-path (`fabro-final-2`)** → `blocked`: with a haiku-only stylesheet
   the loop ran the **ENTIRE happy path** (classify→suff→worktree→plan→impl→
   redgate→integ→review), the LLM **reviewer SIGNED OFF**, but the **deterministic
   `work-done-gate (3 checks)` fail-closed** because the *deliverable* did not
   satisfy its structural checks — NOT a launcher defect. This is the anti-collapse
   gate working correctly (see below).

By the stated GREEN criterion ("fully automatic launch → valid work_done, NO
hand-wiring") the **launcher is GREEN**. The `complete` happy-path is gated by the
loop-def's own deliverable checks / an external rate-limit, both outside the
launch mechanism.

| Engage fix | Automatic on 0.3.48? | Evidence |
|---|---|---|
| #1 def/shim/settings placed on `--workspace-mount` | WORKED | "Placed the self-contained fabro loop def bundle (15 files) into /workspace/.fabro" |
| #2 workflow.toml BC_NAME/WORK_ID = launch values | WORKED | "Rewrote … BC_NAME=fabro-e2e-final WORK_ID=fabro-final-1" |
| #3 SSL_CERT_FILE on shim + engage | WORKED | shim 127.0.0.1:8788; **S3 200** below |
| #4A install-flag drift | FIXED | install clean, "Server running at http://127.0.0.1:32276" |
| #4B `&` cwd-scoping | FIXED | `fabro run` resolved workflow.fabro: "BcShopLoop (23 nodes, 45 edges)" |
| #4C provider registered at server settings | WORKED | settings.toml `[llm.providers.anthropic] base_url=…:8788/v1 adapter=anthropic`, no api_key |
| **#4D executing server carries the key** | **FIXED** | **`/proc/277/environ` of `fabro server tcp:127.0.0.1:32276` carries `ANTHROPIC_API_KEY`(dummy) + `ANTHROPIC_BASE_URL=…:8788/v1` + `SSL_CERT_FILE`; preflight PASSED, loop ran.** |

**Exact launch command (run verbatim, no pre-wiring):**
```
bc-container launch fabro-e2e-final \
  --orchestrator fabro \
  --workspace-mount /home/dstengle/repos/shopsystem-product/.fabro-e2e-scratch/fabro-final-tree \
  --network shopsystem \
  --shopmsg-dsn postgresql://postgres:postgres@postgres:5432/shopsystem \
  --env-file /workspace/.fabro-e2e-scratch/fabro-final.env \
  --work-id fabro-final-1
```
(`--workspace-mount` is the HOST-equivalent of the lead's
`/workspace/.fabro-e2e-scratch/fabro-final-tree`; the lead runs inside
`bc-shopsystem-lead`, `/workspace` ← host `/home/dstengle/repos/shopsystem-product`.)
Tree = throwaway `features/demo.feature` (`@scenario_hash:eff9384fadc9d08b`,
verified via installed `scenarios list`), `src/`, `tests/`, a fresh `bd` registry,
local bare origin `file:///workspace/.origin.git` (`origin/main` resolvable
in-container). The `assign_scenarios` for `fabro-final-1` was seeded into the
inbox BEFORE launch (via `shop-msg send`) so the launcher's own foreground engage
drained it — the fully-automatic S5. Launch **exited 0 with NO engage-failure
warning** (contrast v0.3.47's `No LLM providers configured`).

---

## Defect D — FIXED (empirically pinned in-container)

The engage script (`controller.py::_fabro_engage_script`) now emits, in order:
```
cd /workspace/.fabro && \
  export SSL_CERT_FILE=/home/vscode/.config/agent-vault/ca.pem && \
  export ANTHROPIC_API_KEY=<dummy> && \
  export ANTHROPIC_BASE_URL=http://127.0.0.1:8788/v1 && \
  GH_TOKEN=<dummy> fabro install … --github-strategy token --github-username <dummy> && \
  <provider-register> && \
  { nohup fabro server start --foreground --no-web >…/fabro-server.log 2>&1 & } && \
  fabro run workflow.fabro -I BC_NAME=… -I WORK_ID=…
```
The three exports now precede `fabro install`, so the daemon `fabro install`
spawns (`fabro server tcp:127.0.0.1:32276`, pid **277**) inherits the key. Verified
`/proc/277/environ` carries `ANTHROPIC_API_KEY`(dummy)+`ANTHROPIC_BASE_URL`(shim)
+`SSL_CERT_FILE`(CA). The retained post-install `fabro server start` is the
harmless "× Server already running (pid 277)" no-op (kept to satisfy scenario 77's
argv pin, per the code comment). ADR-049 D1 intact: only a DUMMY key in env; fabro
vault + settings stay `__PLACEHOLDER__` (no api_key in TOML).

---

## S5 — the loop → work_done

### S5a — FULLY AUTOMATIC (fabro-final-1), status **blocked** (external sonnet 429)
The launcher's own foreground engage ran the loop to completion. Run
`01KWG6P1XNBVRP1VT88DK98MRD`: Start→prime→health→arm(drain inbox)→armed(read the
seeded assign_scenarios)→**classify** — where `server.log` shows
`model="claude-sonnet-4-5"` then `Rate limited by anthropic: Error` (3 retries,
`will_retry=false`) → failsafe edge `classify → emit_blk` → REPORTED → Exit
SUCCEEDED. Read back:
```
$ shop-msg read outbox --bc fabro-e2e-final --work-id fabro-final-1
message_type: work_done
work_id: fabro-final-1
status: blocked
summary: a deliverable-side gate or step failed …; reporting blocked, never a silent complete
scenario_hashes: []
```
VALID, schema-clean, emitted via the native emitter — with **zero hand-wiring**.
The sonnet-4-5 429 is an EXTERNAL account-level rate-limit on the shared
agent-vault credential (haiku was 200 throughout, e.g. S3), NOT a launcher defect.

### S5b — HAIKU full-path (fabro-final-2), status **blocked** (work-done-gate fail-closed)
Controlled labelled run to bypass the sonnet 429: overrode ONLY the placed
throwaway def's stylesheet to
`* { model: claude-haiku-4-5 } .coding { … haiku } .review { … haiku }` (on the
workspace-mount tree's `.fabro/workflow.fabro`, NOT the launcher's baked asset),
reseeded a fresh `fabro-final-2`, aligned the placed `workflow.toml`
`[run.environment.env] WORK_ID`, and re-ran `fabro run` against the same
already-keyed server (pid 277). Run `01KWG6WJXJ8AE00ZMM8ZF4S21F` (408 s wall)
executed the **entire happy path on haiku**, every LLM call 200 via
shim→agent-vault:
```
✓ Start ✓ prime ✓ work-tracker health gate ✓ arm(drain inbox) ✓ armed(read msg)
✓ classify → suff [label=scenario] ✓ suff → worktree [label=proceed]
✓ worktree ✓ plan ✓ impl (bc-implementer parallel fan-out — real TDD)
✓ redgate (RED-before-GREEN) ✓ integ (integrating-to-main — pushed real commits)
✓ review (bc-reviewer)  → [label=signoff]
✗ wdg_r  work-done-gate (3 checks): Script failed exit 1  → emit_blk  (fail-closed)
```
The impl subagent produced REAL work — origin/main now carries
`3f9fe1c test(red): demo greeting behavior`, `0d1915f feat(green): demo greeting
behavior`, `55787ac fix: correct scenario hash…`. The LLM **reviewer signed off**,
but `src/greeting.py` is a **stub** (`def greeting(): pass`) that does not return
`"hello-fabro-e2e"`, so the deliverable genuinely does not satisfy the scenario.
The **deterministic `wdg_r` gate re-ran its checks in the integrated worktree and
fail-closed** on two of them:
- porcelain: `M features/demo.feature`, `M src/greeting.py` — **uncommitted staged
  changes** in the worktree at gate time; and
- `git log origin/main --grep <WORK_ID>` — **no origin/main commit references
  `fabro-final-2`** (the impl subagent's commit messages don't embed the work_id).

`wdg_r → emit_blk` → VALID `work_done(blocked)` for `fabro-final-2`. **This is the
anti-collapse gate working exactly as designed: even a haiku reviewer that
over-approved a stub could NOT produce a false `complete`, because the native
work-done-gate is the real barrier and it refused.** Defense-in-depth demonstrated.

**Why no `complete` in-window:** the gate's `WORK_ID-in-an-origin/main-commit`
requirement is not something a generic implementer subagent satisfies by default,
so retrying would deterministically block again — spinning avoided per the brief.
`complete` is reachable only when the deliverable both (a) leaves a clean worktree
and (b) lands a WORK_ID-referencing commit on origin/main; neither is a launch
concern. (The loop machinery to `complete` was independently green in `05b`/`07`.)

---

## S6 — forced reviewer-fail — **fail-closed HELD (GREEN)**
Placed the spike's `workflow-forcefail.fabro` (native `review` script `exit 1`,
haiku-only) + a matching local-sandbox `workflow-forcefail.toml` into the tree's
`.fabro`; ran `fabro run workflow-forcefail.toml -I …WORK_ID=fabro-final-s6`
against the same in-container server. Run `01KWG7E5G6QCYQVAZDSA5VM3T3`:
```
✓ Start
✗ FORCED reviewer failure (outcome=failed)     # review → halt [condition=outcome=failed]
✗ HALTED / FAILED (terminal sink)
=== Run Result === Status: FAILED
```
`emit_r` (the SOLE `work_done(complete)` emitter) was **structurally unreachable**
on the fail path. Assertion: `shop-msg read outbox --bc fabro-e2e-final --work-id
fabro-final-s6` → **"no outbox response found"** → **ZERO** `work_done(complete)`
on the wire. Anti-collapse edge holds: a FAILED node never advances to the
complete-emitter.

---

## S3 credential path — GREEN (live), fully automatic
`POST http://127.0.0.1:8788/v1/messages` (shim started BY THE LAUNCHER) with a
**dummy** `x-api-key: sk-ant-dummy-agent-vault-rides-the-wire` → shim → HTTPS_PROXY
→ agent-vault (real OAuth) → **HTTP 200**, body
`…"content":[{"type":"text","text":"PONG"}]…"model":"claude-haiku-4-5-20251001"…`.
Fabro vault `/workspace/.fabro/vaults/default/secrets.json` = `{GITHUB_TOKEN,
ANTHROPIC_API_KEY}` both `__PLACEHOLDER__`. `settings.toml` carries no `api_key`.
Zero hand-wiring.

---

## Invariant checks (all 5 HELD)

| Invariant | Status | Evidence |
|---|---|---|
| Fabro in-container ONLY | HELD | shim + server (pid 277) + every `fabro run` inside `bc-fabro-e2e-final`; nothing orchestrated on the lead host. |
| agent-vault sole cred; fabro vault `__PLACEHOLDER__` | HELD (live) | S3 200 via shim→HTTPS_PROXY→agent-vault; `secrets.json` both `__PLACEHOLDER__`; only a DUMMY key ever in fabro's env (`/proc/277/environ`). |
| launch-interface parity (bc-container) | HELD | boots on v0.3.48 image `sha256:40ce05207fad` (label v0.3.48); env parity `AGENT_VAULT_ADDR/TOKEN`, `HTTPS_PROXY`, `SSL_CERT_FILE`, `SHOPMSG_DSN`. |
| shop-msg protocol preserved | HELD | `assign_scenarios` seeded + `work_done` emitted/read via `shop-msg`; no false `work_done`; S6 → zero rows. |
| tmux default unchanged | HELD | `--orchestrator fabro` started NO tmux `agent` / NO `claude` (`ps` confirms absent); tmux remains the default. |

---

## Residual (non-launcher)

1. **External:** the shipped loop def's `classify`/`review` are `class="coding"`/
   `"review"` → **`claude-sonnet-4-5`**; whenever that model is account-rate-limited
   (429), the AUTOMATIC path blocks at `classify`. Observation for the loop-def
   owner (not the launch mechanism): consider haiku (or a retry/fallback) for the
   judgment nodes so the automatic path is resilient to sonnet 429. The launch
   mechanism itself is model-agnostic and GREEN.
2. **Loop-def / deliverable:** `complete` requires the deliverable to (a) leave a
   clean worktree and (b) land a `WORK_ID`-referencing commit on origin/main. A
   trivial throwaway scenario + a generic implementer subagent does not satisfy
   these, so the work-done-gate correctly fail-closes to `blocked`. This is
   anti-collapse integrity, not a bug.

**No remaining launcher bug.** All four engage fixes (A/B/C/D) are shipped and
automatic on v0.3.48; the fully-automatic launch → valid work_done path is closed
with zero hand-wiring.
