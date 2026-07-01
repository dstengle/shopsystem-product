# Fabro spike — plan & running log

> **▶ NEXT SESSION — START HERE.** This is the active overnight task (epic
> **lead-6k1r**). Setup is done: all 5 repos tagged `fabro-spike-baseline`
> (rollback point), plan below, memory pointer `fabro-spike-active`. NO workflows
> have been started yet. First action: **create a `fabro-spike` branch in the lead
> repo, then run Slice 0 (fabro recon) via a workflow** (3 parallel legs: (A) install
> + stand up a local ephemeral fabro server, run a trivial workflow, document its
> format + secret-handling; (B) extract the f6ta "2 seams / 3 invariant surfaces";
> (C) inventory the bc-shop loop + shop-templates furniture to translate) → synthesize
> to `00-fabro-recon.md`, then decide Slice 1. Keep main-loop context minimal —
> delegate to workflows/subagents; read only slice summaries.

**Started:** 2026-07-01 (product authority: David; runs autonomously overnight)
**Origin bead:** [lead-f6ta] (fabro as alternable orchestration substrate) — this is
f6ta activated with a concrete goal. Epic bead: see `bd ready`.
**Track:** odqd iterative-experimentation (spike → learn → throw away → graduate via
ADRs+scenarios). Spike vehicle: ADR-029/030/032.

## Goal (success criterion)

A BC **comes up orchestrated by an ephemeral, in-container fabro server** and
**executes work per the shop-msg protocol** — specifically it can handle an
**`assign_scenarios`** dispatch end-to-end (build → review → `work_done`), with the
**same launch interface as `bc-container`**.

Success = Slice 4 green: dispatch `assign_scenarios` to a fabro-orchestrated BC and
observe a valid `work_done` produced by the recreated Implementer→Reviewer loop.

## Hard constraints / invariants (do NOT violate)

1. **Fabro scope = in-container BC orchestration ONLY.** Fabro runs as an ephemeral
   *local* server inside the BC container, executing the BC's workflow loop. It is
   NOT used to orchestrate anything outside the BC (the lead keeps shop-msg /
   Monitor / bc-container-equivalent). No fabro cloud/external orchestration.
2. **Credentials via agent-vault, NOT fabro secrets.** (David, explicit.) The
   fabro-orchestrated BC gets its credentials through agent-vault (the established
   substrate). Fabro has its own secret-management system — do NOT use it. This is
   almost certainly one of the f6ta "invariant surfaces fabro must not touch."
3. **Launch-interface parity.** The fabro launcher must present the *same launch
   interface as `bc-container`* — a drop-in alternate launch path, not a new contract.
4. **shop-msg protocol preserved.** The recreated loop must consume the inbox and
   emit `work_done` per shop-msg exactly as the current bc-shop loop does. shop-msg
   is an invariant surface.
5. **Rollback:** every repo tagged `fabro-spike-baseline` (2026-07-01). All
   experimental work on a `fabro-spike` branch per repo; `main` untouched.
   Rollback = discard `fabro-spike` branches / reset to the tag.

## Baseline tags (rollback point) — created 2026-07-01

- dstengle/shopsystem-product (lead): `fabro-spike-baseline` (pushed)
- dstengle/shopsystem-templates: `fabro-spike-baseline` @ 16d8ccca1845
- dstengle/shopsystem-bc-launcher: `fabro-spike-baseline` @ 306453693979
- dstengle/shopsystem-messaging: `fabro-spike-baseline` @ d1ba322e8698
- dstengle/shopsystem-scenarios: `fabro-spike-baseline` @ 45b4ba1b78bd

## Thin slices (each = one workflow/subagent batch; log observations below)

- **Slice 0 — Baseline + fabro recon.** [tags done] Stand up an ephemeral local
  fabro server in a container; run a trivial workflow; document fabro's
  workflow/dotfile format + how it holds secrets (to design the agent-vault bypass).
  Read prior f6ta analysis → extract the "2 seams / 3 invariant surfaces". Output:
  `findings/fabro-spike/00-fabro-recon.md`.
- **Slice 1 — Spec the targets.** Characterize (from the artifact surface) (a) the
  `bc-container` launch interface a BC launch must satisfy, and (b) the basic
  workflow loop (Implementer→Reviewer, gated, emits via shop-msg/bc-emit). Output:
  `findings/fabro-spike/01-targets-spec.md`.
- **Slice 2 — Translate.** Design fabro dotfiles/workflow definitions recreating the
  loop; translate the needed shop-templates furniture into fabro's format. Output:
  the fabro workflow defs + `findings/fabro-spike/02-translation.md`.
- **Slice 3 — Fabro-orchestrated launch.** Launcher that boots the in-container fabro
  server and brings a BC up with the same launch interface as bc-container;
  credentials via agent-vault (constraint 2). Output: a BC that comes up under fabro.
- **Slice 4 — The goal.** Dispatch `assign_scenarios` to the fabro-orchestrated BC;
  confirm end-to-end shop-msg execution (build → review → work_done). Output: the
  demonstration + `findings/fabro-spike/04-goal-demo.md`.

Slices are provisional; refine as Slice 0 reveals fabro's real shape. Keep each thin.

## Execution discipline

- Drive via **workflows/subagents**; keep the main loop's context minimal (read only
  slice summaries; detailed work + notes live in `findings/fabro-spike/`).
- Test subject: a **throwaway minimal BC** (scaffold or a trivial existing one) — do
  not risk real BCs.
- Commit experimental work to `fabro-spike` branches. Copious notes per slice.

## Running log

- 2026-07-01: repos tagged `fabro-spike-baseline`. Plan persisted. Launching Slice 0.
- 2026-07-01: **Slice 0 DONE** (synthesis: `findings/fabro-spike/00-fabro-recon.md`;
  legs 00a/00b/00c). Result: fabro v0.254.0 is a real single Rust binary (GitHub
  Releases `fabro-sh/fabro`, not pip/npm), installs + boots headlessly, ran a trivial
  workflow end-to-end via `--dry-run` (simulated LLM, zero creds); **agent-vault
  bypass PROVEN** (dummy `GITHUB_TOKEN` in fabro's vault + `HTTPS_PROXY` proxy
  injection → real GitHub calls succeeded). Native secret seam to bypass =
  `vaults/default/secrets.json` (exact-name lookup). f6ta "2 seams / 3 invariants"
  recovered verbatim; Seam(a) launch=CLEAN, Seam(b) reactive-loop=PARTIAL (no native
  external-async primitive; `shop-msg watch` survives as a command node). Sharpest
  risk = fabro SlateDB checkpoint vs bd-authority ADR-012 race at the BC tier + new
  silent-failure-masking hazard (unconditional edges mark FAILED runs SUCCEEDED).
  **Slice 1 recommendation:** write the two target specs against the artifact surface
  only (bc-base is un-rebuildable, no live boot) — (A) the `bc-container` launch
  contract as the drop-in interface a fabro launcher must satisfy, mapping each
  asserted property to its fabro analog (`[run.clone]`/`[run.prepare]`/
  `[environments.<slug>] provider='local'` + vault-placeholder+`HTTPS_PROXY` cred
  path); (B) the minimal Implementer→Reviewer loop + gated `work_done` emission as a
  fabro DOT graph, with **outcome-conditional edges** so a FAILED node cannot reach
  Exit/SUCCEEDED. Output → `findings/fabro-spike/01-targets-spec.md`.
- 2026-07-01: **Slice 1 DONE** (synthesis: `findings/fabro-spike/01-targets-spec.md`;
  legs 01a launch-parity / 01b loop+work_done). Result: both target specs written
  against the artifact surface only (no live boot — bc-base un-rebuildable, ADR-022).
  Target A characterizes the `bc-container launch` contract as 20 observable properties
  (P1–P20) in three tiers — Container (KEPT: fabro rides inside an already-booted
  container under `provider='local'`), Engage (REPLACED: tmux `agent` TUI → ephemeral
  headless `fabro run` of Target B's graph; the idempotent readiness barrier = the seam),
  Credential (PROVEN agent-vault vault-placeholder + `HTTPS_PROXY`) — with 11 parity ACs
  for Slice 3. Target B is the full fabro DOT graph (`workflow.fabro`+`workflow.toml`)
  recreating the Implementer→Reviewer loop with the reviewer as SOLE work_done emitter,
  every fallible node carrying an explicit outcome-labeled failure edge (structural fix
  for the Slice-0 silent-failure-masking hazard) and 10 loop ACs for Slice 4. The two
  halves meet at ONE seam: the readiness barrier IS the first prepare node of the run.
  Consolidated Slice-2 furniture port list (11 skills/shims + the on-PATH CLI set incl.
  `scenarios hash`) captured. Carried risks: bc-base un-rebuildable (hard Slice-4
  prereq); `HTTPS_PROXY`-into-agent-node unproven (needs non-dry-run); LISTEN/NOTIFY
  block-wait unconfirmed (Seam(b) PARTIAL); command-node attribute unpinned (Slice-2
  `fabro validate`). **Slice 2 recommendation:** author the concrete fabro workflow
  defs — `workflow.fabro` DOT (from 01b §2), `workflow.toml`
  (`[environments.local] provider='local'`, `[run.retry.nodes]`,
  `[run.pull_request] enabled=false`), `.fabro` vault scaffold with dummy placeholders —
  and port the 11 shop-templates furniture pieces (bc-router/sufficiency-check/
  writing-plans-bdd/subagent-driven/TDD/worktrees/integrating/bc-review/work-done-gate +
  implementer/reviewer shims) into `prompt=`/`cmd=` node bodies; run `fabro validate` to
  pin the command-node attribute and assert no-fallible-node→SUCCEEDED. Output →
  `findings/fabro-spike/02-translation.md`.
- 2026-07-01: **Slice 2 DONE** (assemble+validate: `findings/fabro-spike/02-translation.md`;
  legs = defs graph + 11 furniture ports). Result: `fabro validate workflow.fabro` →
  **OK, 22 nodes / 39 edges, 0 diagnostics** (fabro 0.254.0, now symlinked onto PATH at
  `~/.local/bin/fabro`). Leg-1 graph × Leg-2 nodes reconciled — every `prompt_file=`
  resolves to a real `nodes/*.md`, every command node carries a concrete inline command,
  **no mismatches to fix**. **Command-node attribute pinned:** no native command
  StageHandler on the DOT surface → command steps are tool-restricted agent nodes
  (`class="command", deterministic=true, permissions="read-write"`, command inline in
  `prompt=`); `deterministic`/`backend` confirmed as binary-recognized tokens, validate
  is permissive on attr names, the LLM-node classification proof needs a live server
  (`preflight` → connection refused). **Fail-closed static check PASS:** `Exit:SUCCEEDED`
  (`done`) has exactly 3 labeled in-edges (`arm→empty`, `emit_r→ok`, `emit_f→ok`); all
  18 fallible nodes carry an explicit failure-labeled edge; three distinct terminals
  (`done`/`reported`/`halt`); only unlabeled edge is `start→prime`. Slice-0
  silent-failure-masking hazard structurally eliminated. Carried: U5 HTTPS_PROXY-into-agent
  LLM (sharpest), U1 box-sink run-status, U2/native-command (both need a live server),
  U3 `-I` input injection, U4 parallel fan-in. **Slice 3 recommendation:** first live
  `fabro run` of the graph inside an already-booted BC container (`provider='local'`,
  the readiness barrier = first prepare node) driven via a workflow — exercise the 8
  Slice-3 ACs in §7 of 02-translation.md, sharpest-risk-first (AC-proxy-cred: a non-dry-run
  agent node's own LLM + gh/git/shop-msg calls succeed through HTTPS_PROXY→agent-vault
  with only `__PLACEHOLDER__` in the vault). Confirm the deterministic-agent command
  nodes execute (else port to `.toml` execution, U2), that `${BC_NAME}`/`${WORK_ID}`
  resolve from `-I`, and that a forced failure yields run-STATUS FAILED with NO
  `work_done(complete)` on the wire (U1). Hard prereq unchanged: bc-base un-rebuildable
  (ADR-022) — needs an already-booted container.
- 2026-07-01: **Slice 3 DONE** (synthesis: `findings/fabro-spike/03-fabro-launch.md`;
  legs 03a proxycred-recon / 03c shim-U5-close / 03b runtime-mechanics). Result: the
  launch path WORKS — first live `fabro run` under `provider='local'` succeeds. **8
  Slice-3 ACs = 6 PASS, 2 DEFERRED, 0 FAIL.** **U5 CLOSED** (was the load-bearing
  BLOCKER): root cause was a header-shape mismatch (fabro's Anthropic adapter uses
  `x-api-key`; the fleet agent-vault only rewrites OAuth `Authorization: Bearer` +
  `anthropic-beta`). Fix = a ~180-line stdlib **anthropic-oauth-shim** (`127.0.0.1:8788`)
  that strips `x-api-key`, adds the OAuth headers, and forwards through `HTTPS_PROXY`→
  agent-vault; fabro points at it via the **`anthropic` adapter `base_url` override**
  (native Anthropic format both ways — NO translation). A fabro node's OWN LLM call +
  its `gh api user` both succeed through agent-vault with fabro's vault holding only
  `__PLACEHOLDER__` — **invariant #2 preserved (verified)**. Runtime mechanics all
  pinned: AC2 command-node (native `script=` = the execution layer, no `.toml` needed),
  AC4 fail-closed (native `exit 1` `halt` SINK + `condition="outcome=failed"`), AC6
  input-injection (`{{ inputs.NAME }}` minijinja + `[run.inputs]` + `-I`), AC7 fan-in
  (`impl parallel=true` single-stage converges, no `parallel.fan_in`). **bc-base =
  AVAILABLE** (3 healthy BC containers running + `:latest` pullable) → Slice-4 real e2e
  is REACHABLE. Defs corrected + revalidated (22 nodes / 44 edges OK); shim (pid 286891)
  + fabro server (pid 287406) left running. Carried #1 risk = AGENT NO-DIRECTIVE HAZARD
  (an agent that completes but emits no directive is not hard-fail-closed; backstops =
  native gates + halt sink; clean fix = native `script=` gates, needs the
  input-into-command-sandbox gap closed). **Slice 4 recommendation:** run the graph
  INSIDE a healthy bc-launcher container (invariant #1; container already carries
  HTTPS_PROXY, side-stepping the local-sandbox env traps) — install fabro+defs+shim,
  seed a throwaway `assign_scenarios` into the inbox via `shop-msg`, `fabro run
  workflow.fabro -I BC_NAME=<bc> -I WORK_ID=<id>`, then exercise the two deferred ACs
  live: AC5 gated-emit (reviewer is SOLE `bc-emit work-done --status complete`;
  UNIQUE-collision → halt → FAILED, no second emit) and AC8 reactive-seam (`shop-msg
  watch` LISTEN/NOTIFY drain). Observe a valid `work_done` = goal green → write
  `findings/fabro-spike/04-goal-demo.md`. Throwaway BC only; never the lead host.
