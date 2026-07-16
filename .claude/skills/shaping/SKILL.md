---
name: shaping
description: Take a validated intent and drive a single candidate to shaped — bounded, de-risked, and ready for a commitment decision
---

# Shaping

## Overview

This is the **shaping** mode of the lead-pm main session. Shaping takes a
validated problem — usually captured as an intent record from discovery — and
works it into a concrete but still-malleable **candidate**: a shape for a
solution that is specific enough to be committed to, yet still at the problem /
capability altitude rather than in implementation detail.

The discipline of shaping is depth over breadth: you drive *one* candidate all
the way to shaped rather than half-shaping many. Shaping is where appetite,
boundaries, and known rabbit holes get pinned down so that whoever commits to the
candidate is committing to something bounded.

**Terminal artifact:** a shaping session terminates in a
**candidate driven to shaped** — a candidate whose problem, appetite, solution
outline, boundaries, and rabbit holes are pinned down well enough to hand to the
lead-po for commitment. A shaping session that leaves every candidate
half-shaped has not closed.

## When to use

- An intent record (or equivalent validated problem) exists and is worth solving.
- You need to convert "there is a real problem" into "here is a bounded shape for
  it" before anyone commits.

## Protocol

### 1. Set the appetite

Decide how much this problem is worth — the appetite — *before* sketching the
solution. Appetite is a constraint on the solution, not an estimate of it: it
bounds how elaborate a candidate is allowed to get.

### 2. Sketch at the right altitude

Sketch the candidate at capability level. Name what the solution does and the
elements it touches — with no env var names, no schemas, and no CLI flags. Keep
it concrete enough to argue about and rough enough to change.

### 3. Find the rabbit holes and set boundaries

Actively hunt the parts that could blow the appetite: the unknowns, the
couplings, the "and then we'd also have to…". Cut them out explicitly by naming
what is **out** of the candidate. Declared boundaries are what make the candidate
committable.

### 4. De-risk with a bounded probe if needed

If a technical unknown blocks convergence, request a bounded feasibility probe
from the Architect, time-boxed by the candidate's appetite. Link the returned
finding in the candidate's Evidence section. The probe's output is a finding, not
an implementation.

### 5. Close on a shaped candidate

When appetite, shape, boundaries, and rabbit holes are pinned down, the candidate
is **shaped**. Declare the mode (`shaping`) in the session record and list the
shaped candidate as the produced artifact.

### 6. Validate the candidate against the knowledge BC before closing

The candidate is one of the knowledge BC's eight recognized artifact types, so it
is gated. Before or while producing it, fetch the canonical template with
`shop-knowledge template candidate` so the candidate is shaped to the typedef the
knowledge BC governs. Before the session closes, validate the produced
`candidate` document against its schema by running `shop-knowledge validate`; if
`shop-knowledge validate` reports a validation failure, surface that failure to
the product authority rather than closing the session silently — a document that
fails validation is not a closed artifact.

## Boundaries

The lead-pm owns the why and the shape; the lead-po owns the commitment (brief ->
scenarios) and consumes the shaped candidate as input. You never write the brief
or the scenarios yourself. If the lead-po later blocks a brief on a why-problem,
the candidate reopens here in shaping to be re-shaped — the why is never patched
down inside the brief.
