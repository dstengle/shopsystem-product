---
name: discovery-interview-prep
description: Design a customer discovery interview plan — research goal, target segment, access constraints, and a bias-resistant question set — so a discovery-dialogue turn produces real learning instead of confirmation. Use when the intent record rests on an assumed job that needs to be heard from a real user.
---

# Discovery Interview Prep (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** discovery-dialogue · **Emits into:** intent record (`intent/intent-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `discovery-dialogue` PM session; its output lands in the intent record. It has no terminal artifact of its own.

*Adapted, with permission, from [`deanpeters/Product-Manager-Skills/skills/discovery-interview-prep`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/discovery-interview-prep) by [Dean Peters](https://www.linkedin.com/in/deanpeters/) — fetched live 2026-07-10, direct-grant terms per [ADR-066](../../adr/066-direct-grant-from-dean-peters-authorizes-mit-ingestion-of-deanpeters-derived-pm-skills-attribution-required.md). Adaptation rules + experimental status: [`../README.md`](../README.md).*

## When to reach for it

The dialogue keeps hitting an **assumed job or pain** — something intent depends
on but nobody has heard a real user say. This lens prepares the interview that
would validate it, so the assumption converts to evidence instead of riding into
a build unexamined.

## The lens (four adaptive questions — run interactively)

PM mode is interactive: work these with the product authority live, letting each
answer reshape the next. This skill *prepares* an interview; the authority is the
one who knows who can be reached and what is already assumed.

1. **Research goal** — validate a problem, explore jobs-to-be-done, investigate
   churn, or prioritize? The goal picks the method.
2. **Target segment** — who exactly: people living the problem now, recent
   switchers, churned users? Precision here is what separates signal from noise.
3. **Constraints** — access reality: limited availability, existing base only,
   cold outreach, or proxy research? Constraints are honest inputs, not excuses.
4. **Methodology** — Mom-Test-style validation (ask about past behavior, never
   hypotheticals), JTBD/switch interviews, or journey mapping.

Output a small plan: opening/core/closing frame, 5+ method-specific questions with
follow-ups, and the bias warnings (no leading questions, no "would you use X",
no hypotheticals). Target depth over breadth — 5–10 people, not a survey.

## Input fork (method identical; who you interview differs)

- **Consumer product (primary):** real end customers and switchers; the plan
  recruits from support tickets, reviews, or a research panel.
- **Framework-as-product (bootstrap/meta):** the "interviewees" are adopters,
  operators, or BC-shop agents; the "Mom Test" becomes asking about the last time
  they actually stood up or wired a shop, not whether they'd like a feature.

## Emits into the intent record

Build is ~free, so the gate is the point. This skill does not itself run the
interview — it hardens the record:

- Each assumption the interview targets is logged on the record's **Open
  threads** as an open validation question, with the segment that would
  answer it.
- Findings, once gathered, either promote an assumed job to the record's **goal**
  or retire it into **non-goals**.
- An assumption too costly to validate before build becomes an explicit
  **failure condition** the intent is accountable to. Never launder an untested
  assumption as fact.
