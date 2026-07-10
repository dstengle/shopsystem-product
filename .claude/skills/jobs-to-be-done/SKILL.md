---
name: jobs-to-be-done
description: Uncover the stable job a user is hiring the product to do — functional, social, emotional — plus their pains and gains, so intent anchors on a validated job instead of a feature request. Use during the discovery-dialogue when a request smells solution-shaped ("add X").
---

# Jobs-to-be-Done (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** discovery-dialogue · **Emits into:** intent record (`intent/intent-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `discovery-dialogue` PM session; its output lands in the intent record. It has no terminal artifact of its own.

*Adapted from [`deanpeters/Product-Manager-Skills/skills/jobs-to-be-done`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/jobs-to-be-done) — fetched live 2026-07-10. Adaptation rules + experimental status: [`../README.md`](../README.md).*

## When to reach for it

A request arrives shaped as a solution ("add a dashboard", "support webhooks").
JTBD recovers the **job underneath** — what the user is trying to accomplish and
why — so intent anchors on a stable job, not on the requester's guessed solution.
Per Christensen: users "hire" a product to do a job and "fire" it when something
does the job better. The job is stable; solutions churn.

## The lens (run it as a dialogue — keep the turn open)

PM mode is interactive: ask, listen, sharpen, ask again. Pull the request apart
into three solution-agnostic, verb-driven layers, probing with the product
authority at each:

- **Jobs** — *Functional* (the task: "reconcile month-end expenses"), *Social*
  (how they want to be seen: "look reliable to the team"), *Emotional* (the state
  sought/avoided: "trust the numbers are right"). Ask for a switch-story — when
  did they last reach for something else, and why?
- **Pains** — obstacles, costliness (time/money/effort), frequent preventable
  mistakes, problems today's solution leaves unsolved.
- **Gains** — what would exceed today's solution, the savings that would delight,
  what would make them switch.

Then **rank pains by intensity** — acute vs. mild — with the authority in the
loop. That ranking is the raw input to what's worth building.

## Input fork (lens identical; inputs differ)

- **Consumer product (primary):** real end-customer jobs from interviews,
  switch-stories, tickets, reviews. Social/emotional jobs are load-bearing —
  people adopt on perception and feeling, not only function.
- **Framework-as-product (bootstrap/meta):** the "user" is the framework adopter,
  operator, or a BC shop. The job is "what is the adopter hiring shopsystem to
  do" (e.g. *"stand up a coordinated multi-BC product without hand-wiring
  messaging"*). Pains are developer-experience pains; the "switch interview" is
  why they'd reach for a competing framework.

## Emits into the intent record

Build is ~free, so the gate is the point. The dialogue must end by sharpening
what's worth building:

- The acute functional job + its top-ranked pain → the intent record's **goal**.
- Jobs the request touches but that are not worth serving → **non-goals**.
- "The job is not done unless…" → the intent's **failure conditions**.
- Any job that is **assumed, not validated** is marked so, and either resolved by
  a further dialogue turn with the authority or parked as a research note on the
  record. A fabricated, unvalidated job is worse than none.
