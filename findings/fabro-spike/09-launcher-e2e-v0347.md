# 09 — CLEAN LIVE END-TO-END: `bc-container launch --orchestrator fabro` on v0.3.47

**Epic** lead-kqgp (fabro launch-path productionization) · **Date** 2026-07-02
· fabro **0.254.0** (497aaba) · bc-container / shopsystem-bc-launcher **0.3.47**
· bc-base `ghcr.io/dstengle/shopsystem-bc-base:latest` = image `94e6a72a157e`,
manifest digest **`sha256:a54c6a19537ff7df082fc521d95557415d16b38a8c64a14acf12bdc0fda33669`**.
· THROWAWAY BC `fabro-e2e-clean3` / WORK_ID `fabro-clean3-1` (S5) + `fabro-clean3-s6`
(S6) only; no real infra BC touched; no outward-facing action (local `file://`
origin, local registry entry). Follow-on to `08-launcher-e2e-clean.md` (v0.3.46).

**NO manual wiring was applied before the automated verdict.** The launch was run
exactly as an operator would. A single by-hand runtime reproduction followed
(authorized) to isolate the remaining defect and confirm the loop runtime — clearly
labelled below.

---

## Bottom line — CLEAN-PATH verdict: **PARTIAL** (one NEW launcher defect: `D`)

`bc-container launch fabro-e2e-clean3 --orchestrator fabro --workspace-mount <tree>`
on v0.3.47 now **automatically clears the 3 sub-defects that broke Fix #4 on v0.3.46**
(A install-flag drift, B `&` cwd-scoping, C provider block written) **AND the S3
credential path is GREEN live** — but a **NEW fourth defect (`D`)** blocks the
automated path at the LLM-provider preflight: the ephemeral server that actually
executes `fabro run` is the one `fabro install` spawns as a side effect **before**
the engage exports `ANTHROPIC_API_KEY`, so that server has **no** LLM key in its
environment; the engage's own keyed `fabro server start` then can't bind (port already
taken) and is a no-op. `fabro run` therefore fails preflight
`Precondition failed: No LLM providers configured. Set ANTHROPIC_API_KEY or
OPENAI_API_KEY` → run **FAILED** → **NO work_done on the automated path.**

The container boots to full parity, places/wires everything, bootstraps + starts the
server, and `fabro run` **loads and enters the 23-node loop** — it fails one step
later than v0.3.46 (provider preflight, not install / not "workflow not found").

| Fix (from 07/08) | Automated on 0.3.47? | Evidence |
|---|---|---|
| **#1** def/shim/settings placed on the `--workspace-mount` path | **WORKED** | *"Placed the self-contained fabro loop def bundle (15 files) into /workspace/.fabro"*; chowned to vscode. |
| **#2** placed `workflow.toml` `BC_NAME`/`WORK_ID` = launch values | **WORKED** | *"Rewrote … [run.environment.env] / [run.inputs] BC_NAME=fabro-e2e-clean3 WORK_ID=fabro-clean3-1"*. |
| **#3** `SSL_CERT_FILE` on shim + engage env | **WORKED** | shim `127.0.0.1:8788` (pid 76); **S3 round-trip 200** (below). |
| **#4A** install-flag drift (`--github-strategy token --github-username` + GH_TOKEN) | **FIXED** | install ran clean: *"✔ GitHub token configured … ✔ Wrote ~/.fabro/settings.toml … ✔ Server running at http://127.0.0.1:32276"*. No `requires --github-strategy`. |
| **#4B** `&` cwd-scoping (`fabro run` finds the workflow) | **FIXED** | `fabro run` resolved `/workspace/.fabro/workflow.fabro`: *"Workflow: BcShopLoop (23 nodes, 45 edges)"*. No `workflow not found`. |
| **#4C** provider registered at server settings | **WORKED (written)** | `~/.fabro/settings.toml` in-container carries `[llm.providers.anthropic] adapter="anthropic" base_url="http://127.0.0.1:8788/v1"` (schema-valid, no `api_key`). `fabro validate`-clean. |
| **#4D** *(NEW)* the executing server carries the LLM key | **FAILED** | see "REMAINING LAUNCHER BUG" — install-spawned server (pid 279) has no `ANTHROPIC_API_KEY`; preflight `No LLM providers configured` → run FAILED. |

**The exact launch command (run verbatim, no pre-wiring):**
```
bc-container launch fabro-e2e-clean3 \
  --orchestrator fabro \
  --workspace-mount /home/dstengle/repos/shopsystem-product/.fabro-e2e-scratch/fabro-clean3-tree \
  --network shopsystem \
  --shopmsg-dsn postgresql://postgres:postgres@postgres:5432/shopsystem \
  --env-file /workspace/.fabro-e2e-scratch/fabro-clean3.env \
  --work-id fabro-clean3-1
```
(`--workspace-mount` is the HOST-equivalent of `/workspace/.fabro-e2e-scratch/fabro-clean3-tree`;
this lead runs inside `bc-shopsystem-lead`, `/workspace` ← host
`/home/dstengle/repos/shopsystem-product`.) Tree = throwaway `features/demo.feature`
(`@scenario_hash:4c4c47bc183cd6b1`, verified by the installed `scenarios list`), `src/`,
`tests/`, a `bd` registry, and a local bare origin `file:///workspace/.origin.git`
(`origin/main` resolvable in-container). `.fabro` is gitignored so the launcher places
it clean. The `assign_scenarios` for `fabro-clean3-1` was seeded into the inbox BEFORE
launch (via `shop-msg send`) so the launcher's own foreground engage would drain it —
the fully-automated S5. Launch stderr: *"warning: fabro engage failure: `fabro server
start` / `fabro run workflow.fabro` exited 1: … Precondition failed: No LLM providers
configured …"*.

---

## Does the fabro server boot + does `fabro run` engage automatically? — YES (both)

On v0.3.47 the launcher's engage **does** bootstrap and start the ephemeral fabro
server and **does** engage `fabro run`:
- **Server boots automatically.** `fabro install --non-interactive --skip-llm
  --overwrite-settings --github-strategy token --github-username <dummy>` (GH_TOKEN
  inline) succeeds and leaves a server on `127.0.0.1:32276`. No
  `requires --github-strategy`, no `server.auth.methods required`, no settings parse
  error. (`[server.auth] methods = ["dev-token"]` written.)
- **`fabro run` engages automatically from the right cwd.** It resolves
  `/workspace/.fabro/workflow.fabro`, prints `Workflow: BcShopLoop (23 nodes, 45
  edges)`, and STARTS a run (Run `01KWG2K5M2P9WZCPV6Q79XRT1F`). No "workflow not found".
- **But the run FAILS at provider preflight** — Defect D — so no loop node executes.

---

## REMAINING LAUNCHER BUG (Defect D) — for a `request_bugfix` to shopsystem-bc-launcher

**Symptom (automated path).** `fabro run` → `=== Run Result === Status: FAILED …
Failure: Precondition failed: No LLM providers configured. Set ANTHROPIC_API_KEY or
OPENAI_API_KEY, or pass --dry-run to simulate.`

**Root cause (empirically pinned in-container).** The engage script
(`_fabro_engage_script`, controller.py ~L812) is:
```
cd /workspace/.fabro && GH_TOKEN=<dummy> fabro install … --github-strategy token --github-username <dummy> && \
  printf … '[llm.providers.anthropic] …' >> ~/.fabro/settings.toml && \
  export SSL_CERT_FILE=… && export ANTHROPIC_API_KEY=sk-ant-dummy-… && export ANTHROPIC_BASE_URL=…/v1 && \
  { nohup fabro server start --foreground --no-web >…/fabro-server.log 2>&1 & } && \
  fabro run workflow.fabro -I BC_NAME=… -I WORK_ID=…
```
The **first** command, `fabro install`, **starts a persistent server daemon as a side
effect** — `fabro server tcp:127.0.0.1:32276` (observed pid **279**) — *before* the
`export ANTHROPIC_API_KEY`. That server therefore has **HTTPS_PROXY + SSL_CERT_FILE but
NO ANTHROPIC_API_KEY** in `/proc/279/environ`. The engage's own
`{ nohup fabro server start … & }` (which *would* inherit the exported key) then
**fails to bind** — `fabro-server.log` = `× Server already running (pid 279) on
127.0.0.1:32276` — so the keyed server never runs. `fabro run` targets
`cli.target = http://127.0.0.1:32276` (= pid 279), whose preflight checks for
`ANTHROPIC_API_KEY`/`OPENAI_API_KEY` in the SERVER's env, finds neither, and fails.
The `[llm.providers.anthropic]` block (Fix C) is present in the settings but carries
**no `api_key`** (schema forbids it — correct per ADR-049), so the settings alone do
NOT satisfy the preflight; the key MUST be in the executing server's environment, and
it is not.

So Fix C wrote the provider *config* but the key never reaches the server that serves
the run — the ordering / server-identity is wrong.

**Verified minimal fix (proven by the by-hand reproduction below).** The server
process that `fabro run` targets must carry `ANTHROPIC_API_KEY` in its environment.
Either:
- **(preferred)** move `export SSL_CERT_FILE / ANTHROPIC_API_KEY / ANTHROPIC_BASE_URL`
  to **before** `fabro install`, so the install-spawned 32276 server inherits the key,
  and drop the now-redundant second `fabro server start` (it only ever collides on the
  port); **or**
- explicitly stop the install-spawned server and start the engage's own keyed
  `fabro server start` (free the port first).

The exact same schema-valid settings block + dummy `ANTHROPIC_API_KEY` env is correct;
only *which process holds the env* is wrong.

---

## By-hand runtime reproduction (Defect D isolated; ONE run) — loop runtime CONFIRMED

To prove Defect D is the *sole* remaining blocker, the ONLY change applied: kill the
install-spawned server and restart `fabro server start --foreground --no-web` **with**
`ANTHROPIC_API_KEY=sk-ant-dummy-agent-vault-rides-the-wire` + `SSL_CERT_FILE` +
`ANTHROPIC_BASE_URL` in its env (pid 744, verified in `/proc/744/environ`). Then the
launcher's exact `fabro run workflow.fabro -I BC_NAME=fabro-e2e-clean3 -I
WORK_ID=fabro-clean3-1`:
```
Sandbox: local (ready in 0ms)
✓ Start   ✓ prime   ✓ work-tracker health gate
✓ arm: drain inbox (reachability)   ✓ armed: message present? read it
✗ bc-router classify   Error: LLM error: Rate limited by anthropic: Error
✓ emit work_done BLOCKED (named evidence)   ✓ REPORTED   ✓ Exit: SUCCEEDED
```
The provider preflight **passed** (no "No LLM providers configured") — Defect D is the
sole automated-path blocker. The loop engaged end-to-end: consumed the seeded
`assign_scenarios` from the inbox, ran the haiku judgment nodes through the shim →
agent-vault (real 200s), reached the **sole emitter** and emitted a **VALID work_done**
via `emit_r`.

### S5 (loop → work_done) — VALID work_done emitted; status **blocked** (not complete)
```
$ shop-msg read outbox --bc fabro-e2e-clean3 --work-id fabro-clean3-1
valid work_done from fabro-clean3-1:
message_type: work_done
work_id: fabro-clean3-1
status: blocked
summary: a deliverable-side gate or step failed (see run context); reporting blocked, never a silent complete
scenario_hashes: []
```
The work_done is schema-VALID and emitted by `emit_r` (sole emitter). It is `blocked`
rather than `complete` because the `classify` node — class `coding` → model
**`claude-sonnet-4-5`** — hit an **anthropic 429 rate-limit** (an EXTERNAL, transient
account-level condition on the shared agent-vault credential; `claude-haiku-4-5` was
200 throughout, e.g. S3). The loop correctly took its **failsafe edge** (LLM node
failed → `emit_blk`), never fabricating a `complete`. A clean `status: complete`
requires `claude-sonnet-4-5` to clear the 429; direct `POST …/v1/messages`
`model=claude-sonnet-4-5` returned **429** persistently across a >10-min poll, so the
`complete` outcome was **not obtainable in-window** — a rate-limit constraint, NOT a
launcher/loop defect. The loop machinery to `complete` is otherwise fully exercised and
was independently GREEN in `05b`/`07`.

### S6 (forced reviewer-fail) — **fail-closed HELD (GREEN)**
Ran the spike's `workflow-forcefail.fabro` (native `review` script `exit 1`,
haiku-only — independent of the sonnet 429) against the same in-container server, with
a matching local-sandbox `workflow-forcefail.toml`, work_id `fabro-clean3-s6`:
```
✓ Start
✗ FORCED reviewer failure (outcome=failed)      # review -> halt [outcome=failed]
✗ HALTED / FAILED (terminal sink)
=== Run Result === Status: FAILED
```
`emit_r` (the sole `work_done(complete)` emitter) was **structurally unreachable** on
the fail path. DB check: **zero** `work_done` rows for `fabro-clean3-s6` → NO
`work_done(complete)` on the wire. Anti-collapse edge holds: a FAILED node never
advances to the complete-emitter.

---

## S3 credential path — GREEN (live), fully automatic

`POST http://127.0.0.1:8788/v1/messages` (shim started BY THE LAUNCHER) with a **dummy**
`x-api-key: sk-ant-dummy-agent-vault-rides-the-wire` → shim → `HTTPS_PROXY` →
agent-vault (real OAuth) → **HTTP 200**, body
`…"content":[{"type":"text","text":"PONG"}]…"model":"claude-haiku-4-5-20251001"…`.
Fabro vault `/workspace/.fabro/vaults/default/secrets.json` = `{GITHUB_TOKEN,
ANTHROPIC_API_KEY}` both `__PLACEHOLDER__`. Invariant #2 verified on the wire; zero
hand-wiring.

---

## Invariant checks (all 5 HELD)

| Invariant | Status | Evidence |
|---|---|---|
| Fabro in-container ONLY | HELD | shim (pid 76), server (pid 744), every `fabro run` inside `bc-fabro-e2e-clean3`; nothing orchestrated on the lead host. |
| agent-vault sole cred; fabro vault `__PLACEHOLDER__` | HELD (live) | S3 200 via shim→HTTPS_PROXY→agent-vault; `secrets.json` GITHUB_TOKEN+ANTHROPIC_API_KEY both `__PLACEHOLDER__`; only a DUMMY `ANTHROPIC_API_KEY` ever in fabro's env. |
| launch-interface parity (bc-container) | HELD | boots on v0.3.47 image `94e6a72a157e` = `sha256:a54c6a19`; env parity `AGENT_VAULT_ADDR/TOKEN`, `HTTPS_PROXY`, `SSL_CERT_FILE`, `SHOPMSG_DSN`; same readiness barriers. |
| shop-msg protocol preserved | HELD | `assign_scenarios` seeded + `work_done` emitted/read via `shop-msg`; no false `work_done`. |
| tmux default unchanged | HELD | `--orchestrator fabro` path started NO tmux `agent` / NO `claude` (`ps` confirms absent); tmux remains the default orchestrator. |

---

## needs_david

**Product decision:** route **Defect D** to `shopsystem-bc-launcher` as a follow-up
`request_bugfix` (capability exists but the engage server-env ordering is unpinned).
Fixes #1/#2/#3 and Fix#4 sub-defects A/B/C landed and are automatic on v0.3.47; the
remaining gap is a **one-line ordering fix** in `_fabro_engage_script`: export
`ANTHROPIC_API_KEY` (and `SSL_CERT_FILE`/`ANTHROPIC_BASE_URL`) **before** `fabro
install` (which starts the serving daemon), and drop the redundant post-install `fabro
server start` that only collides on the port. With that, the install-spawned 32276
server carries the key, the provider preflight passes, and the automated launch →
`work_done` path closes (runtime already proven above once the key reaches the serving
process). Independently: the sonnet-4-5 429 that forced S5 to `blocked` is an external
agent-vault-account rate limit, not in scope for the launcher.
