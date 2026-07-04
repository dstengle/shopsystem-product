# 01 — Disclosure mechanics (the LEVEL mechanic)

**Research stream:** `disclosure-mechanics` (epic lead-x7bp, process bead lead-x2rl)
**Date:** 2026-07-04
**Status:** COMPLETE — three exemplar mechanisms studied (llms.txt, Anthropic Agent Skills, MCP resources); all three converge on the same **two-step index→expand** shape and all three validate our L0/L1/L2 + generated-index goals. One strong anti-pattern surfaced (hand-maintained mirror = guaranteed drift), which reinforces the "generate every tier from ONE source" design target.

---

## Purpose of this stream

Study the *tiering primitive* in three deployed progressive-disclosure systems and, for each, answer four questions:

1. What is the **tiering primitive** (what is the unit that gets disclosed)?
2. How does the **consumer select a level** (what triggers pulling more)?
3. How is the **index represented** (machine-readable? human-readable? both?)?
4. What **maps cleanly onto our L0/L1/L2 + machine/human index** goal?

Plus: transferable mechanics and anti-patterns / overkill flags.

---

## Sources consulted (external, with URLs)

**llms.txt / llms-full.txt (Answer.AI spec):**
- Official spec — https://llmstxt.org/ (structure, `llms_txt2ctx`, two-file expansion, "Optional" section)
- State of adoption 2026 — https://www.aeo.press/ai/the-state-of-llms-txt-in-2026
- Google's June-2026 stance (no SEO effect; IDE-agent use is the real use case) — https://www.searchenginejournal.com/google-says-llms-txt-is-purely-speculative-for-now/577576/ and https://www.techseovitals.com/blog/google-will-never-read-your-llms-txt-build-it-anyway/
- Drift critique ("second copy with nothing enforcing it still matches … will drift, guaranteed") — https://searchsignal.online/blog/llms-txt-2026 and https://www.aeo.press/ai/the-state-of-llms-txt-in-2026

**Anthropic Agent Skills (progressive disclosure):**
- Anthropic engineering post — https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills (three levels, leanness guidance, frontmatter name+description)
- Platform docs — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
- SwirlAI analysis with **measured token budgets** — https://www.newsletter.swirlai.com/p/agent-skills-progressive-disclosure

**MCP resources:**
- Official spec (2025-06-18) — https://modelcontextprotocol.io/specification/2025-06-18/server/resources (resources/list, resources/read, templates, annotations, subscriptions)

**Internal (this repo, for calibration):**
- `/workspace/findings/progressive-disclosure/00-plan.md` — the goals this stream validates
- `/workspace/adr/018-empirical-verification-is-contract-surface.md:1-15` — the current ADR header format (Status / Authors / Pins / Anchored-to / Related-beads — prose, NOT YAML frontmatter)
- `/workspace/pdr/016-*.md:1-20` — PDR header format (same prose-header style)

---

## 1. llms.txt / llms-full.txt (Answer.AI, Jeremy Howard, 2024)

### What it is
A convention for a markdown file at a site root (`/llms.txt`) that gives an LLM a **curated navigation map** of a site's LLM-friendly content, solving the "context window can't hold the whole site / HTML is noisy" problem. Inference-time aid, not a crawl directive. (llmstxt.org)

### Tiering primitive — the FILE, indexed by a curated link with a note
The exact required structure (llmstxt.org):
1. Optional BOM
2. **H1** — project/site name (the *only* required element)
3. **Blockquote** — short summary
4. Zero+ free-text content sections (no headings)
5. **H2-delimited "file lists"** — each item is a markdown list entry: a **required hyperlink `[name](url)`, then optionally `: notes about the file`**

So the index unit is: **`[name](url): one-line note`** — i.e. *title + locator + one-line description*. That is **exactly our L0**.

### The two-tier (really three-artifact) shape
- **`llms.txt`** = the index (links + notes). ≈ our L0 index.
- **`llms-full.txt`** = everything inlined into one file. ≈ our L2 corpus, concatenated.
- The **`## Optional` section** is a first-class disclosure lever: "URLs provided there can be skipped if a shorter context is needed."
- Tooling `llms_txt2ctx` **expands** `llms.txt` into two derived context files: `llms-ctx.txt` (excludes Optional) and `llms-ctx-full.txt` (includes Optional), emitting XML suited to Claude. (llmstxt.org)

### How the consumer selects a level
Human-curated at author time (the author decides what's linked and what's "Optional"); at consume time the client picks `ctx` vs `ctx-full` by **context-budget pressure**. There is no per-decision "decision statement" tier — llms.txt is index→full with a skippable middle, no distinct L1.

### Index representation
**Markdown that is simultaneously human- and machine-readable** — this is the key transferable property. No separate machine format; the same file is the human index and the parseable index (H1/blockquote/H2/list grammar is trivially parseable). This is the shape our "machine+human index (llms.txt / OKF style)" target names directly.

### Adoption reality (anti-pattern signal — IMPORTANT for us)
- Real-world adoption is **tiny**: Google reported ~0.3% of top sites (2026-06-15); crawlers (GPTBot, ClaudeBot, PerplexityBot, Google-Extended) overwhelmingly **skip** it and read HTML directly. Google states it has **no** ranking effect. (searchenginejournal.com; techseovitals.com)
- **BUT the one place it demonstrably works is exactly our use case:** *IDE / coding agents* (Cursor, Windsurf, Claude Code, Copilot, Cline, Aider) fetch `/llms.txt` and `/llms-full.txt` routinely when pointed at a docs site. (techseovitals.com) → llms.txt is validated **for agent-consumes-a-doc-corpus**, which is precisely what we're building.
- **The drift critique is the load-bearing lesson:** "A second copy of your content with nothing enforcing that it still matches … becomes a stale source of truth the moment someone edits a page and forgets the mirror. Hand-maintained, it will drift, guaranteed." Guidance is literally "if you can't commit to quarterly review, deletion is cleaner than a drifting file." (aeo.press; searchsignal.online)
  → **This is our nbx5 single-source thesis, confirmed by an external failure mode.** llms.txt as *hand-authored* is an anti-pattern; llms.txt as a *generated* artifact from the source docs removes the drift entirely. Adopt the *format*, reject the *hand-maintenance*.

---

## 2. Anthropic Agent Skills — progressive disclosure as a first-class design pattern

### What it is
A skill = a directory with a `SKILL.md` (YAML frontmatter + markdown body) plus optionally bundled scripts / reference files. Designed *around* progressive disclosure so the agent loads only what a task needs. (anthropic.com/engineering)

### Tiering primitive — three explicit, named levels
| Level | What loads | Trigger | Measured cost (SwirlAI, 17-skill sample) |
|---|---|---|---|
| **L1 Discovery** | `name` + `description` (frontmatter only) of *every* installed skill, into system prompt at startup | Always (startup) | **median ~80 tokens/skill** (range ~55–235); all 17 skills ≈ **1,700 tokens total** |
| **L2 Activation** | Full `SKILL.md` body | LLM reasons the skill is relevant to the task | body **~275 → ~8,000 tokens**, **median ~2,000** |
| **L3 Execution** | Bundled files (`reference.md`, `forms.md`, scripts) | Agent reaches a step needing them; usually via an explicit reference in the body ("see REFERENCE.md") | Only loaded files cost tokens; unreferenced files never load |

(anthropic.com/engineering; swirlai)

### How the consumer selects a level — pure LLM reasoning over descriptions
Crucial finding: **"Claude selects skills through pure reasoning, with description quality directly determining routing accuracy."** (swirlai) There is no keyword index, no embedding search, no routing table — the *description field is the entire selection surface*. Activation → the model decides SKILL.md is relevant. Execution → the model follows an in-body pointer to a bundled file.

### Index representation
The L1 index is **implicit**: it's the concatenation of every skill's `name`+`description` frontmatter, injected into the system prompt. There is no separate index file — the frontmatter *is* the index, harvested by the runtime. This is the "frontmatter is the single source, index is generated from it" pattern in the wild.

### Leanness guidance
"When the SKILL.md file becomes unwieldy, split its content into separate files and reference them." No hard numbers, but the design intent is: **body = orchestration + pointers; heavy/rarely-needed content = L3 files.** (anthropic.com/engineering)

### Maps onto our goals — this is the CLOSEST analogue
- L1 Discovery ≈ **our L0** (id/title/one-line description for triage) — and the measured ~80 tok/skill confirms a ~100-doc corpus's L0 index is trivially cheap (~8–20k tokens for all of adr+pdr+brief, well inside budget).
- L2 Activation ≈ **our L1/L2 boundary** (the "read the actual thing" step).
- L3 Execution ≈ **our L2** (the full context/alternatives/tradeoffs, pulled only when authoring).
- **Selection = LLM reasoning over the `description`/`decision` fields** → tells us the *quality of our L0 `description` and L1 `decision` text is the entire routing mechanism.* Invest writing effort there; no embeddings needed at this scale.
- Frontmatter-as-single-source, index-harvested-from-it → **directly validates design target (2)** (tiers+index generated from the one source).

**Divergence from our model:** Skills have three tiers but our L0/L1/L2 differ in *what* the middle tier is. Skills' middle (SKILL.md body) is *procedure*; our L1 is a *distilled decision statement* meant to be **distributed outward to BCs to conform to**. Skills have no "pour the L1 digest to another agent" concept — that's our addition (design target 4). So Skills validate the *level mechanic* but not the *distribution* mechanic; MCP resources cover distribution better.

---

## 3. MCP resources — list vs read, application-driven selection

### What it is
MCP servers expose **resources** (files, schemas, app data) to clients. Each is URI-identified. The protocol cleanly separates *discovering what exists* from *reading contents*. (modelcontextprotocol.io, 2025-06-18)

### Tiering primitive — the RESOURCE, discovered via a lightweight descriptor
`resources/list` returns descriptors, each with:
- `uri` (locator, required), `name` (required)
- `title` (optional, human display), `description` (optional), `mimeType` (optional), `size` (optional bytes)

`resources/read` (params: `uri`) returns the **full contents** (`text` or base64 `blob`).

So the two-step is explicit and protocol-level: **list = L0 descriptors; read = full document.** The descriptor (uri+name+title+description) is again *exactly our L0*, and `size` even lets the client budget before reading.

### Selection mechanic — application-driven, with annotation hints
The spec is explicit that resource selection is **"application-driven"**: the host can expose a picker UI, let the user filter/search, or do **"automatic context inclusion, based on heuristics or the AI model's selection."** The protocol deliberately does *not* mandate how you pick.

**Annotations** give machine-usable selection hints on each resource/descriptor:
- `audience`: `["user"]` / `["assistant"]` / both — *who is this level for.* → **directly maps to our "L1 → BCs, L2 → lead-only" audience split.** Tag L1 decision digests `audience: ["assistant"]` for the conforming BC; tag L2 lead-only.
- `priority`: 0.0–1.0, "1 = effectively required, 0 = entirely optional." → maps to the llms.txt `## Optional` lever and to ranking which decisions a BC must load first.
- `lastModified`: ISO-8601 → recency for sorting / staleness detection.

### Index representation
`resources/list` is a **machine (JSON-RPC) index**, paginated (`cursor`/`nextCursor`). `resources/templates/list` exposes **RFC-6570 URI templates** for parameterized/dynamic resources (e.g. `file:///{path}`) — you don't enumerate every doc, you expose a pattern the client fills in. There's also `notifications/resources/list_changed` and per-resource `subscribe` for **live index invalidation** — the machine analogue of "regenerate the index when a source doc changes."

### Maps onto our goals
- **list/read = L0/L2 two-step, as a protocol** → strongest validation that "cheap descriptor index, then pull the full doc by locator" is the right spine.
- **`annotations.audience` = our L1-to-BC vs L2-lead-only distribution split, as data** → we should carry an equivalent field in our frontmatter (or derive it from `status`/`tags`).
- **`annotations.priority`** = our "Optional"/must-conform ranking.
- **`size` in the descriptor** = pre-read budgeting; cheap to include, useful for an agent deciding L1-vs-L2.
- **`list_changed` / `subscribe`** = the event that should *trigger index regeneration* — the coherence-gate/regen should run on doc change, not on a timer (contrast llms.txt's "quarterly review" failure mode).
- **URI templates** are likely **overkill** for us: our corpus is ~100 static, enumerable files, not a dynamic/parameterized space. Enumerate; don't template.

---

## Cross-cutting synthesis: the shared shape

All three independently land on the **same two-move spine**:

> **INDEX of lightweight descriptors (title + locator + one-line note [+ hints]) → EXPAND to the full item by locator, on demand, driven by the consumer's need + budget.**

- The **descriptor** is universally `{name/title, locator, one-line description}` — sometimes plus hints (`audience`, `priority`, `size`, `lastModified`). **This is our L0, and it's remarkably stable across all three specs.**
- **Selection is LLM/consumer reasoning over the description text**, not search infrastructure. At ~100 docs, description quality *is* the retrieval system. (Skills proves this explicitly.)
- Where the three **differ** is the *middle*:
  - llms.txt: no real middle (index → full, with a skippable "Optional" band).
  - Skills: middle = the procedural body (SKILL.md).
  - MCP: no fixed middle; `annotations` let you *build* one.
  - **Our L1 (the distilled decision statement, distributed to conform) is a middle tier none of them ship natively.** It's the piece we must *generate* ourselves — closest prior art is Skills' "distill the essential into frontmatter/body and let heavy detail live one level down," applied to *decisions* rather than *procedures*.

### The distribution mechanic (design target 4)
Only MCP has a native "hand a selected subset to a consumer" model (list→read, with `audience` marking who each resource is for). Skills' "pour" is one-directional (runtime injects metadata; skill can't push a digest to a peer). llms.txt has none. → **For "distribute the L1 decisions digest to BCs," MCP's `audience`-annotated resource model is the cleanest conceptual template**, even though our transport is `shop-msg` / skills-style pour, not a live MCP server.

---

## Transferable mechanics (concrete, adopt these)

1. **Descriptor grammar = `{id/title, locator, one-line description}`.** All three agree. Make L0 exactly this. (llms.txt list-item, MCP `resources/list` entry, Skill frontmatter.)
2. **Human+machine in ONE artifact** (llms.txt's markdown-that-parses). Don't build a separate machine index; use a format that is both. Our frontmatter-in-markdown + a generated markdown/`llms.txt`-style index gives this for free.
3. **Description text IS the router.** No embeddings/RAG at this scale. Spend the effort making `description` (L0) and `decision` (L1) crisp and self-contained; that quality *is* routing accuracy (Skills, explicit).
4. **Split heavy/rare content one level down and reference it by pointer** (Skills leanness rule). Our L2 context/alternatives/tradeoffs = the "reference.md" that only lead-architect-authoring pulls.
5. **Audience + priority as descriptor hints** (MCP annotations). Encode "L1→BC / L2→lead-only" as an `audience`-like field and rank must-conform decisions with a `priority`/status field, rather than as out-of-band convention.
6. **`size` / pre-read budgeting** (MCP) — cheap to emit in the generated index, lets an agent choose L1 vs L2 knowingly.
7. **Regenerate on change, not on a timer** (MCP `list_changed`/`subscribe` vs llms.txt's "quarterly"). Bind index+digest regeneration and the coherence gate to the doc-change event (commit hook / CI), analogous to how `scenarios hash` runs.
8. **A skippable "Optional" band** (llms.txt) is a real, useful lever — maps to "these decisions are context, not conformance"; lets a BC pull a minimal must-conform set and skip the rest under budget pressure.

---

## Anti-patterns / overkill flags

- **A2 / DECISIVE — hand-maintained mirror = guaranteed drift.** The single loudest external signal. llms.txt's real-world failure is exactly a second copy nobody regenerates. *Our whole value proposition collapses if any tier is hand-edited.* Every tier (L0 index, L1 digest, `llms.txt`-style file) MUST be **generated** from the one frontmatter+body source, never authored in parallel. This is the nbx5 single-source precedent, independently confirmed. (aeo.press, searchsignal.online)
- **URI templates / dynamic resource spaces (MCP) = overkill** for ~100 static enumerable docs. Enumerate the corpus; don't build a parameterized template layer.
- **Live server / subscription protocol (MCP) = overkill as transport.** We want a *generated static artifact* (a CLI `decisions` sibling to `scenarios`), not a running MCP server. Borrow MCP's *data model* (list/read, annotations), not its RPC machinery.
- **Embeddings / vector RAG = overkill** at this scale — Skills shows pure description-reasoning routes accurately over a small labeled set; a 56-ADR corpus does not need semantic retrieval. (Defer to stream 04's hierarchical-retrieval analysis, but the level-mechanic evidence already points "no.")
- **Over-tiering.** llms.txt gets by with two tiers + an Optional band; Skills uses three. Three (L0/L1/L2) is the right ceiling — resist adding L1.5 etc. The value is in *generation + coherence*, not tier count.
- **Trusting a static file to stay fresh (llms.txt "quarterly review").** Don't adopt a review cadence; adopt event-triggered regen. A cadence *is* the drift admission.

---

## What this means for OUR L0/L1/L2 + generated-index + coherence-gate goals

- **L0/L1/L2 is well-founded.** The index→expand spine is the industry-convergent shape; our three tiers sit cleanly on it (L0 = MCP/llms.txt descriptor; L2 = the full read; L1 = the distilled-decision middle we must generate ourselves, à la Skills' distill-essential-upward move). CONFIRM the tier model at the mechanics level.
- **The index format should be `llms.txt`-style** (H1 + blockquote + H2 sections + `[id — title](path): decision-one-liner` list items) — human+machine in one artifact, and it's the format IDE/coding agents already fetch. Our generated L0 = an `llms.txt`/`decisions.txt` for the decision corpus.
- **Frontmatter is the single source; index and digest are generated harvests of it** (Skills' name+description → system-prompt index, made explicit and file-based for us). This validates design target (1)+(2) jointly: the required YAML frontmatter *is* the L0/L1 source, and a `decisions` CLI harvests L0 (index) and L1 (decision digest) from it — zero hand-authored mirror. This is how we dodge the A2 drift anti-pattern.
- **Distribution to BCs = the `audience`/`priority`-annotated subset model** (MCP). Encode who-each-tier-is-for as frontmatter (or derive from `status`/`tags`): L1 decision digest carries the must-conform decisions to BCs; L2 stays lead-only. The `## Optional` band (llms.txt) gives BCs a budget lever to load only must-conform decisions.
- **Selection needs no retrieval infrastructure.** At ~100 docs, `description`/`decision` text quality is the entire routing surface (Skills, empirically). Our generation tool's job is to make those fields crisp and self-contained; the agent's L0-scan-then-pull-L2 loop is just reasoning over that text. This narrows scope: build a *generator + gate*, not a *retriever*.
- **The coherence gate should be event-triggered, like `scenarios hash`/`list_changed`, not periodic.** Bind L0/L1 regeneration and the supersede-conflict / contradictory-active-decision check to the doc-change event (commit/CI). This makes the gate the enforcement counterpart of generation — same class as ADR-047's coherence gate and `scenarios --aggregate`. The `supersedes`/`superseded-by`/`status` frontmatter fields are the data the gate reads; `depends-on` gives it the graph to check for dangling/contradictory active edges.
- **Concrete cost check passes trivially:** an all-docs L0 index at ~80 tok/descriptor (Skills-measured) ≈ 8–12k tokens for the whole adr+pdr+brief corpus — cheap enough to always-load, so an agent can triage the entire decision space at L0 before pulling any L2. This is the quantitative green-light for the "always have the index, pull only what's relevant" goal.

---

*End of stream 01. Feeds 02 (index format / OKF), 05 (internal grounding: frontmatter schema + ADR-047 gate + nbx5), and 06 (synthesis scorecard).*
