# ADR-055 -- The build-time CA-trust prerequisite for the MITM-local dagger loop is local infrastructure, explicitly NOT a shipped-path IS-3 divergence: the real bc-base trusts the agent-vault CA only at runtime; the local MITM loop needs a build-time CA-trust base layer; real CI has public egress and is unaffected

- Status: Accepted (2026-07-02)
- Date: 2026-07-02
- Implements: the dagger-spike hard invariant **no-divergence (IS-3)** — the
  real Dockerfile/tests/publish path is exercised verbatim, never edited to
  suit the harness — pinned here as a bounded CARVE-OUT that certifies the
  local-loop CA-trust prerequisite is NOT a bend of that invariant. Graduates
  the Slice-2 CA-trust verdict (`findings/dagger-spike/02-dagger-experiment.md`
  §(d), `01a-egress.md` Finding 5) via the odqd iterative-experimentation
  track (spike -> learn -> throw away -> graduate via ADRs + scenarios). The
  spike-vehicle product decisions are SETTLED under ADR-029/030/032 and are NOT
  re-litigated here.
- Anchored on (decisions this builds on -- NOT re-decided here):
  - [ADR-052](052-dagger-is-the-local-and-ci-build-test-substrate-wrap-not-replace-publish-bc-base.md)
    -- the umbrella dagger graduation decision (ONE engineVersion-pinned module
    over ONE build core, WRAP-not-REPLACE `publish-bc-base.yml`); this ADR is a
    SIBLING realization of that umbrella, scoping one operational tension of the
    local build leg.
  - [ADR-054](054-agent-vault-is-sole-credential-surface-for-the-dagger-build-egress.md)
    -- agent-vault is the sole credential surface for the dagger build egress
    (privileged engine on the shopsystem net, BuildKit-propagated proxy,
    NO_PROXY apex + dagger-infra whitelist). This ADR is the BOUNDED
    prerequisite/carve-out of ADR-054: it delimits WHERE 054's MITM egress
    needs an extra build-time layer, and certifies that layer is not a
    shipped-path IS-3 divergence.
  - [ADR-045](045-agent-vault-ca-pem-is-inline-pem-content-not-a-path.md)
    -- `AGENT_VAULT_CA_PEM` carries inline PEM content (real newlines), the
    MITM trust material; this ADR scopes the build-time env fan
    (`SSL_CERT_FILE`/`REQUESTS_CA_BUNDLE`/`PIP_CERT`/`GIT_SSL_CAINFO`) that a
    local CA-trust base layer must set so pip/git/python validate against that
    CA during `RUN` egress.
  - [ADR-021](021-bc-base-image-owned-by-bc-launcher-auto-rebuilds-on-utility-release.md)
    -- the bc-base image is owned by bc-launcher; the shipped Dockerfile whose
    verbatim shape (IS-3) this carve-out protects belongs to that BC, so the
    which-base decision is a BC dispatch, never a lead edit (IS-5).
  - [ADR-018](018-empirical-verification-is-contract-surface.md) /
    [PDR-011](../pdr/011-empirical-verification-is-contract-surface.md) --
    empirical verification is the contract/artifact surface; the CA-trust
    verdict below was proven on-host against the artifact surface, never by
    reading or running BC source. Per spike-vehicle ADR-032 the spike's
    `findings/dagger-spike/*.md` are that artifact surface.
- Bead: lead-fzxt (P1 dagger-spike epic, proof banked 2026-07-02). Realizes the
  no-divergence (IS-3) carve-out leg; SIBLING of ADR-053 (no-divergence) and
  ADR-054 (agent-vault egress) under the ADR-052 umbrella; bounded
  prerequisite/carve-out of ADR-054.

## Context

bc-launcher CI verifies bc-base STRUCTURALLY only — three workflows, NONE run
tests; the pytest suite fakes docker/git/github and `test_bc_base_*` assert
Dockerfile TEXT, never a built image (`findings/dagger-spike/00-dagger-recon.md`).
That structural-only middle is the fabro empty-middle gap: for the fabro
launcher, ~6 real defects surfaced only at live end-to-end because no leg
between "the Dockerfile text looks right" and "the shipped image works" ever
built and ran the real thing. ADR-052 closes that gap by adding a real-image
tier via a dagger module that builds the real `docker/bc-base/Dockerfile`
VERBATIM (IS-2/IS-3), and ADR-054 lets that build egress through agent-vault so
the local loop needs no real credentials.

That local loop runs the real build behind an agent-vault MITM proxy. This ADR
resolves the one operational tension that setup exposes: the real bc-base
Dockerfile establishes CA trust only at container RUNTIME, so building it
verbatim through a MITM engine fails on the first egress `RUN` — the local loop
needs a build-time CA-trust prerequisite. The load-bearing question is whether
supplying that prerequisite bends the no-divergence invariant (IS-3). It does
not: the tension is MITM-local only; under real CI (public egress, no MITM) the
Dockerfile is verbatim as-is.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

No BC source read, run, or git-observed. Verified against this repo's
`features/`, `adr/`/`pdr/`, message schemas, `shop-msg` mailbox state, and
scenario hashes via the installed `scenarios hash` CLI on 2026-07-02. Per
spike-vehicle ADR-032, the spike's `findings/dagger-spike/*.md` (00/01/01a/02/
02a) are the artifact surface for this graduation:

1. **CA-trust verbatim-for-free is DENIED — verified, not asserted**
   (`02-dagger-experiment.md` §(d), `01a-egress.md` Finding 5). The real
   332-line bc-base Dockerfile's FIRST egress `RUN` is line 70
   (`pip install git+https://github.com/dstengle/…`). There is NO
   `update-ca-certificates` / agent-vault CA-trust step anywhere before the
   egress RUNs — `agent-vault-ca.sh` is only `COPY`'d ~line 255 and wired as
   the RUNTIME `ENTRYPOINT`. So the real bc-base establishes CA trust ONLY at
   container runtime, never at build time (correct under real CI, which has
   direct public egress).

2. **The MITM build REDs at line 70, and the RED is a trust failure, not a
   proxy failure** (`02-dagger-experiment.md` §(d)). Through the MITM engine
   the full verbatim build pulls the public base OK (ADR-054 NEW-A / NO_PROXY
   apex) and then REDs at line 70 with `SSL certificate problem: unable to get
   local issuer certificate` (x509, exit 1). The git clone REACHED github
   THROUGH agent-vault (the proxy works), but `python:3.11` does not trust the
   Agent Vault Root CA.

3. **There is no engine-level channel to inject a CA FILE into a `RUN`
   filesystem** (`01a-egress.md` Finding 5). A `RUN`'s rootfs is the base
   image's; the only CA-file delivery channels are the BASE IMAGE, a Dockerfile
   `COPY`, or `RUN --mount=type=secret`. The latter two EDIT the Dockerfile
   (an IS-3 bend); therefore the sanctioned channel for the local loop is the
   base image. Confirmed by making the base trust the CA → egress then
   succeeded (`01a-egress.md` Finding 6, full egress SUCCESS).

4. **The tension is MITM-LOCAL only; the shipped path is unaffected**
   (`02-dagger-experiment.md` §(d)/(e)). Under real CI (public egress, no MITM)
   the same verbatim Dockerfile is correct as-is — CA trust at runtime is the
   right place because CI's build egress goes directly to public endpoints. So
   the CA tension exists exclusively inside the local MITM loop, not in the
   pipeline the release path runs.

5. **@scenario_hash retirement enumeration — EMPTY (nothing retired).**
   `grep -r "@scenario_hash" features/` carries NO scenario pinning a
   dagger/CI-build, real-image-tier, agent-vault build-egress, or CA-trust
   behavior (`features/dagger-ci/` does not yet exist). The four graduation
   pins under `features/dagger-ci/` are NET-NEW; nothing is retired,
   superseded, or contradicted (mirrors ADR-051 pre-state finding 6). The
   existing `features/bc-launcher/*.gherkin` pin launcher CLI runtime commands
   (launch/attach/inject/monitor), a DISTINCT surface these scenarios do not
   duplicate.

## Decision

### D1 -- CA-trust-verbatim-for-free is DENIED: the local MITM build of the real bc-base Dockerfile REDs at its first egress RUN, and that RED is a trust gap, not a proxy gap (grounds the carve-out; anchored on ADR-054, ADR-045)

The real bc-base Dockerfile trusts the agent-vault CA ONLY at container runtime
(`agent-vault-ca.sh` is the `ENTRYPOINT`, COPY'd ~line 255), and its first
egress `RUN` is line 70. Building it verbatim through the ADR-054 MITM engine
therefore RUNs the proxy correctly — the public base pulls OK, git reaches
github through agent-vault — and then fails with x509 `unable to get local
issuer certificate` because `python:3.11` does not carry the Agent Vault Root
CA in its build-time trust store. This is a positive, verified fact of the
build (pre-state findings 1–2), not an assertion: proxy reachability and
build-time CA trust are SEPARATE requirements, and ADR-054 satisfies only the
first.

### D2 -- The local MITM loop requires a build-time CA-trust PREREQUISITE delivered via the BASE IMAGE, never via a Dockerfile edit (realizes IS-3 by protecting the shipped Dockerfile; anchored on ADR-045, ADR-021)

Because a `RUN`'s rootfs is the base image's and the only non-Dockerfile-editing
CA-file channel is the base image (pre-state finding 3), the local loop supplies
the CA at build time by RESOLVING the real Dockerfile's `FROM` against a
sanctioned CA-trust base — either an org CA-base `FROM`, or a base variant
carrying the CA plus the Python/pip/git build-time env fan (`SSL_CERT_FILE`,
`REQUESTS_CA_BUNDLE`, `PIP_CERT`, `GIT_SSL_CAINFO`, per the ADR-045 inline-PEM
CA). The real Dockerfile body stays BYTE-VERBATIM (IS-3): the prerequisite is
supplied as build context / base selection outside the Dockerfile, not as an
inserted `COPY`/`update-ca-certificates` line. Editing the real Dockerfile to
add a build-time CA step is explicitly FORBIDDEN — it would bend IS-3 on the
shipped path. Because bc-base is bc-launcher-owned (ADR-021, IS-5), the WHICH-
base choice is a BC-side decision carried as a follow-up bead, not decided here.

### D3 -- This CA-trust prerequisite is MITM-LOCAL infrastructure ONLY and is NOT a shipped-path IS-3 divergence (realizes the no-divergence carve-out; anchored on ADR-052, ADR-054)

Under real CI the build has direct public egress and no MITM, so the verbatim
Dockerfile — trusting the agent-vault CA at runtime, no build-time CA step — is
correct AS-IS (pre-state finding 4). The build-time CA-trust prerequisite exists
EXCLUSIVELY to let the local loop reproduce the real build behind the MITM
proxy; it never touches the pipeline the release path runs. Therefore this
prerequisite is local test-harness infrastructure, in the same class as the
privileged engine and the shopsystem-net join of ADR-054, and is NOT a bend of
the no-divergence invariant (IS-3). Treating the CA tension as a shipped-path
concession would be a false read of the evidence: the shipped path is unaffected.

## Consequences

- **The no-divergence invariant is preserved with a documented boundary.** The
  local loop gains a build-time CA-trust base while the real Dockerfile stays
  byte-verbatim (D2); reconciliation can trust that the local dagger build
  exercises the shipped install blocks unchanged, and that any CA machinery is
  base-selection furniture outside the Dockerfile, not an IS-3 edit.
- **ADR-054's egress recipe is bounded, not open-ended.** ADR-054 delivers
  proxy reachability; this ADR names the ONE additional build-time requirement
  (CA trust in the `RUN` trust store) that reachability does not cover, and
  fixes its sanctioned delivery channel (base image, not Dockerfile edit).
- **The which-base choice is deferred, on purpose.** D2 fixes the CONTRACT (base
  image channel, verbatim Dockerfile, ADR-045 env fan) but not the SELECTION
  (org CA-base `FROM` vs. a CA-carrying base variant); that is a bc-launcher-
  owned decision (ADR-021/IS-5) carried as a follow-up bead below.
- **@scenario_hash pins.** This ADR authors no Gherkin and is NOT directly
  referenced by any `features/dagger-ci/` pin — it is a shipped-path-invariant
  carve-out (a lead-process constraint on how the local loop is built), not a
  pinned build behavior; the CA-trust requirement is exercised implicitly when
  scenario 04 (`features/dagger-ci/04-agent-vault-egress-…`, ADR-054) builds
  through the MITM engine. Where a `features/dagger-ci/` pin DOES reference an
  ADR, the block-only `@scenario_hash` is recorded on that ADR under
  defense-in-depth: the PO INTRODUCES the hash at authoring, and lead-architect
  VERIFIES it (recompute via the installed `scenarios hash` CLI over the
  Scenario:→EOF block) on the graduation/dispatch boundary rather than
  introducing it. No `@scenario_hash` is retired (pre-state finding 5).

## Follow-ups / dependencies (named, not designed here)

- **CA-trust base decision (bead, refs ADR-055/ADR-045).** Choose the sanctioned
  build-time CA-trust prerequisite for the local MITM dagger loop — an org
  CA-base `FROM`, vs. a base variant carrying the CA plus the
  `SSL_CERT_FILE`/`REQUESTS_CA_BUNDLE`/`PIP_CERT`/`GIT_SSL_CAINFO` env fan. This
  ADR scopes it MITM-local and fixes the delivery channel (base image); the
  WHICH decision is a bc-launcher-owned dispatch, deferred. Informs the Slice-4
  dispatch.
- **Private-GHCR engine-resolver CA trust (bead, refs ADR-054, `01a` Finding 4).**
  The engine `SSL_CERT_FILE` did NOT satisfy the dockerfile-frontend resolver
  for a private-GHCR `FROM bc-base:vX`; sidestepped in Slice 2 by resolving
  bc-lead from the freshly-built local base. Unexercised; resolve for the real
  bc-lead CI leg.
- **Structural-suite fold decision (bead, Slice-4 reconciliation).** Whether the
  `test_bc_base_*` Dockerfile-shape text-pins fold into the real-image tier once
  dagger builds the real image is a BC reconciliation call, not pre-decided;
  keep both the fast structural tier and the real-image tier until then.

## Alternatives considered

- **Route the local build egress DIRECT to sidestep the CA entirely.** Rejected
  (D1/D3): direct build egress violates IS-2 and ADR-054 (agent-vault is the
  sole credential surface for the dagger build egress). The MITM is the point;
  the CA-trust requirement is the cost of keeping creds off the node, not a
  reason to abandon the broker.
- **Edit the real bc-base Dockerfile to add a build-time
  `update-ca-certificates` / `COPY` CA step.** Rejected (D2): the shipped path
  must stay byte-verbatim (IS-3/no-divergence); a build-time CA step is wrong
  under real CI (which has public egress and trusts CA at runtime) and would
  fork the local loop's Dockerfile from the shipped one — exactly the
  divergence the graduation exists to forbid.
- **Deliver the CA via `RUN --mount=type=secret`.** Rejected (D2): that too
  edits the Dockerfile (a `--mount` on the real `RUN` lines), bending IS-3; the
  base-image channel delivers the CA with ZERO Dockerfile edits.
- **Treat the CA tension as a shipped-path IS-3 bend and document it as a known
  divergence.** Rejected (D3): false read of the evidence — under real CI the
  verbatim Dockerfile is correct as-is (pre-state finding 4). The tension is
  MITM-local test infrastructure only; calling it a shipped-path bend would
  mislabel local harness furniture as a release-path concession.
</content>
</invoke>
