---
name: write-session-record
description: Use when the author is authoring or creating a session-record artifact — a generated guide that drives the session-record to a validated document against the live shop-knowledge template and schema for the session-record kind.
---

<!-- GENERATED write-session-record writing skill — this file is generated and read-only.
     It is regenerated on every shop-templates pour from ONE common structure plus
     the session-record typedef facts, so a hand-edit is caught by the writing-skill drift
     check that guards the generated writing skills. DO NOT EDIT: edit the common
     structure or the session-record typedef and re-pour. -->

# Write a session-record (session record)

## When to use this skill

Use this skill whenever the author is creating a session-record. It drives the session record from an empty draft to a validated artifact. It is one of the eight per-kind writing skills, generated read-only from a single common structure — do not hand-author it per repo.

## Fetch the kind's shape from the live template

Fetch the session-record's canonical shape from the live template with `shop-knowledge template session-record`. That live command is the source of the kind's shape; do not reconstruct the shape from memory and do not paste a copy of it here.

## Draft against the live schema surface

Name the session-record's schema surface with `shop-knowledge schema session-record` and draft each section it reports. For the session-record kind those required sections are: Outcome, Open threads.

## Walk the kind's lifecycle

Open the session-record at its starting status: `open`. The session-record records the session's produced artifacts — record that provenance edge. Cover every required section that `shop-knowledge schema session-record` reports for session-record: Outcome, Open threads.

## Reuse discipline

Check the drafted file with `shop-knowledge validate` before closing; a document that fails `shop-knowledge validate` is not a closed artifact. The template and schema are referenced live and never copied into this skill. The kind's shape is obtained live via `shop-knowledge template session-record` and `shop-knowledge schema session-record`, so a change to the session-record typedef flows into this guidance through those live commands without a second hand-edit of this skill.
