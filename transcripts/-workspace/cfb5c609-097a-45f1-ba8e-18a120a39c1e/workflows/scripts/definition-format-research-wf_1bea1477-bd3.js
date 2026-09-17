export const meta = {
  name: 'definition-format-research',
  description: 'Survey external best practice for definition formats, quality guidelines, and qualitative fitness testing; evaluate the Gherkin-fitness proposal; produce cited sitting material',
  phases: [
    { title: 'Survey', detail: '5 parallel area surveys with citations' },
    { title: 'Verify', detail: 'per-area source verification' },
    { title: 'Synthesize', detail: 'compose drafts/definition-format-research.md' },
    { title: 'Critique', detail: 'completeness pass' },
  ],
}

const CTX = `CONTEXT (include none of this as findings; it frames fit): We operate an LLM-agent-run product-development system ("shopsystem") that is re-founding its quality layer on the principle that construction definitions precede checks: every activity gets (a) an explicit definition of good construction compiled into the generating agent's context (role prompts define standing identity/cross-activity clarity; discrete skills capture individual activities), and (b) mechanical checks and review rubrics DERIVED from those definitions. We must choose FORMATS for a seed layer: process definitions (definition-level, NOT a workflow-engine prescription; must carry expected outcomes/outputs and resulting actions, including termination for long-running loops), role definitions, artifact/document-type schema definitions, principle statements, content-quality guidelines, and SMALL qualitative fitness-test sets for non-deterministic LLM-generated output. STRONG PREFERENCE: adopt established external standards/forms rather than inventing bespoke ones; bespoke requires justification. EVIDENCE BAR: primary sources and named methodologies/standards (not just popularized books); separate DESCRIBING a practice from RECOMMENDING its adoption; never cite a source you have not confirmed exists. You have web access: if WebSearch/WebFetch are not already available, load them via ToolSearch with query "select:WebSearch,WebFetch".`

const FINDINGS = {
  type: 'object', additionalProperties: false,
  required: ['area_summary', 'findings'],
  properties: {
    area_summary: { type: 'string' },
    findings: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['name', 'tradition', 'source_type', 'citation', 'what_it_defines', 'form_elements', 'fit_notes', 'adopt_potential'],
        properties: {
          name: { type: 'string' },
          tradition: { type: 'string' },
          source_type: { enum: ['standard', 'framework', 'book', 'paper', 'tool', 'practice'] },
          citation: { type: 'string' },
          url: { type: 'string' },
          what_it_defines: { type: 'string' },
          form_elements: { type: 'array', items: { type: 'string' } },
          fit_notes: { type: 'string' },
          adopt_potential: { enum: ['adopt', 'adapt', 'context-only', 'reject'] }
        }
      }
    }
  }
}

const VERIFY = {
  type: 'object', additionalProperties: false,
  required: ['checks', 'overall_notes'],
  properties: {
    checks: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['name', 'exists', 'accurately_described', 'corrections'],
        properties: {
          name: { type: 'string' },
          exists: { type: 'boolean' },
          accurately_described: { type: 'boolean' },
          corrections: { type: 'string' }
        }
      }
    },
    overall_notes: { type: 'string' }
  }
}

const AREAS = [
  { key: 'process-role-artifact-metamodels', prompt: `${CTX}

TASK: Survey established meta-models and standards for DEFINING processes, roles, and work products/artifacts — the formats themselves, not the methodologies' content. Cover at minimum (verify each; add others you find): ISO/IEC TR 24774 (guidelines for process description — title/purpose/outcomes/activities format), OMG SPEM 2.0 and Eclipse Process Framework method-content vs process separation, RUP's role/activity/artifact structure, ITIL process definition format (purpose/scope/inputs/outputs/triggers/roles), CMMI process-area structure (goals/practices), ISO/IEC 33001/15504 process assessment models, IEEE/ISO 12207 & 15288 process outcome conventions, BPMN/CMMN positioned at definition level only. For each: exactly what elements its definition format contains, citation, and fit for a lightweight LLM-agent-operated system wanting definition-level process specs WITHOUT prescribing a workflow engine.` },
  { key: 'principle-and-normative-formats', prompt: `${CTX}

TASK: Survey established formats for PRINCIPLE statements and normative language. Cover at minimum (verify each; add others): TOGAF architecture-principle format (Name/Statement/Rationale/Implications) and its quality criteria for principles, RFC 2119 / BCP 14 normative keyword conventions, ISO/IEC Directives Part 2 rules for drafting normative documents, ADR/MADR templates (Nygard form and successors) as decision-statement formats, published engineering-principles practice (e.g., corporate engineering principles, "good principles are decision-guiding / specific enough to disagree with" literature such as Rumelt's good-strategy criteria applied to principles). For each: the format's elements, what makes a principle well-formed under it, citation, fit notes.` },
  { key: 'quality-rubric-forms', prompt: `${CTX}

TASK: Survey established forms for CONTENT-QUALITY GUIDELINES and rubrics — how the world writes down "what good looks like" for authored/generated content. Cover at minimum (verify each; add others): educational assessment rubric design (analytic vs holistic rubrics, AAC&U VALUE rubrics as exemplars), Scrum's Definition of Done as a quality-contract form, acceptance-criteria practice, style-guide governance as a form (Google developer documentation style guide, Microsoft Writing Style Guide — structure and enforcement model, not their content), ISO/IEC 25010 quality-characteristic models, Deming's operational definitions (the concept and its required elements), Gawande's checklist-design principles (Checklist Manifesto: DO-CONFIRM vs READ-DO, brevity constraints), and code-review rubric/checklist practice. For each: form elements, citation, fit for defining quality of LLM-generated documents and code.` },
  { key: 'llm-output-evaluation-and-gherkin', prompt: `${CTX}

TASK part 1: Survey established practice for QUALITATIVE EVALUATION OF NON-DETERMINISTIC / LLM-GENERATED OUTPUT. Cover at minimum (verify each; add others): LLM-as-judge research including known failure modes (position/verbosity/self-preference bias, gameability), rubric-based grading in production eval frameworks (promptfoo assertions incl. llm-rubric, DeepEval G-Eval, Ragas, LangSmith evals, Braintrust, OpenAI evals), model-provider guidance on writing evals (Anthropic/OpenAI eval-writing guidance), and any BDD-for-ML / Given-When-Then prior art for AI evaluation (e.g., Giskard, Cucumber-style LLM testing experiments, scenario-based eval configs).

TASK part 2 — EVALUATE THIS SPECIFIC PROPOSAL from our product authority, verbatim: "Use Given/When/Then Gherkin/BDD form tests to establish fitness. They can work out really well for documenting qualitative tests for non-deterministic generation as long as it is understood they won't be backed by typical code-style implementation. These don't need to be absolutely extensive, but there should be at least a small set of tests to evaluate fitness of any given generated output." Assess: prior art for exactly this pattern (G/W/T scenarios judged by an LLM reviewer rather than executed), strengths (our system already uses Gherkin as its behavior-contract vocabulary, so this reuses one literacy), failure modes (unfalsifiable Then-clauses, judge gameability, executable-culture confusion), mitigations, and alternatives that do the same job. Record the assessment in fit_notes of a finding named "Gherkin-as-qualitative-fitness proposal" with adopt_potential reflecting your evidence-based verdict.` },
  { key: 'agent-context-and-skill-governance', prompt: `${CTX}

TASK: Survey published practice for GOVERNING COMPILED AGENT CONTEXT — how teams define, version, and quality-control the prompt/skill surfaces that shape LLM agent behavior. Cover at minimum (verify each; add others): Anthropic Agent Skills format and authoring best practices (SKILL.md conventions, progressive disclosure, trigger descriptions), llms.txt (Answer.AI), rules-file conventions in the wild (Cursor rules, CLAUDE.md/AGENTS.md practice), prompt-as-code governance (versioning prompts, testing prompts, prompt registries), and MCP resource conventions. For each: what the form prescribes, citation, and fit for our rule that role prompts carry standing identity while each discrete activity is captured in its own skill (for token economy AND diagnosability).` },
]

phase('Survey')
log('Fanning out 5 survey areas with per-area source verification (pipelined)')

const results = await pipeline(
  AREAS,
  a => agent(a.prompt, { label: `survey:${a.key}`, phase: 'Survey', schema: FINDINGS }),
  (survey, a) => {
    if (!survey) return null
    return agent(`You are a skeptical source-verifier. Below is a JSON findings list from a research survey. For EACH finding: use WebSearch/WebFetch (load via ToolSearch with query "select:WebSearch,WebFetch" if needed) to confirm the named standard/framework/tool/paper actually exists and that "what_it_defines" and "form_elements" accurately describe it. Mark exists=false for anything you cannot confirm, accurately_described=false with corrections for anything misdescribed. Be strict: a plausible-sounding but unconfirmable citation must be marked exists=false.

FINDINGS JSON:
${JSON.stringify(survey.findings)}`, { label: `verify:${a.key}`, phase: 'Verify', schema: VERIFY })
      .then(v => ({ area: a.key, survey, verification: v }))
  }
)

const verified = results.filter(Boolean)
log(`Verified ${verified.length}/5 areas; synthesizing report`)

phase('Synthesize')
const synthesis = await agent(`${CTX}

You are the synthesis writer. Below is the full verified research corpus (5 areas: definition meta-models; principle formats; quality/rubric forms; LLM-output evaluation incl. an evaluation of a specific Gherkin-fitness proposal; agent-context/skill governance). Findings whose verification says exists=false MUST be dropped; findings with accurately_described=false must be used only as corrected.

Write the file /workspace/drafts/definition-format-research.md (use the Write tool). It is SITTING MATERIAL for the product authority: it describes and recommends, it decides NOTHING. Required structure:
1. A header block stating: sitting material, not ratified, decides nothing; date 2026-08-05; produced by the definition-format research directed in the re-founding dialogue.
2. "Survey" — per seed element (process definition format, role definition format, artifact/document-type schema format, principle format, content-quality guideline/rubric format, qualitative fitness-test format, compiled-context/skill governance): what established forms exist, with citations. DESCRIPTION ONLY — clearly separated from recommendation.
3. "Recommendations" — a per-element recommendation: adopt X / adapt X with named deltas / bespoke with explicit justification. Each recommendation states what the adopted form would concretely look like in this system, and cites its sources.
4. "The Gherkin-fitness proposal" — a dedicated section: prior art found, strengths, failure modes, mitigations, alternatives, and an evidence-based verdict with the conditions under which it works.
5. "Open questions for the authority" — the genuine decision points the research cannot settle.
Every claim cited. No uncited assertions. Keep it under ~450 lines. Wide content in plain prose, no HTML.

VERIFIED CORPUS:
${JSON.stringify(verified)}

Return as your final text: the file path plus a 10-line executive summary of the recommendations and the Gherkin verdict.`, { label: 'synthesize:report', phase: 'Synthesize' })

phase('Critique')
const critique = await agent(`Read /workspace/drafts/definition-format-research.md. You are a completeness critic for a research report that will seed a quality-system re-founding. Check: (1) does every seed element (process def, role def, artifact schema, principle format, quality guideline/rubric, fitness-test format, context/skill governance) have BOTH survey coverage and an explicit recommendation? (2) any uncited claims? (3) any conflation of describing-a-practice with recommending-adoption? (4) does the Gherkin section give an evidence-based verdict with conditions and alternatives? (5) what tradition or obvious source is missing entirely? Return a concise gap list (or "no material gaps"), most severe first. Do not edit the file.`, { label: 'critique:completeness', phase: 'Critique' })

return { path: '/workspace/drafts/definition-format-research.md', summary: synthesis, critique }