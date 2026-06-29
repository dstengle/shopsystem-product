# Brief 013 — A freshly bootstrapped shop comes up healthy: its credentials and connections are wired and checkable, not agent-rediscovered

**Status:** draft (2026-06-29)
**Authors:** dstengle (stakeholder), Claude (lead-po)
**Lead beads:** [`lead-j8so`](#) (BUG — `SHOPMSG_DSN` unset in the launched lead
shell), [`lead-q3r1`](#) (FEATURE — a `doctor` shell command).

**Anchored to** the product-authority statement (2026-06-29), authoritative for
this brief's scope and vocabulary:

> "The lead claude is up but `SHOPMSG_DSN` is not set so it is trying to diagnose
> and work around. This should be fixed and there should be a doctor shell
> command that validates credentials and connections."

**Cross-links (decisions this builds on — NOT re-decided here):**

- [Brief 012](012-adopter-bootstrap-stand-up-product.md) / PDR-019 / ADR-040 —
  the deterministic agent-less Footing that reaches solid footing. This brief is
  the *health* corollary: footing should also leave the launched lead session
  with working credentials and connections, and a way to check them.
- [PDR-020](../pdr/020-lead-shell-is-a-bc-container-launched-bc-base-session.md)
  — the lead shell is a launched `bc-base` session; `bin/shop-shell` transports
  session-scoped values into it.
- [ADR-020](../adr/020-routing-identity-is-abstract-system-name-shop-root-eliminated.md)
  — explicitly named the `SHOPMSG_DSN`-unset plumbing gap (`lead-3lw6` second
  half) as "named, not closed." This brief closes it.

---

## 1. The problem — the lead comes up, but its plumbing is not wired or knowable

On a freshly bootstrapped product the lead Claude shell comes up, but
`SHOPMSG_DSN` is not set in its environment. `shop-msg` therefore cannot reach
postgres on first use, and the agent wastes a turn self-diagnosing and working
around it. The deeper problem is that this is *one instance of a class*: a
bootstrapped shop has several credential/connection preconditions
(messaging-DB, agent-vault broker + CA trust, Claude OAuth) that, when one is
missing, are discovered reactively and ad-hoc by an agent rather than reported
by a deterministic check.

The build economics make this acute: agent turns are the scarce resource, and
spending them on rediscovering a fixed, knowable precondition set is pure waste.

## 2. The job-to-be-done

*When I bring up a freshly bootstrapped shop, I want its credentials and
connections to be wired correctly and checkable in one command, so that the
lead agent can do product work on its first turn instead of self-diagnosing
broken plumbing.*

## 3. The outcome (observable behavior change)

- A freshly-launched lead-shell agent's **first** `shop-msg` call reaches
  postgres — no self-diagnosis, no manual `export SHOPMSG_DSN=...`.
- An operator (or a session-start hook) runs **one command, `bin/doctor`**, and
  gets a named pass/fail per credential/connection plus one aggregate verdict —
  instead of an agent improvising a diagnosis.

Output (a DSN export line, a `doctor` script) is not the measure; the behavior
change — agents stop spending turns rediscovering preconditions — is.

## 4. Scope

**In scope.**

- **`lead-j8so` (bugfix):** the rendered bringup path (`bin/shop-shell`)
  delivers a non-empty `SHOPMSG_DSN`, derived from the single ops-coordinates
  postgres coordinates, into the launched lead-shell session so `shop-msg`
  reaches the product postgres on first use. Pinned by scenario 214.
- **`lead-q3r1` (feature):** a shop-templates-rendered `bin/doctor` command that
  validates credentials and connections and reports a clear aggregate pass/fail
  diagnosis. Decomposed and recorded in
  [PDR-024](../pdr/024-doctor-command-validates-bootstrapped-shop-credentials-and-connections.md);
  pinned by scenarios 215 (messaging-DB), 216 (agent-vault + CA trust), 217
  (`CLAUDE_OAUTH`), 218 (aggregate pass/fail).

**Out of scope / deferred (named, not decided):**

- The `bin/doctor` **update-path** render (parallel to ops-coordinates scenario
  213) — bootstrap-render is pinned; update-render is an architect follow-on if
  wanted.
- **Auto-remediation** — doctor *diagnoses* (name + status + remediation hint);
  it does not auto-fix. A self-healing variant is a separate intent, not this
  brief.
- Any check beyond the three the product authority enumerated; additional checks
  are additive scenarios under PDR-024 D3's diagnosis surface.

## 5. Strategic trace

Both items serve the adopter-footing strategic bet recorded in Brief 012 /
PDR-019: an adopter can stand a product up and have it *work*. A footing that
produces a lead which cannot reach its own message bus, with no way to check
why, undercuts that bet. This brief makes the footing's result healthy and
self-verifying.
