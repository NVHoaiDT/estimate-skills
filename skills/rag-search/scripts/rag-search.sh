#!/usr/bin/env bash
set -euo pipefail

# Usage: ./rag-search.sh '<features-json>'
# Env:   DSV_AI_SERVICE_URL, DSV_AUTH_TOKEN

FEATURES_JSON="${1:?Usage: rag-search.sh '<features-json>'}"

: "${DSV_AI_SERVICE_URL:?DSV_AI_SERVICE_URL is required}"
: "${DSV_AUTH_TOKEN:?DSV_AUTH_TOKEN is required}"

curl -sf \
  -X POST \
  "${DSV_AI_SERVICE_URL}/mcp/rag-search" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${DSV_AUTH_TOKEN}" \
  -d "{\"features\": ${FEATURES_JSON}}"
