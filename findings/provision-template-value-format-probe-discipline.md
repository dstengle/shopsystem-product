# Discipline: brokered-CLI provision templates need a live-broker (or recorded-fixture) value-format probe

Date: 2026-06-19 (recorded from lead-x33e / lead-l95x mechanism_observation)

## The lesson

`--help` / syntax verification of a brokered CLI (e.g. `agent-vault`) is
**necessary but NOT sufficient** for provision-contract correctness. Verb
existence and flag names pass a green syntax gate while **value-format
constraints** — key casing, value shape, enum values — silently wall the
LIVE broker.

Concrete instance that explains the dummyco-spike iter-2 -> iter-4 grind:
the BC syntax-verified every provision verb under lead-beym against
`agent-vault --help` (verbs + flags existed; gate passed green) — yet
kebab-case credential keys still failed at runtime. `agent-vault 0.32.0`
enforces `SCREAMING_SNAKE_CASE` credential keys at runtime but does NOT
document that in `vault credential set --help`. The constraint is
undiscoverable from `--help` alone.

## Why it matters to templates

`shop-templates` ops templates (compose, shop-shell, agent-vault-provision,
agent-vault-check) encode such broker constraints **by copy** — they
silently inherit any format rule `--help` omits. A template that emits a
kebab key will pass every syntax check and still fail the first live run.

## Proposed discipline

Future provision/credential template work — and the BC verification gate
that precedes it — should include a **live-broker or recorded-fixture
value-format probe** step that exercises the actual key/value shape against
a real (or recorded) broker, not just `--help` syntax. This is exactly the
class of defect that only an e2e run surfaces, which validates the dummyco
spike's purpose.

A recorded-fixture of `agent-vault` provision (capturing the
SCREAMING_SNAKE_CASE enforcement and any enum constraints) would make a
good reusable test asset.

## Routing

This is **role-template / BC-verification discipline**, not lead-instance
config. If formalized into the canonical bc-implementer verification gate
or the shop-templates ops-template authoring guidance, it routes as a
`request_maintenance` / `request_bugfix` to **shopsystem-templates** (the
template owner) — NOT a hand-edit on the lead host. Recorded as a finding
here; flag a templates dispatch if/when the team decides to bake the probe
step into the canonical gate.

Relates: lead-beym, lead-l95x, lead-jdfb, lead-g19j (ADR-026 D2 sharpening).
