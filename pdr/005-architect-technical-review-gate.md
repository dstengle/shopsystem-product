# PDR-005 — Architect technical review gate before dispatch

**Status:** draft (2026-05-20)
**Authors:** dstengle, Claude (lead-po)
**Anchored to:** two dispatch errors on 2026-05-20:
(1) `SHOP_MSG_DB_URL` used in scenarios 13-14 when pre-state verification
had already established `SHOPMSG_DSN` as the correct name (source:
`storage.py:62`); (2) `SHOPMSG_DSN` described as a "socket or volume"
in scenario 15 when it is an environment variable consumed over the
Docker network — dispatched without Architect reading the Then step.

## The question

Should the Architect review PO scenario content for technical accuracy
before dispatching, and if so, how? And should the PO be constrained
from naming specific technical artifacts in the first place?

Both errors shared the same structure: the PO named a technical artifact
without consulting the pre-state findings; the Architect dispatched
without checking the PO's text against those findings. The question is
whether to fix the PO side, the Architect side, or both.

## Context

The session's error sequence:

1. The Architect ran `storage.py:62` empirically and confirmed the env
   var name is `SHOPMSG_DSN`.
2. The PO authored scenarios 13-14 using `SHOP_MSG_DB_URL` — a name
   that was never in the pre-state findings.
3. The Architect dispatched scenarios 13-14 without cross-checking the
   env var name against the empirical finding.
4. The PO authored scenario 15 with a Then step describing `SHOPMSG_DSN`
   as a "socket or volume." `SHOPMSG_DSN` is a connection string env
   var; the BC reaches PostgreSQL over the Docker network. There is no
   socket mount.
5. The Architect dispatched scenario 15 without reading the Then step
   for technical plausibility.

Both errors were caught only after the BC emitted a clarify (scenario
15) or after the user noticed (scenarios 13-14). Each cost at least one
extra round trip.

The errors are symmetric: the PO introduced the wrong technical artifact;
the Architect failed to catch it. Fixing only one side of the contract
leaves the other side exposed.

## Options considered

### Option A — Architect pre-dispatch review step

Add a step to the Architect's `assign_scenarios` sufficiency check
requiring the Architect to read each scenario for steps that make
technical claims (env var names, mount types, command flags, protocol
mechanics, network topology) and verify each claim against pre-state
findings before dispatching.

**Pros:**
- Catches errors regardless of their origin; a single gate covers PO
  errors and the Architect's own analytical errors.
- No change to how the PO works. If the Architect's review is fast and
  accurate, the PO can write freely.
- The Architect is the natural checker: they did the pre-state
  verification and hold the findings.

**Cons:**
- The PO is still free to introduce unverified technical claims.
  Reviewing them adds Architect work that would not exist if the PO had
  avoided them. A bad PO habit is subsidized by Architect labor.
- If the Architect's review misses something (as it did this session),
  the error still ships. One gate, one point of failure.
- Does not shorten the feedback loop to the point where the error is
  first introduced.

### Option B — PO constraint: no unverified technical specifics

Add a constraint to the PO role template instructing the PO not to name
specific technical artifacts (env var names, port numbers, command
flags, protocol specifics, mount types) unless the Architect has
confirmed them. The PO uses placeholder language; the Architect fills in
verified values before dispatch.

Placeholder example: "the container receives the database connection
string via an environment variable whose name and value are confirmed in
pre-state" rather than "the container receives `SHOPMSG_DSN` set to
the database URL."

**Pros:**
- Eliminates the source of the error. A PO who does not name
  `SHOP_MSG_DB_URL` cannot introduce a wrong env var name.
- Forces the Architect to be the sole source of verified technical
  artifact names in final scenario text — consistent with the
  Architect's empirical pre-state role.
- Shorter feedback loop: the error is caught at the PO authoring step,
  not the Architect dispatch step.

**Cons:**
- Placeholder language in Then steps reduces scenario readability.
  Implementers work better with concrete artifact names.
- Increases PO→Architect coordination overhead. For every technical
  artifact a scenario references, the PO must wait for the Architect to
  supply the verified name before authoring is complete.
- The PO's sufficiency check already requires "each step is concrete
  enough to test." Placeholders conflict with that check unless the
  check is carved out for artifact names.

### Option C — Both A and B

Two-sided fix: the PO avoids unverified technical claims, and the
Architect reviews the scenario text against pre-state findings before
dispatching. Neither role is solely responsible.

**Pros:**
- Defense in depth. Two checkpoints catch errors that one misses.
- The PO constraint reduces the volume of technical claims that reach
  the Architect's review — less to check, less to miss.
- Preserves scenario concreteness: the Architect fills in verified
  artifact names at the review step, so final scenario text is concrete.
- Establishes the correct ownership: the PO owns scope and vocabulary
  for the *behavior*; the Architect owns vocabulary for the *technical
  artifact* that implements it.

**Cons:**
- More process. Two roles have new checklist items.
- PO→Architect handoff for artifact names adds a coordination step that
  did not exist before.

### Option D — Neither: accept clarify round trips

Accept that BC clarify-default posture handles under-specified or
technically wrong scenarios. The extra round trip is the system working
correctly. No role template amendment needed.

**Pros:**
- No process overhead. Roles stay as they are.
- The BC's clarify mechanism exists precisely to surface gaps; using it
  is not failure.

**Cons:**
- The errors were not under-specification; they were wrong facts. A
  clarify that corrects a factual error in a dispatched scenario costs
  more than just the round trip — the scenario register may need
  amendment, and the BC may have already begun work against an incorrect
  specification.
- Pre-state verification already produced the correct answer. Shipping
  the wrong answer anyway is not a gap in specification; it is a process
  failure that should have been caught before dispatch.
- "The system working correctly" absorbs costs that belong in the
  lead-shop process, not the BC's clarify mechanism.

## Decision

**Option C — Both A and B.**

### PO amendment

The PO MUST NOT name specific technical artifacts unless the Architect
has confirmed them. The test: if the PO did not derive the name from a
pre-state document the Architect shared, the PO must not use it. Use
behavioral placeholder language instead and note that the Architect
must fill in the verified name at dispatch time.

This is an extension of the existing "commit to specifics" posture, not
a contradiction of it. Committing to specifics means the PO specifies
the *behavior*; the Architect confirms the *artifact* that implements
it. The PO commits that a connection string is passed via an env var;
the Architect commits that the env var is named `SHOPMSG_DSN`.

### Architect amendment

The Architect's `assign_scenarios` sufficiency check MUST include an
explicit technical-accuracy scan before dispatch:

1. Read every scenario step that names or describes a technical artifact
   (env var, file path, port, command flag, mount type, protocol,
   network topology).
2. Cross-check each name against the pre-state findings for the target
   BC.
3. If a name is wrong or unverified, correct it in the scenario text
   (or flag it back to the PO) before dispatching. Do not dispatch with
   a known or suspected technical error in scenario text.

This is not an optional review; it is a gate. A scenario that fails the
technical-accuracy scan is not ready to dispatch.

## Rationale

The failures share a structural cause: the lead-shop process drew no
explicit boundary between "vocabulary for behavior" (PO territory) and
"vocabulary for technical artifacts" (Architect territory). Both roles
were implicitly permitted to use either kind of vocabulary without a
handoff. The errors resulted from the PO crossing into Architect
territory and the Architect not catching it.

Option C restores the correct ownership: the PO specifies behavior
in behavioral language; the Architect owns artifact vocabulary and
verifies it against empirical pre-state before dispatch. Neither role is
redundantly doing the other's job — they are doing complementary jobs
with a shared checkpoint.

Option D is rejected because the clarify mechanism is a contract-level
primitive designed for genuine under-specification, not for factual
errors that pre-state verification had already resolved. Using it for
the latter is a cost transfer from the lead-shop process to the BC's
work queue.

Option A alone is rejected because it subsidizes a PO habit (unverified
artifact naming) with Architect labor, and because the Architect gate
already failed once this session. A single gate, even a required one,
is a weaker guarantee than preventing the error from entering the gate.

Option B alone is rejected because placeholder language in final
scenario text is a readability problem for BC Implementers, and because
the Architect's review step is the natural place to fill in verified
names anyway — so the review step belongs in the process regardless.

## What this leaves open

1. **Template amendment text.** This PDR commits the decision; the
   Architect drafts the exact template amendment language for
   `lead-po.md` and `lead-architect.md` in `shopsystem-templates` as a
   follow-up `request_maintenance` dispatch. The amendment must be
   consistent with the PO's existing sufficiency check (particularly the
   "concrete enough to test" condition, which the PO constraint must
   carve out for unconfirmed artifact names).

2. **Scenario register correction.** Scenarios 13-14 may still carry the
   wrong env var name in the `shopsystem-devcontainer` scenario register.
   The Architect should verify and dispatch a `request_bugfix` if any
   dispatched scenario text contains `SHOP_MSG_DB_URL`.

3. **Placeholder vocabulary.** The PO constraint uses the phrase
   "behavioral placeholder language" without defining it. The Architect
   should draft a short vocabulary guide (three to five examples) as
   part of the template amendment so the PO has concrete models to
   follow.

## Cross-references

- [PDR-001](001-role-templates-role-complete.md) — role-complete
  restructure of `shopsystem-templates` role templates; the amendments
  committed here will be dispatched against the post-PDR-001 template
  surface.
- [PDR-002](002-lead-shop-roles-as-subagents.md) — subagent dispatch
  architecture; the PO and Architect role templates amended here are the
  ones loaded by the subagent definitions.
- [`features/devcontainer/`](../features/devcontainer/) — the scenario
  family where both errors occurred; the `SHOPMSG_DSN` finding is
  empirically established from `shopsystem-messaging:storage.py:62`.
