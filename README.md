# shopsystem-product

Lead shop of the **shopsystem** product, in the DDD sense: the outward face of
the shop system where stakeholders meet the work and where product-level
artifacts live. The shopsystem is itself a product built by a lead shop and
three BC-shops; this repo holds the lead shop's content. Rationale and the
four-repo split are in [`adr/001-framework-packaging.md`](adr/001-framework-packaging.md).

## What's inside

Framework spec (read in order):

- [§1 Principles](01-principles.md) — six principles paired with the anti-pattern each rules out.
- [§2 Bounded Contexts and Subdomains](02-bounded-contexts-and-subdomains.md) — problem-space vs solution-space; recognised vs drawn.
- [§3 Lead shop](03-lead-shop.md) — PO and Architect roles, artifacts, and the turn-limited exchange.
- [§4 BC-shop](04-bc-shop.md) — Implementer and adversarial Reviewer roles, artifacts, the §4.4 loop.
- [§5 Inter-shop protocol](05-inter-shop-protocol.md) — channel, routing, wire format, message catalogue.
- [§6 Work tracking](06-work-tracking.md) — hybrid beads model and reconciliation.

Architecture decisions:

- [`adr/001-framework-packaging.md`](adr/001-framework-packaging.md) — split into four BC-aligned repos.
- [`adr/002-harness-bc-introduction.md`](adr/002-harness-bc-introduction.md) — fifth repo for the harness BC under Platform Operations.

Canonical scenarios (PO-authored, dispatched to each BC):

- [`features/scenarios/`](features/scenarios/) — `shopsystem-scenarios` BC contract.
- [`features/templates/`](features/templates/) — `shopsystem-templates` BC contract.
- [`features/test-harness/`](features/test-harness/) — `shopsystem-test-harness` BC contract.

Findings (consolidated per-prototype):

- [`findings/from-prototype-1.md`](findings/from-prototype-1.md) — message-catalog-v1 (14 slices, 2026-05-06 → 2026-05-10).
- [`findings/from-mechanism-observation-v1.md`](findings/from-mechanism-observation-v1.md) — mechanism-observation-v1.

The frozen prototype evidence that these findings cite lives in the
predecessor repo
[`ddd-product-system`](https://github.com/dstengle/ddd-product-system)
(per ADR-001's provenance note).

## Sibling BC repos

The other three bounded contexts of the shopsystem live alongside:

- [shopsystem-devcontainer](https://github.com/dstengle/shopsystem-devcontainer) — base Docker image for BC shops; container networking for the shop system.
- [shopsystem-messaging](https://github.com/dstengle/shopsystem-messaging) — Pydantic schemas, `shop-msg` CLI, messaging scenarios.
- [shopsystem-scenarios](https://github.com/dstengle/shopsystem-scenarios) — Gherkin canonicalization rule + hash + `scenarios` CLI.
- [shopsystem-templates](https://github.com/dstengle/shopsystem-templates) — role templates (lead-po, lead-architect, bc-implementer, bc-reviewer) + `shop-templates` CLI.

Dependency direction and per-repo responsibilities are detailed in ADR-001.

## Provenance

This repo originated from
[`github.com/dstengle/ddd-product-system`](https://github.com/dstengle/ddd-product-system).
The framework-internal `docs/shop-system/` directory was the lead-shop output
of the shopsystem under its earlier framing; ADR-001 promotes it into this
BC-aligned repo. The migration is tracked by ADR-001 in this repo at
[`adr/001-framework-packaging.md`](adr/001-framework-packaging.md).

## License

MIT. See [LICENSE](LICENSE).
