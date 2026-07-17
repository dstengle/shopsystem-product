---
type: brief
id: brief-024
title: Migrate the ~119-file legacy artifact corpus forward into the modern typed-artifact system
status: draft
created: 2026-07-17
updated: 2026-07-17
authors: ["David Stenglein (product authority)", "Claude (lead-po)"]
description: Shape-first brief pinning the spec for migrating this repo's ~119 pre-modernization pdr/adr/brief files (bold-label statuses, no frontmatter, numeric-slug filenames) forward onto the modern typed-artifact system (PDR-032/ADR-059) so the knowledge coherence gate — correct as built — runs green over the real corpus. This is cand-005's promoted Phase 5.
derives-from: [cand-005, intent-007]
---

## Summary

### Problem / why now — the reframe

This repo carries ~119 legacy artifact files — **33 in `pdr/`, 63 in `adr/`,
23 in `briefs/`** (counts verified 2026-07-17) — authored before the modern
typed-artifact system (PDR-032 / ADR-059) existed. Every one of them (with a
single exception, below) uses the pre-modernization conventions: no YAML
frontmatter, a bold-label `**Status:** accepted (2026-06-10)` header, and a
numeric-slug `NNN-slug.md` filename. Running `shop-knowledge validate` over
them fails 100% (`lead-6n4j6`), and `shop-knowledge-gate` cannot see them as
typed artifacts at all.

The load-bearing correction this brief records: **the tool is correct as
built; the corpus is what is stale.** The earlier direction — teach the
knowledge loader to *tolerate* legacy structure (originating in `lead-cea24`'s
framing) — is now reframed by the product authority as a **mis-diagnosis**.
The coherence-gate CLI, its loader, and the eight typedefs are all
correct-as-designed against the modern layout; bending them to accept legacy
prose would re-introduce exactly the dual-format drift PDR-032/ADR-059 exist
to eliminate. The fix flows the other way: **migrate the corpus forward** to
the spec the tool already enforces. PDR-032 §49 already intended frontmatter
for briefs/PDRs/ADRs; the corpus simply never caught up.

Two product-authority decisions are already locked and are **not** re-opened
here: **(a)** fully rename directories AND files to the new spec, accepting
the cross-link ripple; **(b)** shape-first — pin the spec in this brief before
any file is touched. This brief is (b).

### The pinned target spec (the acceptance target)

Empirically verified by the Architect against `shopsystem-knowledge`
`@69dd0cd`; this brief builds on it rather than re-deriving it. A migrated
corpus is "done" when it matches this spec and the gate runs green over it.

| Dimension | Target |
|---|---|
| **Tool** | `shop-knowledge` (`template`/`schema`/`validate`) + `shop-knowledge-gate <root> [--mode authoring\|distribution]`. All 8 types recognized; **pdr/adr/brief typedefs already exist and are correct — no prerequisite BC dispatch to define types.** |
| **Target dirs** (loader walks PLURAL) | `pdr/` → **`pdrs/`**, `adr/` → **`adrs/`**, `briefs/` already correct (files still migrate). Proven: a typed file dangles in singular `pdr/`, resolves in `pdrs/`. |
| **id patterns** | `pdr-NNN` / `adr-NNN` / `brief-NNN` (3+ digits). |
| **Filenames** | `<id>.md` — e.g. `pdrs/pdr-032.md`, `adrs/adr-059.md`, `briefs/brief-023.md`. |
| **Required frontmatter** | shared 8: `type, id, title, status, created, updated, authors, description` — PLUS per-type: pdr → `+decision-makers, derives-from`; adr → `+derives-from` (**MUST be non-empty**); brief → `+derives-from`. |
| **Required body sections** | pdr → Context / Options considered / Decision / Consequences; adr → Context / Decision / Consequences; brief → Summary / Scope. (Extra sections are tolerated — verified: an ADR with an added `## Provenance` section still validates `conforming`.) |
| **Status enums** (membership only; no transition graph — `validate` checks enum membership) | pdr/adr → `proposed, accepted, superseded, rejected`; brief → `draft, ready, delivered, withdrawn`. |
| **id-derivation** | loader keys on frontmatter `id:`, NOT filename — so adding frontmatter fixes id resolution regardless of filename (Bug 2 dissolves); the `<id>.md` rename is still performed per decision (a). |

Empirically re-confirmed while shaping this brief: an `adr` with
`derives-from: []` validates **non-conforming** ("requires at least one
anchor"); a `brief`/`pdr` tolerates it — so RISK 1 below is a real, hard gate,
not a hypothetical.

### The status-label → enum mapping (defined here)

Every legacy `**Status:**` line becomes the **bare enum member only**; all
date, ratifier, amendment, `rev-N`, `as amended`, and trailing `—` prose is
**stripped from the status field** and relocated to the preserved-provenance
body section (RISK 2). Mapping rules, derived from the actual distinct legacy
values in the corpus:

**pdr / adr** (target enum `proposed, accepted, superseded, rejected`):

- `accepted` / `Accepted` (with any `(date)`, `(ratified by X, date)`,
  `as amended`, `rev-N`, or trailing clause) → **`accepted`**
- `decided` → **`accepted`** (a decision was ratified)
- `proposed` / `Proposed` → **`proposed`**
- `draft` → **`proposed`** — the modern pdr/adr enum has **no `draft`
  member**; a not-yet-accepted decision is `proposed`. This is the one
  semantically lossy mapping and is called out explicitly.
- body/prose indicating the decision was superseded / retired / replaced →
  **`superseded`**; rejected / declined / abandoned → **`rejected`** (none
  observed in the current sample, rule included for completeness).

**brief** (target enum `draft, ready, delivered, withdrawn`):

- `draft` (with `, narrowed`, `, intent gaps resolved`, `(date)`) →
  **`draft`**
- `committed` → **`ready`**
- `ready for architect dispatch` → **`ready`**
- prose indicating dispatched-and-landed → **`delivered`**; withdrawn /
  abandoned → **`withdrawn`** (applied only on clear evidence; default is to
  preserve the mapped `draft`/`ready` value).

### The two ratification decisions (framed for David)

**RISK 1 — adr `derives-from` is hard-required non-empty, but many of the 63
ADRs are foundational/root decisions with no natural upstream.** Empirically
confirmed a fatal gate for those files. Two options:

- **(i) Synthesize/assign an anchor per root ADR** — keeps migration purely
  lead-side, but fabricates artificial provenance edges: a false upstream on
  a decision that genuinely has none.
- **(ii) Dispatch `shopsystem-knowledge`** (`request_bugfix` /
  `assign_scenarios`) to allow empty `derives-from` for root ADRs — e.g. a
  `root: true` exemption — a dependency the migration sequences around.

**Recommendation → (ii), the typedef exemption.** This whole cand-005 arc
exists to stop the corpus from carrying *false machine-readable claims*
(brief-023 §8: fabricating false edges "would NOT satisfy the stakeholder").
Synthesizing artificial `derives-from` edges is precisely that failure mode,
just inverted. A `root: true` exemption keeps the corpus honest at the cost of
one knowledge-BC dispatch that the migration sequences behind. **Needs David's
ratification.** (Second-best fallback if David wants zero BC dependency: point
every root ADR at one real, explicitly-authored "foundational decisions
predate typed provenance" anchor ADR — still a synthetic edge, but a single
honest sentinel rather than dozens of invented lineages.)

**RISK 2 — provenance loss.** Legacy bold-labels carry
ratifier/date/amendment/refined-by prose with no modern frontmatter home (the
schema has no changelog/decision-record fields). Two options:

- **(i) Preserve the stripped prose in a body section** (e.g. a
  `## Provenance (pre-modernization)` section on each migrated file).
- **(ii) Dispatch the knowledge BC** to enrich the typedef with structured
  provenance fields.

**Recommendation → (i), preserve-in-body.** Verified validate-safe (extra
sections conform). It is loss-free, lead-side, and unblocks migrating 119
files without a second BC dependency. Enriching the typedef (ii) is a
legitimate later improvement if structured provenance querying is ever wanted
— it should not gate this migration. **Needs David's ratification.**

### Relationship to cand-005 and lead-cea24

This brief is **cand-005 Phase 5** ("Migrate the legacy corpus"), promoted to
its own brief now that Phases 1–3 have landed and the tool it migrates onto is
verified correct-as-built. It derives from `cand-005` (→ `intent-007`).
`lead-cea24` — the P1 filed to make the gate *tolerate* legacy structure — is
now understood as a mis-diagnosis: its two "defects" (singular-dir mismatch,
numeric-slug id-derivation) are the corpus being stale, not the loader being
wrong. **Disposition: close `lead-cea24` as reframed once this migration
lands** and the gate runs green over the migrated corpus. (If any residual
loader robustness item survives — e.g. RISK 4's UTF-8 guard — it is tracked
separately, not under cea24.)

## Scope

### In scope

- The **119 legacy files** in `pdr/` (33), `adr/` (63), `briefs/` (23):
  directory rename, filename rename to `<id>.md`, frontmatter synthesis,
  status-label→enum mapping, provenance preservation.
- **All cross-link and edge-id rewrites** that the renames break — across all
  119 migrated files AND the already-modern typed files that reference legacy
  ids (RISK 3).
- The **gate-green acceptance check** over the migrated corpus.

### Explicitly out of scope

- **`pdr/034-*.md`** — already fully typed (`id: pdr-034`, real frontmatter).
  **Move it to `pdrs/pdr-034.md`; do NOT re-frontmatter it.** It is a rename
  target only.
- **Redesigning the schema, typedefs, status vocabulary, or lifecycle
  semantics** — this is a forward-migration onto the *existing* spec, not a
  spec change. (RISK 1 option (ii) and RISK 2 option (ii), IF ratified, are
  the only sanctioned typedef touches, and each is a scoped BC dispatch, not
  part of the lead-side migration mechanics.)
- **`intent/`, `candidates/`, `sessions/`, `current-state.md`** — already
  typed; any residual conformance gaps there are `lead-6n4j6`/brief-018
  territory, not this brief.
- **The `shop-knowledge-gate` UTF-8 guard** (RISK 4) — it throws on a
  non-UTF-8 file in a walked dir. Noted, not scoped here; if a non-UTF-8 file
  is hit during migration, track it separately.
- **CI/pre-commit changes** — `bin/check-knowledge-artifacts` (Phase 3)
  already warns-not-blocks on modified legacy files precisely so this
  migration can proceed; it needs no change here.

### Migration plan (the mechanics to execute, once shaped)

Ordered so each step's output is verifiable before the next:

1. **Create plural dirs** `pdrs/` and `adrs/`; `briefs/` already correct.
2. **Per-file forward migration** (all 118 non-exception files match
   `^NNN-slug.md`; clean extraction `NNN` → `<type>-NNN`):
   - synthesize YAML frontmatter — shared 8 + per-type required fields;
     `id` from the extracted `<type>-NNN`; `title` from the H1; `created`
     from the earliest legacy date, `updated` from the latest; `authors`
     from the ratifier prose where present else the legacy author;
     `description` a one-line synopsis;
   - **`status`** = the bare enum member per the mapping table above;
   - **`decision-makers`** (pdr) from ratifier prose; **`derives-from`** per
     the legacy cross-refs, subject to the RISK 1 decision for root ADRs;
   - **provenance** — relocate all stripped status prose (dates, ratifiers,
     amendments, refined-by) into a `## Provenance (pre-modernization)` body
     section (RISK 2 recommendation);
   - ensure the required body sections exist (map legacy headings; the modern
     required set is the floor, extras are tolerated).
3. **Rename** each file to `<id>.md` under its plural dir
   (`pdrs/pdr-032.md`, `adrs/adr-059.md`, `briefs/brief-023.md`), and move the
   `pdr/034` exception to `pdrs/pdr-034.md` untouched.
4. **Rewrite every cross-reference** broken by the renames (RISK 3):
   - **markdown relative links** — `[PDR-031](031-….md)`,
     `../adr/059-….md`, etc. → the new `../pdrs/pdr-031.md` / `pdr-031`
     forms;
   - **frontmatter edge id-lists** — `supersedes` / `superseded-by` /
     `depends-on` / `derives-from` / `incorporates` / `produced` — across all
     119 migrated files **and** the already-modern typed files that reference
     legacy ids (e.g. `current-state.md`'s `incorporates: [pdr-032, pdr-033,
     adr-059]`, `sessions/*`'s `produced` lists).
5. **Retire the old singular `pdr/` and `adr/` dirs** once empty.

### Gate-green acceptance check (definition of done)

The migration is accepted when, over the migrated corpus:

- **`shop-knowledge validate <file>` → `conforming` for every migrated file**
  (each of the 119, including `pdrs/pdr-034.md`).
- **`shop-knowledge-gate .` → 0 dangling edges** — every rewritten link and
  every frontmatter edge-id resolves to a real typed target; the two
  `lead-cea24` grounding cases (PDR-034's `supersedes:[pdr-032]`;
  current-state's `incorporates` list) now resolve as real edges rather than
  dangling/unverifiable-legacy.
- No status field carries date/qualifier prose; every `status` is a bare enum
  member of its type's enum.

### Can execution proceed lead-side only?

The migration mechanics (steps 1–5) are **all edits to the lead shop's own
artifacts** — no BC dispatch is intrinsically required to rename dirs, add
frontmatter, or rewrite links. **However, RISK 1 gates this:** if David
ratifies recommendation **(ii)** (the `root: true` typedef exemption), a
**`shopsystem-knowledge` dispatch must land first** and the migration
sequences behind it — because every root ADR would otherwise fail `validate`
on empty `derives-from`, and the gate-green acceptance check cannot pass. If
David instead chooses RISK 1 option **(i)** (synthesize anchors), execution is
purely lead-side with no BC dependency. RISK 2's recommendation (i) is
lead-side either way. So: **one ratification (RISK 1) determines whether a
knowledge-BC dispatch is a prerequisite; RISK 2 does not gate it.**
