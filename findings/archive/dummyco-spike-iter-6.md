> **ARCHIVED** — historical spike record, not current state (ADR-065). Superseded by: no dedicated graduation ADR — throwaway WS-0/PDR-018 MVP-gate iteration; the MVP gate itself closed in a later iteration under the same epic (lead-jdfb).

# Findings — dummyco instantiation spike, iteration 6 (THE MVP gate: BC launch + §6.4 loop)

**Spike bead:** lead-jdfb (WS-0, PDR-018 — THE MVP gate). **Iteration:** 6 (the
post-human-gate run: the broker now holds the real CLAUDE_OAUTH + GITHUB_PAT, so
conditions 4–10 — BC launch + the §6.4 reconciliation cycle — are reachable for
the first time). **Date:** 2026-06-15.

**Verdict (headline):** *the gate is SUBSTANTIALLY CLEARED with two genuine
genericity walls beaded — NOT a clean pass yet.* A single dummyco BC was stood up
from the provisioned dummyco state via the documented path, cloned brokered
through its OWN broker under the dummyco slug, ran Claude through that broker, and
the lead dispatched `assign_scenarios` under the dummyco slug into an address the
BC reads — the §6.4 transport leg closed. Two walls block a *clean* condition-2/5
pass: WS-1.1 (`shop_msg` `SYSTEM_SLUG` hard-code projects every dummyco address to
`shopsystem/<name>`) and a WS-2 provisioning gap (the broker had no `claude-api`
service so Claude 401'd until the mapping was added via the agent-vault tool).
Both are beaded; neither was hand-patched into code to fake the gate. lead-jdfb
stays `in_progress` — the gate clears clean only after WS-1.1 lands and the run
re-projects under `dummyco/<name>`.

## What the gate is built to catch — and DID catch (the core finding)

PDR-018 condition 2/5: a message to the dummy BC must deposit at an address that
BC reads **under the dummy slug — NOT `shopsystem/<name>`** (the silent-routing
defeat, review finding 2). The spike exercised exactly this and surfaced the
defect at the contract surface:

- bc-launcher correctly **injects** `SHOPMSG_SYSTEM_SLUG=dummyco` into the BC
  container (lead-53y0 unification reached the launcher — verified via
  `docker inspect`).
- But `shop_msg/storage.py:222` defines module-level `SYSTEM_SLUG = "shopsystem"`
  and `_abstract_address_for()` / the registry SQL CASE use it **unconditionally**
  — they never read `SHOPMSG_SYSTEM_SLUG`. The messaging BC (the CONSUMER) was
  never made generic.
- Result: registering `dummyco-product` / `dummyco-greeter` projects to
  **`shopsystem/lead`** and **`shopsystem/dummyco-greeter`**, and the
  `assign_scenarios` dispatch deposited at abstract address
  **`shopsystem/dummyco-greeter`** (verified via `shop-msg dump`).

Transport still round-trips — both lead and BC mis-project *consistently*, so the
BC reads what the lead sends — but condition 2 (distinct identity) is DEFEATED: a
real second product on a shared messaging DB would collide on the
`shopsystem/lead` sentinel. **This is the forecast WS-1.1 P0 wall, now empirically
pinned: lead-ikp5.**

## The empty-start documented path that DID work (conditions 1–4, partial 5–6)

| Step (Brief 011) | Result under the dummyco slug |
|---|---|
| Manifest `product: dummyco` + one BC entry | `bc-container manifest validate` accepts `dummyco-greeter` under the derived dummyco slug (WS-1.3 routing WORKS) |
| `--image` override surface | Present in bc-container v0.3.0 (`--image` > `BC_IMAGE` env > default); WS-1.2 override exists |
| Network auto-derive from `product:` | Launcher auto-derived + created network `dummyco` from manifest `product:` (lead-53y0) |
| Brokered clone via dummyco broker | **Cloned `dstengle/dummyco-greeter` into /workspace** through `<token>:dummyco@dummyco-agent-vault:14322` — brokered git works under the dummyco slug |
| `SHOPMSG_SYSTEM_SLUG` / DSN injection | Container carries `SHOPMSG_SYSTEM_SLUG=dummyco` + `SHOPMSG_DSN=...@dummyco-postgres:5432/dummyco`; reaches both |
| Claude through the dummyco broker | After the WS-2 claude-api fix, Claude Code authenticated + responded through the dummyco broker (real OAuth substitution) |
| Registry projection | **WS-1.1 wall** — projects `shopsystem/<name>`, not `dummyco/<name>` |
| `assign_scenarios` dispatch | Deposited + read back; scenario hash `d501bd7710975ea5` (block-only == wire form — WS-1.5/lead-ji28 did NOT bite this scenario) |

## The trivial real feature (conditions 9/10 scope)

Throwaway dummy BC `dstengle/dummyco-greeter` (private, torn down at teardown).
One genuine scenario (not a no-op echo):

```
Scenario: Greet a person by name
  Given the greeter CLI is installed
  When I run the greeter with the name "Ada"
  Then the output is exactly "Hello, Ada!"
```

Block-only `scenarios hash` = `d501bd7710975ea5`; the `assign_scenarios` wire
payload carried the SAME hash on `scenarios[].hash` (no Feature-line divergence
for this scenario).

## Walls hit -> beads filed (NEW this iteration, all in the SHOPSYSTEM lead registry)

- **lead-ikp5** (P0, shopsystem-messaging) — WS-1.1: `shop_msg/storage.py`
  `SYSTEM_SLUG` hard-coded `shopsystem`; `_abstract_address_for` + registry SQL
  never read `SHOPMSG_SYSTEM_SLUG`. Defeats condition 2/5 distinct-slug
  projection. `request_bugfix`.
- **lead-8jar** (P0, shopsystem-templates) — WS-2: `bin/agent-vault-provision`
  omits the `claude-api` / `claude-platform` / `claude-mcp-proxy` / `github-api`
  broker service mappings the live `fleet` vault has; CLAUDE_OAUTH stored but
  never attached -> BC Claude 401. Unblocked in-spike via the agent-vault tool
  (`vault service add`), NOT a code hand-edit. `request_bugfix`.
- **lead-cs7k** (P1, shopsystem-bc-launcher) — WS-1.2-adj: launcher readiness
  probes (`messaging_db_reachable` / `agent_vault_reachable`) run from the
  launcher HOST against container-network hostnames, so a second-product launch
  (launcher not on the product network) false-fails and gates Claude start +
  prompt injection. Probe-broker-host default `agent-vault:14321` is also a
  shopsystem hardcode coupled to the verbatim runtime-proxy override. Worked
  around in-spike by starting Claude + injecting the prompt manually.
- **lead-9qz5** (P2, docs) — WS-2: fleet-agent vault grant `dummyco:proxy` vs the
  plain vault name; `AGENT_VAULT_VAULT=dummyco:proxy` -> brokered clone 404;
  plain `dummyco` works (matching live `fleet`). Doc/UX gap.
- **lead-71tq** (P2, shop-templates/docs) — WS-2: provision `.env` writeback omits
  `AGENT_VAULT_VAULT` + `AGENT_VAULT_CA_PEM`; both sourced out-of-band for launch
  (CA via `agent-vault ca fetch`). Doc/UX gap.

## In-spike generic unblocks (tool-driven, NOT code hand-edits)

- Added the missing broker service mappings via `agent-vault vault service add`
  (claude-api/platform/mcp) — the SAME verb provision already uses; tracked as the
  shop-templates provision gap lead-8jar.
- Started Claude + injected the session-start prompt manually (the documented
  slow-boot re-inject path, extended to cover the gated Claude START) — tracked as
  the launcher probe gap lead-cs7k.
- Healed the BC's one root-owned `.beads/export-state.json` (recurring BC
  beads-wedge) by chown to vscode — known recurring heal, not a new genericity
  wall.

## Live fleet — undisturbed

The 4 live BCs + `shopsystem-agent-vault-1` + `shopsystem-messaging-postgres-1`
were not touched. dummyco bound its own network (`dummyco`), host ports
(5714/14730/15287), and the new `bc-dummyco-greeter` container is on the `dummyco`
network only. The live `shopsystem` fleet vault was READ (service-shape reference)
but never modified.
