---
type: research-index
id: research-index
owner: product-authority
status: approved
version: 6
created: 2026-08-23
updated: 2026-08-25
---

# Research index

The single register of research reports. Bodies live on the
`research` branch and never leave it; this index is what the live
system carries; it loads only inside a research activity.

## Reports

| Id | Question | Date | Status | Location |
|---|---|---|---|---|
| pm-po-one-role-2026-08 | Are the product manager and product owner the same role with different activities, and what is served by having two roles in this system? | 2026-08-25 | delivered | `research:research/pm-po-one-role-2026-08.md` |
| product-designer-role-2026-08 | What should a product designer role own in the lead shop, and how does one role keep the user experience consistent across every interaction type — CLI, TUI, GUI, API, conversational, voice? | 2026-08-25 | delivered | `research:research/product-designer-role-2026-08.md` |
| pm-po-roles-2026-08 | How does industry define the product manager and product owner roles — accountabilities, decision rights, deliverables — and the interactions between them and with the solutions architect? | 2026-08-25 | delivered | `research:research/pm-po-roles-2026-08.md` |
| solutions-architect-role-2026-08 | How does industry define the solutions architect role, and how would it replace lead-architect as lead-solutions-architect — owning product-wide technology stack decisions — complementing lead-po and lead-pm? | 2026-08-23 | delivered | `research:research/solutions-architect-role-2026-08.md` |
| research-prompting-2026-08 | What should a prompt — and the role and process behind it — contain for an agent to do rigorous research? | 2026-08-23 | delivered | `research:research/research-prompting-2026-08.md` |

## Reading a report

`git show <branch>:<path>` — e.g.
`git show research:research/research-prompting-2026-08.md`.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-23 | update | Created by owner direction, replacing the README stub; first row registers the research-prompting report. |
| 2 | 2026-08-23 | update | Moved from `main` to the `rebaseline` branch by owner direction; `main` carries nothing. |
| 3 | 2026-08-23 | update | Row added: the solutions-architect role report, delivered. |
| 4 | 2026-08-25 | update | Row added: the PM/PO roles report, delivered. |
| 5 | 2026-08-25 | update | Row added: the product designer role report, delivered at both round caps with residuals disclosed. |
| 6 | 2026-08-25 | update | Row added: the PM/PO one-role report, delivered (verification at cap with one label residual; cold read clean). |
