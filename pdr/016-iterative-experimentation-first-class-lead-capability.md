# PDR-016 — Iterative experimentation is a first-class lead capability: the spike lifecycle and findings-driven graduation

**Status:** draft (2026-06-10)
**Authors:** dstengle, Claude (lead-architect)
**Anchored to:** Operator intent expressed 2026-06-09 (initiative **lead-odqd**):
*"extend the shopsystem framework to handle ITERATIVE EXPERIMENTATION as a
first-class capability. Method: spike → learn limitations through real
experimentation → throw the spike away → implement via ADRs+scenarios."* The
scope clarification on the same bead (dave, 2026-06-09) fixes the boundary:
this initiative is **the experiment-discipline meta-capability only** —
agent-vault (lead-mdng) and fabro/substrate (lead-f6ta) were the *proving
cases*, not the deliverable.
**Synthesizes:** `findings/iterative-experimentation-capability.md`
(meta-deliverable **lead-gkhk**, the decision-bearing design synthesis this
PDR graduates).

## Point of intent

The shopsystem framework already *does* iterative experimentation — it did it
three times under lead-odqd (the agent-vault credential spike, the fabro
2PC-as-steps spike, the substrate comparison). What it does not do is **name
the shape as a first-class capability** with a disciplined lifecycle, a verdict
vocabulary, an isolation contract, and a graduation path. This PDR records the
intent to make that shape canonical — as **intent, not implementation** — so a
spike becomes a known, repeatable unit of work rather than an ad-hoc thing we
happened to do well.

A spike is: **a first-class, throwaway, time-boxed unit of work whose sole
durable outputs are a `findings/` document, a verdict, and (on confirm) a set
of implementation-requirements that feed a normal Phase-2 graduation.** The
spike's code and infra are *designed to be discarded* — isolated scratch
(`/tmp`, throwaway `spike-` containers, a throwaway worktree branch), never
committed to lead or BC source, torn down at verdict time.

## Empirical finding (the gap this closes)

Verified against the contract/artifact surface (ADR-018) — no BC code, no
`repos/` on this host:

- **No message-type vehicle models a throwaway experiment.** The §5.3 catalogue
  is `assign_scenarios` (commit new pinned behavior), `request_bugfix` (tighten
  pinned behavior), `request_maintenance` (flat kept change),
  `request_scenario_register` / `request_shop_card` (read-only queries). Every
  one assumes the work product is *kept*. None models "build something real,
  learn from it, throw it away, keep only the finding." That gap is the
  capability.
- **The graduation step already exists — in PDR-014.** PDR-014's findings-driven
  graduation path (finding → lead-po authors scenarios → lead-architect drafts
  the ADR + picks the discriminator vehicle → dispatch to the owning BC) is
  exactly the tail a confirmed spike needs. What is missing is the *stage before
  dispatch*: the throwaway experiment that *produces* the verified pre-state
  finding the ADR-018 discriminator consumes.
- **The three runs already exhibit the full shape.** A research-only eval
  (substrate comparison, lead-8mho), a confirm spike with a human wall
  (agent-vault, lead-jkwo), and a go-with-caveats spike with live throwaway
  infra (fabro, lead-f6ta). The job is to *name and systematize the shape we
  already used*, not to invent a new one.

## The capability to pin

1. **A spike is a first-class unit of work** with a defined six-stage lifecycle
   (intent → research → throwaway execution → verdict → graduate/discard →
   teardown) and a four-value verdict vocabulary (confirm / go-with-caveats /
   no-go / not-viable). (ADR-029.)
2. **A spike sits UPSTREAM of the ADR-018 discriminator.** The spike does not
   add a message-type vehicle; it produces the verified pre-state finding the
   discriminator consumes, then the *existing* vehicle is chosen for the kept
   Phase-2 work. (ADR-029.)
3. **A spike's artifacts are isolated and disposable.** `spike-`-prefixed
   containers on the real network with dummy data only; `/tmp` working dirs or a
   throwaway worktree branch for code; nothing committed to lead/BC source; only
   the `findings/` doc (+ ADR on graduation) survives teardown. (ADR-030.)
4. **An autonomous spike handles human-in-the-loop walls without faking them.**
   Detect the wall, substitute a placeholder, prove everything creds-free up to
   the wall, record the wall, and emit it as a Phase-2 operational step — a
   spike can still reach `confirm` with a recorded wall provided the plumbing is
   proven. (ADR-031.)
5. **A spike executes via Workflow and returns markdown findings**, not a large
   array-heavy StructuredOutput — a reliability requirement, not a style note.
   (ADR-032.)
6. **A confirmed spike graduates via the PDR-014 path**, against a fresh
   Phase-2 bead — the spike bead's `work_id` is never reused for the kept work.
   (ADR-029.)

## The mechanism decision (locked; do not re-open)

The open design question was: a new `request_spike` BC-dispatched vehicle, vs.
extending the PDR-014 graduation path (findings-driven, lead-internal), vs. a
hybrid. **Decision (locked in the synthesis, pinned by ADR-029): the
lead-internal, findings-driven graduation path, with a spike lifecycle made
explicit on top of it. No `request_spike` vehicle in Phase 2. The hybrid is
deferred with a named trigger.**

The load-bearing reason is the ADR-018 line: a BC-dispatched experiment would
have the BC build throwaway code and report a verdict, putting the lead back to
**trusting BC-reported experiment results** — precisely the empirical-
verification boundary ADR-018 draws. Lead-internal spikes keep the experiment
on the one surface the lead may construct evidence on (its own scratch host),
not BC source. ADR-029 records the full rationale and the deferral trigger.

## Scope discipline (do not over-commit)

- This PDR pins **the experiment discipline only**, per the lead-odqd scope
  clarification. agent-vault and fabro/substrate are separate tracks.
- It pins the lifecycle, verdict vocabulary, isolation contract, wall protocol,
  Workflow constraint, and graduation relation — **not** a `request_spike`
  vehicle (explicitly deferred) and **not** the resolution of the secondary
  open questions in the synthesis §(e) (spike-process scenario home, hybrid-
  trigger watch discipline, worktree-vs-`/tmp` convention, findings-doc post-
  graduation lifecycle, time-box enforcement, hard schema cap). Those are
  carried forward as named open questions for the ADRs and PO authoring to
  resolve or explicitly defer.

## What this leaves open (for the ADRs / PO authoring)

- **Where spike-process scenarios live and who owns them** (synthesis §(e).1):
  some pin *lead process* with no BC addressee; others pin *tooling* a BC may
  own. The discriminator picks per scenario; the lead-process scenarios may have
  no addressee — does the lead need a "lead process" features home, or do these
  stay doctrine in primers/ADRs? **PO authoring must place the 8 scenarios and
  flag any with no BC addressee.**
- **The hybrid `request_spike` trigger watch** (§(e).2): tracked as a P3 bead,
  not Phase-2 scope.
- **Worktree vs. `/tmp` for code spikes** (§(e).3), **findings-doc post-
  graduation lifecycle** (§(e).4), **time-box enforcement** (§(e).5), and a
  **hard Workflow schema cap** (§(e).6): the ADRs pin what is decided and name
  the rest as deferred.

## Cross-references

- `findings/iterative-experimentation-capability.md` — the design synthesis
  (lead-gkhk) this PDR graduates; §(a)–(d) are the source material.
- [PDR-014](014-lead-skill-group-pour-and-graduation-path.md) — the findings-
  driven graduation path this capability extends from "skill" to "finding."
- [PDR-012](012-lead-po-product-manager-scope-and-architect-structurizr-maintenance.md)
  — experimental-first adoption doctrine the spike lifecycle generalizes.
- [ADR-018](../adr/018-empirical-verification-is-contract-surface.md) — the
  empirical-verification line the no-`request_spike` decision protects.
- [ADR-029](../adr/029-spike-vehicle-extend-pdr014-graduation-no-request-spike.md),
  [ADR-030](../adr/030-spike-isolation-contract-scratch-dummy-teardown-to-findings.md),
  [ADR-031](../adr/031-human-in-the-loop-wall-protocol-for-autonomous-spikes.md),
  [ADR-032](../adr/032-spikes-execute-via-workflow-return-markdown-findings.md)
  — the four decisions this PDR's intent is pinned by.
- Initiative **lead-odqd**; meta-deliverable **lead-gkhk**; Phase-2 authoring
  bead **lead-95q5**.
- The 8 Gherkin scenarios (synthesis §(d) outlines) are **lead-po's Phase-2
  job**; see ADR-029 §"What this leaves open" for placement guidance.
