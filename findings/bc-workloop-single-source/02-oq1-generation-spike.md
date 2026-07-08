SPIKE — throwaway prototype (scratch under scratchpad, torn down); this findings doc is the durable output per ADR-030/032. NOT authoritative over ADRs/PDRs.

# OQ1 generation spike — how much structure does the composition manifest need?

**Question (OQ1).** David has decided the direction is **(b): single-source the BC
work-loop via a LIGHT structured layer (a composition manifest) over the EXISTING,
UNCHANGED role/skill Markdown**, generalizing to any number of target systems. This
spike proves *how much* structure that manifest actually needs, and whether the existing
Markdown suffices as the content source under a thin manifest, or whether the prose
itself must gain structure.

**Method.** Prototyped a deterministic generator (`gen.py`, Python 3.11, in the
scratchpad) that reads a light TOML manifest + the current role/skill Markdown and emits
fabro-DOT node bodies for **2 representative nodes**:
- `impl` — an **agent** node composing a role bias (`bc-implementer`) + **three** skills
  (`test-driven-development`, `using-git-worktrees`, `subagent-driven-development`).
- `wdg_r` — a **native gate/judgment** node (the `work-done-gate` five checks).

Source content was resolved from the canonical surface where available: the real
`bc-implementer`/`bc-reviewer` templates via `shop-templates show`, and the real
`test-driven-development` skill from `drafts/skills/`. The other three skills are **not
poured on the lead host** (see Risk R1) so representative, clearly-flagged spike
stand-ins were vendored into the scratchpad source tree. The graph contract is ADR-051
(`emit_r` sole gated emitter, native `script=` scoping, fail-closed outcome edges).

---

## VERDICT

**(b)-from-existing-Markdown is FEASIBLE — with one sharp caveat that splits the node
population in two.**

- **Agent nodes (`impl`): YES, existing Markdown is sufficient as-is.** A **10-line**
  manifest block drove the inlining of **23,639 chars of UNCHANGED source prose** into a
  faithful, gate-complete, `fabro validate`-OK node body — deterministically. The prose
  was **not modified**; only **3 mechanical text transforms** fired across the whole body
  (1 skill-invocation rewrite, 2 "via the Skill tool" rewrites). No structure was added
  to the prose itself.

- **Native gate nodes (`wdg_r`): NO — the executable content cannot come from the prose.**
  ADR-051 D3 mandates that gate/state-changing nodes be **native `script=`** (deterministic,
  no LLM). The English five-check prose does **not** mechanically compile to the
  `git status --porcelain … && git log origin/main -E --grep … && grep -rqE '@scenario_hash…'`
  bash pipeline. The manifest must therefore **carry the script as first-class content**
  (5-line block). The prose is retained only as a provenance comment. This is the one place
  structure is required beyond thin metadata — and it lives in the **manifest**, not the prose.

So: the existing Markdown suffices as the *content source* for the judgment (agent) half of
the loop; the *deterministic* (native) half needs its executable form authored in the
manifest. Neither case required rewriting the prose. **The prose stays unchanged; the
structure lives entirely in the thin manifest.**

---

## Manifest schema landed (the light structured layer)

Per-node metadata over unchanged Markdown — it **names source units** and carries
**translation directives**; it never copies prose. Measured size: **19 non-comment
declared lines total** for 2 nodes + a shared target block (`impl`=10, `wdg_r`=5,
`[target]`=4 shared → ~5–10 lines/node).

```toml
[target]                       # generalizes to any substrate — not fabro-only
system   = "fabro"
work_var = "WORK_ID"           # env-overlay input channel (ADR-051 D3)
bc_var   = "BC_NAME"

[node.impl]                    # AGENT node
kind        = "agent"
role        = "bc-implementer"                 # source unit: role template (unchanged MD)
skills      = ["test-driven-development",       # source units: skills (unchanged MD, inlined in order)
               "using-git-worktrees",
               "subagent-driven-development"]
class       = "coding"         # translation: source `model: inherit` -> target tier
parallel    = true             # translation: Task/subagent fan-out -> parallel=true
permissions = "read-write"     # translation: source `tools:` -> permissions=
lane        = "You are the implementation step ONLY … MUST NOT push/emit/consume inbox …"

[node.wdg_r]                   # NATIVE gate node (ADR-051 D3)
kind        = "native-gate"
provenance  = "work-done-gate"  # source unit (prose) — emitted as traceability comment only
permissions = "read-write"
script      = "cd \"../wt-${WORK_ID}\" || exit 1; git fetch origin …; … || exit 1"
```

Translation directives are the four claude-TUI→target mappings named in the task:
`Skill-invocation → inlined prose` (applied by the generator: inline the named skill body,
rewrite the invocation reference — 3 transforms fired), `model → class=`, `Task fan-out →
parallel=true`, `tools → permissions=`. Each is a fixed, deterministic field or substitution.

---

## Determinism check — PASS (byte-identical)

Generator run twice into `out1/` and `out2/`; `sha256sum` on every artifact:

| artifact | sha256 (both runs identical) |
|---|---|
| `impl.node.dot` | `6fc981bc97f617f3ce81acb2660078b7dbb3fb080ab0bcf370ab3a35c156b43f` |
| `wdg_r.node.dot` | `3bd796604327907ab89279adf8f3d183c7a4228739fde36395074ad14149a088` |
| `workflow.fabro` | `d8d37ddd09a54b563edf4fffe3ce3a7f8dc34f43d5ffc29ca33b291532f98c0c` |
| combined tree | `aa915c25a4045b810b60d96f7a32e1327d34cae0ad0fb83b4e380d74f65d3723` |

Deterministic by construction: sorted node iteration, no timestamps, no randomness.

## Validate check — PASS (real binary)

`fabro 0.254.0 (497aaba)` is present on this host. Assembled the 2 generated nodes into a
minimal ADR-051-shaped skeleton (start → impl → wdg_r → emit_r → done, with the D2
fail-closed `condition="outcome=failed"` → `emit_blk`/`halt` edges):

```
$ fabro validate workflow.fabro
Workflow: Oq1Spike (7 nodes, 8 edges)
Validation: OK
EXIT_CODE=0
```

Caveat inherited from the fabro-spike findings: `fabro validate` is **permissive on node
attrs** — it confirms graph shape/topology, not handler classification. A live `fabro run`
preflight (the authoritative classifier for agent-vs-native) is a stronger gate this spike
did not exercise.

---

## The crux, quantified — how much structure, and what resisted

| dimension | agent node `impl` | native gate `wdg_r` |
|---|---|---|
| manifest lines | 10 | 5 |
| unchanged source prose consumed | 23,639 chars | 0 (prose is comment-only) |
| generated body size | 24,104 chars | 652 chars |
| executable content origin | inlined MD (unchanged) | **manifest `script=`** |
| mechanical transforms fired | 3 | 0 |

**Content that resisted mechanical translation (3 categories):**

1. **Native-gate executable script.** English gate prose → bash pipeline is not a
   mechanical transform. Carried in the manifest. *(the sharpest finding)*
2. **Facts that map to graph TOPOLOGY, not prose.** "Hand off to the Reviewer",
   "Reviewer is sole `work_done` emitter", and each node's **scoping lane** ("MUST NOT
   push / emit / consume inbox") are *graph* facts. The role prose is written for a
   standalone TUI agent that fans out via the Task tool and hands off via a subagent —
   not for a scoped, single-lane graph node. These are declared as the manifest `lane`
   field + the graph edges, and are **not derivable from the role Markdown**.
3. **Tier/permission/parallel directives.** `model: inherit → class`, `tools →
   permissions`, `Task fan-out → parallel=true` — trivial declared fields (3 of them).

**Verbosity note (not a correctness issue).** Mechanical inlining produced a **24 KB**
`impl` body vs the reference hand-port's compressed **~4.4 KB** `prompt=` (≈5.4× larger).
The reference's compression is a human judgment step; it is **not required** for validity
or gate fidelity (the verbose body preserves every gate verbatim and validates), but it is
a real **token-cost** consideration for live `fabro run`. A future generator could add an
optional deterministic compression pass, but that is an optimization, not a blocker.

---

## Residual risks

- **R1 — source resolution on the lead host is incomplete.** Only `bc-implementer`,
  `bc-reviewer` (via `shop-templates`) and `test-driven-development` (`drafts/skills/`)
  are resolvable here; `using-git-worktrees`, `subagent-driven-development`,
  `work-done-gate`, `bc-review`, `integrating-to-main` are **not poured on the lead
  host** (consistent with the "no BC source on lead" model — skills live in the BC
  sandbox `skills_dir`). A real single-source generator needs a **defined source-unit
  resolution path** (a `shop-templates`-style skill export, or a canonical skills package
  the lead can read). This spike used flagged stand-ins for the missing three.
- **R2 — validate is necessary, not sufficient.** Handler classification (agent vs
  native `script=`, the anti-collapse guarantee of ADR-051 D3) is only authoritative at
  `fabro run` preflight, not `fabro validate`. A generated def can validate OK yet
  mis-classify a node. Next gate: a live preflight on a generated def.
- **R3 — the manifest `lane`/scoping directive is hand-authored per node.** It is the
  one prose field the manifest carries (not a pointer). It is thin (1 line) but it *is*
  authored content, so it is a place where per-node judgment re-enters. It cannot be
  eliminated because it encodes a graph-topology fact absent from the role prose.

---

## Recommendation — SPLIT THE SEAM: coordinate the source-unit layer with lead-x7bp,
keep the target/translation layer standalone

The manifest has two cleanly separable halves, and they have opposite coordination needs:

- **Upper half — source-unit / `kind` addressing (`role`, `skills[]`, `provenance`, and
  the `kind` discriminator).** This is the *same modeling problem* as the knowledge-context
  epic **lead-x7bp** (decisions-primary reframe; principles / development-guidance as a new
  **kind**). Both need a stable "kind" vocabulary for composable units — here it is
  role/skill/native-gate; x7bp's is decision/principle/guidance — and the `lane`/scoping
  concept overlaps x7bp's development-guidance kind directly. Two divergent source-unit
  taxonomies would **fork the single-source goal**. **Design this half COORDINATED with
  lead-x7bp** so there is one "kind"/source-unit addressing scheme across both efforts.

- **Lower half — target/translation directives (`class`, `parallel`, `permissions`,
  `script`, the native-vs-agent split, the `[target]` block, ADR-051 topology).** These
  are **substrate-specific** — they mean nothing to knowledge-context and everything to
  fabro. **Keep this half STANDALONE**; it is what lets the manifest generalize to any
  number of target systems (the `[target]` block is the seam).

Concretely: **coordinate the "kind"/source-unit vocabulary with lead-x7bp before pinning
the manifest schema; ship the per-target translation + emission layer as an independent,
fabro-facing concern.** The prototype manifest already draws this line
(`[target]` + translation fields vs source-unit refs), so the split is cheap to honor.

---

*Scratch prototype (torn down): generator, manifest, vendored source tree, and both
determinism-run outputs lived under
`…/scratchpad/oq1-gen-spike/` — throwaway per ADR-030. This doc is the durable output.*
