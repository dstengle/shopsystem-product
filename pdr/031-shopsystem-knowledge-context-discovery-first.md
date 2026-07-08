# PDR-031 — shopsystem-knowledge: a kind-extensible knowledge context, discovery-first (decisions v1)

**Status:** draft (2026-07-07)
**Authors:** dstengle, Claude (lead-po)
**Anchored to:** [lead-x7bp](#) (EPIC: progressive disclosure for LLM artifacts) and its DESIGN REFRAME [lead-9lyi](#) — *"the primary value is DISCOVERY, not enforcement."*
**Reference prototype (NOT the spec):** `tools/shopsystem-decisions/` on branch `pd-consistency-experiments` — a spike that proves the mechanics (frontmatter schema, single-source L0/L1/L2 + index, coherence gate). This PDR deliberately does **not** re-spec its gate-heavy shape.

## Point of intent

Stand up a new bounded context, **`shopsystem-knowledge`**, whose job is to keep
the framework's accumulated knowledge *consultable* and *self-consistent* so that
agents (lead-po, lead-architect, and BC architects) reliably reference existing
decisions before authoring new ones. The observed behavior change we are buying:
**a decision-author, at authoring time, is shown the relevant existing decisions
and told whether the new decision is already covered, contradicts one, or
supersedes one — before the new decision is committed.** Today that consultation
is manual and unreliable, which is how the framework accumulated contradictory
and stale decisions (the fabro FC1–FC4 cases mined in lead-9lyi).

This is the *discovery-first* reframe. The epic's original recommendation led
with a coherence/invariant **gate**; the reframe (lead-9lyi, lead-x7bp NOTES,
David 2026-07-07) demotes the gate to opt-in hardening and elevates
**adversarial analysis at authoring** to the everyday, primary mechanism. The
overnight prototype over-invested in the gate (T3) and under-built the
adversarial-authoring pass; this v1 spec inverts that emphasis.

## The job-to-be-done

*When I am about to author a new decision (ADR/PDR/brief), help me discover
whether the framework has already decided this, decided the opposite, or decided
something this replaces — so I do not silently create a contradiction or a
redundant decision.* The JTBD is discovery, not enforcement. Enforcement (a
continuous deterministic tripwire) is a narrower, opt-in job serving only the
few load-bearing claims that want it.

## Scope: a kind-extensible knowledge context, decisions-first

### BC identity

`shopsystem-knowledge` is a **generalized knowledge context** that exposes
**typed accessors per knowledge KIND**. It is not "the decisions tool" — it is
the knowledge context whose **first and only v1 kind is `architecture-decision`**
(the ADR/PDR/brief corpus). The accessor surface is parameterized by kind so
that later kinds slot in without re-founding the BC.

The kinds we design *for* but do **not** build in v1:

- `development-principle` — durable principles / doctrine (the "new kind" from the lead-x7bp knowledge-context reframe).
- `skill-recipe` — agent-skill recipes.
- `experiment-research` — findings / research reports.

**Extensibility requirement (v1, load-bearing):** the accessor contract, the
frontmatter schema, and the projection/index generator must be parameterized by
`kind` — a `kind` field, a per-kind source location, and a per-kind projection
set — such that adding `development-principle` later is *registering a kind*, not
*forking the tool*. v1 ships exactly one registered kind. Requesting an
unregistered kind returns a definite "kind not registered" answer, never a silent
default to `architecture-decision`.

### PRIMARY capability — discovery via adversarial analysis at authoring

This is the centerpiece and the everyday mechanism. When a new decision is being
authored:

1. The system **retrieves the relevant existing neighbours** for the draft via
   the L0/L1 index (relevance triage over cards + decision extracts — bounded
   retrieval, not the whole corpus dumped into context).
2. An **adversarial pass** (prose/LLM judgment over those neighbours) tries to
   *break* the draft against each neighbour and answers the three questions:
   - **Covered?** — is this already decided elsewhere?
   - **Contradicts?** — does this reverse or conflict with an active decision?
   - **Supersedes?** — does this replace a prior decision (and therefore owe a
     supersede edge)?
3. The output is an **assessment report**: the surfaced neighbours by id, and for
   each the covered/contradicts/supersedes verdict **with a citation to the
   neighbour**.

This is **prose/judgment-based, requiring NO pre-encoded invariants**. It catches
the fabro FC1 case — a draft claiming "parity / unchanged interface" while a
neighbour changed the governed engage — by *reading* the neighbour's decision
text, not by matching a registered predicate. Prose analysis is the right tool
here, not a compromise: it is broad, low-burden, and fires on the authoring event
where the human judgment already lives.

### SUPPORTING capability — single-source projections + index

The adversarial pass consumes projections; those projections must be trustworthy
(no summary↔full drift — the same failure class as scenario-hash/gherkin drift).

- **Single-source frontmatter schema.** Every decision document carries its
  machine truth in YAML frontmatter (`id, kind, title, status, date,
  description`, typed `edges`, optional `tags`/`beads`); the human body is
  rationale. One home per fact.
- **Deterministic generation of L0/L1/L2 projections + a machine+human index.**
  From the one source, generate L0 (id+title+description card, for relevance
  triage), L1 (the decision extract, for BCs that must conform), L2 (the source
  document, for authors), plus a machine index (`index.json`) and a human index
  (`DECISIONS.md` / `llms.txt` style). Every output byte is a pure function of the
  parsed corpus — **byte-stable** (no timestamps, hostnames, or absolute paths
  leak in) and **idempotent** (regenerate → zero-byte diff; a `--check` mode is
  the drift gate).
- **`## Decision` heading-convention extraction — noted honestly.** L1 is a
  **verbatim slice** of the document's recognized decision section, located by
  matching one of a small allowed heading set (`## Decision` → `## The decisions`
  → `## The decision` → `## Point of intent`, first match wins, section runs to
  the next H2/EOF). This is **verbatim-but-convention-gated, NOT a pure
  projection**: a document that carries no recognized decision heading has no L1
  to slice, and the system must report that document as **non-conforming**, not
  silently emit an empty extract.

### OPT-IN hardening — the coherence gate (demoted from the prototype's REQUIRED posture)

The prototype made the gate the always-on centerpiece. v1 demotes it:

- **Typed-edge coherence checks are the always-on deterministic floor.** Cheap,
  model-free graph checks over the frontmatter edges — supersession-graph
  coherence (active doc supersedes an active doc; asymmetric or dangling
  supersede edges; the missing `superseded-by` back-edge of the lead-sr93 /
  ADR-025 defect) and dangling edge targets. These earn their keep as a floor
  because they are deterministic, cheap, and catch the exact FC4 class the
  reframe cited.
- **The `governed-delta` invariant tripwire is OPT-IN per load-bearing claim.**
  The T3 baseline-hash set-diff tripwire (a claim pins a baseline over a governed
  surface; any drift trips it) is **not** an always-on discipline. It is reserved
  for the few load-bearing claims that want a *continuous* deterministic tripwire
  — one that also catches **non-authoring** changes (a scenario tweak or bugfix
  with no new decision), the one thing the authoring-time adversarial pass
  structurally cannot cover. Trigger-surface distinction: adversarial fires on an
  authoring **event**; the governed-delta tripwire fires on **any** change to the
  governed artifact. Most claims never opt in.

## Decision

1. **Found `shopsystem-knowledge` as a bounded context** — a kind-extensible
   knowledge context, not a single-purpose decisions tool. v1 registers exactly
   one kind, `architecture-decision`.

2. **Discovery-first.** The PRIMARY, everyday capability is authoring-time
   discovery via adversarial analysis over the L0/L1 index, answering
   covered/contradicts/supersedes with citations, requiring no pre-encoded
   invariants. This is what v1 must make excellent.

3. **Single-source projections are supporting infrastructure**, specified to be
   deterministic, byte-stable, and idempotent, with the L1 decision extraction
   honestly marked as convention-gated (recognized decision heading required;
   non-conforming documents reported, not silently empty).

4. **The coherence gate is opt-in hardening, not a required discipline.**
   Typed-edge supersession/dangling checks are the always-on deterministic floor;
   the `governed-delta` invariant tripwire is opt-in per load-bearing claim only,
   reserved for continuous tripwires that must catch non-authoring changes.

5. **Kind-extensibility is a v1 requirement of the shape, not a v1 deliverable of
   the kinds.** The accessor, schema, and generator are parameterized by kind;
   `development-principle` / `skill-recipe` / `experiment-research` are named as
   future kinds and must not be boxed out, but none are built now.

6. **Build through specs.** The productionized BC is built from PO-authored
   scenarios informed by this reframe — NOT by re-speccing the gate-heavy
   prototype. The prototype is reference for mechanics only.

## What this v1 does NOT do (explicit non-goals)

- Does not build the `development-principle`, `skill-recipe`, or
  `experiment-research` kinds.
- Does not make the `governed-delta` invariant tripwire an always-on discipline.
- Does not re-adopt the prototype's gate-centric required posture.
- Does not distribute the L1 digest to BCs (epic acceptance item; a follow-on
  scenario family once the accessor and projections are pinned).

## Cross-references

- [lead-x7bp](#) — EPIC, and its 2026-07-07 direction to move to a real BC built through specs.
- [lead-9lyi](#) — DESIGN REFRAME: discovery-primary; T3 demoted to opt-in; honest critique of the overnight build.
- `tools/shopsystem-decisions/` @ `pd-consistency-experiments` — reference prototype/spike proving the mechanics (frontmatter schema, generator, coherence gate). Reference only.
- [lead-sr93](#) — the FC4 supersession-without-back-edge defect the always-on typed-edge floor is sized to catch.
- Primary scenario set: `features/shopsystem-knowledge/` (`single_source_projection.feature`, `authoring_discovery.feature`).
