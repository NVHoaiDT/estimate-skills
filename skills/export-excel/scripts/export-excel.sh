#!/usr/bin/env bash
set -euo pipefail

# Usage: ./export-excel.sh '<rePhases-json>' [output-filename]
# Env:   DSV_AI_SERVICE_URL, DSV_AUTH_TOKEN

RE_PHASES_JSON="${1:?Usage: export-excel.sh '<rePhases-json>' [output-filename]}"
OUTPUT_FILE="${2:-DSV-Project-Estimation.xlsx}"

: "${DSV_AI_SERVICE_URL:?DSV_AI_SERVICE_URL is required}"
: "${DSV_AUTH_TOKEN:?DSV_AUTH_TOKEN is required}"

curl -sf \
  -X POST \
  "${DSV_AI_SERVICE_URL}/mcp/excel/download" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${DSV_AUTH_TOKEN}" \
  -d "{\"rePhases\": ${RE_PHASES_JSON}}" \
  -o "${OUTPUT_FILE}"

echo "${OUTPUT_FILE} saved to ./${OUTPUT_FILE}"
