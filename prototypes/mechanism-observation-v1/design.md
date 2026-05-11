# Mechanism Observation Prototype Design

**Status:** design (2026-05-11). Validated against prototype 1 findings; awaiting slice execution.

## Purpose

Validate that BCs can reliably surface load-bearing observations about the *shop-system mechanism* (templates, schemas, role discipline) — not just scenario-level gaps — through a new catalog message `mechanism_observation`. This is the structural mechanism for prototype 1 finding 8's unvalidated item: lead-side accumulation of mechanism observations during regular operation, instead of relying on a human driver to write findings post hoc.

Each observation produces three artifacts:

1. A bead in the BC's beads (originating record)
2. A catalog message (BC → lead wire)
3. A bead in the lead's beads (drain record)

Same three-artifact shape as `assign_scenarios` (lead-NNN ↔ BC breakdown bead ↔ message), inverted in direction.

## Scope

### In scope

- `MechanismObservation` schema in `catalog`
- `shop-msg respond mechanism_observation` CLI in `shop-msg-bc`
- BC-side and lead-side bead conventions (labels, fields, queries)
- Lead drain process (manual, but documented)
- Template revisions to `bc-implementer` / `bc-reviewer` with the discriminator
- Slice progression: mechanism → discipline (under + over) → near-miss → drain

### Out of scope

- Cross-shop-group routing (lead may forward observations manually; catalog doesn't route)
- Recursion / multi-tier shop-groups
- Automatic classification (domain vs mechanism — lead decides)
- Lead-as-subagent (lead is still you-as-driver)
- The two unexercised prototype-1 message types (`request_shop_card`, `request_scenario_register`)
- Hash↔body invariant on `MechanismObservation` (not a scenario carrier; no canonicalization need)

## Architecture

Reuses existing prototype-1 infrastructure end-to-end: filesystem YAML transport, the same per-BC `inbox/outbox`, `catalog.schemas` extended with one new model, `shop-msg-bc` extended with one new `send` subcommand. Existing `shop-msg read outbox` reads the new type without modification.

The new structural piece: a *third artifact class* — the BC's originating bead. Lead-originated messages (`assign_scenarios`, `request_bugfix`, etc.) don't have this because the lead drives. For BC-originated mechanism observations, the BC's record is the canonical source; the message carries a `bd_ref` pointing at it; the lead's drain bead references back via the same `bd_ref`. The chain is queryable in both directions.

## Schema: MechanismObservation

| Field | Type | Required | Purpose |
|---|---|---|---|
| `bd_ref` | str, regex `^[a-z0-9-]+-[a-z0-9]+$` | yes | BC-side bead id (output of `bd create`) |
| `subject` | str, 5–120 chars | yes | One-line summary; must equal the BC bead's title |
| `observed_during` | str | no | Lead-issued work_id (e.g. `lead-022`) the BC was working when this surfaced; null if ambient |
| `body` | str, min 50 chars | yes | Markdown: what was observed, why it's load-bearing, what the BC tried. Long-form analysis lives in the BC bead's notes/design field; this is the readable carrier |
| `evidence` | list[str], min 1 if present | no | File:line refs, template-line refs, package names — verifiable pointers |
| `proposed_action` | str | no | BC's hypothesis: "tighten X template line Y" / "schema gap on Z" |

Schema-level invariants (per prototype 1 finding 4 — input safety belongs in the schema):

- `bd_ref` regex enforces bead-id shape at validation time
- `body` minimum length prevents stub observations
- No `@bc:` tag (this is not a scenario carrier)

## Beads conventions

**BC originating bead** (created BEFORE `shop-msg respond mechanism_observation`):

```
bd create --title "<subject>" --type=task --priority=2 \
  --label mechanism-observation --label originated
```

- Description = full markdown body
- Design field = long-form analysis if any
- Title MUST equal the message's `subject` field

**Lead drain bead** (created during drain):

```
bd create --title "<subject>" --type=task --priority=<lead-assigned> \
  --label mechanism-observation --label received
```

- Description references both the BC bead id and the message file path
- Drain decision (act / park / forward) recorded as a `bd update --notes`

Required queries — all must return useful inventories:

- `bd list --label=mechanism-observation` — full registry
- `bd list --label=mechanism-observation --label=received` — lead's drain inbox
- `bd list --label=mechanism-observation --label=originated` — within a BC, observations that BC has surfaced

## Template revisions (draft discriminator)

The BC-implementer and BC-reviewer templates gain a section before the work-completion handoff:

> *Before emitting `work_done`, ask: did anything about the **mechanism** — schema shape, role-template wording, sufficiency criteria, package boundaries, the lead's instructions — strike you as load-bearing-but-not-scope? If yes AND it's something a future BC dispatch or the lead would want to know, emit a `mechanism_observation` alongside `work_done`.*
>
> *Carve-outs:*
>
> - *Property of the scenario / work item itself (missing acceptance criterion, ambiguous work_id) → `clarify`, not a mechanism observation*
> - *Implementation block you can't fix without further direction → `work_done(blocked)`, not a mechanism observation*
> - *Specifically about the mechanism of the system itself (templates, schemas, role discipline, packages, the spec) → `mechanism_observation`*
>
> *If nothing mechanism-level surfaced: state "no mechanism observations this dispatch" and proceed with `work_done` normally.*

The "asking would be theatre" anti-rationalization line carries over from `clarify` discipline: emitting a `mechanism_observation` when nothing genuinely load-bearing surfaced is theatre and should be avoided.

## Slice plan

### Slice A — Mechanism

- Add `MechanismObservation` to `catalog.schemas`
- Add `shop-msg respond mechanism_observation` subcommand to `shop-msg-bc`
- BC manually constructs a real observation (driver-shaped, no template language yet)
- Verify: message round-trips via `shop-msg read outbox`; both beads exist; the bd_ref chain links them
- **Pass criteria:** `bd list --label=mechanism-observation` shows both beads; message YAML on disk parses; the schema rejects malformed input (path-unsafe `bd_ref`, short `body`)
- This validates infrastructure only; templates not yet revised

### Slice B1 — Discipline (under-emitting test)

- Revise `bc-implementer` and `bc-reviewer` templates with the discriminator language
- Construct a work item where a real mechanism observation is naturally available to the BC during the work (e.g., the work surfaces a template gap or schema ambiguity the BC notices while doing it)
- Dispatch a fresh BC subagent
- **Pass criteria:** BC emits a `mechanism_observation` with substantive body; BC bead chain forms
- **Fail mode:** BC ships `work_done` without surfacing the observation. Response: revise template language, dispatch a fresh subagent against the same work item, retry. Per prototype 1's S2 → S2b precedent, budget 2–3 attempts.

### Slice B2 — Discipline (over-emitting test)

- Same revised templates from B1
- Construct a work item with no load-bearing mechanism observation naturally available
- Dispatch a fresh BC subagent
- **Pass criteria:** BC emits `work_done` only, no spurious `mechanism_observation`
- **Fail mode:** BC over-fires, surfacing a trivial observation. Response: sharpen the discriminator's negative carve-outs in the template; dispatch a fresh subagent.

**B2 is a hard gate, not optional.** Prototype 1 shipped without validating the over-asking side of `clarify` (finding 2 caveat). Not repeating that mistake here.

### Slice B3 (conditional) — Near-miss

- Run only if B1 or B2 surfaces ambiguity about the carve-outs
- Construct two work items: one where the right answer is `clarify` (scenario-level gap), one where the right answer is `work_done(blocked)` (implementation block)
- Verify the templates steer the BC to the right message type, NOT into `mechanism_observation`
- **Pass criteria:** BC emits `clarify` for the first, `work_done(blocked)` for the second; no `mechanism_observation` produced in either case
- **Fail mode:** discriminator is steering observations into the wrong channel. Response: refine carve-out language.

### Slice C — Lead drain

- Formalize the lead's drain action: what does the lead actually do per received observation?
- Define three drain outcomes:
  - **Act** — lead-side work follows (could become an `assign_scenarios` or `request_bugfix`, or a spec edit, or a template revision)
  - **Park** — bead stays open with explicit `noted-not-load-bearing` label
  - **Forward** — lead manually records that the observation should go to another shop-group; since cross-group routing is out of scope, this is a `bd note` documenting the manual hand-off
- Run the drain on observations accumulated from slices A, B1, and (if run) B3
- **Pass criteria:** documented drain process exists; lead-side bd inventory has consistent shape; a fresh reader can pick up the inventory and understand each observation's status

## Promotion gate

After slice C closes, the prototype-1 packages (`catalog`, `scenarios`, `shop-templates`, `shop-msg-bc`) graduate out of `prototypes/` to a top-level `packages/` directory. This is a separate work item with its own design (packaging tradeoffs, dependency surface, where the BCs consume them from). It is NOT slice D of this prototype.

## Success criteria

The prototype is complete when:

- Slice A round-trips and the bead chain is queryable
- Slice B1 passes with the BC emitting `mechanism_observation` from naturally-available observations (may require multiple template revisions)
- Slice B2 passes with the BC NOT over-emitting (hard gate)
- Slice B3 passes if run (correct steering for near-miss cases)
- Slice C closes with a documented drain process and consistent lead-side bd inventory
- A `findings-from-mechanism-observation-v1.md` doc consolidates the prototype's findings, parallel to `findings-from-prototype-1.md`

## Known risks

1. **Template revision iteration cost.** Prototype 1 needed S2 → S2b → S2c to get `clarify` discipline right. Budget multiple attempts per direction during slice B.
2. **Asymmetric calibration trap.** Prototype 1 never validated the over-asking side of `clarify`. Slice B2 is the explicit guard against repeating that mistake. Hard gate, not optional.
3. **Documented-but-untested branches.** Prototype 1's `work_done(blocked)` was named in templates but never exercised by any slice's natural flow (finding 3 caveat). Slice B3 guards against the equivalent risk for `mechanism_observation`'s carve-outs.
4. **Lead drain ambiguity.** No formal lead-side template (still finding-8 territory). Slice C's deliverable is a *documented* drain process even though the actor is human; the lead-as-subagent prototype that closes finding 8 fully is a subsequent piece of work.

## How this connects to prototype 1

- **Finding 1 (catalog mechanism sufficient):** This prototype adds one message type, validating the mechanism scales to 8 total without structural changes.
- **Finding 2 (role discipline is part of the contract):** Slice B is the same discipline question, applied to a new failure mode (under/over-surfacing mechanism observations). Slice B2 is the explicit fix for finding 2's asymmetric-calibration caveat.
- **Finding 3 (§4.4 loop is reproducible mechanism):** Slice B3 guards against introducing a documented-but-untested branch, fixing finding 3's `work_done(blocked)` caveat shape.
- **Finding 4 (schema-level input safety):** `MechanismObservation`'s `bd_ref` regex and `body` length follow the same pattern. No producer-side validation.
- **Finding 5 (message-type selection discipline):** The discriminator in the templates is the BC-side version of the lead-side discriminator (`assign_scenarios` vs `request_bugfix` vs `request_maintenance`). Both are pre-state questions answered by language.
- **Finding 6 (package boundaries):** Reuses existing packages. CLI is the boundary as before.
- **Finding 7 (dogfooding):** Real BC subagents in slice B emit `mechanism_observation` against this prototype's own templates. The system observes itself.
- **Finding 8 (what's not yet validated):** This prototype tackles "lead-side accumulation of mechanism observations" partially — the BC side and the lead-drain side, with the lead-as-subagent piece still deferred.
