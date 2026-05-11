# mechanism-observation-v1 findings

Cumulative narrative across slices. Each entry records what the slice
attempted, what the artifacts show, and the load-bearing-or-not
classification of any surprises.

---

## Slice A — Mechanism (closed 2026-05-11)

**Goal.** End-to-end round-trip of one real `mechanism_observation`:
BC bead -> catalog message -> lead drain bead, with all artifacts
queryable from beads.

**Outcome.** Closed cleanly. The schema rejected malformed `bd_ref`
(path separator, missing suffix, leading hyphen) and short body at
construction time; the CLI propagated the rejections as non-zero
exits; the round-trip read via `shop-msg read outbox` validated the
message against the extended `BCResponse` union without any change to
that CLI. The three artifacts (BC bead `ddd-product-system-ml8`,
catalog YAML at `runs/slice-A/`, lead drain bead
`ddd-product-system-yah`) form a queryable chain via the
`mechanism-observation` label and the `originated` / `received`
sub-labels.

**Surprise — none on the mechanism itself.** The infrastructure was
a straight composition of existing patterns: the schema follows the
same Field/min_length/regex pattern as `Clarify.work_id` (lead-008);
the CLI mirrors `respond clarify` and `respond work_done` exactly; the
BDD scenarios reused 5 existing step definitions across happy-path,
collision, and rejection scenarios — only 2 new step definitions were
needed for the new message type's happy path. **This corroborates
prototype 1 finding 1**: the catalog mechanism scales to a new
message type without structural changes.

**Real surprise — code review surfaced two latent gaps.** The
schema-level `evidence: list[str] | None = Field(min_length=1)`
constraint admitted `evidence=['']` (per-element non-empty was not
enforced) until the A2 code review caught it; fix tightened to
`list[Annotated[str, Field(min_length=1)]] | None`. The `bd_ref`
regex `^[a-z0-9-]+-[a-z0-9]+$` admitted leading hyphens (the
character class includes `-`); fix tightened to
`^[a-z0-9][a-z0-9-]*-[a-z0-9]+$`. **Both gaps are signal that the
code-reviewer subagent's adversarial probing surfaced real schema
gaps — the same loop the spec describes for §4.4 closure, applied
here to schema design rather than scenario tightening.** Both gaps
were closed with new schema-level tests pinning the corrected
constraints.

**Worked example as input to slice B2.** The observation that drove
the round-trip is itself load-bearing for the next slice: the
`bc-implementer` template's anti-rationalization section guards only
the under-asking failure mode (per prototype 1 finding 2 caveat).
Slice B1.1's template revision must add parallel over-asking guards
before slice B2 dispatches, otherwise B2 — the over-emit hard gate —
will likely fail with a false-positive `mechanism_observation` from
the dispatched BC subagent.

**CLI verb correction.** The design doc named the CLI as `shop-msg
send mechanism_observation`, which contradicts the existing
convention (`send` is reserved for lead-originated messages writing
to BC inbox; `respond` is BC-originated writing to outbox). The
implementation plan resolved this as `respond mechanism_observation`
and slice A's closing commit corrects the design doc to match.

**Artifacts:** `runs/slice-A/`
- `ddd-product-system-ml8-mechanism_observation.yaml` — the wire message
- `bc-bead.txt` — `bd show` of the BC originating bead
- `lead-bead.txt` — `bd show` of the lead drain bead
- `bd-list-{all,originated,received}.txt` — the three required queries

**Slice issue:** `ddd-product-system-1yc.1` (closed)

---

## Slice B1 — Discipline / under-emit (closed 2026-05-11, partial result)

**Goal as written.** Validate that a fresh BC subagent dispatched
against a work item with a naturally-available mechanism observation
reaches for `mechanism_observation` without driver prompting.

**What actually happened.** The constructed work item — an
`assign_scenarios` for `bc-shop` pinning `Temperature(0).to_fahrenheit()
== 32` — was not the right shape for the question. The BC subagent
did the work cleanly (wrote feature file, added step defs, ran BDD)
and did NOT emit `mechanism_observation`. Diagnosed initially as
under-emit failure of the discipline trigger language (see
`runs/slice-B1/dispatch-1/report.md`).

**Re-diagnosis.** The work item conflated two questions:

1. *Does the mechanism_observation discipline trigger?*
2. *Does the BC notice it's being asked to do redundant work?*

The BC failed on (2) — they silently produced a redundant feature
file pinning behavior the unit tests already cover. This is NOT a
mechanism observation question. It is a domain-level sufficiency
check: the BC owns the Bounded Context and is the only role that
can see redundancy across scenarios + unit tests + source. The
lead does not have visibility into per-BC test layers.

The right outcome from dispatch-1 was `clarify` ("the scenario pins
behavior already covered by `test_to_fahrenheit_zero` — is this a
tightening, an additive layer, or a lead misread of the pre-state?")
— and the bc-implementer template did not list a sufficiency check
that would have triggered it.

**Surfaced finding (load-bearing).** The bc-implementer's
`assign_scenarios` sufficiency check needed a 4th item: cross-BC
consistency / redundancy check. Applied as commit
`ef624a6` — adds the check with a three-way clarify question
(tightening / over-coverage / lead misread).

**On the original validation target.** The mechanism_observation
discipline question is partially validated — slice A proved the
message + the round-trip + the schema-level constraints work; slice
B1's under-emit test is inconclusive because the work item was
shaped to surface a different gap. Further validation deferred to
real-world use: when BCs do real product work, the discipline
either kicks in or doesn't, and observed behavior tells us where
the trigger language needs sharpening. Engineering more synthetic
work items at prototype-scale is over-investment.

**Cost-of-failure asymmetry.** Under-emit (the failure dispatch-1
showed) means a load-bearing observation goes unsurfaced — recoverable
by the next dispatch noticing the same thing, or by the lead asking.
Over-emit (the asymmetric-calibration concern from slice A) means
the lead drains low-signal observations — also recoverable.
Neither is a hard failure. The cross-BC redundancy gap (now closed
by `ef624a6`) was a hard failure: silent debt accretion the lead
could not see.

**Iteration cap honored.** Per the plan's 4-dispatch cap, no further
B1 dispatches will run on synthetic work items.

**Artifacts:** `runs/slice-B1/`
- `work-item.md` — the originally-constructed (mis-shaped) work item
- `dispatch-1/` — full snapshot + BC subagent report
- (no dispatch-2; not iterated)

**Slice issue:** `ddd-product-system-1yc.2` (closed with this finding)

---

## Slices B2, B3, C — deferred (2026-05-11)

Per the in-session decision after B1's re-diagnosis: the
mechanism_observation discipline question that B2 and B3 were
designed to test is no longer the highest-leverage validation
target. The cross-BC redundancy gap surfaced by B1 is more
load-bearing for usable product work than continuing to engineer
synthetic discipline tests at prototype scale.

**B2 (over-emit hard gate)** — deferred. The asymmetric-calibration
fix from slice A's worked example is in the bc-implementer template.
Whether it works on a fresh subagent is unvalidated, but over-emit
is a low-cost failure (the lead drains noise) and validating it now
would burn dispatches that could be spent on real product work.

**B3 (near-miss)** — deferred. Conditional on B1/B2 outcomes that
won't run.

**C (lead drain formalization)** — deferred. The slice-A worked
example exercised the drain manually. A `lead-drain.md` document
formalizing the per-observation procedure can be written when there
is a real load (multiple BCs producing observations during real
work). At prototype scale with one observation, the procedure is
straightforward enough not to need formal documentation yet.

**Slice issues:** `ddd-product-system-1yc.{3,4,5}` (status updated to
deferred with notes pointing here).
