# Process: Reconcile and close

**Format slice: the loop-free example** — proving the format on a small,
mechanical, already-real shop process (the existing `reconcile-and-close`
skill and wrapper are its current carrier). Same composed format as the
loop-bearing example; no loop, so no exit machinery beyond activity exits.

**Purpose:** Convert a BC's completed dispatch into reconciled shop state:
response consumed, work item closed with a traceable reason, contract
surface confirmed, follow-ups filed.

**Outcomes:**
- O1. The BC's `work_done` response is consumed (no longer pending).
- O2. The originating work item is closed with a reason that cites the
  demonstration evidence.
- O3. The scenario register and pinned hashes are confirmed consistent with
  what was dispatched.
- O4. Every defect or follow-up surfaced by the response exists as a filed
  work item.

**Roles:** router (Accountable — executes); lead-architect (Consulted —
scenario-register discrepancies only).

**Artifacts:** in — the `work_done` outbox row; the originating work item.
out — closed work item; follow-up work items; reconciliation note.

**Carried by:** the existing `reconcile-and-close` skill + executable
wrapper (already an atomic consume+close — this definition is what that
carrier would be conformance-checked against).

## Activities

### R1 — Verify the demonstration
- **Entry:** a `work_done` row is pending for a dispatched work_id.
- **Tasks:** read the response; check the demonstration against the
  dispatched scenarios; compare pinned hashes to the register.
- **Validation:** every dispatched scenario is addressed (done, blocked, or
  explicitly deferred) — silence on a scenario fails validation.
- **Exit:** verdict formed: reconcile, or route a discrepancy.
- **Annotations:** `runtime.fabro: {model: mid-tier (e.g.); this is the
  finite per-message run shape fabro already executes}`

### R2 — Consume and close (atomic)
- **Entry:** R1 verdict = reconcile.
- **Tasks:** consume the outbox row and close the work item with a
  reason citing the demonstration — one atomic act (a consumed-but-open or
  closed-but-pending split state is the known failure mode this process
  exists to prevent).
- **Validation:** neither half succeeded without the other.
- **Exit:** O1 and O2 hold.

### R3 — File the tail
- **Entry:** R2 exit.
- **Tasks:** file follow-up items for every surfaced defect, observation,
  or deferred scenario; link them to the closed item.
- **Validation:** count of surfaced items == count of filed items.
- **Exit:** O4 holds; instance closed.

## Derived checks

| Outcome | Check | Kind |
|---|---|---|
| O1+O2 | no consumed-but-open or closed-but-pending state after run | mechanical |
| O2 | close reason cites demonstration evidence | mechanical presence + judged |
| O3 | register/hash comparison recorded | mechanical |
| O4 | surfaced-vs-filed count match | mechanical |
