---
type: experience-record
id: experience-patterns
record: patterns
owner: product-authority
status: draft
version: 4
created: 2026-08-26
updated: 2026-09-07
maintained-by: lead-product-designer
---

# Experience record: interaction patterns

The recurring shapes an interaction takes, per interaction type, and
the platform guideline each follows. Read by the
[common experience guideline](../guidelines/experience-common.md)
rule 2, the [graphical guideline](../guidelines/experience-gui.md)
rule 1, and the
[interaction fitness set](../fitness/interaction.fitness.md) scenario
2. An entry means: an interaction of that type with that need takes
this shape, or records a variation. Seeded with the patterns the
approved guidelines already name; each is a hypothesis until an
interaction of the type exists and the shape is tested.

## Entries

| Pattern | Where it applies | The shape | Platform guideline it follows | Source | Status |
|---|---|---|---|---|---|
| error message | every type | what happened, in the vocabulary; the cause; one next step; identifiers alongside | Command Line Interface Guidelines (clig.dev) "Errors"; WCAG 2.2 success criteria 3.3.1 and 3.3.3 for gui | common guideline rule 3 | hypothesis |
| confirmation before the hard-to-reverse | conversational, voice; gui; cli when interactive | state the action and its irreversibility; ask; proceed only on yes; a flag or setting to pre-answer | Microsoft's Guidelines for Human-AI Interaction, G16; clig.dev "Interactivity" | assistant guideline rule 2; cli guideline rule 2 | hypothesis |
| help | cli, tui; conversational, voice | purpose in one line; the common path with an example; where the rest is | clig.dev "Help"; Microsoft's Guidelines for Human-AI Interaction, G1 | cli guideline rule 3; assistant guideline rule 1 | hypothesis |
| structured output on request | cli; api | a `--json` or equivalent form beside the human-readable one | clig.dev "Output" | cli guideline rule 1 | hypothesis |
| primary action placement | gui | one primary action per screen, placed where the platform's guideline puts it | the platform's published interface guidelines — to be named per platform when a graphical interaction exists | gui guideline rule 1 | hypothesis |
| tool-skill use entry | api — a framework tool's skill, the agent tool definition an agent reads with nothing else about the tool | one entry per use the tool supports, five parts in this order, each present as itself and none read off another: (1) what it does — the use's effect, and what it does not do; (2) what it takes — each input named for the caller with its meaning, and an omitted input's treatment: the default taken, or that it is required; (3) what it returns — what the use writes to standard output on success, and its form; (4) how it fails — one line per failure: the failure code, the exit status, the condition, the next step — the error pattern above with the code required, the code beside the condition and never in place of it; (5) the exact invocation — the one command line the agent issues for the use, copyable as written, an input's placeholder in angle brackets. Around the entries, the skill's `description` names the tool and its uses in one or two sentences so the harness offers the skill for the task; the skill says nothing about the tool that its answer does not say. Every name the vocabulary's word or its recorded api mapping | Anthropic's guidance on the agent-computer interface, for the tool definition (the api guideline's Layers); man-pages(7) EXIT STATUS, for the failure list; the Agent Skills format the harness loads, for the skill's frontmatter | api guideline rules 1–3; adr-2026-09-07-tool-answer §2; feat-tool-skills, the scenario "each use entry in the lint's skill is complete" and criteria (a)–(c); init-tool-skills, Document History v5, the designer role's first decision entry | hypothesis |

## Checks

[Common experience guideline](../guidelines/experience-common.md)
rule 2; [graphical guideline](../guidelines/experience-gui.md) rule 1;
[interaction fitness set](../fitness/interaction.fitness.md) scenario
2.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Seeded with the five patterns the approved guidelines name. |
| 1 | 2026-08-26 | review | Screened: findings — the GUI pattern named no guideline; HAX unexplained; commitments for interactions that do not exist unlabeled. |
| 2 | 2026-08-26 | update | Repairs: the GUI guideline marked to be named per platform; the human-AI guidelines named in full; every entry marked hypothesis; tokens from the closed set. |
| 2 | 2026-08-26 | review | Re-screened: clean. |
| 2 | 2026-08-26 | review | Re-screened (round 3): clean. |
| 3 | 2026-09-07 | update | The tool-skill use entry pattern entered for the `api` type as a hypothesis by the lead-product-designer role — the decision its attachment to init-tool-skills recorded (Document History v5, the first decision entry: a tool skill's use entry takes one shape per use, entered in this record rather than in a decision record, this role's decisions landing in the corpus) and its own resulting action at feat-tool-skills (v2: criteria (a)–(c), and the scenario "each use entry in the lint's skill is complete", whose Then this shape states), under adr-2026-09-07-tool-answer (v3, checked: §2 the answer's shape — the four parts per use; §3 the third consequence — the skill's body naming each use's exact invocation, output, and failure codes; §2 the stand-in description). The shape: what the use does; what it takes, each input named for the caller, omitted inputs' treatment; what it returns; how it fails, each failure a stable code beside its condition and next step — the error pattern with the api guideline's rule 3 tightening; the exact invocation; and the skill's `description` naming the tool and its uses. The names are the vocabulary's (v4, the same day). The api guideline's rule 2 also asks whether a retry is safe and what a replay returns; not a part here — the framing names four parts and the feature's scenarios state them; whether a fifth is wanted is the delivery screen's finding to the solutions architect role (feat-tool-skills, criterion (b)). Hypothesis until an agent's use is observed — the feature's last three scenarios, read as measured task completion. The feature and the initiative untouched. Maker's self-check against the experience-record typedef (v3) derived checklist, as define-good-up-front asks: `record` patterns and `maintained-by` present; the columns pattern · where it applies · the shape · platform guideline · source · status unchanged; the entry carries a status and a source naming definitions; the platform guideline named by name; the interaction type the closed token `api`; the Checks section unchanged. The lint could not be run from this session (no shell); its mechanical checks applied by hand — frontmatter and version present, Document History last, no link added, no banned term, no numbered-decision reference. |
