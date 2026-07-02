# ADR-054 -- Agent-vault is the sole credential surface for the dagger build egress: privileged engine on the shopsystem net, proxy env propagated by BuildKit, NO_PROXY registry apex + dagger-infra whitelist with github proxied, engine config via docker cp

- Status: Accepted (2026-07-02)
- Date: 2026-07-02
- Implements: hard-invariant #2 of the dagger spike (agent-vault is the SOLE
  credential surface; native secret stores forbidden) as an enforceable
  contract, EXTENDED from the fabro loop (ADR-049) to the dagger BUILD
  PIPELINE, and hard-invariant #3 (IS-2/IS-3: no divergence from the real
  publish path — the shipped Dockerfile stays verbatim). Graduates the
  Slice-1a/Slice-2 EGRESS proof
  (`findings/dagger-spike/01a-egress.md`, `02-dagger-experiment.md` §(b)
  NEW-A/B/C) via the odqd iterative-experimentation track (spike -> learn ->
  throw away -> graduate via ADRs + scenarios). The spike-vehicle product
  decisions are SETTLED under ADR-029/030/032 and are NOT re-litigated here.
- Anchored on (decisions this builds on -- NOT re-decided here):
  - [ADR-052](052-dagger-is-the-local-and-ci-build-test-substrate-wrap-not-replace-publish-bc-base.md)
    -- the UMBRELLA dagger-graduation decision (ONE engineVersion-pinned
    module over ONE build core, WRAP-not-REPLACE `publish-bc-base.yml`). This
    ADR is a SIBLING realization: it certifies that the module's build core
    can egress WITHOUT introducing a second credential surface. ADR-053
    (no-divergence) and ADR-055 (CA-trust carve-out) are the other siblings.
  - [ADR-049](049-agent-vault-is-sole-credential-surface-under-fabro-native-secrets-forbidden.md)
    -- agent-vault is the SOLE credential surface under fabro; the native
    secret system is a FORBIDDEN surface. This ADR EXTENDS that same contract
    from the fabro loop to the dagger BUILD egress: dagger secrets are the
    forbidden native store, agent-vault is the sole broker.
  - [ADR-028](028-agent-vault-broker-is-a-lead-shop-supporting-service-broker-own-behaviors-pinned-by-lead-integration-surface.md)
    -- agent-vault is a lead-shop supporting service that brokers real
    credentials ON THE WIRE; the existing MITM injection substrate this ADR
    routes BuildKit `RUN` egress through, unchanged.
  - [ADR-045](045-agent-vault-ca-pem-is-inline-pem-content-not-a-path.md)
    -- `AGENT_VAULT_CA_PEM` is inline PEM content; the MITM trust material the
    egress `RUN` steps must validate against. ADR-055 (the bounded CA-trust
    prerequisite) is where the build-time trust of that CA is scoped.
  - [ADR-021](021-bc-base-image-owned-by-bc-launcher-auto-rebuilds-on-utility-release.md)
    -- the bc-base image is owned by bc-launcher; dagger WRAPS ITS build and
    its egress, never a lead-owned variant (IS-5 -> Slice-4 dispatch, no lead
    edits to BC CI).
  - [ADR-018](018-empirical-verification-is-contract-surface.md) /
    [PDR-011](../pdr/011-empirical-verification-is-contract-surface.md) --
    empirical verification is the contract/artifact surface; the egress recipe
    was proven ON-HOST against the artifact surface, not by reading or running
    BC source. Per the spike-vehicle track (ADR-029/030/032) the spike
    `findings/dagger-spike/*.md` are the grounding evidence.
- Bead: lead-fzxt (P1, the dagger-spike epic, proof banked 2026-07-02).
  Realizes hard-invariant #2 (credential surface) for the build pipeline;
  sibling of ADR-053/055 under the ADR-052 umbrella; EXTENDS ADR-049. The epic
  stays OPEN through the Slice-4 productionization dispatch.

## Context

The dagger spike (epic lead-fzxt) asked whether dagger can serve as the
local+CI build/test substrate for the bc-base image WITHOUT breaking the hard
invariants — the same odqd graduate-via-ADRs+scenarios track the fabro
graduation (ADR-048..051) rode. The empty-middle gap ADR-052 closes is that
bc-launcher CI runs NO tests today (3 workflows, structural-only fakes): the
same class of gap where ~6 fabro-launcher defects surfaced only at live e2e.

The single make-or-break unknown of THIS ADR's leg was credential-shape for
the BUILD egress. The real bc-base install blocks pull from org-pinned repos
whose credentials agent-vault injects on-wire (invariant #2 / IS-2), so a
dagger build must route its build-time `RUN` egress THROUGH agent-vault rather
than reaching the network directly. The recon baseline found the opposite: a
default dagger engine has DIRECT egress and bypasses agent-vault entirely
(`01a-egress.md` Finding 0) — for the real bc-base that is not merely untidy,
it would auth-fail on the org repos. Forcing traffic through agent-vault is
REQUIRED, not optional, and it had to be achieved WITHOUT editing the shipped
Dockerfile (IS-3 / no-divergence). The spike proved the recipe end-to-end on
dagger v0.21.7; this ADR pins it as the credential-surface contract for the
graduated module so it is a settled boundary, not a per-run improvisation.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

No BC source read, run, or git-observed. Verified against this repo's
`features/`, `adr/`/`pdr/`, message schemas, `shop-msg` mailbox state, and
scenario hashes via the installed `scenarios hash` CLI on 2026-07-02. Per
spike-vehicle ADR-032, the spike's `findings/dagger-spike/*.md` (00 recon, 01
target-spec, 01a egress, 02 experiment, 02a experiment) are the artifact
surface for this graduation:

1. **Default engine egress BYPASSES agent-vault (the IS-2 hole)**
   (`01a-egress.md` Finding 0): a default dagger engine with no proxy builds
   the egress Dockerfile DIRECTLY (apt/PyPI/GitHub all reachable without
   agent-vault). Forcing traffic through agent-vault is required to preserve
   IS-2 for the org-pinned framework CLIs.

2. **`--build-arg http_proxy` is a DEAD END under dagger** (`01a-egress.md`
   Finding 2): dagger's `dockerBuild` treats `--build-args` purely as
   Dockerfile `ARG` values and does NOT implement docker/BuildKit's
   predefined-proxy-ARG auto-injection into `RUN` env — a build pointed at a
   bogus proxy still reached GitHub direct (`GITHUB_HTTP=200`), proving the
   `RUN` ignored the proxy build-args. The docker `--build-arg http_proxy`
   convention does not apply.

3. **BuildKit PROPAGATES the engine daemon's proxy env into every `RUN`**
   (`01a-egress.md` Finding 3): setting `HTTP(S)_PROXY`/`NO_PROXY` as ENV on
   the engine container (pointed at via `_EXPERIMENTAL_DAGGER_RUNNER_HOST`)
   populates all four proxy vars in a build-time `RUN` with ZERO Dockerfile
   edits — the clean, no-divergence proxy lever. The proxy handle must be the
   agent-vault IP (`192.168.0.2`), not DNS, and the engine must JOIN the
   `shopsystem` docker net (192.168.0.0/20) or a default-bridge engine times
   out to the proxy (Finding 1).

4. **Three provisioning facts pinned** (`02-dagger-experiment.md` §(b)
   NEW-A/B/C): **NEW-A** — `NO_PROXY` needs registry APEX entries because Go's
   `httpproxy` treats leading-dot `.mcr.microsoft.com` as subdomains-only, so
   the apex base-image pull was still MITM'd (x509); adding apex forms lets
   public base pulls stay DIRECT (bc-base FROMs a public
   `mcr.microsoft.com/devcontainers` base). **NEW-B** — the Python-SDK
   module's runtime codegen (Go proxy, PyPI) runs INSIDE the target engine and
   x509-failed against the MITM; whitelisting dagger-infra hosts
   (`proxy.golang.org, sum.golang.org, storage.googleapis.com, pypi.org,
   .pythonhosted.org`) in `NO_PROXY` lets the infra egress build DIRECT while
   `github.com` stays PROXIED (IS-2 intact for the org downloads). **NEW-C** —
   the docker daemon cannot see host scratchpad mounts (`docker run -v` is
   silently inert against the daemon's fs view); engine config
   (`/etc/dagger/engine.toml`) is injected via `docker cp` + `docker restart`,
   NOT a host `-v` mount.

5. **The dummy-secret seam is proven** (`02-dagger-experiment.md` §(b),
   `02a-experiment.md`): dagger secrets carry ONLY dummy values; the
   `cmd://`/`env://` seam runs a fetch on the CLIENT HOST and inherits host
   `HTTPS_PROXY`; agent-vault injects the real credential on-wire and dagger
   scrubs the value. Context was fetched read-only via `gh api` with a dummy
   `GH_TOKEN` (proxy injects) and not persisted. Nothing real is ever in a
   dagger secret or an image layer (IS-2). The engine runs `--privileged` on
   the `shopsystem` net.

6. **@scenario_hash retirement enumeration -- EMPTY (nothing retired).**
   `grep -r "@scenario_hash" features/` carries NO scenario pinning a dagger
   build egress, agent-vault-build-credential, or NO_PROXY/BuildKit-proxy
   behavior (no dagger pin exists in `features/` at all;
   `features/dagger-ci/` does not yet exist). The existing
   `features/bc-launcher/*.gherkin` credential pins (45 claude-oauth-brokered,
   46 github-brokered, 47 agent-vault-reachability, 50
   no-real-credential-observable) and `features/fabro-orchestration/02`
   (ADR-049) pin the bc-container LAUNCH/RUNTIME credential path — a DISTINCT
   surface the dagger BUILD egress does not duplicate or retire. This ADR
   authors no Gherkin and retires no pinned coverage; the new
   `features/dagger-ci/04` pin is net-new lead-process contract, authored by
   lead-po next (mirrors ADR-051 finding 6 / ADR-049 finding 5).

## Decision

### D1 -- Dagger secrets carry ONLY dummy values; agent-vault injects real creds ON-WIRE, so nothing real is ever in a dagger secret or an image layer (realizes hard-invariant #2 / IS-2; EXTENDS ADR-049; anchored on ADR-028)

Under the dagger build substrate, **every real credential is brokered by
agent-vault (ADR-028) and only appears on the wire.** Dagger's native secret
system is a FORBIDDEN surface, exactly as fabro's native vault is under
ADR-049:

- Every dagger secret (`GITHUB_TOKEN`, etc.) holds only a DUMMY value; the
  agent-vault MITM proxy injects the real credential on-wire. No real
  credential is ever written to a dagger secret or baked into an image layer
  (IS-2).
- The client-side bridge is a `cmd://`/`env://` fetch that runs on the CLIENT
  HOST and inherits the host `HTTPS_PROXY`; dagger scrubs the fetched value.
  Read-only context fetches (`gh api` with a dummy `GH_TOKEN`, proxy injects)
  are pulled into scratchpad and NOT persisted (pre-state finding 5).
- A dagger definition that stores or reads a real secret from a native secret
  store, or bakes a real credential into a build layer, violates this
  contract. This is the build-pipeline analog of ADR-049 D1.

### D2 -- The engine-egress recipe forces build-time RUN egress THROUGH agent-vault with ZERO Dockerfile edits: privileged engine on the shopsystem net, proxy env on the daemon propagated by BuildKit, agent-vault IP not DNS (realizes IS-2 + IS-3/no-divergence; anchored on ADR-028, ADR-021)

The make-or-break egress leg is RESOLVED as a fixed recipe (pre-state findings
1-3):

- The dagger engine runs `--privileged` and is JOINED to the `shopsystem`
  docker network (192.168.0.0/20); a default-bridge engine has no route to the
  proxy at 192.168.0.2 and times out.
- `HTTP(S)_PROXY` is set as ENV on the ENGINE DAEMON to the agent-vault handle
  using the IP (`192.168.0.2:14322`), not DNS. BuildKit PROPAGATES the
  daemon's proxy env into every build-time `RUN` — so the org-pinned egress
  runs route through agent-vault with ZERO Dockerfile edits, keeping the
  shipped Dockerfile verbatim (IS-3 / no-divergence, the ADR-053 sibling
  guarantee).
- The docker `--build-arg http_proxy` convention is a DEAD END (finding 2):
  dagger's `dockerBuild` ignores predefined-proxy ARGs. The engine-daemon
  proxy env is the ONLY working lever. This forces traffic through agent-vault
  by construction, closing the IS-2 direct-egress hole (finding 1/Finding 0).

### D3 -- Three provisioning facts make the recipe reproducible: NO_PROXY registry apex, dagger-infra whitelist with github proxied, engine config via docker cp (pins the pre-state finding-4 NEW-A/B/C mechanism facts)

The D2 recipe only WORKS because of three v0.21.7 provisioning facts, pinned
here as part of the contract (a future dagger version change against any of
them reopens the recipe):

1. **NEW-A -- `NO_PROXY` needs registry APEX entries.** Go's `httpproxy`
   leading-dot rule treats `.mcr.microsoft.com` as subdomains-only, so the
   apex base-image pull was still MITM'd and x509-failed. Add the APEX forms
   (alongside the leading-dot forms) so PUBLIC base-image pulls go DIRECT with
   standard CAs and no creds. bc-base FROMs a public
   `mcr.microsoft.com/devcontainers` base, so this keeps the primary target's
   base pull direct.
2. **NEW-B -- whitelist dagger-infra hosts while github stays PROXIED.** The
   Python-SDK module's runtime codegen (Go module proxy, PyPI) runs INSIDE the
   target engine and x509-failed against the MITM. Whitelisting the
   dagger-infra hosts (`proxy.golang.org, sum.golang.org,
   storage.googleapis.com, pypi.org, .pythonhosted.org`) in `NO_PROXY` lets
   that infra egress build DIRECT, while `github.com` stays PROXIED so the
   fabro/agent-vault org downloads route through agent-vault (IS-2 intact).
   The proxied/direct split is the load-bearing distinction: infra is public,
   the org downloads are credentialed.
3. **NEW-C -- engine config via `docker cp` + restart, NOT `-v`.** The docker
   daemon cannot see host scratchpad mounts — a `docker run -v` is silently
   inert against the daemon's fs view (daemon fs view != devcontainer shell).
   Engine config that must live inside the engine
   (`/etc/dagger/engine.toml` — e.g. the insecure-registry marker for the
   local `registry:2` spike leg) is injected with `docker cp` + `docker
   restart`.

Note the bounded caveat pinned separately in ADR-055: the engine's
`SSL_CERT_FILE` does NOT make the BuildKit dockerfile-frontend resolver trust
the MITM CA (Finding 4), and the `RUN` filesystem needs the CA in its OWN
trust store — the CA-trust prerequisite is MITM-LOCAL infra, NOT a shipped-path
IS-3 bend. This ADR pins the PROXY-ROUTING half (clean, no Dockerfile edit);
ADR-055 scopes the CA-TRUST half.

## Consequences

- **The build-egress credential surface is a settled boundary.** The graduated
  dagger module inherits a fixed contract: dagger secrets = dummy only, real
  creds via agent-vault on the wire, github proxied while public base +
  dagger-infra go direct. This is the credential-surface leg of the ADR-052
  umbrella, alongside ADR-053 (no-divergence) and ADR-055 (CA-trust carve-out).
- **The ADR-049 contract now covers both loop AND build.** Agent-vault is the
  SOLE credential surface across the fabro RUNTIME loop (ADR-049) and the
  dagger BUILD pipeline (this ADR); native secret stores (fabro's vault,
  dagger's secrets) are the forbidden surface in both.
- **No new credential-injection machinery is introduced.** The recipe routes
  BuildKit `RUN` egress through the existing agent-vault MITM substrate
  (ADR-028); the only new artifacts are engine env/`NO_PROXY` provisioning and
  the `cmd://` dummy-secret seam — no new broker or secret store.
- **The recipe is version-coupled to dagger v0.21.7** (D3): the NEW-A/B/C
  provisioning facts and the BuildKit daemon-proxy propagation are the
  load-bearing behavior. A future dagger that implements predefined-proxy
  build-args, changes the `NO_PROXY` matching, or injects a CA into `RUN` must
  be re-verified against this ADR.
- **The `features/dagger-ci/04-agent-vault-egress-github-proxied-base-direct-dummy-creds.gherkin`
  pin references this ADR** and its block-only `@scenario_hash` value is
  recorded here at graduation reconcile (defense-in-depth: lead-architect
  VERIFIES the PO-authored hash via the installed `scenarios hash` CLI, does
  NOT introduce it) -- `@scenario_hash:2c13b47417b86d09`, recomputed block-only
  and VERIFIED by lead-architect at the 2026-07-02 graduation-reconcile
  boundary to reproduce the PO-authored tag. It asserts: build-time `RUN` egress (fabro/agent-vault github
  release downloads) routes THROUGH agent-vault (github proxied), public
  base-image pulls stay DIRECT (NO_PROXY apex, NEW-A), dagger-infra hosts build
  DIRECT (NEW-B), dummy creds only with the proxy injecting real on-wire. No
  `@scenario_hash` is retired (pre-state finding 6).

## Follow-ups / dependencies (named, not designed here)

- **CA-trust base decision (residual bead, refs ADR-055/ADR-045).** The
  build-time CA-trust prerequisite for the local MITM loop (org CA-base `FROM`
  vs a base variant carrying the CA + the
  `SSL_CERT_FILE`/`REQUESTS_CA_BUNDLE`/`PIP_CERT`/`GIT_SSL_CAINFO` env fan) is
  scoped MITM-local by ADR-055; the WHICH decision is deferred. It informs the
  Slice-4 dispatch.
- **Private-GHCR engine-resolver CA trust (residual bead, refs 01a Finding 4).**
  The engine `SSL_CERT_FILE` did NOT satisfy the dockerfile-frontend resolver;
  a private-GHCR base pull (e.g. bc-lead's `FROM bc-base:vX`) needs
  proxy+creds+engine-CA. Sidestepped in Slice 2 by resolving bc-lead from the
  freshly-built local base; unexercised, resolve for the real bc-lead CI leg.
- **Slice-4 productionization dispatch (child of lead-fzxt).** The module +
  WRAP is NET-NEW CI behavior -> `assign_scenarios` to shopsystem-bc-launcher
  carrying the four `features/dagger-ci/` pins (this ADR's egress recipe is
  provisioned by the launcher's own CI, IS-5/ADR-021). Re-run the empty
  `@scenario_hash` enumeration and cite the contract-surface pre-state
  (ADR-018 D1) in the dispatch description. Run the dispatch UNDER
  `--orchestrator fabro` (dogfood, ADR-051 Reviewer gap). Not designed here.

## Alternatives considered

- **Bake a real credential into the container/build env, or use dagger's
  native secret store for real creds.** Rejected (D1): that violates
  hard-invariant #2 / ADR-049 and forks credential authority away from
  agent-vault — a real secret at rest in a dagger secret or an image layer.
  The dummy-on-secret, real-on-wire posture keeps the credential out of every
  at-rest surface.
- **Accept the default engine's DIRECT build egress as policy.** Rejected
  (D2): the default engine bypasses agent-vault entirely (Finding 0), which
  breaks IS-2 and would auth-fail on the org-pinned framework CLIs. Egress
  MUST route through agent-vault.
- **Route the proxy via docker's `--build-arg http_proxy` convention.**
  Rejected (D2): dagger's `dockerBuild` IGNORES predefined-proxy build-args
  (Finding 2, proven with a bogus-proxy control that still reached GitHub
  direct). The engine-daemon proxy env propagated by BuildKit is the only
  working lever.
- **Mount the engine config via a host `-v` bind.** Rejected (D3 / NEW-C): the
  docker daemon cannot see host scratchpad mounts; a `-v` mount is silently
  inert against the daemon's fs view. Engine config is injected via `docker
  cp` + `docker restart`.
- **Edit the real Dockerfile to add the proxy/CA plumbing.** Rejected (IS-3 /
  no-divergence, ADR-053): the shipped path must stay verbatim. The
  proxy-routing half needs ZERO Dockerfile edits (D2); the CA-trust half is
  scoped as MITM-LOCAL infra by ADR-055, explicitly NOT a shipped-path bend.
