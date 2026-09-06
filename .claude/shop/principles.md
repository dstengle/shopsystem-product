---
type: principles-rendering
id: principles-rendering
status: approved
generated: true
generated-by: basis/tools/compile_principles.py
derived-from: principles
source: basis/principles.md
source-digest: sha256:96ae4155dc8e
scope: working
---

# Working principles (compiled into every session)

These statements govern every activity in this shop. The full set —
rationales, implications, fitness screen — is the source document
named in the front-matter; on conflict the source wins.

- **Define what good looks like up front** (`define-good-up-front`):
  - Every activity MUST operate from a stated definition of what good looks like.
  - That definition MUST drive both the performance of the activity and its check.
  - The check MUST sit with a different role holding a different accountability.
  - Whoever makes an activity's output MUST evaluate that output against the definition of good before submitting it to the check.
  - That evaluation MUST be recorded with the output — in its Document History or the step's own output.
- **Govern the generating context** (`governed-context`):
  - Everything loaded into an agent's generating context — prompts, skills, memories, primers — MUST trace to an approved definition or a governed record.
  - An unsanctioned context channel MUST NOT be created or retained.
- **Every activity belongs to a process** (`no-orphan-activities`):
  - Every activity in the system MUST be part of a defined process with stated expected outcomes, expected outputs, and possible resulting actions.
  - Every long-running loop MUST declare its exit — a reached-state success exit, a round or budget cap, or both.
- **Use defined terms** (`use-defined-terms`):
  - Important terms MUST be defined in the system, in the glossary or as a schema element.
  - A term is important when a reader must know it to perform or check the work.
  - When more than one term could carry a statement, the writer MUST use a defined term if one is available.
- **Use external standards first** (`external-standards-first`):
  - A definition MUST adopt an established external form where one fits.
  - Bespoke structure MUST be justified by a recorded gap in the form it rejects.
- **Single source of truth** (`single-source-of-truth`):
  - Every fact, rule, or definition MUST have exactly one authoritative home.
  - Every other appearance MUST be a reference or a generated rendering.
- **Feedback loops have consumers** (`feedback-loops-with-consumers`):
  - Every feedback channel MUST name its consumer and the resulting action.
  - The effectiveness of processes, tools, and prompts MUST be measured.
  - The definitions of processes, tools, and prompts MUST be updated from what is measured.
- **Delivery is verified in the running system** (`delivery-verified`):
  - Work MUST be counted done only when its effect is demonstrated in the running system.
  - Artifacts existing, checks passing, or reviews approving MUST NOT count as done on their own.
- **Load the least context** (`least-context`):
  - An activity MUST load the minimum context necessary to accomplish its task.
  - The activity's process MUST name what loads into context and the source each input comes from.
  - Context from an unapproved source MUST NOT be loaded.
- **Use tools through skills** (`tools-through-skills`):
  - Every framework tool MUST be usable through a skill that states, for a scenario, what it does, what it takes, what it returns, and how it fails, so that an agent uses it without reading its help.
  - An agent MUST prefer that skill over a bare invocation of the tool.
  - A tool with no such skill MUST be recorded as a gap, not worked around.
