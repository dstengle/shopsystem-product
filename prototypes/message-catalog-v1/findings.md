# Findings — message-catalog-v1 prototype

**Date:** 2026-05-07
**Validation target:** `request_maintenance` message type (and the `clarify` / `work_done` responses it can produce). Specifically: does the catalog mechanism work, and does the underspecified-message → `clarify` path hold?
**Setup:** scripted lead (Python harness) → real BC implementer (Task-tool subagent) → toy BC (temperature converter).
**Iterations:** initial run (S1, S2), tightened-prompt rerun (S2b) plus two new probes (S2c, S3), `assign_scenarios` happy-path with hash roundtrip and live BDD execution (S4), `assign_scenarios` for genuinely new capability with the Implementer + Reviewer split (S5a sufficiency-gap, S5b end-to-end), bootstrap of a second BC (`shop-msg-bc`) producing a `shop-msg` CLI tool (S6), then the first end-to-end §4.4 loop continuation: lead replies with `request_bugfix` carrying a tightened scenario, BC re-implements, Reviewer re-gates and signs off (S7).

## Summary

The catalog **mechanism** works: schemas validate, transport (filesystem YAML in `inbox/`/`outbox/`) is sufficient, both response types parse cleanly across all five runs.

The **clarify path** is not self-enforcing — but it is reliably enforceable with role-prompt discipline. Iteration 1 showed a permissive role prompt + capable agent collapses `clarify` into `work_done` whenever the agent can fill gaps from BC code or world knowledge. Iteration 2 showed that a tightened role prompt with explicit anti-rationalization language and a four-condition success test produces the model's intended behavior reliably across three different probes (underspecified, bad criteria, good criteria).

## Run matrix

| Run | Message shape | Role prompt | Expected | Actual |
|-----|---------------|-------------|----------|--------|
| S1  | Well-described (description + acceptance + file hints) | permissive | `work_done` | `work_done` ✓ |
| S2  | Underspecified (`"Add a kelvin conversion."` only) | permissive | `clarify` | **`work_done`** ✗ |
| S2b | Same as S2 | tightened | `clarify` | `clarify` ✓ |
| S2c | Vague criteria ("works correctly", "doesn't break things", "follows existing style") | tightened | `clarify` | `clarify` ✓ |
| S3  | New task, well-specified | tightened | `work_done` | `work_done` ✓ |
| S4  | `assign_scenarios` with one scenario + hash | tightened (extended for `assign_scenarios`) | `work_done` with hash echoed; BDD pass | `work_done` with hash echoed ✓; BDD pass ✓ |
| S5a | `assign_scenarios` for new behavior, no `When` step | tightened (Implementer + Reviewer split) | Implementer `clarify` (well-formed-Gherkin condition fails) | Implementer `clarify` ✓ |
| S5b | `assign_scenarios` for new behavior, well-formed | tightened (Implementer + Reviewer split) | Implementer does work; Reviewer gates and either signs off or escalates | Implementer wrote step defs + capability + ran BDD; Reviewer found equality-boundary gap and escalated `clarify` ✓ |
| S6  | `assign_scenarios` for `shop-msg respond clarify` to a fresh second BC | Implementer + Reviewer split | Implementer bootstraps from empty skeleton (CLI + step defs + feature); Reviewer probes | Bootstrap succeeded ✓; Reviewer found filename-collision gap and escalated `clarify` (recursive: the tool meant to enforce path consistency had its own unpinned collision behavior) |
| S7  | `request_bugfix` carrying tightened "refuse on collision" scenario | Implementer + Reviewer split | Implementer adds new scenario additively, modifies CLI, both old and new scenarios pass; Reviewer re-gates | Implementer refactored When step + added new collision-refusal logic; Reviewer signed off → `work_done(complete)` with both hashes echoed. **First end-to-end §4.4 loop closure.** ✓ |
| S8  | `request_bugfix` carrying three input-validation scenarios (path-separator + empty work_id + empty question) | Implementer + Reviewer split | Schema-level enforcement; all 5 BC scenarios + cross-BC unit tests pass | Schema constraints on `Clarify.work_id` (regex pattern) and `Clarify.question` (non-empty); `cli.py` unmodified — Pydantic ValidationError → non-zero exit naturally. Reviewer signed off → `work_done(complete)` with all 5 hashes ✓ |
| S9  | `assign_scenarios` for new capability — `shop-msg respond work_done` parallel to `respond clarify`, two scenarios (happy-path + collision-refuse) | Implementer + Reviewer split | New subcommand added without touching existing clarify path; all 7 BC scenarios + cross-BC unit tests pass | Implementer added `_cmd_respond_work_done` mirroring clarify shape, two new When step defs (with/without `--scenario-hash`, `$`-anchored to disambiguate), two new feature files; existing clarify When step untouched. Reviewer signed off → `work_done(complete)` with both hashes ✓ |
| S10 | `assign_scenarios` for new capability — `shop-msg send request_maintenance` (lead-side complement of `respond`), two scenarios (happy-path inbox write + collision-refuse) | Implementer + Reviewer split (using the updated role templates that emit outbox via `shop-msg respond ...`) | New top-level `send` subparser tree; inbox filename `<work_id>.yaml` (no message-type suffix); all 9 BC scenarios + cross-BC unit tests pass | Implementer added `_cmd_send_request_maintenance` mirroring respond's collision short-circuit, new `send`/`request_maintenance` subparser, inbox-side step defs distinct from outbox; existing 7 scenarios untouched. Reviewer used `shop-msg respond work_done` (template's first end-to-end use), signed off with all 9 currently-pinned hashes echoed ✓ |
| S11 | `assign_scenarios` for new capability — repeatable `--acceptance-criterion` + `--file-hint` flags on `send request_maintenance`, two scenarios (one-of-each round-trip + criterion repeatability) | Implementer + Reviewer split | All 11 BC scenarios + cross-BC unit tests pass; CLI now fully covers the RequestMaintenance schema | Implementer added repeatable flags (action="append"), switched dump to `model_dump(exclude_none=True)`, anchored prior When regex with `$` to disambiguate from new variants. Reviewer signed off with all 11 hashes. Same slice retired harness.py emit-s1/s2/s2c/s3 — substituted by the now-complete CLI ✓ |
| S12 | `assign_scenarios` for new capability — `shop-msg send assign_scenarios` (lead-side CLI for assigning Gherkin scenarios), three scenarios (one-scenario happy + hash roundtrip + multi-scenario via repeatable `--scenario-file` + collision-refuse) | Implementer + Reviewer split | All 14 BC scenarios + scenarios unit tests + bc-shop tests pass; CLI shells out to `scenarios hash` (no direct import — package boundary preserved end-to-end through a real consumer) | Implementer added `_cmd_send_assign_scenarios` mirroring the harness's wrap-as-Feature pattern byte-for-byte, used `subprocess.run(["scenarios", "hash"], input=body)` for canonicalization, added body-file Givens with `\n` → newline conversion, two `$`-anchored When variants, hash-equality and distinct-hashes Thens. Reviewer signed off with all 14 hashes ✓ |
| S13 | `assign_scenarios` for new capability — `shop-msg send request_bugfix` (lead-side CLI for the bugfix message), three scenarios (description-only happy + description+scenario+hash-roundtrip + collision-refuse) | Implementer + Reviewer split. **First slice deposited via `shop-msg send assign_scenarios` directly**, not via harness.py — the lead used the CLI to drive its own slice | All 17 BC scenarios + scenarios unit tests + bc-shop tests pass; shared `_build_scenario_payload` helper extracted on second use | Implementer added `_cmd_send_request_bugfix` (description required, scenarios optional), conditional-required `--feature-title`/`--bc-tag` validation post-parse with exit 2 + stderr, extracted shared scenario-payload helper. Reviewer signed off with all 17 hashes ✓ |
| S14 | `assign_scenarios` for new capability — `shop-msg read outbox` (lead-side CLI for reading BC responses), three scenarios (read work_done + read clarify + missing-file error). Then **§4.4 loop closure** within the slice: Reviewer escalated `clarify` flagging the missing schema-validation-failure scenario; lead followed with `request_bugfix` (work_id lead-015) carrying the proposed tightening; Implementer added scenario without touching cli.py (validation handling already existed); Reviewer signed off | Implementer + Reviewer split (twice). **harness.py retires entirely** in this slice — read migrates to shop-msg, harness has no remaining responsibilities | All 21 BC scenarios + scenarios unit tests + bc-shop tests pass | The prototype's second full §4.4 loop closure (first was S6→S7). Lead drove every step via dogfooded CLI: `shop-msg send assign_scenarios` for lead-014, `shop-msg send request_bugfix` for lead-015, `shop-msg read outbox` to validate the final sign-off. Reviewer signed off with all 21 hashes ✓ |
| S15 | `request_bugfix` for tightening — schema-level `@bc:` tag enforcement on ScenarioPayload (lead-016: 3 scenarios pinning the constraint). Then **§4.4 loop closure**: Reviewer found regex `.search()` accepts in-step-text false positives; lead followed with `request_bugfix` (work_id lead-017) for a line-anchored tokenization fix; Implementer rewrote the validator (split-on-whitespace, anchored token regex), added 5th catalog test; Reviewer counterfactually verified the fix and signed off | Implementer + Reviewer split (twice). **First catalog test suite** added in this slice (catalog/tests/test_scenario_payload.py — schema is the SUT for 2 of 3 first-leg scenarios) | All 22 BC + 5 catalog (NEW) + 6 scenarios + 6 bc-shop pass | The prototype's **third** full §4.4 loop closure. Both legs probed in opposing directions: leg-1 Reviewer asked when the gap was real; leg-2 Reviewer respected the defensible deferral on the gherkin-comment-line case. Anti-rationalization holds in both directions across separate dispatches ✓ |
| S16 | `request_bugfix` for tightening — ScenarioPayload hash↔body invariant at catalog layer (lead-018: 3 scenarios). **First slice where the Architect role was a dispatched subagent** rather than driver-orchestrator | lead-architect + Implementer + Reviewer split. Architect fetched role prompt via `shop-templates show lead-architect`, ran the discriminator question-by-question, picked `request_bugfix` (Q1+Q2 combined), composed via `shop-msg send` | All 25 shop-msg-bc + 8 catalog + 6 scenarios + 6 bc-shop + 36 shop-templates = 81 tests pass | Lead-architect template discipline works end-to-end on first dispatch ✓. Process finding: Architect's "pre-state already consistent" claim was wrong; Implementer caught and adapted by rewriting `_build_scenario_payload` to hash wrapped gherkin (sentinel-and-swap). Lead-side pre-state claims need empirical verification, not assertion — template iteration candidate |

## Finding 1 — schema mechanism is fine

All five YAML responses round-tripped through Pydantic without complaint. Filesystem transport is adequate; there is no urgent need to pick a transport from `ddd-product-system-2tf` until the catalog grows beyond a single shop pair. The starting `request_maintenance` schema (work_id, description, optional acceptance_criteria, optional file_hints) survived all probes.

**No change required to the schema.** Optional fields are doing real work — present and used in the happy paths, present-but-bad in S2c (caught by role discipline rather than schema), absent in S2b (caught by role discipline).

## Finding 2 — `clarify` is not automatic, but it is reliably enforceable

The role prompt is what determines whether `clarify` triggers, not the schema. With a permissive prompt, even a deliberately thin message produced silent inference (S2). With a tightened prompt encoding (a) seek-clarity-as-default, (b) a four-condition success test, and (c) explicit anti-rationalization language, the implementer produces `clarify` for both the absent-criteria case (S2b) and the vague-criteria case (S2c), and still produces `work_done` cleanly on a well-specified request (S3).

The behavioral difference between S2 and S2b is attributable to the prompt change alone — same message, same BC, same model. The implementer in S2b explicitly named the temptation to pattern-match BC code and resisted it.

This means: **the operating model for the shop system is "catalog + role discipline,"** not "catalog alone." The role prompt is part of the contract.

## Finding 3 — the implementer evaluates criterion *quality*, not just *presence*

S2c is the most interesting result of iteration 2. The lead supplied three acceptance criteria, but they were vague ("works correctly"), process-shaped ("doesn't break existing tests"), or aesthetic ("follows existing style"). A naïve "criteria present → proceed" check would have passed. The tightened success test caught the substance gap and the implementer emitted `clarify` with a pointed question targeting measurability and outcome-definition.

Implication: the principle the user articulated ("any work request should define what success looks like") is enforceable, but only with criteria that *bite* — meaning measurable outcome assertions, not platitudes. A schema cannot enforce this on its own (you cannot type-constrain "non-vague string"). The role prompt is the right place to encode it.

## Finding 4 — the BC code remains a side channel, but a manageable one

The implementer can read BC code; the question is whether it *acts on* what it reads when the message is underspecified. The tightened prompt's explicit "BC code is not the lead's intent" clause held across all three iteration-2 runs. This is not airtight (a sufficiently confident agent could still rationalize) but it produced the right behavior here.

A complementary safeguard, if needed: have the implementer's clarify question quote which inference it *would* have made if it weren't required to ask, so the lead can either confirm ("yes, that's what I meant") or correct. This compresses round trips without conceding the principle.

## Finding 5 — `assign_scenarios` works as designed; hash discipline survives a roundtrip

S4 exercised the canonical lead → BC handoff. The catalog mechanism extends cleanly to a richer payload: a single `AssignScenarios` schema with a list of `ScenarioPayload` carries Gherkin text, tags, and hashes. The implementer wrote the received scenario to `features/`, pytest-bdd auto-discovered it, and the BDD suite passed. The `work_done.scenario_hashes` field — empty for maintenance work in S1/S3 — earned its keep here, carrying the assigned hash back unchanged. Lead-side `verify-hashes` confirmed the hash sent matches the hash received.

The sufficiency check pattern from `request_maintenance` extends naturally to scenarios: well-formed Gherkin / concrete steps / hash tag present, instead of criteria-present / measurable / outcome / description-pins-thing. The shape of "is this enough to act on?" stays the same; only the substance shifts because Gherkin's Then steps subsume what acceptance criteria do for maintenance. The role-template equipping principle (§4.1) holds across both message types.

What this slice did *not* exercise (worth noting before claiming `assign_scenarios` is fully validated): implementer writing new step definitions, implementer implementing new BC capability when a scenario fails for capability gap, the Reviewer gate, multi-scenario partial pass, and the ambiguous-Gherkin → `clarify` probe.

## Finding 6 — the Implementer + Reviewer split is operationalizable, and the §4.4 loop is real

S5b ran the full BC-shop role split for the first time: Implementer received `assign_scenarios` for capability the BC did not yet support, wrote step definitions from scratch in `conftest.py`, implemented `Temperature.is_hotter_than`, and confirmed BDD pass — but did NOT write to the outbox. Reviewer was dispatched separately, re-ran BDD as an independent verification of the Implementer's claim, and adversarially probed the implementation against the assigned scenario.

The Reviewer found a real scenario gap — both `>` and `>=` implementations of `is_hotter_than` would pass the literal scenario while encoding different contracts (strict-hotter vs at-least-as-hot). That gap is exactly the kind §4.4 is meant to surface: a behavior the lead has not committed to, where a future operator flip could silently break consumers. The Reviewer escalated it as `clarify` with a concrete proposed scenario tightening (the equality case in Gherkin form).

This validates two specific structural claims of the spec:

- **The Implementer cannot emit `work_done` unilaterally.** The split is enforceable in a role-template architecture — separate prompts, separate dispatches, the gate is held by construction. Implementer's correct behavior was to leave the BC in its post-work state and report; not to overreach the outbox.
- **The Reviewer → `clarify` → PO decides → `request_bugfix` loop (§4.4) is real, not aspirational.** The Reviewer naturally produced exactly the message §4.4 describes: "scenario tightening proposed back to the lead shop via clarify." With a concrete Then step the lead can adopt as-is.

S5a was a useful side-finding: the role-template's well-formed-Gherkin sufficiency condition (G+W+T required) is stricter than Gherkin itself permits (Given/Then is valid for predicates). The Implementer applied the stricter rule, correctly. Whether to keep that strictness is a template-level choice — out of scope for the spec, which only states the role must be equipped (§4.1).

What this slice did NOT exercise: the implementation-gap path (Reviewer rejecting code rather than scenarios), multi-pass review loops where the Implementer iterates, multi-scenario partial pass, ambiguous-Gherkin probe (next slice).

## Finding 7 — the catalog scales to a second BC, and the system surfaces gaps in its own tooling

S6 added a second Bounded Context (`shop-msg-bc`) producing the `shop-msg` CLI — dev tooling intended to eliminate filesystem path inconsistencies and prompt bloat in the existing temperature BC's role templates. The Implementer was dispatched against a fully empty skeleton (no source, no step definitions, no features) and produced the CLI, the step definitions, and the feature file from one assigned Gherkin scenario. The Reviewer dispatched separately, re-ran BDD, and probed.

This validates three structural claims:

- **Multi-BC operation works under hub-and-spoke.** Two BCs coexist with separate inboxes/outboxes/feature trees. The harness change to support this was a single small refactor (parameterize the BC path, add `--bc` flag). The catalog's discipline did not have to change at all — the same `assign_scenarios` message goes to either BC.
- **Bootstrap from empty works for infrastructure code.** Same role split as S5b but more pronounced: there was no underlying capability to start from. The Implementer correctly inferred the CLI shape, the schema use, the subprocess invocation pattern for step definitions — all from one Given/When/Then.
- **The system surfaces gaps in the tools it produces.** This is the recursive part. The slice's stated purpose was to eliminate filename inconsistencies (the Reviewer's `lead-005.yaml` slip in S5b motivated the slice). The Reviewer in S6 found that the first command of the new tool has its OWN unpinned filename behavior — collision on the same `work_id` silently overwrites the prior outbox file, destroying clarify history at exactly the §4.4 loop boundary the tool is meant to manage. The escalation went out as `clarify` with three named alternatives (refuse / counter-suffix / timestamp). The lead must pick before the tool is safe to adopt.

This last point is the most interesting finding of the iteration. The shop system did not just produce the tool; it audited the tool against its own purpose, and surfaced exactly the case the tool was supposed to solve. The cost of doing this *before* adoption is one round-trip clarify; the cost of finding it after adoption would be debugging silently-corrupted outbox history across the existing temperature BC's prompts.

What this slice did NOT exercise: the lead's response to the `clarify` (the §4.4 loop continuation — `request_bugfix` with the chosen tightening), the other CLI commands (`send`, `inbox-next`, `hash`), and the actual replacement of hardcoded paths in the temperature BC's role templates (deferred until the CLI's collision contract is pinned).

## Finding 8 — the §4.4 loop closes end-to-end without bespoke mechanism

S7 ran the first complete §4.4 cycle in the prototype. The flow:

```
S5b: Reviewer finds gap (in temperature BC's `is_hotter_than`)
  → clarify with proposed Gherkin tightening to lead
S6: Reviewer finds gap (in shop-msg-bc's `respond clarify`)
  → clarify with three named alternatives to lead
S7: lead chose one alternative
  → request_bugfix with tightened scenario back to BC
  → Implementer adds scenario additively, modifies CLI, all scenarios pass
  → Reviewer re-runs BDD, probes, signs off
  → work_done(complete) with both hashes in scenario_hashes
```

Three structural things this validated:

- **No new mechanism was needed for the loop.** Every step was an existing message type (`clarify`, `request_bugfix`, `work_done`) flowing through the existing role-template architecture. The §4.4 loop is not a special process; it is what the catalog naturally does when used.
- **`request_bugfix` is the right shape.** Carrying `description` (plain language framing — "this is additive, the prior hash must continue to pass") plus optional `scenarios` (the tightening) covers the common case the spec describes. The `additive` framing came from the lead's description and the Implementer respected it.
- **Implementer agency on integration is real and necessary.** The Implementer in S7 did not just paste in a new scenario — it had to refactor the existing `When` step because the new collision scenario shared phrasing but required different exit-code expectations. The original step had `returncode == 0` asserted inline, which would have broken the new scenario. The Implementer recognized this and reorganized the assertions so each scenario's `Then` pins its own expected behavior. A purely additive flow would have produced a regression.

S7 also confirmed:
- **`scenario_hashes` carries the cumulative passing set.** Both `b9ed9c63b8ccb208` and `b6973413b7bfdd12` appeared in the work_done. The lead now has cryptographic evidence that both contracts are pinned by what's currently in the BC.
- **Reviewer respects deferred items.** The previous clarify (S6) flagged path traversal and schema emptiness as out-of-scope for the collision tightening. The S7 Reviewer noticed both, confirmed they were still unaddressed, and deliberately did not re-escalate, citing "folding them in now would muddy the §4.4 loop validation." That is the opposite of the pedantic-clarify failure mode and confirms the role-template's anti-rationalization works in both directions (don't ask when you shouldn't, don't proceed when you should ask).

## Finding 9 — schema-level enforcement is the right place for cross-cutting input safety

S8 closed the safety items deferred from S6/S7 by tightening `Clarify` with Pydantic Field constraints (`work_id` pattern + non-empty; `question` non-empty). The CLI required no code changes — it constructs `Clarify` and lets `ValidationError` propagate, which produces non-zero exit by default. All five shop-msg-bc scenarios pass, plus the temperature bc-shop's six tests (no cross-BC regression).

Two structural takeaways:

- **Constraints belong on the message contract, not on the producer.** Putting the regex on `Clarify.work_id` means every current and future caller — CLI, test harness, any Implementer subagent that builds messages directly — gets the validation for free. A defensive check in `cli.py` would have been redundant on day one and bypassable on day two (a future Implementer that builds the message a different way would silently bypass it).
- **Cross-BC schema evolution is safe when additive.** Adding constraints to `Clarify` did not regress the temperature BC's 6 tests, which never construct `Clarify` instances. Confirms the shared-schemas pattern (one `schemas.py` at the prototype root, importable from any BC's `tests/conftest.py`) holds under additive evolution. Removing or weakening constraints would be a breaking change; adding them is not.

The Implementer also did one quiet integration adaptation: switched the existing `respond clarify` When step from `parsers.parse` to `parsers.re`. `parsers.parse` does not match empty strings, so the new empty-input scenarios would never have triggered the When step without this change. The Implementer noticed this from a failing run, not from the dispatch, and fixed it without escalation. Same kind of integration agency as S7's When-step refactor — the role discipline keeps producing the right judgment calls without adding mechanism.

## Finding 10 — additive symmetric capability extension stays scope-narrow

S9 added `shop-msg respond work_done` to a CLI that already had `respond clarify`, by `assign_scenarios` rather than `request_bugfix` — same shape as S6's bootstrap, but onto an already-populated CLI surface rather than an empty one. The Implementer mirrored the clarify implementation pattern (collision short-circuit → build typed message → `yaml.safe_dump`) without touching the existing clarify path: the existing When step regex was untouched, the existing `_cmd_respond_clarify` was untouched, the 5 prior scenarios all continued to pass.

Three structural takeaways:

- **The lead committed up front to the collision-refuse contract.** S6 discovered the collision gap on the clarify command after Reviewer probe; S7 closed it via `request_bugfix`. S9 baked the same contract into work_done at the moment of introduction. That is the lead applying prior-slice learning to scope decisions: the §4.4 loop is not free — every round trip costs an Implementer + Reviewer pass — and a contract that has already been discovered as load-bearing should be assigned, not rediscovered. Confirms the prototype's "lead picks shape" framing is real authority, not ceremony.
- **The Reviewer respects deferred items across slices, in a chain.** S7's Reviewer deferred path-traversal/empty-input safety, citing "muddies the §4.4 loop validation"; S8's Reviewer reasoned about scope and deferred broader work_id rollout to other message types; S9's Reviewer deferred WorkDone schema-level constraints to a future request_bugfix slice using the same reasoning ("S8 vehicle, not S9"). Three slices in, the role-template's scope-defensible-deferral pattern is reproducible across distinct subagent instances. The anti-rationalization wording in `bc_reviewer_prompt.md` is doing the work — the Reviewer names what it didn't escalate, why, and what the right vehicle would be.
- **Step-definition disambiguation by anchor is a clean adapter pattern.** The two new When steps share a prefix (`I run shop-msg respond work_done with work-id "..." and status "..."`); they differ only in whether `and scenario-hash "..."` follows. The Implementer used `$` anchoring on the no-hash variant so pytest-bdd cannot mis-route between them. This is the same kind of quiet integration agency seen in S7's When-step refactor and S8's `parsers.parse → parsers.re` switch — the Implementer noticed the conflict surface, picked the smallest fix, didn't escalate. The role-template keeps producing this kind of judgment-call without adding mechanism.

What this slice did NOT exercise: schema-level constraints on WorkDone (deferred to a future request_bugfix); the other shop-msg subcommands (`send`, `inbox-next`, `hash`); the actual replacement of hardcoded paths in the temperature BC's role templates (now unblocked on both halves of the respond surface).

## Finding 11 — bidirectional CLI surface, by symmetry where it fits and asymmetry where it doesn't

S10 added `shop-msg send request_maintenance` — the lead-side complement of `shop-msg respond`. Same shape as S9 (assign_scenarios for new capability) but on the opposite half of the message channel. The Implementer mirrored the collision-refuse pattern at the inbox boundary without copying blindly: outbox uses `<work_id>-<type>.yaml` because the BC may emit either clarify or work_done for the same work_id, but inbox uses `<work_id>.yaml` because the lead sends one message per work_id. The Implementer recognized the asymmetry and the Reviewer confirmed it.

Three structural takeaways:

- **The lead-side CLI is now a viable alternative to harness.py's hardcoded builders.** S1/S2/S2c/S3 all used hardcoded `RequestMaintenance` constructors in `harness.py`'s `emit-sN` commands. After S10 those calls are structurally replaceable by `shop-msg send request_maintenance --work-id ... --description ...`. The harness retirement itself is a downstream slice; what S10 establishes is the substrate.
- **The "echo cumulative passing set" Reviewer discipline holds end-to-end on first exercise.** The role-template iteration that landed before S10 added "every scenario hash that currently passes" to the Reviewer's sign-off instruction. The S10 Reviewer echoed all 9 hashes (2 new + 7 pre-existing) without the dispatch reminding it to. The lead's reconciliation now sees the BC's complete pinned-scenario state per slice, not just per-slice deltas. This makes it cheap for the lead to detect silent regressions: if a sign-off omits a hash that appeared in the prior sign-off, something un-pinned itself.
- **The updated role templates work end-to-end.** S10 was the first slice to dispatch role-template subagents that use `shop-msg respond ...` for outbox writes (the prior templates instructed hand-rolled YAML). The Reviewer ran the CLI with multiple `--scenario-hash` repeats and the right `--summary`, the schema-validated YAML matched what the harness's `read` command parses. This closes a circularity in the prototype: the tool the BC produces is now used by the role templates that govern the BC's behavior. The role templates are dogfooding their own CLI, which means future template-level corrections to the CLI shape come back through the same `assign_scenarios`/`request_bugfix` channel that any other behavior-pinning request would.

What this slice did NOT exercise: `send assign_scenarios` / `send request_bugfix` (need hash canonicalization moved from `harness.py` into the catalog package); lead-side response-reading (`shop-msg inbox-next` / `read`); the actual retirement of harness.py's `emit-s1`..`emit-s3`.

## Finding 12 — picking the right catalog message type is itself a discipline that needs role support

S11 surfaced a structural gap the prototype had been quietly carrying since the catalog landed: **the lead has no sufficiency check for choosing a message type.** The BC side has explicit role-template discipline (sufficiency checks, anti-rationalization, Reviewer gate); the lead's choice of `assign_scenarios` vs `request_bugfix` vs `request_maintenance` happens in harness.py code with no checklist, no review.

Discovered by failure mode: when scoping S11, I (Claude as lead-driver) almost framed the new `--acceptance-criterion` / `--file-hint` flags as a `request_bugfix` because S8 had been "the vehicle for tightening." The user caught it before the message went out: that's not a tightening, it's a capability gap — the CLI did not previously accept the flags AT ALL. The right vehicle is `assign_scenarios` with Gherkin pinning the new behavior. Pattern-matching from "this is more CLI work" was the failure; a role-template-style discriminator ("is the BC's pre-state already doing this thing in some unpinned form, or does it not have the capability?") would have caught it.

Three takeaways:

- **The lead-side gap is real and prototype-level concrete.** Tracked as `ddd-product-system-sgh`. The fix is some combination of (a) a lead-side role template parallel to `bc_subagent_prompt.md` / `bc_reviewer_prompt.md`, (b) tighter schema-level discrimination between `assign_scenarios` and `request_bugfix` (currently both can carry `scenarios[]`), or (c) tooling that forces the discriminator at send-time. Not designed yet.
- **The discriminator that actually works is a question, not a definition.** "What is `request_bugfix` for?" produces hand-wavy answers. "Is the BC's pre-state already doing this thing in some unpinned form?" is sharp: if yes → `request_bugfix`/`request_maintenance`; if the BC has no capability at all → `assign_scenarios`. S6, S9, and S10 (new CLI subcommands) and S11 (new CLI flags) all answer "no, the capability didn't exist" → all correctly used `assign_scenarios`. S7 (collision-refuse on existing CLI) and S8 (input-validation on existing CLI) answered "yes, but unpinned" → correctly used `request_bugfix`.
- **Slice 11's slice-shape itself was the fix-in-flight.** The slice committed to `assign_scenarios` for the new flags, and the prototype demonstrated the discrimination it had just discovered. The deferred item is for the *general* pattern-guard; the immediate slice did its own job under the corrected framing.

## Finding 13 — package boundaries hold under a real consumer

The S11→S12 sequence carved scenario/hash logic out of harness.py into a separate `scenarios` package (slice A: `ddd-product-system-fzs`, packaging refactor) and then exercised the boundary from a brand-new consumer (S12: `shop-msg send assign_scenarios`). The package-boundaries rule — **production code shells out to the CLI; only tests may import** — held end-to-end. `cli.py` invokes `subprocess.run(["scenarios", "hash"], input=body)`; the conftest's hash-equality Then traverses the same boundary; neither file imports `compute_scenario_hash` directly. The Reviewer probed this explicitly and confirmed defensibility: a future regression where `cli.py` started importing the function would still produce identical output unless the package's internal API drifted from the CLI, at which point the boundary itself would be the bug.

Three takeaways:

- **The user's separation-of-concerns rule was load-bearing, not stylistic.** The original instinct (mine) was to fold hash logic into the `catalog` package on the grounds that scenarios are carried by catalog messages. The user pushed back — "messaging and hash logic should be separate concerns" — and the right factoring became obvious once stated: messages *carry* scenarios, but they don't *define* what a scenario is. After the split, the catalog has no idea hashing exists, and the scenarios package has no idea about messages. The CLI is the integration point. Saved as memory `shop-system-package-boundaries`.
- **Dogfooding extends down.** Same principle that drove `shop-msg` (every consumer talks to the BC via CLI, not by importing) now applies to `scenarios` (every consumer talks to the canonicalization rule via CLI, not by importing). The harness was retrofitted to subprocess-call `scenarios hash` in slice A; S12's new CLI subcommand follows the same pattern from day one. The composition pattern — one CLI orchestrator (the harness, or the lead) composing two domain CLIs (`shop-msg`, `scenarios`) — is becoming the prototype's canonical shape.
- **Hash-roundtrip is now CLI-testable.** Previously the harness constructed AssignScenarios messages inline with hash discipline as an implicit invariant of Python construction. S12's happy-path Then asserts that the hash in the emitted YAML equals what `scenarios hash` produces for the body. The only way for `cli.py` to regress on hash discipline now is to silently break the canonicalization — which the test would catch. Implicit invariants became explicit pinned ones.

## Finding 14 — the prototype now drives itself

Slice 13 was the first time a slice was deposited via `shop-msg send assign_scenarios` directly rather than via a harness.py `emit-sN` block. The lead wrote three scenario body files in `/tmp/slice13/` and composed the message with one CLI invocation; harness.py was not involved in the emit step at all. The dogfooding circle closed: the tool the prototype produces is now the tool the prototype uses to drive its own validation loop.

This was the destination the slicing has been heading toward since `shop-msg-bc` was bootstrapped in S6. Each subsequent slice carved away another reason for harness.py to exist:

- S10 added `shop-msg send request_maintenance` (replaces emit-s2's inline construction).
- S11 added repeatable `--acceptance-criterion`/`--file-hint` flags (replaces emit-s1/s2c/s3) and retired those four emit blocks.
- S12 added `shop-msg send assign_scenarios` (replaces emit-s4..s12's inline construction). Same slice retired the assign_scenarios builders.
- S13 added `shop-msg send request_bugfix` (replaces emit-s7/s8) AND was itself emitted via the new CLI rather than via a new emit-s13 block.

Three structural takeaways:

- **The harness's purpose has effectively narrowed to read-side.** After S13, harness.py's only remaining responsibilities are `emit-s7`/`emit-s8` (deferred for a separate retirement slice) and the generic `read`/`verify-hashes` ops. The latter two are themselves candidates for migration into a `shop-msg inbox-next` / `read` family, at which point harness.py retires entirely.
- **The shared-helper refactor surfaced on the second consumer, not the first.** S12's `_cmd_send_assign_scenarios` had inline scenario-payload construction. S13's Implementer extracted `_build_scenario_payload` as the second consumer crystallized the abstraction. This is the canonical "extract on second use" rhythm; the Reviewer probed coupling, confirmed it's benign because hashes are computed on body bytes pre-wrap (the wrap is downstream and cosmetic). The helper now sits where any future `send` subcommand carrying scenarios can reuse it.
- **Conditional-required argparse validation is now a recurring prototype pattern.** Second slice to encounter it (S11 was the first, with optional repeatable flags). The pattern — `default=None`, post-parse validation, `exit 2` + stderr — matches argparse's own usage-error convention. The Reviewer probed failure-ordering precedence (collision-refuse beats arg validation) and confirmed correctness. Two slices is not yet a pattern but is enough to write down for the third.

## Finding 15 — the prototype's second §4.4 loop closure, with code-untouched outcome

S14 ran the prototype's second complete §4.4 cycle, this time entirely under the dogfooded lead-side CLI:

```
S14 leg 1: lead emits assign_scenarios (read outbox capability) via shop-msg send assign_scenarios
  → Implementer adds the read outbox subcommand, leaves outbox alone
  → Reviewer finds schema-validation-failure scenario gap
  → clarify with proposed tightening to lead, via shop-msg respond clarify

S14 leg 2: lead emits request_bugfix (work_id lead-015) via shop-msg send request_bugfix
  → carrying the Reviewer's proposed tightening verbatim
  → Implementer adds the new scenario, cli.py UNTOUCHED
  → Reviewer re-runs BDD, probes counterfactually, signs off
  → work_done with all 21 currently-pinned hashes echoed
```

The first full §4.4 loop was S6→S7 (collision-refuse on respond clarify). This is the second. Two full closures is enough to call it a reproducible mechanism, not aspiration.

Three structural takeaways:

- **"Tighten without code change" is a real outcome category.** The Implementer's report on lead-015 was telling: "cli.py UNTOUCHED. The validation handling already exists; this slice only pins the contract under BDD." The Reviewer's counterfactual probe verified that removing the existing try/except *would* fail the new scenario (the resulting pydantic traceback lacks the substring "validation failed" the Then asserts). This is the role-template anti-rationalization working in a quieter direction than usual: a Reviewer who sees "implementation already does this" doesn't dismiss the gap, because future implementations might NOT — and a Test-with-no-Code-change is exactly the right output when the gap is "behavior implemented but not pinned."
- **The lead drove every step of the §4.4 loop via the dogfooded CLI.** No harness.py involvement at any point — the lead used `shop-msg send assign_scenarios` for the initial dispatch, `shop-msg send request_bugfix` for the §4.4 follow-up (second consumer of the S13 CLI, first §4.4 use), and `shop-msg read outbox` to validate the final sign-off (the new CLI from this slice, used to validate its own sign-off). The dogfooding circle that closed in S13 has been reproduced under more demanding conditions: multi-step round trip with two distinct message types and one validation read.
- **harness.py retires.** With read outbox migrated, the harness has no remaining responsibilities. Deleted in this slice. The prototype's lead-side toolchain is now `shop-msg {send,respond,read}` + `scenarios {hash,verify}`. The harness existed for 14 slices and steadily lost responsibility as each capability migrated to a real package CLI (`scenarios` in slice A, then `shop-msg send` in S10/S11/S12/S13, then `shop-msg read` in S14). The arc was always toward zero — only finally hit it here.

## Finding 16 — schema is the right home for what would otherwise be template drift

After S14 closed the lead-side toolchain, several patterns had accumulated as slice-level conventions: `@bc:<name>` tag presence, `@scenario_hash:` consistency with the gherkin body, regex-anchoring on step-defs, conditional-required argparse. My initial framing of these as "promote to role-template guidance" missed an important distinction: **most aren't role concerns at all.**

The user's observation: most belong in tools or schemas, not templates. After unpacking:

- `@bc:` tag presence and `@scenario_hash:` consistency → **catalog schema** (Pydantic constraints on ScenarioPayload). Cross-cutting, every constructor gets validation for free, can't be bypassed without intent.
- Regex-anchoring on step-defs → pytest-bdd hygiene, lives in a comment in the BC's `conftest.py`.
- Conditional-required argparse → Python CLI hygiene, lives in `cli.py` itself or a shared helper.

S15 demonstrated the realignment for the first item: a request_bugfix tightening ScenarioPayload with `@model_validator` enforcing `@bc:<name>` as a whitespace-bounded token on some line. The §4.4 loop ran twice within the slice (Reviewer escalated on regex-search-vs-line-anchor false positives, lead followed with the line-tokenization fix), producing the prototype's **third** full §4.4 closure.

Three structural takeaways:

- **The discriminator "would adding this to the template be load-bearing?" should run BEFORE the discriminator "is this a recurring pattern?"** S15 is the slice that articulated this. Before S15, my instinct on observed friction was "the templates should mention it." After S15, the better instinct is "where does this kind of invariant live in the package boundary, and would a schema/tool catch it for free?" The role templates stay focused on role discipline (sufficiency, anti-rationalization, gate); schemas catch what schemas can catch.
- **The catalog package gets its first test suite in this slice.** Until S15, the catalog had no tests — its schemas were exercised indirectly through shop-msg-bc's BDD. The schema-level constraint added here changes that calculus: the SUT for 2 of the 3 first-leg scenarios is the schema itself, not the CLI. Tests where they belong (Implementer's call on placement; Implementer chose `catalog/tests/`).
- **Anti-rationalization holds in BOTH directions across separate Reviewer dispatches.** Lead-016's Reviewer found a real regex-search gap and escalated. Lead-017's Reviewer (separate dispatch instance) probed the tightened version, found another loosening (gherkin-comment lines), and chose to defer with explicit reasoning ("no historical scenario uses gherkin comments AND a prior test deliberately pins the 'any line' looseness"). This is the canonical role-template anti-rationalization: ask when the gap is real, don't ask when the deferral is defensible.

## Finding 17 — the lead-architect template works on first dispatch, and surfaces a new failure mode

S16 was the first slice where the Architect role was a dispatched subagent under the `lead-architect` template (from the `shop-templates` package), rather than driver-orchestrator (me). The template's discriminator did its job — the Architect ran Q1+Q2 question-by-question and selected `request_bugfix` correctly for the ScenarioPayload hash↔body invariant work, reporting which question selected the vehicle per the template's Reporting back section. This is the role-template version of the memory-mitigated discriminator that's held since S11.

But the slice also surfaced a new failure mode that the lead-side templates need to address: **pre-state verification is not the same as pre-state assertion.** The Architect's dispatch description to the BC Implementer claimed today's `shop-msg send` payloads were "internally consistent." They weren't — the CLI stored `hash=canonical(body)` but `gherkin=wrapped(body)`, and `canonical(wrapped) ≠ canonical(body)`. The Architect was running the discriminator template-correctly (Q1 + Q2) but hadn't EMPIRICALLY VERIFIED its answer to Q1's "loose sense of capability" claim. The Implementer caught the mismatch and adapted by rewriting `_build_scenario_payload` to hash the wrapped gherkin (sentinel-and-swap pattern). The Reviewer flagged this as a process finding.

Three structural takeaways:

- **Discriminator discipline doesn't substitute for empirical verification of the BC's pre-state.** The `lead-architect` template's "Sufficiency check — message-type selection" tells the Architect to "check the BC's current state (scenario register, code, prior work_done's)" but doesn't require demonstrating that the failure mode the bugfix would close is actually a current failure mode. A template iteration candidate: require the Architect to EMPIRICALLY CONFIRM the pre-state, e.g., by composing a counterexample that would fail under the new constraint and verifying it currently passes.
- **Implementer agency on integration adaptation continues to produce the right judgment calls without escalation.** The dispatch description's wrong claim about pre-existing consistency would have made the ADDITIVE constraint un-satisfiable as written. The Implementer modified the CLI to make it satisfiable rather than weakening the validator. Same pattern of judgment-without-escalation seen in S7 (When-step refactor), S8 (parsers.parse→parsers.re), S11 (`$`-anchoring), and S15 (line-by-line tokenization). Five slices now is enough to call this a reproducible behavior of the bc-implementer template, not a coincidence.
- **First-dispatch lead-side template validation is the natural mirror of S2→S2b's BC-side validation.** The BC templates were validated by S2's permissive prompt producing wrong behavior, then S2b's tightened prompt producing right behavior. The lead-side templates' first dispatch (S16) succeeded on the discriminator but found a new gap in the pre-state-verification step. The right response is a template iteration informed by this finding — same as the BC templates after S2.

## Cumulative state after slice 16

- **shop-msg-bc:** 25 scenarios passing (+3 in S16: hash-matches-body accepted, mismatched rejected, CLI round-trip).
- **catalog:** 8 tests passing (+3 in S16: 2 new schema unit tests + 1 cross-package agreement pin against scenarios' known hashes).
- **scenarios:** 6 tests passing.
- **bc-shop:** 6 tests passing.
- **shop-templates:** 36 tests passing (bc-implementer, bc-reviewer, lead-architect, lead-po — 4 templates, 9 parametrized section pins each on average).
- **TOTAL: 81 tests across 5 packages.**
- **shop-msg CLI surface:** unchanged externally; internal change to `_build_scenario_payload` (S16: hash now matches wrapped gherkin, not body — sentinel-and-swap pattern preserves canonical-hash invariance under tag substitution).
- **scenarios CLI surface:** `hash`, `verify`.
- **shop-templates CLI surface:** `list`, `show <name>`.
- **Role templates:** BC templates unchanged through S10–S16 — seven slices reproducing cleanly. Lead-architect template first-dispatched in S16; lead-po template not yet dispatched. Process finding (Finding 17): lead-architect's discriminator Q1 needs an empirical pre-state verification step.
- **Lead role:** Architect was a dispatched subagent in S16 (first slice); driver-orchestrator in S1–S15. PO is still driver-orchestrator across all slices.
- **Catalog message types exercised end-to-end:** `request_maintenance`, `assign_scenarios`, `request_bugfix`, `clarify`, `work_done`.
- **Catalog message types still unexercised:** `request_shop_card`, `request_scenario_register` (closed-as-deferred during P3 triage).
- **Open deferred items:**
  - First dispatch of lead-po template.
  - Iteration to lead-architect template based on S16's process finding: empirical pre-state verification.
  - Cross-shop `@bc:` tag ↔ dispatch-target consistency.
  - `shop-msg read inbox` (BC-side counterpart).
  - `shop-templates render <name>` (parameterized templates).
  - Two P4: transport choice (`ddd-product-system-2tf`), audit-beyond-scenario-register (`ddd-product-system-udi`).

## P3 triage on 2026-05-10

Six P3 issues that had been open since the catalog landed (2026-05-06) or were filed mid-prototype (sgh, 2026-05-08) were closed after slice 14 with reasoning recorded in each issue's bd close note:

- **`ddd-product-system-1p4`** (request_bugfix / request_maintenance payload structure) — closed: schemas validated end-to-end across S1-S3, S7-S8, S10-S14; current shapes survived two full §4.4 closures; no additional structure needed.
- **`ddd-product-system-5p8`** (Domain & Context Map) and **`ddd-product-system-yun`** (scenario-to-BC assignment) — closed/reframed: not message-catalog constructs, they're lead-shop tracking artifacts. The prototype's lead shop is driver-orchestrator (me), not an installable shop with persistent tracking. Deferred to a future prototype with lead-shop scaffolding parallel to bc-shop's structure.
- **`ddd-product-system-6mk`** (request_shop_card schema) and **`ddd-product-system-r7u`** (request_scenario_register schema) — closed: unexercised message types but pattern proven (Finding 1 — catalog mechanism is uniform across types). Specific schemas deferred to a future prototype that needs those specific flows (e.g., a multi-BC topology where the lead queries BC capabilities at startup, or aggregates registers across BCs).
- **`ddd-product-system-sgh`** (lead-side message-type-selection sufficiency check) — closed with mitigation: bd memory `shop-system-message-type-selection` captures the discriminator and has held across S11, S12, S13, S14. Formal pattern guard (lead-side role template) deferred: the prototype's lead is not a dispatched subagent, so a template has no current consumer.

What this leaves open as P3+: nothing in the catalog/messaging layer. The remaining open items at all priorities are P4 (transport choice, audit-beyond-scenario-register) and the message-type coverage gap (request_shop_card / request_scenario_register), which now lives implicitly in this finding rather than in five separate tracking issues.

## Was the simplified message-catalog decision a good one?

**Yes**, with one substantive caveat now articulated:

- The 7-message catalog and YAML/Pydantic wire are not the constraint.
- The **operating model is catalog + role prompt**, not catalog alone. The shop-system spec should treat the BC implementer's role discipline as a first-class artifact alongside the message schemas.
- The principle "any work request should define what success looks like" is enforceable in the role prompt, not the schema. The four-condition success test in `bc_subagent_prompt.md` is a working draft of that enforcement.

The simplification of the catalog itself stands. The simplification was honest about *what messages exist*; iteration 2 made it equally honest about *what it takes to make `clarify` actually fire*.

## Recommendations

- **Spec stays principle-level; the test lives in the role template.** §4 (BC-shop) should say *that* the Implementer's role must be equipped with explicit criteria for evaluating request sufficiency, but should not enumerate the criteria themselves. The four-condition success test is a template artifact (system prompt or analysis skill like `analyze-work-request`), not a spec artifact. Templates are where experimentation and refinement happen; pulling the specifics into the spec would freeze them and bulk the spec with details that should evolve. (`bc_subagent_prompt.md` in this prototype is exactly such a template artifact — it lives under `prototypes/`, not under `docs/shop-system/`.)
- **Update beads issue `ddd-product-system-1p4`** (request_maintenance payload structure) with the working schema as a starting point.
- **No schema change to `request_maintenance` for now.** Leaving `acceptance_criteria` optional is correct: required-by-schema would force ceremony in cases where the lead genuinely wants the implementer to choose (e.g., a documentation tweak), and it would not catch the more subtle S2c failure (vague criteria) anyway.
- **Consider a follow-up probe** with a domain-specific request the agent cannot fill from world knowledge (e.g., business-rule maintenance), to confirm the success test holds when the temptation to infer is weaker.

## Artifacts

- `runs/scenario-1/` — well-described, permissive prompt → `work_done` (success)
- `runs/scenario-2/` — underspecified, permissive prompt → `work_done` (failure mode found)
- `runs/scenario-2b/` — same as S2 with tightened prompt → `clarify` (failure mode resolved)
- `runs/scenario-2c/` — bad acceptance criteria, tightened prompt → `clarify` (substance test holds)
- `runs/scenario-3/` — good acceptance criteria, tightened prompt → `work_done` (no over-correction)
- `runs/scenario-4/` — `assign_scenarios` with one scenario, tightened prompt extended for the new message type → `work_done` with hash echoed; BDD passes
- `runs/scenario-5a/` — `assign_scenarios` with no `When` step → Implementer `clarify` on sufficiency
- `runs/scenario-5b/` — `assign_scenarios` for new capability, full Implementer + Reviewer pass → Reviewer escalated `clarify` on equality-boundary scenario gap
- `runs/scenario-6/` — `shop-msg-bc` bootstrap + first CLI command, Implementer + Reviewer pass → Reviewer escalated `clarify` on collision-on-same-work-id gap (recursive: the tool meant to fix filename inconsistency had its own)
- `runs/scenario-7/` — `request_bugfix` with tightened scenario → Implementer adds scenario additively + refactors When step + modifies CLI; Reviewer signs off → `work_done(complete)` with both hashes. First end-to-end §4.4 loop closure.
- `runs/scenario-8/` — `request_bugfix` with three input-validation scenarios → schema-level enforcement (Clarify constraints), CLI unmodified, all 5 BC scenarios pass, no cross-BC regression. Reviewer signs off with all 5 hashes.
- `runs/scenario-9/` — `assign_scenarios` adding `shop-msg respond work_done` parallel to `respond clarify` (happy-path + collision-refuse) → Implementer adds new subparser + step defs without touching existing clarify path; Reviewer signs off with both hashes. Confirms scope-narrow additive capability extension and cross-slice deferral discipline.
- `runs/scenario-10/` — `assign_scenarios` adding `shop-msg send request_maintenance` (lead-side complement of `respond`) → Implementer adds new top-level `send` subparser tree with inbox-side step defs; inbox filename `<work_id>.yaml` chosen by lead/BC semantics, not surface symmetry. First Reviewer dispatch under the updated role templates that use `shop-msg respond ...` for outbox writes — clean end-to-end; Reviewer echoes all 9 currently-pinned hashes per the new "cumulative passing set" instruction.
- `runs/scenario-11/` — `assign_scenarios` adding repeatable `--acceptance-criterion` and `--file-hint` flags on `send request_maintenance` (full RequestMaintenance schema coverage). Same slice retired harness.py's emit-s1/s2/s2c/s3 hardcoded builders — substituted by the now-complete CLI. Surfaced the lead-side message-type-selection gap (`ddd-product-system-sgh`) when I almost mis-classified new flags as a `request_bugfix`.
- `runs/scenario-12/` — `assign_scenarios` adding `shop-msg send assign_scenarios` (lead-side CLI for assigning Gherkin scenarios). First production consumer of the `scenarios` package's CLI boundary; `cli.py` shells out to `scenarios hash` rather than importing `compute_scenario_hash`. Hash-roundtrip is now an explicit pinned invariant rather than an implicit one. Three scenarios: one-scenario happy + hash-roundtrip, multi-scenario via repeatable `--scenario-file`, collision-refuse.
- `runs/scenario-13/` — `assign_scenarios` adding `shop-msg send request_bugfix` (lead-side CLI for the bugfix message). First slice deposited via `shop-msg send assign_scenarios` directly rather than via a harness.py emit block — the dogfooding circle closed. Three scenarios: description-only happy, description+scenario+hash-roundtrip, collision-refuse. Implementer extracted `_build_scenario_payload` shared helper on second use; conditional-required `--feature-title`/`--bc-tag` validation post-parse. Reviewer signed off with all 17 currently-pinned hashes.
- `runs/scenario-14/` — `assign_scenarios` adding `shop-msg read outbox` (lead-side CLI for reading BC responses), then a full §4.4 loop within the slice: Reviewer escalated `clarify` flagging the missing schema-validation-failure scenario; lead followed with `request_bugfix` (work_id lead-015) carrying the proposed tightening; Implementer added the scenario without touching cli.py (validation handling already existed); Reviewer signed off with all 21 currently-pinned hashes. The prototype's second full §4.4 closure (first was S6→S7), now entirely under the dogfooded lead-side CLI. **harness.py deleted** in this slice — its last responsibility (`read`) migrated.
- `runs/scenario-15/` — `request_bugfix` adding schema-level `@bc:` tag enforcement on ScenarioPayload, then a full §4.4 loop within the slice: Reviewer escalated `clarify` flagging the regex-search-vs-line-anchor false-positive case; lead followed with `request_bugfix` (work_id lead-017) for a line-tokenization fix; Implementer rewrote the validator and added the 5th catalog test; Reviewer counterfactually verified the fix and signed off with all 22 currently-pinned shop-msg-bc hashes. The prototype's **third** full §4.4 closure. First catalog test suite added in this slice (catalog/tests/) — the schema is the SUT for 2 of 3 first-leg scenarios.
- `runs/scenario-16/` — `request_bugfix` adding ScenarioPayload hash↔body invariant at the catalog layer. **First slice with Architect-as-dispatched-subagent** (rather than driver-orchestrator). Lead-architect fetched role prompt via `shop-templates show lead-architect`, ran the discriminator question-by-question, picked `request_bugfix` correctly. Implementer chose option (b) for the package-boundary tension (duplicate canonicalization rule in catalog with cross-package agreement pin). Found that the Architect's dispatch claim about pre-state consistency was wrong, adapted the CLI to make the ADDITIVE constraint satisfiable. Reviewer probed and signed off with all 25 hashes. Process finding: lead-architect template needs an empirical pre-state verification step in the discriminator's Q1.
- `schemas.py` — the catalog schemas under test (extended in iteration 3 with `AssignScenarios` and `ScenarioPayload`; in iteration 6 with `RequestBugfix`; in iteration 7 with `Clarify` Field constraints)
- `bc_subagent_prompt.md` — Implementer role template (sufficiency checks for both `request_maintenance` and `assign_scenarios`; for `assign_scenarios`, instructed to do work but NOT write outbox)
- `bc_reviewer_prompt.md` — Reviewer role template (adversarial probe; sole writer of `assign_scenarios` outbox responses)
- `shop-msg-bc/` — the second BC; produces the `shop-msg` CLI tool. Currently has `respond clarify` only; collision contract pending lead's reply to S6's clarify.
