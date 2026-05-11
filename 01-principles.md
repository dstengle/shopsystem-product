# §1 Principles

## 1.0 Why these principles exist

Building products is increasingly a collaboration between humans and agents, and between agents and other agents. As the number of participants grows, the cost of any one participant having to comprehend the entire product to do their job grows with it. For agents that cost is literal — context loaded is context paid for. For humans it is real but easier to ignore. Either way it is the bottleneck.

These principles cap that cost. Each is normative and paired with the anti-pattern it rules out. In the shop system they produce: actors work from local descriptions and contracts; architects reason from maps, not codebases; product intent flows from expressed desire to working software with provenance at every step; the product is extended, retired, and refactored as ordinary work, not as a series of fragile expeditions.

## 1.1 Vocabulary used in this section

Three terms are pinned before the principles. Full treatment is in [§2](02-bounded-contexts-and-subdomains.md), [§3](03-lead-shop.md), and [§4](04-bc-shop.md).

- **Bounded Context** — a region of the product you have designed, with one internal language, one model, and one set of product contracts to other Bounded Contexts. Something *drawn*, not discovered.
- **Shop** — the entity that builds, operates, and evolves part of the product. Two types: the **lead shop** (system-level coordinator; houses PO and Architect) and each **BC-shop** (contains exactly one Bounded Context and produces it).
- **Activity** — a discrete unit of work performed inside a shop, against a known contract or process, with inputs, outcomes, and recorded provenance.

"Actor" is used loosely throughout. The principles do not constrain what an actor is — they constrain what an *activity in a shop* must look like, regardless of who or what performs it.

---

## 1.2 Principle 1 — Each first-class entity has a knowable shape

The product has two kinds of first-class entity: the **Bounded Context** (the product/business region) and the **Shop** (the entity that builds, operates, and evolves part of the product). Each BC is owned by exactly one BC-shop, which contains it; BC-shops and BCs are paired 1:1. The lead shop owns no BC — it is the system-level coordinator and produces product-level artifacts instead. Each entity is describable from outside without reference to its internal code.

A Bounded Context's description names what it is for, what it accepts and produces, what it guarantees, the language it speaks, and the product contracts it offers. A shop's description names what it owns (for a BC-shop, its BC; for the lead shop, the product-level artifacts it holds), its current state, and the operational contract it exposes. Anyone — actor, architect, stakeholder, operator — can understand the role of an entity from its description alone. Descriptions are authoritative (Principle 5), maintained as first-class artifacts, complete enough that the surrounding product is not surprised by the entity's behaviour.

**Anti-pattern ruled out.** Reading source code, scanning configuration, or interrogating maintainers to discover what a Bounded Context does or what a shop's current state is. If understanding a first-class entity requires any of these, the description is incomplete and that is the defect.

---

## 1.3 Principle 2 — Contracts are the only currency across Bounded Contexts

Anything one Bounded Context expects of another, or accepts from another, passes through a typed, named, versioned contract. There is no shared state, no implicit coordination, no behaviour learned by convention, no out-of-band channel. A contract names its schemas (what is exchanged), its semantics (what each operation means), its errors (how failure is communicated), and its relationship kind (Customer-Supplier, Anti-Corruption Layer, Open Host Service, etc.). If a contract does not say it, it is not promised; if a context relies on something a contract does not say, the contract is incomplete and that is the bug.

**Anti-pattern ruled out.** Two contexts that "just know" how to interact. A field that "is usually populated" but isn't in the contract. A behaviour that emerged from convention and is now relied on. Cross-context calls that pass another context's internal identifiers, share types from a neighbour's internals, or branch on undocumented values.

---

## 1.4 Principle 3 — The discipline applies to activities in shops, not to actors

What gets governed is *the activity in a shop*, not the kind of actor performing it. An activity has a shop where it occurs, a contract or process it follows, inputs, outcomes, and provenance. Whether the actor is a human, an agent, a scheduled job, an external service, or a kind of participant not yet imagined is incidental — the activity is the same shape regardless. This makes the product uniformly disciplinable. Agents in particular cannot exploit social shortcuts ("ask the team next door"); framing the discipline at the activity level forecloses that whole class of bypass for every kind of actor at once.

**Anti-pattern ruled out.** Different rules for "what humans can do" versus "what agents can do" versus "what services can do" inside the same shop. Authority granted to an individual rather than to a role and an activity. Activities that record nothing because "it was just an automation."

---

## 1.5 Principle 4 — Comprehension is local at every level

A participant never needs to read more than the level they're working at.

- Working *inside* a shop: read its beads and code (plus its local Gherkin scenarios and scenario register if a BC-shop, or its product-level artifacts if the lead shop).
- Consuming a BC's product: read that BC-shop's product contracts and scenarios.
- Working *across* Bounded Contexts: read product contracts and the Domain & Context Map.
- Working at the shop-system level: read the product brief and the Domain & Context Map.

Each level's description is sufficient for that level's work. Drilling deeper is a choice, not a prerequisite. The cost of working on any one part of the product stays bounded by that part's size, not the whole product's.

**Anti-pattern ruled out.** "You'll need to look at how Context X actually does it to understand the contract." "Let me grep the monorepo to figure out what we have." Architectural reasoning that proceeds by reading every codebase rather than reading the maps.

---

## 1.6 Principle 5 — Design is authoritative, with bidirectional conformance

The design — descriptions, contracts, process records — is the authoritative statement of what the product is and does. Code conforms to the design; the design is not derived from the code. Conformance is checked in both directions:

- **Forward conformance.** Every element in the design has corresponding code that implements it. *"Did we build what we said?"*
- **Reverse conformance.** Every element in the code is called for by the design. *"Did we build only what we said?"*

When design and code disagree, code conforms to design. When implementation reveals the design is wrong, the design change is itself a recorded activity with provenance — not silent drift that retroactively redefines what was meant. Retirement and refactoring are conformance-gated: retiring a feature removes it from the design first, after which reverse conformance identifies the code that may now be removed; refactoring leaves both sets unchanged, with reverse conformance confirming no behaviour crept in and forward confirming none was lost.

**Anti-pattern ruled out.** The description is "kept up to date" by reading the code. New behaviour appears in code without a design change. A feature is "removed" but its code stays, accumulating dead branches. Drift is normalised by treating the description as documentation rather than specification.

---

## 1.7 Principle 6 — Intent flows in from outside, through contracts, with provenance preserved

A human (or any originator) expresses a desired outcome at the product's edge. That intent enters through a contract — a product contract on some Bounded Context, or an operational contract on some shop — and is received by the shop where the work happens. Intent may get translated, may get delegated to other shops through *their* contracts. At every step the intent and its translations are recorded; activities can be traced back to the originator without ambiguity. This is how product management becomes a normal operation in the same product rather than a separate system that hands work over the wall. The same boundary discipline applies to translation steps as to any other activity.

**Anti-pattern ruled out.** Intent that disappears once it enters the product. Decisions whose origin can no longer be reconstructed. "Why did we build this?" answered only by asking someone who happened to be there. Product backlogs that live outside the product's audit trail and re-enter through informal channels.

---

## 1.8 How the principles relate

The six principles reinforce one another; weakening one weakens the rest.

- Without **(1) knowable shape**, **(2) contracts** are speculative — you cannot write a contract for something whose shape you cannot describe.
- Without **(2) contracts**, **(4) local comprehension** collapses — actors must read internals to understand interactions.
- Without **(3) activity-level discipline**, **(2) contracts** become advisory — actors who can talk their way around a contract do so.
- Without **(5) design authority and conformance**, **(1) knowable shape** drifts — descriptions stop matching reality.
- Without **(6) intent flow and provenance**, **(5) conformance** is blind — you can verify code matches design, but not whether either matches what anyone wanted.

A successful instantiation honours all six. Compromising any one is admissible only as a recorded, scoped, time-bounded exception — itself an activity with provenance.

## 1.9 What the principles do not say

The principles say nothing about: how a Bounded Context or shop organises its internals; what technologies materialise design or contracts; what kinds of actors exist or how they are authorised; what process a shop uses to translate intent into work.

Concrete pins — format choices, the catalogue of shop types, and the on-disk form of artifacts — live in §§3–6, not in the principles.
