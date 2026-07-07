---
id: PDR-018
kind: pdr
title: The dummy-product instantiation spike is the MVP acceptance gate
status: draft
date: "2026-06-12"
description: The dummy-product instantiation spike is the MVP acceptance gate
beads: [lead-jdfb, lead-po, lead-wm2r]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: []
  pins: []
  related: []
---
# PDR-018 — The dummy-product instantiation spike is the MVP acceptance gate

**Status:** draft (2026-06-12)
**Authors:** dstengle, Claude (lead-po)
**Anchored to:** `findings/independent-mvp-review-2026-06.md` rec #1 — *"Make
'instantiate a second product' the MVP acceptance test."* Scopes bead
**lead-jdfb** (WS-0), the spine of epic **lead-wm2r** (Framework genericity —
path to a second product).
**Synthesizes:** the independent MVP review (2026-06-11) and its work plan
(`findings/independent-mvp-review-2026-06-WORKPLAN.md`, WS-0..WS-9).
**Is a spike PDR** under the PDR-016 / ADR-029 lineage: it scopes a learning-
oriented, throwaway run whose durable output is a verdict and a set of beads,
not a kept build.

## Point of intent

The review's one-line verdict is that the shopsystem is **a working *instance*,
not yet a working *framework*** — every reviewed subsystem carries at least one
hard-coded `shopsystem`/`dstengle` assumption, and no document walks an adopter
from empty `briefs/adr/pdr/features` to a working lead shop. That verdict is a
*hypothesis* until it is run. The self-hosting loop structurally cannot produce
genericity findings on its own (review finding 10): the one instance never
exercises the framework's genericity, so a genericity defect never emits a
`mechanism_observation`.

This PDR pins the intent to **convert that verdict into a checked state** by
standing up a trivial second product — **a trivial app with a real feature
implemented in a single BC, runnable self-contained in a docker container**
(user refinement, 2026-06-12) — and letting every wall it hits become a bead and
a fix, validated by re-running. The run *is* the MVP acceptance test:
nothing in epic lead-wm2r is "done" until the spike runs clean. The spike is
the spine — WS-1 (identity constants) and WS-2 (bootstrap path) are
**discovered and proven by it**, not planned in the abstract.

## Empirical finding (the gap this closes)

Verified against the contract/artifact surface (ADR-018) — no BC code, no
`repos/` reading:

- **"MVP" is currently a judgment, not a checked state** (review finding 10).
  No artifact defines what the MVP gate requires, in a system whose ethos is
  empirical verification. This spike supplies the missing check.
- **The genericity defects are distributed, not deep** (review finding 2). Five
  layers across four repos each bake a product identity:
  `SYSTEM_SLUG = "shopsystem"` (silent cross-product routing failure),
  `BC_IMAGE` with no override surface, the manifest `product:` field
  (implemented, undocumented, unused), and the `bring-up-bc` skill's
  `/home/dstengle` / author-scoped image / `shopsystem` db name. Each is a
  small diff; the finding is their *distribution*. A spike walks the
  distribution in execution order and beads each wall as it is hit.
- **No end-to-end new-product bootstrap path exists** (review finding 3). The
  prime-the-pump steps (`docker network create`, hand-clone bc-launcher before
  `manifest sync`) live only inside a skill or are absent entirely. A spike
  starting from EMPTY is the only thing that exercises the path as an adopter
  would.

## What "runs clean end-to-end" means — the acceptance gate

This is the bar the architect later verifies (WS-0's named division of labor:
**lead-po scopes the gate here; the architect verifies it**). The gate is an
**observable, re-runnable check**, satisfied only when ALL hold.

Per the user refinement (2026-06-12): **"the framework running" means a trivial
app with a real feature implemented in a single BC, runnable self-contained in a
docker container.** Two things follow, and both are load-bearing:

- The single BC must **implement a genuine (trivial) feature** — the assigned
  scenario is a real behavior the BC builds and passes through its
  implementer→reviewer→`work_done` loop, **not** a no-op, echo, or
  plumbing-only round-trip. The §6.4-assigned scenario (conditions 5–7) **is**
  that one feature; the `work_done` must correspond to a working feature.
- The resulting dummy app must be **runnable self-contained in a docker
  container** — the single BC (plus whatever minimal substrate it needs) comes
  up and serves its one feature in a container, observably, on a docker network
  and host ports distinct from the live fleet (the user constraint already
  recorded on bead **lead-l7uz** / WS-2).

So the bar is the **§6.4 reconciliation cycle running generically over a real
implemented feature in a self-contained containerized app** — not merely
transport: the dummy product must survive a real
`assign_scenarios → work_done(scenario_hashes) → reconcile` loop under its own
slug (conditions 5–7), where that loop pins an actually-implemented feature
(condition 9) running self-contained in docker (condition 10), not just a single
typed message round-trip (condition 4):

1. **Empty start, proven empty.** The dummy product begins with empty
   `briefs/`, `adr/`, `pdr/`, `features/` for the new system slug — no carried-
   over shopsystem product content. The *only* inheritance is skills + templates
   + installed tools. (If the run silently reuses a shopsystem artifact, the gate
   fails: the inheritance boundary is part of what is under test.)

   *Gate-condition-1 interpretation note (lead-ii9q, 2026-06-12 spike iter-2):*
   "empty" here means **no carried-over content** — the gate is satisfied
   whether the dirs are *absent entirely* or *present-and-empty*. The v0.5.0
   bootstrap renders `briefs/ adr/ pdr/ features/` as ABSENT (`ls: No such
   file or directory`), which SATISFIES this condition. Read the check as
   "zero inherited shopsystem artifacts," not "scaffolded dirs exist and are
   empty." (If placeholder dirs + `.gitkeep` are later wanted as an author
   ergonomic, that is a separate shopsystem-templates request, not a gate
   failure.)

2. **A distinct identity, end to end.** A system slug that is **not**
   `shopsystem` and an org that is **not** `dstengle`, carried through every
   layer the review named: messaging address projection, the BC image
   reference, and the manifest `product:` field. The discriminating check:
   a message sent to the dummy product's one BC must deposit to an address that
   BC actually reads — i.e. the ADR-020 abstract address must project under the
   dummy slug, not `shopsystem/<name>` (review finding 2, the silent-routing
   defeat).

3. **Exactly ONE BC, stood up by the documented path only.** The BC is
   instantiated using only skills + templates + tools — **no hand-editing of
   inbox/outbox/manifest YAML, no `shopsystem`/`dstengle` hard-codes patched in
   by hand.** Every prerequisite the path needs (network create, prime-the-pump
   clone, bootstrap) is either already documented or becomes a bead.

4. **One typed round-trip succeeds.** The lead shop dispatches one unit of work
   to the one BC via `shop-msg send`, the BC responds, and the lead consumes the
   response from its inbox — a typed message round-trip executed under the dummy
   slug. This proves transport carries a product generically; conditions 5–7
   then prove the §6.4 reconciliation *spine* does too.

5. **A scenario assignment is dispatched under the dummy slug.** The lead shop
   dispatches **`assign_scenarios`** to the one dummy BC via `shop-msg send`,
   addressed under the dummy slug (not `shopsystem/<name>`). This carries at
   least one PO-authored scenario with its `scenarios[].hash`, projected through
   the same ADR-020 abstract address the typed round-trip (#4) exercised.

6. **The BC emits `work_done` carrying `scenario_hashes`.** The dummy BC
   completes the assignment and responds with a **`work_done`** whose
   `scenario_hashes` field names the scenario(s) it pinned — the §6.4 evidence
   the lead reconciles against. The lead consumes this from its inbox under the
   dummy slug. The `work_done` must correspond to a **genuinely implemented
   trivial feature** (see condition 9), not a no-op acknowledgement.

7. **The lead reconciles the scenario register and matches the hashes.** The
   lead confirms the dummy product's scenario register lands and that the
   `work_done` `scenario_hashes` **match** the assigned scenarios — the §6.4
   reconciliation cycle, executed generically. Hash equality here exercises the
   scenario-hash canonicalization surface (block-only `@scenario_hash` / on-disk
   register vs the wire form), so a clean match under the dummy slug is the
   discriminating proof that reconciliation — not just transport — carries a
   product. (See the WS-1 dependency surface for the **lead-ji28** adjacency.)

8. **Every wall is a bead with a fix, and the fix is validated by re-running.**
   A clean run is not "first try succeeds"; it is "the *final* re-run, after all
   beaded fixes land, completes 1–10 with no hand-edits and no remaining wall."
   The trail of beads + fixes + the final clean re-run *is* the deliverable.

9. **The single BC implements a real (trivial) feature.** The scenario assigned
   in #5 names an actual behavior — the BC builds it through its
   **implementer→reviewer→`work_done`** loop and the feature *works*. The check
   is observable: the implemented feature is exercisable (its `Then` is
   demonstrably satisfied by the running BC), not stubbed, echoed, or
   acknowledged-only. The feature is deliberately the **smallest genuine
   behavior** that still counts as a feature (see scope discipline for the
   default bar); triviality is a scope choice, not a license to fake it.

10. **The dummy app runs self-contained in a docker container.** The dummy
    product's single BC — plus only the minimal substrate it needs — **comes up
    and serves its one implemented feature inside a container**, observably,
    from the empty-start documented path. It runs on a **docker network and host
    ports distinct from the live shopsystem fleet** (the recorded user
    constraint, bead **lead-l7uz** / WS-2), so it is self-contained and
    non-colliding. "Self-contained" means the container(s) the documented path
    stands up are sufficient to demonstrate the feature without reaching into
    the live fleet.

The gate is **re-runnable**: the architect verifies it by re-executing the
documented path from empty, not by trusting a one-time narration. A passing
gate is the empirical definition of "MVP" for epic lead-wm2r.

**What "runs clean" means (made explicit, per the 2026-06-12 refinement):** a
clean pass is the **trivial app — with its one genuinely implemented feature —
coming up self-contained in docker (conditions 9–10) AND the §6.4 reconciliation
cycle closing for that feature's scenario (conditions 5–7)**, all reached from an
empty start via the documented path with **no hand-edits** (conditions 1–3, 8).
Transport-only (condition 4) or a no-op `work_done` does **not** clear the bar.

## Division of labor (as the bead names it)

- **lead-po (this doc):** scopes the spike — frames the problem, defines the
  acceptance gate above, fixes the in/out-of-scope boundary, and names the
  WS-1/WS-2 dependency surface the run is expected to exercise. lead-po does
  **not** author Gherkin here; a spike PDR is the right altitude, and the
  genericity-fix scenarios follow under WS-1/WS-2.
- **lead-architect:** verifies the gate, including **running the
  `assign_scenarios → work_done(scenario_hashes) → reconcile` loop** (gate
  conditions 5–7) under the dummy slug and confirming hash equality — the §6.4
  reconciliation leg is the architect's to dispatch, verify empirically, and
  reconcile — **and confirming that the loop pinned a genuinely implemented
  trivial feature (condition 9) running self-contained in a docker container on
  a distinct network/ports (condition 10)**, not a no-op round-trip. Selects how the spike executes against the contract/artifact
  surface (ADR-018), runs the spike under the PDR-016 / ADR-029..032 spike
  contract (throwaway, isolated scratch, markdown findings, human-wall
  protocol), reaches a verdict, and drives the wall→bead→fix→re-run loop. On a `confirm` verdict, the kept fixes graduate via the PDR-014 path
  against fresh WS-1/WS-2 beads — the spike bead's `work_id` is never reused for
  kept work (ADR-029).

This is a **spike, not a polished build**: learning-oriented, time-boxed,
wall→bead→fix→re-run. Its durable outputs are the verdict, the bead trail, and
the final clean re-run — not a maintained second product.

## Scope discipline (do not over-commit)

**In scope:** exactly ONE BC; a *trivial* dummy product (the smallest thing
that exercises identity projection, one typed round-trip, one full
`assign_scenarios → work_done(scenario_hashes) → reconcile` cycle pinning **one
genuinely implemented trivial feature**, and that feature **running
self-contained in a docker container** distinct from the live fleet); a distinct
system slug and org; an empty-start instantiation via skills + templates +
tools. The PO authors the *minimal* single scenario the assign_scenarios leg
needs — and it must name a **real behavior the BC can build and pass**, not a
plumbing echo — so the gate has a genuine feature to hash, run, and reconcile.
That minimal seed is not the genericity-fix Gherkin, which stays a WS-1/WS-2
deliverable. The feature stays deliberately trivial: the default bar is **one
observable behavior with one `Then` the running BC demonstrably satisfies**
(e.g. a single request the BC answers correctly), which the architect may
realize as whatever smallest genuine behavior the dummy BC's substrate makes
cheapest.

**Explicitly out of scope:**

- **Not a real second product build.** No domain modelling, no multi-BC
  decomposition, no maintained briefs/ADRs/PDRs/features for the dummy product
  beyond what the one round-trip needs. The dummy product is a *probe*, torn
  down at teardown per the ADR-030 isolation contract.
- **Not the genericity fixes themselves.** WS-1 (externalize `SYSTEM_SLUG`,
  `BC_IMAGE`, manifest `product:`; re-template `bring-up-bc`) and WS-2 (Brief
  007 checklist, INSTALL.md rewrite, Brief 008 Slice 1 proof, prerequisite docs)
  are *driven and validated* by this spike but **owned and authored elsewhere**
  — WS-1 by the architect (vehicles + ADR-005 successor), WS-2 by lead-po
  (brief + scenarios). This PDR commits only to the spike that surfaces and
  re-validates them.
- **Not the parallel work-streams.** WS-3 (§5.3/§6.4 spec honesty), WS-4
  (primer pour-back), WS-5..WS-9 are independent of the spike and out of WS-0's
  scope.
- **Not a Gherkin authoring task.** Scenarios for the genericity fixes are a
  WS-1/WS-2 deliverable, not part of this spike PDR.

## WS-1 / WS-2 dependency surface (expected walls)

The spike is **expected** to hit these, each becoming a bead routed to its
owning surface. Naming them here is forecast, not pre-solution — the spike's
job is to confirm or refute each empirically:

- **WS-1.1 — `SYSTEM_SLUG`** (`storage.py:222`, `_abstract_address_for()`):
  the gate's discriminating check (#2/#4/#5) is built to hit this first — the
  `assign_scenarios` dispatch (#5) and its `work_done` return (#6) must both
  project under the dummy slug. → owner shopsystem-messaging, `request_bugfix`.
- **WS-1.5 — scenario-hash canonicalization** (the gate's #7 reconciliation
  leg): matching `work_done` `scenario_hashes` against the assigned scenarios
  under the dummy slug exercises the two-hash-unit surface — block-only
  (`@scenario_hash` tag / on-disk register / `scenarios hash` CLI, e.g.
  `641bae…`) vs the Feature-line-included wire form `shop-msg send` writes onto
  `scenarios[].hash` (e.g. `07d405…`). The open bug **lead-ji28** (umbrella
  **lead-wgv**; pinned by ADR-036 D3 to block-only) is the adjacency: if it
  bites under the dummy slug it becomes a wall on this spike, beaded against
  lead-ji28 rather than re-discovered. The spike confirms or refutes that the
  divergence blocks generic reconciliation, not just the shopsystem instance.
  → owner shopsystem-messaging (mechanical, lead-ji28) / architect (procedural).
- **WS-1.2 — `BC_IMAGE` override** (bc-launcher `controller.py:32`): the one BC
  cannot run on the author-scoped image without an override surface. → owner
  shopsystem-bc-launcher, `request_bugfix`.
- **WS-1.3 — manifest `product:` field** (implemented, undocumented, unused;
  ADR-005 never defines it): the spike either populates it and proves it routes,
  or proves the fallback to hard-coded `"shopsystem"` defeats the dummy slug.
  → owner shopsystem-bc-launcher + ADR-005 successor (architect).
- **WS-1.4 — `bring-up-bc` re-template** (`/home/dstengle`, author image,
  `shopsystem` db name): the empty-start path uses this skill, so its hard-codes
  surface as walls. → owner shopsystem-templates, `request_bugfix`.
- **WS-2 — bootstrap prerequisites:** `docker network create <slug>` (compose
  net is `external: true`), prime-the-pump bc-launcher clone before
  `manifest sync`, and the absence of a keep/empty/run checklist (Brief 007).
  Each missing step is a wall. → owner lead-po (brief + scenarios) on
  graduation.

## Cross-references

- `findings/independent-mvp-review-2026-06.md` — rec #1 (the gate), findings
  2, 3, 10 (the genericity gap, the bootstrap gap, the unchecked MVP).
- `findings/independent-mvp-review-2026-06-WORKPLAN.md` — WS-0 (this spike) as
  the spine; WS-1/WS-2 as discovered-and-proven; the "WS-0 scope" judgment item.
- [PDR-016](016-iterative-experimentation-first-class-lead-capability.md) — the
  spike lifecycle, verdict vocabulary, and isolation contract this run executes
  under.
- [ADR-029](../adr/029-spike-vehicle-extend-pdr014-graduation-no-request-spike.md),
  [ADR-030](../adr/030-spike-isolation-contract-scratch-dummy-teardown-to-findings.md),
  [ADR-031](../adr/031-human-in-the-loop-wall-protocol-for-autonomous-spikes.md),
  [ADR-032](../adr/032-spikes-execute-via-workflow-return-markdown-findings.md)
  — the spike contract (throwaway scratch, human-wall protocol, markdown
  findings) the run is bound by.
- [PDR-011](011-empirical-verification-is-contract-surface.md) /
  [ADR-018](../adr/018-empirical-verification-is-contract-surface.md) — the gate
  is verified against the contract/artifact surface; the architect reconciles,
  the BC demonstrates.
- [PDR-014](014-lead-skill-group-pour-and-graduation-path.md) — the graduation
  path a `confirm` verdict's fixes feed into (against fresh WS-1/WS-2 beads).
- Bead **lead-jdfb** (WS-0, this spike); epic **lead-wm2r**.
