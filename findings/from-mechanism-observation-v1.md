# Findings from mechanism-observation-v1

**Status:** stable artifact. Consolidates the load-bearing claims
from this prototype's slice run (slice A executed in full; slice B1
executed once and re-diagnosed; slices B2, B3, C deferred — see
`findings.md` for the per-slice narrative). Input to the next
prototype's design and to the spec edit pass.

The prototype's stated validation target was the BC-originated
`mechanism_observation` message and the BC-template discipline that
makes BCs surface load-bearing observations during regular work.
By the end it had also surfaced a load-bearing template gap in
`bc-implementer`'s `assign_scenarios` sufficiency check that was
more important than the discipline question itself.

This document only carries claims that are **load-bearing for the
spec or the next prototype**. Per-slice evidence lives in
`findings.md` and `runs/slice-N/`.

---

## 1. The catalog mechanism scales to a new message type without structural changes

**Claim.** Adding `mechanism_observation` as the 8th message type
required only: one new Pydantic model, one CLI subcommand mirroring
the existing `respond clarify`/`respond work_done` pattern, one
import update to extend the `BCResponse` union, and 2 new pytest-bdd
step definitions for the happy-path scenario. No architectural
changes; no schema infrastructure changes; no transport changes.

**Evidence.** Slice A produced 4 BDD scenarios (happy-path,
collision-refuse, path-separator rejection, body-min-length
rejection) by reusing 5 existing step definitions from prototype 1's
conftest and adding only 2 new ones. The end-to-end round-trip
(BC bead → catalog message → lead drain bead via `shop-msg read
outbox`) worked without modifying the read CLI — the extended
`BCResponse` union was sufficient.

**Caveat.** N=2 BC topology unchanged from prototype 1. The
mechanism would face new pressure if N>2 BCs each emit observations
the lead must drain in parallel; this is unvalidated.

**Implication for spec.** Corroborates prototype 1 finding 1
("the catalog mechanism is sufficient"). §5 normative language can
treat catalog growth as a low-cost operation: each new message type
adds a Pydantic model + a CLI subcommand and otherwise composes.

---

## 2. Schema-level constraints are the right gate for input safety — including for new fields surfaced by code review

**Claim.** Cross-cutting input safety on `MechanismObservation`
belongs in the Pydantic schema, not in the CLI. The CLI is the
propagation surface (non-zero exit on rejection); the schema is
the gate. The pattern from prototype 1 finding 4 holds, and *the
adversarial code-review loop catches schema gaps that synthetic
tests miss.*

**Evidence.**
- The `bd_ref` regex `^[a-z0-9-]+-[a-z0-9]+$` was committed in A1
  (commit `d74fe13`). Code review in the same task surfaced that
  the character class admits leading hyphens (e.g., `-leading-hyphen`
  validates), contradicting the stated "beads issue-id shape"
  intent. Tightened to `^[a-z0-9][a-z0-9-]*-[a-z0-9]+$` in commit
  `8282912`.
- The `evidence: list[str] | None = Field(min_length=1)` constraint
  committed in A1 constrained list length but not per-element
  length. Code review in A2 surfaced that `evidence=['']` was
  silently accepted. Tightened to
  `list[Annotated[str, Field(min_length=1)]] | None` in commit
  `70ef3c2`.

**Sub-finding.** Both gaps were caught by the code-review subagent's
adversarial probing, not by the implementer's TDD cycle. This is
the same shape as prototype 1's §4.4 Reviewer-finds-gap loop,
applied here to schema design rather than scenario tightening.
Schema invariants benefit from the same adversarial discipline that
scenarios do.

**Caveat.** Both gaps were Minor in code-review terms (no current
production bug, both required malformed callers to surface). The
fix-on-review pattern works at this scale; it is unproven whether it
catches Critical schema gaps before they ship.

**Implication for spec.** §5.6 (schema-level invariants, added
during prototype 1's spec integration) should add a brief note that
adversarial review on schema constraint declarations is part of how
the gate gets and stays correct. The §4.4 loop framing applies to
schema work, not just scenario work.

---

## 3. The cross-BC consistency check is a load-bearing sufficiency-check item the prior bc-implementer template was missing

**Claim.** When a BC receives an `assign_scenarios` message, the
sufficiency check must include: *does this scenario pin behavior the
BC already implements?* The BC owns the Bounded Context and is the
only role with visibility into per-BC test layers (existing
scenarios, unit tests, source). A lead constructing an
`assign_scenarios` message cannot see redundancy from outside; if
the BC silently treats the work as net-new, the result is redundant
feature files plus over-coverage in tests — silent debt accretion
the lead cannot catch.

**Evidence.** Slice B1 dispatch-1 (`runs/slice-B1/dispatch-1/`):
the BC subagent received an `assign_scenarios` for behavior the
unit test `test_to_fahrenheit_zero` already pinned. The BC
correctly noted in its report ("No changes to `src/temperature.py`
were needed — `to_fahrenheit()` already implements
`celsius * 9 / 5 + 32`") but proceeded to write the feature file
and step definitions anyway, producing redundant coverage. Per
the bc-implementer template's pre-fix sufficiency check, this was
behavior-compliant — the template did not name redundancy as a
clarify trigger.

**Resolution.** Commit `ef624a6` adds a 4th sufficiency check item
to bc-implementer's `assign_scenarios` section, with a three-way
clarify question (tightening of unpinned behavior / additive layer
over already-pinned / lead misread of pre-state).

**Caveat.** The fix has not been re-dispatched against the same
work item (slice B1 was closed after re-diagnosis, not iterated).
The fix is grounded in the dispatch-1 evidence but unvalidated on
a fresh subagent.

**Implication for spec.** §4 (BC-shop) should name the cross-BC
consistency check as a first-class sufficiency-check responsibility,
parallel to the well-formed-Gherkin and concrete-step checks. The
spec language should not enumerate the specific check (per the
`shop-system-spec-vs-templates` discipline from prototype 1) — the
template carries the specifics, but the spec should NAME that the
BC must verify the request fits the BC's existing capability shape
before treating it as net-new.

---

## 4. Slice construction must isolate the variable being tested — confounded slices teach less than no slice

**Claim.** A prototype slice that conflates two validation
questions teaches little about either. Slice B1's work item
("scenario pinning behavior the unit tests already cover") was
constructed to test mechanism_observation discipline (would the BC
notice and surface it?) but was *also* a sufficiency-check failure
mode (would the BC `clarify` instead of doing redundant work?).
The BC failed both, but only the second was load-bearing — and
the slice's evaluation framework was set up to score the first,
which was the wrong question.

**Evidence.** The slice's pass/fail criteria in
`runs/slice-B1/work-item.md` listed mechanism_observation
emission as the PASS condition. The BC's actual outcome (silent
redundant work) was scored as "FAIL — under-emitting" — but the
right re-classification is "the slice was the wrong shape; the
template gap surfaced is more important than the gap the slice
was designed to test." Re-diagnosis happened in-session; the
findings doc records both the original interpretation and the
correction.

**Sub-finding.** Slices designed by the driver are subject to the
same "is this the right question?" discipline as messages
constructed by the lead. The `assign_scenarios` vs
`request_bugfix` discriminator from prototype 1 finding 5 has a
slice-design analog: *what is this slice actually testing, and is
the work item shaped to surface that and only that?*

**Caveat.** The re-diagnosis was made by the user (the human
driver), not by the AI driver-orchestrator. Whether an AI driver
running solo would have caught the conflation is unvalidated.

**Implication for next prototype.** Before constructing a slice,
the driver should ask: *if the BC subagent does X (the most likely
literal-reading behavior), does my evaluation framework correctly
distinguish whether X is a pass on the question I'm asking, a
fail, or a sign that I'm asking the wrong question?* The third
case is a real outcome and the framework should accommodate it.

---

## 5. The mechanism_observation discipline question is partially validated

**Claim.** The `mechanism_observation` *message* and its
*round-trip mechanism* (BC bead + catalog message + lead drain
bead, all queryable via `bd list --label mechanism-observation`)
are validated end-to-end. The *discipline trigger language* in the
bc-implementer template that should make a BC subagent reach for
`mechanism_observation` when load-bearing observations are
available is **not** validated — slice B1's evidence is
inconclusive (the work item was the wrong shape) and slices B2,
B3 are deferred.

**Evidence (positive side).** Slice A round-tripped a real
observation end-to-end with one human driver and one CLI invocation
chain. The schema rejected malformed input at construction time;
the CLI propagated the rejection; the read CLI validated the message
on the lead side without any change.

**Evidence (negative side).** Slice B1 did not produce evidence
either way about whether the discipline trigger language works on
a fresh subagent.

**Caveat.** The asymmetric-calibration fix from slice A's worked
example (parallel over-asking guards in the bc-implementer's
anti-rationalization section) is in the template but has only been
exercised by the dispatch-1 BC, who did not over-emit (and also
did not under-emit on a real mechanism-level observation).

**Implication for next prototype / for real-world use.** The
discipline question is best validated by *real BC dispatches doing
real product work*, not by synthetic prototype slices. Defer
further validation to the next prototype OR to the first
real-product use of the shop-system. Observed BC behavior on real
work tells us where the trigger language needs sharpening; further
synthetic slice engineering at this scale produces low-information
results.

---

## 6. What's deferred or unvalidated (input to next-prototype scope)

**From this prototype:**

- The mechanism_observation discipline trigger on a fresh BC
  dispatched against a work item constructed to isolate the
  question. (Slice B1 was the wrong shape; B2 and B3 deferred.)
- The over-emit hard gate (B2). The asymmetric-calibration template
  fix is in place but unproven on a fresh subagent.
- Lead drain formalization (`lead-drain.md`). The slice-A worked
  example exercised the drain manually; a documented procedure is
  warranted when there is a real load (multiple BCs producing
  observations during real product work).
- The cross-BC consistency check (finding 3) on a fresh BC
  dispatch — the template fix is grounded in dispatch-1 evidence
  but unvalidated post-fix.

**Carried over from prototype 1:**

- Multi-BC topology with cross-BC fan-out (prototype-1 §8 #1).
- Lead-as-subagent (prototype-1 §8 #2). Partially advanced by the
  lead-architect template added in slice 16 of prototype 1 but
  not re-exercised here.
- Cross-session §4.4 (prototype-1 §8 #4).
- The two unexercised message types `request_shop_card` and
  `request_scenario_register`.

---

## 7. Implications for the next prototype

The next prototype should accept findings 1–5 as starting
conditions and pick its target from one of:

1. **Real product BC.** Stand up a non-toy Bounded Context (not
   `bc-shop` Temperature) using the now-shipped catalog +
   templates + CLIs. Surface real findings against real work
   instead of engineering synthetic slices. **Highest-information,
   most generative — and the natural next step after package
   promotion.**
2. **Multi-BC topology with cross-BC fan-out** (prototype-1's
   highest-leverage deferred item, still unaddressed). A lead
   request that implies coordinated changes in two BCs.
3. **Lead-as-subagent** (closes prototype-1 finding-8 fully). A
   prototype where the lead is also a subagent with its own role
   templates. Tests prototype-1 findings 2 and 5 from the
   previously-unobserved direction.

**Recommendation: option 1, after package promotion.** The
shop-system has accumulated enough validated mechanism that real
product work is the right pressure to apply next. Synthetic
slice engineering has hit diminishing returns at the current
prototype scope.

---

## 8. How to use this document

When designing the next prototype:

- Take findings 1–3 as starting conditions. They are validated.
- Take finding 4 as a slice-construction discipline. Apply it
  before building any work item.
- Take finding 5 honestly: the discipline question is open, but
  real-world BC behavior is a better validator than more synthetic
  tests.
- Use §6 to scope what to pick up.
- Use §7 as a rough priority ordering; real-product BC stand-up is
  the recommended path.

When updating the spec proper:

- Finding 1 → §5 normative language treats catalog growth as
  low-cost composition.
- Finding 2 → §5.6 should add a brief note that schema
  constraints benefit from adversarial review during their
  design.
- Finding 3 → §4 should NAME that the BC must verify a request
  fits the BC's existing capability shape, without enumerating
  the specific check (template carries specifics).
- Finding 4 → not a spec change; a process note for next-prototype
  designers.
- Finding 5 → caveat in §5 that discipline-side validation of new
  message types is best done against real work, not synthetic
  slices.
