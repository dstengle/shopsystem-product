# ADR-035 — The three-tier ADR hierarchy (framework / system-global / BC-local) and a periodic system-architect review cadence over the BC-local tier

**Status:** accepted (2026-06-10)
**Authors:** dstengle, Claude (lead-architect)
**Pins:** the locked design intent recorded on `lead-ir9m` (dave, 2026-06-05)
— decision (3), the three-tier ADR hierarchy in full: *"framework ADRs
(template-delivered) / system-global ADRs (lead repo, per-product, NOT
template-delivered, new home/convention needed) / BC-local ADRs (per BC,
reviewed periodically at system-architect level)."* This ADR is the umbrella
that names all three tiers as one coherent model, defines the BC-local tier and
its periodic review cadence, and ties together
[ADR-033](033-bc-local-architect-role-design-sensibility-up-front-no-bc-po.md)
(produces the BC-local tier) and
[ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md)
(homes the system-global tier). It resolves the remainder of the structural
bet [PDR-013](../pdr/013-bc-decomposition-discipline-and-design-quality-structural-bets.md)
§3 (S3) deferred to `lead-cnbu`.
**Anchored to:** [ADR-018](018-empirical-verification-is-contract-surface.md)
(the artifact-surface evidence rule, and the boundary that makes the BC-local
tier's *review* a reconcile-on-emissions activity, not a clone read);
[ADR-017](017-bc-side-bead-creation.md) (BC sovereignty — the lead's view of a
BC is its emissions, which shapes how the periodic review reaches BC-local
ADRs).
**Anchored on (PDR):**
[PDR-013](../pdr/013-bc-decomposition-discipline-and-design-quality-structural-bets.md)
(the three-tier hierarchy structural bet and the periodic-review intent — *"BC
internal structural choices … aren't recorded, so the periodic reader can't see
intent"*, opportunity O3).
**Related beads:** `lead-cnbu` (this design bead), `lead-ir9m` (locked the
three-tier decision), `lead-5hm1` (the role-agnostic decomposition discipline
whose design rationale BC-local ADRs record).

---

## Context

`lead-ir9m` decision (3) and PDR-013 §3 (S3, opportunity O3) name a three-tier
ADR hierarchy as a structural bet: framework / system-global / BC-local, with
the BC-local tier *reviewed periodically at the system-architect level.* The
two lower questions are resolved in sibling ADRs — ADR-034 homes the
system-global tier (in the existing `adr/` tree, tier-tagged) and ADR-033
introduces the BC-local architect role that *produces* BC-local ADRs. What
remains, and what this ADR pins, is **(a) the model as a whole** — naming the
three tiers, their homes, owners, and propagation — and **(b) the BC-local tier
itself plus its periodic system-architect review cadence**, the one piece of
S3 neither sibling ADR covers.

PDR-013 O3 states the underlying pain precisely: *"A BC's internal structural
choices (why this split, why this boundary) aren't recorded, so the periodic
reader can't see intent."* The BC-local ADR tier is the recording mechanism;
the periodic review is how the system architect keeps that local trail coherent
with the system-global one without violating BC sovereignty (ADR-017) or the
no-clone doctrine (ADR-018).

This is a structural / convention decision with no product-UX surface change —
hence an **ADR**, not a PDR.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

Verified from the lead CWD on 2026-06-10 against this repo's `adr/`/`pdr/`
records, spec sections, and the two sibling ADRs authored in this same bead. No
BC source involved.

1. **No tier model exists today; ADRs are a flat undifferentiated tree.
   CONFIRMED** (read of `adr/`, finding mirrors ADR-034 finding 2). There is no
   framework/system-global/BC-local distinction recorded anywhere; the model
   this ADR pins is net-new on the convention surface.

2. **The BC-local tier has NO home today and CANNOT live in the lead repo.
   CONFIRMED** (ADR-018 doctrine + §4.3). The lead host carries no `repos/` BC
   source (ADR-018); BC artifacts live in the BC repos and the lead sees only
   emissions (ADR-017). §4.3 enumerates BC-shop-owned artifacts (code, tests,
   local Gherkin, scenario register, BC beads, shop card) — a BC-local ADR is a
   BC-owned artifact by the same logic, so it MUST live in the BC repo, not the
   lead's `adr/`. This is why the BC-local tier is a *third* home, not a
   subdirectory of the lead's `adr/`.

3. **The periodic review must reconcile-on-emissions, not read clones.
   CONFIRMED** (ADR-018 D1/D6, ADR-017). The system architect reviewing
   BC-local ADRs cannot read them from a `repos/<bc>` clone (none exists) and
   MUST NOT execute or git-observe BC source. The admissible channel for the
   lead to learn a BC's recorded design decisions is the BC's *emissions* — a
   shop-card / `work_done` demonstration / an explicit request vehicle — exactly
   as reconciliation already works. So the periodic review's *mechanism* is
   constrained by the same doctrine as every other lead-side BC interaction.

4. **The sibling ADRs in this bead establish the other two tiers' homes.
   CONFIRMED** (read of the two files authored alongside this one): ADR-034
   homes framework + system-global tiers in the lead `adr/` tree (tier-tagged);
   ADR-033 introduces the bc-architect role that authors BC-local ADRs. This
   ADR composes those into one model and adds the missing BC-local-tier
   definition + review.

5. **@scenario_hash retirement enumeration. CONFIRMED — empty.** Convention/
   model decision; no Gherkin, no pinned coverage touched.

---

## Decision

### D1 — The three-tier ADR hierarchy, defined as one model

Architecture decisions in the shopsystem are recorded at one of three tiers,
each with a distinct home, owner, scope, and propagation:

| Tier | Scope | Home | Owner | Template-delivered? |
|---|---|---|---|---|
| **framework** | the framework spec / doctrine itself, applies to every product instantiation | lead repo `adr/` (tier-tagged), distinct from the `01-…`–`06-…` SPEC sections | lead architect (system architect) | recorded per-product; only genuine framework doctrine is conceptually portable (ADR-034 D3) |
| **system-global** | cross-BC, per-product structural decisions (how *this* product's BCs relate) | lead repo `adr/` (tier-tagged) — the existing tree (ADR-034 D1) | lead architect | NO — per-product, lead-authored (ADR-034 D3) |
| **BC-local** | a single BC's internal structural choices (why this split, why this boundary) | the **BC repo**, alongside its code/tests (a BC-owned artifact, §4.3) | the **BC-local architect** (ADR-033) | NO — BC-authored; never on the lead host (ADR-018) |

The tiers are distinguished by **scope of the decision**, not by file format:
all three use the same ADR shape (Status, Context, pre-state findings,
Decision, Alternatives, Consequences). The discriminator on any decision:
*does it change the framework for everyone (framework), the way this product's
BCs relate (system-global), or one BC's internals (bc-local)?*

### D2 — The framework and system-global tiers are realized per ADR-034 (no new mechanism here)

The two lead-resident tiers' home and tag convention are fully decided by
[ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md):
both live in the existing lead `adr/` tree, distinguished from each other (and
from the framework SPEC sections) by a `**Tier:**` header tag, not by separate
directories. This ADR adopts that verbatim; it adds nothing to the two
lead-resident tiers beyond naming them as members of the model.

### D3 — The BC-local tier lives in the BC repo, is authored by the BC-local architect, and is a BC-owned artifact (never on the lead host)

A **BC-local ADR** records a single BC's internal structural decisions (the O3
pain: why this split, why this boundary). It MUST live in the **BC repo**
(finding 2) — it is a BC-owned artifact in the same class as code, tests, and
the scenario register (§4.3). It is authored by the **BC-local architect**
(ADR-033 D2.3), whose design-up-front posture is exactly the role that *makes*
the structural choice the ADR records. A suggested home is `adr/` within the BC
repo, mirroring the lead convention — but the *path* is a BC-internal
convention the BC owns, not a lead-imposed one (consistent with §4.3's "the
BC-shop holds only what it needs"). The lead does NOT carry these files
(ADR-018); it learns of them only via emissions (D4).

### D4 — Periodic system-architect review cadence over the BC-local tier, conducted reconcile-on-emissions (NOT by reading clones)

The BC-local tier is **reviewed periodically at the system-architect level**
(`lead-ir9m` (3)) — the system architect (the lead architect) periodically
checks that BC-local design decisions are coherent with the system-global ones
and that significant BC-local decisions that *should* be system-global (because
they affect cross-BC contracts) get promoted up a tier.

The cadence and mechanism, constrained by ADR-018/ADR-017 (finding 3):

- **Trigger / cadence.** The review is **event-anchored, not calendar-anchored**
  by default: it runs (a) during reconciliation of a BC's `work_done` that
  carries a structural change, and (b) as a standing periodic sweep the lead
  router can schedule (a `bd` review bead per BC, recurring) — calendar cadence
  is an operator knob, the event-anchored trigger is the floor. This keeps the
  review tied to *when a BC's structure actually changes*, not to an arbitrary
  clock.
- **Mechanism (reconcile-on-emissions).** The system architect learns a BC's
  recorded design decisions through the **BC's emissions** — its shop card
  (which §4.3 already serves via `request_shop_card`) and its `work_done`
  demonstrations — NOT by reading a `repos/<bc>` clone (there is none; ADR-018
  D1). If the architect needs a BC-local ADR's content that emissions do not
  carry, the move is a **`clarify`/`nudge` to the BC** (ADR-018 D5), never a
  clone read. The review is reconciliation, specialized to design-decision
  coherence, and obeys the same "the BC demonstrates, the lead reconciles"
  posture (ADR-018 D6).
- **Output.** Two outcomes: (i) a BC-local decision found to have **cross-BC
  reach** is *promoted* to a system-global ADR in the lead `adr/` tree (it was
  mis-tiered); (ii) a BC-local decision found to **conflict** with a
  system-global ADR loops back to the BC as a `clarify` (a structure question —
  ADR-033 D2.4 routes BC↔lead structure questions through `clarify`), for the
  BC-local architect to reconcile, exactly as the §4.4 loop handles
  requirement tightenings. The review never *edits* a BC-local ADR from the
  lead (BC sovereignty, ADR-017).

### D5 — Tier promotion is the relief valve; mis-tiering is expected and cheap to correct

Because the tier is determined by *scope* (D1) and scope is sometimes only
clear in hindsight, a decision recorded at one tier may later prove to belong
at another (the ADR-034 Open question is an instance: a system-global ADR that
turns out framework-portable; the D4 review's promotion case is another). Tier
promotion — re-tagging a lead ADR, or promoting a BC-local decision into a
system-global ADR — is a **normal, low-cost** operation, not a failure. The
periodic review (D4) is the standing occasion for it. This is the mechanism
that keeps the hierarchy honest over time, mirroring how §4.4 keeps the Gherkin
corpus honest.

---

## Alternatives considered

**Option A — Collapse to two tiers (framework vs everything-else), dropping the
BC-local tier.** Rejected — the BC-local tier is the direct answer to PDR-013
O3 (the unrecorded "why this split" intent the periodic reader can't see) and
is named explicitly in `lead-ir9m` (3). Without it, the BC-local architect
(ADR-033) has no recording home for the design decisions its posture produces,
and design intent stays oral/lost — the exact pain. The BC-local tier earns its
place.

**Option B — Host BC-local ADRs in the lead repo (a fourth lead `adr/`
sub-tree per BC).** Rejected (D3, finding 2) — this violates ADR-018 (no BC
artifacts on the lead host) and ADR-017 (BC sovereignty). A BC-local ADR is a
BC-owned artifact (§4.3 class); the lead reaching into it by file would
re-create the clone-read coupling ADR-018 severs. The lead sees it only via
emissions (D4).

**Option C — Calendar-only periodic review (e.g. "review all BC-local ADRs
monthly").** Rejected as the *default* (D4) — a fixed clock decouples the review
from when a BC's structure actually changes, producing either stale reviews
(structure changed, next review is weeks away) or wasted ones (nothing changed).
The event-anchored trigger (reconcile a structural `work_done`) is the floor; a
scheduled sweep is an *additional* operator knob, not the primary mechanism.

**Option D — Let the lead architect read BC-local ADRs directly to review
them.** Rejected (D4, finding 3) — there is no clone to read (ADR-018 D1), and
reading BC source is exactly the doctrine violation ADR-018 exists to prevent.
The review is reconcile-on-emissions; missing content is a `clarify`/`nudge`
(ADR-018 D5), not a clone read.

---

## Consequences

- **A single named three-tier model** (framework / system-global / BC-local)
  now governs all architecture decisions (D1), composing ADR-033 (produces the
  BC-local tier) and ADR-034 (homes the two lead-resident tiers) into one
  coherent scheme. **No tier collapse** — all three earn distinct homes/owners.
- **BC-local ADRs are a recognized BC-owned artifact** (D3) — implying a
  **follow-up to `shopsystem-templates`**: the `bc-architect.md` role template
  (ADR-033 Consequences) should pin that the BC-local architect records
  structural decisions as BC-local ADRs in the BC repo. **Flagged NOT dispatched
  here** (templates BC flaky/offline, `lead-yxsr`); rides the same bc-architect
  template dispatch ADR-033 flags. §4.3's artifact list may also gain a
  "BC-local ADRs" entry — a minor framework-tier spec edit, flagged as a
  follow-up.
- **A periodic system-architect review cadence** is established over the
  BC-local tier (D4), event-anchored by default with an optional scheduled
  sweep, conducted reconcile-on-emissions (shop-card / `work_done` / `clarify`),
  never by clone read. The lead router can realize the scheduled sweep as a
  recurring per-BC `bd` review bead — an operational follow-up, not actioned
  here.
- **Tier promotion is the standing relief valve** (D5); mis-tiering is expected
  and corrected at the periodic review — the mechanism that keeps the hierarchy
  honest, mirroring §4.4 for the Gherkin corpus.
- **The ADR-034 tier tag should be applied to this ADR and its two siblings**
  (all three are `system-global`) once the tag convention is ratified — see
  ADR-034 Open question on immediate backfill.
- **No Gherkin authored, no dispatch sent, no `@scenario_hash` retired** here
  (finding 5).

## Cross-references

- [PDR-013](../pdr/013-bc-decomposition-discipline-and-design-quality-structural-bets.md)
  — the three-tier hierarchy bet (S3) and O3 (unrecorded BC structural intent)
  this ADR's BC-local tier + review resolve.
- [ADR-033](033-bc-local-architect-role-design-sensibility-up-front-no-bc-po.md)
  — the BC-local architect role that authors the BC-local tier (D3).
- [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md)
  — homes the framework + system-global tiers (D2) and the tier-tag convention.
- [ADR-018](018-empirical-verification-is-contract-surface.md) — the
  artifact-surface / no-clone doctrine that constrains the periodic review to
  reconcile-on-emissions (D4); [ADR-017](017-bc-side-bead-creation.md) — BC
  sovereignty (the review never edits a BC-local ADR from the lead).
- `04-bc-shop.md` §4.3 — the BC-owned-artifact class BC-local ADRs join (D3).
- [lead-cnbu](beads:lead-cnbu), [lead-ir9m](beads:lead-ir9m) (locked the
  three-tier decision), [lead-5hm1](beads:lead-5hm1), [lead-yxsr](beads:lead-yxsr)
  (templates-BC flakiness gating the bc-architect template follow-up).
