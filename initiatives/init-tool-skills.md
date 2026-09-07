---
type: initiative
id: init-tool-skills
name: Tool skills
status: proposed
version: 5
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
produced from the tool's own answer. Now: 0 of 11 (four compilers and the
lint the shop owns; six external tools it runs). Target: 1, the
lint — the tool every session runs — proven end to end; then the
rest as a second bet. Interaction types: none — a skill is read by an
agent inside a process step; no core task carries it.

## Appetite

One working session of the lead shop for the proof on the lint: the
standard question and the shape of its answer, the lint answering it,
the skill produced from the answer and current with it by a check, an
agent running the lint through the skill. No-gos, each with its
reason:

- The other ten tools — a second feature the proof's pass
  authorizes in advance (the authority: "If it passes then proceed to
  the rest without asking me"); the external tools' descriptions
  beside them until their owners answer the question.
- Reading a tool's source to describe it — the authority's direction:
  the tool answers, the source stays its own.

## Feasibility and usability

Feasible in one session: the lint, the renderer, and the load-point
check all sit in the lead shop's tree. Unrecorded decision the bet depends on:
the standard flag, its answer's shape, and the answer as the skill's
source — an ADR before the bet. Risks: the load-point check rejects a
tool skill until amended; §2's count. Full offer: history v3.
(architect, 2026-09-07)

Usability: none due — §2 names no interaction type. Stated
regardless, the skill and flag being agent-facing interfaces the
corpus screens (`agent-is-a-user`): a hypothesis until the proof's
last part runs as measured task completion — one agent, fresh context,
the skill its only source, the lint's uses completed and one failure
read as the skill states it. Full offer: history v5. (designer,
2026-09-07)

## Decomposition

None: no Bounded Context is touched — every change sits in the lead
shop's tree; no contract exists on this branch. Cross-context flow:
none.

## Features

None yet.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Recorded `proposed` by the discovery conversation's frame step, on the authority's convergence — "Prove it on the lint first" (work item lead-igvr4; session sess-2026-09-06-c; review-of-evidence form). Evidence reviewed: the framework tools and how an agent learns each today (none of the five compilers or the lint answers --help; the work register's flags copied script to script); the research report tool-self-description-2026-09 (on the research branch), whose recommendation — the tool is the source, the skill generated from its export, the generated skill gated — the authority sharpened: the export is the tool's answer to a standard flag, not a walk of its source, so tools from other Bounded Contexts are usable without source; the digest over the answer; the flag and its answer's shape a guardrail for the architect to record; definitions beside tools that cannot answer. |
| 2 | 2026-09-07 | update | The authority's standing direction for this initiative, recorded before the check: "If it passes then proceed to the rest without asking me" — the bet and the flow through the proof on the lint, and the other nine tools as a second feature on the proof's pass, without a further ask; the appetite's first no-go reworded to say so. |
| 3 | 2026-09-07 | update | Feasibility and decomposition attached by the lead-solutions-architect role at initiative-check (v9)'s attach-architecture step, from its one-sentence prompt. The full offer, in the role-offer type's parts, which the 500-word rule keeps out of §4 (§1–3 stood at 442 words): *role* — lead-solutions-architect. *verdict* — feasible within the appetite: one session for the proof on the lint. Reasons: every part of the proof sits in the lead shop's tree — the lint under basis/tools, the renderer beside the four compilers, the skill at the load point .claude/skills/, the check in the skill-rendering process — so no contract, no dispatch, and no Bounded Context is in the way of the frozen shop; the shape of the work is the typedef-rendering precedent (one definition, one compiler, renders, a current-with check, delivered in one session under adr-2026-09-05-typedef-rendering) applied to a new source kind, the tool's answer in place of a definition; the pattern the load point already runs — a rendering gated on a source digest (skill-rendering v7's check: a fresh render diffed against what stands, a `source-digest` in every rendered skill) — carries over unchanged with the digest taken over the answer, which is what makes "a change to what a tool says about itself reaches its skill" a check and not a promise; the tools are argparse-based Python on the standard library, so the flag adds no dependency, no vendor, and no recurring cost — nothing crosses the cost threshold the authority has not yet set. Not feasible as some readings of the outcome would have it: the answer cannot be the tool's `--help` text — argparse gives a home to what a tool does and what it takes but none to what it returns or how it fails (the research report's F1 and F3), and the lint today answers `--help` by running its normal function (observed 2026-09-07: `PASS: 0 violation(s)`, exit 0); so the answer is a structured shape the tool composes, and the lint must answer the flag before doing anything else. *decisions* — entries: D1, decision: "Every framework tool describes itself in answer to one standard flag, in one shape stating per use what it does, what it takes, what it returns, and how it fails, and its skill is produced from that answer and gated on a digest of it; a tool that cannot answer has a description beside it in the same shape" — a platform guardrail under this role's `guardrail` right: hard to reverse once tools from other shops answer it and their skills are produced from the answer, since the flag and shape are then a contract those shops build to — the relationship kind a published language, the answering tool an open host; the shape to adopt an established external form as external-standards-first asks (the agent-facing tool definition the research report finds converged on — name, description, input schema, output schema, F2 high — with the failure part added, since no opened form carries exit conditions), serialized in a standard-library form, so the stack bound is inside this one decision and no second decision entry is raised for it; record: none — the subject ready for adr-authoring through the check's route-decisions step. No other decision in this role's domain is raised: the decomposition is none (below); the integration strategy — the flag as the only channel by which a tool's shape reaches the shop — is D1's consequence; no non-functional requirement is set by this initiative. *risks* — R1: skill-rendering v7's check step names any load-point skill whose `source:` is not an approved process definition `unrecognized` and escalates it by path on every run, so a tool skill placed at .claude/skills/ without that process amended — or a sibling process for tool skills — is a standing escalation, and the measure ("usable through a skill") holds only while the load-point check stays clean; the amendment is a process definition's, the owner's domain, recommended at the feature's make step, carried in the same session. R2: the measure's denominator — §2 counts ten (five compilers and the lint; four external); basis/tools holds four compilers and the lint, and the discovery's evidence table (sess-2026-09-06-c) names six external tools (bd, shop-msg, shop-knowledge, agent-vault, bc-emit, shop-templates) — eleven by the evidence, twelve once the answer's renderer exists, itself a framework tool that must answer; the PM role's to settle, reported not rewritten; the target of one on the lint is unaffected, the second feature's "rest" is. R3: the answer's shape must carry returns and failures as fields of its own, or the skill states neither and the tools-through-skills principle's first statement is not met — the proof's check must read those fields present, not the flag answered. R4: the external tools' beside-descriptions are hand-written and no gate reaches them until their owners answer; drift there is unreached by this bet's check — inside the no-go, named for the second feature. R5: the appetite — the ADR runs before the bet through the check's route and is outside the session; inside it are the lint's answer, the renderer, the load-point check's amendment, the skill, and one run of the lint through the skill — the typedef-rendering precedent fit one session with the same parts; tight, not over. *unknowns* — U1: the flag's name and the answer's serialization — the ADR's to fix; default: a long option in the GNU form, answered on standard output with exit 0 and no other action (the standard's rule for `--help`: other arguments ignored, the normal function not performed), JSON as the standard-library form. U2: whether the harness activates a tool skill at .claude/skills/ as it does a process skill; default: yes — the Agent Skills format is one format (the report's F4), the description model-judged, the body naming each use's exact invocation; the proof's last part observes it. U3: which compiler renders the tool skill; default: a new compiler beside the four, one compiler per source kind as compile_role and compile_typedef set the precedent, its own skill among the second feature's rest. U4: the uses the lint's skill states — the definitions name three (bare, over the basis; `--derive-chain <artifact_type>`; `--process <path>`); default: the lint's answer decides, the definitions' three checked present in it. U5: whether the external tools' owners can be asked while the shop is frozen; default: no — beside-descriptions in the answer's shape, the second feature. *evidence* — the initiative (v2); req-2026-09-06-tool-skills (v3); the research report tool-self-description-2026-09 (v3, research branch — spike findings, read as the authority's evidence, not as authority); features/ read in full — five features, all assigned and delivered in the lead shop's tree, no scenario naming a framework tool, its description, a tool skill, or a flag; touch-points: feat-skills-availability's scenarios over the load point (@hash:4899d4bba6ad, the clean pass; @hash:26f78a3ca4a6, the reconcile) and skill-rendering's `unrecognized` finding, which a tool skill meets — R1 — and which contradicts nothing once the source kind is recognized; no conflict; contracts: none exist on this branch; decisions/ — five ADRs and five PDRs, adr-2026-09-05-typedef-rendering and adr-2026-09-03-role-rendering as the generate-then-gate precedent; the architecture principle set (v6); the working principle set (v11, `tools-through-skills`); the glossary (v23: framework tool, skill, gap); skill-rendering (v7); initiative-check (v9); the role-offer type (v2); the initiative typedef (v11) and fitness set (v5); sess-2026-09-06-c; the tools under basis/tools observed by running each with `--help`, not read: the lint runs its normal function, compile_process reads the flag as a file path, compile_principles exits on a traceback, compile_role and compile_typedef print a usage sheet. *Principle screen* — knowable-shape: the answer is the tool's description sufficient without its source — conforms, the rule extended to tools; contracts-between-contexts: a tool from another context reached through its answer alone, the flag and shape a named contract with a stated relationship kind — conforms; actor-neutral-discipline: the skill's use binds whoever runs the tool — conforms; local-comprehension: the skill is the designated artifact for using a tool at the shop's level, the source below it — conforms; bidirectional-conformance: forward, every framework tool has a skill or a recorded gap; reverse, a skill whose tool no longer answers as digested is a finding — conforms; intent-provenance: request → initiative → the record, each step recorded — conforms. No principle a design cannot satisfy; no exception to escalate; no vendor or recurring cost. *Maker's self-check* against the initiative fitness set — scenario 5: the verdict with reasons in §4, the five parts each present here, none reading "none" but `record`; scenario 6: contexts (none), relationship kind (no contract relied on), flow (none) in §5; scenario 7: 528 words after this attachment (wc) — over 500 by 28, within the 20% variance the owner ruled at the init-role-decisions bet (its Document History v8) while the cap's split, adr-2026-09-05-role-offer's first candidate, stands unruled; §1–3 untouched. |
| 4 | 2026-09-07 | update | The architect's R2 taken: the measure's denominator corrected from ten to eleven (four compilers and the lint owned; six external tools run), the second feature's count with it. |
