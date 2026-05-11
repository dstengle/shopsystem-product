# Findings from prototype 1 (message-catalog-v1)

**Status:** stable artifact. This is the consolidated set of validated principles
the message-catalog-v1 prototype produced over 14 slices (2026-05-06 → 2026-05-10).
It is **not** a spec — the spec proper (`01-principles.md` through `06-work-tracking.md`)
will absorb the durable claims here on a follow-on edit pass. This document is the
input to that pass and the design surface for the next prototype.

The prototype's stated validation target was the inter-shop message catalog from
`05-inter-shop-protocol.md`. By the end it had also exercised the role-template
architecture from `04-bc-shop.md`, the §4.4 loop from `05-inter-shop-protocol.md`,
and several principle-level questions about where invariants belong (schemas vs
tools vs templates).

Per-slice narrative + cumulative state lives in `prototypes/message-catalog-v1/findings.md`
and the per-slice artifacts under `prototypes/message-catalog-v1/runs/scenario-N/`.
This document only carries claims that are **load-bearing for the spec or the next
prototype**.

---

## 1. The catalog mechanism is sufficient

**Claim.** Filesystem YAML transport + Pydantic schemas + a 7-message catalog is
sufficient for inter-shop communication. The mechanism does not need to grow until
multi-shop topology forces it.

**Evidence.** Five of seven message types (`request_maintenance`, `assign_scenarios`,
`request_bugfix`, `clarify`, `work_done`) round-tripped end-to-end across slices 1–15
without a single schema change motivated by mechanism limitations. Every change to the
schemas was substantive (S8 input-validation tightening, S15 `@bc:` tag enforcement) —
none were "the wire format couldn't carry what we needed." Inbox/outbox files survived
two §4.4 loop closures with concurrent reads/writes from independent subagent
dispatches.

**Caveats.**
- The two unexercised types (`request_shop_card`, `request_scenario_register`)
  were closed-as-deferred during P3 triage on 2026-05-10. The pattern is proven; the
  specific schemas need design when a future prototype actually uses them.
- Multi-BC topology is exercised at N=2 (the temperature `bc-shop` and `shop-msg-bc`).
  N>2 with cross-BC fan-out is unvalidated. A genuine multi-BC test would add load.
- The transport choice (P4 issue `ddd-product-system-2tf`) remains open. Filesystem
  YAML is sufficient for one-host single-process runs but does not generalize to
  distributed shops.

**Implication for spec.** §5 should treat the catalog mechanism as validated and
focus normative language on what the catalog **carries** (semantics) rather than
how it transports. Transport choice belongs in implementation notes, not normative
prose.

---

## 2. Role discipline is part of the contract, not adjacent to it

**Claim.** The Implementer and Reviewer roles operate on **role templates** that
encode sufficiency checks, anti-rationalization language, and gate discipline.
Without these templates the catalog mechanism produces wrong outcomes silently.
With them, the same catalog produces correct outcomes reliably.

**Evidence.** S2 (permissive prompt + thin message) collapsed `clarify` into
`work_done` because the Implementer "filled in" missing intent. S2b (same message,
tightened prompt) produced `clarify` correctly. S2c (vague-criteria probe, tightened
prompt) caught the substance gap and asked. S3 (well-specified, tightened prompt)
correctly proceeded. The behavior changed because of the prompt language, not the
schema or the implementation.

Across S5b–S15, the Implementer + Reviewer split held by construction (separate
dispatches, separate prompts) without any test enforcing it. The Reviewer found
real adversarial gaps multiple times (S5b equality-boundary; S6 collision; S14
schema-validation; S15 regex-search-vs-line-anchor) and signed off when no gap
was real. Same role templates, different dispatch instances, consistent behavior.

**Caveats.**
- The lead has no equivalent role template. The discriminator for
  `assign_scenarios` vs `request_bugfix` vs `request_maintenance` lives only as a
  bd memory (`shop-system-message-type-selection`) and as my own awareness while
  driving slices. A formal lead-side template is deferred.
- Anti-rationalization language is calibrated to under-asking failure modes
  (S2's silent inference). Over-asking failure modes (Implementer clarifies when
  sufficient) are unvalidated — the template's "asking would be theatre" line guards
  against this in principle but no slice has stress-tested it.

**Implication for spec.** §4 should treat role-template discipline as a first-class
artifact alongside the message schemas. The schemas describe *what* the system
exchanges; the templates describe *how the actors hold themselves to the contract.*
Per memory `shop-system-spec-vs-templates`: the spec should NAME that the role must
be equipped (e.g., "the Implementer must be equipped with explicit sufficiency
criteria"), but should NOT enumerate the specific criteria — those evolve in
templates.

---

## 3. The §4.4 loop is reproducible mechanism, not aspiration

**Claim.** "Reviewer finds gap → `clarify` → PO decides → `request_bugfix` with
tightened scenario → Implementer adds it → Reviewer signs off" is a closed loop
that uses only existing message types and the role-template architecture. No
special process or tooling is needed for §4.4.

**Evidence.** Three full closures across the prototype:

- **S6 → S7.** Reviewer in S6 found a collision-on-same-work_id gap in
  `shop-msg respond clarify`; lead in S7 sent `request_bugfix` with the tightening;
  Implementer added the scenario + CLI change; Reviewer signed off.
- **S14 (within slice).** Reviewer found a missing schema-validation-failure
  scenario for `shop-msg read outbox`; lead followed with `request_bugfix` (work_id
  lead-015) carrying the proposed tightening; Implementer added the scenario
  *without touching cli.py* (validation handling already existed); Reviewer
  counterfactually verified and signed off.
- **S15 (within slice).** Reviewer found a regex-search false-positive on
  `@bc:` tag schema enforcement; lead followed with `request_bugfix` (work_id
  lead-017); Implementer rewrote validator as line-by-line tokenization; Reviewer
  counterfactually verified and signed off.

Each closure had different specifics (collision-refuse, schema-validation pinning,
regex-line-anchor tightening) but identical SHAPE.

**Sub-finding ("tighten without code change," from S14):** sometimes the right
§4.4 result is to lock down behavior the implementation already has but no scenario
pins. The Reviewer's "implementation gap" branch (`work_done(blocked)`) is one
outcome; "tighten without code change" is another. Future template language should
name this category.

**Caveats.**
- The `work_done(blocked)` branch (Reviewer rejects the implementation, not the
  scenarios) is documented in `bc_reviewer_prompt.md` but not exercised. Either
  the Implementer + Reviewer pair is good enough that this branch rarely surfaces,
  or constructing a deliberate test is harder than expected.
- All three closures were within slice — the Reviewer's clarify and the lead's
  bugfix happened in the same session. Cross-session §4.4 (Reviewer escalates
  on Monday, lead responds on Tuesday) is unvalidated but should be straightforward
  given the catalog's transport semantics.

**Implication for spec.** §4.4 should reference these three closures as evidence
that the loop is real and add a normative note that the loop's mechanism reuses
existing message types — implementations should not invent §4.4-specific
machinery.

---

## 4. Schema-level enforcement is the right home for cross-cutting input safety

**Claim.** Invariants that span all callers (path safety, non-emptiness, tag
discipline, structural shape) belong in the catalog schemas as Pydantic
constraints. They do **not** belong in the producer code (CLI, role templates,
ad-hoc scripts). Schema-level enforcement catches every construction site for
free, including future tools that don't exist yet.

**Evidence.**
- **S8.** Three input-validation scenarios on `Clarify.work_id` (path-separator
  rejection, empty rejection, empty-question rejection). The Implementer pinned
  these via `Field(min_length=1, pattern=r"^[a-zA-Z0-9-]+$")` on the schema; the
  CLI was UNTOUCHED. Pydantic's `ValidationError` propagates as a non-zero exit
  by default, satisfying every scenario. A defensive check in `cli.py` would
  have been bypassable on day two by any future tool that built `Clarify` a
  different way.
- **S15.** `@bc:<name>` tag requirement on `ScenarioPayload.gherkin`. Same
  pattern: a `@model_validator(mode="after")` enforces the constraint at the
  schema layer. The CLI's `--bc-tag` flag composes correctly with the schema
  but is not the gate. Hand-constructing a `ScenarioPayload` without a tag
  fails at validation time.

**Sub-finding (from S15 + S16 narrative):** the discriminator "would adding this
to the role template be load-bearing?" should run BEFORE "is this a recurring
pattern?" Many recurring patterns belong in schemas (tag discipline) or
language-level hygiene (regex anchoring on pytest-bdd step-defs, conditional-
required argparse), NOT in role templates. Templates stay focused on *role
discipline*; schemas catch what schemas can catch; tools catch what tools
catch.

**Caveats.**
- Hash↔body invariant on `ScenarioPayload` (the hash field equals
  `compute_scenario_hash(gherkin)`) is a natural next schema constraint but
  has design tension: it requires `catalog` to depend on `scenarios`, breaking
  the package boundary. A `@model_validator` that takes a callable could
  resolve this with the producer injecting the canonicalization rule. Deferred.
- Cross-shop `@bc:` tag ↔ dispatch-target consistency (the `@bc:` tag could
  disagree with the BC the message is being sent to) is an integration-level
  invariant, not enforceable by any single shop's schemas alone. Open.

**Implication for spec.** §5.6 ([Schema-level invariants](05-inter-shop-protocol.md#56-schema-level-invariants), added as part of integrating these findings) states the principle: catalog message schemas carry constraints that enforce structural and safety invariants; the schema is the contract, producer code is not.

---

## 5. Message-type selection is itself a discipline

**Claim.** Choosing `assign_scenarios` vs `request_bugfix` vs `request_maintenance`
for a given piece of work is not arbitrary; it follows from a question about
the BC's pre-state:

> *"Is the BC's pre-state already doing this thing in some unpinned form, or
> does it not have the capability at all?"*

If the BC has no capability → `assign_scenarios` (lead commits to new behavior
via Gherkin scenarios). If the BC has the behavior but no scenario pins it →
`request_bugfix` (lead tightens unpinned existing behavior). If the BC has the
behavior and scenarios pin it but the lead wants a flat change (refactor, doc
tweak, value-only update) → `request_maintenance`.

**Evidence.**
- **S6, S9, S10, S11, S12, S13, S14 (first leg).** All added new CLI capability
  the BC did not previously have. All correctly used `assign_scenarios`.
- **S7, S8, S14 (§4.4 follow-up), S15 (both legs).** All tightened or pinned
  behavior the BC was already doing in some unpinned form. All correctly used
  `request_bugfix`.
- **S11 was the slice that articulated this discriminator** — Claude almost used
  `request_bugfix` to add new CLI flags (`--acceptance-criterion`, `--file-hint`),
  pattern-matching on "S8 was the vehicle for CLI tightening" without checking
  whether the work was actually a tightening. User caught it.

**Caveats.**
- The discriminator currently lives only as a bd memory
  (`shop-system-message-type-selection`) and as my awareness. The lead has no
  formal sufficiency check that enforces this at message-construction time.
- A schema-level discriminator (e.g., `request_bugfix` REQUIRES a description
  with a prior-hash reference; `assign_scenarios` REQUIRES new scenarios) is
  one possible mechanization. Currently both message types can carry scenarios,
  which makes the boundary fuzzy at the catalog level. Open design question.

**Implication for spec.** §3 (lead shop) or §5 should state the discriminator
explicitly. The spec currently treats the three message types as parallel choices
without articulating the question that picks between them.

---

## 6. Package boundaries hold under real-consumer pressure when dogfooding is preserved

**Claim.** A package's CLI is the boundary. Production code composes packages by
shelling out to their CLIs, not by importing their internals. Tests may import
freely. This rule scales: it keeps each package independently evolvable, makes
package boundaries observable from outside, and prevents the kind of soft
coupling that would force packages to co-evolve.

**Evidence.**
- The prototype evolved from a single tree (everything on `sys.path`) into four
  installable packages (`catalog`, `scenarios`, `shop-msg-bc`, `bc-shop`) plus
  a fifth (`harness.py` retired in S14).
- Two CLI surfaces emerged: `shop-msg` (catalog messaging) and `scenarios` (hash
  + verify).
- Production code shells out at every package boundary:
  - `shop-msg-bc/cli.py` invokes `scenarios hash` via subprocess to compute
    canonical hashes (S12; verified in S12 Reviewer probe).
  - The harness invoked `scenarios hash` via subprocess for every emit-sN
    block before its retirement.
  - Test code (e.g., `shop-msg-bc/tests/conftest.py`) imports both `catalog`
    and uses `subprocess` to invoke `shop-msg` and `scenarios` for setup.

The boundary rule was tested adversarially in S12 (the Reviewer probed whether
shelling out vs importing was defensible). The answer was: shelling out keeps
the boundary observable; a regression where production code started importing
internal functions would be a real bug, caught by the next person reading the
code.

**Sub-finding (from `shop-system-package-boundaries` memory, established in
slice A):** message-related concerns (catalog schemas, transport, wire format)
and scenario-related concerns (canonicalization, hash discipline, tag rules) are
SEPARATE concerns. Messages CARRY scenarios; messages don't DEFINE what a
scenario is. The catalog package and scenarios package are independent.
`ScenarioPayload` lives in `catalog` because it is a wire shape; the
canonicalization rule lives in `scenarios` because it is about scenario
semantics. The CLI is the integration point.

**Caveats.**
- The dogfooding rule is enforced by convention, not by tooling. A linter or
  test that fails when `from scenarios.hash import ...` appears in a `cli.py`
  would automate it. None exists.
- Performance impact of shelling out is real but tolerable at prototype scale
  (every emit-sN spawned a `scenarios hash` subprocess; the slice runtime
  was dominated by subagent dispatch, not subprocess overhead).

**Implication for spec.** §6 (or a new packaging section) should state that
shop-system implementations SHOULD treat package CLIs as the integration
boundary and avoid cross-package imports in production code. This rule
supports the spec's BC-as-boundary principle by making the discipline
observable at the file level: anyone reviewing `cli.py` can see whether
the boundary is being honored.

---

## 7. Dogfooding closes the loop on the system itself

**Claim.** A shop system whose internal tooling is built using its own
mechanism is more honest about whether the mechanism works than one where
the tooling is hand-built. By S14 every step of a §4.4 round trip ran via
the dogfooded CLI — including using `shop-msg read outbox` to validate the
final sign-off of the slice that introduced `shop-msg read outbox`.

**Evidence.**
- S6 bootstrapped a second BC (`shop-msg-bc`) whose CLI tool's purpose was
  to eliminate filesystem path inconsistencies in role-template usage. That
  BC's first command's collision contract was itself flagged by the Reviewer
  as ambiguous, escalated as `clarify`, and tightened in S7 — the system
  surfaced a gap in the tool it was producing, AGAINST its own purpose.
- S13 was the first slice deposited via `shop-msg send assign_scenarios`
  rather than via a `harness.py` `emit-sN` block. The lead used the CLI
  to drive its own slice.
- S14 used `shop-msg send assign_scenarios`, `shop-msg send request_bugfix`,
  and `shop-msg read outbox` (all CLIs of the system under test) to drive
  every step of the slice that introduced the read CLI itself.

**Caveats.**
- Dogfooding requires that the tooling reach a baseline of capability before
  it can be used to drive its own evolution. The first 9 slices used
  `harness.py` as a hand-built lead because the CLI didn't exist yet. A
  cleanly-structured prototype starting from this baseline would skip that
  bootstrap.
- The "lead" in this prototype is me (Claude as driver-orchestrator), not
  a dispatched subagent. A future prototype where the lead is also a
  subagent would test whether the dogfooding principle survives one more
  level of indirection.

**Implication for spec.** Implementations of the shop system SHOULD use their
own message catalog and CLI surface for all internal operations, not just
for the work the BCs produce. This is a discipline, not a property — easy
to miss if the temptation arises to "just bypass for this one case."

---

## 8. What is NOT yet validated

**Items the prototype either deferred or did not surface.** Listing here so
the next prototype can pick up cleanly:

- **`request_shop_card` and `request_scenario_register` schemas.** Pattern
  proven (Finding 1), specific shapes deferred. P3 issues 6mk and r7u closed
  on 2026-05-10 with reasoning.
- **Lead-side sufficiency check (formal pattern guard).** P3 issue sgh closed
  with mitigation (bd memory `shop-system-message-type-selection`). A
  prototype where the lead is also a subagent would need a formal
  `lead_subagent_prompt.md` parallel to the BC versions.
- **Lead-shop tracking artifacts.** Domain & Context Map (5p8), scenario-to-BC
  assignment register (yun) — closed-as-reframed; these are lead-shop
  concerns the prototype's driver-orchestrator lead didn't need.
- **Multi-pass review loops.** The prototype validated single-pass §4.4
  closures. Cases where the Reviewer rejects the Implementer's work and
  the Implementer iterates were not exercised.
- **`work_done(blocked)` (implementation-gap) outcome branch.** Documented
  in `bc_reviewer_prompt.md` but not surfaced by any slice's natural flow.
- **Cross-BC scenarios.** All slices targeted a single BC at a time. A
  scenario where the lead's request implies coordinated changes across two
  or more BCs is unvalidated.
- **Cross-session §4.4.** All three closures happened within a single
  driving session. The transport mechanism allows asynchronous round trips
  in principle.
- **Hash↔body invariant constraint on `ScenarioPayload`.** Identified as the
  natural next schema-level constraint; deferred for design tension reasons
  (`catalog` would need to depend on `scenarios` or accept a callable).
- **Cross-shop `@bc:` tag ↔ dispatch-target consistency.** The `@bc:` tag in
  a `ScenarioPayload` could disagree with the BC the message is dispatched
  to. Single-BC dispatch can't catch this; lead-side logic could.
- **Transport beyond filesystem.** P4 issue 2tf. Not load-bearing for
  single-process work.

---

## 9. Implications for the next prototype

The next prototype should accept Findings 1–7 as starting conditions and pick
ONE or two of the unvalidated items as its target. Candidates, ordered by
how much they would teach:

1. **Multi-BC topology with cross-BC fan-out** (most generative). A lead
   request that implies coordinated changes in two BCs. Tests Findings 1, 6,
   and likely surfaces new findings about §4 and §5 the current prototype
   couldn't reach.
2. **Lead-shop scaffolding** (closes the symmetry gap). A prototype where
   the lead is also a subagent with its own role templates. Tests Findings
   2 and 5 from the previously-unobserved direction; would require
   formalizing the message-type-selection discriminator.
3. **`request_shop_card` + `request_scenario_register` validation**
   (closes catalog coverage). The two unexercised message types. Lower
   structural learning per slice but cleanest known scope.
4. **Cross-session §4.4** (validates async assumption). Run a §4.4 loop
   across a context-clear or process-restart boundary. Mechanically
   straightforward; mostly a "does the assumption I made hold?" probe.

The first option is the highest-information slice. The second is the most
architecturally interesting. The third is the safest shipping target. The
fourth is a quick probe that should run in any case before the next
prototype takes findings 1–7 too literally.

---

## How to use this document

When designing the next prototype:
- **Take the claims in §1–§7 as starting conditions.** They are validated.
  Don't re-validate; build on top.
- **Use §8 to scope the next prototype's target.** Pick one unvalidated
  item; let the slices stress-test it.
- **Use §9 as a rough priority ordering.** The list is opinionated;
  push back if the next product context says otherwise.

When updating the spec proper (`01-principles.md` through
`06-work-tracking.md`):
- Each "Implication for spec" subsection in §1–§7 names where in the spec
  the durable claim should land.
- Resist the temptation to copy the evidence sections verbatim into the
  spec — spec language is normative; evidence belongs here or in
  `prototypes/message-catalog-v1/runs/scenario-N/`.
