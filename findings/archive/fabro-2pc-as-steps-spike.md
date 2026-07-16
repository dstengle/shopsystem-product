> **ARCHIVED** — historical spike record, not current state (ADR-065). Superseded by: informed the fabro-adoption decision recorded in ADR-048; no dedicated graduation ADR of its own.

# Spike: moving the shop-msg bd-first 2PC into separate fabro steps (lead-f6ta)

Initiative lead-odqd. Throwaway spike, 2026-06-09. **Verdict: go-with-caveats.** Real experiment: installed fabro 0.254.0, stood up a local fabro server (non-interactive, no LLM, dev-token auth), and ran a throwaway harness modelling ADR-012's three-step outbox protocol (bd `outbox_pending`+fsync → postgres/SQLite deposit → bd `dispatched`) as distinct fabro nodes against a stealth bd Dolt store + a SQLite outbox carrying ADR-012's exact `UNIQUE(work_id,direction,shop)` backstop. Live shopsystem postgres/fleet untouched.

## The hypothesis (yours)

Split ADR-012's bd-first 2PC into **separate fabro nodes** so fabro's per-node checkpoint boundaries *align* with the protocol's step boundaries, removing the phantom/duplicate-postgres-row hazard that lead-f6ta flagged for the single-node (ADR-016-as-is) design where fabro checkpoints on the same node that runs `shop-msg respond`.

## Result — confirmed for the common case, not a full fix

- **CONFIRMED for a kill landing BETWEEN nodes.** fabro checkpoints after every node (`completed_nodes` accumulates start→n1→n2→n3, each with a `next_node_id`); resume re-executes only from `next_node_id`. A kill after N2's checkpoint replays **only** N3 — never re-deposits. Postgres row stays exactly 1, no UNIQUE violation, bd correctly reaches `dispatched`. (Single-node baseline B1: a kill inside the one node re-executes the **entire** node from the top on resume — the hazard the decomposition removes.)
- **NOT eliminated for the micro-window kill.** A kill *inside* N2 after the DB commit but before N2's checkpoint causes resume to re-run N2 and re-attempt the deposit — rejected **only** by ADR-012's UNIQUE backstop (observed `SQLITE_CONSTRAINT` exit 19). So **ADR-012's UNIQUE constraint + the bd-first sweeper remain mandatory**; step-decomposition narrows the window, it does not close it.
- **NEW, unanticipated hazard.** fabro's default **unconditional edges advance past a FAILED node and mark the whole run SUCCEEDED**, silently masking the deposit-retry failure. Must be handled with **outcome-conditional edges or node retry policies** — otherwise a failed deposit looks like success.

## What Phase 2 (ADR + scenarios) must cover, if fabro is adopted

- Keep ADR-012's `UNIQUE(work_id,direction,shop)` + bd-first sweeper as the authority — decomposition is an optimization, not a replacement.
- Model the outbox protocol as ≥3 nodes with **outcome-conditional edges** (no silent pass-through on node failure); idempotent deposit (`INSERT … ON CONFLICT`/retry-aware) so a replayed N2 is a no-op rather than a hard constraint error.
- Carries forward the prior fabro verdict's invariants: bd stays the authority (fabro checkpoint demoted to resume-only); no addressing-registry analog (lead still runs `shop-msg registry add`); harvest only via `shop-msg` + `scenarios hash` (ADR-018), never fabro outputs.

## Note

This resolves the *2PC-as-steps* sub-question of lead-f6ta. The bead's broader full-e2e (fabro running a live BC round-trip) remains gated on bc-base rebuildability (ADR-022) per the original bead. See also `findings/substrate-candidate-comparison-vs-fabro.md` — fabro remains the substrate baseline; no simpler self-hostable alternative beats it on the reactive-loop seam.
