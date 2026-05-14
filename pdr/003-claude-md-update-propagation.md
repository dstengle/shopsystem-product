# PDR-003 — CLAUDE.md update propagation

**Status:** Proposed
**Date:** 2026-05-14
**Author:** lead-po (subagent dispatch)
**Beads:** lead-5kn

## Context

A shop must bootstrap and run self-contained — the `repos/` directory of
the lead-shop product is not assumed available inside a bootstrapped shop.
That was the bootstrap-time framing. The **temporal corollary** has not
been pinned by scenarios: once bootstrapped, a shop must stay self-
contained as the canonical evolves. Concretely, when the canonical
`CLAUDE.md` primer in `shopsystem-templates` changes (e.g., the Monitor-
arming directive added by scenarios 71/72/73), bootstrapped shops must
receive that change through `shop-templates update`, not through manual
re-editing in each shop.

The current contract pins the **opposite**: `shop-templates update` is
explicitly forbidden to touch the target's `CLAUDE.md`, even when the
canonical primer has changed since bootstrap (scenario 39, reinforced by
scenario 56's error-path invariant). The source comment at
`repos/shopsystem-templates/src/shop_templates/cli.py:585-587` cites four
hashes as the "non-touch invariant on CLAUDE.md / .gitignore / .beads/".

The deeper tension is that `CLAUDE.md` is **part-canonical, part-per-
shop**: scenario 45 requires the bootstrap-generated `CLAUDE.md` to name
the shop's own identity (shop name, role set), while scenario 44 holds
the canonical primer as package-data source-of-truth. Empirical evidence:
this product's `repos/shopsystem-templates/CLAUDE.md` carries canonical
primer text *and* shop-authored sections like "Repo layout" and "Build &
Test" that no canonical template would dictate. Any propagation contract
must reconcile these.

## Design alternatives

### A. Full replace
`update` overwrites `CLAUDE.md` from canonical unconditionally. Cleanest
mechanism; loses scenario 45 (no shop identity in the result) and erases
shop-authored prose. Rejected.

### B. Identity parameterization
`CLAUDE.md` becomes fully canonical once shop name and role set are
template parameters resolved at update time. The shop owns *no*
`CLAUDE.md` content. Pure mechanism, but requires that no shop ever
benefits from local primer additions — empirically false for the
`shopsystem-templates` BC repo today, which carries shop-authored "Repo
layout" and "Build & Test" sections. Would force migration of all
shop-authored prose elsewhere before adoption. Rejected as the first
move; viable as a longer-term direction once the canonical primer is
parameterized.

### C. Sentinel-delimited canonical region
The canonical primer template defines a region delimited by sentinel
comments (e.g., `<!-- shop-templates:canonical:begin -->` and
`<!-- shop-templates:canonical:end -->`). `update` replaces only the
text between sentinels in the target's `CLAUDE.md`; everything outside
the sentinels is preserved byte-for-byte. Requires mutating `CLAUDE.md`
on every update, which contradicts scenario 39's byte-for-byte non-touch
invariant and forces amending scenarios 39 and 56 to scope the invariant
to outside-sentinel content. Rejected in favor of F (below); F achieves
the same propagation outcome with cleaner ownership and no merge logic.

### D. Sectioned merge by header name
Like C but keyed on Markdown headers instead of sentinels. Rejected as
fragile: header text edits in either the canonical template or the
target would silently break the merge contract. Sentinels are explicit;
headers are not.

### E. Canonical primer in dedicated imported files, with shop-owned `CLAUDE.md`
The canonical primer content lives in a dedicated file under
`.claude/canonical/`. `CLAUDE.md` is shop-owned end to end and imports
the canonical file via Claude Code's `@<filename>` directive. `update`
overwrites the canonical imported file in place and never touches
`CLAUDE.md`. Preserves scenarios 39, 45, 56 verbatim. Rejected per
stakeholder directive (2026-05-14) in favor of F, which trades some
scenario preservation for a cleaner ownership story.

### F. Canonical-managed `CLAUDE.md` with four typed imports (RECOMMENDED)
`CLAUDE.md` is **canonical-managed and overwritten by `update`**. Its
body is intentionally minimal: a short header plus a fixed sequence of
`@<filename>` imports. The substantive content lives in four typed
files, each with a single owner:

1. **Shop-name file** — contains the shop's own name (the literal string
   passed as `--shop-name` at bootstrap). **Bootstrap-only**, never
   touched by `update`. Owner: the shop.
2. **Shop-type file** — contains the shop's type token (`bc` or `lead`).
   **Bootstrap-only**, never touched by `update`. Owner: the shop.
3. **Canonical primer file** — the canonical router-prompt content for
   this shop type. Ships as package data; **overwritten by `update`** on
   drift. Owner: canonical (`shop-templates` package data).
4. **Shop-specific primer file** — shop-authored prose (e.g., "Repo
   layout", "Build & Test", anything the shop wants to add). Created
   at bootstrap as an empty (or near-empty) placeholder. **Never touched
   by `update`**. Owner: the shop.

`CLAUDE.md` itself is a deterministic function of canonical package data
and the shop type — the same `CLAUDE.md` body is written into every shop
of a given type. Bootstrap parameters (`--shop-name`, `--shop-type`) are
captured in the two shop-owned dotfiles imported by `CLAUDE.md`, not
spliced into `CLAUDE.md` itself.

Pros:
- **Cleanest ownership story.** Every file has exactly one owner. The
  path itself signals ownership (see "File-path convention" below). A
  reader can answer "who writes this file?" without reading its
  contents.
- **Canonical content propagation is unconditional and bulletproof.**
  The shop cannot accidentally remove an import or hand-edit `CLAUDE.md`
  in a way that loses canonical content, because `update` rewrites
  `CLAUDE.md` from canonical every time. No drift is possible.
- **No merge logic, no sentinels, no parsing.** `update` performs four
  operations at most: rewrite `CLAUDE.md`, rewrite the canonical primer
  file, leave the two shop-owned files alone, leave the shop-specific
  primer alone.
- **Shop-authored prose has a dedicated home.** The shop-specific
  primer file is the named, expected place for "Repo layout", "Build &
  Test", and other shop-local content. Separation of concerns is
  explicit at the file boundary, not buried inside a multi-author file.
- **Symmetric with how `update` already handles `.claude/agents/`.** Both
  surfaces become "canonical package data poured in place"; `CLAUDE.md`
  joins the same model rather than being a special case.

Cons:
- **Scenario 39 is contradicted.** `update` does overwrite `CLAUDE.md`.
  Operators who hand-edited `CLAUDE.md` under the old contract lose
  those edits on `update`. A migration story is required (see below).
  The recommendation accepts this hit deliberately; the cleaner
  ownership story is judged to be worth the cost.
- **Four files instead of one.** More bootstrap surface; a new reader
  has more files to orient to. Mitigated by `CLAUDE.md` being short and
  literally naming each import (e.g., `@.claude/shop/name.md  # the
  shop's own name`) so the import graph is self-documenting.
- **Depends on Claude Code's `@<filename>` import mechanism** being
  stable across consumers (CLI, IDE extension, future agent runtimes).
  Same dependency as alternative E.
- **Bootstrap parameter capture lives in a file, not in prose.** A
  human glancing at `CLAUDE.md` will see only the imports, not the
  shop's name directly. They must follow `@.claude/shop/name.md` to
  see "shopsystem-product". Mitigated by `CLAUDE.md` placing the
  shop-identity imports at the top, so the indirection is visible
  immediately.

## Recommendation

Adopt **alternative F — canonical-managed `CLAUDE.md` with four typed
imports**. The contract becomes:

1. Canonical primer content for each shop type ships as a dedicated file
   in `shop-templates` package data (`lead-primer.md`, `bc-primer.md`),
   parallel to the role-prompt template files already shipped there. A
   canonical `CLAUDE.md` template body also ships as package data, one
   per shop type.
2. Bootstrap writes **five** files into the target shop:
   - `CLAUDE.md` at the target root (canonical-managed).
   - `.claude/shop/name.md` (shop-owned, bootstrap-only) — the literal
     value passed as `--shop-name`.
   - `.claude/shop/type.md` (shop-owned, bootstrap-only) — the literal
     value passed as `--shop-type`.
   - `.claude/canonical/<shop-type>-primer.md` (canonical-managed) —
     the canonical router-prompt body.
   - `.claude/shop/primer.md` (shop-owned, bootstrap-only placeholder)
     — empty or near-empty; the shop fills it in over time.
   `CLAUDE.md`'s body imports those four files in a fixed order with
   short headings that name each import's role.
3. `update` overwrites two files: `CLAUDE.md` (from the canonical
   `CLAUDE.md` template for the shop's declared type) and
   `.claude/canonical/<shop-type>-primer.md` (from the canonical primer
   for the shop's declared type). It reads `.claude/shop/type.md` to
   know which shop type's canonical to apply.
4. `update` is idempotent when both canonical-managed files already
   match package data byte-for-byte — no diagnostic, no file mtime
   change, exit zero.
5. `update` does **not** touch `.claude/shop/name.md`,
   `.claude/shop/type.md`, or `.claude/shop/primer.md` under any
   circumstances.
6. **Migration** for legacy shops (including this product's own lead
   shop today, whose `CLAUDE.md` predates the four-file split): see the
   "Migration" subsection below.

### File-path convention

The split lives under `.claude/`:

- `.claude/canonical/` — **canonical-managed**. Files here are written
  by `bootstrap` and rewritten by `update` from package data. Operators
  must not hand-edit; edits will be silently reverted on the next
  `update`. Today this directory already houses the canonical agent
  files (`bc-implementer.md`, etc., via `.claude/agents/` — see note
  below); alternative F adds `<shop-type>-primer.md` to its content
  set.
- `.claude/shop/` — **shop-managed**. Files here are written once at
  bootstrap and then owned by the shop. `update` never touches anything
  under `.claude/shop/`.
- `CLAUDE.md` at the target root — **canonical-managed** (this is what
  changes under F). Its content is a deterministic function of
  `.claude/shop/type.md` and canonical package data.

Note on `.claude/agents/`: today the agent role-prompt files live there
and are managed by `update`. Under F they remain where they are;
`.claude/agents/` is canonical-managed in the same sense as
`.claude/canonical/`. The PDR does not propose renaming `.claude/agents/`
into `.claude/canonical/agents/`; that is a follow-up consolidation if
desired.

Rationale for path choice: ownership is legible from the path alone.
`.claude/canonical/...` says "do not hand-edit"; `.claude/shop/...` says
"this is yours". A new operator does not need to read a contract
document to know which is which.

### Migration

A legacy shop (one bootstrapped under the pre-F contract) has a
monolithic `CLAUDE.md` containing canonical primer text inlined,
shop-authored prose interleaved, and no `.claude/shop/` directory.
This product's own lead shop is exactly such a legacy shop today, so
the migration UX is concrete, not hypothetical.

The recommended migration shape is **refuse-with-diagnostic** (not
auto-migrate). When `update` runs in a target that lacks
`.claude/shop/type.md`, it:

- Exits non-zero.
- Writes a diagnostic to stderr naming the migration steps the
  operator must perform: create `.claude/shop/{name,type,primer}.md`
  with appropriate contents; move any shop-authored prose from the
  existing `CLAUDE.md` into `.claude/shop/primer.md`; then re-run
  `update`.
- Touches no files in the target.

Rationale: auto-migrate would have to parse a free-form `CLAUDE.md` to
separate canonical text from shop-authored prose, with no reliable
delimiter. That's exactly the brittleness alternative D was rejected
for. Refuse-with-diagnostic keeps the migration step explicit, manual,
and reviewable; the cost is a one-time per-shop operator action.

A future `shop-templates migrate` subcommand could automate the file
moves once we accept the legacy `CLAUDE.md` will need a sentinel or
operator-marked region to make the split deterministic. That is out of
scope for this PDR.

## Scenarios this PDR contradicts

- **39** (`update-preserves-shop-owned-claude-md-edits`). Under F,
  `update` overwrites `CLAUDE.md` from canonical. The original
  invariant ("byte-for-byte preservation of `CLAUDE.md`") no longer
  holds against `CLAUDE.md` itself. The replacement invariant is that
  `update` preserves shop-authored content **in
  `.claude/shop/primer.md`** byte-for-byte; `CLAUDE.md` itself is
  canonical-managed and outside the preservation contract. The PO
  proposes **amending** scenario 39 (not superseding) — the same
  identifier should continue to express "update does not destroy the
  shop's authored content," with the storage location updated to
  `.claude/shop/primer.md`. Architect's call whether amend or supersede.

## Scenarios this PDR preserves (unchanged)

- **31** (bootstrap writes top-level `CLAUDE.md`) — preserved.
  `bootstrap` continues to write `CLAUDE.md`; the file is non-empty
  (its body contains the four import lines plus a short header).
- **44** (canonical primer is package data) — preserved. The canonical
  primer continues to ship as package data, now as dedicated
  `<shop-type>-primer.md` files. A second canonical asset
  (`<shop-type>-claude-md.md` or similar — the canonical `CLAUDE.md`
  template body) is added; this is additive to 44, not a contradiction.
- **56** (`update-rejects-missing-target-with-argparse-error`) — the
  error-path clause that `CLAUDE.md` is unchanged from before the
  invocation **holds**, because `update` writes nothing on argparse
  error. The wording can stand verbatim; on the success path,
  `CLAUDE.md` may now change, but the error-path invariant is
  unrelated to the success-path contract.
- **40, 41** (`.gitignore` and `.beads/` non-touch invariants) —
  unaffected; F changes only the `CLAUDE.md` surface.

## Scenarios this PDR amends (Architect call)

- **45** (`bootstrap-generated-claude-md-names-the-shops-identity`).
  Under F, the substring check `that file contains the literal substring
  "<shop_name>"` no longer passes against `CLAUDE.md` directly — the
  shop name lives in `.claude/shop/name.md`, imported by `CLAUDE.md`.
  Two phrasings, Architect's pick:
  - **Phrasing A (PO leans):** retain the assertion at the level of
    the assistant-resolved `CLAUDE.md` (imports included). The
    scenario pins "the shop's identity is named in the agent's
    startup context," which is what we actually care about.
  - **Phrasing B:** amend the scenario to assert "the `CLAUDE.md`
    import graph names the shop identity" — i.e., `CLAUDE.md` imports
    `.claude/shop/name.md`, and that file contains `<shop_name>`.
    More mechanism-precise; couples the scenario to the import
    discipline.
  PO leans toward Phrasing A.
- **71 / 72 / 73** (Monitor-arming directive in canonical and
  bootstrap-generated `CLAUDE.md`). Same dichotomy as in v2 of this
  PDR. Under F, the directive lives in
  `.claude/canonical/<shop-type>-primer.md`, reachable from
  `CLAUDE.md` via import. Phrasing A (assertion at the level of
  assistant-observable behavior — the directive is present in the
  agent's startup context) is preserved as-is. Phrasing B (assert the
  storage location directly) requires amendment to name the canonical
  primer file. PO leans Phrasing A — the scenarios pin agent-
  observable behavior, not storage location.

## New scenarios this PDR will author after acceptance

1. **Canonical `CLAUDE.md` body ships as package data, per shop type.**
   `shop-templates` exposes a canonical `CLAUDE.md` template body for
   each shop type via the same package-data surface as the primer and
   role-prompt templates. (Companion to scenario 44.)
2. **Bootstrap writes the canonical-managed `CLAUDE.md`** whose body
   is the canonical template body for the shop's type, byte-for-byte.
3. **Bootstrap writes `.claude/shop/name.md`** containing exactly the
   value passed as `--shop-name`, with no other content.
4. **Bootstrap writes `.claude/shop/type.md`** containing exactly the
   value passed as `--shop-type` (`bc` or `lead`), with no other content.
5. **Bootstrap writes `.claude/canonical/<shop-type>-primer.md`** with
   the canonical primer for the chosen shop type, byte-for-byte from
   package data.
6. **Bootstrap writes `.claude/shop/primer.md`** as a shop-authored
   placeholder (empty or near-empty); the operator may populate it
   later. (Companion to "shop-authored prose has a dedicated home"
   under F.)
7. **`CLAUDE.md` body imports the four typed files in a fixed order**
   — property-level assertion: when the assistant resolves `CLAUDE.md`,
   the contents of all four files are present in its startup context.
   Literal import syntax is an Implementer follow-up against
   authoritative Claude Code documentation.
8. **`update` overwrites `CLAUDE.md`** with the canonical `CLAUDE.md`
   body for the shop's declared type when the target's `CLAUDE.md`
   has drifted from canonical.
9. **`update` overwrites `.claude/canonical/<shop-type>-primer.md`**
   when the canonical primer has drifted from the target's copy.
10. **`update` does not touch `.claude/shop/name.md`** under any
    circumstances on the success path.
11. **`update` does not touch `.claude/shop/type.md`** under any
    circumstances on the success path.
12. **`update` does not touch `.claude/shop/primer.md`** under any
    circumstances on the success path (this is the F-shaped
    replacement for the old scenario 39's intent — shop-authored
    content is preserved, just in a different file).
13. **`update` is idempotent** when both canonical-managed files
    already match package data byte-for-byte — exit zero, no
    diagnostic, no file mtime change.
14. **`update` reads `.claude/shop/type.md`** to determine which
    shop type's canonical templates to apply. (Pins the data flow:
    the shop's declared type at bootstrap is authoritative for
    subsequent updates, not a flag re-passed at update time.)
15. **Migration scenario — refuse-with-diagnostic.** When `update`
    runs against a target that lacks `.claude/shop/type.md` (legacy
    bootstrap), `update` exits non-zero, writes a diagnostic naming
    the migration steps the operator must perform, and touches no
    files in the target.

## Open questions (for Architect)

1. **Phrasing A vs. Phrasing B** for scenarios 45 and 71/72/73 — the
   Architect's call when assigning the new scenario set.
2. **Whether to amend or supersede scenario 39.** PO recommends amend
   (same identifier, new storage location for the preservation
   contract).
3. **Exact filenames** for the canonical assets under
   `shop-templates`' package data — the PDR names `<shop-type>-
   primer.md` and a parallel canonical `CLAUDE.md` body asset, but
   does not pin the literal filename of the latter (e.g.,
   `<shop-type>-claude-md.md` vs. `claude-md-<shop-type>.md`). An
   Implementer concern.
4. **Whether `update`'s migration exit code should be 1 or another
   non-zero value**, and whether the diagnostic should be
   machine-parseable (e.g., a stable error tag). PO recommends 1 with
   a free-form but consistent diagnostic; Architect may refine.
5. **Whether `.claude/shop/type.md` and `.claude/shop/name.md` should
   be plain-text single-line files** or a single combined YAML/TOML
   file. PO recommends two plain-text files for path-level legibility
   (the path itself names what it holds); Architect may prefer one
   structured file for forward extensibility (e.g., adding a future
   `shop-version` field).
