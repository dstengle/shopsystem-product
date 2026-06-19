# Lead-architect pre-state verification discipline (two refinements)

Two disciplines that belong in the canonical **lead-architect role template**
(shipped by shopsystem-templates; the lead's `.claude/agents/lead-architect.md`
+ lead-primer are POURED instance copies). Recorded here as the lead-owned
decision; durable landing requires `request_maintenance → shopsystem-templates`
(role-template prose). Recorded 2026-06-19 from lead-4r39 and lead-n64d.

## 1. "Constant X consumed by function Y" → verify against Y's BODY (lead-4r39)

Surfaced by lead-rfc5 (2026-06-12): a dispatch PRE-STATE asserted
`BC_NAME_RE` (manifest.py:34) was "consumed by `validate()` at :170" and thus
gated the CLI. In fact `validate()` never referenced it — the constant was
DEAD CODE, only asserted in `tests/conftest.py`. So the change was net-new
behavior dressed as a tightening. Outcome was fine (the BC wired the check
into `validate()` with revert-teeth binding the actual call site), but a
less-careful implementer could have parameterized the dead constant and
shipped a no-op.

**Discipline.** When an architect pre-state claims "constant/value X is
consumed by function Y" (and uses that to classify the surface as
pinned-existing vs net-new), confirm it against **Y's body**, not merely X's
presence. Presence of a constant is not evidence it is live. If Y does not
reference X, the surface is net-new (`assign_scenarios`), not a tightening
(`request_bugfix`); and revert-teeth must bind the actual call site, not the
dead definition. (This is the contract/artifact-surface analogue of ADR-018:
the "body" here is the lead-visible artifact text / BC-reported demonstration,
never lead-side execution of BC source.)

## 2. Canonical-template pre-state from PACKAGE DATA, not the local primer (lead-n64d)

Surfaced by lead-f3gm (2026-06-12): a `request_bugfix` revising a canonical
template described DELTA EVIDENCE that did not match canonical
`claude/lead.md` on origin/main — it claimed the PRIME DIRECTIVE block was
entirely absent (in fact misplaced after the SHOP_NAME heading) and claimed
the older prohibition-framed choice-suppression body (in fact already
partially reframed). The acceptance pins were genuinely unmet so the BC
reached them idempotently, but the DELTA EVIDENCE described a partly-satisfied
pre-state.

**Root cause.** The architect computed the pre-state delta against the lead
shop's LOCAL `.claude/canonical/lead-primer.md` copy (a derived/POURED
artifact, the intended end-state / pour SOURCE), which had drifted ahead of
what canonical package data carried.

**Discipline.** When composing a `request_bugfix` (or any dispatch) that
revises a CANONICAL template (`claude/<shop>.md`, `lead-architect.md`,
`lead-po.md`, `bc-*.md`), recompute pre-state from **actual package data at
compose time** — the installed canonical template the BC will edit
(`shop-templates show <role>` / installed `claude/lead.md` package file)
reconciled with the BC's last reported origin/main commit — NOT the lead
host's local poured primer copy. Cite the package-data pre-state in DELTA
EVIDENCE, distinct from the pour-source intent.

**Caveat.** Installed package data may itself lag the BC's origin/main (per
ADR-018 the lead cannot git-observe the BC tree). So "package data at compose
time" = installed package data + the BC's last reported origin/main, and the
DELTA EVIDENCE should note when these diverge.

---

**Template-landing status:** both disciplines need
`request_maintenance → shopsystem-templates` to land in the canonical
lead-architect role-template prose. Flagged on lead-4r39 and lead-n64d; NOT
dispatched here (router batches dispatches).
