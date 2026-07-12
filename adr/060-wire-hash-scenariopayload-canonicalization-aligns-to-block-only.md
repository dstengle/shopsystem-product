# ADR-060 — The on-wire `ScenarioPayload.hash` (and messaging's catalog canonicalization) aligns to BLOCK-ONLY; whole-text catalog canonicalization was a latent ADR-019 non-conformance that scenarios 0.3.1 exposed

**Status:** accepted (2026-07-12)
**Tier:** system-global (governs a cross-BC on-wire contract: the
canonical text of every `ScenarioPayload.hash` transported between shops —
not one BC's internals).
**Authors:** dstengle (offline autonomous directive), Claude (lead-architect)
**Anchored to:** [ADR-019](019-canonicalization-ownership-in-scenarios-bc.md)
(canonicalization + scenario-hash discipline are owned by `shopsystem-scenarios`;
exactly ONE canonical scenario-block hash text; D2 — messaging *delegates*,
never re-enacts, and never hashes a `Feature:`-line-wrapped string),
[ADR-056 D5](056-scenario-file-schema-off-the-shelf-gherkin-validation-and-bc-tag-source-of-truth-cutover.md)
(the `scenarios hash` CLI is reconciled to parse-then-block-only; ONE
canonicalization), [ADR-018](018-empirical-verification-is-contract-surface.md)
(this ADR's pre-state is contract-surface only).
**Pins (already-authored):** [scenario 117](../features/templates/117-canonical-scenario-hash-canonicalization-is-scenario-block-only-not-feature-line-included.gherkin).
**Related beads:** `lead-14xb.1` (the re-dispatched messaging bugfix this ADR
directs), `lead-14xb.2` (the gated bc-launcher/bc-base re-release that carries
fleet-wide simultaneous adoption), `lead-14xb` (fabro convergence epic).

---

## Context

The fabro convergence requires rebuilding `bc-base`, which requires
`shopsystem-messaging` to move its `scenarios` pin `0.2.0 → 0.3.1` (shop-templates
0.52.0 co-installs and requires `scenarios 0.3.1`). Moving the pin turned
messaging's own suite RED (20 failed / 438 passed; clean 458/458 on 0.2.0).

Root cause (verified by the BC and reconciled against the lead artifact
surface): `scenarios 0.3.1` changed the **`scenarios hash` CLI subcommand**
canonicalization from whole-text to **parse-then-block-only** (ADR-056 D5) —
it strips surrounding `@`-tag lines and any `Feature:` line before hashing.
The `scenarios` **library** `compute_scenario_hash` is byte-identical across
0.2.0..0.3.1; only the CLI subcommand changed. Messaging's
`catalog._canonical_scenario_hash`, the `ScenarioPayload.hash` validator
(`catalog/schemas.py`), and `shop_msg.cli._compute_scenario_hash` canonicalize
**whole-text**, and `tests/integration/test_catalog_scenarios_agreement.py`
pins the required contract `catalog._canonical_scenario_hash == 'scenarios hash'
CLI`. Under 0.3.1 the two diverge for any body carrying tag/`Feature:` lines
(e.g. a standalone `@bc:test` line: CLI block-only `f16a86c6e862d938` vs catalog
whole-text `b6dd1cdfc038dba6`). The agreement test stayed green only because its
sample bodies are pure `Scenario:` blocks where block-only == whole-text,
masking the divergence.

Messaging correctly did NOT ship, reverted to green, and escalated this as an
ADR-level wire-hash decision (blast radius: every on-wire `ScenarioPayload.hash`
for tag/`Feature:`-wrapped bodies; every BC + the lead adopt simultaneously).

### Pre-state, contract-surface only (ADR-018 D1/D2)

- **The canonical rule is block-only.** ADR-019 D1 assigns ownership of the
  canonicalization rule (scenario-block-only; drop blanks; drop `@scenario_hash:`
  lines) to `shopsystem-scenarios`, "exactly one canonical hash text per scenario
  block, not one per surface." ADR-019 **D2** states messaging computes that hash
  over the **scenario-block-only** canonical form, "**never a `Feature:`-line-wrapped
  string**," and must not re-enact canonicalization.
- **The `scenarios hash` CLI is now block-only.** ADR-056 D5: "`scenarios hash`
  is reconciled to parse-then-hash so raw and parser paths cannot disagree."
- **The lead-held register is ALREADY block-only.** Empirically, all **150**
  `@scenario_hash` pins in `features/shopsystem-messaging/` reproduce **exactly**
  under the block-only parser path (`scenarios list`), **0 mismatch** — including
  files wrapped with `@bc`/`@origin`/`Feature:` lines (e.g.
  `send_assign_scenarios.feature` pin `42d2d64c4e45ca7d`). The on-disk register
  never encoded whole-text.

## Decision

**The on-wire `ScenarioPayload.hash` is the BLOCK-ONLY canonical hash of the
scenario block, per ADR-019 D1/D2 and ADR-056 D5.** Messaging's
`catalog._canonical_scenario_hash`, the `ScenarioPayload.hash` validator, and
`shop_msg.cli._compute_scenario_hash` are aligned to block-only (parse-then-
block-only), delegating in-process to `scenarios.hash` rather than re-enacting
the rule (ADR-019 D2). The `test_catalog_scenarios_agreement` pin is strengthened
to exercise a tag/`Feature:`-wrapped body so the catalog==CLI agreement is
genuinely tested, not masked by pure-block samples.

**This is CONFORMANCE, not a new direction.** The canonical rule was block-only
all along (ADR-019, scenario 117). Messaging's whole-text catalog was a **latent
non-conformance** with ADR-019 D2 that agreed with the old whole-text CLI by
coincidence and was masked by pure-block test samples; `scenarios 0.3.1` (ADR-056
D5) merely exposed it. The alignment is therefore carried by a `request_bugfix`
(existing, 117-pinned behavior brought into conformance), not `assign_scenarios`.

**No scenario-register re-pin.** Because the on-disk `@scenario_hash` pins are
already block-only, aligning messaging's runtime computation makes the wire
value MATCH the existing pins — no `@scenario_hash` is retired, superseded, or
contradicted. The on-wire hash for tag/`Feature:`-wrapped bodies now equals the
on-disk pin (previously it diverged — the defect).

**Fleet adopts simultaneously.** The change lands via the bc-base rebuild +
lead `shop-msg` reinstall gated on `lead-14xb.2`; every BC and the lead pick up
block-only wire hashing in the same convergence step. Register pins are unchanged.

## Alternatives considered

- **Put whole-text on the wire (make the CLI/register conform to messaging).**
  Rejected: contradicts ADR-019 D1/D2 and scenario 117 ("exactly one canonical
  hash text … never a `Feature:`-line-wrapped string") and would force re-pinning
  the entire register off its authored block-only hashes.
- **Keep messaging on `scenarios 0.2.0`.** Rejected: blocks bc-base co-install
  with shop-templates 0.52.0 and thus the whole fabro convergence; and it leaves
  the ADR-019 D2 non-conformance latent, to re-surface at the next tag bump.
- **Treat this as a new architectural decision requiring fresh product shaping.**
  Rejected: the block-only wire contract is already decided (ADR-019 + ADR-056 D5)
  and already pinned (scenario 117); nothing here is contested or net-new.

## Consequences

- `request_bugfix` on `lead-14xb.1` carries: pin `→ 0.3.1`; migrate the three
  canonicalization sites to block-only (in-process delegation, ADR-019 D2);
  strengthen `test_catalog_scenarios_agreement` to a wrapped body; suite green;
  cut messaging **v0.4.6** (ADR-039).
- No `@scenario_hash` re-pin across any BC; the register is already block-only.
- Fleet-wide adoption is simultaneous via bc-base rebuild + lead reinstall
  (`lead-14xb.2`), unblocking fabro convergence (`lead-14xb`).
- The mechanism_observation on `lead-14xb.1` (ADR-018 contract-surface analysis
  is blind to a dependency's CLI-subcommand behavior change) is a real
  sufficiency-mechanism gap: a future "bump a scenarios pin" analyzed purely
  from Requires-Dist + byte-identical library API will keep mis-scoping a
  CLI-behavior change as a no-op. Going forward, when a BC consumes a dependency
  **via its CLI**, the impact analysis must include a CLI-behavior probe across
  old/new tags on representative inputs. (Recorded here as consequence; a
  standalone doctrine ADR may follow if the pattern recurs.)
