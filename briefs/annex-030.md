---
type: material
id: annex-030
owner: product-authority
status: draft
version: 1
created: 2026-08-23
updated: 2026-08-23
---

# Annex 030: role-definition content research and skills import survey

Full material behind brief-030. Sources: the frozen `main` tree (old
agent templates, findings, ADRs, PDRs, the skill catalogue) read via
`git show`, and named external practice.

## 1. What thin roles cost — the evidence on `main`

The old lead-architect template (~600 lines) and lead-po template
(~340 lines) are fossil records: nearly every section is a patch
citing a specific incident. The failure classes:

- **Missing judgment discriminators.** The assign/bugfix/maintenance
  vehicle choice lived "only as a bd memory and my own awareness";
  the Architect pattern-matched the wrong vehicle until a checklist
  and anti-rationalization language were written into the template.
  A controlled comparison in the prototype findings (a permissive
  prompt vs a tightened one, same schema) showed the prompt language
  alone changed the outcome — posture text is causal, not decorative.
- **Missing evidence rules.** "Verify empirically" without an
  admissible-evidence list led the Architect to read BC internals
  (the one thing isolation exists to prevent — a whole ADR exists to
  define "empirical" as demonstrated against the contract surface),
  to trust dead code, a drifted local copy, and stale spike prose as
  authoritative. A role must name its authoritative inputs.
- **Missing completeness mandates.** Without a required corpus-wide
  sweep, "no conflicting scenario hash exists" was asserted wrongly
  four times on the strength of a lead-held grep; BC shops did the
  completeness QA through repeated clarifies.
- **Prose carrying machine obligations.** Judgment-free invariants
  (hash verification, gate checks) kept failing in role prose and
  had to move into tooling — role text carries judgment discipline;
  tools and schemas carry invariants.
- **A topology gap.** Interactivity is a position in the execution
  topology, not a role attribute: a subagent PO could not hold a turn
  open with a human, so discovery rolled downhill until the PM was
  created as a main-session mode carried by skills.

## 2. External practice on role content

- **RAPID (Bain) / DACI**: a role carries explicit decision rights —
  what it decides, what it recommends, what it must escalate; one
  accountable seat per decision (already in the typedef).
- **Scrum Guide (2020)**: accountability ↔ owned artifact ↔
  commitment — a role is anchored to the artifact types it owns and
  the quality bar each carries.
- **Team Topologies (Skelton & Pais)**: interaction modes — a role
  states who it exchanges with and in what mode; unstated interfaces
  become ad-hoc channels.
- **SFIA**: competencies as level-set skills, split from
  responsibilities; responsibilities phrased as outcomes.
- **Capability-contract practice** (already adopted): frontmatter as
  machine contract; mechanical enforcement of stance.

## 3. Proposed role-definition content model (typedef v3)

Sections a role definition carries (additions marked +):

1. Mission (opening).
2. **+ Default posture** — the standing stance governing the seat's
   judgment (e.g. "pre-state determines vehicle, verified against the
   contract surface").
3. Accountabilities (4–6, answerable; each tied to an owned artifact
   type where one exists).
4. **+ Decision rights** — Decides: the exclusive domain (unchanged,
   exactly one). Escalates: named triggers and the seat they go to.
5. **+ Admissible evidence** — the authoritative sources for the
   seat's judgments and what counts as proof; sources that are
   explicitly NOT authoritative are named.
6. **+ Interfaces** — the seats and shops this role exchanges with
   and the vehicle (contract, message type, conversation type).
7. **+ Knowledge and skills** — the governed skills the seat loads;
   the seat's declared context list beyond the conversation.
8. **+ Anti-rationalization** — the tempting thoughts specific to
   this seat, each with its stop; written generically, no incident
   citations.
9. Competencies.

New rules: mechanical invariants MUST live in tools or schemas, never
in role prose; per-activity sufficiency checks MUST live in the
process definitions of those activities (the chain layer the old
system lacked), never in the role; sequencing stays banned.

## 4. Per-role enrichment

- **lead-architect** (highest priority — the costliest failures):
  posture: pre-state determines vehicle, verified against the
  contract/artifact surface, never BC internals. Evidence rules:
  contract surfaces, registry-wide sweeps via the aggregate tooling,
  canonical package data; NOT authoritative: local poured copies,
  spike findings, forward-looking prose, code reachable only by
  entering a BC. Decision rights: decides decomposition and vehicle
  selection; escalates contract-breaking changes and cross-context
  conflicts to the authority. Interfaces: BC shops via typed
  messages; PO via the bounded decomposition collaboration; PM for
  framing. Skills: vehicle discrimination, pre-state verification,
  scenario-sweep completeness, reconcile-and-close.
- **lead-po**: posture: commitment owner, not order-taker — scope is
  declined with a recorded reason when it serves no committed
  outcome. Evidence rules: corpus-wide scenario discovery through
  the registry tooling, never file search alone. Decides scenario
  wording; escalates scope conflicts. Skills: work-splitting, the
  brief/PDR/scenario writing skills.
- **lead-pm**: execution position declared (main-session seat).
  Posture: ground before probing; no session closes without its
  terminal record. Decides framing; escalates every product decision
  to the authority. Skills: the six session modes (as processes) and
  the technique-skill catalogue below.

## 5. Skills on `main`: inventory and dispositions

38 installed skills; the buckets below sum to 38. Dispositions:

| Group | Count | Disposition |
|---|---|---|
| PM session skills (discovery-dialogue, shaping, option-tradeoff, prioritization, problem-space-mapping, product-narrative) | 6 | **Rewrite as process definitions** through the approved process chain; each already has a mandatory terminal artifact, which becomes the run's typed result. discovery-dialogue reconciles with the existing discovery-conversation process. Their terminal artifact types (intent record, candidate, PDR, prioritization record, problem-space map, current-state) get typedefs and chains — this is also where the intent-provenance chain becomes real. |
| PM technique skills (19 deanpeters-derived lenses + the PO's work-splitting) | 20 | **Import as a new `technique` artifact type** — a knowledge lens with Serves/Emits-into and no terminal artifact; needs its own chain (typedef, guideline, fitness set). Pulled on demand as the session processes that invoke them come online. |
| Generated writing skills (write-adr, write-brief, …) | 8 | **Not imported as content** — they are renderings; regenerate from the new system's typedefs as those artifact types gain chains. |
| Lead-ops skills (create-bc, bring-up-bc, reconcile-and-close) | 3 | reconcile-and-close already exists as a basis process (verify parity at import). create-bc / bring-up-bc: demand-pull — eligible, imported when BC operations resume post-migration. |
| stakeholder-presentation | 1 | Already in the basis. |
| TDD draft (BC-side; uninstalled, in `drafts/` — not among the 38) | 1 | Not a lead-shop skill; stays for the BC handoff. |

**License constraint (binding content):** the deanpeters-derived
technique skills exist under a direct grant from the author requiring
preserved attribution; the skills were once removed over a license
conflict and restored only under that grant. The grant's terms must
get a covering home in the new system — a license rule on the
`technique` typedef plus the preserved per-file notices — before any
of those files are imported.

## 6. Sequencing

1. Typedef v3 amendment → re-author lead-architect, lead-po, lead-pm
   through the amended chain (old templates as keeper sources;
   sufficiency-check content routes to process definitions as they
   are authored).
2. Session-skill processes + their artifact chains, starting with
   discovery (Phase 2's first interview needs it).
3. `technique` chain, license rule first; then demand-pull imports.
4. Writing-skill regeneration rides each artifact chain as it lands.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-23 | update | Authored as the research annex for brief-030. |
