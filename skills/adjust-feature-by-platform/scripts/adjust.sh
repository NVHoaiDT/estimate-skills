#!/usr/bin/env bash
set -euo pipefail

# Usage: ./adjust.sh <platform> '<features-json>'
#   platform: web-only | mobile-only | cross-platform

PLATFORM="${1:?Usage: adjust.sh <platform> '<features-json>'}"
FEATURES_JSON="${2:?Usage: adjust.sh <platform> '<features-json>'}"

command -v jq >/dev/null 2>&1 || { echo "jq is required: brew install jq" >&2; exit 1; }

case "$PLATFORM" in
  web-only)
    echo "$FEATURES_JSON" | jq '[.[] | .feMobileEstimate = 0 | .designMobileEstimate = 0 | .qcMobileEstimate = 0]'
    ;;
  mobile-only)
    echo "$FEATURES_JSON" | jq '[.[] | .feWebEstimate = 0 | .feResponsiveEstimate = 0 | .designWebEstimate = 0 | .designResponsiveEstimate = 0 | .qcWebEstimate = 0]'
    ;;
  cross-platform)
    echo "$FEATURES_JSON"
    ;;
  *)
    echo "Unknown platform: $PLATFORM. Must be web-only, mobile-only, or cross-platform." >&2
    exit 1
    ;;
esac
