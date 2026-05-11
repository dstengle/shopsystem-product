# §2 Bounded Contexts and Subdomains

The principles refer to Bounded Contexts as the unit of *product decomposition*; the **BC-shop** is the unit of *system decomposition*, with one BC-shop containing exactly one BC (see [§4](04-bc-shop.md)). This section pins what a Bounded Context is, distinguishes it from related DDD vocabulary, and sets the heuristics for telling them apart in practice.

## 2.1 The single test

- **Domain** and **Subdomain** are *problem-space* concepts. They exist whether or not you build anything.
- **Bounded Context** is a *solution-space* concept. It exists because you drew a line.

If you can describe it without pointing at the product, it is a Domain or Subdomain. If describing it requires pointing at something designed or built, it is a Bounded Context.

## 2.2 Definitions

**Domain.** The problem space the product is for — the world the product operates in. A Domain isn't designed; it's recognised. It is described by what people in it care about, what they do, what they say, what's at stake. A product has exactly one Domain at the top level.

**Subdomain.** A coherent region of a Domain — how the *problem* divides up, not how the product divides up. Subdomains carry a strategic classification (a property of the problem, not the solution): **Core** (where competitive value lives — why the product exists), **Supporting** (necessary but not differentiating), or **Generic** (off-the-shelf wins). Classification does not move when the product reorganises.

**Bounded Context.** A region of the product you have designed, with one Ubiquitous Language, one internal model, and one set of contracts to other Bounded Contexts. It is *something you drew*; inside, terms mean one thing and across the boundary they must be translated, mapped, or refused. The boundary is an act of design, accountable to the principles in [§1](01-principles.md).

## 2.3 The relationship

Every Bounded Context belongs to exactly one Subdomain — that is how problem connects to solution. The cardinality going the other way is not fixed:

- **One Subdomain → one Bounded Context.** The clean case. Aim for this.
- **One Subdomain → many Bounded Contexts.** Common when scale, team, or independence forces a split the problem does not naturally have.
- **Many Subdomains → one Bounded Context.** Rare and usually a smell; the context probably should be split.

A Bounded Context whose job is to serve the product itself (observability, scaffolding, audit, maintenance) belongs to a Subdomain too — typically a self-introduced one such as *"Platform Operations"*. Once a product exists, it becomes a problem space for its own maintainers; that is a legitimate Subdomain, not an exception.

## 2.4 Heuristics

| Question | If yes |
|---|---|
| Could this exist before any software did? | Domain or Subdomain |
| Could a stakeholder name this without knowing what you are building? | Subdomain |
| Would two operators in this Domain agree it is important, even with different products? | Subdomain |
| Does this have its own internal language and model? | Bounded Context |
| Is this where you place a team, a deploy unit, a description? | Bounded Context |
| Does describing this require pointing at code, a contract, or a design doc? | Bounded Context |

## 2.5 Common confusions worth naming

- **Calling a Subdomain a Bounded Context.** *"Billing"* is usually a Subdomain. The *"Billing Context"* is what you designed to handle it. They might align, but they are not the same thing.
- **Reorganising Subdomains when the product reorganises.** Subdomains are discovered; moving Subdomain boundaries because a team split means you are moving Bounded Contexts and mislabelling them.
- **Putting `core / supporting / generic` on a Bounded Context.** That classification belongs to the Subdomain. The Bounded Context implementing a Core Subdomain inherits the strategic weight, but the label lives on the problem side.
- **Treating Subdomains as units of deployment.** Subdomains are not deployable; Bounded Contexts are. Saying "the Domain" when you mean a Subdomain is the same mistake at a higher level — a product has one Domain, and *"the billing domain"* is loose talk for *"the billing subdomain"*.

## 2.6 Where each lands in the shop system

| Concept | Where it lives | Notes |
|---|---|---|
| Domain | Product brief | One per product |
| Subdomain | Domain & Context Map (Subdomain section) | Problem-space inventory; classified core / supporting / generic |
| Bounded Context | Its own description, Ubiquitous Language, contracts | Assigned to exactly one Subdomain |
| Subdomain → Bounded Context assignment | Domain & Context Map (Subdomain section) | The bridge between problem and solution |
| Bounded Context → Bounded Context relationships | Domain & Context Map (Context section) | Solution-space only; uses named relationship kinds |

The Domain & Context Map — a single artifact with two labelled sections, since the assignments and the relationships are only meaningful together — is owned by the lead shop (see [§3](03-lead-shop.md)).
