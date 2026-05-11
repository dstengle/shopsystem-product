# Scenario 10 — bidirectional CLI surface (`shop-msg send request_maintenance`)

## Setup
- Single `assign_scenarios` (work_id: lead-010) carrying two scenarios for the lead-side complement of `respond`:
  - hash `8c763f64d50253dc` — happy path: write a valid RequestMaintenance inbox file
  - hash `6f37b1ccd3826bad` — collision-refuse: refuse to overwrite an existing inbox file for the same work_id
- Pattern: same shape as S6 (assign_scenarios for new capability) and S9 (additive sibling subcommand), but on the lead side. The lead applied the collision-refuse contract from S6→S9 learning to the inbox boundary at the moment of introduction.
- Pre-state: 7 scenarios passing in shop-msg-bc; 6 unit tests passing in temperature bc-shop. Both remained green throughout.

## Run sequence

1. **Implementer dispatched.** Sufficiency check passed for both scenarios.
   - **`cli.py`**: added `_cmd_send_request_maintenance` mirroring the respond collision short-circuit pattern — exists()-check on `<bc-root>/inbox/<work_id>.yaml`, then build `RequestMaintenance(...)` and `yaml.safe_dump`. New top-level `send` subparser tree with `request_maintenance` subcommand; flags `--bc-root`, `--work-id`, `--description`. Optional schema fields (`acceptance_criteria`, `file_hints`) NOT exposed as CLI flags — scenarios don't pin them; left to a later request_bugfix slice if/when needed.
   - **`tests/conftest.py`**: added `RequestMaintenance` import; new step defs for inbox-side phrasings (Given preexisting inbox file, When `shop-msg send request_maintenance ...`, Then inbox-contains-file, Then RequestMaintenance-parses, Then inbox-file-unchanged). Reused existing `Then the command exits non-zero`. Distinct context-dict key (`preexisting_inbox_files`) so inbox-side and outbox-side preexisting fixtures don't collide.
   - **Two new feature files**, tags preserved.
   - BDD: 9/9 in shop-msg-bc; 6/6 in bc-shop (cross-BC regression check).
   - Outbox: NOT written. Implementer respected the gate.

2. **Reviewer dispatched** via the updated role template (uses `shop-msg respond ...` for outbox writes, not hand-rolled YAML). Re-ran BDD; probed adversarially; signed off.

## Reviewer outcome

- **Sign-off** via `shop-msg respond work_done`. All 9 currently-pinned scenario hashes echoed in `scenario_hashes` (2 new + 7 pre-existing) — the Reviewer respected the role-template's "every scenario hash that currently passes" instruction added in this iteration.
- Probes considered and dismissed:
  - **Literal-text shortcut on happy path** — dismissed; CLI builds a real `RequestMaintenance(...)` via Pydantic and round-trips through `yaml.safe_dump`. The Then step parses through the schema again, so a hard-coded YAML literal would diverge from the schema's serialization.
  - **Collision TOCTOU** between `exists()` and `open("w")` — present but parallels existing respond pattern; not pinned by scenarios. Dismissed for consistency.
  - **`RequestMaintenance.work_id` lacks pattern constraint** (unlike `Clarify.work_id`) — pre-acknowledged catalog-wide deferral. Dismissed.
  - **`acceptance_criteria` / `file_hints` flags absent** — scenarios don't pin them; lead pre-scoped to S8 vehicle for any future expansion. Dismissed.
  - **Fixture state leakage between inbox-side and outbox-side preexisting buckets** — separate `context["preexisting_files"]` vs `context["preexisting_inbox_files"]` dict keys. No leak.
  - **Then-step ambiguity (inbox vs outbox phrasings)** — step text differentiates `inbox` vs `outbox` literally; pytest-bdd cannot mis-route. Clean.
  - **Send subparser tree** — `required=True` on both `command` and `message_type` ensures bare `shop-msg send` errors out. Clean.

## What this validated

- **The lead-side surface mirrors the BC-side cleanly.** `shop-msg send` is the bidirectional complement of `shop-msg respond` — same collision-refuse contract, same schema-validation-on-construction discipline, same filename short-circuit pattern. The CLI is now a viable path for the lead to write inbox messages, just as the BC writes outbox responses. Harness builders for `request_maintenance` (`emit-s1`, `emit-s2`, `emit-s2c`, `emit-s3`) are now structurally replaceable by `shop-msg send request_maintenance` calls — that retirement is downstream work, but the foundation is there.
- **Inbox filename convention diverges from outbox by design, not accident.** Inbox is `<work_id>.yaml`; outbox is `<work_id>-<type>.yaml`. The asymmetry is correct: the lead sends one message per work_id (a work_id is the unit of work the lead initiated), while the BC may emit either clarify or work_done for the same work_id (different responses to the same lead message). The Implementer recognized the asymmetry, didn't try to enforce a uniform convention, and the Reviewer confirmed the choice. This is the right kind of role-template-enabled judgment: align with the underlying semantics, not surface symmetry.
- **The "echo cumulative passing set" discipline (added to the Reviewer template in the prior iteration) was respected on first use.** The Reviewer in S10 echoed all 9 hashes — both newly assigned (2) and pre-existing (7) — without being prompted by anything other than the updated role-template language. The lead now has cryptographic evidence of the BC's complete pinned-scenario state at the moment of sign-off, not just the new hashes.
- **The updated Reviewer template's CLI invocation worked end-to-end on first use.** The Reviewer ran `shop-msg respond work_done --status complete --scenario-hash ... --summary ...` (multiple repeats of `--scenario-hash`, one per pinned scenario), the CLI accepted it, the YAML serialized cleanly, the harness's `read` command parsed it as a valid WorkDone. The prior slice (S9) introduced the CLI; this slice exercised it from a real Reviewer subagent for the first time.

## Cumulative state after slice 10

- **shop-msg-bc:** 9 scenarios passing
  - happy-path respond clarify (b9ed9c63b8ccb208)
  - refuse-on-collision clarify (b6973413b7bfdd12)
  - refuse path-separator work_id on clarify (6ab8e9d72c4732a4)
  - refuse empty work_id on clarify (564632ae9310058c)
  - refuse empty question on clarify (9563c33a653afed7)
  - happy-path respond work_done (650e6761d5479ce3)
  - refuse-on-collision work_done (35fece8e1f96e074)
  - happy-path send request_maintenance (8c763f64d50253dc)
  - refuse-on-collision send request_maintenance (6f37b1ccd3826bad)
- **temperature bc-shop:** 6 tests passing (5 unit + 1 BDD scenario from S5b).
- **shop-msg CLI surface:** `respond clarify`, `respond work_done`, `send request_maintenance`. Bidirectional foothold established.
- **Catalog message types exercised end-to-end:** `request_maintenance`, `assign_scenarios`, `request_bugfix`, `clarify`, `work_done`.
- **Catalog message types still unexercised:** `request_shop_card`, `request_scenario_register`.
- **Open deferred items:**
  - `shop-msg send assign_scenarios` / `send request_bugfix` — needs scenario-payload handling + hash canonicalization moved into the catalog package.
  - `shop-msg inbox-next` / `read` — lead-side response-reading parallel to harness.py's `read`.
  - `harness.py` `emit-s1..s3` retirement — now structurally possible; separate slice.
  - Schema-level `work_id` constraints on `RequestMaintenance` and other lead-message types (deferred catalog-wide).
  - `--acceptance-criterion` / `--file-hint` repeatable flags on `send request_maintenance` — deferred to a request_bugfix slice if needed.
