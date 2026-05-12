# §4 BC-shop

A BC-shop produces one Bounded Context of the product. The relationship between BC and shop is one-to-one: one shop = one repo = one BC, and the BC name is the shop name. The BC-shop receives its work from the lead shop via the inter-shop protocol, carries out implementation and review internally, and reports back when work is complete.

## 4.1 Roles

**Implementer.** The Implementer receives assigned work from the lead shop, opens a top-level beads issue that cross-references the lead beads ID, and breaks the work down into sub-issues. The Implementer writes the code and tests, runs the BDD suite to confirm assigned scenarios pass, and updates the scenario register accordingly. When scope or vocabulary is unclear, the Implementer sends a `clarify` message to the lead shop rather than making assumptions. Treating "clarity" as self-evident is unreliable — a capable agent will fill gaps from BC code or world knowledge unless its role is equipped with explicit criteria for what counts as a sufficient request. Those criteria live in the BC-shop's role template (system prompt or analysis skill), not in this spec, so they can be iterated without spec churn. The Implementer cannot emit `work_done` unilaterally — that gate is held by the Reviewer.

**Reviewer.** The Reviewer's stance is adversarial by design. The Reviewer probes the implementation against the assigned scenarios, looking for cases the Gherkin does not cover and for implementation behaviour that violates intent even when tests pass. Where the Implementer's job is to make things work, the Reviewer's job is to find where they break. The Reviewer records findings in beads and blocks `work_done` until satisfied. When the Reviewer judges that a scenario is too loosely specified to catch the failure mode found, the finding loops back to the lead shop via `clarify` for the PO to decide on — it is not the Reviewer's call to rewrite requirements unilaterally.

## 4.2 Activities

The Implementer handles the mechanics of receiving work, building, and reporting; the Reviewer handles the adversarial quality gate. The two roles are sequential within a unit of work: implementation proceeds until the Reviewer's gate opens. The table below is the authoritative activity catalogue for the BC-shop.

| Role | Activity | Artifacts touched |
|---|---|---|
| Implementer | Receive work, open top-level beads issue with lead ID as external ref | beads issue |
| Implementer | Break down into sub-issues | beads sub-issues |
| Implementer | Implement (code + tests) | code, tests |
| Implementer | Run BDD suite, update scenario register | scenario register |
| Implementer | Send `work_done` | message |
| Implementer | Send `clarify` when scope/vocabulary unclear | message |
| Implementer | Maintain shop card and respond to `request_shop_card` | shop card |
| Reviewer | Adversarial probe of implementation against assigned scenarios | review notes (in beads) |
| Reviewer | Construct failing cases not covered by Gherkin | edge-case findings |
| Reviewer | Gate `work_done` (block until satisfied) | beads state |
| Reviewer | Propose scenario tightenings back to lead shop via `clarify` | message |

## 4.3 Artifacts owned

The BC-shop holds only what it needs to do its own work — implementation artifacts and the local tracking layer. The list below names each BC-shop-owned artifact with its format and its one-clause job.

- **Code, tests, build artifacts** *(language-specific)* — the primary product of the BC-shop; held in the BC repo.
- **Local Gherkin scenarios** *(Gherkin)* — received from the lead shop inline via `assign_scenarios` and written to the features directory on receipt; maintained alongside the implementation as the local reference for what the BC is expected to do.
- **Scenario register** *(YAML; schema deferred to a future prototype — see [findings/from-prototype-1.md §8](findings/from-prototype-1.md))* — the list of Gherkin scenario hashes currently passing in this BC-shop; the Implementer updates it after each BDD run and the lead shop pulls it during reconciliation via `request_scenario_register`.
- **BC-shop beads** *(beads native)* — the local breakdown of assigned work; one top-level issue per unit of work received, cross-referencing the lead beads ID as an external reference, with sub-issues for the Implementer's internal breakdown.
- **Shop card** *(YAML; schema deferred to a future prototype — see [findings/from-prototype-1.md §8](findings/from-prototype-1.md))* — this BC-shop's own declarative metadata: name, BC, roles, activities offered. Lives at a known path in the BC repo (e.g. `shop-card.yaml`); served to the lead shop via `request_shop_card`.
- **Inbox and outbox** *(conceptual queues)* — the inbound and outbound message queues for inter-shop traffic. Their on-disk representation (paths, filenames, directory layout) is private to the `shop-msg` CLI and is not part of the inter-shop contract. Producing roles deposit messages via `shop-msg send` / `shop-msg respond`; receiving roles drain them via `shop-msg read`. Conventions about filenames or directory shape are not normative — invariants belong where they can be enforced (see [findings/from-prototype-1.md finding 4](findings/from-prototype-1.md)), and an unenforced filename convention is a slippery-slope dependency on a representation no schema or tool defends. **Carve-out:** tests of `shop-msg`'s own implementation may inspect the underlying storage directly; consumer-BC tests and role activities go through the CLI.

## 4.4 Reviewer mechanics

The Reviewer functions as an internal gate — an adversarial checkpoint that sits between the Implementer finishing and the BC-shop reporting back to the lead shop. The gate is not advisory: the Implementer cannot emit `work_done` until the Reviewer signs off, and that sign-off is recorded as a state transition on the top-level beads issue. The lead shop sees only `work_done`; the internal blocking is invisible to it, which is intentional — the BC-shop is responsible for its own quality boundary.

When the Reviewer's probing surfaces a failure mode that the existing Gherkin would not catch — a scenario whose specified behaviour is too loose to rule out the defect — the finding does not stay inside the BC-shop. The Reviewer proposes a scenario tightening back to the lead shop via `clarify`. The PO receives the `clarify` and decides whether to tighten the Gherkin. If the PO accepts the tightening, the revised scenario returns to the BC-shop as a `request_bugfix` carrying the tightened scenario text. The BC-shop then implements against the tighter specification and the Reviewer re-gates.

This loop — Reviewer finds gap → `clarify` → PO decides → `request_bugfix` with tightened scenario → BC-shop re-implements → Reviewer re-gates — is the mechanism by which discovered edge cases feed back into the canonical requirements rather than living only in ad hoc test code. It keeps the Gherkin corpus honest over time.

The loop reuses existing message types — `clarify`, `request_bugfix`, `work_done` — rather than introducing §4.4-specific machinery. Implementations should not invent special handling for it; the role-template architecture and the message catalog produce the loop as a natural consequence of holding the gate.

A second outcome category surfaces in practice: **tighten without code change**. When the Reviewer's probing finds that the implementation already handles a case but no scenario pins it, the right §4.4 result is to add the pinning scenario and verify (typically via counterfactual: would removing the existing handler break the new test?), without modifying production code. This is distinct from `work_done(blocked)` — the implementation isn't wrong, the requirements just weren't tight enough to prevent future regression.

## 4.5 Cross-references

- Lead shop side: [§3](03-lead-shop.md).
- Inter-shop messages and routing: [§5](05-inter-shop-protocol.md).
- Work tracking and beads cross-references: [§6](06-work-tracking.md).
- Empirical validation of the role-template architecture, the §4.4 loop (three full closures), and the schema-vs-template-vs-tool discriminator: see [`findings/from-prototype-1.md`](findings/from-prototype-1.md).
