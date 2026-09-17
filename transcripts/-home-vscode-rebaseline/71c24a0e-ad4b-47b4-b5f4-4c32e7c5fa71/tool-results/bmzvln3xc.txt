---
type: research-report
id: tool-self-description-2026-09
status: delivered
version: 3
date: 2026-09-07
question: "What are the established best practices for making a command-line tool self-describing in a way an agent skill can consume — where the description lives (in the tool itself versus a separate definition maintained beside it), what shape it takes, and how drift between the tool and its description is prevented?"
requested-by: product-authority
created: 2026-09-07
updated: 2026-09-07
---

# Tool self-description for agent skills

## Executive summary

**Answer: keep the description in the tool, export it by walking the tool's argument parser, generate the skill from that export, and gate the generated skill in CI.** A gate is a check in the build that fails when a generated file differs from the one checked in. No standard gives a command-line tool's description a home outside the tool; every practice opened either generates the separate document from the tool or — in docopt, a Python library that builds the parser from the help text — generates the tool's parser from the document. None keeps two hand-maintained copies.

Findings, each with confidence in the evidence (scheme: high — a standard or the format's owner plus a second independent source; medium — one authoritative source; low — inference or a single non-authoritative source):

1. GNU requires `--help` in the tool; man-pages(7) defines the separate document; POSIX is silent on help. — *medium*
2. Agent-facing tool formats (MCP, Anthropic tool use, OpenAI function calling) converge on one shape: name, a natural-language description, a JSON Schema for inputs. — *high*
3. The format owners specify what a description must contain: what the tool does, when to use it and when not, what each parameter means, its limits. Anthropic alone calls the description "by far the most important factor in tool performance". — *high* for the content; *medium* for Anthropic's performance claim
4. Anthropic's Agent Skills format is the layer an agent reads over scripts: `SKILL.md` carries a what-and-when description; its body names each script with the exact invocation and output format; scripts run with only their output entering context. — *medium*
5. In agent-tool SDKs and CLI frameworks the description is derived from the code: docstrings become descriptions, type hints or parser definitions become the schema, and separate documents are generated from the parser. — *high*
6. Drift is prevented by generate-then-gate (Kubernetes) and by contract tests where a contract exists (Schemathesis). — *medium*
7. A description served only at runtime (MCP `tools/list`, a CLI's `--help`) costs static consumers an execution; a community workaround is a shipped `tool-schema.json`. — *low*
8. No standard exists for a machine-readable CLI self-description; each framework has its own export. — *low* (inference from absence)
9. docopt is the inverse single source: the help text generates the parser. — *medium*

### Recommendation

The consumer's principle, from the frame: "Every framework tool MUST be usable through a skill that states, for each use it supports, what it does, what it takes, what it returns, and how it fails, so that an agent uses it without reading its help." Against that principle the findings support one decision — the tool is the source — in three parts:

**(a) Description in the tool.** Each framework tool's argparse parser carries the agent-grade text: the parser `description` says what the tool does and when to use it; each argument's `help` says what it takes; the `epilog` says what it returns and how it fails (exit codes, output shape). argparse has fields for the first two only; returns and failures are text by convention (F1, F3, F5). Decidable now.

**(b) Export by parser walk.** Adopt the form sphinx-argparse uses: a step that imports each tool module, obtains its `ArgumentParser`, and walks it — description, sub-commands, arguments, help, epilog — into the definition the existing skill compiler consumes (F5). The shop's tools are argparse-based Python, so no new framework is needed. The docopt inverse (write the definition, generate the parser) was weighed and set aside as the default (Alternative 5). **Open check before (b) is adopted:** whether the compiler's source digest can cover the tool module itself, so that a change to the tool re-renders the skill. The scope excluded the shop's definitions, so this was not examined; the authority orders the check.

**(c) Gate the generated skill.** CI regenerates each `SKILL.md` from the walk and fails when it differs from the checked-in file — the Kubernetes pattern (F6). A second check, running each tool's `--help` and comparing it with the export, is the researcher's proposal, not an observed practice.

A separate definition beside the tool is justified only for what the parser cannot know — the workflow across tools, and when to choose this tool over another — and references the export rather than restating flags (Alternative 1).

## Method

Nine web searches covered the POSIX and GNU standards, clig.dev, man-page conventions, docopt, the MCP tool specification, Anthropic's tool-use and Agent Skills documentation and engineering posts, OpenAI's function-calling guide and Agents SDK, argparse, Click, Typer, Cobra, clap_mangen, sphinx-argparse, help2man, docs-as-code, Schemathesis, a CI generated-docs gate, and agent-era CLI guidance (2025–2026).

Twenty-nine pages were opened (Sources). Five pages came back as full page text — the MCP specification, the agentskills.io specification, Anthropic's Skills overview, Anthropic's "Define tools", and Anthropic's Skill best practices — and quotes from them are the page's own words. Six pages were reopened in the verification round with verbatim checks — clig.dev, the sphinx-argparse usage page, the MCP discussion, the docopt README, the MCP Python SDK README, and the Skill best practices page — and quotes from them are confirmed. Quotes from the other pages come from a single summarizing fetch and may carry the summarizer's wording; the verification round found and retracted three such sentences (Document History).

Not opened: gnu.org (HTTP 403 and 429; a mirror of the same standard was read), docopt.org (certificate error; the GitHub README was read), cobra.dev's how-to page (404; the Go package page was read), and a Fern post on schema drift (unreadable twice; dropped). No number in this report is from memory.

## Findings

Quotes beyond those given here are in Appendix A.

### F1. GNU requires --help in the tool; man-pages defines a separate document; POSIX is silent — *medium*

GNU Coding Standards: "All programs should support two standard options: `--version' and `--help'." `--help` "should output brief documentation for how to invoke the program, on standard output, then exit successfully." man-pages(7) defines the separate document's sections — NAME, SYNOPSIS, DESCRIPTION, OPTIONS, EXIT STATUS, EXAMPLES. POSIX XBD 12 defines syntax notation and option guidelines and contains no provision on help output.

Corroboration: argparse "automatically generates help and usage messages"; Click adds `--help` to every command; clig.dev says "Display help when passed `-h` or `--help` flags."

Judgment on the label: the GNU requirement is corroborated by clig.dev and two frameworks, but the standard's text was read at a mirror of unknown edition through a summarizing fetch; man-pages(7) is one authoritative source; POSIX silence is an absence. Medium is the honest label for the finding as a whole.

Sources: 2, 4, 1, 7, 8, 5.

### F2. Agent-facing formats converge on name + description + JSON Schema — *high*

MCP: "`name`: Unique identifier for the tool ... `description`: Human-readable description of functionality ... `inputSchema`: JSON Schema defining expected parameters", plus optional `outputSchema` and `annotations`. Anthropic: `name`, `description` ("A detailed plaintext description of what the tool does, when it should be used, and how it behaves"), `input_schema`. OpenAI: `name`, `description` ("Details on when and how to use the function"), `parameters` (JSON schema), `strict`. Field-level quotes in Appendix A.

Sources: 13, 16, 23.

### F3. The description's required content is specified — *high*; Anthropic's "main lever" claim — *medium*

Anthropic, "Define tools": descriptions should explain "What the tool does; When it should be used (and when it shouldn't); What each parameter means and how it affects the tool's behavior; Any important caveats or limitations ... Aim for at least 3–4 sentences for each tool description." OpenAI: "Write clear and detailed function names, parameter descriptions, and instructions"; "Use enums and object structure to make invalid states unrepresentable." The two vendors agree on the content, so the content specification is high.

Anthropic alone says: "Provide extremely detailed descriptions. This is by far the most important factor in tool performance," and its engineering post reports a SWE-bench Verified improvement "after we made precise refinements to tool descriptions." Vendor-reported, one source: medium, and the figure is reported as direction only.

Sources: 16, 17, 23.

### F4. The Agent Skills format is the layer an agent reads over scripts — *medium*

Agent Skills specification: `description` is required, "Max 1024 characters ... Describes what the skill does and when to use it"; `scripts/` "Contains executable code that agents can run." Anthropic's Skills overview: "When instructions mention executable scripts, Claude runs them through bash and receives only the output (the script code itself never enters context)." Anthropic's best practices document each script inside `SKILL.md` with its command line and output format, and require "Make execution intent clear: 'Run `analyze_form.py` to extract fields' (execute); 'See `analyze_form.py` for the extraction algorithm' (read as reference)."

Judgment on the label: the specification and the platform documentation are both the format owner's; no independent second source was opened, so medium. Judgment on meaning: in this format the skill body, not the script's `--help`, is what the agent reads for the invocation; nothing in the sources tells an agent to read a script's help, and nothing forbids it.

Sources: 22, 18, 19, 20.

### F5. Descriptions are derived from code; separate documents are generated from the parser — *high*

MCP Python SDK: "no JSON Schema (`a: int, b: int` *is* the schema), no request parsing, no validation code, no protocol handling" — the docstring is the description. OpenAI Agents SDK: "Tool description will be taken from the docstring of the function"; "The schema for the function inputs is automatically created from the function's arguments." Two vendors, independent.

CLI tool chains generate the separate document from the parser: sphinx-argparse — "you should point it to the function that will return a pre-filled `ArgumentParser`" and it renders "positional arguments, options and sub-commands"; Typer — `typer ... utils docs --output README.md`; Cobra — `GenMarkdownTree` "will generate a markdown page for this command and all descendants", likewise man, ReST, and YAML; clap_mangen — "Generate ROFF from a `clap::Command`" during development, not from a shipped flag; help2man — "produces simple manual pages from the '--help' and '--version' output of other commands" so authors need not "maintain that document."

Judgment: one source in the code, every other form generated. Cobra's YAML tree and the sphinx-argparse walk are the closest existing analogs to what a skill compiler would consume; the recommendation adopts the latter because the shop's tools are argparse-based.

Sources: 15, 24, 10, 11, 9, 12, 3.

### F6. Drift is prevented by generate-then-gate and by contract tests — *medium*

Kubernetes `hack/verify-generated-docs.sh` "checks that various type of documents(*.md, *.yaml and man files) are generated correctly"; its core call regenerates into a temporary directory, diffs against the checked-in files, and fails with "Generated docs need to be updated ... Please run 'hack/update-generated-docs.sh'". Schemathesis "automatically generates property-based tests from your OpenAPI or GraphQL schema and exercises the edge cases that break your API." Write the Docs' docs-as-code lists version control, code review, and automated tests for documentation.

Judgment on the label: one primary example of the gate in practice plus a tool's own documentation; medium.

Sources: 25, 26, 27.

### F7. A runtime-served description costs static consumers an execution — *low*

MCP discovers tools by `tools/list` at runtime. A community discussion in the MCP specification repository (2025-11-05) asks for schemas "without executing the server code" for "static analysis, documentation generation, auditing"; a reply (2026-05-09) says "some publishers ship a `tool-schema.json` alongside their server in the package root. it's literally the cached `tools/list` response," and that spawning servers to enumerate tools "genuinely doesn't scale across thousands of registry entries." No maintainer answers.

Judgment: a community thread, so low. The parallel to a CLI's `--help` — also runtime-served — is the researcher's inference; likelihood that a build-time export removes the problem for a local script is high in the researcher's judgment, since no network or side effects are involved.

Sources: 13, 14, 21.

### F8. No standard machine-readable CLI self-description exists — *low*

None of POSIX XBD 12, the GNU standards, man-pages(7), or clig.dev defines a structured export of a command's interface; each framework has its own (Cobra YAML, Typer Markdown, sphinx-argparse, clap_mangen). Inference from absence in the opened sources. The one agent-era checklist found (Garbas, 2026-02-22, a single blog) asks for "Clear –help Output" with one-line descriptions, grouped flags, and examples, and for JSON output treated "as an API contract".

Sources: 1, 2, 4, 5, 28.

### F9. docopt is the inverse single source — *medium*

docopt README: "the option parser *is* generated based on the beautiful help message that you write yourself". The repository shows 8.0k stars and 225 open issues; maintenance status was not established.

Judgment: docopt keeps one source — the document — and generates the parser from it. A design-first separate definition is defensible only on that condition (Alternative 5).

Sources: 6.

## Alternatives considered

1. **A separate, hand-maintained definition beside the tool.** Weighed because the shop already compiles skills from definitions and a definition can carry what a parser cannot. Findings stand against it as the home for flags and parameters: no standard gives that content a home outside the tool (F1, F8); every practice opened generates the second form from the first (F5); two hand-maintained copies need a gate anyway (F6). It remains the home for cross-tool content, referencing the export. *Note:* the objection that hand-written descriptions serve agents better than generated ones (F3) concerns the text's quality, not where it is stored; part (a) puts the hand-written text in the parser, which frameworks pass through unchanged (F5).
2. **No artifact: the agent runs `--help`.** Cheapest. Contradicts the consumer's principle ("without reading its help") and gives the compiler nothing to digest (F7).
3. **Wrap the tools as an MCP server.** Richest schema (F2) but served only at runtime; static consumers need an execution or a generated `tool-schema.json` (F7) — the same export as (b) with a protocol layer added. Not excluded later.
4. **Both a tool description and a separate definition, reconciled by a contract test.** The recommendation's gate with two authored sources; acceptable only when the definition adds what the tool cannot carry.
5. **The docopt inverse: the definition is the source and the parser is generated from it.** Keeps one source (F9) and would let the shop's definition format be primary. Set aside as the default because the shop's tools already carry argparse parsers, docopt's maintenance status is unestablished, and the export form in (b) reaches the same single-source outcome without changing the tools' parser library. Worth reopening if the definition format must carry more than a parser can express.

## Limitations

- gnu.org refused both fetchers; the GNU text was read at a mirror (ime.usp.br) of unknown edition. docopt.org and cobra.dev's how-to page were unreadable; substitutes were used. A Fern post on schema drift was unreadable and is not cited.
- The verification round was run by the same researcher reopening six sources, not by a fresh worker context as the process asks; the runtime provided none. The other twenty-three pages were read once through a summarizing fetch. Two of those readings produced sentences a second reading could not find (clig.dev, docopt); they are retracted. A reader who needs a quote should open the source.
- F8 is an inference from absence; no dedicated search for a `--help=json` convention was run. A standard the run did not find would change the export form in (b).
- No empirical study comparing agent performance with descriptions stored in the tool versus beside it was found; F3's performance claim is one vendor's.
- Whether the shop's compiler digest can cover a tool module was not examined (scope); it is the open check named in (b).
- What would change the judgment: a published standard for machine-readable CLI description; Anthropic guidance telling skills to have agents read `--help`; evidence that parser-derived descriptions underperform hand-written ones for agents.

## Sources

Status: *reopened* — opened twice, quotes confirmed verbatim; *opened (full text)* — returned as page text once; *opened* — read once through a summarizing fetch; *UNOPENED* — not readable in this run. Per-entry notes are in Appendix B.

1. POSIX XBD 12 "Utility Conventions" — https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html — opened.
2. GNU Coding Standards, "Standards for Command Line Interfaces", mirror — https://www.ime.usp.br/~jose/standards.html — opened. Originals at https://www.gnu.org/prep/standards/html_node/_002d_002dhelp.html and .../Command_002dLine-Interfaces.html — UNOPENED.
3. help2man — https://www.gnu.org/software/help2man/ — opened.
4. man-pages(7) — https://man7.org/linux/man-pages/man7/man-pages.7.html — opened.
5. clig.dev — https://clig.dev/ — reopened.
6. docopt README — https://github.com/docopt/docopt — reopened. docopt.org — UNOPENED.
7. argparse — https://docs.python.org/3/library/argparse.html — opened.
8. Click, "Documenting Scripts" — https://click.palletsprojects.com/en/stable/documentation/ — opened.
9. Typer, "Building a Package" — https://typer.tiangolo.com/tutorial/package/ — opened.
10. sphinx-argparse — https://sphinx-argparse.readthedocs.io/en/stable/ — opened; usage page https://sphinx-argparse.readthedocs.io/en/stable/usage.html — reopened.
11. Cobra `doc` package — https://pkg.go.dev/github.com/spf13/cobra/doc — opened. cobra.dev how-to page — UNOPENED.
12. clap_mangen README — https://github.com/clap-rs/clap/blob/master/clap_mangen/README.md — opened.
13. MCP specification 2025-11-25, Tools — https://modelcontextprotocol.io/specification/2025-11-25/server/tools — opened (full text).
14. MCP discussion #1765 — https://github.com/modelcontextprotocol/modelcontextprotocol/discussions/1765 — reopened.
15. MCP Python SDK README — https://github.com/modelcontextprotocol/python-sdk — reopened.
16. Anthropic, "Define tools" — https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools — opened (full text).
17. Anthropic engineering, "Writing effective tools for AI agents" (2025-09-11) — https://www.anthropic.com/engineering/writing-tools-for-agents — opened.
18. Anthropic, Agent Skills overview — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview — opened (full text).
19. Anthropic, Skill authoring best practices — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices — reopened.
20. Anthropic engineering, "Equipping agents for the real world with Agent Skills" (2025-10-16) — https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills — opened.
21. Anthropic engineering, "Code execution with MCP" (2025-11-04) — https://www.anthropic.com/engineering/code-execution-with-mcp — opened.
22. Agent Skills specification — https://agentskills.io/specification — opened (full text).
23. OpenAI, Function calling — https://developers.openai.com/api/docs/guides/function-calling — opened.
24. OpenAI Agents SDK, Tools — https://openai.github.io/openai-agents-python/tools/ — opened.
25. Kubernetes `hack/verify-generated-docs.sh` — https://github.com/kubernetes/kubernetes/blob/master/hack/verify-generated-docs.sh — opened.
26. Schemathesis — https://schemathesis.readthedocs.io/en/stable/ — opened.
27. Write the Docs, "Docs as Code" — https://www.writethedocs.org/guide/docs-as-code/ — opened.
28. Rok Garbas, "AI Agents Are Your New Users - A 2026 CLI Checklist" (2026-02-22) — https://garbas.si/posts/ai-agents-are-your-new-users-cli/ — opened; non-authoritative.
29. Fern, "Stopping schema drift" — https://buildwithfern.com/post/stopping-schema-drift-coupling-sdks-documentation-claude — UNOPENED; not cited.

Count: 29 pages opened (28 numbered sources, one with two pages), of which 6 reopened and 5 returned as full text; 5 pages unopened.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Drafted under research-inquiry: frame, plan (three sub-questions, two or more search paths each), gather, extract, synthesize. Maker self-check against the research-report typedef: every finding carries a scheme label and an opened source; confidence and likelihood stated apart; alternatives present; unopened references marked. Verification round 1 (same researcher, six sources reopened): verdict "findings" — clig.dev single-source sentence retracted (F1, F6); docopt reduced to its one confirmed sentence (F9); MCP discussion quotes replaced with the exact text and dates (F7). No confidence label changed. |
| 2 | 2026-09-07 | review | Cold read (judge claude-fable-5-1, as the consumer), read_round 1: "findings" — the recommendation's direction decidable but parts (b) and (c) not; four confidence labels not matching the evidence; Sources' "verified" not true to the method; over-sized. |
| 2 | 2026-09-07 | update | Repairs: evidence stated true to the method (six reopened and confirmed; five full-text; the rest single summarized fetch), "verified" replaced with opened/reopened, page count reconciled to 29; F1 retitled and re-judged to medium; F3 split (content high, Anthropic's performance claim medium); F4 re-judged to medium and its "not expected to read its help" moved to a Judgment line; F7 dropped to low; the `--help`-versus-export check marked as the researcher's proposal; the consumer's principle quoted and the recommendation made decidable with an argparse parser walk as the export form and the compiler-digest feasibility as an open check; former Alternative 5 folded into Alternative 1, docopt inverse added as Alternative 5; POSIX notation, field-by-field schema quotes, token budgets, and per-source notes moved to Appendices A and B; "gate" glossed and docopt introduced at first use. |

## Appendix A — Quotations moved from the findings

**POSIX XBD 12.1 notation (F1).** "Arguments or option-arguments enclosed in the '[' and ']' notation are optional and can be omitted." "Ellipses ( "..." ) are used to denote that one or more occurrences of an operand are allowed." Guideline 3: "Each option name should be a single alphanumeric character (the alnum character classification) from the portable character set." Guideline 10: "The first -- argument that is not an option-argument should be accepted as a delimiter indicating the end of options."

**GNU (F1), from the mirror.** "Other options and arguments should be ignored once this is seen, and the program should not perform its normal function. Near the end of the `--help' option's output there should be a line that says where to mail bug reports." "It is a good idea to follow the POSIX guidelines for the command-line options of a program. The easiest way to do this is to use getopt to parse them." "Please define long-named options that are equivalent to the single-letter Unix-style options."

**man-pages(7) (F1).** SYNOPSIS: "A brief summary of the command or function's interface." DESCRIPTION: "An explanation of what the program, function, or format does." OPTIONS: "A description of the command-line options accepted by a program and how they change its behavior." EXIT STATUS: "A list of the possible exit status values of a program and the conditions that cause these values to be returned."

**clig.dev (F1), reopened.** "Display help when passed `-h` or `--help` flags. This also applies to subcommands which might have their own help text." "Lead with examples." "Display output as formatted JSON if `--json` is passed." "Provide terminal-based documentation." "Consider providing man pages." No sentence on generating documentation from a single source exists on the page.

**argparse and Click (F1, F5).** argparse: "The program defines what arguments it requires, and argparse will figure out how to parse those out of sys.argv. The argparse module also automatically generates help and usage messages." "The help value is a string containing a brief description of the argument." `description` "gives a brief description of what the program does and how it works"; `epilog` carries "additional description of the program after the description of the arguments." Click: "For commands, the docstring of the function is automatically used if provided." "Help parameters are automatically added by Click for any command."

**MCP tool fields (F2), full text.** "A tool definition includes: `name`: Unique identifier for the tool; `title`: Optional human-readable name of the tool for display purposes; `description`: Human-readable description of functionality; ... `inputSchema`: JSON Schema defining expected parameters — Follows the JSON Schema usage guidelines — Defaults to 2020-12 if no `$schema` field is present — MUST be a valid JSON Schema object (not `null`); `outputSchema`: Optional JSON Schema defining expected output structure; `annotations`: Optional properties describing tool behavior." "To discover available tools, clients send a `tools/list` request." Servers with `listChanged` "SHOULD send a notification: `notifications/tools/list_changed`."

**Anthropic tool definition (F2, F3), full text.** `name`: "Must match the regex `^[a-zA-Z0-9_-]{1,64}$`." `description`: "A detailed plaintext description of what the tool does, when it should be used, and how it behaves." `input_schema`: "A JSON Schema object defining the expected parameters for the tool." Optional `input_examples`. The good example ends: "It will not provide any other information about the stock or company."

**Anthropic engineering (F3).** "When writing tool descriptions and specs, think of how you would describe your tool to a new hire on your team." "Input parameters should be unambiguously named: instead of a parameter named `user`, try a parameter named `user_id`." "Even small refinements to tool descriptions can yield dramatic improvements."

**OpenAI (F2, F3).** `type` "Must always be `function`"; `description` "Details on when and how to use the function"; "Aim for fewer than 20 functions available at the start of a turn."

**Agent Skills token budgets (F4), full text.** Metadata "(~100 tokens)" always loaded; instructions "(< 5000 tokens recommended)" on activation; resources "loaded only when required." "Keep your main `SKILL.md` under 500 lines." `name`: max 64 characters, lowercase, hyphens, must match the directory. Skills overview: "Claude loads this metadata at startup and includes it in the system prompt. The `description` is what Claude matches your request against." Best practices, reopened: the `analyze_form.py` example gives `python scripts/analyze_form.py input.pdf > fields.json` followed by an "Output format" JSON block; checklist items "Scripts have clear documentation" and "Required packages listed in instructions and verified as available"; "Create evaluations BEFORE writing extensive documentation." Engineering post: "At startup, the agent pre-loads the `name` and `description` of every installed skill into its system prompt."

**OpenAI Agents SDK (F5).** "The name of the tool will be the name of the Python function (or you can provide a name)." "Descriptions for each input are taken from the docstring of the function, unless disabled" — parsed with griffe (google, sphinx, numpy formats).

**Anthropic, "Code execution with MCP" (F7).** "Most MCP clients load all tool definitions upfront directly into context." "Presenting tools as code on a filesystem allows models to read tool definitions on-demand, rather than reading them all up-front." "Adding a SKILL.md file to these saved functions creates a structured skill that models can reference."

**Garbas checklist (F8).** "Clear –help Output — provide one-line descriptions, grouped flags, and examples for all commands"; "Predictable Output Schemas — treat JSON output as an API contract"; cites clig.dev and MCP adoption statistics not checked here.

## Appendix B — Notes on sources

- 2: mirror edition unknown; the `--help`/`--version` requirement is stable across editions, but current wording was not read.
- 6: the two sentences first attributed to the README ("such a help message, but formalized"; conventions "used for decades") were not found on reopening and are retracted; they may be on docopt.org.
- 13: also cited for security text not used here; the specification is the standard behind F2 and F7.
- 14: no maintainer or specification author comments in the thread; dates 2025-11-05 (question) and 2026-05-09 (reply).
- 16: reached by redirect from `.../tool-use/implement-tool-use`.
- 23: reached by redirect from `platform.openai.com`; the page does not mention Pydantic or zod helpers.
- 28: single non-authoritative blog; used only in F8.
- 29: content unreadable in two attempts; nothing from it is cited.
| 3 | 2026-09-07 | state | draft → delivered by the lead-pm at the deliver step: one verification round (by the same researcher, disclosed in Limitations) and one cold read, each followed by one revise, under the single review cycle; body committed to the research branch, registered in the research index. |
