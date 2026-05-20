# Brief 001 — Inter-shop messaging encapsulation

**Status:** draft, intent gaps resolved (2026-05-12), item C scope
corrected to empirical reality (2026-05-12)
**Authors:** dstengle, Claude (lead-po)
**Beads:** [`lead-231`](#) (this brief)
**Anchored to:** mechanism observation
[`shopsystem-templates-kin`](../repos/shopsystem-templates/outbox/shopsystem-templates-kin-mechanism_observation.yaml)
emitted by the shopsystem-templates BC during lead-kq0, sharpened in
conversation 2026-05-12, three intent gaps resolved by user-driver
2026-05-12 (tests carve-out from invariant 1; spec stays conceptual
with no filename conventions; catalog audit covers all currently-
implemented message types — `request_scenario_register` and
`request_shop_card` deferred per
[`findings/from-prototype-1.md` finding 1](../findings/from-prototype-1.md),
with the decoupling invariant carrying forward to their eventual
authoring).

## Point of intent

Inter-shop messaging exists as a **bounded surface** that other parts of
the shop-system compose with, not a directory layout that other parts of
the shop-system inspect. Today, templates and subagents reach past the
surface and read `inbox/` and `outbox/` directly because the surface
does not yet expose the operations they need. The cost is that
`shop-msg`'s storage layout — a filesystem convention that should be a
private implementation detail of the messaging BC — has become a public
shape that every consumer depends on.

The brief commits the shop-system to two invariants and a corollary,
and names the five scope items the invariants imply.

## The two invariants

### Invariant 1 — `shop-msg` is the sole inter-shop messaging surface

No consumer (template, subagent, runbook, ad-hoc script) inspects
messaging storage directly. The storage representation (PostgreSQL —
migrated from the earlier filesystem-YAML prototype; a different
backend tomorrow) is a **private implementation detail of the messaging
BC**. The parenthetical is a completed-migration note, not a
forward-look: shop-msg already uses PostgreSQL.

**Carve-out for messaging-BC tests.** Tests of `shop-msg`'s own
implementation may freely inspect messaging storage — they are the
messaging BC, not inter-shop consumers. Tests of BCs that consume
`shop-msg` (and any non-test consumer of any kind) must use the CLI for
setup and assertion like any other consumer.

This is the messaging-surface application of
[`findings/from-prototype-1.md` finding 6](../findings/from-prototype-1.md)
("package CLIs are the integration boundary"). Prototype 1 validated
the principle for catalog schemas, scenarios canonicalisation, and the
test harness. It applies equally to the messaging surface — and the
mechanism observation `shopsystem-templates-kin` is the evidence that
it currently does not hold.

The observation enumerates the leak:

- `ls inbox/ outbox/` to enumerate state.
- "A message is unprocessed when there is no outbox file for its
  `work_id`" — set-difference on filenames.
- `grep message_type inbox/<work_id>.yaml` to decide which subagent to
  dispatch.

These appear in the canonical templates this BC ships
(`bc-implementer.md`, `bc-reviewer.md`, the BC-router section of
`repos/shopsystem-templates/CLAUDE.md`). Because those files are
`shopsystem-templates`'s **product**, the leak ships to every
downstream BC that adopts them.

### Invariant 2 — Inter-shop messages are self-contained

The receiving shop acts on a message **without consulting the sending
shop's internal artifacts** (beads, source files, working directories).
A message carries everything its recipient needs to decide what to do.
The local-clone topology currently hides violations of this — every
shop's repo is reachable on the same filesystem, so an implementer that
reads sender-side state happens to succeed. Remote-shop topology will
not be so forgiving.

### Corollary — `shop-msg` and `bd` are decoupled

Catalog schemas must not require participation in `bd`. Template
language must not instruct creating beads as a precondition for
messaging. `bd` is each shop's local work-tracker; messaging is the
inter-shop surface; the two may compose but **neither requires the
other**.

The originating observation itself shows the current coupling:
`MechanismObservation.bd_ref: shopsystem-templates-kin` is a required
field, and the bc-implementer template instructs the BC to "create a
beads issue capturing what you observed" before emitting the message.
A shop that does not use `bd` cannot emit a `mechanism_observation`
today — even though `bd` participation is **its own concern**, not the
inter-shop concern.

## Five scope items

The brief commits intent on five items. Each is named here in product
terms; vehicle selection and implementation specifics are the
Architect's call after BC pre-state verification.

### A — `shop-msg` CLI surface (symmetric, both BC and lead sides)

`shop-msg` exposes the operations every consumer needs so that no
consumer falls back on `ls`/`cat`/`grep` against the mailbox
directories. At minimum:

- **Enumerate pending unprocessed work.** A consumer (a BC-shop router,
  the lead's drain operation, a runbook) can ask "is there an
  unprocessed message here, and what is its `message_type`?" without
  inspecting the filesystem. `--bc <name>` filtering is part of the
  contract from day one — the lead side will need it.
- **Read inbox by `work_id`.** Parallel to the existing
  `shop-msg read outbox <work_id>`. Today the templates instruct
  reading inbox YAML directly because no CLI operation exists.
- **Parity check.** No operation a consumer needs (whether template,
  subagent, runbook, or ad-hoc script) currently requires direct file
  access. The Architect closes this by enumerating the call sites
  during pre-state verification.

The contract is **symmetric** between BC side and lead side. The lead
shop never touches BC outboxes directly any more than a BC-shop touches
its own inbox directly. Both sides use the same surface.

### B — Templates rewrite

The canonical templates at
`repos/shopsystem-templates/src/shop_templates/templates/bc-implementer.md`
and `bc-reviewer.md`, together with the BC-router section of
`repos/shopsystem-templates/CLAUDE.md`, **use the `shop-msg` CLI only**
— no direct references to `inbox/` or `outbox/` directories or to
their filename conventions, except in conceptual material that
explicitly describes the protocol at the spec level.

The same discipline applies to the lead-side templates
(`lead-po.md`, `lead-architect.md` in the same templates directory)
and to the lead-shop `CLAUDE.md`. The point of intent is uniform across
roles: **no role enacts the protocol by inspecting messaging storage.**

### C — Catalog schema decoupling

The catalog schemas under `shop-msg`'s `catalog` package are audited
in full across the **six currently-implemented message types**
(`assign_scenarios`, `request_bugfix`, `request_maintenance`,
`clarify`, `work_done`, `mechanism_observation`) — for required
references to `bd`. `MechanismObservation.bd_ref` is the known
instance, but the audit does not presuppose the other five are clean:
full coverage of what exists is cheap and catches anything that has
slipped in unnoticed.

`request_scenario_register` and `request_shop_card` are **deferred**
per [`findings/from-prototype-1.md` finding 1](../findings/from-prototype-1.md)
— no Pydantic schema for either lives in `catalog/schemas.py` today,
and no open lead-shop bead currently schedules authoring them (the
prototype-1 issues `6mk` and `r7u` closed as deferred 2026-05-10).
Authoring of `request_scenario_register`'s schema will naturally ride
with [`lead-otu`](#) (the per-BC scenario register surface), since
that message type depends on what a register IS. `request_shop_card`
awaits its own driver.

The decoupling invariant **carries forward**: when those two schemas
are eventually authored, they honor the invariant from the start
alongside whatever functional schema design they require. The brief
commits the invariant; the future work commits the schemas.

The committed outcome (for the six in-scope today): `bd` references
are either **optional** or **removed**. If retained, they are framed
strictly as **provenance metadata** that the producer happens to
carry, never as **required participation** in `bd`. The schema makes
it possible for a shop that does not use `bd` to emit any message
type the catalog defines.

### D — Template-language decoupling

The template language is audited in parallel — particularly the
`bc-implementer.md` "Surfacing mechanism observations" section, which
today instructs:

> Create a beads issue capturing what you observed: `bd create --title …`
>
> Emit the wire message: `shop-msg respond mechanism_observation
> --bd-ref <bead id from step 1> …`

This is rewritten so that **`bd` participation is an independent
local-tracker concern, never a precondition for messaging**. If a shop
uses `bd`, the template may describe how the two compose — but the
ordering "bead first, then message" is removed, and the message is
emit-able regardless of whether a bead exists.

The audit covers all four canonical templates
(`lead-po.md`, `lead-architect.md`, `bc-implementer.md`,
`bc-reviewer.md`) and both `CLAUDE.md` files (lead-shop and the
shopsystem-templates BC).

### E — Spec edits (§4 and §5)

[`§4`](../04-bc-shop.md) is amended to describe messaging in **purely
conceptual terms**: *what flows* (inbox messages from lead, outbox
responses from BC) and *what consumers do via the CLI*. The spec
proper **does not name any filename pattern, directory layout, or
on-disk convention**. Storage shape — including any filename
convention like `<work_id>-<response_type>.yaml` — is `shop-msg`'s
internal realization, not part of the inter-shop contract. The
Architect may retain examples of the current realization in
implementation notes inside the messaging BC, but those examples do
not enter the §4 spec text.

[`§5`](../05-inter-shop-protocol.md) is amended to name the
**self-contained-messages invariant** explicitly. §5.6 already commits
the schema-as-contract principle; the self-contained-messages claim is
a sibling and belongs alongside it (or in a new §5.7). §5 is held to
the same discipline as §4: it characterises the protocol, never the
storage.

The Architect directs implementation specifics for both edits; the
brief commits the **intent** that the spec stops describing storage
shape and starts describing protocol semantics. The principle is the
same one [`findings/from-prototype-1.md` finding 4](../findings/from-prototype-1.md)
applies to invariants: claims belong where they are enforceable;
conventions that are not part of the contract are noise that invites
slippery-slope dependency.

## Out of scope — named explicitly

**Auto-loading messages into `bd` (drain automation).** The decoupling
holds in both directions: messaging does not require `bd`, and `bd`
does not need to be fed automatically by messaging. If a `shop-msg
drain` command (or similar) is wanted later, a follow-on brief opens
when manual-drain friction surfaces in real-product BC use. This is
adjacent to
[`findings/from-mechanism-observation-v1.md §6`](../findings/from-mechanism-observation-v1.md)
("lead drain formalization") — that item stays **deferred for now**.

## Sequencing

- **Messaging half (A + C) and spec edits (E)** can be authored and
  dispatched **independently** of templates work. They target
  shopsystem-messaging and the lead-shop spec respectively; neither
  collides with lead-kq0.

- **Templates half (B + D)** **waits on lead-kq0
  ([PDR-001](../pdr/001-role-templates-role-complete.md))
  closing.** B and D rewrite the same template surface lead-kq0 is
  currently restructuring. Collision risk is high otherwise:
  lead-kq0's restructure changes the **shape** of the templates; B+D
  changes their **content** with respect to messaging storage. The two
  changes interleave badly if dispatched in parallel.

The ordering is a sequencing constraint on dispatch, not on authoring.
The Architect may verify pre-state and pick vehicles for B+D before
lead-kq0 closes, but the `assign_scenarios` / `request_bugfix`
dispatches for B+D should not land in the templates BC's inbox until
lead-kq0's `work_done` does.

## Vehicle hints (Architect's call)

For the Architect's awareness during pre-state verification — not as a
prejudgment of the discriminator:

- **A** likely lands as `assign_scenarios` against shopsystem-messaging
  (new capability: the read-side and enumeration commands do not exist
  in `shop-msg` today, per `shop-msg --help`).
- **C** likely lands as `request_bugfix` against shopsystem-messaging
  (tightening existing schemas: catalog schemas exist and carry the
  coupling; the change is to remove or relax the coupling, not to add
  new schema infrastructure).
- **B + D** likely land as `request_bugfix` against
  shopsystem-templates (tightening existing templates: the templates
  exist; the change is to replace their direct-mailbox references with
  CLI references and to remove "bead first, then message" ordering).
- **E** likely lands as `request_maintenance` against the lead-shop
  spec docs (flat content change in `04-bc-shop.md` and
  `05-inter-shop-protocol.md` — no new behavior, no scenario
  movement).

These are hints. The Architect's `PRE-STATE DETERMINES VEHICLE —
VERIFIED EMPIRICALLY` posture stands.

## Grounding artifacts

- [`repos/shopsystem-templates/outbox/shopsystem-templates-kin-mechanism_observation.yaml`](../repos/shopsystem-templates/outbox/shopsystem-templates-kin-mechanism_observation.yaml)
  — the originating BC observation that started this brief.
- [`findings/from-prototype-1.md` finding 6](../findings/from-prototype-1.md)
  — the validated principle ("package CLIs are the integration
  boundary") this brief extends to the messaging surface.
- [`findings/from-mechanism-observation-v1.md` §6](../findings/from-mechanism-observation-v1.md)
  — drain formalization, **referenced as deferred** to make the
  out-of-scope boundary explicit.
- [`repos/shopsystem-templates/CLAUDE.md`](../repos/shopsystem-templates/CLAUDE.md)
  — current BC inbox/outbox protocol section; shows the current
  coupling.
- [`repos/shopsystem-templates/src/shop_templates/templates/bc-implementer.md`](../repos/shopsystem-templates/src/shop_templates/templates/bc-implementer.md)
  and
  [`bc-reviewer.md`](../repos/shopsystem-templates/src/shop_templates/templates/bc-reviewer.md)
  — canonical templates whose language scope B and D rewrite.
- [`CLAUDE.md`](../CLAUDE.md), [`§4`](../04-bc-shop.md),
  [`§5`](../05-inter-shop-protocol.md) — spec-edit targets for scope E.

## What this leaves open

The brief commits **intent**, not scenarios. Scenarios come after the
Architect verifies BC pre-state and picks vehicles per the
discriminator. Specifically:

- **Exact CLI command names and flag shapes for A.** "Enumerate
  pending" might be `shop-msg pending`, `shop-msg list`, or
  `shop-msg next`; "read inbox" is most plausibly
  `shop-msg read inbox <work_id>` for parity with `read outbox`, but
  the Architect names the shapes in the dispatched scenarios.
- **Whether `bd_ref` becomes optional, is removed entirely, or is
  renamed to a neutral `provenance_ref`.** All three are consistent
  with the invariant; pre-state verification on the catalog schemas
  picks one.
- **Whether E is one `request_maintenance` or two.** §4 and §5 edits
  are independent in principle; the Architect may bundle or split.

These are vehicle-level questions, not intent-level. The PO's commit
is the two invariants + the five scope items + the sequencing
constraint.
