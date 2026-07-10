# PM technique skills + lead operations

**Status: EXPERIMENTAL.** These skills are the PM-mode skill furniture under
[PDR-033](../../pdr/033-pm-as-main-session-mode.md) (PM as a main-session mode),
adopted **experimental-first**: they live in the lead repo and are proven in use
*before* the canonical `shopsystem-templates` template group formalizes the
proven subset (LOCAL → CANONICAL, the graduation path the six PM **session**
skills already took). They are **not yet** part of the canonical pour. Tracked in
bead `lead-k9hh` (which supersedes the PDR-012 experimental slice `lead-di16` /
`lead-tgs4`).

Curation follows the operator's include list *"SKILL SET FOR SHOPSYSTEM PRODUCT
ROLES"* (2026-07-10).

## Session skills vs technique skills

- A **session skill** defines a procedure with a **mandatory terminal artifact**
  (discovery-dialogue → intent record; shaping → candidate; option-tradeoff → PDR
  draft; prioritization → prioritization record; problem-space-mapping →
  problem-space map; product-narrative → README/site/current-state). The six PM
  session skills are **canonical** — they ship from `shopsystem-templates` and
  arrive via the PDR-033 re-render, not from this directory.
- A **technique skill** is a **lens invoked *inside* a session skill**. It
  declares `Serves:` (which session skill) and `Emits into:` (which artifact its
  output lands in). It has **no terminal artifact of its own**. The skills in this
  directory (except the lead-po and lead-operations sections below) are technique
  skills.

## What these are

Adaptations — **not imports** — of skills from
[`deanpeters/Product-Manager-Skills`](https://github.com/deanpeters/Product-Manager-Skills),
rewritten for *this* shop's process and artifact system. The four adaptation
rules (updated for PDR-033):

1. **Output collapses onto our artifact system.** A PM skill's canvas, tree, or
   PR is not a new artifact type — its output lands in the **intent record**,
   **candidate**, **PDR draft**, **prioritization record**, or
   **current-state/README** the session skill already owns. No parallel artifact
   surface.
2. **PM mode IS interactive — retain the round-trip.** This **reverses** the
   retired PDR-012 rule. Under PDR-012 the PM competency sat on the *batch* lead-po
   subagent, so workshop loops were collapsed to "commit-to-specifics from best
   evidence." PDR-033 makes the PM a **main-session mode** that holds the turn open
   with the product authority, so these technique skills **keep** their dialogic /
   one-question-at-a-time / workshop form.
3. **Product-general, with a consumer / framework input fork.** The disciplines
   are identical across products; only their *inputs* fork. Each skill names both:
   a real **consumer product** (end-customer jobs, real markets) and
   **framework-as-product** (adopter / operator / BC-shop jobs, competing
   frameworks). Consumer is primary; framework-as-product is the bootstrap/meta
   instance.
4. **Build is ~free → the gate is the point.** Because the BC fleet builds exactly
   what is specified, these skills exist to stop the **build trap**. A skill that
   does not end by sharpening *what is worth building* (and what is not) has
   failed.

## The technique → session-skill → artifact map

**Serving `discovery-dialogue` (emits into the intent record):**

| Skill | Lens |
|---|---|
| [`jobs-to-be-done`](jobs-to-be-done/SKILL.md) | the stable job, pains, gains → goal-behind-the-ask + non-goals |
| [`discovery-interview-prep`](discovery-interview-prep/SKILL.md) | plan a bias-resistant discovery interview |
| [`discovery-process`](discovery-process/SKILL.md) | stage a multi-turn discovery; sequence the other lenses |
| [`problem-statement`](problem-statement/SKILL.md) | user-centered "I am / trying to / but / because / feel" frame |
| [`problem-framing-canvas`](problem-framing-canvas/SKILL.md) | reframe a solution-shaped ask → problem + "How Might We" |
| [`stakeholder-identification`](stakeholder-identification/SKILL.md) | enumerate every stakeholder, equity-aware |
| [`stakeholder-mapping`](stakeholder-mapping/SKILL.md) | Power×Interest + Impact×Power grids |
| [`stakeholder-engagement-advisor`](stakeholder-engagement-advisor/SKILL.md) | plan engagement for one critical/resistant stakeholder |
| [`incoming-request-advisor`](incoming-request-advisor/SKILL.md) | **at PM-mode ENTRY** — decode literal-ask vs job-behind-it; absorbs part of the retired router discovery gate (PDR-033 clause b) |

**Serving `shaping` (emits into the candidate):**

| Skill | Lens |
|---|---|
| [`opportunity-solution-tree`](opportunity-solution-tree/SKILL.md) | outcome → opportunities → solutions → chosen bet |
| [`pol-probe`](pol-probe/SKILL.md) | design a cheap Proof-of-Life probe → Evidence line |
| [`pol-probe-advisor`](pol-probe-advisor/SKILL.md) | select the right probe flavor from the harshest truth |
| [`derisk-measurement-advisor`](derisk-measurement-advisor/SKILL.md) | DUFV+PESTEL risk scan → rabbit-holes / no-gos |

**Serving `option-tradeoff` (emits into the PDR draft):**

| Skill | Lens |
|---|---|
| [`workshop-facilitation`](workshop-facilitation/SKILL.md) | divergence/convergence choreography over options |
| [`recommendation-canvas`](recommendation-canvas/SKILL.md) | structured per-option bet evaluation → Options + Decision |

**Serving `prioritization` (emits into the prioritization record):**

| Skill | Lens |
|---|---|
| [`prioritization-advisor`](prioritization-advisor/SKILL.md) | pick the method (MoSCoW / RICE / Kano / weighted) for the context |

**Serving `product-narrative` (emits into README / site / current-state):**

| Skill | Lens |
|---|---|
| [`press-release`](press-release/SKILL.md) | Amazon-style working-backwards PR/FAQ |
| [`eol-message`](eol-message/SKILL.md) | empathetic capability retirement; the `status: retired` brief-flip trigger |

## lead-po technique skills

| Skill | Lens |
|---|---|
| [`work-splitting`](work-splitting/SKILL.md) | import the splitting *technique* (not the user-story artifact) to right-size Epics into thin, single-behavior scenarios; emits into feature files |

*(Future lead-po adds from the include list: `example-mapping` (NEW BUILD,
rules→examples→questions → feature files) and `user-story-splitting` (adapted to
emit scenario-shaped cuts, never user stories).)*

## Lead operations skills (not PM skills)

Some skills here are **lead operational** capabilities — same experimental-first
status, different lineage.

| Skill | What it does |
|---|---|
| [`bring-up-bc`](bring-up-bc/SKILL.md) | instantiate a BC as a running container via `bc-container` so the lead can dispatch to it |
| [`create-bc`](create-bc/SKILL.md) | create a new BC from scratch — scaffold, remote, manifest, brokered launch |

## Disposition of removed / parked catalogue skills

- **Removed:** `customer-journey-map` — removed 2026-07-10 (operator decision).
- **Parked pending decision:** `company-research` — the include list parks it under
  GTM scope (PDR-033 amendment-c: market research is out of PM scope). It remains
  in this directory until the operator confirms removal.
- The include list's full **Not included** set (removed competing artifact systems
  like `prd-development` / `user-story-mapping`; parked GTM skills like
  `tam-sam-som-calculator` / `positioning-*`; removed career/meta skills) is not
  adopted.
- **Future NEW BUILDs** (not deanpeters adaptations): `event-storming` (serving
  problem-space-mapping) and `example-mapping` (lead-po). **Pending full-text
  review:** `lean-ux-canvas`, `storyboard`, `epic-hypothesis`.

## How a skill graduates

When a technique skill proves useful in real PM work, it is pinned by a Gherkin
scenario in `features/` and dispatched (`assign_scenarios` / `request_bugfix`) to
the `shopsystem-templates` BC so the canonical lead-pm skill group owns it (the
`lead_skill_group_pm_skills` LOCAL→CANONICAL path). Until then it lives here,
experimental.
