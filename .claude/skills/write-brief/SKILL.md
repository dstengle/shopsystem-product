---
name: write-brief
description: Use when the author is authoring or creating a brief artifact — a generated guide that drives the brief to a validated document against the live shop-knowledge template and schema for the brief kind.
---

<!-- GENERATED write-brief writing skill — this file is generated and read-only.
     It is regenerated on every shop-templates pour from ONE common structure plus
     the brief typedef facts, so a hand-edit is caught by the writing-skill drift
     check that guards the generated writing skills. DO NOT EDIT: edit the common
     structure or the brief typedef and re-pour. -->

# Write a brief (commitment brief)

## When to use this skill

Use this skill whenever the author is creating a brief. It drives the commitment brief from an empty draft to a validated artifact. It is one of the eight per-kind writing skills, generated read-only from a single common structure — do not hand-author it per repo.

## Fetch the kind's shape from the live template

Fetch the brief's canonical shape from the live template with `shop-knowledge template brief`. That live command is the source of the kind's shape; do not reconstruct the shape from memory and do not paste a copy of it here.

## Draft against the live schema surface

Name the brief's schema surface with `shop-knowledge schema brief` and draft each section it reports. For the brief kind those required sections are: Summary, Scope.

## Walk the kind's lifecycle

Open the brief at its starting status: `draft`. The brief commits a shaped candidate and anchors its scenarios — record that provenance edge. Cover every required section that `shop-knowledge schema brief` reports for brief: Summary, Scope.

## Reuse discipline

Check the drafted file with `shop-knowledge validate` before closing; a document that fails `shop-knowledge validate` is not a closed artifact. The template and schema are referenced live and never copied into this skill. The kind's shape is obtained live via `shop-knowledge template brief` and `shop-knowledge schema brief`, so a change to the brief typedef flows into this guidance through those live commands without a second hand-edit of this skill.
