# Grounding record — graceful BC shutdown vehicle

> **Recommendation:** Build a new `shutdown` message type.
> **Confidence: HIGH** on the message-type choice.  ✓ 4 verified · ⚠ 3 judgment calls · ✗ 3 known gaps.
> **One risk that could flip this (LOW likelihood):** a shutdown vehicle may already exist, hidden inside a broadly-titled decision I did not read (`adr-048`, `adr-050`, `adr-058`).
> **To trust this in one step:** read those three decisions and confirm none already defines a graceful-exit vehicle. Or run the checks below (exit 0 = every verified fact still reproduces).

## Words used here

- **BC** — Bounded Context: a service that runs in its own container and does work for the shop.
- **Message type** — a named kind of inter-shop message (e.g. `nudge`, `work_done`). The shop has a fixed catalog of them.
- **The three options.** **(a)** add a new `shutdown` message type. **(b)** reuse an existing message type. **(c)** use the container system to stop the BC directly.

## Decision

**Build option (a): a new `shutdown` message type.** A still-running BC receives it, finishes its work (session-close: git/bd push), then exits.

- **Not (b).** No existing message type means "wind down and exit." Reusing one would overload its meaning.
- **Not (c) alone.** Option (c) is a hard stop, already owned by `bc-container`. It kills a BC; it does not shut one down gracefully.
- **Full mechanism.** (a) then (c), composed under one skill: the message shuts the agent down cleanly, then the container is torn down. Only the message type (a) is new and must be built.

## ✓ Verified grounding — 4 facts (each is a check, not a summary)

Read down the **Claim** column to pick what to spot-check; run its command; the fact passes if the output **contains** the anchor string.

| # | Claim (what it grounds) | Command (run from anywhere) | Passes if output contains |
|---|---|---|---|
| A1 | The message catalog has no shutdown/exit type today | `shop-knowledge render adr-015 --corpus /workspace` | `nudge` present **and** `shutdown` **absent** |
| A2 | Messaging is transport only — a down BC has no listener, so teardown can't be a message | `shop-knowledge render pdr-010 --corpus /workspace` | `transport`, `wakeup`, `liveness` |
| A3 | Container lifecycle is `bc-container`'s job; routing it through messaging is a stated mistake | `shop-knowledge render pdr-004 --corpus /workspace --view transformation` | `category error`, `stop` |
| A4 | Precedent: add a distinct type when the job is new, don't overload one | `shop-knowledge render pdr-029 --corpus /workspace` | `Different` |

**Re-run all (paste once):**

```bash
set -uo pipefail
C="--corpus /workspace"
render(){ shop-knowledge render "$1" $C ${2:-}; }
fail=0
render adr-015        | grep -q  'nudge'         || { echo "A1a FAIL"; fail=1; }
render adr-015        | grep -qv 'shutdown'       || { echo "A1b FAIL (shutdown unexpectedly present)"; fail=1; }
render pdr-010        | grep -q  'transport'      || { echo "A2 FAIL";  fail=1; }
render pdr-004 "--view transformation" | grep -q 'category error' || { echo "A3 FAIL"; fail=1; }
render pdr-029        | grep -q  'Different'      || { echo "A4 FAIL";  fail=1; }
echo "verified-grounding: $([ $fail = 0 ] && echo PASS || echo FAIL)"; exit $fail
```

## ⚠ Judgment calls — 3 (scrutinize these; I can't prove them by re-running)

| # | The call I made | Why it's relevant | Why you can't re-run it |
|---|---|---|---|
| B1 | Used `nudge` as the nearest precedent for adding an operational (non-work) message type | It's the only prior case of the catalog growing a non-dispatch message | The analogy is my judgment: `nudge` means "keep going," `shutdown` means "stop" — opposite intents |
| B2 | Concluded no existing decision already defines a shutdown vehicle | If one existed, we'd follow it instead of building (a) | I selected decisions by reading titles; the tag filter is empty (see gap #3), so I can't prove I didn't miss one |
| B3 | Set the proposed fabro decisions (`adr-048/050/058`) aside as not decisive | The teardown half must work for fabro-run BCs too | I didn't read them; I assumed fabro changes *how (c) works*, not *which message (a) is* |

## ✗ Known gaps — 3 (ranked by whether they can change the decision)

1. **[CAN FLIP THE DECISION]** A shutdown vehicle might already be defined inside a broadly-titled decision I did not read — `adr-048`, `adr-050`, `adr-058`. This is the one check worth doing before you approve.
2. **[does not change the recommendation]** How teardown (c) works under fabro is unexamined. It affects the *implementation of (c)*, not the choice of (a).
3. **[does not change the recommendation]** The tag filter is empty (`shop-knowledge query --corpus /workspace --facet tag --value <any>` → `[]`), so I could not corroborate my decision-selection structurally — only by reading titles. This is *why* gap #1 exists.
