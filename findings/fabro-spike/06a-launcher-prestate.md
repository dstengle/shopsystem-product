# 06a — Launcher pre-state for productionizing the fabro launch path

**Epic** lead-6k1r (fabro spike graduation → productionization) · **Date** 2026-07-01
· **Author** lead-architect (verify + decompose only; orchestrator owns dispatch)
· **Surface** artifact/contract only — no BC source read, run, or git-observed
(ADR-018 D1/D2). Evidence = this repo's `features/`, `adr/`, the spike findings
`findings/fabro-spike/*` (spike-vehicle artifact surface, ADR-032), and
`scenarios hash` recompute.

GOAL being pre-stated: make **`bc-container launch <bc> --orchestrator fabro`**
(or equivalent) a real, first-class launch path — boot a BC whose engage path is
the fabro run-graph and have it perform normal work (consume `assign_scenarios` →
build → review → emit `work_done`). The spike proved this POSSIBLE by
hand-provisioning; this pre-states the launcher change to make it real.

---

## 0. Contract-surface verification performed (ADR-018 D1)

- **Graduation pins exist and reproduce.** `features/fabro-orchestration/01–04`
  are present. Recomputed each block-only `@scenario_hash` via the installed
  `scenarios hash` tool; all four reproduce the authored + ADR-recorded values:
  `01`→`1aeace4c593ab14f` (ADR-050), `02`→`9c7b4e8280665239` (ADR-049),
  `03`→`56c0f126447e48d6` (ADR-051), `04`→`7ddada412f406767` (ADR-051).
  These are **LEAD-PROCESS contract pins**, explicitly NOT dispatchable /
  not-yet-BC-owned (ADR-048 Consequences).
- **`@scenario_hash` enumeration over the engage surface** (`grep -r
  "@scenario_hash" features/bc-launcher features/launcher-credentials`): the
  engage tier is pinned by `04` (`04236074a60ffcd7`), `45`
  (`c4e88075a0b4bd00`/`3931e43e01824a3c`), `27` (`5f391bc9e4089462`), `34`
  (`c946bc6d8a05e44a`/`767eba36f237a79a`), `55`, `28/29/30/31`, `07/08`. **No
  `@scenario_hash` anywhere pins an orchestrator/engage abstraction or a fabro
  launch path** — the engage tier is hardcoded to tmux/claude (see §1).

---

## 1. Current launch + engage interface, and WHERE the tmux/claude assumption is pinned

`bc-container launch` is owned by **shopsystem-bc-launcher** (ADR-004/PDR-004).
Subcommand surface `launch/attach/inject/monitor/stop/status/list` (scenario 17,
P20). The launch sequence (from `features/bc-launcher/`, tiered per
`01a-target-launch-parity.md`):

| Phase | Pinned by | Tier |
|---|---|---|
| boot container `bc-<bc>` from pinned `bc-base:latest` | 01; ADR-021 | container |
| clone repo in-container `/workspace` (URL from `bc-manifest.yaml`) | 02, 65 | container |
| `bd dolt pull` + leave beads functional | 03, 32 | container |
| pour `shop-templates` skill-group into `.claude/skills/` | 42, 43 | container |
| inject `SHOPMSG_DSN` + HTTPS_PROXY + MITM CA + `SSL_CERT_FILE` | 45, 47, 69, 70 | credential |
| Docker HEALTHCHECK = readiness (beads + DB reachable) | 35, 07/P7 | container |
| network `shopsystem` from on-disk config, coordinates from `ops-coordinates` | 63, 15/16/P14-17 | network |
| **readiness barrier** (postgres + agent-vault, idempotent, fail-closed) | 33, 34, 47, 48 | **engage** |
| **engage**: start tmux `agent`; run `agent-vault run -- claude`; send-keys startup prompt | 04, 45, 16/27, 28/30/31, 55 | **engage** |
| verify-online via `shop-msg bc-status` + ping | ADR-014; P18 | engage (invariant) |

### The engage seam is HARDCODED — there is NO orchestrator/engage abstraction

The "orchestrator = a single `claude` TUI in a tmux session named `agent`, driven
by `tmux send-keys`" assumption is pinned literally and non-abstractly:

- **Scenario 04** (`04236074a60ffcd7`): "a tmux session named `agent` exists inside
  the container" — the tmux `agent` session is the literal engage host.
- **Scenario 45** (`c4e88075a0b4bd00`): "the command line that launches the agent
  inside the tmux session named `agent` invokes `agent-vault run -- claude`" — the
  **agent binary is hardcoded to `claude`**, wrapped `agent-vault run -- claude`,
  inside the tmux `agent` session.
- **Scenarios 27/28/29/30/31, 55**: the whole "startup prompt → `send-keys` →
  autonomous submit (text then Enter as two discrete send-keys) / Escape
  auto-dismiss / monitor the tmux pane" discipline — all TUI-paste workarounds
  bound to the tmux `agent` session (P8/P9).
- **Scenario 34** (`c946bc6d8a05e44a`): the readiness barrier gates that
  "**the startup prompt is sent to the tmux session named `agent`**" only after the
  barrier passes.

**The exact seam a fabro launch path slots into is scenario 34's barrier→engage
handoff.** Today that handoff is "barrier PASS → inject startup prompt into tmux
`agent` session" (34 + 45). There is **no substrate-selection abstraction, no
`--orchestrator` flag, no `bc-manifest` orchestrator field** — the engage tier
(P5/P6/P8/P9/P18) is where fabro slots in, and it is currently a single hardcoded
tmux/claude path. Per ADR-050 D3 the engage tier is the SOLE replaced surface;
everything upstream is KEPT byte-for-byte because `provider='local'` fabro rides
inside the already-booted container (ADR-050 D1).

---

## 2. Dependency graph to make fabro a real launch option (per-BC ownership)

### (a) fabro binary + anthropic-oauth-shim: bake into bc-base or install at launch?

**BAKE into `bc-base`.** Owner: **bc-launcher** (bc-base is bc-launcher-owned,
ADR-021; auto-rebuilds on utility release via the scenario 57–62 baked-dep poll).

- `fabro` (v0.254.0, single Rust binary) becomes a **new baked bc-base dependency**,
  exactly like `agent-vault`/`shop-templates`/`gh` are baked (scenarios 42, 53, 64)
  and auto-bumped by the 58–62 poll (each baked dep → latest release → pin bump →
  rebuild → republish `:latest`). This is the parity-clean home: it makes fabro's
  version-coupling (ADR-051 D3 pins v0.254.0 mechanism facts) a tracked, bumpable
  pin rather than a launch-time install.
- The **anthropic-oauth-shim** (`shim.py`, ~180 lines python-stdlib) needs only
  `python3`, which the bc-base lineage already carries (spike ran the shim inside a
  bc-base-parity container, `03c`/`04-goal-demo.md §3 inv#2`; Leg-1 addendum "On-PATH
  CLIs… all PRESENT"). Package it as a bc-base file drop OR as poured furniture (see
  (b)). Bake is simplest for slice 1. (This is the ADR-049 follow-up "shim packaging
  / co-location", left open there — resolve to bc-base bake.)

### (b) fabro-defs (workflow.fabro + nodes furniture): shop-templates poured, or ship with launcher?

**Split ownership; ship self-contained with the launcher for slice 1.**

- `workflow.fabro` (the 23-node/45-edge DOT loop topology + native `script=` barrier
  and `emit_r` gate scripts) and `workflow.toml` (the `[run.environment.env]` overlay,
  `provider='local'`, `[run.pull_request].enabled=false`) are the **engage MECHANISM**
  — the fabro analog of today's hardcoded tmux/claude engage. → **bc-launcher** owns
  them (parallel to bc-launcher owning the tmux engage today). They are also
  version-coupled to fabro v0.254.0 (ADR-051 D3), reinforcing bc-launcher ownership
  alongside the baked binary.
- The `nodes/*.md` prompt bodies are **ports of 11 `shop-templates` furniture pieces**
  (bc-router, bc-sufficiency-check, writing-plans-bdd, subagent-driven-development,
  test-driven-development, using-git-worktrees, integrating-to-main, bc-review,
  work-done-gate, bc-implementer, bc-reviewer — `fabro-defs/README.md` map). Their
  canonical source is **shopsystem-templates**. The durable path is: pour them like
  skills via the **scenario 43 pour** seam and keep them derived from the SKILL.md
  sources. For slice 1, the spike's **inlined-prompt** assembly (self-contained graph,
  no pour dependency — `fabro-defs/README.md` Leg-1 "inlines so each node is
  self-contained") ships with the launcher; the shop-templates furniture-sync is a
  named follow-up so the ports don't drift from canon.
- fabro's native vault (`vaults/default/secrets.json` = `__PLACEHOLDER__` only) ships
  with the def unchanged (ADR-049 D1 forbidden-surface). → bc-launcher.

### (c) credential wiring the launcher must set up in-container

Owner: **bc-launcher** (launch already injects the whole credential/transport
surface — scenarios 45/47/69/70; `agent-vault run` wrap). Under `provider='local'`
the fabro nodes INHERIT the parent container env, so the big simplification vs the
spike is that **the spike's `[run.environment.env]` proxy/CA overlay and inline-git-
token workarounds FALL AWAY** — they were `provider=local`-sandbox-specific; the real
in-container target already carries HTTPS_PROXY + CA (ADR-049 Follow-ups). What launch
must additionally wire on the fabro branch:

1. **Start the anthropic-oauth-shim** in-container (`launch-shim.sh`) — it inherits
   HTTPS_PROXY + `SSL_CERT_FILE` from the container env already injected by launch.
2. **Point fabro at the shim**: `[llm.providers.anthropic] base_url =
   "http://127.0.0.1:8788/v1"` in `~/.fabro/settings.toml` (adapter stays `anthropic`,
   no format translation — ADR-049 D2).
3. **Deliver `BC_NAME`/`WORK_ID` to native `script=` nodes** via the
   `[run.environment.env]` overlay — the ONLY channel that reaches the native sandbox
   (ADR-051 D3; `-I`/`{{ inputs }}` do NOT reach `script=`).
4. fabro native vault stays `__PLACEHOLDER__` (ADR-049 D1); real creds only on the
   wire via agent-vault (P12/P13 KEPT).

### (d) manifest / broker / coordinates implications

Owner: **bc-launcher** (`bc-manifest`, `ops-coordinates`). Under `provider='local'`
the container/network/coordinates tiers are KEPT (ADR-050 D1) — **no new
manifest/coordinate surface is needed**. The barrier node reads `SHOPMSG_DSN` +
the broker address from the env launch already sets (P14/P16). The ONE new
launch-contract surface: a way for launch to select the fabro engage substrate
instead of the tmux engage — a **`--orchestrator fabro` flag** and/or an optional
per-BC **`bc-manifest` `orchestrator: fabro|tmux`** field (default `tmux`). Both are
bc-launcher-owned additions.

### Ownership summary

| Dependency | Owner BC | Vehicle note |
|---|---|---|
| `fabro` binary baked into `bc-base` | **bc-launcher** (ADR-021; poll 58–62) | net-new baked dep |
| anthropic-oauth-shim packaged (bake or furniture) | **bc-launcher** (bake) | resolves ADR-049 follow-up |
| `workflow.fabro` + `workflow.toml` (loop topology + env overlay) | **bc-launcher** | engage mechanism |
| `nodes/*.md` prompt bodies (furniture ports) | **shop-templates** source; poured by bc-launcher (scenario 43) | inlined for slice 1 |
| in-container cred wiring (shim start, base_url, env overlay, placeholder vault) | **bc-launcher** | provider=local inherits proxy/CA |
| `--orchestrator fabro` flag / `bc-manifest orchestrator` field | **bc-launcher** (+ bc-manifest) | new launch-contract surface |
| `ops-coordinates` / network / isolation | **bc-launcher** (unchanged) | KEPT, no change |

---

## 3. Cleanest seam + minimal first slice

### The seam: an engage-substrate selector at scenario-34's barrier→engage handoff

Introduce a launch-time branch at exactly the point where the readiness barrier
hands off to engagement:

- `--orchestrator tmux` (**default, unchanged**): start tmux `agent`, `agent-vault
  run -- claude`, send-keys the startup prompt (scenarios 04/45/27 hold as-is).
- `--orchestrator fabro` (**new**): after the SAME barrier passes, (i) start the
  anthropic-oauth-shim, (ii) set fabro's `base_url` to it, (iii) start the ephemeral
  in-container `fabro server start --foreground --no-web --bind <unix-socket>`, and
  (iv) `fabro run workflow.fabro` with `[run.environment.env]` carrying
  `BC_NAME`/`WORK_ID`.

Everything upstream of the handoff — boot (P1), clone (P2), beads (P3), skills pour
(P4), health (P7), isolation/creds (P10–P13), network/coordinates (P14–P17), and the
readiness barrier (P6) itself — is REUSED byte-for-byte via the existing launch code
path. That is the entire leverage of `provider='local'` (ADR-050 D1). Verify-online
stays `shop-msg` (P18/AC9, ADR-018 invariant — never fabro run outputs).

### Minimal first slice (thinnest change that boots a fabro-orchestrated BC doing real work)

1. **bc-base bakes `fabro` + drops the shim** — the one image change (bc-launcher).
2. **bc-launcher ships the assembled fabro def** (workflow.fabro + workflow.toml +
   inlined node prompts + `__PLACEHOLDER__` vault) as launch furniture placed into
   the container (bc-launcher; inlined prompts avoid the shop-templates furniture-sync
   dependency for slice 1).
3. **bc-launcher adds the `--orchestrator fabro` branch** at the barrier→engage seam:
   start shim → set `base_url` → start fabro server → `fabro run` with the env overlay.
   Container/credential/network provisioning is the SAME already-exercised code path.
4. **Reuse the existing launcher readiness barrier** (33/34/47/48) unchanged as the
   gate in front of `fabro run` for slice 1; reconciling it to the in-graph fabro
   barrier node (ADR-050 D4) is a leaner follow-up, not slice 1.

**Acceptance for slice 1** = the fabro-orchestration/`01` observable
(`1aeace4c593ab14f`) reproduced **via `bc-container launch <bc> --orchestrator
fabro`** instead of hand-provisioning, plus `03` (`56c0f126447e48d6`) — a seeded
`assign_scenarios` consumed → `work_done(complete)` via `emit_r`, end-to-end through
the real launch path. This is the "boot a BC and do normal work" GOAL, minus
hand-provisioning.

### Discriminator note for the orchestrator (I did NOT dispatch)

- **Vehicle = `assign_scenarios` to `shopsystem-bc-launcher`** (NET-NEW capability).
  Verified empirically against the contract surface: the engage tier is hardcoded to
  tmux/claude (scenarios 04/45/27/34); **no `--orchestrator`/engage abstraction is
  pinned anywhere** in `features/`, and `bc-base` carries no `fabro` today (scenario
  64 pins only gh + agent-vault on PATH). The `--orchestrator fabro` engage path and
  the baked fabro binary are genuinely new behavior → `assign_scenarios`, NOT
  `request_bugfix`.
- **`@scenario_hash` retirement enumeration for the slice = EMPTY.** The slice is
  purely ADDITIVE: the tmux engage stays the default and all its pins (04, 45, 27,
  28–31, 34, 55) remain valid; the fabro-orchestration/01–04 pins are LEAD-PROCESS
  contract references, not bc-launcher-side coverage the slice supersedes. A first
  slice retires no hash on either surface (consistent with ADR-048/049/050/051, all of
  which record the enumeration EMPTY).
- The first-slice `assign_scenarios` would author fresh **bc-launcher-surface**
  scenarios pinning the `--orchestrator fabro` launch path (the engage-branch
  selection, the shim/fabro-server provisioning, the barrier→`fabro run` handoff, and
  the P18 shop-msg verify-online), citing fabro-orchestration/01–04 + ADR-048/049/050/051
  as the contract reference and the reference impl at `findings/fabro-spike/fabro-defs/`.

---

## Named follow-ups (not slice 1)

- shop-templates furniture-sync: derive `nodes/*.md` from the canonical SKILL.md
  sources and pour via scenario 43, replacing the inlined-prompt assembly.
- Reconcile the launcher barrier to the in-graph fabro barrier node (ADR-050 D4).
- Flat-path (`impl_f→wdg_f→emit_f`) stale-cwd/empty-hash fix (ADR-051 residual 2;
  same fix already applied to `emit_r`) before the flat lane is exercised.
- `scenario_hashes` over-include polish at `emit_r` (ADR-051 residual 1).
- Seam(b) reactive LISTEN/NOTIFY: `shop-msg watch` survives only as a command node;
  the session-start drain is not robust to upstream consumption (G3/G4) — orthogonal.
