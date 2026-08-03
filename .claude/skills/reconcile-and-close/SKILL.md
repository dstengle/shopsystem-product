---
name: reconcile-and-close
description: Reconcile a completed BC dispatch by consuming its work_done outbox row and closing the corresponding bead as one atomic reconcile-and-close action via the reconcile-and-close executable wrapper
---

# Reconcile and Close

## Overview

When a BC finishes a dispatch it emits a `work_done` message into its outbox.
The lead's reconciliation step for that dispatch is two operations that must
land together:

1. **`shop-msg consume`** of the BC's `work_done` outbox row — so the row no
   longer appears in `shop-msg pending outbox`, and
2. **`bd close`** of the corresponding bead for that `work_id` — so the lead's
   work-tracking ledger records the dispatch as done.

These two operations are a **pair**: a consumed outbox row alongside a bead
that is still open (consumed-but-open drift), or a closed bead alongside an
outbox row that was never consumed (closed-without-consume drift), are both
reconciliation defects. This skill's job is to land the pair **atomically**.

## Do NOT run the two steps by hand

Do **not** reconcile a dispatch by running `shop-msg consume` and `bd close`
as two separate hand-typed commands. Running them by hand has no fail-safe: if
the second command fails (or you are interrupted between them) the pair
half-completes and the ledger drifts out of sync with the outbox. The manual
two-step is exactly the failure mode this skill exists to remove.

## Instead: invoke the `reconcile-and-close` executable wrapper

Invoke the executable **`reconcile-and-close`** wrapper (poured into the shop
ops surface at `bin/reconcile-and-close`, parallel to the `bc-emit` work-done
wrapper). The wrapper performs the `shop-msg consume` of the BC `work_done`
outbox row and the `bd close` of the corresponding bead as **one atomic
reconcile-and-close action**:

```bash
bin/reconcile-and-close --bc <bc-name> --work-id <work_id>
```

The wrapper resolves the `work_done` outbox row for `<work_id>` under
`<bc-name>` and the corresponding bead (the bead whose id is the `work_id`),
and reconciles them together.

## The fail-safe guarantee

The wrapper is **fail-safe in both directions** — the pair never
half-completes:

- If the **`bd close` fails**, the wrapper leaves the `work_done` outbox row
  **unconsumed** (it still appears in `shop-msg pending outbox`), rolling back
  any partial consume rather than leaving a consumed row alongside an open
  bead. No consumed-but-open drift results.
- If the **`shop-msg consume` fails**, the wrapper leaves the corresponding
  bead **open** (rolling back the `bd close` via `bd reopen`), rather than
  leaving a closed bead alongside an unconsumed row. No closed-without-consume
  drift results.

On either failure the wrapper exits non-zero and names which step failed, so
the operator can fix the underlying condition and re-invoke the wrapper. On
success both the outbox row is consumed and the bead is closed, and the
wrapper exits zero.
