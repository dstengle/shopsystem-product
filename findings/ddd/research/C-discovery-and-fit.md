# DDD Artifact Research — Angle C: Collaborative Discovery + Fit to Our System

**Scope.** One of three parallel research angles for choosing DDD artifacts. This
angle covers (1) **collaborative-discovery** techniques that *produce* ubiquitous
language + bounded-context boundaries, and (2) the crucial **fit** of each to *our*
specific system — the shopsystem framework, which is small, fast-moving, and
**operated by AI agents that must maintain artifacts from the repo, not from live
human workshops**.

**Bottom line up front.** Of the three discovery artifacts, the **Domain Message
Flow Diagram** and the **Bounded Context Canvas** (both DDD Crew) are near-native
fits because they are *text/structured* artifacts an agent can author and maintain
from our contract surface, and they map almost 1:1 onto structures we already have
(`shop-msg` message catalog; `@bc`-tagged scenario corpus; structurizr dynamic
views). **Event Storming** and **Domain Storytelling** are *human, synchronous,
sticky-note elicitation* techniques — they do **not** fit as agent-maintained repo
artifacts, but they *do* have a real home as a **one-time human discovery input at
the product-authority discovery gate** when a genuinely new subdomain/product is
being framed (e.g. the PLANNED ecommerce BC), whose *output* is then captured into
the agent-maintained artifacts. This is the classic EventStorming → Bounded Context
Canvas pipeline, mapped onto our gate.

---

## PART 1 — The discovery artifacts (cited background)

### 1. Event Storming (Alberto Brandolini)

**What it is + origin.** A workshop-based collaborative modeling technique where a
cross-functional group "storms out" a domain as a chronological wall of **domain
events** on sticky notes. Invented by **Alberto Brandolini**, introduced in a
**November 2013** blog post ("Introducing Event Storming"); piloted at Italian Agile
Day 2012. Purpose: build *shared understanding* fast — "a comprehensive model of a
complete business flow in hours instead of weeks."
Sources: <http://ziobrando.blogspot.com/2013/11/introducing-event-storming.html>,
<https://www.eventstorming.com/>, <https://en.wikipedia.org/wiki/Event_storming>.

**Three levels.**
- **Big Picture** — widest scope, 25–30 people; produces a broad event landscape and
  surfaces **emerging bounded contexts** + hotspots.
- **Process-Level** — one process end-to-end; adds commands, read models, policies,
  actors.
- **Design-Level** — single context, developers only; adds the **aggregate**; a model
  meant to move ~1:1 to code.
Sources: <https://www.qlerify.com/post/event-storming-the-complete-guide>,
<https://mrpicky.dev/design-level-event-storming-with-examples/>.

**What it produces / how boundaries + language emerge.** Elements are color-coded
(canonical ddd-crew legend): **domain event = orange**, **command = blue**,
**actor = small yellow**, **policy = lilac**, **read model/query = green**,
**external system = pink**, **aggregate = big yellow**, **hotspot = red/neon-pink**.
**Pivotal events** (the few most significant state changes, e.g. *Order Placed*)
"often mark the boundaries between" bounded contexts; pivotal events + **emergent
clusters** reveal *Emerging Bounded Contexts*. **Ubiquitous language** emerges
because every sticky is named in the domain experts' own words, and naming
disagreements surface as hotspots.
Source: <https://ddd-crew.github.io/eventstorming-glossary-cheat-sheet/>.

**Effort / live-vs-async.** Fundamentally **live and synchronous** — Brandolini's
requirements are "unlimited modeling space" (a long wall), sticky notes in ≥5 colors,
and *the right people in the room*. Remote is possible (Miro) but documented to run
**20–40% slower**, loses body language, and is capped ~7 people. Duration: hours to a
full day. Fully-async (no live conversation) undermines its core value.
Sources: <https://radekmaziarka.pl/2020/03/29/event-storming-remotely-tips-and-tricks/>,
<https://tanzu.vmware.com/content/blog/how-to-conduct-a-remote-event-storming-session>.

**Strengths / weaknesses.** + Extremely fast; genuine shared understanding; no
notation to learn; surfaces risks early; versatile across three levels. − Needs the
right people synchronously; facilitator-dependent; remote loses fidelity; **outputs
are transient stickies that must be deliberately captured to persist**.

### 2. Domain Storytelling (Stefan Hofer & Henning Schwentner)

**What it is + origin.** A collaborative visual technique where **domain experts tell
concrete work stories while a modeler records them live in a pictographic language**.
Created by **Hofer & Schwentner** (WPS, Hamburg); first paper 2015; definitive book
*Domain Storytelling* (Addison-Wesley, 2022, Vernon Signature Series).
Sources: <https://domainstorytelling.org/>, <https://domainstorytelling.org/book>,
<https://ddd-practitioners.com/home/glossary/domain-storytelling/>.

**The language / what it produces.** A small **sentence grammar**: *who (actor) does
what (activity) with what (work object) with whom* — **actors** (icons for humans vs.
systems), **work objects** (documents/items exchanged), **activities** (labeled
arrows with domain verbs), **sequence numbers** ordering the narrative, plus
annotations. **Scenario-based and concrete**: one story = one concrete run-through
("order when all items in stock" is separate from "…when one is out of stock").
Three dimensions: **as-is/to-be**, **coarse/fine-grained**, **pure/digitalized** —
coarse-grained as-is/to-be stories are the granularity for *finding boundaries*.
Source: <https://domainstorytelling.org/quick-start-guide>.

**How boundaries + language emerge.** Because the modeler records stories *in the
experts' own words*, the diagram is a live capture of the **ubiquitous language**.
**Boundaries** surface where **the language shifts** — where the same work object
changes name/icon/meaning, or where scenarios pull in different actors/systems —
signaling a subdomain split.
Sources: <https://techleadjournal.dev/episodes/75/>,
<https://kalele.io/why-eventstorming-practitioners-should-try-domain-storytelling/>.

**Effort / live-vs-async.** A **live, moderated workshop** (experts + team + a
modeler drawing live, e.g. with the open-source tool **Egon.io**, which auto-numbers
and replays stories). More *guided/structured* than Event Storming (explicit sentence
grammar, small alternating cycles). The **elicitation is synchronous**; the resulting
diagrams are strong **async documentation/onboarding** artifacts.
Sources: <https://egon.io/>, <https://github.com/WPS/egon.io>.

**Strengths / weaknesses.** + Better for onboarding/documentation (self-explanatory,
replayable sentence diagrams); centers actor cooperation ("who does what with whom");
structured/moderated. − Scenario-at-a-time (doesn't sweep a whole process like Big
Picture Event Storming); facilitator- and live-participation-dependent. The two are
**complementary, not competing.**
Source: <https://kalele.io/why-eventstorming-practitioners-should-try-domain-storytelling/>.

### 3. Domain Message Flow Diagram (DDD Crew) — **the one that maps to us**

**What it is + origin.** A lightweight strategic-design diagram that visualizes the
flow of **commands, events, and queries between bounded contexts** (and actors), for
**a single scenario**. Introduced by **Nick Tune** (~2020) with the DDD Crew;
notation is explicitly "a mix between **Simon Brown's C4 Container Diagrams** and
**Domain Storytelling**." CC BY 4.0.
Sources: <https://github.com/ddd-crew/domain-message-flow-modelling>,
<https://domainstorytelling.org/articles/domain-message-flow-modeling/>.

**What it models / produces.** Messages between sender→recipient, each with **name,
significant data (payload), and sequence order**. Message trio: **command** (request
to do), **query** (request for info; request+response shown together), **event**
(notification something happened). Purpose: **validate a candidate bounded-context
decomposition and identify coupling** *before* implementation. Keep each diagram to
**5–9 messages** (Miller's Law); split larger scenarios. Deliberately lightweight
(~30 min in the workshop recipe), tool-agnostic, and **amenable to
diagrams-as-code / text-based rendering** (works sync or async).

**Strengths / weaknesses.** + Cheap, fast, version-controllable as text; makes
integration style (command/event/query) and coupling explicit; feeds directly into
the Bounded Context Canvas. − Single-scenario scope (needs many diagrams for full
coverage); shows messages, not internals; quality depends on a good candidate-context
input.

### The Bounded Context Canvas (DDD Crew) — the pipeline's terminal artifact

Not itself a discovery technique but the **standard capture target** for discovery
output, so it matters for the fit analysis. "A collaborative tool for designing and
documenting the design of a **single** bounded context" (DDD Crew; inspired by the
Business Model Canvas). CC BY 4.0.
Source: <https://github.com/ddd-crew/bounded-context-canvas>.

**Fields (verbatim labels):** Name; Purpose; Strategic Classification (Domain Type
core/supporting/generic · Business Model · Evolution); Domain Roles; **Inbound
Communication**; **Outbound Communication**; Ubiquitous Language; Business Decisions;
Assumptions; Verification Metrics; Open Questions.

- **Inbound Communication** = "collaborations initiated by *other* collaborators,"
  listed as **Messages** (command / query / event) × **Collaborators** (who sends
  them), plus a **Relationship Type** (Customer/Supplier, Conformist, ACL,
  Partnership…) in V4/V5.
- **Outbound Communication** = "collaborations initiated by *this* context… the same
  message types and notations apply."

So each communication row = **{message name, kind ∈ {command,query,event},
collaborator, direction (received/sent), relationship type}**.

**The canonical pipeline** (Nick Tune's workshop recipe): Big Picture EventStorming
(≥1h) → Candidate Context Modelling (≥30m) → **Domain Message Flow Modelling** (≥30m)
→ **Bounded Context Canvas** (≥90m) → Refined Context Exploration (≥45m). The
EventStorm's stickies (events, pivotal events, clusters) become candidate contexts;
message-flow **validates** the boundaries; each surviving context gets a Canvas whose
inbound/outbound rows are lifted from the message-flow arrows.
Source: <https://medium.com/nick-tune-tech-strategy-blog/modelling-bounded-contexts-with-the-bounded-context-design-canvas-a-workshop-recipe-1f123e592ab>,
<https://github.com/ddd-crew/ddd-starter-modelling-process>.

---

## PART 2 — Fit to our system (the differentiator)

**Grounding read.** Framework spec §1–§6; ADR-018 (empirical verification = the
contract/artifact surface; the lead carries **no BC code**); §5 message catalog;
§2 (BC vs subdomain); §3.3 (lead-owned artifacts incl. the *Domain & Context Map*,
schema deferred); `features/<bc>/*.gherkin` (each scenario tagged
`@bc:<name>` + `@scenario_hash:<hash>`); `structurizr/workspace.dsl`.

Our system's shape, in three facts that decide everything:
1. **BCs coordinate ONLY via a typed message bus** (`shop-msg`), **hub-and-spoke**:
   only lead ↔ BC; BCs never message each other (§5.1). The catalog is 8 pinned
   types (7 active): `assign_scenarios`, `request_bugfix`, `request_maintenance`,
   `request_completion_journal` (fka `request_scenario_register`), `request_shop_card`
   (deferred), `nudge` ↔, plus BC→lead `work_done`, `clarify`, `mechanism_observation`.
2. **The durable artifact surface is text an agent owns from the repo**: `@bc`-tagged
   Gherkin (canonical, PO-authored) + ADRs + PDRs + the structurizr DSL + beads.
   ADR-018 makes this a *hard constraint*: the lead may only build/verify from that
   surface — never from live workshops or reading BC code.
3. It is **small, fast-moving, and agent-operated.** Artifacts must be *maintainable
   by agents*, diffable, and cheap to keep in sync — not one-shot whiteboard outputs.

### (a) Which artifacts integrate NATIVELY — the top native-fit insights

**Native-fit insight #1 — Domain Message Flow maps ~1:1 onto `shop-msg`, and we
already have a partial implementation in structurizr.** A Domain Message Flow Diagram
*is* "named messages, with sequence order and a sender→recipient, for one scenario."
That is exactly our inter-shop protocol: the `shop-msg` catalog **is** the message
vocabulary, and the structurizr `workspace.dsl` **dynamic views** (`AssignScenarios­Flow`,
`ClarifyRoundTrip`, `BcBaseRebuild`) are already sequenced single-scenario message
flows labeled with those exact types (e.g. step "1. shop-msg send assign_scenarios",
"5. respond work_done(complete) with scenario_hashes"). So the artifact is not new —
it is a **formalization of a text artifact the Architect already maintains**. Two
important nuances:
   - Our message *kinds* differ from DDD's command/event/query trio: `assign_scenarios`
     / `request_bugfix` / `request_maintenance` / `nudge` are **commands**;
     `work_done` / `mechanism_observation` are **events**; `request_completion_journal`
     / `request_shop_card` are **queries**; `clarify` is a query-shaped event
     (BC-initiated). A message-flow view over shop-msg would classify each catalog
     type into that trio — a clean, useful annotation.
   - **Topology is hub-and-spoke, not free inter-context messaging.** A message-flow
     of the *coordination* layer is always a star (every edge touches the lead). The
     high-value message flows to model are therefore the **operational scenarios**
     (the dynamic views), not a context-to-context web — which is why the existing
     dynamic-view form is the right vehicle.

**Native-fit insight #2 — the Bounded Context Canvas's Inbound/Outbound Communication
fields ARE the shop-msg contract for each BC.** Fill a Canvas per BC and the
Inbound/Outbound rows are enumerable *directly from the catalog + hub-and-spoke rule*:
every BC's **Inbound** = {`assign_scenarios`, `request_bugfix`, `request_maintenance`,
`request_completion_journal`, `nudge`} from collaborator **lead**; every BC's
**Outbound** = {`work_done`, `clarify`, `mechanism_observation`, `nudge`} to
collaborator **lead**. The relationship type is uniform **Customer/Supplier**
(lead = customer, BC = supplier). This is a genuinely native mapping — but note it
also exposes that, at the *framework* level, the communication sections are **nearly
identical across all BCs** (everyone talks only to the lead via the same catalog), so
the Canvas's *differentiating* value here is its **other** fields — Purpose, Strategic
Classification (subdomain: Inter-shop coordination / Specification / Role discipline /
Platform Operations, already recorded in the structurizr element descriptions),
Domain Roles, **Ubiquitous Language**, Business Decisions. The Canvas is most valuable
as the **per-BC "knowable shape" description** that §1.2 (Principle 1) already demands
but which today lives only as scattered structurizr descriptions.

**Native-fit insight #3 — per-BC ubiquitous language is already scoped by the
`@bc`-tagged scenario set.** Discovery techniques *produce* ubiquitous language; our
repo already *homes* it: the `@bc:<name>` tag partitions the canonical Gherkin corpus
into exactly one language-region per BC (92 `@bc` tags across `features/`), and §2.2
defines a Bounded Context as "one Ubiquitous Language." So the Canvas's *Ubiquitous
Language* field and any Domain-Storytelling term capture do not need a new store —
they are a **distillation of the `@bc`-scoped scenario vocabulary**, and an agent can
build/refresh that list from the repo (grep the `@bc` set, extract domain nouns/verbs)
with no workshop. This is the single strongest agent-maintainability lever.

### (b) Lightweight-vs-heavy tradeoff for an agent-operated system

The decisive filter is ADR-018 + "agents maintain from the repo." Rank by that:

| Artifact | Elicitation | Persistent form | Agent-maintainable from repo? | Verdict |
|---|---|---|---|---|
| **Domain Message Flow** | lightweight, sync-or-async | **text / diagrams-as-code** (structurizr dynamic view) | **Yes** — already is one | **Adopt (formalize existing)** |
| **Bounded Context Canvas** | template, async-friendly, "living document" | **Markdown/YAML** | **Yes** — fields derive from catalog + `@bc` corpus | **Adopt (per-BC)** |
| **Domain Storytelling** | live moderated workshop | pictographic (Egon.io) | No — synchronous elicitation; pictographic form not diffable | **Human discovery input only** |
| **Event Storming** | live sticky-note workshop | transient stickies | No — synchronous; outputs are transient | **Human discovery input only** |

The heavy artifacts (Event Storming, Domain Storytelling) fail the maintainability
test not because they are bad but because their *value is in the live human dialogue*
— which an agent cannot conduct and cannot re-run to keep an artifact fresh. Adopting
them as standing repo artifacts would create exactly the drift ADR-018 / Principle 5
forbid. The light artifacts (Message Flow, Canvas) pass because they are **structured
text derivable from surfaces the lead already owns**.

But the heavy artifacts are not worthless to us: the framework already has a
**product-authority discovery gate** (lead-primer) and discovery skills
(problem-framing-canvas, jobs-to-be-done, opportunity-solution-tree,
customer-journey-map). Those are *problem-space* discovery. Event Storming / Domain
Storytelling fill a **different, currently-empty slot: solution-space boundary +
ubiquitous-language discovery** — needed exactly once per *new* subdomain/product
(e.g. the PLANNED ecommerce BC). Their right role is a **one-time human workshop run
BY the product authority at the discovery gate**, whose *output* (events, terms,
candidate boundaries) is captured into the agent-maintained artifacts. This is the
EventStorming → Message Flow → Bounded Context Canvas pipeline, mapped onto our gate.

### (c) How the chosen artifacts plug into the existing ADR/PDR/scenario/beads flow

- **Domain Message Flow** → lives as **structurizr dynamic views** (already the
  Architect's §3.3 artifact). New inter-shop scenarios add a dynamic view; validated
  in CI via `structurizr validate`. No new substrate. When a flow reveals a coupling
  problem, that's an **ADR** (structural decision) and the fix routes as `assign_scenarios`
  / `request_bugfix` per the §5.3 discriminator.
- **Bounded Context Canvas** → one **Markdown** file per BC (candidate home:
  `findings/ddd/` now, promotable to a first-class §3.3 artifact or folded into the
  deferred **Domain & Context Map** / shop-card schema). Inbound/Outbound rows are
  generated from the catalog; Ubiquitous Language is distilled from the `@bc` corpus;
  Strategic Classification reuses the subdomain labels already in the structurizr
  descriptions. Authoring/refresh is a **lead-po** (language, purpose) + **lead-architect**
  (classification, communication, relationships) collaboration — the same PO/Architect
  split that already owns the Domain & Context Map (§3.2 turn-limited exchange).
- **Discovery workshops (when a new subdomain arrives)** → run at the discovery gate;
  their persistence obligation is discharged by writing the Canvas + Message Flow +
  `@bc` scenarios, and any boundary decision becomes a **PDR** (product decision:
  what/why the boundary) and/or **ADR** (structural), tracked as **beads**. This
  keeps intent-provenance (Principle 6) intact: the workshop is the recorded point of
  intent; the durable artifacts are its conformant capture.

---

## Recommendation (for the cross-angle decision)

1. **Adopt the Domain Message Flow Diagram** — but recognize we already have it as
   structurizr dynamic views; the work is to *formalize/standardize* that form and add
   the command/query/event classification of the `shop-msg` catalog. Highest native
   fit, lowest cost.
2. **Adopt the Bounded Context Canvas** as the per-BC "knowable shape" record
   (Principle 1), Markdown, agent-maintained; it unifies today's scattered structurizr
   descriptions and gives the deferred Domain & Context Map / shop-card a concrete
   shape. Its communication fields are the shop-msg contract; its Ubiquitous Language
   field is a distillation of the `@bc` corpus.
3. **Do NOT adopt Event Storming or Domain Storytelling as standing repo artifacts.**
   Reserve them as **one-time human discovery workshops at the product-authority
   discovery gate**, for new subdomains only (ecommerce BC), feeding the two artifacts
   above via the EventStorming → Message Flow → Canvas pipeline.

**Lightweight-vs-heavy, one line:** for an agent-operated system under ADR-018, an
artifact earns a standing place in the repo only if an agent can *maintain it from the
contract surface* — which selects the text-based Message Flow and Canvas and demotes
the two workshop techniques to human-only, one-time discovery inputs.

---

### Sources
- Event Storming: <http://ziobrando.blogspot.com/2013/11/introducing-event-storming.html> ·
  <https://www.eventstorming.com/> · <https://en.wikipedia.org/wiki/Event_storming> ·
  <https://ddd-crew.github.io/eventstorming-glossary-cheat-sheet/> ·
  <https://www.qlerify.com/post/event-storming-the-complete-guide> ·
  <https://mrpicky.dev/design-level-event-storming-with-examples/>
- Domain Storytelling: <https://domainstorytelling.org/> ·
  <https://domainstorytelling.org/quick-start-guide> · <https://domainstorytelling.org/book> ·
  <https://egon.io/> · <https://github.com/WPS/egon.io> ·
  <https://kalele.io/why-eventstorming-practitioners-should-try-domain-storytelling/> ·
  <https://techleadjournal.dev/episodes/75/>
- Domain Message Flow: <https://github.com/ddd-crew/domain-message-flow-modelling> ·
  <https://domainstorytelling.org/articles/domain-message-flow-modeling/>
- Bounded Context Canvas: <https://github.com/ddd-crew/bounded-context-canvas> ·
  <https://medium.com/nick-tune-tech-strategy-blog/modelling-bounded-contexts-with-the-bounded-context-design-canvas-a-workshop-recipe-1f123e592ab> ·
  <https://github.com/ddd-crew/ddd-starter-modelling-process>
- Our surface: `01-principles.md`–`06-work-tracking.md`; `adr/018-…contract-surface.md`;
  `05-inter-shop-protocol.md` (§5.3 catalog); `02-…subdomains.md`; `03-lead-shop.md` (§3.3);
  `structurizr/workspace.dsl` (dynamic views); `features/<bc>/*.gherkin` (`@bc` tags).
