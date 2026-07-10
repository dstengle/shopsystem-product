---
name: problem-space-mapping
description: Continuously maintain the map of the product's problem space so every candidate and intent has a place to hang, producing problem-space map revisions
---

# Problem-Space Mapping

## Overview

This is the **mapping** mode of the lead-pm main session, and unlike the others
it runs *continuously* rather than as a one-off session. Its job is to keep the
**problem-space map** — the living picture of the problems the product exists to
solve, how they relate, which are solved, which are open, and which are parked —
current as intent records, candidates, and decisions accumulate.

The map is what keeps discovery and shaping honest: a new problem is understood by
where it sits relative to the ones already mapped, and a candidate is understood
by which mapped problem it closes. Without the map, each session re-derives the
landscape from scratch and the product loses its throughline.

**Terminal artifact:** a mapping pass terminates in a **problem-space map
revision** — an update to the living map reflecting a newly surfaced problem, a
newly closed one, a re-drawn relationship, or a re-parked area. Because mapping is
continuous, its artifact is a revision to the existing map rather than a fresh
document each time.

## When to use

- A discovery or shaping session surfaced a problem the map does not yet hold.
- A commitment closed a problem the map still shows as open.
- The relationships between problems shifted — a decision merged, split, or
  re-parked an area.

Mapping is not a gate you wait for; it is upkeep you fold into every session that
changes the problem landscape.

## Protocol

### 1. Locate the change

Identify what moved: a new problem, a closed problem, a changed relationship, a
re-scoped area. Tie it to the intent record, candidate, or decision that caused
the move.

### 2. Place it against what exists

Situate the change relative to the problems already on the map. Is it a child of
an existing problem, a sibling, a newly independent area, or a re-framing of one
already there? The value of the map is in the relationships, not the list.

### 3. Revise the map in place

Update the living problem-space map: add, close, re-relate, or re-park. The map is
a stewarded living document — you revise it in place as the product moves rather
than appending a new copy.

### 4. Record the revision

Declare the mode (`mapping`) in the session record and list the **problem-space
map revision** as the produced or revised artifact.

## Altitude

The map lives in the problem space — problems and their relationships, at
capability altitude. It never carries implementation detail: no schemas, no CLI
flags, no env var names. Those belong to the solution space the Architect holds.
