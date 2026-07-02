# Slice 0 · Leg A — dagger.io tool characterization (empirical)

**Date:** 2026-07-02 · **Branch:** `dagger-spike` · **Host:** lead shop container
(`81f6babe607c`, Debian 13 trixie, x86_64) · **Epic:** lead-fzxt

All commands below were run for real in this environment; outputs are quoted verbatim
(progress-log noise trimmed). Scratchpad: `/tmp/claude-1000/-workspace/<sess>/scratchpad`.

---

## 1. Install + version + engine

### Preconditions found
- No dagger pre-installed (`which dagger` empty).
- Docker present and healthy: client `29.6.1`, server engine `29.5.3`, `docker ps` works.
- Runtimes: `python3 3.11.15` present; **no `go`, no `node`** on host (irrelevant — the
  SDK runtime runs *inside the engine container*, not on the host).
- Outbound HTTP goes through the agent-vault proxy:
  `HTTPS_PROXY=http://av_agt_…:fleet@agent-vault:14322`, `AGENT_VAULT_ADDR=http://agent-vault:14321`.
  `curl https://dl.dagger.io/dagger/install.sh` → `200`.

### Install (exact steps)
```
curl -sSL https://dl.dagger.io/dagger/install.sh -o dagger-install.sh   # 380-line official script
BIN_DIR=$HOME/.local/bin sh dagger-install.sh
# -> dagger-install.sh info installed /home/vscode/.local/bin/dagger
```
`/usr/local/bin` is root-owned; installing to `~/.local/bin` (already on PATH) avoided sudo.

```
$ dagger version
dagger v0.21.7 (image://registry.dagger.io/engine:v0.21.7) linux/amd64
```

### The engine (daemon model)
Dagger is a **CLI + a BuildKit-derived engine that runs as a Docker container**. The CLI
auto-provisions it on first use (no manual daemon step needed here — Docker was enough):
```
$ docker ps --filter name=dagger
74c676b63c7e registry.dagger.io/engine:v0.21.7 Up … dagger-engine-v0.21.7
$ docker images | grep dagger
registry.dagger.io/engine:v0.21.7 … 635MB
```
- Engine container is **privileged**, **bridge network**, mounts a docker volume at
  `/var/lib/dagger` (its cache/state).
- First-ever call cost ~12s to pull+start the engine (`connect DONE [12.4s]`); subsequent
  calls reuse the running container (`connect DONE [0.2s]`).
- **Engine carries NO `HTTP(S)_PROXY` / vault env and cannot resolve `agent-vault`.**
  → Container *build* traffic (e.g. `apk add`) leaves the engine with **direct** network,
  NOT via the agent-vault proxy. This is a seam (see §4).

---

## 2. Trivial pipeline + dagger's model

### Trivial end-to-end run (Dagger Shell one-liner)
```
$ dagger -c 'container | from alpine:3.20 | with-exec echo,hello-from-dagger | stdout'
…
hello-from-dagger        (real ~14s cold incl engine start; sub-second warm)
```
Steps observed: `connect` → load module → `Container.from(alpine:3.20)` →
`withExec echo hello-from-dagger` → `Container.stdout` → prints the string. Every step runs
**inside a container in the engine**; the pipeline is a lazy GraphQL DAG the engine resolves.

### The model — four ways to author, ONE runtime
Dagger's API is a **GraphQL DAG evaluated by the engine**. You author against it via:

1. **Dagger Shell** — `dagger -c '<expr>'`. Pipe (`|`) chains method calls on core types
   (`container`, `directory`, `host`, `secret`). Nesting via `$( … )`. Great for probing;
   **fragile for complex inner `sh -c` scripts** (its parser eats `|`, `$()` — bit me
   repeatedly; use script files or the SDK for anything non-trivial).
2. **Modules + SDK** (Go / **Python** / TypeScript) — the durable, reusable unit. `dagger
   init --sdk=python` scaffolds a module; functions are decorated methods:
   ```python
   @object_type
   class Demo:
       @function
       def container_echo(self, string_arg: str) -> dagger.Container:
           return dag.container().from_("alpine:latest").with_exec(["echo", string_arg])
   ```
   `dagger.json` records `{name, engineVersion: "v0.21.7", sdk: {source: "python"}}`.
   The SDK runtime executes *in the engine*, so the host needs no Python/Go/Node deps.
3. **`dagger call`** — the CLI invocation of a module function, chained on the command line:
   ```
   $ dagger call container-echo --string-arg="hello-via-dagger-call" stdout
   hello-via-dagger-call
   ```
   `--flag=…` sets function args; trailing words (`stdout`) chain further API calls on the
   returned object. **This is the same verb CI uses (§4).**
4. **`dagger query`** — raw GraphQL (not needed here).

### Caching model
Content-addressed, BuildKit-style layer/op cache in the engine volume. Re-running the same
build:
```
Directory.dockerBuild   CACHED [0.0s]
Container.withExec      CACHED [0.0s]
```
Any op whose inputs are unchanged is a cache hit → the "fast local loop" the spike wants.
Secrets have an explicit `--cache-key` knob so cache keys don't leak plaintext.

---

## 3. The two capabilities we need + secrets

### (a) BUILD a container image from a real Dockerfile
`host | directory <abs-path> | docker-build` builds the **actual Dockerfile** unmodified
(BuildKit/Dockerfile-compat frontend). Proven against a multi-step Dockerfile
(`FROM alpine` → `apk add bash` → `RUN echo > /etc/built.txt` → `COPY hello.sh` → `chmod`
→ `CMD`):
```
$ dagger -c 'host | directory /tmp/ddemo | docker-build | with-exec /hello.sh | stdout'
…
Directory.dockerBuild DONE
hello from built image; built.txt=built-layer
```
It honored every Dockerfile instruction (RUN/COPY/CMD/WORKDIR/ENV). **This is exactly the
shape of the real bc-base Dockerfile build** — dagger builds it as-is, no hand-ported
variant (satisfies invariant #1). NOTE: `host | directory .` resolves against dagger's
*system workdir*, NOT the shell cwd — **always pass an absolute path**.

### (b) RUN tests in a container + RED propagation
`with-exec` runs the test command in the built image. **Nonzero exit fails the pipeline AND
the dagger process** (critical: this is what makes CI/local go red):
```
$ dagger -c 'container | from alpine:3.20 | with-exec sh,-c,"exit 7" | stdout'
Error: exit code: 7            # DAGGER_EXIT=1  (confirmed with $?)
```
Packaged as a reusable module function (`build_and_test(src, test_cmd)` — build the
Dockerfile then `with_exec(["sh","-c",test_cmd]).stdout()`):
```
$ dagger call build-and-test --src=/tmp/ddemo --test-cmd='/hello.sh && echo TEST-PASSED'
hello from built image; built.txt=built-layer
TEST-PASSED
$ dagger call build-and-test --src=/tmp/ddemo --test-cmd='grep NONEXISTENT /etc/built.txt'
… exit code: 1   → DAGGER_CALL_EXIT=1     # dagger call exits nonzero on a failing test
```
→ dagger cleanly expresses "build the real image, run the real tests, go red on failure"
as one reusable function. This is the Slice-2 primitive.

### (c) SECRETS — and the agent-vault bridge seam
`secret <uri>` constructs a `Secret`; inject via `with-secret-variable NAME $(secret <uri>)`
or `with-mounted-secret`. Providers (URI schemes) confirmed:
- `env://VAR` → `secret env://MY_TOKEN | plaintext` returned `super-secret-value-123`.
- `cmd://<command>` → runs an arbitrary command and uses its stdout as the secret.
  `secret cmd://<script> | plaintext` returned the script's output.
- `file://` also supported. Unknown scheme → `unsupported secret provider: "bogus"`
  (op:// 1Password / vault:// HashiCorp exist upstream but are NOT our path).

**Masking:** dagger scrubs secret values from its own progress/logs. Even
`with-exec sh -c 'echo $TOK'` produced **0** raw-secret appearances in the full captured log.

**THE SEAM (decisive finding):** `cmd://` runs on the **CLIENT HOST**, not the engine, and
inherits the host's proxy env:
```
$ dagger -c 'secret cmd:///…/whoami.sh | plaintext'
host=81f6babe607c;proxyset=YES      # 81f6… = client host (engine is 74c6…); HTTPS_PROXY visible
```
So the agent-vault bridge = a **host-side `cmd://` fetch script** that calls agent-vault
through `HTTPS_PROXY`, whose output dagger ingests as a scrubbed `Secret` and injects into
the build/test container. This is precisely fabro's shim shape, and it sidesteps the fact
that the engine itself has no proxy/vault access. **No secret is baked into any image**
(satisfies invariant #2). Bridge lives client-side; engine only ever sees a scrubbed Secret.

---

## 4. Same module locally AND in GitHub Actions (the no-divergence value prop)

- A module is `dagger.json` + `src/`, pinned to a specific **`engineVersion` (`v0.21.7`)**.
  That pin is the divergence guard: local and CI resolve the identical engine + module.
- Local invocation = `dagger call <fn> --arg=… <chain>` (proven above).
- **CI invocation is the same verb.** Official GitHub Actions integration
  (docs.dagger.io/ci/integrations/github) uses `dagger/dagger-for-github@v8.3.0`:
  ```yaml
  uses: dagger/dagger-for-github@v8.3.0
  with:
    version: "latest"
    verb: call
    module: github.com/…@vX.Y.Z
    args: build-and-push --registry=$REGISTRY --image-name=$IMAGE
  ```
  `verb: call` + `args:` is literally `dagger call build-and-push …` — **the exact command
  run locally.** Same module, same engine version, same function, same args → one definition
  runs locally and in CI. This is the core "doesn't deviate" property David asked for
  (invariant #1) and directly closes the fabro gap (defects visible in the local loop, not
  only at the live e2e).

---

## Implications for the next slices (seams / invariant surfaces)

- **Build+test primitive is trivial in dagger** (`docker-build` + `with-exec`, red on
  nonzero). The real work of Slice 2 is pointing it at the *real bc-base Dockerfile +
  launcher tests + fabro e2e*, not proving dagger can build/run.
- **Divergence guard = one module, `engineVersion`-pinned, invoked by identical `dagger
  call` locally and via `dagger/dagger-for-github`.** Slice 1 should spec that this single
  module is what `publish-bc-base.yml` invokes (build/test stage) — the publish/version-tag
  → GHCR contract (invariant #3) can stay, with dagger as the build+test substrate feeding it.
- **agent-vault bridge = client-side `cmd://` fetch script** (host has `HTTPS_PROXY`; engine
  does not). Mirror fabro's shim: script hits agent-vault via proxy, dagger wraps stdout as
  a scrubbed `Secret`. No baked secrets (invariant #2). Confirm proxy-only egress needs for
  the real build (bc-base `apk`/pip pulls leave the engine directly today — may need a proxy
  config on the engine or vendored deps; flag for Slice 1/2).
- **Ownership:** productionizing = dispatch to `shopsystem-bc-launcher` to add the module +
  the `dagger/dagger-for-github` workflow to ITS repo (invariant #4); lead never edits BC
  source. Characterize its current `publish-bc-base.yml` via read-only `gh` (Leg B).
- **Host prereqs are minimal:** Docker + the dagger CLI. No host Go/Node/Python needed (SDK
  runs in-engine). GHA runners already have Docker → low adoption cost.

## Open flags
- Engine egress is NOT proxied → decide whether bc-base build pulls must route through
  agent-vault (policy) or direct egress is acceptable for a build host.
- Engine runs **privileged** — note for any hardened CI runner constraints.
- Dagger Shell quoting is fragile; author the real pipeline as a **Python SDK module**, not
  shell one-liners.
