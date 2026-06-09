# Iterative experimentation as a first-class shopsystem capability

**Initiative:** lead-odqd · **Meta-deliverable bead:** lead-gkhk · 2026-06-09
**Status:** design synthesis (decision-bearing; feeds Phase 2 ADR/PDR + scenarios)

This synthesizes how the shopsystem framework should support **iterative
experimentation** — spike, learn the real limits, throw the spike away,
implement for keeps — as a named capability rather than an ad-hoc thing we
happened to do three times. Everything below is grounded in how the three
lead-odqd experiments *actually ran*:

- **agent-vault credential spike** (`findings/agent-vault-credential-spike.md`,
  lead-jkwo) — a CONFIRM spike: research → real throwaway broker + `spike-bc-av`
  container on the `shopsystem` network → five assertions passed → verdict +
  Phase-2 requirements. Had **one hard human-gated step** (the one-time real
  OAuth token paste into the broker) the autonomous agent could not perform.
- **fabro 2PC-as-steps spike** (`findings/fabro-2pc-as-steps-spike.md`,
  lead-f6ta) — a go-with-caveats spike: installed fabro 0.254.0, stood up a
  local server, ran a real kill/resume harness modelling ADR-012's three-step
  outbox protocol. Refined an existing hypothesis (decomposition narrows the
  race) **and surfaced a new hazard** (fabro's unconditional edges mask a failed
  node as SUCCEEDED).
- **substrate comparison** (`findings/substrate-candidate-comparison-vs-fabro.md`,
  lead-8mho) — a **research-only** evaluation of five tools to fabro-level depth,
  no live execution, run as a multi-agent Workflow. Produced a scorecard, a
  firm "nothing beats fabro," and **filed four follow-up beads** including one
  new spike (agent-runtime, lead-fih1).

These three already exhibit the full shape of the capability — a research-only
eval, a confirm spike, and a go-with-caveats spike, two of them with live
throwaway infra and one with a human wall. The job here is to *name and
systematize the shape we already used*, not to invent a new one.

---

## (a) The capability and the chosen mechanism

### The capability

**A spike is a first-class, throwaway, time-boxed unit of work whose sole
durable outputs are a `findings/` document, a verdict, and (on confirm) a set
of implementation-requirements that feed a normal Phase-2 graduation.** The
spike's code and infra are *designed to be discarded* — they live in isolated
scratch (`/tmp`, throwaway `spike-` containers, a throwaway worktree branch),
are never committed to lead or BC source, and are torn down at verdict time.

This is distinct from every existing message-type vehicle, all of which assume
the work product is *kept*: `assign_scenarios` commits new pinned behavior,
`request_bugfix` tightens pinned behavior, `request_maintenance` makes a flat
kept change, `request_scenario_register` / `request_shop_card` are read-only
queries. **None of them models "build something real, learn from it, throw it
away, keep only the finding."** That gap is the capability we are adding.

### The mechanism — DECISION: extend PDR-014's findings-driven graduation path; do NOT add a `request_spike` message-type vehicle now

The open design question was: a new `request_spike` BC-dispatched vehicle, vs.
extending the PDR-014 graduation path (findings-driven, lead-internal), vs. a
hybrid. **Decision: the lead-internal, findings-driven graduation path, with a
spike lifecycle made explicit on top of it. No `request_spike` vehicle in
Phase 2. Leave a hybrid open as a deferred trigger.**

Justification, grounded in the three runs:

1. **All three spikes were lead-host-internal infra, and that is not an
   accident of sampling — it is where spikes live.** agent-vault is launcher /
   credential plumbing; fabro is orchestration substrate; the substrate eval is
   substrate selection. These are **lead-host concerns** (the launcher,
   credential brokering, the reactive loop, the choice of orchestration
   engine) — the carve-out to "no implementation code in the lead repo" the
   user already named. A spike answers *"can the lead host's own machinery work
   this way?"*. There was **no BC to dispatch to** because the question was not
   about a BC's pinned behavior; it was about the substrate the lead runs on.
   A `request_spike` vehicle would have had no addressee in any of the three
   cases.

2. **The graduation step we actually want already exists in PDR-014.** A
   confirmed spike graduates exactly the way an experimental skill graduates:
   the finding → lead-po authors scenarios → lead-architect drafts the ADR and
   picks the discriminator vehicle → dispatch to the **owning** BC. The
   agent-vault spike's "What Phase 2 must cover" section is already a
   graduation manifest pointed at `bc-launcher`; the fabro spike's is pointed
   at the substrate decision (likely an ADR + scenarios against the messaging /
   loop seam). We do not need a new dispatch vehicle; we need the **stage
   *before* dispatch** — the throwaway experiment — named and disciplined. The
   discriminator (ADR-018 pre-state) still chooses the Phase-2 vehicle, exactly
   as today. The spike's job is to *produce the verified pre-state finding the
   discriminator consumes.* A confirmed spike feeds `assign_scenarios` (new
   capability, e.g. agent-vault) or `request_bugfix` (tighten unpinned behavior,
   e.g. fabro hardening the outbox protocol) — the spike does not replace that
   choice, it informs it.

3. **A `request_spike` vehicle would weaken the discriminator and the ADR-018
   harvest discipline.** A BC-dispatched experiment implies the BC builds
   throwaway code and reports a verdict — but the lead's only admissible
   evidence about a BC is the contract/artifact surface + the BC's `work_done`
   demonstration (ADR-018). A spike's value is *constructed, observed behavior*
   ("a request reached `api.anthropic.com` through the MITM proxy and returned
   a real `request_id`"; "a kill after N2's checkpoint replays only N3"). If a
   BC ran that experiment, the lead would be back to trusting BC-reported
   experiment results — precisely the empirical-verification line ADR-018 draws.
   Lead-internal spikes keep the experiment *on the surface the lead is allowed
   to observe directly* (the lead host's own scratch infra is not BC source).

4. **The hybrid is a real future need, but unproven — defer with an explicit
   trigger.** Some experiment could genuinely need a BC's not-yet-built
   capability (e.g. "spike whether the scenarios BC can canonicalize a new hash
   form"). For that, a future `request_spike` would dispatch a throwaway
   experiment whose `work_done` carries a verdict + finding rather than a pinned
   register. We do **not** build it now — none of the three cases needed it, and
   building a vehicle on zero proving cases is exactly the build-trap the
   experimental-first doctrine exists to prevent. **Trigger to revisit:** the
   first time a spike's question can only be answered by a BC constructing
   throwaway behavior the lead cannot stand up on its own host. Track as a P3
   bead, not Phase-2 scope.

**Net:** the mechanism is *lead-internal spike lifecycle + PDR-014 graduation*,
formalized. The spike is a new **work-tracking + findings discipline**, not a
new message type.

---

## (b) The spike lifecycle

Six stages. Each stage names its gate, its artifact, and its bd/findings/worktree
convention. The lifecycle is the same whether the verdict is confirm,
go-with-caveats, no-go, or not-viable — only the tail differs.

| Stage | What happens | Gate to advance | Durable artifact |
|---|---|---|---|
| **1. Intent** | A spike bead is filed under the initiative; the question is stated as a *kill-or-confirm* (a falsifiable hypothesis + the assertion(s) that would settle it). | The question is falsifiable and scoped to one substrate/seam. Vague "evaluate X" is sent back. | bd spike bead (type, P-level, blocks/depends links to the initiative) |
| **2. Research** | Read docs, schemas, source-of-the-substrate; for a research-only eval this is the whole body (substrate comparison stopped here, by design). | Either a verdict is already firm from research alone (→ stage 6, e.g. agentic-lab not-viable), or a *constructed* demonstration is required (→ stage 3). | research notes folded into the findings draft |
| **3. Throwaway execution** | Stand up real infra in **isolated scratch**: `/tmp` working dirs, throwaway `spike-` containers on the real network *with dummy/placeholder data*, a throwaway worktree branch for any code. The live fleet and real credentials are never touched. | Infra runs; the planned assertions can actually be exercised. | nothing committed — scratch only |
| **4. Verdict** | Run the assertions; record pass/fail; capture findings *beyond the plan* and any *new hazards*. Assign one of four verdicts. | All planned assertions exercised (or the human wall is hit and recorded — see protocol below). | `findings/<spike>.md` with verdict + "what Phase 2 must cover" |
| **5a. Graduate** (confirm / go-with-caveats) | Hand the finding's implementation-requirements to the PDR-014 path: lead-po authors scenarios, lead-architect drafts ADR + picks the discriminator vehicle, dispatch to the owning BC. | A clean finding with implementation-requirements. | Phase-2 bead(s), ADR, scenarios, dispatch |
| **5b. Discard** (no-go / not-viable) | Record the negative as a finding + a kill bead so it is not re-litigated. No dispatch. | A clean negative finding. | findings doc + closed kill bead |
| **6. Teardown** | Tear down all scratch infra (`spike-` containers, `/tmp` dirs, worktree branch). Keep **only** the findings doc (+ ADR if graduated). | Scratch is gone; nothing throwaway leaked into lead/BC source. | (nothing — the point is removal) |

### Verdict vocabulary (four values, all observed in the three runs)

- **confirm** — hypothesis held end-to-end; graduate. (agent-vault.)
- **go-with-caveats** — hypothesis held for the common case but with mandatory
  carry-forward constraints and/or a newly surfaced hazard; graduate *with the
  caveats pinned in the ADR*. (fabro: keep ADR-012's UNIQUE constraint;
  outcome-conditional edges mandatory.)
- **no-go** — constructed experiment refuted the hypothesis; discard + record.
- **not-viable** — research alone refuted it; no spike warranted. (agentic-lab.)

### The human-in-the-loop protocol

The agent-vault spike hit a wall an autonomous agent **cannot** cross: a human
must once read the real `accessToken`/`refreshToken` from a logged-in
`~/.claude/.credentials.json` and store them in the broker. The agent correctly
**used a dummy, proved everything creds-free, and recorded the wall** rather
than faking it (assertion (d) passed with a creds-free 401 kill-line — exactly
the right shape: prove the plumbing, stop at the secret). The protocol codifies
that behavior:

1. **Detect the wall.** A spike step requires a one-time human secret, an
   interactive OAuth paste, a dashboard-only action, or any input the autonomous
   agent has no admissible way to supply.
2. **Do not fake it.** Substitute a dummy/placeholder and prove *everything up
   to the wall* (the creds-free kill-line is the template: a real `request_id`
   + an expected failure that a real secret would turn into success).
3. **Record the wall explicitly** in the findings doc as "the one hard
   human-gated step," naming exactly what the human must do and what resumes
   afterward (the broker auto-refreshes thereafter).
4. **Hand to the human / resume.** The wall becomes a **Phase-2 operational
   step** (a runbook line, or a scenario step the operator performs once), not a
   blocker on the spike's verdict. A spike can reach **confirm** with a recorded
   human wall, *provided the creds-free plumbing is proven* — agent-vault did.
5. **Correct predicted walls against reality.** The agent-vault spike *corrected
   two predicted human walls* (owner registration and CA export turned out to be
   CLI-doable, not dashboard-only). The protocol requires re-testing predicted
   walls during execution, not assuming them.

### bd / findings / worktree conventions

- **bd:** every spike is a bead under the initiative (`blocks`/`depends-on`
  links, as lead-odqd already does). The spike bead's `work_id` is the lead
  beads ID — and, on graduation, the Phase-2 ADR/scenario work gets **its own
  fresh bead** (e.g. lead-jkwo spike → lead-v4ih Phase-2), never reusing the
  spike's ID. Spikes that surface new spikes file them as fresh beads (the
  substrate eval filed four, including lead-fih1). A no-go/not-viable verdict
  closes the spike bead with the finding linked.
- **findings:** one `findings/<spike-slug>.md` per spike, header line carrying
  `Initiative · bead · date · Verdict`. The doc is the durable artifact; it
  outlives the scratch. House style is set by the three existing docs: problem →
  what was executed → assertions → findings-beyond-plan → new hazards → "what
  Phase 2 must cover" → verdict.
- **worktree / scratch:** code spikes use a **throwaway git worktree branch**
  (never merged) or `/tmp`; infra spikes use **`spike-`-prefixed containers** on
  the real network with **dummy data only**. The naming prefix is the
  teardown contract — anything `spike-` is disposable by definition. **Nothing
  from scratch is ever committed to lead or BC source** (the standing "no
  implementation code in the lead repo" rule holds; the carve-out is only that
  these are *lead-host* infra experiments in scratch, not kept lead source).

### Execution engine — spikes run via Workflow, return markdown

All three ran via the **Workflow** multi-agent engine. We learned a hard
reliability constraint: **a heavy-context agent emitting a large, array-heavy
StructuredOutput schema hangs** — the agent-vault doc is explicitly *salvaged
from the agent's transcript* because the structured-emit stage hung even though
the experiment completed. The capability codifies the mitigation:

- **Spikes execute via Workflow** (multi-agent; the substrate eval was a
  multi-agent workflow, the two execution spikes were agent-run).
- **Spikes return markdown findings, not large structured output.** Prefer
  prose + small tables. If structured emit is needed, keep the schema small and
  flat (no big arrays). This is a *capability requirement*, not a style note —
  it is the difference between a completed spike whose finding survives and one
  whose finding is lost in a hung emit.

---

## (c) Relation to existing vehicles and PDR-014

**Message-type vehicles (`assign_scenarios` / `request_bugfix` /
`request_maintenance` / `request_scenario_register` / `request_shop_card`):**
the spike does **not** add to this set. It sits *upstream* of it. A spike
*produces the verified pre-state finding the discriminator consumes*; the
discriminator then picks the existing vehicle for the kept Phase-2 work. Spike →
finding → (PDR-014 graduation) → discriminator → existing vehicle. The spike is
the empirical-verification engine that feeds ADR-018's pre-state question with
*constructed* evidence, on the one surface the lead may construct evidence on
(its own scratch host), not BC source.

**PDR-014 graduation path:** the spike lifecycle is the **same shape** as the
experimental-skill graduation path, generalized from "skill" to "finding."
PDR-014/PDR-012 already say: prove a thing experimentally, then pin it by
Gherkin and dispatch to the owning BC so the canonical template owns it. A spike
is that, for *substrate/infra learnings* instead of *skills*. The two converge
at the same graduation gate (lead-po scenarios + lead-architect ADR + dispatch).
**This capability extends PDR-014's path to cover throwaway-experiment findings,
not just experimental skills.** A natural artifact of that convergence: a
`run-spike` (or `experiment-lifecycle`) **lead skill** could itself graduate via
PDR-014 into the canonical lead skill-group — the lifecycle in (b) is its body.

---

## (d) Phase-2 ADR/PDR skeleton + scenario outlines

*(Titles + one-line intents only. Full Gherkin is lead-po's Phase-2 job — these
are outlines, not authored scenarios.)*

### PDR (intent record)

- **PDR-016 — Iterative experimentation is a first-class lead capability:
  the spike lifecycle and findings-driven graduation.** Records the intent that
  spikes are throwaway, time-boxed, lead-internal, Workflow-executed units whose
  durable output is a `findings/` doc + verdict, graduating via the PDR-014 path;
  no `request_spike` vehicle now (hybrid deferred with explicit trigger).

### ADRs (decisions with rejected alternatives)

- **ADR-026 — Spike vehicle: extend PDR-014 graduation, reject `request_spike`
  for now.** Decision + the three rejected alternatives (new vehicle / pure
  PDR-014 / hybrid) with the grounded rationale; names the trigger that would
  reopen the hybrid.
- **ADR-027 — Spike isolation contract: `spike-` scratch, dummy data, throwaway
  worktree, teardown-to-findings.** Decision that no spike artifact is ever
  committed to lead/BC source; the `spike-` prefix is the teardown contract;
  only the findings doc (+ ADR) survives.
- **ADR-028 — Human-in-the-loop wall protocol for autonomous spikes.** Decision
  that an autonomous spike detects/records/never-fakes a human-gated step,
  proves everything creds-free up to the wall, can still reach `confirm`, and
  emits the wall as a Phase-2 operational step.
- **ADR-029 — Spikes execute via Workflow and return markdown findings (no
  large StructuredOutput).** Decision pinning the engine + the
  small-schema/markdown reliability constraint, grounded in the salvaged-transcript
  failure.

### Scenario outlines (for lead-po to author in Phase 2)

Targeted at the lead's own process / tooling surface (and, where a BC owns the
machinery, dispatched per the discriminator):

1. **Spike intent is falsifiable** — Given a spike bead, When it lacks a
   kill-or-confirm hypothesis, Then it is sent back before execution.
2. **Spike scratch is isolated and disposable** — Given a running spike, Then
   its containers are `spike-`-prefixed on the real network with dummy data, and
   nothing is committed to lead/BC source.
3. **Spike teardown keeps only the finding** — Given a verdict, When the spike
   completes, Then all scratch is torn down and only `findings/<spike>.md`
   (+ ADR if graduated) remains.
4. **Verdict is one of four values** — confirm / go-with-caveats / no-go /
   not-viable, each with the required findings-doc sections.
5. **Human wall is detected, not faked** — Given a step needing a one-time human
   secret, Then the spike uses a placeholder, proves the plumbing up to the wall,
   records the wall, and may still reach confirm.
6. **Confirmed spike graduates via PDR-014** — Given a confirm/go-with-caveats
   verdict with implementation-requirements, Then lead-po authors scenarios and
   lead-architect drafts the ADR and picks the discriminator vehicle, against a
   fresh Phase-2 bead.
7. **Spike runs via Workflow and returns markdown** — Given a spike execution,
   Then it runs via Workflow and returns markdown findings (not a large
   array-heavy StructuredOutput).
8. **New hazards surface as findings + beads** — Given a spike that uncovers an
   unanticipated hazard (e.g. fabro's silent-success edge), Then it is recorded
   in the finding and filed as a fresh bead.

---

## (e) Open questions

1. **Where do spike scenarios live and who owns them?** Some pin *lead process*
   (intent-falsifiability, teardown) with no BC owner; others pin *tooling*
   (Workflow markdown-return, `spike-` container hygiene) that a BC may own. The
   discriminator picks per scenario, but the spike-process scenarios may have no
   addressee — does the lead need a "lead process" features home, or do these
   stay doctrine in primers/ADRs rather than dispatched Gherkin?
2. **The hybrid `request_spike` trigger — how is it watched?** We deferred it
   with a trigger ("first spike whose question only a BC can answer by
   constructing throwaway behavior"). Who notices the trigger fired, and does
   recognizing it require its own bead discipline?
3. **Worktree vs. `/tmp` for code spikes — one convention or author's choice?**
   The three runs used `/tmp` + `spike-` containers; no code-spike used a
   throwaway worktree branch yet. Pin one convention, or leave it to the spike?
4. **Findings doc lifecycle after graduation.** Once a spike graduates to an
   ADR, is the findings doc frozen as historical, or does it get a "superseded
   by ADR-NNN" header (like the memory-note supersession pattern)? Avoid stale
   findings masquerading as current.
5. **Time-boxing enforcement.** "Time-boxed" is named but unmeasured — none of
   the three had an explicit box. Is a box a soft norm or a bd-tracked budget,
   and what happens when a spike blows it (auto-verdict "inconclusive"?)?
6. **Workflow reliability constraint — codify a hard schema cap?** "Prefer
   small/flat schemas" is qualitative. Should the capability state a hard limit
   (e.g. no arrays in spike StructuredOutput; markdown-only return), since the
   one observed failure was exactly a large array-heavy schema hang?
