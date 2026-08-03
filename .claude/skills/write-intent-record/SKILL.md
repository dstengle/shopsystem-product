---
name: write-intent-record
description: Use when the author is authoring or creating a intent-record artifact — a generated guide that drives the intent-record to a validated document against the live shop-knowledge template and schema for the intent-record kind.
---

<!-- GENERATED write-intent-record writing skill — this file is generated and read-only.
     It is regenerated on every shop-templates pour from ONE common structure plus
     the intent-record typedef facts, so a hand-edit is caught by the writing-skill drift
     check that guards the generated writing skills. DO NOT EDIT: edit the common
     structure or the intent-record typedef and re-pour. -->

# Write a intent-record (intent record)

## When to use this skill

Use this skill whenever the author is creating a intent-record. It drives the intent record from an empty draft to a validated artifact. It is one of the eight per-kind writing skills, generated read-only from a single common structure — do not hand-author it per repo.

## Fetch the kind's shape from the live template

Fetch the intent-record's canonical shape from the live template with `shop-knowledge template intent-record`. That live command is the source of the kind's shape; do not reconstruct the shape from memory and do not paste a copy of it here.

## Draft against the live schema surface

Name the intent-record's schema surface with `shop-knowledge schema intent-record` and draft each section it reports. For the intent-record kind those required sections are: Verbatim anchors, The goal behind the ask, Who it serves, Constraints, Non-goals, Appetite signal, Failure conditions, Open threads.

## Walk the kind's lifecycle

Open the intent-record at its starting status: `recorded`. The intent-record originates a candidate — record that provenance edge. Cover every required section that `shop-knowledge schema intent-record` reports for intent-record: Verbatim anchors, The goal behind the ask, Who it serves, Constraints, Non-goals, Appetite signal, Failure conditions, Open threads.

## Reuse discipline

Check the drafted file with `shop-knowledge validate` before closing; a document that fails `shop-knowledge validate` is not a closed artifact. The template and schema are referenced live and never copied into this skill. The kind's shape is obtained live via `shop-knowledge template intent-record` and `shop-knowledge schema intent-record`, so a change to the intent-record typedef flows into this guidance through those live commands without a second hand-edit of this skill.
