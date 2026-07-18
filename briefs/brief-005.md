---
type: brief
id: brief-005
title: BC manifest
status: draft
created: 2026-05-20
updated: 2026-07-17
authors: [dstengle, Claude (lead-po)]
description: '**What behavior would satisfy the stakeholder:**'
derives-from: [pdr-006, pdr-004]
---

## Summary

## Scope

## Source (pre-modernization)

#### Interview notes (PO capture)

**What behavior would satisfy the stakeholder:**

- There is a single file, committed into the lead shop repo, that says
  exactly which BCs belong to this product. It is machine-readable (not
  a narrative document). A script can parse it and emit a list of
  canonical BC names and their GitHub remotes without any interpretation.
- Adding a BC to the product is a PR that edits this file. Removing a
  BC from the product is a PR that edits this file. Neither operation
  requires editing `repos/`, remembering to update a database, or
  updating a narrative document elsewhere.
- The lead shop's `repos/` clones, the DB registry (when it exists),
  and any "launch all BCs" list are all derived from the manifest — not
  maintained independently alongside it.
- A CLI command can take the manifest and produce derived state: clone
  missing repos, warn about extras, register BCs in the DB, or all of
  the above. The CLI is the bridge between the manifest (source of
  truth) and the derived representations.
- The manifest can be validated: the CLI can check that every BC
  declared in the manifest actually exists on GitHub, that the `repos/`
  directory is in sync, and that the manifest itself is syntactically
  valid.

**What would NOT satisfy the stakeholder:**

- Inferring BC membership from `repos/` (gitignored, drifts, contains
  non-product repos like `ddd-product-system`).
- Inferring BC membership from narrative documents (ADRs, briefs, PDRs)
  — those mention BCs but are incomplete and not machine-queryable.
- Inferring BC membership from message history (`shop-msg pending
  outbox`) — silent about BCs that have not yet communicated.
- A manifest that is a section of a larger file (e.g., a list inside
  `CLAUDE.md`) — it must be independently parseable.
- A manifest that requires human interpretation to determine whether a
  given BC is in scope.

**Boundaries the PO commits to:**

1. **The manifest is the source of truth for BC membership.** All
   other representations are derived. If the manifest and `repos/` 
   disagree, the manifest wins. If the manifest and the DB disagree,
   the manifest wins.
2. **The manifest lives in the lead shop repo, committed.** Not
   gitignored. Not in `repos/`. Not in a separate repo. The lead shop
   is the authoritative scope manager for the product.
3. **Each BC entry in the manifest has at minimum:** a canonical name
   (the `shopsystem-X` identifier), a GitHub remote URL, and a role
   label (e.g., `bc` to distinguish from future entries that might
   describe the lead shop itself or external dependencies). Additional
   fields (e.g., beads remote, devcontainer image tag) may be added
   but are not committed by this brief.
4. **The manifest is machine-readable.** A shell script or a Python
   snippet must be able to parse it and extract canonical names without
   calling an LLM or a PO. Format (YAML, TOML, JSON) is the
   Architect's call; machine-readability is the PO's invariant.
5. **The sync command operates from the manifest outward.** It does
   not read `repos/` and update the manifest; it reads the manifest
   and updates `repos/` (and the DB, if asked). The direction of
   authority is non-negotiable.

**Open questions the PO cannot close without Architect pre-state
verification:**

- **File format.** The PO commits machine-readability; YAML vs TOML
  vs JSON is the Architect's call after checking what the ecosystem
  already uses (e.g., whether `shop-msg` or `bd` parse any structured
  config today).
- **CLI name and flag shape.** The brief uses behavioral language
  ("the sync command", "the validate command"); exact command names
  and flags are the Architect's call per PDR-006.
- **Which BC owns the CLI.** PDR-006 resolves this. The brief commits
  the CLI must exist; its home is the PDR's question.
- **DB registration scope.** The manifest must exist before `shop-msg
  registry sync` (or equivalent) can work. The DB registry itself is
  brief 006's domain; the manifest is this brief's domain.
- **Initial manifest contents.** The six current product BCs are
  known from `repos/` inspection and session history. `ddd-product-
  system` in `repos/` is NOT a shopsystem BC and must not appear in
  the manifest. The six are:
  `shopsystem-messaging`, `shopsystem-scenarios`, `shopsystem-
  templates`, `shopsystem-test-harness`, `shopsystem-devcontainer`,
  `shopsystem-bc-launcher`. The Architect should verify each one
  exists on GitHub before populating the manifest.

---

#### Point of intent

The shopsystem today has no canonical answer to the question "which BCs
belong to this product?" BC membership is inferred from three overlapping
sources that do not agree: the `repos/` directory (gitignored, contains
non-product repos, drifts from truth), narrative documents (ADRs, briefs,
scenario files — partial, not machine-queryable), and message history
(`shop-msg pending outbox` — silent about idle BCs). The gap is most
visible at two operational moments:

1. **bc-container launch --all.** Brief 004 deferred this to "follow-on
   composition" specifically because there is no authoritative list to
   iterate over. Without the manifest, `bc-container launch --all`
   cannot know which BCs to launch.
2. **shop-msg registry sync.** If brief 001's DB registry work lands
   without a manifest, registry population reverts to ad-hoc
   (`shop-msg registry add shopsystem-messaging ...`, done by hand) and
   will drift as BCs are added or renamed.

This brief fixes the structural gap: the product defines its BC
membership explicitly, in a committed file, once. Derived representations
exist to serve operational tools; the manifest exists to tell the truth.

---

#### The invariant

##### The manifest file is the single source of truth for BC membership

Every BC that belongs to this product is declared in the manifest file.
Every BC that is NOT declared in the manifest file is NOT a product
member, regardless of what `repos/` contains, what a narrative document
says, or what the DB holds.

Adding a BC to the product requires a commit to the manifest file.
Removing a BC from the product requires a commit to the manifest file.
No other action is sufficient; no other action is required.

---

#### Three scope items

##### A — The manifest file

A structured, machine-readable file committed to the lead shop repo at
a well-known path. Each BC entry declares at minimum:

- The canonical BC name (`shopsystem-X` identifier).
- The GitHub remote URL from which the BC's repository is cloned.
- A role label that identifies the entry as a BC (as opposed to future
  entry types the format might support — the lead shop itself, external
  dependencies, etc.).

The file is committed in version control. It is not gitignored. It is
parseable by a standard YAML/TOML/JSON library with no custom code.
It contains no narrative prose that a parser must skip. All six current
product BCs appear in the initial commit of the manifest file.

**What the PO does not commit:** the exact format (YAML vs TOML vs
JSON), the exact field names beyond the three categories above, and the
well-known path (adjacent to `CLAUDE.md`, under `.claude/`, or at
`bcs.yaml` — the Architect picks after PDR-006 resolves ownership).

##### B — The sync command

A CLI command that reads the manifest and produces derived state. At
minimum, the sync command must support two operations (either as
separate subcommands or flags — the Architect picks the shape):

1. **Clone-sync:** for each BC declared in the manifest, ensure
   `repos/<canonical-name>/` is cloned from the declared remote. If
   a clone is missing, clone it. If a clone exists and its remote
   matches, skip it. If `repos/` contains a directory for a BC not in
   the manifest, warn (do not delete without explicit confirmation).
2. **Validate:** check that every BC declared in the manifest has a
   GitHub repository reachable at the declared remote URL, and that the
   manifest file is syntactically valid. Exit non-zero if any check
   fails; emit a human-readable summary of what passed and what failed.

The sync command is scriptable: machine-friendly arguments, no
interactive prompts, deterministic exit codes (0 = all checks passed;
non-zero = at least one failure with the failure enumerated on stderr).

The clone-sync operation is idempotent: running it twice on a fully
synced workspace produces no changes and exits zero both times.

##### C — Drift detection

The sync command's validate operation must include drift detection
between the manifest and `repos/`. Specifically:

- Any directory in `repos/` that matches `shopsystem-*` but is not
  declared in the manifest is reported as an unexpected entry.
- Any BC declared in the manifest whose `repos/<name>/` directory is
  absent is reported as a missing clone.
- Any BC declared in the manifest whose `repos/<name>/` remote URL
  does not match the manifest's declared remote is reported as a
  remote mismatch.

`ddd-product-system` in `repos/` is the canonical example of an
unexpected entry: it is not a shopsystem BC, and the validate operation
should flag it.

---

#### Out of scope — named explicitly

**The DB registry.** Populating the DB with BC entries (so that
`shop-msg` can use them for routing) is brief 006's domain. The manifest
is the source of truth the DB is populated FROM; the DB population
mechanism is not this brief's scope. Scope item B (sync command) may
include a `--register` or `--db` flag as a stretch goal, but only if
the Architect confirms that the DB registration API exists at pre-state
time. If it does not exist, the sync command's initial scope is
clone-sync and validate only.

**Building or publishing the devcontainer image.** The manifest declares
which BCs exist; it does not configure how their containers are built.
BC-specific image configuration belongs to the devcontainer BC and the
bc-launcher BC.

**Automated manifest updates.** The manifest is a committed file edited
by humans (or by a PO-directed Architect dispatch). There is no
mechanism in this brief for the manifest to update itself automatically
when a new BC is created. New BC creation is a deliberate act that
includes a manifest PR as a step.

**Lead shop manifest.** The manifest is for product BCs. The lead shop
is not a BC and does not appear in the manifest. Lead-shop metadata
(beads remote, GitHub URL) lives in the lead shop's own configuration.

---

#### Sequencing

- **Scope item A** (the file) has no blockers. It can land as soon as
  PDR-006 resolves file path and the Architect verifies the six BC
  GitHub remotes.
- **Scope item B** (sync command) requires item A to exist (the command
  must have a file to read), and requires PDR-006 to name the owning BC.
- **Scope item C** (drift detection) is part of scope item B's validate
  operation — same command, no separate blockers beyond B.
- **Brief 006 (DB registry)** follows this brief: the manifest is the
  prerequisite for populating the registry. Sequencing is strict.

#### Vehicle hints (Architect's call)

- Scope item A (the manifest file) is a flat file committed to the lead
  shop repo — zero BC work unless the Architect determines that file
  format tooling (a schema validator, a linter) needs to be authored
  by a BC. The Architect may author the file directly in the lead shop
  as part of dispatching.
- Scope items B and C (sync and validate commands) are net-new
  capability. The vehicle is `assign_scenarios`. The target BC is
  PDR-006's answer.

#### Grounding artifacts

- [brief 004](004-bc-container-isolation.md) — deferred `bc-container
  launch --all` to "follow-on composition"; the manifest is what makes
  that follow-on unblock-able.
- [brief 001](001-inter-shop-messaging-encapsulation.md) — the DB
  registry that the manifest will eventually feed (brief 006 is the
  bridge).
- [PDR-004](../pdr/004-bc-container-command-ownership.md) — establishes
  `shopsystem-bc-launcher` as the BC that needs a BC list to operate.
- [PDR-006](../pdr/006-bc-manifest-ownership.md) — resolves which BC
  owns the manifest's CLI.

#### What this leaves open

The brief commits **intent**, not scenarios. Scenarios come after the
Architect verifies BC pre-state and picks vehicles per the discriminator.

- **Exact file format and field names.** YAML vs TOML vs JSON; field
  names for canonical name, remote, role. Architect picks after
  PDR-006 resolves ownership and pre-state is verified.
- **Well-known file path.** Adjacent to `CLAUDE.md` (e.g., `bcs.yaml`),
  under `.claude/` (e.g., `.claude/bcs.yaml`), or elsewhere. Architect
  picks.
- **DB integration.** Whether the sync command's initial scope includes
  `--register` depends on whether brief 006's DB API exists at pre-state.
  Architect verifies.
- **Which BC owns the CLI (PDR-006).** Until that PDR resolves, the
  scenarios cannot be assigned. The PO flags PDR-006 as the blocker.
