---
name: jobs-to-be-done
description: Uncover the stable job a user is hiring the product to do — functional, social, emotional — plus their pains and gains, so intent anchors on a validated job instead of a feature request. Use during problem discovery, before committing a brief/PDR/scenario, when a request smells solution-shaped ("add X").
---

# Jobs-to-be-Done (adapted, EXPERIMENTAL)

**Discipline 1 — Problem discovery & selection.** Adapted from
`deanpeters/Product-Manager-Skills/skills/jobs-to-be-done`. See
[`../README.md`](../README.md) for the adaptation rules and experimental status.

## Why the PO reaches for this

A request arrives shaped as a solution ("add a dashboard", "support webhooks").
JTBD is the lens that recovers the **job underneath** — what the user is trying
to accomplish and why — so the committed intent anchors on a stable job, not on
the requester's guessed solution. Per Christensen: users "hire" a product to do
a job and "fire" it when something does the job better. The job is stable over
time; solutions churn.

This directly serves Discipline 1's sufficiency criterion: *every committed
intent traces to a validated problem/job, not to a stakeholder feature request.*

## The lens

Pull the request apart into three layers, each solution-agnostic and
verb-driven:

- **Jobs** — *Functional* (the task: "reconcile month-end expenses"), *Social*
  (how they want to be seen: "look reliable to the team"), *Emotional* (the
  state sought/avoided: "trust the numbers are right").
- **Pains** — obstacles, costliness (time/money/effort), frequent preventable
  mistakes, problems current solutions leave unsolved.
- **Gains** — what would exceed today's solution, the savings that would
  delight, what would make them switch.

Then **rank pains by intensity** — acute vs. mild — because that ranking is the
raw input to selection (which problem is worth solving first).

## Lands in our artifacts

- The jobs/pains/gains become the **problem framing in the product brief** —
  the evidence that justifies why an intent is worth committing.
- A sharp functional job + its acute pain feeds a **problem statement** in a
  PDR (pairs well with `problem-framing-canvas`).
- It does **not** by itself produce Gherkin. JTBD justifies *that* we build;
  the scenario (Discipline 4) pins *what behavior* satisfies the job.

## Product-general fork (inputs differ; lens is identical)

- **Consumer product (primary):** real end-customer jobs, from interviews,
  switch-stories, support tickets, reviews. Social/emotional jobs are
  load-bearing — people adopt on perception and feeling, not only function.
- **Framework-as-product (this repo, meta):** the "user" is the **framework
  adopter, the operator, or a BC shop**. The job is "what is the adopter hiring
  shopsystem to do" (e.g. *"stand up a coordinated multi-BC product without
  hand-wiring messaging"*). Pains are developer-experience pains (setup
  friction, unclear contracts). "Switch interview" = why they'd reach for a
  competing framework instead.

## Posture (COMMIT-TO-SPECIFICS, not a workshop)

The source skill runs a human through interview questions and waits. You do not.
Commit the best-evidence job/pain/gain set from what is on the contract surface
and what the operator has said. Where a job is **assumed, not validated**, say so
explicitly — mark it `unvalidated` and either raise a `clarify` to the operator
or open a bounded research task. Never stall waiting for a stakeholder turn the
loop does not have. A fabricated, unvalidated JTBD is worse than none.

## Sufficiency check

- The job is stated **separately from any solution** (verb-driven, not "use X").
- At least one **acute** pain is identified and ranked above the mild ones.
- Each committed intent **traces back to a job on this list** — anything that
  traces to no job is a build-trap candidate; cut it or justify it explicitly.
