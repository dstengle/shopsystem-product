# Experimental PM research skills (lead-po)

**Status: EXPERIMENTAL.** These skills are the first slice of the
Product-Manager elevation in [PDR-012](../../pdr/012-lead-po-product-manager-scope-and-architect-structurizr-maintenance.md),
adopted **experimental-first**: they are adapted into the lead repo and proven
in use *before* the lead-po role template (owned by the `shopsystem-templates`
BC) formalizes the proven subset. They are **not yet** part of the canonical
template. Tracked in bead `lead-di16` under initiative `lead-tgs4`.

## What these are

Adaptations — **not imports** — of skills from
[`deanpeters/Product-Manager-Skills`](https://github.com/deanpeters/Product-Manager-Skills).
Each source skill was rewritten for *this* shop's process. The four adaptation
rules (from PDR-012, carried from the TDD/superpowers precedent):

1. **Artifacts collapse onto our §3.3 artifacts.** A PM skill's PRD, canvas, or
   tree is not a new artifact type — its output lands in the **product brief**,
   a **PDR**, or **Gherkin scenarios** the PO already owns. No parallel artifact
   surface.
2. **Interactive/workshop loops → COMMIT-TO-SPECIFICS.** The source skills run a
   human through one question at a time and pause for sign-off. The PO does not
   stall: it commits the specific from best evidence, or records explicitly what
   it cannot yet commit (as a `clarify` to the operator, or a bounded research
   task). It never introduces a stakeholder round-trip the shopsystem loop does
   not already have.
3. **Product-general, with a consumer/framework input fork.** The disciplines are
   identical across products; only their *inputs* fork. Each skill names both
   forks: a real **consumer product** (end-customer jobs, competitor companies,
   real markets) and **framework-as-product** (adopter/operator/BC-shop jobs,
   competing frameworks, the developer-experience "market"). Consumer is the
   primary case; framework-as-product is the bootstrap/meta instance.
4. **Build is ~free → the gate is the point.** Because the BC fleet builds
   exactly what is specified, these discovery skills exist to stop the **build
   trap**. A skill that does not end by sharpening *what is worth building* (and
   what is not) has failed.

## The slice → discipline map (PDR-012)

| Skill | Discipline | Lands in |
|---|---|---|
| [`jobs-to-be-done`](jobs-to-be-done/SKILL.md) | D1 — Problem discovery & selection | brief (jobs/pains/gains); problem statements |
| [`problem-framing-canvas`](problem-framing-canvas/SKILL.md) | D1 — Problem discovery & selection | brief/PDR problem statement + "How Might We" |
| [`opportunity-solution-tree`](opportunity-solution-tree/SKILL.md) | D1 — Problem discovery & selection | PDR (outcome → opportunities → bet); chosen behavior → Gherkin |
| [`customer-journey-map`](customer-journey-map/SKILL.md) | D1 — Problem discovery & selection | brief (journey stages + friction/emotion curve); PDR problem statement (highest-friction moment); findings |
| [`company-research`](company-research/SKILL.md) | D1 — consumer-fork market input | brief market/competitive context |
| [`work-splitting`](work-splitting/SKILL.md) | D4 — specification (right-sizing) | Epic → scenarios; thin single-behavior scenarios |

The Discipline-1 cluster (jobs/framing/tree/journey-map) is on purpose — the
determination named it "the scarcest good," and it is exactly
where the current order-taking PO is weakest. `customer-journey-map` adds the one
**sequence-and-friction** lens the others lack: JTBD and framing are point-in-time
(the stable job, the acute pain), while the journey map locates *where across the
sequence* the experience breaks (moments-of-truth, cognitive-load spikes,
drop-off). Like the other experimental PM skills here, it is vulnerable to the
`lead-1e8d` shop-templates over-prune until that bead lands; until then it lives
in this repo, unprotected by the canonical template. `work-splitting` adds the first
**Discipline 4** (specification) slice — it imports the splitting *technique*
(not the user-story artifact) to right-size Epics into thin, single-behavior
scenarios, and is also the candidate the BC template would deliver for the BC
decomposition discipline (`lead-ir9m`). A later slice adds Discipline 3
(strategy: `product-strategy-session`, `prioritization-advisor`).

## Lead operations skills (not PM disciplines)

Some skills here are **lead operational** capabilities rather than PM research
disciplines — same experimental-first status, different lineage.

| Skill | What it does |
|---|---|
| [`bring-up-bc`](bring-up-bc/SKILL.md) | Instantiate a BC as a running container via `bc-container` so the lead can dispatch to it (DSN/network, the devcontainer `BCLAUNCHER_HOST_HOME` gotcha, verification). |

## How a skill graduates

When a skill proves useful in real lead work, it is pinned by a Gherkin scenario
in `features/` and dispatched (`assign_scenarios`) to the `shopsystem-templates`
BC so the canonical lead template owns it. Until then it lives here, experimental.
