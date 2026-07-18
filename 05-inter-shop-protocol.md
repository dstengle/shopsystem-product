# §5 Inter-shop protocol

The inter-shop protocol is the typed message catalogue through which shops coordinate work. It pins eight message types and the discipline around how they move; the routing, wire format, and specialised delivery mechanisms are detailed in the subsections below. One of the eight (`request_shop_card`) is spec'd but formally deferred — see §5.3.

## 5.1 Channel and routing

- **Single bidirectional channel.** Either side may originate any message that makes sense in context. There is no push/pull split: a lead shop message and a BC-shop message differ by content, not by which party is allowed to initiate.
- **Hub-and-spoke.** Only lead shop ↔ BC-shop messages exist. BC-shops do not message each other directly during construction. Cross-BC awareness comes from product-level artifacts that all shops can read (the Domain & Context Map, ADRs, structurizr workspace).

## 5.2 Wire format

Messages are YAML, validated by Pydantic schemas. YAML is chosen because it is the easiest to parse and maintain, is human-editable, validates cleanly, and fits the existing Markdown / Gherkin / Structurizr DSL stack.

## 5.3 Message catalogue

The direction column names the originating shop type for the canonical use of each message; symmetric origination is permitted where the message's meaning is symmetric. `nudge` is symmetric in practice (either side may originate it, per [ADR-015](adrs/adr-015.md)); `request_shop_card` qualifies in principle but is deferred.

`request_completion_journal` (formerly catalogued as `request_scenario_register`) is renamed to fit its realized semantics: it returns *completed* scenarios, not a full register. Its first iteration is a request against the existing scenario-completion journal — not a new pull substrate — and its data source is the journal **file in `shopsystem-scenarios`** ([ADR-025](adrs/adr-025.md) re-homed the journal there as a file; the messaging-owned store of [ADR-023 D2](adrs/adr-023.md) was retired).

| Direction | Message | Purpose |
|---|---|---|
| lead → BC | `assign_scenarios` | Designated Gherkin scenarios (inline text) with tags + hash + work ID |
| lead → BC | `request_bugfix` | Defect or scenario tightening, with work ID |
| lead → BC | `request_maintenance` | Plain-language maintenance work, with work ID |
| lead → BC | `request_completion_journal` | Returns the requested BC's scenario-completion journal entries (completed scenarios), sourced from the journal file in `shopsystem-scenarios` per [ADR-025](adrs/adr-025.md). First iteration returns what has been completed. (Renamed from `request_scenario_register`.) |
| lead → BC | `request_shop_card` | Asks for current shop card *(deferred — see below)* |
| lead ↔ BC | `nudge` | Operational-liveness ping (no scenario state). Carries a `reason` enum (`stuck-on-you` / `status-check` / `predecessor-landed` / `general`), an optional `note`, and an optional `work_id`; it does NOT carry `scenario_hashes`. Auxiliary signaling that does not block, extend, or modify any dispatch lifecycle. Defined in [ADR-015](adrs/adr-015.md). |
| BC → lead | `work_done` | Work ID + scenario hashes now passing + status |
| BC → lead | `clarify` | Question or proposal back to PO/Architect |
| BC → lead | `mechanism_observation` | BC-originated observation about the shop-system mechanism itself (template, schema, package boundary, spec). Carries a `bd_ref` to a BC-side bead and a `body` with the load-bearing claim; lead drains by creating a corresponding lead-side bead. Distinct from `clarify` (which is about the work item) and `work_done(blocked)` (which is about implementation). Validated end-to-end in [`findings/from-mechanism-observation-v1.md`](findings/from-mechanism-observation-v1.md). |

**Deferred message types.** `request_shop_card` is pinned in this catalogue but has no schema class and is not implemented in `shopsystem-messaging`; it has not been exercised by the live fleet ([`findings/from-prototype-1.md`](findings/from-prototype-1.md), [`findings/from-mechanism-observation-v1.md`](findings/from-mechanism-observation-v1.md)). It is **formally deferred**: the conformance loop in production runs on the `work_done`-`scenario_hashes` push (see [§6.4](06-work-tracking.md)), which closes the reconciliation loop without a pull. `request_shop_card` remains reserved for authoritative shop-card acquisition (§5.5) if and when a consumer needs it. It is kept in the catalogue as a named reservation, not an available vehicle; do not select it as a dispatch vehicle until a schema class lands.

`request_completion_journal` is **no longer deferred** (per the 2026-06-12 override): its first iteration is implemented as an on-demand pull of the requested BC's *completed* scenario-completion journal entries, realized as a request against the existing journal rather than a new pull substrate. Its data source is the journal file in `shopsystem-scenarios` ([ADR-023 D2](adrs/adr-023.md) / [ADR-025](adrs/adr-025.md)). This complements the `work_done`-`scenario_hashes` push (§6.4) with an on-demand completed-entries pull; it does not replace the primary push loop.

The choice between `assign_scenarios`, `request_bugfix`, and `request_maintenance` follows from the BC-shop's pre-state with respect to the work being requested. If the BC has no capability for what is being asked → `assign_scenarios` (the lead commits to new behavior via Gherkin scenarios that become part of the BC's acceptance contract). If the BC is already exhibiting the behavior in some form but no scenario pins it → `request_bugfix` (the lead tightens unpinned existing behavior, optionally carrying a tightened Gherkin scenario). If the BC has the behavior and scenarios pin it but the lead wants a flat change with no new scenarios — refactor, doc tweak, value-only update — → `request_maintenance`. The discriminator is the BC's pre-state, not the surface impression of the work.

## 5.4 Scenario delivery

Scenario delivery is inline. Full Gherkin text travels inside the `assign_scenarios` message; the BC-shop writes the scenarios to its features directory on receipt. Tags and hash live in the scenario itself — no cross-repo read coupling is required. The lead shop holds the canonical copy; the BC-shop's local copy is what it implements and tests against.

## 5.5 Shop card delivery

Each shop's card lives at a known path in its repo (e.g. `shop-card.yaml`) — that's where it is maintained. The lead shop acquires BC-shop cards via `request_shop_card`; the BC responds with the card content. Keeping acquisition on the typed channel preserves the uniform inter-shop traffic discipline (no shop reads another shop's repo directly).

`request_shop_card` is currently **formally deferred** (§5.3) — it has no schema class and the live fleet has not needed authoritative card acquisition. This subsection records the intended contract for when a consumer does; it is not an available vehicle today.

## 5.6 Schema-level invariants

Catalog message schemas carry constraints that enforce structural and safety invariants of the message contract. The schema is the contract — producer code is not. Constraints expressed at the schema layer apply to every construction site, including future tools that do not yet exist; constraints expressed only in producer code can be bypassed on day two by any caller that builds the message a different way.

This applies to structural shape (required fields, type constraints, list cardinality) and to cross-cutting safety invariants (work-id discipline, non-emptiness of fields whose meaning depends on non-emptiness, tag-presence requirements on payloads). It does not apply to invariants that require external context (e.g., a tag matching a known dispatch target — that is integration-level, not single-message) or that span messages.

Where an invariant cannot be expressed cleanly at the schema layer — typically because it requires composition with another package's logic, or because it spans messages — the alternative is a tool that validates the invariant at the integration boundary, never a defensive check in producer code.

## 5.7 Self-contained messages

A message must carry everything the receiving shop needs to act on it. The receiving shop acts on a message without consulting the sending shop's internal artifacts — its beads database, its source files, its working directory, or any other state private to the sender. The schema captures the meaning; the wire payload captures the data. Anything load-bearing for the receiver belongs in the message itself.

This is a sibling invariant to the schema-as-contract principle in §5.6. Schema-level invariants ensure each message is well-formed; the self-contained-messages invariant ensures each message is *complete*. Together they keep the inter-shop boundary clean: a shop reasons about what arrives in its inbox, not about how the sender constructed it. Cross-shop read coupling — receiver inspecting sender's repo to interpret a message — defeats the typed-channel discipline §5.1 and §5.4 establish and tightens the topology to single-host single-process by accident.

References inside a message (e.g., a `bd_ref` on `mechanism_observation` recording the sender's local bead) are provenance for the sender's own reconciliation, not load-bearing for the receiver. The receiver's response logic must work without resolving such references.

## 5.8 Cross-references

- Lead shop: [§3](03-lead-shop.md).
- BC-shop: [§4](04-bc-shop.md).
- How beads tracks the work referenced by these messages: [§6](06-work-tracking.md).
- Empirical validation of the catalog mechanism, the message-type discriminator, and the schema-as-contract principle: see [`findings/from-prototype-1.md`](findings/from-prototype-1.md).
