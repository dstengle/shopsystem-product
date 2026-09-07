---
type: initiative
id: init-tool-skills
name: Tool skills
status: proposed
version: 2
owner: lead-pm
created: 2026-09-07
updated: 2026-09-07
request: ../requests/req-2026-09-06-tool-skills.md
---

# Initiative: Tool skills

## Framing

Originator (product authority, 2026-09-06, through the lead shop's
operational contract, which has no artifact yet (lead-4kymc); the
request req-2026-09-06-tool-skills, its section 1): "Next thing we
need to do is make the tool skills or we won't be able to operate."
And in the review of evidence, on where a tool's description lives:
"Why not put a standard flag on the tools instead of analyzing the
source code? This would allow tools from other bounded contexts to be
used without needing access to the source code."

Problem: no framework tool the shop runs can be used through a skill,
so an agent that needs one reads its source or copies a prior command
— which the tools-through-skills principle now forbids — and a tool
from another shop could not be used at all without its source.
Outcome: every framework tool is usable through a skill that states,
for each use it supports, what it does, what it takes, what it
returns, and how it fails; the skill is produced from what the tool
says about itself in answer to one standard question, so a tool from
any shop is usable the moment it answers; a tool that cannot answer
has a description beside it in the same shape; and a change to what a
tool says about itself reaches its skill.

## For whom

Every agent of the shop that runs a tool, and the shops whose tools
the product accepts. Measure: framework tools usable through a skill
produced from the tool's own answer. Now: 0 of 10 (five compilers and
the lint the shop owns; four external tools it runs). Target: 1, the
lint — the tool every session runs — proven end to end; then the
rest as a second bet. Interaction types: none — a skill is read by an
agent inside a process step; no core task carries it.

## Appetite

One working session of the lead shop for the proof on the lint: the
standard question and the shape of its answer, the lint answering it,
the skill produced from the answer and current with it by a check, an
agent running the lint through the skill. No-gos, each with its
reason:

- The other nine tools — a second feature the proof's pass
  authorizes in advance (the authority: "If it passes then proceed to
  the rest without asking me"); the external tools' descriptions
  beside them until their owners answer the question.
- Reading a tool's source to describe it — the authority's direction:
  the tool answers, the source stays its own.

## Feasibility and usability

Not yet.

## Decomposition

Not yet.

## Features

None yet.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Recorded `proposed` by the discovery conversation's frame step, on the authority's convergence — "Prove it on the lint first" (work item lead-igvr4; session sess-2026-09-06-c; review-of-evidence form). Evidence reviewed: the framework tools and how an agent learns each today (none of the five compilers or the lint answers --help; the work register's flags copied script to script); the research report tool-self-description-2026-09 (on the research branch), whose recommendation — the tool is the source, the skill generated from its export, the generated skill gated — the authority sharpened: the export is the tool's answer to a standard flag, not a walk of its source, so tools from other Bounded Contexts are usable without source; the digest over the answer; the flag and its answer's shape a guardrail for the architect to record; definitions beside tools that cannot answer. |
| 2 | 2026-09-07 | update | The authority's standing direction for this initiative, recorded before the check: "If it passes then proceed to the rest without asking me" — the bet and the flow through the proof on the lint, and the other nine tools as a second feature on the proof's pass, without a further ask; the appetite's first no-go reworded to say so. |
