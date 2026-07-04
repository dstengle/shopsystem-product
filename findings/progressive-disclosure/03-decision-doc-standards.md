# 03 — Decision-doc standards: frontmatter/metadata schema prior art

**Research stream:** `decision-doc-standards` (epic lead-x7bp, progressive-disclosure)
**Date:** 2026-07-04
**Status:** COMPLETE — recommends a concrete required YAML frontmatter schema for our
artifacts, grounded field-by-field in MADR / adr-tools / Nygard / log4brains /
Structured MADR, with the L1/L2 split anchored to Diátaxis Reference-vs-Explanation.

---

## TL;DR

- The industry ADR frontmatter baseline is small and stable: **`status`, `date`,
  `decision-makers`** (MADR). log4brains adds **`tags`** + a `draft` status.
  Structured MADR extends to a full machine-readable set incl. **`title`,
  `description`, `type`, `category`, `tags`, `status`, `created`, `updated`,
  `related`**.
- **The DECISION statement lives in the BODY in every standard** — no standard
  puts the decision text in frontmatter. Diátaxis explains *why* this is the
  right cut: the decision is **Reference** (austere fact, for conformance), the
  context/alternatives/consequences are **Explanation** (for study/authoring).
  This maps *exactly* onto our L1 (Reference) vs L2 (Explanation) tiers.
- **Supersession is the recurring failure mode.** Nygard/adr-tools maintain
  bidirectional `Supersedes`/`Superseded by` links *by hand in prose*, and the
  documented anti-pattern is that teams update one side and forget the other.
  This is the direct justification for making `supersedes`/`superseded-by`
  **first-class structured fields checked by our coherence gate**.
- Structured MADR's JSON-LD / MIF / 3-conformance-tier / vendored-Ajv machinery
  is **overkill** for our ~100-doc corpus — take its field set and its
  "markdown stays canonical, derive the machine representation" principle; leave
  the enterprise-compliance apparatus.

---

## Sources consulted (with URLs)

- MADR home — https://adr.github.io/madr/
- MADR ADR-0013 "Use YAML front matter for meta-data" —
  https://adr.github.io/madr/decisions/0013-use-yaml-front-matter-for-meta-data.html
- MADR full template (raw) —
  https://raw.githubusercontent.com/adr/madr/main/template/adr-template.md
- MADR repo — https://github.com/adr/madr
- ozimmer "MADR Template Explained and Distilled" —
  https://ozimmer.ch/practices/2022/11/22/MADRTemplatePrimer.html
- Structured MADR repo — https://github.com/zircote/structured-madr
- Structured MADR SPECIFICATION.md (raw) —
  https://raw.githubusercontent.com/zircote/structured-madr/main/SPECIFICATION.md
- log4brains — https://github.com/thomvaill/log4brains ; ADR-0001 example —
  https://thomvaill.github.io/log4brains/adr/adr/20200924-use-markdown-architectural-decision-records/
- Nygard template — https://github.com/jamesmh/architecture_decision_record/blob/master/adr_template_by_michael_nygard.md
- adr-tools (npryce) `adr-new` / `-s` supersede flag —
  https://github.com/npryce/adr-tools/blob/master/src/adr-new
- ADR templates & operational patterns (Konishi) —
  https://hidekazu-konishi.com/entry/architecture_decision_records_templates_and_operations.html
- Diátaxis — https://diataxis.fr/ ; Explanation — https://diataxis.fr/explanation/

Internal grounding (this repo):
- `/workspace/adr/047-*.md:1-30` — current ADR head: prose `- Status: Accepted (date)`
  + `Implements:` / `Anchored on:` cross-refs in prose.
- `/workspace/adr/005-bc-manifest-in-lead-repo.md:1-5` — different style: `**Status:** Accepted` + `**Date:**` + `**Author:**`.
- `/workspace/pdr/016-*.md:1-14` — PDR head: `**Status:** draft (date)`, `**Authors:**`, `**Anchored to:**`, `**Synthesizes:**` all in prose.
- Corpus survey: 53 ADRs, ~30 PDRs. **Zero** currently use YAML frontmatter (the
  `^---` grep hits were Markdown horizontal rules, not frontmatter). Status lines
  are inconsistent: `**Status:** accepted (date)` vs `- Status: Accepted (date)`
  vs `**Status:** Accepted`. 28 files mention "supersed…" — **all in prose**, none
  as a structured field.

---

## (a) MADR — Markdown Any Decision Records

### Frontmatter (MADR ADR-0013)
MADR deliberately keeps frontmatter **minimal**. The canonical fields:

```yaml
---
status: "accepted"            # proposed | rejected | accepted | deprecated | … | superseded by ADR-0123
date: 2026-07-04              # YYYY-MM-DD, when the decision was last updated
decision-makers: [list]       # who decided
consulted: [list]             # SMEs consulted (two-way comms)
informed: [list]              # kept informed (one-way comms)
---
```

Rationale MADR gives for putting these in frontmatter rather than body (ADR-0013):
"shortens the body (essence of the ADR)", "tools can handle it more easily",
"indicates the lower importance of the data." Stated **disadvantage**: YAML
frontmatter "pretends to be more accurate than it can be" about the allowed
status values — i.e. an *enum discipline* problem MADR chose not to solve.
(source: adr.github.io/madr/decisions/0013)

### Status lifecycle (from the template comment)
`proposed | rejected | accepted | deprecated | … | superseded by ADR-0123`
— note supersession is expressed **inline inside the status string**, not as a
separate field. (source: raw template)

### Body sections (the L2 material)
`Context and Problem Statement` → `Decision Drivers` → `Considered Options` →
`Decision Outcome` (with `Consequences` good/bad, and an optional `Confirmation`
= how the decision is validated: tests, reviews) → `Pros and Cons of the Options`
→ `More Information` (evidence, related decisions, cross-refs). The **decision
itself lives in "Decision Outcome"**, in the body — never in frontmatter.
(source: raw template, ozimmer primer)

### Template variants
`adr-template.md` (full+explained), `-minimal` (mandatory only), `-bare`
(empty), `-bare-minimal`. Filenames `nnnn-title.md`; **the id is the filename
number**, not a frontmatter field. (source: github.com/adr/madr)

## (b) Other ADR metadata conventions

### Nygard (original) + adr-tools (npryce)
- Status values: **Proposed, Accepted, Deprecated, "Superseded by ADR-NNNN"**.
- Bidirectional supersession convention: mark the old ADR `Superseded by ADR-NNN`
  **and** add `Supersedes ADR-MMM` on the new one. adr-tools' `adr new -s NNN`
  automates *both* sides: inserts a Markdown link in the new ADR's Status section
  and rewrites the superseded ADR's status.
- **Documented anti-pattern:** "Most teams update one side of the supersession
  link and forget the other… reading old ADRs without forward references is one
  of the fastest ways to act on a decision the team has already reversed."
  (source: hidekazu-konishi.com; npryce/adr-tools `adr-new`)
- Nygard keeps status/supersedes **in the body's Status section**, not
  frontmatter — adr-tools is a pure-Markdown/no-frontmatter tradition.

### log4brains
- Uses MADR as its default template; therefore inherits `status`,
  `decision-makers`, `date`.
- **Adds a `tags` field** and a **`draft` status** (to enable collaborative
  writing before `proposed`/`accepted`).
- Immutability principle: **only the status of an ADR changes over time**; the
  record is otherwise immutable — you track evolution via status transitions +
  new superseding records, not by rewriting history. (source: log4brains docs,
  MADR ADR-0013)

### Structured MADR (zircote) — the machine-readable extreme
Directly on-point for our "machine+human index" goal. Required frontmatter:

| Field | Type | Enum / notes |
|---|---|---|
| `title` | string | — |
| `description` | string | one-line summary (our L0!) |
| `type` | string | `adr` |
| `category` | string | architecture/api/security/performance/infra/migration/integration/data/testing |
| `tags` | string[] | free tags |
| `status` | string | **`proposed`, `accepted`, `deprecated`, `superseded`** |
| `created` | date | ISO-8601 |
| `updated` | date | ISO-8601 |
| `author` | string | — |
| `project` | string | — |

Optional: `technologies[]`, `audience[]` (developers/architects/operators/
stakeholders), `related[]` (filenames of related ADRs).

Relationships: **no explicit `supersedes`/`depends-on`/`id` fields** — supersession
is only `status: superseded` + a prose "Related Decisions" body section + the
`related[]` array. Machinery: JSON Schema (Ajv2020) validation, JSON-LD "MIF"
objects derived from the markdown, **three conformance tiers**, a GitHub Action
validator, vendored schemas pinned via `VENDOR.lock`. Principle worth stealing:
**"structured-MADR markdown stays canonical" — the JSON is *derived*, never
authored.** (source: github.com/zircote/structured-madr + SPECIFICATION.md)

## (c) Diátaxis — where the decision maps (informs L1 vs L2)

Diátaxis splits docs into four needs: **tutorial, how-to, reference, explanation**.
Two are relevant to decision docs (both are "propositional knowledge", not action):

- **Reference** — "the technical description — facts — that a user needs in order
  to do things correctly: accurate, complete, reliable, **free of distraction and
  interpretation**." Austere, for lookup *during work*. (diataxis.fr)
- **Explanation** — "understanding-oriented"; holds **design decisions, historical
  reasons, technical constraints, alternatives, perspectives, connections**. For
  *study*, not immediate work. (diataxis.fr/explanation)

**The clean mapping (Diátaxis's own ADR example, confirmed on fetch):**

| ADR part | Diátaxis type | Our tier |
|---|---|---|
| one-line description | (index / Reference) | **L0** |
| the DECISION statement (+status/supersedes) | **Reference** — factual, for conformance | **L1** |
| context / alternatives / tradeoffs / consequences | **Explanation** — for authoring/study | **L2** |

This is the strongest theoretical result of the stream: **our L1/L2 split is not
arbitrary — it lands exactly on a documented cognitive boundary.** L1 is the
Reference face a conforming BC acts on; L2 is the Explanation face
lead-architect reads when *authoring* a new decision. Reference "states what is,
without interpretation"; Explanation "brings context." That is precisely
conform-vs-author.

---

## Recommended required YAML frontmatter schema for OUR artifacts

```yaml
---
id: ADR-047                    # stable machine key (DIVERGE from MADR — see below)
title: The system-manifest.yaml BOM mechanics
status: accepted               # enum: draft|proposed|accepted|rejected|deprecated|superseded
description: >-                 # ONE line — this IS L0
  A releases:-history BOM schema with a split advisory/blocking coherence gate.
decision: >-                    # the L1 conformance statement (see caveat: prefer body-anchored)
  system-manifest.yaml records a releases: history; the coherence gate is
  advisory on drift, blocking on supersede-conflict.
supersedes: []                 # list of ids this replaces        (structured, gate-checked)
superseded-by: null            # id that replaced this, or null   (structured, gate-checked)
depends-on: [PDR-030, ADR-005] # decisions this builds on         (structured DAG for the gate)
tags: [manifest, release, coherence-gate]
date: 2026-06-30               # ADD — universally supported, currently prose-only in our corpus
---
```

### Field-by-field grounding

| Field | Verdict | Grounding / divergence |
|---|---|---|
| `id` | **DIVERGE (justified)** | No standard has an id field (MADR/adr-tools use the filename number; Structured MADR none). We NEED it: our ids (`ADR-047`, `PDR-016`, bead `lead-x7bp`) already exist, flow into `shop-msg` as `work_id`, and L0 triage + the coherence-gate DAG need a stable key independent of filename renames. |
| `title` | **CONFIRM** | Structured MADR required field; MADR H1. |
| `status` | **CONFIRM** | Universal (MADR/Nygard/log4brains/Structured MADR). Adopt enum `draft\|proposed\|accepted\|rejected\|deprecated\|superseded`. `draft` from log4brains. **Fixes** our current inconsistent prose status lines. |
| `description` | **CONFIRM** | Structured MADR required "one-line summary" — this is literally our **L0** entry. Single-source it: L0 index = collected `description`s. |
| `decision` | **DIVERGE + CAVEAT** | No standard frontmatters the decision (all keep it in the body's "Decision Outcome"/Status). Our L1-distribution goal wants it machine-pullable. **Caveat/anti-drift:** do NOT duplicate a decision paragraph into YAML and again in the body — that re-creates the summary/full drift we are fighting. **Prefer:** a canonical `## Decision` body section that the generator EXTRACTS as L1 (single source), with an optional short `decision:` frontmatter line only where a one-sentence pin suffices. Diátaxis backs this: the decision is Reference-tier content. |
| `supersedes` / `superseded-by` | **DIVERGE (justified) — core of the gate** | Nygard/adr-tools do this bidirectionally but **in prose**, and the *documented* failure is one-sided updates. Structured MADR doesn't structure it at all. Making both first-class structured fields is exactly what lets the **coherence gate** verify bidirectional consistency and flag supersede-conflicts mechanically (the analogue of `scenarios --aggregate` / ADR-047's gate). This is a *feature*, not a divergence to apologize for. |
| `depends-on` | **DIVERGE-with-precedent** | Generalizes Structured MADR's `related[]` and MADR's "More Information" cross-refs into a directed edge. Our ADRs already say "Implements PDR-030 / Anchored on ADR-005" in prose (`/workspace/adr/047-*.md:3-9`) — `depends-on` just makes that a machine DAG the gate can walk. |
| `tags` | **CONFIRM** | log4brains addition + Structured MADR required. |
| `date` | **ADD (recommend)** | Target schema omits it, but date is universal (MADR/Nygard/adr-tools) and our corpus already carries it in prose status lines. Cheap, useful for the gate's "which of two conflicting actives is newer" tiebreak. Optionally add `updated` per Structured MADR (`created`/`updated`). |

### Fields we deliberately DON'T require
- `decision-makers`/`consulted`/`informed` (MADR), `author`/`project`
  (Structured MADR): optional at most. This is a lead shop with a known small
  author set; these add ceremony without serving the L0/L1/L2 or gate goals.
- `type`/`category` (Structured MADR): our artifact type is already the
  directory (`adr/` `pdr/` `brief/` `features/` `findings/`) + the `id` prefix.
  Fold any needed sub-classification into `tags`.

---

## Transferable mechanics

1. **Minimal-required, everything-else-optional** (MADR): keep the required set
   tight so authors actually fill it. Nine fields is already at the upper bound.
2. **Enum-discipline is the author's job the tool must enforce** (MADR's own
   stated weakness): a fixed `status` enum + a validator, or the field rots. Our
   coherence gate is that validator.
3. **Automate BOTH sides of supersession** (adr-tools `-s`): never rely on a
   human to update `supersedes` on the new doc AND `superseded-by` on the old.
   A `decisions supersede <old> --by <new>` command (sibling to `adr new -s`)
   should write both; the gate then only has to *verify* consistency.
4. **Markdown stays canonical; derive the rest** (Structured MADR): the `.md` +
   frontmatter is the ONE source. L0 index, L1 digest, and any JSON are
   GENERATED — this is the same single-sourcing lesson as the scenario-hash /
   gherkin-drift fight (the "nbx5 single-source precedent" in our plan).
5. **Immutable-except-status** (log4brains): supersession does not rewrite the
   old L2. Flip `status: superseded`, set `superseded-by`, keep the old document
   for provenance. The gate treats `superseded` docs as inactive.
6. **Split supersession OUT of the status string** (fixing MADR): MADR crams
   "superseded by ADR-0123" into `status`. That is not cleanly machine-parseable.
   Our separate `superseded-by` field is the right call for a gate.

## Anti-patterns / overkill flags

- **Duplicating the decision text into frontmatter.** Re-creates summary/full
  drift. Single-source it from a `## Decision` body anchor instead. (Flag: HIGH.)
- **Structured MADR's full apparatus** — JSON-LD/MIF objects, three conformance
  tiers, vendored Ajv schemas, `VENDOR.lock`. Built for enterprise audit/
  compliance at scale. For ~100 docs this is **overkill**: adopt the field set
  and the derive-don't-author principle; skip the JSON-LD/tier machinery. (Flag:
  MEDIUM — resist scope creep here.)
- **Supersession in prose only** (Nygard/adr-tools default, and our current
  state — 28 files, all prose). Guarantees the one-sided-update rot. Our whole
  reason to structure `supersedes`/`superseded-by`. (Flag: this is the bug we're
  fixing.)
- **Over-rich required metadata** (decision-makers/consulted/informed/author/
  project/category/technologies/audience): ceremony that doesn't serve L0/L1/L2
  or the gate. Push to optional. (Flag: LOW.)
- **Free-form status vocabulary** (our current `accepted`/`Accepted`/`draft`
  mixed casing): normalize to a lowercase enum or the gate can't reason about
  "active".

---

## What this means for OUR L0/L1/L2 + generated-index + coherence-gate goals

- **L0 = the `description` field, collected.** Directly supported (Structured
  MADR "description" is a required one-liner). The generated `llms.txt`/OKF index
  is just `id + title + description` per doc — nothing exotic needed.
- **L1 = the DECISION statement + `status`/`supersedes`/`superseded-by`.** This is
  Diátaxis **Reference** — the austere, interpretation-free face a conforming BC
  acts on. Generate it from a canonical `## Decision` body anchor plus the
  relationship frontmatter; distribute as the "decisions digest." Do NOT hand-
  author L1 separately (drift).
- **L2 = the full doc** (context/alternatives/consequences) — Diátaxis
  **Explanation**, lead-architect authoring surface, stays lead-only. No
  transformation needed; L2 *is* the source `.md`.
- **Generated index / single-sourcing:** every tier is a projection of the one
  frontmatter+body source. This is the exact anti-drift posture the repo already
  takes for scenarios (hash) and gherkin. Frontmatter is the machine face; the
  `## Decision` anchor is the L1 face; the whole file is L2.
- **Coherence gate:** the structured `status` + `supersedes` + `superseded-by` +
  `depends-on` fields give it everything it needs to be the ADR-047-style
  advisory/blocking gate:
  - **blocking:** bidirectional supersession inconsistency (A.superseded-by=B but
    B.supersedes omits A) — the documented adr-tools rot, now mechanically caught;
    a doc that is both `accepted` and `superseded-by` something; a `depends-on`
    edge to a `superseded`/`deprecated` (retired) decision; a `depends-on` cycle.
  - **advisory:** two `accepted` docs sharing tags whose decisions may conflict
    (heuristic flag for human review — the analogue of `scenarios --aggregate`'s
    soft coherence signal). `date`/`updated` gives the newer-of-two tiebreak.
- **The eventual `decisions` CLI** (sibling to `scenarios`, built BY a BC): needs
  `decisions validate` (frontmatter schema + enum), `decisions index`
  (L0/L1 generation), `decisions supersede <old> --by <new>` (writes both sides),
  and `decisions coherence` (the gate). All grounded above; none require the
  Structured-MADR JSON-LD tier.
