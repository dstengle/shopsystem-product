---
type: research-report
id: research-prompting-2026-08
status: delivered
version: 1
date: 2026-08-23
question: What should a prompt — and the role and process behind it — contain for an agent to do rigorous research?
requested-by: product-authority
---

# Research report: prompts for doing research

## Executive summary

1. **Rigorous research is a process, not a prompt.** Every serious
   source describes the same shape: plan → gather in parallel →
   extract grounded evidence → synthesize → verify separately →
   report with limitations. A single prompt cannot enforce the
   separation that makes verification work. *(Confidence: high.)*
2. **The expert-persona opener does not help and can hurt.** Two
   2025–26 studies found "you are an expert in X" gave no accuracy
   gain on knowledge tasks and sometimes reduced it; personas help
   tone and alignment, not correctness. *(High.)*
3. **Fabricated references are the dominant failure and prompts
   alone do not stop them.** Measured rates: 19.9% of citations in
   LLM-written literature reviews entirely fabricated, two-thirds
   fake or wrong; 3–13% of URLs in commercial LLM and deep-research
   output hallucinated — and deep-research agents hallucinated more
   than search-augmented models while citing more. Prompt specificity
   did not reduce fabrication. What works: grounding in retrieved
   sources, quotes-before-claims, explicit permission to abstain,
   claim-by-claim citation with retraction, and a mechanical
   existence check on every reference (one tool cut non-resolving
   URLs 6–79×, to under 1%). *(High.)*
4. **Verification must be factored away from the draft.**
   Chain-of-Verification's gain comes from answering verification
   questions independently of the draft so errors are not copied
   forward; a self-review inside the same pass is weaker. *(High for
   the mechanism; effect sizes deliberately omitted — see
   Limitations.)*
5. **An external analytic standard already exists and fits.** The
   US intelligence community's ICD 203 tradecraft standards —
   describe source quality, express uncertainty, separate facts from
   assumptions from judgments, assess alternatives, argue clearly,
   state consistency with prior analysis — are a ready-made
   definition of good for a research role. It also mandates keeping
   *likelihood* and *confidence* apart; the seed prompt's single
   High/Medium/Low scale conflates them. *(High.)*
6. **Confidence labels are only useful if calibrated.** Kent's
   words-of-estimative-probability work exists because uncalibrated
   verbal labels mislead readers; a confidence scheme needs defined
   meanings and a calibration check. *(High.)*
7. **Context engineering shapes the architecture.** Sub-agents
   explore widely and return 1–2k-token distillations; the
   synthesizer never holds the raw haul; identifiers are kept and
   sources re-fetched just-in-time; structured notes persist across
   tool calls. *(High.)*

## Method

Six web searches and nine fetches on 2026-08-23 (US-only search
index), covering: analytic tradecraft standards, vendor prompt
guidance, citation-fabrication studies, verification techniques,
persona-prompting studies, and deep-research agent architectures.
Every claim below names its source; where a source could not be read
in full, the confidence is lowered and the gap is stated. No claim
rests on a source that was not opened.

## Findings

### F1 — Persona openers: no accuracy benefit *(high)*

- Prompting Science Report 4 (arXiv 2512.05858, Dec 2025), six
  models, hard multiple-choice science/engineering/law: matching
  expert personas produced "no significant impact on performance"
  (one model excepted); mismatched personas were marginal or
  harmful; low-knowledge personas harmful. "Persona prompts
  generally did not improve accuracy relative to a no-persona
  baseline."
- The PRISM paper (arXiv 2603.18507, Mar 2026): expert personas
  improved alignment with human expectations but reduced accuracy on
  knowledge-heavy tasks (reported overall 68.0% vs 71.6% baseline on
  one benchmark, from secondary coverage — *medium* for the exact
  figure).
- Implication: open a research prompt with the task, the evidence
  rules, and the output contract — not a persona.

### F2 — Reference fabrication is common and structural *(high)*

- JMIR Mental Health experimental study (PMC12658395, Nov 2025):
  GPT-4o, 176 citations across six reviews — 19.9% fabricated; of
  the real ones, 45.4% contained errors (37.8% wrong DOIs).
  Fabrication tracked topic familiarity (6% → 29%) more than prompt
  design: general vs specialized prompts did not significantly change
  the overall rate, and specialized prompts made one topic worse
  (46% vs 17%).
- Reference-hallucination study (arXiv 2604.03173): 3–13% of
  citation URLs hallucinated, 5–18% non-resolving; deep-research
  agents worse than search-augmented LLMs despite more citations;
  a liveness/existence tool with agentic self-correction reduced
  non-resolving URLs 6–79×, to under 1%.
- Implication: "do not fabricate" is necessary but not sufficient.
  The working controls are positive scaffolds — every claim carries a
  source identifier or an explicit UNSOURCED mark; every reference is
  mechanically checked to exist; abstention is permitted and
  expected.

### F3 — Grounding techniques with vendor backing *(high)*

- Anthropic's hallucination-reduction guidance recommends: permit "I
  don't know"; extract word-for-word quotes before analysis for long
  inputs and base the analysis only on the quotes; cite a supporting
  quote per claim and *retract any claim without one*; restrict to
  provided documents when the task is closed-world; and, as advanced
  measures, chain-of-thought verification, best-of-N comparison, and
  iterative refinement — with the caveat that none eliminates
  hallucination entirely.

### F4 — Factored verification *(high for mechanism)*

- Chain-of-Verification (Dhuliawala et al., ACL Findings 2024):
  draft → plan verification questions → answer them independently
  "so the answers are not biased by other responses" → produce the
  verified response; hallucination decreased across list, QA, and
  longform tasks. The independence of the verification pass is the
  active ingredient.
- Implication for a process: verification is a separate step with a
  fresh context that sees the claims, not the draft's reasoning.

### F5 — An existing standard of good: ICD 203 *(high)*

- Five analytic standards (objective; independent of political
  consideration; timely; based on all available sources; exhibits
  the tradecraft standards) and nine tradecraft standards: source
  quality and credibility; uncertainty and confidence; distinguishing
  facts, assumptions, and judgments; analysis of alternatives;
  relevance; clear argumentation up front; consistency with prior
  analysis; accuracy; visual presentation.
- Likelihood and confidence are distinct and must not be combined in
  one sentence. Kent (1964) established why: verbal probability words
  are read inconsistently unless defined.
- Implication: the role's definition of good can adopt this standard
  nearly whole, per the shop's external-standards-first principle.

### F6 — Architecture and context *(high)*

- Anthropic, context engineering for agents: system prompts at the
  right altitude ("specific enough to guide behavior effectively,
  yet flexible enough to provide strong heuristics"); tools
  "self-contained, robust to error, and extremely clear"; just-in-time
  retrieval via lightweight identifiers; structured note-taking
  outside the context window; sub-agents that "return only a
  condensed, distilled summary (often 1,000–2,000 tokens)".
- Deep-research agent practice (multiple sources): decompose the
  question into parallel search tasks; orchestrator plus specialist
  workers; iterate rounds on interim findings; "the biggest
  performance improvements often come from clearly explaining tool
  usage in the system prompt."

### F7 — Stepwise reasoning instructions *(medium)*

- With thinking-enabled models, reasoning happens at the model level
  and is "much richer than what you'd get by asking Claude to think
  step by step" (Anthropic); forcing deliberate thinking on simple
  tasks can degrade output. Explicit "show your reasoning" remains
  useful as an *auditable artifact* — the reader can check the chain
  — not as a performance lever. *(Medium: the prompting-guidance page
  itself was not readable in this sweep; the claim rests on the
  product announcement and secondary coverage.)*

## The seed prompt, line by line

| Seed element | Assessment | Change |
|---|---|---|
| "You are an expert research analyst with deep domain expertise in [field]" | No accuracy gain; can reduce it (F1). | Replace with the task, scope, and evidence rules. Domain knowledge enters as *sources to consult*, not a persona. |
| "conduct a rigorous analysis of [question]" | Good — names the object. | Keep; add the consumer and the decision the research serves (ICD 203 relevance). |
| "Think step by step before providing your final conclusions" | Redundant for thinking models; useful as an audit trail (F7). | Ask for the reasoning to be *recorded* — facts, assumptions, judgments separated. |
| "Base your analysis strictly on verified facts… state confidence High/Medium/Low" | Right instinct; conflates confidence with likelihood; labels undefined (F5, F6). | Define the scale; separate confidence-in-evidence from likelihood-of-claim; require a source identifier per claim or an UNSOURCED mark. |
| "Identify core themes, conflicting viewpoints, and major gaps or assumptions" | Good — maps to ICD 203 alternatives and assumptions. | Keep; make alternatives a required section, not a passing mention. |
| "Do not assume or fabricate references or metrics" | Necessary, insufficient (F2). | Add the positive scaffold: every reference checked to exist; unverifiable ones marked; abstention permitted. |
| Output: executive summary, bulleted findings, limitations | Good and matches practice. | Add: method, sources with verification status, alternatives considered, what would change the judgment. |

## Recommended design

**Role (researcher).** Default posture: every claim is grounded or
marked; the reader can trace each finding to a source that exists.
Admissible evidence: sources opened in this run, with identifiers;
model knowledge only when labeled as such with lowered confidence.
Decides: the confidence assigned to each finding. Escalates: any
question whose answer would rest mainly on unverifiable knowledge.
Anti-rationalization: "I remember this paper said…" → open it or mark
it; "the numbers looked plausible" → plausibility is not existence;
"the persona will make me more careful" → it will not.

**Process (research inquiry).** Frame (question, consumer, scope,
admissible sources, confidence scheme) → plan (sub-questions, search
tasks) → gather in parallel (workers return distilled notes with
identifiers) → extract (quotes first) → synthesize (findings with
confidence, alternatives, gaps) → verify in a fresh context (claims
only; existence check on every reference; retract or mark) → report
→ cold read for decidability → deliver. Loop exit: a verification
round cap.

**Report (research-report).** Executive summary; method; findings
with confidence and source; alternatives considered; limitations;
sources with verification status; what would change the judgment.

## Limitations

- Two primary papers (2512.05858, 2604.03173) could not be read in
  full — PDF extraction failed; their findings come from abstracts
  and a secondary account, and are marked accordingly.
- The Chain-of-Verification full text was read through a small
  extraction model whose reported numbers contradicted the paper as
  independently remembered; the numbers are omitted and only the
  abstract-level claim is used. This is itself an instance of the
  failure mode under study.
- Search index was US-only; one afternoon's sweep, not a systematic
  review; no attempt at completeness across vendors' guidance.
- The recommended design is untested. Per the shop's
  feedback-loops principle, its first runs need a calibration sample
  (grade a set of findings' confidence labels against later
  verification) before the confidence scheme is trusted.

## Sources (opened this run)

- ICD 203 overview: https://legalclarity.org/icd-203-analytic-standards-for-all-source-intelligence/
- ODNI objectivity page: https://www.dni.gov/index.php/how-we-work/objectivity
- Kent, Words of Estimative Probability (overview): https://en.wikipedia.org/wiki/Words_of_estimative_probability
- Prompting Science Report 4 (abstract): https://arxiv.org/abs/2512.05858
- PRISM persona study (via secondary coverage): https://arxiv.org/pdf/2603.18507 ; https://www.theregister.com/2026/03/24/ai_models_persona_prompting/
- JMIR Mental Health citation-fabrication study: https://pmc.ncbi.nlm.nih.gov/articles/PMC12658395/
- Reference hallucination detection (abstract): https://arxiv.org/abs/2604.03173
- Chain-of-Verification (abstract; full text unreliable extraction): https://arxiv.org/abs/2309.11495 ; https://aclanthology.org/2024.findings-acl.212/
- Anthropic, Reduce hallucinations: https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/reduce-hallucinations
- Anthropic, Effective context engineering for AI agents: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- Anthropic, Claude 3.7 / extended thinking announcement (via search summary): https://www.anthropic.com/news/claude-3-7-sonnet
- Deep research agent context-engineering guide: https://www.promptingguide.ai/agents/context-engineering-deep-dive

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-23 | update | Authored from a six-search, nine-fetch sweep; delivered to the product authority with the seed prompt assessed line by line. |
