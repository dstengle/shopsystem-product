# Brief 009 — Scenario-completion journal (BC-authoritative) and lead-side system implementation-state snapshot

**Status:** draft (2026-06-08)
**Authors:** dstengle (stakeholder, problem-framing-canvas), Claude (lead-po)
**Umbrella bead:** [`lead-5p07`](#) — its notes field carries the full
problem framing and the four stakeholder decisions verbatim; this brief is
the lead-shop-visible authoring artifact that operationalizes them.
**Anchored to:** stakeholder framing 2026-06-08 (problem-framing-canvas;
discovery is complete — this brief authors intent, it does not re-interview).

---

## Problem statement (reframed — this IS the problem)

**HMW:** make per-scenario completion a *durable, queryable fact* — an
authoritative append-only journal in each BC, mirrored as a lead-side
snapshot — so that "is **this** scenario done?" and "what is outstanding
**system-wide**?" are **lookups**, not manual reconstructions.

Today, reconciliation is a per-`work_done` sweep: the lead recomputes
block-only canonical hashes via `scenarios hash`, matches them against the
on-disk `@scenario_hash:` tags, and cross-checks the mailbox. That is far
too much labor for a question that should be a constant-time lookup, and the
labor recurs on every dispatch.

### Seed story (element #1 — the MVP must nail this)

The lead saw a bead marked **READY** in its registry whose scenario was *in
fact already implemented* in a BC. There was no cheap way to answer **"has
THIS scenario been implemented?"** The atomic per-scenario completion lookup
is the single most important behavior in this brief. Everything else is
support for it or motivation behind it.

---

## Stakeholder decisions (accountable inputs — not relitigated here)

These were decided by the stakeholder during framing. They are inputs to
authoring, not open questions.

1. **"Completed" (MVP definition) = PINNED & DEMONSTRATED.** A scenario
   counts as done once **both** of these hold:
   - a `work_done` has landed for it, **and**
   - its **block-only canonical hash** (ADR-019 / scenario-117 vocabulary)
     equals the on-disk `@scenario_hash:` tag for that scenario block.

   "Currently green" (the scenario's test passes *right now*) and
   drift-tracking are **explicitly LATER, not MVP**. "Completed" here is a
   historical, demonstrated-once fact, not a live test-status reading.

2. **Denominator for "outstanding" = ALL canonical scenarios in this repo's
   `features/`,** including scenarios that have *never been dispatched* to
   any BC. Authored-but-not-built-anywhere is the **true gap** and must be
   visible in the outstanding view — that is precisely the class the seed
   story is a symptom of.

3. **Mechanism intent (product constraint only — the Architect owns the
   design).** The BC holds the **authoritative, append-only journal** of its
   completed scenario hashes. The lead keeps a **snapshot** that it:
   - **mirrors incrementally** from the `work_done` messages it already
     receives, **and**
   - can **fully reconcile on demand** by pulling BC journals.

   **Prefer a lightweight unification** of the incremental-update path and
   the full-reconcile path **only if it does not add heavy
   complexity/resource cost** — otherwise keep them separate. The trade-off
   to weigh is incremental-work-amount vs. full-on-demand-reconcile
   capability. This brief commits the *behavioral surface* (incremental
   reflect, on-demand reconcile); whether they share one code path is the
   Architect's structural call.

4. **Secondary jobs MOTIVATE the design but are NOT MVP features now:**
   - **(a) State/progress recovery after agent failure.** An agent failure
     that loses progress is what makes the BC journal *authoritative*: the
     lead can rebuild its snapshot from BC journals. This is the *reason*
     the journal lives in the BC, but a recovery workflow is not authored
     in this brief.
   - **(b) Scenario-level progress tracking** (sub-scenario / in-flight
     progress, not just done/not-done).
   - **(c) Rolling work progress up into higher-level units** (bead → epic →
     initiative roll-ups over completion state).

   These are named as motivating context and future surface. **No scenarios
   in this brief build them out.** See "Out of scope" and "Future surface."

---

## What this brief commits — MVP scope

The MVP is the **atomic per-scenario completion lookup**, plus exactly the
mechanism that makes that lookup authoritative and the system-wide
outstanding view correct. Concretely, the system must support:

1. **Atomic lookup — "is scenario X implemented?"** Given a scenario block
   (identified by its block-only canonical hash), the system answers a
   definite **yes / no**, keyed on that hash. This is the seed story's
   answer made cheap.

2. **BC records a completed scenario into its journal on completion.** When a
   BC completes a scenario (the PINNED & DEMONSTRATED condition is met), the
   scenario's block-only canonical hash is appended to that BC's
   authoritative journal. The journal is append-only.

3. **The lead's snapshot reflects a newly-completed scenario.** When a
   `work_done` lands carrying a completed scenario, the lead's snapshot
   incrementally records that scenario as completed — no full sweep
   required.

4. **The lead reconciles its snapshot against a BC journal on demand.** The
   lead can pull a BC's journal and reconcile its snapshot against it,
   producing a snapshot that matches the BC's authoritative state for that
   BC (this is the path that recovers from a lost/incomplete snapshot).

5. **The system-wide outstanding view counts never-dispatched canonical
   scenarios as outstanding.** A canonical scenario authored under
   `features/` that has never been dispatched and never completed is
   reported as outstanding — it is part of the denominator (decision #2).

6. **An orphan (unrecognized) completion is FLAGGED as an anomaly — never
   silently counted and never made first-class.** When a BC's journal reports
   a completed scenario whose block-only canonical hash is **absent** from any
   `@scenario_hash:` tag under this repo's canonical `features/`, the
   system-state view **flags it as an unrecognized/orphan anomaly surfaced for
   investigation**. It is **excluded from the coverage count** and **excluded
   from the outstanding denominator** — it counts toward neither side of the
   ledger. (See "Resolved scope decision: orphan completions" below.)

### Resolved scope decision: orphan completions (stakeholder, 2026-06-08)

A scope question — *what happens when a BC journals a completed hash that has
no match in canonical `features/`?* — was resolved **with the stakeholder
(dave)** on 2026-06-08. **Decision (option A): canonical `features/` is the
sole authority for what counts.** An orphan completion is **flagged as an
anomaly** ("unrecognized/orphan completion") and surfaced for investigation;
it is **NOT** counted toward coverage and **NOT** counted in the outstanding
denominator. It is never silently dropped and never promoted to a first-class
counted completion.

**Rationale (empirically grounded — do not relitigate).** Canonical scenario
hashes are content-addressed and **retire-and-replace**: editing a scenario
body mints a new hash and the author must rewrite the `@scenario_hash:` tag
(scenario **117-E**, integrity / edit-detection; **117-D** Feature-line-edit
invariance). A BC-completed hash that is absent from canonical `features/` is
therefore **not a legitimate steady state**. It can only arise from one of:

- **(i)** the in-flight hashing-divergence defect (wire `scenarios[].hash`
  vs. on-disk `@scenario_hash:` tag) tracked by **lead-ji28** (in_progress)
  and **lead-gw60** (open — defect-(a) construction-site fix unverified);
- **(ii)** transient propagation / version-lag (the BC completed a
  now-retired hash); or
- **(iii)** a BC-local / never-promoted scenario.

Flagging-as-anomaly is the correct design **and** doubles as a free detector
for the lead-ji28 divergence class. **Caveat:** until **lead-gw60** closes, a
flagged orphan may *be* that known defect rather than a true anomaly — which
is the **desired surfacing**, not a contradiction.

### Vocabulary (load-bearing)

- **Completed scenario** — a scenario that is PINNED & DEMONSTRATED per
  decision #1: a `work_done` landed for it AND its block-only canonical hash
  equals the on-disk `@scenario_hash:` tag. Historical fact, not live test
  status.
- **Block-only canonical hash** — the per-scenario hash defined by ADR-019
  and pinned by scenario-117: sha256 (first 16 lower-case hex) of the
  scenario-block-only canonical text, computed by the `scenarios hash`
  contract tool. The **identity key** for a scenario throughout this brief.
- **BC journal** — a BC's authoritative, append-only record of the
  block-only canonical hashes of the scenarios it has completed.
- **Lead snapshot** — the lead's materialized view of system-wide
  completion state, mirrored incrementally from `work_done` and
  fully reconcilable on demand from BC journals.
- **Outstanding** — a canonical scenario under this repo's `features/` that
  is not completed (including never-dispatched scenarios).
- **Orphan (unrecognized) completion** — a BC-journaled completion whose
  block-only canonical hash is absent from any `@scenario_hash:` tag under
  this repo's canonical `features/`. Flagged as an anomaly and surfaced for
  investigation; counts toward neither coverage nor the outstanding
  denominator (resolved scope decision, 2026-06-08).

---

## What would NOT satisfy the stakeholder

- A "currently green" / live-test-status reading dressed up as completion.
  Completion is **demonstrated-once + hash-matched**, per decision #1.
  Re-deriving "is it green now?" is a *different* (later) job.
- An outstanding view whose denominator is "dispatched scenarios only."
  That would hide the exact class the seed story is a symptom of
  (authored-but-never-built). The denominator is ALL `features/` canonical
  scenarios (decision #2).
- A lead snapshot treated as the source of truth. The **BC journal is
  authoritative**; the lead snapshot is a mirror that can always be rebuilt
  from BC journals (decision #3, motivated by secondary job (a)).
- A lookup keyed on anything other than the block-only canonical hash
  (e.g., keyed on bead ID, scenario title, or dispatch record). The hash is
  the stable identity (ADR-019 / scenario-117); keying on anything else
  reintroduces the drift the hash exists to eliminate.
- Building out secondary jobs (a)/(b)/(c) now. They motivate the shape;
  they are not MVP features.

---

## Product constraints the Architect inherits (NOT decisions this brief makes)

This brief deliberately does **not** decide design/decomposition. It records
the framed constraints so the Architect inherits intent, then makes the
structural calls.

- **Which BC owns the journal.** Not decided here. The block-only hash
  concern is `shopsystem-scenarios`' territory (ADR-019); journal/snapshot
  transport likely touches `shopsystem-messaging` (the lead already receives
  `work_done` there); the `@scenario_hash:` tag tooling lives in
  `shopsystem-templates`. Ownership is the Architect's decomposition call at
  pre-state.
- **The journal store and the snapshot store** (DB table? file under the
  BC? a `scenarios`-owned artifact? a messaging-owned table?) — Architect's
  call.
- **The on-demand journal-pull vehicle.** The lead needs a way to REQUEST a
  BC's journal. Whether that is a new `shop-msg` message type, an extension
  of an existing one, or a CLI surface on an existing BC is the Architect's
  call. This brief commits only that the on-demand reconcile capability
  exists.
- **Whether the incremental-reflect and full-reconcile paths are unified.**
  Decision #3 expresses a *preference* for lightweight unification; the
  Architect weighs it against complexity/resource cost and decides.
- **Message-type discriminator.** Per the lead primer: new capability →
  `assign_scenarios`; capability-exists-but-unpinned → `request_bugfix`;
  flat → `request_maintenance`. The Architect applies this after empirical
  pre-state verification against the contract/artifact surface (ADR-018).

---

## Out of scope — named explicitly (this brief)

- **"Currently green" / drift-tracking.** Completion is demonstrated-once +
  hash-matched (decision #1). Live test-status reading is later.
- **Agent-failure recovery workflow (secondary job a).** The journal is
  *made* authoritative so recovery is *possible*; the recovery workflow
  itself is not authored here.
- **Scenario-level / in-flight progress tracking (secondary job b).** This
  brief tracks done / not-done, not partial progress.
- **Roll-up into higher-level units (secondary job c).** Completion roll-ups
  over beads/epics/initiatives are future surface.
- **BC decomposition, store design, and the journal-pull vehicle** — the
  Architect's calls (see "Product constraints the Architect inherits").

---

## Future surface — sketched, NOT committed

Enumerated so the Architect sees the trajectory; **nothing here is
committed**, and the secondary jobs are deliberately un-authored as
scenarios:

- **Recovery (motivated by job a):** a workflow where the lead, having lost
  snapshot state, rebuilds it by pulling every BC journal. The on-demand
  reconcile capability (MVP scope item 4) is the primitive this would build
  on.
- **Progress tracking (job b):** sub-scenario / in-flight progress beyond
  binary done/not-done.
- **Roll-ups (job c):** completion state aggregated over beads, epics, and
  initiatives.

Each future item is its own brief, authored when its assumptions are worth
committing to.

---

## Grounding artifacts

- [`adr/019-canonicalization-ownership-in-scenarios-bc.md`](../adr/019-canonicalization-ownership-in-scenarios-bc.md)
  — block-only canonicalization ownership; the hash that keys this brief.
- [`features/templates/117-canonical-scenario-hash-canonicalization-is-scenario-block-only-not-feature-line-included.gherkin`](../features/templates/117-canonical-scenario-hash-canonicalization-is-scenario-block-only-not-feature-line-included.gherkin)
  — pins the block-only canonical-hash vocabulary this brief reuses.
- [`adr/018-empirical-verification-is-contract-surface.md`](../adr/018-empirical-verification-is-contract-surface.md)
  — the contract/artifact surface the Architect verifies pre-state against;
  also the reason `scenarios hash` (not hand-computation) produces the tags.
- [`briefs/006-messaging-name-registry-and-lead-inbox.md`](006-messaging-name-registry-and-lead-inbox.md)
  — the lead-inbox / `work_done` transport the incremental-reflect path
  consumes.
- Umbrella bead `lead-5p07` — full framing + the four decisions verbatim.

---

## What this leaves open

The brief commits **MVP intent** and the five MVP behaviors (pinned by the
scenarios under `features/scenario-journal/`). It deliberately leaves open:

- Every "Product constraints the Architect inherits" item (ownership, store
  design, journal-pull vehicle, path unification, discriminator).
- All secondary jobs (a)/(b)/(c) — future surface, un-authored.

The PO commits the intent and the behaviors. The Architect verifies
pre-state, decides decomposition and vehicle, and dispatches.
