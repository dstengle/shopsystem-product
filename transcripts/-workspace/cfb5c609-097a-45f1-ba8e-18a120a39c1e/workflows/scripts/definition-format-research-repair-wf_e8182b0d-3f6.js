export const meta = {
  name: 'definition-format-research-repair',
  description: 'Close the completeness-critique gaps in drafts/definition-format-research.md: three missing traditions surveyed+verified, report patched in place, re-critiqued',
  phases: [
    { title: 'Gap survey', detail: 'QM lineage, RACI/role forms, document typing' },
    { title: 'Verify', detail: 'source verification per gap area' },
    { title: 'Patch', detail: 'edit the report in place' },
    { title: 'Re-critique', detail: 'confirm all 7 gaps closed' },
  ],
}

const CTX = `CONTEXT: We operate an LLM-agent-run product-development system re-founding its quality layer on construction-definitions-precede-checks. An existing research report at /workspace/drafts/definition-format-research.md surveys established definition formats (process/role/artifact/principle/quality/fitness-test/context-governance) and recommends adopt/adapt/bespoke per element. A completeness critique found missing traditions. Your findings will be integrated into that report. EVIDENCE BAR: primary sources; never cite a source you have not confirmed exists; separate describing from recommending. Web access: if WebSearch/WebFetch are unavailable, load via ToolSearch with query "select:WebSearch,WebFetch".`

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
  { key: 'quality-management-lineage', prompt: `${CTX}

TASK: Survey the quality-management lineage missing from the report. Cover: ISO 9001:2015 documented-information requirements and document-control practice (clause 7.5 — creation/update/control, the controlled-document concept, versioning and audit traceability) and ISO 9000:2015 vocabulary; the Shewhart/Deming PDCA cycle as an improvement-loop FORM (original sources: Shewhart 1939, Deming's PDSA lectures; where each phase's expected outputs live); Six Sigma CTQ (critical-to-quality) trees — the canonical derivation from qualitative customer need to measurable characteristic to specification/check, with a primary or authoritative secondary source; DMAIC as a defined process-with-phase-gates form. For each: exact form elements, citation, and fit for a system deriving mechanical checks and rubrics from ratified construction definitions and governing versioned prompt/skill/definition surfaces.` },
  { key: 'role-responsibility-forms', prompt: `${CTX}

TASK: Survey role-responsibility assignment formats missing from the report's role-definition survey. Cover: RACI (Responsible/Accountable/Consulted/Informed) responsibility-assignment matrices — origin and authoritative form (PMBOK's RAM treatment or an equivalent authoritative source), the one-A-per-deliverable rule, RASCI and other variants, known failure modes/criticisms; Holacracy's role format (Holacracy Constitution — purpose / domains / accountabilities structure, role vs person separation, governance-meeting amendment process); optionally other structured role forms with real adoption (e.g., team topologies team-interaction modes as role-adjacent, only if verifiable). For each: form elements, citation, fit notes — noting that this system binds each artifact kind to exactly one accountable role (RUP-style) and has a pending PO-vs-Architect RACI investigation.` },
  { key: 'document-typing-standards', prompt: `${CTX}

TASK: Survey established document-type taxonomies missing from the report's artifact-schema survey. Cover: DITA 1.3 (OASIS standard) — topic typing (concept/task/reference), specialization as a governed mechanism for deriving new constrained types from base types, maps; Diátaxis (Procida, diataxis.fr) — the tutorial/how-to/reference/explanation quadrant, its axes (acquisition/application x action/cognition), its rule that a document serves exactly one quadrant; optionally arc42 and the "docs-as-code" typing practice if verifiable. For each: form elements, citation, and fit for a system whose artifact kinds need structurally-defined schemas with required content per kind — note DITA specialization as a possible external anchor for deriving new artifact kinds from generic types.` },
]

phase('Gap survey')
log('Surveying 3 missing traditions with per-area verification')

const results = await pipeline(
  AREAS,
  a => agent(a.prompt, { label: `survey:${a.key}`, phase: 'Gap survey', schema: FINDINGS }),
  (survey, a) => {
    if (!survey) return null
    return agent(`You are a skeptical source-verifier. For EACH finding in the JSON below: use WebSearch/WebFetch (load via ToolSearch "select:WebSearch,WebFetch" if needed) to confirm the named source exists and is accurately described. Mark exists=false for anything unconfirmable; corrections for anything misdescribed. Be strict.

FINDINGS JSON:
${JSON.stringify(survey.findings)}`, { label: `verify:${a.key}`, phase: 'Verify', schema: VERIFY })
      .then(v => ({ area: a.key, survey, verification: v }))
  }
)

const verified = results.filter(Boolean)
log(`Verified ${verified.length}/3 gap areas; patching report`)

phase('Patch')
const patch = await agent(`${CTX}

You are the report editor. Edit /workspace/drafts/definition-format-research.md IN PLACE (Read it first, then use Edit). Apply exactly these repairs, which close a completeness critique. Keep the report's existing voice, citation density, and structure. Drop any new finding whose verification says exists=false; apply corrections where accurately_described=false.

NEW VERIFIED MATERIAL to integrate:
${JSON.stringify(verified)}

REPAIRS:
1. Add the quality-management lineage: a new survey subsection (fit it into section 1 coherently, e.g. within or after 1.5) covering ISO 9001 documented-information/document control, PDCA, CTQ trees, DMAIC — description only; then weave its consequences into section 2 where they genuinely bear (document-control/versioning into 2.7's promotion/versioning governance; CTQ's need-to-measurable derivation alongside the 330xx outcomes-to-indicators pattern in 2.1/2.5). Do not force-fit; only integrate where it strengthens an existing recommendation.
2. Add RACI/RASCI and Holacracy role forms to survey 1.2; in recommendation 2.2, address RACI explicitly — adopt, adapt, or reject WITH reasons — and note its direct relevance to the shop's pending PO-vs-Architect RACI investigation (bead lead-jozud.2).
3. Add DITA (topic typing + specialization) and Diátaxis to survey 1.3; in 2.3, state whether either changes the 15289-anchored recommendation (e.g., DITA specialization as a second external anchor for deriving new kinds; Diátaxis's one-document-one-quadrant rule as a per-kind discipline) — or why not.
4. Fix the 2.4-vs-Open-Question-1 inconsistency: soften 2.4's BCP 14 adoption to a preferred-candidate framing that names the open question, OR restate Q1 as "ratify the BCP 14 recommendation or override with ISO shall/should" — one of the two, consistently.
5. Neutralize the evaluative leaks inside section 1 (which claims to describe only): "the standards world's clearest vocabulary for unpredictable knowledge-work" (CMMN), "essentially academic" (24744), "the working proof" (EPF), "the mature exemplar artifact" (AAC&U), "the only classic form that builds verification into the definition cell" (ETVX). Either neutralize the phrasing in place or move the evaluation into section 2 where evaluation belongs.
6. Repair uncited claims: (a) 24744 uptake — cite a source or rephrase as an observation with stated basis; (b) TOGAF "only broadly adopted formal template specifically for principles" — soften to a bounded claim or cite; (c) "Anthropic ships no runner" — verify against current Anthropic docs and cite or rephrase; (d) the Gherkin negative claim ("no established named standard exists") — add one sentence describing the search scope/method that grounds the negative.
7. Resolve the Essence 2.0 status: the report says "formal publication scheduled March 2026" but the report is dated 2026-08-05. Check OMG's current status via the web and state what is actually true now (published / slipped / still beta), cited.
8. Update the header block: add a one-line revision note that a completeness-critique repair pass (same date) added the QM lineage, role-assignment forms, and document-typing traditions and repaired cited inconsistencies.

Return as final text: a list of the edits made, each in one line, plus any repair you could NOT complete and why.`, { label: 'patch:report', phase: 'Patch' })

phase('Re-critique')
const recheck = await agent(`Read /workspace/drafts/definition-format-research.md. A prior completeness critique raised 7 gaps: (1) missing ISO 9000/9001, PDCA, Six Sigma CTQ lineage in survey AND recommendations; (2) missing RACI/RASCI and Holacracy in the role survey with explicit treatment in the role recommendation; (3) missing DITA and Diátaxis in the artifact-schema survey with stated impact on the recommendation; (4) internal inconsistency between recommendation 2.4 (adopt BCP 14) and Open Question 1 (unresolved BCP-14-vs-ISO choice); (5) uncited claims: 24744 "essentially academic", TOGAF "only broadly adopted" principle template, "Anthropic ships no runner", and the ungrounded negative "no established named standard exists" for judged Gherkin; (6) evaluative language leaking into the describe-only survey section (CMMN "clearest vocabulary", EPF "working proof", AAC&U "mature exemplar", ETVX "only classic form"); (7) stale "Essence 2.0 scheduled March 2026" statement in a document dated 2026-08-05. Verify EACH is now resolved; also confirm no new uncited claims or describe/recommend conflations were introduced by the edits. Return a numbered verdict per gap (RESOLVED / NOT RESOLVED with what remains) plus any new defects introduced. Do not edit the file.`, { label: 'recheck:gaps', phase: 'Re-critique' })

return { edits: patch, recheck }