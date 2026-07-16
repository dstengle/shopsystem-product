# Slice 4 — THE GOAL: fabro-orchestrated throwaway BC consumes `assign_scenarios`, emits `work_done`

**Epic** lead-6k1r (Fabro spike) · **Slice** 4 (goal slice) · **Branch** `fabro-spike`
· **Date** 2026-07-01 · fabro v0.254.0 · SPIKE / THROWAWAY · odqd iterative-experimentation track.

Legs: `04a-fabro-launch-in-container.md` (LAUNCH — PASS) · `04b-goal-demo-run.md` (DEMO — this synthesis's evidence base).

---

## 0. GOAL VERDICT — **PARTIAL** (artifact GREEN, loop-fidelity RED)

The spike goal (plan §Goal): *"dispatch `assign_scenarios` to a fabro-orchestrated BC and
observe a valid `work_done` produced by the recreated Implementer→Reviewer loop."* Split it
into its two halves and the result is unambiguous:

| Half of the goal | Verdict | Why |
|---|---|---|
| A valid `work_done` produced under fabro orchestration from a seeded `assign_scenarios` | **GREEN (artifact)** | A real non-dry-run `fabro run` (`01KWDTN9F1J0MASAPDCE3TAAN8`, real haiku LLM + real tools, all through the shim) consumed the seeded message end-to-end and deposited a valid `status: complete` work_done to the outbox. |
| …*produced by the recreated Implementer→Reviewer node loop* | **RED (fidelity)** | The graph decomposition was **bypassed**: the `prime` node's runaway general-agent executed the entire Implementer→Reviewer pipeline inside node index=1 and emitted the work_done itself. The 9 downstream loop nodes (`classify/suff/worktree/plan/impl/redgate/integ/review/wdg_r/emit_r`) **never ran**; `arm` drained an already-empty inbox and idled to a **false `Exit: SUCCEEDED`**. |

**So: the goal is PARTIAL.** fabro *can* drive a real BC container through the shop-msg
protocol from `assign_scenarios` to a valid `work_done` on the wire — the launch interface,
the credential path, and the emit all work. But the load-bearing *structural* claim of the
slice — that the **recreated graph loop** is what produces the work_done, with the reviewer
node as the sole gated emitter — is **not** demonstrated, because in fabro v0.254.0 a
"command" node is a general read-write agent carrying the whole graph goal, and nothing keeps
it in its lane. This is the headline fabro-integration gap, and it is a *worse* variant of the
Slice-3 no-directive hazard: not "an agent slips a gate" but **an agent swallows the entire
pipeline and shared state (node-collapse)**.

### The GOAL artifact (verbatim from the outbox)

`shop-msg read outbox --bc fabro-throwaway --work-id fabro-spike-demo-1`:

```
message_type: work_done
work_id: fabro-spike-demo-1
status: complete
summary: 'BDD scenario passes. ... Test-first artifacts verified: test(red) 8eec830
  precedes feat(green) a2abb16. All 5 work-done-gate checks pass: clean tree, work_id
  reachable from main, scenario hash found in features/, plan sub-issues closed with
  RED marker, test-first sequence verified.'
scenario_hashes:
- 674e0bb2d51a6f2b        # canonical block-only hash, subset of features/, reproducible
```

Valid WorkDone shape; substantive, evidence-backed summary; `scenario_hashes` a correct
block-only subset of `features/` (`674e0bb2d51a6f2b`, reproduced in-container via
`printf '<block>' | scenarios hash`). Real commits back the claims: `test(red)` `8eec830`
(03:14:50Z) precedes `feat(green)` `a2abb16` (03:16:02Z), both pushed to the local bare
`origin/main`. The artifact is genuine — it is only its *provenance* (prime-collapse, not the
node loop) that fails the fidelity half.

---

## 1. AC5 — gated-emit: **PARTIAL**

The **emit mechanics are CONFIRMED**, but the **reviewer-sole-emitter structural guarantee is
NOT exercised and is NOT enforced by fabro**:

- **Gate ran.** `bc-emit`'s enforced gate (Checks C1 clean tree / C2 `work_id` reachable from
  `origin/main` / C3 scenario-hash recompute ⊆ payload) re-ran and passed; the summary's
  claims are backed by real commits. (Checks 4/5 — bd sub-issues, genuine-red execution — are
  furniture prose, not wrapper-enforced, so `behave` being absent in bc-base did **not** block
  the emit; that env gap did not bite.)
- **Exactly one work_done exists**, and the **UNIQUE-collision backstop is CONFIRMED**:
  re-running the same `bc-emit work-done` for the same `work_id` → `refusing to overwrite
  existing work_done response ... (use --force)`, **exit 1**. The wrapper's C1/C2/C3 passed on
  the re-run (it reached the respond layer); the **UNIQUE(work_id, direction, shop)** DB
  constraint (ADR-012) refused. In-graph this is `emit_r → halt` via
  `condition="outcome=failed"` — a nonzero emit fails the run, never a silent second success.
- **What AC5 did NOT get to demonstrate:** `emit_r` as the *structural sole emitter*, reached
  only via `review → signoff → wdg_r → pass`. Because `prime` collapsed the loop,
  `review`/`wdg_r`/`emit_r` never executed — the emit came from the runaway prime node. **fabro
  does not enforce sole-emit**: any node with `bc-emit` on PATH + `read-write` permission can
  emit. The sole-emitter property is therefore unproven at the graph level and, structurally,
  unenforced.

## 2. AC8 — reactive-seam: **GREEN (mechanism), Seam(b) PARTIAL**

Probed live with a fresh `fabro-spike-demo-2` (identical trivial scenario), both seam forms:

- **Drain (the `arm` node's actual mechanism):** `shop-msg pending inbox --bc fabro-throwaway`
  → `fabro-spike-demo-2 assign_scenarios` (non-empty ⇒ `arm` routes `message` → `classify`);
  `shop-msg read inbox --work-id fabro-spike-demo-2` returns the message. **Observed.**
- **Reactive LISTEN/NOTIFY:** `shop-msg watch --bc fabro-throwaway` printed
  `fabro-spike-demo-2 assign_scenarios` then `READY` before a bounded timeout — the reactive
  watcher observes the arrival and emits the `<work_id> <message_type>` line. **Observed.**
- **Caveats:** (1) `shop-msg watch` is **not a fabro node primitive** — the `arm` node is a
  poll/drain, so **Seam(b) remains PARTIAL** (consistent with Slice 0's finding: fabro has no
  native external-async primitive). (2) The live run proved the drain is **not robust to
  upstream over-consumption**: `arm` observed empty because `prime` had already consumed the
  message. The seam works; its *placement* in a graph of unbounded general-agent nodes does not.

---

## 3. The five hard invariants — ALL HELD across the live run

| # | Invariant | Held? | Evidence |
|---|---|---|---|
| 1 | **Fabro scope = in-container BC orchestration only** | **HELD** | fabro ran as an ephemeral local server (`pid 379 @ 127.0.0.1:32276`) *inside* `bc-fabro-throwaway`, executing only that BC's loop. No fabro cloud/external orchestration; the lead kept shop-msg/Monitor. |
| 2 | **Credentials via agent-vault, NOT fabro secrets** | **HELD** | `vaults/default/secrets.json` = `__PLACEHOLDER__` for both `GITHUB_TOKEN` and `ANTHROPIC_API_KEY` (unchanged); server `ANTHROPIC_API_KEY` = dummy. All real LLM traffic went dummy-`x-api-key` → in-container anthropic-oauth-shim → container `HTTPS_PROXY` → agent-vault (real OAuth) → `POST /v1/messages 200`. Real GitHub token only on the wire (`curl api.github.com/user` → 200 with a dummy token). Nothing real ever written to/read from fabro's vault. |
| 3 | **Launch-interface parity with `bc-container`** | **HELD** | Booted from the same `shopsystem-bc-base:latest` the 3 healthy infra BCs run; launch-parity (agent-vault proxy + MITM CA + `SSL_CERT_FILE` + postgres DSN) provisioned by hand to match what `bc-container launch` injects; the BC presented a **real, registered, EMPTY** postgres mailbox — the exact starting posture of a launched BC. Entry path `prime→health→arm→classify` traversed clean under `--dry-run` and non-dry-run. |
| 4 | **shop-msg protocol preserved** | **HELD** | Input arrived as a real `assign_scenarios` via `shop-msg send`; output was a valid `work_done` consumed via `shop-msg read outbox`; the whole loop used shop-msg/`bc-emit` exactly as the current bc-shop loop does. No mailbox storage touched directly. |
| 5 | **Rollback: all work on `fabro-spike`; `main` untouched** | **HELD** | All defs + findings on `fabro-spike` (commit `fb997c2`, not yet pushed at leg close). The only `origin/main` writes were to a **local bare git origin** at `/root/origin.git` *inside the throwaway container* — not any real repo. Every real repo still sits at its `fabro-spike-baseline` tag. |

**needs_david: none** — the entire slice stayed in-scope: local docker throwaway container,
local postgres rows for a throwaway BC, a local bare origin, `fabro-spike`-branch defs. No real
infra BC touched, no remote repo, no message seeded to a real BC.

---

## 4. What the spike PROVED (and its throwaway-scope caveats)

**Proven across Slices 0–4:**

1. **fabro is a viable in-container BC orchestrator at the launch + credential + protocol
   layers.** It boots headless inside a bc-base container, runs a real multi-node workflow with
   a real LLM, and speaks shop-msg end-to-end — dispatching `assign_scenarios` in and depositing
   a valid `work_done` out.
2. **The agent-vault bypass of fabro's native secret system is real and complete** (invariant
   #2). The anthropic-oauth-shim (Slice 3, ~180 lines stdlib) resolves the last load-bearing
   blocker — fabro's `x-api-key` adapter vs the fleet's OAuth-`Bearer` agent-vault — with fabro's
   vault holding only `__PLACEHOLDER__`. This held under real LLM load in Slice 4.
3. **Launch-interface parity is achievable** by hand-replicating the `bc-container launch`
   provisioning onto a plain `docker run` bc-base container (invariant #3).
4. **The fail-closed graph design works where it runs** — the AC5 UNIQUE-collision backstop
   (`emit_r → halt` on `outcome=failed`) is confirmed; the Slice-0 silent-failure-masking hazard
   is structurally addressed by outcome-conditional edges.

**Throwaway-scope caveats (what the spike did NOT prove):**

- **Loop fidelity is unproven** — the structured Implementer→Reviewer node sequence never
  actually ran; a single collapsed agent produced the artifact. The graph's decomposition and
  its sole-emitter guarantee are, in v0.254.0, **advisory, not enforced**.
- **Not run via `bc-container launch`** — launch-parity was hand-provisioned; the real
  drop-in-launcher integration (manifest/broker/clone machinery) was deliberately side-stepped.
- **Not a real infra BC, no real repo, no shared manifest** — throwaway container, local
  postgres rows, local bare origin only.
- **haiku only, expensive/slow** — `prime` burned 83 turns / 4m14s / $0.48 for what should be
  two commands; `retry=N` did not appear to wire at the stage layer (`max_attempts=1` observed).

---

## 5. Remaining gaps

The spike's real signal is a short list of **fabro-integration gaps** (not environment gaps):

- **G1 — command-as-agent node scope overrun / node-collapse (headline).** v0.254.0 has no
  native templated `command` handler, so every "command" node is a general read-write agent
  carrying the global goal. Nothing encloses it to its command → it can swallow the whole
  pipeline and mutate shared state (inbox, git, emit). **This is the gating gap.**
- **G2 — no structural sole-emit enforcement.** Any node with `bc-emit` + read-write can emit;
  reviewer-as-sole-emitter is not a fabro guarantee.
- **G3 — drain seam not robust to upstream consumption.** The `arm` poll/drain can observe empty
  if an earlier node consumed the message.
- **G4 — no reactive LISTEN/NOTIFY primitive** (Seam(b) PARTIAL; `shop-msg watch` survives only
  as a command node).
- **G5 (minor)** — `retry=N` not observed at the stage layer; command-as-agent nodes slow/costly.

**The clean fix for G1/G2 is the same one carried since Slice 3:** native `script=`-gated
command nodes + per-node tool/permission scoping (and a prompt-enclosure that hard-stops the
agent after its command). That fix is **blocked by the `input-into-command-sandbox` gap noted
in 03b** — templated inputs do not reach a native `script=` command sandbox — which is the
single most important thing to resolve before fabro can be trusted to run the loop structurally.

---

## 6. Recommendation — **PARTIAL: one more thin slice before graduation**

The goal is PARTIAL, not GREEN, so **do not graduate yet.** The artifact-level proof is
banked; the missing piece is *loop fidelity*, and it turns on exactly one blocker.

**Next thin slice — Slice 5 "structural loop, no collapse":** close the
`input-into-command-sandbox` gap (03b) so the `prime`/`arm`/emit command nodes become native
`script=`-gated deterministic steps with per-node tool/permission scoping, then re-run the exact
Slice-4 demo and assert **loop fidelity**: (a) `prime` runs *only* `shop-msg prime && bd prime`
and touches nothing else; (b) `classify/suff/impl/review/wdg_r/emit_r` all execute in sequence;
(c) the work_done is emitted by `emit_r` alone (sole-emitter proven structurally, closing AC5's
PARTIAL); (d) a forced reviewer-fail yields run-STATUS FAILED with no `work_done(complete)` on
the wire. Output `findings/fabro-spike/05-structural-loop.md`. Keep it throwaway-scoped exactly
as Slice 4.

**Only after Slice 5 is GREEN, graduate via the odqd track** (ADRs + scenarios; spike vehicle
ADR-029/030/032). At that point the ADRs to draft are:

- **ADR — fabro as an alternable in-container BC-orchestration substrate** (records the Seam(a)
  launch-parity contract + the `provider='local'` in-container model; supersedes the f6ta
  origin bead lead-f6ta).
- **ADR — agent-vault as the sole credential surface under fabro** (the vault-`__PLACEHOLDER__`
  + `HTTPS_PROXY` + anthropic-oauth-shim path; formalizes invariant #2 as a contract, names
  fabro's native secret system as a forbidden surface).
- **ADR — fabro launch-interface parity with `bc-container`** (the drop-in-launcher contract:
  which of the P1–P20 properties from Slice 1 are KEPT/REPLACED, and the readiness-barrier seam).
- **ADR — the fabro DOT loop-graph contract** (the Implementer→Reviewer graph with reviewer as
  sole gated emitter + outcome-conditional fail-closed edges; must land *with* the Slice-5 fix
  that makes those guarantees enforced rather than advisory).

Corresponding graduation **scenarios** pin: launch-parity boot, agent-vault-only credential
injection, the assign_scenarios→work_done loop, and the fail-closed (forced-fail ⇒ no complete
emit) behavior.
