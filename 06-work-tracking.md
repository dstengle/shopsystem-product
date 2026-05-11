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

Architect's reconciliation activity:

1. Pulls the scenario register from a BC via `request_scenario_register`.
2. Compares hash-sets against open lead beads issues for that BC.
3. Closes lead beads issues whose scenarios appear in the register.
4. Flags issues where the scenario was assigned but doesn't appear (forward-conformance gap).
5. Flags entries in the register whose hashes were not assigned (reverse-conformance gap).

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
