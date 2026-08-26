---
type: fitness-set
id: backlog-order-fitness
owner: product-authority
status: approved
approved: 2026-08-26
version: 3
created: 2026-08-26
updated: 2026-08-26
target-type: backlog-order
judged: true
executable: false
judged-by: cold-reviewer
---

# Fitness set: backlog order

A backlog order is the PO role's ordered list of requirements within
the PM role's framing — the PO role's exclusive decision — as submitted for
the PM role's check. These scenarios are the criteria set the
[PO output check](../processes/po-output-check.md) screens an order
against, alongside the framing (criterion `framing`). Evaluated by the
`cold-reviewer` role, never executed. The judge's model and prompt
version are recorded with each round verdict.
The judge reads only the criteria set, the framing, and the artifact;
every scenario therefore asks for what the artifact itself carries, and
a fact it must carry — a term's definition, a reference, a reason — is
what these scenarios make it carry. These scenarios stand in for the
pending backlog-order typedef — no definition yet treats the order as an
artifact — and are its first draft; the typedef inherits them. Scenario 1 overlaps the
process's `framing` criterion by design: the process passes one
framing and an order spans many. What the
judge cannot catch from the order alone — a recommendation omitted, a
wrong context — is the solutions architect role's to raise through its
interface with the PO role.

## Scenarios

Scenario 1: every item serves a framing
  Given each item in the order
  When its framing reference is read
  Then it names the framing it serves, or is marked declined with a
  reason

Scenario 2: the order states the priority it follows
  Given the order's statement of the roadmap priority it was made
  against
  When the order is compared with that statement
  Then items serving a higher-priority framing precede items serving a
  lower one, or the order states a reason for each exception

Scenario 3: enabler work is placed or declined with reasons
  Given the order's list of enabler recommendations received from the
  solutions architect role
  When the order is read
  Then each recommendation appears in the order with its position
  reasoned, or is declined with a reason

Scenario 4: the order names each item's context
  Given each item
  When it is read
  Then it names the Bounded Context that owns it, and an item crossing
  contexts is marked as such with the escalation to the PM role named

Scenario 5: the next item says whether it is ready
  Given the first item not yet taken up
  When it is read
  Then the order marks it ready and links the brief or scenario set it
  states is checked (passed the PO output check), or marks it not ready
  and names what it waits on

## Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 — serves a framing | "For each item: framing named, or declined with a reason? Cite any item with neither." |
| 2 — follows stated priority | "Compare the order with the priority it states; cite each inversion and whether a reason is stated. Any unreasoned inversion = fail." |
| 3 — enablers placed or declined | "For each recommendation the order lists: placed with a reasoned position, or declined with a reason? Cite any that is neither." |
| 4 — context named | "Does each item name its owning Bounded Context, with cross-context items marked and their escalation named? Cite any that does not." |
| 5 — next item ready | "Is the first untaken item marked ready with the artifact it states is checked linked, or not ready with what it waits on? Cite." |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction as the criteria set the PO output check screens a backlog order against; rests on the lead-po role's exclusive domain and interfaces (priority from the PM role, enablers and decomposition from the solutions architect). |
| 1 | 2026-08-26 | review | Screened: findings — scenarios 2–5 rested on the priority, recommendations, decomposition, and other artifacts' status, none of which the screen loads; typedef-pending note missing; cross-context items lacked the escalation. |
| 2 | 2026-08-26 | update | Repairs: every Given re-based on what the order itself states; what the judge then cannot catch named and routed to the architect's interface; scenario 1's overlap with `framing` justified inline; escalation named; typedef-draft status stated. |
| 2 | 2026-08-26 | review | Re-screened: findings — scenario 5 read another artifact's status; the framing-overlap note sat inside a Then; "checked" unglossed; the intro misassigned the exclusive decision. |
| 3 | 2026-08-26 | update | Repairs: scenario 5 judges what the order states; the overlap justification moved to the intro; checked glossed; the PO role named as the exclusive decider. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean — every Then decidable from the criteria set, the framing, and the artifact; attributions accurate. |
| 3 | 2026-08-26 | state | draft → approved by the owner. |
