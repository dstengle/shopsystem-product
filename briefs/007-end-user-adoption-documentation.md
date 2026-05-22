# Brief 007 — End-user adoption documentation

**Status:** ready for architect dispatch (2026-05-22) — Q1–Q5 resolved by
stakeholder in this session; one design exploration (Q6, scenarios-as-doc
source) and one launcher-gap finding (Q7, no host-side primitive launches
a lead shop into a container today) surfaced for later resolution. Q7 is
paired with brief 008 slice 1 as its empirical prove-out vehicle.
**Authors:** dstengle, Claude (lead-po)
**Beads:** [`shopsystem-templates-h22`](#) (this brief — note: bead lives
in the `shopsystem-templates` BC tracker, surfaced to the lead via this
brief)
**Anchored to:** stakeholder intent, session 2026-05-22 17-30Z (verbatim):

> "I need documentation on bootstrapping a new product with a lead shop
> and individual BCs."

…clarified after a misread (the prior brief, 007, was authored against
an internal-contributor audience and was withdrawn):

> "I want documentation for how a user would create a completely new
> product using the shop system. This would involve Creating repos,
> launching containers using the tools to initialize templates and
> such. This is not related to the structure of this product."

…and on minimum friction:

> "Given this system is meant to run entirely in containers, there
> should be a way to launch the lead container, bootstrap automatically
> from inside and run the rest of the system. This could start by using
> docker outside of docker. In short, the work the user needs to do
> should be minimal. If necessary, these steps could be documented for
> an agent to consume and do the setup."

---

## Interview notes (PO capture)

**What behavior would satisfy the stakeholder:**

- A net-new outward-facing repository (working name: `shopsystem-docs`)
  exists, separate from this product's internal repositories, that an
  adopter encounters first. Its content takes an adopter who has *no*
  prior checkout and walks them to a running lead shop + the BCs they
  want, configured for *their own* product (not the shopsystem product
  this repo represents).
- The path of least resistance for an adopter is: pull and launch one
  container; the container, on first run, bootstraps the rest of the
  system on the adopter's behalf. The adopter does not hand-clone the
  lead shop and each BC repo, hand-run the per-shop bootstrap CLI,
  hand-run `bd init`, hand-launch Postgres, and hand-launch each BC
  container. Some of those steps can — and per the stakeholder
  *should* — be automated behind a single "launch this container"
  affordance.
- Where automation is not yet possible, the documentation enumerates the
  manual steps explicitly enough that an agent (Claude Code, equivalent)
  can execute them on the adopter's behalf when handed the doc as input.
  The doc is the same artifact; the audience flexes between human and
  agent based on how the adopter chooses to consume it.
- The documentation covers GitHub repo creation / org setup as part of
  the surface — the adopter is creating their own product, with their
  own GitHub org and repos, not cloning into `dstengle/`.
- "Running entirely in containers" is taken seriously: the adopter does
  not install Python, `bd`, `gh`, `shop-templates`, `shop-msg`,
  `bc-container`, or any other framework tool on their host, and does
  not create a host-side or container-local `.venv`. The host needs
  Docker. Every framework tool is delivered on the container PATH inside
  the images the adopter pulls.

**What would NOT satisfy the stakeholder:**

- A README-level walkthrough that lives inside this product's existing
  repositories (the lead shop, or any internal BC such as the templates
  BC). Stakeholder explicitly said *new repo*. The outward-facing
  audience is not served by docs that live alongside internal artifacts.
- A doc that reproduces this product's INSTALL.md (which targets an
  internal contributor adding a BC to *this* product). The audience of
  brief 007 is an adopter creating *their own* product. Different
  audience, different scope.
- A doc that assumes the adopter has already cloned anything. The first
  step is "you have Docker; you ran one command." Anything before that
  is friction the brief commits to eliminating where the framework
  supports it and surfacing as a manual step where it doesn't yet.
- A doc that requires the adopter to read the spec (§1–§6), the ADRs,
  or the PDRs to bootstrap. Those are reference material for internal
  contributors. The adoption doc treats the framework as a product the
  adopter consumes, not a system they extend.
- Two parallel docs ("human guide" + "agent guide") with the same
  content phrased twice. The stakeholder's framing — confirmed by the
  resolved Q1 — is layering, not duplication: one doc, single voice,
  with enough structure that an agent can mechanically execute the
  steps while a human reads it as a normal guide.

**Boundaries the PO commits to:**

1. **Doc home: net-new repository, a new BC under the shopsystem
   product.** Working name `shopsystem-docs`. Per resolved Q4, this
   is a sibling of `shopsystem-messaging`, `shopsystem-templates`,
   etc., with its own `bc-implementer` / `bc-reviewer` cycle. NOT
   inside this product's lead-shop repo, NOT inside any existing
   internal BC.
2. **Audience: end-user adopter creating a new product.** Not an
   internal contributor extending the shopsystem product itself. Not a
   BC implementer working a dispatched scenario.
3. **The doc covers the full adoption surface the stakeholder named:**
   GitHub repo / org setup; container launch; minimum-friction
   bootstrap UX. v1 documents the manual composition (per resolved
   Q3); brief 008 has been sliced (slice 1: lead-only bring-up;
   slice 2+: BC bring-up), and the doc updates incrementally to
   describe each delivered slice as it lands.
4. **Layering, not duplication.** One doc, single voice, structured
   so that an agent can mechanically execute its setup steps (per
   resolved Q1). No two-audience branching; no parallel docs.
5. **"Bootstrap done" means lead-shop container + per-BC containers
   running.** Per the resolved Q2 (see "Resolved decisions" below): the
   adopter's product is fully composed — the lead-shop container is up,
   and one container per BC in the adopter's manifest is up, all
   registered, ready to dispatch. The capability that delivers this end
   state is sibling brief 008's responsibility, now sliced: slice 1
   delivers lead-shop-container-up (and is the empirical prove-out for
   Q7's launcher gap); slice 2+ delivers BC bring-up. The v1 doc
   describes this end state as the adopter target throughout, reached
   via whichever combination of manual composition and slice-delivered
   capabilities exists at doc-authoring time.
6. **One doc, single voice, structured for agent consumption.** Per the
   resolved Q1: headings, command blocks, and verification steps are
   formatted so an agent can extract and execute them; a human reads it
   as a normal guide. No two-audience branching, no parallel docs.
7. **`shopsystem-docs` is a new BC under the shopsystem product.** Per
   the resolved Q4: it follows standard BC mechanisms
   (`bc-implementer` / `bc-reviewer` cycle, scenarios authored and
   worked the way every other BC's work is authored and worked). The
   lead shop dispatches `assign_scenarios` to it for doc work.
8. **Manual composition in v1; orchestrator is sibling brief 008
   (sliced).** Per the resolved Q3: brief 007's doc walks the adopter
   through the current manual composition (postgres compose,
   `shop-templates bootstrap`, per-BC `bc-container launch`, manual `gh
   repo create`). Brief 008's orchestrator capability is now sliced —
   slice 1 delivers lead-shop bring-up only (using docker compose +
   existing primitives); slice 2+ adds BC bring-up. Brief 007 remains
   the doc track only; the v1 doc updates incrementally as each slice
   lands. For the lead-launch step specifically, the v1 doc is also
   shaped by Q7 (the launcher-gap finding) — see Q7 below; the doc
   notes the gap honestly until it closes.
9. **No `repos/` convention for the adopter.** Per the resolved Q5: the
   adopter's BC repositories are checked out fresh per container
   instance (cloned inside the orchestrator-launched container per
   `bc-container launch`'s existing `--repo-url` pattern). The doc
   does NOT prescribe a shared host-side parent directory for BC
   clones. The host-side working directory the adopter mounts is for
   lead-shop + adopter-specific state, not for BC clones.
10. **v1 publishing format: plain markdown files in the docs BC
    repository — no documentation site.** The first implementation of
    `shopsystem-docs` ships plain `.md` files committed to the BC's
    repo; the adopter reads them directly (e.g., GitHub's rendered
    markdown view in the browser, or the raw markdown in their
    editor). v1 does NOT ship a MkDocs/Docusaurus/static-site-
    generator build, does NOT ship GitHub Pages or any other hosted
    rendered HTML, and does NOT ship a custom rendering pipeline.
    This is a v1-specific narrowing — a future iteration may introduce
    a documentation site — but the first implementation commits to
    the simplest possible publishing surface so that the doc content
    itself is the only thing the docs BC has to get right.

**Resolved decisions (this session), one design exploration, and one
launcher-gap finding:**

- Q1–Q5 were closed by the stakeholder in session 2026-05-22; see the
  "Resolved decisions" section below for each answer and how it flowed
  into the boundaries above.
- One design exploration — Q6, "scenarios-as-source-of-truth for
  docs" — was surfaced by the stakeholder in the same turn. It is NOT
  resolved here; it is parked for the Architect (and possibly a new
  PDR) after the docs BC's first scenarios are concrete enough to
  evaluate what export to documentation would actually require.
- One launcher-gap finding — Q7, "no host-side primitive launches a
  lead shop into a container today" — was surfaced by the stakeholder
  after the initial round of resolutions. The v1 doc cannot honestly
  walk the adopter through "launch the lead container" because no such
  command exists today; `bc-container launch` is BC-only. Q7 is paired
  with brief 008 slice 1 as its empirical prove-out vehicle; resolution
  is open and routed to the Architect (likely PDR-shaped).

---

## Point of intent

The shopsystem framework today has internal documentation that serves
internal contributors: `INSTALL.md` walks through adding a BC to the
existing `shopsystem-product`; `README.md` describes that product's
outward face; the spec files (§1–§6), ADRs, and PDRs explain the
framework's rationale. None of those is an adoption surface for a
downstream user who wants to use the framework to build their *own*
product.

The cost is closed-set adoption. The framework cannot be evaluated,
piloted, or used by anyone who does not already have insider context.
Stakeholder intent commits the framework to having an outward face: a
doc surface that takes a Docker-equipped user from zero to a running
product (their own, not shopsystem-product) with minimum friction.

The brief commits two things together because they are inseparable:

1. **A new doc home — a new BC under the shopsystem product** named
   `shopsystem-docs` (working name; final name is the docs BC's
   authoring concern). Per resolved Q4, the docs BC follows standard
   shopsystem BC mechanisms; the lead shop dispatches
   `assign_scenarios` to it for all doc work.
2. **The adopter-facing bootstrap UX the docs describe** — concretely,
   *what* the docs walk the adopter through. v1 documents the
   per-piece manual composition (postgres compose, `shop-templates
   bootstrap`, per-BC `bc-container launch`, manual `gh repo
   create`). Sibling brief 008 has been sliced — slice 1 commits the
   lead-only prove-out (lead-shop container brought up via docker
   compose + existing primitives); slice 2+ will add BC bring-up. As
   each slice lands, the doc updates incrementally to describe the
   delivered capability instead of the manual step it replaces.

The brief does NOT commit the docs BC's internal toolchain (build
pipeline, static-site generator, scenario-to-docs export shape — the
last being Q6), the exact text of the doc, or the orchestrator's CLI
shape (that is brief 008's scope). Those are downstream of the brief.

---

## Behavioral commitments (what changes after this lands)

After the doc and the supporting bootstrap UX exist, an adopter can do
the following that they cannot do today:

1. **Land on a single outward-facing page** (the `shopsystem-docs` repo's
   README or a designated entry doc) that names what the framework
   *is*, what they need (Docker, a GitHub account), and the next step
   to take. The current outward face — `shopsystem-product`'s README —
   describes *this* product, not the framework as a thing to adopt.
2. **Create their own product's repository set** — lead shop repo, the
   BCs they need, the beads companion repos — following an explicit,
   non-tribal procedure. v1 of the doc walks the adopter through this
   as a `gh repo create` sequence (per resolved Q3); brief 008's
   orchestrator may collapse some of these into one composed step.
   Either way, the adopter does not need to read the lead-shop
   INSTALL.md and reverse-engineer the BC version.
3. **Walk through the current manual composition transparently —
   including any honest gaps.** Brief 007 v1 documents the per-piece
   composition the framework supports today: launch postgres (via
   `docker compose up` from `shopsystem-devcontainer`), launch each BC
   container (`bc-container launch <bc> --repo-url ...`), and create
   the adopter's GitHub repos (`gh repo create`). For the lead-shop
   step specifically, the v1 doc is shaped by Q7 (the launcher gap):
   `shop-templates bootstrap --shop-type lead` exists today only as an
   *in-container* primitive, and no host-side command launches the
   lead container that runs it. Until Q7 resolves and brief 008 slice 1
   lands, the v1 doc names this gap explicitly rather than papering
   over it. As brief 008's slices land (slice 1: lead-only bring-up;
   slice 2+: BC bring-up), the doc updates incrementally to describe
   each delivered capability instead of the manual step it replaces.
4. **Hand the doc to a coding agent and have the agent execute the
   setup**, in the case where the adopter wants agent assistance. The
   doc's structure supports this: instructions are concrete enough
   (specific commands, specific arguments, specific verification steps)
   that an agent can run them without inferring intent.
5. **End in a state they can immediately use.** "Use" is committed
   (per resolved Q2): the adopter has a lead-shop container running
   plus one container per BC declared in their manifest, all
   registered, ready for the adopter to open a Claude Code session
   against the lead shop and dispatch their first `assign_scenarios`
   to one of their BCs. Sibling brief 008 is now sliced — slice 1
   delivers the lead-shop-container-up half of this end state; slice
   2+ delivers BC bring-up. Brief 007's doc describes the same end
   state throughout, reached via whichever combination of manual
   composition and slice-delivered capabilities exists at
   doc-authoring time.

---

## Resolved decisions

Q1–Q5 were closed by the stakeholder in session 2026-05-22; each
resolution and its rationale is recorded below, with a pointer to where
the decision was folded into the brief's commitments. Q6 is a new
design exploration the stakeholder raised in the same turn; it is
surfaced explicitly so the Architect can resolve it (likely via a PDR
or ADR) once the docs BC's first scenarios are authored and the export
shape becomes concrete enough to evaluate.

### Q1 — Target persona — RESOLVED: option (a)

**Decision:** Single doc, single voice, structured for agent
consumption. Headings, command blocks, and verification steps are
formatted so an agent can extract and execute them; a human reads it
as a normal guide.

**Rationale:** The stakeholder ruled directly. The PO's prior
"pilot-then-commit" caveat is withdrawn — this is the commitment.
There is no two-audience branching, no parallel docs, no per-step
"if human do X; if agent do Y" forks.

**Folded into:** PO boundary 6 ("One doc, single voice…"); behavioral
commitment 4 (handing the doc to an agent is supported by the doc's
structure, not by a separate doc).

### Q2 — "Bootstrap done" end state — RESOLVED: option (ii), with text edit

**Decision:** The adopter's "bootstrap done" end state is the lead-shop
container running plus per-BC containers running — one container per BC
declared in the adopter's manifest. All BCs are registered with the
messaging registry. The adopter can immediately dispatch work from a
Claude Code session against the lead shop.

**Rationale:** The stakeholder confirmed the PO's lean (ii). The
stakeholder additionally edited the original option text to remove
framework-internal language: the parenthetical "— at minimum the BC
that provides the messaging capability, since without it `shop-msg`
is non-functional;" was carved out because that explanation refers to
the underlying framework system, not to anything the adopter needs to
know. In adopter-facing language the end state reads:

> Lead-shop container + per-BC containers (one for each BC in the
> adopter's product, as the adopter's manifest declares), all
> registered, adopter can dispatch.

**Folded into:** PO boundary 5 (`"Bootstrap done"…`); behavioral
commitment 5 (the end state the doc names). The brief no longer
acknowledges (i) or (iii) as live options.

### Q3 — Empirical pre-state on container-launching-container — RESOLVED: separate scope (sibling brief 008)

**Decision:** Brief 007 documents the current manual composition in v1.
The single-container orchestrator that collapses postgres launch +
lead-shop scaffold + per-BC `bc-container launch` into one `docker run`
is sibling brief 008's capability scope. Brief 007 commits this without
hedging — it is the doc track, not the capability track.

**Rationale:** The stakeholder confirmed the PO's lean. The scope split
between the two briefs is intentional: brief 007 is what an adopter
reads; brief 008 is what an adopter runs. When brief 008 lands, brief
007's doc updates to describe the orchestrator; until then, the doc
walks the adopter through the per-piece composition transparently.

**Folded into:** PO boundary 8 ("Manual composition in v1…");
behavioral commitment 3 (the doc walks through the current manual
composition). The empirical pre-state observations the PO captured in
this session remain in the "Empirical pre-state" section below, because
they are the substrate the doc describes for v1.

**Subsequent narrowing of brief 008 (same session, recorded for
cross-brief coherence):** brief 008 was subsequently rewritten in the
same session to commit only **slice 1** (lead-only bring-up via docker
compose + existing primitives). The "single-container orchestrator
that collapses postgres + lead-shop + per-BC launches into one
`docker run`" framing in the Q3 resolution describes brief 008's
*eventual aim* across slices, not what slice 1 commits. Brief 007's v1
doc therefore updates incrementally as each brief 008 slice lands;
this does not change the Q3 resolution's load-bearing decision (brief
007 is the doc track; brief 008 is the capability track), only the
shape of how brief 008's capability arrives.

### Q4 — Topology — RESOLVED: option (a)

**Decision:** `shopsystem-docs` becomes a new BC under the shopsystem
product. It follows standard BC mechanisms: scenarios are authored by
this lead shop's PO and dispatched via `assign_scenarios`; the BC has
its own `bc-implementer` / `bc-reviewer` cycle; work proceeds the same
way every other BC's work proceeds.

**Rationale:** The stakeholder ruled directly. The PO's non-binding
observation (docs are a product, products are produced by shops
working scenarios, therefore docs deserve a BC) is now load-bearing
rather than aspirational — the framework keeps its own discipline for
its outward face.

**Folded into:** PO boundary 7 ("`shopsystem-docs` is a new BC…");
vehicle hints (the recipient for `assign_scenarios` on doc content is
now named).

### Q5 — Adopter BC layout on host — RESOLVED: per-container-instance checkout

**Decision (stakeholder, verbatim):**

> "repos are checked out per container instance - the repos/ directory
> will go away in shopsystem once it is relaunched with the new
> framework."

**What this means for brief 007:** the adopter's BC repositories are
checked out fresh per container instance — i.e., cloned inside the
orchestrator-launched BC container by the existing `bc-container
launch <bc> --repo-url …` pattern. There is no shared host-side
parent directory for the adopter's BC clones; there is no `repos/`
convention, no `~/code/shopsystem-org/*`, no host-visible BC clone tree
at all. The host-side working directory the adopter mounts (per brief
008's framing) is for lead-shop + adopter-specific state, NOT for BC
clones.

**Rationale:** The current `repos/` sibling-clone convention is a
shopsystem-product-internal artifact of this product's history; it
does not belong in adopter-facing documentation, and the stakeholder
has additionally noted that shopsystem-product itself will move off
`repos/` when it is relaunched on the new framework. The adopter
gets the cleaner model directly; this product gets it on relaunch.

**Folded into:** PO boundary 9 ("No `repos/` convention for the
adopter…"); the "What this leaves open" section, which now flags the
shopsystem-product-itself `repos/` deprecation as forward context for
the Architect (not a brief 007 commitment).

**Cross-brief implication (now resolved by brief 008's narrowing):**
brief 008 was originally going to need a mount-semantics re-read for
Q5. With brief 008 now narrowed to slice 1 (lead-only bring-up), the
mount semantics naturally land where Q5 wants them — slice 1's
host-mounted working directory is for the lead-shop scaffold only,
and BC clones do not enter the picture until slice 2+. The Q5
implication for slice 2+ (BC clones happen inside per-container
instances, not in any host-mounted BC parent dir) will be a PO
boundary the slice 2+ brief commits explicitly.

### Q6 — Design exploration: scenarios-as-source-of-truth for docs

The stakeholder, in the same turn that resolved Q1–Q5, raised this
idea verbatim:

> "Here is an idea, can the features be written in a way that can be
> exported into the documentation?"

**PO-honest read of what this would commit (if accepted):** the docs
BC's Gherkin scenarios — the things the BC pins as behavior — would
themselves be the source from which the published documentation is
generated. An adopter-facing instruction like "to launch the lead
container, run `docker run …`" would be authored as Gherkin (Given /
When / Then), the scenario would be the BC's work artifact, and the
rendered documentation site would be generated from those scenarios
by a build step the docs BC owns.

**What this would commit:**

- The docs BC's scenarios become dual-purpose: they pin BC behavior
  (the framework's standard role for scenarios) AND they are the
  authoring surface for the published doc. The scenario body has to
  be readable as documentation prose AND testable as Gherkin.
- The docs BC owns a build step (markdown / static-site generator)
  that consumes its own scenarios and produces the published artifact.
- The scenarios' `Then` clauses become the doc's verification steps,
  which is well-aligned with the brief's "command blocks and
  verification steps formatted so an agent can extract and execute
  them" commitment (resolved Q1).

**What this would NOT commit:**

- It does not change Q4 — the docs BC remains the home; the export
  shape is internal to the BC.
- It does not change the scenario authoring contract — the PO still
  authors scenarios and the Architect still dispatches them. Whether
  the BC additionally builds a doc site from them is a recipient-BC
  concern.
- It does not affect any other BC's scenarios. Other BCs continue to
  pin behavior in Gherkin without doubling as documentation source.

**Framework-shape implications worth naming:** This idea has reach
beyond brief 007. If scenarios-as-doc-source proves workable for the
docs BC, the pattern is generalizable — other BCs' user-facing
behavior could be documented from their own scenarios. That is a
framework-level question that belongs in an ADR or PDR, not in this
brief. The brief surfaces the idea but does NOT pre-decide it.

**Who resolves:** Architect, after the docs BC's first scenarios are
authored and the export shape is concrete enough to evaluate. A PDR
is the appropriate vehicle if the design is non-obvious; an ADR if
the cross-BC implications need to be pinned. The PO does not
pre-commit; this is the stakeholder's framing as an idea and it should
be resolved on real authored scenarios, not on speculation.

**Scope note (added 2026-05-22 after boundary 10 was committed):** with
v1 publishing as plain markdown only, Q6's evaluation surface in v1 is
just "scenarios → markdown files," not "scenarios → rendered website."
The static-site-generator half of the "what this would commit"
bulleting above belongs to a future iteration that introduces a doc
site, not to the v1 scope this brief covers. Q6's design question
itself is unchanged.

### Q7 — Launcher gap: how is the lead shop launched into a container? — OPEN

**Stakeholder framing (verbatim, same session):**

> "On 007, there may be a gap with assumptions about bc-launcher. A
> shop can be a BC or the lead, we need a tool that can launch either
> one since the tools to bootstrap the lead aren't available on the
> host."

**The gap, made concrete:** `bc-container launch`
([CLI](../repos/shopsystem-bc-launcher/src/bc_launcher/cli.py)) is the
framework's only per-container shop-launch primitive today, and it is
**BC-only**. There is no host-side command (no `lead-launcher`, no
`shop-launcher`, no `bc-container launch --shop-type lead`) that, from
an adopter's clean host with only Docker installed, launches a
lead-shop container ready to bootstrap from inside. The v1 doc
(boundary 8: manual composition in v1) cannot honestly document a
"launch the lead container" step until a primitive that performs it
exists.

**Candidate resolution shapes (PO-honest read of the trade-off; NOT
pre-decided):**

- **(a) Extend `bc-launcher` to handle either shop type.** Add
  `--shop-type {bc,lead}` (and rename or alias the CLI accordingly —
  `bc-container` becomes the historical name; `shop-container` or
  similar becomes the symmetric one). One BC owns "launch a shop
  container regardless of shop type"; one tool / one mental model on
  the host. Risk: collapsing two shop-type lifecycles into one CLI
  surface may surface contract differences (lead has no `--repo-url`
  in the same sense; lead's first-run scaffold is `shop-templates
  bootstrap --shop-type lead`, not a repo clone) that pollute the
  CLI's shape.
- **(b) Introduce a new `lead-launcher` BC.** Separate tool, separate
  BC, parallel to `bc-launcher`. Clean separation of concerns: each BC
  owns one shop type's host-side launch primitive. Risk: two tools to
  document, two BCs to maintain, more overhead — same trade-off
  ADR-004 / PDR-004 navigated for `shopsystem-bc-launcher` originally.
- **(c) Compose-only.** Slice 1 of brief 008 may prove that a docker
  compose file alone is sufficient as the adopter's "launch the lead
  container" surface, with no new framework CLI needed at all. If
  slice 1's evidence supports this, the gap closes by the doc
  pointing at a `docker compose up` against a framework-shipped
  compose file. Risk: pure compose may not be expressive enough for
  the lead-shop bootstrap shape (mounts, first-run idempotency,
  passing through credentials) the slice 1 author will discover.

**Empirical pairing with brief 008 slice 1.** Brief 008 has been
narrowed (in this same session) to a single slice: prove out launching
and bootstrapping the lead in a container, using primitives that
already exist (docker compose + the existing postgres service +
`shop-templates bootstrap --shop-type lead`). Slice 1's deliverable
explicitly includes an honest finding about whether a new host-side
primitive was required to invoke the lead-shop container's launch —
the answer to Q7 is informed materially by slice 1's evidence. **Q7
does NOT gate brief 007's dispatch**; it shapes how the v1 doc's
"launch the lead container" step is eventually written.

**What the v1 doc does in the meantime:** until Q7 resolves and slice 1
lands, the v1 doc's "launch the lead container" section is written as
an honest manual step — including, if needed, an explicit note that
the adopter currently has to perform the lead-launch by hand because
the framework does not yet ship a primitive for it. The doc does NOT
paper over the gap.

**Who resolves:** Architect, likely PDR-shaped given the BC
decomposition question ((a) vs (b) vs (c) is a "which BC owns this
capability" decision), after brief 008 slice 1's evidence is in. The
PO surfaces the gap and the candidate shapes; the PO does not
pre-decide.

**Folded into:** empirical pre-state finding 5 (the gap is named as a
substrate observation); behavioral commitment 3 (the v1 doc walks
through the current substrate honestly, including the gap if it is
still open at doc-authoring time); "What this leaves open" (Q7 is
listed as a follow-up paired with brief 008 slice 1).

---

## Empirical pre-state (carried over from session 2026-05-22)

These observations were captured by the PO in the same session that
resolved Q1–Q5. They are the substrate the v1 doc describes (per
resolved Q3) and the dispatch input the Architect verifies against
when assigning scenarios to the docs BC. They are NOT open questions.

1. **Docker-out-of-docker is mechanically available** in the
   shopsystem-product devcontainer today. `docker --version` runs;
   `/var/run/docker.sock` is bind-mounted from the host; `docker ps`
   lists host-running containers (including
   `shopsystem-messaging-postgres-1`, the lead-shop's
   `vsc-shopsystem-product-*`, etc.). The mount comes from
   [`.devcontainer/devcontainer.json`](../.devcontainer/devcontainer.json)'s
   default devcontainer behavior plus the explicit
   `--network=shopsystem` runArg. So the substrate for a
   container-launching-container flow exists — this is the substrate
   sibling brief 008's orchestrator builds on.
2. **`shop-templates bootstrap`** ([CLI source](../repos/shopsystem-templates/src/shop_templates/cli.py))
   today takes a `--shop-type {bc,lead}` argument and pours a
   canonical scaffold (agents, CLAUDE.md, .claude/, .gitignore,
   .beads/) into a target directory. For adopter purposes, this is
   per-shop, in-place scaffolding. It does not clone the adopter's BC
   repos, create GitHub repos, launch postgres, or launch BC
   containers. Composition over multiple shops is the adopter's (or
   the orchestrator's) responsibility today.
3. **`bc-container launch <bc>`** ([CLI](../repos/shopsystem-bc-launcher/src/bc_launcher/cli.py))
   exists today and is one-BC-at-a-time. It takes `--repo-url`,
   `--shopmsg-dsn`, `--network`, `--startup-prompt`. It launches a
   single BC container, **clones the repo inside that container** (the
   primitive that realizes resolved Q5's per-container-instance
   checkout model), initializes beads, starts tmux. It does NOT launch
   multiple BCs, does NOT launch postgres, does NOT bootstrap the lead
   shop.
4. **Postgres** is run today from
   [`repos/shopsystem-devcontainer/docker-compose.yml`](../repos/shopsystem-devcontainer/docker-compose.yml)
   as a separate manual step (`docker compose up -d postgres`) outside
   any of the framework CLIs. The doc walks the adopter through this
   step explicitly in v1.
5. **Launcher-gap finding — no host-side primitive launches a lead
   shop into a container today.** `bc-container launch`
   ([CLI](../repos/shopsystem-bc-launcher/src/bc_launcher/cli.py)) is
   the only per-container shop-launch primitive the framework ships,
   and it is **BC-only**: its single positional argument is `bc_name`,
   its required input is `--repo-url` for the BC's repository, and the
   `bc-container manifest` subcommands assume the launched shop is a BC.
   There is no `--shop-type` flag, no `--shop-type lead` mode, and no
   sibling `lead-launcher` CLI. The asymmetry the stakeholder named is
   real: a shop in the framework can be a BC or a lead, but the tools
   to bootstrap a lead into a container are not available on the
   adopter's host today — they live inside container environments. The
   v1 doc cannot honestly walk an adopter through "launch the lead
   container" until this gap closes. Q7 below tracks the resolution
   options; brief 008 slice 1 is the empirical prove-out vehicle.

The pieces the v1 doc walks the adopter through are:

- Postgres launch (currently `docker compose up` in
  `shopsystem-devcontainer`).
- Lead-shop **launch and** scaffolding (currently a gap on the host —
  see Q7. `shop-templates bootstrap --shop-type lead` is the in-
  container scaffold primitive, but no host-side primitive launches
  the lead container that would run it. The v1 doc surfaces this
  honestly until brief 008 slice 1 closes the gap).
- Per-BC container launch (currently `bc-container launch <bc>` per
  BC; each container clones the BC repo into itself).
- Repo creation on the adopter's GitHub org (currently manual `gh
  repo create`).

As sibling brief 008's slices land (slice 1: lead-shop bring-up via
docker compose; slice 2+: BC bring-up), the doc updates incrementally
to describe each delivered capability and drops the corresponding
manual step.

---

## Vehicle hints (Architect's call)

For pre-state verification, not as a prejudgment:

- **Doc home creation (the `shopsystem-docs` repo itself).** Net-new
  repository under the shopsystem product (per resolved Q4). The work
  is `gh repo create` for the docs BC's repo, the standard
  shopsystem-templates bootstrap for a new BC (`shop-templates
  bootstrap --shop-type bc --shop-name shopsystem-docs`), and the
  customary new-BC plumbing (devcontainer, beads remote, manifest
  entry per brief 005). Vehicle: net-new BC creation precedes scenario
  dispatch — same pattern ADR-004 established for `shopsystem-bc-launcher`.
  An ADR documenting the docs-BC introduction is the Architect's call.
- **Initial doc content (the adoption walkthrough).** Net-new authoring,
  dispatched to the new `shopsystem-docs` BC via `assign_scenarios`.
  Resolved Q1 (single voice, agent-consumable) and resolved Q2
  (lead+chosen-BCs end state) shape the scenarios' Then clauses;
  resolved Q3 (manual composition in v1) shapes the When clauses.
- **Manifest-driven adopter clone pattern in the doc.** Resolved Q5
  pins that BC repos are cloned inside their per-container instances
  by `bc-container launch <bc> --repo-url …`. The doc describes this
  shape directly; no `repos/` directory, no shared host parent for BC
  clones. Whether the doc references a starter `bc-manifest.yaml` the
  adopter customizes — and where that starter ships — may surface
  during scenario authoring as a clarify; the Architect cross-checks
  against brief 005.
- **Q6 (scenarios-as-doc-source) is NOT a brief 007 dispatch.** It is
  a follow-up design decision the Architect resolves after the docs
  BC's first scenarios are concrete enough to evaluate. If the design
  is accepted, the scenarios authored under brief 007 may be the
  first ones whose Gherkin bodies are written with future export in
  mind, but the brief does not commit that ex ante.
- **Q7 (launcher gap) is NOT a brief 007 dispatch either.** It is a
  framework-level decomposition decision the Architect resolves
  (likely PDR-shaped) after brief 008 slice 1 produces empirical
  evidence on whether a new host-side primitive was required. The
  three candidate shapes — (a) extend `bc-launcher` with
  `--shop-type`, (b) new `lead-launcher` BC, (c) compose-only — are
  surfaced under the Q7 entry above. Brief 007's doc-content
  scenarios may need a clarify back to PO once Q7 lands so the
  "launch the lead container" step's prose matches the delivered
  shape.

---

## Sequencing

- **Q1–Q5 are closed.** All five questions that previously gated
  dispatch were resolved by the stakeholder in this session; the
  brief is ready for the Architect's discriminator pass.
- **Q6 (scenarios-as-doc-source) does NOT gate this brief.** It is a
  follow-up design exploration the Architect resolves after the docs
  BC's first scenarios are concrete. Brief 007's dispatch proceeds
  without waiting on Q6.
- **Q7 (launcher gap) does NOT gate this brief either.** Q7 shapes
  how the v1 doc's "launch the lead container" step is eventually
  written, but the doc is honest about the gap in the interim, and
  brief 008 slice 1 is the empirical prove-out vehicle. Brief 007's
  dispatch proceeds without waiting on Q7.
- **Within scope items**: docs BC creation (ADR + `gh repo create` +
  shop-templates bootstrap + manifest entry) precedes scenario
  dispatch to the docs BC. Doc content scenarios are then dispatched
  via `assign_scenarios` to the new docs BC.
- **Brief 008 is a sibling, not a dependency, and is now sliced.**
  Brief 007's v1 doc describes the manual composition (resolved Q3);
  as brief 008's slices land (slice 1 first: lead-only bring-up;
  slice 2+ later: BC bring-up), the doc updates incrementally to
  describe each delivered capability. Either brief can land first;
  brief 007's v1 doc remains honest about the current substrate at
  doc-authoring time.
- **This brief does NOT block on briefs 003–006.** Those briefs
  improve the framework's substrate (event-driven activation, BC
  container isolation, BC manifest, name registry); the adoption doc
  describes what's there at doc-authoring time. If those briefs land
  first, the doc describes a smoother substrate; if not, the doc
  describes the current substrate honestly.

---

## Out of scope — named explicitly

**Authoring this brief does NOT commit:**

- **The doc's title, voice details, or section structure.** Those are
  authoring choices the docs BC makes after the brief lands.
- **The orchestrator's CLI shape.** That is sibling brief 008's scope,
  not brief 007's. Brief 007's v1 doc describes the manual composition
  (resolved Q3); the orchestrator's surface is committed elsewhere.
- **The docs BC's internal toolchain.** Build pipeline, static-site
  generator, scenario-to-docs export shape (Q6) — all recipient-BC
  concerns. Brief 007 commits the BC's existence and the doc's
  audience / end state, not how the BC produces the published artifact.
- **A documentation site for v1 — deferred to a future iteration.**
  Per boundary 10, v1 publishes plain markdown files committed to the
  `shopsystem-docs` repo and nothing more. Documentation-site tooling
  (MkDocs, Docusaurus, GitHub Pages or any other rendered HTML
  hosting, static-site generators of any flavor, custom rendering
  pipelines) is explicitly out of v1 scope. This is a v1-specific
  narrowing, not a permanent exclusion — a future iteration may
  introduce a doc site once the markdown content has proven its shape
  and the docs BC has a concrete reason to render it. Until that
  future iteration is briefed and authored, the docs BC does not own
  a site build.
- **Whether the doc covers Windows / macOS / Linux symmetrically.**
  The framework today is Linux-container-centric; the adopter is
  assumed to have Docker. Cross-OS specificity is the docs BC's
  authoring concern, surfaced to the PO if a real adopter question
  arises.
- **Examples or tutorials beyond the bootstrap walkthrough.** Brief 007
  scopes "how do I adopt this framework"; broader "how do I use the
  framework once adopted" is a follow-on.
- **Marketing positioning or framework-vs-alternatives content.** The
  doc is operational, not promotional.
- **Migration docs for users on a predecessor system** (e.g.,
  `ddd-product-system` consumers). Different audience, follow-on brief
  if it surfaces.
- **Translating the spec (§1–§6), ADRs, or PDRs into adopter-facing
  prose.** Reference material remains reference material. The
  adoption doc *may* link to it; it does not reproduce it.

---

## Grounding artifacts

- [`INSTALL.md`](../INSTALL.md) — the existing internal-contributor
  walkthrough for adding a BC; tone / resolution baseline for the
  adoption doc, but explicitly NOT its model (different audience).
- [`README.md`](../README.md) — this product's outward face; describes
  this product, not the framework as a thing to adopt.
- [`repos/shopsystem-templates/src/shop_templates/cli.py`](../repos/shopsystem-templates/src/shop_templates/cli.py)
  — current `shop-templates bootstrap` surface; pre-state for any
  orchestrator extension.
- [`repos/shopsystem-bc-launcher/src/bc_launcher/cli.py`](../repos/shopsystem-bc-launcher/src/bc_launcher/cli.py)
  — current `bc-container` surface; pre-state for multi-BC launch.
- [`repos/shopsystem-devcontainer/docker-compose.yml`](../repos/shopsystem-devcontainer/docker-compose.yml)
  — current postgres launch path; pre-state for whether postgres
  becomes part of the orchestrator or stays adopter-managed.
- [`.devcontainer/devcontainer.json`](../.devcontainer/devcontainer.json)
  — current devcontainer config; demonstrates the docker-socket
  mount + `--network=shopsystem` runArg pattern the
  container-launching-container path inherits.
- [`briefs/002-shop-bootstrap-cli-surface.md`](002-shop-bootstrap-cli-surface.md)
  — prior brief on the per-shop bootstrap surface; the orchestrator
  question in brief 007 is a level above this.
- [`briefs/004-bc-container-isolation.md`](004-bc-container-isolation.md)
  — established `bc-container launch` as the per-BC primitive.
- [`briefs/005-bc-manifest.md`](005-bc-manifest.md) — BC manifest
  introduction; relevant if the orchestrator reads a manifest to
  decide which BCs to launch.
- [`briefs/008-single-container-bootstrap-orchestrator.md`](008-single-container-bootstrap-orchestrator.md)
  — sibling brief, the capability track, **narrowed (2026-05-22) to
  slice 1: prove out launching and bootstrapping the lead in a
  container, using existing primitives (docker compose, the existing
  postgres service, `shop-templates bootstrap --shop-type lead`).**
  Slice 1 is the empirical prove-out vehicle for brief 007's Q7
  (launcher gap). BC bring-up and the full lead+chosen-BCs end state
  are deferred to slice 2+, authored after slice 1's evidence is in.
  Brief 007's v1 doc continues to describe the manual composition for
  BCs until slice 2+ delivers that capability; the lead-launch step
  the v1 doc covers will reflect slice 1's findings once they land.
- [`adr/004-bc-launcher-as-new-bc.md`](../adr/004-bc-launcher-as-new-bc.md)
  — established the bc-launcher BC; the precedent the docs BC
  introduction follows per resolved Q4 (new BC under the shopsystem
  product, with the customary ADR).

---

## What this leaves open

Q1–Q5 are closed (see "Resolved decisions" above). What remains open
is genuinely downstream of those resolutions:

- **Q6 (scenarios-as-doc-source).** The stakeholder's new design idea
  for the docs BC: can the BC's Gherkin scenarios themselves be the
  source from which the published documentation site is generated?
  Architect-resolved (likely PDR or ADR) after the docs BC's first
  scenarios are concrete enough to evaluate. Surfaced explicitly so
  it is not lost; not a gate on brief 007's dispatch.
- **Q7 (launcher gap — how is the lead shop launched into a
  container?).** No host-side primitive launches a lead shop into a
  container today; `bc-container launch` is BC-only. Three candidate
  resolution shapes (extend `bc-launcher` with `--shop-type`, new
  `lead-launcher` BC, compose-only) are surfaced under the Q7 entry
  above. Architect-resolved (likely PDR-shaped). **Paired with brief
  008 slice 1 as the empirical prove-out vehicle** — slice 1's
  findings on whether a new host-side primitive was required will
  materially inform Q7's resolution. NOT a gate on brief 007's
  dispatch; shapes how the v1 doc's "launch the lead container" step
  is eventually written.
- **The docs BC's exact CLI surface and (post-v1) build pipeline.**
  Recipient-shop authoring concerns. Brief 007 commits the BC's
  existence, audience, and end state; the BC's internals are
  scenario-level. Note that for v1 the build pipeline is empty by
  commitment — boundary 10 pins plain markdown only, so there is no
  static-site toolchain to author in v1. A build pipeline becomes a
  live open question only when a future iteration introduces a
  documentation site.
- **The doc's title, voice details, section ordering, and example
  product.** Authoring choices the docs BC makes after the brief
  lands. Brief 007 commits the audience (adopter creating their own
  product) and the agent-consumable structure (resolved Q1), not the
  exact wording.
- **Whether the doc covers Windows / macOS / Linux symmetrically.**
  The framework today is Linux-container-centric; the adopter is
  assumed to have Docker. Cross-OS specificity is the docs BC's
  authoring concern, surfaced to the PO if a real adopter question
  arises.

**Forward context for the Architect (NOT a brief 007 commitment):**
the resolved Q5 carries a related framework-level observation worth
flagging. The `repos/` sibling-clone convention used by *this product*
is being deprecated; when shopsystem-product is relaunched on the new
framework, it will also adopt per-container-instance checkout. That is
stakeholder context for shopsystem-product's own future, not a brief
007 commitment — the Architect should be aware of it when any
shopsystem-product-internal layout change is being considered, but
brief 007 itself is only concerned with adopter-facing layout.

The PO commits intent (a new docs BC under the shopsystem product
authored against an adopter audience; the adoption surface the doc
covers; the lead+chosen-BCs end state; the manual composition in v1;
the per-container-instance BC clone model). The brief explicitly does
NOT commit the docs BC's internal toolchain, the exact wording of the
doc, or the resolution of Q6 — those are downstream.
