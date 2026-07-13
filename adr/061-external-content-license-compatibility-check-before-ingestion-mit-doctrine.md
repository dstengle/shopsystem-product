# ADR-061 — External-content ingestion MUST pass an MIT-compatibility check BEFORE adoption or commit; copyleft/NonCommercial families (CC-\*-NC, \*-SA, GPL-family) are incompatible, and clean-room authoring from non-copyrightable frameworks is MIT-safe — doctrine only, BC enforcement explicitly deferred

**Status:** accepted (2026-07-13)
**Tier:** system-global (governs a cross-cutting per-product ingestion policy —
the license posture of everything that enters the shopsystem-product tree,
regardless of which BC or role does the ingesting — not one BC's internals).
Per [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md)
this home is the lead repo's `adr/` tree; per
[ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md)
this is the system-global tier of the three-tier hierarchy.
**Authors:** dstengle (operator directive — "doctrine + ADR only this round"),
Claude (lead-architect)
**Anchored to:** [ADR-018](018-empirical-verification-is-contract-surface.md)
(the pre-state for this decision is the contract/artifact surface — the
`LICENSE` file, the reverting commit pair, and the recorded finding — not any
BC-code execution).
**Realizes finding:** [`findings/external-content-license-compatibility.md`](../findings/external-content-license-compatibility.md).
**Related beads:** `lead-qa3t` (the diligence request and contamination record),
`lead-ac1f` (parent ingest epic).

## Context — the forcing incident

Operator-requested diligence ("the same diligence as the forge finding") on the
external source `deanpeters/Product-Manager-Skills` found it licensed
**CC-BY-NC-SA 4.0** (Attribution + NonCommercial + ShareAlike). That license is
**incompatible with shopsystem-product's MIT** (© 2026 David Stenglein,
confirmed in `LICENSE`) on three independent grounds:

- **ShareAlike (SA)** forbids relicensing a derivative under MIT — a derivative
  must carry the same CC-BY-NC-SA terms, so it cannot be absorbed into an MIT
  repo.
- **NonCommercial (NC)** contradicts MIT's unrestricted commercial grant — the
  two cannot coexist in one distributed work.
- **Attribution (BY)** imposes an attribution obligation MIT does not.

Nineteen skills adapted from that source had been adopted and were **reverted**:
commit `a0d5cd6` (adopt the deanpeters-derived PM technique-skill group) was
reverted by `40102a2` (remove all deanpeters-derived PM skills — CC-BY-NC-SA
incompatible with MIT). The contamination is already out of the tree; this
decision records the doctrine that would have caught it at the ingestion
boundary rather than after.

## Decision

**Any external-content ingestion — skills, templates, code, docs, prompts,
prose — MUST pass a license-compatibility check against the repo's MIT license
BEFORE adoption or commit.** The check runs at the ingestion boundary, not after
the content is already in the tree.

**D1 — Incompatible license families (rejected at the boundary).** These recur
and are incompatible with MIT:

- **CC-\*-NC** — any NonCommercial Creative Commons variant contradicts MIT's
  commercial grant.
- **\*-SA** — any ShareAlike / copyleft-style term forbids MIT relicensing of
  derivatives.
- **GPL-family** — GPL / AGPL / LGPL where linkage triggers copyleft imposes
  obligations MIT cannot satisfy.

**D2 — Compatible (permissive) families (ingestible, obligations honored).**
MIT, BSD, Apache-2.0, CC0, and CC-BY (attribution honored) may be ingested,
honoring their attribution and notice requirements.

**D3 — Clean-room carve-out (method vs. expression).** Copyright protects
**expression, not method**. Product-management methods and frameworks —
Jobs-To-Be-Done (JTBD), Opportunity Solution Trees (OST), PESTEL, MoSCoW, and
their kin — are **ideas and processes, which are not copyrightable**. What is
copyrightable is a specific author's expression: their wording, their file,
their worked examples, their diagrams. Therefore **clean-room authoring is
MIT-safe**: authoring skill/template content about those frameworks **in one's
own words from primary framework sources** — not derived from, and not
transcribed out of, any incompatibly-licensed source file — produces original
expression that is shopsystem-product's own MIT-licensed work. The
discriminator is the **source of the expression**, not the subject matter. This
is why the reverted PM skills can be re-authored clean-room under MIT rather
than abandoned: the frameworks were never the problem; the adopted *files*
were.

**D4 — Ingestion boundary, not retroactive audit.** The rule governs the moment
content enters the tree. A retroactive corpus audit is out of scope of this
decision.

## Alternatives considered

- **Mechanize the check now** (wire a license-compatibility gate into
  `create-bc`, a skill-adoption path, or any fork/ingest path). **Rejected this
  round** — the operator scoped this explicitly to **doctrine + ADR only**. A
  mechanized enforcement capability is a real future candidate but is a
  scenario-pinned BC dispatch, not a doctrine record, and pre-committing to a
  mechanism here would over-reach the operator's decision. See "Explicitly
  fenced as future" below.
- **Blanket-ban all Creative Commons and copyleft-adjacent content.**
  Rejected — over-broad. CC0 and CC-BY (with attribution honored) and permissive
  OSS licenses are MIT-compatible; banning them would needlessly foreclose
  legitimate reuse. The discriminator is compatibility, not license *family*
  name.
- **Abandon the reverted PM-skill subject matter entirely.** Rejected — conflates
  method with expression. D3's clean-room carve-out preserves the ability to
  re-author the same frameworks under original MIT-licensed expression.

## Explicitly fenced as future (NOT decided here)

**Mechanized BC enforcement of this policy is out of scope of this ADR.** Wiring
the compatibility check into `create-bc`, a skill-adoption path, or any
fork/ingest path — as a scenario-pinned BC capability — is a **future
candidate**, deliberately not decided here. The operator chose **doctrine-only**
this round. This ADR is the enforceable *statement of intent* against which a
later realizing dispatch, if the operator directs one, would be shaped.

## Consequences

- The doctrine is now citable at every ingestion boundary; a reviewer or author
  who is about to adopt external content has a decision record to check against
  and to cite when refusing incompatible content.
- The contamination is recorded with its revert pair (`a0d5cd6` → `40102a2`) so
  the forcing incident is auditable.
- Because enforcement is doctrine-only, adherence is currently **manual and
  cultural**, not gated — a known and accepted gap this round, tracked as a
  future candidate rather than an open defect.

## Cross-references

- [`findings/external-content-license-compatibility.md`](../findings/external-content-license-compatibility.md)
  — the realizing finding and its detailed rationale.
- `LICENSE` — shopsystem-product MIT, © 2026 David Stenglein: the compatibility
  baseline every ingestion is checked against.
- Commits `a0d5cd6` → `40102a2` — the deanpeters CC-BY-NC-SA adoption and its
  revert; the forcing incident.
- [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md),
  [ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md)
  — the system-global doctrine tier this ADR occupies.
- [ADR-018](018-empirical-verification-is-contract-surface.md) — the
  contract-surface pre-state rule this decision's evidence honors.
