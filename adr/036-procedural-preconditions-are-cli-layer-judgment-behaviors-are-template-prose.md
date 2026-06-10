# ADR-036 — Procedural preconditions that can be mechanically checked are CLI-layer (a `shop-templates` emit wrapper enforces them and refuses the emit on failure); judgment behaviors that require natural-language interpretation stay template-prose-layer — and the wrapper's `scenario_hashes-match` check uses scenario-block-only canonicalization

**Status:** accepted (2026-06-10)
**Tier:** system-global (per [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md) / [ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md) — this is a cross-BC structural decision about *where* a class of contract enforcement lives, per this product; not framework doctrine, not one BC's internals.)
**Authors:** dstengle, Claude (lead-architect)
**Pins:** the layering principle recorded on `lead-o6tp` (dave, 2026-05-29, as revised) — *procedural preconditions that can be mechanically checked belong in a CLI-layer emit path that enforces them and refuses the emit on failure; judgment behaviors that require natural-language interpretation stay in the template-prose layer* — folded together with the canonicalization-unit precision of `lead-ji28` / `lead-wgv`: the wrapper's `scenario_hashes-match` precondition MUST use **scenario-block-only** canonicalization ([ADR-019](019-canonicalization-ownership-in-scenarios-bc.md) / [scenario 117](../features/templates/117-canonical-scenario-hash-canonicalization-is-scenario-block-only-not-feature-line-included.gherkin)), not the Feature-line-included wire form.
**Anchored to:** [ADR-019](019-canonicalization-ownership-in-scenarios-bc.md) (scenario-block-only is the one canonical hash text; `scenarios` owns the rule and messaging/templates *delegate* to it); [ADR-018](018-empirical-verification-is-contract-surface.md) (the artifact-surface evidence rule this ADR's pre-state honors, and the no-clone doctrine the wrapper's git checks must respect — they run inside the BC container against the BC's own tree, never lead-side); [ADR-010](010-clarify-resolution-work-done-scope.md) (the `work_done.scenario_hashes` strict-subset rule the `scenario_hashes-match` precondition mechanizes); [ADR-015](015-nudge-message-type.md) (the `--force` / forced-recovery escape valve posture).
**Anchored on (PDR):** [PDR-001](../pdr/001-role-templates-role-complete.md) (role templates must be role-*complete*: this ADR draws the line between what the template must *say* — judgment posture — and what it may *stop saying* because the CLI now enforces it — mechanical preconditions); [PDR-010](../pdr/010-bd-authoritative-shop-msg-transport.md) (the layering instinct: `shop-msg`'s domain is the messaging protocol; orthogonal policy enforcement does not belong coupled into it — the same wrong-layer mistake this ADR's revision avoids).
**Related beads:** `lead-o6tp` (the layering-principle ADR-candidate this ADR ratifies), `lead-ji28` (the canonicalization-unit precision folded in), `lead-wgv` (umbrella canonicalization-ambiguity, closed at the contract level by 117), `lead-cw7` / `lead-8lm` (the clean-tree + commit-on-origin-main scenarios 105-112 this ADR routes to retro-retirement), `lead-83l` (the `scenario_hashes`-pre-emit scenarios 113-116, retirement decision recorded here), `lead-yxsr` (BC-reliability flakiness gating tonight's dispatch).

---

## Context

The framework has been pinning **procedural consistency checks** as *prose in
canonical role templates* (`bc-reviewer.md`, `bc-implementer.md`, `bc-primer.md`):
before a BC emits `work_done`, its working tree must be clean, the work_id's
change must be committed to `origin/main`, and the payload's `scenario_hashes`
must match the committed `features/`. The "check" only happens if the agent
reads and follows the prose. This is **fragile** — `lead-cw7` documents three
distinct occurrences (and ultimately five, across four different BCs) where
agents emitted `work_done` with a dirty tree or uncommitted work *despite* the
prose, each costing a reconciliation round-trip and a blocker bead — and it is
**verbose**: 4 scenarios × 2 roles × N preconditions, re-poured into every BC
template adoption.

`lead-o6tp` proposes the counter-design: enforce the mechanically-checkable
preconditions in a **CLI layer** so that *running the emit command IS the check*,
and the emit is *refused* on failure. The role-template prose for those checks
collapses to a one-line pointer ("the wrapper enforces these; if your emit is
refused, fix the underlying state and retry"). Judgment behaviors that *cannot*
be mechanically checked stay prose, because they require natural-language
interpretation an exit code cannot render.

Two refinements from the bead history are load-bearing and folded in here:

1. **Layer correction (`lead-o6tp` revision, dave 2026-05-29).** The enforcement
   must NOT live in `shop-msg respond` itself. `shop-msg`'s domain is the
   messaging protocol (postgres deposit / read / consume / watch); git status /
   commit-reachability / hash-recompute is **orthogonal policy enforcement**.
   Coupling `shop-msg` to git is the same wrong-layer mistake the `lead-767`
   round-3 conversation rejected (and the instinct PDR-010 encodes). The
   enforcement home is the **role-template-package layer** (`shopsystem-templates` /
   the `shop-templates` distribution): a wrapper emit command that runs the
   preflight and then invokes the pure `shop-msg respond` primitive. `shop-msg
   respond` stays a pure messaging primitive, available bare for forced recovery.

2. **Canonicalization-unit precision (`lead-ji28` / `lead-wgv`).** The
   `scenario_hashes-match` precondition recomputes hashes — and there are **two
   different hash units in the wild**. Naming them precisely (below) and pinning
   the right one is what makes the check correct rather than a 10th instance of
   the divergence it is meant to close.

This is a structural / convention decision with no product-UX surface change —
hence an **ADR**, not a PDR.

### The two hash units, named precisely (from `lead-ji28` / `lead-wgv` / ADR-019)

There are exactly two hash representations that have collided across 9+ tallied
reconciliations:

- **Scenario-block-only** — the canonical hash text is the scenario block alone
  (tag-stripped `Scenario`/`Scenario Outline` + steps + `Examples`), with no
  `Feature:` header line. This is what the `scenarios hash` contract tool
  computes, what the on-disk `@scenario_hash:<hex>` tag carries, and what
  preserved feature-file hashes reproduce. ADR-019 D1 and scenario 117 pin this
  as the *one* canonical hash text per scenario block. Example from the
  `lead-2ca` observation: `641bae76c069bf5b`.

- **Feature-line-included** — the hash computed over a string whose first line
  is the `Feature:` header (the wrap `shop-msg send`'s `--scenario-file` builder
  currently prepends before hashing, surviving canonicalization because the rule
  strips only blank and `@scenario_hash:` lines). This is the value currently
  written onto the wire `scenarios[].hash`. Example from the same observation:
  `07d405ae455c5553`.

These diverge for identical scenario semantic content. The
`scenario_hashes-match` precondition the wrapper enforces MUST use
**scenario-block-only** — the unit the `@scenario_hash` tag and `scenarios hash`
already use — so the wrapper's recompute agrees with the on-disk tags it
checks against and with lead-side reconciliation. Using the Feature-line-included
wire unit would bake the very divergence (ADR-019's defect (a)) into the gate.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

Verified from the lead CWD (`/workspaces/shopsystem-product`) on 2026-06-10
against this repo's `features/templates/`, `adr/`/`pdr/`, the `bd` registry, and
the `shop-templates show` / `scenarios hash` contract tools. No BC source read,
run, or git-observed (ADR-018 D1).

1. **The mechanically-checkable preconditions are pinned today as
   template-prose-content assertions. CONFIRMED.** Scenarios
   `105`–`112` (clean-tree + work_id-commit-on-origin-main, Reviewer and
   Implementer arms) and `113`–`116` (scenario_hashes recompute / stale / missing /
   orphan) live in `features/templates/`. Read of scenario 105 confirms the shape:
   *"When I read the bc-reviewer template via `shop-templates show bc-reviewer` /
   Then the content names `git status --porcelain` as a pre-emit verification step
   the reviewer must run …"*. These pin what the template **prose must say**, i.e.
   they pin a *prose-layer* obligation, not a CLI behavior — exactly the fragility
   `lead-o6tp` targets.

2. **The canonical unit is already pinned scenario-block-only. CONFIRMED.**
   Scenario 117 (`features/templates/117-…`) pins *"exactly one canonical hash
   text per scenario block, … the `Feature:` header line is NOT part of it"*, and
   ADR-019 D1/D2 assign ownership of that rule to `shopsystem-scenarios`
   (`scenarios.hash.compute_scenario_hash`) with messaging/templates delegating
   in-process. The wrapper's hash check therefore has a ready, single delegate;
   it must not re-enact canonicalization.

3. **The two units diverge for identical content. CONFIRMED at the artifact
   level** via the `lead-ji28` recorded observation (same shape ADR-019's own
   pre-state reproduced over contract text: `16afa7a01a0cd120` block-only vs
   `a9fd70077400931a` Feature-wrapped). The `scenarios hash` tool is the
   admissible contract-fact producer (ADR-018 D2). This is the systematic
   divergence behind the 9-occurrence reconciliation-blocked tally
   (`lead-xscs … lead-8hxz`).

4. **The judgment behaviors named to stay prose have no mechanical check.
   CONFIRMED** (read of the lead-primer / `lead-dl6` referenced behaviors):
   continuous-action / end-of-turn continuation, the idle-detection checklist,
   choice-suppression, and inbound-message sufficiency checks all require
   natural-language interpretation of intent/state — there is no exit code that
   renders "did you correctly judge this clarify as scope-vs-architecture". They
   are not CLI-expressible and must stay template prose.

5. **`lead-83l` already LANDED at templates `origin/main`. CONFIRMED**
   (`bd show lead-83l`: CLOSED, close-reason cites commit `9e7138c`
   `feat(lead-83l): pin bc-reviewer pre-emit scenario_hash integrity (ADR-010)`,
   all 4 hashes verified on-disk under
   `features/bc_reviewer_pre_emit_scenario_hash_integrity.feature`). The open
   question framed as "cancel vs land-then-retire" is therefore **already
   collapsed by history on the cancel side**: it cannot be cancelled — it has
   shipped. The live decision is only whether to **retro-retire** it (and how),
   alongside 105-112. `lead-cw7` (105-108) and `lead-8lm` (109-112) likewise
   CLOSED and landed (commits `3f74c52`, `850ed99`).

6. **@scenario_hash retirement enumeration over lead-held `features/`.**
   The conflicting BC-side coverage this ADR's *eventual* dispatch will retire is
   the prose-content pins 105-116 in `features/templates/`. This ADR authors no
   Gherkin and dispatches nothing tonight, so it retires no hash here; the
   enumeration is recorded as a *next-step obligation* for the future
   messaging/templates dispatch (Consequences), to be re-run at dispatch time per
   the Architect-template @scenario_hash discipline.

---

## Decision

### D1 — The layering principle: mechanically-checkable procedural preconditions are CLI-layer; judgment behaviors are template-prose-layer

A pre-emit obligation belongs in the **CLI layer** (enforced by an emit wrapper
that refuses the emit on failure) if and only if it is **mechanically
checkable** — its satisfaction is decidable by a program from the artifact
surface, yielding a deterministic pass/fail with a named-cause error. Otherwise
it is a **judgment behavior** and stays in the **template-prose layer**, because
it requires natural-language interpretation of intent or state that an exit code
cannot render.

The discriminator on any pre-emit obligation: *can a program decide pass/fail
from the tree/payload/contract surface alone, or does it require an agent to
interpret meaning?* The first is CLI-layer; the second is prose-layer.

**Move to the CLI layer (mechanically checkable):**

- **clean-working-tree** — `git status --porcelain` is empty (modulo the
  established ambient-artifact carve-outs, e.g. `.specstory`,
  `.claude/scheduled_tasks.lock`, per the `lead-8lm` precedent). Scenarios
  105-107, 109-111.
- **work_id-commit-on-origin-main** — the dispatched work_id's change is present
  on the BC's `origin/main`. Scenarios 108, 112.
- **scenario_hashes-match** — each hash in `work_done.scenario_hashes` recomputes
  equal to the on-disk `@scenario_hash:` tag for its committed scenario block,
  with no stale / missing / orphan members (ADR-010 strict-subset). Scenarios
  113-116. **Uses scenario-block-only canonicalization** — see D3.

**Stay in the template-prose layer (judgment, not mechanically checkable):**

- continuous-action / end-of-turn continuation (`lead-dl6`);
- the idle-detection checklist (`lead-dl6`);
- choice-suppression (`lead-dl6`);
- sufficiency checks on inbound messages (natural-language interpretation).

### D2 — The CLI-layer home is the `shop-templates` package as an emit *wrapper*, NOT `shop-msg respond`

The enforcement lives in the **role-template-package layer** (`shopsystem-templates`,
the `shop-templates` distribution), realized as a **wrapper emit command** — the
`lead-o6tp` (a) shape: e.g. `bc-emit work-done --scenario-hash <h> --summary "…"`
that (1) runs the preflight (clean-tree, commit-on-origin-main, scenario_hashes
recompute), (2) if all green, invokes the bare `shop-msg respond work_done` with
validated args, (3) if any check fails, exits non-zero with a **named-cause**
error (which file is dirty; which work_id has no reachable `origin/main` commit;
which hash is stale / missing / orphan).

The wrapper (a) is chosen over a standalone preflight (b) because it is
**atomic**: running the wrapper *is* the emit, so the agent cannot accidentally
skip the check — the failure mode prose-pinning had. `shop-msg respond` remains a
**pure messaging primitive** in both shapes; it is NOT coupled to git or hashing
(PDR-010's layer instinct; the `lead-767` round-3 rejection). The bare
`shop-msg respond … --force` path stays available for forced recovery (ADR-015
escape-valve posture).

The git checks the wrapper runs execute **inside the BC container, against the
BC's own tree** — they are BC-side, never lead-side. This does not violate
ADR-018: ADR-018 forbids the *lead* from reading/running BC code; the wrapper is
BC-owned tooling running in the BC's own environment as part of the BC's gated
loop. The lead still only ever sees emissions.

### D3 — The `scenario_hashes-match` precondition uses scenario-block-only canonicalization, delegated to `scenarios`

The wrapper's hash recompute MUST compute the **scenario-block-only** canonical
hash (the unit the `@scenario_hash:` tag and `scenarios hash` use; ADR-019 D1,
scenario 117), **never** the Feature-line-included wire form currently written
onto `scenarios[].hash`. It MUST obtain that hash by **delegating** to
`scenarios.hash.compute_scenario_hash` in-process (ADR-019 D2), not by
re-enacting canonicalization and not by shelling out to a PATH-resolved binary.

This makes the gate agree with the on-disk tags it checks against and with
lead-side reconciliation. It also means the wrapper's correctness is *downstream
of* the ADR-019 messaging fix: the wire `scenarios[].hash` divergence (ADR-019
defect (a)) is the bug; this wrapper, computing block-only, is on the correct
side of that fix and corroborates it.

### D4 — Open-question resolution: `lead-83l` is LAND-THEN-RETIRE, not cancel (cancel is moot)

Per finding 5, `lead-83l` **already landed** at templates `origin/main`
(`9e7138c`, CLOSED) — so "cancel in favor of the messaging/templates CLI
scenarios" is **moot**: there is nothing to cancel. The decision is therefore
**land-then-retire**, and it is the correct one on its merits regardless of
timing:

- **Rationale.** The prose pins (105-116) were never *wrong* — they correctly
  describe the obligation; they are merely the *fragile* enforcement layer this
  ADR replaces. Landing them did real work (the templates BC verified them; BDD
  green) and the contract they describe stays live until the wrapper exists.
  Retiring them *before* the CLI enforcement landed would leave a window with
  **no** enforcement of either kind — strictly worse than the prose. So the
  sequence is: (i) author the wrapper scenarios pinning `bc-emit work-done`
  preconditions; (ii) land the wrapper in `shopsystem-templates`; (iii) only
  *then* retro-retire 105-116, replacing them with one-line pointer prose. The
  `lead-83l` close-reason already anticipated this ("o6tp's retirement plan
  explicitly covers lead-83l; landing as authored does not block the o6tp
  shift"). This ADR ratifies that sequencing as the decision.

This sequencing — enforce-then-retire, never retire-then-gap — is the same
discipline ADR-019 used (fix messaging before relying on equality) and §4.4 uses
for the Gherkin corpus (the new pin lands before the old one is retired).

---

## Alternatives considered

**Option A — Put the enforcement in `shop-msg respond` itself (the original
`lead-o6tp` proposal).** Rejected (D2, `lead-o6tp` revision). It couples the
messaging protocol primitive to orthogonal git/hash policy — the wrong-layer
mistake PDR-010 and the `lead-767` round-3 conversation both reject. `shop-msg`
transports; it does not enforce repo policy.

**Option B — Keep everything as template prose (status quo).** Rejected (D1,
finding 1). The prose is exactly the fragile layer that produced 5 documented
emit-without-commit occurrences across 4 BCs (`lead-cw7`). A check that only runs
if the agent remembers to run it is not a check.

**Option C — Standalone preflight command (`bc-preflight work-done <id>`), emit
separately (`lead-o6tp` (b)).** Rejected as the primary shape (D2). It re-creates
the trust problem prose had — the agent must *remember* to run preflight before
the bare emit. The wrapper (a) makes the check atomic with the action.

**Option D — Move the judgment behaviors (continuous-action, idle-checklist,
choice-suppression, inbound sufficiency) to the CLI too, for uniformity.**
Rejected (D1, finding 4). They are not mechanically decidable — there is no exit
code for "did you correctly route this ambiguous clarify". Forcing them into a
CLI would either trivialize them (a no-op gate) or mis-encode judgment as a
brittle heuristic. They are prose because they *are* judgment.

**Option E — Cancel `lead-83l`.** Rejected / moot (D4, finding 5). It already
landed; there is nothing to cancel, and land-then-retire is the correct sequence
on its merits (no enforcement-gap window).

**Option F — Use the Feature-line-included wire unit for the
`scenario_hashes-match` check (it is "what `shop-msg send` writes today").**
Rejected (D3, findings 2-3). That bakes ADR-019's defect (a) into the gate; the
check would disagree with the on-disk `@scenario_hash:` tags and with lead-side
reconciliation. Block-only is the one canonical unit (117) and is what the gate
must use.

---

## Consequences

### The implied next-steps — a tracked plan, NOT dispatched tonight

Per the task constraint and `lead-yxsr` (BC agents idle-park after finishing
work; messaging/templates dispatch is unreliable until that lands), **no Gherkin
is authored and no dispatch is sent by this ADR.** The plan is recorded as
tracked next-steps and on the beads:

1. **Author the wrapper precondition scenarios** (PO) pinning
   `bc-emit work-done` behavior in the `shopsystem-templates` surface: clean-tree
   (with ambient-artifact carve-outs), commit-on-origin-main, and
   scenario_hashes-match **using scenario-block-only canonicalization delegated
   to `scenarios.hash.compute_scenario_hash`** (D3). Each scenario passes the
   `assign_scenarios` sufficiency check; the dispatch gets its own fresh lead
   bead as `work_id`.
2. **Dispatch to `shopsystem-templates`** (Architect) once that BC is verified
   live per `lead-yxsr` (not idle-parked). Message-type discriminator: the
   `bc-emit` wrapper is **new capability** in the `shop-templates` package
   surface (no command pins it today) → `assign_scenarios`. At dispatch time,
   **re-run the @scenario_hash enumeration** over lead-held `features/templates/`
   (the 105-116 set is the conflicting prior coverage that the retro-retirement
   step removes) and cite it in the dispatch description per the Architect
   @scenario_hash discipline.
3. **Retro-retire scenarios 105-116** (PO/Architect) in `features/templates/`
   *only after* step 2 lands — replacing them with one-line pointer prose
   ("the `bc-emit` wrapper enforces these preconditions; if your emit is refused,
   fix the underlying state and retry"). This is the land-then-retire sequence
   (D4); never retire before the wrapper enforces, to avoid an enforcement-gap
   window. Covers the `lead-cw7` (105-108), `lead-8lm` (109-112), and `lead-83l`
   (113-116) prose pins.

### Other consequences

- **D3 is downstream of the ADR-019 messaging fix.** The wrapper computing
  block-only is on the correct side of ADR-019 defect (a); the two reinforce one
  another. If the ADR-019 `request_bugfix` has not yet landed, the wrapper still
  computes correctly (it delegates to `scenarios`), and lead-side reconciliation
  equality is fully closed only once *both* land.
- **Template-prose-layer shrinks; role-completeness is preserved (PDR-001).**
  Removing 105-116 prose does not make the templates *less* role-complete — the
  obligation moves to a more reliable layer and the prose gains a pointer. The
  judgment behaviors (D1) are untouched.
- **No tier collapse.** This is a system-global decision (per-product, cross-BC:
  it governs where the messaging-adjacent emit-policy enforcement lives across
  the templates and scenarios BCs); it is not framework doctrine and not one BC's
  internals. Tag `system-global` per ADR-034 once the tag convention is
  backfilled.
- **`lead-o6tp` and `lead-ji28` stay OPEN.** This ADR ratifies the *decision*;
  the *code fixes it implies* (the `bc-emit` wrapper in `shopsystem-templates`;
  and the ADR-019 messaging canonicalization fix `lead-ji28` tracks) remain
  BC-bound work. The beads carry a note recording this ADR + the deferred-dispatch
  plan and are NOT closed.
- **A follow-up bead** tracks the messaging/templates dispatch of the wrapper
  scenarios (filed alongside this ADR), dependent on `lead-yxsr` BC-reliability.

## Cross-references

- [ADR-019](019-canonicalization-ownership-in-scenarios-bc.md) — scenario-block-only
  is the one canonical hash text; `scenarios` owns the rule (D3 delegates to it).
- [scenario 117](../features/templates/117-canonical-scenario-hash-canonicalization-is-scenario-block-only-not-feature-line-included.gherkin)
  — pins the block-only canonical unit the `scenario_hashes-match` check uses.
- [ADR-018](018-empirical-verification-is-contract-surface.md) — artifact-surface
  evidence rule (pre-state) and the no-clone doctrine the wrapper's BC-side git
  checks respect (BC-owned tooling in the BC's own tree, never lead-side).
- [ADR-010](010-clarify-resolution-work-done-scope.md) — `work_done.scenario_hashes`
  strict-subset rule the `scenario_hashes-match` precondition mechanizes.
- [ADR-015](015-nudge-message-type.md) — forced-recovery / `--force` escape valve
  that keeps bare `shop-msg respond` available.
- [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md) /
  [ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md)
  — the tier model this ADR is filed under (system-global).
- [PDR-001](../pdr/001-role-templates-role-complete.md) — role-completeness
  (the prose-vs-CLI line this ADR draws).
- [PDR-010](../pdr/010-bd-authoritative-shop-msg-transport.md) — `shop-msg` is
  transport, not policy enforcement (the layer instinct behind D2).
- [lead-o6tp](beads:lead-o6tp) — the layering-principle ADR-candidate ratified
  here (and its revision that moved the home off `shop-msg`).
- [lead-ji28](beads:lead-ji28) / [lead-wgv](beads:lead-wgv) — the two-hash-unit
  precision (D3); umbrella closed at the contract level by 117.
- [lead-cw7](beads:lead-cw7) / [lead-8lm](beads:lead-8lm) / [lead-83l](beads:lead-83l)
  — the prose pins (105-116) routed to retro-retirement (D4 / Consequences).
- [lead-yxsr](beads:lead-yxsr) — the BC-reliability flakiness gating the dispatch.
