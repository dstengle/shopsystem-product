---
name: write-prioritization-record
description: Use when the author is authoring or creating a prioritization-record artifact — a generated guide that drives the prioritization-record to a validated document against the live shop-knowledge template and schema for the prioritization-record kind.
---

<!-- GENERATED write-prioritization-record writing skill — this file is generated and read-only.
     It is regenerated on every shop-templates pour from ONE common structure plus
     the prioritization-record typedef facts, so a hand-edit is caught by the writing-skill drift
     check that guards the generated writing skills. DO NOT EDIT: edit the common
     structure or the prioritization-record typedef and re-pour. -->

# Write a prioritization-record (prioritization record)

## When to use this skill

Use this skill whenever the author is creating a prioritization-record. It drives the prioritization record from an empty draft to a validated artifact. It is one of the eight per-kind writing skills, generated read-only from a single common structure — do not hand-author it per repo.

## Fetch the kind's shape from the live template

Fetch the prioritization-record's canonical shape from the live template with `shop-knowledge template prioritization-record`. That live command is the source of the kind's shape; do not reconstruct the shape from memory and do not paste a copy of it here.

## Draft against the live schema surface

Name the prioritization-record's schema surface with `shop-knowledge schema prioritization-record` and draft each section it reports. For the prioritization-record kind those required sections are: Ranking, Rationale.

## Walk the kind's lifecycle

Open the prioritization-record at its starting status: `draft`. The prioritization-record orders candidates and intents by priority — record that provenance edge. Cover every required section that `shop-knowledge schema prioritization-record` reports for prioritization-record: Ranking, Rationale.

## Reuse discipline

Check the drafted file with `shop-knowledge validate` before closing; a document that fails `shop-knowledge validate` is not a closed artifact. The template and schema are referenced live and never copied into this skill. The kind's shape is obtained live via `shop-knowledge template prioritization-record` and `shop-knowledge schema prioritization-record`, so a change to the prioritization-record typedef flows into this guidance through those live commands without a second hand-edit of this skill.
