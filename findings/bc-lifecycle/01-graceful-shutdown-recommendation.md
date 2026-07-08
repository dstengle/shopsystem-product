# BC lifecycle management — graceful shutdown mechanism (design recommendation)

- **Bead:** lead-4qqn (P1, IN_PROGRESS) — BC lifecycle management: graceful shutdown.
- **Author:** lead-architect (Claude), 2026-07-06.
- **Status:** DESIGN RECOMMENDATION — pre-decision. This is a design finding, not an
  ADR: an ADR records a *settled* decision with a rejected alternative, and this
  recommendation still carries open vocabulary questions that David must resolve
  before a decision can be recorded (see §5). Home chosen to mirror the research-first
  pattern in `findings/progressive-disclosure/` (research → recommendation, reviewed
  with the product authority before any dispatch). NO BC dispatch is implied by this
  document.
- **Empirical basis (ADR-018 D1/D2):** No BC source read, run, or git-observed — the
  lead host carries none. Verified against this repo's `adr/`/`pdr/`/`features/`, the
  installed `shop-msg` / `bc-container` / `scenarios` CLIs via `--help`, and the
  `shop-templates` package data, on 2026-07-06.

---

## 1. The problem (David, 2026-07-06)

Shutting down a BC has no high-level interface. `bc-container` is the **low-level
container surface**; its `stop` = "stop **and remove** the container" = a hard kill
that skips the agent's session-close protocol (git commit/push, `bd dolt push`). Once
an agent is running, `bc-container` is the wrong layer for high-level lifecycle.

David's leaning: a **message** instructing a shop to gracefully shut down (agent
receives it → runs session-close → exits cleanly) **combined with** lower-level
container teardown via `bc-container`, the whole thing **wrapped in a skill** as the
high-level interface. Layering tension David named: one *could* have `bc-container`
call `shop-msg`, but the name "container" signals a concern-mismatch — keep
`bc-container` = container primitives, `shop-msg` = agent messaging, orchestration in
a **skill** that composes both. Do not overload `bc-container` with messaging.

---

## 2. Pre-state (empirical, artifact/tool surface only)

### 2a. Message vocabulary — NO lifecycle vehicle today (verified)

`shop-msg send --help` outbound lead→BC types:
`request_maintenance`, `assign_scenarios`, `clarify_response`, `request_bugfix`,
`request_completion_journal`, `request_scenario_register`, `nudge`. There is **no**
shutdown / stand-down / lifecycle vehicle. A new vehicle is required — confirmed.

`shop-msg respond --help` BC→lead response types:
`clarify`, `work_done`, `mechanism_observation`, `request_completion_journal`. There
is **no** shutdown-ack response type either. But `shop-msg nudge --bc <SENDER>`
(ADR-015 decision 4, bidirectional) means the BC **can already originate a nudge to
the lead** — this is the cleanest available handshake channel for a shutdown
confirmation without minting a new response type.

**Closest precedent for a new lifecycle message: `nudge` (ADR-015).** It is the
lightest lead→BC vehicle: `reason` enum + optional `note` + optional `work_id`, **no
`scenario_hashes`**, does **not** open/close/modify bead state, non-blocking auxiliary
semantics, one-reply cap. Its `status-check` reason already has the exact
request→bounded-reply shape a shutdown handshake needs (lead asks; BC MUST reply with
a single nudge carrying state). A shutdown message shares this shape (schema-light, no
scenarios, expects a bounded reply). See §3 for why I nonetheless recommend a *distinct*
type rather than a nudge reason.

### 2b. `bc-container` — container primitives only; `stop` = stop-and-remove; no graceful hook (verified)

`bc-container --help` subcommands:
`launch / attach / inject / monitor / stop / status / start-agent / list / manifest`.
`bc-container stop --help` takes only `bc_name`; the subcommand description is
literally **"Stop and remove the container."** There is **no** `--graceful` /
pre-stop hook. `inject` sends text to the tmux session; `monitor` streams tmux output;
`start-agent` recovers an already-cloned healthy container WITHOUT re-cloning
(idempotent) — i.e. a stopped-but-kept container can be re-engaged.

The `stop` behavior is **pinned**: `features/shopsystem-bc-launcher/bc_container.feature`
carries `@scenario_hash:05b93eda8268ee7c` — *"bc-container stop stops the named BC
container"* → *"no Docker container named ... is running."* The scenario pins
container removal; it does **not** pin any agent wind-down. Ownership of the whole
`bc-container` surface is `shopsystem-bc-launcher` (PDR-004 Decision, Option A).

### 2c. Session-close protocol — defined for the LEAD; a GAP on the BC side

The lead's session-close is spelled out in `.claude/shop/primer.md` (lines 77–78):
*"Work is not done until `git push` succeeds. `git status` → `git add` → `git commit`
→ `bd dolt push` → `git push` → `git status`."* That is what "graceful" must
guarantee for any shop: **commit, push, `bd dolt push`, and (for a BC) drain the
inbox / not abandon in-flight work.**

The BC-side templates (`shop-templates show bc-implementer` / `bc-reviewer`) define
per-dispatch `work_done` emission (bc-implementer step 4; ADR-042 emit gate) but
**do not define a whole-session close-out imperative** analogous to the lead primer's.
So "the agent runs session-close" is not yet a pinned BC behavior — authoring it is
part of this design (see ownership map §4), not something that already exists to be
tightened.

### 2d. Fabro — does NOT own container lifecycle; teardown stays on `bc-container` (verified from ADR-048/050/051)

As of 2026-07-06 BCs may run under fabro (dogfood). From the artifact surface:

- **ADR-048 D1:** fabro is admissible only as an *ephemeral LOCAL in-container server*
  (`provider='local'`, bound to `127.0.0.1`), orchestrating **only that single BC's
  Implementer→Reviewer loop**. "There is no fabro tier above the BC."
- **ADR-050 D1:** the **container tier (P1–P4, P7, P10–P17) is KEPT** — fabro runs
  *inside* an already-booted container and does **not** create it; the outer
  `bc-container` docker invocation is unchanged. The P20 subcommand surface
  (`launch/attach/inject/monitor/stop/status/list`) is KEPT as thin shims.

**Conclusion for teardown:** container removal is the outer `bc-container` invocation's
job **regardless of substrate**. `bc-container stop` still applies under fabro; the
container-teardown half of David's design is fabro-compatible.

**But the ENGAGE tier IS replaced (ADR-050 D3):** under fabro the in-container agent is
a **headless `fabro run`** whose entry path is `prime→health→arm→classify` — **not** a
reactive tmux `claude` TUI. ADR-051 shows the loop graph terminates at `reported→done`/
`halt` after a single gated `work_done` round-trip; `shop-msg watch` survives only as a
*command node* (Seam (b) PARTIAL, ADR-048 D2). So **how a shutdown message reaches, and
is acted on by, a headless fabro agent — whether `classify` recognizes a
`request_shutdown` and routes to a clean session-close terminal node instead of the
Implementer→Reviewer loop — is NOT answered by the artifact surface.** This is a genuine
open question, flagged as a candidate BC clarify to `shopsystem-bc-launcher` (owns the
fabro def + loop graph, ADR-050/051). Do not guess it here.

---

## 3. Mechanisms considered (breadth → converge)

### Option 1 — David's leaning: new lifecycle MESSAGE + `bc-container` teardown + orchestration SKILL  ★ RECOMMENDED

- **The message.** A new lead→BC vehicle, working name **`request_shutdown`**
  (vocabulary is David's call — see §5). Modeled on `nudge`'s *shape*: schema-light,
  **no `scenario_hashes`**, optional `note`, optional `mode` (see §5 stop-vs-keep-vs-
  hibernate), does not touch scenario-coverage state. Semantically it is an
  *actionable request*, not a ping (justification below).
- **The handshake.** On receipt the agent runs the BC session-close protocol
  (commit → push → `bd dolt push` → inbox drain), then **confirms via a BC-originated
  `shop-msg nudge` to the lead** (e.g. `--reason general --note
  "session-close complete; ready for teardown"`), reusing the existing bidirectional
  nudge channel (§2a) so no new response type is minted for the MVP. (A dedicated
  `respond shutdown_ack` is a possible future tightening; the nudge ack is sufficient
  and auditable now.)
- **The teardown.** After the confirmation (or after the ADR-014 heartbeat goes
  `offline`), the skill calls **existing `bc-container stop`** to remove the container.
- **The skill (high-level interface).** A lead-side skill orchestrates:
  `send request_shutdown → await session-close confirmation (nudge / heartbeat-offline)
  → bc-container stop`. It composes `shop-msg` (messaging) and `bc-container`
  (container) without either tool crossing into the other's concern — this is exactly
  David's layering. Lead skills pour into the lead shop per PDR-014
  (lead-skill-group-pour-and-graduation-path).

**Why a distinct message type, not a `nudge` reason.** ADR-015 §6 pins nudge as
*transmission-layer only*: it "MUST NOT block the original dispatch's lifecycle, MUST
NOT count as a `work_done` precondition," and is "not scenario state." A shutdown
imperative triggers **substantive agent work** (the session-close protocol) and expects
confirmation that that work *completed*, and it has a real lifecycle consequence (the
shop stops). Folding it into `nudge` would repeat precisely the dilution ADR-015
Option A rejected for `clarify` (a sub-reason opting out of the type's own contract). It
borrows nudge's *shape* but deserves its own catalog entry with its own semantics. This
is a recommendation, not a settled call — confirm with David (§5).

**Trade-offs.** Gracefulness: full — in-flight work is committed/pushed before
teardown. Auditability: full — the imperative and the ack are both `shop-msg` mailbox
records (honors ADR-015 Option C: "all inter-shop coordination flows through
`shop-msg`"). Layering: clean — no concern-merge. Fabro: teardown half is compatible
(§2d); the delivery-to-headless-fabro-agent half is the §5 open question.

### Option 2 — `bc-container stop --graceful` that itself signals the agent

`bc-container stop` gains `--graceful`: before docker stop/rm it signals the agent to
run session-close, waits, then tears down. **Weighed, not dismissed:** it gives a
single operator command. But it makes `bc-container` (owned by `shopsystem-bc-launcher`,
a *container* domain, PDR-004) originate **agent messaging** — the exact concern-mismatch
David flagged, and it forces bc-launcher to depend on the messaging schema. The skill in
Option 1 delivers the *same* one-command UX at the lead layer **without** merging the two
BCs' concerns. Rejected on layering grounds; the UX benefit is fully recovered by the
skill.

### Option 3 — fabro-native teardown path

Rejected as a primary path by pre-state: ADR-048 D1 says there is *no fabro tier above
the BC* and ADR-050 D1 keeps the container tier on the outer `bc-container`. Fabro cannot
remove the container; the most a fabro-native path covers is the *in-container loop
terminating* — which is downstream of the agent's session-close, not a substitute for
container removal. It resurfaces only as the §5 open question (can the fabro loop graph
route a shutdown to a clean terminal node), not as an alternative mechanism.

### Option 4 — pure-skill, no new message type: inject a stop instruction over tmux via `bc-container inject`

The skill types a "run session-close and stop" prose instruction into the tmux `agent`
session via `bc-container inject`, waits, then `bc-container stop`. Rejected on three
counts: (1) **Auditability** — the instruction is a tmux keystroke, **not** a `shop-msg`
record; it carves the out-of-band hole ADR-015 Option C explicitly refuses. (2)
**Gracefulness** — depends on the agent obeying free prose with no structured contract or
confirmation. (3) **Fabro-portability — BREAKS:** ADR-050 D3 replaces the tmux `claude`
TUI with a headless `fabro run`; there is no interactive TUI to `inject` into (inject maps
to a `fabro steer` shim). Not a durable cross-substrate mechanism.

---

## 4. Recommendation and ownership map

**Recommend Option 1** — David's layered *message + container-primitive + skill* — with
the message as a **new first-class catalog type modeled on `nudge`'s shape**, and the
BC-side confirmation reusing the **existing bidirectional nudge** channel for the MVP.
Pre-state does not contradict David's leaning; it strengthens it (Options 2 and 4 fail on
the layering / auditability / fabro grounds David's framing anticipated).

| Piece | Owning BC / surface | Pre-state | Discriminator that WOULD apply later (NOT dispatched now) |
|---|---|---|---|
| New `request_shutdown` message type + its schema (no `scenario_hashes`) + the BC-nudge ack convention | **shopsystem-messaging** (owns the message catalog/schema; the ADR-015 pattern) | No such type exists (§2a) — net-new | `assign_scenarios` (net-new capability) |
| BC session-close-on-shutdown **behavior** (agent runs commit→push→`bd dolt push`→drain, then emits the ack) | **shopsystem-templates** (BC role-template prose: `bc-implementer` / BC primer standing rule — mirrors ADR-015 "templates learn the standing rules") | No BC-side session-close imperative exists today (§2c) — net-new standing rule | `assign_scenarios` (net-new behavior). If a partial session-close protocol is later found already pinned, re-check for `request_bugfix` |
| Container teardown after graceful exit | **shopsystem-bc-launcher** (owns `bc-container`, PDR-004) | Existing `bc-container stop` pinned by `@scenario_hash:05b93eda8268ee7c` (§2b) | **If the skill reuses existing `stop`: NO change / no dispatch.** If David wants a stop-but-keep / hibernate variant (§5): `assign_scenarios` for a new subcommand, or `request_bugfix` to tighten `stop` — depends on the §5 vocabulary decision |
| Orchestration **skill** (send shutdown → await confirmation → `bc-container stop`) | **lead templates / shopsystem-templates** lead-skill-group (PDR-014), poured into the lead shop | No such skill exists — net-new | `assign_scenarios` to shopsystem-templates (skill authoring), or a lead-local skill pour per PDR-014 |

Sequencing note (not dispatched): the messaging type and the BC session-close behavior
are the load-bearing pair; the skill and any `bc-container` variant compose on top. A
later dispatch chain would order messaging-type + templates-behavior first, skill last.

---

## 5. Open questions

**For David (scope / product vocabulary):**

1. **Message name / concept.** `request_shutdown` vs `request_standdown` vs
   `stand-down` / `hibernate`. Names carry different intent (permanent shutdown vs
   resumable stand-down). My working name is `request_shutdown`; confirm.
2. **Teardown semantics — the container-fate question.** Three distinct end-states,
   each with a different `bc-container` need:
   - **stop-and-remove** (today's `stop`, `05b93eda8268ee7c`) — hard teardown after
     graceful exit; the skill reuses existing `stop`, **no bc-launcher change**.
   - **stop-but-keep** — container remains, agent gone; resumable later via existing
     `bc-container start-agent` (idempotent, §2b). Needs a new `bc-container` mode.
   - **hibernate / pausable** — a paused container. Needs a new `bc-container`
     subcommand. This determines whether `shopsystem-bc-launcher` is touched at all.
3. **First-class type vs `nudge` reason.** I recommend first-class (§3 reasoning);
   confirm you agree rather than extending `nudge`.

**For a BC `clarify` (fabro lifecycle ownership) — route to `shopsystem-bc-launcher`:**

4. Under fabro (`provider='local'`, headless `fabro run`, ADR-048/050/051), can the
   in-container loop graph **receive a `request_shutdown` mid-run and route to a clean
   session-close terminal node** instead of the Implementer→Reviewer loop? The loop
   graph terminates at `reported→done`/`halt` after one gated `work_done` (ADR-051), and
   `shop-msg watch` is only a command node (Seam (b) PARTIAL) — so whether `classify`
   recognizes a shutdown message type is graph-design-dependent and **not** settled by
   the artifact surface. (The container-removal half via `bc-container stop` **is**
   settled as fabro-compatible per ADR-050 D1 — §2d.) Do not guess; this needs the BC
   that owns the fabro def/loop graph.
</content>
</invoke>
