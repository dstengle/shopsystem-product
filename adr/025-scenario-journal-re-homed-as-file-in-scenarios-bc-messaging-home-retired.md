---
id: ADR-025
kind: adr
title: The scenario-completion journal is a FILE owned by `shopsystem-scenarios`; the message bus is not a store; the mis-homed `messaging` journal implementation is retired; sc04–07 are lead-side aggregate tooling
status: accepted
date: "2026-06-08"
description: Re-homes the completion journal as a FILE owned by shopsystem-scenarios; retires the mis-homed messaging journal; sc04-07 become lead-side aggregate tooling.
beads: [lead-7hsl, lead-9b3w, lead-9zx1, lead-architect, lead-facing, lead-h4q2, lead-held, lead-if3j, lead-lsbs]
edges:
  supersedes: [ADR-023, ADR-024]
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-018]
  pins: [ADR-019]
  related: []
---
# ADR-025 — The scenario-completion journal is a FILE owned by `shopsystem-scenarios`; the message bus is not a store; the mis-homed `messaging` journal implementation is retired; sc04–07 are lead-side aggregate tooling

**Status:** accepted (2026-06-08); **amended 2026-06-08** (D3 retirement set
corrected 4→7 pins — see "Amendment 2026-06-08" below)
**Authors:** dstengle, Claude (lead-architect)
**Supersedes:** [ADR-023](023-scenario-completion-journal-decomposition.md) **D2**
(messaging owns the BC-authoritative journal store) and **D3** (the lead snapshot /
system-state view ships as `shop-msg` subcommands over messaging-shipped state);
the **messaging-home parts of [ADR-024](024-journal-bootstrap-rebuild-rides-messaging-store-and-sc06-tightening-deferred.md)**
(D1: sc08 rebuild is an op ON the messaging-owned store). ADR-024 D2 (sc06
deferral) and ADR-023 D1 (scenarios owns the block-only-hash KEY + features-tree
enumeration) **remain in force** — this ADR extends D1 from "owns the key" to
"owns the journal file primitive."
**Pins (the contract surface this rests on):**
[ADR-019 D1](019-canonicalization-ownership-in-scenarios-bc.md) — the block-only
canonical hash is owned by `shopsystem-scenarios` and is the journal's identity
key; and scenario 117
([`features/templates/117-…`](../features/templates/117-canonical-scenario-hash-canonicalization-is-scenario-block-only-not-feature-line-included.gherkin))
— exactly one canonical hash text per scenario block.
**Anchored to:** [ADR-018](018-empirical-verification-is-contract-surface.md)
(the artifact-surface evidence rule; every finding below is from the lead-held
`features/`, the installed `scenarios`/`shop-msg` contract tools, `git show HEAD`
over the lead-held tree, and `shop-msg` registry/bc-status state — no `repos/` BC
source, which the lead host does not carry).
**Related beads:** `lead-9zx1` (umbrella: journal bootstrap orchestration, the
GAP that surfaced the mis-home); `lead-lsbs` (scenarios `assign_scenarios` — the
file capability, this ADR's new home); `lead-h4q2` (messaging `request_bugfix` —
retire the mis-homed implementation); the now-superseded `lead-if3j` / `lead-9b3w`
/ `lead-7hsl` (the messaging journal store + sc08 rebuild + lead-facing view this
ADR retires).

---

## Context

The scenario-completion journal was originally decomposed (ADR-023) with the
**BC-authoritative store and the lead-facing snapshot living in `shopsystem-messaging`**,
co-located with the `work_done` ingest path and rendered through new `shop-msg`
subcommands over messaging-owned state. ADR-024 added the sc08 rebuild as a new op
**on that messaging-owned store**. The implementation landed: messaging shipped a
`catalog.journal` module (`CompletionState`, `LeadSnapshot`, `ScenarioJournal`,
`SystemStateView`) across commits `b1c8ced` / `cddb55c` / `036c3a3`.

The stakeholder has since fixed a load-bearing correction: **`shop-msg`'s postgres
is a message BUS, not a store.** A durable, queryable completion artifact does not
belong inside the transport substrate. The journal is a **FILE**, and its natural
owner is **`shopsystem-scenarios`** — the BC whose charter is "what a scenario is,"
which already owns the block-only canonical hash (the journal's identity key,
ADR-019 D1) and the features-tree enumeration (ADR-023 D1). The messaging
`catalog.journal` implementation is therefore **mis-homed and must be retired**,
and the journal must be **rebuilt in scenarios as a file primitive**.

This ADR records the re-home: scenarios *builds* the file capability, messaging
*retires* the mis-homed implementation, and the lead-side aggregate scenarios
(sc04–07) are pinned as lead-held tooling, not BC work.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

Verified 2026-06-08 from the lead CWD against the lead-held `features/`, the
installed `scenarios hash` contract tool, `git show HEAD` over the lead-held
tree, and `shop-msg registry`/`bc-status`. No BC implementation read, run, or
git-observed; the lead host carries no `repos/` BC source.

1. **The three new file-based CLI scenarios verify against `scenarios hash`
   (the admissible ADR-018 D2 "run"), over the bare block (tag line stripped):**

   | lead-held file | new `@scenario_hash` | `scenarios hash` of bare block | match |
   | -------------- | -------------------- | ------------------------------ | ----- |
   | 01-completion-lookup-yes (journal-query CLI, definite YES) | `2f98b0bb8380af42` | `2f98b0bb8380af42` | ✓ |
   | 02-completion-lookup-no  (journal-query CLI, definite NO)  | `cc4c8fcd07b5587c` | `cc4c8fcd07b5587c` | ✓ |
   | 08-bc-rebuilds-journal (journal-rebuild CLI, file from tags, idempotent) | `60ff847fac2a4be5` | `60ff847fac2a4be5` | ✓ |

2. **The journal capability is net-new in `shopsystem-scenarios`. CONFIRMED.**
   `scenarios --help` subcommands are `hash, verify, list, count, titles, tags`
   — it enumerates and hashes but holds **no** journal-query and **no**
   journal-rebuild surface, and no completion-state file. The only scenarios-side
   journal-adjacent bead, sc06 (`f58a7dc39c4e718a`, `lead-onfq`), is the
   *outstanding-enumeration* primitive — unrelated to a journal file. The
   discriminator therefore resolves to **`assign_scenarios`** for the scenarios
   dispatch (genuinely new, not unpinned-existing).

3. **@scenario_hash retirement enumeration (the message-type / supersession
   pre-state step). CONFIRMED — non-empty.** `grep -r "@scenario_hash"
   features/scenario-journal/` over the lead-held tree, cross-read against
   `git show HEAD` and the BC implementations named in `lead-9zx1`:
   - **HEAD (committed, == what messaging implemented):** file 01 →
     `1b21dbb923413455`, file 02 → `528c08b5a0a6d024`, file 08 →
     `d1f0cf457019db29`; file 03 → `d01313bf5090bee6`. These four are the old
     journal hashes, **pinned/implemented in `shopsystem-messaging`** (lead-if3j
     carried 01/02/07; lead-9b3w carried 03/05; lead-7hsl carried 08; commits
     `b1c8ced`/`cddb55c`/`036c3a3`).
   - **Working tree (PO re-authored):** files 01/02/08 now carry the new
     scenarios-owned hashes (finding 1); file 03 (`d01313bf`) is dropped/
     superseded (event-append model — the mis-homed shape, not re-homed).
   - **The retirement set is therefore `{1b21dbb923413455, 528c08b5a0a6d024,
     d1f0cf457019db29, d01313bf5090bee6}`**, all named explicitly in the
     `lead-h4q2` messaging dispatch description (ADR-018 95/128).
     **[CORRECTED 2026-06-08 — this 4-pin set was INCOMPLETE. The enumeration
     scoped `grep` to the working-tree/superseded view and missed sc04/sc05/sc07,
     which messaging had ALSO implemented in `catalog.journal`. The full
     messaging retirement set is SEVEN pins. See "Amendment 2026-06-08".]**

4. **Target-BC presence. CONFIRMED.** `shop-msg registry list` routes both
   `shopsystem-scenarios` and `shopsystem-messaging`; `shop-msg bc-status`
   reports **both ONLINE** (scenarios hb 25, messaging hb 16). The stakeholder
   directed routing this through scenarios properly and dispatching — both
   dispatches can be worked immediately. No `--depends-on` guard applies (the two
   dispatches are independent — see D4).

---

## Decision

### D1 — The scenario-completion journal is a FILE owned by `shopsystem-scenarios`; the message bus is not a store

The journal is a **file on disk under the `shopsystem-scenarios` bounded
context**, keyed solely on the block-only canonical hash (not on bead id, title,
dispatch record, or message-bus row). `shopsystem-scenarios` owns it because it
already owns the hash KEY (ADR-019 D1) and the features-tree enumeration (ADR-023
D1) — the journal file is the natural extension of "what a scenario is" into "is
this scenario recorded." **`shop-msg`'s postgres is a message BUS, not a store**;
durable completion state does not belong in the transport substrate. This
**supersedes ADR-023 D2** (messaging-owned journal store).

The scenarios file capability is two CLI surfaces, dispatched net-new via
`assign_scenarios` (`lead-lsbs`):
- **journal-query** — definite YES/NO for a block-only hash against the journal
  file (scenarios `2f98b0bb8380af42`, `cc4c8fcd07b5587c`).
- **journal-rebuild** — write a journal file whose entries are the
  `@scenario_hash` tags present in a features tree, derived from the as-committed
  tags alone (no `work_done`/message-bus event required), idempotent and
  non-destructive (scenarios `60ff847fac2a4be5`).

### D2 — CLI ergonomics: the rebuild CLI takes an OPTIONAL features-tree positional arg, defaulting to the conventional `./features/` root

Settled (not relitigated): `scenarios journal rebuild [FEATURES_TREE]` — the
features-tree argument is an **optional positional** defaulting to the
conventional `./features/` root. This is both composable (point it at any tree)
and zero-arg convenient (the common case). Pinned in the `lead-lsbs` dispatch
context and recorded here so the BC implements it without a clarify round-trip.

### D3 — The mis-homed `messaging` journal implementation is RETIRED via `request_bugfix`

The `catalog.journal` module (`CompletionState`, `LeadSnapshot`, `ScenarioJournal`,
`SystemStateView`) and the old journal `@scenario_hash` pins are retired from
`shopsystem-messaging`. **[CORRECTED 2026-06-08: the retirement set is SEVEN
pins, not four. The original `lead-h4q2` dispatch named only
`1b21dbb923413455`, `528c08b5a0a6d024`, `d1f0cf457019db29`, `d01313bf5090bee6`;
it omitted `307967ddfb53fc45` (sc04), `d0a74c6e8ecb8eb3` (sc05), and
`03a396b8dc08041e` (sc07), which messaging had also implemented in
`catalog.journal` (`LeadSnapshot.apply_work_done`, `LeadSnapshot.reconcile_against`,
`SystemStateView`). messaging correctly raised a `clarify`; the corrected 7-pin
scope is re-dispatched on `lead-tydd` (ADR-009 vehicle (b)). See "Amendment
2026-06-08". The full corrected retirement set is named there.]** **Vehicle: `request_bugfix`,
not `request_maintenance`** — the discriminator turns on whether pinned scenario
coverage is retired: these four hashes are *pinned scenario coverage* in
messaging, so retiring them is behavioral supersession (the named role of
`request_bugfix`), not a flat refactor. The dispatch carries **no replacement
scenarios** (`scenarios: []`) — replacement coverage now lives in scenarios (D1).
The dead-code removal rides along; the load-bearing act is the coverage
retirement, with each hash named explicitly (ADR-018 95/128). This **supersedes
ADR-023 D3 and ADR-024 D1**.

### D4 — The two dispatches are independent (no `--depends-on`)

Scenarios *builds* the new home; messaging *retires* the old one. Neither blocks
the other on the wire — the retirement does not wait on the build, and the build
does not read messaging's store. Both ran as parallel independent dispatches
under `lead-9zx1`. (This ADR is the record that scenarios is the new home; that
recording is the only ordering relationship, and it is satisfied here.)

### D5 — sc04, sc05, sc06, sc07 are LEAD-SIDE aggregate tooling — lead-held, lead-implemented, NOT dispatched to any BC

The remaining journal scenarios describe **lead-side reconciliation tooling**:
the lead joins the scenarios file-journal primitive (D1) with its *own* dispatch
ledger (the bead registry, `scenario_hashes_pinned` on reconciled dispatches)
across BCs. They are not BC capabilities:
- **sc04** (`307967ddfb53fc45`) — lead snapshot incrementally reflects a
  `work_done`-carried completion.
- **sc05** (`d0a74c6e8ecb8eb3`) — lead reconciles its snapshot against a BC
  journal pulled on demand.
- **sc06** (`f58a7dc39c4e718a`) — system-wide outstanding view counts a
  never-dispatched canonical scenario (the lead-aggregate denominator; sc06's
  predicate-deferral from ADR-024 D2 stands).
- **sc07** (`03a396b8dc08041e`) — orphan completion (absent from the lead's
  canonical features) flagged as an anomaly.

These remain **lead-held / lead-implemented** — the
reconciliation-script-becomes-tooling path. They are NOT authored or dispatched
as BC work going forward. The lead joins the file-journal primitive scenarios
builds (D1) with its bead ledger to render the aggregate; that join is
lead-resident, off any BC's contract surface.

**[CORRECTED 2026-06-08: "not dispatched as BC work" was true as forward-looking
intent but elided a pre-state fact — sc04 (`307967ddfb53fc45`), sc05
(`d0a74c6e8ecb8eb3`), and sc07 (`03a396b8dc08041e`) had ALREADY been dispatched
to and implemented in `shopsystem-messaging` (via `lead-if3j`/`lead-9b3w`) before
the re-home decision. Their messaging `catalog.journal` implementations are
therefore part of the retirement and MUST be removed (this is why the corrected
retirement set is 7 pins, not 4). The lead-held `features/scenario-journal/04,05,07`
copies STAY as lead canonical for the eventual lead-side implementation; only
messaging's implementations are retired. sc06 (`f58a7dc39c4e718a`) was never
dispatched to messaging (ADR-024 D2 deferral) and is correctly NOT in the
messaging retirement set. See "Amendment 2026-06-08".]**

---

## Consequences

- One `assign_scenarios` dispatch (`lead-lsbs` → `shopsystem-scenarios`), on-wire
  `scenarios[].hash` ∈ `{2f98b0bb8380af42, cc4c8fcd07b5587c, 60ff847fac2a4be5}`,
  confirmed by read-back.
- One `request_bugfix` dispatch retiring the mis-homed messaging journal,
  `scenarios: []` (removal only). **[CORRECTED 2026-06-08: the retirement is
  SEVEN pins — `{1b21dbb923413455, 528c08b5a0a6d024, d1f0cf457019db29,
  d01313bf5090bee6, 307967ddfb53fc45, d0a74c6e8ecb8eb3, 03a396b8dc08041e}` —
  and removes the whole `catalog.journal` module + all seven feature files +
  step defs, leaving messaging with zero journal footprint and a green suite.
  Originally dispatched as 4 pins on `lead-h4q2`; corrected to 7 and
  re-dispatched on `lead-tydd` after messaging's correct clarify. See
  "Amendment 2026-06-08".]**
- ADR-023 D2/D3 and ADR-024 D1 are superseded; the journal's home moves from the
  message bus to a scenarios-owned file. ADR-023 D1 (scenarios owns the key +
  enumeration) and ADR-024 D2 (sc06 deferral) survive.
- sc04–07 are pinned as lead-side aggregate tooling — no BC owes them; the lead
  builds the reconciliation/snapshot/outstanding/orphan view itself over the
  scenarios file-journal primitive plus its bead ledger.
- The lead-held canonical `features/scenario-journal/01,02,08` carry the new
  scenarios-owned hashes (working tree); file 03 (`d01313bf`) is superseded/
  dropped. The committed HEAD still carries the old hashes until this slice's
  features changes are committed — a follow-up commit closes that drift (not done
  in this dispatch turn).

## Amendment 2026-06-08 — messaging retirement is SEVEN pins (zero journal footprint), correcting the 4-pin enumeration

**What was wrong.** D3 and the pre-state finding (§Pre-state, item 3) enumerated
the messaging retirement set as the four pins
`{1b21dbb923413455, 528c08b5a0a6d024, d1f0cf457019db29, d01313bf5090bee6}`.
That enumeration was **incomplete**. It was derived from a `grep` scoped to the
working-tree / superseded-shape view of `features/scenario-journal/` and did not
reconcile against what `shopsystem-messaging` had *actually implemented*. The
messaging `catalog.journal` module (`CompletionState`, `LeadSnapshot`,
`ScenarioJournal`, `SystemStateView`) backs **seven** journal pins, not four:
the three additional pins are sc04/sc05/sc07, whose step defs call
`LeadSnapshot.apply_work_done`, `LeadSnapshot.reconcile_against`, and
`SystemStateView` respectively.

**How it surfaced.** `shopsystem-messaging` raised a correct `clarify` on
`lead-h4q2`: deleting `catalog.journal` while leaving the sc04/sc05/sc07 feature
files + conftest step defs in place would break the BDD suite (import errors /
undefined steps). The BC asked whether those three are also retired or require
replacement coverage. They are also retired (no replacement in messaging).

**The corrected retirement set (SEVEN pins), verified against the lead-held
HEAD `features/scenario-journal/` tree (`git show HEAD`), which equals what
messaging implemented:**

| pin | scenario / file | messaging implementation |
| --- | --- | --- |
| `1b21dbb923413455` | sc01 completion-lookup-yes | original 4 |
| `528c08b5a0a6d024` | sc02 completion-lookup-no | original 4 |
| `d1f0cf457019db29` | sc08 bc-rebuilds-journal | original 4 |
| `d01313bf5090bee6` | sc03 event-append (dropped) | original 4 |
| `307967ddfb53fc45` | sc04 lead-snapshot-reflects-completion | `LeadSnapshot.apply_work_done` |
| `d0a74c6e8ecb8eb3` | sc05 lead-reconciles-against-bc-journal | `LeadSnapshot.reconcile_against` |
| `03a396b8dc08041e` | sc07 orphan-completion-flagged-as-anomaly | `SystemStateView` |

`sc06` (`f58a7dc39c4e718a`, outstanding-counts-never-dispatched) was **never
dispatched to messaging** (ADR-024 D2 deferral) and is correctly **excluded**.

**Outcome — messaging ends with ZERO journal footprint.** The corrected scope
removes the *entire* `catalog.journal` module **plus all seven journal feature
files and their conftest step defs**, leaving a GREEN suite and no journal code
in messaging at all. None of the seven receives replacement coverage in
messaging: sc01/sc02/sc08 are rebuilt as a file-based capability in
`shopsystem-scenarios` (`lead-lsbs`, in flight); sc04/sc05/sc06/sc07 remain
**lead-held / lead-implemented** aggregate tooling (D5) — their lead-held
`features/scenario-journal/` copies STAY as lead canonical, but messaging's
implementations of sc04/sc05/sc07 are removed.

**Vehicle / dispatch.** Per ADR-009 vehicle (b), the corrected scope is
re-dispatched as a fresh `request_bugfix` on a new lead bead **`lead-tydd`**
(`scenarios: []`, removal only), citing the original `lead-h4q2` for
correlation. `lead-h4q2` is marked superseded; `lead-9zx1` now depends on
`lead-tydd` for the messaging-retire leg. The discriminator answer is unchanged
(`request_bugfix`: retiring pinned scenario coverage is behavioral supersession);
only the enumerated set widened 4→7.

**Lesson (ADR-018 95/128 enumeration discipline).** The retirement enumeration
must be reconciled against *what the target BC actually implemented* (the
HEAD-committed `@scenario_hash` tags == the BC's implemented set), not only
against the working-tree/superseded view of the lead's own re-authored features.
A `grep` scoped to "what changed" misses pins that are unchanged at HEAD but
still implemented in the BC and still backed by the module being deleted.

## Alternatives considered

**Keep the journal in `messaging`'s postgres (ADR-023 D2 status quo).** Rejected
(D1): the stakeholder fixed that the bus is a transport, not a store; a durable
queryable completion artifact in the transport substrate conflates two concerns
ADR-006 §5 keeps separate.

**`scenarios` owns the journal but as a DB table, not a file.** Out of scope —
the stakeholder fixed "a FILE." The file shape also makes rebuild-from-features
(scenario 08) a pure derivation with no store-migration coupling.

**Dispatch the messaging retirement as `request_maintenance` (flat dead-code
removal).** Rejected (D3): the removal retires *pinned scenario coverage*
(`1b21dbb`/`528c08b`/`d1f0cf45`/`d01313bf`), which is behavioral supersession.
`request_maintenance` names flat changes that introduce/retire no scenario
coverage; the correct discriminator answer is `request_bugfix`.

**Dispatch sc04–07 to a BC.** Rejected (D5): they describe lead-side aggregate
reconciliation joining the scenarios file-journal with the lead's own bead
ledger across BCs — lead-resident tooling, not a BC capability.

## Cross-references

- [ADR-023](023-scenario-completion-journal-decomposition.md) — D2/D3 superseded
  here; D1 (scenarios owns key + enumeration) survives and is extended.
- [ADR-024](024-journal-bootstrap-rebuild-rides-messaging-store-and-sc06-tightening-deferred.md)
  — D1 (messaging-home rebuild) superseded; D2 (sc06 deferral) survives.
- [ADR-019](019-canonicalization-ownership-in-scenarios-bc.md) — block-only-hash
  ownership in scenarios that makes the journal key (and its file home) sound.
- [ADR-018](018-empirical-verification-is-contract-surface.md) — the
  artifact-surface evidence rule the pre-state findings honor.
- `features/templates/117-…` — exactly one canonical hash text per scenario block.
- `features/scenario-journal/01,02,08` (new scenarios-owned hashes); `…/03`
  (superseded); `…/04,05,06,07` (lead-side aggregate, D5).
- `lead-9zx1` umbrella; `lead-lsbs` (scenarios build); `lead-h4q2` (messaging
  retire).
