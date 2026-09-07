---
type: adr
id: adr-2026-09-07-tool-answer
title: A framework tool describes itself in answer to one standard flag, and its skill is produced from that answer
status: checked
version: 4
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
is a rendering of a process definition, produced by
`compile_process.py` — the compiler that renders a process definition
into its skill, stamping the skill with `source`, the definition's
path, and `source-digest`, `sha256:` plus twelve hex digits of the
source text's hash; the skill-rendering process (v7) checks each skill
by diffing a fresh render against what stands and names any skill
whose `source:` is not an approved process definition `unrecognized`,
escalated by path — so a tool skill placed there before that check is
amended is a standing escalation. No framework tool has a skill. The
initiative [init-tool-skills](../initiatives/init-tool-skills.md) (v5)
counts eleven tools — four compilers and the lint the shop owns; six
external tools it runs, owned elsewhere — and 0 of 11 usable through a
skill; whether the count is eleven is the PM role's, reported not
rewritten. None of the five owned tools answers `--help` with a
description of itself: observed 2026-09-07, the lint runs its normal
function on `--help` and on an unknown flag alike (`PASS: 0
violation(s)`, exit 0). The feature repository (five features, read in
full at the initiative check) carries no scenario naming a tool's
description; no contract exists on this branch; the five prior
architecture decision records decide nothing about tools.

Forces. The authority, in the review of evidence that framed the
initiative (its Framing): "Why not put a standard flag on the tools
instead of analyzing the source code? This would allow tools from
other bounded contexts to be used without needing access to the source
code." The research report `tool-self-description-2026-09` (v3, on
the research branch; read as the authority's evidence, not as
authority): the GNU standard requires `--help` in the tool as brief
invocation documentation for a person, written to standard output
before exiting, other arguments ignored and the normal function not
performed (finding 1, medium); agent-facing tool formats — MCP,
Anthropic's tool use, OpenAI's function calling — converge on one
shape: a name, a natural-language description, a JSON Schema for
inputs, an optional output schema (finding 2, high); the format owners
specify the description's content — what the tool does, when to use
it and when not, what each parameter means, its limits (finding 3,
high); no standard machine-readable self-description of a
command-line tool exists — each framework has its own export
(finding 8, low, inference from absence); and the recommendation: the
tool is the source, the skill is generated from its export, and the
generated skill is gated on a digest — which the authority sharpened
in the framing to an answer the tool gives, not a walk of its source.
The flag's name: GNU asks for long-named options; `--help` is taken,
its behaviour fixed by the standard, and argparse treats it as an
action that exits before any other handler runs — so the flag is a
second long option, a verb naming the act, its behaviour the
`--help` rule applied. The designer role's attachment (initiative v5,
its D2 — the experience decisions inside the flag and its shape): the
flag's name and the shape's field names are names for the caller, a
caller saying what each is from the name and the vocabulary alone,
entered in the vocabulary when the data type is made; the failure
part carries a stable code from a closed, documented set beside an
explanation and a next step; the answer goes to standard output with
exit 0 and no other action, before anything else the tool would do.
The architecture principle `knowable-shape` demands a description
that suffices without reading the entity's internal code;
`local-comprehension` designates the artifacts a level reads and
calls a task that needs a read below its level a design defect. The
shop's precedent for a rendering gated on its source, delivered in
one session:
[adr-2026-09-05-typedef-rendering](adr-2026-09-05-typedef-rendering.md)
and [adr-2026-09-03-role-rendering](adr-2026-09-03-role-rendering.md)
— one source, one compiler on the `compile_process.py` pattern, the
digest stamp, the diff check. The initiative's own risk that the
proof's check must read the returns and failures present as fields,
not the flag answered, or the working principle's first statement is
not met.

This decision is the solutions architect role's under its guardrail
right: it bounds what a BC shop's tool must do to be used by the
product, and it names no vendor and no recurring cost. The initiative
check named it the one decision the bet rests on (initiative v3, the
role's offer); it runs before the bet through the check's route.

Options that were real:

- **The agent reads the tool's `--help`.** Declined: the working
  principle forbids it; `--help` is documentation for a person, and
  argparse — the parser library every owned tool uses — gives a home
  to what a tool does and what it takes but none to what it returns
  or how it fails (findings 1 and 3); and the lint today answers
  `--help` by running its normal function.
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
  protocol layer, and a static consumer needs an export anyway (the
  report's finding 7, low) — the same answer with a layer added. Not
  excluded later; a review trigger in §4.
- **`--help` with the returns and failures in its epilog text.**
  Declined: text by convention has no shape a renderer can read fields
  from or a check can find fields present in — the initiative's risk
  above.
- **`--help=json`, a structured form of the existing option.**
  Declined: no standard exists to borrow the form from (finding 8),
  and it overloads an option whose behaviour the GNU standard fixes
  and argparse pre-empts; a second long option costs nothing.

Not decided here: the follow-on questions are listed in this record's
Document History (v1) as candidates for later records.

## 2. Decision

A framework tool's answer to the standard flag `--describe` is the
sole source of its skill.

The decision's parts, one guardrail together. *The flag's behaviour:*
on `--describe` the tool writes its answer to standard output and
exits 0, before any other action, with its other arguments ignored —
the GNU rule for `--help` applied; an answer counts only when the exit
status is 0 and the output parses against the data type below, and
anything else is "cannot answer". *The answer's shape:* the tool's
name and description — a name in the form the agent-facing
definitions of finding 2 give their `name`, MCP's unique identifier
for a tool, in the regex Anthropic's tool definition fixes for it,
`^[a-zA-Z0-9_-]{1,64}$`; a description saying what the tool does and
when to use it — and, for each use it supports: *what it does*, in
that description's content; *what it takes*, the use's command line
and a JSON Schema object over its arguments, the converged input-schema
form, each input named for the caller and an omitted input's treatment
stated; *what it returns*, what the use writes to standard output on
success — a JSON Schema where the output is structured, a stated text
form where it is not; *how it fails*, a list in which each entry
carries a stable code from a closed, documented set, the exit status,
the condition that produces it, and the caller's next step —
man-pages(7)'s EXIT STATUS form with the code the designer's
attachment requires. *The contract artifact:* the tool-description
data type at `basis/types/tool-description.md`, written under this
record and approved through the definition chain, is the versioned
contract a tool answers to — it carries the flag's name, the shape's
field names (named for the caller, entered in the vocabulary), the
closed set of failure codes, and the relationship kind: the shape a
published language, the answering tool an open host service. *The
digest gate:* the skill carries `source:`, the tool it was produced
from, and `source-digest:`, `sha256:` plus twelve hex digits over the
answer's bytes as written; the load-point check re-asks the tool,
re-digests, and treats a difference as drift to re-render. *The
stand-in description:* a tool that cannot answer is used through a
description written beside it in the same shape, at the home the data
type names, its skill produced from the file and gated on the file's
digest, until the tool answers. *The JSON bound:* the answer is JSON,
which every language the shop's tools are written in serializes from
its standard library — the stack bound this decision folds in, adding
no dependency and binding no shop's language.

### 2.1 Principles screen

Screened against the
[architecture principle set](../basis/architecture-principles.md):
conforms on five; `intent-provenance` rests on the exception
[adr-2026-09-04-request-front-end](adr-2026-09-04-request-front-end.md)
carries, escalated to the authority (work item lead-4kymc).
`knowable-shape` — the answer is the tool's description, sufficient
without its source; a tool with no answer and no beside-description is
not yet usable, whatever code exists. `contracts-between-contexts` — a
tool from another shop is reached through its answer alone, and the
tool-description data type is the named, versioned contract it answers
to: the schemas exchanged (the shape), the meaning of the one
operation (the flag), the error behaviour (the failure codes and
"cannot answer"), and the relationship kind (published language; open
host service). `actor-neutral-discipline` — every step's use of a tool
is the skill's invocation whoever performs the step, and a
beside-description is written and gated under the same rule whoever
writes it. `local-comprehension` — the skill is the designated
artifact for using a tool at the shop's level, the answer the artifact
for producing the skill, the source below both.
`bidirectional-conformance` — this record precedes the flag; forward,
the initiative's measure (1 of 11, then 11 of 11); reverse, a skill
whose digest no longer matches the tool's answer is regenerated or
removed, and a beside-description for a tool that answers is a second
home, removed. `intent-provenance` — the request, the discovery
conversation, the initiative, and this record are each recorded; the
operational contract the request entered through has no artifact yet
— the cited exception.

## 3. Consequences

- Every owned framework tool answers the flag. What changes: the four
  compilers, the lint, and `compile_tool.py` — the compiler this
  decision adds, below — each gain one handler that composes the
  answer and exits before any other action. For whom: the solutions
  architect role, which maintains the shop's tools. Cost: one handler
  per tool, six; the lint's first, as the proof; a tool whose parser
  swallows unknown flags today, as the lint does, must answer the flag
  before parsing anything else. Forecloses: `--help` as the source of
  any skill; a tool with no answer and no beside-description at the
  load point.
- The shape gets one home. What changes: the tool-description data
  type at `basis/types/tool-description.md` fixes the field names of
  the parts §2 names, the closed set of failure codes, and the
  relationship kind, and enters its names in the vocabulary; approved
  through the definition chain, with the designer role screening the
  field names before this record is checked, as its attachment asks.
  For whom: the product authority, who owns and approves definitions;
  the designer role; every tool author, who answers in it. Cost: one
  type definition and its approval; a change to the shape is a change
  to what every answering tool owes, versioned there. Forecloses: a
  per-tool variant of the shape.
- Tool skills become renderings of answers. What changes:
  `compile_tool.py`, a compiler on the `compile_process.py` pattern,
  asks each tool, writes its skill — the description as the skill's
  what-and-when, the body naming each use's exact invocation, output,
  and failure codes, the format the harness activates — and stamps
  `source` and `source-digest`; the load-point check that today names
  a non-process `source:` `unrecognized` is amended, or a sibling
  process for tool skills defined, so that a tool source is recognized
  and checked by re-asking and re-digesting. For whom: the solutions
  architect role, maker of `compile_tool.py`; the owner of the
  skill-rendering process, whose definition amends. Cost: one
  compiler, itself a framework tool that answers the flag; one process
  amendment; a standing `unrecognized` escalation for every tool skill
  placed before the amendment lands. Forecloses: a hand edit of a tool
  skill — it is drift, and the next render overwrites it.
- A tool that cannot answer gets a beside-description. What changes:
  for each of the six external tools, the shop that runs it writes a
  description in the shape at the home the data type names, carrying
  which tool it stands beside and who owns that tool; `compile_tool.py`
  produces the skill from the file and gates it on the file's digest;
  the tool's lack of an answer is recorded as a gap against its owner.
  For whom: the lead shop, as writer; the owning shops, as the gap's
  addressees once the shop is unfrozen. Cost: six hand-written
  descriptions; drift between such a description and its tool is
  unreached by any check until the tool answers — the initiative's
  second feature carries them. Forecloses: nothing — a
  beside-description is retired when its tool answers, and a
  beside-description standing for a tool that answers is a finding.
- Every step runs a tool through its skill. What changes: a step's
  use of a tool is the skill's invocation — the exact invocation the
  answer gave — whoever performs the step; a step that cannot load a
  skill carries that same invocation, so the record of the step is the
  same either way. For whom: every agent of the shop; process authors.
  Cost: none beyond reading the skill; the skill's metadata joins what
  the harness pre-loads.

Bound on Bounded Context shops, stated as one: a framework tool a BC
shop offers to the product MUST answer `--describe` in the shape the
tool-description data type defines, and the product produces that
tool's skill from the answer and from nothing else — never from the
tool's source. A BC shop's tool that does not answer is reachable only
through a beside-description the consuming shop writes, and its
absence of an answer is a gap recorded to the offering shop. The
shop's own skill for the tool, shipped in lockstep as the working
principle asks, is produced from the same answer. Within the bound
the BC shop chooses: its tools' language, parser library, and how the
answer is composed are its own.

## 4. Reversibility

Reversible at low cost while only the lead shop's tools answer: six
handlers removed, `compile_tool.py` deleted, the data type retired,
the skills hand-written or removed, the load-point check restored
from source control. Hard once a BC shop's tool answers and a skill
at any load point is produced from that answer: the flag and the
shape are then a published language two or more shops build to, and
each reversal is a contract change per shop, with every skill
produced from an answer re-sourced. Review triggers: a published
standard for a machine-readable command-line self-description appears
— finding 8 was an inference from absence, and the report names such
a standard as what would change its judgment — so the shape is
re-based on it; the harness stops activating a skill produced this
way; a tool whose uses the shape cannot carry — streaming output, an
interactive prompt — so the data type cannot be answered in; the
product adopts a runtime-served channel for tool descriptions, the
MCP option declined in §1, so the answer is served there and this
flag is its export; the beside-descriptions outnumber the answering
tools after the initiative's second feature — the bound not reaching
the tools it was set for.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Authored through the adr-authoring process (v3) at its author step, invoked as the initiative check's route for the decision the lead-solutions-architect role's attachment to init-tool-skills (v4, Document History v3, its first decision entry) left unrecorded, before the bet. Right: `guardrail` — a bound BC shops choose within, decided by this role; whether the role held it is the PM role's ruling at the check. The stack bound (JSON, serialized from a standard library) folded into the one decision as the offer stated, so no second record is raised for it. The initiative's first unknown — the flag's name and the answer's serialization — taken as this record's to fix; the reasons are in §1 as of v2. Candidates for later records, not decided here: (1) the data type's field names and the beside-description's home — the feature's make, approved through the definition chain; (2) whether skill-rendering amends to recognize a tool source or a sibling process is defined for tool skills — the process owner's; (3) how the gap for a tool that cannot answer is recorded to its owner while the shop is frozen; (4) whether the product adopts a runtime-served channel for tool descriptions (the report's alternative 3). The count of framework tools is the PM role's, reported not rewritten. Maker's self-check against the adr fitness set and guideline, as define-good-up-front asks: scenario 1 — the title one line, the decision sentence one decision; scenario 2 — forces and pre-state with their evidence, five real options each with its reason against; scenario 3 — `decided-by` and `right` in the frontmatter and §1; scenario 4 — five consequences each with what changes, for whom, cost, and what it forecloses, the bound on BC shops stated as one with MUST; scenario 5 — reversible now, hard after the first BC shop's tool answers, five triggers; scenario 6 — the screen after §2, conforms on five, `intent-provenance` resting on the standing exception, no new escalation. Status draft pending the screen. |
| 1 | 2026-09-07 | review | Screen round 1, the one screen (judge: claude-fable-5-1 / screen prompt v6): four confident — `actor-neutral-discipline`, the actor-kind split in consequence five ("a step with no agent may still carry the bare command"); labels used without their content (D1, U1, U3, U5, R1, R2, R3, "finding 1"); the new compiler unnamed and the compile_process.py pattern unintroduced; the principles screen unnumbered — and four wobbly, ruled by the lead-pm: scenario 1, the decision as one sentence with the parts after it, said to be one guardrail; `contracts-between-contexts`, the contract artifact to be named; the `--describe` reasoning to move from the history into §1; the agent-facing form the name regex is borrowed from to be named. The designer role's attachment (initiative v5, its D2) added to the subject for the shape's parts. |
| 2 | 2026-09-07 | update | The one revise. Consequence five and the `actor-neutral-discipline` line re-stated: every step's use of a tool is the skill's invocation whoever performs the step, a step that cannot load a skill carrying the same invocation, the record the same either way. Every label replaced by its content — the initiative's decision entry, unknowns, and risks said in words; "finding 1" stated (GNU's `--help` requirement and its behaviour). The compiler named once, `compile_tool.py`, and `compile_process.py` introduced in the pre-state as the compiler that renders a process definition into its skill with its `source` and `source-digest` stamp. The principles screen numbered §2.1, a sub-part of §2. §2 re-formed: one sentence — the answer to `--describe` is the sole source of the skill — and the parts after it, named as one guardrail: the flag's behaviour, the answer's shape, the contract artifact, the digest gate, the stand-in description, the JSON bound. The contract artifact named — the tool-description data type at `basis/types/tool-description.md`, written under this record, carrying the flag's name, the shape's field names, the closed set of failure codes, and the relationship kind — in §2, in the `contracts-between-contexts` line with the four things a contract states, and in the second consequence. The `--describe` reasoning moved into §1 as a force (GNU's long options; `--help` taken, its behaviour fixed, argparse's pre-emption) and `--help=json` added as a sixth declined option. The name form attributed as the report has it: MCP's `name`, the tool's unique identifier, in the regex Anthropic's tool definition fixes — finding 2 cites both; the report's Appendix A places the regex with Anthropic's definition, so the record names both rather than MCP alone. The designer's D2 folded into the shape: the failure part carries a stable code from a closed, documented set beside the exit status, the condition, and the caller's next step; the field names named for the caller and entered in the vocabulary when the data type is made; the designer role screens the field names before this record is checked (second consequence); the answer on standard output, exit 0, before any other action, kept. Maker's self-check re-run against the six scenarios: one sentence in §2 (scenario 1); six options in §1 (2); decider and right unchanged (3); five consequences priced, the bound stated as one (4); reversibility and five triggers, `compile_tool.py` named (5); the screen at §2.1, its result unchanged (6). Context re-counted under half the record by word count; the lint passes on the tree. |
| 3 | 2026-09-07 | state | `draft` → `checked`: the PM role's pass after the one screen and the one revise — the principle finding (the actor-kind split) repaired, the decision stated as one sentence with its parts as one guardrail, the contract artifact named; the record made through the initiative check's pre-bet route on init-tool-skills' one unrecorded decision. Decider the solutions architect role under its guardrail right; checked for form. |
| 4 | 2026-09-07 | update | Two readings by the lead-solutions-architect role at the delivery of feat-tool-skills-rest (v7), the guidance's seventh item; §1–§4 unchanged. (1) The relationship kind for each of the six external tools, read against §2 and the bound in §3: conformist for all six — bd, shop-msg, shop-knowledge, agent-vault, bc-emit, shop-templates — each used through a description the lead shop wrote beside it from what the tool shows whoever runs it, no promise in it owed by the owner; the kind becomes the record's published language and open host service for a tool the moment it answers, none having done so. (2) The fifth review trigger — the beside-descriptions outnumbering the answering tools after the second feature: six descriptions stand beside six answering tools (the lint and the five compilers), equal, the trigger not fired. Also read: the four consequences delivered as this record prices them — five handlers for the compilers, one process amendment (skill-rendering v9), six descriptions, the digest gate over the descriptions' bytes; no dependency, vendor, or recurring cost added (the compilers' answers are JSON from the standard library, the schema block read through PyYAML as before). |
