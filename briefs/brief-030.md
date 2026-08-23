---
type: decision-brief
status: delivered
date: 2026-08-23
reader: product-authority
decisions-requested: 4
annex: annex-030.md
verified-by:
  - {round: 1, role: cold-reviewer, model: claude-fable-5, date: 2026-08-23, verdict: findings, notes: "five/six count mismatch; asks 2-3 not self-sufficient; coinages unglossed"}
  - {round: 2, role: cold-reviewer, model: claude-fable-5, date: 2026-08-23, verdict: findings, notes: "ask 4 evidence-less and unsourced; skill arithmetic unreconciled; chain/typedef term slip"}
  - {round: 3, role: cold-reviewer, model: claude-fable-5, date: 2026-08-23, verdict: findings, notes: "delivered at the round cap; three residuals (stale 36 in the annex pointer, PM skill count, lead-pm source material) repaired post-round and disclosed here"}
version: 4
---

# Brief 030: role depth and the skills import

**The answer first.** The three new lead roles are thin because the
typedef only asks for identity, accountabilities, and one decision —
while the old system's evidence shows the content that actually
changed agent behavior was posture, evidence rules, decision
boundaries, and anti-rationalization text, accreted as ~950 lines of
incident patches across the two old agent templates on `main`
(`.claude/agents/lead-architect.md`, ~600 lines;
`.claude/agents/lead-po.md`, ~340 lines). The PM seat worked only
because its procedure lived entirely in skills — six working modes
plus a catalogue of technique and writing skills. Recommendation: enrich the
role-definition typedef with six sections the evidence and external
practice agree on, re-author the three roles through it, and import
the skill catalogue by kind — the PM's six working-mode skills become
processes, its technique skills become a new governed type, generated
skills regenerate. Asks 1–3 gate the work; ask 4 defaults on
silence.

## Asks

**Ask 1 — amend the role-definition typedef (v3).** Add six
sections: Default posture, Decision rights (decides + escalates),
Admissible evidence, Interfaces, Knowledge and skills,
Anti-rationalization; add two rules: mechanical invariants live in
tools, never role prose; per-activity sufficiency checks live in
process definitions, never the role. *Evidence:* each of the old
system's recorded failure classes — wrong message vehicle chosen,
inadmissible evidence trusted, incomplete sweeps asserted complete,
machine obligations ignored in prose — maps onto exactly one of these
sections, and the decision-rights, interface, and competency content
matches established frameworks (RAPID and DACI, decision-rights
matrices; Scrum's accountability-to-artifact pairing; Team
Topologies' interaction modes; SFIA, the IT skills framework).
*Default:* none — gates role re-authoring.

**Ask 2 — re-author `lead-architect`, `lead-po`, and `lead-pm`
through the amended typedef (v3) and its approved guideline and
fitness set**, using the two old agent templates as
source material — rewritten through the new sections, never pasted —
with lead-architect first; lead-pm had no template, so its source
material is the skill-carried procedure: the six working-mode skills
and the mode primer on `main`. *Evidence:* the architect's absences were
the costliest on record: it read a Bounded Context's internals when
"empirical" went undefined, trusted dead code and a drifted local
copy as pre-state, and asserted corpus-wide claims from partial
sweeps — each a section ask 1 adds. Per-role content is outlined in
annex §4. *Default:* none — gates Phase 1 exit.

**Ask 3 — approve the skills import plan** (file-by-file table in
annex §5–6). `main` installs exactly 38 skills; the five buckets sum
to it: the PM's 6 working-mode skills (discovery, shaping,
option-tradeoff, prioritization, problem-space-mapping,
product-narrative) are rewritten as process definitions — each
already mandates a terminal artifact, which becomes the run's typed
result, and those records are where intent stays traceable from
expression to work; 20 technique skills (19 product-management
lenses plus the PO's work-splitting) import as a new `technique`
artifact type with its own definition chain, each pulled only when a
process that invokes it comes online, never on a schedule; 8
generated writing skills regenerate from the new typedefs, never
imported; 3 operations skills wait for post-migration Bounded
Context operations; stakeholder-presentation (the 38th) is already
in the basis. A separate uninstalled draft (test-driven development)
stays with the Bounded Context handoff. *Evidence:* the by-kind
split follows what each file is — the working modes have flows and
outcomes (process-shaped), the techniques are knowledge with no
flow, and the writing skills are renderings whose source is a
typedef. *Default:* none — gates the import.

**Ask 4 — license coverage.** The 19 product-management technique
skills derive from Dean Peters' Product-Manager-Skills collection.
*Evidence:* the frozen tree records the history — an architecture
decision record removed them over a license conflict, and a later
one (`main:adrs/adr-066.md`, 2026-07-16) restored them under a
direct grant from the author requiring preserved attribution; each
derived file carries its notice today. The grant's terms become a
binding license rule on the `technique` typedef, and no derived file
imports without its notice. *Default:* rides ask 3 — approving the
plan approves this handling.

## Deferred

The decision-brief typedef's closed frontmatter set predates the
versioning standard (this brief carries `version` anyway) — a
one-line typedef reconciliation, deferred to the next typedef pass.

## Annex

[annex-030.md](annex-030.md) — full research: evidence, external
practice, per-role content, the 38-skill inventory table, and
sequencing. Optional reading; every ask is decidable from this brief.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-23 | update | Authored from the main-tree research and external practice; carried by the stakeholder-presentation process. |
| 1 | 2026-08-23 | review | Cold read round 1: findings — the ask-1 count mismatch, asks 2 and 3 leaning on the annex, unglossed coinages. |
| 2 | 2026-08-23 | update | Round-1 repairs: count fixed at six; the old templates named; asks 2 and 3 carry inline evidence; keeper/demand-pull/provenance coinages replaced with plain descriptions; external frameworks glossed. |
| 2 | 2026-08-23 | review | Cold read round 2: findings — ask 4 carried no evidence line and an unsourced grant; skill counts did not visibly sum; "amended chain" term slip. |
| 3 | 2026-08-23 | update | Round-2 repairs: ask 4 gains its evidence (the recorded license history and grant source); skill arithmetic exact (38 installed, five buckets summing); ask 2 names the typedef and chain links; abbreviations expanded. |
| 3 | 2026-08-23 | review | Cold read round 3 (the cap): findings — the annex pointer's stale count, the PM skill count, lead-pm's unnamed source material. |
| 4 | 2026-08-23 | update | Post-cap residual repairs, disclosed in verified-by; delivered at the round cap per the presentation process's failsafe. |
| 4 | 2026-08-23 | state | draft → delivered. |
