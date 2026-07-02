# Angle A — Per-Context Definition Artifacts

**Research question.** What ARTIFACT form should we define, per bounded context (BC),
to capture a BC's **scope** (what's in / out) and its **ubiquitous language**, for a DDD
review of our system?

**Deliverable.** Options + background for each candidate per-context artifact, with a
ranked shortlist and a recommended field-structure "spine". This angle covers the shape of
a *single BC's* scope+language doc. (Cross-context maps and portfolio/strategic views are
sibling angles.)

---

## TL;DR — ranked shortlist

| Rank | Artifact | One-line background | Best-fit note |
|------|----------|--------------------|----------------|
| **1** | **Bounded Context Canvas (BCC)** — markdown form | Invented by Nick Tune, now maintained by the DDD Crew under CC-BY-4.0; the de-facto standard structured per-BC design/documentation tool (currently V5). | The front-runner. Captures scope *and* language *and* the in/out boundary (via inbound/outbound messages) in one bounded field set. Use a markdown-per-BC variant so it lives in the repo. |
| **2** | **Ubiquitous Language table** (per-context glossary) | Core Evans/Vernon DDD practice; the one non-negotiable DDD artifact. | Necessary but not sufficient — it captures language but *not* scope/collaborators. It is a **section inside** the BCC spine, not a competitor to it. Keep as its own table so it can grow. |
| **3** | **Lightweight "context card"** (stripped BCC: purpose / owns / does-not-own / key terms / collaborators) | Not a formally-named community artifact; a synthesized minimal subset of the BCC + Team Topologies "owns/does-not-own" framing. | Good starting rung / low-ceremony option when a full BCC is too heavy for a first pass. Trivially upgrades to a full BCC. Its explicit `does-not-own` line is the single best cheap tool for exposing an overloaded BC. |
| — | **Aggregate Design Canvas (ADC)** | DDD Crew, structured tool for designing an *aggregate*. | **Out of scope for this angle** — it documents the internal tactical model (invariants, state transitions, commands/events of one aggregate), not the BC's outward scope+language. Note it, don't adopt it here. |

**Recommended spine** (single field-structure to standardize on): a **markdown Bounded
Context Canvas per BC**, with fields in this order —
`Name · Purpose · Strategic Classification · Domain Role(s) · Owns / Does-not-own ·
Inbound Communication · Outbound Communication · Ubiquitous Language table ·
Business Decisions · Assumptions & Open Questions`. This is the standard BCC field set
with one deliberate addition — an explicit **Owns / Does-not-own** pair (borrowed from
the lightweight context card / Team Topologies) — because that pair is what makes an
**overloaded BC** visible on the page. Rationale below.

---

## 1. Bounded Context Canvas (BCC) — the front-runner

### What it is + who originated it
A structured, one-page template for **designing and documenting a single bounded
context**. Invented by **Nick Tune**; now maintained by the **DDD Crew** (contributors
incl. Kenny Baas-Schwegler, Kim Lindhard, Michael Plöd, Maxime Sanglan-Charlier) on
GitHub under **Creative Commons Attribution 4.0 (CC-BY-4.0)**. Currently at **V5**
(released Nov 2022). Ships as Miro / draw.io / Lucidchart / Excalidraw / HTML templates
plus community translations. Nick Tune frames a fully-completed canvas as "very good
documentation," and explicitly invites teams to "change the canvas or create an entirely
new one" — it is meant to be adapted.

### Exact field structure (V5 order)
1. **Name** — the context's name; agreeing it as a team "frames how you design the context."
2. **Purpose** — a few sentences, *business language, no technical detail*; may name the key actors it provides value for.
3. **Strategic Classification** — three sub-dimensions:
   - **Domain importance**: core / supporting / generic.
   - **Business model role**: revenue generator / engagement creator / compliance enforcer (a.k.a. cost reducer etc.).
   - **Evolution stage** (Wardley): genesis / custom-built / product / commodity.
4. **Domain Roles** — behavioural archetype(s) of the context (see the model-traits list below). References Brandolini's Bounded Context Archetypes and Wirfs-Brock's role stereotypes.
5. **Inbound Communication** — messages *received* from collaborators, typed as **commands / queries / events**, each tagged with the sending collaborator.
6. **Outbound Communication** — messages this context *initiates* toward others, same notation.
7. **Ubiquitous Language** — key domain terms and their in-context definitions.
8. **Business Decisions** — the key business rules and policies enforced inside this context.
9. **Assumptions** — design assumptions made under incomplete knowledge, made explicit.
10. **Verification Metrics** — measurable signals to check the boundary was drawn well (e.g. change-coupling, message volume).
11. **Open Questions** — unknowns / things no one in the room could answer.

(V3 also introduced a **Model Traits** section — "Draft/Execute/Audit" style trait tags
from Enterprise Integration Patterns — and split the old "Information & Services Provided"
into explicit **Messages Consumed / Produced**, and split dependencies into **suppliers**
vs **consumers** with a "why does this relationship exist?" emphasis.)

**Domain-role archetypes** (from the DDD Crew model-traits worksheet — useful vocabulary
for naming *what a BC is for*, and for spotting overload when a BC matches several):
Draft/Specification model, Execution model, Analysis/Audit model, Approver, Enforcer,
Octopus Enforcer, Interchanger (translates between ubiquitous languages), Gateway,
Gateway-Interchange, Dogfood context, Bubble context, Autonomous Bubble, **Brain context**
("contains a large number of important rules and many other contexts depend on it"),
Funnel context, Engagement context.

### Good at
- **One artifact covers all three targets**: scope (purpose + strategic classification),
  boundary/collaborators (inbound/outbound messages), and ubiquitous language.
- Forces the **in/out boundary** to be concrete: every inbound and outbound message names
  a collaborator, so "what's outside this BC" is enumerated, not implied.
- Carries **strategic context** (core/supporting/generic, evolution stage) that a bare
  glossary can't.
- Well-known, licensed, tooled, versioned — low risk to standardize on.

### Weak at
- **Heavier** than a glossary; a first-pass canvas per BC is a real workshop's worth of
  effort. Fields like Verification Metrics / Evolution stage are often left blank early.
- Native form is a **visual board** (Miro/draw.io) — not diff-friendly. Mitigated by the
  markdown variants (below).
- The message-centric inbound/outbound model assumes an **event/message architecture**;
  contexts integrated by shared DB or RPC need interpretation.
- Says nothing about *internal* model design (that's the Aggregate Design Canvas's job).

### Effort/weight
**Medium–heavy.** Positioned as a design *and* documentation tool. Realistically a
30–90 min collaborative pass per BC to fill well; cheap to *maintain* thereafter as a
markdown file.

### Concrete example (markdown form)
```markdown
# Bounded Context: Billing

## Purpose
Owns the money story for a subscription: turning usage + plan into invoices,
charging customers, and reporting revenue. Serves Finance and the customer.

## Strategic Classification
- Importance: Core
- Business model role: Revenue generator
- Evolution: Product

## Domain Role
Execution model + Analysis/Audit model (charges, then reports on charges).

## Owns / Does-not-own
- Owns: Invoice, Charge, PaymentAttempt, Dunning policy
- Does NOT own: Plan catalog (→ Catalog), Usage metering (→ Metering),
  Tax rates (→ Tax)

## Inbound Communication
- Command: IssueInvoice (from Subscriptions)
- Event: UsageRecorded (from Metering)
- Query: GetInvoice (from Customer Portal)

## Outbound Communication
- Event: InvoiceIssued → Notifications, Reporting
- Event: PaymentFailed → Subscriptions (dunning)

## Ubiquitous Language
| Term    | Definition (in THIS context)                              | Not to be confused with |
|---------|-----------------------------------------------------------|-------------------------|
| Invoice | Immutable statement of amounts owed for one billing cycle | "Receipt" (payment proof) |
| Charge  | A single attempt to move money for an invoice             | Invoice line item       |

## Business Decisions
- An invoice is finalized at cycle close and never mutated; corrections are credit notes.
- 3 failed charges → subscription enters dunning.

## Assumptions & Open Questions
- Assume Tax context provides rates synchronously. OPEN: multi-currency in scope?
```

### How it captures SCOPE and UBIQUITOUS LANGUAGE
- **Scope-in**: Purpose + Strategic Classification + Business Decisions describe what the
  BC is responsible for. **Scope-out**: the inbound/outbound message lists (and, in our
  recommended spine, the explicit *Does-not-own* line) enumerate what lives elsewhere.
- **Ubiquitous language**: a dedicated section/table of terms with *in-context* meanings —
  exactly the "language-per-context" requirement.

### Storage / living-artifact
Native tool is a board, but the community has converged on **markdown-per-BC** so the
canvas versions alongside code:
- `grjsmith/bounded_context_canvas_md` — a plain markdown/YAML template (headings: Name,
  Description, Ubiquitous language [bullet term:definition], Inbound data, Events consumed,
  Business rules [GIVEN/WHEN/THEN], Outbound data, Events published, Assumptions; creator +
  date in header). Editable in any editor, version-controlled.
- A public **V4 markdown gist** (oguzhaneren) mirrors the canvas as headed markdown.
- `pierregillon/BoundedContextCanvasGenerator` — a POC that *generates* `bounded_context_canvas.md`
  from source-code annotations, on the premise that "source code is the only source of
  truth that is always up to date."
Recommended: one `bounded-context.md` (or `context-canvas.md`) file **per BC directory**,
reviewed in PRs like code.

### How it handles an OVERLOADED context (our `templates` BC)
The BCC surfaces overload structurally, though not automatically:
- **Purpose** that needs "and… and…" to state, or won't fit "a few sentences," is the
  first smell.
- **Multiple Domain Roles** matching at once (e.g. it's a Gateway *and* an Execution *and*
  a Brain context) signals accreted concerns.
- **Ubiquitous Language** containing terms that pull in different directions / an
  overloaded term meaning two things exposes fault lines.
- **Business Decisions** clustering into unrelated groups suggests two contexts wearing
  one name.
The canvas *shows* the overload; the reader must read it. This is exactly why the
recommended spine adds an explicit **Owns / Does-not-own** pair — an overloaded BC's
`Owns` list becomes visibly long and multi-themed, making the split candidate obvious on
the page rather than requiring interpretation.

---

## 2. Ubiquitous Language artifacts (per-context glossary / term dictionary)

### What it is + origin
The **glossary of the ubiquitous language**, scoped to one bounded context. This is the
foundational DDD practice from **Eric Evans** (*Domain-Driven Design*, 2003) and
**Vaughn Vernon** (*Implementing DDD*): DDD is "modeling a Ubiquitous Language in an
explicitly Bounded Context." Related formal notion: **Published Language** (a
documented, shared language used for integration between contexts).

### Fields / structure captured
A per-context table, typically: **Term · Definition (in this context) · Synonyms-to-avoid
/ deprecated terms · Overloaded-with (the same word's meaning in another context) ·
Example / code type**. Key conventions:
- **One phrase ↔ one concept.** No synonyms: "if two different phrases are used, it has to
  mean two semantically different concepts," and vice-versa.
- **Per-context meaning.** The *same word* legitimately means different things in different
  BCs; the glossary records the meaning *for this BC*. (Divergent meaning of a shared term
  is itself the signal that you've crossed a context boundary.)

### Good at / weak at
- **Good at**: the single most important DDD artifact for language; cheap; the thing code,
  tests and conversation must align to; directly drives naming.
- **Weak at**: captures *language only* — no scope, no collaborators, no strategic role.
  On its own it doesn't tell you what the BC is *for* or where its edges are. It is best
  treated as **one section of a larger per-BC doc**, not the whole doc.

### Effort/weight
**Lightweight.** A table you grow continuously. Lowest ceremony of all options.

### Concrete example
| Term | Definition (Fulfilment context) | Avoid / synonym | Overloaded-with |
|------|----------------------------------|------------------|------------------|
| Order | A confirmed, paid basket ready to ship | "cart", "basket" | In *Sales*, "Order" includes unpaid drafts |
| Shipment | One parcel dispatched to one address | "delivery" | — |

### Scope vs language
- **Ubiquitous language: yes**, this *is* the language artifact.
- **Scope: essentially no.** It only bounds language, and only implicitly (a term whose
  definition drifts implies you've left the context).

### Storage / living-artifact
A `glossary.md` (or `ubiquitous-language.md`) per BC directory, or the Ubiquitous-Language
section of the BCC. Version-controlled markdown table; reviewed with code so language and
code stay in lockstep.

### Overloaded context
A glossary makes overload visible **only via the "overloaded-with" column** — if one BC's
glossary keeps needing "(in the X sense)" qualifiers, the BC is straddling meanings. But a
glossary won't reveal *responsibility* overload (a BC doing too many jobs with a
consistent vocabulary). Weaker than the BCC on this axis.

---

## 3. Lightweight "context card" / capability-scope statement

### What it is + origin
Not a single formally-named community artifact — it's the **stripped-down minimum**: a few
lines per BC. Synthesized from (a) the BCC's top fields and (b) Team Topologies /
Independent Service Heuristics framing of "what does this team/service own vs not own."
Fowler's *BoundedContext* bliki and DDD strategic-pattern writing establish the underlying
idea that a BC "owns its own domain model, ubiquitous language, and schema."

### Fields / structure
Minimal, e.g.:
- **Purpose** — one sentence.
- **Owns** — the responsibilities/entities inside the boundary.
- **Does NOT own** — explicit exclusions, each pointing at the BC that *does* own it.
- **Key terms** — 3–8 ubiquitous-language terms.
- **Collaborators** — upstream/downstream contexts it talks to.

### Good at / weak at
- **Good at**: near-zero ceremony; fits on an index card; the **`Does-not-own` line is the
  cheapest possible overload detector**; trivially upgrades into a full BCC (it *is* the
  BCC's top rows).
- **Weak at**: no strategic classification, no message typing, no business rules — thin for
  a serious DDD review; easy to let it drift into vagueness ("owns billing stuff").

### Effort/weight
**Very lightweight.** Minutes per BC.

### Concrete example
```markdown
# Context Card: Notifications
Purpose: Deliver transactional messages (email/SMS/push) on behalf of other contexts.
Owns: Channel routing, delivery status, templates-rendering-at-send
Does NOT own: Template authoring (→ Templates), user contact prefs (→ Identity)
Key terms: Notification, Channel, DeliveryReceipt, Template (rendered instance)
Collaborators: in ← Billing, Subscriptions; out → (none; terminal)
```

### Scope vs language
- **Scope: strong for its size** — the explicit Owns / Does-not-own pair *is* the in/out
  boundary, stated more bluntly than the BCC does.
- **Language: partial** — a short key-terms list, not a full glossary.

### Storage / living-artifact
A `context-card.md` per BC. Ideal as a **first rung**: adopt cards fleet-wide fast, then
promote high-value/ambiguous BCs to full canvases.

### Overloaded context
**Best-in-class per unit of effort.** For our `templates` BC, a `Does NOT own` line forces
the question "then what *does* it own?" — and if the `Owns` list reads as several unrelated
capabilities, the card has exposed the accretion in five lines. This is precisely the
property we lift into the recommended BCC spine.

---

## 4. Aggregate Design Canvas (ADC) — noted, out of scope

**What/who**: DDD Crew structured tool for designing and documenting **a single
aggregate**. Fields: Aggregate Name, Purpose & Responsibilities, State Transitions,
Enforced Invariants, Corrective Policies, Handled Commands & Created Events.

**Why out of scope here**: the ADC documents the **internal tactical model** — invariants,
consistency boundary, state machine, command/event surface of *one aggregate inside* a BC.
It does not describe a BC's outward **scope** (in/out, collaborators, strategic role) or
its **ubiquitous language** as a whole. It's the right tool one level *down* (tactical
design / a later review), complementary to but not a substitute for a per-BC scope+language
doc. Note it in the report; do not adopt it for this angle.

---

## 5. "Context Canvas" / team-context variants (adjacent, mostly sibling-angle)

- **Core Domain Chart** (Nick Tune) — plots a *portfolio* of contexts by
  model-complexity × business-differentiation to show core/supporting/generic at a glance.
  This is a **cross-context/strategic** view, not a per-BC definition doc — belongs to a
  sibling angle, but note that its core/supporting/generic axis is exactly the BCC's
  *Strategic Classification* field, so the two stay consistent if we adopt the BCC spine.
- **Independent Service Heuristics (ISH)** (Team Topologies) — a checklist of "is this a
  good, independently-ownable boundary?" questions. Not a per-BC document form, but a good
  *validation lens* to apply while filling the Owns/Does-not-own and Purpose fields.
- **"Team-context" / product-variant ownership** (Tune, Team Topologies) — about mapping a
  context to a single owning team. Relevant to *who maintains the artifact* (one BC = one
  owning team = one file), not to the artifact's fields.
- Generic business-model "Context Canvas" (strategy tooling) — unrelated to DDD; ignore.

---

## Recommendation — the spine to standardize on

Adopt a **markdown Bounded Context Canvas, one file per BC** (`context-canvas.md` in the
BC's directory / registered per BC), using the standard BCC field set with **one addition**
(explicit Owns / Does-not-own) lifted from the lightweight context card:

```
Name
Purpose                     (business language, a few sentences)
Strategic Classification    (core|supporting|generic · business-model role · evolution)
Domain Role(s)              (from the archetype vocabulary)
Owns / Does-not-own         (← added: the blunt in/out boundary + overload detector)
Inbound Communication       (commands|queries|events, tagged by collaborator)
Outbound Communication      (commands|queries|events, tagged by collaborator)
Ubiquitous Language         (Term | in-context definition | avoid-synonym | overloaded-with)
Business Decisions          (key rules & policies)
Assumptions & Open Questions
```

**Why this spine**
- It is the **recognized standard** (BCC), so it's defensible in a DDD review and comes
  with tooling, a license, and shared vocabulary.
- It covers **all three targets in one artifact**: scope-in (Purpose/Classification/
  Decisions), scope-out (Owns-not / inbound-outbound), and **ubiquitous language** (its own
  table).
- **Markdown-per-BC** makes it a living, diffable, PR-reviewed artifact next to (or
  registered against) each BC — not a stale Miro board.
- The **Owns / Does-not-own** addition is the cheap, high-signal fix for our concrete pain:
  it makes an **overloaded BC (`templates`) visibly overloaded** — a long, multi-theme
  `Owns` list and a thin `Does-not-own` list is the split signal, readable at a glance.
- It **scales down gracefully**: the first five lines *are* the lightweight context card,
  so we can roll out cards fleet-wide first and promote ambiguous/core BCs (like
  `templates`) to the full canvas — same file, just more sections filled.

Keep the **per-context glossary** as the Ubiquitous-Language section (promote to its own
`glossary.md` if a BC's term list outgrows the canvas). Treat the **Aggregate Design
Canvas** as the next-level-down tactical tool, not part of this per-BC scope+language spine.

---

## Sources
- Bounded Context Canvas (DDD Crew, CC-BY-4.0): https://github.com/ddd-crew/bounded-context-canvas
- Model-traits / domain-role archetypes worksheet: https://github.com/ddd-crew/bounded-context-canvas/blob/master/resources/model-traits-worksheet.md
- Nick Tune, "Bounded Context Canvas V2/V3: Simplifications and Additions": https://medium.com/nick-tune-tech-strategy-blog/bounded-context-canvas-v2-simplifications-and-additions-229ed35f825f
- BCC V5 release notes (Robin Konrad): https://robinkonrad.de/posts/20221122_ddd_boundedcontextcanvasupdated/
- BCC in markdown (grjsmith): https://github.com/grjsmith/bounded_context_canvas_md
- BCC V4 markdown gist (oguzhaneren): https://gist.github.com/oguzhaneren/a57730c8cd50aec23c54977387032e79
- BCC generated from source (pierregillon): https://github.com/pierregillon/BoundedContextCanvasGenerator
- Aggregate Design Canvas (DDD Crew): https://github.com/ddd-crew/aggregate-design-canvas
- Ubiquitous Language (Qlerify DDD glossary): https://www.qlerify.com/dddconcepts/ubiquitous-language
- Ducin, "Speaking Ubiquitous Language" (one-phrase-one-concept convention): https://ducin.dev/ddd-speaking-ubiquitous-language
- Published Language (DDD Practitioners): https://ddd-practitioners.com/home/glossary/bounded-context/bounded-context-relationship/published-language/
- Martin Fowler, "BoundedContext" bliki: https://martinfowler.com/bliki/BoundedContext.html
- DDD strategic patterns / defining bounded contexts (DZone): https://dzone.com/articles/ddd-strategic-patterns-how-to-define-bounded-conte
- Core Domain Charts (Nick Tune, via esilva.net): https://esilva.net/tla_insights/core-domain-charts_tune
- Independent Service Heuristics (Team Topologies): https://teamtopologies.com/key-concepts-content/finding-good-stream-boundaries-with-independent-service-heuristics
- DDD Crew context-mapping: https://github.com/ddd-crew/context-mapping
