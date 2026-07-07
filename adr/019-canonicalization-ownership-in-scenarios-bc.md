---
id: ADR-019
kind: adr
title: Scenario canonicalization and hash discipline are owned by `shopsystem-scenarios`; messaging transports, it does not re-enact
status: accepted
date: "2026-06-02"
description: Scenario canonicalization and hash discipline are owned by `shopsystem-scenarios`; messaging transports, it does not re-enact
beads: [lead-2ca, lead-architect, lead-ji28, lead-wgv]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-006, ADR-018]
  pins: []
  related: []
---
# ADR-019 — Scenario canonicalization and hash discipline are owned by `shopsystem-scenarios`; messaging transports, it does not re-enact

**Status:** accepted (2026-06-02)
**Authors:** dstengle, Claude (lead-architect)
**Pins:** [scenario 117](../features/templates/117-canonical-scenario-hash-canonicalization-is-scenario-block-only-not-feature-line-included.gherkin)
— *the canonical hash text for a scenario block is scenario-block-only;
the `Feature:` header line is NOT part of it; there is exactly one
canonical hash text per scenario block, not one per surface.*
**Anchored to:** [ADR-018](018-empirical-verification-is-contract-surface.md)
(the artifact-surface evidence rule this ADR's pre-state honors);
[ADR-006](006-messaging-name-registry-design.md) §5 (messaging owns the
`ScenarioPayload` value object as transported content).
**Related beads:** `lead-ji28` (the in-the-wild lead-2ca occurrence this
pins the resolution for), `lead-wgv` (the umbrella canonicalization-ambiguity
bead scenario 117 closes at the contract level).

---

## Context

Two bounded contexts touch scenario hashes:

- **`shopsystem-scenarios`** declares itself (dist Summary, verified via
  `pip show scenarios`): *"Scenario domain logic — canonicalization and
  hashing of Gherkin scenarios. Separate from the messaging catalog:
  messages happen to carry scenarios, but hash discipline is a scenario
  concern."* It is a clean leaf domain — `Requires:` is empty.
- **`shopsystem-messaging`** declares itself (dist Summary, verified via
  `pip show shopsystem-messaging`): *"Messaging bounded context … Pydantic
  schemas for the eight inter-shop message types and the `shop-msg` CLI."*
  It `Requires: scenarios` (among others) — it depends on the scenarios
  leaf.

Scenario 117 (PO-authored, lead-held under `features/templates/`) pins the
upstream-of-everything contract: a scenario hash is computed under
**scenario-block-only canonicalization**; the `Feature:` header line is NOT
part of the canonical hash text; and there is *exactly one* canonical hash
text per scenario block, identical on the disk-authoring side
(`@scenario_hash:<hex>` tag) and the wire-payload side
(`scenarios[].hash`). Scenario 117 line 46-54 explicitly defers to the
Architect *which BC owns the canonicalization implementation*, naming
messaging's `_build_scenario_payload` / `_compute_scenario_hash` as the
on-wire side of the observed disagreement. This ADR resolves that deferral.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

The canonicalization rule itself is **correct in `scenarios`**. Read from
the installed `scenarios` distribution (`scenarios/hash.py`,
`compute_scenario_hash`): it splits on lines, strips per line, drops blank
lines, drops any line whose stripped form starts with `@scenario_hash:`,
and sha256-truncates the joined result. It does **not** add a `Feature:`
line. This matches scenario 117 byte-for-byte. The module docstring states
the boundary outright: *"The canonicalization rule is part of the scenario
contract, not the messaging contract — so it lives here rather than in the
catalog package. Messages carry scenarios; messages do not define what a
scenario is."*

The **117 violation lives in messaging's CLI**, two coupled defects,
verified by reading the installed `shop_msg` distribution and demonstrated
via the `scenarios hash` contract tool (the admissible "run" per ADR-018 D2):

- **(a) Construction/canonicalization logic leaked into the transport CLI.**
  `shop_msg/cli.py:880-903` (the `--scenario-file` payload builder) prepends
  `f"Feature: {feature_title}\n"` to the body and then hashes that
  Feature-inclusive string (`_compute_scenario_hash(sentinel_tagged)` at
  line 895). Because `scenarios`' canonicalization drops only blank lines and
  `@scenario_hash:` lines, the `Feature:` line **survives** canonicalization,
  so the dispatched `scenarios[].hash` diverges from the on-disk
  `@scenario_hash:` tag computed over the bare scenario block. This is
  scenario-payload **construction** logic — a scenario concern per the
  scenarios charter — that has leaked into the transport CLI. (Contrast: the
  `--payload` path correctly transports a pre-built canonical payload; that
  is the correct shape.)

  Demonstrated at the artifact level from the lead CWD: feeding one scenario
  body to `scenarios hash` yields `16afa7a01a0cd120` (scenario-block-only,
  what an on-disk tag carries); feeding the same body wrapped in
  `Feature: … / @scenario_hash:0000… @bc:x / <body>` (the `cli.py:895`
  shape) yields `a9fd70077400931a`. The two diverge — the 117 violation,
  reproduced over contract text with no BC-code execution. This is the same
  shape lead-2ca observed in the wild (07d405ae455c5553 wire-form vs
  641bae76c069bf5b scenario-block-only — `lead-ji28`), now the 9th tallied
  occurrence.

- **(b) Two inconsistent paths to one rule.** `shop_msg/cli.py:364-378`
  `_compute_scenario_hash` shells out via
  `subprocess.run(["scenarios", "hash"])` — a PATH-fragile invocation that
  re-enters the scenarios package through a separate process boundary, when
  `scenarios` is already a direct in-process dependency (`Requires: scenarios`).
  An in-process `from scenarios.hash import compute_scenario_hash` is the one
  source of truth, with no PATH dependency. (See "asserted vs confirmed"
  below: a sibling in-process call elsewhere in messaging was *cited* but
  could not be confirmed in the installed dist; the in-process *import path
  itself* — `scenarios.hash.compute_scenario_hash` — is confirmed to exist
  and to be the correct delegate.)

## Decision

### D1 — Canonicalization and scenario-hash discipline are owned by `shopsystem-scenarios`, single source of truth

The rule for *what a scenario hash is* — the canonicalization (scenario-block-only,
drop blanks, drop `@scenario_hash:` lines) and the hash algorithm
(sha256, 16-hex truncation) — is owned by `shopsystem-scenarios` and lives
in `scenarios.hash.compute_scenario_hash`. This matches the scenarios charter
and scenario 117. No other BC may define, re-implement, or vary this rule.
There is exactly one canonical hash text per scenario block (117), so there
is exactly one implementation of the rule, and it lives in the leaf domain
every other BC already depends on.

### D2 — Messaging *transports* a `ScenarioPayload`; it *delegates* canonicalization and validation to `scenarios`, and must not re-enact either

`shopsystem-messaging` owns the `ScenarioPayload` value object as
*transported content* (ADR-006 §5) and the `shop-msg` CLI that puts it on
the wire. Its correct posture toward hashing is **delegation**:

- Where it must compute a hash, it calls `scenarios`' canonicalization —
  in-process via `from scenarios.hash import compute_scenario_hash`, not by
  shelling out to a PATH-resolved binary (resolves defect (b)).
- It computes that hash over the **scenario-block-only** canonical form,
  never a `Feature:`-line-wrapped string (resolves defect (a)). The
  dispatched `scenarios[].hash` then equals the on-disk `@scenario_hash:`
  tag for the same block, as 117 requires.

Messaging must not re-enact canonicalization (prepend a `Feature:` line,
strip-and-join, or otherwise re-derive the canonical hash text). The
`--payload` transport path — which carries a pre-built canonical payload —
is the reference for the correct shape: messaging moves the value object;
it does not manufacture its canonical identity.

### D3 — Relocating payload *construction* into `scenarios` is a noted consequence, not decided here

Defect (a) exists because payload *construction* (building the tagged,
Feature-wrapped `ScenarioPayload` from a bare body) lives in the messaging
CLI at all. The minimal fix (carried by the dispatch this ADR motivates) is
to make that construction compute the hash over the scenario-block-only form
via the `scenarios` delegate. A **fuller** structural move — relocating
payload construction itself into `scenarios` (a builder function or a
`scenarios payload` subcommand that emits a canonical `ScenarioPayload`), so
messaging only ever transports a value it received pre-built — would change
the `scenarios` BC's contract surface and is therefore **scoped as a noted
consequence**, requiring a follow-up `assign_scenarios` to `shopsystem-scenarios`
if pursued. It is **not** dispatched by this ADR. The bugfix this ADR
motivates resolves (a) and (b) within messaging's current surface; the
construction relocation is downstream work named here, not an action.

## Open question — shop/BC registry and addressing ownership (DEFERRED, not decided)

This session surfaced repeated drift in registry and addressing state.
This ADR records the **symptoms only** and explicitly **defers** the
ownership/structure decision. No split is recommended; nothing is decided.

Symptoms observed this session (artifact-surface facts, not a diagnosis):

- The messaging name registry came up **without** an entry for the BC being
  dispatched to; `shop-msg registry add` had to be re-run this session to
  reach a routable state. (`registry list` showed `shopsystem-product` and
  `shopsystem-templates` but not the target messaging BC.)
- `SHOPMSG_DSN` was **unset** in the lead-host shell and had to be exported
  before any `shop-msg` call resolved (recurring drift, also tracked
  `lead-3lw6`).
- A **slug-vs-display-form mismatch** persists between the canonical name
  the registry/addressing expect (`shopsystem-product`, slug form) and
  `.claude/shop/name.md`'s display form (`shopsystem product`), which breaks
  `shop-msg prime` (also tracked `lead-ykq2` / `lead-3lw6`).

What is **deferred** (not decided here): which BC owns the registry and
addressing contract, whether registry state belongs with messaging or a
separate addressing concern, and whether any structural split is warranted.
Per stakeholder direction (dave, 2026-06-02), this is recorded as an open
question only.

## Alternatives considered

**Option A — Put the canonicalization rule (or a copy of it) in messaging,
since messaging is where dispatch happens.** Rejected. It contradicts the
scenarios charter ("hash discipline is a scenario concern") and scenario 117
("exactly one canonical hash text per scenario block, not one per surface").
A second implementation is exactly how the wire/disk divergence (defect (a),
`lead-ji28`, the 9-occurrence tally) arises: two implementations drift.
`scenarios` is a zero-dependency leaf every BC already requires; there is no
coupling cost to delegating.

**Option B — Keep the `subprocess.run(["scenarios", "hash"])` shell-out
(defect (b)) and only fix the Feature-line wrap (defect (a)).** Rejected.
The shell-out is PATH-fragile (it resolves a binary, not the imported
package the dist already depends on) and is a second, separate route to the
same rule — the structural hazard D1 closes. Fixing (a) without (b) leaves
the divergence latent: a PATH mismatch reintroduces a different `scenarios`
than the one `Requires:` pins.

**Option C — Relocate payload construction into `scenarios` now (D3's
fuller move) as part of this decision.** Rejected *for this ADR*. It changes
the `scenarios` BC's contract surface and so requires `assign_scenarios`, not
the `request_bugfix` the (a)+(b) tightening is. Bundling it would conflate a
within-surface tightening with a new-capability assignment to a different BC.
D3 scopes it as a noted consequence for a separate dispatch.

## Consequences

- A `request_bugfix` to `shopsystem-messaging` carries the (a)+(b) fix:
  compute the dispatched hash over the scenario-block-only canonical form
  (citing 117), and delegate in-process to
  `scenarios.hash.compute_scenario_hash` instead of shelling out. This is a
  behavioral tightening of existing, scenario-pinned (117) behavior →
  `request_bugfix`, not `assign_scenarios` (the capability exists) and not
  `request_maintenance` (117 behavior is directly contradicted by the
  current shape).
- Once landed, dispatched `scenarios[].hash` values equal on-disk
  `@scenario_hash:` tags for the same block, closing the lead-side
  reconciliation divergence tallied across `lead-ji28` (9 occurrences) and
  resolving the umbrella `lead-wgv` ambiguity at the implementation level
  (117 already resolved it at the contract level).
- The fuller construction-relocation move (D3) remains open as a possible
  follow-up `assign_scenarios` to `shopsystem-scenarios`; it is not scheduled
  by this ADR.
- The registry/addressing ownership question remains an explicit open
  question; no structural change follows from this ADR on that axis.

## Cross-references

- [scenario 117](../features/templates/117-canonical-scenario-hash-canonicalization-is-scenario-block-only-not-feature-line-included.gherkin)
  — the canonicalization contract this ADR assigns ownership for.
- [ADR-018](018-empirical-verification-is-contract-surface.md) — the
  artifact-surface evidence rule the pre-state findings honor (D2
  contract-tool invocation of `scenarios hash`).
- [ADR-006](006-messaging-name-registry-design.md) §5 — messaging owns the
  `ScenarioPayload` as transported content; the registry/addressing design
  whose ownership the open question revisits.
- [lead-ji28](beads:lead-ji28) — the lead-2ca in-the-wild occurrence
  (07d405ae455c5553 vs 641bae76c069bf5b) this ADR pins the resolution for.
- [lead-wgv](beads:lead-wgv) — umbrella canonicalization-ambiguity bead,
  resolved at the contract level by 117 and at the implementation level by
  the dispatch this ADR motivates.
