---
type: brief
id: brief-022
title: '`lead-po`/`lead-architect` corpus-wide scenario retrieval goes through the installed `scenarios` CLI''s own query commands, not ad-hoc grep'
status: draft
created: 2026-07-15
updated: 2026-07-17
authors: [David Stenglein (product authority), Claude (lead-po)]
description: Subagent retrieval against `features/` (this shop's scenario corpus) is
derives-from: [adr-056, adr-064, adr-018]
candidate: cand-003
---

## Summary

Subagent retrieval against `features/` (this shop's scenario corpus) is
currently unscoped, ad-hoc `Grep`/`Read`, with no directive to prefer the
corpus's own purpose-built query tool. This produced two concrete failures in
the same working session:

- Four wrong-path citations (cosmetic — the `@scenario_hash` tag, not the path,
  carries cross-repo identity, so hash-keyed reconciliation caught nothing wrong
  functionally).
- One real scope-verification gap: an architect dispatch enumerated conflicting
  `@scenario_hash` entries by grepping a single assumed file instead of the
  corpus, and missed a sibling file in the same directory that carried a real
  conflict (`lead-ifye3.6`/`lead-r2bsr`). It reached the BC only because that
  BC's own Implementer independently caught it.

Verified directly against the installed `scenarios` CLI's own source this
session (cand-003 Evidence): the tool's aggregate operations (`scenarios journal
rebuild`, which harvests every `@scenario_hash` tag via
`Path(features_dir).rglob("*.feature")`, and `scenarios validate --aggregate`,
which runs the corpus-consistency gate the same way) already scan the full tree
correctly — no path-shape assumption, no partial-scan defect. The gap is
exclusively that subagents reach for a hand-scoped `grep` instead of the tool
that already gets this right.

The job-to-be-done: when a PO or Architect subagent needs to know what exists,
what's owned by which BC, or what conflicts with a proposed change across the
whole `features/` corpus, it should run the installed `scenarios` CLI's own
corpus-wide query commands, so that "what exists" is answered by a tool whose
full-tree coverage is already correct, not by a hand-crafted `grep` whose scope
is only as good as the author's assumption about where the relevant file lives.

This brief argues for a prompt/role-definition-level change directing the two
lead subagents' corpus-wide scenario retrieval through the `scenarios` CLI's
aggregate commands. The observable behavior change — not the output (two edited
role-prompt sections) — is that a subagent's belief about "what exists in
`features/`" is produced by a tool with proven full-tree correctness, not by an
assumption about file location that has already been wrong five times in one
session:

- A `lead-architect` dispatch that retires, supersedes, or contradicts prior
  BC-side scenario coverage establishes its conflicting-hash enumeration via
  `scenarios journal rebuild` / `scenarios validate --aggregate` over the full
  `features/` tree — never via a `grep` scoped to one file the architect assumed
  was the only relevant one. A missed-sibling-file gap of the
  `lead-ifye3.6`/`lead-r2bsr` shape becomes structurally impossible via this
  path.
- A `lead-po` subagent about to author or sharpen a scenario establishes whether
  an equivalent or conflicting scenario already exists in the corpus the same
  way — via the `scenarios` CLI's corpus-wide commands — before writing new
  Gherkin, rather than trusting an ad-hoc grep's incidental scope.
- Plain `Grep`/`Read` remains available and correct for its narrower job:
  pulling the full text of a specific, already-identified scenario. This brief
  narrows *when* `Grep` is reached for, not whether it is ever used.

The pinned solution shape (from cand-003, not re-decided here) is cand-003's
element 1 — the well-understood, ready-to-ship half: the `lead-architect`
template's existing `@scenario_hash` conflict-enumeration discipline
(`features/shopsystem-templates/lead_architect_empirical_pre_state_contract_surface.feature`)
is extended to name the installed `scenarios` CLI's aggregate commands
(`scenarios journal rebuild`, `scenarios validate --aggregate`) as the required
mechanism for **any** corpus-wide scenario question — existence, ownership,
conflict enumeration — not only the retirement/supersede/contradict trigger the
existing scenarios already cover; a hand-scoped, single-file `Grep` is named as
insufficient for that job, while plain `Grep`/`Read` stays correct for reading a
specific, already-identified scenario's full text. The `lead-po` template gets
an analogous, new discipline: before authoring or sharpening a scenario, check
the corpus for an existing or conflicting scenario via the same `scenarios` CLI
commands, not ad-hoc grep. This is a prompt/role-definition-level change only —
the `scenarios` CLI itself is unchanged and already correct (cand-003 Evidence);
what changes is which tool the role prompt directs the subagent to reach for.

Load-bearing vocabulary: **Corpus-wide scenario question** — any question whose
answer requires knowing something about the *whole* `features/` tree: does a
hash exist anywhere live, which BC owns a given scenario, which scenarios
conflict with a proposed change (contrast with reading a single,
already-identified scenario's full text, which stays a `Grep`/`Read` job); **the
`scenarios` CLI's aggregate commands** — concretely `scenarios journal rebuild
<features_tree> <journal_file>` (harvests every `@scenario_hash` tag via a
full-tree `rglob`) and `scenarios validate --aggregate <dir>` (the adr-056 D8
corpus-consistency gate), both already-installed and already-correct per
cand-003's direct source verification, this brief adding no new CLI behavior;
**Hand-scoped grep** — a `Grep`/manual search invocation whose scope (file,
directory) is chosen by the subagent's own assumption rather than by a tool with
proven full-tree coverage — the failure mode this brief closes, not `Grep` as a
tool in general.

Strategic trace: this traces directly to intent-004 (stakeholder intent,
recorded 2026-07-14: "prompt adjustment to challenge citation sources and
validate that they are acceptable") and cand-003 (shaped and committed
2026-07-15 by the product authority, in direct response to this same session's
own incident record). intent-004's broader theme — subagent retrieval should be
provenance-and-tool-aware rather than relying on written-only rules and private
router memory — is only partially resolved here (the scenario-corpus half); this
brief is a concrete, narrow instance of that theme, following the exact
mechanical shape adr-064 already proved out earlier this same day.

What would NOT satisfy the stakeholder: adding a written rule that only says
"use the right tool" without naming the concrete commands (`scenarios journal
rebuild`, `scenarios validate --aggregate`) — the same vague-instruction failure
mode intent-004's Failure conditions section already names; banning `Grep`/`Read`
outright — this brief narrows *when* hand-scoped search is appropriate, it does
not remove a tool the roles legitimately need; silently treating this brief as
resolving `lead-r2bsr` without recording that call, or silently absorbing
`lead-xf7t4`'s or `lead-x7bp`'s scope; extending scope to the
knowledge/decision-record corpus without a recorded reason for either deferring
it or requesting a probe.

## Scope

**In scope** (pinned by the scenarios below):

- `lead-architect` template: corpus-wide scenario retrieval (existence,
  ownership, conflict enumeration) directed through the `scenarios` CLI's
  aggregate commands, generalizing the existing
  retirement/supersede/contradict-triggered enumeration discipline to any
  corpus-wide question.
- `lead-po` template: a new pre-authoring discipline directing the same
  tool-based check before authoring or sharpening a scenario.
- Both scenarios explicitly preserve plain `Grep`/`Read` for reading a specific,
  already-identified scenario's full text — this is not a ban on `Grep`, it is a
  scoping of when hand-crafted search is the right tool.

**Out of scope / explicit non-goals:**

- **The knowledge/decision-record corpus analog** (ADR/PDR/brief/finding
  retrieval via a `shopsystem-knowledge` query surface). Named in cand-003 as
  element 2, feasibility unconfirmed there. See Housekeeping for this brief's
  disposition.
- **Mechanical enforcement** (a gate that fails/flags retrieval that didn't go
  through the tool). cand-003's Rabbit holes names this as an open design
  question, not decided here — this brief ships the role-prompt-discipline shape
  only, the same shape adr-064 already used successfully for the
  retirement-convention fix.
- **Rebuilding progressive disclosure** (`lead-x7bp`'s territory) or a general
  N-corpus retrieval-scoping framework — cand-003's own No-gos, carried forward
  unchanged.
- **`lead-xf7t4`'s directory-flattening** — independent, unblocked by this
  brief, not re-litigated here.

**Dispatch target** (explicit, not left implicit): both scenarios target
**shopsystem-templates** (the BC that pours the `lead-po`/`lead-architect` role
templates — this shop's own doctrine, per intent-004's Constraints, forbids
hand-editing `.claude/agents/*.md` locally). Files already carry the concrete
`@bc:shopsystem-templates` tag (not the `@bc:unassigned` transitional marker)
because both extend/sit alongside already-`@bc:shopsystem-templates`-tagged
sibling scenarios in the same directory, so ownership is unambiguous at
authoring time — no Architect re-tagging needed, only pre-state verification and
dispatch.

- `features/shopsystem-templates/lead_architect_empirical_pre_state_contract_surface.feature`
  — one new scenario appended (the file's existing 5 scenarios are unchanged).
- `features/shopsystem-templates/lead_po_scenario_corpus_query_discipline.feature`
  — new file, one scenario.

**Pinned scenarios** (computed via the installed `scenarios hash` CLI with
block-only canonicalization, reproducing exactly via `scenarios list` against
the on-disk files; both files pass `scenarios validate` — verified before this
brief was written):

- `features/shopsystem-templates/lead_architect_empirical_pre_state_contract_surface.feature`
  — `@scenario_hash:b4795e33b958f6e2` — "lead-architect template directs
  corpus-wide scenario retrieval (existence, ownership, conflict enumeration)
  through the installed scenarios CLI's own aggregate commands, not a
  hand-scoped grep against an assumed file or directory."
- `features/shopsystem-templates/lead_po_scenario_corpus_query_discipline.feature`
  — `@scenario_hash:6161fd393e4662c6` — "lead-po template directs the PO to
  check scenario existence and ownership via the installed scenarios CLI before
  authoring or sharpening a scenario, not via ad-hoc grep."

**Housekeeping — the knowledge-corpus element (cand-003 element 2). Call: scope
this brief to element 1 only (scenario corpus, above). Element 2
(knowledge/decision-record corpus retrieval via a `shopsystem-knowledge` query
surface) is an explicit named follow-on, not requested for an Architect probe as
part of this brief's own preparation.** Reasoned, not silently dropped:

1. **The feasibility question is already answered, on the artifact surface,
   without needing a fresh probe.** Grepping every
   `features/shopsystem-knowledge/*.feature` file for a query/corpus-wide
   capability (this repo's own admissible adr-018 evidence surface, not BC
   source) surfaces exactly two candidates: `active_digest_generation.feature`
   and `distribution_boundary.feature`. Both describe an internal L1
   decision-digest generation/distribution mechanism for pouring accepted
   decisions to conforming BCs — not an externally-invokable query CLI a
   `lead-po`/`lead-architect` subagent could call for "does ADR-X exist," "who
   owns PDR-Y," "what conflicts with proposed decision Z." The nearest actual
   CLI candidate, `shop-knowledge template/schema/validate` (brief-019), is
   validation/template-only by its own pinned scope — not existence, ownership,
   or conflict enumeration — and its tracking bead `lead-5msa9` is still OPEN.
2. **Requesting a feasibility probe now would target a CLI that doesn't exist
   yet.** The only plausible extension point is `shop-knowledge` itself, which
   this repo has not yet built; an Architect probe today could only re-confirm
   finding (1). A probe that asks "should `shop-knowledge` grow query commands,
   and what shape" is a real design question, but premature until
   `shop-knowledge` exists to extend — sequencing it after `lead-5msa9` ships is
   the reasoned deferral, not indefinite silence.
3. **Recorded follow-on:** once `lead-5msa9`/brief-019 ships, an Architect
   feasibility probe on extending `shop-knowledge` with corpus-wide query
   commands (existence, ownership, conflict enumeration — the
   ADR/PDR/brief/finding analog of `scenarios journal rebuild`/`validate
   --aggregate`) is the correct next step, named here so it is not lost. Not
   filed as a blocking dependency of `lead-gg926` — this brief's element 1 ships
   independently of when/whether element 2 is picked up.

**On `lead-r2bsr`:** this brief's `lead-architect` scenario is offered as
satisfying `lead-r2bsr`'s ask at the mechanism level — stronger than what was
literally asked (a tool-based full-tree scan rather than an instruction to `grep
-r` correctly). The Architect confirms and closes/reconciles `lead-r2bsr`
against this brief's dispatch outcome at pre-state-verification time; this brief
does not itself close `lead-r2bsr`. **On `lead-xf7t4` and `lead-x7bp`:** both
confirmed distinct and non-duplicative — neither requires sequencing against
this brief.

## Source (pre-modernization)

#### 1. The problem

Subagent retrieval against `features/` (this shop's scenario corpus) is
currently unscoped, ad-hoc `Grep`/`Read`, with no directive to prefer the
corpus's own purpose-built query tool. This produced two concrete failures
in the same working session:

- Four wrong-path citations (cosmetic — the `@scenario_hash` tag, not the
  path, carries cross-repo identity, so hash-keyed reconciliation caught
  nothing wrong functionally).
- One real scope-verification gap: an architect dispatch enumerated
  conflicting `@scenario_hash` entries by grepping a single assumed file
  instead of the corpus, and missed a sibling file in the same directory
  that carried a real conflict (`lead-ifye3.6`/`lead-r2bsr`). Reached the BC
  only because that BC's own Implementer independently caught it.

Verified directly against the installed `scenarios` CLI's own source this
session (cand-003 Evidence): the tool's aggregate operations (`scenarios
journal rebuild`, which harvests every `@scenario_hash` tag via
`Path(features_dir).rglob("*.feature")`, and `scenarios validate
--aggregate`, which runs the corpus-consistency gate the same way) already
scan the full tree correctly — no path-shape assumption, no partial-scan
defect. The gap is exclusively that subagents reach for a hand-scoped `grep`
instead of the tool that already gets this right.

#### 2. The job-to-be-done

*When a PO or Architect subagent needs to know what exists, what's owned by
which BC, or what conflicts with a proposed change across the whole
`features/` corpus, I want it to run the installed `scenarios` CLI's own
corpus-wide query commands, so that "what exists" is answered by a tool
whose full-tree coverage is already correct, not by a hand-crafted `grep`
whose scope is only as good as the author's assumption about where the
relevant file lives.*

#### 3. The outcome (observable behavior change)

- A `lead-architect` dispatch that retires, supersedes, or contradicts
  prior BC-side scenario coverage establishes its conflicting-hash
  enumeration via `scenarios journal rebuild` / `scenarios validate
  --aggregate` over the full `features/` tree — never via a `grep` scoped
  to one file the architect assumed was the only relevant one. A
  missed-sibling-file gap of the `lead-ifye3.6`/`lead-r2bsr` shape becomes
  structurally impossible via this path, because the tool's own scan
  already covers the whole tree.
- A `lead-po` subagent about to author or sharpen a scenario establishes
  whether an equivalent or conflicting scenario already exists in the
  corpus the same way — via the `scenarios` CLI's corpus-wide commands —
  before writing new Gherkin, rather than trusting an ad-hoc grep's
  incidental scope.
- Plain `Grep`/`Read` remains available and correct for its narrower job:
  pulling the full text of a specific, already-identified scenario. This
  brief narrows *when* `Grep` is reached for, not whether it is ever used.

Output (two edited role-prompt sections) is not the measure — the behavior
change is: a subagent's belief about "what exists in `features/`" is
produced by a tool with proven full-tree correctness, not by an assumption
about file location that has already been wrong five times in one session.

#### 4. The pinned solution shape (from cand-003, not re-decided here)

One element (cand-003's element 1 — the well-understood, ready-to-ship
half; see Housekeeping for the disposition of element 2, the knowledge-
corpus analog):

- The `lead-architect` template's existing `@scenario_hash` conflict-
  enumeration discipline (`features/shopsystem-templates/
  lead_architect_empirical_pre_state_contract_surface.feature`) is extended
  to name the installed `scenarios` CLI's aggregate commands (`scenarios
  journal rebuild`, `scenarios validate --aggregate`) as the required
  mechanism for **any** corpus-wide scenario question — existence,
  ownership, conflict enumeration — not only the retirement/supersede/
  contradict trigger the existing scenarios already cover. A hand-scoped,
  single-file `Grep` is named as insufficient for that job. Plain `Grep`/
  `Read` stays correct for reading a specific, already-identified
  scenario's full text.
- The `lead-po` template gets an analogous, new discipline: before
  authoring or sharpening a scenario, check the corpus for an existing or
  conflicting scenario via the same `scenarios` CLI commands, not ad-hoc
  grep.

This is a prompt/role-definition-level change only — the `scenarios` CLI
itself is unchanged and already correct (cand-003 Evidence); what changes
is which tool the role prompt directs the subagent to reach for.

#### 5. Vocabulary (load-bearing)

- **Corpus-wide scenario question** — any question whose answer requires
  knowing something about the *whole* `features/` tree: does a hash exist
  anywhere live, which BC owns a given scenario, which scenarios conflict
  with a proposed change. Contrast with reading a single, already-
  identified scenario's full text, which is not corpus-wide and stays a
  `Grep`/`Read` job.
- **The `scenarios` CLI's aggregate commands** — concretely, `scenarios
  journal rebuild <features_tree> <journal_file>` (harvests every
  `@scenario_hash` tag via a full-tree `rglob`, i.e., "what hashes exist
  anywhere") and `scenarios validate --aggregate <dir>` (the ADR-056 D8
  corpus-consistency gate, i.e., "is everything correctly owned/tagged").
  Both are already-installed, already-correct per cand-003's direct source
  verification; this brief adds no new CLI behavior.
- **Hand-scoped grep** — a `Grep`/manual search invocation whose scope
  (file, directory) is chosen by the subagent's own assumption rather than
  by a tool with proven full-tree coverage. This is the failure mode this
  brief closes, not `Grep` as a tool in general.

#### 6. Scope

**In scope** (pinned by the scenarios below):

- `lead-architect` template: corpus-wide scenario retrieval (existence,
  ownership, conflict enumeration) directed through the `scenarios` CLI's
  aggregate commands, generalizing the existing retirement/supersede/
  contradict-triggered enumeration discipline to any corpus-wide question.
- `lead-po` template: a new pre-authoring discipline directing the same
  tool-based check before authoring or sharpening a scenario.
- Both scenarios explicitly preserve plain `Grep`/`Read` for reading a
  specific, already-identified scenario's full text — this is not a ban on
  `Grep`, it is a scoping of when hand-crafted search is the right tool.

**Out of scope / explicit non-goals:**

- **The knowledge/decision-record corpus analog** (ADR/PDR/brief/finding
  retrieval via a `shopsystem-knowledge` query surface). Named in cand-003
  as element 2, feasibility unconfirmed there. See Housekeeping for this
  brief's disposition.
- **Mechanical enforcement** (a gate that fails/flags retrieval that
  didn't go through the tool). cand-003's Rabbit holes names this as an
  open design question, not decided here — this brief ships the role-
  prompt-discipline shape only, the same shape ADR-064 already used
  successfully for the retirement-convention fix.
- **Rebuilding progressive disclosure** (`lead-x7bp`'s territory) or a
  general N-corpus retrieval-scoping framework — cand-003's own No-gos,
  carried forward unchanged.
- **`lead-xf7t4`'s directory-flattening** — independent, unblocked by this
  brief, not re-litigated here.

#### 7. Dispatch target (explicit, not left implicit)

Both scenarios below target **shopsystem-templates** (the BC that pours the
`lead-po`/`lead-architect` role templates — this shop's own doctrine, per
`intent-004`'s Constraints, forbids hand-editing `.claude/agents/*.md`
locally). Files already carry the concrete `@bc:shopsystem-templates` tag
(not the `@bc:unassigned` transitional marker) because both extend/sit
alongside already-`@bc:shopsystem-templates`-tagged sibling scenarios in
the same directory, so ownership is unambiguous at authoring time — no
Architect re-tagging needed, only pre-state verification and dispatch.

- `features/shopsystem-templates/lead_architect_empirical_pre_state_contract_surface.feature`
  — one new scenario appended (the file's existing 5 scenarios are
  unchanged).
- `features/shopsystem-templates/lead_po_scenario_corpus_query_discipline.feature`
  — new file, one scenario.

#### 8. Pinned scenarios

Authored, hashed, and written to disk at:

- [`features/shopsystem-templates/lead_architect_empirical_pre_state_contract_surface.feature`](../features/shopsystem-templates/lead_architect_empirical_pre_state_contract_surface.feature)
  — `@scenario_hash:b4795e33b958f6e2` — "lead-architect template directs
  corpus-wide scenario retrieval (existence, ownership, conflict
  enumeration) through the installed scenarios CLI's own aggregate
  commands, not a hand-scoped grep against an assumed file or directory."
- [`features/shopsystem-templates/lead_po_scenario_corpus_query_discipline.feature`](../features/shopsystem-templates/lead_po_scenario_corpus_query_discipline.feature)
  — `@scenario_hash:6161fd393e4662c6` — "lead-po template directs the PO to
  check scenario existence and ownership via the installed scenarios CLI
  before authoring or sharpening a scenario, not via ad-hoc grep."

Both `@scenario_hash` values were computed by the PO via the installed
`scenarios hash` CLI (block-only canonicalization) and reproduce exactly
via `scenarios list` against the on-disk files; both files pass `scenarios
validate` — verified before this brief was written.

#### 9. Strategic trace

Traces directly to `intent-004` (stakeholder intent, recorded 2026-07-14:
"prompt adjustment to challenge citation sources and validate that they are
acceptable") and `cand-003` (shaped and committed 2026-07-15 by the product
authority, in direct response to this same session's own incident record).
`intent-004`'s broader theme — subagent retrieval should be provenance-
and-tool-aware rather than relying on written-only rules and private
router memory — is only partially resolved here (the scenario-corpus half);
this brief is a concrete, narrow instance of that theme, following the
exact mechanical shape ADR-064 already proved out earlier this same day.

#### 10. What would NOT satisfy the stakeholder

- Adding a written rule to a role prompt that only says "use the right
  tool" without naming the concrete commands (`scenarios journal rebuild`,
  `scenarios validate --aggregate`) — the same vague-instruction failure
  mode `intent-004`'s Failure conditions section already names.
- Banning `Grep`/`Read` outright — this brief narrows *when* hand-scoped
  search is appropriate, it does not remove a tool the roles legitimately
  need for reading identified scenarios.
- Silently treating this brief as resolving `lead-r2bsr` without recording
  that call, or silently absorbing `lead-xf7t4`'s or `lead-x7bp`'s scope —
  see Anchored-to and Housekeeping for the explicit, recorded reconciliation
  calls instead.
- Extending scope to the knowledge/decision-record corpus without a
  recorded reason for either deferring it or requesting a probe — see
  Housekeeping.

#### Housekeeping — the knowledge-corpus element (cand-003 element 2)

**Call: scope this brief to element 1 only (scenario corpus, above).
Element 2 (knowledge/decision-record corpus retrieval via a
`shopsystem-knowledge` query surface) is an explicit named follow-on, not
requested for an Architect probe as part of this brief's own preparation.**

Reasoned, not silently dropped:

1. **The feasibility question is already answered, on the artifact
   surface, without needing a fresh probe.** Grepping every
   `features/shopsystem-knowledge/*.feature` file for a query/corpus-wide
   capability (this repo's own admissible ADR-018 evidence surface, not BC
   source) surfaces exactly two candidates: `active_digest_generation.feature`
   and `distribution_boundary.feature`. Both describe an **internal L1
   decision-digest generation/distribution mechanism for pouring accepted
   decisions to conforming BCs** — not an externally-invokable query CLI a
   `lead-po`/`lead-architect` subagent could call for "does ADR-X exist,"
   "who owns PDR-Y," "what conflicts with proposed decision Z." The
   nearest actual CLI candidate, `shop-knowledge template/schema/validate`
   (brief-019), is validation/template-only by its own pinned scope
   (§4/§6) — not existence, ownership, or conflict enumeration — and its
   tracking bead `lead-5msa9` is still **OPEN**, not yet shipped.
2. **Requesting a feasibility probe now would target a CLI that doesn't
   exist yet.** The only plausible extension point for a knowledge-corpus
   query surface is `shop-knowledge` itself, which this repo has not yet
   built. An Architect probe today could only re-confirm finding (1); a
   probe that asks "should `shop-knowledge` grow query commands, and what
   shape" is a real design question, but it is premature until
   `shop-knowledge` exists to extend — sequencing it after `lead-5msa9`
   ships is the reasoned deferral, not indefinite silence.
3. **Recorded follow-on:** once `lead-5msa9`/brief-019 ships, an Architect
   feasibility probe on extending `shop-knowledge` with corpus-wide query
   commands (existence, ownership, conflict enumeration — the ADR/PDR/
   brief/finding analog of `scenarios journal rebuild`/`validate
   --aggregate`) is the correct next step, and is named here so it is not
   lost. Not filed as a blocking dependency of `lead-gg926` — this brief's
   element 1 ships independently of when/whether element 2 is picked up.

**On `lead-r2bsr`:** this brief's `lead-architect` scenario is offered as
satisfying `lead-r2bsr`'s ask at the mechanism level (see Anchored-to,
above) — stronger than what was literally asked (a tool-based full-tree
scan rather than an instruction to `grep -r` correctly). The Architect
confirms and closes/reconciles `lead-r2bsr` against this brief's dispatch
outcome at pre-state-verification time; this brief does not itself close
`lead-r2bsr`.

**On `lead-xf7t4` and `lead-x7bp`:** both confirmed distinct and
non-duplicative per the Anchored-to section above — neither requires
sequencing against this brief.
