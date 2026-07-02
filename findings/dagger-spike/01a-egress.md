# Slice 1a — Dagger BuildKit egress THROUGH agent-vault (make-or-break)

**Date:** 2026-07-02 · **Branch:** `dagger-spike` · **Epic:** lead-fzxt (Slice 1) · **Leg:** EGRESS
**Question:** Can a dagger BuildKit build-time `RUN` reach the network **through agent-vault**
(HTTPS_PROXY + MITM CA) **without modifying the real Dockerfile**?

## BOTTOM LINE

**YES — egress-through-agent-vault works for BuildKit `RUN` steps, and the proxy half needs
ZERO Dockerfile changes.** Proven end-to-end on-host with dagger v0.21.7: build-time `RUN`
steps hitting **PyPI** (`pip install requests`), **GitHub over git+https**
(`pip install git+https://github.com/psf/requests@main`), and **api.github.com** (`curl`) all
succeeded through the agent-vault MITM proxy (HTTP 200 / `Successfully installed` / `git clone`
OK), using the host's agent-vault handle as the sole credential surface (IS-2).

The recipe has **two independent halves**, and they land very differently against IS-3:

| Half | Mechanism | Dockerfile edit? |
|------|-----------|------------------|
| **Proxy routing** | Set `HTTP(S)_PROXY`/`NO_PROXY` on the **dagger ENGINE container**; BuildKit **propagates the daemon's proxy env into every `RUN`**. | **NONE** — clean. |
| **MITM CA trust** | The MITM CA must be present + trusted **inside the `RUN` filesystem**, which can ONLY come from the **base image** (or a Dockerfile `COPY`/`--mount`). There is **no engine-level knob that injects a CA into `RUN`**. | **Base-image layer** (Dockerfile text stays verbatim) OR a Dockerfile edit. This is the only IS-3 tension. |

**The `--build-arg http_proxy=...` docker convention DOES NOT WORK under dagger** (see Finding 2).
The working lever is engine-daemon env propagation, not build-args.

---

## ENVIRONMENT (located empirically)

- **MITM CA:** `/home/vscode/.agent-vault/mitm-ca.pem` — `CN=Agent Vault Root CA` (self-signed
  root; NOT the `~/.config/agent-vault/` path the brief guessed).
- **Proxy:** `http://av_agt_<...>:fleet@agent-vault:14322` (from host `HTTPS_PROXY`).
  `agent-vault` = **192.168.0.2**; use the **IP** in engine env to avoid DNS dependence.
- **agent-vault lives on docker network `shopsystem` (192.168.0.0/20).** The devcontainer/lead
  host (this shell = `bc-shopsystem-lead`, 192.168.0.9) shares that network. **The dagger
  engine's default `bridge` (172.17.0.0/16) has NO route to 192.168.0.2** — a plain
  bridge/alpine container **times out** to `192.168.0.2:14322`. The engine must be **attached
  to the `shopsystem` network** to reach the proxy.
- Proxy is a true **MITM**: `curl -x proxy https://api.github.com` without the CA fails
  `SSLCertVerificationError / unable to get local issuer certificate`; with the CA → 200.
  Credential injection into HTTPS bodies/headers => TLS interception is inherent => CA trust
  is unavoidable for HTTPS `RUN` egress.

---

## FINDINGS (in the order they were established)

### Finding 0 — engine has DIRECT egress today (the IS-2 hole)
Baseline: build the egress Dockerfile with the **default** engine and **no** proxy → it
**succeeds directly** (apt/PyPI/GitHub all reachable without agent-vault). So today a dagger
build **bypasses agent-vault entirely**. For the real bc-base this is not merely untidy: the 4
VCS-pinned framework CLIs are org repos whose creds agent-vault injects on-wire — direct egress
would auth-fail. Forcing traffic through agent-vault is **required**, not optional.

### Finding 1 — a bridge-network engine cannot reach the proxy
`docker run --rm --network bridge alpine nc -zv 192.168.0.2 14322` → **timeout**.
`--network shopsystem` → **`succeeded!`**. Root cause: the proxy is on the `shopsystem` docker
net; the default `bridge` isn't routed to it. **Engine must join `shopsystem`.**

### Finding 2 — dagger `dockerBuild` IGNORES docker's predefined proxy build-args
Passing `--build-args http_proxy=... --build-args https_proxy=...` (both cases) to
`docker-build` and echoing them in a `RUN`:
```
RUN echo "http_proxy=[$http_proxy] HTTP_PROXY=[$HTTP_PROXY] ..."   ->  ALL EMPTY []
```
A build pointed at a **bogus** proxy (`http://192.168.0.2:1`, closed port) still reached GitHub
(`GITHUB_HTTP=200`) — proving the `RUN` **ignored** the proxy build-args and went direct.
Control: a **declared** `ARG FOO` + `--build-args FOO=bar123` DID reach the `RUN` (`FOO=[bar123]`).
=> dagger's `dockerBuild` treats build-args purely as Dockerfile `ARG` values; it does **not**
implement Docker/BuildKit's "predefined proxy ARG auto-injection into RUN env". **The
`--build-arg http_proxy` recipe is a dead end under dagger.**

### Finding 3 — BuildKit PROPAGATES the ENGINE DAEMON's proxy env into every `RUN` ✅
Set `HTTP_PROXY/HTTPS_PROXY/http_proxy/https_proxy` (+ `NO_PROXY`) as **env on the engine
container**, point dagger at it via `_EXPERIMENTAL_DAGGER_RUNNER_HOST`, build with **no**
build-args, echo in a `RUN`:
```
UP http_proxy=[http://av_agt_...@192.168.0.2:14322] HTTP_PROXY=[...] https_proxy=[...] HTTPS_PROXY=[...]
```
All four populated. **This is the clean, no-Dockerfile-edit proxy lever** (BuildKit's documented
behavior: buildkitd's own proxy env is the fallback for `RUN` when build-args don't override).

### Finding 4 — engine image pulls also go through the engine proxy (needs NO_PROXY or engine CA)
With engine `HTTPS_PROXY` set, the **base-image pull** (`FROM python:3.11-slim`) is routed
through the MITM proxy and fails `x509: certificate signed by unknown authority` — first at
manifest resolution (`registry-1.docker.io`), then at the blob CDN
(`production.cloudfront.docker.com`). Fixed by putting the **registry hosts in `NO_PROXY` as
domain suffixes** so public base pulls go **direct** (standard CA, no creds needed):
`NO_PROXY=localhost,127.0.0.1,.docker.io,.docker.com,.cloudfront.net,.cloudflare.docker.com,registry.dagger.io`.
> Note: setting `SSL_CERT_FILE=<combined-bundle>` on the engine did **NOT** make the BuildKit
> **dockerfile-frontend resolver** trust the MITM CA (it still x509-failed) — the resolver
> inherits the engine's **proxy** env but not its cert-file env. So public base pulls must be
> `NO_PROXY`-direct. **Open item:** a **private GHCR** base pull (e.g. bc-lead's
> `FROM bc-base:vX`) needs proxy+creds+engine-CA — engine-resolver CA trust is unresolved and
> is carried to Slice 1/2. (bc-base itself FROMs a **public** `mcr.microsoft.com/devcontainers`
> base, so the primary target is unaffected — just add `.mcr.microsoft.com` to `NO_PROXY`.)

### Finding 5 — `RUN` needs the MITM CA in its OWN trust store (base-image concern) 
With engine proxy propagating correctly but a stock base, HTTPS `RUN` egress fails:
```
curl: (60) SSL certificate problem: unable to get local issuer certificate   -> GITHUB_HTTP=000
```
There is **no engine-level way to inject a CA *file* into a `RUN` filesystem** — `RUN`'s rootfs
is the base image's; the only file-delivery channels are the **base image**, a Dockerfile
`COPY`, or `RUN --mount=type=secret` (the latter two edit the Dockerfile). Confirmed by making
the base trust the CA (below) → egress then succeeds.

### Finding 6 — FULL egress SUCCESS once the base trusts the CA ✅✅
Base layer establishes CA trust (system store **and** Python/pip/git env — Python uses its own
`certifi` bundle, so the system `update-ca-certificates` alone is insufficient for pip):
```dockerfile
COPY agent-vault-ca.pem /usr/local/share/ca-certificates/agent-vault-ca.crt
RUN apt-get update -qq && apt-get install -y -qq curl git ca-certificates \
 && cat /usr/local/share/ca-certificates/agent-vault-ca.crt >> /etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt \
    PIP_CERT=/etc/ssl/certs/ca-certificates.crt \
    GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
```
Then the **egress `RUN` steps** (verbatim, mimic real bc-base) all succeed **through agent-vault**:
```
GITHUB_HTTP=200
Successfully installed certifi-2026.6.17 ... requests-2.34.2 urllib3-2.7.0   PIP_PYPI_OK
Cloning https://github.com/psf/requests (to revision main) ... git clone --quiet ...  PIP_GIT_OK
```
(pip's exit code — not masked by `| tail` — governed the build, so these are true successes.)

---

## THE WORKING RECIPE (reproducible)

```bash
# 0. Locate CA + proxy; build a combined CA bundle (system + MITM) for the engine.
CB=/tmp/.../combined-ca.pem
cat /etc/ssl/certs/ca-certificates.crt /home/vscode/.agent-vault/mitm-ca.pem > "$CB"
PXY='http://av_agt_<...>:fleet@192.168.0.2:14322'          # agent-vault handle = SOLE cred (IS-2)
NP='localhost,127.0.0.1,.docker.io,.docker.com,.cloudfront.net,.cloudflare.docker.com,registry.dagger.io'

# 1. Custom dagger engine: privileged, on the shopsystem net, carrying proxy env + CA.
docker run -d --name dagger-egress-engine --privileged --network shopsystem \
  -e HTTP_PROXY="$PXY" -e HTTPS_PROXY="$PXY" -e http_proxy="$PXY" -e https_proxy="$PXY" \
  -e NO_PROXY="$NP"    -e no_proxy="$NP" \
  -e SSL_CERT_FILE=/etc/agent-vault/combined-ca.pem \
  -v "$CB":/etc/agent-vault/combined-ca.pem:ro \
  registry.dagger.io/engine:v0.21.7 --debug

# 2. Point the dagger CLI at that engine (identical `dagger` commands otherwise).
export _EXPERIMENTAL_DAGGER_RUNNER_HOST=docker-container://dagger-egress-engine

# 3. Build the REAL Dockerfile verbatim; RUN steps inherit proxy from the engine, trust the
#    MITM CA from the (CA-trusting) base image, and egress through agent-vault.
dagger -c "host | directory <ABS> | docker-build --dockerfile Dockerfile | stdout"
```

The minimal test Dockerfiles + outputs live in the scratchpad (`.../scratchpad/egress/`):
`Dockerfile.up` (proxy-echo), `Dockerfile.c` (bogus-proxy control / no-CA cert-fail),
`Dockerfile.ok` + `Dockerfile.pip` (full egress success).

---

## DOES THE DOCKERFILE STAY UNMODIFIED? — the IS-3 answer

- **Proxy routing: YES, fully unmodified.** Engine-daemon env → `RUN` propagation touches
  nothing in the Dockerfile.
- **CA trust: the Dockerfile TEXT stays verbatim ONLY IF the base image trusts the MITM CA.**
  A `RUN` cannot obtain a CA *file* from the engine; it must come from the base layer. Three
  options, ranked by IS-3 fidelity:

  1. **BEST — CA-trusting base image (Dockerfile byte-identical).** The base referenced by
     `FROM` (for bc-base: `mcr.microsoft.com/devcontainers/python:3.11`) is provided as a
     variant that has the MITM CA in `/etc/ssl/certs/ca-certificates.crt` **and** the Python/pip
     CA env. This is a **tiny additive CA-trust base layer**, not app divergence — trusting the
     org/CI CA in the base is standard for a MITM-proxied build environment. **Tension:** it is
     not literally the upstream image; and delivering it *without* editing the `FROM` line
     requires either seeding the engine image store under the same tag or a BuildKit
     **named-build-context** override (`--build-context <from-ref>=docker-image://<ca-base>`) —
     **and dagger's `dockerBuild` CLI does NOT expose build-contexts** (signature:
     `[--dockerfile] [--platform] [--build-args] [--target] [--secrets] [--no-init] [--ssh]`).
     So under today's dagger the override-without-edit isn't available via CLI; it needs the
     org base to genuinely carry the CA, or a Python-SDK path if `dockerBuild` accepts
     `buildContexts` there. **Verify whether the real bc-base already establishes agent-vault
     CA trust early in its build** (it bakes agent-vault v0.32.0 + "CA/bootstrap" entrypoints) —
     if that CA trust lands *before* the pip-from-git RUNs and matches the CI CA, the real build
     is unmodified **for free**.

  2. **ACCEPTABLE — pin the `FROM` to an org CA-base** (`FROM org/python-3.11-cabase`). One-line
     Dockerfile change; bends IS-3 (real Dockerfile not verbatim) minimally.

  3. **DISCOURAGED — accept direct build egress as policy** (Finding 0). Zero Dockerfile change
     but **violates IS-2** (bypasses agent-vault; org-private framework repos would auth-fail).

---

## INVARIANT TENSIONS / CARRY-FORWARD

- **IS-2 (agent-vault sole cred surface): SATISFIED.** Egress used only the agent-vault proxy
  handle (`av_agt_...`, host-provided, lives in the **engine env** — not in any image layer);
  the proxy injects real GitHub/PyPI creds on-wire; dummy/no service token needed;
  **no secret baked** into the built image.
- **IS-3 (real Dockerfile verbatim): proxy half clean; CA half requires a base-image CA-trust
  layer** (option 1 above). This is the one genuine tension — flagged, with the mitigation that
  it's an infra/base concern, not app divergence, and that the real bc-base may already trust an
  agent-vault CA at build time (to be verified).
- **Open item → Slice 1/2:** engine **dockerfile-frontend resolver** CA trust for
  **proxied private-registry pulls** (bc-lead `FROM bc-base:vX` on GHCR). Engine `SSL_CERT_FILE`
  did not satisfy the resolver; public base pulls were sidestepped via `NO_PROXY`. bc-base's own
  build is unaffected (public base).
- **Engine model note:** the egress engine must be **privileged + on the `shopsystem` net**;
  in CI (`dagger/dagger-for-github`) the same env (`HTTP(S)_PROXY`/`NO_PROXY`) must be set on the
  provisioned engine and the runner must share agent-vault's network — carry into the
  WRAP-not-REPLACE `publish-bc-base.yml` spec.

## CLEANUP NOTE
Slice-0 side effect: the shared auto-engine `dagger-engine-v0.21.7` was `docker network connect`ed
to `shopsystem` during probing; the purpose-built `dagger-egress-engine` is the recipe engine.
Both can be removed with `docker rm -f`; `dagger-engine-v0.21.7` re-provisions on next default use.
