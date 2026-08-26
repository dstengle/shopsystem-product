---
type: quality-guideline
id: experience-cli-guideline
target-type: interaction
interaction-type: [cli, tui]
owner: product-authority
status: approved
approved: 2026-08-26
version: 3
created: 2026-08-26
updated: 2026-08-26
---

# Guideline: command-line and terminal interactions

**Voice principle.** Write the command line for the person at the
prompt who has not read the manual and for the script that will run
the same command unattended: every command guessable, every output
readable by whichever of them consumes it, and every failure a
sentence that says what to do.

**Highlights (the layer compiled into generating context):** prose for
a terminal, data for a pipe · flags over positional arguments, and a
flag for anything a prompt would ask · help at every level, on one
screen · a non-zero, distinct exit code on failure, the internal error
behind a verbosity flag · a full-screen terminal interaction keeps
keyboard reach and a fixed reading order, with the same tasks on the
plain command line.

**Layers:** this guideline covers the command-line (`cli`) and
full-screen terminal (`tui`) interaction types and layers their idiom
on the common experience guideline, which carries vocabulary, errors,
core tasks, and accessibility for every type. Its platform guideline,
named by the corpus, is the Command Line Interface Guidelines
(clig.dev), with the Heroku CLI style guide for output conventions;
where the two differ, clig.dev governs. No authoritative full-screen
terminal guideline exists; rule 5 derives from clig.dev and WCAG2ICT. Precedence when rules conflict: an approved principle beats the
[quality-guideline typedef](../artifacts/quality-guideline.md), which
beats the [common experience guideline](experience-common.md), which
beats this one; the base writing style is never overridden. Every rule
feeds scenario 6 of the
[interaction fitness set](../fitness/interaction.fitness.md), judged by
the product designer role, and names the principle bullet or the
corpus-named platform guideline (through `consistent-not-uniform`
bullet 2) it derives from.

---

## Rules

**1. Prose for a terminal, data for a pipe.**
Before: a table with box-drawing characters and colour written to
stdout whether or not stdout is a terminal.
After: the table when stdout is a TTY; one record per line, no colour,
when it is not; `--json` for a structured form on request.
*Test:* run the command with stdout as a TTY and with stdout piped.
*Criterion:* the TTY output is readable prose or a table in which no
meaning rests on colour alone; the piped output is line-oriented data
without escape codes; a `--json` or
`--plain` flag exists where the output has structure. *Decision:*
yes/no per command.
*Derived check:* judged — interaction fitness scenario 6; clig.dev
"Output" via `consistent-not-uniform` bullet 2.

**2. Prefer flags; never require a prompt.**
Before: `deploy production main` — three positionals whose order the
user must remember; a confirmation prompt with no way to pre-answer.
After: `deploy --env production --ref main --yes`, with the prompt
shown only when stdin is a TTY and `--yes` absent.
*Test:* list each command's inputs and each prompt. *Criterion:* every
input beyond one primary argument is a named flag; every prompt has a
flag that supplies its answer, and the command shows no prompt when
stdin is not a TTY. *Decision:* yes/no per command.
*Derived check:* judged — interaction fitness scenario 6; clig.dev
"Arguments and flags", "Interactivity" via `consistent-not-uniform`
bullet 2.

**3. Help at every level, on one screen.**
Before: `tool --help` prints forty options in alphabetical order with
no example.
After: `tool --help` shows the purpose in one line, the three most
common commands with an example each, and where to find the rest;
`tool <command> --help` does the same for the command.
*Test:* run `--help` at the top level and for each command; count
lines at 80 columns. *Criterion:* purpose, examples, and the common
path fit in 24 lines; every flag has a one-line description beginning
lowercase without a trailing period. *Decision:* yes/no per help text.
*Derived check:* judged — interaction fitness scenario 6; clig.dev
"Help" via `consistent-not-uniform` bullet 2.

**4. Failure has an exit code and keeps the internal error behind a
flag.**
Before: `Error: ENOENT: no such file or directory, open 'cfg.yml'`,
exit code 0.
After: `No config file at ./cfg.yml. Create one with \`tool init\` or
pass --config <path>.` on stderr, exit code 2; the original error
behind `--verbose`.
*Test:* trigger each error path. *Criterion:* the exit code is non-zero
and distinct from success; the message goes to stderr; the internal
error appears only behind a verbosity flag (the message's content is
the common guideline's rule 3). *Decision:* yes/no per error.
*Derived check:* judged — interaction fitness scenario 6; clig.dev
"Errors" via `consistent-not-uniform` bullet 2; the message content,
interaction fitness scenario 3.

**5. A full-screen terminal interaction stays reachable.**
Before: a TUI whose only sign of the current selection is a colour
change, whose panes redraw in an order a screen reader cannot follow.
After: the selection marked by a glyph and a label as well as colour;
every action with a key shown on screen; a fixed, announced reading
order.
*Test:* walk the interaction without colour and with a screen reader;
list each action's key. *Criterion:* meaning never rests on colour
alone; every action is keyboard-reachable and labeled (that the `cli`
type carries the same core tasks is the common guideline's rule 4).
*Decision:* yes/no per TUI.
*Derived check:* judged — interaction fitness scenario 6;
`accessible-by-standard` bullet 2 (the WCAG2ICT record itself is the
common guideline's rule 5).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction as the second layer of the experience guidance corpus, applying the approved experience principles to the command-line and terminal interaction types; external standard clig.dev, Heroku for output. |
| 1 | 2026-08-26 | review | Screened with the other four: findings — derived checks named no existing check; typedef did not admit the form; rules 1–3 cited no principle; rule 3's criterion had no number; plain CLI accessibility uncovered; vocabulary and error rules duplicated across files. |
| 2 | 2026-08-26 | update | Repairs: layered on the new common guideline (vocabulary, errors, core tasks, accessibility have one home); every derived check names the interaction fitness set and its derivation; rule 3 decidable at 24 lines; rule 4 reduced to the CLI-specific parts; rule 5 covers both types' tasks; typedef v3 admits the form. |
| 2 | 2026-08-26 | review | Re-screened: interaction-type named one value for two types; plain-CLI colour-not-alone absent; rule 5 restated the common core-task rule; an unsourced 'keyboard-first patterns'. |
| 3 | 2026-08-26 | update | frontmatter lists cli and tui; colour clause added to rule 1; rule 5 reduced to the TUI's reachability; the unsourced phrase cut. |
| 3 | 2026-08-26 | review | Final screen (round 3): clean — every rule decidable with a named scenario and derivation; two line edits and three optional stumbles polished in place. |
| 3 | 2026-08-26 | state | draft → approved by the owner. |
