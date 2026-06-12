# §6 Work tracking

Shops use beads to break down and track work. The shop system uses a hybrid model — the lead shop's beads is canonical for cross-shop designations; each BC-shop's beads holds local breakdown. Work IDs flow outward from the lead shop and appear in every inter-shop message that references a unit of work.

## 6.1 Hybrid model

- **Lead shop's beads** holds cross-shop designations — the canonical work registry. One lead beads issue per assigned scenario (or per bugfix / maintenance unit).
- **BC-shop's beads** holds the local breakdown of that work — sub-issues, role assignments, in-progress state.
- The BC's top-level beads issue carries the lead beads ID as an external reference (metadata field). Everything inside the BC is local-namespaced.
- One shop = one repo = one beads instance. The hybrid model preserves this.

## 6.2 Work identifiers

The work ID quoted in inter-shop messages is the lead beads issue ID. Unambiguous, single-source, no composite-key gymnastics. IDs flow outward from the lead shop.

## 6.3 Granularity

- `assign_scenarios` carrying N scenarios produces N lead beads issues — one per scenario, because each can pass/fail independently and the Architect reconciles them individually.
- The message itself bundles for transport efficiency; beads tracks per-scenario.
- `request_bugfix` and `request_maintenance` produce one lead beads issue each.

## 6.4 Reconciliation

Reconciliation closes the conformance loop: did the scenarios the Architect assigned actually land in the BC, with the expected hashes? The loop the live fleet runs is **push-based** — it rides the `scenario_hashes` a BC reports on its `work_done`, not a separate pull. When a BC finishes a dispatch, its Reviewer emits `work_done` carrying the set of scenario hashes now passing in the BC's as-committed `features/` tree; that set is the reconciliation input.

Architect's reconciliation activity, on consuming a `work_done`:

1. Reads the `scenario_hashes` set the BC reported on the `work_done` for the dispatched `work_id`.
2. Compares that set against the open lead beads issues for that BC (each `assign_scenarios`-derived issue carries the scenario hash it was dispatched with, per §6.5).
3. Closes the lead beads issues whose scenario hashes appear in the reported set.
4. Flags issues where the scenario was assigned but its hash does not appear in the reported set (forward-conformance gap — the BC did not land the work, or the scenario body drifted between receipt and pinning so the hash changed).
5. Flags hashes in the reported set that were not assigned (reverse-conformance gap).

The `work_done` payload is a sound reconciliation input because it is **gated at the BC**: per [ADR-010 §4](../adr/010-clarify-resolution-work-done-scope.md) the reported `scenario_hashes` MUST be a subset of the hashes actually pinned under `@scenario_hash:` tags in the BC's as-committed `features/` tree, and the BC's Reviewer blocks a `work_done(complete)` emit when the payload carries an orphan hash (one not reachable in `features/`) or omits a hash for a dispatched scenario that is present in `features/`. So the hashes the Architect reconciles against are already confirmed-pinned BC-side before they cross the wire.

**On-demand complement — completed-journal pull.** The primary conformance loop above is the push: it rides the `scenario_hashes` a BC reports on `work_done`. The on-demand complement is a pull via `request_completion_journal` (formerly `request_scenario_register`; see [§5.3](05-inter-shop-protocol.md)). Its first iteration returns the requested BC's *completed* scenario-completion journal entries — realized as a request against the existing scenario-completion journal, not a new pull substrate. The journal is a **file homed in `shopsystem-scenarios`** ([ADR-023 D2](../adr/023-scenario-completion-journal-decomposition.md) / [ADR-025](../adr/025-scenario-journal-re-homed-as-file-in-scenarios-bc-messaging-home-retired.md): the journal was re-homed there as a file; the earlier messaging-owned store was retired), so the pull reads completed entries from that scenarios-BC journal file. The push loop remains primary and closes reconciliation without a pull; the completed-journal pull is the on-demand path the Architect reaches for when it wants a BC's recorded completions directly rather than waiting on the next `work_done`.

## 6.5 Intent provenance

The hybrid beads model also carries intent provenance forward, not just work provenance. The chain runs: **PDR → Gherkin scenario → lead beads issue → BC beads issue → code**. Each link is recorded:

- The PO writes a PDR motivating new functionality and authors Gherkin scenarios as that PDR's executable specification.
- The Architect's `assign_scenarios` produces a lead beads issue per scenario, with the scenario hash on the issue.
- The BC-shop's top-level beads issue cross-references the lead beads ID; sub-issues for the breakdown reference the parent.
- Commits cite the BC beads issue they advance.

A reader asking "why did we build this code?" walks the chain backward to a PDR. This is what makes [§1.7 Principle 6](01-principles.md) (intent flows in with provenance preserved) structurally enforceable rather than aspirational.

## 6.6 Cross-references

- Reconciliation activity: [§3](03-lead-shop.md).
- BC work intake and breakdown: [§4](04-bc-shop.md).
- Messages that carry work IDs: [§5](05-inter-shop-protocol.md).
- The bidirectional conformance principle this implements: [§1.6 Principle 5](01-principles.md).
- Empirical validation of the work-tracking flow under §4.4 loop closure (lead beads ↔ BC beads cross-reference, hash-based reconciliation): see [`findings/from-prototype-1.md`](findings/from-prototype-1.md).
