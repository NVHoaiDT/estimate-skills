---
name: build-re-features
description: Group processed features into RE-level feature buckets for the estimation sheet. Use after `adjust-feature-by-platform` when asked to "group features", "build RE features", or "organize into feature groups".
---

# Build RE Features

Groups the flat `processedFeatures.json` list into semantically coherent RE-level feature objects. Each RE-level feature is a named bucket that holds the core features belonging to it.

## How It Works

1. Read `processedFeatures.json` (output of `adjust-feature-by-platform`).
2. Cluster features by their functional domain (authentication, messaging, payments, etc.).
3. Assign a clear `reLevelFeatureName` to each cluster (use matched `module` values as hints for matched features).
4. Build a `reFeatures` array where each item holds a `coreFeatures` sub-array.
5. Every feature in `processedFeatures.json` must appear in exactly one `coreFeatures` list.

## Output Shape

```typescript
type REFeatureType = {
   reLevelFeatureName: string; // e.g. "Authentication", "Dashboard", "Reporting"
   coreFeatures: ProcessedFeatureType[];
};
```

Assign to: `reFeatures.json`

## Grouping Guidelines

- Use the `module` field of matched features as the primary grouping hint.
- For unmatched features, infer the domain from the `clientFeature` description.
- Prefer fewer, broader groups (5–15 features per group) over many tiny groups.
- A group with only one feature is fine when it is truly standalone (e.g. "Onboarding").
- Keep `reLevelFeatureName` short and recognizable (2–4 words).

## Example

Input (`processedFeatures.json`):

```json
[
  { "clientFeature": "Sign up with email", "module": "Authentication", ... },
  { "clientFeature": "Log in with Google", "module": "Authentication", ... },
  { "clientFeature": "View dashboard", "module": "Dashboard", ... },
  { "clientFeature": "Export report to PDF", "module": "", ... }
]
```

Output:

```json
[
  {
    "reLevelFeatureName": "Authentication",
    "coreFeatures": [
      { "clientFeature": "Sign up with email", ... },
      { "clientFeature": "Log in with Google", ... }
    ]
  },
  {
    "reLevelFeatureName": "Dashboard",
    "coreFeatures": [
      { "clientFeature": "View dashboard", ... }
    ]
  },
  {
    "reLevelFeatureName": "Reporting",
    "coreFeatures": [
      { "clientFeature": "Export report to PDF", ... }
    ]
  }
]
```

## Present Results to User

```
Built N RE-level feature groups from M processed features:

- Authentication (2 features)
- Dashboard (1 feature)
- Reporting (1 feature)

Saved as `reFeatures.json`. Ready to run `build-re-phases`.
```

## Troubleshooting

- **Too many single-feature groups**: consolidate into a broader "Miscellaneous" or "Other" group only if no better label exists.
- **Features spanning multiple domains**: assign to the primary domain; note secondary concerns as a comment.
