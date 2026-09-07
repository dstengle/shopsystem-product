---
type: request
id: req-2026-09-07-run-efficiency
status: routed
version: 2
date: 2026-09-07
reader: lead-pm
owner: lead-pm
created: 2026-09-07
updated: 2026-09-07
originator: product-authority
received-through: operational-contract
arose-in: init-tool-skills
route: discovery
route-reason: "the cost sits in more than one place — the lead-pm session's context, the builds, the PO's feature prose, sequential waiting — and the fix is a set of process and system changes worth framing against a measure, not one change through the lane; a review of evidence, the analysis below the evidence"
routed-to: ""
work-item: lead-rr5c0
---

# Request: drastically higher efficiency per unit of work

## 1. What is requested

The product authority, 2026-09-07, on the analysis of agent time and
tokens for init-tool-skills: "We need drastically higher efficiency.
This was a relatively straightforward task and should not be so
expensive."

The task: every framework tool the shop runs made usable through a
skill produced from the tool's own answer — twelve tools, two
features, delivered and verified in one afternoon.

## 2. From whom

Reader: the lead-pm role. Originator: the product authority, in
conversation. Received through the lead shop's operational contract,
which has no artifact yet (lead-4kymc).

## 3. Route

Route said by the lead-pm role, 2026-09-07: **discovery, as a review
of evidence**. Why: the cost has four homes, and no one change through
the lane reaches them all; the discovery frames an initiative with a
measure — cost per unit of work — and the changes that move it. What
it costs the authority: one review of the evidence below. Topic:
"run efficiency (req-2026-09-07-run-efficiency)".

Originator's answer: **accepted** — the request is the authority's own
direction. The discovery opens next, ahead of the migration review
(brief-038 Ask 2's order is overtaken by this direction).

### Evidence: init-tool-skills, from the recorded initiative to the handoff (16:10–18:22)

Source: the session transcript and the 36 subagent transcripts.
Output tokens are estimated from characters written at four per
token (the transcripts carry only a streaming stub); context is the
input processed per model turn, summed over turns, mostly cache reads.

| | Wall min | Agent-min | Turns | Context (M tok) | Output (k tok) | Tool uses |
|---|---|---|---|---|---|---|
| Lead-pm session | 132 | 132 | 142 | 64 | 47 | ~380 |
| 34 subagents | | 171 | 262 | 21 | 242 | 617 |

| Step | Wall | Agents | Agent-min | Agent ctx (M) | Agent out (k) | Lead-pm turns / ctx (M) |
|---|---|---|---|---|---|---|
| Initiative-check (two attachments, ADR via the pre-bet route, two screens, bet) | 19 | 5 | 25 | 1.8 | 30 | 18 / 16.4 |
| Bet record + backlog order, two screens | 6 | 4 | 13 | 0.9 | 20 | 14 / 13.1 |
| Feature 1 authoring (PO draft and revise, designer, architect, corpus entries, screen) | 20 | 5 | 34 | 3.0 | 34 | 29 / 19.7 |
| Assignment 1 | 5 | 1 | 4 | 0.6 | 8 | 9 / 0.8 |
| Build 1, one nested proof agent, verification | 14 | 2 | 12 | 3.3 | 20 | 14 / 1.8 |
| Type screen by the designer | 5 | 1 | 4 | 0.6 | 7 | 6 / 0.9 |
| Feature 2 authoring (PO draft and revise 29 min, designer, architect, screen) | 25 | 4 | 43 | 3.0 | 52 | 23 / 4.0 |
| Assignment 2 | 8 | 1 | 8 | 1.1 | 11 | 2 / 0.4 |
| Build 2, nine nested proof agents, verification | 25 | 10 | 27 | 6.6 | 56 | 12 / 2.9 |
| Brief, session record, handoff | 5 | 1 | 1 | 0.02 | 3 | 15 / 4.4 |

Before this window: the discovery conversation and the research
inquiry — one researcher run of 13 min and 1.3M context, and 19
lead-pm turns at 17M context.

### Where the cost sits (the lead-pm's reading, for the discovery)

1. **The lead-pm session's context** — three times all agents
   combined. Before the compaction (to about 17:00) each turn carried
   about 1M tokens; after it, 100k–200k. Bookkeeping steps (bet
   record, order: 6 min of wall time) cost 13M of context. Candidates:
   compact or hand off more often; move bookkeeping (hash filling,
   status lines, history rows) into runtime steps the lead-pm does
   not run by hand; the plain-status and step-communication requests
   bear on this.
2. **The builds** — 36 agent-min, 9.9M context, 75k output, 131 tool
   uses; the second implementer's context reached 210k per turn over
   96 tool uses. Candidates: split a build by guidance item or by
   tool; verification by nested fresh-context agents is cheap (ten
   runs, each under half a minute, about 0.1M each) and stays.
3. **The PO's feature prose** — draft and revise 19 and 29 min, 13k
   and 32k output, most of it the Contributors and Edges sections and
   the history rows. The Contributors rule already routed
   (req-2026-09-07-contributors-body) attacks part of it; the Edges
   table and the history rows' length are the rest.
4. **Sequential waiting** — 171 agent-min against 132 wall-min only
   because attachments and corpus entries ran in parallel; the
   designer's and architect's feature steps could run together once
   the draft stands.

Screens are cheap (1–3 min, 20k–90k context each): the single review
cycle is not where the cost is; the revise is.

## 4. Result

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Recorded by the lead-pm at the request-intake process's record step from the authority's words on the cost analysis of init-tool-skills; the analysis attached as evidence; route discovery (review of evidence) decided, said, and accepted; opens next. |
| 2 | 2026-09-07 | update | The discovery opened by the authority ("Open the run-efficiency discovery"): the discovery-conversation process's open step, work item lead-rr5c0; the request's section 1 is the Framing's source. |
