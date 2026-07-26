---
name: write-adr
description: Use when the author is authoring or creating a adr artifact — a generated guide that drives the adr to a validated document against the live shop-knowledge template and schema for the adr kind.
---

<!-- GENERATED write-adr writing skill — this file is generated and read-only.
     It is regenerated on every shop-templates pour from ONE common structure plus
     the adr typedef facts, so a hand-edit is caught by the writing-skill drift
     check that guards the generated writing skills. DO NOT EDIT: edit the common
     structure or the adr typedef and re-pour. -->

# Write a adr (architecture decision record)

## When to use this skill

Use this skill whenever the author is creating a adr. It drives the architecture decision record from an empty draft to a validated artifact. It is one of the eight per-kind writing skills, generated read-only from a single common structure — do not hand-author it per repo.

## Fetch the kind's shape from the live template

Fetch the adr's canonical shape from the live template with `shop-knowledge template adr`. That live command is the source of the kind's shape; do not reconstruct the shape from memory and do not paste a copy of it here.

## Draft against the live schema surface

Name the adr's schema surface with `shop-knowledge schema adr` and draft each section it reports. For the adr kind those required sections are: Context, Decision, Consequences.

## Walk the kind's lifecycle

Open the adr at its starting status: `proposed`. The adr supersedes / superseded-by another ADR — record that provenance edge. Cover every required section that `shop-knowledge schema adr` reports for adr: Context, Decision, Consequences.

## Reuse discipline

Check the drafted file with `shop-knowledge validate` before closing; a document that fails `shop-knowledge validate` is not a closed artifact. The template and schema are referenced live and never copied into this skill. The kind's shape is obtained live via `shop-knowledge template adr` and `shop-knowledge schema adr`, so a change to the adr typedef flows into this guidance through those live commands without a second hand-edit of this skill.
