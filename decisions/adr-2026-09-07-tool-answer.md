---
type: adr
id: adr-2026-09-07-tool-answer
title: A framework tool describes itself in answer to one standard flag, and its skill is produced from that answer
status: draft
version: 1
date: 2026-09-07
decided-by: lead-solutions-architect
right: guardrail
owner: lead-solutions-architect
created: 2026-09-07
updated: 2026-09-07
derives-from: [adr-2026-09-05-typedef-rendering, adr-2026-09-03-role-rendering]
---

# ADR: A framework tool describes itself in answer to one standard flag, and its skill is produced from that answer

## 1. Context

This repository is the lead shop — the coordinating shop of the
product, owning the product-level definitions under `basis/` and no
Bounded Context (a region of the product with its own model, built by
a shop of its own, a BC shop). A *framework tool* is a tool the shop's
definitions name for an activity: the compilers, the lint, the work
register's command, and their like. A *skill* is the rendering at the
agent's load point — the `.claude/skills/` directory the harness
loads skills from — that states an activity or a tool's use so an
agent performs it from the definition alone; a *rendering* is a
generated output of a definition, never edited by hand. A *guardrail*
is a bound this role sets that BC shops choose within.

Pre-state, 2026-09-07, read from lead-shop-held records. The
[working principle set](../basis/principles.md) (v11) holds
`tools-through-skills`, in force since 2026-09-06: every framework
tool usable through a skill that states, for each use it supports,
what it does, what it takes, what it returns, and how it fails, so
that an agent uses it without reading its help; a tool with no such
skill is a gap, recorded, never worked around; tool owners ship each
tool's skill with the tool, in lockstep. Every skill at the load point
is a rendering of a process definition: the skill-rendering process
(v7) checks each one by its `source:` and names any skill whose source
is not an approved process definition `unrecognized`, escalated by
path. No framework tool has a skill. The initiative
[init-tool-skills](../initiatives/init-tool-skills.md) (v4) counts
eleven tools — four compilers and the lint the shop owns; six external
tools it runs, owned elsewhere — and 0 of 11 usable through a skill.
None of the five owned tools answers `--help` with a description of
itself: observed 2026-09-07, the lint runs its normal function on
`--help` and on an unknown flag alike (`PASS: 0 violation(s)`, exit
0). The feature repository (five features, read in full at the
initiative check) carries no scenario naming a tool's description; no
contract exists on this branch; the five prior architecture decision
records decide nothing about tools.

Forces. The authority, in the review of evidence that framed the
initiative (its Framing): "Why not put a standard flag on the tools
instead of analyzing the source code? This would allow tools from
other bounded contexts to be used without needing access to the source
code." The research report
`tool-self-description-2026-09` (v3, on the research branch; read as
the authority's evidence, not as authority): agent-facing tool formats
converge on one shape — a name, a natural-language description, a JSON
Schema for inputs, an optional output schema (finding 2, high); the
format owners specify the description's content — what the tool does,
when to use it and when not, what each parameter means, its limits
(finding 3, high); no standard machine-readable self-description of a
command-line tool exists — each framework has its own export
(finding 8, low, inference from absence); and the recommendation: the
tool is the source, the skill is generated from its export, and the
generated skill is gated on a digest — which the authority sharpened
in the framing to an answer the tool gives, not a walk of its source.
The architecture principle `knowable-shape` demands a description that
suffices without reading the entity's internal code; `local-comprehension`
designates the artifacts a level reads and calls a task that needs a
read below its level a design defect. The shop's precedent for a
rendering gated on its source, delivered in one session:
[adr-2026-09-05-typedef-rendering](adr-2026-09-05-typedef-rendering.md)
and [adr-2026-09-03-role-rendering](adr-2026-09-03-role-rendering.md)
— one source, one compiler, a `source-digest` stamp (`sha256:` plus
twelve hex digits of the source text's hash) in every rendering, a
check that diffs a fresh render against what stands.

This decision is the solutions architect role's under its guardrail
right: it bounds what a BC shop's tool must do to be used by the
product, and it names no vendor and no recurring cost. The initiative
check named it the one decision the bet rests on (initiative v3, the
role's offer, D1); it runs before the bet through the check's route.

Options that were real:

- **The agent reads the tool's `--help`.** Declined: the working
  principle forbids it; `--help` in the GNU form is brief invocation
  documentation for a person, and argparse — the parser library every
  owned tool uses — gives a home to what a tool does and what it takes
  but none to what it returns or how it fails (findings 1 and 3); and
  the lint today answers `--help` by running its normal function.
- **A hand-maintained description beside every tool, the skill
  rendered from it.** Declined as the source for a tool that can
  answer: the tool and the document are two homes for one fact, and a
  gate finds their drift only after it has happened (the report's
  alternative 1). Kept, in this decision, as the stand-in for a tool
  that cannot answer.
- **Export by walking the tool's parser** — the report's
  recommendation (b): a step imports each tool module and walks its
  `ArgumentParser`. Declined by the authority's sharpening: the walk
  runs the tool's source in the caller's process, so a tool from
  another shop is unusable without its source — the defect
  `knowable-shape` and `local-comprehension` exist to prevent — and
  the parser carries two of the four parts. Not foreclosed inside a
  tool: how a tool composes its answer is its own.
- **Serve descriptions through an MCP server.** Declined for now: the
  richest schema (finding 2), but served only at runtime behind a
  protocol layer, and a static consumer needs an export anyway
  (finding 7) — the same answer with a layer added. Not excluded
  later; a review trigger in §4.
- **`--help` with the returns and failures in its epilog text.**
  Declined: text by convention has no shape a renderer can read fields
  from or a check can find fields present in (the initiative's R3).

Not decided here: the follow-on questions are listed in this record's
Document History (v1) as candidates for later records.

## 2. Decision

Every framework tool answers the standard flag `--describe` by writing
to standard output, before any other action and with its other
arguments ignored, a JSON description of itself in one shape — the
tool's name and what it is for, and for each use it supports what it
does, what it takes, what it returns, and how it fails — and exits 0;
its skill is produced from that answer and stamped with the answer's
digest, so a change in the answer is drift the load-point check finds;
and a tool that cannot answer is used through a description written
beside it in the same shape, produced and gated the same way, until
the tool answers.

The shape's parts and the established form each adopts (the shape's
field names live in one data type under `basis/types/`, its one home):
the tool's *name* and *description* as the agent-facing tool
definition has them (a name in the `^[a-zA-Z0-9_-]{1,64}$` form; a
description saying what the tool does and when to use it); per use,
*what it does* as that description's content; *what it takes* as the
use's command line and a JSON Schema object over its arguments — the
converged input-schema form; *what it returns* as what the use writes
to standard output on success, a JSON Schema where the output is
structured and a stated text form where it is not; *how it fails* as a
list of exit statuses, each with the condition that produces it —
man-pages(7)'s EXIT STATUS form, since no agent-facing form carries
exit conditions. The serialization is JSON: every language the shop's
tools are written in serializes it from its standard library, so the
bound adds no dependency and binds no shop's language — the stack
bound this decision folds in. An answer counts only when the exit
status is 0 and the output parses against the data type; anything
else is "cannot answer". The digest is `sha256:` plus twelve hex digits
over the answer's bytes as written — the stamp form the shop's
renderings already carry — in the skill's `source-digest`, with
`source:` naming the tool, or the beside-description, it was produced
from.

## Principles screen

Screened against the
[architecture principle set](../basis/architecture-principles.md):
conforms on five; `intent-provenance` rests on the exception
[adr-2026-09-04-request-front-end](adr-2026-09-04-request-front-end.md)
carries, escalated to the authority (work item lead-4kymc).
`knowable-shape` — the answer is the tool's description, sufficient
without its source; a tool with no answer and no beside-description is
not yet usable, whatever code exists. `contracts-between-contexts` — a
tool from another shop is reached through its answer alone; the flag
and the shape are the named channel, the shape a published language
and the answering tool an open host service, the relationship kinds
its contract states. `actor-neutral-discipline` — the skill's use
binds whoever runs the tool; a beside-description is written and gated
under the same rule whoever writes it. `local-comprehension` — the
skill is the designated artifact for using a tool at the shop's level,
the answer the artifact for producing the skill, the source below
both. `bidirectional-conformance` — this record precedes the flag;
forward, the initiative's measure (1 of 11, then 11 of 11); reverse, a
skill whose digest no longer matches the tool's answer is regenerated
or removed, and a beside-description for a tool that answers is a
second home, removed. `intent-provenance` — the request, the
discovery conversation, the initiative, and this record are each
recorded; the operational contract the request entered through has no
artifact yet — the cited exception.

## 3. Consequences

- Every owned framework tool answers the flag. What changes: the four
  compilers, the lint, and the renderer this decision calls for each
  gain one handler that composes the answer and exits before any other
  action. For whom: the solutions architect role, which maintains the
  shop's tools. Cost: one handler per tool, six; the lint's first, as
  the proof; a tool whose parser swallows unknown flags today, as the
  lint does, must answer the flag before parsing anything else.
  Forecloses: `--help` as the source of any skill; a tool with no
  answer and no beside-description at the load point.
- The shape gets one home. What changes: a data type under
  `basis/types/` fixes the field names of the parts §2 names, approved
  through the definition chain. For whom: the product authority, who
  owns and approves definitions; every tool author, who answers in it.
  Cost: one type definition and its approval; a change to the shape
  is a change to what every answering tool owes, versioned there.
  Forecloses: a per-tool variant of the shape.
- Tool skills become renderings of answers. What changes: a compiler
  on the compile_process.py pattern asks each tool, writes its skill
  — the description as the skill's what-and-when, the body naming
  each use's exact invocation, output, and exit conditions, the format
  the harness activates — and stamps `source` and `source-digest`;
  the load-point check that today names a non-process `source:`
  `unrecognized` is amended, or a sibling process for tool skills
  defined, so that a tool source is recognized and checked by re-asking
  and re-digesting. For whom: the solutions architect role, maker of
  the compiler; the owner of the skill-rendering process, whose
  definition amends. Cost: one compiler, itself a framework tool that
  answers the flag; one process amendment; a standing `unrecognized`
  escalation for every tool skill placed before the amendment lands.
  Forecloses: a hand edit of a tool skill — it is drift, and the next
  render overwrites it.
- A tool that cannot answer gets a beside-description. What changes:
  for each of the six external tools, the shop that runs it writes a
  description in the shape at the home the data type names, carrying
  which tool it stands beside and who owns that tool; the skill is
  produced from the file and gated on the file's digest; the tool's
  lack of an answer is recorded as a gap against its owner. For whom:
  the lead shop, as writer; the owning shops, as the gap's addressees
  once the shop is unfrozen. Cost: six hand-written descriptions;
  drift between such a description and its tool is unreached by any
  check until the tool answers — the initiative's second feature
  carries them. Forecloses: nothing — a beside-description is retired
  when its tool answers, and a beside-description standing for a tool
  that answers is a finding.
- Agents run tools through skills. What changes: an agent step's use
  of a tool is the skill's use — the exact invocation the answer gave —
  and a step with no agent may still carry the bare command. For whom:
  every agent of the shop; process authors. Cost: none beyond reading
  the skill; the skill's metadata joins what the harness pre-loads.

Bound on Bounded Context shops, stated as one: a framework tool a BC
shop offers to the product MUST answer `--describe` in the shape the
data type defines, and the product produces that tool's skill from the
answer and from nothing else — never from the tool's source. A BC
shop's tool that does not answer is reachable only through a
beside-description the consuming shop writes, and its absence of an
answer is a gap recorded to the offering shop. The shop's own skill
for the tool, shipped in lockstep as the working principle asks, is
produced from the same answer. Within the bound the BC shop chooses:
its tools' language, parser library, and how the answer is composed
are its own.

## 4. Reversibility

Reversible at low cost while only the lead shop's tools answer: six
handlers removed, one compiler deleted, the data type retired, the
skills hand-written or removed, the load-point check restored from
source control. Hard once a BC shop's tool answers and a skill at any
load point is produced from that answer: the flag and the shape are
then a published language two or more shops build to, and each
reversal is a contract change per shop, with every skill produced from
an answer re-sourced. Review triggers: a published standard for a
machine-readable command-line self-description appears — finding 8
was an inference from absence, and the report names such a standard
as what would change its judgment — so the shape is re-based on it;
the harness stops activating a skill produced this way; a tool whose
uses the shape cannot carry — streaming output, an interactive prompt
— so the data type cannot be answered in; the product adopts a
runtime-served channel for tool descriptions, the MCP option declined
in §1, so the answer is served there and this flag is its export; the
beside-descriptions outnumber the answering tools after the
initiative's second feature — the bound not reaching the tools it was
set for.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Authored through the adr-authoring process (v3) at its author step, invoked as the initiative check's route for the decision the lead-solutions-architect role's attachment to init-tool-skills (v4, Document History v3, D1) left unrecorded, before the bet. Right: `guardrail` — a bound BC shops choose within, decided by this role; whether the role held it is the PM role's ruling at the check. The stack bound (JSON, serialized from a standard library) folded into the one decision as the offer stated, so no second record is raised for it. The initiative's U1 taken as this record's to fix: the flag named `--describe` — a long option in the GNU form, a verb naming the act, not `--help` (whose behaviour GNU fixes as brief invocation documentation and which argparse treats as an action exiting before any other handler) and not `--help=json` (no standard exists to borrow it from; the report's finding 8); the answer's behaviour the GNU rule for `--help` applied — other arguments ignored, the normal function not performed, standard output, exit 0. Candidates for later records, not decided here: (1) the data type's field names and the beside-description's home — the feature's make, approved through the definition chain; (2) whether skill-rendering amends to recognize a tool source or a sibling process is defined for tool skills (the initiative's R1 and U3) — the process owner's; (3) how the gap for a tool that cannot answer is recorded to its owner while the shop is frozen (U5); (4) whether the product adopts a runtime-served channel for tool descriptions (the report's alternative 3). The count of framework tools (R2) is the PM role's, reported not rewritten. Maker's self-check against the adr fitness set and guideline, as define-good-up-front asks: scenario 1 — the title one line, the decision sentence one decision (flag, shape, answer-as-source gated on its digest, beside-description as stand-in — the parts of one guardrail, as the precedent's method commitments stood in one decision); scenario 2 — forces and pre-state with their evidence, five real options each with its reason against; scenario 3 — `decided-by` and `right` in the frontmatter and §1's third paragraph; scenario 4 — five consequences each with what changes, for whom, cost, and what it forecloses, the bound on BC shops stated as one with MUST; scenario 5 — reversible now, hard after the first BC shop's tool answers, five triggers; scenario 6 — the screen after §2, conforms on five, `intent-provenance` resting on the standing exception, no new escalation. Terms defined at first use or in the glossary (framework tool, skill, rendering, gap, relationship kind); Context under half the record by word count. Status draft pending the screen. |
