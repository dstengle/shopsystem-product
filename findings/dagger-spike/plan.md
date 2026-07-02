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
