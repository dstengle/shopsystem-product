export const meta = {
  name: 'rebaseline-system-analysis',
  description: 'Comprehensive evidence-based analysis of where the shopsystem rebaseline went wrong, scored against externally-derived rating factors',
  phases: [
    { title: 'Evidence and research' },
    { title: 'Rating factors' },
    { title: 'Scoring' },
    { title: 'Adversarial check' },
    { title: 'Report' },
  ],
}

const REPO = '/home/vscode/rebaseline'
const OUT = args && args.out ? args.out : '/tmp/analysis'
const TRANSCRIPTS = '/home/vscode/.claude/projects/-home-vscode-rebaseline'

// Working hypotheses from the authority's own diagnosis. Agents test these; they do NOT assume them.
const CONTEXT = `
## The system under analysis

You are analysing the "shopsystem" — an agent-run software shop that defines
itself. Repository: ${REPO} (branch \`rebaseline\`). It is a definition corpus:
principle sets, artifact typedefs, process definitions, role definitions,
quality guidelines, fitness sets — plus the working artifacts those produce
(initiatives, features, requests, decisions, session records, implementation
guidance). Agents execute the processes; a single human, the product authority,
decides at every approval point and is the only human in the loop.

The rebaseline branch was seeded 2026-08-22 as a clean restart of an earlier
corpus (still on \`main\`). Today is 2026-09-17. In 26 days it has produced a
large definition corpus and has not yet built any software.

The product authority has decided the rebaseline is off course and is
considering a second restart. This analysis informs that decision.

## Working hypotheses — TEST THESE, DO NOT ASSUME THEM

These came from the authority and from one session's observations. Your job is
to confirm, refute, quantify, or complicate each with evidence. A refuted
hypothesis is a valuable finding. Do not go looking only for support.

H1. The corpus is too verbose, and the problem is idea-density (many words
    combined into complex ideas) rather than raw length. Dense rules require
    judgment; judgment-dependent rules get interpreted inconsistently and
    waived.
H2. The principle \`define-good-up-front\` was read as mandating checks, which
    made every process end in a check step and generated most of the process
    mass. Its author intended it as a design principle about being explicit,
    not an operating obligation loaded into every prompt.
H3. The corpus defines "principle" AS "a standing rule", requires binary
    testability, and requires each principle to imply at least one check.
    This structurally excludes guidance-style principles ("use modular
    design"), so the architecture and implementation principle sets contain
    process rules only and say nothing about what a good built artifact
    looks like.
H4. Every constraint in the system can be waived or routed around by the
    thing it constrains: word targets waived by the author as "accepted
    gaps"; artifact tooling bypassed with sed/grep; approval status stamped
    by the maker; in-document fitness screens self-asserted with
    unreproducible passes.
H5. The authority is the bottleneck: dense definitions buy clarification
    rounds that only the authority can resolve, so throughput is bounded by
    one human's attention.
H6. The corpus adopted RFC 2119 / BCP 14 normative keywords (MUST/SHOULD/MAY)
    — a convention whose purpose is removing implementer discretion — into
    documents whose purpose is improving judgment.

Report what the evidence actually shows, including anything that contradicts
the hypotheses and anything important that none of them names.
`

const EVIDENCE_SCHEMA = {
  type: 'object',
  properties: {
    findings: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          claim: { type: 'string', description: 'One sentence stating what is true' },
          evidence: { type: 'string', description: 'Concrete proof: file paths, counts, quotes, ids, dates' },
          severity: { type: 'string', enum: ['critical', 'major', 'moderate', 'minor'] },
          hypothesis: { type: 'string', description: 'Which of H1-H6 this bears on, or NEW' },
          direction: { type: 'string', enum: ['confirms', 'refutes', 'complicates', 'new'] },
        },
        required: ['claim', 'evidence', 'severity', 'hypothesis', 'direction'],
      },
    },
    metrics: { type: 'string', description: 'Raw numbers gathered, as a compact table or list' },
    surprises: { type: 'string', description: 'What you expected to find and did not, or found and did not expect' },
  },
  required: ['findings', 'metrics', 'surprises'],
}

const RESEARCH_SCHEMA = {
  type: 'object',
  properties: {
    factors: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          name: { type: 'string' },
          question: { type: 'string', description: 'The diagnostic question this factor asks of a system' },
          source: { type: 'string', description: 'External source: author, work, year, URL where available' },
          measurement: { type: 'string', description: 'How to score it — observable, ideally countable' },
          why: { type: 'string', description: 'Why this discriminates a healthy system from a sick one' },
        },
        required: ['name', 'question', 'source', 'measurement', 'why'],
      },
    },
    key_sources: { type: 'string' },
    cautions: { type: 'string', description: 'Where this literature is contested, weak, or a poor fit for an agent-run shop' },
  },
  required: ['factors', 'key_sources', 'cautions'],
}

const EVIDENCE = [
  {
    label: 'ev:session-records',
    prompt: `Read every session record in ${REPO}/sessions/ (29 files, including the -cost.md rows).

Build the defect history of this system from its own records. Every session
record carries an Outcome, Open threads, and usually a Corrections table
naming defects found and the work-register bead filed for each.

Determine, with counts and dates:
- Every defect class recorded, when first seen, and whether it recurred.
- Defects found by RUNNING a process versus by reading one. The records
  distinguish these; the ratio matters.
- Open threads that appear in one session and are still open sessions later.
  Which threads never close? Name them.
- How many corrections were filed as beads versus repaired in place.
- Deviations self-reported by the router or the session (there are several).
- What the cost rows show: per-session and per-step cost, and its trend.

Then answer: is the defect rate falling, flat, or rising over the 26 days? Do
fixes stick? Is there evidence that a fix to one artifact ever changed the
definition or prompt that generated the fault?`,
  },
  {
    label: 'ev:work-register',
    prompt: `Analyse the work register. Run \`bd list\` and \`bd show <id>\` in ${REPO}
(the \`bd\` skill is at ${REPO}/.claude/skills/bd/SKILL.md). There are ~283 items;
many predate the rebaseline and belong to the frozen \`main\` corpus and its
infrastructure — separate those from items filed against the rebaseline corpus
itself (rebaseline items were filed 2026-08-22 or later and target paths under
basis/, features/, initiatives/, guidance/, decisions/).

Determine, with counts:
- Rebaseline-era defects by target: which definitions attract the most defects?
- Open versus closed, and age distribution of the open ones.
- Recurrence: defect classes filed more than once against different targets
  (e.g. unreproducible fitness-screen passes, tooling bypassed, stale
  restatements of one fact).
- Defects whose target is a TOOL versus a DEFINITION versus an ARTIFACT.
- How many beads describe something the system could not enforce mechanically.

Then answer: what does the register say about where this system breaks most
often, and is it breaking in new ways or the same ways repeatedly?`,
  },
  {
    label: 'ev:corpus-metrics',
    prompt: `Measure the corpus at ${REPO} quantitatively. Write Python for this; do not eyeball.

Per artifact class (basis/processes, basis/artifacts, basis/roles,
basis/guidelines, basis/fitness, basis/principles*.md, features/, initiatives/,
guidance/, decisions/, requests/, sessions/):
- File count, total words, words per file.
- Document History weight as a share of each file and of the whole.
- Sentence count, mean and median sentence length, share of sentences over 40
  words, share stacking 2+ qualifiers (em-dash, semicolon, parenthetical).
- For process definitions specifically: total words versus the words inside
  \`prompt:\` blocks. The prompt text is the ONLY part that reaches an agent's
  context via the rendered skill; everything else is apparatus. Compute the
  ratio per process and overall.
- Growth over time: use \`git log\` to plot corpus word count by date since
  2026-08-22.
- What is actually loaded into a session's context: .claude/shop/*.md plus
  .claude/skills/*/SKILL.md plus .claude/agents/*.md. Total words, and the
  share of the corpus it represents.
- Cross-document repetition: find sentences or clauses of 12+ words appearing
  in more than one file (single-source-of-truth violations in practice).

Report the numbers plainly. Where a number contradicts H1, say so.`,
  },
  {
    label: 'ev:definition-structure',
    prompt: `Analyse the STRUCTURE of the definitions at ${REPO}/basis/, not their prose.

For all 25 process definitions in basis/processes/:
- Step count; how many steps are checks, screens, verdicts, or approvals
  versus steps that make something.
- How many processes end in a check. How many have a check as their only exit.
- Human steps: which processes require the product authority, and at which
  step. Count the human decision points across the whole flow from a request
  to built software.
- Sub-process depth: how deep does product-flow nest?
- Declared inputs per step (the \`least-context\` principle requires them) —
  and whether the same records are declared over and over.

For the principle sets (basis/principles.md, architecture-principles.md,
implementation-principles.md):
- Count statements using MUST/MUST NOT versus SHOULD versus MAY.
- Classify every statement: does it constrain an ACTIVITY (who must do what,
  when, with what record) or does it describe a property of a BUILT ARTIFACT
  (what the thing itself should be like)? Give the ratio per set.
- Read basis/guidelines/principle-set.md and basis/fitness/principle-set.fitness.md
  and determine mechanically whether a guidance-style principle such as
  "use modular design" or "prefer composition to inheritance" could pass the
  admission bar. Show the specific clauses that admit or exclude it.

For the artifact typedefs: how many required sections does each demand, and how
many of those sections exist to serve a check rather than a reader?`,
  },
  {
    label: 'ev:transcripts',
    prompt: `Analyse the agent execution transcripts at ${TRANSCRIPTS}/*.jsonl.

WARNING: these are large (137MB across all projects, 725 files). Do NOT cat or
read whole files into context. Use \`ls\`, \`wc -l\`, \`grep\`, \`jq\`, and
targeted \`python3\` streaming line by line. Sample where you must, and say what
you sampled.

Look for what agents ACTUALLY did versus what the definitions told them to do:
- Tool bypass: agents using \`sed\`, \`grep\`, \`cat\`, \`python3\` heredocs or
  direct file writes where \`basis/tools/artifact_tools.py\` was the sanctioned
  route. Count occurrences and name the tasks.
- Clarification: places where an agent asked the human a question, held, or
  reported it could not decide. Count them, and classify what kind of ambiguity
  triggered each.
- Rework: the same file edited repeatedly within a run; steps re-run; agents
  correcting a previous agent's output.
- Failures and refusals: steps that could not complete, tools that errored,
  instructions an agent reported as contradictory or impossible.
- Context weight: where measurable, how much of an agent's input was definition
  text versus the artifact it was working on.
- Agents reporting that they did something on their own authority, or
  disclosing a workaround.

Quantify wherever possible. This is the best available evidence of what the
definitions actually cause agents to do, as opposed to what they say.`,
  },
  {
    label: 'ev:velocity-cost',
    prompt: `Measure delivery velocity and cost for the rebaseline at ${REPO}.

Use \`git log\` on branch \`rebaseline\` from 2026-08-22 to 2026-09-17, plus the
cost rows in ${REPO}/sessions/*-cost.md, plus the initiatives in
${REPO}/initiatives/ and features in ${REPO}/features/.

Determine:
- Commits per day; lines and words added versus deleted; rework (files touched
  more than N times).
- Initiatives bet, features authored, features assigned, features delivered —
  with dates. How long does one feature take from bet to delivered? Give the
  distribution, not just a mean.
- From the cost rows: tokens, tool uses and wall-clock per step and per role.
  Which roles and which steps cost most? What share of total cost goes to
  making versus checking versus recording?
- What share of all corpus output is about the system's own governance
  (session records, document histories, cost rows, guidance records, beads)
  versus content that would matter to someone using the product?
- The stated goal on the roadmap was cost per delivered feature falling from
  ~42M context tokens to under 5M. What does the evidence say actually
  happened?

Then answer plainly: at the observed rate, what would it cost and how long
would it take to build one real piece of software through this system?`,
  },
]

const RESEARCH = [
  {
    label: 'res:principles-policy',
    prompt: `Research how principles, policies and design guidance should be written so
they actually guide judgment, and derive rating factors from it.

Cover at least: TOGAF's architecture-principle criteria; Jared Spool on design
principles; Richard Rumelt on strategy kernels versus fluff; Patrick Lencioni's
permission-to-play distinction; the plain-language and legislative-drafting
literature (Bryan Garner, the US Plain Writing Act, the UK Office of the
Parliamentary Counsel drafting guidance); Amazon-style narrative and tenets
practice; Dan Ward or similar on simplicity in system design; and the
distinction in regulatory theory between rules and standards (Kaplow,
"Rules versus Standards"), which is directly on point.

The core question to answer with sources: what distinguishes a principle that
IMPROVES judgment from a rule that REPLACES it, and what does each cost? When
is a bright-line rule correct and when is an open standard correct?

Also cover: RFC 2119 / BCP 14 — what it was designed for, what its authors say
it is for, and whether its use outside interoperability specification is
considered sound.

Produce rating factors a reviewer could apply to a real corpus.`,
  },
  {
    label: 'res:agent-instruction',
    prompt: `Research how instructions, specifications and context should be designed for
LLM agents, and derive rating factors from it.

Cover at least: context engineering and context-window economics; the evidence
on instruction-following degradation with long, dense, or conflicting
instructions; "lost in the middle" and positional effects; specification
ambiguity as a driver of model error; the trade-off between constraining an
agent and letting it generalise; agent-harness design patterns (tool design,
guardrails at the tool boundary versus in the prompt); evaluation of prompt
effectiveness; and what is known about multi-agent handoff and error
propagation.

Search for current sources — this field moves fast, prefer 2024-2026 material,
including Anthropic's own published guidance on writing tools and agent
instructions if you can reach it.

The core questions to answer with sources: does more specification reliably
produce better agent output, or is there a turning point? What kinds of rule
are better enforced by tooling than by prose instruction? What makes an
instruction cheap for a model to follow correctly?

Produce rating factors a reviewer could apply to a real corpus of agent-facing
definitions.`,
  },
  {
    label: 'res:process-quality',
    prompt: `Research how to measure whether a process-and-governance system is healthy or
pathological, and derive rating factors from it.

Cover at least: DORA / Accelerate delivery metrics and what they measure;
the SPACE framework for developer productivity; ISO/IEC 25010 product quality
characteristics; Lean and Theory of Constraints on bottlenecks, WIP and
flow efficiency (value-added time as a share of lead time); Deming on
inspection versus building quality in, and what he actually argued; Goodhart's
law and measurement dysfunction; the literature on bureaucratic accretion and
process ossification in organisations; technical-debt and documentation-debt
measurement; and Shape Up's appetite-and-circuit-breaker model, which this
system claims to use.

The core questions to answer with sources: what distinguishes governance that
produces quality from governance that produces artifacts about quality? What
early indicators show a process system is accreting rather than delivering?
How should a system that has produced no output in 26 days be judged?

Produce rating factors a reviewer could apply, with thresholds or comparisons
where the literature offers them.`,
  },
]

phase('Evidence and research')
log(`Gathering evidence over ${REPO} and researching rating factors — ${EVIDENCE.length} evidence agents, ${RESEARCH.length} research agents, concurrent.`)

const all = await parallel([
  ...EVIDENCE.map(e => () => agent(`${CONTEXT}\n\n## Your assignment\n\n${e.prompt}`, {
    label: e.label, phase: 'Evidence and research', schema: EVIDENCE_SCHEMA,
  })),
  ...RESEARCH.map(r => () => agent(`${CONTEXT}\n\n## Your assignment\n\n${r.prompt}\n\nUse WebSearch and WebFetch freely. Cite sources precisely enough that a reader can find them. Where the literature disagrees, say so rather than picking a side.`, {
    label: r.label, phase: 'Evidence and research', schema: RESEARCH_SCHEMA,
  })),
])

const evidence = all.slice(0, EVIDENCE.length).filter(Boolean)
const research = all.slice(EVIDENCE.length).filter(Boolean)
log(`${evidence.length}/${EVIDENCE.length} evidence agents returned, ${research.length}/${RESEARCH.length} research agents returned.`)
if (evidence.length < EVIDENCE.length || research.length < RESEARCH.length) {
  log(`NOTE: ${(EVIDENCE.length - evidence.length) + (RESEARCH.length - research.length)} agent(s) failed; coverage is incomplete and the report must say so.`)
}

const evidenceDigest = JSON.stringify(evidence)
const researchDigest = JSON.stringify(research)

phase('Rating factors')
const FACTOR_SCHEMA = {
  type: 'object',
  properties: {
    factors: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          name: { type: 'string' },
          question: { type: 'string' },
          measurement: { type: 'string' },
          sources: { type: 'string' },
          weight: { type: 'string', enum: ['foundational', 'major', 'contributing'] },
        },
        required: ['id', 'name', 'question', 'measurement', 'sources', 'weight'],
      },
    },
    rationale: { type: 'string', description: 'Why this set, what was merged, what was dropped and why' },
  },
  required: ['factors', 'rationale'],
}

const factors = await agent(`${CONTEXT}

Three researchers independently derived candidate rating factors for judging a
definition-and-process system of this kind. Their output:

${researchDigest}

Synthesise ONE coherent rating factor set for judging this system. Requirements:

- Merge duplicates across the three researchers; keep the sharpest formulation.
- Between 8 and 14 factors. Fewer, sharper factors beat many overlapping ones.
- Every factor must be OBSERVABLE against a real corpus — countable where
  possible. A factor that can only be judged by taste is not admissible.
- Every factor keeps its external source. This set must not be invented here.
- Weight each: foundational (if this is wrong the system cannot work), major,
  or contributing.
- Cover at least: guidance versus constraint; specification density and its
  effect on both human and model readers; enforceability (prose rule versus
  tooled gate); flow efficiency and bottlenecks; whether quality is built in or
  inspected in; feedback from outcome back to specification; and output
  actually delivered versus artifacts about output.

Return the factor set and your rationale for the shape of it.`, {
  label: 'synthesize-factors', phase: 'Rating factors', schema: FACTOR_SCHEMA,
})

const factorDigest = JSON.stringify(factors)

phase('Scoring')
const SCORE_SCHEMA = {
  type: 'object',
  properties: {
    scores: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          factor_id: { type: 'string' },
          factor_name: { type: 'string' },
          score: { type: 'string', enum: ['healthy', 'strained', 'failing', 'absent'] },
          evidence: { type: 'string', description: 'The specific numbers, files, ids that justify this score' },
          counter_evidence: { type: 'string', description: 'What argues for a better score — state it honestly, or "none found"' },
        },
        required: ['factor_id', 'factor_name', 'score', 'evidence', 'counter_evidence'],
      },
    },
    root_causes: { type: 'string', description: 'The smallest set of underlying causes that explain the most failing factors' },
    what_works: { type: 'string', description: 'What this system genuinely got right and should be carried into any restart' },
  },
  required: ['scores', 'root_causes', 'what_works'],
}

const HALF = Math.ceil((factors.factors || []).length / 2)
const scoreGroups = [
  { label: 'score:first-half', slice: (factors.factors || []).slice(0, HALF) },
  { label: 'score:second-half', slice: (factors.factors || []).slice(HALF) },
]

const scored = (await parallel(scoreGroups.map(g => () => agent(`${CONTEXT}

## The rating factors you are applying

${JSON.stringify(g.slice)}

## The evidence gathered by six independent agents over the real corpus

${evidenceDigest}

## Your assignment

Score the system against EACH factor above, using the evidence. You may read
files at ${REPO} directly to check or extend any claim — do so where a score
turns on something the evidence does not settle.

Rules:
- Cite specific numbers, paths, ids or dates for every score. A score without
  evidence is not a score.
- State counter-evidence honestly for every factor. If the system does better
  than expected on a factor, say so plainly — this analysis is worthless if it
  only finds fault.
- Then name the smallest set of ROOT CAUSES that explain the most failing
  factors. Prefer two or three deep causes to a list of ten symptoms.
- Then name what this system genuinely got RIGHT and that a restart should
  carry forward. Be specific and concrete; "the machinery" is not an answer.`, {
  label: g.label, phase: 'Scoring', schema: SCORE_SCHEMA,
})))).filter(Boolean)

log(`${scored.length}/2 scoring agents returned.`)
const scoreDigest = JSON.stringify(scored)

phase('Adversarial check')
const CRITIC_SCHEMA = {
  type: 'object',
  properties: {
    overturned: { type: 'array', items: { type: 'string' }, description: 'Findings or scores that do not survive scrutiny, each with why' },
    overstated: { type: 'array', items: { type: 'string' }, description: 'Claims that are directionally right but stated too strongly' },
    missing: { type: 'array', items: { type: 'string' }, description: 'What this analysis failed to examine — unread sources, unrun measurements, unasked questions' },
    strongest: { type: 'array', items: { type: 'string' }, description: 'The findings that survive the hardest scrutiny and should anchor the report' },
    verdict: { type: 'string' },
  },
  required: ['overturned', 'overstated', 'missing', 'strongest', 'verdict'],
}

const critique = await agent(`${CONTEXT}

You are the adversarial check on an analysis that is about to be given to the
product authority as the basis for deciding whether to abandon a month of work
and restart. Being wrong here is expensive in both directions: a false alarm
throws away good work, a missed problem repeats it.

## The rating factors
${factorDigest}

## The scores
${scoreDigest}

## The underlying evidence
${evidenceDigest}

## Your assignment

Attack this analysis. Specifically:

1. OVERTURN what does not hold. Check claims against the real corpus at ${REPO}
   yourself — read files, run counts, verify quotes. A claim that misreads a
   document, double-counts, or draws a causal conclusion from a correlation
   must be named.
2. Find what is OVERSTATED — directionally right, rhetorically inflated.
3. Find what is MISSING. What did six evidence agents and three researchers
   fail to examine? Consider especially: is there a reading of this system in
   which it is doing fine and the authority's frustration is mistimed rather
   than well-founded? A corpus built in 26 days by a system defining itself
   may be at a normal stage. Argue that case as strongly as the evidence allows,
   then say whether it stands.
4. Name the findings that SURVIVE the hardest scrutiny.

Default to scepticism. It is better to strike a true finding you could not
verify than to pass an unverified one to a decision this size.`, {
  label: 'adversarial-critic', phase: 'Adversarial check', schema: CRITIC_SCHEMA, effort: 'high',
})

phase('Report')
const report = await agent(`${CONTEXT}

Write the final analysis to \`${OUT}/system-analysis.md\` using the Write tool,
then return a 200-word summary of what it says.

## Inputs

Rating factors:
${factorDigest}

Scores:
${scoreDigest}

Adversarial critique — findings it overturned must NOT appear as findings;
findings it flagged as overstated must be restated at the strength the evidence
supports; what it found missing must be declared as a limit of this analysis:
${JSON.stringify(critique)}

Underlying evidence:
${evidenceDigest}

## How to write it

The reader is the product authority: the single human who decides, who has been
working on this for 26 days, who already suspects the diagnosis and does not
need persuading. He has told this session, repeatedly and correctly, that the
corpus's prose is too dense and too long. Do not reproduce the disease in the
diagnosis.

Requirements:
- Plain language. Short sentences. One idea per sentence. No stacked
  qualifications. If a sentence needs the reader to hold two conditions at once,
  split it.
- Lead with the verdict, then the evidence for it. Never build to a conclusion.
- Every claim carries its number, path, or id inline. No unsourced assertions.
- Include the rating factor table with scores, compactly.
- A section on what the system got RIGHT, of real substance, not a courtesy.
- A section stating this analysis's own limits, from the critique.
- No recommendations section listing options. State what the evidence implies,
  once, and stop. The decision is the authority's and he has not asked for a plan.
- Under 2000 words in the body. Tables do not count toward that.

Write the file, then return the summary.`, {
  label: 'write-report', phase: 'Report',
})

return { report, factors: (factors.factors || []).length, evidenceAgents: evidence.length, researchAgents: research.length, out: `${OUT}/system-analysis.md` }
