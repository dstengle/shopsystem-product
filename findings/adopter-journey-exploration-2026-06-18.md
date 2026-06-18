# Adopter-bootstrap journey exploration — JTBD + journey map (2026-06-18)

**Bead:** lead-y73x (spec; authoritative). Depends on lead-pb70 (journey-map skill adopted).
**Lens skills:** `.claude/skills/jobs-to-be-done/SKILL.md`, `.claude/skills/customer-journey-map/SKILL.md`.
**Fork:** framework-as-product (Brief 007/011 persona). **Posture:** COMMIT-TO-SPECIFICS;
assumed emotions/frictions marked `unvalidated` with a named bounded check.

**Scope (fixed, not widened):** the ADOPTER-BOOTSTRAP journey only — a new user
from an empty directory to a working product of *their own* built on shopsystem.
NOT the framework end-user; NOT the "adopt + grow/scale" follow-on.

**Evidence base (no cold-start invention):**
- `briefs/011-new-product-bootstrap-path.md` — the authoritative 6-step empty-dir→working-product walk.
- `briefs/007-end-user-adoption-documentation.md` — adopter doc UX, the named persona, the launcher gap (Q7).
- `findings/install-walkthrough-2026-06-15.md` — the VALIDATED cold-walkthrough (`acme`, "YES with caveats", three real walls). This is the empirical baseline trace.
- `features/docs/*.gherkin` and `INSTALL.md` (current INSTALL.md is the lead-orchestrated rewrite under lead-l7uz).

---

## 1. Jobs-to-be-Done summary

### The stable functional job (verb-driven, solution-agnostic)

> *Stand up a coordinated, isolated product of my own — a lead shop plus at least
> one BC actually doing real work — from an empty directory, without hand-wiring
> messaging, credentials, or containers, and without learning the framework's
> internals.*

This is stable: solutions (compose files, a lead skill, an orchestrator CLI) will
churn; the job — "get my own product running on this framework with minimum
friction" — does not. It is the Brief 011 §1 job restated as a hire.

### Social and emotional jobs (load-bearing, framework fork)

- **Social:** *"look competent adopting this — not someone who had to reverse-engineer
  an internal product to use it."* (Brief 007 names exactly this: adoption is closed-set
  today because it requires insider context.)
- **Emotional:** *"trust that what I stood up is correct and isolated — that I haven't
  half-wired something that will silently break, and that I haven't collided with or
  damaged anything else on my machine."* (The `acme` run's obsession with isolation —
  distinct net/ports/volumes, live fleet untouched — is this emotional job made concrete.)

### Pains (ranked by intensity)

| Rank | Pain | Intensity | Evidence |
|---|---|---|---|
| P1 | **The promised "talk to the lead, it stands up your product" experience does not yet exist as a capability** — the orchestration the doc promises (services up + provision + create-BC) is OPEN work, so the adopter either gets a lead that cannot do what the front door promised, or falls back to a manual 6-step walk. | **ACUTE** | INSTALL.md §2/§3 promise lead orchestration; `stand-up-product` (lead-5cgv), lead-driveable provision (lead-8vxy), create-bc orchestration are OPEN/partial. The validated path (2026-06-15) was *manual*, not lead-driven. |
| P2 | **The one human credential gate is failure-prone and under-explained** — vault-scope requirement, proposal capture, OAuth credential casing all bite exactly at the most identity-coupled, least-recoverable step. | **ACUTE** | WALL-2 in the `acme` run: `proposal create` died "Session requires vault scope"; required an undocumented `vault token` mint to proceed. |
| P3 | **Silent half-success** — steps that exit 0 while not actually establishing the precondition (e.g. `agent-vault-check` exits 0 silently pre-provision; `.env` not gitignored despite the prose asserting it is). The adopter cannot tell "worked" from "looked like it worked." | **HIGH** | GAP-1 (`.gitignore` omits `.env`, lead-7if5); `agent-vault-check` soft-advisory overstated as a reachability gate. |
| P4 | **Stale/incomplete commands** — default image tag lags (`:latest` ≠ `:v0.3.1`), launch command missing required flags. | MILD–MODERATE | GAP-3 / lead-2xi3; Step 6a flag set incomplete. |
| P5 | **Vocabulary load before the first win** — lead vs. BC, broker, vault, proposal, scenario/hash arrive before anything visibly works. | MODERATE | Brief 007 commits to *not* requiring spec/ADR/PDR reading; INSTALL.md works hard to hide this, but the concepts still surface at the gate. |

**Acute pains for selection input: P1 and P2.** P1 is a moment-of-truth capability gap;
P2 is a moment-of-truth reliability gap.

---

## 2. The journey map — stage by stage

Stages named as the adopter experiences them, from "empty directory" to "job done."
Emotion is a relative curve (▲ rising confidence, ▼ dip). `unvalidated` marks an
emotion/friction assumed rather than observed in the `acme` trace, with the bounded
check that would confirm it.

| # | Stage | Actions | Thoughts | Emotion | Friction / drop-off | Moment of truth / load spike |
|---|---|---|---|---|---|---|
| 1 | **Discover** | Lands on INSTALL.md / docs entry. | "Is this for me? What do I need?" | Curious → hopeful ▲ | INSTALL.md front-loads a *fully hands-off* promise it then hedges ("still maturing"). Gap between promise and delivery seeds later disappointment. `unvalidated` — no observed discover-stage trace. **Bounded check:** fresh reader reaction to the entry doc. | — |
| 2 | **Start the lead** | `mkdir`; `docker run … bc-base bash`; `shop-templates bootstrap --shop-type lead`; `claude`; sign lead in. | "Which thing is the lead? Did bootstrap work?" | Confident ▲ (this step is clean) | Lead-vs-BC distinction lands here as raw vocabulary. `:latest` image lag risk (P4). Bootstrap PASS in `acme` run. | **Load spike (mild):** first concept load (lead vs BC, image, container). |
| 3 | **Ask the lead to stand up the product** | Brief the lead in plain language ("stand up this product, add a `greeter` BC…"). | "Will it actually do this, or just talk about it?" | Hopeful → **anxious ▼** | **THE FORK.** INSTALL.md promises the lead orchestrates from here. The capability (`stand-up-product` lead-5cgv, create-bc orchestration, lead-driveable provision lead-8vxy) is OPEN/partial. The lead today is a router with no skill that wraps `docker compose up` → provision → create-BC. `unvalidated as an end-to-end lead-driven run` — the 2026-06-15 trace did the orchestration *manually*, not by asking the lead. **Bounded check:** a cold walkthrough that issues the §2 plain-language brief to a real lead and records whether it can execute it. | **MOMENT OF TRUTH #1** — does the front door's core promise hold? |
| 4 | **Bring up services** | (lead or adopter) `docker compose up -d`; `agent-vault-check`. | "Is the DB/broker actually up and isolated?" | Cautious ▲ (when it works) | Silent half-success: `agent-vault-check` exits 0 silently pre-provision (P3). `.env` not gitignored (P3, lead-7if5). Services PASS in `acme` run, isolated. | **Load spike:** isolation model (net/ports/volumes) must be trusted, not verified by the adopter. |
| 5 | **Provision the broker (THE human gate)** | Owner password; paste GitHub token+username; approve the CLAUDE_OAUTH proposal. | "Did I paste the right thing? Why did it reject me?" | **Anxious → frustrated ▼▼** then relief ▲ if recovered | **WALL-2 (observed):** `proposal create` → "Session requires vault scope"; required minting `vault token` — undocumented, not lead-driveable (provision is an interactive `read -s` script, lead-8vxy). OAuth casing/format sharp edges (P2). This is the least-recoverable step (real secrets, one shot). | **MOMENT OF TRUTH #2** — the single most identity-coupled, most failure-prone step. |
| 6 | **Create & launch the first BC** | `bc-container launch <bc> --network/--repo-url/--shopmsg-dsn/--agent-vault-broker/--env-file --image :v0.3.1`. | "Why so many flags? Is it really online?" | Tense ▲ on success | GAP-3: doc launch command incomplete; image must be pinned `:v0.3.1` (P4). Brokered clone CA-path lookup fragility (lead-sfme: shop-shell CA not guaranteed to reach container). BC came **online** + projected `acme/greeter` in the run. | **Load spike:** flag set + image pin + brokered-clone mechanics. |
| 7 | **Dispatch first work & see it land** | lead-po authors a scenario; lead-architect `assign_scenarios`; BC builds; `work_done`; reconcile. | "Did it actually BUILD my thing?" | Relief → **delight ▲▲** | assign→deposit→BC-read PASS in `acme` run; the full build→work_done→reconcile was a **boundary** under the dummy Claude token (already proven with real creds in iter-7). `unvalidated under a fresh cold run with real creds` — proven separately, not in one continuous adopter run. **Bounded check:** one continuous real-cred cold run through Stage 7. | **MOMENT OF TRUTH #3** — "it actually built the thing." The job is *done* only here. |

---

## 3. Emotion / friction curve narrative

The curve rises cleanly through **Discover → Start the lead** (Stages 1–2: hope, a
clean first win). It then hits its **first and deepest structural dip at Stage 3**:
the adopter does the one thing the front door told them to do — *brief the lead in
plain language* — and the lead cannot yet execute it end-to-end, because the
orchestration capability is OPEN work. This is not a small annoyance; it is the
promised core experience missing at the exact moment the adopter reaches for it.

The curve then takes its **sharpest observed (not assumed) dip at Stage 5**, the
human credential gate, where WALL-2 (vault scope) blocked progress and required an
undocumented recovery. Stages 4 and 6 are "works, but on trust and with sharp edges"
— cautious climbs punctuated by silent-half-success (Stage 4) and flag/image
fragility (Stage 6). The curve only reaches **delight at Stage 7**, and even there
the full real-cred build was proven separately rather than inside one continuous
adopter run.

**Two dips dominate: Stage 3 (capability/promise) and Stage 5 (reliability/recovery).**
Stage 3 is the more dangerous because it is the *first* deep dip and it is a
promise-vs-delivery gap — the adopter who was told "just talk to the lead" discovers
the lead can't, which poisons trust for every later stage. Stage 5 is recoverable
once documented; Stage 3 is a missing capability, not a documentation patch.

---

## 4. Ranked moments-of-truth and load spikes

**Moments of truth (make-or-break), ranked:**
1. **Stage 3 — "ask the lead to stand up the product."** The front door's core
   promise. A failure here outweighs every downstream friction because it is the
   first deep dip and it is a promise gap, not a bug. *(capability OPEN: lead-5cgv,
   lead-8vxy, create-bc)*
2. **Stage 5 — the human credential gate.** Observed hard wall (WALL-2). Highest
   identity-coupling, least recoverable, real secrets.
3. **Stage 7 — "it actually built the thing."** The job-done moment; high stakes but
   already proven with real creds (iter-7) — risk is "not proven in one continuous
   adopter run," not "doesn't work."

**Cognitive-load spikes, ranked:**
1. **Stage 5** — vault/proposal/scope/credential-format concepts converge at the
   riskiest step.
2. **Stage 6** — flag set + image-pin + brokered-clone mechanics at once.
3. **Stage 2** — first lead-vs-BC / image / container concept load (mild; early but clean).

---

## 5. Selection — the build-trap gate (a CUT, not a picture)

### THE single highest-priority moment to fix (stated as a problem, not a solution)

> **At Stage 3 — the moment the adopter does exactly what the front door instructed
> ("just brief the lead in plain language to stand up your product") — the lead
> cannot yet carry the request through to a standing product. The promised
> lead-orchestrated bootstrap is a missing capability, not a documentation gap: the
> lead is a router with no skill that takes a plain-language "stand up my product"
> and drives services-up → broker-provision (through the human gate) → first-BC
> create/launch. The adopter is silently dropped into the manual 6-step walk the
> front door told them they would not have to run.**

This is the right cut because it is (a) the **first deep dip**, (b) a **moment of
truth** (the core promise), and (c) a **promise-vs-delivery gap** that poisons trust
for all later stages — outranking even the observed WALL-2, which is recoverable and
documentable. Per the JTBD lens, it sits on the **acute** P1 pain. Per the journey
lens, fixing the highest-friction *moment of truth* beats fixing whatever surfaced
first or loudest.

This problem statement is ready to hand to `problem-framing-canvas` / a PDR as the
next step (once dave picks the bet). **No solution is committed here** — whether the
fix is the `stand-up-product` lead skill, a different decomposition, or a narrower
"honest-handoff" lead behavior is the PDR's call.

### Real-but-NOT-selected frictions (explicitly deferred)

- **WALL-2 / human-gate reliability (Stage 5, P2).** Real and acute, but recoverable
  and partly documented; the vault-scope fix is in flight. Touched by **lead-sfme**
  (shop-shell CA reach), **lead-9qdn** (vault scope, prior), **lead-8vxy** (make
  provision lead-driveable — overlaps the selected problem's solution space but is
  scoped as the gate-reliability slice).
- **Silent half-success (Stage 4, P3).** `.env`-not-gitignored is beaded **lead-7if5**;
  `agent-vault-check` overstatement left as non-blocking. Real but low-stakes relative
  to a missing capability.
- **Stale/incomplete commands & image lag (Stages 2/6, P4).** Beaded **lead-2xi3**
  (`:latest` lag) and fixed inline in INSTALL Step 6a. Mechanical, not a moment of truth.
- **Vocabulary load before first win (P5).** Real, but the doc already mitigates it and
  it is diffuse — not a single fixable moment.
- **One-continuous-real-cred run through Stage 7 (unvalidated).** Worth a bounded cold
  walkthrough but the underlying capability is already proven (iter-7); this is
  verification debt, not a capability gap.

**Beads already touching the selected problem (named, NOT dispatched):**
`lead-5cgv` (stand-up-product lead skill — the most direct), `lead-8vxy` (lead-driveable
provision), and the create-bc orchestration capability are the existing surface; the
PM-skills-pruning regression `lead-1e8d` and ops-drift `lead-94mn` are adjacent
correctness risks for *this* instance, not the adopter journey.

### What is marked `unvalidated` (with its bounded check)

- **Stage 1 (Discover) emotion** — no observed discover-stage trace. *Check:* fresh
  reader reaction to the entry doc.
- **Stage 3 lead-driven orchestration** — the 2026-06-15 trace ran the orchestration
  *manually*; no recorded run of a real lead executing the §2 plain-language brief
  end-to-end. *Check:* a cold walkthrough that issues the plain-language brief to a
  real lead and records whether it can execute it. **(This check is also the
  acceptance probe for the selected problem.)**
- **Stage 7 continuous real-cred run** — assign→read proven cold; build→reconcile
  proven only separately (iter-7) and only under real creds in a non-continuous run.
  *Check:* one continuous real-cred cold run through Stage 7.
