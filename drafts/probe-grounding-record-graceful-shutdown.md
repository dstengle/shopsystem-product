# Grounding record — graceful BC shutdown vehicle

## Decision

Deliver graceful BC shutdown as **(a) a new inter-shop message type** — a `shutdown` vehicle that a *still-running* BC agent receives and answers by running its session-close protocol, then exiting. This is the one genuinely new capability: `bc-container` already owns container teardown (option c is the *hard-kill* half, not the graceful half), and no existing message vehicle carries "wind down and exit" semantics, so option (b) reuse is precluded. The complete mechanism composes the new message (a) with a `bc-container` teardown (c) under an orchestrating skill; the recommendation names (a) as the vehicle that must be *authored*.

## How to trust this (read first)

- **Verified:** 5 facts, each re-runnable — section A.

- **Discretionary:** 3 relevance judgments to scrutinize — section B.

- **To trust it:** re-run section A; sanity-check that section B picked the right *set* — the weakest link is that I selected relevant decisions by scanning `type`-facet titles (the `tag` facet is empty), so I cannot prove I did not miss a shutdown-bearing decision hiding under a broad fabro/lifecycle title.

## A. Verified grounding (re-runnable)

### A1 — The message catalog has no shutdown/lifecycle vehicle; a new vehicle is required.

- **Command:** `shop-knowledge render adr-015 --corpus /workspace` (context paragraph) + `BEADS_DIR=/workspace/.beads bd show lead-4qqn` (empirical pre-state line).

- **Result:** ADR-015 enumerates the catalog: `assign_scenarios`, `request_bugfix`, `request_maintenance`, `clarify`, `work_done`, `mechanism_observation` (+ `nudge` added by that ADR; pull vehicles `request_completion_journal` / `request_scenario_register` added later). Bead lead-4qqn records "EMPIRICAL PRE-STATE (verified 2026-07-06): shop-msg send has NO shutdown/lifecycle vehicle today ... -> a new message vehicle is required." No existing type expresses "exit gracefully."

### A2 — shop-msg is transport + wakeup + liveness, never a lifecycle store; and a down container has no listener.

- **Command:** `shop-knowledge render pdr-010 --corpus /workspace`

- **Result:** PDR-010 (accepted) fixes shop-msg's role as "transport + wakeup + liveness" and states messaging "was never meant to carry strategic intent." Class B: "BC has no agent running at all. The container is down and a carrier does nothing, because there is no listener." This is the load-bearing constraint: a shutdown *message* only works while the agent is still up to consume it — it is precisely the running→exited transition, not a post-mortem signal. It also confirms that once the agent is gone, the *teardown* cannot be a message (nothing drains it) and must be a container primitive.

### A3 — bc-container is the container-lifecycle owner and already scopes a `stop` companion; a lifecycle op routed through shop-msg is a "category error."

- **Command:** `shop-knowledge render pdr-004 --corpus /workspace --view transformation`

- **Result:** PDR-004 commits `bc-container launch` "(with companion attach, inject, monitor, stop, status, list)" — so container *stop/teardown* is already an anticipated `bc-container` primitive owned by `shopsystem-bc-launcher`, not a new message. PDR-004 explicitly distinguishes the command from messaging ("shop-msg routes messages; this command routes containers") and calls `shop-msg container launch` "a category error." This is why the teardown half is option (c), and only the graceful-signal half needs a new vehicle.

### A4 — Precedent: author a distinct vehicle when the semantic job differs; do not overload an existing type with a sub-reason.

- **Command:** `shop-knowledge render pdr-029 --corpus /workspace` and `shop-knowledge render adr-015 --corpus /workspace` (alternatives section).

- **Result:** PDR-029 (accepted) chose a distinct `request_scenario_register` over extending `request_completion_journal`, rationale "Different questions, different answers." ADR-015 rejected "extend `clarify` with a `nudge` sub-reason" because the two semantics "deserve distinct catalog entries." A graceful-shutdown instruction (terminal, triggers session-close, agent exits) has semantics distinct from every existing type — including `nudge`, whose intent is "get the system moving *again*"; overloading it with a "please die" reason inverts that. Precedent favors (a) a distinct type over (b) reuse.

### A5 — The container-primitive family is a real, edge-linked cluster distinct from the message catalog.

- **Command:** `shop-knowledge navigate pdr-004 --corpus /workspace --direction both` and `shop-knowledge navigate adr-015 --corpus /workspace --direction both`

- **Result:** PDR-004 is `derived-by` adr-004 (`shopsystem-bc-launcher` as a BC), adr-050 (fabro launch-interface parity / engage-tier), brief-004 ("BC container isolation"), pdr-020 (bc-container-launched shell) — a coherent container-lifecycle cluster. ADR-015 is edge-coupled to PDR-010 only (`derives-from`/`derived-by`), reinforcing that the message catalog and the container surface are two different subdomains — the shutdown mechanism must therefore straddle both, not collapse into one.

## B. Discretionary grounding (scrutinize)

### B1 — I treated `nudge` (ADR-015) as the closest analogical precedent for "add a new operational message type."

- **Why relevant (my judgment):** `nudge` is the only prior case of the catalog growing a new *operational* (non-work-dispatch) primitive, so its accept/reject reasoning is the best template for evaluating a `shutdown` type. I used its rejected "Option A" (don't overload) as the argument against option (b).

- **Unverifiable because:** the analogy itself is a judgment — `nudge` is a *liveness* ping (agent keeps going) while `shutdown` is *terminal* (agent exits); whether they are truly parallel operational primitives is my call, not a fact. With no freeform search I could not enumerate *all* operational-primitive precedents to check `nudge` is the right comparator; I picked it because the `type=adr` facet surfaced its title.

### B2 — I concluded no existing accepted/proposed decision already fixes a shutdown vehicle.

- **Why relevant (my judgment):** if a shutdown/lifecycle decision already existed, the recommendation would be to follow it, not to author (a). I read the full `type=adr` and `type=pdr` title lists (accepted + proposed + superseded all appeared) and saw none naming shutdown/lifecycle-exit.

- **Unverifiable because:** the `tag` facet returned `[]` (empty), so I could not facet on a "lifecycle" or "message-catalog" tag — relevance rested entirely on eyeballing titles. A shutdown decision could be buried inside a broadly-titled fabro/lifecycle ADR (e.g. adr-050 "engage-tier replacement", adr-048 fabro substrate) whose title I judged non-decisive without rendering it.

### B3 — I judged the proposed fabro ADRs (adr-048 / adr-050 / adr-058) as out of decisive scope.

- **Why relevant (my judgment):** the bead flags that BCs now run under fabro, so the *teardown* half must account for fabro-orchestrated shops; fabro's launch/engage-tier decisions could bear on how (c) is realized.

- **Unverifiable because:** these are `proposed` (would need `--view transformation`) and I did not render them — a 1-hop navigate from PDR-004 surfaced adr-050's title only. Whether fabro changes the *vehicle* choice (vs. only the teardown implementation) is unverified; I assumed it changes only (c)'s realization, not the (a) recommendation.

## C. Coverage gaps

- **`tag` facet is empty** (`query --facet tag` → `[]`), and `status`-facet queries also returned `[]` for the values tried — so ALL relevance selection came from `type`-facet title scans plus 1-hop edge navigation. No semantic-tag path exists to corroborate the selection.

- **Proposed fabro decisions (adr-048/050/058) not rendered** — the fabro teardown/engage seam is unexamined; it could reshape the container-primitive (c) half of the composed mechanism.

- **Cannot prove the negative.** With no freeform search permitted, "no existing vehicle fits" rests on the ADR-015 catalog enumeration + the bead's pre-state line, not an exhaustive corpus sweep.

- **a/b/c is not mutually exclusive.** The bead's own framing is a *composition* (shutdown message + bc-container teardown, wrapped in a skill). The recommendation picks (a) as the new vehicle to author; it is not a claim that (c) is unused.

## Ratio

- **A (verified):** 5  ·  **B (discretionary):** 3
