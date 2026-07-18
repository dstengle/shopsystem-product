---
type: brief
id: brief-014
title: Scenario-register visibility vehicle (`request_scenario_register`)
status: draft
created: 2026-06-30
updated: 2026-07-17
authors: [dstengle (stakeholder, authorized vehicle build), Claude (lead-po)]
description: The lead can already ask a BC *which scenario hashes it has completed* via
derives-from: [adr-018, pdr-029, adr-019]
---

## Summary

The lead can already ask a BC which scenario hashes it has completed via
`request_completion_journal` — but that vehicle returns bare block-only canonical
hashes and nothing else. When the lead holds a hash it does not recognize, or
needs to locate, import, or supersede a BC's pinned scenario, a bare hash is
insufficient: there is no way to learn the scenario's title, its step text, where
the pin lives in the BC's `features/` tree, or whether it is still live versus
retired/superseded. This gap is concrete and recurring: lead-igzz needs the
shopsystem-templates scenario register for three approve-claude pins and has no
vehicle to pull it with, and lead-oxd8 is blocked behind the same absence. The
lead's reconciliation and import/supersede work is the seed story — it needs the
register, not just the journal.

Observable behavior change targeted: today, when the lead needs a BC's pinned
scenario in usable form, the only path is a manual, out-of-band reconstruction
(or it is simply not possible). After this vehicle exists, the lead pulls a BC's
scenario register over the wire and locates, imports, or supersedes any pin from
the response alone — without reading BC source (forbidden per ADR-018) and without
a manual sweep. The brief argues for a new, additive `shop-msg` message-type
vehicle that stands beside `request_completion_journal` rather than replacing it.

## Scope

Committed: a new `shop-msg` message-type vehicle, `request_scenario_register`, the
richer sibling of `request_completion_journal`. (1) Request side (lead → BC): the
lead names the target bounded context whose register is sought; narrowing is
optional — the lead may confine the request to a named feature-area surface or to
an explicit set of block-only canonical hashes, and omitting narrowing requests
the BC's full register. (2) Response side (BC → lead): the BC returns per-entry
register detail — for each entry its block-only canonical hash, the scenario's
title and step text, its file location within the BC's `features/` tree, and a
live-or-retired/superseded status; the distinguishing contract versus
`request_completion_journal` is exactly this per-entry richness, so a bare hash
with no title/text/location/status is not a valid register entry. Both behaviors
are pinned by the scenarios below.

Distinguishing it from `request_completion_journal` (load-bearing):
`request_completion_journal` answers "which hashes are done?" — a bare set of
hashes (scenarios 26/27/28/29 under `features/messaging/`);
`request_scenario_register` answers "what are this BC's pins, where do they live,
and are they live?" — per-pin detail sufficient to locate / import / supersede. It
is additive and does not replace the journal (PDR-029).

Vocabulary (load-bearing): scenario register (a BC's set of canonical scenario
pins, each carrying full per-entry detail — hash + title/text + `features/` file
location + live/retired status — distinct from the completion journal, which is a
bare set of completed block-only canonical hashes); register entry (one pinned
scenario's detail record: block-only canonical hash, title and step text, file
location within the BC's `features/` tree, and live-or-retired/superseded status);
block-only canonical hash (the per-scenario identity key defined by ADR-019 and
pinned by scenario-117, computed by the `scenarios hash` contract tool); narrowing
selector (an optional request field confining the pull to a feature-area surface
or an explicit hash set; absent ⇒ full register); and status (whether a pin is
live or retired/superseded — a retire-and-replace edit mints a new hash per
scenario-117-E).

What would NOT satisfy the stakeholder: a response that returns bare hashes (that
is already `request_completion_journal` — the gap stays open); a register entry
missing any of hash, title/text, `features/` file location, or live/retired status
(each is needed to locate / import / supersede); any path that requires the lead
to read or run BC source to obtain the register (forbidden per ADR-018 — the
register must come over the wire); and a vehicle that replaces
`request_completion_journal` rather than standing beside it.

Product constraints the Architect inherits (NOT decisions this brief makes):
owning BC — the vehicle is a `shop-msg` message type and transport is
shopsystem-messaging territory (the lead already receives BC responses there), and
the Architect verifies pre-state and confirms ownership; schema shape / field
names — the scenarios pin the behavioral contract (which fields must be present
and what they mean), while concrete field names and storage are the Architect's
call; and the message-type discriminator — new capability ⇒ `assign_scenarios` (no
such vehicle exists), applied after empirical pre-state verification (ADR-018) and
dispatched to shopsystem-messaging.

Grounding artifacts: brief-009 (left the on-demand journal-pull vehicle open; this
brief authors the richer register-pull sibling); features/messaging/26–29 (the
`request_completion_journal` request/response pair this vehicle parallels);
ADR-019 / scenario-117 (block-only canonical hash, the register entry's identity
key); ADR-018 (why the register must arrive over the wire, not from reading BC
source); and PDR-029 (why a distinct vehicle rather than an extension of the
journal). Pinned scenarios: features/messaging/36 (request side — names the target
BC, optional narrowing, omission ⇒ full register; `@scenario_hash:5b13b13d2205459b`)
and features/messaging/37 (response side — per-entry hash + title/text +
`features/` location + live/retired status, bare hash rejected;
`@scenario_hash:9b12f88736c6964f`).

## Source (pre-modernization)

#### Problem statement (this IS the problem)

The lead can already ask a BC *which scenario hashes it has completed* via
`request_completion_journal` — but that vehicle returns **bare block-only
canonical hashes and nothing else**. When the lead holds a hash it does not
recognize, or needs to **locate, import, or supersede** a BC's pinned
scenario, a bare hash is insufficient: there is no way to learn the
scenario's title, its step text, **where the pin lives** in the BC's
`features/` tree, or **whether it is still live** versus retired/superseded.

This gap is concrete and recurring. [`lead-igzz`](#) needs the
shopsystem-templates scenario register for three approve-claude pins and has
**no vehicle to pull it with**; [`lead-oxd8`](#) is blocked behind the same
absence. The lead's reconciliation and import/supersede work is the seed
story: it needs the *register*, not just the *journal*.

##### Observable behavior change targeted

Today, when the lead needs a BC's pinned scenario in usable form, the only
path is a manual, out-of-band reconstruction (or it is simply not possible).
After this vehicle exists, **the lead pulls a BC's scenario register over the
wire and locates, imports, or supersedes any pin from the response alone** —
without reading BC source (forbidden per ADR-018) and without a manual sweep.

---

#### What this brief commits — scope

A **new `shop-msg` message-type vehicle, `request_scenario_register`**, the
richer sibling of `request_completion_journal`:

1. **Request side (lead → BC).** The lead names the **target bounded
   context** whose register is sought. Narrowing is **optional**: the lead
   may confine the request to a named **feature-area surface** or to an
   **explicit set of block-only canonical hashes**; **omitting** narrowing
   requests the BC's **full register**.

2. **Response side (BC → lead).** The BC returns **per-entry register
   detail** — for each entry: its **block-only canonical hash**, the
   scenario's **title and step text**, its **file location within the BC's
   `features/` tree**, and a **live-or-retired/superseded status**. The
   distinguishing contract versus `request_completion_journal` is exactly
   this per-entry richness: a bare hash with no title/text/location/status
   is **not** a valid register entry.

These two behaviors are pinned by the scenarios below.

##### Distinguishing it from `request_completion_journal` (load-bearing)

- `request_completion_journal` answers *"which hashes are done?"* — a bare
  set of hashes (scenarios 26/27/28/29 under `features/messaging/`).
- `request_scenario_register` answers *"what are this BC's pins, and where
  do they live, and are they live?"* — per-pin detail sufficient to
  **locate / import / supersede**. It is additive; it does not replace the
  journal. See [PDR-029](../pdr/029-scenario-register-vehicle-distinct-from-completion-journal.md).

---

#### Vocabulary (load-bearing)

- **Scenario register** — a BC's set of canonical scenario *pins*, each
  carrying full per-entry detail (hash + title/text + `features/` file
  location + live/retired status). Distinct from the **completion journal**,
  which is a bare set of completed block-only canonical hashes.
- **Register entry** — one pinned scenario's detail record: block-only
  canonical hash, scenario title and step text, file location within the
  BC's `features/` tree, and live-or-retired/superseded status.
- **Block-only canonical hash** — the per-scenario identity key defined by
  [ADR-019](../adr/019-canonicalization-ownership-in-scenarios-bc.md) and
  pinned by scenario-117; computed by the `scenarios hash` contract tool.
- **Narrowing selector** — optional request field confining the register
  pull to a feature-area surface or an explicit hash set; absent ⇒ full
  register.
- **Status** — whether a pin is **live** or **retired/superseded** (a
  retire-and-replace edit mints a new hash per scenario-117-E).

---

#### What would NOT satisfy the stakeholder

- A response that returns bare hashes (that is already
  `request_completion_journal` — the gap stays open).
- A register entry missing any of: hash, title/text, `features/` file
  location, live/retired status — each is needed to locate / import /
  supersede.
- Any path that requires the lead to read or run BC source to obtain the
  register (forbidden — ADR-018; the register must come over the wire).
- A vehicle that *replaces* `request_completion_journal` rather than
  standing beside it.

---

#### Product constraints the Architect inherits (NOT decisions this brief makes)

- **Owning BC.** The vehicle is a `shop-msg` message type; transport is
  `shopsystem-messaging` territory (the lead already receives BC responses
  there). The Architect verifies pre-state and confirms ownership.
- **Schema shape / field names.** The scenarios pin the *behavioral*
  contract (which fields must be present and what they mean); concrete
  schema field names and storage are the Architect's call.
- **Message-type discriminator.** New capability ⇒ `assign_scenarios` (no
  such vehicle exists). The Architect applies the discriminator after
  empirical pre-state verification (ADR-018) and dispatches to
  `shopsystem-messaging`.

---

#### Grounding artifacts

- [Brief 009](009-scenario-completion-journal-and-system-state-snapshot.md)
  — left the on-demand journal-pull vehicle open; this brief authors the
  richer register-pull sibling.
- [`features/messaging/26-29`](../features/messaging/) — the
  `request_completion_journal` request/response pair this vehicle parallels.
- [ADR-019](../adr/019-canonicalization-ownership-in-scenarios-bc.md) /
  scenario-117 — block-only canonical hash, the register entry's identity
  key.
- [ADR-018](../adr/018-empirical-verification-is-contract-surface.md) — why
  the register must arrive over the wire, not from reading BC source.
- [PDR-029](../pdr/029-scenario-register-vehicle-distinct-from-completion-journal.md)
  — why a distinct vehicle rather than an extension of the journal.

---

#### Pinned scenarios

- [`features/messaging/36-catalog-request-scenario-register-request-names-target-bc-and-optional-narrowing.gherkin`](../features/messaging/36-catalog-request-scenario-register-request-names-target-bc-and-optional-narrowing.gherkin)
  — request side: names target BC; optional narrowing; omission ⇒ full
  register. `@scenario_hash:5b13b13d2205459b`
- [`features/messaging/37-catalog-request-scenario-register-response-carries-per-entry-detail.gherkin`](../features/messaging/37-catalog-request-scenario-register-response-carries-per-entry-detail.gherkin)
  — response side: per-entry hash + title/text + `features/` location +
  live/retired status; bare hash rejected. `@scenario_hash:9b12f88736c6964f`
