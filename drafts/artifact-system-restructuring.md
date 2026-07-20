# Artifact System Restructuring — shaped initiative (captured 2026-07-20)

**Status:** shaped, **deferred** to a separate initiative (off the
`migrate/legacy-corpus-modernization` branch). This file preserves the shaping
from the 2026-07-19/20 sessions so it isn't lost; it is a planning capture, not
a decision (non-authoritative per ADR-065). When the initiative starts, this
decomposes into the separate intents below.

## Why deferred

The migration branch already put the corpus in largely the state we need
(typed, plural, gate-passing). That branch does only **light frontmatter care**
now (withdraw the two never-ratified drafts ADR-067/PDR-035; leave the rest).
The work below — breaking down the ADRs/PDRs, the templates work, and the
tooling — is the major follow-on, done as its own initiative.

## North star (the founding requirement)

**Two views over one corpus:**

- **Current-system view** = the `status: accepted` documents read as a set.
  Must be *self-contained* (no accepted doc reaches into a superseded one to be
  understood) and *mutually consistent* (no two accepted docs contradict). This
  is "what the system **is**."
- **Transformation view** = the full graph including superseded docs and the
  `supersedes`/`superseded-by` chains. "How the system **got here**."

You obtain the current view by filtering to `accepted`; what remains stands on
its own. History is reachable via materialized supersede edges but never
*required* to read the present. `status` is the axis that separates the views.
Coherence is therefore the **founding requirement the schema serves**, not a
technical decision that precedes it.

## The changelog rule (self-containment exception)

Self-containment applies to **content sections** (title, description, decision,
consequences). The **changelog** is the *sanctioned* place an accepted doc names
its superseded predecessor (the "copied forward from X" line). The changelog
belongs to the transformation view, so the current-view render filters it out.

## Base schema additions

- **Three materialized, gate-enforced bidirectional edge pairs:**
  `supersedes`/`superseded-by`, `derives-from`/`derived-by`,
  `references`/`referenced-by`. Both directions stored in frontmatter; the gate
  maintains them and fails on asymmetry. (This deliberately replaces the old
  "resolve transitively / computed" posture — back-edges are materialized so the
  graph is traversable from frontmatter alone.)
- **`tags`** field.
- **`distribution`** field, values `product` | `system-wide` (bc-local excluded —
  these are lead-repo artifacts). Reconcile vs. the ADR-034/035 tier model.
- **External references** field.
- Supersession is **N:M**: a doc may be jointly superseded by several successors
  (`superseded-by` is a list; each successor carries a `supersedes` back-edge).

## Decomposition — separate intents, in dependency order

Each is its own intent → candidate → PDR/ADR chain (standalone, ordered).

1. **Foundational artifact-system needs (PDR)** — the need for artifacts; the 8
   kinds and how they compose (provenance spine + reference/derive edges); the
   two-views/self-containment requirement + the changelog rule. *First.*
2. **Base schema (ADR = the spec)** — encodes the fields above; carries the first
   supersede edges. *(needs 1)*
3. **Per-artifact needs (PDR ×8) + per-artifact schema (ADR ×8)** — the bulk;
   explodes PDR-032's taxonomy into per-type docs. *(needs 1, 2)*
4. **Per-artifact writing skills** — PDR (each type has a writing skill bundling
   template + schema checks); ADR (skill-template structure); ADR (shop-templates
   enforces: every type has a writing skill; skills have valid content). *(needs 3)*
5. **Graph navigation** — PDR + ADR: knowledge tool queries frontmatter per doc,
   returns json/yaml. *(needs 1)*
6. **Rendering with section filtering** — PDR + ADR: filtering mechanism + CLI,
   outputs md/json/yaml. *(needs 1)*
7. **Query by frontmatter** — PDR + ADR: query methods bound by schema; results as
   (a) compact doc list (text/json/yaml) or (b) rendered docs with section
   filtering, e.g. title/description/decision (md/json/yaml). *(needs 1; shares
   the CLI with 5, 6)*

Open slicing calls: whether #3 is one intent or per-type; whether #5–7 stay three
intents or fold into one "programmatic access" intent.

## Supersession accounting (the clean restart)

The fresh family formally supersedes the prior artifact corpus — nothing orphaned:

| Prior (accepted) | Superseded by |
|---|---|
| PDR-031 — BC founding (discovery-first, kind-extensible) | #1 |
| PDR-032 — owns type system + taxonomy + base fields + boundary rules | #1 + #2 + #3 (taxonomy explodes into per-type docs) |
| ADR-059 — typedef→generator format mechanism | #2 (mechanism copied forward, new fields folded in) |

The withdrawn ADR-067 content (no-amendment / full-supersede copy-forward + lane
discipline) re-homes into #1's requirement + #2's mechanics, re-authored on the
new schema.

## Known issue to fold in

**`current-state` typedef conflict.** The typedef requires `current-state-NNN` +
`status: [current, superseded]` + `Current decisions`/`Stewardship` sections —
i.e. it models current-state as a *versioned, supersede-able* artifact — while
the live `current-state.md` is a *singleton rewritten in place*. The versioned
model actually fits the two-views framing (each snapshot accepted; prior
snapshots superseded = history). Resolve in the per-artifact schema work (#3),
not by force-fixing the instance.

## Templates / enforcement / tooling homes

Per lane discipline: needs → PDRs; schema/mechanism/CLI → ADRs; role behavior +
writing-skill enforcement → shopsystem-templates; formats + gate → shopsystem-
knowledge; executable gate rules → scenarios. The gate enforces: no partial
amendments; whole-doc supersession with matched materialized back-edges; edge
symmetry.
