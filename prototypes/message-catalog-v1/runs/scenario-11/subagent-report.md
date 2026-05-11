# Scenario 11 — full RequestMaintenance flag coverage on `shop-msg send` + harness retirement

## Setup
- Single `assign_scenarios` (work_id: lead-011) carrying two scenarios:
  - hash `d57e1ed181a81e7e` — happy path: one criterion + one file hint round-trip
  - hash `c68d62ccae4fc40d` — repeatability: multiple `--acceptance-criterion` flags accumulate
- Lead chose `assign_scenarios` (not `request_bugfix`) deliberately. The CLI did not previously accept these flags at all — this is a capability gap, not a tightening of unpinned behavior. User correction during the slice 11 framing established this discriminator (saved as bd memory `shop-system-message-type-selection`); deferred design item filed as `ddd-product-system-sgh` (lead-side message-type-selection sufficiency check).
- Pre-state: 9 scenarios passing in shop-msg-bc; 6 unit tests passing in temperature bc-shop. Both remained green throughout.

## Run sequence

1. **Implementer dispatched.** Sufficiency check passed.
   - **`cli.py`**: added repeatable `--acceptance-criterion` and `--file-hint` flags (action="append", default=None) on `send request_maintenance`. Mirrors the `--scenario-hash` pattern from `respond work_done`. Coerces with `list(args.X or []) or None` so absence yields `None`. Switched the YAML dump to `model_dump(exclude_none=True)` so optional fields stay out of the YAML when unset.
   - **`tests/conftest.py`**: anchored the pre-existing description-only When regex with `$` so longer-phrased When variants do not collide; added two new When step defs (each anchored with `$`) and two new Then step defs that use a small `_parse_quoted_list` helper for list-content assertion.
   - **One new feature file** containing both scenarios.
   - BDD: 11/11 in shop-msg-bc; 6/6 in bc-shop.
   - Outbox: NOT written. Implementer respected the gate.

2. **Reviewer dispatched.** Re-ran BDD; probed; signed off.

## Reviewer outcome

- **Sign-off** via `shop-msg respond work_done` with all 11 currently-pinned scenario hashes echoed (2 new + 9 pre-existing).
- Probes considered and dismissed:
  - **`model_dump(exclude_none=True)` regression risk on prior happy-path** — prior Then step asserts only on `work_id` and `description`; `RequestMaintenance(**data)` treats absent and None equivalently for the optional list fields. No regression. Dismissed.
  - **`_parse_quoted_list` edge cases** — naive regex (`r'"([^"]*)"'`) would mis-parse strings containing escaped quotes, but pinned scenarios use simple strings. Defensible. Dismissed.
  - **Anchoring the pre-existing When regex** — change to existing step-def code; collision scenario still uses description-only and passes. No regression. Dismissed.
  - **Empty-list edge case** (`--acceptance-criterion ""` vs absent) — different semantics, not pinned. Defensible deferral. Dismissed.
  - **File-hint repeatability** not separately scenario-pinned — identical argparse code path as criterion. Defensible deferral. Dismissed.
  - **Step def hygiene** — all `$`-anchored, no exception swallowing, function-scoped fixtures. Clean.

## Harness retirement (same slice)

`emit-s1`, `emit-s2`, `emit-s2c`, `emit-s3` blocks deleted from `harness.py`. Help text updated (commands now start at `emit-s4`). `RequestMaintenance` removed from harness imports (no longer constructed). The historical `runs/scenario-{1,2,2c,3}/inbox.yaml` files remain untouched as frozen artifacts; the lead-side reproduction path is now `shop-msg send request_maintenance` with the values from those frozen YAMLs.

## What this validated

- **The "right vehicle" discriminator survives the catalog.** The lead-side could have used `request_bugfix` to add the new flags (and once nearly did — see ddd-product-system-sgh and the bd memory). It did not: `assign_scenarios` is the correct vehicle for new capability, with Gherkin scenarios committing to the new behavior. The slice is the prototype demonstrating the discrimination it just discovered.
- **The lead-side CLI now fully covers the RequestMaintenance schema.** All four schema fields (`work_id`, `description`, `acceptance_criteria`, `file_hints`) are CLI-addressable. The harness retirement is the natural consequence — the four hardcoded builders are no longer load-bearing convenience.
- **Cumulative-passing-set echoing held on second exercise.** S10 was the first slice where the Reviewer echoed the full pinned set; S11 confirms the discipline reproduces. Two slices is not yet a pattern, but the role-template language is doing what it was meant to do.
- **`exclude_none=True` discipline keeps the wire format clean.** Previously, the `send request_maintenance` happy-path emitted `acceptance_criteria: null` and `file_hints: null` keys. Now those keys are absent when unspecified. The Reviewer probed whether this regresses prior assertions; it does not, because `RequestMaintenance(**data)` accepts both representations.

## Cumulative state after slice 11

- **shop-msg-bc:** 11 scenarios passing (5 clarify, 2 work_done, 4 send: happy, collision-refuse, full-flags happy, repeatable-criterion).
- **temperature bc-shop:** 6 tests passing.
- **shop-msg CLI surface:** `respond clarify`, `respond work_done`, `send request_maintenance` (now full schema coverage). Bidirectional + complete for the request_maintenance message type.
- **harness.py:** retired emit-s1/s2/s2c/s3; commands are now emit-s4..emit-s11 + read + verify-hashes.
- **Catalog message types exercised end-to-end:** `request_maintenance`, `assign_scenarios`, `request_bugfix`, `clarify`, `work_done`.
- **Catalog message types still unexercised:** `request_shop_card`, `request_scenario_register`.
- **Open deferred items:**
  - `shop-msg send assign_scenarios` / `send request_bugfix` — needs hash canonicalization moved into the catalog package.
  - `shop-msg inbox-next` / `read` — lead-side response-reading parallel to harness.py's `read`.
  - Lead-side message-type-selection sufficiency check (ddd-product-system-sgh).
  - Schema-level `work_id` constraints on RequestMaintenance and other lead-message types — deferred catalog-wide.
  - Replacing hardcoded paths in temperature BC's role templates — possible since both `respond` halves AND `send request_maintenance` are safe.
