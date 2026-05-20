# Brief 006 — Messaging name registry and lead inbox

**Status:** draft (2026-05-20)
**Authors:** dstengle, Claude (lead-po)
**Anchored to:** stakeholder intent 2026-05-20:
*"Shops are addressed by canonical name, not by filesystem path. The
registry is the resolution layer; the BC manifest is the source of truth
for canonical names. The lead is a named participant, with its own inbox,
so that messages carry from/to fields and routing is symmetric."*

---

## Interview notes (PO capture)

**What behavior would satisfy the stakeholder:**

- Every `shop-msg` CLI call that currently takes `--bc-root <path>` or
  `--lead-root <path>` is rewritten to accept `--bc <name>` and
  `--lead <name>` instead. The canonical name (`shopsystem-messaging`,
  `shopsystem-product`, etc.) is the stable address. The filesystem path
  is an implementation detail that `shop-msg` resolves internally by
  querying the DB registry.
- A DB-backed registry holds the mapping from canonical name to
  connection information. `shop-msg` provides management commands for
  the registry (`registry add`, `registry remove`, `registry list`,
  `registry sync`). The lead shop calls these commands at bootstrap;
  no BC calls them unless the lead delegates that.
- The lead shop itself is a named participant in the registry — it has
  a canonical name (matching its `shop/name.md`) and an inbox in the
  same storage layer that BC inboxes use. A BC responding to the lead
  sends to the lead's name; the lead reads its own inbox by name.
- Every message carries a `from` field (sender canonical name) and a
  `to` field (recipient canonical name). Neither field is optional or
  inferred after the fact. The messaging BC adds these fields to every
  message schema it owns.
- `shop-msg watch` no longer polls BC outboxes. It watches the lead's
  inbox by name. A notification fires when any message arrives addressed
  to the lead — regardless of which BC sent it.

**What would NOT satisfy the stakeholder:**

- `--bc-root` and `--lead-root` continuing to be the primary addressing
  mode. Name-based addressing is the goal; path-based addressing is the
  thing being eliminated.
- The lead shop having to poll each BC's outbox to collect responses.
  The inbox model must be push-based: BCs send to the lead's name;
  the lead reads one place.
- A registry that lives only in memory or only in config files. The
  registry must be in the same PostgreSQL database `shop-msg` already
  uses, so every party on the shared Docker network can resolve names.
- `from` and `to` fields that are optional or populated by convention
  rather than enforced by schema. If a received message does not have
  both fields, `shop-msg` must treat it as malformed.
- The lead shop appearing in the BC manifest. The BC manifest (brief 005)
  is for product BCs. The lead shop's registry entry is added via
  `shop-msg registry add` at bootstrap — it does not go through the
  BC manifest's sync mechanism.

**Boundaries the PO commits to:**

1. **Shops are addressed by canonical name.** Path-based addressing is
   a legacy concern; the new model uses names throughout the CLI surface.
2. **The registry is in PostgreSQL.** Same DB `shop-msg` already uses.
   `shop-msg` owns the registry schema (it needs it to resolve names).
   The lead shop is the authoritative writer for registry state.
3. **The BC manifest is the source of canonical names for BCs.** The
   manifest (brief 005) lists the product's BCs with their canonical
   names. The registry is populated FROM the manifest via
   `shop-msg registry sync`. The lead shop's own entry is added
   separately via `shop-msg registry add`.
4. **The lead shop is a named participant.** It has a registry entry,
   an inbox, and a canonical name. It is not special-cased; it uses the
   same message-storage layer as BCs.
5. **`from` and `to` are required on every message.** The messaging BC
   enforces this at schema validation time. No message is delivered or
   accepted without both fields populated.

**Open questions the PO cannot close without Architect pre-state
verification:**

- **Backward compatibility strategy for `--bc-root`/`--lead-root`.**
  The Architect verifies which callers exist (lead shop CLAUDE.md,
  agent templates, BC primers, runbooks) and determines whether a clean
  break or deprecation period is safer. See PDR-007.
- **Registry table schema.** What columns the `registry` table requires
  beyond `name` and `connection_info`. The Architect verifies the DB
  pre-state and proposes a schema that covers all resolution needs.
- **Migration of messages in flight.** Any existing messages in the
  current outbox model lack `from`/`to` fields. The Architect determines
  whether to drop in-flight messages, add NULL-allowed columns and
  backfill, or require a cut-over window. That is not a PO decision.
- **Whether `shop-msg respond` is the BC's send primitive.** The current
  model has BCs calling `shop-msg respond` to write to their own outbox.
  With the new model, `shop-msg respond` should write to the lead's
  inbox by name. The Architect verifies the current `respond` command's
  mechanism and determines whether it needs a new flag (`--to`) or a
  behavior change.
- **Lead shop canonical name.** The name in `shop/name.md` is
  `shopsystem product` (with a space). Whether the registry key is
  `shopsystem-product` (hyphen, slug form) or the raw name is the
  Architect's call; the PO commits that the lead shop has exactly one
  canonical name that the registry uses consistently.

---

## Point of intent

The shopsystem messaging layer today uses filesystem paths as addresses.
`shop-msg send --bc-root repos/shopsystem-messaging` works only when the
caller and the BC share a filesystem. In a world where BCs run in
separate containers — which brief 004 explicitly targets — the path
`repos/shopsystem-messaging` is meaningful only from one host, or only
if the lead shop's filesystem is bind-mounted everywhere. That assumption
cannot hold.

Two gaps compound this:

1. **No stable addresses.** Every CLI call encodes a path. Moving a BC,
   containerizing it, or running the lead shop from a different directory
   invalidates every call.
2. **No lead inbox.** The lead shop is not a named participant in its own
   messaging system. It polls each BC's outbox — an inherently path-
   dependent operation. There is no canonical place to send a message
   "to the lead." BC responses go into a BC outbox that the lead must
   know to poll.

Both gaps share a root cause: the messaging layer treats addresses as
filesystem paths rather than as opaque names that the system resolves.
The fix is a resolution layer (the registry) and symmetric participation
(the lead has an inbox, every message carries from/to). These two are
inseparable: name-based addressing without a lead inbox still requires
the lead to know which names to poll; a lead inbox without name-based
addressing still ties the inbox to a path.

---

## The invariant

### Shops are addressed by canonical name, not by filesystem path

Every `shop-msg` CLI invocation that targets a shop uses a canonical
name. `shop-msg` resolves the name internally by querying the registry.
No caller ever passes a filesystem path as a shop address.

The registry is the resolution layer. The BC manifest is the source of
truth for BC names. The registry is populated from the manifest.

---

## Five scope items

### A — Registry management commands on `shop-msg`

`shop-msg` gains a `registry` subcommand group with at minimum:

- `shop-msg registry add <name>` — register a shop by canonical name,
  with the connection information needed for `shop-msg` to route to it.
  The lead shop calls this for its own entry at bootstrap.
- `shop-msg registry remove <name>` — deregister a shop. Idempotent
  on unknown names (exits zero, emits a notice).
- `shop-msg registry list` — list all registered shops, their canonical
  names, and any status information `shop-msg` can derive (e.g., whether
  the DB is reachable). Machine-readable output (one shop per line,
  consistent field order).
- `shop-msg registry sync` — read the BC manifest and reconcile the
  registry: add entries for BCs in the manifest not yet in the registry,
  remove entries for BCs in the registry that are no longer in the
  manifest, leave entries for BCs in both unchanged. The lead shop's own
  entry is NOT touched by sync (it is not in the manifest). Sync is
  idempotent: running it twice on an already-synced state produces no
  changes and exits zero.

The lead shop calls `registry add` for itself and `registry sync` for
BCs at bootstrap. No BC calls registry management commands; the lead is
the authoritative writer.

**What the PO does not commit:** the exact flags for `registry add`
(what information constitutes "connection information" — the Architect
verifies what the current routing mechanism needs), and the exact output
format of `registry list` (beyond "machine-readable one shop per line").

### B — Name-based addressing in `shop-msg`

Every subcommand that currently takes `--bc-root <path>` or
`--lead-root <path>` gains a corresponding `--bc <name>` and
`--lead <name>` flag. The new flags are name-based: `shop-msg` resolves
the name via registry lookup to determine how to route the message.

The intent is for `--bc-root` and `--lead-root` to be replaced by
`--bc` and `--lead`. Whether this replacement is a clean break or a
deprecation period is PDR-007's decision; the PO commits the intent
that name-based addressing is the target state, not a new option
alongside path-based addressing.

Callers that will need updating (at minimum): the lead shop CLAUDE.md,
the lead-architect.md agent, the lead-po.md agent, the BC primer, and
any bootstrap runbooks that call `shop-msg` with path flags.

### C — Lead inbox

The lead shop has an inbox in the same storage layer as BC inboxes. The
inbox is identified by the lead shop's canonical name. BC responses go
to the lead's inbox by name; the lead reads its own inbox via
`shop-msg read inbox --lead <name>`.

The lead inbox preserves the "stays until consumed" semantic that BC
inboxes use: a message in the lead inbox persists until the lead
explicitly consumes it. `shop-msg pending inbox --lead <name>` lists
unconsumed messages in the lead inbox. `shop-msg consume inbox --lead
<name> --work-id <id>` marks a message consumed.

The lead shop no longer needs to know which BC's outbox to poll; it
reads its own inbox and all BC responses are there.

**What the PO does not commit:** the physical storage mechanism (whether
the lead inbox is a row in a shared table keyed by `to` name, or a
separate table — the Architect picks after pre-state review). The PO
commits the behavioral surface: `read inbox --lead <name>`,
`pending inbox --lead <name>`, `consume inbox --lead <name>`.

### D — `from` and `to` fields on every message

Every message that passes through `shop-msg` carries:

- `from` — the canonical name of the sender (the shop calling
  `shop-msg send` or `shop-msg respond`).
- `to` — the canonical name of the recipient (the intended reader of
  the message).

Both fields are required. `shop-msg` validates their presence on send
and on receipt. A message without either field is rejected at send time
with a non-zero exit and a human-readable error naming the missing field.

The messaging BC adds `from` and `to` to all message schemas it owns
(assign_scenarios, request_bugfix, request_maintenance, clarify,
work_done, mechanism_observation). The fields are validated alongside
the existing required fields.

`shop-msg send` determines `from` from the caller's registered name
(the name under which the lead shop is registered in the registry).
`shop-msg respond` determines `from` from the BC's registered name.
Neither field requires the caller to pass it explicitly — `shop-msg`
injects both from registry state. (The Architect verifies whether this
injection requires a config file or a new flag at send time.)

### E — `shop-msg watch` by lead name

`shop-msg watch --lead <name>` watches the lead's inbox by name. It
fires one notification line to stdout when a new message arrives
addressed to the lead, regardless of which BC sent it.

The command no longer scans BC outboxes. Its watch target is the lead's
inbox. The startup drain behavior (draining messages present at startup
before entering live-notification mode) is preserved. The no-exit-on-
quiet-inbox behavior is preserved. The DB-unreachable fail-fast behavior
is preserved.

The `--lead-root` flag on `watch` is removed or deprecated per PDR-007.

---

## Out of scope — named explicitly

**Backward compatibility strategy for `--bc-root`/`--lead-root`.**
Whether to remove immediately or maintain a deprecation period is
PDR-007's decision. The PO commits the intent; the Architect determines
the migration approach.

**Message routing between BCs.** This brief covers lead-to-BC and
BC-to-lead messaging. BC-to-BC direct messaging (where neither party
is the lead) is not in scope. If BCs need to communicate directly, a
future brief covers that.

**DB schema design.** The exact table names, column names, and index
structure for the registry and lead inbox are the Architect's call after
pre-state verification. The PO commits behavioral contracts, not schema.

**Migration of existing messages in flight.** Messages currently sitting
in BC outboxes lack `from`/`to` fields. The migration approach (drop,
backfill, cut-over window) is the Architect's call.

**Lead shop appearing in the BC manifest.** The lead shop is NOT a BC
and does NOT appear in the manifest. Its registry entry is added via
`shop-msg registry add`.

---

## Sequencing

- **Brief 005 (BC manifest) is a prerequisite for scope A.** `shop-msg
  registry sync` reads the manifest. The manifest must exist before sync
  can work.
- **Scope A (registry) and B (name addressing) are the foundation** for
  C, D, and E. They must be substantially complete before the lead inbox,
  from/to fields, or watch update can be implemented correctly.
- **Scope C (lead inbox) and D (from/to fields) are co-dependent.** A
  lead inbox without from/to fields leaves the lead unable to identify
  the sender. From/to fields without a lead inbox leave messages with
  addresses that have no delivery target. Author and assign together.
- **Scope E (watch update) depends on C.** The watch command cannot
  watch the lead inbox until the lead inbox exists.

## Vehicle hints (Architect's call)

- Scope A (registry commands) and B (name addressing) are net-new
  capability in `shopsystem-messaging`. Vehicle: `assign_scenarios`.
- Scope C (lead inbox) requires storage changes and new CLI surface in
  `shopsystem-messaging`. Vehicle: `assign_scenarios`.
- Scope D (from/to fields) is net-new schema validation in
  `shopsystem-messaging`. Vehicle: `assign_scenarios`.
- Scope E (watch update) modifies existing behavior in
  `shopsystem-messaging`. Vehicle: TBD — if the existing watch
  scenarios pin the old behavior, this may be `request_bugfix` or a
  new `assign_scenarios` that supersedes them. Architect verifies.

## Grounding artifacts

- [brief 001](001-inter-shop-messaging-encapsulation.md) — the original
  messaging surface; `shop-msg` is its primary deliverable.
- [brief 004](004-bc-container-isolation.md) — BC containerization; the
  context in which path-based addressing becomes untenable.
- [brief 005](005-bc-manifest.md) — the BC manifest; prerequisite for
  registry sync.
- [PDR-006](../pdr/006-bc-manifest-ownership.md) — establishes
  `shopsystem-bc-launcher` as the manifest CLI owner; relevant because
  the registry sync reads the manifest that the bc-launcher manages.
- [PDR-007](../pdr/007-path-to-name-addressing-migration.md) — resolves
  the backward compatibility question for `--bc-root`/`--lead-root`.
