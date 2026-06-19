# Scenario supersession & dispatch-discipline doctrine

Consolidated resolution of a cluster of lead-architect doctrine beads
(lead-rv9, lead-uhd2, lead-yug, lead-ymct, lead-otu). These are decisions
to record, not mechanism changes — the existing 7-type catalog + prose
conventions cover the cases; what was missing was a canonical home for the
discriminator/convention decisions. Recorded 2026-06-19.

## 1. work_done(blocked) → request_maintenance for Reviewer-cited value fixes (lead-rv9)

**Decision.** When a Reviewer emits `work_done(blocked)` naming a concrete,
value-only defect plus the canonical fix (e.g. "these 4 `@scenario_hash`
values are wrong; correct them to X/Y/Z via `scenarios hash`"), the lead's
canonical response is **`request_maintenance`** carrying the cited fix. The
existing 7-type catalog covers `work_done(blocked)` responses by
composition — no new message type is needed.

"Flat / Reviewer-cited correction" is an explicit pathway under
`request_maintenance`, alongside refactor / doc / value-update. The
discriminator: the gap is a defect in the BC's own pinned artifacts (hash
values, file contents), NOT a missing scenario pin (that would be
`request_bugfix`) and NOT a question (that would be `clarify`). The BC is
not authorized to re-emit `work_done` unilaterally; the lead must send the
correcting message.

Template-level work_done(blocked) report-shape constraint already landed in
the bc-reviewer template (2026-06-09). This records the lead-SIDE response
shape, which was previously unrecorded.

## 2. Supersession of BC-committed scenarios is invisible at dispatch (lead-uhd2)

**Problem.** Scenarios committed in a BC's OWN `features/` (outside the
lead's ADR-018 artifact surface) can be contradicted/superseded by a new
dispatch, and the lead cannot see the collision at compose time. Observed
three times: agent-vault (lead-v4ih superseded 7 host-cred-mount scenarios),
respond-guard (lead-rl0f contradicted 2 prime_lead scenarios), each caught
by the BC via `clarify` (loop worked as designed). Contrast the GOOD case
(ADR-028 D3): `f23dfbe84c899968` lived on the lead's OWN ADR-018-visible
surface, so the lead retired it directly with no clarify round-trip.

**Resolution approach (design note, not yet built).** Two complementary
options, both retained:
- **(1) Pre-dispatch scenario-register reconciliation.** The lead reconciles
  the BC's reported scenario register (via `request_shop_card` / a
  scenario-register surface, see §5/lead-otu) against intended scenarios
  before dispatch, so contradictions surface lead-side instead of via BC
  clarify. This stays within ADR-018: the register is a BC-reported
  artifact, not lead-side git observation of BC source.
- **(2) `@supersedes:<hash>` tooling** (see §3) makes retirement explicit
  and first-class so a dispatch carries the retirement instruction even when
  the lead cannot independently see the superseded scenario.

Until either lands, the operating discipline is: when a dispatch plausibly
supersedes BC-committed coverage the lead cannot see, carry an explicit
retirement/supersession instruction in the dispatch prose, and treat a BC
clarify on collision as expected, not exceptional. (This is the same
enumeration step the lead-architect template's @scenario_hash check already
mandates, extended to the BC-committed surface via the BC's mailbox-reported
register.)

## 3. `@supersedes:<hash>` tag convention (lead-yug)

**Decision (convention recorded; build DEFERRED, P3).** When a new scenario
supersedes a previously-dispatched one, the relationship today lives only in
prose (Gherkin Feature description, dispatch description). The agreed
convention, should it be built: a machine-readable `@supersedes:<hash>` tag,
parallel to the existing `@bc:<name>` and `@scenario_hash:<hash>` injections,
set at dispatch time (candidate mechanism: a `--supersedes` flag on
`shop-msg send`, or a PO authoring-time tag, mirroring how `@scenario_hash`
is PO-authored and verified at dispatch).

**Why deferred, not done.** The prose mechanism works today; this is an
ergonomic / discipline improvement, not a correctness gap. Building it is a
`shop-msg` schema / send-side change owned by shopsystem-messaging, to be
folded into a future scenario-discipline consolidation rather than dispatched
standalone. Benefits when built: machine-readable retire-from-feature-file
instruction for the BC Implementer; audit trail in the BC outbox; enables a
supersede-chain view on a future scenario-register surface (§5).

## 4. Parallel in-flight dispatches to one BC — commit-sequencing deadlock (lead-ymct)

**Mechanism.** Dispatching multiple bugfix/maintenance items to the SAME BC
before earlier dispatches are reviewer-signed-off AND committed accumulates
interleaved changes across shared files (e.g. `conftest.py`, `storage.py`,
`cli.py`). The BC then cannot commit any single item without HEAD referencing
still-uncommitted siblings — violating "leave main green." Observed twice on
shopsystem-messaging (lead-2ca, lead-2122).

**Cure pattern — VALIDATED, adopt as lead-side process discipline.**
*Serialize bugfix/maintenance dispatches per BC: do not dispatch lead-N to BC
X until lead-(N-1) is reviewer-signed-off AND committed.* When entanglement
has already occurred, the **carrier pattern** (a follow-up dispatch that
sequences the joint recommit/push once the blocker lands, e.g. lead-pfmb)
recovers it. Both were empirically validated: lead-2ca recovered via
lead-pfmb→lead-xscs carrier; lead-nn5f succeeded as a clean single-dispatch
after the tree was clear.

The carrier is recovery/mitigation; serialization is prevention. The router's
end-of-turn continuation rule already implies per-BC serialization (don't
dispatch the next item to a BC with an unreconciled in-flight item); this
records WHY. **Open for a future PDR:** whether to additionally provide a CLI
affordance (`shop-msg dispatch-after <work_id>` deferring send until a
predecessor lands) rather than relying on discipline alone — not blocking.

## 5. Scenario-register surface — degenerate-by-design for now (lead-otu)

**Decision.** The lead-architect activity "Reconcile scenario registers
against assigned work" has no dedicated register surface under
`features/templates/` (only raw gherkin files). Rather than build a per-BC
register surface speculatively, **accept reconciliation as degenerate-by-
design for the templates BC for now, and reconcile against the BC's
mailbox-reported `work_done` scenario register** (the ADR-018-admissible
surface) when one is reported.

**Why degenerate, documented.** A standalone lead-side register surface
(authored / dispatched / signed-off status, designed once for all BCs) is
worth building only once it has a consumer with teeth — namely the
pre-dispatch reconciliation of §2/option(1) and the supersede-chain view of
§3. Building it now, ahead of those consumers, would be a surface the
mechanism doesn't yet exercise. It graduates from "degenerate by design" to
"build it" when §2(1) or §3 is scheduled. Until then the role names a
responsibility realized via the BC's reported register, not a missing lead
artifact.
