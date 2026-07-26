---
name: write-pdr
description: Use when the author is authoring or creating a pdr artifact — a generated guide that drives the pdr to a validated document against the live shop-knowledge template and schema for the pdr kind.
---

<!-- GENERATED write-pdr writing skill — this file is generated and read-only.
     It is regenerated on every shop-templates pour from ONE common structure plus
     the pdr typedef facts, so a hand-edit is caught by the writing-skill drift
     check that guards the generated writing skills. DO NOT EDIT: edit the common
     structure or the pdr typedef and re-pour. -->

# Write a pdr (product decision record)

## When to use this skill

Use this skill whenever the author is creating a pdr. It drives the product decision record from an empty draft to a validated artifact. It is one of the eight per-kind writing skills, generated read-only from a single common structure — do not hand-author it per repo.

## Fetch the kind's shape from the live template

Fetch the pdr's canonical shape from the live template with `shop-knowledge template pdr`. That live command is the source of the kind's shape; do not reconstruct the shape from memory and do not paste a copy of it here.

## Draft against the live schema surface

Name the pdr's schema surface with `shop-knowledge schema pdr` and draft each section it reports. For the pdr kind those required sections are: Context, Decision, Consequences.

## Walk the kind's lifecycle

Open the pdr at its starting status: `proposed`. The pdr supersedes / superseded-by another PDR — record that provenance edge. Cover every required section that `shop-knowledge schema pdr` reports for pdr: Context, Decision, Consequences.

## Reuse discipline

Check the drafted file with `shop-knowledge validate` before closing; a document that fails `shop-knowledge validate` is not a closed artifact. The template and schema are referenced live and never copied into this skill. The kind's shape is obtained live via `shop-knowledge template pdr` and `shop-knowledge schema pdr`, so a change to the pdr typedef flows into this guidance through those live commands without a second hand-edit of this skill.
