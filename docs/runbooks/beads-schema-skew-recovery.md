# Runbook: recovering a beads Dolt remote wedged by main-series schema skew

## When this runbook applies

Your beads (bd) tracker refuses to open, sync, or migrate a Dolt remote, and
the failure is a migration dying with a **`table not found: wisps`** error
(observed at migration `0047_recompute_mixed_is_blocked`). This happens when an
**older** bd binary last pushed the remote and a **newer** bd binary is now
adopting it — specifically, when the remote's main-series schema is in the
**20..46 band** (last pushed by bd `<= v1.0.4`, schema `v32`) and it is now
being adopted by bd `v1.1.0` (schema `v53`). Any remote in that schema band
wedges identically. If your symptom is a different missing table or a
migration outside this band, this runbook may not fit — stop and diagnose
before applying any step below.

> **Read the whole runbook before touching the remote.** The two "obvious"
> recoveries bd itself suggests are both traps on a wedged remote (see
> "Why bd's two suggested recoveries are traps"). The safe path does a
> read-only diff *before* any write.

## Root cause: a local-only table on a pushed migration series

The `wisps` table is registered in **`dolt_ignore`**. `dolt_ignore` entries are
**local-only**: they never transfer on clone. The migration that *creates*
`wisps` — `0020_create_wisps` — nonetheless lives in the **main migration
series**, which **does** push, because migration application is recorded in the
**`schema_migrations`** table and `schema_migrations` transfers on clone.

The two facts collide on any clone:

- `schema_migrations` arrives claiming migration `0020` was applied, so a
  freshly-cloned bd believes `wisps` already exists.
- The `wisps` table itself never arrived (it was `dolt_ignore`d at the source
  and so was never part of what pushed).

The clone therefore holds a `schema_migrations` history that is **ahead of** the
tables actually present. A later migration — `0047_recompute_mixed_is_blocked`
— reads `wisps`, finds it absent, and dies with `table not found: wisps`. The
newer binary cannot migrate forward through `0047`, and the remote is wedged.

The trigger is a binary/schema mismatch across a push boundary: a remote last
pushed by a bd whose **max main-series migration equals the remote's schema**
(e.g. `v1.0.4` at schema `v32`) is now being adopted by a bd carrying a much
higher schema (`v1.1.0` at schema `v53`), whose migration set includes `0047`.

## Why bd's two suggested recoveries are traps

On hitting the wall, bd suggests two recoveries. **Both are traps on a wedged
remote that may be ahead of your local copy.** Do not run either blind:

1. **Force-push-keep-local.** This overwrites the remote with your local
   history. If the remote is actually **ahead** of your local copy — it holds
   issues or updates you never pulled — a force-push **silently destroys** those
   remote-ahead issues. You cannot know whether the remote is ahead until you
   have read it, and the wall is precisely what is stopping you from reading it
   with the new binary. Force-pushing before you have a real ID-set diff is
   data loss waiting to happen.

2. **Bootstrap-keep-remote.** This re-initializes local state from the remote
   and keeps the remote as-is. It gets you a working local DB, but that DB
   inherits the same skewed `schema_migrations`/`wisps` mismatch — so it
   **cannot migrate forward**. You have a DB that opens but wedges again the
   moment a forward migration touches `wisps`. You have deferred the wall, not
   cleared it.

## The safe path: read the wedged remote with the matching OLD binary first

The safe recovery reads the remote **without hitting the migration wall**, so
you can compute a real diff before any write touches anything.

Use the **OLD bd binary whose maximum main-series migration equals the remote's
current schema** — for a remote at schema `v32`, that is bd `v1.0.4`. That
binary's migration set does **not** include `0047`, so it never reaches the
`wisps` read that wedges the new binary. It reads the remote **natively**,
exactly as the binary that pushed it would.

1. **Identify the remote's schema version.** Determine the schema the remote was
   last pushed at (it is in the `20..46` band for this failure mode; `v32` is
   the canonical example). Select the OLD bd binary whose max main-series
   migration equals that schema — `v1.0.4` for `v32`.

2. **Read the remote with the OLD binary.** Open/clone the remote with the OLD
   binary. Because that binary never runs `0047`, it opens the remote cleanly
   and lets you enumerate the remote's real issue ID set.

3. **Compute a real ID-set diff — read-only, before any write.** Enumerate the
   remote's issue IDs (via the OLD binary) and your local issue IDs, and diff
   the two sets. This tells you the truth the traps above assume away:
   - IDs present on the remote but **absent locally** = remote-ahead issues a
     force-push would destroy.
   - IDs present locally but **absent on the remote** = local-ahead work a
     keep-remote bootstrap would drop.

4. **Only now choose a recovery, informed by the diff.** With the real diff in
   hand you can reconcile deliberately — reintegrate remote-ahead IDs into local
   before any push, and only then bring the tracker forward under the new
   binary — instead of gambling on one of the two blind traps. Never let the
   first write happen before the read-only diff is complete.

## Summary

- **Symptom:** `table not found: wisps` at migration `0047`, remote schema in
  the `20..46` band, new binary `v1.1.0` (schema `v53`) adopting a remote last
  pushed by `<= v1.0.4` (schema `v32`).
- **Cause:** `wisps` is `dolt_ignore`d (local-only, never clones) but its
  creating migration `0020` rides the pushed `schema_migrations` series, so
  clones inherit a migration history ahead of their actual tables.
- **Do not:** force-push-keep-local (destroys remote-ahead issues) or
  bootstrap-keep-remote (leaves a DB that cannot migrate forward) — not before a
  diff.
- **Do:** read the wedged remote with the OLD binary whose max main-series
  migration equals the remote's schema, compute a real read-only ID-set diff,
  and only then reconcile and migrate forward.
