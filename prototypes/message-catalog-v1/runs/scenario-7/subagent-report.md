# Scenario 7 — §4.4 loop continuation: request_bugfix → re-implement → re-gate

## Setup
- Lead's response to S6's clarify: chose "refuse with non-zero exit" from the three alternatives the Reviewer proposed.
- New schema: `RequestBugfix` (work_id, description, scenarios). Added to `LeadMessage` union.
- Implementer prompt extended with a `request_bugfix` section: sufficiency check (description concrete + embedded scenarios well-formed), and "doing the work" (treat embedded scenarios as additive; all scenarios — old and new — must pass).
- Pre-state: BC has 1 passing scenario (`b9ed9c63b8ccb208` — happy-path respond clarify) from S6. Verified via pre-dispatch `pytest tests/`.

## Run sequence
1. Lead emitted `request_bugfix` (work_id: lead-007, scenario hash: b6973413b7bfdd12). Description named the contract change ("refuse with non-zero exit when an outbox file for the given work_id already exists, leaving the existing file unchanged"), referenced the prior hash as additive (not superseded), and explicitly framed the new scenario as additive.

2. **Implementer dispatched.** Sufficiency check passed (both parts).
   - Wrote `features/respond_clarify_collision.feature` preserving tags.
   - Added step definitions to `tests/conftest.py`:
     - `Given the BC's outbox already contains a file named "..."` (seeds preexisting bytes via fixture)
     - `Then the command exits non-zero`
     - `Then the BC's outbox file "..." is unchanged` (byte-identical compare against bytes captured at Given time)
   - **Refactored the existing When step.** The original `When I run shop-msg respond clarify ...` had `returncode == 0` asserted inline; that would have failed the new scenario. The Implementer correctly moved the success assertion into the happy-path `Then ... contains a file named "..."` step so the collision scenario could share the When phrasing while expecting non-zero exit. Both Then branches now pin their expected exit code.
   - Modified `src/shop_msg/cli.py`: `_cmd_respond_clarify` checks `out_path.exists()` and returns exit 1 with stderr message before constructing or writing the Clarify message; the preexisting file is not touched.
   - BDD: 2 passed, 0 failed. Did NOT write to outbox.

3. **Reviewer dispatched.** Re-ran BDD (2/0). Adversarially probed.

## Reviewer outcome
- **Sign-off.** Emitted `work_done` with `status: complete` and both hashes (`b9ed9c63b8ccb208`, `b6973413b7bfdd12`) in `scenario_hashes`.
- Probes considered and dismissed:
  - **Existence check ordering.** Verified `out_path.exists()` runs BEFORE message construction or file open. Correct.
  - **Byte-exactness of "unchanged".** Read at Given, compared after CLI runs — would catch truncate-and-rewrite-same-bytes attempts. Solid.
  - **Refactored When step swallowing failures.** Both branches assert exit code; failing CLI cannot silently slip past either scenario. No gap.
  - **Symlink / file-vs-directory at target path.** `Path.exists()` covers both; refusal consistent. Adjacent to deferred path-traversal concern; not urgent.
  - **Same-content collision.** CLI refuses unconditionally on existence per the lead's literal contract. Faithful.
  - **Empty `--work-id` / `--question`, path traversal via `--work-id`.** Both explicitly deferred by the lead's prior clarify; folding them in now would muddy the §4.4 loop validation. Not urgent enough to escalate.

## What this validated

**The §4.4 loop is real and closes end-to-end.** The full cycle ran in this prototype for the first time:

```
S5b → S6 → S7
Reviewer finds gap → clarify to lead → lead decides → request_bugfix
                  → BC re-implements → Reviewer re-gates → work_done
```

Each step happened naturally inside the role-template + dispatch architecture; no bespoke mechanism was needed for the loop. The Reviewer in S6 surfaced a real gap (collision behavior unpinned, recursive: in the very tool meant to manage path consistency). The lead chose one of three named alternatives. The Implementer in S7 implemented the chosen contract, the existing scenario continued to pass, and the Reviewer signed off after probing both new and old behavior.

**`work_done.scenario_hashes` carries the cumulative passing set.** Both the original `b9ed9c63b8ccb208` and the new `b6973413b7bfdd12` appear in the list. The lead can confirm both contracts are pinned by what's currently in the BC.

**Implementer agency on integration is real and necessary.** The Implementer was not just adding a scenario — it had to refactor the existing When step because the new scenario shared phrasings but required different exit-code expectations. A purely additive flow would have failed BDD; the Implementer correctly identified this and reorganized the assertions so both scenarios pin their expected behavior cleanly. This is the kind of judgment that distinguishes scenario-driven development from scenario-stapled development.

## Open items still deferred
- Path traversal via `--work-id` containing "/" or ".."
- Schema-level emptiness on `Clarify.work_id` / `Clarify.question`
- Other CLI commands (`send`, `inbox-next`, `hash`)
- Replacing hardcoded paths in the temperature BC's role templates (now safer to attempt: the CLI's collision contract is pinned)

## Slice 6 also exercised

- **`RequestBugfix` schema works.** First time the catalog actually carries this message type with embedded scenarios. The optional-empty `scenarios` field accommodates plain-language defects too (untested in this slice).
- **Multi-scenario BC.** Two scenarios in one BC, both auto-discovered by `tests/test_features.py`, both pass. Step-definition reuse across scenarios works (the new scenario reuses the original `Given empty BC at a temporary path` and `When I run shop-msg respond clarify ...`).
- **Reviewer respects deferred items.** The Reviewer noted the parenthetical concerns from the previous clarify and deliberately did not re-escalate them, citing "folding them in now would muddy the §4.4 loop validation." Good discipline — exact opposite of pedantic-clarify failure mode.
