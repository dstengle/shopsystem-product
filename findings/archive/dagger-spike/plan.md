# Dagger local-build loop — plan & running log

**Started:** 2026-07-02 (David executive decision: **dagger.io**, not act). Run like the
fabro effort. **Epic:** lead-fzxt. **Track:** odqd iterative-experimentation (spike →
learn → throw away → graduate via ADRs+scenarios → productionize via BC dispatch).
**Branch:** `dagger-spike` (off main; main untouched at 199b495).

## Goal (success criterion)

A **dagger pipeline that runs the REAL bc-base/bc-launcher build + test (+ the fabro
e2e) definition LOCALLY** — the *same* definition locally and in CI — so launcher/image
defects are caught in a fast local loop **before** the version-tag → publish-bc-base.yml
→ GHCR release round-trip.

**Why:** the fabro launcher productionization (epic lead-kqgp, DONE) took ~6 fix rounds,
*every* defect caught only at the live end-to-end, because the bc-launcher build host
verifies STRUCTURALLY (no docker/fabro/agent-vault) and its agent is context-limited.
A local dagger loop closes that gap.

**Success = Slice 2 green:** a local dagger run reproduces the real build+test and
CATCHES a defect the current structural-only loop misses (e.g. re-run one of the 6
fabro-launcher live-only bugs and show dagger REDs on it locally, before any release).

## Hard invariants (do NOT violate)

1. **NO divergence from the real pipeline** — dagger runs the real Dockerfile / tests /
   publish definition, not a hand-built variant. (David explicit: "doesn't deviate too
   far.") Ideally the SAME dagger module runs locally and is what GHA invokes.
2. **Credentials via agent-vault**, not baked secrets (same as fabro's invariant #2).
3. **Official release path preserved** — dagger is the local fast-feedback loop and/or
   the same engine CI invokes; the version-tag → publish-bc-base.yml → GHCR publish
   contract stays intact.
4. **bc-launcher owns its CI/build** — productionize by DISPATCH to shopsystem-bc-launcher,
   never lead edits of BC source (ADR-018).
5. **main untouched** during the spike (dagger-spike branch). Graduate via ADRs+scenarios.

## Provisional slices (refine after Slice 0)

- **Slice 0 — dagger recon.** Install dagger + run a trivial pipeline locally; document
  its model (Functions/SDK/Shell, the engine, containerized build, caching, secrets →
  how to bridge to agent-vault); characterize the REAL bc-launcher CI (publish-bc-base.yml
  + the bc-base Dockerfile + the launcher test setup) via read-only `gh` on the public
  repo (no BC source cloned to the host); identify the "seams / invariant surfaces."
  → `00-dagger-recon.md`.
- **Slice 1 — spec the target.** The exact bc-base build + launcher test (+ fabro e2e)
  pipeline dagger must run, and the "same-as-CI, no-divergence" contract.
- **Slice 2 — experiment.** A local dagger pipeline that builds bc-base + runs the
  launcher tests locally and PROVES it REDs on a fabro-style defect the structural loop
  missed (the throwaway proof).
- **Slice 3 — graduate.** ADRs (dagger as local-build/CI substrate; same-definition
  locally+in-CI; agent-vault creds; relationship to publish-bc-base.yml) + scenarios.
- **Slice 4 — productionize.** Dispatch to shopsystem-bc-launcher to dagger-ify its real
  CI (runs locally + in GHA). Reconcile.

## Execution discipline

- Drive via workflows/subagents; keep main-loop context minimal (read slice summaries;
  detail in `findings/dagger-spike/`).
- Throwaway experiments on `dagger-spike`; copious notes per slice.
- Read-only `gh` on the public bc-launcher repo to understand its CI is the disciplined
  way to characterize the pipeline (as the architects did during fabro) — do NOT clone
  BC source onto the lead host; the real dagger-ification is the BC's job (Slice 4).

## Running log

- 2026-07-02: epic lead-fzxt activated; `dagger-spike` cut off main; plan persisted.
  Launching Slice 0 recon.
- 2026-07-02: **Slice 0 DONE** (legs A/B/C + synthesis `00-dagger-recon.md`). Result:
  dagger v0.21.7 installed & proven on this host — real-Dockerfile `docker-build` +
  `with-exec` RED-propagation + `cmd://` client-side agent-vault secret bridge + identical
  `dagger call` locally and via `dagger/dagger-for-github`; the real bc-launcher CI is 3
  workflows and NONE run tests (structural-only fakes = the exact fabro empty-middle gap);
  mapped 3 seams (A build+push CLEAN, B test-loop relocation-only, C fabro-e2e PARTIAL) +
  5 invariant surfaces; contract is WRAP-not-REPLACE `publish-bc-base.yml`. **No blockers.**
  → **Slice 1:** spec ONE engineVersion-pinned Python-SDK module (local `build-and-test`
  + CI `build-test-and-push` over the same build core, GHA becomes a thin
  `dagger/dagger-for-github` wrapper preserving IS-1/IS-4). Make-or-break design item to
  resolve first: agent-vault egress into the dagger engine + BuildKit `RUN` steps (engine
  carries no proxy/CA today) — proxy+MITM-CA injection vs. accept direct build egress.
- 2026-07-02: **Slice 1a EGRESS leg DONE** (`01a-egress.md`). Make-or-break RESOLVED:
  egress-through-agent-vault WORKS for BuildKit `RUN`, proven end-to-end (PyPI + git+https +
  api.github.com all 200/OK through the MITM proxy, agent-vault handle = sole cred, IS-2 held).
  Recipe = two halves: (1) PROXY routing is CLEAN/no-Dockerfile-edit — set `HTTP(S)_PROXY`+
  `NO_PROXY` on a privileged engine JOINED to the `shopsystem` net; BuildKit propagates daemon
  proxy env into every `RUN` (docker's `--build-arg http_proxy` convention is IGNORED by dagger
  — dead end). (2) MITM CA trust must come from the BASE IMAGE (no engine knob injects a CA file
  into a `RUN` rootfs) — the ONE IS-3 tension; verify whether real bc-base already trusts the
  agent-vault CA early → verbatim-for-free, else one-line org-CA-base `FROM` (never direct
  egress = IS-2 violation). Open item: private-GHCR engine-resolver CA trust (bc-lead `FROM
  bc-base:vX`) unresolved; public bc-base base unaffected via `NO_PROXY`.
- 2026-07-02: **Slice 1 DONE** — target spec written (`01-dagger-target-spec.md`). Specifies
  (1) ONE Python-SDK module (`engineVersion` v0.21.7) over ONE build core: `build-and-test`
  (LOCAL: real bc-base/bc-lead `dockerBuild` verbatim + structural pytest tier + NEW real-image
  tier running the freshly-built image — fabro/shim/scenarios/bd/gh live self-checks) and
  `build-test-and-push` (CI: same core + GHCR dual-tag-one-digest push, IS-4); inputs/build-args,
  the `cmd://` agent-vault secret seam (IS-2), the `01a` engine egress recipe, and the
  same-`dagger call`-locally-and-in-GHA no-divergence property. (2) WRAP-not-REPLACE
  `publish-bc-base.yml` before/after: swap ONLY `docker/build-push-action@v6` for a
  `dagger/dagger-for-github` call; keep `v*` trigger, GHCR cred source, dual-tag, OCI labels,
  visibility PATCH, rollback (IS-1/IS-4/IS-5). (3) Seam-C fabro-e2e as an optional advanced
  `fabro_e2e` fn (docker-socket nesting + agent-vault net — the hard, highest-value part).
  (4) Slice-2 acceptance criteria. (5) Dogfood-fabro Slice-4 dispatch angle.
  → **Slice 2 recommendation:** BUILD the throwaway. First resolve the CA-trust verify item
  (does real bc-base trust the agent-vault CA before its egress RUNs); then run
  `dagger call build-and-test` against the real bc-base, and PROVE it REDs on a fabro-style
  defect the structural loop misses (sharpest: shim-not-a-listener via the real-image `listen`
  smoke, or a bad `FABRO_VERSION` asset-URL 404 at build-time). Show the structural suite stays
  GREEN while dagger goes RED locally, before any tag. **No blockers; egress resolved.**
- 2026-07-02: **Slice 2 DONE — the LOAD-BEARING PROOF is GREEN** (`02-dagger-experiment.md`;
  detail `02a-experiment.md`). **PROVED:** dagger, building the real bc-base fabro/agent-vault
  install blocks BYTE-VERBATIM through the agent-vault MITM engine + a real-image tier, REDs
  LOCALLY on a fabro-style defect the structural pytest gate stays GREEN on — before any tag.
  **Two clean splits:** (1) sha256 sidecar `.sha256`→`.sha256sum` (a bead-0fz sibling) —
  structural GREEN (no text-pin covers the sidecar), dagger RED (`curl 404`); (2)
  shim-not-a-listener — structural + `--help` tier GREEN, real-image listen smoke RED
  (`SHIM_NOT_LISTENING`). Honest nuance: the brief's goreleaser-name defect (0fz) is now
  DOUBLE-caught (suite hardened post-0fz) — text-pins are reactive, which is exactly why the
  sidecar sibling proves the point. **No-divergence push:** same build core, dual-tag
  `{v0.3.48,latest}` → identical `sha256:a1b927…bad6` (IS-4), observed not asserted.
  **IS-3 CA-trust verdict: NOT verbatim-for-free** — the real bc-base trusts the agent-vault CA
  only at RUNTIME (entrypoint), never before its build-time egress RUNs, so the full verbatim
  Dockerfile x509-fails at line-70 through the MITM; needs a build-time CA-trust base (01a
  option 2). MITM-LOCAL ONLY — under real CI (public egress) the Dockerfile is verbatim as-is,
  NOT a shipped-path IS-3 bend. Three new engine-provisioning findings for the WRAP spec:
  NO_PROXY needs registry APEX entries (Go leading-dot rule); whitelist dagger-infra hosts
  (go-proxy/pypi) while github stays proxied (two-engine split, IS-2 intact); engine config via
  `docker cp`+restart, not host `-v` (daemon can't see scratchpad mounts). Residuals carried:
  private-GHCR resolver (sidestepped via local base), fabro-e2e Seam-C nesting, engine-in-BC
  dogfood, structural-suite fold. **No blockers.**
  → **Slice 3 recommendation: GRADUATE.** Draft 4 ADRs (dagger as local+CI substrate /
  WRAP-not-replace publish-bc-base.yml; same-definition-local==CI no-divergence; agent-vault
  egress recipe incl. NEW-A/B/C; build-time CA-trust prerequisite as MITM-local infra) + author
  4 scenarios (sidecar-404 RED / structural-GREEN split; shim listen-smoke split; dual-tag
  one-digest same-core; egress recipe github-proxied/base-direct). Then Slice 4 DISPATCHES the
  module+WRAP to shopsystem-bc-launcher (IS-5/ADR-018), carrying the residuals.

- 2026-07-02: **Slice 3 GRADUATED** — ADR-052..055 + dagger-ci scenarios authored on
  dagger-spike; next Slice 4 productionize (dispatch to bc-launcher, run under
  --orchestrator fabro).

- 2026-07-02: **Slice 4 — CHECKPOINTED for David** (findings 04a/04b/04c). Dispatched the
  dagger CI work to a separate fabro-orchestrated `shopsystem-bc-launcher-dagger` (distinct
  identity; real infra untouched) and DOGFOODED fabro. **Fabro dogfood SUCCEEDED (its goal):
  5 real residuals found+fixed on real work → fabro v0.3.48→v0.3.50** (F1 classify→haiku; F2
  fail-closed non-consuming/retriable, held 3×; F3+R7 launch-returns via docker exec -d; R6a
  ALL .coding/.review→haiku-primary — the BC caught that fabro's stylesheet `fallbacks:` key
  is silently-swallowed=false-green). On v0.3.50 the loop ran FULL LENGTH on haiku
  (classify→suff→worktree→plan→impl→RED/GREEN gate) — fabro proven end-to-end on real work.
  **BUT the dagger ci/ module is NOT yet built** — impl authored only BDD test scaffolding.
  Two forks for David: (a) fabro `integ` pushes worktree→origin/main (dogfood clone can't/
  shouldn't push to the real repo → fail-closed protectively; emit-vs-push is a DESIGN Q, not
  a clear bug); (b) DISPATCH-SHAPE gap — `armed` reads 1 msg/work_id so the 03 module-spec
  (companion carrier) never reached the implementer; haiku saw only the 4 behavioral scenarios
  → scaffolded tests. Deeper: the fabro BDD implement-a-scenario loop may be the wrong builder
  for an infra module, and haiku scaffolds where sonnet might build (quota). **Queued David
  decisions:** restore sonnet quota; how to complete the module build (re-shape dispatch /
  convey the proven spike module via request_maintenance+adopt / need sonnet); integ
  emit-vs-push; whether bc-launcher MERGES the dagger CI into its shipped repo (real release).
  lead-fzxt stays OPEN. Follow-ups filed: lead-o8qk, lead-sh4a. **DAGGER GRADUATED + fabro
  dogfood delivered; module-build productionization paused on David's judgment.**
