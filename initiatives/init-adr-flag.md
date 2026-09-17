---
type: initiative
id: init-adr-flag
name: The ADR flag, named and housed
status: planned
version: 1
owner: lead-pm
created: 2026-09-17
updated: 2026-09-17
request: ../requests/req-2026-09-16-fix-lead-ibme0.md
---

# Initiative: The ADR flag, named and housed

## Framing

Originator: David Stenglein, product authority, through the lead
shop's operational contract (lead-4kymc), by
req-2026-09-16-fix-lead-ibme0, section 1 — three turns, 2026-09-16:
"fix lead-ibme0"; "Looking at the issue, the problem is using grep
and sed rather than structured tools"; "The word decision is
overused. I understand where it comes from now and it makes sense
given the ordering that the architect determines that a decision is
needed but the decision must be written after the features and
before sending. How can we name this and document it better?"

Direction taken in the discovery (lead-imsnb, sess-2026-09-17-a):
"the record should trace to its origin by reference"; "Once I commit
to a bet, I want to see it done and not be involved. Anything I do
will be spot reviews."

Problem: the flag the architect writes on a checked feature before it
is sent has no name and no home — the process finds it by matching
prose, misses a wrapped line, loses a second flag silently, and the
ADR it leads to carries no reference back to its trigger; and the
flow's process definitions reach into artifacts by bare text
matching, not the artifact-tools skill: 13 reaches across five
definitions.

Outcome: every flagged decision is found by the process as defined
and recorded by the architect with no human step; the record's id
travels with the scenario it bears on, so the Bounded Context shop
can read it and ask; each record traces to its origin by a reference
the tool finds; the flow's definitions reach artifacts through
artifact-tools only.

## For whom

The solutions architect role, which flags, records, and handles the
scenario hash; the PO role, on whose feature the flag rides; the
Bounded Context shops, which receive the id; the authority,
spot-reviewing afterwards, never inside the flow.

Measure: flagged decisions the process as defined finds and records,
each traced to its trigger by a reference artifact-tools
`references` returns. Now 0 of 1 — the one flag written since
2026-09-15. Target: 1 of 1 on the next flagged feature.

Interaction types: none — the outcome holds in definitions and
records agents read, not at an interface.

## Appetite

Small: one working session of the lead shop's capacity, starting
from the shape the discovery settled (sess-2026-09-17-a; this
document's history). Within the bound: the flag named and given
a home the flow finds; one record per flag until none remains; the
record written and its id passed on by the architect, no human step;
a defaulted ask named in the record's Document History, not only in
a record row — the authority's direction at the bet; the scenario
hash the architect's at assignment, after the records; the 13 bare
reaches replaced by artifact-tools uses. Whether writing the id
beside a scenario is "changed scenario text" under the feature
typedef's rule, the architect states at feature authoring.

No-gos:

1. Nothing touches the frozen messaging contract on `main`: the shop
   receives the id, not the content; ADR content to Bounded Context
   shops is a named follow-on.
2. No new glossary term: the flag names the defined term adr.
3. No new human step or ask after the bet: ADRs are the architect's
   under its rights; escalation only for a principle exception.
4. The rendering processes' bulk scans stay: artifact-tools has no
   corpus-wide read — a filed gap (lead-ng3hc), a different class.
5. The `supersedes` reverse edge derived by search: an aside, filed
   as lead-jzmz5.
6. A flag on a small-lane feature: a follow-on; that lane has no
   step to consume it.

## Features

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-17 | update | Recorded by the lead-pm at the discovery conversation's frame step, framed across the interview on request req-2026-09-16-fix-lead-ibme0 (anchor lead-imsnb, parent execution lead-ldyrn, session record sess-2026-09-17-a), and set `planned` on the authority's word "bet" (2026-09-17), with the direction given at the same moment folded into the Appetite: a defaulted ask is named in the record's Document History, not only in a record row. What the discovery settled, held here so the bet's shape has a home outside sections 1–3 and feature authoring starts from it: (1) Option A — adr-authoring's `author` step receives the triggering feature as a declared input and reads it as its own evidence; (2) many flags per feature — one ADR execution per flag, one record per pass, exit when no flag remains; (3) "the shop" is both — this shop's agents reach `decisions/` already, and a publication channel for Bounded Context shops is a follow-on; (4) "available" is small — the record's id on the scenario's tag line plus the shop's right to ask, nothing on the frozen `main` messaging contract. Grammar: `@needs-adr:` on write, resolved to `@adr:<id>` at product-flow's resolve step through a tool use before `assign` — a tag, not frontmatter, because the tag line is what `assign_scenarios` carries. Provenance: a path-valued `trigger` field on the ADR, one per record, the house form of feature→initiative and initiative→request, carrying the scenario `@hash:` as a second value; `@adr:` on the tag line is that field's one rendering, not a second home. The hash: the architect's at scenario-assignment's `assign`, after both tag writes — `fill-hash` digests step lines only, so writing `@adr:` changes no hash. The bare reaches: 13 across five process definitions, replaced by artifact-tools uses; the rendering processes' bulk scans are a different class (no-go 4). The two threads the session record left to this step, reconciled: the count is 13 reaches in five definitions, not "seven steps", with the bulk scans set aside; a flag on a small-lane feature is no-go 6. Left to the architect at feature authoring: whether a tag write is "changed scenario text" under the feature typedef's rule. Framer's quantification for the authority's spot review: the authority's word for the bound was "small"; "one working session of the lead shop's capacity" is this step's reading of it, changeable by the authority without touching the bet. Maker's evaluation against the initiative fitness set: 1 pass — the originator's three turns quoted from the request's section 1 with its id as reference, the discovery's direction quoted from the session record, problem, outcome, and the operational contract named; 2 pass — one measure (flagged decisions found, recorded, and traced by a reference the tool returns), now 0 of 1, target 1 of 1, interaction types "none" with the reason; 3 pass — a bound in capacity, six no-gos each with its reason; 4 pass in the framer's own wording — sections 1–3 name no technology, structure, or form outside the no-gos, which name what they exclude (the PM role's standing reading in the fitness set's history, 2026-09-04), and outside the originator's quoted turn 2, which names two text tools and, under the owner's ruling of no exemption (same history), draws the known finding rather than an altered quote, since the typedef requires the request's words verbatim; the settled tag, field, and step names stand in this entry, not in sections 1–3; 5 and 6 not applicable — Feasibility and usability and Decomposition are filled at feature authoring, not before the bet (typedef v13); 7 — 597 words outside this history by `wc -w`, headings included: over the 500 rule and inside the owner's soft-cap ruling of 20% variance (typedef v11), the overage carried by the 110 words of verbatim turns the typedef requires; the bet statable from sections 1–3; 8 not applicable — no initiative's `parent` names this one. The file was written whole because artifact-tools has no create use (its `write` replaces an existing part), a gap outside lead-ng3hc's list; the request's parts were written through the skill. |
