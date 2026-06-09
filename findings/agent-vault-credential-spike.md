# Spike: agent-vault replacing the host-filesystem credential bind-mount (lead-jkwo)

Initiative lead-odqd. Throwaway spike, 2026-06-09. **Verdict: CONFIRM (go-with-caveats).** Real experiment executed end-to-end against a throwaway agent-vault broker + a `spike-` BC on the `shopsystem` network; live fleet and real credentials never touched. (The structured-emit stage of the workflow agent hung on a large schema; this doc is salvaged from the agent's transcript — the experiment itself completed and all assertions passed.)

## The problem being removed

Every BC launch (`bc_launcher/controller.py` `launch()`) builds a **read-write** bind-mount of host `~/.claude` → `/home/vscode/.claude`, carrying the real OAuth credential (`~/.claude/.credentials.json`, 471 bytes, mode 0600) **into every BC container**. The entire `_resolve_host_path` / `BCLAUNCHER_HOST_HOME` machinery exists only to make that mount's source resolvable on this ZFS-dataset host. So today: real creds are exfiltrable from any BC, and the launcher is coupled to host filesystem layout.

## How agent-vault removes it (verified)

`agent-vault run -- claude` passes **no token** to the child. It sets `HTTPS_PROXY` to the broker's MITM listener (`:14322`) and a full CA-trust env set (`SSL_CERT_FILE`, `NODE_EXTRA_CA_CERTS`, `REQUESTS_CA_BUNDLE`, `CURL_CA_BUNDLE`, `GIT_SSL_CAINFO`, `DENO_CERT`), then execs `claude`. Claude reads a placeholder `.credentials.json` (`accessToken:"__PLACEHOLDER__"`, `expiresAt:9999999999999`); its request to `api.anthropic.com` hits the proxy, which substitutes the **broker-stored** real credential as `Authorization: Bearer …`. The container holds no real token; the broker (on the `shopsystem` network) holds the only copy.

## What was actually executed, and the five assertions

Installed agent-vault from the GitHub release tarball; stood up a broker (owner register + vault + 3 Bearer services + proxy-role agent token + `ca fetch`), authored a 128-byte placeholder credential, and launched a throwaway `spike-bc-av` on `shopsystem` **without** `BCLAUNCHER_HOST_HOME` and **without** any `~/.claude` rw mount.

- **(a) PASS** — no `/home/vscode/.claude` rw dir mount; only a single **ro** placeholder-file mount. Exfiltration surface gone.
- **(b) PASS** — container's `.credentials.json` is the 128-byte `__PLACEHOLDER__`, not the 471-byte real cred.
- **(c) PASS** — `agent-vault run` validated the proxy-role token against the broker, then injected `HTTPS_PROXY=http://<token>:shopsystem@spike-agent-vault:14322` + the full CA-trust env into the child.
- **(d) PASS (creds-free kill-line)** — a request reached `api.anthropic.com` **through the MITM proxy** (TLS validated against the auto-written CA, no cert error), returning a real `request_id` and `"Invalid bearer token"` 401. This proves the proxy substituted the stored (dummy) credential as a Bearer token, and that the dummy fails upstream — exactly the expected creds-free outcome. A *real* credential would succeed; supplying it is the one human-gated step.
- **(e) PASS** — all of the above worked with **no `BCLAUNCHER_HOST_HOME`** set; the `.claude` arm of the ZFS coupling is eliminated.

## Findings beyond the plan

1. **The broker must run as a container ON the `shopsystem` network** (reached by name), not a host process — proven the hard way: a host-process broker on the dev-container loopback was unreachable from sibling BCs via the docker gateway. (Also: the control API binds `127.0.0.1` even with `--host 0.0.0.0` unless restarted carefully — a binding gotcha.)
2. **`agent-vault run --isolation container`** can itself launch the container (`--image`, `--mount`, `--share-agent-dir`, iptables firewall) — an architectural *alternative* to bc-launcher's own `docker run`. Worth weighing in Phase 2.
3. **Owner registration, vault/service/agent/token mint, and `ca fetch` are all CLI-doable** — this *corrects* two predicted human walls (registration and CA export are NOT dashboard-only).
4. **The built-in `anthropic` catalog template is api-key (x-api-key), NOT the OAuth Bearer flow** Claude Code uses. The three Bearer services (`api.anthropic.com`, `platform.claude.com`, `mcp-proxy.anthropic.com`) must be configured manually; there is no catalog default for them.

## The one hard human-gated step

A human must, once, read the real `accessToken`/`refreshToken` from a logged-in `~/.claude/.credentials.json` and store them in the broker vault (proxy auto-refreshes thereafter). The spike correctly used a dummy and did not touch real tokens.

## What the real implementation (Phase 2 ADR + scenarios) must cover

- Launcher change: drop the `~/.claude` rw mount; add `AGENT_VAULT_ADDR/TOKEN/VAULT` env + a ro placeholder `.credentials.json` + CA material; wrap the agent invocation in `agent-vault run -- claude …` (inside tmux, preserving the readiness-marker sequence).
- **Broker as a `shopsystem`-network service** with a launch-time **`agent_vault_reachable` readiness barrier** (precedent: `messaging_db_reachable`, `driver.py:312`) — broker availability becomes a hard launch dependency.
- **Scope decision for PO/architect:** `~/.config/gh` and `~/.gitconfig` are *still* bind-mounted, so the ZFS coupling persists for those unless a GitHub service is added to agent-vault (there is a `github` template) — or we accept it. `.claude.json` is config (not secret) — keep copying or bake into bc-base.
- Posture note: `AGENT_VAULT_TOKEN` is secret-ish but revocable/rotatable and grants only proxy substitution — strictly better than shipping the raw OAuth credential.

## Verdict

**CONFIRM.** The launcher change is small and mechanical, it removes the real-OAuth exfiltration surface and the `.claude` arm of the ZFS coupling, and the creds-free plumbing was proven end-to-end. The only unavoidable human step is the one-time token paste into the broker. Graduate to an ADR + scenarios (Phase 2).
