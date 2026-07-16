> **ARCHIVED** — historical spike record, not current state (ADR-065). Superseded by: ADR-048, ADR-050, ADR-051 (fabro as orchestration substrate + engage lifecycle + DOT-loop graph contract).

# Slice 0 — Fabro recon synthesis

**Epic:** lead-6k1r (Fabro spike). **Date:** 2026-07-01. **Branch:** `fabro-spike`.

Scope of this spike (per `plan.md`): fabro is narrowed to **in-container BC
orchestration only** — an ephemeral *local* server inside a BC container that runs
the BC's Implementer→Reviewer loop. The lead keeps shop-msg / Monitor /
bc-container-equivalent. Credentials ride **agent-vault, not fabro secrets**.

Detail legs: [00a-fabro-tool.md](00a-fabro-tool.md) ·
[00b-f6ta-seams.md](00b-f6ta-seams.md) · [00c-bcshop-loop.md](00c-bcshop-loop.md).

---

## (a) Fabro the tool

**What it is.** Fabro ("the open source dark software factory", site fabro.sh, docs
docs.fabro.sh) is a **single Rust binary** shipped via GitHub Releases at
`fabro-sh/fabro` — *not* a pip/npm package (that is why `pip install fabro` 404s on
pypi.org). Latest release **v0.254.0 (2026-06-04)** — exactly the version the prior
f6ta spike / ADR-030 used, so those claims are corroborated. Asset
`fabro-x86_64-unknown-linux-gnu.tar.gz` (~47MB); `fabro --version` =>
`fabro 0.254.0 (497aaba 2026-06-04)`.

**Standing up an ephemeral local server (no browser wizard), proven this slice:**

1. Install: `GH_TOKEN=dummy gh release download v0.254.0 --repo fabro-sh/fabro
   --pattern fabro-x86_64-unknown-linux-gnu.tar.gz` → extract to `~/.fabro/bin/fabro`.
   (The agent-vault proxy injects the real GitHub token on-wire; fabro never holds it.)
2. Bootstrap non-interactively: `fabro install --non-interactive --skip-llm
   --github-strategy token --github-username X --overwrite-settings --storage-dir <dir>`
   with `GH_TOKEN`/`GITHUB_TOKEN` in env.
3. Start headless: `fabro server start --foreground --bind <ip:port|unix-socket>
   --no-web --storage-dir <dir>`.
4. Run a workflow: `fabro run <name> --dry-run --auto-approve` — `--dry-run` uses a
   **SIMULATED LLM backend needing NO credentials**. A trivial hello workflow ran
   end-to-end → **SUCCEEDED**.

**Workflow / dotfile format.** `~/.fabro/settings.toml` (server+cli); per-project
`.fabro/project.toml`; `.fabro/workflows/<name>/workflow.fabro` (a **Graphviz DOT
graph**) + `workflow.toml` (run/environment). Node vocab: `shape=Mdiamond` Start,
`shape=Msquare` Exit, `shape=hexagon` human gate, a node with `prompt=` is an LLM
agent, `class=` routes to a model via the `model_stylesheet` graph attr,
outcome-labeled edges, parallel nodes. `workflow.toml [environments.<id>]
provider='local'|...` is the launch/sandbox seam (relevant to launch-interface
parity); `fabro sandbox` subcommands exist for non-local providers.

**Native secret handling + the exact seam to bypass.** Two-tier plaintext under
`FABRO_STORAGE_DIR`:
- `server.env` — bootstrap secrets (`FABRO_DEV_TOKEN`, `SESSION_SECRET`; precedence
  process env → server.env).
- `vaults/default/secrets.json` — the **workflow-visible vault**, written by
  `fabro secret set KEY VALUE`, resolved into nodes by **exact name**. Provider keys
  like `ANTHROPIC_API_KEY` live here.

**The vault is the seam to bypass.** Bypass **PROVEN this slice:** set
`GITHUB_TOKEN=dummy_proxy` in fabro's vault — GitHub calls still succeeded because the
agent-vault egress proxy (`HTTPS_PROXY=...@agent-vault:14322`) injects the real
credential on the wire. **Bypass recipe = keep fabro's vault holding only dummy
placeholders + ensure node execution env inherits `HTTPS_PROXY`.** Durable
run/checkpoint state is a **SlateDB object store** at `<storage>/objects/slatedb` —
fabro's checkpoint authority (the competing-authority-vs-bd concern, confirmed present).

---

## (b) The 2 seams + 3 invariant surfaces (recovered, not reconstructed)

The framing is stated **literally** in origin bead lead-f6ta's VERDICT line
("directionally right but leaks-materially. Reframe as TWO seams of replacement
bounded by THREE invariant-surfaces fabro must NOT touch") and quoted verbatim in
`findings/substrate-candidate-comparison-vs-fabro.md`.

**Two seams (what fabro replaces):**
- **Seam (a) BC-launch → fabro-run — CLEAN.** bc-container launch ≈ a fabro run;
  `BC_IMAGE` → `[environments.<slug>]`; container-init → `[run.prepare]`+`[run.clone]`;
  discriminator → child `approval_required` gate. Under lead-6k1r this collapses to
  **launch-interface parity with bc-container**, not an external `POST /runs`.
- **Seam (b) Monitor / reactive-loop → fabro-loop — PARTIAL.** All 15 fabro hook
  events are **internal lifecycle points**; fabro has **no native primitive for the
  external async postgres LISTEN/NOTIFY arrival**. So `shop-msg watch` survives as a
  command node inside a fabro loop; fabro's checkpoint/resume subsumes only the
  session-start drain.

**Three invariant surfaces (fabro must NOT touch):**
1. **bd is authoritative state** (PDR-010 / ADR-016). Fabro's SlateDB checkpoint is a
   **competing authority** — demote to run-resume-only.
2. **Name registry + `<system>/<name>` addressing** (ADR-006 / ADR-020). No fabro
   analog; the lead still runs `shop-msg registry add`.
3. **Empirical-harvest surface** (ADR-018). Never harvest `work_done` from fabro child
   outputs; keep `shop-msg read outbox` + `scenarios hash`.

**4th invariant added by this epic (not in f6ta's three):** **credentials via
agent-vault, not fabro secret-management** (David explicit; plan.md §2; PDR-017).
f6ta's three predate the PDR-017 agent-vault decision. Under the in-container-only
scope, the bd-authority race now lives **entirely at the BC tier** where fabro runs.

---

## (c) What the fabro loop must recreate + the launch interface it must match

**The bc-shop loop lives in shop-templates furniture** (poured into each BC by
bc-container launch), *not* in BC source. It is:

- **bc-router skill** (top-level BC agent; there is no `bc-router.md` subagent) does
  session-start (shop-msg prime, bd prime, work-tracker health gate, arm Monitor on
  `shop-msg watch`, drain inbox), then **classifies each message via a 4-row table**:
  `assign_scenarios`(+scenarios) and non-empty `request_bugfix` → implementer→reviewer,
  **reviewer emits work_done**; empty `request_bugfix` and `request_maintenance` →
  implementer only, **implementer emits work_done**.
- **Scenario pipeline:** sufficiency-check → using-git-worktrees → writing-plans-bdd
  (RED/GREEN bd sub-issue DAG) → subagent-driven-development (parallel bc-implementer,
  inter-layer gate: test(red) committed & watched-fail *before* feat(green)) →
  integrating-to-main → bc-reviewer.
- **bc-reviewer is the SOLE work_done emitter for scenario work**, via the `bc-emit
  work-done` wrapper enforcing three pre-emit gates: (1) clean deliverable tree over
  `features/,src/,tests/`; (2) work_id reachable as a whole token from origin/main
  (`git log origin/main -E --grep='\b<work_id>\b'`); (3) ADR-010 scenario_hashes are a
  **subset** of committed `@scenario_hash` tags, recomputed via `scenarios hash`
  (block-only, ADR-019 — `Feature:` line not hashed).

**work_done wire shape** = `catalog.schemas.WorkDone`:
`message_type='work_done'`, `work_id:str`, `status:Literal[complete,partial,blocked]`,
`summary:str|None`, `scenario_hashes:list[str]`. Emitted only through
`shop-msg respond work_done` / `bc-emit`, never hand-written.

**Launch-interface parity target = `bc-container`** (owned by shopsystem-bc-launcher,
ADR-004), subcommands `launch/attach/inject/monitor/stop/status/list`. `launch`:
starts a `bc-base` container named `bc-<bc>`, clones the repo inside at `/workspace`,
`bd dolt pull`, pours shop-templates skills to `.claude/skills/`, starts tmux session
`agent`, runs an **idempotent readiness barrier** composing postgres (`SHOPMSG_DSN`) +
agent-vault reachability, then injects the startup prompt as **two discrete send-keys
invocations** (text alone, then Enter alone). **Isolation:** only the BC's own repo
bind mount — no sibling/lead mounts, no host `~/.claude`/`~/.config/gh`/`~/.gitconfig`;
agent launched wrapped `agent-vault run -- claude` with `HTTPS_PROXY` to the broker and
a read-only `__PLACEHOLDER__` `.credentials.json`. Coordinates single-source in
`ops/ops-coordinates` (ADR-043): network `shopsystem`, broker
`{slug}-agent-vault:14321`(API)/`:14322`(proxy), postgres `{slug}-postgres`.

**Furniture to port to fabro:** `templates/skills/` = bc-router, bc-sufficiency-check,
writing-plans-bdd, subagent-driven-development, test-driven-development,
using-git-worktrees, integrating-to-main, bc-review, work-done-gate; role shims
`bc-implementer.md`/`bc-reviewer.md`; `claude/bc.md` + `claude_settings/bc.json`
(SessionStart hooks bd prime + shop-msg prime); `ops/` compose + broker scaffolding.

---

## (d) Cross-cutting risks & open questions

**Sharpest risk — ADR-012 vs fabro-checkpoint race at the BC tier.** `shop-msg
respond` is a bd-first fsync'd transactional write (ADR-016) under the ADR-012 3-step
protocol; fabro checkpoints on **every node** and the BC tier has a git repo → the
checkpoint-commit collides on the node running `shop-msg respond` → ADR-012 ordering
hazard (phantom postgres row on retry). The 2PC-as-steps spike
(`findings/fabro-2pc-as-steps-spike.md`) found: between-node kill **safe**; micro-window
in-node kill **not eliminated** (only the ADR-012 `UNIQUE(work_id,direction,shop)`
backstop catches it) → **UNIQUE + bd-first sweeper remain mandatory**. New hazard
found: **fabro unconditional edges advance past a FAILED node and mark the run
SUCCEEDED** (silent failure-masking) → need outcome-conditional edges / node retry.

**Standing blocker.** `bc-base` is currently **un-rebuildable** (ADR-022: scenarios CLI
not baked, pdr/002 pin 404s) — must resolve before any full e2e that stands up a real
BC container.

**Open questions carried into later slices:**
- Does a fabro agent/command node inherit `HTTPS_PROXY` into its execution env so
  agent-vault injection reaches the *agent's own* tool/LLM calls (not just fabro's
  GitHub ops)? Provider-dependent (local inherits parent env; docker/sandbox may need
  explicit passthrough) — verify with a **non-dry-run** agent node.
- Can the LLM provider key itself ride agent-vault (dummy `ANTHROPIC_API_KEY` in vault
  + proxy injection to api.anthropic.com), same pattern as the proven GitHub bypass?
- Does in-container-only scope fully dissolve Seam (b)? The BC's inbound wake still
  arrives via postgres LISTEN/NOTIFY that fabro can only poll, not block-and-wait on —
  confirm whether a fabro node can block-and-wait on an external signal.
- Fabro empirical unknowns: `:latest` digest vs stale cache (ADR-021 D3);
  `fabro_run_events` ordering/delivery guarantees; can one node emit multiple shop-msg
  messages when only final JSON is validated?
- Launcher-internal specifics (bc-launcher-owned, not on this host per ADR-018): exact
  `bc-base` tag/digest, full docker run argv/env/mounts, readiness-barrier impl, the
  concrete tmux key token for Escape.

---

## (e) RECOMMENDATION for Slice 1 — "Spec the targets"

Slice 0 confirmed fabro is real, installs headlessly, runs `--dry-run` with zero
credentials, and the agent-vault bypass works. Slice 1 should now **write the two
target specs against the artifact surface**, refined by what Slice 0 revealed:

1. **Launch-interface contract (target A).** Characterize the `bc-container` `launch`
   contract as the **drop-in interface a fabro launcher must satisfy** — the observable
   properties bc-launcher scenarios assert (container named `bc-<bc>`, repo cloned
   inside, skills poured, tmux `agent` session, idempotent readiness barrier over
   postgres+agent-vault, two-send-keys engage, isolation/no-host-cred-mounts,
   coordinates from `ops-coordinates`). Map each to its fabro analog: `[run.clone]` /
   `[run.prepare]` / `[environments.<slug>] provider='local'` and the vault-placeholder +
   `HTTPS_PROXY` credential path. Explicitly note the launcher-internal unknowns
   (exact image digest, docker argv) as **out of artifact-surface scope**.

2. **Loop contract (target B).** Spec the minimal Implementer→Reviewer loop and its
   gated `work_done` emission as a **fabro DOT-graph shape**: which nodes are LLM-agent
   (`prompt=`) vs command nodes (running `bc-emit` / `shop-msg` / `scenarios hash`),
   where the RED-before-GREEN gate and the three work-done-gate checks sit, and — given
   the silent-failure-masking hazard — mandate **outcome-conditional edges** so a
   FAILED node cannot advance to Exit/SUCCEEDED.

Keep Slice 1 to the artifact surface (no live BC boot — `bc-base` is un-rebuildable).
Output: `findings/fabro-spike/01-targets-spec.md`. Defer the real ADR-012-vs-checkpoint
race exercise and the non-dry-run agent-vault-through-agent verification to Slices 3-4;
just record them as the acceptance criteria those slices must hit.
