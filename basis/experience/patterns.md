---
type: experience-record
id: experience-patterns
record: patterns
owner: product-authority
status: draft
version: 2
created: 2026-08-26
updated: 2026-08-26
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
