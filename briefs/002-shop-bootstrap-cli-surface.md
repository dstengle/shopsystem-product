# Brief 002 — Shop bootstrap CLI surface

**Status:** draft (2026-05-12)
**Authors:** dstengle, Claude (lead-po)
**Beads:** [`lead-3d7`](#) (this brief)
**Anchored to:** user-driver observation 2026-05-12:
*"There should really be a way to bootstrap a repo into a shop. Right now
I'm going around and doing it semi-manually but that is not scalable."*
Five BC shops + the lead shop were set up by hand; an ecommerce product
is staging that will need both a lead-shop and several BC-shop scaffolds.

## Point of intent

A shop is a **shape** the framework defines (§3 for lead, §4 for BC). That
shape today is reproduced **by hand** every time a new shop is needed —
the canonical role templates are copied into `.claude/agents/`, a
shop-aware `CLAUDE.md` is hand-authored, `bd init` is run, `.gitignore`
is filled in. The cost of doing this manually compounds: it scales linearly
with shop count while the framework itself is meant to scale across
products, each containing one lead shop plus many BC shops.

The brief commits the shop-system to a **single CLI-driven bootstrap surface**
that takes an existing repository and adds the canonical shop scaffold to
it, parametrised by shop type (lead or BC). The surface is owned by
`shopsystem-templates` — extending the existing `shop-templates` CLI
(`list`, `show`) with bootstrap-related subcommands. This is net-new
capability for that BC.

The brief carries one invariant, four scope items, and an explicit
out-of-scope boundary.

## The invariant

### Inline `.claude/agents/*.md` copies remain CLI-managed

Per [PDR-002 path (a)](../pdr/002-lead-shop-roles-as-subagents.md), every
shop carries inline copies of the canonical role-prompt templates at
`.claude/agents/<role>.md`. Those copies are **provisional** until path
(b) lands (a `shop-templates` subagent export mode). The provisionality
turns into drift unless the lead shop and every BC have a **mechanical
way to re-sync** their inline copies against the templates BC's canonical
source.

The bootstrap surface IS that mechanism. The CLI both **lays down** the
inline copies at init time and **re-pours** them at update time. No
shop's `.claude/agents/*.md` is hand-edited; the source of truth is
always the canonical template under `shopsystem-templates`, reached
through the `shop-templates` CLI.

This is the [PDR-002](../pdr/002-lead-shop-roles-as-subagents.md) /
[brief 001](001-inter-shop-messaging-encapsulation.md) discipline applied
to the templates surface: the CLI is the integration boundary
([`findings/from-prototype-1.md` finding 6](../findings/from-prototype-1.md)),
not the filesystem. A scaffold that any consumer reproduces by hand is
not really a managed surface — it is a transcription error waiting to
happen.

## Four scope items

The brief commits intent on four items. Each is named here in product
terms; CLI command names, flag shapes, and on-disk substitution mechanics
are scenario-level concerns the Architect picks up after BC pre-state
verification.

### A — Bootstrap subcommand surface (scriptable, non-interactive)

`shop-templates` exposes a bootstrap subcommand surface that, given an
existing repository, adds the canonical scaffold for one shop. The
surface is **scriptable**: machine-friendly arguments, no interactive
prompts, deterministic exit codes, idempotent for the managed surface
(re-running against an already-bootstrapped shop re-pours managed files
and leaves shop-owned files untouched — see scope item D).

The surface supports **both shop types** through the same entry point:
parametrised by a shop-type argument or flag. A user (or a downstream
product-setup script) selects `bc` to get a BC-shop scaffold and `lead`
to get a lead-shop scaffold. The CLI shape is symmetric across shop
types — anything one type takes, the other takes equivalently — because
the eventual product-setup composition operates over both uniformly.

The surface accepts (at minimum):

- **Shop type.** `bc` or `lead`. No default — the caller commits.
- **Shop name.** Used wherever the scaffold names the shop (CLAUDE.md
  header, references in templated content). For a BC shop this is the
  BC name (e.g., `shopsystem-messaging`); for a lead shop this is the
  product name (e.g., `shopsystem-product`).
- **Target directory.** The existing repo to scaffold. Default to the
  current working directory; explicit override for the
  product-setup-script case where bootstrap is invoked at a known path.

The Architect's pre-state verification picks the exact subcommand names
(e.g., `shop-templates init` vs `shop-templates bootstrap` vs `shop-templates
new`) and the exact flag-vs-positional split. The brief commits the
shape, not the spelling.

### B — Generated surface (tight, named, both shop types)

The bootstrap generates **exactly** the following files inside the target
repo. The list is intentionally tight: anything outside it is shop-owned
(per scope item D) or out of scope (per the explicit out-of-scope
section).

**For both shop types:**

- `.claude/agents/<role>.md` — inline copies of the canonical role
  templates, sourced from `shop_templates.templates`. The role set
  varies by shop type: `bc-implementer.md` + `bc-reviewer.md` for BC;
  `lead-po.md` + `lead-architect.md` for lead.
- `CLAUDE.md` — the shop's router primer (BC-router structure for BC;
  lead-shop role-identity primer for lead). Shop name and role-set
  references substituted where templating applies. See scope item E
  for the substitution stance.
- `.beads/` — initialized via `bd init` (the same operation the
  framework already uses for beads-bootstrap; bootstrap composes it
  rather than reimplementing).
- `.gitignore` — standard shop-shape entries. The BC and lead variants
  may differ in detail (the lead-shop gitignore today ignores `/repos/`
  and `.venv/`; a BC shop's gitignore typically ignores its own
  `.venv/` plus the same beads/dolt entries).

**NOT generated:**

- `inbox/`, `outbox/` — these are `shop-msg`'s private storage. Per
  [brief 001 invariant 1](001-inter-shop-messaging-encapsulation.md),
  the storage layout is an implementation detail of the messaging BC;
  no consumer (including the bootstrap surface) creates or reads those
  directories. `shop-msg send` and `shop-msg respond` create what they
  need when they need it.
- `features/`, `tests/` — these are per-shop product concerns. The lead
  shop's `features/` holds PO-authored canonical scenarios; a BC shop's
  `features/` holds the scenarios that have been dispatched to it.
  Neither is bootstrap's concern.
- `pyproject.toml` — packaging is a per-shop product concern. A lead
  shop today uses the metapackage trick (`packages=[]`); a BC shop has
  its own real package. Bootstrap does not presume either.
- `README.md` — the shop author's call. Bootstrap stays out.

The boundary "what bootstrap generates" versus "what bootstrap does not
generate" is part of the contract, not a heuristic. The Architect's
scenarios pin each item.

### C — Update mechanism (re-syncs managed surface, leaves shop-owned alone)

When `shopsystem-templates` publishes new canonical role prompts (or new
canonical `CLAUDE.md` structure), existing shops must be able to **pull
the new versions into their inline copies** without re-bootstrapping
from scratch. PDR-002 path (a) is explicit that inline copies CAN drift;
the update mechanism is what keeps them honest.

The update operation:

- Re-pours every **bootstrap-managed** file from the current
  `shop-templates` package data into the target repo (see scope item D
  for the managed set).
- **Does not touch** shop-owned files. A shop's `features/`, `tests/`,
  `pyproject.toml`, `README.md`, or anything else outside the managed
  set is invisible to update.
- Is **idempotent**: running update against an up-to-date shop is a
  no-op (no spurious diffs).
- Is **discoverable as part of the same CLI surface**: whether update
  is a separate subcommand (e.g., `shop-templates update`) or a flag
  on the init subcommand (e.g., `shop-templates init --update`) is the
  Architect's call. The brief commits that **there is one CLI surface
  for the bootstrap concern**, not two parallel ones.

A consequence the Architect should pin in scenarios: when the canonical
template changes shape (a new role is added, or a role is removed), the
update operation's behavior against an older scaffold must be
specified — does it add the new role file, remove the old one, leave
unknown files alone? The brief commits intent that the managed set is
**always the current canonical set**, which implies adds-and-removes;
the Architect names the exact behavior in scenarios.

### D — File-management boundary (managed vs. shop-owned)

Every file the bootstrap surface touches falls into one of two classes,
explicitly named:

**Bootstrap-managed (replaceable on update, never hand-edited):**

- `.claude/agents/<role>.md` — every file in this directory that
  corresponds to a canonical role template. The agent file's content
  is always equal to the canonical template (with whatever
  substitution scope item E commits). A shop that wants to extend its
  agent set adds files with names outside the canonical role set;
  those are shop-owned by definition.

**Init-only (laid down at bootstrap, then shop-owned):**

- `CLAUDE.md` — laid down at init from the canonical primer template
  with substitution applied. After init, the shop may extend or
  customise it; update does NOT overwrite it. (See scope item E for
  why this is the right cut — and the residual question it raises.)
- `.gitignore` — laid down at init from the canonical entries. After
  init, the shop may add product-specific entries; update does NOT
  overwrite it.
- `.beads/` — laid down at init by composing `bd init`. After init,
  beads owns it; bootstrap does not touch it again.

The cut is: **content that exists to enforce role discipline is managed;
content that exists to express per-shop product intent is shop-owned.**
Role prompts are the framework's product (they define the discipline);
CLAUDE.md is partially the framework's product (it primes the router)
and partially the shop's (it names this shop's particulars). The cut
puts the dual-nature file on the shop-owned side because **the cost of
overwriting a shop's CLAUDE.md customisations is higher than the cost
of CLAUDE.md going slightly stale** — staleness surfaces under use;
overwriting silently loses work.

The Architect's scenarios pin the managed/init-only boundary explicitly,
file by file. Anything not on either list is out of bootstrap's scope.

## Out of scope — named explicitly

**Repository creation.** Bootstrap operates on an **existing** repo;
`gh repo create`, `git init`, remote configuration, and any other
repo-existence concern is the caller's responsibility. The user's
framing — "easy to add github or other repo creation later" — is
acknowledged but does not bind this brief. A follow-on can compose
repo-creation with bootstrap when a concrete driver surfaces.

**Product-level bootstrap (compose-N-shops-into-a-product workflow).**
The user's higher-level intent — a workflow that bootstraps a lead shop,
N BC shops, and wires them together (and possibly creates their remotes)
— is **explicitly out of scope for this brief**. This brief is the
per-shop building block; the product-level workflow composes it. A
follow-on brief opens when the ecommerce product surfaces concrete
composition requirements.

**Remote wiring (sibling clones, beads remotes, etc.).** A bootstrapped
shop knows nothing about its siblings. Putting a clone of BC X next to
the lead shop, or pointing the lead's `bd` at the lead-beads remote, is
a separate concern. The lead-shop convention names
`/workspaces/shopsystem-product/repos/` as the sibling-clone location
(per the user's auto-memory), but bootstrap does not create or manage
that directory. (Related: `lead-zmi` — shop-msg-on-PATH — is independent
of this brief.)

**Bootstrapping a non-repo directory.** Bootstrap assumes the target is
a git repository. Creating one and then bootstrapping it is the
caller's responsibility; the brief does not commit a "bootstrap also
runs `git init`" behavior.

## Vehicle hints (Architect's call)

For the Architect's awareness during pre-state verification — not as a
prejudgment of the discriminator:

- The bootstrap surface as a whole is **new capability** for the
  `shopsystem-templates` BC — `shop-templates --help` today shows only
  `list` and `show`. Net-new capability points to `assign_scenarios`.
- The single biggest pre-state question for the Architect is **whether
  the canonical lead-shop CLAUDE.md exists as a template in
  `shop_templates.templates/`**. Today the lead-shop CLAUDE.md (this
  repo's) is hand-authored and lives in this repo, not in the templates
  BC's package data. The templates BC ships role-prompt templates
  (`lead-po.md`, `lead-architect.md`, `bc-implementer.md`,
  `bc-reviewer.md`) but does NOT today ship a lead-shop CLAUDE.md
  template OR a BC-router CLAUDE.md template. Scope item E names this
  explicitly; the Architect's pre-state work confirms what exists and
  what must be elevated to canonical template before bootstrap can
  generate it.
- The BC-router CLAUDE.md template's pre-state is parallel: the current
  BC-router structure lives in `repos/shopsystem-templates/CLAUDE.md`
  as hand-authored content, not in the package data. Same question:
  elevate to canonical template? Or templated programmatically from
  shop-name + role-set?

These are pre-state observations, not prejudgments. The Architect's
`PRE-STATE DETERMINES VEHICLE — VERIFIED EMPIRICALLY` posture stands.

## E — CLAUDE.md substitution and the lead-shop template question (PO stance + open gap)

This deserves its own section because the brief commits a stance and
also names a residual gap that may escalate to a PDR if pre-state
verification or scenario authoring surfaces enough design tension.

**PO stance committed in this brief:**

1. **Both lead-shop and BC-shop CLAUDE.md primers ship as canonical
   templates from the templates BC.** Bootstrap generates each shop's
   CLAUDE.md by reading the appropriate canonical primer template,
   substituting per-shop parameters, and writing the result to the
   target repo. This means the current hand-authored
   `repos/shopsystem-templates/CLAUDE.md` (BC-router primer) and the
   current hand-authored `/workspaces/shopsystem-product/CLAUDE.md`
   (lead-shop role-identity primer) must be elevated to canonical
   templates inside `shop_templates.templates/` — net-new package data
   alongside the four existing role-prompt templates.
2. **The parameter set is minimal:** shop name, and the role set
   inferred from shop type. Adding more parameters expands the
   substitution mechanism's surface; minimalism keeps it tractable.
3. **CLAUDE.md is init-only, not managed (per scope item D).** Once
   laid down, the shop owns it. Bootstrap does not re-pour CLAUDE.md
   on update.

**Where the residual gap lives:**

The lead-shop CLAUDE.md is the **router primer** — it says "you are the
router; dispatch to PO or Architect; here is when to dispatch." That
content is the same across every lead shop (because every lead shop
has the same two judgment roles). But the lead-shop CLAUDE.md ALSO
expresses **per-product intent** — what this product is, what its
repo topology looks like, what "out of scope" means HERE. The current
hand-authored file mixes the two.

Elevating it to a canonical template forces a separation: the
router-primer-half is canonical (and would be managed on update if not
for the cost cited in scope item D); the per-product half is
substitution-fill (parameters) or shop-edits-after-init. The cut may
be cleaner than I'm naming, or it may turn out to require splitting
CLAUDE.md into two files (one canonical-managed, one shop-owned) — at
which point this becomes a PDR-shaped question about CLAUDE.md
architecture, not a scenario-shaped question about bootstrap behaviour.

**Forward path the brief commits to:** the Architect's pre-state work
on scope item E (specifically: extracting the canonical primer content
from the two hand-authored CLAUDE.md files) will surface whether the
separation is clean. If it is, scenarios pin the substitution and the
brief is the right vehicle. If the separation is messy enough that
"CLAUDE.md architecture" becomes a live design question, the Architect
flags it and a PDR opens before scenarios are authored against this
scope item. Items A–D are independent of E and can proceed regardless.

## Sequencing

- **Item A (bootstrap subcommand surface), B (generated surface for
  agents + .beads/ + .gitignore), C (update mechanism), D (managed vs.
  shop-owned boundary)** are independent of the CLAUDE.md-template
  question (E). They can be authored as scenarios and dispatched once
  the Architect has verified pre-state on the `shop-templates` CLI
  surface and confirmed the generated surface composes cleanly with
  `bd init`.
- **Item E (CLAUDE.md substitution + lead-shop template)** depends on
  the Architect's extraction of canonical-primer-content from the two
  hand-authored CLAUDE.md files. That extraction may surface a
  PDR-shaped question (per the gap named above). E proceeds last among
  the scope items — or escalates to a PDR if pre-state warrants.
- **Soft sequencing constraint:** this brief's work shares the
  templates BC with brief 001's items B + D (template-language
  decoupling). Brief 001's sequencing already pins that B+D wait on
  PDR-001's role-complete restructure ([`lead-kq0`](#)). Bootstrap's
  scaffolding work also waits on PDR-001 — the canonical templates the
  bootstrap copies must be in their post-restructure shape, otherwise
  the inline copies will need re-pouring as soon as PDR-001 closes.
  Authoring may proceed in parallel; dispatch should land after
  `lead-kq0`.

## Grounding artifacts

- [`pdr/002-lead-shop-roles-as-subagents.md`](../pdr/002-lead-shop-roles-as-subagents.md)
  — establishes the inline-copy discipline this brief operationalises;
  path (a) is the basis for "agents are bootstrap-managed."
- [`pdr/001-role-templates-role-complete.md`](../pdr/001-role-templates-role-complete.md)
  — the role-complete restructure that must precede bootstrap dispatch
  so the inline copies land in the right shape.
- [`briefs/001-inter-shop-messaging-encapsulation.md`](001-inter-shop-messaging-encapsulation.md)
  — invariant 1 (shop-msg as sole messaging surface) is what keeps
  `inbox/`/`outbox/` out of bootstrap's generated set.
- [`findings/from-prototype-1.md` finding 6](../findings/from-prototype-1.md)
  — "package CLIs are the integration boundary"; bootstrap is this
  finding applied to the templates surface.
- [`repos/shopsystem-templates/src/shop_templates/cli.py`](../repos/shopsystem-templates/src/shop_templates/cli.py)
  — current `shop-templates` CLI (`list`, `show`); bootstrap extends
  this surface.
- [`repos/shopsystem-templates/src/shop_templates/templates/`](../repos/shopsystem-templates/src/shop_templates/templates/)
  — canonical role-prompt templates; bootstrap reads from here for
  the `.claude/agents/*.md` inline copies.
- [`CLAUDE.md`](../CLAUDE.md) and
  [`repos/shopsystem-templates/CLAUDE.md`](../repos/shopsystem-templates/CLAUDE.md)
  — current hand-authored CLAUDE.md primers; scope item E names them
  as candidates for elevation to canonical templates.
- [`.gitignore`](../.gitignore) and the BC-shop equivalents — current
  scaffold content that scope item B's `.gitignore` generation
  reproduces.

## What this leaves open

The brief commits **intent**, not scenarios. Scenarios come after the
Architect verifies pre-state and picks vehicles per the discriminator.
Specifically:

- **Exact CLI subcommand names and flag shapes for A and C.** Whether
  bootstrap is one subcommand parametrised by `--type` versus two
  parallel subcommands (`init-bc`, `init-lead`), and whether update
  is a separate subcommand versus a flag, are scenario-level decisions
  the Architect names after pre-state.
- **Substitution mechanism details for E.** How parameters are
  expressed in the canonical template (placeholder tokens?
  templating-engine syntax? plain string interpolation?) is the
  Architect's call. The brief commits that substitution happens and
  what its minimal parameter set is.
- **Composition with `bd init` for B.** Whether bootstrap shells out
  to `bd init` (the same way `shop-msg` shells out to its dependencies)
  or composes the operation in-process is the Architect's call. The
  brief commits that bootstrap **produces** an initialised `.beads/`
  state regardless of mechanism.
- **PDR-vs-brief escalation for E.** As named in the section, if the
  Architect's extraction of canonical primer content from the two
  hand-authored CLAUDE.md files surfaces a cut that splits CLAUDE.md
  into managed-half and shop-owned-half (rather than a single
  init-only file), a PDR opens before E's scenarios are authored.

These are vehicle-level and design-tension questions, not intent-level.
The PO's commit is the invariant + the four scope items + the
explicit out-of-scope boundary + the stance and named gap on E.
