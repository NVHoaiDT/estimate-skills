---
name: estimate-unmatched-feature
description: AI-estimate hours for features that had no database match. Use after `verify-feature` when asked to "estimate unmatched features", "fill in missing estimates", or "AI estimate".
---

# Estimate Unmatched Feature

For every feature in `verifiedFeatures` where `isMatched: false`, produces a reasoned hour estimate by referencing the scale and complexity of the matched features in the same list.

## How It Works

1. Read `verifiedFeatures` (output of `verify-feature`).
2. Separate matched (`isMatched: true`) and unmatched (`isMatched: false`) entries.
3. Use the matched features as a reference calibration set.
4. For each unmatched feature, reason about complexity relative to similar matched features and fill in all 10 estimate fields.
5. Replace the unmatched entries in-place and output the full updated array as `verifiedFeatures`.

## Estimation Fields

| Field                      | Meaning                       |
| -------------------------- | ----------------------------- |
| `beEstimate`               | Backend hours                 |
| `feWebEstimate`            | Frontend web hours            |
| `feMobileEstimate`         | Frontend mobile hours         |
| `feResponsiveEstimate`     | Frontend responsive-web hours |
| `designWebEstimate`        | Design (web) hours            |
| `designMobileEstimate`     | Design (mobile) hours         |
| `designResponsiveEstimate` | Design (responsive) hours     |
| `baEstimate`               | Business analysis hours       |
| `qcWebEstimate`            | QA (web) hours                |
| `qcMobileEstimate`         | QA (mobile) hours             |

## Calibration Strategy

- Find 2–3 matched features of similar complexity to the unmatched one.
- Scale estimates proportionally based on perceived complexity difference.
- If no similar matched feature exists, use the median of all matched estimates as a baseline.
- Never leave a field as `null` — use `0` when a discipline is clearly not involved.

## Output

The full `verifiedFeatures` array with unmatched entries filled in. Unmatched entries keep `isMatched: false`, `similarity: 0`, `module: ""`, `feature: ""`, `subFeature: ""`.

Assign to variable: `verifiedFeatures` (overwrites previous value)

## Present Results to User

```
Estimated N unmatched features using X matched features as reference:

- "Export project report to PDF"
  BE: 20h | FE Web: 14h | Design: 8h | BA: 4h | QC: 8h
  (based on: "Generate invoice PDF" complexity level)

- "Custom dashboard with drag-and-drop"
  BE: 12h | FE Web: 30h | Design: 16h | BA: 6h | QC: 12h

Updated `verifiedFeatures`. Ready to run `adjust-feature-by-platform`.
```

## Troubleshooting

- **No matched features to reference**: use conservative industry-average hours and note the uncertainty.
- **Feature is very large/vague**: break it into sub-estimates internally and sum them, then output the total.
