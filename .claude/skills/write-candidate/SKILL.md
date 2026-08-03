---
name: write-candidate
description: Use when the author is authoring or creating a candidate artifact — a generated guide that drives the candidate to a validated document against the live shop-knowledge template and schema for the candidate kind.
---

<!-- GENERATED write-candidate writing skill — this file is generated and read-only.
     It is regenerated on every shop-templates pour from ONE common structure plus
     the candidate typedef facts, so a hand-edit is caught by the writing-skill drift
     check that guards the generated writing skills. DO NOT EDIT: edit the common
     structure or the candidate typedef and re-pour. -->

# Write a candidate (solution candidate)

## When to use this skill

Use this skill whenever the author is creating a candidate. It drives the solution candidate from an empty draft to a validated artifact. It is one of the eight per-kind writing skills, generated read-only from a single common structure — do not hand-author it per repo.

## Fetch the kind's shape from the live template

Fetch the candidate's canonical shape from the live template with `shop-knowledge template candidate`. That live command is the source of the kind's shape; do not reconstruct the shape from memory and do not paste a copy of it here.

## Draft against the live schema surface

Name the candidate's schema surface with `shop-knowledge schema candidate` and draft each section it reports. For the candidate kind those required sections are: Verbatim anchors, Problem, Appetite, Solution sketch, Rabbit holes, No-gos, Evidence / experiments, Resolution, Changelog.

## Walk the kind's lifecycle

Open the candidate at its starting status: `exploring`. The candidate shaped from an intent record and committed by a brief — record that provenance edge. Cover every required section that `shop-knowledge schema candidate` reports for candidate: Verbatim anchors, Problem, Appetite, Solution sketch, Rabbit holes, No-gos, Evidence / experiments, Resolution, Changelog.

## Reuse discipline

Check the drafted file with `shop-knowledge validate` before closing; a document that fails `shop-knowledge validate` is not a closed artifact. The template and schema are referenced live and never copied into this skill. The kind's shape is obtained live via `shop-knowledge template candidate` and `shop-knowledge schema candidate`, so a change to the candidate typedef flows into this guidance through those live commands without a second hand-edit of this skill.
