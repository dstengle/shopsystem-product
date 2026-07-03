# ADR-056 — Scenario files conform to an off-the-shelf-Gherkin + `@bc`/`@scenario_hash` schema enforced by `scenarios validate`; the in-file `@bc` tag becomes the authoritative owner and beads dispatch history is deauthorized for assignment (one-time backfill)

**Status:** draft (2026-07-03) — DESIGN ONLY, no dispatch. Authored under
epic `lead-vzxd`; blocks the DDD bounded-context review `lead-bh2m`.
**Tier:** system-global (per ADR-034/035 — governs a cross-BC contract:
where scenario-ownership truth lives and how every shop validates scenario
files. Not one BC's internals; not framework doctrine.)
**Authors:** dstengle, Claude (lead-architect)
**Anchored to:** ADR-018 (empirical verification is the contract/artifact
surface; no BC clone on the lead host), ADR-019 (canonicalization ownership
lives in the `scenarios` BC — there is exactly ONE canonical scenario-block
hash text and `scenarios` owns the rule; templates delegate), ADR-036 D3
(block-only canonicalization), ADR-042 (the `bc-emit work-done` wrapper is
the mechanically-enforced pre-emit gate; it already checks that
`work_done.scenario_hashes` match the committed `features/`), ADR-011
(bead↔message field mapping — the `dispatched_to_bc` /
`scenario_hashes_pinned` metadata this ADR deauthorizes for assignment),
ADR-005 (`bc-manifest.yaml` is the canonical BC registry).
**Anchored on (PDR):** PDR-011 (empirical verification is contract surface).

---

## Context

Two problems, one artifact surface.

**(1) Ownership is not on the artifact.** Today "which BC owns scenario X"
is recovered from **beads dispatch history** — each dispatch bead carries
metadata `dispatched_to_bc` + `scenario_hashes_pinned` (ADR-011). That is a
production-system ledger fact, not a product fact. The DDD review
(`lead-bh2m`) needs to read ownership *off the scenarios themselves*, and
ownership is a PRODUCT fact (which bounded context a behavior belongs to),
so it must live in the product artifact — the scenario file — not the ledger.

Measured pre-state (2026-07-03, artifact + `bd export` surface, ADR-018):

- Corpus: **562 scenarios** across **484 `.gherkin` files** under
  `features/` (via `scenarios list`, the authoritative per-scenario view).
- **Only ~29.5%** of scenarios (166/562) resolve to an owner by *exact
  block-only hash match* against the beads dispatch map (379 distinct
  pinned hashes, built from 182 dispatch beads: 66 `assign_scenarios` +
  116 `request_bugfix`). Adding existing in-file `@bc` tags (49) and
  work_id-comment→`dispatched_to_bc` inference (14) reaches only **40.7%**.
  **59.3% (333 scenarios) are not cleanly derivable from beads** and must
  be resolved by a supervised heuristic or marked `@bc:unassigned`.
- **213 of 379 (56%)** beads-pinned hashes no longer match ANY current
  scenario body — heavy drift/supersession. Beads is therefore an
  unreliable *ongoing* ownership oracle even for what it did record.
- Only **53 files** carry a real `@bc:` tag line today; `templates/` (225
  files) and the lead's own mirror are entirely untagged. Tag **absence**
  is the default state across ~431 files.

**(2) There is no schema and no validation, and there are TWO
canonicalizations in the shipped tool.** `scenarios` today offers
`hash / verify / list / count / titles / tags` — **no `validate`, no schema,
no tag enforcement, no create/modify**. Worse, empirical probing surfaced a
latent ADR-019 violation:

- The **parser path** (`scenarios list` / `scenarios count`) parses the
  Gherkin, extracts each scenario node, and hashes it **block-only,
  tag/comment/`Feature:`-insensitive**. It reproduces **100% (417/417)** of
  the embedded `@scenario_hash` tags in the corpus, with **zero
  mismatches**. This is the authoritative canonicalization.
- The **raw-stdin path** (`scenarios hash < text`) canonicalizes whatever
  literal text it is handed; it retains `@bc` and comment/`Feature:` lines
  as content and therefore **diverges** from the parser path whenever those
  are present. Example: `features/messaging/23-*.gherkin` →
  parser `266fbc83d32ad724` vs raw-block `5cb732540fec3c93`. The two agree
  only coincidentally (e.g. `templates/213`). The commonly-used recompute
  recipe `awk '/Scenario:/{p=1} p' FILE | scenarios hash` is therefore
  **unsafe** — it is right for `213` and wrong for `23`.

David additionally requires (this session): scenario files must be **real
ecosystem-valid Gherkin** (pass an off-the-shelf parser) with a proper
`Feature:` declaration and multiple scenarios grouped per file — today
**370/484 files have no `Feature:` line at all**, so they would be rejected
by any standard Gherkin parser.

## Considered alternatives

- **Keep beads authoritative, add a lookup tool.** Rejected: 56% hash drift
  makes beads unreliable ongoing; ownership is a product fact that belongs
  on the product artifact; and `lead-bh2m` cannot read the ledger as a
  product surface.
- **Directory = owner.** Rejected: directory name is not a BC name
  (`features/agent-vault-broker/` scenarios resolve to `shopsystem-templates`;
  `features/launcher-credentials/` holds `@bc:shopsystem-bc-launcher` tags),
  and two directories are genuinely mixed-owner (`templates/` leaks one
  `shopsystem-messaging` scenario; `scenario-journal/` splits
  scenarios/messaging). Directory is a useful *review hint*, never an
  authority.
- **Bespoke Gherkin dialect + our own hasher as the only validator.**
  Rejected per David: files must pass a standard off-the-shelf parser so the
  corpus stays ecosystem-portable.
- **Two canonicalizations, documented.** Rejected: ADR-019 mandates exactly
  one canonical hash text owned by `scenarios`. The raw-stdin divergence is
  a bug to close, not a feature to document.

---

## Decision

### D1 — Scenario-file SCHEMA (validated, enforced)

A conformant scenario file MUST satisfy ALL of:

1. **Off-the-shelf-Gherkin valid.** It parses cleanly under the pinned
   **official `@cucumber/gherkin`** parser (see D4 for why this one). This
   forces a `Feature:` declaration and well-formed structure — the corpus
   becomes ecosystem-valid Gherkin, not a bespoke dialect.
2. **Exactly one `Feature:`** per file, with one or more scenarios grouped
   under it.
3. **Every `Scenario` / `Scenario Outline` carries exactly one owner tag:**
   `@bc:<canonical-bc-name>` **or** the explicit sentinel `@bc:unassigned`.
   **Tag absence is a schema violation** — this is the core mandate. The
   owner tag is placed on the scenario (immediately above `Scenario:`), not
   on the `Feature:`, because a grouped file may hold scenarios of different
   owners (see D6). `<canonical-bc-name>` MUST be a known BC (D5).
4. **Every scenario carries exactly one `@scenario_hash:<16-hex>` tag** whose
   value equals the **parser (block-only) canonical hash** of that scenario
   (D3). This is the PO-authored pin; `scenarios validate` recomputes and
   confirms it.
5. **Canonicalization is block-only and tag/comment/`Feature:`-insensitive**
   (ADR-019 / ADR-036 D3): editing the `Feature:` line, adding/removing
   `@bc`/`@scenario_hash` tags, and inter-scenario blank lines/comments do
   NOT change any `@scenario_hash`. This is an *invariant the tool must
   uphold*, and it is **empirically verified today under the parser path**
   (D3 evidence).

### D2 — `scenarios validate` conformity contract

`scenarios validate <path...>` (net-new capability in the `scenarios` BC):

- Runs the pinned off-the-shelf Gherkin parser over each file; a parse error
  is a violation.
- Enforces schema rules D1.2–D1.4: exactly one `Feature:`; every scenario has
  exactly one `@bc:` owner tag (known BC or `unassigned`); every scenario has
  a `@scenario_hash` matching the recomputed **parser** hash.
- **Exit non-zero** on any violation.
- Emits **machine-readable JSON** (`--json`): a list of
  `{file, line, scenario_title, scenario_hash, bc, violations:[code,…]}`
  with stable violation codes (`E_NO_FEATURE`, `E_MULTI_FEATURE`,
  `E_MISSING_BC`, `E_MULTI_BC`, `E_UNKNOWN_BC`, `E_MISSING_HASH`,
  `E_HASH_MISMATCH`, `E_GHERKIN_PARSE`). Human-readable default output too.

### D3 — ONE canonicalization; the parser path is authoritative; the raw-stdin divergence is a bug to close

Per ADR-019 there is exactly one canonical scenario-block hash text. It is
the **parser path** used by `scenarios list`/`count`, verified to reproduce
100% of the corpus's embedded `@scenario_hash` tags. `scenarios validate`
MUST compute hashes via this parser path — never via the tag-sensitive
raw-stdin path. As a same-BC tool fix, **`scenarios hash` MUST be
reconciled** to parse-then-hash (so raw and parser paths cannot disagree),
or be scoped to a single already-parsed scenario block; the current
"`awk … | scenarios hash`" recompute recipe is deprecated. This closes the
slice-16-class "two inputs to canonicalization" hazard on the artifact
surface.

### D4 — Off-the-shelf parser choice

Pin the **official `@cucumber/gherkin`** parser (the reference
implementation maintained by the Cucumber project) as the conformance
oracle, over `gherkin-lint` (unmaintained; style-lint scope, not a
spec-parser). Rationale: `@cucumber/gherkin` is the canonical spec parser,
tracks the Gherkin grammar itself, is multi-language, and gives an
authoritative parse/AST we can layer our extra rules on. `scenarios
validate` = run `@cucumber/gherkin` for structural validity, then apply our
extra rules (D1.2–D1.4) over its AST + tag scan. The `scenarios` BC vendors
or shells the pinned parser version; the version is pinned so validation is
deterministic across shops.

### D5 — Known-BC set = `bc-manifest.yaml`; reconcile the drift

The set of legal `@bc:<name>` values is the canonical registry
`bc-manifest.yaml` (ADR-005), plus the sentinel `@bc:unassigned`. Pre-state
drift to fix as part of this work: dispatch history references BCs **absent
from the manifest** — `shopsystem-bc-launcher-dagger`,
`shopsystem-agent-vault-broker`, and throwaway spike names (`fabro-e2e*`).
Before backfill, the manifest MUST be reconciled (add the real BCs; the
spike names never become owners). `E_UNKNOWN_BC` fires on any `@bc` value not
in the reconciled manifest.

### D6 — Owner tag is per-scenario; the "what is a feature" grouping is a PRODUCT decision (defer to David / `lead-bh2m`)

The owner tag is mandatory **per scenario** (not per `Feature:`) so that a
grouped file can legally contain scenarios of different owners. The
definition of *what constitutes a feature* — i.e. which scenarios group into
one file during structural consolidation (D7) — is a product-judgment call
that connects directly to the DDD feature-clustering under `lead-bh2m`. This
ADR does NOT decide it; it names it as a David decision. Candidate grouping
strategies (recommend deciding in `lead-bh2m`): (a) existing Feature-wrapped
precedent (33 files already multi-scenario); (b) `@bc` + topic cluster;
(c) numbered-file clustering. Recommended interim: group by existing
directory/topic while preserving per-scenario `@bc`, so consolidation is
hash-preserving and owner-safe regardless of the final DDD clustering.

### D7 — Source-of-truth CUTOVER (one-time migration)

1. **Backfill is a ONE-TIME migration** from beads dispatch history → in-file
   `@bc` tags. After cutover, **the in-file `@bc` tag is authoritative for
   scenario ownership**, and **beads `dispatched_to_bc` /
   `scenario_hashes_pinned` are DEAUTHORIZED for assignment** (they remain a
   historical dispatch/audit record only).
2. Backfill resolution is **supervised**, three tiers:
   - **Authoritative** (auto-tag): exact block-only hash match to a single
     BC in the dispatch map (166 scenarios) + existing in-file `@bc` tags
     (49). ~38%.
   - **Review-queue** (propose, human-confirm): directory-pure /
     work_id-comment heuristics for the residual in pure directories.
     Presented as a diff, never silently applied — mixed dirs (`templates`
     leak, `scenario-journal`) and dir-name≠BC cases (`agent-vault-broker`,
     `launcher-credentials`) force human review.
   - **`@bc:unassigned`** (explicit sentinel): anything still underivable.
     Grep-able backlog; every such scenario satisfies the "no tag absence"
     mandate while flagging owed product judgment.
3. **Consumers repoint** off beads onto the tag at cutover (see Consequences).

### D8 — Enforcement guard (no regression after cutover)

`scenarios validate` wires into the **`bc-emit work-done` gate** (ADR-042,
rendered by `shopsystem-templates` into `bc-reviewer`/`bc-implementer`) and
into CI, so no scenario file can merge/emit with a missing/absent `@bc`,
missing/mismatched `@scenario_hash`, or non-off-the-shelf-valid Gherkin. The
ADR-042 wrapper already checks hash-match; this extends it to schema + tag
validity. The role-template gate edits are owned by the `shopsystem-templates`
BC.

---

## Consequences

**Owner-reader consumers that must repoint beads → tag at cutover:**

1. **lead-architect pre-state `@scenario_hash` enumeration** — reads ownership
   from the in-file `@bc` tag instead of inferring from dispatch history.
2. **Reconciliation** (router standing rule + lead-architect) — the "assigned
   owner" cross-check reads the tag; beads becomes audit-only.
3. **Scenario-to-BC assignment / assign-per-structurizr** — the tag is the
   per-scenario owner of record.
4. **`request_scenario_register` / lead-mirror import** — imported scenarios
   carry/receive their `@bc` tag (this vehicle stays VISIBILITY-only; it was
   never a universal-tagging mechanism — see design doc A.iii).
5. **`bc-emit work-done` gate (ADR-042) + `bc-reviewer`/`bc-implementer`
   templates** — enforcement point for D8 (owned by `shopsystem-templates`).
6. **DDD review `lead-bh2m`** — reads ownership off the tag (the blocked
   consumer this ADR unblocks).
7. **Scenario-completion journal (ADR-023/024/025, `scenarios` BC)** — keyed
   by hash; note the tag as the ownership dimension if it reports per-BC.

**Tooling:** `scenarios` gains `validate` (+ pinned off-the-shelf parser) and
optionally a conformant-Gherkin `create`/`modify` surface (design doc C1
weighs the tradeoff). `scenarios hash` is reconciled to the single
canonicalization (D3).

**Migration is hash-preserving.** Structural consolidation (Feature header +
grouping + tag backfill + inter-scenario comments/blanks) does NOT invalidate
any `@scenario_hash` under the parser path — verified empirically (design doc
B). No re-pin cascade, no beads-dispatch invalidation from the edits.
