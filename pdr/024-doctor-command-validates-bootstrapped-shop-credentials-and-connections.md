---
id: PDR-024
kind: pdr
title: A rendered `bin/doctor` command validates a bootstrapped shop's credentials and connections and reports one aggregate pass/fail diagnosis
status: draft
date: "2026-06-29"
description: A rendered `bin/doctor` command validates a bootstrapped shop's credentials and connections and reports one aggregate pass/fail diagnosis
beads: [lead-j8so, lead-po, lead-q3r1, lead-shell]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-043, ADR-045, PDR-020]
  pins: []
  related: []
---
# PDR-024 — A rendered `bin/doctor` command validates a bootstrapped shop's credentials and connections and reports one aggregate pass/fail diagnosis

**Status:** draft (2026-06-29)
**Authors:** dstengle (intent), Claude (lead-po)
**Lead bead:** [`lead-q3r1`](#) — *Add `doctor` shell command* (feature).
Surfaced alongside [`lead-j8so`](#) (the `SHOPMSG_DSN`-unset bug).

**Anchored to** the product-authority statement (2026-06-29):

> "The lead claude is up but `SHOPMSG_DSN` is not set so it is trying to
> diagnose and work around. This should be fixed and there should be a doctor
> shell command that validates credentials and connections."

That statement pins both scope and vocabulary for this PDR — no discovery
workshop was required.

**Anchored on (decisions this builds on — NOT re-decided here):**

- [PDR-020](020-lead-shell-is-a-bc-container-launched-bc-base-session.md) — the
  lead shell is a `bc-container`-launched `bc-base` session brought up by the
  rendered `bin/shop-shell`; that bringup path is where session-scoped
  credentials and connection coordinates are transported.
- [ADR-045 / scenario 200](../features/templates/200-bringup-path-delivers-broker-ca-as-inline-pem-content-to-leaf-trust-file.gherkin)
  — the broker CA is delivered as inline PEM content; the failure mode doctor's
  agent-vault check surfaces is exactly the path-string-instead-of-certificate
  degradation that fails brokered TLS subtly.
- [ADR-043 / scenario 211](../features/templates/211-bootstrap-renders-shell-sourceable-ops-coordinates-artifact-carrying-env-overridable-ops-keys.gherkin)
  — the single ops-coordinates artifact carrying the product postgres
  coordinates doctor's messaging-DB check reads.
- Scenario 202 (`@scenario_hash:1c054dfdc468860a`) — the blank-`CLAUDE_OAUTH`
  writeback bug; doctor's Claude check is the standing diagnosis for that
  credential's health.

## Point of intent

Today a bootstrapped shop's health is discovered *reactively and ad-hoc*: when
a credential or connection is missing (notably `SHOPMSG_DSN` unset — the
long-named-but-not-closed plumbing gap carried out of ADR-020, the `lead-3lw6`
second half), the lead agent spends a turn self-diagnosing and working around
it. That is the build-trap inverse of a product: precise machinery that wastes
agent turns rediscovering a fixed, knowable set of preconditions.

The intent is to convert that reactive self-diagnosis into a single,
deterministic, agent-less command — `bin/doctor` — that validates the
bootstrapped shop's credentials and connections and reports a clear pass/fail
diagnosis. The observable behavior change: an operator (or an agent at session
start) runs one command and gets a named verdict per check plus one aggregate
verdict, instead of an agent improvising a diagnosis.

This PDR is paired with the `SHOPMSG_DSN`-unset *bugfix* (`lead-j8so`,
scenario 214): the bug fixes the missing precondition; doctor makes the whole
precondition set *checkable* so the next gap does not require agent
improvisation either.

## The decision

**D1 — `bin/doctor` is a new shop-templates-rendered ops command, in the same
shop-owned `bin/` family as `bin/shop-shell` / `bin/ops-coordinates`.** It is
rendered at bootstrap; the architect carries the update-path render question
(parallel to scenario 213 for ops-coordinates) as a follow-on if wanted — the
authored scenarios pin only the bootstrap-rendered presence and behavior.

**D2 — doctor's check set is, at minimum, three named checks:**

1. **messaging-DB** — `SHOPMSG_DSN` set + the product postgres reachable at
   that DSN (scenario 215).
2. **agent-vault** — the broker reachable + its CA trusted by the leaf, with
   the unreachable-broker cause distinguished from the untrusted-CA cause
   (scenario 216).
3. **Claude credential** — `CLAUDE_OAUTH` present + in a refreshable/connected
   state (scenario 217).

**D3 — the diagnosis surface is the contract, not the probe.** Each check
asserts three things: a stable check *name*, an explicit *pass/fail status*,
and — on failure — a *remediation hint* naming the corrective action. The
scenarios deliberately do NOT pin how each reachability/credential probe is
implemented; the BC owns that. This keeps doctor a diagnosis contract, not a
re-specification of postgres/broker/oauth internals.

**D4 — doctor reports one aggregate verdict with a meaningful exit code**
(scenario 218): all-checks-pass ⇒ overall pass + exit 0; any failed check ⇒
overall fail naming the failed check(s) + non-zero exit. The aggregate is
derived from the individual results, so a script or session-start hook can gate
on `bin/doctor`'s exit status.

## Why a PDR (why this would be re-asked)

- **Why a command and not just the existing `shop-msg prime` DSN check?**
  `shop-msg prime` checks only messaging-DSN reachability (scenario 101/102).
  doctor's value is the *aggregate* across all three credential/connection
  surfaces with one verdict — the thing an agent currently assembles by hand.
- **What exactly does doctor assert?** D3's diagnosis-surface contract (name +
  pass/fail + remediation hint) is the answer, recorded so future check
  additions follow the same surface shape rather than inventing per-check
  output formats.
- **Where does doctor's check set stop?** The three checks of D2 are the
  authored floor (the product authority's "credentials and connections"
  enumerated). Additional checks are additive scenarios under the same D3
  surface; they do not re-open this decision.

## Decomposition / dispatch (architect, later — NOT done here)

- `lead-q3r1` → **`assign_scenarios`** to shopsystem-templates (new capability):
  scenarios 215, 216, 217, 218.
- `lead-j8so` → **`request_bugfix`** to shopsystem-templates (tightens existing
  bringup render): scenario 214.

The architect verifies pre-state empirically against the contract/artifact
surface and adds the `@bc:` / reproducing `@scenario_hash` tags at dispatch.
