# 07 — LIVE END-TO-END: `bc-container launch --orchestrator fabro`

**Epic** lead-kqgp (fabro launch-path productionization) · **Date** 2026-07-01
· fabro v0.254.0 · bc-launcher **v0.3.45** · bc-base **v0.3.45**
(`ghcr.io/dstengle/shopsystem-bc-base:latest` = image `539cb42de838`,
manifest digest `sha256:4a4d29930f1231e6a9fde9be9d26cde274cfe727bb03f25c57b525bd13ba45f4`).
· THROWAWAY BC `fabro-e2e` only; no real infra BC touched; no outward-facing action.

---

## Bottom line — verdict

**END-TO-END via the shipped `bc-container launch … --orchestrator fabro` on the
in-scope (workspace-mount) path: BLOCKED by launcher bugs.** The launch **boots the
container to full parity** (correct v0.3.45 image, agent-vault creds, HTTPS_PROXY,
CA, SHOPMSG_DSN, mounted tree, healthy) but the **fabro orchestration never comes
up on its own** — three independent launcher defects each block it (see §Bugs).

**Fabro RUNTIME in the launched container: GREEN.** Once the launcher's OWN
packaged wiring is applied (def/shim/settings placed by the launcher's exact
scripts) and the three launcher gaps are worked around, the in-container fabro
server runs the ADR-051 loop with **full fidelity** and:

- **S3 credential path — GREEN (live):** a fabro/shim LLM call goes dummy
  `x-api-key` → anthropic-oauth-shim (strips it, adds OAuth Bearer +
  `anthropic-beta`) → `HTTPS_PROXY` → agent-vault (real OAuth) → `200`, with
  fabro's vault holding only `__PLACEHOLDER__`. Invariant #2 verified on the wire.
- **S5 loop→work_done — GREEN:** _(payload below)_
- **S6 forced reviewer-fail — GREEN (fail-closed):** _(below)_

All five hard invariants held. **needs_david: product decision only** — whether to
route the three launcher bugs to shopsystem-bc-launcher as `request_bugfix` (they
are real and each independently blocks a fabro-orchestrated launch).

---

## Launch command used

```
bc-container launch fabro-e2e \
  --orchestrator fabro \
  --workspace-mount /home/dstengle/repos/shopsystem-product/.fabro-e2e-scratch/fabro-e2e-tree \
  --network shopsystem \
  --shopmsg-dsn postgresql://postgres:postgres@postgres:5432/shopsystem \
  --env-file <AGENT_VAULT_ADDR/TOKEN/VAULT/CA_PEM> \
  --work-id fabro-e2e-1
```

- `--workspace-mount` is the **in-scope** choice for a throwaway: it SKIPS the
  clone and ALL clone-path provisioning (the outward beads-remote push, shop-templates
  pour), so no outward-facing action is taken. The mount is a self-contained tree with
  `features/demo.feature` (`@scenario_hash:eff9384fadc9d08b`), `src/`, a `bd init`
  registry, and a **local bare origin** (`file:///workspace/.origin.git`, `origin/main`
  resolvable) so the loop's worktree/integrate/gate nodes have real, fully-local ground.
- Result: `Started container bc-fabro-e2e` (exit 0) — container boots healthy on
  v0.3.45 with all credential/env parity — **followed immediately by**
  `warning: fabro engage failure … cd: can't cd to /workspace/.fabro … workflow not
  found: /workspace/workflow.fabro`.

---

## Launcher bugs found (each independently blocks a fabro-orchestrated launch)

### BUG #1 — `--orchestrator fabro` + `--workspace-mount`: fabro def/shim/settings NEVER placed
The fabro provisioning (def-bundle placement, shim start, effective-settings write)
lives **inside the `if repo_url and not workspace_mount:` clone-provisioning guard**
(`controller.py` ~L1815 → def placement L2227, shim/settings L2291). On the
workspace-mount path that whole block is skipped, yet `_start_agent_session` **still
runs the fabro engage** (`cd /workspace/.fabro && fabro server start … && fabro run
workflow.fabro …`) which fails because `.fabro` was never created. So the ONLY
in-scope launch path for a throwaway (workspace-mount, which deliberately skips the
outward provisioning) is exactly the path where the fabro wiring is dead. **The fabro
def/shim/settings placement must move OUT of the clone-only guard and run on both the
clone and workspace-mount paths (it is a `/workspace/.fabro` write independent of the
repo source).**

### BUG #2 — placed `workflow.toml` hardcodes `BC_NAME`/`WORK_ID`; `-I` doesn't reach native nodes
The launcher places the packaged `workflow.toml` **byte-verbatim**; its
`[run.environment.env]` (and `[run.inputs]`) hardcode `BC_NAME = "fabro-throwaway"`
/ `WORK_ID = "fabro-spike-demo-3"`. The ADR-051 loop's **native `script=` nodes read
`$BC_NAME`/`$WORK_ID` from that overlay** — the drain (`arm`/`armed`), `worktree`,
`integ`, `wdg_r`, and the **sole emitter `emit_r`** all use it. The launcher passes
the real values ONLY via `fabro run … -I BC_NAME=<bc> -I WORK_ID=<id>`, which (per the
def's own documentation, empirically pinned in Slice 5) overrides **only
`[run.inputs]` for agent PROMPTS via minijinja — NOT the native command sandbox env.**
Net: on the shipped path the mailbox/worktree/emit nodes operate on
`fabro-throwaway`/`fabro-spike-demo-3` regardless of the launched BC name and
`--work-id`. **The launcher must rewrite the placed `workflow.toml`
`[run.environment.env]` `BC_NAME`/`WORK_ID` (and `[run.inputs]`) to the actual
`bc_name`/`work_id` — the same way it rewrites `settings.toml`.** Verified live: the
placed `/workspace/.fabro/workflow.toml` still read `fabro-throwaway`/`fabro-spike-demo-3`.

### BUG #3 — shim (and engage) started in a NON-LOGIN shell without `SSL_CERT_FILE` → upstream TLS fails
The launcher starts the shim via `exec_run(["/bin/sh","-c", nohup anthropic-oauth-shim …])`
as a non-login shell. `SSL_CERT_FILE` (and `REQUESTS_CA_BUNDLE` etc.) are exported by
the bc-base **login profile** `/etc/profile.d/agent-vault-ca.sh`, **not** as docker
`ENV`, so a non-login `/bin/sh` does not have them (confirmed:
`sh -c 'echo $SSL_CERT_FILE'` → empty). The shim's Python `urllib` therefore does not
trust the agent-vault MITM root CA, and its upstream `POST → https://api.anthropic.com`
via `HTTPS_PROXY` fails `SSL: CERTIFICATE_VERIFY_FAILED` (→ 502). The shim's own
docstring requires `SSL_CERT_FILE` in its env. **The launcher must start the shim (and
the fabro server/run engage) with `SSL_CERT_FILE=/home/vscode/.config/agent-vault/ca.pem`
explicitly on the exec env** (parallel to how the clone path sets `GIT_SSL_CAINFO`
explicitly for the same non-login-shell reason — the fabro path just never got the
equivalent fix). With `SSL_CERT_FILE` exported, the shim round-trip is `200` (see S3).

### BUG #4 — engage starts `fabro server start` with NO server config → server refuses to start
The engage runs `fabro server start --foreground --no-web`, but the launcher writes
**only the workflow-level** `/workspace/.fabro/settings.toml` (`[llm.providers.anthropic]`
base_url). It never bootstraps a **server-level** config (no `~/.fabro/settings.toml`
with `[server.auth] methods`, no storage, no dev-token, no registered LLM provider).
The server aborts: `× failed to resolve server settings: server.auth.methods: field
is required`, so `fabro run` then can't reach it (`Cannot reach Fabro server: no
settings.toml configured`). **The engage must first bootstrap the ephemeral server**
(e.g. `fabro install --non-interactive --skip-llm --overwrite-settings` + register the
anthropic provider pointing at the shim + `ANTHROPIC_API_KEY` dummy in the server's
env) — exactly what the spike did by hand and what the launcher omits.

---

## Invariant checks (all HELD)

| Invariant | Status | Evidence |
|---|---|---|
| Fabro in-container ONLY | HELD | ephemeral `fabro server` + `fabro run` inside `bc-fabro-e2e`; provider=local; nothing orchestrated outside the one container |
| agent-vault sole cred; fabro vault `__PLACEHOLDER__` | HELD (live) | `/workspace/.fabro/vaults/default/secrets.json` = `{GITHUB_TOKEN:__PLACEHOLDER__, ANTHROPIC_API_KEY:__PLACEHOLDER__}`; every LLM hop `200` via shim→HTTPS_PROXY→agent-vault; only a DUMMY `ANTHROPIC_API_KEY` ever in fabro's own env/vault |
| launch-interface parity (bc-container) | HELD (boot) | same `docker run` from v0.3.45, same env injection (AGENT_VAULT_*, HTTPS_PROXY, CA, SHOPMSG_DSN, SHOPMSG_SYSTEM_SLUG), same readiness barrier; only the engage tier differs |
| shop-msg protocol preserved | HELD | seeded `assign_scenarios` consumed; `work_done` emitted; read back via `shop-msg read outbox` |
| tmux default unchanged | HELD | `--orchestrator` default is `tmux`; the fabro block is gated on `launch_path == "fabro"`; NO tmux `agent` session / NO `claude` on the fabro path (engage log confirms) |

---

## Detailed evidence

### Boot / parity (the launch command, live)
- `docker inspect bc-fabro-e2e` image = `sha256:539cb42de838…` (= v0.3.45 `:latest`).
- Container env (in-container `env`): `AGENT_VAULT_ADDR=http://agent-vault:14321`,
  `AGENT_VAULT_VAULT=fleet`, `HTTPS_PROXY=http://av_agt_…:fleet@agent-vault:14322`,
  `SHOPMSG_DSN=postgresql://postgres:postgres@postgres:5432/shopsystem`,
  `SSL_CERT_FILE/CURL_CA_BUNDLE/REQUESTS_CA_BUNDLE/GIT_SSL_CAINFO/NODE_EXTRA_CA_CERTS
  =/home/vscode/.config/agent-vault/ca.pem` (login profile).
- Mounted `/workspace` = the throwaway tree; `git rev-parse origin/main` resolves;
  `features/demo.feature` present. `/workspace/.fabro` ABSENT after launch (BUG #1).

### Wiring applied via the launcher's OWN scripts (to prove the runtime past BUG #1)
`_load_fabro_def_files()` + `_fabro_def_install_script()` placed the 15-file def
bundle at `/workspace/.fabro`; `_fabro_shim_start_script()` started the shim;
`_fabro_settings_install_script()` wrote `settings.toml`
(`base_url=http://127.0.0.1:8788/v1`, `adapter=anthropic`, no credential).
`fabro validate workflow.fabro` → **OK, 23 nodes / 45 edges**.

### S3 — live credential round-trip (fabro-orchestration/02, now live)
`POST http://127.0.0.1:8788/v1/messages` with dummy `x-api-key` →
`HTTP=200`, body `…"content":[{"type":"text","text":"PONG"}]…"model":"claude-haiku-4-5-20251001"…`;
shim log `"POST /v1/messages HTTP/1.1" 200`. Vault `__PLACEHOLDER__` throughout.
(Required BUG #3 workaround: shim restarted with `SSL_CERT_FILE` exported.)

### Fail-closed also observed under a real environment fault (sonnet rate-limit)
The first S5 run used the graph's default `.coding`/`.review` = `claude-sonnet-4-5`;
`classify` hit `Rate limited by anthropic` (a known spike residual, orthogonal to the
launcher). The graph fail-closed correctly: `classify → emit_blk [outcome=failed]` →
a `status: blocked` work_done to the outbox — **never a silent complete.** The clean
S5 GREEN below re-ran with the model_stylesheet switched to haiku-only (env workaround).
