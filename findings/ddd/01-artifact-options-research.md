# DDD artifact options — what the per-BC scope + ubiquitous-language artifact(s) could look like

**For:** David (asked 2026-07-02: "do a research project on what the artifact(s) could
look like and give me options and background"). **Epic:** lead-bh2m (DDD bounded-context
review). **Grounding:** `findings/ddd/00-current-state-inventory.md` +
`findings/ddd/research/A|B|C-*.md` (cited web sources in each). Read-only artifact surface
(ADR-018); main untouched.

---

## 1. The question, precisely

We need artifact(s) that, per bounded context (BC), pin **(a) scope** — what the BC owns and
does *not* own — and **(b) ubiquitous language** — the terms and their per-context meaning;
and, at the system level, a **map** of how the BCs relate, so we can run the **drift review**
(system-as-defined vs behaviors-assigned-over-time) and **rehome** mis-placed capabilities
(the overloaded `templates`; the homeless dagger module; the build **management-vs-execution**
smear).

## 2. The DDD artifact landscape (background)

Three layers, from the research:

**Per-context definition (angle A).**
- **Bounded Context Canvas (BCC)** — Nick Tune → DDD Crew, CC-BY-4.0. One artifact per BC:
  *Purpose · Strategic Classification (core/supporting/generic) · Domain Roles · Inbound /
  Outbound communication · Ubiquitous Language table · Business Decisions · Assumptions/Open
  Questions.* Native form is a Miro board, but a mature **markdown-per-BC** ecosystem exists
  (diffable, agent-maintainable).
- **Ubiquitous Language table** — the one non-negotiable DDD artifact (Evans/Vernon);
  one-phrase-one-concept, per-context meaning, an "overloaded-with" column. Best as a
  *section inside* the BCC, not a rival.
- **Lightweight "context card"** — a stripped BCC (*Purpose / Owns / Does-not-own / key terms
  / collaborators*). Its **Does-not-own** line is the cheapest overload detector; upgrades
  trivially into a full BCC.

**Strategic / system map (angle B).**
- **Context Map + relationship patterns** (Partnership, Shared Kernel, Customer-Supplier,
  Conformist, ACL, Open Host Service, Published Language, Separate Ways, **Big Ball of Mud**)
  — the primary *overload detector*: a multi-role, high-fan-in node is the tell.
- **Core / Supporting / Generic subdomain classification** — the *placement rule* by business
  worth; the sharpest lens on management-vs-execution.
- **Core Domain Charts** (Nick Tune), **C4** (system-context/container, runtime confirmation),
  **Wardley** (evolution; selective use), **ContextMapper CML** (a text DSL that makes the map
  CI-checkable) — supporting options.

**Discovery techniques (angle C).**
- **Domain Message Flow Diagram** (DDD Crew) — messages between contexts. **Near-native for
  us** (see §3).
- **Event Storming** (Brandolini) and **Domain Storytelling** (Hofer/Schwentner) — powerful
  *live, synchronous workshops*; their output is transient. **Not standing repo artifacts** an
  agent can refresh; they fit only as a **one-time human discovery input** at the
  product-authority gate for a genuinely new subdomain (e.g. the planned ecommerce BC).

## 3. Why our system biases the choice (the fit — angle C + inventory)

Under ADR-018 + AI-agent operation, **an artifact earns a standing place only if an agent can
maintain it from the contract surface.** That single test selects text artifacts and demotes
the workshops. Three native-fit facts make the BCC + a message-flow map fit us almost for free:

1. **A Domain Message Flow *is* our `shop-msg` protocol** — and we already have a partial one:
   the structurizr **dynamic views** (`AssignScenariosFlow`, `ClarifyRoundTrip`,
   `BcBaseRebuild`) are message-typed sequenced flows. Topology is **hub-and-spoke** (every
   edge touches the lead). Adoption ≈ formalizing an existing artifact.
2. **The BCC's Inbound/Outbound fields *are* the per-BC shop-msg contract** (Inbound =
   assign_scenarios/request_bugfix/request_maintenance/nudge from lead; Outbound =
   work_done/clarify/mechanism_observation/nudge to lead; relationship = Customer/Supplier).
   These are near-identical across BCs — so the BCC's **differentiating value is its *other*
   fields**: Purpose, Strategic Classification, and Ubiquitous Language.
3. **Per-BC ubiquitous language is already scoped by the `@bc` tag** partitioning the Gherkin
   corpus (one language-region per BC). So the BCC's UL field is a *distillation an agent
   builds from the repo* — not a workshop output. Strongest agent-maintainability lever.

Plus: **spec §3.3 already defines a "Domain & Context Map" but defers its schema.** There is a
framework-sanctioned home waiting to be instantiated. And existing per-BC scope docs: **none**
(ADR-001/002 tables are stale) — we reconstruct, we don't refine.

## 4. Options (what we could adopt)

Each option is a *package* (per-context artifact + system map + weight). All are markdown/text,
agent-maintainable, and land boundary decisions as PDR/ADR tracked in beads.

### Option 1 — Lightweight Context Cards only (minimum viable)
Per-BC card: *Purpose / Owns / Does-not-own / key terms / collaborators*. No formal system map
beyond a prose relationship list.
- **Background:** the stripped-BCC / Team-Topologies "owns vs not" framing (angle A).
- **For us:** ~1 short file per BC; the `Does-not-own` line alone surfaces the `templates`
  overload; distillable from `@bc` scenarios.
- **Effort:** lowest. **Pros:** fast, unintimidating, immediate drift signal. **Cons:** thin
  ubiquitous language; no rigorous relationship map for the *hard* placement calls
  (management-vs-execution needs the subdomain lens Option 2/3 carry); may under-serve the
  ecommerce-BC discovery later.

### Option 2 — Full Bounded Context Canvas per BC + system Context Map (DDD-standard)
Complete BCC per BC + a Context Map with relationship patterns and Core/Supporting/Generic
classification.
- **Background:** the canonical DDD Crew package (angles A+B).
- **For us:** rigorous and familiar; the Context Map's Big-Ball-of-Mud / high-fan-in tells
  pinpoint overloads; the subdomain pass gives the placement *rule*.
- **Effort:** highest to fill. **Pros:** most rigorous; best for the genuinely contested
  splits. **Cons:** the BCC's Inbound/Outbound fields are largely redundant with the shop-msg
  catalog (busywork near-identical across BCs); heavier than a 6-BC system strictly needs.

### Option 3 — Tailored hybrid: instantiate §3.3 as trimmed per-BC Canvases + reuse structurizr (RECOMMENDED)
Instantiate the **deferred §3.3 Domain & Context Map** as the system artifact, composed of
per-BC **Context Canvases that are BCC-derived but trimmed to our reality**: keep *Purpose,
Strategic Classification (core/supporting/generic), Owns/Does-not-own, Ubiquitous Language
(distilled from the `@bc` corpus), Business Decisions, Assumptions*; **drop the redundant
Inbound/Outbound prose** and instead reference the **shop-msg catalog + the structurizr
dynamic views** as the Domain Message Flow layer. Boundary/placement decisions → PDR/ADR in
beads.
- **Background:** BCC spine (A) minus the fields our message bus already encodes (C), plus the
  Context-Map + subdomain lens (B) as the map, all inside the framework's own §3.3 slot.
- **For us:** maximal reuse (the §3.3 placeholder, structurizr views, `@bc` tags); every field
  earns its place under the agent-maintainability test; the Owns/Does-not-own pair + subdomain
  classification directly drive the `templates` split and the management/execution split.
- **Effort:** low-moderate. **Pros:** lightest artifact that still carries the rigorous
  placement lens; native to our surface; promotable per-BC (start as a card, grow to a canvas
  for contested BCs). **Cons:** a small amount of "which BCC version/fields" tailoring up front
  (a one-time schema decision — see open questions).

### Option 4 — ContextMapper CML (formal DSL) — as a possible upgrade, not a starting point
Model the whole thing (Bounded Contexts + Context Map) in the ContextMapper text DSL,
CI-validated beside our ADRs.
- **Background:** angle B §6.
- **For us:** most tooled/rigorous; diffable + machine-checkable. **Cons:** new tooling to
  stand up; likely overkill for ~6 BCs *now*. **Verdict:** note as a future hardening step if
  the markdown canvases prove valuable, not the first move.

**Cross-cutting:** in every option, **Event Storming / Domain Storytelling** are reserved as
*one-time human discovery inputs* (product-authority gate) for new subdomains — never standing
artifacts. The EventStorming → Message Flow → Canvas pipeline is how a workshop would feed the
text artifacts.

## 5. Recommendation

**Option 3.** It is the lightest package that still carries the two things the drift review
actually needs — an explicit **Owns/Does-not-own** per BC and a **Core/Supporting/Generic**
placement lens — while reusing three things we already have (the §3.3 slot, the structurizr
message-flow views, and the `@bc`-scoped language regions). It answers your two named tensions
directly: `templates`' long `Owns` list becomes the visible split signal, and
management-vs-execution resolves as **two subdomains** (control-plane management vs generic
"adopt/wrap-don't-build" execution — which is exactly ADR-052/053's "wrap not replace").

## 6. Open questions for your dialogue (product-authority; before any authoring)

Carried from the inventory + surfaced by the research:
1. **Templates:** what is it actually *for* — is there an **"Adopter Footing/Provisioning"**
   context to split out (inventory groups 4–11), and where's the ubiquitous-language seam?
2. **Management vs execution boundary:** do dagger + fabro + the hollowed devcontainer's image
   role consolidate into one **"Build/Release Execution"** context, distinct from a **"Release
   Management/BOM"** context (system-manifest, bc-manifest, cadence)?
3. **In or out:** are `docs` / `test-harness` / `devcontainer` (defined-but-not-live) retired,
   resurrected, or absorbed — and reconcile their orphaned `features/` coverage?
4. **Artifact-form confirmation:** adopt Option 3? And the one schema decision it needs — which
   BCC field set / version (V4 vs V5 names vary) becomes our per-BC canonical spine.
5. **Scope of first pass:** whole-system (all ~6 BCs) up front, or hotspots-first (`templates`
   + build-pipeline) then generalize? (Recommend: whole-system *cards* first — cheap — then
   promote the two hotspots to full canvases.)

## 7. Deliverables produced

- This synthesis + the three cited research files (`research/A|B|C-*.md`) + the current-state
  inventory (`00-*.md`).
- A comparison **artifact page** (options side-by-side) for offline review — URL in the
  session report.
- No target model authored; that awaits your dialogue on the questions above.
