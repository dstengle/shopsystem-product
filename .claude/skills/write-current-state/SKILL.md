---
name: write-current-state
description: Use when the author is authoring or creating a current-state artifact — a generated guide that drives the current-state to a validated document against the live shop-knowledge template and schema for the current-state kind.
---

<!-- GENERATED write-current-state writing skill — this file is generated and read-only.
     It is regenerated on every shop-templates pour from ONE common structure plus
     the current-state typedef facts, so a hand-edit is caught by the writing-skill drift
     check that guards the generated writing skills. DO NOT EDIT: edit the common
     structure or the current-state typedef and re-pour. -->

# Write a current-state (current-state narrative)

## When to use this skill

Use this skill whenever the author is creating a current-state. It drives the current-state narrative from an empty draft to a validated artifact. It is one of the eight per-kind writing skills, generated read-only from a single common structure — do not hand-author it per repo.

## Fetch the kind's shape from the live template

Fetch the current-state's canonical shape from the live template with `shop-knowledge template current-state`. That live command is the source of the kind's shape; do not reconstruct the shape from memory and do not paste a copy of it here.

## Draft against the live schema surface

Name the current-state's schema surface with `shop-knowledge schema current-state` and draft each section it reports. For the current-state kind those required sections are: Summary, Capabilities, Gaps.

## Walk the kind's lifecycle

Open the current-state at its starting status: `current`. The current-state supersedes the prior current-state entry — record that provenance edge. Cover every required section that `shop-knowledge schema current-state` reports for current-state: Summary, Capabilities, Gaps.

## Reuse discipline

Check the drafted file with `shop-knowledge validate` before closing; a document that fails `shop-knowledge validate` is not a closed artifact. The template and schema are referenced live and never copied into this skill. The kind's shape is obtained live via `shop-knowledge template current-state` and `shop-knowledge schema current-state`, so a change to the current-state typedef flows into this guidance through those live commands without a second hand-edit of this skill.
