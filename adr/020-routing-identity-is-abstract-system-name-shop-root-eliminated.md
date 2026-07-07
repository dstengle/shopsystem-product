---
id: ADR-020
kind: adr
title: Routing identity is an abstract `<system>/<name>` address; `shop_root` is eliminated from the registry
status: accepted
date: "2026-06-02"
description: Routing identity is an abstract `<system>/<name>` address; `shop_root` is eliminated from the registry
beads: [lead-0217, lead-3lw6, lead-architect, lead-gf4h, lead-h1tw, lead-pw41]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-006, ADR-018, ADR-019]
  pins: [PDR-007]
  related: []
---
# ADR-020 — Routing identity is an abstract `<system>/<name>` address; `shop_root` is eliminated from the registry

**Status:** accepted (2026-06-02)
**Authors:** dstengle, Claude (lead-architect)
**Pins:** [PDR-007](../pdr/007-path-to-name-addressing-migration.md) — *"Shops are
addressed by canonical name, not by filesystem path."* This ADR completes PDR-007's
clean-break commitment by removing the last surviving filesystem-path coupling
(the registry's `shop_root` column and the `registry add` path argument).
**References:** [PDR-009](../pdr/009-implicit-cwd-shop-resolution.md) (implicit CWD
resolution — the name-derivation step that survives `shop_root` removal),
[PDR-010](../pdr/010-bd-authoritative-shop-msg-transport.md) (bd is authoritative
for state; shop-msg is transport — the substrate under the bd-cwd consequence).
**Anchored to:** [ADR-006](006-messaging-name-registry-design.md) (the registry
design this ADR amends), [ADR-018](018-empirical-verification-is-contract-surface.md)
(the artifact-surface evidence rule the pre-state findings honor),
[ADR-019](019-canonicalization-ownership-in-scenarios-bc.md) §"Open question — shop/BC
registry and addressing ownership" (this ADR partially resolves that deferral; see
"Relationship to the ADR-019 open question" below).
**Related beads:** `lead-h1tw` (this ADR's tracking bead, P1), `lead-0217`
(BC self-registers container path), `lead-3lw6` (registry-reset drift),
`lead-gf4h` (absent-path crash audit), `lead-pw41` (misdelivered to lead inbox).

---

## Context

PDR-007 (decided 2026-05-20) committed the invariant: *shops are addressed by
canonical name, not by filesystem path.* ADR-006 operationalized it by adding the
`shop-msg registry`, name-based `--bc`/`--lead` flags, and removing the
`--bc-root`/`--lead-root` CLI flags. PDR-009 extended addressing with an implicit
CWD walk-up that *derives* a canonical name from `.claude/shop/name.md`. PDR-010
made bd authoritative for state and reduced shop-msg to transport.

**The migration was completed at the CLI surface but not at the storage surface.**
The registry still stores a filesystem path as the routing/collision key, and the
`registry add` CLI still requires it. This residual path-as-identity coupling is
the root cause of a recurring class of routing failures.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

Verified from the lead CWD against the contract/artifact surface only — no BC code
read, run, or git-observed; the lead host carries no `repos/` BC source.

1. **`registry add` still takes a positional `shop_root` filesystem path.**
   `shop-msg registry add --help` (run from the installed `.venv`) reports:
   ```
   usage: shop-msg registry add [-h] [--lead-shop] name shop_root
     name         canonical shop name
     shop_root    filesystem path to the shop root directory
   ```
   The path is a required positional, not an optional field. **Confirmed.**

2. **`registry list` projects a path column.** `shop-msg registry list` emits
   three space-separated columns — `<name> <shop_root> <type>`:
   ```
   shopsystem-messaging /workspaces/shopsystem-product/repos/shopsystem-messaging bc
   shopsystem-product   /workspaces/shopsystem-product                            lead
   shopsystem-templates /workspaces/shopsystem-product/repos/shopsystem-templates bc
   ```
   The `shop_root` is a stored, mutable column. **Confirmed.** (Note: the
   `shopsystem-messaging` and `shopsystem-templates` paths point at
   `repos/<bc>` clones that do not exist on the lead host — see ADR-018 — yet
   delivery works because both lead-send and container-read resolve the *name* to
   the same registered key via shared postgres. The path is already functioning
   as nothing but an opaque key string; it is not consulted as a filesystem path
   for routing. This is the tell that `shop_root` is dead weight.)

3. **The migration's half-done state is pinned in scenario evidence**
   (`features/messaging-registry/`):
   - **11–14** — name addressing landed; `--bc-root`/`--lead-root` removed
     (scenario 13: "Using the removed `--bc-root` flag exits non-zero with a
     migration error message"). The *flags* are gone; the *stored path* is not.
   - **29–37** — cwd-walk-up identity resolution (PDR-009). Scenario 29 resolves
     a shop's identity to a canonical *name* + *type* by reading
     `.claude/shop/{name,type}.md` — identity already derives from CWD-local
     files, not from a registry path.
   - **45–47** — name-addressed ops and `registry add`/`list` explicitly *do not
     require `shop_root` to exist on the lead host* (scenario 45: send by `--bc`
     "succeeds when the registered BC's `shop_root` path does not exist on the
     lead host"; scenario 47: `registry add`/`list` accept a path that does not
     exist, with no staleness warning). These are **path-as-identity
     workarounds** — they exist only to neutralize the fact that a path is being
     stored when nothing routes by it.
   - **39–44** — tmp-path leak scrubbing (scenario 42: "no `shop_root` row for any
     production canonical name has a tmp_path-prefixed `shop_root`" after a pytest
     session). These are **symptom management** for a mutable path column that test
     sessions and re-registrations corrupt.

4. **The routing failures the path key produces are confirmed in beads:**
   - **`lead-0217`** — a BC running `shop-msg send`/`respond` from inside its
     container (`cwd=/workspace`) had the cwd-walk-up resolver derive its name
     and re-`registry add` against `/workspace`, overwriting the canonical
     lead-host entry. Outbox rows then split across `bc=/workspace` and the
     canonical key; `read outbox --work-id …` failed with
     "no outbox response found … in bc=/workspace".
   - **`lead-pw41`** (closed) — `request_bugfix` to `shopsystem-messaging` was
     keyed to the **lead's own** root (`/workspaces/shopsystem-product`) because
     the messaging entry's path had flipped to collide with the lead's path; the
     message landed in the lead's inbox and never reached messaging. The bead's
     note records the messaging root observed flipping `/workspace` →
     `/workspaces/shopsystem-product` between consecutive `registry list` calls —
     **actively unstable**. The note states explicitly: *"Inbox is keyed by the
     REGISTERED ROOT STRING."*
   - **`lead-gf4h`** — `shop-msg respond` / `pending inbox` crashed with
     `FileNotFoundError`/`NotADirectoryError` when `shop_root` pointed at a
     nonexistent path (bd-facade scoping its cwd to the registry path). Centrally
     hardened to degrade rather than crash, but the path-scoping audit remains
     open because the path is still there to scope to.

These are not three bugs; they are one root cause — **a mutable filesystem path
serving as the routing/collision key** — surfacing as drift, misdelivery, and
crashes.

---

## Decision

### D1 — Routing identity is an abstract `<system>/<name>` address

The messaging registry's routing/collision key becomes an abstract, location-independent
address of the form:

```
<system>/<name>
```

**Grammar:**

- **`<system>`** — the product/network name: the slug identifying the shop-system
  deployment all participating shops share. For the current deployment this is
  `shopsystem`. It is the namespace under which a `<name>` is unique. (One postgres
  registry/mailbox serves one `<system>`; the `<system>` segment makes the address
  self-describing and forward-compatible with multiple deployments sharing storage,
  without committing to that now.)
- **`<name>`** — the shop's canonical name within the system. For a BC this is the
  BC canonical name (slug form, matching `.claude/shop/name.md` slugified, per
  ADR-006 §4 and the slug-source-of-truth discipline). For the lead shop, `<name>`
  is the canonical lead sentinel `lead` — **not** the lead's product slug. The lead
  is *the* lead of its `<system>`; addressing it as `<system>/lead` removes the
  collision class where a BC's path-key coincided with the lead's product-slug key
  (the `lead-pw41` misdelivery).
- **Separator** — a single `/`. `<system>` and `<name>` are each non-empty slugs
  (`[a-z0-9][a-z0-9-]*`); `/` does not appear within either segment, so the address
  parses unambiguously on the first `/`.

**Canonical addresses for the current deployment:**

| shop                     | address                  |
| ------------------------ | ------------------------ |
| messaging BC             | `shopsystem/messaging`   |
| templates BC             | `shopsystem/templates`   |
| scenarios BC             | `shopsystem/scenarios`   |
| docs BC                  | `shopsystem/docs`        |
| lead shop                | `shopsystem/lead`        |

The address is the postgres mailbox key. Inbox/outbox rows are keyed by the abstract
`<system>/<name>` of the recipient (`to`) and stamped with the abstract address of
the sender (`from`), replacing ADR-006 §5's name string and §4's path-string key
with a single, stable, location-independent identifier. `shop-msg` resolves an
explicit `--bc <name>` / `--lead <name>` flag (or a CWD-derived name per PDR-009) to
its `<system>/<name>` address through the registry; the `<system>` segment is
supplied by the registry entry (or, in the bootstrap case, defaults to the single
deployment's `<system>` slug).

### D2 — `shop_root` is removed from the registry schema and the CLI

`shop_root` is **eliminated**, not demoted to optional. Concretely:

- The `shop_registry` table drops its `shop_root` column. The registry stores
  `<system>`, `<name>`, and `shop_type` (bc | lead) — no filesystem path.
- `shop-msg registry add` drops the `shop_root` positional argument. Its signature
  becomes `registry add [--lead-shop] <name>` (the `<system>` is the deployment's
  configured system slug; `--lead-shop` continues to set `shop_type=lead` and binds
  `<name>` to the `lead` sentinel).
- `shop-msg registry list` drops the path column. It emits `<system>/<name> <type>`
  (or `<name> <type>` within a single-system deployment) — no path.

The path-as-identity **workaround** scenarios (45–47) and the tmp-path **scrubbing**
scenarios (39–44) lose their reason to exist: there is no path to be absent, stale,
or tmp-leaked. The PO retires or rewrites them when authoring the completing
scenarios (see Consequences). This ADR does not author scenarios.

### D3 — bd's working directory derives from the local invoking CWD, not the registry

With `shop_root` gone, bd's working directory is **not** read from the registry.
Per PDR-009 (implicit CWD resolution) and PDR-010 (bd authoritative; shop-msg is
transport), a `shop-msg` invocation that needs a bd context uses the **local
invoking CWD** — the same CWD walk-up that resolves `.claude/shop/{name,type}.md`
and that bd itself uses to discover `.beads/`. bd state is local to where the
command runs; shop-msg never projects a stored path into a bd cwd.

This is the structural fix for the **`lead-gf4h` crash class**: there is no
registry `shop_root` for a bd-facade call to scope its cwd to, so there is no
absent/nonexistent-path to crash on. The crash was a symptom of scoping bd's cwd to
a registry-stored path; removing the stored path removes the scoping site. The
hardening recorded under `lead-gf4h` (degrade rather than crash) is superseded by
the removal of the path it hardened against.

---

## What this subsumes / fixes

| bead         | failure                                                              | how D1–D3 fix it                                                                                                                                  |
| ------------ | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lead-0217`  | BC self-registers container path (`/workspace`), overwriting key    | There is no path to write. A BC's CWD walk-up derives only a *name* (PDR-009); the abstract address is registry-resolved and not re-derived from container CWD. The registry is read-only from a non-lead shop (ADR-006 §2 writer rule preserved). |
| `lead-3lw6`  | registry-reset drift; path column churns                            | The removed `shop_root` is the column that drifted on re-registration; an abstract address has no per-host mutable component to drift. (The `SHOPMSG_DSN`-unset half of `lead-3lw6` is environment plumbing, out of this ADR's scope; named, not closed.) |
| `lead-gf4h`  | absent-path `FileNotFoundError` crash in bd-facade                  | D3 — bd cwd derives from local invoking CWD, not a registry path; no stored path to scope to, no absent path to crash on.                          |
| `lead-pw41`  | lead→BC message misdelivered to the lead's own inbox (path collision) | D1 — the lead is addressed as `<system>/lead`, a distinct sentinel that cannot collide with any BC's `<system>/<name>`; a BC's key can no longer coincide with the lead's product-slug path-key. |

---

## Migration / back-compat

Existing path-keyed mailbox rows and registry entries must migrate to the abstract
key. The ADR commits the *shape* of the migration; the executing BC owns the
realization detail:

1. **Registry entries.** For each existing `shop_registry` row, the canonical
   `<name>` is already present (it is the addressing key callers use today). The
   migration maps each row to `<system>/<name>` — `<system>` = the deployment's
   configured system slug (`shopsystem`); `<name>` = the existing canonical name,
   except the lead entry, whose `<name>` becomes the `lead` sentinel (currently
   stored under the product slug `shopsystem-product`). The `shop_root` column is
   dropped after the address column is populated.
2. **Mailbox rows.** Existing inbox/outbox rows are keyed today by the registered
   key string (per `lead-pw41`'s note, the *root string*, which in practice equals
   the registered name's resolved key). The migration rewrites `from`/`to` keys to
   the corresponding `<system>/<name>` address via the same name→address mapping
   used for registry entries. Rows whose key cannot be mapped to a known canonical
   name (e.g. the `/workspace` and tmp-path orphans from `lead-0217`/`lead-3lw6`)
   are **dropped or quarantined** — they are precisely the corrupted rows the
   scrubbing scenarios (39–44) existed to manage, and they have no valid recipient
   under the abstract scheme.
3. **One-shot, no dual-key window.** Consistent with PDR-007's clean-break
   rationale (Option A), the migration is a single forward step: the schema migration
   adds the address column, backfills it, drops `shop_root`, and the CLI ships
   without the path argument in the same change. No parallel path-keyed and
   address-keyed resolution coexist — two resolution paths are the complexity
   PDR-007 rejected.

The exact DDL, the migration ordering against in-flight rows, and the
drop-vs-quarantine policy for orphan rows are realization details for the executing
BC's scenarios; this ADR does not leave them silent but does not over-specify them.

---

## Cross-BC ownership / decomposition

- **The registry implementation lives in `shopsystem-messaging`.** Per ADR-006 the
  registry is a postgres table in shop-msg's storage layer and the `registry`
  command surface is shop-msg's. The schema change (drop `shop_root`, add the
  abstract address key), the `registry add`/`list` CLI change, the `from`/`to`
  keying change (ADR-006 §5), and the migration all target **`shopsystem-messaging`**.
- **`shopsystem-templates`** owns the prose surfaces that reference the old shape:
  the lead CLAUDE.md, the lead-po/lead-architect/bc role templates, and the BC
  primer all describe addressing and (in places) `registry add <name> <path>`. The
  PO/Architect follow-up that completes the migration includes a templates-BC update
  (the same caller-update commitment PDR-007 §"Migration commitment" already
  established for the flag removal).
- **Decomposition target for scenarios:** the behavioral scenarios that complete
  this migration are authored by the PO against **`shopsystem-messaging`** (registry
  schema/CLI/keying) with a companion **`shopsystem-templates`** caller-update. This
  ADR does not author or dispatch them.
- **Sequencing vs. readiness work.** `features/bc-launcher/32-35` (BC readiness)
  sits on top of this addressing layer — a BC is "ready" only once it is routable,
  and routability is exactly what the abstract address provides. **Recommendation:
  the addressing change (this ADR's scenarios) lands first**, before the
  bc-launcher readiness scenarios consume it, so readiness is defined against the
  stable abstract address rather than the path-keyed scheme it replaces.

---

## Relationship to the ADR-019 open question

ADR-019 recorded — and explicitly deferred — an open question on *"which BC owns the
registry and addressing contract, whether registry state belongs with messaging or a
separate addressing concern, and whether any structural split is warranted,"* citing
the same drift symptoms (registry came up without the dispatch target; `SHOPMSG_DSN`
unset; slug-vs-display mismatch).

This ADR **partially resolves** that open question and **carries the remainder**:

- **Resolved:** the *addressing model* — routing identity is the abstract
  `<system>/<name>` address (D1), and the registry stores no filesystem path (D2).
  The drift symptoms ADR-019 logged (`lead-3lw6` re-registration drift; the path
  column churning) are root-caused and fixed here for the path axis.
- **Carried (not decided here):** the *ownership/structural-split* axis — whether
  registry/addressing remains inside `shopsystem-messaging` (this ADR assumes it
  does, per ADR-006, and targets messaging accordingly) or is eventually factored
  into a separate addressing concern. This ADR does **not** mandate a split; it
  decides the model while leaving the BC-boundary question where ADR-019 left it.
  Two ADR-019 symptoms remain outside this ADR's scope and stay open on their own
  beads: `SHOPMSG_DSN`-unset environment plumbing (`lead-3lw6` second half) and the
  slug-vs-display-form `name.md` mismatch (`lead-ykq2`/`lead-3lw6`).

---

## Alternatives considered

**Option A — Demote `shop_root` to an optional non-identity field (bd-cwd hint).**
Rejected per stakeholder direction (dave, 2026-06-02). Keeping the column "for bd
cwd" preserves the exact mutable-path-as-state surface that drifts (`lead-3lw6`),
gets self-overwritten from a container (`lead-0217`), and crashes when absent
(`lead-gf4h`). PDR-009/PDR-010 already make bd's cwd a *local-CWD* derivation, so a
stored path is not needed for bd; an optional field that nothing authoritative reads
is dead weight that invites the next drift. Removal is the only state that closes the
class.

**Option B — Keep the canonical name as the bare key (no `<system>` segment).** This
is essentially the status quo's *intended* key (name only). Rejected as the recorded
identity grammar because a bare name leaves the lead/BC collision class latent: the
lead's product-slug name and a BC's name live in one flat namespace, and the
`lead-pw41` misdelivery showed a key collision routing a BC message to the lead. The
`<system>/<name>` form makes `<system>/lead` a structurally distinct sentinel and
namespaces every shop, at near-zero cost (one slug segment). It also forward-fits a
future multi-deployment shared-storage scenario without a schema change. (Within a
single deployment, the CLI may still *display* the bare `<name>`; the *stored key* is
the full address.)

**Option C — Per-shop registry isolation (each BC uses its own container postgres).**
Named in `lead-0217` cure (b). Rejected for this ADR as a larger architectural lift
orthogonal to the identity model: it changes *where* the registry lives, not *what
the key is*. The abstract-address decision is the smaller, root-cause fix and does
not preclude per-shop isolation later; it makes isolation cleaner if pursued (the key
is location-independent regardless of which postgres holds it).

---

## Consequences

- An `assign_scenarios` (registry schema/CLI is gaining new *behavior* — an abstract
  address key the registry has never stored — so the discriminator points at
  `assign_scenarios`, not `request_bugfix`; the PO/Architect confirm the vehicle at
  dispatch time per the message-type discriminator) to **`shopsystem-messaging`**
  carries: drop `shop_root`, store/key by `<system>/<name>`, update
  `registry add`/`list`, key mailbox `from`/`to` by the abstract address, and the
  one-shot migration of existing rows. A companion caller-update to
  **`shopsystem-templates`** revises the CLAUDE.md / templates / primer references.
- Scenarios 45–47 (path-absent workarounds) and 39–44 (tmp-path scrubbing) lose
  their subject and are retired or rewritten by the PO as part of the completing
  scenario set; the dispatch enumerates their `@scenario_hash` set for retirement
  (Architect's §"conflicting hash enumeration" duty at dispatch time — not done in
  this ADR).
- `lead-0217`, `lead-3lw6` (path axis), `lead-gf4h`, and the `lead-pw41` misdelivery
  class are subsumed by D1–D3 and close when the scenarios land.
- PDR-007 is completed: with `shop_root` gone from storage and CLI, no filesystem
  path participates in routing identity anywhere in the system.
- The ADR-019 registry/addressing open question is reduced to its ownership/split
  axis only; the addressing-model axis is decided here.
- `features/bc-launcher/32-35` readiness work is recommended to land *after* this
  addressing change so readiness is defined against the stable abstract address.

---

## Cross-references

- [PDR-007](../pdr/007-path-to-name-addressing-migration.md) — name-based addressing
  clean break; this ADR completes it by removing the residual stored path.
- [PDR-009](../pdr/009-implicit-cwd-shop-resolution.md) — CWD walk-up name
  derivation; the surviving identity-from-local-context mechanism.
- [PDR-010](../pdr/010-bd-authoritative-shop-msg-transport.md) — bd authoritative,
  shop-msg is transport; the substrate for the D3 bd-cwd consequence.
- [ADR-006](006-messaging-name-registry-design.md) — the registry design this ADR
  amends (§4 keying, §5 `from`/`to` fields).
- [ADR-018](018-empirical-verification-is-contract-surface.md) — the artifact-surface
  evidence rule the pre-state findings honor.
- [ADR-019](019-canonicalization-ownership-in-scenarios-bc.md) — the deferred
  registry/addressing open question this ADR partially resolves and partially carries.
- `features/messaging-registry/` scenarios 11–14, 29–37, 39–47 — the half-done
  migration's contract-surface evidence.
