---
type: roadmap-priority
id: roadmap-priority
status: draft
version: 8
owner: lead-pm
created: 2026-09-02
updated: 2026-09-07
---

# Roadmap priority

The PM role's recorded priority, which every backlog order is placed
against (the backlog-order typedef's `priority` link). No roadmap
typedef exists yet — it is a pending reconcile-side amendment; this
record exists because the backlog-order typedef requires a recorded
priority, and it is to be re-formed under the typedef when that
amendment lands.

## Priority

1. **init-run-efficiency** — proposed, a parent
   ([initiatives/init-run-efficiency.md](initiatives/init-run-efficiency.md)):
   the authority's direction of 2026-09-07; cost per delivered
   feature from about 42M context tokens to under 5M. Its
   sub-initiatives, bet on alone in this order:
   1. **init-process-runner** — proposed; next: initiative-check,
      with the migration-review discovery beside it.
   2. **init-run-measurement** — proposed.
   3. **init-artifact-tools** — proposed.
   4. **init-plain-voice** — proposed.
2. **init-tool-skills** — active
   ([initiatives/init-tool-skills.md](initiatives/init-tool-skills.md)):
   both features delivered 2026-09-07; measure 6 of 12, the six
   external tools counted when their owners answer.
3. **init-role-decisions** — active: delivered 2026-09-06.
4. **init-typedef-rendering** — active: measure met 2026-09-05 (1 of
   22); the batch of 21 not started.
5. **init-request-routing** — active; measure met 2026-09-04.
6. **init-roles-availability** — active; measure met 2026-09-03.
7. **init-skills-availability** — active; its one feature assigned.
8. **More comprehensive rendering work** — the authority's direction,
   verbatim: "sibling process for now, more comprehensive work later"
   (bead lead-sx9xj). Not yet framed.

Requests routed and awaiting the authority's answer (not yet in the
priority): req-2026-09-05-step-communication (discovery);
req-2026-09-06-plain-status (small-change); req-2026-09-06-migration-review
(discovery, accepted, opens beside init-process-runner's check);
req-2026-09-04-operational-contract (discovery open, lead-bmmzh).

Delivered and removed from the priority: **ADR artifact and
processes** (bead lead-mfcyp) — the ADR chain was authored and
approved on 2026-09-02 through definition-chain-migration, outside
the initiative path.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-02 | update | Recorded by the PM role's assisting agent from the authority's stated direction, as the priority the first backlog order requires; pre-typedef, flagged for re-forming when the roadmap amendment lands. |
| 2 | 2026-09-03 | update | Re-recorded by the PM role's assisting agent on the authority's bet of 2026-09-03: init-roles-availability placed first; init-skills-availability kept as active; the later rendering work added from the authority's words (lead-sx9xj); the ADR item removed as delivered. Still pre-typedef. |
| 3 | 2026-09-04 | update | Re-recorded by the PM role's assisting agent on the authority's bet of 2026-09-04: init-request-routing placed first; init-roles-availability kept as active with its measure met; the rest unchanged. Still pre-typedef. |
| 4 | 2026-09-04 | update | init-request-routing's measure met the same day; kept as active pending the `completed` state. Still pre-typedef. |
| 5 | 2026-09-05 | update | Re-recorded on the authority's bet of 2026-09-05: init-typedef-rendering placed first; the three active initiatives kept; the six routed requests noted as awaiting the authority's answer. Still pre-typedef. |
| 6 | 2026-09-06 | update | Re-recorded on the authority's bet of 2026-09-06: init-role-decisions placed first; the four active initiatives kept in order of their bets; the routed requests updated. Still pre-typedef. |
| 7 | 2026-09-07 | update | Re-recorded on the authority's bet of 2026-09-07: init-tool-skills placed first; init-role-decisions active; the routed requests updated. Still pre-typedef. |
| 8 | 2026-09-07 | update | init-run-efficiency placed first as a parent with its four sub-initiatives in the authority's order ("make process runner first"); init-tool-skills active, delivered. |
