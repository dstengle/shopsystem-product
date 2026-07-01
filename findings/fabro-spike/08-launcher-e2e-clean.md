# 08 — CLEAN LIVE END-TO-END: `bc-container launch --orchestrator fabro` on v0.3.46

**Epic** lead-kqgp (fabro launch-path productionization) · **Date** 2026-07-01
· fabro **0.254.0** (497aaba) · bc-container / shopsystem-bc-launcher **0.3.46**
· bc-base `ghcr.io/dstengle/shopsystem-bc-base:latest` = image `d71987b35d58`,
manifest digest `sha256:0dfa8d060709de0a6e16ef153a89d1f8a8edc4b0fbca0aca31aec1ef9642eb8b`.
· THROWAWAY BC `fabro-e2e-clean` / WORK_ID `fabro-clean-1` only; no real infra BC
touched; no outward-facing action (local `file://` origin, local registry entry).

Follow-on to `07-launcher-e2e.md`, which found 4 launcher wiring bugs. This run
re-tests the shipped path after the fixes landed in 0.3.46. **NO manual wiring was
applied before the verdict** — the launch was run exactly as the operator would.

---

## Bottom line — CLEAN-PATH verdict: **PARTIAL**

`bc-container launch fabro-e2e-clean --orchestrator fabro --workspace-mount <tree>`
on 0.3.46 **automatically performs 3 of the 4 fixes and the S3 credential path is
GREEN live** — but **Fix #4 (ephemeral fabro server bootstrap + engage) is still
broken**, so the in-container fabro server never starts, `fabro run` never engages,
and **NO work_done is produced on the automated path.** The launch boots the
container to full parity and places/wires everything up to the engage; the engage
itself fails.

| Fix (from 07) | Automated on 0.3.46? | Evidence |
|---|---|---|
| **#1** def/shim/settings placed on the `--workspace-mount` path | **WORKED** | 15-file def bundle placed at `/workspace/.fabro`; log: *"Placed the self-contained fabro loop def bundle (15 files)… (lead-h2bj)"*. Hoisted out of the clone-only guard, gated on `launch_path==fabro`. |
| **#2** placed `workflow.toml` `BC_NAME`/`WORK_ID` rewritten to launch values | **WORKED** | placed `/workspace/.fabro/workflow.toml` reads `BC_NAME = "fabro-e2e-clean"` / `WORK_ID = "fabro-clean-1"` in **both** `[run.inputs]` and `[run.environment.env]` (NOT the packaged `fabro-throwaway`/`fabro-spike-demo-3`). |
| **#3** `SSL_CERT_FILE` on the shim + engage exec env | **WORKED** | shim listening `127.0.0.1:8788` (pid, `python3`); its `/proc/<pid>/environ` carries `SSL_CERT_FILE=/home/vscode/.config/agent-vault/ca.pem` + `HTTPS_PROXY`. **S3 round-trip 200** (below). |
| **#4** engage bootstraps the server-level config before `fabro server start` / `fabro run` | **FAILED** | engage exited 1: `× non-interactive install requires --github-strategy` **and** `× workflow not found: /workspace/workflow.fabro`. Server never started; loop never ran. |

**S3 credential path — GREEN (live), fully automatic.** `POST
http://127.0.0.1:8788/v1/messages` with a **dummy** `x-api-key` → shim → `HTTPS_PROXY`
→ agent-vault (real OAuth) → **HTTP 200**, body
`…"content":[{"type":"text","text":"PONG"}]…"model":"claude-haiku-4-5-20251001"…`;
shim log `"POST /v1/messages HTTP/1.1" 200`. Fabro vault
`/workspace/.fabro/vaults/default/secrets.json` = `{GITHUB_TOKEN:__PLACEHOLDER__,
ANTHROPIC_API_KEY:__PLACEHOLDER__}`. Invariant #2 verified on the wire — the shim +
SSL fix (#3) makes the credential path work with zero hand-wiring.

---

## The exact launch command (run verbatim, no pre-wiring)

```
bc-container launch fabro-e2e-clean \
  --orchestrator fabro \
  --workspace-mount /home/dstengle/repos/shopsystem-product/.fabro-e2e-scratch/fabro-clean-tree \
  --network shopsystem \
  --shopmsg-dsn postgresql://postgres:postgres@postgres:5432/shopsystem \
  --env-file /workspace/.fabro-e2e-scratch/fabro-clean.env \
  --work-id fabro-clean-1
```

- `--workspace-mount` = a self-contained throwaway tree: `features/demo.feature`
  (`@scenario_hash:4c4c47bc183cd6b1` — the canonical `iter_scenarios`/`scenarios list`
  hash 0.3.46 computes, verified in bc-base), `src/`, `tests/`, a `bd`-init registry,
  and a **local bare origin** `file:///workspace/.origin.git` (`origin/main`
  resolvable). `.fabro` is **untracked + gitignored** so the launcher places it clean.
- The `assign_scenarios` for `fabro-clean-1` was **seeded into the inbox BEFORE launch**
  (`shop-msg send assign_scenarios --bc fabro-e2e-clean …`), so the launcher's own
  foreground engage (`fabro run …`) would have drained it — the fully-automated S5.
- Result: `Started container bc-fabro-e2e-clean` (boots healthy on v0.3.46, full
  credential/env parity) **followed by** `warning: fabro engage failure: … exited 1`.

---

## REMAINING LAUNCHER BUG (for `request_bugfix`) — Fix #4 did not take

The Fix #4 code (`_fabro_engage_script`, `_fabro_server_install_argv` in
`controller.py`) has **three** sub-defects; the engage generated is:

```
cd /workspace/.fabro && fabro install --non-interactive --skip-llm --overwrite-settings && \
  export SSL_CERT_FILE=… && export ANTHROPIC_API_KEY=sk-ant-dummy… && \
  export ANTHROPIC_BASE_URL=http://127.0.0.1:8788/v1 && \
  nohup fabro server start --foreground --no-web >/workspace/.fabro/fabro-server.log 2>&1 &
fabro run workflow.fabro -I BC_NAME=fabro-e2e-clean -I WORK_ID=fabro-clean-1
```

### Defect A — `fabro install` flag contract drifted; server never bootstraps
`fabro install --non-interactive --skip-llm --overwrite-settings` →
`× non-interactive install requires --github-strategy`. fabro 0.254.0's
non-interactive install now **requires** `--github-strategy {token,app}` plus, for
`token`, `--github-username <u>` and a GitHub token available to the `gh` CLI (env
`GH_TOKEN`/`GITHUB_TOKEN`); for `app`, `--github-owner` + app creds. Without
`--skip-llm` it also demands `--llm-provider` + one of
`--llm-api-key-stdin|--llm-api-key-env`, and then validates the key against the LLM
provider. The launcher's argv supplies **none** of these, so install aborts and
`~/.fabro/settings.toml` (`[server.auth] methods`) is never written → `fabro server
start` has nothing to start.

**Empirically-verified working minimal bootstrap** (found by resolving the flag chain
in-container):
```
GH_TOKEN=<any> fabro install --non-interactive --skip-llm --overwrite-settings \
   --github-strategy token --github-username <any>
```
→ writes `~/.fabro/settings.toml` with `[server.auth] methods = ["dev-token"]`, a
session secret, and a dev token; leaves a server on `127.0.0.1:32276`.

### Defect B — trailing `&` backgrounds the whole `cd … &&` list; `fabro run` loses the cwd
`&` binds to the **entire** `cd … && install && … && nohup server` AND-list, so the
`cd /workspace/.fabro` executes **inside the backgrounded subshell** and the parent
shell's cwd stays `/workspace` (the image WORKDIR). The next line `fabro run
workflow.fabro` therefore resolves `/workspace/workflow.fabro` → `× workflow not
found: /workspace/workflow.fabro`. **Independent of Defect A** — even with a working
server, the run would still fail to find the workflow. Isolated repro:
`sh -c "cd /workspace/.fabro && true && nohup sleep 0.1 & \n pwd; ls workflow.fabro"`
printed `/tmp` (not `.fabro`) and `ls: cannot access 'workflow.fabro'`.
**Fix:** only background the server (`( … ) &` around the server line, or `nohup fabro
server start … & ` on its OWN line after the `cd`+install completed synchronously), and
run `fabro run` after an explicit `cd`/absolute-path so the workflow resolves.

### Defect C — the anthropic provider is never registered at the server
Fix #4's docstring promises to *"register the anthropic provider pointed at the shim
base_url"*, but `--skip-llm` **skips** provider registration. Result: even once the
server is up, `fabro model test --model haiku` = `not configured`; only the
**workflow-level** `/workspace/.fabro/settings.toml` carries
`[llm.providers.anthropic] base_url=http://127.0.0.1:8788/v1`, which the server does
not read for `fabro model/run` model resolution. The engage must ALSO register the
provider at the server level (either append `[llm.providers.anthropic]` to
`~/.fabro/settings.toml`, or run install WITHOUT `--skip-llm` but with
`ANTHROPIC_BASE_URL` pointed at the shim so key-validation rides agent-vault → 200 and
the provider registers legitimately).

---

## S5 / S6

- **S5 (automated loop → work_done): NOT REACHED.** The launcher engage failed before
  the loop ran, so `shop-msg read outbox --bc fabro-e2e-clean --work-id fabro-clean-1`
  = *"no outbox response found"* and the seeded `assign_scenarios` is **still pending
  in the inbox** (never drained). No automated `work_done`.
- **S6 (forced reviewer-fail): N/A on the automated path** — the loop never engaged.
  However a **launcher-level fail-closed holds**: the engage failure emitted **NO**
  `work_done(complete)` (outbox empty) — a launcher engage abort never fabricates a
  completion on the wire.
- **Runtime GREEN previously proven** (`05b-rerun.md` §(c)/(d), `07-launcher-e2e.md`
  S5/S6): the ADR-051 loop is the structural sole `work_done` emitter and a forced
  reviewer-fail yields run FAILED with no `complete` on the wire. The def bundle placed
  here is **byte-verbatim** the same asset, so that runtime evidence carries. A clean
  manual re-confirmation on the 0.3.46 image was **inconclusive under exec-based
  reproduction** precisely because fabro 0.254.0's server-bootstrap contract (Defect A)
  has drifted — i.e. the same gap that breaks Fix #4 also blocks a quick by-hand redo.

---

## Invariant checks (all HELD)

| Invariant | Status | Evidence |
|---|---|---|
| Fabro in-container ONLY | HELD | every fabro process (shim, server, run) inside `bc-fabro-e2e-clean`; nothing orchestrated on the lead host. |
| agent-vault sole cred; fabro vault `__PLACEHOLDER__` | HELD (live) | S3 `200` via shim→HTTPS_PROXY→agent-vault; fabro vault `secrets.json` = `__PLACEHOLDER__`-only; only a DUMMY `ANTHROPIC_API_KEY` ever in fabro's env. |
| launch-interface parity (bc-container) | HELD | boots on v0.3.46 `sha256:0dfa8d06`; env parity `AGENT_VAULT_*`, `HTTPS_PROXY`, CA/`SSL_CERT_FILE`, `SHOPMSG_DSN`; same readiness barriers; only the engage tier fails. |
| shop-msg protocol preserved | HELD | `assign_scenarios` seeded + inbox/outbox inspected via `shop-msg`; no false `work_done` produced. |
| tmux default unchanged | HELD | fabro wiring gated on `launch_path==LAUNCH_PATH_FABRO`; `--orchestrator` default `tmux`; no tmux `agent` / no `claude` on the fabro path. |

---

## needs_david

**Product decision:** route Fix #4 completion to `shopsystem-bc-launcher` as a
follow-up `request_bugfix`. Fixes #1/#2/#3 landed and the S3 credential path is GREEN
automatically; the remaining gap is the ephemeral-server engage (Defect A install-flag
drift, Defect B `&` cwd-scoping, Defect C provider-not-registered), which fully blocks
an automated fabro-orchestrated launch from reaching `work_done`.
