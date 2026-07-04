# Progressive disclosure — research stream 02: knowledge-index

**Stream:** knowledge-index (INDEX + single-source generation)
**Date:** 2026-07-04
**Status:** research complete — CONFIRM that a parse-frontmatter → emit-tiers/index generator is proven prior art (OKF `regenerate_indexes` is a near-exact template for OUR L0/L1); LLM-synthesized rollups flagged as overkill for our moderate, human-authored corpus.

This stream owns: (a) Google Open Knowledge Format (OKF) / `GoogleCloudPlatform/knowledge-catalog` — its frontmatter model, bundle/index shape, and how machine+human indexes are generated from a single source; (b) other machine+human index conventions (llms.txt, docs-as-data SSGs, JSON catalogs). The through-line question: **how do proven systems generate indexes/summaries from ONE source so hand-maintained summaries can't drift?**

---

## 1. Sources consulted

External (URLs):
- OKF spec — https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md (raw: https://raw.githubusercontent.com/GoogleCloudPlatform/knowledge-catalog/main/okf/SPEC.md)
- OKF README — https://raw.githubusercontent.com/GoogleCloudPlatform/knowledge-catalog/main/okf/README.md
- OKF reference-agent index generator (source) — https://raw.githubusercontent.com/GoogleCloudPlatform/knowledge-catalog/main/okf/src/reference_agent/bundle/index.py
- OKF frontmatter parser (source) — https://raw.githubusercontent.com/GoogleCloudPlatform/knowledge-catalog/main/okf/src/reference_agent/bundle/document.py
- OKF real generated index — https://raw.githubusercontent.com/GoogleCloudPlatform/knowledge-catalog/main/okf/bundles/ga4/index.md
- OKF repo tree — https://github.com/GoogleCloudPlatform/knowledge-catalog/tree/main/okf (dirs: `bundles/`, `samples/`, `src/reference_agent/`, `tests/`; files: `SPEC.md`, `README.md`, `pyproject.toml`)
- llms.txt spec — https://llmstxt.org/
- llms.txt tooling (Fern) — https://buildwithfern.com/learn/docs/ai-features/llms-txt
- llms.txt tooling (Mintlify) — https://www.mintlify.com/blog/how-to-generate-llmstxt-file-automatically
- Google Cloud OKF announcement — https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing/
- docs-as-data / frontmatter single-source — https://blog.trysteakhouse.com/blog/front-matter-standard-using-yaml-metadata-programmatically-control-crawler-behavior ; https://blog.thea.codes/a-small-static-site-generator/

Internal (this repo, for mapping):
- `/workspace/adr/018-empirical-verification-is-contract-surface.md:1-14` — current artifact header style: `# ADR-018 — <title>` then `**Status:** accepted (date)`, `**Pins:**`, `**Anchored to:**`, `**Related beads:**`. **No YAML frontmatter today.**
- `/workspace/pdr/016-*.md:1-5` — same bold-field-in-body pattern (`**Status:** draft (date)`, `**Authors:**`, `**Anchored to:**`).
- Only a handful of `adr/*.md` match `^---` (e.g. 028, 040, 006, 019–024) — and those are `---` horizontal rules mid-body, **not** frontmatter blocks. So the corpus has **zero** existing YAML frontmatter; L0/L1 metadata is currently locked inside prose headers.
- Corpus scale confirmed: `adr/` = 53 files, `pdr/` = 29 files, plus `brief/`, `features/`, `findings/`. Order ~100 decision-bearing docs — MODERATE.

---

## 2. OKF — the frontmatter + bundle model (the direct precedent)

**What OKF is:** a vendor-neutral, tooling-optional format for representing knowledge as *plain markdown files with YAML frontmatter*, organized into a hierarchical directory called a **Knowledge Bundle** (the unit of distribution). "No schema registry, no central authority, no required tooling." (SPEC / GC blog).

**Concept = one markdown doc.** Each `.md` (that isn't a reserved file) is a *concept*.

**Frontmatter schema (SPEC.md):**
- **Required: exactly one field — `type`** ("a short string identifying the kind of concept; consumers use it for routing, filtering, and presentation").
- **Recommended optional:** `title`, `description` ("a single sentence summarizing the concept — used by `index.md` generators, search snippets, and previews"), `resource` (URI of the underlying asset), `tags` (YAML list, cross-cutting), `timestamp` (ISO-8601 last meaningful change).
- Producers MAY add custom keys; **consumers MUST preserve unknown keys.** (Forward-compat by contract.)

Note the reference *implementation* (`document.py`) is stricter than the spec: `REQUIRED_FRONTMATTER_KEYS = ("type", "title", "description", "timestamp")` and `validate()` raises on any missing/empty one. So the shipped tool enforces a 4-field schema even though the spec mandates only `type`. **Takeaway: spec = permissive; the generator/validator is where you enforce the real required schema.** That is exactly the lever OUR coherence gate wants.

**Reserved files (bundle layout):**
```
bundle/
├── index.md      (Optional — directory listing; supports progressive disclosure)
├── log.md        (Optional — update history, date-grouped, newest first)
├── <concept>.md
└── <subdir>/
    ├── index.md
    ├── <concept>.md
    └── ...
```
`index.md` and `log.md` are reserved — MUST NOT be concept documents. **`index.md` contains NO frontmatter** and is grouped markdown sections of `[link](rel) - description`. Crucially: *"Producers MAY generate `index.md` automatically; consumers MAY synthesize one on the fly when none is present."* i.e. **the index is an artifact, not a source.**

**Cross-linking:** a link from concept A to concept B *asserts a relationship*; link semantics live in the surrounding prose, not the link. Two link forms: bundle-absolute (`/...`, recommended) or relative. (This is weaker than what we need — see anti-patterns; our `supersedes`/`depends-on` want *typed* edges, not prose-typed links.)

---

## 3. The generation pipeline (the golden nugget) — `bundle/index.py::regenerate_indexes`

This is the proven **parse-frontmatter → emit-index** pipeline, read from source. Mechanics:

1. **Parse (single source):** `OKFDocument.parse(text)` (document.py) splits the leading `---…---` YAML block from the body via `yaml.safe_load`; returns `{frontmatter, body}`. The concept `.md` IS the one source; frontmatter carries `title`/`description`/`type`/`timestamp`.
2. **Walk:** `_directories_to_index` collects every directory containing `.md` files.
3. **Per directory, per child `.md`:** load doc, read `fm["title"]` (fallback to filename stem), `fm["description"]` (fallback `""`), `fm["type"]` (fallback `""`). Build a tuple `(type, title, filename, description)`. **`index.md` itself is skipped** (never indexes itself).
4. **Emit (`_build_index_text`):** group entries by `type`, and for each type emit a `# <Type>` section with lines:
   ```
   * [<title>](<relative-link>)<space>-<space><description>
   ```
   Sorted by type, then title (case-insensitive). This is the machine+human index line — and it is *literally* id/title + one-line description = **our L0**.
5. **Rollup (bottom-up):** directories are processed deepest-first; a subdir appears in its parent's index under a synthetic `Subdirectories` group, with a rolled-up description. If a subdir has exactly one concept, its lone description is reused verbatim; **otherwise `synthesize_description(rel, pairs, model="gemini-flash-latest")` calls an LLM to write the rollup.** ← the only non-deterministic step; flagged below.
6. **Write:** `index_path.write_text(...)` overwrites `index.md`. Idempotent: re-run regenerates every index from current frontmatter. **Edit a description once (in the concept's frontmatter) → re-run → every index that mentions it updates. Zero hand-maintained summaries.**

Real output (`bundles/ga4/index.md`):
```
# Subdirectories

* [datasets](datasets/index.md) - A sample of obfuscated Google Analytics ...
* [references](references/index.md) - This directory contains specifications ...
* [tables](tables/index.md) - Contains Google Analytics event export data ...
```

**This `regenerate_indexes` function is a near-exact template for OUR L0 emitter.** Swap OKF's `(type,title,description)` for our `(id,title,description[,status])`, group by `tags`/`type` (or by artifact class adr/pdr/brief), and you have a generated L0 index with no drift surface. The whole generator is ~90 lines of stdlib + PyYAML.

**Broader pipeline (README):** the reference agent is a CLI (`reference_agent`) with `enrich` (generate bundles from BigQuery + optional LLM web crawl) and `visualize` (render bundle → self-contained HTML graph via Cytoscape.js/marked.js). For US: `enrich`/`visualize` are out of scope (source-extraction and pretty viz); **`regenerate_indexes` is the piece that transfers.**

---

## 4. llms.txt — the machine+human index convention + its tiering

**Format (llmstxt.org):** a `/llms.txt` markdown file: (1) required H1 project name; (2) blockquote summary; (3) zero+ free markdown sections (no headings); (4) zero+ H2 sections, each an "file list" of `[name](url): optional notes` links. A special **`## Optional`** section marks "secondary information which can be skipped if context length is limited." Deliberately markdown-not-XML so it's human-readable *and* regex/parser-friendly ("fixed processing methods").

**Its own tiering primitive — directly maps to L0/L1/L2:**
- `llms.txt` = the index (links + one-line notes) → **L0-ish** (triage).
- `llms_txt2ctx` (FastHTML CLI/Python module) expands the link list into two context files: **`llms-ctx.txt`** (excludes the `## Optional` links) and **`llms-ctx-full.txt`** (includes them). i.e. two disclosure depths generated from *one* link list. That "same source → two depths" pattern is exactly OUR L1-digest-vs-L2-full split.

**Single-sourcing in practice (corroboration):** Fern and Mintlify auto-generate `/llms.txt` + `/llms-full.txt` + per-page `.md` from the docs' own frontmatter — Fern "uses the `description` field if present, otherwise falls back to subtitle"; pages ordered alphabetically, descriptions pulled from frontmatter. Mintlify ships it "with no configuration." **The description is authored once in frontmatter; the index is emitted.** Same anti-drift discipline as OKF.

---

## 5. docs-as-data / SSG / JSON-catalog conventions (part b, briefly)

- **Static site generators** are the mainstream proof of "index generated from frontmatter": the generator loops over post metadata to render a top-level `index.html` listing — "avoids drift between content and index since the generator reads markdown and frontmatter" and writes the index as output (thea.codes; idratherbewriting). The recurring advice: **define a standard frontmatter schema and enforce it across the team** (title/description/author/date), because "mandatory structure … ensures content is clean and machine-readable."
- **JSON catalog / sitemap** variants (sitemap.xml, JSON manifests) are the same shape — a derived machine index emitted from the doc set — but they are *separate files a human can't read as prose*. OKF/llms.txt deliberately choose markdown so the index is dual-use (human + machine) from one artifact. For OUR ~100-doc corpus the markdown-index choice is right; a parallel machine-readable `index.json` (same generator, second emitter) is cheap to add if the coherence-gate/CLI wants structured input rather than re-parsing markdown.

---

## 6. Transferable mechanics (what to lift)

1. **One source = the doc's own YAML frontmatter; every index/digest/tier is an emitted artifact.** (OKF, llms.txt, all SSGs converge on this.) L0 and L1 are *outputs of a generator*, never hand-written — this is the core requirement and it is thoroughly proven.
2. **`regenerate_indexes` shape:** walk docs → `parse` frontmatter → project the tier's fields → group/sort → `write_text` (overwrite, idempotent). ~90 lines stdlib+PyYAML. Re-run = fresh index; drift is structurally impossible because there's no second place to edit.
3. **`OKFDocument.parse`/`.serialize`/`.validate` split:** a tiny dataclass that (a) parses `---…---` + body, (b) round-trips via `yaml.safe_dump(sort_keys=False)`, (c) `validate()` raises on missing required keys. Copy this shape; it's the schema-enforcement point.
4. **Spec permissive, tool strict:** put the real required-field set in the *validator*, not the prose spec. That validator is where our coherence gate lives.
5. **Tier = a field-projection of the same parsed frontmatter.** L0 = `(id,title,description)`; L1 = `(id,title,decision,status,supersedes,superseded-by)`; L2 = the whole file. Three emitters, one parser, one source.
6. **Two-depth expansion (llms_txt2ctx `ctx` vs `ctx-full`)** shows the L1-digest-to-distribute vs L2-full-lead-only split is a known, tooled pattern — not novel.
7. **Reserved index filename, self-excluded, no-frontmatter:** the generated index never indexes itself and carries no source-of-truth metadata — keeps the "source vs derived" boundary crisp.
8. **`timestamp` / `log.md`:** OKF tracks "last meaningful change" per concept + a date-grouped changelog. Useful for OUR staleness/coherence signals (a superseded doc whose `superseded-by` target is newer, etc.).

---

## 7. Anti-patterns / overkill flags

- **LLM-synthesized descriptions (`synthesize_description`, gemini-flash) = drift risk + non-determinism. AVOID for us.** OKF uses an LLM to roll up multi-concept directory descriptions. For OUR corpus every ADR/PDR *already has a human-authored one-line intent*; the `description` frontmatter field should be the single authored source and the generator should be **purely deterministic** (project + concatenate, no model call). An LLM in the generate path re-introduces exactly the summary-drift the initiative exists to kill, and makes the index non-reproducible (fails a hash/CI check). Keep the generator model-free.
- **The `enrich` (BigQuery/web-crawl source extraction) and `visualize` (Cytoscape HTML) halves of the reference agent are out of scope.** We are not extracting concepts from an external system nor building graph viz; we own hand-authored decision docs. Only `regenerate_indexes` transfers.
- **OKF's prose-typed links are too weak for supersede/depends-on.** OKF says "link semantics live in surrounding prose." OUR `supersedes`/`superseded-by`/`depends-on` must be *typed frontmatter fields* (machine-checkable edges), because the coherence gate needs to compute the supersede graph without NLP. Do not adopt OKF's untyped-link relationship model for decision edges; use explicit frontmatter list fields.
- **Don't build a JSON/sitemap catalog as the *primary* index for a ~100-doc corpus.** A markdown `index.md` (llms.txt-style, dual human+machine) is the right primary. Emit an optional `index.json` from the *same* generator only if the CLI/gate prefers structured input — but never maintain it by hand and never let it be a second source.
- **No central registry / schema server.** OKF explicitly rejects this; correct for our scale. The schema lives in the validator code + a short spec doc, versioned in-repo.

---

## 8. What this means for OUR L0/L1/L2 + generated-index + coherence-gate goals

- **Frontmatter migration is the precondition and the only real cost.** Today's ADRs/PDRs carry their metadata as *prose bold-fields* (`**Status:** accepted (2026-05-30)`, `**Pins:** …`) with **zero YAML frontmatter** across all 82 adr+pdr files. The design target's schema (`id,title,status,description,decision,supersedes,superseded-by,depends-on,tags`) must be lifted out of prose into a `---…---` block. This is a one-time backfill (candidate for a scripted extract + human review), after which the prose header can shrink or be regenerated. **This is where experiment 07 should focus: can we parse today's headers into the target frontmatter cleanly?**
- **L0 emitter = OKF `regenerate_indexes` almost verbatim.** Group by artifact class or `tags`, emit `* [<id> — <title>](<link>) - <description>`. Deterministic, idempotent, re-run in CI. This is proven; low risk. Verdict on the L0 mechanic: **CONFIRM.**
- **L1 "decisions digest" = a second emitter, same parser.** Project `(id, title, status, decision, supersedes, superseded-by)` into a single `DECISIONS.md` / `decisions.txt` digest. This is the tier "poured" to BCs (llms_txt2ctx `ctx` precedent: a distributable context file built from the index). L2 = the untouched full doc, lead-only. Three emitters over one `parse()`.
- **Single-sourcing / anti-drift:** structurally guaranteed the OKF/llms.txt/SSG way — `description` and `decision` are authored once in frontmatter; L0 and L1 are `write_text` outputs regenerated on every build; a CI check (`decisions build --check` / hash compare, mirroring the repo's existing `scenarios hash` discipline) fails the PR if a committed index is stale. Same anti-drift class the repo already fights with scenario hashes — the mechanism carries over cleanly.
- **Coherence gate = the validator + a supersede-graph pass.** OKF's `validate()` (raise on missing required keys) is the schema half. Add a graph pass over the *typed* `supersedes`/`superseded-by`/`depends-on` fields to flag: (a) a doc with `status: accepted` that is the target of some other doc's `superseded-by` (contradictory active decision); (b) asymmetric supersede edges (A supersedes B but B lacks `superseded-by: A`); (c) `depends-on` pointing at a superseded/absent doc; (d) two active docs with conflicting decisions on the same `tags` (heuristic surface). This is the analogue of `scenarios --aggregate` / the ADR-047 coherence gate — and it only works because we made the edges *typed frontmatter*, not OKF prose links.
- **Build-by-a-BC, CLI-sibling-to-`scenarios`:** everything above is a ~150–250-line Python CLI (`decisions parse|build|check|cohere`) with the `regenerate_indexes`/`OKFDocument` shapes as the skeleton. No LLM in the path. Fits the "decisions CLI sibling to scenarios, built by a BC" target. The generator being deterministic is what lets it live behind the same hash/CI gate as `scenarios`.
- **Net verdict for this stream:** the generate-from-one-source index pipeline is **CONFIRM** (OKF ships a working, minimal, copyable implementation; llms.txt + SSGs corroborate the single-source discipline). The frontmatter-backfill of the existing prose corpus is the **go-with-caveats** item to validate experimentally. The one thing to explicitly reject from the prior art is the **LLM-in-the-generator** rollup — keep OURS deterministic.
