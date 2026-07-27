# Knowledge-tools-as-understanding-basis + procedural skills — analysis (captured 2026-07-27)

**Status:** analysis / shaping capture, non-authoritative (ADR-065). Seeds a set of
ordered intents when picked up. Grounded empirically 2026-07-27 against the
installed `shop-knowledge` v0.1.0, the corpus (162 artifacts), and the role
prompts / CLAUDE.md / ADR-018.

## The goal (product authority, 2026-07-27)

Make the **knowledge tools the sole basis for understanding the system** when
making decisions — **eliminate grep and raw file-reading**. Combined with **much
more extensive skills** that encapsulate the procedural/tool steps roles must
take. Specifically: an agent understands the system by (1) **searching/querying
for headers**, (2) **building a map of the document set** to understand purely
from **frontmatter + graph connections**, then (3) **pulling decision sections
on demand**. Supporting this needs the tools fleshed out (real help; a freeform
search to replace grep; targeted queries; **current-only defaults**).

## Headline finding

**The read-tools exist; the process does not use them.** `shop-knowledge` ships
`query`, `navigate`, `render` (plus `template`/`schema`/`validate`). But those
three read verbs are referenced **only** inside the `write-<kind>` authoring
skills' typedef calls — **nowhere** in CLAUDE.md, the primers, the role prompts,
or ADR-018. Every "understanding / verify-pre-state" path is pointed at raw
`features/` + `adr/` + `pdr/` reads, `grep`, and the `scenarios` CLI. So this is
a **doctrine + skills rewiring** at least as much as a tool buildout.

---

## Current state (grounded)

### A. The corpus — 162 artifacts, 8 kinds, heavy non-current noise

| kind | total | current* | non-current (noise) |
|---|---|---|---|
| adr | 68 | 49 accepted | 16 proposed, 3 superseded |
| pdr | 38 | 12 accepted | **24 proposed**, 1 rejected, 1 superseded |
| brief | 24 | 4 ready | 20 draft |
| candidate | 10 | 6 committed / 4 shaped | (exploring/parked/rejected possible) |
| intent-record | 12 | 12 recorded | (superseded possible) |
| session-record | 9 | 9 closed | (open possible) |
| current-state | 1 | 1 current | (superseded snapshots accrue) |
| prioritization-record | 0 | — | — |

\* "current" is **per-type**, not a single status — the design point for a
current-only default. PDRs return **2× more proposed noise than accepted** today.

- **Edge fields** (from adr-067): `derives-from`/`derived-by`,
  `references`/`referenced-by`, `supersedes`/`superseded-by`, plus `incorporates`
  (current-state). Materialized + symmetric — a real graph to traverse.
- **Progressive-disclosure payoff ~240×:** an L0 header is ~147 bytes; a full
  render is ~35 KB. Headers for all 162 artifacts ≈ 24 KB (a map you can hold) vs
  ~5.7 MB to read them all.

### B. The tools — `shop-knowledge` v0.1.0, and its gaps

| verb | today | gap vs the goal |
|---|---|---|
| `query` | `--facet {type\|status\|tag\|distribution} --value <v>`; returns id/title/status (L0) | single facet only (no compound/AND); **no freeform text**; **lumps all statuses** (no current default); returns L0 only (no description/edges = no L1) |
| `navigate` | `<id> --direction forward\|back\|both`; 1-hop edge neighbourhood | **1-hop only** (`--depth` deferred) → **cannot build a multi-hop map / subgraph** |
| `render` | `<id> --view current-system\|transformation --format md\|json\|yaml` | **no section-level projection** (`--section Decision`) → **cannot pull "just the decision"** (the L2 step) |
| `template`/`schema`/`validate` | authoring typedef surface | fine; already used by `write-<kind>` skills |
| help | `--help` errors; per-verb "help" is a one-line arg-error string | **no discoverability** — poor for human or agent |
| (missing) `search` | — | **no freeform search → nothing replaces grep** |

### C. The understanding *process* — runs on grep + raw reads

- Both judgment subagents declare `tools: Read, Edit, Write, Bash, Grep, Glob`
  (`.claude/agents/lead-po.md:4`, `lead-architect.md:4`) — grep/glob are
  first-class.
- lead-architect literally prescribes `grep -r "@scenario_hash" features/`
  (`lead-architect.md:321`) for conflict enumeration.
- **ADR-018's admissible-evidence list** (the "verify pre-state empirically"
  doctrine) is a **list of files/CLIs to read directly** — `features/`, `adr/`,
  `pdr/`, `briefs/`, `scenarios hash`, message schemas, `shop-msg` — and **never
  names a knowledge-query layer** (`adrs/adr-018.md:80-92`).
- "Verify pre-state" in practice = raw reads + `grep` + `scenarios hash` +
  `shop-msg`. `shop-knowledge query/navigate/render` plays **no role**.
- Load model is mostly on-demand already (lead-pm body + role prompts + skills
  lazy), except the always-on ~334-line router primer. But on-demand retrieval of
  decisions is **by hand (read/grep)**, not through a tool.

### D. The skills landscape — PM-rich, operational-surface bare

- **37 skills.** The lead-pm surface (discovery/shaping/deciding/communicating)
  is heavily encapsulated (~25 skills). Artifact authoring is fully encapsulated
  (`write-<kind>` ×8, routed through the `shop-knowledge` typedef).
- **The lead-architect/lead-po/router *operational* surface is almost entirely
  ad-hoc prose** — the only operational skills are `bring-up-bc`, `create-bc`,
  `work-splitting`. Everything else (dispatch composition, hashing, pre-state
  verification, reconcile-and-close, discriminator routing, mailbox ops, idle
  checklist, watcher arming, clarify response, conflict enumeration, session
  discipline) lives as prose in the prompts + CLAUDE.md.
- **Dangling skill reference:** `lead-architect.md:171-181` tells the agent to
  "load the `po-architect-decomposition-exchange` skill" — **no such skill
  exists**. Named as a skill, shipped as absent.

---

## Gap against the four requirements

1. **Tools as sole basis / eliminate grep** — read verbs exist but the *doctrine*
   (ADR-018) and the *role prompts* route around them to grep/raw-read. Blocked on
   doctrine + prompt rewiring, and on `search` (no grep replacement exists).
2. **Full progressive disclosure (headers → map → sections)** — L0 headers exist
   (thinly); **the map layer does not** (navigate is 1-hop); **the section-pull
   does not** (render has no `--section`); L1 (header+description+edges) is not a
   query output.
3. **Tool completeness (help, freeform search, current default)** — **all three
   missing.**
4. **Extensive procedural skills** — the operational surface is prose, not skills.

---

## Proposed TOOL capabilities (`shop-knowledge` buildout)

| # | Capability | What it adds |
|---|---|---|
| T1 | **Real help** | `--help` on top-level + every verb: usage, options, the facet/edge/status vocabulary, worked examples. Table-stakes discoverability. |
| T2 | **`search` (freeform)** | Full-text search over title/description/body, ranked, returning L0/L1 headers; scoped by `--in title\|description\|body`, `--type`, `--status`. **The grep replacement.** |
| T3 | **Current-only default** | A per-type "in-force" status set (adr/pdr=accepted, current-state=current, session=closed, brief=ready, candidate=committed, intent=recorded); default hides non-current (superseded/rejected/parked/draft/proposed) across query/search/navigate/render; `--all`/`--include-superseded` to opt in. |
| T4 | **Tiered projection L0/L1** | Extend query/search to return **L1** (id/title/status + description + tags + distribution + edges) via `--level`/`--fields`; L0 stays the default cheap header. |
| T5 | **`render --section <name>`** | Pull a single section (Decision, Context, Consequences, …) — the on-demand **L2** step. |
| T6 | **Map building** | `navigate --depth N` and/or a `map`/`graph` verb: transitive subgraph (nodes = L0/L1 headers, edges) from a seed id or a query/search result, as json/yaml + an md summary. **The "build a map from frontmatter + edges" capability.** |
| T7 | **Compound query** | AND across facets (type+status+tag+distribution) and edge-participation; query/search results feed T6/T5. |

**Scope flag:** `shop-knowledge` indexes the **artifact corpus** (adr/pdr/brief/
candidate/intent/session/current-state/prioritization). "Understanding the system"
also spans **scenarios** (`features/`, owned by the scenarios BC, its own CLI) and
**mailbox/bd** state. Eliminating grep *entirely* means either extending
shop-knowledge to index `features/` too, or an understanding skill that
orchestrates shop-knowledge + `scenarios` + `shop-msg`. **A product decision.**

## Proposed SKILL set

**Understanding skills (replace grep/read):**
- `survey-the-corpus` / `understand-system` — the headers→map→sections flow:
  `search`/`query` for headers → `map` to build the subgraph → `render --section`
  to pull specifics. The procedural encapsulation of progressive disclosure.
- `verify-pre-state` — how a role verifies pre-state through the knowledge tools
  (query/search/render the relevant decisions + contract surface), superseding
  the grep/raw-read discipline.

**Operational/tool skills (encapsulate today's prose):**
- `dispatch-to-bc` (discriminator vehicle pick + `shop-msg send` mechanics +
  read-back verify) · `author-scenarios` (Gherkin + block-only `@scenario_hash`
  hashing + conflict enumeration on retire) · `reconcile-work-done` (wraps the
  reconcile-and-close — composes with lead-t96cf's wrapper) · `respond-to-clarify`
  · `route-monitor-event` · `session-start` (arm watcher + drain + idle checklist)
  · `session-close` (git/bd push discipline) · **ship the missing
  `po-architect-decomposition-exchange`**.

## Cross-cutting: the doctrine rewire (the actual "eliminate grep")

The tools + skills are necessary but not sufficient. The **doctrine must be
rewired** so understanding/pre-state routes through the tools:
- **A new ADR extending/superseding ADR-018's *execution*:** "verify pre-state
  empirically" = query/search/render the corpus, not grep/raw-read (the *what*
  — the artifact surface — is unchanged; the *how* changes).
- **Role-prompt edits (shopsystem-templates-owned):** lead-po/lead-architect
  point at the knowledge tools + the new understanding skills; the literal
  `grep -r` directive is replaced.
- **Tool-access constraint:** reconsider `Grep`/`Glob` as first-class subagent
  tools once the knowledge path is complete (they're the fallback that keeps the
  old habit alive).

## Suggested decomposition (ordered intents, when picked up)

1. **Tool completeness foundation** — T1 help + T3 current-default + T4 L1 (the
   cheap, high-leverage base). *shopsystem-knowledge.*
2. **Freeform search (T2)** — the grep replacement. *shopsystem-knowledge.*
3. **Map + section-pull (T5, T6, T7)** — the map layer + L2 section-pull that
   complete the headers→map→sections flow. *shopsystem-knowledge.*
4. **Understanding skills** — `survey-the-corpus`, `verify-pre-state` (need 1–3).
   *shopsystem-templates.*
5. **Operational skills wave** — the dispatch/hashing/reconcile/session skills +
   the missing decomposition skill. *shopsystem-templates.*
6. **Doctrine rewire** — the ADR-018-execution ADR + role-prompt edits + the
   Grep/Glob constraint. *lead + shopsystem-templates.*
7. **Corpus-scope decision** — whether shop-knowledge also indexes `features/`
   (scenarios) + mailbox, or an orchestrating skill spans the CLIs. *decision
   first, then build.*

Open slicing calls: whether 1–3 are one "shop-knowledge read-surface" intent or
three; whether the doctrine rewire (6) leads (unblocks adoption) or trails
(needs the tools to exist first).
