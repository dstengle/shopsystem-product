# Brief 003 — Event-driven shop activation

**Status:** draft (2026-05-13)
**Authors:** dstengle, Claude (lead-po)
**Beads:** [`lead-0h1`](#) (this brief)
**Anchored to:** user-driver observation 2026-05-12:
*"The biggest issue right now is coordinating work between multiple agents.
Extending shopsystem is somewhat slow without having things be more event
driven."* Empirically validated this session: an `inotifywait`-armed
Monitor watching the lead-shop's BC outboxes delivered sub-second
event-fire on `lead-79q` `work_done` arrival, reconciled without polling.

## Point of intent

Today, every shop — lead and BC — communicates via `shop-msg` mailboxes
on the filesystem, but **no shop is reactive to inbound messages**.
Reactivity is approximated by manual polling (`shop-msg pending`),
scheduled checks (`/loop`), or out-of-band human attention. The cost is
agent-coordination latency that scales with shop count and dispatch
cadence: a lead shop dispatching to four BCs and waiting on four
`work_done`s pays four manual-check round-trips per cycle, and a BC
implementer sitting on a fresh inbox message does not know it has work
until the human nudges it.

The brief commits the shop-system to **event-driven activation as a
shop's default posture**: every shop, on every session, arms a watcher
on its inbound mailbox surface so that arrival of a message wakes the
session immediately. The activation mechanism rides on top of the
filesystem realization that `shop-msg` currently uses, but it does not
break encapsulation — the event tells the agent *that something
happened*; reading *what happened* still goes through `shop-msg`.

The brief carries **two invariants**, **five scope items** (three core,
two adjacent), and an **explicit out-of-scope boundary**.

## The two invariants

### Invariant 1 — Every shop is reactive on session start

No shop should require polling to discover inbound messages. Every
shop's session-start sequence arms a watcher on its inbound mailbox
surface so that filesystem-level arrival of an inbound message produces
an in-session notification to the active agent. The watcher is armed
**before the agent does any other work**, so the reactive posture holds
across the entire session — not just after a manual check.

The watcher's watch target is **shop-type-specific**:

- **BC shop** watches its own `inbox/` (where the lead drops inbound
  messages targeted at this BC).
- **Lead shop** watches `repos/*/outbox/` (where every BC drops its
  outbound responses; the lead-shop's reconciliation work fires when
  any BC posts `work_done`, `clarify`, or a `mechanism_observation`).

The mechanism — what filesystem-event subsystem, what tool, what
pipeline shape — is **realization detail the Architect commits to in
scenarios**. The empirical work that grounds this brief used
`stdbuf -oL inotifywait -m -e create,moved_to ...` piped into a
buffer-line-aware filter. The validated shape is reproduced under scope
item B as the reference realization; deviation is allowed, but the
end-to-end property the invariant pins — sub-second event-fire when an
inbound message lands — must hold.

### Invariant 2 — Activation honors brief 001's encapsulation

The activation mechanism fires a **wake signal**; it does not deliver
**content**. When the watcher fires, the agent learns "something arrived
in the watched directory." The agent then reads the actual message via
`shop-msg read inbox <work_id>` (BC side) or `shop-msg read outbox
<work_id> --bc <name>` (lead side) — the same surface every other
consumer uses, per
[brief 001 invariant 1](001-inter-shop-messaging-encapsulation.md).

The watch path the activation mechanism uses (e.g., `inbox/`,
`repos/*/outbox/`) is **incidentally** the filesystem realization
`shop-msg` happens to use today. That is acceptable for the activation
mechanism because it operates **below** the messaging layer — it is a
process-wake signal, not a consumer-of-messages. The watcher does not
parse YAML, does not extract `message_type`, does not act on the
content of the file it sees touched; it only signals "wake up."

**Corollary — activation adapts when the transport changes.** When
`shop-msg`'s storage shifts (filesystem → SQLite → daemon → queue), the
activation mechanism's realization shifts with it. A future
`shop-msg watch` subcommand is the natural place to land that
abstraction; this brief does not commit to it, but the invariant
**permits and anticipates** it. The brief's scope is: **make every shop
reactive on the current transport, in a shape that can evolve when the
transport evolves**.

## Three core scope items

### A — Canonical `.claude/settings.json` template per shop type

Two new package-data files ship via `shopsystem-templates`, parallel to
the role-prompt templates already in
`shop_templates.templates/`:

- A **lead-shop variant** carrying a `SessionStart` hook that arms a
  Monitor watching `repos/*/outbox/`.
- A **BC-shop variant** carrying a `SessionStart` hook that arms a
  Monitor watching the shop's own `inbox/`.

Each variant is canonical (PO-authored, framework-property), versioned
alongside the role templates, and **delivered to consumers exclusively
through the `shop-templates` CLI** — same encapsulation discipline
brief 002 invariant applies to the inline `.claude/agents/*.md` copies.
No shop hand-edits its `.claude/settings.json` to install the
activation hook; the canonical template is the source of truth.

The two variants share the same JSON shape (so that the substitution /
update mechanics in brief 002 scope item C apply uniformly) and differ
only in the hook content their `SessionStart` carries. The shape choice
— `command`-type hook running a script, `prompt`-type hook executing
arm-Monitor instructions, or another shape Claude Code's hook API
supports — is **the Architect's call** during pre-state on Claude
Code's hook surface. The brief commits **what** the hook arms; it does
not commit **how** the hook is expressed in `settings.json`.

The current lead-shop `.claude/settings.json` (this repo) already
carries a `SessionStart` `bd prime` hook. The canonical lead-shop
variant **composes** these — the existing `bd prime` hook (operational
hygiene) remains; the new activation hook is added alongside it. The
two-hook composition is the canonical shape, not a one-or-the-other
cut.

### B — SessionStart hook content (reference realization)

The hook's payload arms a Claude Code `Monitor` on a pipeline of the
shape validated in this session. The empirical-validated reference
realization is named here so the Architect has a concrete target to
codify in scenarios, but the Architect may deviate if pre-state on
Claude Code's Monitor surface or `inotify-tools` packaging reveals a
better shape.

**Reference pipeline (lead side):**

```
stdbuf -oL inotifywait -m -e create,moved_to --format '%w%f' repos/*/outbox/ 2>&1 \
  | stdbuf -oL /usr/bin/grep -E '\.yaml$|inotifywait:'
```

**Reference pipeline (BC side):**

```
stdbuf -oL inotifywait -m -e create,moved_to --format '%w%f' inbox/ 2>&1 \
  | stdbuf -oL /usr/bin/grep -E '\.yaml$|inotifywait:'
```

Four properties this shape carries that the Architect must preserve
(deviation in form, not in property):

1. **Line-buffered output.** `stdbuf -oL` on every pipeline stage
   forces `setvbuf` to line-buffering mode via `LD_PRELOAD`. Without
   it, libc default behavior block-buffers stdout when piped (not a
   TTY); single low-volume events sit in a ~4KB buffer and never
   reach the Monitor harness. The Architect MUST commit a
   stage-by-stage line-buffering guarantee, however realized.
2. **Alias bypass for `grep`.** The lead-shop's shell snapshot
   aliases `grep` to `ugrep -G --ignore-files ...`. `ugrep`'s
   `--line-buffered` flag does NOT flush reliably end-to-end in
   this harness; `/usr/bin/grep` does. Whatever filter the Architect
   commits to, it MUST bypass the shell alias and use a flushing
   implementation. Naming `/usr/bin/grep` explicitly is one valid
   shape; using a non-`grep` filter (e.g., `awk`) is another.
3. **Startup-chatter and error visibility.** `2>&1` merges
   `inotifywait`'s startup messages ("Setting up watches", "Watches
   established") and error output into stdout; the filter regex
   passes both message-arrival lines (`\.yaml$`) and `inotifywait:`
   diagnostic lines through so silent failures (no permission,
   `inotify-tools` not installed, watch-limit exhausted) surface as
   notifications rather than producing a black-hole watcher.
4. **Monitor-as-persistent-arming.** The `inotifywait -m` (monitor
   mode) is the right shape so the watcher persists for the session;
   the Monitor harness is configured `persistent: true` so the
   pipeline restarts on its own exit. The brief commits the
   property — arming is once-per-session, behavior is for-the-session
   — and lets the Architect name the parameter shape.

Watch directories are named **explicitly per shop type** in the
canonical hook content (the lead-side hook hardcodes `repos/*/outbox/`;
the BC-side hook hardcodes `inbox/`). The brief does NOT introduce
parametrisation of the watch path: a lead is a lead and a BC is a BC,
and their watch targets are framework property, not per-shop
customisation.

### C — Bootstrap writes `.claude/settings.json`

[Brief 002](002-shop-bootstrap-cli-surface.md) commits a CLI-driven
bootstrap surface for new shops. This brief **extends** that surface:
the generated surface produced by `shop-templates` bootstrap now
includes `.claude/settings.json`, per the shop-type variant defined in
scope item A.

Specifically:

- The **generated surface** under brief 002 scope item B gains one
  more entry: `.claude/settings.json` (per shop type). The file is
  laid down at init alongside `.claude/agents/*.md`, `CLAUDE.md`,
  `.beads/`, and `.gitignore`.
- The **update operation** under brief 002 scope item C re-pours
  `.claude/settings.json` from the current canonical variant when
  the canonical evolves. Same posture as `.claude/agents/*.md`: the
  file is **bootstrap-managed** (per brief 002 scope item D's
  managed-vs-shop-owned cut), not hand-edited and not init-only.
  Rationale: the activation hook is framework property — it enforces
  reactivity discipline the same way role prompts enforce role
  discipline. Letting a shop drift from canonical means the shop is
  silently no longer reactive, which is the failure mode this brief
  exists to prevent.
- A shop that wants to **extend** its `settings.json` with hooks
  beyond the canonical set faces the same constraint
  `.claude/agents/*.md` faces: the canonical content is replaceable;
  extensions live elsewhere. Whether "elsewhere" means an
  additional file, a project-local override, or something else is a
  Claude-Code-hook-surface question the Architect addresses in
  scenarios (or escalates if pre-state surfaces it as a PDR).

Treating `.claude/settings.json` as bootstrap-managed (not init-only,
unlike `CLAUDE.md`) is a **delta from brief 002 scope item D**'s
managed/init-only cut. The cut still applies — content that exists to
enforce framework discipline is managed; content that exists to express
per-shop intent is shop-owned — but `.claude/settings.json` falls on
the managed side. The activation hook IS framework discipline; nothing
about it expresses per-shop intent.

## Two adjacent scope items

### D — Prereqs naming

The activation mechanism depends on host-level packages: `inotify-tools`
(for `inotifywait`) and `coreutils` (for `stdbuf`, almost always
already present on Linux). The bootstrap surface **names these
prereqs** in the generated shop scaffold so a downstream operator
running into a missing tool has a documented expectation to point at.

Realization of the naming is **the Architect's call**: the prereqs may
live in a section of the generated `CLAUDE.md` (per brief 002 scope
item E's substitution surface), in a generated `PREREQS.md`, or as
inline comments in `.claude/settings.json` (if Claude Code's
settings.json schema permits comments — which is itself a pre-state
question). The brief commits that the prereqs are **named in the
generated surface**; the surface entry is the Architect's pick.

**Out of scope under D:** installing the prereqs. Bootstrap is a
shop-shape concern; installing host-level packages is host
infrastructure (devcontainer `postCreate`, Dockerfile, NixOS module,
or whatever the operator runs). The brief acknowledges devcontainer
postCreate exists as the natural install site but does NOT commit
this brief to writing it.

### E — Venv install drift mitigation

[`lead-xq0`](#) (P2) names the venv drift problem: the product venv's
installed CLIs (`shop-msg`, `shop-templates`) drift from BC source as
BCs land work, because the install mode is non-editable. The Architect
on `lead-79q` worked around the drift by direct `ls` of `inbox/` —
a brief-001-invariant-1 violation forced by tooling staleness.
Re-installing manually via `pip install -e repos/shopsystem-messaging/`
fixed the surface.

This brief folds the mitigation into the activation surface. **PO
stance committed:** the canonical `SessionStart` hook (scope item B)
**also** ensures the product venv reflects current BC source, so that
the first thing every fresh session does is sync the venv before
arming the watcher and before the agent attempts any `shop-msg`
operation. The committed property is: **on session start, the venv's
installed BCs are equivalent to their current source.**

Realization of the property is **the Architect's call**. Three
candidate shapes pre-state should evaluate:

1. **Hook-time `pip install -e repos/*/`.** The SessionStart hook
   runs the install before arming Monitor. Pro: closes drift even if
   bootstrap installed non-editable. Con: paid every session; slow if
   BCs proliferate.
2. **Bootstrap-time editable install.** Brief 002's bootstrap (or a
   sibling product-level bootstrap that composes per-shop bootstrap
   with venv setup) installs BCs editable from the start, so source
   changes flow without reinstall. Pro: zero per-session cost. Con:
   does not help shops created before this lands; needs a one-time
   migration.
3. **Both.** Bootstrap installs editable AND the hook re-runs install
   if it detects drift (e.g., via `pip show` version comparison or
   a sentinel file). Pro: belt-and-suspenders. Con: complexity for
   what should be a default.

**PO leaning (not a commit):** option 2 is the right shape long-term;
option 1 is a useful safety net during the transition; option 3 is
the realization the Architect is likely to commit to if pre-state
surfaces real drift cases not covered by 2 alone. **The PO commits
the property (venv-source equivalence on session start) and the
folding (this brief subsumes `lead-xq0`); the Architect commits the
shape.**

If pre-state on E surfaces design tension large enough that the cut
between scope-of-this-brief and product-level-bootstrap (brief 002's
explicit out-of-scope) becomes blurry — for example, if "venv setup"
turns out to belong cleanly to the product-level workflow and not to
per-shop bootstrap or to per-shop SessionStart — the Architect flags
it and **E escalates to its own brief** (or a PDR), without blocking
A-D. A-D are independent of E and can dispatch regardless of how the
E call resolves.

## Out of scope — named explicitly

**Session supervision.** The user starts and restarts Claude Code
sessions manually. The brief commits per-session reactivity, not
session lifecycle management. No automated session restart, no
devcontainer auto-launch of Claude Code, no tmux/screen wrapper, no
systemd unit. If a session crashes or is closed, the next session
arms the watcher again on start; until then, the shop is unreactive.

**Cloud / distributed activation.** Cross-host activation (a watcher
in shop X firing on a message dropped by shop Y on a different machine)
is a follow-on brief. Filesystem events do not cross hosts; a future
brief commits a different activation primitive (HTTP webhook, queue
notify, `shop-msg watch` subcommand fronting a daemon) when the
shop-system becomes distributed. Brief 003 commits to **local-filesystem
activation appropriate to the current transport**.

**Long-running persistent-session optimization.** Each Claude Code
session is a normal human-started session. The brief does NOT
introduce a daemon mode, a persistent agent process, or a
context-window optimisation strategy for long sessions. The user
manages session length via the normal Claude Code controls (compact,
restart); the brief is invisible to those concerns.

**Replacing `inotify` with something else.** The brief's activation
mechanism IS `inotifywait` on the filesystem, because that is the
realization the empirical work validated against the transport
`shop-msg` currently uses. A future `shop-msg watch` subcommand that
abstracts the watch primitive away from the filesystem is **adjacent
future work**, anticipated by invariant 2's corollary but not
committed by this brief.

**devcontainer `postCreate` host installation.** Per scope item D,
host-level packages (`inotify-tools`, `coreutils`) are named in the
generated shop scaffold so an operator has a documented expectation,
but the brief does NOT commit to writing the devcontainer or any
other host infrastructure that installs them. That is host
infrastructure, a separate concern from shop-shape.

**Lead-shop drain automation.** `shop-msg drain` (auto-loading inbound
messages into `bd`) remains deferred per
[brief 001 out-of-scope](001-inter-shop-messaging-encapsulation.md).
Event-driven activation makes manual-drain friction more visible —
the agent wakes immediately, instead of discovering messages on a
schedule — but the brief does not commit drain automation. A
follow-on opens when manual-drain friction surfaces under real-product
BC use, per brief 001's framing.

## Sequencing

- **A, B, C, D** are a coherent unit. They target `shopsystem-templates`
  and extend the brief 002 bootstrap surface. They can be authored as
  scenarios and dispatched together once the Architect has verified
  pre-state on (1) Claude Code's `SessionStart` hook surface — what
  payload shapes the hook supports, whether `prompt`-type hooks can
  arm Monitor, whether `command`-type hooks are appropriate for the
  arming work; (2) `inotify-tools`' availability assumption (is it
  reasonable to require it on every host where a shopsystem shop
  runs?); (3) brief 002's current bootstrap pre-state, so the
  `.claude/settings.json` generation slots in cleanly.

- **E** depends on the venv install-mode pre-state. The Architect's
  pre-state on E (specifically: confirming the current installs are
  non-editable, confirming the bootstrap install path, identifying
  which of the three candidate shapes pre-state actually supports)
  may surface design tension that escalates E to its own brief or to
  a PDR. **The PDR escalation trigger fires AT the Architect's
  pre-state verification on E**, per the same pattern brief 002
  applies to its scope item E.

- **Dispatch may proceed immediately on brief close.** No in-flight
  chain blocks brief 003 — brief 002's dispatch chain
  ([`lead-1uo`](#) / [`lead-03r`](#)) is complete, the BC inbox is
  empty, and PDR-001's role-complete restructure
  ([`lead-kq0`](#)) is in progress but does not collide (this brief
  adds new package data, it does not modify the templates the
  restructure is working on).

- **Soft sequencing constraint relative to brief 002:** brief 003
  scope item C extends brief 002's bootstrap surface. The two
  briefs' scope items co-locate in the same BC's work. Authoring
  may proceed in parallel; dispatch ordering should let brief 002's
  bootstrap-surface scenarios land first so that brief 003's
  `.claude/settings.json` addition slots into an already-bootstrapped
  generated surface rather than racing it. **This is a dispatch
  ordering hint, not a hard constraint.** The Architect may bundle
  the two briefs' scope into a single `assign_scenarios` if pre-state
  surfaces that as cleaner.

## Vehicle hints (Architect's call)

For the Architect's awareness during pre-state verification — not as
a prejudgment of the discriminator:

- The activation hook as a whole is **net-new framework property** on
  `shopsystem-templates` — no canonical `.claude/settings.json`
  template exists today. Net-new capability points to
  `assign_scenarios`.
- Scope item C extends brief 002's `shop-templates` bootstrap surface;
  if brief 002's surface is already dispatched and partly built when
  brief 003 dispatches, C lands as `request_bugfix` (tightening the
  generated surface to include the new file) — otherwise it folds into
  the brief 002 `assign_scenarios`.
- Scope item E's vehicle depends on its realization. Hook-time
  `pip install` (option 1) is a behavior change to the generated
  hook, parallel to A/B/C — same `assign_scenarios`. Bootstrap-time
  editable install (option 2) tightens brief 002's bootstrap behavior
  — likely `request_bugfix`. The Architect picks after pre-state.

These are hints. The Architect's `PRE-STATE DETERMINES VEHICLE —
VERIFIED EMPIRICALLY` posture stands.

## Grounding artifacts

- [`briefs/001-inter-shop-messaging-encapsulation.md`](001-inter-shop-messaging-encapsulation.md)
  — invariant 1 (`shop-msg` as sole messaging surface); the
  encapsulation invariant this brief's activation mechanism must
  respect (event signals the wake; CLI delivers content).
- [`briefs/002-shop-bootstrap-cli-surface.md`](002-shop-bootstrap-cli-surface.md)
  — the bootstrap surface this brief extends (`.claude/settings.json`
  is added to the generated surface defined in scope item B; update
  semantics from scope item C apply).
- [`findings/from-prototype-1.md` finding 6](../findings/from-prototype-1.md)
  — "package CLIs are the integration boundary"; activation operates
  **below** the messaging layer (process-wake signal) and so does not
  enter the consumer-of-messages role finding 6 governs.
- [`lead-xq0`](#) — venv drift bug; scope item E folds it in.
- [`lead-zmi`](#) — shop-msg PATH ergonomics; **adjacent**, not
  folded. Same theme (tooling-availability ergonomics affecting
  inter-shop work), different facet (PATH vs install mode).
  Independent resolution.
- [`.claude/settings.json`](../.claude/settings.json) — current
  lead-shop hook content (`bd prime` on `SessionStart` and
  `PreCompact`); the canonical lead-shop variant under scope item A
  composes with this content.
- [`repos/shopsystem-templates/src/shop_templates/templates/`](../repos/shopsystem-templates/src/shop_templates/templates/)
  — the package-data directory the new canonical `settings.json`
  variants ship from.

## What this leaves open

The brief commits **intent**, not scenarios. Scenarios come after the
Architect verifies pre-state and picks vehicles per the discriminator.
Specifically:

- **Claude Code hook surface details for A and B.** What hook type
  (`command` vs `prompt`) carries the arm-Monitor payload, what the
  exact `settings.json` JSON shape looks like, and whether the
  prompt-content lives inline in JSON or in a referenced script — all
  are pre-state-determined. The brief commits **what** the hook does,
  not **how** Claude Code carries the doing.
- **`inotify-tools` packaging assumption.** Whether to commit
  `inotify-tools` as a hard prereq (named in D, with the hook failing
  loudly on missing-tool) versus a soft prereq (the hook falls back
  to a polling shape on missing-tool) is a realization decision. The
  brief commits the property (reactivity on session start); falling
  back to polling **silently** violates invariant 1 — so any fallback
  must be loud (notification surface) rather than transparent.
- **Venv-install realization for E.** The three candidate shapes
  (hook-time, bootstrap-time, both) are named with PO leaning toward
  option 2 + 1 as belt-and-suspenders, but the commit is the property,
  not the shape. Pre-state on the install path picks the realization.
- **PDR-vs-brief escalation for E.** As named in the section, if
  pre-state on E surfaces that venv setup belongs cleanly to a
  product-level workflow rather than per-shop bootstrap or per-shop
  SessionStart, E escalates to its own brief or PDR before scenarios
  are authored against it. A-D proceed regardless.

These are vehicle-level and design-tension questions, not intent-level.
The PO's commit is the two invariants + the five scope items + the
explicit out-of-scope boundary.
