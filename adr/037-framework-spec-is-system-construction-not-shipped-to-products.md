# ADR-037 — The framework spec (§1–6) is a system-CONSTRUCTION artifact (it describes the system's own design); it stays in the framework/lead repo and is NOT shipped to product instances — product role templates are self-contained, situational guidance lives in skills

**Status:** accepted (2026-06-12)
**Tier:** system-global (per [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md) / [ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md) — this is a cross-product packaging/boundary decision about *what the templates BC delivers to a product instance* and *what stays a framework-construction artifact*; not one BC's internals, and not a framework-doctrine edit to §1–6 themselves.)
**Authors:** dstengle (ratified the principle), Claude (lead-architect)
**Pins:** the principle dave ratified (2026-06-12, tracking bead `lead-el6r`): untangle *"constructing products WITH the system"* from *"constructing the system itself"* — the framework spec §1–6 (`01-…`–`06-…` in this repo) describes the **system's own design** and is therefore a **system-construction artifact**; a product built *with* the system does not need the framework's self-description, only **self-contained role templates + skills**.
**Anchored to:** [ADR-018](018-empirical-verification-is-contract-surface.md) (the artifact-surface evidence rule the pre-state findings honor — every finding below is from this repo's `01-…`–`06-…` spec sections, `adr/`/`pdr/` records, and the canonical `.claude/agents/` role-template copies; no `repos/` BC source). [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md) D3 (system-global ADRs are per-product and NOT template-delivered; the templates BC ships *role templates and canonical primers*, not a product's framework self-description) — this ADR generalizes that "NOT template-delivered" boundary from ADRs to the framework spec itself.
**Anchored on (PDR):** [PDR-001](../pdr/001-role-templates-role-complete.md) (role templates must be role-*complete* — this ADR sharpens "complete" to mean *self-contained*: the template carries the operative doctrine inline, it does not lean on a spec section the product instance won't have); [PDR-002](../pdr/002-lead-shop-roles-as-subagents.md) (roles are delivered as subagent templates inline-copied from the canonical source — the delivery surface this ADR scopes); [PDR-014](../pdr/014-lead-skill-group-pour-and-graduation-path.md) (the canonical lead skill-group and graduation path — the home this ADR assigns to situational guidance).
**Related beads:** `lead-el6r` (this principle's tracking bead), `lead-hyxx` (WS-4 — whose Part 2 / Part 3 this ADR reshapes; see Consequences).

---

## Context

The framework spec lives in this repo as the numbered section files
`01-principles.md` … `06-work-tracking.md`. Two activities have been quietly
conflated:

- **Constructing the system itself** — designing the shop-system framework:
  what a lead shop is, what a BC shop is, the inter-shop protocol, the
  work-tracking model. This is what §1–6 *describe*. They are the system's
  **self-description**, the artifact a *framework builder* reads.
- **Constructing a product WITH the system** — instantiating a lead shop and
  its BCs to build some *other* product. The agents doing this need to know
  *how to play their role* (author scenarios, pick a message vehicle, verify
  pre-state, reconcile) — they do **not** need the framework's account of why
  the framework is shaped the way it is.

These are different audiences with different needs. The framework spec answers
"why is the system designed this way?"; a product instance's role templates
answer "how do I do my job inside an instance?" An earlier inclination — recorded
and reversed here — was to **ship the framework spec §1–6 as package data** with
`shopsystem-templates` so every product instance carries it. That treats the
system's self-description as if it were operative product doctrine. It is not:
it is construction scaffolding for the system, and a product built with the
system is finished scaffolding-free.

The sharp question is whether the product role templates actually *depend* on
the spec sections they cite, or merely *gesture* at them. If the templates are
already self-contained — restating their operative doctrine inline and citing
`§x` only as provenance — then the spec is not load-bearing at the product
instance, and shipping it adds weight a fresh product never needs. The pre-state
settles this empirically.

This is a packaging / boundary / convention decision with no product-UX surface
change — hence an **ADR**, not a PDR.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

Verified from the lead CWD (`/workspaces/shopsystem-product`) on 2026-06-12
against this repo's `01-…`–`06-…` spec sections, the canonical role-template
copies at `.claude/agents/lead-architect.md` / `.claude/agents/lead-po.md`, and
`adr/`/`pdr/`. No BC source read, run, or git-observed (ADR-018 D1).

1. **The framework spec §1–6 IS the system's self-description, distinct from the
   `adr/` decision record. CONFIRMED** (read of section headers + ADR-034
   finding 3, which already drew this line). `03-lead-shop.md` §3.2 is the
   *authoritative Architect activity catalogue*; §3.4 specifies the
   turn-limited PO↔Architect exchange mechanics; the sections describe what a
   lead/BC shop *is*. This is framework-construction text, not per-product
   operative doctrine — a product instance does not re-decide what a lead shop
   is, it *is* one.

2. **The canonical role templates already RESTATE the operative doctrine inline
   and then cite `§x` as a dangling provenance footnote — the citation is not a
   content dependency. CONFIRMED** (read of `.claude/agents/lead-architect.md`).
   The template opens: *"Your job is the §3.2 Architect activity catalogue, made
   operational. The §3.2 spec catalogues eight Architect activities. Each is
   listed below with the one-line guidance that governs it."* — and then it
   **lists all eight inline** (Write ADRs, Maintain structurizr workspace,
   Collaborate with PO on BC decomposition, Assign scenarios, Reconcile scenario
   registers, Send `request_bugfix`/`request_maintenance`, Read a shop card,
   Respond to BC clarify), each with its governing guidance. A fresh product
   instance handed this template can execute every one of the eight **without
   ever opening §3.2**. The `§3.2` reference is therefore provenance, not a load-
   bearing pointer: dropping the spec breaks nothing the template needs.

3. **At least one cited behavior is genuinely situational, not ambient. CONFIRMED**
   (read of `03-lead-shop.md` §3.4 + the template's "(turn-limited)" guidance).
   The turn-limited PO↔Architect exchange (3-round cap, one extension) applies
   *only during* a BC-decomposition collaboration — it is dead prose at every
   other moment in the role. Carrying it as ambient template prose taxes every
   read of the template with guidance that is live in a narrow window. This is
   exactly the shape PDR-014's skill-group is for: conditional/situational
   guidance the agent loads *when the situation arises*, not standing prose.

4. **The "ship the spec as package data" inclination has no landed artifact —
   it was an inclination, not a shipped decision. CONFIRMED — empty.** No ADR/PDR
   pins "spec ships with templates"; ADR-034 D3 in fact already states the
   templates BC ships *role templates and canonical primers*, NOT a product's
   architecture decisions. This ADR records the inclination's consideration and
   rejection explicitly (Alternatives, Option A) so it is not re-litigated, and
   generalizes ADR-034 D3's boundary from ADRs to the spec.

5. **@scenario_hash retirement enumeration over lead-held `features/`. CONFIRMED
   — empty.** Packaging/boundary decision; this ADR authors no Gherkin and
   dispatches nothing, so it touches no pinned `@scenario_hash` coverage. (The
   downstream WS-4 templates `request_bugfix` it reshapes WILL re-run this
   enumeration at dispatch time per the Architect @scenario_hash discipline —
   see Consequences.)

---

## Decision

### D1 — The framework spec §1–6 is a system-construction artifact; it stays in the framework/lead repo and is NOT shipped to product instances

The numbered sections `01-principles.md` … `06-work-tracking.md` are the
**system's self-description** — the artifact a *framework builder* reads to
construct or evolve the shop-system itself. They are NOT shipped with the
`shopsystem-templates` package to product instances. A product built *with* the
system needs **self-contained role templates + skills** (D2, D3), not the
framework's account of its own design. The spec remains canonical and lives
here, in the framework/lead repo, exactly as today; what changes is the explicit
rule that it does **not** propagate into product instances as package data.

This **reverses the earlier "ship the spec as package data" inclination**
(finding 4). That inclination is considered and rejected (Alternatives, Option
A): it conflates the system's self-description with operative product doctrine.

### D2 — Product role templates are self-contained; external `§x` spec citations are NOT load-bearing

A product role template MUST carry, inline, the operative doctrine it currently
cites — it does not lean on a spec section the product instance will not have.
The canonical templates already meet this bar (finding 2): `lead-architect.md`
restates the §3.2 activity catalogue inline before citing it. Going forward,
external `§x` citations in product templates are treated as **bare provenance
footnotes at most, or dropped** — never as a content dependency. The test of a
self-contained template: *a fresh product instance handed only this template (no
§1–6) can execute every behavior the template names.* The canonical
`lead-architect.md` passes this test today; the bar is "stay self-contained,"
not "become self-contained."

### D3 — Conditional/situational guidance lives in skills, not ambient template prose

Guidance that is operative only *during a specific situation* (finding 3 — e.g.
the turn-limited PO↔Architect exchange, live only during a BC-decomposition
collaboration) belongs in a **skill** (PDR-014's canonical lead skill-group),
loaded when the situation arises — NOT as standing template prose that taxes
every read. This keeps the always-on template lean (the operative doctrine the
role *always* needs, D2) and routes the *sometimes*-needed guidance to the
load-on-demand surface PDR-014 establishes.

### D4 — The general test for future template authors

When adding guidance to a product role template, classify it before placing it,
by asking which of three kinds it is:

| Kind | Test | Home |
|---|---|---|
| **operative doctrine** | the role *always* needs it to do its job | **inline it** in the template (D2) |
| **situational** | the role needs it *only during* a specific situation | make it a **skill** (D3, PDR-014) |
| **system-self-description** | it explains *why the system is shaped this way* | it belongs in the **framework spec** §1–6, NOT the product (D1) |

The discriminator: *does the role always need this (inline), sometimes need this
(skill), or is this the system explaining itself to its builder (spec — keep it
out of the product)?* The third kind is the trap this ADR closes:
system-self-description masquerading as product doctrine, dragged into a product
instance that never needed it.

---

## Alternatives considered

**Option A — Ship the framework spec §1–6 as package data with
`shopsystem-templates`, so every product instance carries it (the earlier
inclination).** Rejected (D1, finding 4). It treats the system's
self-description as operative product doctrine. A product built *with* the system
does not re-decide what a lead shop is; it *is* one. The templates already carry
the operative doctrine inline (finding 2), so the spec is not load-bearing at the
instance — shipping it adds weight a fresh product never needs and blurs the
construction-of-the-system vs. construction-with-the-system boundary this ADR
draws. ADR-034 D3 already excludes a product's *decisions* from template
delivery; this generalizes the same boundary to the spec.

**Option B — Keep the `§x` citations as live, load-bearing pointers in product
templates (status quo, read literally).** Rejected (D2, finding 2). It would make
every product template *depend* on a spec the product instance does not carry —
either forcing the spec to ship after all (Option A's defect) or leaving dangling
references that resolve to nothing. The empirical pre-state shows the citations
are *already* non-load-bearing (the eight activities are fully inline), so the
honest move is to name them provenance footnotes, not pretend they are pointers.

**Option C — Put the situational guidance (turn-limited exchange, etc.) inline in
the template as ambient prose (status quo for §3.4-shaped guidance).** Rejected
(D3, finding 3). Situational guidance carried as standing prose taxes every read
of the template with guidance live only in a narrow window. PDR-014's skill-group
is the purpose-built home for load-on-demand guidance; routing situational prose
there keeps the always-on template lean.

**Option D — Delete §1–6 from the framework/lead repo entirely once templates are
self-contained.** Rejected (D1). The spec is the system's self-description and
remains canonical *for the framework builder* — it is exactly the artifact a
future framework architect (or the periodic system-architect review, ADR-035)
reads. "Not shipped to products" is not "not needed"; it stays home, it just does
not propagate outward.

---

## Consequences

- **The framework spec §1–6 stays in the framework/lead repo and is excluded
  from `shopsystem-templates` package data** (D1). The earlier "ship the spec"
  inclination is recorded as considered-and-rejected so it is not re-litigated.
- **Product role templates are held to a self-contained bar** (D2): operative
  doctrine inline, `§x` citations demoted to provenance footnotes or dropped.
  The canonical `lead-architect.md` already passes; the standing obligation is to
  *keep* templates self-contained as they evolve.
- **Situational guidance routes to the PDR-014 skill-group** (D3), not ambient
  template prose — e.g. the turn-limited PO↔Architect exchange becomes a skill
  loaded during BC-decomposition collaboration.
- **The three-way author test** (D4 — operative/situational/self-description)
  becomes the standing rule for placing any new guidance, closing the
  self-description-masquerading-as-product-doctrine trap.

### Consequence for WS-4 (`lead-hyxx`)

This ADR reshapes the WS-4 work plan:

- **WS-4 Part 2 becomes "make role templates self-contained"** — realized as a
  **`request_bugfix` to `shopsystem-templates`**: the canonical templates'
  unpinned existing behavior (citing `§x` while restating doctrine inline, per
  finding 2) is *tightened* into the explicit self-contained bar (D2), with
  situational guidance extracted to skills (D3). It is a tightening of existing
  template behavior, not new capability — message-type discriminator: the
  capability (carrying role doctrine) exists and is unpinned at the
  self-contained granularity → **`request_bugfix`**, not `assign_scenarios`. At
  dispatch time the Architect **re-runs the @scenario_hash enumeration** over
  lead-held `features/templates/` and cites it in the dispatch description per
  the Architect @scenario_hash discipline (finding 5 records it empty *for this
  ADR*; the dispatch re-runs it independently).
- **WS-4 Part 3 (citation generalization) is ABSORBED** into D2 — generalizing
  the §x-citations-are-provenance rule is no longer a separate step; it is the
  same self-contained tightening Part 2 now carries.

These WS-4 reshapings are recorded here as the plan; **no dispatch is sent and no
bd state is touched by this ADR** (per the task constraint). The `lead-hyxx`
work plan picks them up.

- **No tier collapse.** This is a system-global decision (cross-product
  packaging/boundary about what the templates BC delivers to a product
  instance); it is not a framework-doctrine edit to §1–6, and not one BC's
  internals. Tagged `system-global` per ADR-034.
- **No Gherkin authored, no dispatch sent, no `@scenario_hash` retired** here
  (finding 5).

## Cross-references

- [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md)
  — D3 (system-global ADRs are per-product, NOT template-delivered; the templates
  BC ships role templates and canonical primers, not a product's architecture
  decisions) — the boundary this ADR generalizes from ADRs to the framework spec
  itself; also finding 3 there (spec sections distinct from the `adr/` record).
- [ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md)
  — the tier model this ADR is filed under (`system-global`); the periodic
  system-architect review is a reader of §1–6 that stays in the framework repo.
- [ADR-018](018-empirical-verification-is-contract-surface.md) — the
  artifact-surface evidence rule the pre-state findings honor (no `repos/` BC
  source; templates inspected via the canonical `.claude/agents/` copies and the
  spec sections).
- [PDR-001](../pdr/001-role-templates-role-complete.md) — role-completeness,
  sharpened here to *self-contained* (D2).
- [PDR-002](../pdr/002-lead-shop-roles-as-subagents.md) — roles as subagent
  templates inline-copied from the canonical source (the delivery surface D1/D2
  scope).
- [PDR-014](../pdr/014-lead-skill-group-pour-and-graduation-path.md) — the
  canonical lead skill-group, the home assigned to situational guidance (D3).
- `01-principles.md`–`06-work-tracking.md` — the framework spec sections this ADR
  classifies as system-construction artifacts (D1); `03-lead-shop.md` §3.2 (the
  Architect activity catalogue the templates restate inline) and §3.4 (the
  turn-limited exchange D3 routes to a skill).
- [lead-el6r](beads:lead-el6r) — this principle's tracking bead.
- [lead-hyxx](beads:lead-hyxx) — WS-4, whose Part 2/Part 3 this ADR reshapes
  (Consequences).
