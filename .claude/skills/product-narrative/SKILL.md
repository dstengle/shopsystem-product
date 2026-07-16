---
name: product-narrative
description: Render the product's current state outward as an honest, grounded narrative, producing a README, site, or current-state revision that traces to real capability
---

# Product Narrative

## Overview

This is the **communicating** mode of the lead-pm main session. It renders the
product outward — the README, the site, and the current-state narrative — so that
what the product *is* is told honestly and legibly. Product communication is in
scope for the lead-pm; the market-facing go-to-market disciplines (positioning,
pricing, segmentation, growth metrics) are parked out of scope per PDR-033
amendment-c, so this skill stays on the current-state-narrative side of the line.

The governing discipline is traceability: every capability claim in an outward
rendering must trace to a current-state entry. An outward claim with no
current-state anchor is a claim you may not publish. The narrative reflects what
exists — it does not sell what is hoped for.

**Terminal artifact:** a communicating session terminates in a **README, site, or
current-state revision** — a concrete update to one of the outward renderings or
to the current-state doc that backs them. A communicating session that publishes
nothing durable has not closed.

## When to use

- A capability landed and the outward renderings do not yet reflect it.
- The README or site drifted from what the product actually does.
- The current-state doc needs to catch up to what has shipped so outward claims
  have an anchor to trace to.

## Protocol

### 1. Reconcile against current state

Start from the current-state doc and the completion journal. Establish what the
product actually does now before writing a word of narrative. If the current-state
doc itself is stale, revising *it* is the session's artifact.

### 2. Write to what exists

Draft the narrative for the README, site, or current-state doc so that each
capability claim names a real, landed capability. Keep it legible and honest;
resist the pull toward aspirational language that outruns current state.

### 3. Trace every claim

For each capability claim in the rendering, confirm it traces to a current-state
entry. Cut or defer any claim that has no anchor — an unanchored claim is not
publishable, however true it may feel.

### 4. Close on a rendering revision

Declare the mode (`communicating`) in the session record and list the **README,
site, or current-state revision** as the produced or revised artifact.

### 5. Validate a current-state revision against the knowledge BC before closing

The three outward renderings do not close the same way. The README and site
renderings are not among the knowledge BC's eight recognized artifact types, so
the README and site closing branches do not require `shop-knowledge validate`;
they close on the traceability pass alone.

Only the current-state-revision closing branch requires `shop-knowledge
validate`, because the current-state document is one of those eight recognized
artifact types. Before or while producing it, fetch the canonical template with
`shop-knowledge template current-state`; before the session closes, validate the
produced `current-state` document against its schema by running
`shop-knowledge validate`. If `shop-knowledge validate` reports a validation
failure, surface that failure to the product authority rather than closing the
session silently — a document that fails validation is not a closed artifact.

## Boundaries

The README and site are living documents the lead-pm stewards and revises in
place; the current-state doc is their anchor. Product communication is in scope;
the parked GTM disciplines are not — if the product authority needs positioning,
pricing, or growth metrics, name the gap and route it rather than improvising it
here.
