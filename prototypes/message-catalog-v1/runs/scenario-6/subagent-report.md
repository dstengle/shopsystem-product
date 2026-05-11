# Scenario 6 — shop-msg-bc bootstrap, first command (`respond clarify`)

## Setup
- New BC: `shop-msg-bc/`, scaffolded as an empty skeleton (empty `src/shop_msg/__init__.py`, `tests/conftest.py` with sys.path setup but no step defs, `tests/test_features.py` auto-discovery one-liner, empty `features/`/`inbox/`/`outbox/`).
- Harness parameterized with `--bc <path>`. Defaults to the temperature `bc-shop/`; this run targeted `shop-msg-bc/`.
- Lead emitted `assign_scenarios` (work_id: lead-006, hash: b9ed9c63b8ccb208) specifying one scenario for `shop-msg respond clarify`.

## Run sequence
1. **Implementer dispatched.** Sufficiency check passed.
   - Wrote `features/respond_clarify.feature` preserving tags.
   - Added step definitions to `tests/conftest.py` (Given empty BC at tmp_path; When run subprocess `python3 -m shop_msg respond clarify --bc-root --work-id --question`; Then outbox contains file; And file parses as valid Clarify with field assertions).
   - Implemented the CLI:
     - `src/shop_msg/cli.py` — argparse with `respond clarify --bc-root --work-id --question`. Constructs `Clarify` (validating against the shared `schemas.Clarify`), writes YAML to `<bc-root>/outbox/<work_id>-clarify.yaml`.
     - `src/shop_msg/__main__.py` — entry-point shim so the CLI runs via `python3 -m shop_msg`.
   - BDD: 1 passed, 0 failed.
   - Did NOT write to outbox (correct).

2. **Reviewer dispatched.** Re-ran BDD (1/0). Adversarially probed.

## Reviewer outcome
- **Emitted `clarify`** to lead with proposed scenario tightening.
- Outbox: `shop-msg-bc/outbox/lead-006-clarify.yaml` (validates against `Clarify` schema).
- Probes:
  - **Filename collision on same work_id (REAL GAP).** Second invocation silently overwrites. Concrete reasoning given: the §4.4 loop validated in S5b is exactly "BC clarifies → lead request_bugfix → BC may clarify again on the same work_id," and the CLI is the tool meant to enforce path consistency across that loop. The current behavior destroys outbox history at exactly this boundary. Three defensible alternatives named (refuse with non-zero exit; counter-suffix; timestamp-suffix). Lead asked to pick.
  - *Path traversal via `--work-id "../escape"`* — surfaced parenthetically.
  - *Empty work_id / empty question accepted* — surfaced parenthetically (schema-level concern).
  - *Non-existent BC root* — dismissed as low-stakes for this tightening.
  - *Multi-line questions / colons in YAML* — round-trip clean. Dismissed.
  - *Step regex tightness* — `parsers.parse` with quoted captures, no risk of cross-step matching. Dismissed.

## What this validated

- **Multi-BC operation works.** Two separate BCs (`bc-shop/` and `shop-msg-bc/`) coexist under one prototype root, each with own inbox/outbox/features/tests. The lead targets either via `--bc <path>`. The harness change to support this was small (parameterize `BC_SHOP`, add `--bc` flag).
- **Bootstrap from empty skeleton works.** The Implementer received a BC with no source code, no step definitions, and no Gherkin features, and produced all three from one assigned scenario. Same as S5b but more pronounced — there was no underlying capability at all to start from.
- **Scenarios are rich enough to specify CLI contracts.** A single Given/When/Then captured the BC root, command shape, output filename, and YAML schema. Both Implementer and Reviewer worked from this representation alone.
- **The Implementer + Reviewer split holds for infrastructure code.** Same role discipline that worked for the temperature BC worked here — Implementer doesn't write outbox, Reviewer is the gate, Reviewer surfaces a real scenario gap.
- **Recursive demonstration.** The slice's whole purpose was to eliminate filename inconsistencies in the message catalog. The Reviewer found that the tool's first command has its OWN filename inconsistency (collision behavior unpinned). The fix loops back through the §4.4 mechanism. The system surfaces gaps in the tools meant to manage its own gaps.

## Open items surfaced (deferred)
- The collision-on-same-work_id contract — the lead must pick (refuse / counter-suffix / timestamp). Until pinned, the tool is unsafe to adopt in the existing temperature BC's role prompts.
- Path traversal through `--work-id` (separate scenario worth assigning).
- Schema-level emptiness checks on `Clarify.work_id` / `Clarify.question` (separate concern).
- Other commands (`send`, `inbox-next`, `hash`, etc.) deferred to later slices.
- Replacing hardcoded paths in `bc-shop/` role prompts deferred until the CLI is mature enough to adopt.
