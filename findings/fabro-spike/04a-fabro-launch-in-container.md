# Slice 4 — LAUNCH leg: fabro-orchestrated THROWAWAY BC, launch-parity going live

**Epic** lead-6k1r (Fabro spike) · **Slice** 4 · **Leg** LAUNCH · **Branch** `fabro-spike`
· **Date** 2026-07-01 · fabro v0.254.0 · SPIKE / THROWAWAY.

**Bottom line: PASS.** A fresh throwaway BC container (`bc-fabro-throwaway`) was booted
from the already-present `bc-base` image, provisioned to launch-parity (agent-vault
proxy + MITM CA + postgres DSN), and the full fabro furniture (binary + anthropic-oauth
shim + defs) was deployed INTO it. In-container verification is green on every gate:
`fabro model test --model haiku` → **ok** (LLM reached Anthropic through the
in-container shim + agent-vault with fabro's vault = `__PLACEHOLDER__`),
`fabro validate workflow.fabro` → **OK (22 nodes / 44 edges)**, and a `--dry-run` of the
graph against the throwaway BC's real (registered, empty) inbox traverses the entry path
prime → health → arm → classify from a clean preflight. **Invariant #2 held.** No
`needs_david` escalation — the whole path stayed in-scope (local docker + one local
postgres registry row for a throwaway BC; no remote infra, no real infra BC touched).

---

## 1. Throwaway target chosen + why safe

**Chosen: a FRESH ephemeral container `bc-fabro-throwaway`** (id `a46eec04c211`), booted
via plain `docker run` from `shopsystem-bc-base:latest` (= v0.3.6 `3a39227d8b7c`, the
same image the three healthy infra BCs run), attached to the `shopsystem` docker
network, `sleep infinity`.

Why this over the alternatives, and why it is safe:
- **Not a real infra BC.** The SAFETY invariant forbids running the loop inside — or
  seeding messages to — `bc-shopsystem-{messaging,scenarios,bc-launcher,templates,lead}`.
  A fresh throwaway side-steps that entirely.
- **No `bc-container launch`** was used, deliberately: `launch` pulls in manifest
  lookup + agent-vault broker provisioning + (optionally) a repo clone — machinery that
  edges toward shared/outward config. Plain `docker run` from bc-base is exactly the
  path the task sanctions ("a FRESH ephemeral container booted from the already-present
  bc-base image with a minimal throwaway repo inside") and is maximally in-scope: purely
  local docker.
- **Launch-parity replicated by hand, documented.** bc-base does NOT bake in the
  agent-vault proxy/CA/vscode-profile — those are injected at `bc-container launch` time.
  I replicated exactly that provisioning (see §2) so the container presents the same
  starting posture a launched BC would.
- **Throwaway identity.** BC name `fabro-throwaway`, WORK_ID `fabro-spike-demo-1` — both
  obviously throwaway; the registry row is a local postgres row (in-scope per SAFETY).

## 2. Deploy steps (all against `bc-fabro-throwaway`)

1. **Boot** — `docker run -d --name bc-fabro-throwaway --network shopsystem` with env
   `HTTPS_PROXY`/`HTTP_PROXY` = the fleet agent-vault broker
   (`http://av_agt_…:fleet@agent-vault:14322`, read from the messaging container),
   `NO_PROXY=localhost,127.0.0.1,agent-vault,postgres,shopsystem-postgres`,
   `SHOPMSG_DSN=postgresql://postgres:postgres@postgres:5432/shopsystem`,
   `ANTHROPIC_API_KEY=sk-ant-DUMMY-placeholder-proxy-injects`, image
   `shopsystem-bc-base:latest`, `sleep infinity`.
2. **MITM CA provisioning** — `docker cp` the agent-vault MITM CA out of the messaging
   container and into the throwaway at `/root/.config/agent-vault/ca.pem` (+
   `/root/.agent-vault/mitm-ca.pem`); wrote `/root/fabro-env.sh` exporting the proxy
   vars + `SSL_CERT_FILE`/`REQUESTS_CA_BUNDLE`/`NODE_EXTRA_CA_CERTS` → that CA. (bc-base
   runs exec as `root`, `HOME=/root`; the launched BCs get this same wiring under
   `/home/vscode` via the vscode login profile.)
3. **fabro binary** — the host binary (`fabro 0.254.0`, x86-64 ELF) `docker cp`'d to
   `/usr/local/bin/fabro` (bc-base ships no fabro). `fabro --version` → `0.254.0`.
4. **defs + shim** — `docker cp` all of `findings/fabro-spike/fabro-defs/` →
   `/root/fabro-defs/` (workflow.fabro, workflow.toml, project.toml, nodes/, vaults/,
   anthropic-oauth-shim/).
5. **fabro config** — `/root/.fabro/settings.toml` = the host's full server config
   (`[server.auth] methods=["dev-token"]`, listen `127.0.0.1:32276`, web) PLUS the U5
   `[llm.providers.anthropic] base_url="http://127.0.0.1:8788/v1"` override and a
   `[run.environment.env]` overlay (proxy + CA path). `/root/.fabro/environments/local.toml`
   = `provider="local"`.
6. **shim** — launched in-container in background:
   `python3 /root/fabro-defs/anthropic-oauth-shim/shim.py --host 127.0.0.1 --port 8788`
   under `source /root/fabro-env.sh` → listening `127.0.0.1:8788`, forwarding to
   `api.anthropic.com` via the container's own `HTTPS_PROXY`.
7. **server** — `fabro server start` → `pid 379 on 127.0.0.1:32276`; `fabro auth login
   --dev-token …` to authenticate the in-container CLI to it.

## 3. Verification output

**Reachability (from inside the container):**
- `postgres:5432` → OK · `agent-vault:14322` → OK.
- Real cred injection on the wire: `curl https://api.github.com/user` with only a dummy
  token → **HTTP 200** (agent-vault injected the real `GITHUB_TOKEN`, CA validated the
  MITM). BC tooling present: shop-msg, bc-emit, scenarios, bd, git, gh, curl.

**fabro deployed + verified:**
- `fabro --version` → `fabro 0.254.0 (497aaba 2026-06-04)`.
- `fabro model test --model haiku` → `claude-haiku-4-5  anthropic  … RESULT ok`. Shim
  log confirms the traversal: `"POST /v1/messages HTTP/1.1" 200`. So the node's own LLM
  call went dummy-`x-api-key` → in-container shim (strips it, adds
  `Authorization: Bearer` + `anthropic-beta: oauth-2025-04-20`) → container `HTTPS_PROXY`
  → agent-vault injects the real OAuth → 200 — **with fabro's vault holding only
  `__PLACEHOLDER__`.** This closes the load-bearing question: the shim path works with
  the container's OWN `HTTPS_PROXY`, so the two Slice-3 local-sandbox env traps
  (global-overlay-vs-file, credential-var stripping) do NOT bind the in-container run.
- `fabro validate workflow.fabro` → `Workflow: BcShopLoop (22 nodes, 44 edges) …
  Validation: OK`.

## 4. Entry-path readiness (same starting posture as a launched BC)

- Registered the throwaway BC: `shop-msg registry add fabro-throwaway` → listed as
  `fabro-throwaway shopsystem/fabro-throwaway bc` (a shop name must be registered before
  its mailbox is addressable; a local postgres row, in-scope).
- The `prime` entry command `shop-msg prime --bc fabro-throwaway` → `DB reachable: yes /
  Pending inbox messages: 0`. The `arm` entry command `shop-msg pending inbox --bc
  fabro-throwaway` → empty. So the throwaway BC presents a **real, registered, EMPTY**
  mailbox over postgres — exactly the starting posture of a bc-container-launched BC.
- `fabro run workflow.fabro -I BC_NAME=fabro-throwaway -I WORK_ID=fabro-spike-demo-1
  --environment local --dry-run --auto-approve` (simulated LLM backend; keeps the real
  mutating loop for the DEMO/goal leg) → preflight clean, goal templated with
  `fabro-throwaway`/`fabro-spike-demo-1` (input injection working), `Sandbox: local
  (ready in 0ms)`, and the run traverses **Start → prime → work-tracker health gate →
  arm watch + drain inbox → bc-router classify → … → Exit: SUCCEEDED** (run
  `01KWDT68R1PXVNQ43JZWPK1MFY`). The fabro-orchestrated launch STARTS the graph against
  the throwaway BC and dispatches the whole prime/health/arm/classify entry path.

## 5. Invariant #2 — HELD

`/root/fabro-defs/vaults/default/secrets.json` = `__PLACEHOLDER__` for BOTH
`GITHUB_TOKEN` and `ANTHROPIC_API_KEY` (unchanged). Server `ANTHROPIC_API_KEY` = dummy
`sk-ant-DUMMY-placeholder-proxy-injects`. The real Anthropic OAuth + real GitHub token
were supplied ONLY on the wire by agent-vault via `HTTPS_PROXY`; nothing real was ever
written to or read from fabro's vault. The shim stores no secret — it only normalizes
header shape.

## 6. needs_david

**None.** The entire path was in-scope: one local docker container, one local postgres
registry row + empty mailbox for a throwaway BC, defs on the `fabro-spike` branch. No
new remote repo, no push to a real BC remote, no shared-manifest registration, no real
infra BC disturbed, no message seeded to a real BC.

## 7. Live state (for the DEMO/goal leg to consume)

- Container `bc-fabro-throwaway` (`a46eec04c211`), image `shopsystem-bc-base:latest`, Up
  healthy, on the `shopsystem` network.
- In-container: fabro server `pid 379` @ `127.0.0.1:32276`; shim @ `127.0.0.1:8788`;
  env at `/root/fabro-env.sh`; defs at `/root/fabro-defs/`; config at `/root/.fabro/`.
- Throwaway identity: BC `fabro-throwaway` (registered, empty inbox), WORK_ID
  `fabro-spike-demo-1`.
- The DEMO leg's job: seed a minimal throwaway `assign_scenarios` into the
  `fabro-throwaway` inbox + a minimal repo at the sandbox cwd, then run the graph for
  real (non-dry-run LLM) to exercise AC5 (gated-emit) + AC8 (reactive-seam) and observe
  a valid `work_done`.
