# ADR-023 — The scenario-completion journal is decomposed `scenarios`(KEY) + `messaging`(BC journal store + pull vehicle) + lead-facing snapshot/view on `shop-msg`; incremental and on-demand paths are kept SEPARATE over a shared store

**Status:** proposed (2026-06-08)
**Authors:** dstengle, Claude (lead-architect)
**Pins (the contract surface this rests on):**
[ADR-019 D1](019-canonicalization-ownership-in-scenarios-bc.md) — the
block-only canonical hash is owned by `shopsystem-scenarios` and is the
journal's identity key; and
[scenario 117](../features/templates/117-canonical-scenario-hash-canonicalization-is-scenario-block-only-not-feature-line-included.gherkin)
— exactly one canonical hash text per scenario block. This ADR decomposes
the seven `features/scenario-journal/` scenarios (01–07, all hash-verified
below) across BCs; it does not retire any BC-side pinned `@scenario_hash`
coverage.
**Anchored to:** [ADR-018](018-empirical-verification-is-contract-surface.md)
(the artifact-surface evidence rule the pre-state findings honor — every
finding below is from the lead-held `features/`, the installed `scenarios`/
`shop-msg` contract tools, the catalog schema, and `shop-msg` registry/
heartbeat state; no `repos/` BC source, which the lead host does not carry);
[brief 009](../briefs/009-scenario-completion-journal-and-system-state-snapshot.md)
and [PDR-015](../pdr/015-scenario-completion-journal-solution-space.md) (the
authored intent and pre-weighted trade-off this ADR's decomposition serves).
**Related beads:** `lead-5p07` (umbrella feature), `lead-onfq` (scenarios
KEY + enumeration unit), `lead-9b3w` (messaging BC journal store + pull
vehicle unit), `lead-if3j` (lead-facing snapshot + system-state-view unit);
`lead-ji28` (in_progress) and `lead-gw60` (open) — the hash-divergence
defect class scenario 07's orphan-flag doubles as a detector for.

---

## Context

Brief 009 / PDR-015 commit the MVP intent: make per-scenario completion a
durable, queryable fact — a BC-authoritative append-only journal keyed on
the block-only canonical hash, mirrored as a lead-side snapshot — so that
"is this scenario done?" and "what is outstanding system-wide?" are lookups,
not the per-`work_done` reconciliation sweep they are today. The stakeholder
fixed four decisions (completed = pinned & demonstrated; denominator = ALL
`features/` scenarios incl. never-dispatched; BC-authoritative journal +
lead snapshot; prefer lightweight unification of incremental + on-demand
ONLY if cheap) and one sub-decision (orphan completions are flagged, not
counted — option A). The brief/PDR deliberately leave the **decomposition,
the store design, the journal-pull vehicle, and the path-unification call**
to the Architect, made after empirical pre-state. This ADR records those
structural calls.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

Verified from the lead CWD on 2026-06-08 against the lead-held `features/`,
the installed `scenarios`/`shop-msg` contract tools, the `catalog` schema
package, and `shop-msg` registry/heartbeat state. No BC implementation read,
run, or git-observed; the lead host carries no `repos/` BC source.

1. **No journal / snapshot / completion-state / outstanding capability
   exists anywhere on the contract surface today. CONFIRMED.**
   - `grep -rl "journal\|completion\|snapshot" features/` returns only the
     seven net-new `features/scenario-journal/` files this feature authors —
     no pre-existing pinned coverage.
   - `shop-msg --help`: subcommands are `respond, send, nudge, read,
     pending, consume, sweep, promote, prime, dump, watch, bc-status,
     registry`. **No** `journal`, `snapshot`, `outstanding`, `coverage`, or
     `system-state` surface.
   - `scenarios --help`: subcommands are `hash, verify, list, count, titles,
     tags`. It can enumerate scenarios in a feature file (`list`/`titles`)
     and compute the block-only hash (`hash`), but holds **no** completion
     state and **no** features-tree-wide outstanding enumeration.
   This is the load-bearing Q1 fact: the journal/snapshot/lookup/outstanding
   capability is **genuinely new** — not an unpinned existing behavior.

2. **The incremental-reflect feedstock ALREADY exists in the message
   schema. CONFIRMED.** `catalog.schemas.WorkDone` (the messaging catalog,
   verified via `WorkDone.model_fields`) carries
   `scenario_hashes: list[str]` — the list of completed block-only hashes a
   BC reports on `work_done`. `shop_msg/cli.py:562` populates it from
   `--scenario-hash`. **The lead already receives, per `work_done`, exactly
   the hashes the incremental snapshot (scenario 04) reflects.** This means
   scenario 04 builds a *consumer/materializer* over an existing wire field;
   it does **not** require a schema change to `work_done`. (There is also a
   bd-side `scenario_hashes_pinned` metadata key, `bd_facade.py:42` — a
   parallel signal, not the journal.)

3. **The block-only hash — the journal KEY — is correctly owned by
   `scenarios` and the ADR-019 wire/disk divergence defects are now FIXED in
   the installed `shop-msg`. CONFIRMED.** All seven journal scenarios are
   keyed on the block-only canonical hash. The installed `scenarios.hash`
   produces it, and ADR-019's two defects are resolved in the installed CLI:
   - defect (b) shell-out → `shop_msg/cli.py:107`
     `from scenarios.hash import compute_scenario_hash`, in-process
     (`cli.py:418`).
   - defect (a) Feature-line wrap → `shop_msg/cli.py:965-968`
     `_build_scenario_payload` now builds a **scenario-block-only**
     `sentinel_block` (no `Feature:` line) and hashes that.
   This matters two ways: (i) the journal key is stable and single-sourced,
   so keying the journal on it is sound; (ii) `lead-gw60` (the open
   reconciliation-gap bead asserting defect (a)'s construction-site fix was
   *unverified*) is now empirically verifiable as fixed on the installed
   surface — but it is **still OPEN**, so until it closes the orphan-flag
   (scenario 07) retains its detector value (see Decision D5).

4. **The seven `features/scenario-journal/` scenarios are all hash-pinned
   and every tag matches `scenarios hash`. CONFIRMED.** Verified by piping
   each file through the installed `scenarios hash` contract tool (the
   admissible "run" per ADR-018 D2):

   | file | `@scenario_hash:` tag | `scenarios hash` | match |
   | ---- | --------------------- | ---------------- | ----- |
   | 01-completion-lookup-yes | `1b21dbb923413455` | `1b21dbb923413455` | ✓ |
   | 02-completion-lookup-no | `528c08b5a0a6d024` | `528c08b5a0a6d024` | ✓ |
   | 03-bc-records-completion-in-journal | `d01313bf5090bee6` | `d01313bf5090bee6` | ✓ |
   | 04-lead-snapshot-reflects-completion | `307967ddfb53fc45` | `307967ddfb53fc45` | ✓ |
   | 05-lead-reconciles-against-bc-journal-on-demand | `d0a74c6e8ecb8eb3` | `d0a74c6e8ecb8eb3` | ✓ |
   | 06-outstanding-counts-never-dispatched | `f58a7dc39c4e718a` | `f58a7dc39c4e718a` | ✓ |
   | 07-orphan-completion-flagged-as-anomaly | `03a396b8dc08041e` | `03a396b8dc08041e` | ✓ |

5. **@scenario_hash retirement enumeration (the message-type / supersession
   pre-state step). CONFIRMED — empty.** This feature is purely additive: it
   introduces no scenario that retires, supersedes, or contradicts any
   prior BC-side pinned `@scenario_hash` coverage. `grep -r "@scenario_hash"
   features/scenario-journal/` is exactly the seven new hashes in finding 4;
   none of them is a re-author of an existing pinned scenario. **There is no
   conflicting BC `@scenario_hash` set to enumerate or retire** in any of the
   three dispatches this ADR plans.

6. **Target-BC presence (registry + heartbeat). CONFIRMED.** `shop-msg
   registry list` routes `shopsystem-scenarios`, `shopsystem-messaging`,
   `shopsystem-bc-launcher`, `shopsystem-templates` (and the lead
   `shopsystem-product`). `shop-msg bc-status` reports **all four BCs
   `offline`** as of 2026-06-08 — every target needs bring-up before its
   dispatch can be worked. This is a dispatch-time operational fact, not a
   decomposition blocker.

### What could NOT be verified (asserted, not confirmed)

- **The exact store shape inside each BC** (a DB table vs. an appended file
  vs. a `scenarios`-owned artifact) is BC-internal implementation, off the
  lead artifact surface. This ADR assigns *ownership and behavior*; the BC
  Implementer picks the store mechanism under its own architect.
- **Whether any BC currently persists completed hashes anywhere the lead
  could already read.** No such surface exists in the contract tools or the
  schema (finding 1/2); a hidden BC-internal store would be off-surface and,
  per ADR-018, not admissible — the journal capability is treated as new.

---

## Decision

### D1 — `shopsystem-scenarios` owns the journal KEY and the outstanding-denominator enumeration primitive

The journal/lookup identity is the **block-only canonical hash**, already
owned by `scenarios` (ADR-019 D1, finding 3). `scenarios` additionally owns
the **enumeration of all canonical scenarios under a `features/` tree** — it
already walks feature files (`list`/`titles`/`count`) and is the only BC
whose charter is "what a scenario is." The outstanding denominator
(decision #2: ALL `features/` scenarios incl. never-dispatched, scenario 06)
is computed from that enumeration cross-referenced against the completion
set. The enumeration primitive (the *source* of the denominator) is a
`scenarios` concern; **where** the outstanding view is finally rendered is a
lead-facing concern (D3). This is the `lead-onfq` unit, carrying scenario 06
as its enumeration-source primitive.

### D2 — `shopsystem-messaging` owns the BC-authoritative append-only journal store AND the on-demand journal-pull request/response vehicle

The BC-side journal (scenario 03) is an **append-only store of completed
block-only hashes per BC**, and the lead's on-demand reconcile (scenario 05)
needs a **transport vehicle to request a BC's journal and receive it.**
Both are messaging's territory: messaging owns the inter-shop transport and
the `shop-msg` CLI, and the journal store is naturally co-located with the
`work_done` ingest path that already carries `scenario_hashes` (finding 2).
The pull vehicle is a **new request/response pair on `shop-msg`** (a new
message-type or a new `shop-msg` subcommand surface — the BC Implementer's
structural call within messaging). This is the `lead-9b3w` unit, carrying
scenario 03 (BC append-only record) and scenario 05's BC side (serve the
journal on demand).

Rationale for messaging over scenarios here: the journal is *transported
content keyed by* the scenarios-owned hash — the same split ADR-019/ADR-006
§5 already drew (messaging transports a `ScenarioPayload` whose canonical
identity scenarios owns). The journal is "completion records moving across
shops," which is transport, not "what a scenario is."

### D3 — The lead-facing snapshot store and the system-state-view CLI ship as new `shop-msg` subcommands

The lead snapshot and the system-state view (atomic lookup 01/02,
incremental reflect 04, on-demand reconcile 05's lead side, orphan-flag 07)
are **lead-facing tooling**, and the lead-facing CLI surface today *is*
`shop-msg` — `prime`, `pending`, `bc-status`, `read`, `consume` all live
there and are how the lead already inspects system state. Adding the
snapshot store + `shop-msg`-namespace view commands (e.g. a `shop-msg
journal`/`shop-msg coverage` family) puts the lookup where the lead already
looks, reuses the `work_done` ingest path (finding 2) for the incremental
mirror, and reuses the D2 pull vehicle for on-demand reconcile. This is the
`lead-if3j` unit. It is therefore **`shopsystem-messaging` work as well** —
but only in the sense of **which BC ships the CLI code**.

**Code-ownership vs data-residence (resolving the flagged ambiguity, per
stakeholder decision #3).** The snapshot is **lead-owned state**: the lead
"keeps a snapshot that *it* keeps up to date" and rebuilds it from the
authoritative BC journals on agent-failure recovery (decision #3, secondary
job a). The snapshot data is therefore **lead-resident** — it lives in the
lead's own `shop-msg` store (the lead-host / lead-owned side of the existing
`shop-msg` state, the same place `pending`/`consume`/registry state the lead
already owns lives), **NOT inside any BC container's filesystem.**
`shopsystem-messaging` *ships the `shop-msg` subcommands* (the CLI code) that
maintain it — exactly as it already ships `shop-msg pending`/`bc-status`,
which run lead-side over lead-owned state. The incremental feed has no
cross-BC hop because the `work_done` ingest and the snapshot-maintaining
subcommands are the same messaging-shipped toolchain running on the lead
host — not because the snapshot lives in a BC. This keeps the BC journals
authoritative (the source) and the lead snapshot a lead-owned, always-
rebuildable mirror (the view), per ADR-018's "the BC demonstrates, the lead
reconciles" posture. The exact lead-side store shape (a lead-owned table vs
a local file) is off-surface implementation, the Implementer's call.

A separate "lead-tooling BC" was considered and rejected (Alternative
C): there is no such BC, and standing one up to host four subcommands the
existing `shop-msg` surface naturally absorbs is unjustified.

### D4 — Incremental-reflect (C1) and on-demand-reconcile (C2) are kept SEPARATE over ONE shared snapshot store — NOT unified into one code path

PDR-015 §4 records the stakeholder's pre-weighted steer: prefer a
lightweight unification of incremental (scenario 04) and on-demand
(scenario 05) **only if it does not add heavy complexity/resource cost;
otherwise keep them separate.** The Architect's call, made against pre-state:

**Keep the two *paths* separate; share the *store*, not the *code path*.**
The two paths have genuinely different triggers and costs — C1 is an
event-driven single-hash upsert off a `work_done` the lead already receives
(finding 2: cheap, continuous, no network round-trip); C2 is an operator-/
recovery-triggered full pull of a BC journal over the D2 vehicle (heavier,
per-invocation, networked). Collapsing them into one "reconcile" entry point
would force the cheap incremental case to carry the on-demand path's
machinery (a pull, a diff, an entry-by-entry match — scenario 05's `Then`),
which is exactly the "heavy complexity/resource cost" the steer guards
against. **But** both write to and read from **one** snapshot store keyed on
the block-only hash, so they do not diverge into two materialized views.
This satisfies the steer's *intent* (no duplicate snapshot state; the cheap
path stays cheap) while declining the literal single-code-path unification
as not-lightweight. The unification is therefore **deferred, not adopted** —
revisitable if the two paths later prove to share more than the store.

### D5 — The orphan-flag (scenario 07) is the chosen anomaly posture AND a deliberate detector for the `lead-ji28`/`lead-gw60` divergence class

Per the resolved scope sub-decision (option A, brief 009): a BC-journaled
completion whose block-only hash is absent from any `@scenario_hash:` tag
under the lead's canonical `features/` is **flagged as an unrecognized
orphan anomaly, excluded from both the coverage count and the outstanding
denominator** (scenario 07) — never silently counted, never first-class.
The rationale is empirical and recorded so it is not re-litigated: canonical
hashes are content-addressed and retire-and-replace (scenario 117-D/E), so
an absent-from-canonical completed hash is not a legitimate steady state —
it can only arise from (i) the wire/disk divergence defect (`lead-ji28`
in_progress, `lead-gw60` open), (ii) transient version-lag, or (iii) a
BC-local never-promoted scenario. Finding 3 shows the divergence defect is
*now fixed on the installed surface*, but `lead-gw60` remains **open**;
until it closes a flagged orphan may *be* that known defect — which is the
**desired surfacing**, not a contradiction. The orphan-flag is thus a free,
standing detector for that class. This decision **does not** reopen the
denominator (D1); it is a boundary of it.

---

## Cross-BC ownership / decomposition + ordering

| unit (bead) | owning BC | scenarios | message type | depends on |
| ----------- | --------- | --------- | ------------ | ---------- |
| `lead-onfq` | `shopsystem-scenarios` | 06 (enumeration source) | `assign_scenarios` | — (ready) |
| `lead-9b3w` | `shopsystem-messaging` | 03, 05 (BC journal + pull) | `assign_scenarios` | `lead-onfq` |
| `lead-if3j` | `shopsystem-messaging` (lead-facing `shop-msg`) | 01, 02, 04, 05 (lead side), 07 | `assign_scenarios` | `lead-onfq`, `lead-9b3w` |

Ordering rationale (wired via `bd dep`, ADR-013): `lead-onfq` ships the
block-only-hash KEY and the enumeration primitive that the other two key on
and count over → it blocks both. `lead-9b3w` ships the BC journal + the pull
vehicle that the lead-facing on-demand reconcile (scenario 05) consumes → it
blocks `lead-if3j`. All three block the umbrella `lead-5p07`. Scenario 05 is
split: its BC-serve side is in `lead-9b3w`, its lead-reconcile side is in
`lead-if3j` (the lead pulls, the BC serves) — both dispatches reference the
same scenario hash `d0a74c6e8ecb8eb3`, which is intentional, not duplicated
pinning.

## Alternatives considered

**Option A — `scenarios` owns the journal store and the pull vehicle too
(one BC owns the whole feature).** Rejected. The journal is *completion
records moving across shops* — transport — not *what a scenario is*.
ADR-019/ADR-006 §5 already drew this line (messaging transports the
`ScenarioPayload`; scenarios owns its canonical identity). Putting a
cross-shop request/response vehicle and a per-BC journal store into the
zero-dependency `scenarios` leaf would inflate the leaf's contract surface
and re-couple transport into the domain. `scenarios` owns the **key** and
the **enumeration**; messaging owns the **records in motion**.

**Option B — Unify the incremental and on-demand paths into one "reconcile"
entry point (PDR-015 branch C3 taken literally).** Rejected for now (D4):
it forces the cheap event-driven incremental case to carry the heavier
pull-diff-match machinery — the exact complexity/resource cost the
stakeholder steer guards against. The *intent* of the steer (no duplicate
snapshot state) is met by sharing the store; the literal single-code-path
unification is deferred.

**Option C — Stand up a dedicated lead-tooling BC for the snapshot + view.**
Rejected (D3). No such BC exists, and the lead-facing CLI surface is already
`shop-msg`. Four new subcommands the existing surface naturally absorbs do
not justify a new BC, a new repo, a new bring-up, and a new cross-BC hop for
the incremental feed.

**Option D — Lead-authoritative ledger (PDR-015 branch B2).** Already
rejected upstream by stakeholder decision #3: agent-failure recovery
(secondary job a) requires the BC to be authoritative so the lead can
rebuild its snapshot from BC journals. Recorded here so it is not
re-litigated.

**Option E — Count orphan completions toward coverage (the rejected half of
the orphan sub-decision).** Rejected upstream (option A chosen): an
absent-from-canonical hash is not a legitimate steady state and counting it
would mask the `lead-ji28` divergence class instead of surfacing it (D5).

## Consequences

- Three additive `assign_scenarios` dispatches, no `request_bugfix`/
  `request_maintenance`: the journal/snapshot/lookup/outstanding capability
  is genuinely new on the contract surface (finding 1), so the discriminator
  resolves to `assign_scenarios` for every unit. No BC-side `@scenario_hash`
  retirement is implicated (finding 5).
- The incremental-reflect path is essentially free: `work_done` already
  carries `scenario_hashes` (finding 2), so scenario 04 is a materializer
  over an existing wire field — no `work_done` schema change.
- The snapshot is a mirror, always rebuildable from BC journals via the D2
  pull vehicle (scenario 05) — this is the primitive the deferred
  agent-failure-recovery workflow (secondary job a) will later build on.
- The orphan-flag (scenario 07) ships a standing detector for the
  `lead-ji28`/`lead-gw60` divergence class; until `lead-gw60` closes, a
  flagged orphan may be that defect — the intended surfacing (D5).
- All four target BCs are `offline` (finding 6); each needs bring-up before
  its dispatch is worked. The ordering (`onfq` → `9b3w` → `if3j`) means the
  scenarios BC is brought up and dispatched first.
- The C1/C2 path-unification question is deferred (D4), revisitable if the
  paths later share more than the store.

## Cross-references

- [brief 009](../briefs/009-scenario-completion-journal-and-system-state-snapshot.md)
  / [PDR-015](../pdr/015-scenario-completion-journal-solution-space.md) — the
  authored intent, four decisions, and the pre-weighted C1/C2 trade-off this
  ADR's D4 resolves.
- [ADR-019](019-canonicalization-ownership-in-scenarios-bc.md) — the
  block-only-hash ownership (D1) that makes the journal key sound; its
  defects (a)/(b) are now fixed on the installed surface (finding 3).
- [ADR-018](018-empirical-verification-is-contract-surface.md) — the
  artifact-surface evidence rule the pre-state findings honor.
- [ADR-006 §5](006-messaging-name-registry-design.md) — messaging transports
  value objects keyed by scenarios-owned identity; the split D2 extends.
- [ADR-013](013-dispatch-dependencies-via-bd-dep.md) — the `bd dep` dispatch
  ordering this ADR's unit graph uses.
- `features/scenario-journal/01–07` — the seven MVP scenarios, all
  hash-verified (finding 4).
- [lead-5p07](beads:lead-5p07) umbrella; [lead-onfq](beads:lead-onfq),
  [lead-9b3w](beads:lead-9b3w), [lead-if3j](beads:lead-if3j) units;
  [lead-ji28](beads:lead-ji28) / [lead-gw60](beads:lead-gw60) — the
  divergence class scenario 07's orphan-flag detects (D5).
