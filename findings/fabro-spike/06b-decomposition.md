# 06b — Decomposition: productionize the fabro launch path into `bc-container`

**Epic** lead-6k1r (fabro spike graduation → productionization) · **Date** 2026-07-01
· **Author** lead-architect (verify + decompose + draft only — orchestrator owns
dispatch; NO `shop-msg send` issued here) · **Surface** artifact/contract only, no
BC source read/run/git-observed (ADR-018 D1/D2).

GOAL (David-directed): make **`bc-container launch <bc> --orchestrator fabro`** a
real, first-class launch path — boot a BC whose engage tier is the fabro run-graph
and have it perform normal work (consume `assign_scenarios` → build → review → emit
`work_done`), with the four graduated invariants held. The spike proved this
POSSIBLE by hand-provisioning (ADR-048/049/050/051); this decomposes the launcher
change to make it REAL.

## Contract-surface verification carried into this decomposition (ADR-018 D1)

- **Graduation pins reproduce (defense-in-depth, `scenarios hash` recompute
  2026-07-01):** `fabro-orchestration/01`→`1aeace4c593ab14f` (ADR-050),
  `02`→`9c7b4e8280665239` (ADR-049), `03`→`56c0f126447e48d6` (ADR-051),
  `04`→`7ddada412f406767` (ADR-051). All four are **LEAD-PROCESS** pins — not yet
  BC-owned, explicitly NOT dispatchable — and serve as the acceptance observables
  each real-launch slice must reproduce THROUGH the productionized path.
- **No orchestrator/engage abstraction is pinned anywhere.** `grep -r
  "@scenario_hash" features/` over the engage surface: the engage tier is hardcoded
  tmux/claude — `04` (`04236074a60ffcd7`, tmux `agent` session), `45`
  (`c4e88075a0b4bd00`, `agent-vault run -- claude`), `27/28/29/30/31/55` (send-keys
  TUI discipline), `34` (`c946bc6d8a05e44a`, barrier→tmux engage handoff). The only
  `orchestrator`-string hits in `features/` are unrelated (`templates/174`,
  `templates/199`). `bc-base` carries no fabro today (`64` pins only gh +
  agent-vault on PATH). → the `--orchestrator fabro` path and the baked fabro binary
  are **NET-NEW**, so the primary vehicle is `assign_scenarios` (per discriminator).
- **`@scenario_hash` retirement enumeration for every additive slice = EMPTY.** The
  build-out is purely additive: tmux stays the DEFAULT engage (04/45/27/28–31/34/55
  all remain valid), and `fabro-orchestration/01–04` are lead-process references,
  not BC-side coverage a slice supersedes. Consistent with ADR-048/049/050/051, each
  of which records the enumeration EMPTY.

## The seam (from 06a §3)

One launch-time branch at **scenario-34's barrier→engage handoff**. Everything
UPSTREAM (container/credential/network/coordinates tiers, P1–P4/P7/P10–P17, and the
readiness barrier P6 itself) is REUSED byte-for-byte — that is the entire leverage
of `provider='local'` (ADR-050 D1). The engage tier (P5/P6/P8/P9, with P18 held
invariant over shop-msg) is the SOLE replaced surface (ADR-050 D3).

## Dependency-ordered thin vertical slices

Each slice pins ONE coherent behavior. Target BC is `bc-launcher` unless noted;
`bc-base` changes are dispatched to bc-launcher (owns bc-base, ADR-021).
Message-type per the discriminator (net-new→`assign_scenarios`; existing-unpinned→
`request_bugfix`; flat→`request_maintenance`).

### S1 — bc-base bakes `fabro` + `anthropic-oauth-shim`  ·  bc-launcher  ·  assign_scenarios  ·  deps: none
The one image change and the hard prerequisite. `bc-base:latest` carries the `fabro`
v0.254.0 Rust binary and the `anthropic-oauth-shim` (`shim.py`, python-stdlib —
`python3` already present) as a NEW poll-tracked baked dependency alongside
gh/agent-vault/shop-templates (baked-dep poll 57–62 auto-bumps on release);
version-coupled per ADR-051 D3.
**Vehicle:** net-new — `64` pins only gh+agent-vault present; no fabro presence
pinned anywhere. **Retirement set:** EMPTY.
**Acceptance:** new bc-launcher-surface scenario pins "`fabro --version` = v0.254.0
and the shim is present/launchable in `bc-base:latest`, tracked by the baked-dep
poll." Resolves the ADR-049 shim-packaging follow-up (→ bc-base bake).

### S2 — launch places the assembled fabro def into the container  ·  bc-launcher  ·  assign_scenarios  ·  deps: S1
Launch drops the self-contained fabro def — `workflow.fabro` (23-node/45-edge
Implementer→Reviewer graph), `workflow.toml` (`provider='local'`,
`[run.pull_request].enabled=false`), the inlined node prompts, and
`vaults/default/secrets.json` = `__PLACEHOLDER__` only — into the container so
`fabro validate` passes. The pin is **source-agnostic** ("a valid def is present"),
so S8 can later swap inlined→poured as a flat change.
**Vehicle:** net-new furniture placement. **Retirement set:** EMPTY.
**Acceptance:** scenario pins "after launch the container carries a valid fabro def
(`fabro validate` OK, 23/45) whose native vault holds only `__PLACEHOLDER__`
(ADR-049 D1)."

### S3 — fabro-branch credential surface is agent-vault-only  ·  bc-launcher  ·  assign_scenarios  ·  deps: S1, S2
On the fabro branch, launch starts the anthropic-oauth-shim in-container, points
fabro `[llm.providers.anthropic] base_url` at it (adapter stays `anthropic`, no
format translation), and the native vault holds only `__PLACEHOLDER__`. A dummy
`x-api-key` request flows shim → container `HTTPS_PROXY` → agent-vault → real OAuth
200; the real credential is only on the wire. Under `provider='local'` the nodes
inherit the parent container's HTTPS_PROXY + `SSL_CERT_FILE`, so the spike's
proxy/CA `[run.environment.env]` overlay FALLS AWAY (06a §2c).
**Vehicle:** net-new (fabro credential path unpinned on any BC surface).
**Retirement set:** EMPTY.
**Acceptance:** reproduce `fabro-orchestration/02` (`9c7b4e8280665239`) via the REAL
launch path — dummy `x-api-key` → 200; native vault `__PLACEHOLDER__` only; real
cred never in the fabro store (ADR-049 D1/D2).

### S4 — `--orchestrator fabro` engage branch + selection surface  ·  bc-launcher  ·  assign_scenarios  ·  deps: S1, S2, S3
Add `--orchestrator {tmux|fabro}` to `bc-container launch` (+ optional per-BC
`bc-manifest orchestrator` field, default `tmux`). On `fabro`, after the SAME
readiness barrier passes, start the ephemeral in-container fabro server
(`provider=local`, 127.0.0.1/unix-socket, `--foreground --no-web`) and `fabro run
workflow.fabro` with `[run.environment.env]` carrying `BC_NAME`/`WORK_ID` (the ONLY
channel reaching native `script=` nodes, ADR-051 D3). KEPT surface: same image,
real registered EMPTY mailbox, `prime→health→arm→classify` order, no tmux engage.
tmux path unchanged. This is the drop-in that replaces the spike's hand-provisioning.
**Vehicle:** net-new engage abstraction (no `--orchestrator`/engage-selection
pinned). **Retirement set:** EMPTY (tmux stays default; 04/45/27/34/55 hold).
**Acceptance:** reproduce `fabro-orchestration/01` (`1aeace4c593ab14f`) via
`bc-container launch <bc> --orchestrator fabro` instead of hand-provisioning; tmux
default byte-for-byte unchanged.

### S5 — full assign_scenarios→work_done loop through the real launch path  ·  bc-launcher  ·  assign_scenarios  ·  deps: S4
A seeded `assign_scenarios` is consumed by the fabro-launched BC; the structural
Implementer→Reviewer graph runs to completion; `emit_r` is the SOLE in-graph node
depositing `work_done(complete)` via `bc-emit`/`shop-msg`, carrying a block-only
`scenario_hashes` subset of the assigned block; the lead reconciles over `shop-msg`,
never fabro outputs (ADR-018 / ADR-051 D1). This is the "perform normal work" GOAL.
**Vehicle:** net-new. **Retirement set:** EMPTY.
**Acceptance:** reproduce `fabro-orchestration/03` (`56c0f126447e48d6`) end-to-end
via the REAL launch path.

### S6 — fail-closed proven through the real launch path  ·  bc-launcher  ·  assign_scenarios  ·  deps: S5
A forced reviewer-fail on the fabro-launched BC yields run STATUS FAILED, `wdg_r`/
`emit_r` never reached, no `work_done(complete)` on the wire — ENFORCED by native
`script=` scoping and outcome-conditional edges (ADR-051 D2/D3), not advisory.
**Vehicle:** net-new. **Retirement set:** EMPTY.
**Acceptance:** reproduce `fabro-orchestration/04` (`7ddada412f406767`) via the REAL
launch path.

> **END-TO-END acceptance is reached at S6.** S7–S11 harden/de-risk; they are NOT
> required for the end-to-end GOAL but close the named ADR-049/050/051 follow-ups.

### S7 — shop-templates authors the fabro-node furniture group  ·  shop-templates  ·  assign_scenarios  ·  deps: S2
shop-templates ships the 11 `nodes/*.md` prompt bodies as CANONICAL furniture
derived from their `SKILL.md` sources (bc-router, bc-sufficiency-check,
writing-plans-bdd, subagent-driven-development, test-driven-development,
using-git-worktrees, integrating-to-main, bc-review, work-done-gate, bc-implementer,
bc-reviewer — `fabro-defs/README.md` map), pourable via the scenario-43 seam. Keeps
the ports from drifting off canon.
**Vehicle:** net-new furniture group (shop-templates surface). **Retirement set:**
EMPTY. **Acceptance:** scenario pins "shop-templates exposes the fabro-node
furniture group; each body derives from its canonical SKILL.md and is pourable."

### S8 — launch sources the def from poured furniture (flat swap)  ·  bc-launcher  ·  request_maintenance  ·  deps: S7
Flat: the def's node bodies are sourced by pouring the S7 shop-templates furniture
(scenario 43) instead of the S2 inlined self-contained assembly. Observable (valid
def, working loop) unchanged — S2's pin is source-agnostic, so no new scenario.
**Vehicle:** flat refactor, no new observable → `request_maintenance`.
**Acceptance:** def still `fabro validate` OK and the S5 loop still completes; node
bodies now trace to shop-templates furniture (drift closed).

### S9 — reconcile launcher barrier → in-graph fabro barrier node  ·  bc-launcher  ·  request_bugfix  ·  deps: S4 (ideally S5)
S4 reused the existing launcher readiness barrier as the interim gate in front of
`fabro run`. This tightens it to a native `script=` in-graph barrier node with
outcome-conditional edges that fail-CLOSED and name `SHOPMSG_DSN` (33) and the
broker address (48), idempotent no-op-reporting-ready (34) — ADR-050 D4.
**Vehicle:** the barrier-gates-engage capability EXISTS from S4 but the in-graph
fail-closed-node discipline is UNPINNED → `request_bugfix` (tighten S4).
**Retirement set:** EMPTY (34/48 are bc-container-path pins that stay valid; the
fabro node RELATES to them, retires none). **Acceptance:** fabro barrier node
reproduces bc-launcher 33/34/48 fail-for-fail — postgres down → FAIL naming
`SHOPMSG_DSN`; broker down → FAIL naming broker; both up → PASS; re-run → no-op ready.

### S10 — flat-lane stale-cwd/empty-hash fix  ·  bc-launcher  ·  request_bugfix  ·  deps: S2
Apply the `emit_r` fix (`cd ../wt-$WORK_ID`; build `--scenario-hash` from on-disk
tags) to the parallel FLAT lane `impl_f→wdg_f→emit_f`, which carries the same defect
un-exercised (ADR-051 residual 2). Tightens existing-but-unpinned def behavior.
**Vehicle:** `request_bugfix`. **Retirement set:** EMPTY.
**Acceptance:** the flat lane emits a valid `request_maintenance`/empty-`request_bugfix`
`work_done` with correct cwd + non-empty `scenario_hash`.

### S11 — `emit_r` scenario_hashes over-include polish  ·  bc-launcher  ·  request_maintenance  ·  deps: S5
Scope `emit_r`'s payload to only the assigned block's `@scenario_hash` instead of
every on-disk tag (currently a correct SUPERSET; C3 ⊆-satisfied, so cosmetic —
ADR-051 residual 1). No observable/behavior change, no new scenario.
**Vehicle:** flat → `request_maintenance`. **Acceptance:** `emit_r` payload
`scenario_hashes` = exactly the assigned block; ADR-042 C3 still satisfied.

## SLICE 1 = S1 (bc-base bakes fabro + shim) — ordering justification

S1 is the thinnest slice with observable progress AND the single hard prerequisite.
The fabro server cannot start (S4), the loop cannot run (S5/S6), the credential shim
cannot launch (S3), and the shipped def is inert (S2) with no `fabro` binary on PATH
— everything downstream is dead without it. It is the ONE image change, it slots
cleanly into the already-proven baked-dep poll (57–62) so it is small and
well-understood, and it produces a concrete observable (`bc-base:latest` carries
`fabro` v0.254.0 + the shim, version-tracked). Per the 06a minimal-first-slice and
the instruction's "prerequisite slice if the dependency graph requires it," the
graph REQUIRES the binary first — so S1 leads.

## END-TO-END acceptance for the whole capability

`bc-container launch <bc> --orchestrator fabro` boots a BC from the same
`shopsystem-bc-base:latest` (S1), with the fabro def present and valid (S2), the
agent-vault-only credential surface live (S3, native vault `__PLACEHOLDER__` only),
and the engage tier replaced by the ephemeral in-container fabro run-graph after the
KEPT readiness barrier passes (S4). That BC consumes a seeded `assign_scenarios`,
runs the structural Implementer→Reviewer loop, and `emit_r` — the SOLE gated
emitter, reachable only via `review→wdg_r→emit_r` — deposits a valid
`work_done(complete)` over `bc-emit`/`shop-msg`, reconciled by the lead via
`shop-msg read outbox` (S5); a forced reviewer-fail is fail-closed with no complete
on the wire (S6). All four graduated invariants HELD: fabro in-container only
(ADR-048); agent-vault sole credential surface, native secrets forbidden (ADR-049);
launch-interface parity with bc-container, engage-tier-only replacement (ADR-050);
DOT loop graph with emit_r sole gated emitter + fail-closed (ADR-051). Observable =
`fabro-orchestration/01`+`02`+`03`+`04` (`1aeace4c593ab14f`, `9c7b4e8280665239`,
`56c0f126447e48d6`, `7ddada412f406767`) ALL reproduced through the real
`--orchestrator fabro` launch path instead of hand-provisioning.

## Risks / watch-items

- **S8 pour-derived drift.** If S7/S8 slip, the inlined S2 ports drift from canonical
  SKILL.md; the fabro loop silently diverges from the tmux loop's discipline. Keep
  S7/S8 on the roadmap even though not on the end-to-end critical path.
- **v0.254.0 version-coupling (ADR-051 D3).** The fail-closed guarantee rests on
  three v0.254.0 mechanism facts (native `script=` sole lever; `[run.environment.env]`
  sole native-input channel; `permissions=` NOT enforced). The S1 baked-dep poll will
  auto-bump fabro on new releases — a bump that changes any of the three reopens the
  guarantee and must re-verify S5/S6 before the new `:latest` is trusted.
- **P18 harvest temptation.** S5/S6 acceptance must assert online/work_done over
  `shop-msg`, NEVER by reading `fabro events`/run outputs (ADR-018 / ADR-050 D3).
- **S9 barrier-location interim.** Between S4 and S9 the fail-closed guarantee leans
  on the reused launcher barrier rather than the in-graph node; acceptable interim
  but must land S9 for the ADR-050 D4 in-graph outcome-conditional-edge contract.
- **S10 flat-lane latent defect.** The flat lane ships in the S2 def carrying the
  stale-cwd/empty-hash defect; do NOT route `request_maintenance`/empty-`request_bugfix`
  work through the fabro path until S10 lands.
- **shim/base_url binding.** S3 depends on the shim binding a stable in-container
  address and fabro `base_url` matching; a port/socket mismatch fails LLM traffic
  closed — acceptance must exercise a live dummy-`x-api-key`→200 round trip.
</content>
</invoke>

## Reconciliation log

- **2026-07-01 — S1 (lead-ckq5) RECONCILED.** shopsystem-bc-launcher work_done
  status=complete. Both assigned scenarios GREEN: block-only `scenarios hash`
  recompute (calibrated on anchor scn213→4c646ae20a1540e3) confirms
  features/bc-launcher/73→a3512aedb8763150 and 74→4fc67c610cba6227, exact match
  to reported hashes; additive (retirement set EMPTY); Gate A clean, Gate B commit
  3627302 reachable from bc-launcher origin/main HEAD. CAVEAT: scenario-73 version
  leg MODELED (docker unavailable in BC env), not container-executed. LIVE-IMAGE
  GAP (empirical registry/contract surface): `ghcr.io/dstengle/shopsystem-bc-base:latest`
  is NOT yet rebuilt with fabro — pulled digest sha256:36a73b60…, Created
  2026-06-30T19:19Z, version v0.3.41; throwaway boot → FABRO_NOT_FOUND, no shim.
  S1 delivered SOURCE only; the fabro-carrying `:latest` rebuild is a pending
  version-tag/poll consequence. Follow-ups filed: lead-3aoj (confirm/trigger
  fabro-carrying `:latest`, S2-S6 prereq), lead-czy8 (deferred live-verify scn-73
  in booted container, blocked-by lead-3aoj). Row consumed; lead-ckq5 closed.
  **S2 BLOCKED on lead-3aoj** (its acceptance needs a launched container whose
  bc-base image actually carries fabro).
