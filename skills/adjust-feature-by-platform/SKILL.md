---
name: adjust-feature-by-platform
description: Zero out estimation fields that don't apply to the project's target platform. Use after `estimate-unmatched-feature` when the platform is known and asked to "adjust for platform", "zero out mobile estimates", or "filter by platform".
---

# Adjust Feature By Platform

Applies deterministic zeroing rules to estimation fields based on the project's `projectPlatform`, then saves the result as `processedFeatures`.

## How It Works

1. Confirm `projectPlatform` — ask the user if not yet known.
2. Read `verifiedFeatures`.
3. Run `scripts/adjust.sh` with the platform and features JSON, or apply the rules below manually.
4. Save the result as `processedFeatures`.

## Platform Rules

### `web-only`

Zero out all mobile-specific fields:

```
feMobileEstimate      → 0
designMobileEstimate  → 0
qcMobileEstimate      → 0
```

Keep: `feWebEstimate`, `feResponsiveEstimate`, `designWebEstimate`, `designResponsiveEstimate`, `qcWebEstimate`

### `mobile-only`

Zero out all web-specific fields:

```
feWebEstimate             → 0
feResponsiveEstimate      → 0
designWebEstimate         → 0
designResponsiveEstimate  → 0
qcWebEstimate             → 0
```

Keep: `feMobileEstimate`, `designMobileEstimate`, `qcMobileEstimate`

### `cross-platform`

No changes — keep all fields as-is.

## Arguments

- `platform` — one of `web-only`, `mobile-only`, `cross-platform` (required)
- `features` — JSON array of `verifiedFeatures` (required)

## Output

Same shape as `verifiedFeatures` with relevant fields zeroed. Assign to: `processedFeatures`

## Present Results to User

```
Adjusted N features for platform: web-only

Zeroed fields per feature: feMobileEstimate, designMobileEstimate, qcMobileEstimate

Saved as `processedFeatures`. Ready to run `build-re-features`.
```

## Troubleshooting

- **Unknown platform**: ask the user — "Is this a web app, mobile app, or cross-platform?"
- **jq not found**: install via `brew install jq` (macOS) or `apt-get install jq` (Linux), or apply the zeroing rules manually.
