# Progressive disclosure for LLM artifacts — research & experiment initiative

**Epic:** lead-x7bp · **Process bead:** lead-x2rl · **Started:** 2026-07-04
**Status:** RESEARCH IN PROGRESS (no PDR/ADR may precede this finding)

## Why this doc exists

David requested (2026-07-04) that the progressive-disclosure epic run through
the **same experimental protocol as the fabro integration** — *research
available materials → take lots of notes → synthesize reports → run experiments
as necessary to validate the goals can be met → recommend an implementation
path* — **before** any PDR/ADR is authored. This mirrors PDR-016 (spike
lifecycle) and the lead-odqd proving cases (`findings/fabro-spike/`,
`findings/substrate-candidate-comparison-vs-fabro.md`,
`findings/iterative-experimentation-capability.md`).

The epic's earlier "research report delivered in-session" was NOT a durable
artifact. This directory IS the durable research surface.

## The goals to be validated (from epic lead-x7bp)

An agent (lead or BC) should pull only the disclosure LEVEL relevant to its
activity, from a single source, with no summary/full drift, and a coherence
gate catching contradictory/superseded active decisions. Concretely:

- **L0** = id+title+one-line description (relevance triage).
- **L1** = the DECISION statement (+status/supersedes) — the tier distributed
  to BCs that must CONFORM.
- **L2** = full document (context/alternatives/tradeoffs/consequences) — for
  lead-architect AUTHORING new decisions.
- Required YAML frontmatter schema (id,title,status,description,decision,
  supersedes,superseded-by,depends-on,tags), tiers+indexes GENERATED from the
  ONE source (single-sourcing; same anti-drift lesson as scenario hash/gherkin).
- Machine+human index (llms.txt / OKF style); L1 digest distributed to BCs;
  L2 lead-only; a decision-coherence GATE (analogue of `scenarios --aggregate`
  / ADR-047 coherence gate).

## Structure of this directory

| Doc | Content |
|---|---|
| `00-plan.md` | this framing doc |
| `01-disclosure-mechanics.md` | llms.txt, Anthropic Agent Skills progressive disclosure, MCP resources — the LEVEL mechanic |
| `02-knowledge-index.md` | Google Open Knowledge Format (OKF), machine+human index / single-source generation |
| `03-decision-doc-standards.md` | MADR, Diataxis, ADR tooling — the frontmatter/metadata schema prior art |
| `04-hierarchical-retrieval.md` | RAPTOR, GraphRAG, contextual retrieval — what transfers to a ~60-doc decision corpus, what's overkill |
| `05-internal-grounding.md` | the repo's actual adr/pdr/features conventions, `scenarios` CLI shape, ADR-047 coherence gate, nbx5 single-source precedent |
| `06-synthesis.md` | scorecard of design options + recommended direction + goals-to-validate-experimentally |
| `07-experiment.md` | throwaway spike (isolated /tmp) validating the goals against REAL repo ADRs; verdict |
| `08-recommendation.md` | verdict + recommended implementation path (ordered) + Phase-2 requirements + thin-slice decomposition |

## Verdict vocabulary (PDR-016)

CONFIRM / go-with-caveats / REFUTED. Experiment code + infra are throwaway
(isolated `/tmp` scratch), never committed, torn down at verdict.
