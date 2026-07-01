# Fabro spike — plan & running log

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
