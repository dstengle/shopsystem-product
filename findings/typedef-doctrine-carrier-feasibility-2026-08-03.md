# Finding: can the per-kind typedef carry authoring DOCTRINE, and can the generator emit it into the eight `write-<kind>` skills?

Architect feasibility read for `lead-vo4cd`, requested by the lead-pm mode before
shaping. Recorded 2026-08-03. **This is a finding — not an ADR, not a candidate,
not a dispatch.** Verified against the contract/artifact surface only (this repo's
`features/`, `adrs/`, `pdrs/`, the installed `shop-knowledge` / `shop-templates` /
`shop-knowledge-gate` / `scenarios` CLIs). **No BC source was read, run, or
git-observed** (ADR-018 D1/D2); none is on this host. Every exit code below was
measured **unpiped**.

---

## Headline

**The question as posed rests on a premise that does not hold on this host.**

"Can the per-kind typedef carry doctrine, and can the generator emit it into the
eight skills" presumes there is *one* typedef→generator channel reaching the
`write-<kind>` skills. There is not. The channel ADR-070 D2 decides — the eight
skills generated from "each kind's per-type typedef, the same ADR-059
typedef→generator single source that already emits `shop-knowledge template
<kind>` and `schema <kind>`" — **is not wired across the
shopsystem-knowledge → shopsystem-templates boundary.** `shop-templates` carries
its **own** per-kind fact table, which has **already diverged from
`shop-knowledge schema <kind>` for 7 of the 8 kinds**.

So the carrier verdict is not "yes" or "no". It is: **the carrier the question
names does not currently exist as a live channel, and the bet must first decide
which of two divergent sources becomes it.**

---

## 1. The carrier verdict

### 1a. The pipeline is broken across the BC boundary (NEW — not previously recorded)

Poured skill facts vs. the live `shop-knowledge schema <kind>` surface, all eight
kinds, measured 2026-08-03:

| kind | starting status: skill / schema[0] | required sections match? |
|---|---|---|
| adr | `proposed` / `proposed` ✓ | ✓ Context, Decision, Consequences |
| pdr | `proposed` / `proposed` ✓ | ✗ skill omits **Options considered** |
| brief | `drafted` / **`draft`** ✗ | ✗ skill: Problem, Scope, Out of scope, Acceptance — schema: Summary, Scope |
| intent-record | `captured` / **`recorded`** ✗ | ✗ skill: Problem, Evidence, Whose problem — schema: 8 different sections |
| candidate | `sketched` / **`exploring`** ✗ | ✗ skill: 5 sections — schema: 9 different sections |
| session-record | `open` / `open` ✓ | ✗ skill: Mode, Produced artifacts, Outcome — schema: Outcome, Open threads |
| current-state | `current` / `current` ✓ | ✗ skill: Summary, Capabilities, Gaps — schema: Current decisions, Stewardship |
| prioritization-record | `recorded` / **`draft`** ✗ | ✓ Ranking, Rationale |

**Only `adr` is fully consistent. 7 of 8 kinds carry at least one wrong fact.**

And the blocking enforcement passes anyway:

```
shop-templates check-writing-skills --target .   → EXIT=0, [PASS] × 8 + overall PASS
```

`write-pdr` omits a section `shop-knowledge schema pdr` reports as **required**,
and ADR-071 D2 / `@scenario_hash:e22aefbf2c4d838c` say that must **FAIL**. It
passes. So the checker is not reading `shop-knowledge`.

**Decisive test.** Three constructed targets (copies of `.claude/`, never the
live tree), each run unpiped:

- T1 — `write-adr` section list edited to omit `Consequences`
  → `EXIT=1`, `[FAIL] adr: writing skill does not cover a required section
  ('Consequences') for the kind`. So the checker *does* check sections.
- T2 — `write-pdr` **corrected** to `shop-knowledge`'s set (adds `Options
  considered`) → `EXIT=0`. Containment check, not equality.
- T3 — `write-brief` set to **exactly** `shop-knowledge schema brief`'s
  `required_sections` (`Summary, Scope`)
  → `EXIT=1`, `[FAIL] brief: writing skill does not cover a required section
  ('Problem') for the kind`.

T3 is the proof. `shop-templates` demands a section (`Problem`) for `brief` that
`shop-knowledge` does not require, and does not demand one (`Summary`) that
`shop-knowledge` does. **shop-templates has its own per-kind required-section
table, divergent from the knowledge typedef.** Generator table and checker table
are mutually consistent, so the blocking gate is **vacuous with respect to the
actual single source** — it validates the skills against the same stale table
that produced them.

Corroborating package metadata (artifact surface, not BC source):

```
shop-templates 0.54.0  Requires-Dist: ['scenarios @ git+...shopsystem-scenarios@v0.3.1', dev extras]
```

**No dependency on `shopsystem-knowledge`.** And it does not shell out to the
installed `shop-knowledge` either — if it did, T3 would have passed.

### 1b. What this means for doctrine

- Adding a doctrine field to a **shopsystem-knowledge** typedef would **not reach
  the generated skills**. There is no channel.
- The doctrine would have to be added to **shopsystem-templates'** own table, which
  is precisely the second-source copy ADR-059/ADR-067 exist to eliminate — and
  which has already demonstrably drifted.
- Either way, the bet's **first** unit of work is closing the cross-BC single-source
  break, not authoring doctrine.

### 1c. The encouraging half: prose-shaped per-kind facts ALREADY reach the skills

Three per-kind facts in the poured skills are **prose, not schema**, and are **not
exposed by `shop-knowledge schema <kind>` at all**:

1. **Kind gloss** — `# Write a adr (architecture decision record)`, `(commitment
   brief)`, `(solution candidate)`, `(current-state narrative)`.
2. **Edge-participation sentence** — a full per-kind sentence:
   `The brief commits a shaped candidate and anchors its scenarios — record that
   provenance edge.` / `The candidate shaped from an intent record and committed
   by a brief …`. `schema <kind>` reports only `type_required_fields:
   ["derives-from"]`; the sentence is nowhere in that JSON.
3. **Starting-status label** — `schema` reports a `statuses` array; "the first is
   the starting status" is an ADR-070 D3 convention, restated as prose.

So **free-text per-kind prose already flows into the generated skills**. The
mechanism to carry doctrine is not novel — a doctrine block is the same shape as
the edge-participation sentence, one size larger. What is missing is not
expressiveness. It is that the source of those strings is the **wrong BC**.

### 1d. What cannot be determined from here, and exactly what would settle it

The typedef's **actual field vocabulary** is a YAML file in shopsystem-knowledge
(`typedef/*.yaml`, per ADR-059's title). No installed CLI publishes it —
`shop-knowledge` exposes only the two *projections* (`template`, `schema`), and
both are lossy: neither carries the gloss or the edge sentence. So from the lead
host I **cannot** determine:

- whether a shopsystem-knowledge typedef can hold a free-text / structured-list
  field at all, or whether its schema is closed;
- whether `shop-templates`' per-kind table is a hardcoded literal, a vendored
  snapshot of the knowledge typedefs, or a third artifact;
- whether the two were ever wired and drifted, or never wired.

**What would settle it — two `clarify` messages. Naming the vehicle only; composing
is the router's action.**

- **`clarify` → `shopsystem-knowledge`:** "Is the per-type typedef's field set open
  or closed? Can a typedef declare a non-schema, prose-or-list field (authoring
  doctrine) that the generator emits into a downstream consumer without violating
  ADR-069 D9's additive discipline? Where in the typedef does the per-kind gloss
  (`architecture decision record`) and the edge-participation sentence live today,
  and are they published anywhere other than `template`/`schema`?"
- **`clarify` → `shopsystem-templates`:** "Where does `check-writing-skills` /
  the writing-skill generator source each kind's `required_sections` and starting
  status? `shop-templates` declares no dependency on `shopsystem-knowledge`, and a
  constructed target whose `write-brief` states exactly `shop-knowledge schema
  brief`'s `required_sections` FAILS with `does not cover a required section
  ('Problem')`. Is that a hardcoded table, a vendored typedef snapshot, or stale
  version skew?"

---

## 2. Per-hash collision table

The controlling discriminator is **emit-only vs. enforced**. Doctrine that is
merely *emitted* into the skills collides with almost nothing; doctrine that
becomes a *validity criterion* of the blocking gate collides with one pinned
scenario head-on.

| hash | feature | verdict | why |
|---|---|---|---|
| `210aafd52ca34318` | template_structure — five required parts | **untouched** | Thens are "carries a frontmatter trigger… carries a reuse-discipline note". Additive: a sixth part leaves all five assertions true. The scenario says "carries", not "carries exactly five". |
| `617923c8aa748acb` | reuse-by-reference, no frozen copy | **STRAINED — and already strained today** | Its third Then: "a change to the adr typedef that alters the live `shop-knowledge template adr` output flows into the skill's guidance without a second hand-edit". §1a shows this is satisfied only in the weak sense (the skill *names* the live command); the inline restated section list is a frozen copy that **has already drifted for 6/8 kinds**. Doctrine baked at pour time is the same shape. Literal Thens are scoped to "the adr template body or schema body", so doctrine does not break the letter — but it deepens an already-violated spirit. |
| `718c0cd3edd23d91` | eight differ only in per-kind typedef facts; byte-stable | **STRAINED, conditionally breaks** | Two clauses at risk. (a) "differing only in the per-kind facts read from that kind's typedef" — legal if doctrine is a per-kind typedef fact, **or** if doctrine is identical across all eight. **Breaks** if doctrine is authored per-kind in a source that is not the kind's typedef (e.g. a shop-templates doctrine file) — which, per §1a, is where it would land today. (b) byte-stability — safe if doctrine is deterministic generator input; **breaks** if fetched live at pour time from a mutable source. |
| `ef445d7bf63d271b` | every kind valid → PASS × N, exit 0 | **BREAKS if doctrine is enforced; untouched if emit-only** | Its Given describes a shop whose skills "reference the live surface and cover their required sections", and its Then is unconditional PASS. If doctrine coverage becomes a validity criterion, a shop matching that exact Given but carrying no doctrine block would now FAIL — a direct contradiction. **This is the one hash a doctrine-enforcement bet must retire or re-pin** (ADR-064 convention: unreachable by block-only recompute; provenance comment outside every canonical scenario region). |
| `776802406cff551f` | missing skill dir → coverage FAIL | **untouched** | Presence-of-directory check. Doctrine is orthogonal. |
| `ca27d16dbba30756` | frozen template copy → validity FAIL | **untouched** | Scoped to "inlines a verbatim copy of the `adr` **template body**". Doctrine text is not the template body. Note the checker's notion of "frozen copy" is narrow enough that today's inline section lists pass it. |
| `e22aefbf2c4d838c` | omits a required section → validity FAIL | **untouched, but is the natural extension point** | Doctrine is not a required *section*. A "omits the kind's doctrine block → FAIL" rule is a **new** scenario alongside this one, not an edit to it. Independently: this hash is **currently unsatisfied in practice** — `write-pdr` omits `Options considered` and the gate returns exit 0. |
| `258b8a4777cffde9` | blocking not advisory, no warn tier | **untouched** | A doctrine criterion inherits this posture rather than changing it. |

**Also in scope, not on the lead-pm's list:**

- `1afdfb1b5cfcbe71`, `1a1b80bd796ead01`, `3bcea617f9a026d9`
  (`per_type_typedef_generation`) — **untouched**. Doctrine is not a ninth type
  and not a shared frontmatter field.
- `e4d8b3c856424c18`, `d5e1af8a4c00ffda` (`per_type_additive_discipline`) —
  **untouched if doctrine is a per-type delta; STRAINS if doctrine is common**.
  ADR-069 D9 enumerates the legal per-type delta set as "required body sections,
  status enum, edge participation". Doctrine would be a **fourth** member of that
  list, which is an ADR-069 amendment, not a free addition.
- `ad20e320470be043`, `a5c1fe90339df4ed`, `f8e379db80066582`
  (`typedef_drift_check`) — **untouched** provided doctrine is deterministic
  typedef input.

---

## 3. Bounded gate read — can the coherence gate carry a self-containment check?

**Short answer: yes for the frontmatter-visible half, no for the prose half — and
the frontmatter half is small, clean, and already lands on the lead-pm's exemplar.**

### The prose half is blocked by a pinned architectural stance

`coherence_gate_typed_edges` narrative, pinned:

> **Frontmatter links are the graph and body mentions are commentary: the gate
> resolves only frontmatter link fields, so an id that appears only in body prose
> forms no edge and a load-bearing mention must be promoted to `derives-from` to
> become one.**

A check that reads ADR-067's 23 `adr-034` / 21 `adr-035` **prose** mentions would
contradict that stance directly. `body_section_conformance` reinforces it: "The
check is **structural** — it inspects the document's headings, not prose quality."
So a prose-grep doctrine check has no home at the current gate altitude.

### The frontmatter half is checkable today, at the existing altitude, with a blast radius of ONE

PDR-035's requirement — "no accepted document reaches into a superseded one to be
understood" — has a faithful frontmatter expression: **an active document whose
*comprehension* edges (`derives-from`, `references`, `incorporates`) resolve to a
`superseded` document.** The `supersedes` / `superseded-by` edges are exempt by
construction: those *are* the transformation view. The changelog exception is
handled for free — the changelog is body, and the gate does not read body.

Measured over all 169 corpus artifacts:

```
accepted-reaches-into-superseded (frontmatter link fields): 1
  ('adr-067', 'accepted', 'derives-from', 'adr-059')
```

**Exactly one violation, and it is the lead-pm's own exemplar.** ADR-067's
`supersedes: [adr-059, adr-034, adr-035]` is legitimate; its
`derives-from: [adr-059, pdr-035]` is the actual reach-into-superseded.

**Altitude:** this is gate rule 11, a sibling of the existing typed-edge floor
(asymmetric-supersede, active-yet-superseded, dangling-edge, supersede-cycle) —
same doctor-form finding shape, same advisory/blocking mode split, same
frontmatter-only input. It does **not** need a new mechanism class.

**ADR-072 constrains it correctly and costs nothing:** D1 keeps `shop-knowledge`
non-mutating, and the gate's pinned contract is already report-a-finding-plus-a-
remediation, never write. A rule-11 check reports `adr-067 derives-from the
superseded adr-059; promote the live successor or drop the edge`. That is exactly
the posture ADR-072 pins.

**Where doctrine and the gate meet:** the doctrine block in the write-`<kind>`
skill would say *"do not cite a superseded document in a way that routes a reader
into it unguarded"*; rule 11 catches the frontmatter-visible half at acceptance.
The prose half stays doctrine-only and unenforced — and that asymmetry should be
stated in the bet rather than discovered later.

---

## 4. Decision-records map — this is a slice sequence, not one ADR

| record | status | disposition |
|---|---|---|
| **ADR-059** (typedef→generator single source) | **superseded** by ADR-067 | **Not touched, and not amendable.** The lead-pm's framing lists it as live; it is not. Its mechanism survives via ADR-067 D1. Amending ADR-059 would itself be the self-containment violation under study. |
| **ADR-067** (base schema) | accepted | **AMENDED only if doctrine is a common base field.** Also the record the §1a break is measured against — the typedef→generator mechanism it carries forward is not spanning the BC boundary. |
| **ADR-069** (per-type schema) | accepted | **AMENDED.** D9 enumerates the legal per-type delta set as three members; a per-kind doctrine field is a fourth. This is the primary amendment target if doctrine is per-kind. |
| **ADR-070** (writing-skill lane) | accepted | **AMENDED.** D3's "five required parts" becomes six. D2's "read from the kind's typedef at generation time" is the clause §1a shows is unrealized. |
| **ADR-071** (blocking enforcement) | accepted | **CONSTRAINS if emit-only; AMENDED if enforced.** D2's validity criteria would gain a doctrine member — and that is what forces `ef445d7bf63d271b`'s retirement. |
| **PDR-035** (self-containment) | accepted | **CONSTRAINS only.** It already states the requirement; nothing to amend. It is the *content source* for the doctrine text and for gate rule 11. |
| **ADR-072** (non-mutating read surface) | proposed | **CONSTRAINS only.** Gate rule 11 reports, never rewrites — already the pinned posture. D6's "adjacent and separate" placement discipline is the model for sequencing here too. |
| **ADR-064** (retirement convention) | — | **CONSTRAINS** the retirement of `ef445d7bf63d271b` if doctrine becomes enforced. |

**Verdict: a slice sequence, minimum three.**

1. **Close the cross-BC single-source break** (§1a). Prerequisite — until the
   generator is actually fed by the knowledge typedef, "put doctrine in the
   typedef" has no observable effect. Larger than `lead-8aqj3`.
2. **Doctrine carrier** — amends ADR-069 (per-type delta set) + ADR-070 (sixth
   part). Emit-only. Collides with nothing on the hash table.
3. **Doctrine enforcement + gate rule 11** — amends ADR-071 D2, retires
   `ef445d7bf63d271b` per ADR-064, adds the frontmatter self-containment rule.
   Separable; can be deferred.

Slices 2 and 3 are each one ADR. Slice 1 is a BC dispatch, not an ADR.

---

## 5. Interaction with `lead-8aqj3`

**Same root cause class, strictly larger, and doctrine sequences AFTER both.**

`lead-8aqj3` is the **intra-BC** half: within shopsystem-knowledge, ADR-067's
base-schema fields landed on the read/loader side (`query --facet tag` and
`--facet distribution` are live) but never on the typedef→generator side (no
template emits `tags:` or `distribution:`; `schema <kind>` reports no optional
field at all).

§1a is the **inter-BC** half, and it is new: the shopsystem-knowledge typedef does
not reach the shopsystem-templates writing-skill generator **at all**. Different
boundary, different fix, larger blast radius — it silently mis-instructs the
author of every artifact kind except `adr`, and the blocking gate certifies the
mis-instruction as PASS.

- **Rides the same fix?** No. `lead-8aqj3`'s `request_bugfix` goes to
  shopsystem-knowledge and tightens *its* generator's emission. §1a's fix is a
  wiring decision spanning two BCs, and it is a **decision before it is a
  dispatch**: which source becomes authoritative for the write-`<kind>` per-kind
  facts.
- **Conflicts?** No. They are disjoint and mutually reinforcing — both are
  instances of "the typedef→generator single source is asserted but not realized."
- **Sequences?** **Doctrine sequences after both.** Landing doctrine on either
  divergent source before the channel is settled installs a *third* copy of
  per-kind facts.

**Recommended queue action (not taken here):** file a sibling bead to `lead-8aqj3`
for the inter-BC break, cross-linked. It is independently worth fixing regardless
of whether the doctrine bet is ever committed — right now `write-candidate`
instructs the author to open at `sketched` (not a legal candidate status; the enum
is `exploring | shaped | briefed | committed | parked | rejected`) and to write
five sections, four of which the schema does not require, while omitting five it
does.

---

## 6. What remains unverifiable from here

1. **The typedef's field vocabulary** — open or closed; whether a prose/list field
   is expressible. Settled by: `clarify` → `shopsystem-knowledge` (§1d).
2. **Where `shop-templates` sources its per-kind facts** — hardcoded, vendored
   snapshot, or version skew. Settled by: `clarify` → `shopsystem-templates` (§1d).
3. **Where the per-kind gloss and edge-participation sentence live today** — the
   single most useful unknown, because it is the existing proof-of-concept for a
   prose-shaped per-kind fact. Folded into the shopsystem-knowledge `clarify`.
4. **Whether the divergence is a defect or version skew** — two `shop-templates`
   distributions are installed here (0.54.0 at `~/.local`, 0.52.3 at
   `/usr/local`); `shopsystem-knowledge` is 0.1.0. Skew cannot explain a *missing
   dependency edge*, but it could explain the magnitude. Settled by the same
   `clarify`.

**None of the four is answerable by reading or running BC code from this host, and
none was attempted** (ADR-018 D1/D2).
