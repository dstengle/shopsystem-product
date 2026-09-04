---
type: adr
id: adr-2026-09-03-role-rendering
title: Approved role definitions reach the agent runtime as a compiled rendering
status: checked
version: 5
date: 2026-09-03
decided-by: product-authority
right: escalation
owner: lead-solutions-architect
created: 2026-09-04
updated: 2026-09-04
---

# ADR: Approved role definitions reach the agent runtime as a compiled rendering

## 1. Context

An agent filling a named role in a process step is instantiated by
the harness — the agent runtime — from its load point,
`.claude/agents/<name>.md`, reading its front-matter as the
subagent's contract and its body as the role's prompt.
What a role *is* stands elsewhere: the six approved
[role definitions](../basis/roles/) in `basis/roles/`, each carrying,
in its front-matter, the runtime keys the harness honors (`name`,
`description`, `tools`, `maxTurns`) alongside the shop's identity
keys it does not read, and in its body a Document History and links
written relative to `basis/`. On 2026-09-03 no `.claude/agents/`
existed on this branch, and the two agents the harness offered —
`lead-architect` and `lead-po` — came from the frozen corpus: the
harness reads project-level agents from the repository's `main`
checkout, which this branch's worktree shares, so `main`'s
`.claude/agents/` reached sessions opened here. 0 of 6 approved roles
were instantiable from an approved source
([init-roles-availability](../initiatives/init-roles-availability.md),
For whom; [sess-2026-09-03-a](../sessions/sess-2026-09-03-a.md)). The question the discovery conversation put to the
authority was in what form an approved definition stands at the load
point.

The pre-state held one exemplar of the answer for another definition
kind: the [skill-rendering](../basis/processes/skill-rendering.md)
process, approved 2026-09-02, renders approved process definitions to
`.claude/skills/` through `compile_process.py`. Working principles
bearing: `single-source-of-truth` — every appearance
of a definition other than its home is a reference or a generated
rendering — `governed-context`, and `least-context`.

**The escalation that settled it.** The decision is the authority's,
so it records under `right: escalation`. The fork reached the
authority as the lead-pm's options in the discovery conversation for
init-roles-availability on 2026-09-03 (lead-wm8n5 — the discovery
conversation, brainstorm form; recorded in sess-2026-09-03-a), and
the authority ruled in its words: "Render the role rather than use
verbatim, sibling process for now, more comprehensive work later."
The ruling entered the initiative's Document History (v1). This
record is authored retroactively: its `date` is the decision date,
2026-09-03, and its `created` the record's authoring date, 2026-09-04
— after the ruling was applied, the
[role-rendering](../basis/processes/role-rendering.md) process
approved (v5) and run, six roles rendered by
[`compile_role.py`](../basis/tools/compile_role.py), `lead-po`'s
instantiation from the rendering demonstrated
([feat-roles-availability](../features/feat-roles-availability.md),
v6).

Options that were real:

- **Place the definition file verbatim at the load point.** Declined,
  for the authority's reasons: the definition's body carries a
  Document History and `basis`-relative links that do not belong in
  an agent prompt — history the role does not need, links that break
  at the load point — and its front-matter carries the shop's identity keys
  the harness does not read; and under `single-source-of-truth` even
  a verbatim copy would have to be generated and reconciled, so the
  real choice was what the generated form carries.
- **A two-layer render — a lean prompt plus the rest reachable from
  it.** Not chosen now: the ruling's "more comprehensive work later"
  carried it forward rather than rejecting it. The single-layer render
  — a strip, a digest, and placement, per the architect's feasibility
  verdict in the initiative's
  [Feasibility and usability](../initiatives/init-roles-availability.md#feasibility-and-usability)
  section — met the initiative's measure within its one-session
  appetite; a second loadable form with no exemplar was not needed (see
  §4).
- **One generalized rendering process over skills and roles.** This
  option answers a different question — which process carries the
  rendering — and is the ruling's second clause, "sibling process for
  now": a separate decision, split out under the typedef's
  one-decision rule. Candidate record: *the rendering of roles is
  carried by a sibling process of skill-rendering rather than one
  generalized rendering process*, carried in lead-sx9xj. This record
  takes a maintaining rendering process — today, role-rendering — as
  pre-state fact without deciding its shape.

Screened against the
[architecture principle set](../basis/architecture-principles.md):
conforms.

- `bidirectional-conformance` — the definition is the authoritative
  design and the rendering conforms to it; the maintaining process
  checks both directions, forward and reverse, through the finding
  kinds named in role-rendering's fourth outcome, O4 — `missing` (an
  approved definition with nothing at the load point), `diverged` (a
  rendering not byte-equal to a fresh render), `stale` (a rendering
  whose source does not stand approved), `unrecognized` (a load-point
  file that is no rendering of any definition). The role-rendering
  definition (v5) was the design element the code conformed to; the
  decision itself stood recorded only in the initiative's history row
  and the session record from 2026-09-03 to 2026-09-04 — a recording
  gap this record closes.
- `local-comprehension` — an agent filling a role works at the
  inside-a-shop level, and the rendering alone suffices for that work:
  its links resolve at the load point and its history is stripped, so
  nothing beyond the rendering is read to instantiate the role.
- `knowable-shape` — the lead shop's description of what stands at
  its load point is the role-rendering definition's Data section, and
  every rendering names its `source` and `source-digest`.
- `actor-neutral-discipline` — the rendering, the check, and the
  reconciliation attach to the role-rendering process and the
  solutions architect role, with the same records whoever runs a step.
- `intent-provenance` — the intent entered through the lead shop's
  operational contract as the initiative's Framing records, the
  discovery conversation being the process under that contract, and
  the ruling traces to the originator's words through the initiative's
  history; that contract has no artifact on this branch — a shop-wide
  gap carried by lead-4kymc, not an exception of this decision.
- `contracts-between-contexts` — no Bounded Context is touched, so
  nothing crosses a contract.

No principle is unsatisfied; nothing is escalated.

## 2. Decision

An approved role definition reaches the agent runtime only as a
rendering — the agent file the maintaining rendering process generates
from the definition and places at the load point as
`.claude/agents/<name>.md` — never as the definition file placed
there as it stands.

## 3. Consequences

- The load point holds renderings, never definitions. What changes:
  `.claude/agents/<name>.md` is a generated file — the runtime keys
  plus `source` and `source-digest`, the definition's body without its
  Document History, every relative link resolved for the load point —
  and a hand edit there is overwritten at the next reconciliation. For
  whom: every agent filling a role; the architect role, which
  reconciles. Cost: a second compiler to
  maintain beside `compile_process.py` — today
  `basis/tools/compile_role.py`, the current instrument; the decision
  is tool-neutral, so the compiler's experiment status does not alter
  the cost. Forecloses: tuning a prompt at the load point; a change goes
  through the definition and its owner.
- Currency is owed after every definition change. What changes: an
  amended definition is not what the runtime instantiates until it is
  re-rendered; the interval is a `diverged` finding of the maintaining
  process. For whom: the owner amending a role; the architect. Cost: a run of role-rendering after each
  approval; until it runs, the runtime instantiates the previous
  rendering (lead-ghaiq — the run-record divergence — records the same
  interval for skills).
- Approval gates instantiation at render time. What changes: the
  compiler renders only a definition with `status: approved`, so a
  draft role cannot be instantiated from the load point. For whom: role authors and the owner. Forecloses:
  exercising a draft role through the load point before approval.
- The runtime contract of a role definition is fixed in the design,
  and the compiler conforms to it. What changes: the front-matter keys
  that pass to the harness are those the
  [role-definition typedef](../basis/artifacts/role-definition.md)'s
  Required frontmatter names — `name`, `description`, `tools`,
  `maxTurns`, its functional contract keys — plus the optional harness
  keys the role-rendering definition's Data section names; the
  compiler passes those and no others, and a new harness key reaches
  the runtime only once a definition admits it. For whom: the
  typedef's owner; the architect role. Cost: a definition change per new key, the
  conforming compiler change, and the re-render.
- No bound on Bounded Context shops. The decision covers the lead
  shop's own load point and its six roles: no Bounded Context exists
  on this branch (the initiative's Decomposition) and no contract
  carries the rule. Extending it — a BC shop's roles reach
  its runtime as renderings — would be a guardrail decision — a
  decision on the platform guardrails Bounded Context shops build
  within, the architect role's domain — not taken here.

## 4. Reversibility

Reversible at moderate cost, design first. Reverting to verbatim
placement is: amend the role-rendering definition — the recorded
design change; its Data section defines the loadable form — then run that
definition's `check` step — both directions — whose reverse findings
(`stale`, `unrecognized`) name every rendering the amended design no
longer calls for, retired at reconciliation; then re-place the six
definitions. The definitions themselves are untouched, and
feat-roles-availability's scenarios ("current with its approved
definition") hold under either form. A two-layer render is the
smaller change: the Data section amended, a second loadable form in
the compiler. Review triggers: lead-sx9xj — the comprehensive
rendering work the authority named (fold the sibling processes, bring
the principles rendering under a process); a harness that reads a role
definition in the shop's own form, or stops honoring the compiled
form; a role whose prompt needs something the single-layer rendering
cannot carry.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-04 | update | Authored through the adr-authoring process for the authority's ruling of 2026-09-03 in the discovery conversation for init-roles-availability (lead-wm8n5), after the ruling was applied. Right: `escalation`, the fork the lead-pm put to the authority; §1 names it. The ruling's second clause — "sibling process for now" — split out under the one-decision rule as a candidate (§1, option 3). Status draft pending the screen. |
| 2 | 2026-09-04 | review | Screen round 1 (judge: claude-fable-5-1 / adr-screen prompt v6): five findings — F1 (scenario 1, wobbly) the decision sentence named `compile_role.py`, so folding the siblings under lead-sx9xj would falsify it; F2 (principles, wobbly) Consequence 4 placed the runtime key list's design authority in the compiler; F3 (principles, wobbly) `intent-provenance`'s entry contract unstated; F4 (uncovered, wobbly) "experiment apparatus" unpriced; F5 (uncovered, confident) the retroactive dates unexplained. |
| 2 | 2026-09-04 | update | Round-1 repairs: decision sentence tool-neutral, the compiler moved to Consequence 1, option 3 cut (F1); Consequence 4's design home the role-definition typedef plus role-rendering's Data, the compiler conforming (F2); entry contract stated (F3); experiment status priced (F4); `date` and `created` explained in §1 (F5). Glossed: harness, the four finding kinds, lead-wm8n5, lead-ghaiq. |
| 3 | 2026-09-04 | review | Screen round 2 (judge: claude-fable-5-1 / adr-screen prompt v6): six wobbly findings, none confident — F1 Consequence 1's experiment-status clause overlong for a tool-neutral decision; F2 option 3 did not name the candidate decision in one line; F3 §4's reversal listed code before design; F4 the `bidirectional-conformance` clause did not name the recording interval plainly; F5 the v2 row mixed findings and repairs; F6 `intent-provenance` did not name the contract. |
| 3 | 2026-09-04 | update | Round-2 repairs: experiment-status clause cut to a phrase (F1); the candidate named in one line, carried in lead-sx9xj, the v2 row split (F2, F5); §4 design-first (F3); the 2026-09-03 to 2026-09-04 recording gap named, role-rendering v5 the design element the code conformed to (F4); the operational contract named as a kind (F6). Glossed: O4, guardrail decision; `local-comprehension` reads "nothing beyond the rendering". |
| 4 | 2026-09-04 | review | Screen round 3, the cap (judge: claude-fable-5-1 / adr-screen prompt v6): five wobbly findings, none confident — F1 `intent-provenance` read the contract's missing artifact as this decision's exception; F2 option 1 left the real choice unstated; F3 §4 called `check` a reverse check only; F4 the feasibility verdict's home uncited; F5 how `main`'s agents reached this branch unstated. The PM role's ruling: pass on form, the decider being the authority. |
| 4 | 2026-09-04 | update | Round-3 repairs: the missing artifact a shop-wide gap carried by lead-4kymc, not an exception (F1); option 1 closes on what the generated form carries (F2); §4 names both directions and the reverse findings `stale`, `unrecognized` (F3); the feasibility verdict linked to the initiative's Feasibility and usability section (F4); the shared `main` checkout named (F5). Principles screen bulleted; the guardrail gloss made non-circular. Repaired post-cap by the PM role's direction, disclosed. |
| 5 | 2026-09-04 | state | `draft` → `checked`: the PM role's decision from the adr-authoring check. Right ruled first: the decider is the product authority, so the record is checked for form only, and the form holds — one decision, real options, decider and right named (`escalation`, the typedef's admitted value for an authority decision), consequences priced, reversibility stated, the principle screen stated and holding on the judge's own reading of the set. Rounds (judge claude-fable-5-1 / screen prompt v6): round 1 five findings, one confident (the `date` key's meaning), repaired; round 2 six wobbly, repaired; round 3, the cap, five wobbly, none confident, repaired post-cap by direction and disclosed. Reasons for pass at the cap: no named criterion missed with confidence in any round; the one substantive open question — intent entering through an operational contract that has no artifact — is a shop-wide gap (lead-4kymc), not this record's. The candidate decision the author split out (the sibling process rather than one generalized rendering process) is ruled to stand as the applied change in role-rendering's Document History with lead-sx9xj as its review trigger; no second record. |
