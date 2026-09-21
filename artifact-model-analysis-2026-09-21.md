# The artifact model, and what could replace it

Two parts. Part one reads the current model from the corpus and the defect
record and states what any replacement must do. Part two surveys the
alternatives against primary sources and scores each against the failures
part one found. A short section at the end says what the two parts say
together.

---

# Part one — the current model


## What the current model is

Every artifact is one markdown file. It has three kinds of content, mixed:

1. **YAML frontmatter** — identity and state (`type`, `id`, `status`,
   `version`, `owner`, dates) and links to other artifacts by path.
2. **A prose body** in level-2 sections, some of them required by the type.
3. **Typed blocks embedded as fenced code** — YAML for a process's steps and
   data, Gherkin for a feature's scenarios, Mermaid for a process's diagram.
   Plus markdown tables for Document History, Edges, and fitness screens.

Numbers from the corpus (280 files):

| class | files | words/file | L2 sections | fenced blocks |
|---|---|---|---|---|
| process definitions | 25 | 2,520 | 5.1 | yaml ×2, mermaid ×1 each |
| artifact typedefs | 24 | 1,182 | 8.0 | none |
| role definitions | 9 | 1,054 | 1.0 | none |
| features | 18 | 5,123 | 6.0 | gherkin ×1 |
| data types | 14 | 411 | 3.0 | yaml ×1 |

Two facts matter for what follows.

**The structured core already exists.** Every process definition's `## Steps`
block parses as valid YAML on its own — 23 of 23. The steps, their roles,
inputs, outputs, prompts, branches and CEL conditions are already data. The
markdown around them is a wrapper. 35% of a process file's words sit inside
fenced blocks; 65% are prose and tables.

**Two schemas share one frontmatter.** A role definition's frontmatter holds
the harness's runtime contract (`name`, `tools`, `model`, `maxTurns`) and the
corpus's identity keys (`type`, `id`, `owner`, `status`, `version`) in one
YAML mapping. Nothing says which keys belong to which consumer.

## How the tooling reads it

Every tool — 4,461 lines of Python across nine files — locates parts by
regular expression over the raw text. No markdown parser is imported anywhere.

- `artifact_tools.py`: `FM_RE` finds the frontmatter, `HEADING_RE` finds
  `## ` lines. Those are the only two addressable units.
- `compile_process.py`: `re.findall(r"```yaml\n(.*?)```")` finds the blocks;
  `**Purpose:**` and `**Guiding statement:**` are found by matching the bold
  label.
- `lint_basis.py`: 14 regular expressions. `REQUIRED_HEADINGS` checks that
  section names exist. `BANNED` scans for five strings.

So the model is: a text file with data inside it, and tools that find the
data by pattern. The pattern works until the text moves.

## Where it broke — seven failures from the defect record

**1. The unit a process is made of is not addressable.** A step is the thing
a process definition is built from. The tool cannot read or write one. It
reads a frontmatter key or replaces a whole level-2 section. To change one
step's prompt an agent replaces the entire `## Steps` section or reaches for
`sed`. Six such gaps are filed on `lead-ng3hc`; the lead-pm role itself
worked around them, which `tools-through-skills` forbids.

**2. The document contains its own rendering.** The Mermaid diagram is
regenerated from the steps by the compiler and written back into the same
file as a fenced block. Source and output live in one document. A reader
cannot tell the diagram is derived without reading the section heading's
"(compiled)" suffix.

**3. Provenance is a hand-appended table.** Document History is 36% of the
corpus by words — 102,000 words. Every row was appended by `printf` or a
heredoc, because the tool's `write` replaces a section and cannot append a
row. The most-written part of every artifact has no tool.

**4. Structure was carried in prose, and prose wraps.** The flag
`needs decision:` was a string the architect wrote into a Contributors bullet
and `product-flow` found by `grep -m1`. The guideline wraps lines at 72
columns. "needs" ended one line and "decision:" began the next. The flag
became invisible and a feature was assigned with its decision unrecorded
(`lead-ibme0`, P0).

**5. Validation checks shape, not meaning.** The lint confirms headings exist
and links resolve. It cannot validate the YAML inside a section against a
schema, because there is no schema — the typedef describes the fields in
prose. Eight features carry `status: delivered`, a value the feature typedef
does not define. Lint passes.

**6. No typed query across the corpus.** "Which features cite this ADR" is a
grep. `references` matches only `](path)` links and `.md`-ending frontmatter
strings. The rendering processes scan whole directories with `awk` for
`status: approved`.

**7. One fact, two homes, one stale.** The principle-set `scope` enum lives
in the typedef's prose. `principle-set-authoring` restated it in its data
block as `enum: [working, architecture]`. The typedef gained `experience` on
Aug 26. The process's copy did not, for three weeks. Nothing could have
caught it: neither copy is a schema the other references (`lead-qd0an`).

Two more, outside the numbered list because they are consequences:

- Two process definitions have no `## Steps` block at all
  (`definition-chain-migration`, `corpus-close-out`). The format was never
  enforced, so the compiler skips what it cannot find.
- The tooling has no `create`. A new artifact is written whole, outside any
  tool, every time.

## The diagnosis in one sentence

The corpus already has a structured core, but the structure is stored inside
prose and found by pattern, so nothing can validate it, address it, or keep
one copy of it.

## What any replacement must do

Derived from the seven failures, not from preference:

| need | test |
|---|---|
| Address the natural unit | read and write one step, one scenario, one history row, by id |
| Validate meaning | a `status` value outside the enum fails; a `$ref` to a missing type fails |
| One home per fact | an enum is defined once and referenced, never restated |
| Render, never embed | diagram, skill, prompt, guideline are outputs; none lives in its source |
| Append provenance by tool | a history row is a record the tool writes |
| Query across the corpus | "features citing this ADR" is a typed lookup |
| Create by tool | a new artifact starts from its schema, not a blank file |
| Stay readable raw and rendered | a human reads the source in a diff; an agent reads it in context |
| Keep prose as prose | a step's prompt, a rationale, a framing stay markdown, however they're stored |

The last two pull against the first seven. That tension is what part two
evaluates each alternative on.

## One thing this analysis rules out

The question was whether the Mermaid-as-quoted-block problem can be overcome
inside markdown. It can: the diagram is already generated from the steps; the
fix is to write it to its own file and include it by reference, or render it
at build time. That is a small change and would be worth making under any
model.

But it is the smallest of the seven failures. Fixing it alone leaves steps
unaddressable, enums restated, history hand-appended, and `status` values
unvalidated. The diagram was the visible symptom of a document that contains
its own derived outputs; the invisible one is that it contains its own
unvalidated data.

---

# Part two — the alternatives, against primary sources

Date: 2026-09-21. Sources are primary (specs, official docs, source repos). Every claim carries the URL that was fetched. Where a source was silent or could not be fetched, this says so.

## The current model, as the tools see it

The artifact tool reads and writes two kinds of part: a frontmatter field or a whole level-2 section (`basis/tools/artifact_tools.py`, `do_read`, `do_write`). A step inside the `## Steps` yaml block is below that grain. The process compiler regenerates the Mermaid diagram from the steps yaml and writes it back into the source file's `## Flow (compiled)` section (`basis/tools/compile_process.py`, `write_flow`). In `basis/processes/feature-authoring.md` the Document History is 446 of 1,491 words.

Two facts frame every family below. First, YAML frontmatter has no standard. CommonMark 0.31.2 contains no mention of front matter, and its author states that front matter "is not going to be part of the spec" and that an application "must strip this off, interpret it, and pass the rest to the CommonMark parser" (https://spec.commonmark.org/0.31.2/; https://talk.commonmark.org/t/front-matter-best-practice/2235). Second, every markdown AST treats a fenced block as a string. The mdast `Code` node is a `Literal` with `lang`, `meta`, and a string `value` (https://github.com/syntax-tree/mdast). The MyST schema's `code` node has the same `value: string` (https://mystmd.org/spec/myst-schema). Pandoc's is `CodeBlock Attr Text` (https://hackage-content.haskell.org/package/pandoc-types-1.23.1.2/docs/Text-Pandoc-Definition.html). So failure 1 is not a markdown failure. It is the consequence of quoting typed content inside a code fence.

## A. Typed frontmatter + markdown body with schema

**Astro Content Collections.** Collections are declared with `defineCollection({ loader, schema })`; the schema is Zod. Entries expose `id`, `data`, and "a `body` containing the raw, uncompiled body". `reference("authors")` links entries across collections. "If any file violates its collection schema, Astro will provide a helpful error." The body is untyped (https://docs.astro.build/en/guides/content-collections/). Custom loaders must call `parseData()` to validate before storing (https://docs.astro.build/en/reference/content-loader-reference/). At scale: Astro's own docs (https://github.com/withastro/docs/blob/main/src/content.config.ts).

**Contentlayer.** `defineDocumentType({ name, filePathPattern, contentType, fields, computedFields })`; content types are `markdown`, `mdx`, or `data` (https://contentlayer.dev/docs/reference/source-files/define-document-type-eb9db60e). The original repo says it "is no longer maintained due to lack of funding" (https://github.com/contentlayerdev/contentlayer); the `contentlayer2` fork is maintained (https://github.com/timlrx/contentlayer2).

**Obsidian Properties and Bases.** Properties are typed frontmatter YAML (https://obsidian.md/help/Editing+and+formatting/Properties). Bases give "database-like views of your notes" where "each row is a file, and each column is a property" (https://obsidian.md/help/bases). Query reaches properties, never the body.

**Verdict.** This family types frontmatter and queries across files (failure 6, partial; failure 7 via a shared Zod enum). Nothing in it reaches inside the body; a step stays opaque. None of the sources mention agents.

## B. Structured source, markdown as projection

**OpenAPI / AsyncAPI.** Prose lives only in `description` strings. The spec says "CommonMark syntax MAY be used for rich text representation" on Info, Server, Path Item, Operation, Parameter, Response, Tag, and others; the Schema Object's `description` does not carry that sentence (https://spec.openapis.org/oas/v3.1.0.html). `$ref` addresses any node by JSON Pointer. Redoc renders docs from the description (https://redocly.com/docs/redoc). Spectral is the semantic lint: rules have `given` (JSONPath), `then` (function), `severity`, and custom functions return `[{message, path}]` (https://github.com/stoplightio/spectral/blob/develop/docs/getting-started/3-rulesets.md; https://github.com/stoplightio/spectral/blob/develop/docs/guides/5-custom-functions.md). At scale: GitHub's REST API description (https://github.com/github/rest-api-description).

**Backstage.** `catalog-info.yaml` carries `apiVersion`/`kind`/`metadata`/`spec` (https://backstage.io/docs/features/software-catalog/descriptor-format). Entity references are `kind:namespace/name` (https://backstage.io/docs/features/software-catalog/references). Long prose lives in a separate MkDocs tree joined by the `backstage.io/techdocs-ref` annotation (https://backstage.io/docs/features/techdocs/; https://backstage.io/docs/features/software-catalog/well-known-annotations). Processors validate per kind and emit relations (https://backstage.io/docs/features/software-catalog/external-integrations/processors). This is the one surveyed design that keeps record and prose both first-class, at the cost of two files per thing.

**Kubernetes CRDs.** A structural OpenAPI v3 schema validates each resource; `description` is "Text description of the field" with no format stated (https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/; https://kubernetes.io/docs/reference/kubernetes-api/extend-resources/custom-resource-definition-v1/). `kubectl explain` renders docs from the schema (https://kubernetes.io/docs/reference/kubectl/generated/kubectl_explain/). `kubectl patch --type json` addresses a field by RFC 6902 path such as `/spec/containers/0/image` (https://kubernetes.io/docs/tasks/manage-kubernetes-objects/update-api-object-kubectl-patch/). `x-kubernetes-validations` carry CEL rules with `rule`, `message`, `fieldPath` (https://kubernetes.io/docs/reference/using-api/cel/). The shop already uses CEL for branches. cert-manager's field comments become both site docs and `kubectl explain` output (https://cert-manager.io/docs/contributing/crds/).

**Pydantic v2.** `model_json_schema()` emits Draft 2020-12 with field order preserved (https://pydantic.dev/docs/validation/latest/concepts/models/); the description comes from the class docstring or `Field(description=...)` (https://pydantic.dev/docs/validation/latest/concepts/json_schema/); errors carry a `loc` tuple path (https://pydantic.dev/docs/validation/latest/errors/errors/). Doc generators render field tables: autodoc_pydantic (https://autodoc-pydantic.readthedocs.io/en/stable/) and griffe-pydantic for mkdocstrings (https://mkdocstrings.github.io/griffe-pydantic/). At scale: FastAPI (https://fastapi.tiangolo.com/features/).

**json-schema-for-humans / jsonschema2md.** Both produce field-reference pages from a schema; the former has a `description_is_markdown` option (https://raw.githubusercontent.com/coveooss/json-schema-for-humans/main/README.md; https://github.com/adobe/jsonschema2md).

**MADR / log4brains / adr-tools.** MADR 4.0 is a template with frontmatter and fixed headings; its only lint is markdownlint (https://raw.githubusercontent.com/adr/madr/develop/README.md). log4brains has "No enforced markdown structure" (https://raw.githubusercontent.com/thomvaill/log4brains/master/README.md). adr-tools inserts a line after `## Status` by regex (https://raw.githubusercontent.com/npryce/adr-tools/master/src/_adr_add_link): the shop's own hand-append mechanism, in shell.

**Verdict.** Family B solves failures 1, 5, 6, and 7 directly: every node has a path, lint runs over a typed tree, query is a tree walk, and an enum lives once in the schema. Failure 2 is solved only because the rendering is a projection the source never contains. Failures 3 and 4 are solved if the schema models history and flags as typed lists. The cost: all prose becomes `description` strings. JSON Schema's `description` "MUST be a string" and says nothing about format (https://json-schema.org/draft/2020-12/json-schema-validation). Headings, links, and prose lint over Purpose, Outcomes, and step prompts are lost unless the renderer re-creates them. No source mentions agents.

## C. Configuration languages with schema and docs built in

**CUE.** "Types are values"; definitions (`#Foo`) are closed structs (https://cuelang.org/docs/concept/the-logic-of-cue/). `cue vet -c` checks data files against constraints (https://cuelang.org/docs/concept/how-cue-enables-data-validation/); `cue export --out yaml|json` and `cue eval -e <expr>` read by path (https://cuelang.org/docs/reference/command/cue-help-eval/). Comments reach the Go API via `Value.Doc()` (https://pkg.go.dev/cuelang.org/go/cue), but a maintainer states `cue export` "does not (currently) have a way of saying 'please also export comments'" (https://github.com/cue-lang/cue/discussions/1178) and no `cue doc` command exists (https://cuelang.org/docs/reference/command/). Write-back is parse, edit AST, reformat (https://pkg.go.dev/cuelang.org/go/cue/ast/astutil). Dagger dropped CUE in 2023 (https://dagger.io/blog/ending-cue-support/); Grafana's `cog` still generates its SDK from CUE (https://github.com/grafana/cog).

**Pkl.** Typed classes with constraints such as `Int(isBetween(0, 1023))`; `///` doc comments "are processed by Pkldoc"; triple-quoted strings keep indentation relative to the closing delimiter (https://pkl-lang.org/main/current/language-reference/index.html). Pkldoc produces "navigable and searchable API documentation" as HTML (https://pkl-lang.org/main/current/pkl-doc/index.html). `pkl eval -f json|yaml|xml|plist|properties|textproto|jsonnet|pcf` and `-x <expression>` read by path (https://pkl-lang.org/main/current/pkl-cli/index.html). The LSP has hover, go-to-definition, and formatting; rename and find-references "remain unimplemented" (https://github.com/apple/pkl-lsp). No source-editing API was found. Code generation for Go, Java, Kotlin, Swift (https://pkl-lang.org/go/current/index.html).

**Dhall.** Typed, total, hashed imports; `dhall-docs` builds HTML from per-file header comments only (https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-docs). At scale: dhall-kubernetes (https://github.com/dhall-lang/dhall-kubernetes).

**Nickel.** Contracts and metadata: `| doc "..."`, `| default`, enum contracts `[| 'a, 'b |]` (https://nickel-lang.org/user-manual/contracts/). `nickel query --field <path>` prints a field's documentation, contract, and default (https://raw.githubusercontent.com/tweag/nickel/master/cli/src/cli.rs); `nickel doc` renders markdown docs (https://raw.githubusercontent.com/tweag/nickel/master/cli/src/doc.rs). No set-by-path. At scale: Organist (https://github.com/nickel-lang/organist).

**Jsonnet.** No schema, no doc comments (https://jsonnet.org/ref/language.html). At scale: Grafana Tanka (https://tanka.dev/).

**KDL.** 2.0 finalized December 2024 (https://github.com/kdl-org/kdl); its schema language dates from 2021 (https://github.com/kdl-org/kdl/blob/main/SCHEMA-SPEC.md) and its query language is unreleased (https://github.com/kdl-org/kdl/blob/main/QUERY-SPEC.md). At scale: Zellij (https://zellij.dev/documentation/configuration.html).

**HCL and YAML round-trip, for contrast.** HCL's `hclwrite` makes "specific surgical changes to existing HCL configurations" and preserves comments and newlines when unchanged (https://pkg.go.dev/github.com/hashicorp/hcl/v2/hclwrite). For YAML, the spec says comments "must not be used to convey content information" (https://yaml.org/spec/1.2.2/). ruamel.yaml "supports roundtrip preservation of comments, seq/map flow style, and map key order", broken only by structural deletes (https://pypi.org/project/ruamel.yaml/; https://yaml.dev/doc/ruamel.yaml/overview/). yq edits in place by path and "attempts to preserve comment positions and whitespace as much as possible" (https://mikefarah.gitbook.io/yq/).

**Verdict.** CUE, Pkl, and Nickel give one home for an enum, schema validation, path reads, and doc comments a generator renders (Pkl and Nickel; CUE only through Go). None of them writes back to source; they evaluate to a value. Only hclwrite, ruamel.yaml, and yq do path-addressed writes that keep comments. So this family solves 5, 6, and 7, and 1 for reads; for writes it needs an AST round-trip. No source mentions agents.

## D. Extensible document markup with directives

**reStructuredText / Sphinx domains / MyST.** A directive is `.. name::` with arguments, `:option:` fields, and an indented body (https://docutils.sourceforge.io/docs/ref/rst/directives.html). A Sphinx domain is "a collection of markup ... to describe and link to objects belonging together"; `py:function` declares an object, `:py:func:` links to it, and the domain "will typically keep an internal index of all entities" (https://www.sphinx-doc.org/en/master/usage/domains/index.html). A custom domain implements `get_objects()` and `resolve_xref()` (https://www.sphinx-doc.org/en/master/development/tutorials/adding_domain.html). Every build writes `objects.inv`, a corpus-wide object index (https://www.sphinx-doc.org/en/master/usage/extensions/intersphinx.html). MyST writes directives as fenced ```` ```{name} ```` blocks with `:key: val` options (https://myst-parser.readthedocs.io/en/latest/syntax/roles-and-directives.html). The MyST spec defines a `mystDirective` node with `name`, `args`, `options` (object), `value`, and `children` (https://mystmd.org/spec/myst-schema). This is the one markdown dialect whose spec gives a typed block a parsed `options` object. At scale: CPython docs (https://devguide.python.org/documentation/markup/); Jupyter Book on MyST (https://jupyter-book.readthedocs.io/v1/content/myst.html).

**AsciiDoc.** Any block takes `[#id .role key="value"]` attributes and unknown attributes "will be stored on the element" (https://docs.asciidoctor.org/asciidoc/latest/attributes/element-attributes/). `include::file[tag=name]` pulls a tagged region (https://docs.asciidoctor.org/asciidoc/latest/directives/include/). `doc.find_by(context:, id:)` walks the tree (https://www.rubydoc.info/gems/asciidoctor/Asciidoctor/AbstractBlock). No write-back API. At scale: Pro Git 2 (https://github.com/progit/progit2).

**MDX.** Markdown plus JSX; a component is an `MdxJsxFlowElement` node with typed `attributes` (https://github.com/syntax-tree/mdast-util-mdx-jsx); frontmatter "is not supported by default" (https://mdxjs.com/guides/frontmatter/); rendering needs a JS runtime. At scale: Docusaurus (https://docusaurus.io/docs/markdown-features/react).

**DITA.** XML topic types with specialization (https://docs.oasis-open.org/dita/dita/v1.3/os/part1-base/archSpec/base/specialization.html); `@conref` reuses content with validity checks (https://docs.oasis-open.org/dita/dita/v1.3/os/part1-base/archSpec/base/conref.html); keys give map-level indirection (https://docs.oasis-open.org/dita/dita/v1.3/os/part1-base/archSpec/base/keys-core-concepts.html). DITA-OT outputs html5, pdf, and markdown (https://www.dita-ot.org/dev/topics/output-formats.html).

**Djot.** CommonMark-derived; attributes `{.class #id key="value"}` attach to any block; no generic directive (https://github.com/jgm/djot/blob/main/doc/syntax.md). No large production user confirmed.

**Verdict.** Yes, a document format can carry typed blocks natively: MyST `{directive}` with an `options` object, Pandoc fenced divs with `Attr`, AsciiDoc blocks with attributes, DITA elements. That gives failure 1 a parsed node instead of a string, and Sphinx domains give failure 6 a real object index. Validation of a directive's body is per directive class, not a schema; write-back is by hand or by re-emitting the tree. Failure 7 is solved by DITA keys or a Sphinx domain registry, not by rST itself.

## E. AST-first markdown tooling

**unified / remark / mdast.** Parse, transform, stringify over mdast (https://unifiedjs.com/learn/guide/introduction-to-unified/). `Code` is `{ type: 'code', lang, meta, value: string }` (https://github.com/syntax-tree/mdast). `remark-frontmatter` "Doesn't parse the data inside them" (https://github.com/remarkjs/remark-frontmatter). `unist-util-select` gives CSS-like selectors over nodes (https://github.com/syntax-tree/unist-util-select); every node carries `position` (https://github.com/syntax-tree/unist). `remark-directive` adds `:::name{attrs}` container nodes with `name` and `attributes` (https://github.com/remarkjs/remark-directive). Round-trip: `mdast-util-to-markdown` "will do its best to serialize markdown to match the syntax tree, but there are several cases where that is impossible" (https://github.com/syntax-tree/mdast-util-to-markdown).

**Pandoc.** `INPUT --reader--> AST --filter--> AST --writer--> OUTPUT`; `pandoc -t json` emits the AST (https://pandoc.org/filters.html). `Div Attr [Block]`, `CodeBlock Attr Text`, `Attr = (id, classes, key-values)`; fenced divs `::: {.class}` and code attributes `{#id .lang key=val}` (https://pandoc.org/demo/example33/8.18-divs-and-spans.html; https://pandoc.org/demo/example33/8.5-verbatim-code-blocks.html). Lua filters replace elements by type (https://pandoc.org/lua-filters.html). "Pandoc attempts to preserve the structural elements of a document, but not formatting details" (https://pandoc.org/MANUAL.html). At scale: Quarto (https://quarto.org/docs/extensions/filters.html).

**markdown-it.** A token stream, not a tree (https://github.com/markdown-it/markdown-it/blob/master/docs/architecture.md); `markdown-it-attrs` puts `{#id}` on fences (https://github.com/arve0/markdown-it-attrs). At scale: VitePress (https://vitepress.dev/guide/markdown).

**CommonMark info string.** "The first word of the info string is typically used to specify the language"; the rest is free text and mdast exposes it as `meta` (https://spec.commonmark.org/0.31.2/#fenced-code-blocks). An id can ride there today.

**Verdict.** The failure is not markdown's. It is that the typed content sits in a `code` string. AST tooling can find the fence by section and `meta`, but reaching a step needs a second parser (ruamel.yaml or yq) over `value`, and writing back needs both parsers to round-trip. remark and Pandoc rewrite formatting on output. Nothing here validates or queries typed content by itself.

## F. Workflow and process definition precedents

**GitHub Actions.** `jobs.<job_id>` with `needs`, `if`, `outputs`, `steps[]` (`id`, `name`, `run`/`uses`, `with`, `if`); reusable-workflow inputs carry `type`, `description`, `default` (https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions). Steps are addressed as `steps.<id>.outputs.<name>` (https://docs.github.com/en/actions/reference/workflows-and-actions/contexts). The schema is community-maintained (https://www.schemastore.org/github-workflow.json). The run graph is drawn from `needs` (https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/using-the-visualization-graph). actionlint type-checks expressions and detects `needs` cycles (https://github.com/rhysd/actionlint).

**Argo Workflows.** `Template` has `inputs`, `outputs`, and `steps` or `dag`; `WorkflowStep` has `name`, `template`, `arguments`, `when`; `Parameter` has `enum` and `description` (https://raw.githubusercontent.com/argoproj/argo-workflows/main/api/jsonschema/schema.json). Templates have no description field; titles and descriptions ride annotations, which since v3.6 may embed Markdown (https://argo-workflows.readthedocs.io/en/latest/title-and-description/). `argo lint` validates (https://argo-workflows.readthedocs.io/en/latest/cli/argo_lint/).

**CWL v1.2.** `Workflow` has `inputs`, `outputs`, `steps`; `WorkflowStep` has `id`, `in`, `out`, `run`, `when`, `scatter`, `label`, `doc` (https://www.commonwl.org/v1.2/Workflow.html). `doc` is "A documentation string for this object, or an array of strings which should be concatenated". The schema language, Schema Salad, has `doc`, `docParent`, `docChild` fields "to facilitate self-documenting schemas" and `schema-salad-tool --print-doc` renders HTML (https://www.commonwl.org/v1.2/SchemaSalad.html; https://github.com/common-workflow-language/schema_salad). The CWL spec's own `doc` blocks contain `##` headings and code spans (https://raw.githubusercontent.com/common-workflow-language/cwl-v1.2/main/Workflow.yml), and schema-salad depends on the mistune markdown parser (https://pypi.org/pypi/schema-salad/json). `cwltool --validate` and `--print-dot` (https://cwltool.readthedocs.io/en/latest/cli.html). CWL is the closest precedent: a YAML process definition whose schema and whose docs are both generated from one self-documenting source.

**Temporal.** Workflows are code; no declarative schema; the UI shows event history, not a diagram (https://docs.temporal.io/workflows; https://docs.temporal.io/web-ui).

**Dagster.** `@op(description=...)` falls back to the docstring (https://docs.dagster.io/api/dagster/ops). Lineage is drawn from `Definitions` (https://docs.dagster.io/guides/operate/webserver). YAML components exist: `defs.yaml` with `type` and `attributes`, checked by `dg check yaml` against schemas (https://docs.dagster.io/guides/build/components/building-pipelines-with-components/adding-component-definitions; https://docs.dagster.io/api/clis/dg-cli/dg-cli-reference).

**BPMN 2.0.** `sequenceFlow` has `sourceRef`, `targetRef`, `conditionExpression`; every element may carry `documentation` with `textFormat` defaulting to `text/plain` (https://www.omg.org/spec/BPMN/20100501/Semantic.xsd). `tDefinitions` holds both `rootElement` and `bpmndi:BPMNDiagram` (https://www.omg.org/spec/BPMN/20100501/BPMN20.xsd); each `BPMNShape` points at its semantic element through `bpmnElement` (https://www.omg.org/spec/BPMN/20100501/BPMNDI.xsd). The diagram lives in the same file, in a separate section, and references the model; the model never references the diagram. bpmn-auto-layout generates DI when it is absent (https://github.com/bpmn-io/bpmn-auto-layout).

**SCXML.** `<state id>`, `<transition event cond target>`; no documentation element and no diagram interchange (https://www.w3.org/TR/scxml/).

**Structurizr DSL.** `workspace { model views }` with `autoLayout`; `!docs` attaches "Markdown/AsciiDoc documentation" and `!adrs` imports ADRs (https://docs.structurizr.com/dsl/language). Docs embed a diagram by key: `![](embed:MyDiagramKey)` (https://docs.structurizr.com/ui/documentation/diagrams). `workspace.dsl` is source; `workspace.json` is "the 'compiled' version ... including diagram layout information" (https://docs.structurizr.com/workspaces/file-types). Export to mermaid, plantuml, d2, dot, one file per view (https://docs.structurizr.com/cli/export).

**Serverless Workflow.** `do` is an ordered map of named tasks with `if` and `then`; `document.summary` is "The workflow's Markdown summary" (https://raw.githubusercontent.com/serverlessworkflow/specification/main/schema/workflow.yaml).

**Verdict.** Every precedent computes the diagram from the definition and never writes it back into the semantic block (failure 2). Prose is a string field per node: `description`, `doc`, `documentation`, `summary`; markdown in it is explicit in CWL, Argo annotations, Serverless `summary`, and Airflow `doc_md` (https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dags.html). None carries a long multi-line prompt as a step body; the shop's `prompt` field has no precedent here. Steps are addressed by id everywhere.

## G. Cell and notebook models

**Jupyter nbformat.** JSON with `cells[]`; each cell has `cell_type`, `metadata`, `source`, and, since 4.5, a required `id` of 1 to 64 chars matching `^[a-zA-Z0-9-_]+$`, unique per notebook (https://nbformat.readthedocs.io/en/latest/format_description.html; https://github.com/jupyter/nbformat/blob/main/nbformat/v4/nbformat.v4.schema.json). `nbformat.validate(nb, ref="code_cell")` validates a cell against its sub-schema (https://nbformat.readthedocs.io/en/latest/api.html). Line diffs fail on it; nbdime is content-aware and installs git drivers (https://nbdime.readthedocs.io/en/latest/).

**Jupytext.** Stores a notebook as `.md` or `.py`; "Cell metadata are appended after the language information, with a `key=value` syntax, where `value` is encoded in JSON format"; markdown cells with metadata use `<!-- #region key="value" -->`; MyST format puts a YAML block inside the cell (https://jupytext.org/formats/markdown/). Percent format uses `# %% [markdown] key="value"` (https://jupytext.org/formats/scripts/). The text file is the versioned source; the `.ipynb` is re-created (https://jupytext.org/using/paired-notebooks/). This is the direct precedent for typed, addressable cells stored in markdown with metadata on the fence line.

**marimo.** Notebooks are Python; each cell is an `@app.cell` function and the DAG comes from variable references (https://docs.marimo.io/guides/reactivity/). A markdown form tags fences `{.marimo name="x"}` (https://github.com/marimo-team/marimo/blob/main/marimo/_tutorials/markdown_format.md).

**Quarto.** `.qmd` is markdown with a YAML header and ```` ```{python} ```` cells whose options are `#|` comment lines (https://quarto.org/docs/get-started/hello/text-editor.html). Options are typed (https://quarto.org/docs/reference/cells/cells-jupyter.html) and validated on save (https://quarto.org/docs/tools/vscode/index.html); render errors read "Validation of YAML cell metadata failed. (line 9, columns 4--16)" (https://github.com/quarto-dev/quarto-cli/discussions/2433). `{{< include _file.qmd >}}` pastes text (https://quarto.org/docs/authoring/includes.html). `{{< embed nb.ipynb#cell-id >}}` addresses a cell in another file by `id`, then `label`, then `tags` (https://quarto.org/docs/authoring/notebook-embed.html).

**Verdict.** This family solves failure 1 by construction: parts have ids and types, and Claude Code's own `NotebookEdit` edits "one cell at a time, targeting cells by their `cell_id`" (https://code.claude.com/docs/en/tools-reference). Quarto shows typed, schema-validated cell options in a markdown file (failure 5) and cross-file addressing by id (toward failure 6). The JSON form diffs badly; every project converged on a text twin as source of truth.

## H. Diagrams as separately rendered sources

Mermaid CLI renders `.mmd` and can rewrite fences in a markdown file into images (https://github.com/mermaid-js/mermaid-cli); GitHub renders inline fences only, with no include (https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams). PlantUML has `!include` (https://plantuml.com/preprocessing), D2 imports `@file` (https://d2lang.com/tour/imports), Graphviz renders DOT (https://graphviz.org/doc/info/command.html), and Kroki serves 30+ engines over HTTP (https://kroki.io/). Include-by-reference in markdown: MkDocs `pymdownx.snippets` `--8<-- "file.mmd"` works inside a fence (https://facelessuser.github.io/pymdown-extensions/extensions/snippets/); mkdocs-kroki `@from_file:` (https://github.com/AVATEAM-IT-SYSTEMHAUS/mkdocs-kroki-plugin); Docusaurus `raw-loader` import (https://docusaurus.io/docs/markdown-features/react); Structurizr `embed:Key`.

**Verdict.** Failure 2 has two standard fixes: keep the diagram in a sibling file and include it by reference at render time, or generate it at render time from the definition (family F). Both need a renderer step; GitHub's viewer will not follow an include.

## The four further questions

**Does JSON Schema or Pydantic give a document with an ordered prose body?** No. JSON Schema's `description` "MUST be a string" (https://json-schema.org/draft/2020-12/json-schema-validation). Pydantic maps a docstring or `Field(description)` to that keyword and nothing more (https://pydantic.dev/docs/validation/latest/concepts/json_schema/). Every Pydantic or schema doc generator surveyed renders a field table per record. An ordered body is either one string field or a list of typed section objects, in which case the ordering lives in the schema. sphinx-jsonschema allows rST in `description` but was archived April 2026 (https://github.com/lnoor/sphinx-jsonschema); sphinx-pydantic is dormant (https://sphinx-pydantic.readthedocs.io/en/latest/).

**Do LLM tool specs carry markdown in structured fields?** Anthropic defines `description` as "A detailed plaintext description of what the tool does" and asks for "at least 3–4 sentences" (https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools). MCP's `Tool.description` is "Human-readable description of functionality"; markdown appears only as a resource `mimeType: text/markdown` (https://modelcontextprotocol.io/specification/2025-06-18/server/tools; https://modelcontextprotocol.io/specification/2025-06-18/server/resources). OpenAI's `description` is "Details on when and how to use the function" (https://developers.openai.com/api/docs/guides/function-calling). Long prose in a structured field is the norm. Markdown in it is licensed only by OpenAPI, and only outside Schema Objects.

**Evidence on LLMs editing YAML/JSON vs markdown.** Thin, and none of it measures in-place editing. Tam et al. find "a significant decline in LLMs reasoning abilities under format restrictions" (https://arxiv.org/abs/2408.02442). StructuredRAG finds JSON compliance "ranging from 0 to 100%" across tasks (https://arxiv.org/abs/2408.11061). He et al. find prompt format swings GPT-3.5 "by up to 40%"; larger models are more robust (https://arxiv.org/abs/2411.10541). Aider measured code returned in JSON scoring 5 to 11 points below markdown fences (https://aider.chat/2024/08/14/code-in-json.html). The one hard mechanical fact: Claude Code's Edit "performs exact string replacement" and "A single character of whitespace or indentation difference is enough to miss" (https://code.claude.com/docs/en/tools-reference). YAML is indentation-sensitive. No source measures that risk. The "YAML uses fewer tokens" claim has no primary source found.

**The compiled shape Anthropic requires.** SKILL.md is YAML frontmatter plus a markdown body: `name` at most 64 chars, lowercase, digits, hyphens; `description` non-empty and at most 1024 chars; body "Under 5k tokens", "under 500 lines", references one level deep (https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview; https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices). The open spec adds that the body has "no format restrictions" (https://agentskills.io/specification). Claude Code's skill frontmatter adds `allowed-tools`, `model`, `context`, `agent`, `hooks`, `paths`, `metadata` (https://code.claude.com/docs/en/skills). Subagents at `.claude/agents/<name>.md` take `name`, `description`, `tools`, `disallowedTools`, `model`, `permissionMode`, `maxTurns`, `skills`, `mcpServers`, `hooks`, `memory`, `background`, `isolation`, `color`, and more; "The Markdown body after the frontmatter becomes the system prompt" (https://code.claude.com/docs/en/sub-agents). CLAUDE.md `@path` imports go four hops deep and skip fenced code (https://code.claude.com/docs/en/memory). Whatever the source format, the renderer must emit exactly frontmatter plus markdown.

## Comparison

| Family | 1 step addressable | 2 diagram in source | 3 history by tool | 4 structure in prose | 5 semantic lint | 6 typed query | 7 one enum home |
|---|---|---|---|---|---|---|---|
| A typed frontmatter | no | no | partial (frontmatter list) | partial | partial (frontmatter) | partial | partial |
| B structured source | solves | solves | solves | solves | solves | solves | solves |
| C config languages | partial (read; no write-back) | solves | partial | solves | solves | solves | solves |
| D directive markup | partial (parsed node) | partial | no | solves | partial | solves (Sphinx/DITA) | partial |
| E markdown AST | partial (needs second parser) | no | partial | partial | no | no | no |
| F workflow YAML | solves | solves | partial | solves | solves | partial | solves |
| G cells in markdown | solves | partial | partial | solves | partial (Quarto) | partial | no |
| H external diagrams | no | solves | no | no | no | no | no |

"Solves" means the family's primary sources show the mechanism; "partial" means it needs a convention or a second tool on top; "no" means the sources offer nothing.

## Which models fit best

Three models fit the seven failures, each with a distinct cost. First, a CWL-style structured source (B/F): a YAML or Pydantic-modelled definition whose schema validates steps, enums, and history, whose documentation and diagram are both generated from it, and whose steps are addressed by id; the cost is that Purpose, Outcomes, and step prompts become string fields, markdown inside them is unvalidated by any schema tool, and no precedent carries a multi-line prompt as a step body. Second, a Jupytext- or Quarto-style markdown with typed, id-bearing parts (G, using MyST's `mystDirective` or a fence-line `meta` id from D/E): the file stays the human document and the Claude load-point shape, each step becomes a parsed node with schema-validated options, and the history becomes a typed part the tool appends to; the cost is that the shop writes and maintains its own parser, lint, and cross-file query, since no off-the-shelf tool does all three, and the diagram still needs to move to a sibling file or a render step. Third, the Backstage split (B): a typed record file beside a prose markdown file, joined by a reference, which solves every structural failure with off-the-shelf schema tools and leaves prose as real markdown; the cost is two files per definition and a join the tools must maintain. The decision is the authority's.

---

# What the two parts say together

**The preference to test was a stricter Pydantic or JSON Schema model.** Part
two finds it solves four of the seven failures outright — steps addressable
by path, semantic validation, typed query, one home per enum — and the diagram
failure by construction, since a rendering is never written back into a
schema-validated source. It also finds the cost precisely: JSON Schema's
`description` "MUST be a string", every Pydantic doc generator emits a field
table, and no workflow precedent surveyed carries a long multi-line prompt as
a step body. Under that model, Purpose, Outcomes, rationales, and step
prompts become string fields. The prose the corpus is mostly made of — 65%
of a process file — loses its structure and its lint.

**The failure that started this — the diagram quoted inside its source — is
real but small.** Every workflow precedent computes the diagram from the
definition and never writes it back. BPMN is the only format that keeps a
rendering in the same file, and it does so in a separate section that
references the model by id, never the reverse. The shop's compiler does the
opposite: it writes the output into the source's body. The fix is one
sibling file per diagram, or a render step. Worth doing under any model, and
it does not decide the model.

**The failure that should decide the model is the first one.** A step is the
unit a process is made of, and no tool can touch one. Part two shows this is
not markdown's fault: every markdown AST — mdast, MyST, Pandoc — makes a
fenced block a `value: string`. The steps are unaddressable because they
were *quoted* into a fence, not because they are in a markdown file. Two
families give a typed block a parsed node inside a document: MyST's
`mystDirective` with an `options` object, and the notebook cell model, where
every part carries an `id` and Claude Code's own `NotebookEdit` targets cells
by that id. Those keep the file a document. Family B keeps the data a record
and renders the document.

**Three fits survive, and they differ on one axis: where the prose lives.**

| model | prose lives | structure lives | cost |
|---|---|---|---|
| CWL-style structured source | string fields inside the record | the record | prose is unvalidated, un-linted, unshaped |
| Markdown with typed, id-bearing parts | the document | typed nodes inside it | the shop writes its own parser, lint, and query |
| Backstage split | a markdown file | a typed record beside it | two files per definition, a join to maintain |

The corpus today is the second model, minus the types, minus the ids, minus
the parser — which is why it broke the way it did. The question the
authority is choosing on is whether the shop is willing to own that parser,
or would rather adopt off-the-shelf schema tooling and accept prose as
strings or as a second file.

**Two findings that bear on any choice, from outside the seven failures.**
The compiled outputs are fixed: Anthropic requires SKILL.md and subagent
files as YAML frontmatter plus a markdown body, and the body becomes the
system prompt verbatim. Whatever the source, a renderer to exactly that
shape is needed — so the source need not be that shape. And the evidence on
whether models edit YAML or markdown more reliably is thin and measures
generation, not editing; the one hard fact is that Claude Code's `Edit` is
exact-string replacement and YAML is indentation-sensitive. Nothing measured
that risk.

The decision is the authority's.
