# PDR-012 — Elevate lead-po to Product-Manager-grade research scope; develop lead-architect structurizr-workspace-maintenance

**Status:** draft (2026-06-04)
**Authors:** dstengle, Claude (lead-po)
**Anchored to:** PO intent expressed in conversation 2026-06-04:
*"I want the PO to do more product-manager work vs the straightforward
product-owner work we currently do"* — covering competitive/market analysis,
domain & DDD discovery, deep-research investigations, and requirements
elicitation; with the external skill catalogue at
`github.com/deanpeters/Product-Manager-Skills` (49 skills) named as
*"quite a bit of it being useful."*

## Point of intent

This PDR records two intent commitments, both of which target §3.2 activities
that [PDR-001](001-role-templates-role-complete.md) flagged as **uncovered**
in the current role templates:

1. **Elevate the lead-po role from narrow Product-Owner scope toward
   Product-Manager scope.** Today the PO template's authored content is
   complete only for *Write Gherkin scenarios* and *Respond to BC clarify*;
   the three upstream activities — *Interview stakeholder*, *Maintain product
   brief*, *Write PDR* — carry one-line guidance but no research discipline.
   The PO's upstream work is currently *order-taking* ("a stakeholder said X,
   write scenarios for X"). The intent is to make it *product-management*:
   the PO discovers the problem, sizes and frames the opportunity, and
   investigates the domain *before* committing intent to scenarios.

2. **Develop the lead-architect *Maintain structurizr workspace* activity.**
   §3.2 names "Maintain structurizr workspace (containers, components,
   dynamic views)" and §3.3 names the Structurizr DSL workspace as a
   lead-owned artifact. PDR-001's gap table marks this activity *No* (uncovered).
   Today the template carries a single paragraph of guidance with no
   sufficiency criteria for *which* views must be maintained or *when* the
   workspace must change relative to assignment. The intent is to give the
   activity sufficiency criteria of the same grade as the message-type
   activities already carry.

This PDR is **intent, not implementation.** Per PDR-001's "What this leaves
open," the concrete restructure of `lead-po.md` and `lead-architect.md` is BC
work owned by the
[`shopsystem-templates`](https://github.com/dstengle/shopsystem-templates)
BC. This PDR names *what the restructured templates must cover* and the
*sufficiency criteria* each activity must satisfy; the accompanying Gherkin
scenarios (`features/templates/146`–`151`) pin those requirements and the
Architect dispatches them via `assign_scenarios`.

## The four research flavors (lead-po elevation)

The PM elevation is scoped to **four research flavors**. Each flavor names the
discipline the PO must carry, the artifact it produces (mapped onto the §3.3
artifacts the PO already owns — interview notes, brief, PDR), and the
sufficiency criterion that distinguishes product-management work from
order-taking.

### Flavor 1 — Competitive / market analysis

**What it is:** Before committing intent, the PO situates the desired behavior
against the market — who else solves this, where the product is positioned,
how large the addressable space is. **Artifact:** brief (a positioning /
market-context section) and/or a PDR rationale grounded in market facts.
**Sufficiency criterion:** the analysis names at least one concrete external
reference point (a competitor, an alternative the user "hires" today, or a
sized market segment) rather than asserting desirability in a vacuum. A market
claim with no external reference point is an opinion, not analysis.

### Flavor 2 — Domain & DDD discovery

**What it is:** The PO discovers the *problem space* — the jobs the user is
trying to get done, the ubiquitous-language terms, the subdomain boundaries —
so that the downstream BC decomposition (the Architect's job) rests on a
genuine domain model rather than on implementation convenience. This is the
PO's contribution to the §3.4 turn-limited decomposition collaboration.
**Artifact:** interview notes and brief, expressed in domain language (jobs,
pains, gains; candidate subdomains; ubiquitous-language glossary).
**Sufficiency criterion:** the discovery separates *problem* from *solution*
(names the job-to-be-done distinctly from any proposed feature) and names the
ubiquitous-language terms a downstream scenario or clarify would otherwise
have to invent.

### Flavor 3 — Deep-research investigations

**What it is:** For a non-obvious intent commitment, the PO runs a bounded
investigation — gathering external evidence (company/market research, prior
art, context) and synthesizing it — rather than deciding from intuition.
**Artifact:** a PDR whose "options considered" and "rationale" sections cite
the investigation. **Sufficiency criterion:** the investigation is *bounded*
(it names what question it set out to answer and stops when answered) and its
synthesis is *cited* (the PDR rationale points at the evidence, not at a
hunch). An unbounded "research forever" investigation and an uncited "I looked
into it" are both failures.

### Flavor 4 — Requirements elicitation

**What it is:** The PO turns discovered problems into well-formed requirements
— framing the problem, splitting epics into right-sized units, and writing the
Gherkin scenarios that pin behavior. This flavor *connects to* the existing
*Write Gherkin scenarios* activity rather than replacing it: the scenario
authoring sufficiency check (already in the template) is the terminal gate;
this flavor adds the upstream discipline (problem framing, story splitting)
that feeds well-formed scenarios into that gate. **Artifact:** brief, PDR, and
scenarios. **Sufficiency criterion:** each elicited requirement traces back to
a discovered problem (Flavor 2) and forward to at least one testable scenario;
a requirement that traces to neither is scope drift.

## Skill-to-activity mapping (experimental-first)

The deanpeters PM skill catalogue is **experimentally adopted, not wholesale
imported.** Per our established discipline (adapt to our process, run
experimental slices, formalize via the standard process only once proven —
see the TDD/superpowers precedent), the proven subset is staged as adapted
`.claude/skills/` in the lead repo first; the template later owns or
references the subset that survives the experiment. The mapping below is the
*candidate* set, not a commitment to ship all of it.

| Flavor | Candidate PM skills (adaptation targets) |
|---|---|
| Competitive / market | company-research, pestel-analysis, tam-sam-som-calculator, positioning-statement, positioning-workshop, acquisition-channel-advisor, organic-growth-advisor |
| Domain & DDD discovery | jobs-to-be-done, opportunity-solution-tree, problem-framing-canvas, problem-statement, customer-journey-map (+workshop), proto-persona, discovery-process, discovery-interview-prep, user-story-mapping (+workshop) |
| Deep-research | company-research, context-engineering-advisor (+ essays "The Product Manager as an Orchestrator", "Context Engineering for Product Managers") |
| Requirements elicitation | prd-development, epic-hypothesis, epic-breakdown-advisor, user-story, user-story-splitting, recommendation-canvas, press-release (working-backwards), lean-ux-canvas |
| PM-grade strategy / prioritization (supporting) | prioritization-advisor, product-strategy-session, roadmap-planning, altitude-horizon-framework, feature-investment-advisor |

**Adaptation constraints** (carried from the TDD precedent so the next slice
does not re-litigate them):

- These skills carry their own process furniture — `type: interactive`,
  `type: workflow`, human-checkpoint steps, their own artifact templates (PRD,
  canvases). That furniture must be **adapted** to shopsystem, not wrapped:
  the PM artifacts collapse onto the §3.3 artifacts the PO already owns
  (interview notes, brief, PDR, scenarios). The skill's PRD becomes a brief /
  PDR section; its canvases become brief content; its "interactive" question
  loops become the PO's own interview discipline.
- A PM skill's **human-checkpoint** maps onto the PO's *commit-to-specifics*
  posture: where a skill would pause for human sign-off, the PO either commits
  the specific (the default) or records explicitly that it cannot commit yet —
  it does not stall. The PO does not introduce a stakeholder round-trip the
  shopsystem loop does not already have.

## Structurizr-workspace-maintenance development (lead-architect)

The *Maintain structurizr workspace* activity must carry sufficiency criteria
naming, at minimum:

1. **Which views.** The three view families §3.2 names explicitly —
   **containers, components, dynamic** — must all be in scope of the
   activity's discipline, not only the static container view.
2. **The "assign per structurizr" coupling.** The workspace is the
   *instrument* that drives scenario-to-BC assignment (§3.2: "Assign scenarios
   to BCs **per structurizr**"). The sufficiency criterion must make explicit
   that a BC named in an `assign_scenarios` dispatch must correspond to a
   container/component in the workspace — assigning to a BC the workspace does
   not model is a structural gap.
3. **ADR ↔ workspace traceability.** Carrying forward the guidance already in
   the template: every workspace edge traces to an ADR and every structural
   ADR shows up in the workspace. The development adds that this is a
   *sufficiency gate on the activity*, not merely advisory prose.

## Options considered

- **(A) Import the 49 PM skills wholesale into the template.** Rejected:
  violates our adopt-experimentally discipline; the skills' process furniture
  does not line up with shopsystem (same lesson as the TDD/superpowers
  integration); and PDR-001 says template restructure is BC work, not a
  lead-side dump of external content.
- **(B) Author the elevation as a single monolithic "PM research" activity.**
  Rejected: the four flavors have distinct sufficiency criteria and distinct
  failure modes; collapsing them hides the criteria that make each one
  testable, and the names-every-activity / guidance-or-pending scenario
  pattern (features/templates 10/11/14/15) wants each activity named.
- **(C, chosen) Record intent + sufficiency criteria here; pin them with
  Gherkin scenarios in the existing template-scenario family; mark
  still-developing areas pending per PDR-001 decision #2; dispatch the
  restructure to the templates BC.** Matches PDR-001's division of labor and
  the established experimental-first adoption discipline.

## Decision

1. The lead-po template SHALL **name each of the four research flavors** as
   activities (or as named discipline within the upstream §3.2 activities) and
   carry **either sufficiency criteria or an explicit "guidance pending"
   marker** for each — same bar PDR-001 decision #2 set for every §3.2
   activity.
2. The four flavors' sufficiency criteria are as stated above (one concrete
   external reference point; problem-separated-from-solution + named ubiquitous
   language; bounded + cited investigation; each requirement traces back to a
   problem and forward to a testable scenario).
3. The PM skill catalogue is **experimentally adopted** — staged as adapted
   `.claude/skills/` first, with the template owning the proven subset later.
   No wholesale import.
4. The lead-architect template's *Maintain structurizr workspace* activity
   SHALL carry sufficiency criteria covering the three view families
   (containers, components, dynamic), the assign-per-structurizr coupling, and
   ADR↔workspace traceability — or mark any of these "guidance pending."
5. **Identity-precedes-procedure is preserved.** The elevation adds activity
   coverage and research discipline; it does not move procedural CLI content
   above the role identity/posture, and it does not weaken the existing
   posture statements (COMMIT TO SPECIFICS; PRE-STATE DETERMINES VEHICLE).

## What this leaves open (pending, per PDR-001 decision #2)

- **The concrete per-flavor skill subset that ships in the template** is
  pending the experimental slices — the mapping table above is candidate, not
  committed. Until a flavor's skill subset is proven, the template marks that
  flavor's *tooling* "guidance pending" even though the flavor's *sufficiency
  criterion* is committed here.
- **Whether the four flavors become four new named template subsections or
  enrich the three existing upstream activities** (Interview / Brief / PDR) is
  a template-authoring decision owned by the templates BC; the scenarios pin
  that the names and criteria appear, not the heading structure.
- **PM-grade strategy/prioritization** (prioritization-advisor,
  roadmap-planning, altitude-horizon, feature-investment) is named as a
  *supporting* cluster, not a fifth flavor; whether it earns its own activity
  is **guidance pending** a later intent commitment.
- **The structurizr DSL toolchain / rendering** (how the workspace is
  validated or rendered) is out of scope here; this PDR develops the
  *activity discipline*, not the tooling.

## Cross-references

- [§3.2 Lead-shop activities](03-lead-shop.md#32-activities) — the activity
  catalogue this PDR develops coverage against.
- [§3.3 Artifacts owned](03-lead-shop.md#33-artifacts-owned) — interview
  notes, brief, PDR, structurizr workspace; the PM artifacts collapse onto
  these.
- [PDR-001](001-role-templates-role-complete.md) — role-complete templates;
  the gap table this PDR closes two rows of, and the BC-ownership division
  of labor this PDR follows.
- The TDD/superpowers integration precedent for experimental-first external
  skill adoption (lead-tgs4 initiative; memory `project_tdd_skill_integration`).
