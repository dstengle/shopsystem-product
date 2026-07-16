# ADR-066 — Direct grant from Dean Peters (rights holder) authorizes MIT ingestion of deanpeters-derived PM skills, conditioned on attribution — resolves within ADR-061 D2, does not overturn ADR-061 D1

**Status:** accepted (2026-07-16)
**Tier:** system-global (governs a cross-cutting per-product ingestion policy —
the license posture of specific external content now permitted back into the
shopsystem-product tree — not one BC's internals). Per
[ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md)
this home is the lead repo's `adr/` tree; per
[ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md)
this is the system-global tier of the three-tier hierarchy.
**Authors:** dstengle (product authority — obtained and reported the direct
grant), Claude (lead-architect)
**Anchored to:** [ADR-018](018-empirical-verification-is-contract-surface.md)
(the pre-state for this decision is the contract/artifact surface — the prior
finding, the revert commit pair, the rights holder's own repository content
fetched live, and the product authority's report of the direct conversation —
not any BC-code execution).
**Operates within:** [ADR-061](061-external-content-license-compatibility-check-before-ingestion-mit-doctrine.md)
— this ADR does **not** overturn ADR-061. It records a new fact (a direct
grant from the rights holder) that changes which of ADR-061's own decision
branches (D1 vs. D2) governs this specific content, per the doctrine ADR-061
itself already lays out. See "Relationship to ADR-061" below.

## Context — the new fact

On or before 2026-07-16, the product authority (David Stenglein) spoke
directly with **Dean Peters**, the rights holder of
[`deanpeters/Product-Manager-Skills`](https://github.com/deanpeters/Product-Manager-Skills),
and obtained **explicit permission** to use the 19 previously-reverted PM
technique skills (plus the 20th, `workshop-facilitation`, which the revert's
own diff also removed — see "Correction to the revert's own tally" below),
conditioned only on **attribution**:

1. Credit **"Dean Peters"** by name.
2. Link his site: `https://www.linkedin.com/in/deanpeters/`.
3. Link the source repo: `https://github.com/deanpeters/Product-Manager-Skills`.

This is a **direct grant from the copyright holder**, distinct from and
superseding the default public CC-BY-NC-SA 4.0 license *for this specific
ingestion*. A rights holder may always grant broader permissions than their
default public license terms to a specific licensee for a specific use — that
is a standard and uncontroversial feature of copyright licensing, not a
reinterpretation of the CC-BY-NC-SA terms themselves. The public license
posture of the upstream repo is unaffected and unchanged (see "License
recheck" below); what changed is that shopsystem-product now holds an
*additional*, narrower permission that supersedes NC and SA for its own use
of this content.

## Decision

**The 20 deanpeters-derived PM skill directories removed by commit `40102a2`
are restored**, sourced verbatim from `40102a2~1` (pre-revert state,
equivalently `a0d5cd6`), **with upgraded attribution headers** reflecting the
direct grant, and with any references to now-stale artifact-schema section
names or status enums corrected against the current-correct typedefs (per
`cand-005` Phase 1, landed 2026-07-16 — see "Cross-check against Phase 1"
below). They remain **LOCAL / EXPERIMENTAL**, not promoted to canonical
`shopsystem-templates` pour status — restoration is not graduation; the
`lead-k9hh` LOCAL→CANONICAL graduation convention is unchanged and still
governs any future promotion.

### Relationship to ADR-061 — resolves within D2, does not overturn D1

ADR-061 already names the exact framework this fact resolves under. Its
decision already has:

- **D1** — incompatible license families rejected at the ingestion boundary,
  explicitly naming **CC-\*-NC** and **\*-SA** as recurring incompatible
  terms.
- **D2** — compatible (permissive) families ingestible, explicitly including
  **"CC-BY (attribution honored)"**.

The direct grant does not dispute that the public CC-BY-NC-SA 4.0 license —
taken alone — triggered D1 (NC contradicts MIT's commercial grant; SA forbids
MIT relicensing of derivatives). D1's finding was and remains **correct** for
the public-license case. What the direct grant does is **lift exactly the two
restrictions that caused the D1 rejection** — NonCommercial and ShareAlike —
for this specific ingestion, while Attribution (BY) is retained and honored.
Dropping NC and SA while keeping only BY converts the *operative terms
governing this content* to **CC-BY-equivalent**, which is precisely what D2
already lists as ingestible, "honoring their attribution and notice
requirements." This ADR is therefore an **application of D2 to a newly
CC-BY-equivalent grant**, not a reopening or reversal of D1's reasoning. D1
remains correctly-decided doctrine for any *other* CC-\*-NC or \*-SA content
that does not carry an equivalent direct grant.

### Attribution obligation — load-bearing, stated plainly

Every file or location carrying deanpeters-derived content **MUST** credit:

- **"Dean Peters"** by name,
- linked to `https://www.linkedin.com/in/deanpeters/`,
- and linked to `https://github.com/deanpeters/Product-Manager-Skills`.

This obligation is **specific to shopsystem-product's use** under the direct
grant reported here — it is not a blanket relicense of Dean Peters's work to
the public, and it is not retroactively binding on the upstream repo's other
users, who remain subject to the public CC-BY-NC-SA 4.0 terms.

**This is a real, load-bearing constraint that a fork must not lose.**
shopsystem-product is MIT-licensed, and MIT's own license text carries **no
attribution-forwarding mechanism** — an MIT `LICENSE` file does not
automatically propagate per-file attribution notices to a downstream fork the
way, say, a CC-BY license's own terms would. If this repo is ever forked or
redistributed, MIT alone does **not** carry the Dean Peters attribution
obligation forward — **only the attribution notices embedded directly in the
files themselves** (the upgraded `SKILL.md` headers this ADR installs, and
this ADR's own text) carry that obligation forward, by continuing to travel
with the files as ordinary file content. Anyone maintaining a fork of this
repo must not strip those in-file attribution lines under the mistaken
assumption that MIT alone settles provenance — doing so would silently
violate the terms the direct grant was conditioned on. This ADR is the
canonical place that states the constraint; the in-file headers are the
mechanism that enforces it in practice.

### Restoration inventory — correction to the revert's own tally

The task of restoring this content required checking `40102a2`'s diff
directly rather than trusting its commit message's count, per
[ADR-018](018-empirical-verification-is-contract-surface.md)'s discipline of
verifying against the artifact surface rather than an assertion. The revert
commit's message claims "**19 dirs**" removed ("the 15 technique skills from
`a0d5cd6`, plus `jobs-to-be-done`, `opportunity-solution-tree`,
`problem-framing-canvas`, `work-splitting`"). The commit's actual diff,
inspected directly (`git show --stat 40102a2`), shows **20 directories**
removed — the message's own enumeration omits `workshop-facilitation`
(a `SKILL.md`-only removal, one of the 15 originally adopted in `a0d5cd6`,
serving `option-tradeoff`), which the diff nonetheless deletes. This ADR
records the correction: **20 directories restored**, not 19. The commit
message's miscount is noted here so a future reader diffing "19" against a
directory listing of 20 does not conclude something was over-restored.

The 20 restored directories: `company-research`,
`derisk-measurement-advisor`, `discovery-interview-prep`,
`discovery-process`, `eol-message`, `incoming-request-advisor`,
`jobs-to-be-done`, `opportunity-solution-tree`, `pol-probe-advisor`,
`pol-probe`, `press-release`, `prioritization-advisor`,
`problem-framing-canvas`, `problem-statement`, `recommendation-canvas`,
`stakeholder-engagement-advisor`, `stakeholder-identification`,
`stakeholder-mapping`, `work-splitting`, `workshop-facilitation`.

### Cross-check against `cand-005` Phase 1 (landed 2026-07-16)

These skills were originally adapted 2026-07-10, before `cand-005` Phase 1
corrected the `intent-record`, `candidate`, and `session-record` typedefs'
real body-section structure and status enums (see `artifact-lifecycle.md`
and `features/shopsystem-knowledge/{intent_record_body_section_structure,
candidate_body_section_structure,session_record_id_and_body_structure}.feature`).
Checked directly against every restored file:

- Nearly all restored skills already used the **now-correct** section
  vocabulary for `intent record` (goal / non-goals / failure conditions) and
  `candidate` (problem / appetite / solution sketch / rabbit-holes / no-gos
  / evidence-experiments) — because these skills were written against real
  practice and existing candidate/intent-record instances, not against the
  broken generated-template placeholders ("Intent"/"Signals of success" for
  intent-record; "Context"/"Open questions" for candidate) that `cand-005`
  Phase 1 found and fixed. No drift found on this axis.
- One genuine drift found and corrected: `incoming-request-advisor/SKILL.md`
  and `discovery-interview-prep/SKILL.md` referenced the intent record's
  "open questions" — the real, now-pinned section name is **"Open threads"**
  (`intent_record_body_section_structure.feature`). Both files were corrected
  to say "Open threads" in place of "open questions" before commit.
- No restored skill referenced the old, since-corrected `shop-knowledge
  template <type>` output shape, the old `session-NNN` id pattern, or the
  old `Summary`/`Outcomes` session-record sections — none of the 20 files
  named the knowledge CLI or the session-record schema at that level of
  detail.

### License recheck (due diligence, not a blocker)

Rechecked 2026-07-16 whether the public license posture of
`deanpeters/Product-Manager-Skills` has itself changed since the 2026-07-10
finding — **irrelevant to whether the direct grant is valid** (a direct
grant from the rights holder stands regardless of the public license), but
worth recording as due diligence:

- The repo's own `LICENSE` file, fetched live, is unchanged: its first line
  reads "Attribution-NonCommercial-ShareAlike 4.0 International" — still
  CC-BY-NC-SA 4.0.
- GitHub's repository-metadata API (`GET /repos/deanpeters/Product-Manager-Skills`)
  reports `license.spdx_id: "NOASSERTION"` / `license.key: "other"`. This is
  a known quirk of GitHub's automated license detector, which frequently
  fails to classify Creative Commons licenses confidently (CC licenses are
  not in its primary matcher's trained set the way OSS code licenses are) —
  it is **not** evidence of an actual license change. The raw `LICENSE` file
  content is the authoritative signal here, and it is unchanged.
- **Finding: the public license posture is unchanged.** This ADR's authority
  to restore the content rests entirely on the direct grant, not on any
  shift in the public license.

## Alternatives considered

- **Treat the direct grant as reopening ADR-061 for general revision.**
  Rejected — ADR-061's doctrine (the MIT-compatibility check, D1's rejected
  families, D2's ingestible families, D3's clean-room carve-out) is unchanged
  and correctly governs every *other* future ingestion. Only the license
  family actually governing *this* specific content changed, which is a new
  ADR applying existing doctrine to a new fact, not a doctrine revision.
- **Re-author the skills clean-room under ADR-061 D3 instead of restoring
  verbatim.** Rejected as unnecessary now — D3 was the fallback path
  precisely because no permission existed; now that permission exists
  (attribution-conditioned), verbatim restoration with corrected attribution
  is both faster and more faithful to the source than a clean-room rewrite
  would be, and the grant's condition (attribution) is explicitly compatible
  with keeping the original expression.
- **Promote the restored skills to canonical `shopsystem-templates` pour
  status while restoring them.** Rejected — restoration is not graduation.
  The `lead-k9hh` LOCAL→CANONICAL convention (a skill graduates once pinned
  by a Gherkin scenario and dispatched to the `shopsystem-templates` BC)
  still governs; nothing in the direct grant changes that convention, and no
  such dispatch is part of this ADR's scope.

## Consequences

- The 20 skill directories are restored to `.claude/skills/`, LOCAL /
  EXPERIMENTAL, with attribution headers upgraded to name Dean Peters, link
  his LinkedIn, and link the source repo, per the grant's exact terms.
- `.claude/skills/README.md` is restored and its framing corrected from
  "removed, clean-room-only path forward" to "restored under direct grant,
  see ADR-066," citing this ADR.
- The attribution obligation is now doctrine, stated plainly: a fork of this
  MIT-licensed repo does not automatically carry the Dean Peters attribution
  forward via MIT's own terms — only the in-file attribution notices do, and
  they must not be stripped.
- `lead-k9hh`'s revert-driven closure and its "clean-room re-authoring is the
  only MIT-safe path" note are now superseded for this specific content by
  this ADR's direct-grant path; `lead-k9hh` itself is not reopened (it was
  correctly closed for its own scope at the time), but a future reader
  following its trail should land here.

## Cross-references

- [ADR-061](061-external-content-license-compatibility-check-before-ingestion-mit-doctrine.md)
  — the doctrine this ADR operates within (D1 rejection reasoning unchanged
  and correct for the public-license case; D2 is the branch this ADR's grant
  qualifies under).
- [`findings/external-content-license-compatibility.md`](../findings/external-content-license-compatibility.md)
  — the original finding this ADR's context section summarizes.
- Commits `a0d5cd6` (adoption) → `40102a2` (revert) → this ADR's restoration
  commit — the full lineage.
- `candidates/cand-005.md`, `artifact-lifecycle.md`,
  `features/shopsystem-knowledge/intent_record_body_section_structure.feature`,
  `features/shopsystem-knowledge/candidate_body_section_structure.feature`,
  `features/shopsystem-knowledge/session_record_id_and_body_structure.feature`
  — the corrected typedef structure the restored skills were cross-checked
  against.
- `lead-k9hh` (beads) — the original adoption/revert bead; superseded for
  this content by this ADR's direct-grant path, not reopened.
- [ADR-018](018-empirical-verification-is-contract-surface.md) — the
  contract-surface pre-state rule this decision's evidence honors (the
  revert diff was inspected directly rather than trusting its commit
  message's count; the upstream `LICENSE` file was fetched live rather than
  assumed unchanged).
