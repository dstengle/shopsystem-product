---
type: request
id: req-2026-09-16-fix-lead-ibme0
status: routed
version: 3
date: 2026-09-16
reader: lead-pm
owner: lead-pm
created: 2026-09-16
updated: '2026-09-16'
originator: product-authority
received-through: operational-contract
route: discovery
route-reason: the ask's third turn is a question — what to name and where to document
  the flag the architect writes on a feature between its authoring and its sending
  — with no defined term or schema home today, spanning feature-authoring, product-flow,
  the feature typedef, and the ADR chain; its shape is the authority's to explore,
  so not one definition or one instance for the lane
routed-to: null
---

# req-2026-09-16-fix-lead-ibme0

## 1. What is requested

The originator's words, in the order they arrived, all on 2026-09-16:

1. "fix lead-ibme0"
2. "Looking at the issue, the problem is using grep and sed rather than
   structured tools"
3. "The word decision is overused. I understand where it comes from now
   and it makes sense given the ordering that the architect determines
   that a decision is needed but the decision must be written after
   the features and before sending. How can we name this and document
   it better?"

The three turns together are the ask as confirmed.

## 2. From whom

Reader: the lead-pm role. Originator: David Stenglein, the product
authority. Received through the lead shop's operational contract,
which has no artifact yet (lead-4kymc). Brought directly, in an
interactive session on the rebaseline branch; no process run was in
flight.

## 3. Route

Discovery, in the form of an interview with the originator, on the
words in section 1.

Reason: the ask as confirmed is the three turns together, and the
third is a question, not a change. Turn 1 alone — the two lines in
product-flow (find-decision, resolve-decision) that miss a
`needs decision:` flag wrapped across two lines — would be a simple
change. Turn 2 names a class, not a site: bare grep and sed reads of
artifacts across several process definitions, and a tool whose read
returns the key with the value, so a substitution still reaches for
sed. Turn 3 asks what to call the thing the architect flags on a
feature between its authoring and its sending, and where to document
it: that thing has no defined term and no schema home today, and
naming it and giving it a home touches feature-authoring,
product-flow, the feature typedef, and the ADR chain. The shape of
that answer is the originator's to explore; it is not one definition
or one instance of one, so it is not the small-change lane's.

Originator's answer: accepted, 2026-09-16, at the request-intake
process's observe step. The route stands as said and is acted on
from here: the discovery conversation opens on this request as its
input, in the form of an interview on the words in section 1. No
register work item is opened by this process on the discovery route;
the conversation opens its own.

## 4. Result

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-16 | update | Recorded by the lead-pm; the originator's three turns quoted verbatim; route awaiting. Execution anchor lead-ldyrn. |
| 2 | 2026-09-16 | update | Route decided by the lead-pm at the request-intake process's decide-route step, first pass: discovery, form interview, for the reason in section 3 and `route-reason`; status routed; the originator's answer not yet answered, no action taken. Self-check against the step's definition of good before submitting: the ask read from section 1 only, never a transcript; a one-line topic named afresh; the route and reason said to the originator in words before any action; every part written through the artifact-tools skill. |
| 3 | 2026-09-16 | update | The originator's answer landed by the lead-pm at the request-intake process's land step: accepted, no objection; the discovery route stands as said, acted on from here by the discovery conversation opening on this request. Status unchanged, routed. No work item opened: the route is discovery, not small-change, so `work_item` returns empty. Self-check against the step's definition of good before submitting: the answer written in section 3 in the word the step names; a history row; the check `route != small-change || work_item != ""` holds; every part written through the artifact-tools skill. Execution anchor lead-ldyrn. |
