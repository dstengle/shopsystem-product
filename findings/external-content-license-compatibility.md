# External-content license-compatibility doctrine

License-compatibility diligence for any external content ingested into
shopsystem-product — skills, templates, code, docs, prompts, prose. Recorded
2026-07-13 (bead `lead-qa3t`, parent epic `lead-ac1f`). This is **doctrine to
record**, not a mechanism change: it establishes the rule and its rationale so a
realizing decision record can pin it. The operator decision this round is
**doctrine + ADR only** — no BC enforcement capability is dispatched. The
realizing decision is **ADR-061** (ADR-060 is taken by wire-hash
`ScenarioPayload` canonicalization); the Architect drafts ADR-061 from this
finding.

## The forcing incident

Operator-requested diligence ("the same diligence as the forge finding") on
`deanpeters/Product-Manager-Skills` found it licensed **CC-BY-NC-SA 4.0**
(Attribution + NonCommercial + ShareAlike). That license is **incompatible with
shopsystem-product's MIT** (© 2026 David Stenglein, confirmed in `LICENSE`) on
three independent grounds:

- **ShareAlike (SA)** forbids relicensing a derivative under MIT — a derivative
  must carry the same CC-BY-NC-SA terms, so it cannot be absorbed into an
  MIT repo.
- **NonCommercial (NC)** contradicts MIT's unrestricted commercial grant — MIT
  permits commercial use; NC prohibits it. The two cannot coexist in one
  distributed work.
- **Attribution (BY)** requires attribution that MIT does not, an added
  obligation on every downstream user.

Nineteen skills adapted from that source had been adopted and were
**reverted** — commit `a0d5cd6` (`feat(skills): adopt PM technique-skill group
… deanpeters`) reverted by `40102a2` (`revert(skills): remove all
deanpeters-derived PM skills — CC-BY-NC-SA incompatible with MIT`). The
contamination is already out of the tree; this finding records the doctrine that
would have caught it before adoption rather than after.

## The rule

**Any external-content ingestion — skills, templates, code, docs, prose — MUST
pass a license-compatibility check against the repo's MIT license BEFORE
adoption or commit.** The check runs at the ingestion boundary, not after the
content is already in the tree.

Incompatible license families (non-exhaustive, but these are the ones that
recur):

- **CC-\*-NC** (any NonCommercial Creative Commons variant) — contradicts MIT's
  commercial grant.
- **\*-SA** (any ShareAlike / copyleft-style term) — forbids MIT relicensing of
  derivatives.
- **GPL-family** (GPL / AGPL / LGPL where linkage triggers copyleft) — imposes
  copyleft obligations MIT cannot satisfy.

Permissive licenses that are MIT-compatible (MIT, BSD, Apache-2.0, CC0,
CC-BY with attribution honored) may be ingested, honoring their attribution and
notice requirements.

## The clean-room carve-out (methods vs. expression)

Copyright protects **expression, not method**. Product-management **methods and
frameworks** — Jobs-To-Be-Done (JTBD), Opportunity Solution Trees (OST), PESTEL,
MoSCoW, and their kin — are **ideas and processes, which are not copyrightable**.
What is copyrightable is a specific author's **expression** of them: their
wording, their file, their worked examples, their diagrams.

Therefore **clean-room authoring is MIT-safe**: authoring skill/template content
about JTBD, OST, PESTEL, MoSCoW, etc. **in one's own words from primary
framework sources** — not derived from, and not transcribed out of, any
incompatibly-licensed source files — produces original expression that is
shopsystem-product's own MIT-licensed work. The discriminator is the **source of
the expression**, not the subject matter:

- **Safe:** "I understand JTBD as a method and I write a skill describing it in
  my own words." The method is free; my expression is mine.
- **Not safe:** "I adapt deanpeters's JTBD skill file." The file is that
  author's expression under CC-BY-NC-SA; adapting it produces a derivative bound
  by SA + NC.

This carve-out is why the reverted PM skills can be **re-authored clean-room**
under MIT rather than abandoned — the frameworks were never the problem; the
adopted *files* were.

## Boundary and scope

- **Doctrine + ADR only this round.** No scenario-pinned BC capability and no
  enforcement dispatch. The rule lives as doctrine (this finding) and as a
  decision record (ADR-061). Mechanizing the check — wiring a
  license-compatibility gate into `create-bc`, a skill-adoption path, or any
  fork/ingest path — is a **future candidate**, deliberately not decided here.
- **Ingestion boundary, not audit.** The rule governs the moment content enters
  the tree. A retroactive corpus audit is out of scope.
- ADR-061 is the named realizing decision (NOT ADR-060, which is wire-hash
  `ScenarioPayload` canonicalization). The Architect owns the ADR-061 draft.

## Cross-references

- `LICENSE` — shopsystem-product MIT, © 2026 David Stenglein: the compatibility
  baseline every ingestion is checked against.
- Bead `lead-qa3t` (parent epic `lead-ac1f`) — the diligence request and the
  contamination record.
- Commits `a0d5cd6` → `40102a2` — the deanpeters CC-BY-NC-SA adoption and its
  revert; the forcing incident.
- ADR-061 (to be drafted by the Architect) — the realizing decision record for
  this doctrine.
