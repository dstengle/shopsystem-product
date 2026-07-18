---
type: intent-record
id: intent-002
title: Operator-configurable, release-independent LLM provider/model selection for fabro
status: recorded
created: 2026-07-14
updated: 2026-07-14
authors: [dstengle, "Claude (acting lead-pm)"]
description: Stakeholder intent for making fabro's LLM provider/model choice an operator-controlled runtime dial instead of a release-gated default, proven via OpenRouter as the first additional provider.
stakeholder: dstengle
session: sess-2026-07-14-a
superseded-by:
beads: [lead-obfub, lead-txhou]
---

# intent-002 — Operator-configurable, release-independent LLM provider/model selection for fabro

## Verbatim anchors

2026-07-14: "It is time to look at using multiple model providers with
fabro, starting with openrouter."

2026-07-14: "Oauth gates are happening really fast and unlikely to be
minimized. I want configurable and dynamic model choices. It should be
possible to select models without requiring software releases."

2026-07-14: "Build with intent for provider selection and build for
openrouter first."

2026-07-14: "Leave the dial with the operator for simplicity."

2026-07-14: "[Config should be] fleet-wide with overrides for
flexibility of testing at least. The possible mechanisms for that
configuration are varied, though."

## The goal behind the ask

fabro-orchestrated BCs need a way to change which LLM provider and
model a node uses **without a software release**. Today that choice is
baked into release-gated artifacts (the poured `workflow.fabro`
model_stylesheet; the launcher's provider-wiring at container-engage
time), so responding to a shift in provider availability costs a full
author → release → rebuild → relaunch cycle. Concretely proven this
session: `lead-txhou` — a haiku default that "got stuck" in a poured
skeleton and stayed wrong until noticed, because nothing short of a
release could change it.

The proximate trigger is the proven root cause of fabro's substantive-
work unreliability: Anthropic gates premium models on a request
carrying the interactive Claude Code system-prompt identity, which
fabro's node requests never carry, producing a misleading
`rate_limit_error`. The stakeholder's explicit prior direction is not
to spoof that fingerprint (ToS), and instead to give fabro a real,
legitimately-accessible additional path — starting with OpenRouter.
But the stakeholder was explicit that OpenRouter is the *first
instance*, not the whole ask: the OAuth-gating pressure "is happening
really fast and unlikely to be minimized," so the durable need is a
provider/model **selection capability**, proven by shipping OpenRouter
through it — not a one-off OpenRouter integration.

## Who it serves

The stakeholder (dstengle), acting as the fleet operator who currently
has no way to react to a gated/unreliable provider except by shipping
a code change. Downstream, every fabro-orchestrated BC benefits from
not depending on a fragile single-provider path.

## Constraints

- Must conform to ADR-049: agent-vault remains the sole credential
  surface under fabro (dummy-on-node/real-on-wire); fabro's native
  vault stays `__PLACEHOLDER__`-only. Any new provider's credential
  path is scoped by this, not re-opened.
- The dial stays **operator-controlled**, not self-reactive. The
  stakeholder explicitly chose simplicity over an auto-fallback/self-
  healing system for this slice: "leave the dial with the operator."
- Config scope is **fleet-wide by default, with overrides** — at least
  enough to let a single BC be pointed at a different provider/model
  for testing without changing the fleet default. The exact mechanism
  is explicitly open (see Open threads) — the stakeholder named this
  as unresolved, not implementation detail I should assume.

## Non-goals

- Automatic/self-reactive provider fallback (detecting a gate/failure
  and switching without operator action) — explicitly deferred, not
  ruled out permanently.
- A general N-provider abstraction with more than OpenRouter proven
  through it, for this slice. OpenRouter is the one provider that must
  actually work end-to-end; the seam should not require re-architecture
  to add a third provider later, but a third provider is not being
  built now.
- Cost/spend observability — related and triggered by this work (moving
  real spend onto per-token billing), but tracked separately as
  [[intent-003]] since it has its own stakeholders-of-concern and will
  shape independently.

## Appetite signal

Not stated numerically. Appetite for implementation to be set at
candidate shaping.

## Failure conditions

- Shipping "OpenRouter support" as another baked, release-gated default
  — that would satisfy the literal ask while missing the actual
  problem (release-gated configuration).
- A configuration mechanism so complex it reintroduces the same
  friction it's meant to remove (e.g. requiring a rebuild to change a
  config file that itself lives in a poured, release-gated artifact).

## Open threads

- **Configuration mechanism** is unresolved — the stakeholder named
  several possible shapes as live options ("the possible mechanisms
  for that configuration are varied") without committing. This is an
  Architect feasibility question for the shaping pass, not a decision
  made here.
- Whether "fleet-wide with overrides" means per-BC granularity only, or
  also per-node-class (e.g. `.coding` vs `.review`) within a BC — not
  probed yet.
- Relationship to `lead-obfub` (existing bead capturing a prior,
  narrower OpenRouter scoping note) and `lead-txhou` (haiku-default bug)
  — both are concrete evidence for this intent and should be
  reconciled/superseded once a candidate is shaped, not left as
  parallel untracked work.
