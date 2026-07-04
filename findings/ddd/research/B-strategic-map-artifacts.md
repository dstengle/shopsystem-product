# Angle B — System / Strategic DDD Artifacts: mapping how contexts RELATE and deciding WHERE capabilities belong

Research brief (angle B of 3). Purpose: choose DDD artifacts that (a) map how our
bounded contexts relate and (b) decide where capabilities belong — with specific
attention to resolving **overloaded contexts** and the **"build-pipeline
MANAGEMENT vs EXECUTION"** placement question. Deliverable is OPTIONS + BACKGROUND,
not a decision.

> Scope note: this angle is the *system/strategic* layer — relationships between
> contexts and placement of capabilities. Tactical modeling (aggregates, events,
> EventStorming inside one context) is a sibling angle, not covered here.

## Our system, in one paragraph (for the concrete examples)

The lead shop's `bc-manifest.yaml` registers six Bounded Contexts:
`shopsystem-messaging`, `shopsystem-scenarios`, `shopsystem-templates`,
`shopsystem-test-harness`, `shopsystem-devcontainer`, and
`shopsystem-bc-launcher`. Recent ADRs add three build-pipeline concerns whose
homes are the live question: **bc-launcher** *manages* the pipeline (owns the BC
base image, triggers auto-rebuilds on utility release — ADR-021/022, and launches
BCs — ADR-004/050); **fabro** is an *in-container orchestration substrate* for the
BC gated loop (ADR-048/050/051); **dagger** is the *build/test execution
substrate*, local and CI (ADR-052/053). That spread — one context that launches,
owns an image, and triggers rebuilds, sitting beside two "substrate" concerns — is
exactly the kind of overload/placement question the artifacts below are designed to
expose. These names recur as the concrete examples throughout.

---

## 1. Context Map + context-mapping patterns

**What it is + origin.** The Context Map is Eric Evans' strategic-design artifact
(*Domain-Driven Design*, 2003): a single picture of all the Bounded Contexts in
play and the **relationship pattern** on each edge between them. The pattern
vocabulary was later curated and standardized by the DDD community (ddd-crew,
Context Mapper, the Open Group's O-AA standard).

**What it captures.** Every integration edge is labelled with one of nine patterns,
which split into upstream/downstream (power/direction) categories:

- **Partnership** — two contexts succeed or fail together; coordinated change.
- **Shared Kernel** — a deliberately shared subset of model/code; high coupling,
  needs joint governance.
- **Customer/Supplier** — upstream prioritizes the downstream's needs.
- **Conformist** — downstream simply adopts upstream's model (no translation).
- **Anticorruption Layer (ACL)** — downstream inserts a translation layer to keep
  the upstream's model out of its own.
- **Open Host Service (OHS)** — upstream publishes a stable protocol for many
  consumers.
- **Published Language (PL)** — a documented, shared interchange format (often
  paired with OHS).
- **Separate Ways** — no integration; contexts stay independent on purpose.
- **Big Ball of Mud** — an explicit demarcation of a region with mixed models and
  inconsistent boundaries, drawn so the mess is *named* and kept from contaminating
  neighbors.

**How it helps spot mis-homed / overloaded capabilities.** This is the primary
overload-detector of the set. Three tells:

1. **The Big Ball of Mud label** is literally a "demarcation of a bad model or
   system quality" — you draw it around a context whose responsibilities have
   blurred. If `bc-launcher` is doing launch **and** base-image ownership **and**
   rebuild-triggering, mapping it forces the question of whether one box is really
   two or three.
2. **Edge-count and pattern-mix per node.** A single context that is simultaneously
   Supplier to some, Shared-Kernel with others, and Conformist to a third is a
   coupling hotspot — the map makes the fan-in/fan-out visible in a way an ADR list
   never does. (ADR-022 already fought this: it *centralized* base-rebuild in
   bc-launcher rather than fanning-in dispatch — a Context Map would show that edge
   consolidation directly.)
3. **Missing ACLs on high-traffic downstream edges** flag places where an
   upstream's model is leaking in (Conformist where you wanted isolation).

**Strengths.** Cheap; the shared vocabulary turns "these two are tangled" into a
named, discussable pattern; directional edges expose power and change-coupling;
scales from a whiteboard to a governed artifact.

**Weaknesses.** Purely relational — it says nothing about *investment worth* (that
is Core-Domain-Chart / subdomain territory). Grows unwieldy if you try to draw the
whole landscape at once; ddd-crew's own guidance is to draw **small, focused maps
that answer one question**, with multiple maps for multiple viewpoints, and to
annotate each pattern so non-DDD stakeholders can read it.

**Effort.** Low. A first map is a 60–90 min whiteboard session; the six BCs plus
the three pipeline concerns fit on one page. Keeping it current is the only ongoing
cost (addressed by ContextMapper, §6).

**Concrete example (ours).** Draw: `scenarios` publishes the canonical scenario
model → most BCs are **Conformist/Customer** to it; `messaging` is an **Open Host
Service / Published Language** (the `shop-msg` protocol every BC speaks);
`agent-vault` is a **Supporting** supplier reached over a published credential
surface (ADR-026/028). Now place `bc-launcher`: it is Supplier to every BC (it
launches them) *and* owns the base image every BC inherits (Shared-Kernel-like
coupling) *and* triggers their rebuilds. That triple-role node is the visual
overload signal; the map is where you'd decide to split "launch/manage" from
"base-image ownership."

Sources: [ddd-crew/context-mapping](https://github.com/ddd-crew/context-mapping),
[Context Mapper — Context Map](https://contextmapper.org/docs/context-map/),
[Open Group O-AA — DDD strategic patterns](https://pubs.opengroup.org/architecture/o-aa-standard/DDD-strategic-patterns.html),
[Software Architecture Guild — Integration of Bounded Contexts](https://software-architecture-guild.com/guide/architecture/domains/integration-of-bounded-contexts/).

---

## 2. Subdomain classification: Core / Supporting / Generic

**What it is + origin.** Evans' strategic distinction between three *subdomain*
kinds; sharpened by Vaughn Vernon and (for the investment framing) Vlad Khononov.
Where a Context Map answers *how contexts relate*, subdomain classification answers
*how much each is worth and therefore how it should be built and where it should
live*.

**What it captures.** For each capability/subdomain, one label:

- **Core** — a genuine business differentiator; high complexity **and** high
  differentiation; deserves your best people, rich modelling, custom build.
- **Supporting** — necessary but not a differentiator, and too specific to buy
  off-the-shelf; moderate investment, pragmatic patterns, no over-engineering.
- **Generic** — a solved, common problem; buy/adopt SaaS or open source rather than
  build.

**How it helps spot mis-homed / overloaded capabilities — and the pipeline
question.** This is the artifact that most directly reasons about **build-pipeline
management vs execution**, because it asks *"is this a differentiator or a
commodity?"* of each half:

- **Execution** — actually building/testing images and running the gated loop — is
  a **Generic** subdomain: it is what `dagger` (build/test) and `fabro` / OCI
  runtimes (orchestration) are *for*. DDD's prescription for Generic is **buy/adopt,
  don't build** — which is exactly why ADR-052/048 wrap existing engines rather than
  writing our own. Custom code here is misinvestment.
- **Management** — *which* image, *when* to rebuild, coherence gating, release
  wiring, the manifest/BOM (ADR-047), presence/heartbeat — is where the framework's
  actual differentiation lives. That is **Core (or at least Supporting)** and
  belongs in first-class, richly-modelled framework code.

Classification thus gives you the crisp rule for the placement question:
**management is the differentiating subdomain, execution is the generic substrate;
they should not live in the same context.** A context that mixes them is a
Core-mixed-with-Generic smell — the strongest single argument for splitting
`bc-launcher`'s *policy* (management) from the *engines* it drives (execution). The
related anti-pattern to watch, from the Core Domain literature, is **"Suspect
Supporting"**: a supposedly-supporting box carrying too much complexity usually
means either accidental tech-debt or a mis-classification — apply it to any BC that
feels heavier than its label.

**Strengths.** Turns "where should this go?" into a defensible investment rule;
directly prescribes build-vs-buy; needs no tooling.

**Weaknesses.** Labels are judgement calls and drift over time (today's Core is
tomorrow's Generic — see Wardley/evolution, §5). Says nothing about relationships or
coupling — pairs with, but does not replace, the Context Map.

**Effort.** Very low. A labelling pass over the manifest + pipeline concerns is a
single workshop; the payoff is the placement rule above.

**Concrete example (ours).** Label the pipeline: `dagger` build/test = **Generic**
(wrap, don't replace — ADR-052/053 already commit to this); `fabro` loop
orchestration = **Generic** substrate (ADR-048, alternable); coherence
gate + manifest/BOM + release wiring (ADR-047) = **Core** (the framework's
distinctive value); `messaging`/`shop-msg` = **Core** (the framework's own
protocol); `agent-vault` credential brokering = **Supporting** (ADR-028 names it a
"lead-shop supporting service"). The moment you write those labels, "management vs
execution" resolves to "Core policy vs Generic substrate — keep them in separate
contexts."

Sources: [Core vs Supporting vs Generic (ilovedotnet)](https://ilovedotnet.org/blogs/ddd-core-supporting-generic-domains/),
[Vaadin — Strategic DDD](https://vaadin.com/blog/ddd-part-1-strategic-domain-driven-design),
[Jonathan Oliver — Core/Supporting/Generic subdomains](https://blog.jonathanoliver.com/ddd-strategic-design-core-supporting-and-generic-subdomains/),
[SAP curated-resources — core concepts](https://github.com/SAP/curated-resources-for-domain-driven-design/blob/main/blog/0002-core-concepts.md).

---

## 3. Core Domain Charts (Nick Tune)

**What it is + origin.** A visual portfolio tool by Nick Tune (ddd-crew), plotting
each Bounded Context on two axes so the whole system's investment posture is legible
at a glance. It operationalizes the Core/Supporting/Generic idea into a coordinate
space.

**What it captures.** Two axes:

- **Y — Model Complexity**: effort to learn, model, and maintain the context
  (engineers gauge this).
- **X — Business Differentiation**: competitive advantage / ROI potential (product
  gauges this).

Named regions/patterns include **Decisive Core** (high/high — market-leader maker),
**Short-Term Core** (high differentiation, low complexity — undefendable, gets
copied), **Table Stakes / Former Core** (once-core, now industry standard),
**Commoditized Core** (now replaceable by SaaS/OSS, e.g. Elasticsearch for search),
and the misinvestment flags **Hidden Core** and **Suspect Supporting** (a
"supporting" box carrying core-level complexity — a signal of tech-debt or
mis-classification).

**How it helps spot mis-homed / overloaded capabilities.** The chart's whole job is
flagging **misinvestment and mis-placement**: a context sitting in the wrong region
is a placement error you can *see*. Two payoffs for us:

1. A **generic** concern (dagger/fabro execution) that we find ourselves investing
   in as if it were core would plot as high-complexity-low-differentiation — the
   chart says "commoditize / adopt, stop hand-building."
2. An overloaded context plots as **one dot that wants to be two**: if `bc-launcher`
   scores high-differentiation on its management responsibilities but drags generic
   execution complexity with it, the single dot straddles regions — the visual case
   for a split.

**Strengths.** One picture aligns product + engineering on where to invest; makes
misinvestment and overloaded contexts visually obvious; directly extends §2 with
a portfolio view.

**Weaknesses.** Axis scoring is subjective and needs both product and engineering
in the room; a point-in-time snapshot (evolution over time is Wardley's job, §5);
adds little over plain Core/Supporting/Generic labels if you only have a handful of
contexts.

**Effort.** Low–moderate. One facilitated workshop to score and plot the six BCs +
pipeline concerns; ddd-crew ships a free Miro/templated toolkit.

**Concrete example (ours).** Plot: `messaging` and the coherence-gate/manifest
machinery high on both axes (**Core**); `dagger`/`fabro` low differentiation, whatever
their complexity (**Generic / commoditize — wrap not build**); `agent-vault` low-mid
differentiation (**Supporting**); `templates`/`devcontainer` low/low. `bc-launcher`
plotted honestly is the tell — if it lands as a smeared dot spanning core-management
and generic-execution, that's the chart telling you to split it.

Sources: [Nick Tune — Core Domain Patterns](https://medium.com/nick-tune-tech-strategy-blog/core-domain-patterns-941f89446af5),
[ddd-crew/core-domain-charts](https://github.com/ddd-crew/core-domain-charts),
[esilva.net — Core Domain Charts (Tune)](https://esilva.net/tla_insights/core-domain-charts_tune).

---

## 4. C4 model (System Context + Container)

**What it is + origin.** Simon Brown's four-level notation for software
architecture — Context, Container, Component, Code. In practice most teams use only
levels 1–2 (System Context and Container).

**What it captures.** **System Context** = the system as one box with its users and
external systems around it. **Container** = the deployable/runnable units (services,
apps, datastores) inside the system and how they talk. Crucially, at the Container
level **a container maps naturally onto a Bounded Context** — so C4 gives the
*deployment/runtime* view that a DDD Context Map (a *conceptual/relational* view)
deliberately abstracts away.

**How it helps spot mis-homed / overloaded capabilities.** It is complementary, not
primary: C4 shows *where code actually runs*, which surfaces a specific overload
signature — **one deployable doing several conceptual jobs.** If the Context Map says
"bc-launcher is three responsibilities" and the C4 Container diagram shows those
three all inside one running container/process, you've confirmed the overload is
real at runtime, not just conceptual. Conversely, C4 can reveal the opposite:
concepts that *should* be one context scattered across many containers.

**Strengths.** Low ceremony, widely understood, great for onboarding and for the
runtime/deployment picture DDD maps omit; integrates cleanly with DDD (containers ⇄
bounded contexts).

**Weaknesses.** Notation is *not* a DDD concept framework — it shows structure, not
relationship semantics (no Conformist/ACL/OHS vocabulary), and nothing about
investment worth. Common misuse: treating a Container diagram as a full architecture
model. Use it *with* a Context Map, not instead of one.

**Effort.** Low. Levels 1–2 for our system are a couple of diagrams; tooling
optional (Structurizr, or just boxes).

**Concrete example (ours).** System Context: "shopsystem framework" box, with
*product teams* and *GitHub/registry/agent-vault* as externals. Container view: the
lead shop, the postgres messaging store, agent-vault, and each BC as a
`bc-launcher`-run container — this is where you'd *see* whether launch, base-image
ownership, and rebuild-trigger are one container or several, corroborating §1/§3.

Sources: [c4model.com](https://c4model.com/),
[C4 model — Wikipedia](https://en.wikipedia.org/wiki/C4_model),
[Misuses and mistakes of the C4 model](https://www.workingsoftware.dev/misuses-and-mistakes-of-the-c4-model/),
[ddd.academy — visualising software architecture](https://ddd.academy/visualising-software-architecture/).

---

## 5. Wardley Mapping (brief — a strategic/evolution lens)

**What it is + origin.** Simon Wardley's strategy map: components arranged in a
**value chain** (Y, anchored on a user need, visible→invisible) against an
**evolution** axis (X: Genesis → Custom-Built → Product → Commodity/Utility).

**What it captures.** Not relationships or model complexity, but **maturity and
movement**: where each capability sits on the commoditization curve and which way
it's drifting. Transitions (Custom→Product, Product→Commodity) are the strategic
decision points — build, buy, or divest.

**How it helps spot mis-homed / overloaded capabilities.** It catches a *temporal*
mistake the other artifacts miss: **custom-building something that has evolved into
a commodity.** This is precisely the build-pipeline execution question over time —
container build (dagger) and loop orchestration (fabro/OCI runtimes) are commodities;
Wardley makes "stop hand-rolling the substrate, ride the commodity" a positioned,
defensible move rather than an opinion. It also flags Core capabilities silently
sliding toward commodity (so you disinvest before over-investing).

**When it adds value vs overkill for us.** *Value*: settling build-vs-buy on the
pipeline substrate, and any recurring "should we own this engine?" debate — Wardley
is the sharpest lens for exactly that. *Overkill*: for the day-to-day placement/
overload work with only ~six contexts, a Core/Supporting/Generic pass (§2) plus a
Context Map (§1) delivers most of the insight at a fraction of the facilitation cost.
Reach for Wardley on the specific evolution/build-vs-buy calls, not as the default
map.

**Effort.** Moderate–high (facilitation-heavy; the user-need anchoring and evolution
placement take practice). Use selectively.

**Concrete example (ours).** Anchor on the product-team need "get a BC built,
launched, and gated." Chain: coherence-gate/manifest (Custom-Built, differentiating)
→ launch/management (Product-ish) → **build/test + loop orchestration far right in
Commodity** (dagger/fabro). The map's punchline is visual: our *management* concerns
sit left (invest), our *execution* substrate sits right (adopt) — the same
management-vs-execution split, now expressed as evolution.

Sources: [Wardley map — Wikipedia](https://en.wikipedia.org/wiki/Wardley_map),
[wardleymaps.com — Evolution Stages](https://www.wardleymaps.com/glossary/evolution-stages),
[lethain.com — Refining strategy with Wardley Mapping](https://lethain.com/wardley-mapping/).

---

## 6. ContextMapper (open-source DSL) — a living-artifact medium

**What it is + origin.** An open-source (Apache-2) project offering **CML**, an
Xtext-based DSL for expressing Bounded Contexts and Context Maps **as text**, with
generators that produce graphical Context Maps, PlantUML, service-decomposition
suggestions, and MDSL contracts. VS Code and Eclipse tooling.

**What it captures.** The same strategic content as §1 — Bounded Contexts and their
relationship patterns (Partnership, Shared Kernel, Customer/Supplier, Conformist,
OHS, PL, ACL, Separate Ways) — but version-controllable, diffable, and
auto-visualized. It also reaches into tactical patterns (Aggregates, Entities,
Services) if desired.

**How it helps spot mis-homed / overloaded capabilities.** Two ways beyond a
whiteboard map: (1) making the map a **committed text artifact** means it lives next
to our ADRs and evolves with them — placement decisions stop rotting; a
`bc-launcher` split shows up as a reviewable diff. (2) ContextMapper ships
**architectural-refactoring / service-decomposition** transformations that can
*suggest* splitting or merging contexts from the model — tool-assisted overload
detection, not just eyeballing.

**Strengths.** Text = diffable, reviewable, CI-checkable; auto-generated diagrams
never drift from the source; strong fit for a codebase that already governs decisions
as committed markdown/ADRs.

**Weaknesses.** A real DSL to learn and a JVM/VS-Code toolchain to run; likely
overkill for six contexts unless we commit to keeping the map long-term; couples the
artifact to a specific tool.

**Effort.** Moderate to stand up (learn CML, wire generation); low to maintain once
running.

**Concrete example (ours).** A `system.cml` in the lead repo declaring the six BCs
plus pipeline concerns, edges like `bc-launcher -> [OHS,PL] messaging` and
`scenarios [U,S]-> * [D,CF]`, checked in beside `bc-manifest.yaml`, regenerating a
PNG on commit. It becomes the durable home for the very split decisions §1–§3
surface.

Sources: [contextmapper.org](https://contextmapper.org/),
[ContextMapper/context-mapper-dsl (GitHub)](https://github.com/ContextMapper/context-mapper-dsl),
[mimacom — DDD in practice with Context Mapper](https://blog.mimacom.com/ddd-and-context-mapper-experience/),
[ozimmer.ch — Context Mapper insights](https://ozimmer.ch/modeling/2022/11/23/ContextMapperInsights.html).

---

## The DDD framing for "build-pipeline MANAGEMENT vs EXECUTION"

**Short answer: it is best framed as TWO subdomains of different kinds — a Core/
Supporting *management* subdomain and a Generic *execution* subdomain — and, at the
runtime/architecture layer, as a control-plane / data-plane split. It is not one
context.** The field gives you two complementary vocabularies:

**Vocabulary 1 — DDD subdomain kinds (the "why they differ in worth" layer).**
- *Management* (which image, when to rebuild, coherence gating, release/BOM wiring,
  presence) is the **differentiating** concern → **Core** (or Supporting), custom
  build, rich model.
- *Execution* (actually building/testing images, running the gated loop) is a
  **solved, common** concern → **Generic**, adopt/wrap don't build.
- The rule: **do not co-locate a Core management concern and a Generic execution
  concern in one Bounded Context.** A context that mixes them is the classic
  "Suspect Supporting"/Big-Ball-of-Mud smell. This is the single most decisive lens.

**Vocabulary 2 — control/data/management planes (the "how they split at runtime"
layer, from networking/platform architecture).**
- **Control plane** — makes decisions: orchestration, scheduling, policy, monitoring.
  = our *management* concern.
- **Data plane** — executes the actual work per the control plane's instructions.
  = our *execution* substrate (dagger builds, fabro/OCI runs the loop).
- **Management plane** — the configuration/observation surface (CLIs, dashboards,
  config files) you use to tell the system what you want. = `bc-container` / manifest
  / `shop-msg` operator surfaces.
- The canonical example the literature uses is *literally an ETL/CI pipeline*: the
  control plane schedules jobs and defines pipeline logic; the data plane does the
  extract/transform/load. Their headline benefit — *"modify orchestration logic
  without disrupting execution, and change execution engines without touching
  policy"* — is exactly the decoupling we'd gain by separating pipeline management
  from dagger/fabro. This is our ADR-052/053 "wrap, not replace" and ADR-048
  "alternable substrate" instincts stated in the field's own terms.

**Synthesis.** The two vocabularies agree and stack: *management = Core control-plane
context; execution = Generic data-plane substrate you adopt.* Together they say the
build-pipeline concern is **two subdomains** with a **plane boundary** between them,
and that today's coupling of launch + base-image ownership + rebuild-trigger inside
`bc-launcher` is a management/execution (control/data plane) conflation worth
splitting. A Context Map (§1) makes the conflation visible; Core/Supporting/Generic
(§2) and a Core Domain Chart (§3) justify the split by worth; Wardley (§5) confirms
the execution half is a commodity to ride, not build.

Sources: [The three planes: control, data, management (Parashar)](https://medium.com/@pankaj-parashar/the-three-layers-of-modern-software-architecture-control-data-and-management-planes-58d3cb2f677a),
[Control plane vs data plane (TrueFoundry)](https://www.truefoundry.com/blog/control-plane-vs-data-plane),
[Control plane vs data plane vs management plane (StarWind)](https://www.starwindsoftware.com/blog/control-plane-vs-data-plane-vs-management-plane/),
[Airbyte — data plane vs control plane](https://airbyte.com/data-engineering-resources/data-plane-vs-control-plane).

---

## Bottom line — which artifact(s) best expose our overloads + guide placement

| Need | Best artifact | Effort |
|---|---|---|
| See how the six BCs + pipeline concerns **relate**, and *spot the overload* | **Context Map** + patterns (§1) — the Big-Ball-of-Mud / multi-role-node signal | Low |
| Decide **where each capability belongs** by worth (incl. mgmt-vs-execution) | **Core/Supporting/Generic** classification (§2) — gives the placement *rule* | Very low |
| Align product + engineering on **misinvestment / mis-placement** visually | **Core Domain Charts** (§3) — the smeared-dot / Suspect-Supporting tell | Low–moderate |
| Confirm the overload at **runtime** and complement the conceptual map | **C4** System Context + Container (§4) | Low |
| Settle **build-vs-buy on the execution substrate** over time | **Wardley** (§5) — selective, not the default | Moderate–high |
| Keep the map as a **durable, diffable artifact** beside our ADRs | **ContextMapper** CML (§6) | Moderate to stand up |

**Recommended minimal pairing for the immediate question:** a **Context Map** (§1)
to expose the `bc-launcher` overload and the pipeline coupling, plus a
**Core/Supporting/Generic** pass (§2) to fix placement — together they answer both
"how do they relate?" and "where does it belong?" at very low cost. Add a **Core
Domain Chart** (§3) if you want a product-facing picture of the whole portfolio, and
**ContextMapper** (§6) only if the map is worth maintaining long-term.

**Field vocabulary for "management vs execution":** it is **two subdomains** — a
**Core/Supporting management (control-plane) context** and a **Generic execution
(data-plane) substrate you adopt, don't build** — separated by a **control/data-plane
boundary**, with the operator surfaces forming the **management plane**. Not one
context; the current `bc-launcher` coupling is the conflation to split.
