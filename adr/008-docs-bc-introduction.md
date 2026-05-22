# ADR-008 — shopsystem-docs as a new Bounded Context

**Status:** accepted (2026-05-22)
**Authors:** dstengle, Claude (lead-architect)
**Anchored to:** [brief 007](../briefs/007-end-user-adoption-documentation.md)
(resolved Q4); [ADR-004](004-bc-launcher-as-new-bc.md) (precedent for
introducing a new BC under the shopsystem product).
**Depends on:** [ADR-001](001-framework-packaging.md)

## Decision

A new Bounded Context, `shopsystem-docs`, is created to own end-user adoption
documentation for the shopsystem framework. It is the outward-facing doc surface
an adopter encounters when they want to use the framework to build their own
product. It is not folded into any existing BC, and it does not live in this
lead-shop repository.

The BC follows standard shopsystem BC mechanisms: scenarios are authored by the
lead-shop PO and dispatched via `assign_scenarios`; the BC has its own
`bc-implementer` / `bc-reviewer` cycle. The lead shop dispatches scenarios for
doc work the same way it dispatches scenarios for `shopsystem-messaging`,
`shopsystem-bc-launcher`, etc.

**v1 publishing format is plain markdown** (brief 007 boundary 10). The first
implementation of `shopsystem-docs` ships plain `.md` files committed to the
BC's repo; the adopter reads them directly (GitHub's rendered markdown view,
or raw markdown in an editor). v1 does NOT ship a MkDocs/Docusaurus/static-site-
generator build, does NOT ship GitHub Pages or any other hosted rendered HTML,
and does NOT ship a custom rendering pipeline. This narrows the BC's v1 scope
to content authoring; documentation-site tooling is explicitly deferred to a
future iteration once the markdown content has proven its shape.

## Alternatives considered

**Option B — Docs as a directory in the lead-shop repo (`shopsystem-product/docs/`).**
The lead shop already holds briefs, ADRs, PDRs, and the canonical scenario
register; adoption docs could be one more directory alongside them. Rejected
per brief 007 boundary 1: stakeholder explicitly ruled "new repo" and the
audience split is load-bearing. The lead-shop repo's contents serve internal
contributors (briefs, ADRs, PDRs, the spec); the adopter is a different
audience and should not have to read internal artifacts to bootstrap. Stuffing
adopter docs into the internal repo confuses both audiences.

**Option C — Docs as a directory in an existing BC repo
(`shopsystem-templates/docs/` or `shopsystem-bc-launcher/docs/`).**
The templates BC owns shop bootstrapping; the bc-launcher BC owns
container-launch primitives — both touch the surface an adopter exercises.
Rejected for the same audience-split reason (the templates BC's README and
scenarios serve framework-internal consumers, not adopters) and because doc
work would compete with the BC's existing scenario load. A docs change should
not have to wait behind a templates-feature change in the same BC's
implementer queue.

**Option D — Docs as an external static site (no shopsystem BC at all),
authored outside the framework's scenario discipline.** Rejected per brief 007
resolved Q4: the stakeholder ruled directly that the docs follow standard BC
mechanisms. Docs are a product; products are produced by shops working
scenarios; therefore docs deserve a BC. Treating the adoption surface as
outside the framework's own discipline would split the framework's authoring
model in two and erode the dogfooding the framework relies on.

## Rationale

1. **Audience cleanliness.** Brief 007 commits the docs BC to an adopter
   audience — someone with Docker and a GitHub account who wants to build
   their own product using the framework. This audience is disjoint from
   every existing BC's audience (framework-internal contributors,
   implementers working dispatched scenarios). A new BC draws the right
   boundary; co-locating with any internal artifact blurs it.

2. **Same precedent as ADR-004.** ADR-004 introduced `shopsystem-bc-launcher`
   as a new BC because container-lifecycle orchestration was a distinct
   subdomain not owned by any existing BC. End-user adoption documentation
   is similarly distinct: no existing BC's domain includes "the outward
   face an adopter reads first." The structural move is the same — a
   net-new BC, bootstrapped via the standard sequence (GitHub repo create
   → `shop-templates bootstrap` → registry add), with its own dispatch
   surface.

3. **v1 narrowing keeps the BC's first deliverable knowable.** Boundary 10
   pins plain markdown only for v1. This means the docs BC's first
   implementation cycle does not have to choose a static-site generator,
   author a build pipeline, or commit to a rendering toolchain alongside
   the content. The BC ships markdown; the content itself is the only
   thing v1 has to get right. A future iteration can introduce a doc site
   on top of proven content.

4. **Avoids scope addition to loaded BCs.** Templates, messaging, and
   bc-launcher are all carrying in-flight work. A new BC starts with a
   clean inbox, a clean scenario register, and no contention with prior
   commitments.

5. **Self-documenting name.** `shopsystem-docs` names the subdomain
   directly. Final BC naming is the docs BC's authoring concern per brief
   007 boundary 7, but the working name (and the registry-add name set
   now) is `shopsystem-docs` — it is what every reference in this ADR,
   the brief, and the initial dispatches uses.

## Q6 and Q7 — surfaced but not pre-decided

Brief 007 raised two follow-up questions that this ADR explicitly does NOT
resolve:

- **Q6 (scenarios-as-source-of-truth for docs):** can the docs BC's Gherkin
  scenarios themselves be the source from which published documentation is
  generated? Resolution is deferred to the Architect once the docs BC's
  first scenarios are concrete enough to evaluate. With v1 publishing as
  plain markdown (boundary 10), the v1 evaluation surface is "scenarios →
  markdown files," not "scenarios → rendered website."

- **Q7 (launcher gap — how is a lead shop launched into a container?):**
  no host-side primitive launches a lead shop into a container today.
  Paired with brief 008 slice 1 as the empirical prove-out vehicle.
  Resolution is downstream of slice 1's evidence. Brief 007's v1 doc names
  the gap honestly until Q7 resolves; this ADR does not pre-decide which
  candidate shape (extend `bc-launcher`, new `lead-launcher` BC,
  compose-only) wins.

Neither Q6 nor Q7 gates this ADR or the docs-BC introduction.

## Consequences

1. **New repo to bootstrap.** `dstengle/shopsystem-docs` does not yet exist
   (verified by the prior architect's pre-state: `gh repo view
   dstengle/shopsystem-docs` returned "Could not resolve"). Before any
   `assign_scenarios` dispatch can land, the GitHub repo must be created,
   bootstrapped with `shop-templates`, cloned into `repos/shopsystem-docs/`,
   and registered with `shop-msg registry add`. This is the bootstrap
   prerequisite tracked as a separate lead-shop bead in the same pattern
   ADR-004 used (`lead-mxy`).

2. **New dispatch surface.** Once the BC exists and is registered, all
   brief 007 adoption-doc scenarios dispatch to `shopsystem-docs` via
   `assign_scenarios`. The vehicle is `assign_scenarios` (not
   `request_bugfix` or `request_maintenance`) because the BC has no
   capability today — it does not exist yet.

3. **Standard BC governance applies.** The docs BC has a `bc-implementer`
   that works dispatched scenarios; a `bc-reviewer` that reviews the
   resulting work; a scenario register that the lead shop reconciles
   against; an inbox/outbox surface via `shop-msg`. The docs BC is not a
   special case in any of these dimensions.

4. **No implementation in this repo.** As with all BCs, code (and in the
   docs BC's case, doc content) lives in the BC repo. The lead shop's
   role is to author scenarios and dispatch; `assign_scenarios` is the
   vehicle once the BC is bootstrapped.

5. **v1 deliverable shape is bounded.** Until a future iteration is
   briefed and authored to introduce a documentation site, the docs BC
   does not own a site build, a static-site-generator pipeline, or any
   rendered-HTML hosting. The BC's first scenario register pins markdown
   content + honest gap call-outs, nothing more.

## Cross-references

- [brief 007](../briefs/007-end-user-adoption-documentation.md) — the
  intent anchor; resolved Q4 commits the docs-BC topology, resolved Q1
  commits the single-voice agent-consumable structure, boundary 10
  commits v1 plain-markdown publishing.
- [ADR-004](004-bc-launcher-as-new-bc.md) — precedent for introducing a
  new BC under the shopsystem product; the bootstrap sequence (GitHub
  repo create → `shop-templates bootstrap` → registry add) and the
  bootstrap-precedes-dispatch ordering are the same.
- `features/docs/` — the PO-authored adoption-doc scenarios dispatched
  via `assign_scenarios` once the BC is bootstrapped.
- [`shopsystem-templates-h22`](#) — brief 007's tracking bead in the
  templates-BC tracker; surfaced here for cross-tracker discoverability.
