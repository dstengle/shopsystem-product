# ADR-006 — Messaging name registry design

**Status:** decided (2026-05-20)
**Authors:** dstengle, Claude (lead-architect)
**Anchored to:** brief 006 (messaging name registry and lead inbox);
PDR-007 (clean break on path-based addressing).

---

## Context

The shopsystem messaging layer currently uses filesystem paths as shop
addresses. Every `shop-msg` CLI invocation that targets a shop takes
`--bc-root <path>` or `--lead-root <path>`. This works only when the
caller and the BC share a filesystem. Brief 004 targets BC
containerization; in that world, `repos/shopsystem-messaging` is a path
that is meaningful only from the lead shop's host, or only if the lead
shop's filesystem is bind-mounted into every BC container. That assumption
cannot hold.

Two structural gaps compound this:

1. **No stable addresses.** Every CLI call encodes a path. Moving a BC,
   containerizing it, or running the lead shop from a different directory
   invalidates every call.
2. **No lead inbox.** The lead shop is not a named participant in its own
   messaging system. It polls each BC's outbox — an inherently
   path-dependent operation.

Both gaps share a root cause: the messaging layer treats addresses as
filesystem paths rather than as opaque names the system resolves.

Pre-state empirical verification (2026-05-20):

- `shop-msg registry` does not exist. Running `shop-msg registry --help`
  exits 2 with "invalid choice: 'registry'".
- No `--bc` or `--lead` flag exists on any subcommand. Running
  `shop-msg send assign_scenarios --bc shopsystem-messaging ...` exits 2
  with "error: ambiguous option: --bc could match --bc-root, --bc-tag".
  Running `shop-msg read inbox --lead shopsystem-product ...` exits 2
  with "error: the following arguments are required: --bc-root".
- `--bc-root` and `--lead-root` exist and are the only addressing flags.
  `shop-msg watch` accepts `--lead-root` (verified: running
  `shop-msg watch --lead-root .` starts cleanly).
- No `from` or `to` fields exist on any message schema. The
  `catalog/schemas.py` models (`AssignScenarios`, `RequestBugfix`,
  `RequestMaintenance`, `Clarify`, `WorkDone`, `MechanismObservation`)
  carry `message_type` and `work_id` but no sender/recipient fields.
- No lead inbox exists. `shop-msg consume inbox` exits 2 with "invalid
  choice: inbox (choose from outbox)". `shop-msg pending inbox` requires
  `--bc-root` (BC-side only).
- `shop-msg watch --lead-root` currently scans BC outboxes (NOTIFY on
  `outbox_<bc_slug>` channels) — it does not watch a lead inbox.

---

## Decisions

### 1. The registry lives in PostgreSQL (same DB as message storage)

The registry is a table in the same PostgreSQL database that `shop-msg`
already uses for message storage. The storage layer (`storage.py`)
already owns the schema DDL (`_ensure_schema`) and the DSN
(`SHOPMSG_DSN`). Adding a `registry` table to the same DDL keeps the
resolution layer co-located with the messages it resolves, available to
every party on the shared Docker network, and managed by the same
connection and schema-migration mechanism.

**Rejected alternative — registry as a config file passed at
invocation.** A TOML or YAML file containing name→path mappings would
preserve path-based addressing under a thin naming veneer. Config files
are not shared across containers, are not updated atomically, and require
callers to know the file path. This fails the containerization goal.

**Rejected alternative — registry in a separate service.** A dedicated
registry service (HTTP API, etcd, Consul) would add an operational
dependency with no added capability for the current scale (a handful of
shops, single Docker Compose deployment). PostgreSQL is already running
and already required; co-locating avoids the dependency.

### 2. The lead shop is the authoritative writer for registry state

The lead shop calls `shop-msg registry add` for its own entry and
`shop-msg registry sync` to reconcile BC entries from the BC manifest.
No BC calls registry management commands. This preserves the lead shop's
role as the authoritative source of product topology.

**Registry command surface:**

- `shop-msg registry add <name>` — register a shop with connection
  information needed for `shop-msg` to route to it. Idempotent.
- `shop-msg registry remove <name>` — deregister. Idempotent (exits
  zero on unknown name with a notice).
- `shop-msg registry list` — list all registered shops, one per line,
  machine-readable.
- `shop-msg registry sync` — reconcile registry against the BC manifest:
  add missing entries, remove stale entries, leave the lead shop's own
  entry untouched.

### 3. Clean break on `--bc-root` / `--lead-root` (per PDR-007)

`--bc-root` and `--lead-root` are removed when name-based addressing
ships. Using a removed flag produces a non-zero exit and a clear error
naming the replacement flag. No deprecation period; no parallel paths.

Callers to update atomically with the CLI change: the lead shop CLAUDE.md,
lead-architect.md agent template, lead-po.md agent template, the BC
primer in `shopsystem-templates`, and any runbooks. All four file sets
are updated before or at the moment the new CLI ships (per PDR-007
migration commitment).

**Rejected alternative — deprecation period (Option B per PDR-007).**
Two resolution paths add implementation complexity for zero behavioral
benefit during the transition. Path-based addressing that continues to
work means containerization (brief 004) is incomplete until all callers
migrate. The clean break forces completion.

**Rejected alternative — alias accepting path-or-name (Option C per
PDR-007).** Heuristic detection of whether a value is a path or a name
introduces permanent ambiguity and contradicts the invariant that shops
are addressed by canonical name.

### 4. The lead shop is a named participant with a symmetric inbox

The lead shop has a registry entry (canonical name `shopsystem-product`,
the slug form of `shop/name.md`'s "shopsystem product"), an inbox in the
same storage layer as BC inboxes, and participates in every message's
`from`/`to` routing. BC responses go to the lead's inbox by name; the
lead reads one place rather than polling each BC's outbox.

The physical lead inbox is implemented as rows in the shared `messages`
table, keyed by `to` name. This is the Architect's call after pre-state
review: a separate table adds no behavioral capability and complicates
the query surface; a shared table with a `to` column covers both BC
inboxes and the lead inbox with a single schema migration.

**Rejected alternative — lead inbox as a separate table.** No behavioral
benefit. Adds a schema split that makes cross-shop queries harder.

### 5. `from` and `to` are required on every message

Every message schema in `catalog/schemas.py` gains `from_shop` and
`to_shop` fields (Python-safe names for the `from` / `to` concept; the
wire format uses `from` and `to`). Both are required; `shop-msg` validates
their presence at send and receive time. A message without either field
is rejected at send time with a non-zero exit naming the missing field.

`shop-msg send` determines `from` from the caller's registered name.
`shop-msg respond` determines `from` from the BC's registered name.
Neither field requires the caller to pass it explicitly — `shop-msg`
injects both from registry state at send time.

**Decision — sender identity.** The registered name is authoritative.
If the calling shop is not registered, `shop-msg send` exits non-zero
with an error naming the missing registry entry.

### 6. `shop-msg watch` watches the lead inbox (not BC outboxes)

`shop-msg watch --lead <name>` replaces `shop-msg watch --lead-root`.
It watches the lead's inbox for messages addressed to the lead — a
single LISTEN channel rather than one channel per BC outbox. This
eliminates the O(N BCs) LISTEN fan-out and removes the requirement for
the lead shop to enumerate sibling BC clones.

The five scenarios pinned in `watch.feature`
(`@scenario_hash:bb47cfb8520284e9`, `6b5910b7b30777d8`,
`ff1a4eb2f35f4ff5`, `772b41c106385041`, `dd52b41c28f2ab14`) cover the
BC-side `--bc-root` inbox watch mode. These remain valid and unchanged.

The three scenarios in `outbox_notify_and_watch_lead_root.feature`
(`@scenario_hash:b4d0e28257f26985`, `3acbf477af0c3f0e`,
`b4083b5ff38638f7`) cover the `--lead-root` outbox watch mode. These
are superseded by the new `--lead <name>` inbox watch scenarios (brief
006 scope E, scenarios 24–28). The dispatch for scope E carries explicit
retirement instructions for these three hashes.

---

## Sequencing

- Brief 005 (BC manifest) is a prerequisite for `registry sync`.
- Scope A (registry) and B (name addressing) are dispatched together
  as a single `assign_scenarios` message (scenarios 01–14 + 15). These
  are the foundation for scope C, D, and E.
- Scope C (lead inbox), D (from/to fields), and E (watch update) are
  dispatched together as a second `assign_scenarios` message (scenarios
  15–28 minus scenario 15 which is covered in dispatch 1). C and D are
  co-dependent; E depends on C. Dispatching them together means the
  Implementer can sequence them in one implementation pass.

---

## Cross-references

- [brief 006](../briefs/006-messaging-name-registry-and-lead-inbox.md)
- [PDR-007](../pdr/007-path-to-name-addressing-migration.md) — clean break decision
- [brief 004](../briefs/004-bc-container-isolation.md) — containerization context
- [brief 005](../briefs/005-bc-manifest.md) — BC manifest (prerequisite for sync)
- [PDR-006](../pdr/006-bc-manifest-ownership.md) — manifest CLI ownership
