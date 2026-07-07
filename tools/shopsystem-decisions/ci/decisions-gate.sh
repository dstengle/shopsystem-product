#!/usr/bin/env bash
#
# decisions-gate.sh — the decision-coherence gate as CI/pre-pour invokes it.
#
# ONE entrypoint, run identically on the lead host (doctor / pre-commit) and in
# CI (the dagger build), per ADR-053 "same dagger definition runs locally and in
# CI — no divergence". The split advisory/blocking doctrine is ADR-047 D3: the
# gate WARNs at authoring/PR time and BLOCKS at the distribution/pour boundary.
#
# Three legs, in order (fail-fast on the two hard legs):
#
#   1. LINT      decisions check --lint          schema floor; blocks EVERYWHERE (exit 2)
#   2. DRIFT     decisions build --check         decision-refs/ must match source (exit 1)
#   3. COHERENCE decisions check --mode $MODE     FC1-FC4; teeth depend on --mode
#
# Modes:
#   authoring     (default) — leg 3 WARNs; blocking coherence rows are captured as a
#                 PR annotation but DO NOT fail the build. Legs 1-2 still hard-fail.
#                 This is the PR / doctor surface.
#   distribution  — leg 3 BLOCKS; any FC1-FC4 blocking row aborts. This is the
#                 DECISIONS.md digest-pour / release-reconciliation surface.
#
# Exit: 0 clean · 1 blocking coherence/drift · 2 lint/usage. In authoring mode
# the process exits 0 even with coherence findings (they are advisory there).
#
# Usage:
#   tools/shopsystem-decisions/ci/decisions-gate.sh [--mode authoring|distribution]
#                                                   [--base DIR] [--dirs "adr pdr briefs"]
set -euo pipefail

MODE="authoring"
BASE="."
DIRS="adr pdr briefs"
ANNOT="${DECISIONS_ANNOTATION_FILE:-}"   # optional: authoring-mode WARNs -> this file

while [ $# -gt 0 ]; do
  case "$1" in
    --mode) MODE="$2"; shift 2 ;;
    --base) BASE="$2"; shift 2 ;;
    --dirs) DIRS="$2"; shift 2 ;;
    -h|--help) sed -n '2,40p' "$0"; exit 0 ;;
    *) echo "decisions-gate: unknown arg '$1'" >&2; exit 2 ;;
  esac
done

case "$MODE" in
  authoring|distribution) ;;
  *) echo "decisions-gate: --mode must be authoring|distribution" >&2; exit 2 ;;
esac

# shellcheck disable=SC2086
run() { ( cd "$BASE" && decisions "$@" ); }

echo "== decisions-gate: mode=$MODE dirs=[$DIRS] base=$BASE =="

# ---- Leg 1: LINT (schema floor — blocks in EVERY mode) --------------------- #
echo "-- leg 1/3: lint (schema floor, blocking everywhere)"
# shellcheck disable=SC2086
run check $DIRS --lint --aggregate

# ---- Leg 2: DRIFT (decision-refs/ must be a pure function of the source) ---- #
echo "-- leg 2/3: build --check (projection drift, blocking everywhere)"
run build --check

# ---- Leg 3: COHERENCE (FC1-FC4; teeth per mode) ---------------------------- #
echo "-- leg 3/3: coherence check (mode=$MODE)"
if [ "$MODE" = "authoring" ]; then
  # WARN surface: capture blocking rows as a PR annotation, never fail the build.
  if [ -n "$ANNOT" ]; then
    # shellcheck disable=SC2086
    run check $DIRS --mode authoring --json > "$ANNOT" || true
    echo "   (coherence findings written to $ANNOT as a PR annotation)"
  fi
  # shellcheck disable=SC2086
  run check $DIRS --mode authoring --aggregate   # exit 0 unless lint fires
else
  # POUR surface: any FC1-FC4 blocking row aborts.
  # shellcheck disable=SC2086
  run check $DIRS --mode distribution --aggregate
fi

echo "== decisions-gate: PASS (mode=$MODE) =="
