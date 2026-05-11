# §3 Lead shop

The lead shop is the outward face of the shop system — where stakeholders meet the work. It owns all product-level artifacts, coordinates the BC-shops, and houses the two roles responsible for product intent and product shape. The shop system is composed of one lead shop and one or more BC-shops; the lead shop is the single point through which intent enters and reconciliation returns. There is exactly one lead shop per product.

## 3.1 Roles

**Product Owner (PO).** The PO is stakeholder-facing and owns product intent — translating expressed desire into requirements artifacts (the product brief, PDRs, Gherkin scenarios) that the rest of the shop system can act on. The PO holds the authoritative picture of what the product is supposed to do and is the named party for scope and vocabulary questions arriving from BC-shops via `clarify`. When a BC-shop asks whether a term means one thing or another, or whether a scenario is in or out of scope, the PO is the party who answers. The PO does not design structure — that is the Architect's concern — but the PO does author the Gherkin scenarios that structure the work, since scenarios are requirements before they are assignments.

**Architect.** The Architect owns product shape, scenario assignment, and reconciliation. Where the PO answers *what*, the Architect answers *how it is structured* — maintaining the structurizr workspace, decomposing the problem into Bounded Contexts, assigning scenarios to the right BC-shop, and closing the loop when work comes back. The Architect is the party that sends `assign_scenarios`, `request_bugfix`, and `request_maintenance` to BC-shops, and that pulls and interprets scenario registers to verify that assigned work has landed. The two roles collaborate on BC decomposition, with a hard cap on rounds to keep that exchange bounded (see [§3.4](#34-turn-limited-po--architect-exchange) for the turn-limit mechanics). The Architect is also the named party for BC-shop `clarify` messages on architecture — questions about structure, contracts, or decomposition decisions.

## 3.2 Activities

The activities of the lead shop divide cleanly between the two roles: the PO works upstream (stakeholders → requirements → scenarios) while the Architect works downstream (scenarios → assignments → reconciliation). The two roles meet at BC decomposition, which is a bounded collaboration with a shared output — the Domain & Context Map. The table below is the authoritative activity catalogue.

| Role | Activity | Artifacts touched |
|---|---|---|
| PO | Interview stakeholder | interview notes |
| PO | Maintain product brief | brief |
| PO | Write PDR for new functionality | PDR |
| PO | Write Gherkin scenarios as requirements | scenarios (with tags + stable hash) |
| PO | Respond to BC `clarify` (scope, vocabulary) | clarification reply |
| Architect | Write ADRs | ADR |
| Architect | Maintain structurizr workspace (containers, components, dynamic views) | structurizr DSL |
| Architect | Collaborate with PO on BC decomposition (turn-limited) | Domain & Context Map |
| Architect | Assign scenarios to BCs per structurizr | scenario-to-BC assignment, lead beads issues, `assign_scenarios` |
| Architect | Reconcile scenario registers against assigned work | `request_scenario_register`, lead beads close-out |
| Architect | Send `request_bugfix` / `request_maintenance` | lead beads issues, message |
| Architect | Read a BC-shop's card via `request_shop_card` | message, BC-shop card |
| Architect | Respond to BC `clarify` (architecture) | clarification reply |

## 3.3 Artifacts owned

The lead shop is the heavier side of the artifact split — it holds all product-level artifacts, while each BC-shop holds only what it needs to do its own work. The list below names each lead-shop-owned artifact with its format and its one-clause job.

- **Product brief** *(Markdown)* — the authoritative statement of what the product is and what it is for; the entry point for stakeholder intent.
- **PDRs** *(Markdown)* — Product Decision Records; records of product-level decisions, each anchored to a point of intent expressed by the PO.
- **ADRs** *(Markdown)* — Architecture Decision Records; records of structural decisions made by the Architect; govern how the product is decomposed and how BCs relate.
- **Structurizr workspace** *(Structurizr DSL)* — the canonical structural model of the product, holding static diagrams (containers, components) and dynamic views; the Architect's primary instrument for BC decomposition.
- **Domain & Context Map** *(YAML; schema deferred to a future prototype — see [findings/from-prototype-1.md §8](findings/from-prototype-1.md))* — the bridge between problem space (subdomains) and solution space (Bounded Contexts); records subdomain-to-BC assignments and cross-BC relationships. Owned jointly by both roles; PO and Architect produce it through their bounded collaboration.
- **Gherkin scenarios** *(Gherkin; tags carry stable hash + owning BC)* — requirements expressed as executable specifications, authored by the PO; each scenario carries tags that hold a stable hash and the owning BC, making assignment and reconciliation unambiguous. The lead shop holds the canonical copy; BC-shops receive their assigned scenarios inline via `assign_scenarios` and hold local copies alongside the implementation.
- **Scenario-to-BC assignment** *(YAML; schema deferred to a future prototype — see [findings/from-prototype-1.md §8](findings/from-prototype-1.md))* — the explicit mapping from each Gherkin scenario to the BC-shop responsible for implementing it; produced by the Architect from the structurizr workspace and used to drive `assign_scenarios` messages.
- **Lead beads** *(beads native)* — the canonical work registry for the shop system; one lead beads issue per assigned scenario, bugfix, or maintenance unit, with IDs that flow outward into inter-shop messages (see [§6](06-work-tracking.md)). Work IDs are always lead beads IDs.
- **Shop card** *(YAML; schema deferred to a future prototype — see [findings/from-prototype-1.md §8](findings/from-prototype-1.md))* — the lead shop's own declarative metadata: name, roles, activities offered. Lives at a known path in the lead shop's repo (e.g. `shop-card.yaml`); served via the message channel if requested.

## 3.4 Turn-limited PO ↔ Architect exchange

When PO and Architect collaborate on BC decomposition, the exchange is bounded:

- **Hard cap of 3 rounds by default.**
- Either party may request **one extension**, which the other accepts or refuses.
- Refusal forces accept-current. The current state of the Domain & Context Map at that point is recorded as the agreed decomposition.

The cap and extension mechanics are the same shape as ordinary inter-shop messages even though both parties live in the same shop.

## 3.5 Cross-references

- Inter-shop messages and routing: see [§5](05-inter-shop-protocol.md).
- Work tracking model and beads usage: see [§6](06-work-tracking.md).
- BC-shop side of the relationship: see [§4](04-bc-shop.md).
- Empirical validation of the lead shop's role split, message-type discipline, and scenario-assignment flow: see [`findings/from-prototype-1.md`](findings/from-prototype-1.md).
