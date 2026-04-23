---
name: verify-feature
description: Pick the best estimation candidate for each feature from RAG search results, or mark the feature as unmatched. Use after `rag-search` when asked to "verify features", "pick best matches", or "confirm estimates".
---

# Verify Feature

Evaluates each feature's candidate list from `ragSearchResults` and selects the best database match, or flags the feature as unmatched when no candidate is close enough.

## How It Works

1. Read `ragSearchResults` (output of `rag-search`).
2. For each item, evaluate the top candidate using the rules below.
3. Build a `verifiedFeatures` array — one entry per original feature.

## Matching Rules

Apply in order:

| Condition                                                                                            | Decision                                                                                                                         |
| ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `candidates` is empty                                                                                | `isMatched: false`                                                                                                               |
| Top candidate `similarity >= 0.88` AND module/feature/subFeature semantically fits the clientFeature | `isMatched: true`, use that candidate's estimates                                                                                |
| Top candidate `0.75 <= similarity < 0.88`                                                            | Evaluate semantically: if the sub-feature clearly covers the client's intent → `isMatched: true`; otherwise → `isMatched: false` |
| Top candidate `similarity < 0.75`                                                                    | `isMatched: false`                                                                                                               |

When `isMatched: false`, fill estimation fields with `0` and module/feature/subFeature with `""`.

## Output Shape

```typescript
type VerifiedFeatureType = {
   isMatched: boolean;
   clientFeature: string;
   module: string;
   feature: string;
   subFeature: string;
   similarity: number;
   beEstimate: number;
   feWebEstimate: number;
   feMobileEstimate: number;
   feResponsiveEstimate: number;
   designWebEstimate: number;
   designMobileEstimate: number;
   designResponsiveEstimate: number;
   baEstimate: number;
   qcWebEstimate: number;
   qcMobileEstimate: number;
};
```

Assign to variable: `verifiedFeatures`

## Example

Input candidate:

```json
{
  "id": "feat_001",
  "clientFeature": "Sign up with email and password",
  "candidates": [
    { "module": "Authentication", "feature": "Sign-up", "subFeature": "With Email", "similarity": 0.9076, "beEstimate": 30, ... }
  ]
}
```

Output:

```json
{
  "isMatched": true,
  "clientFeature": "Sign up with email and password",
  "module": "Authentication",
  "feature": "Sign-up",
  "subFeature": "With Email",
  "similarity": 0.9076,
  "beEstimate": 30,
  ...
}
```

## Present Results to User

```
Verification complete for N features:

Matched (X):
✓ "Sign up with email and password" → Authentication > Sign-up > With Email (91%)

Unmatched (Y) — will be estimated by AI:
✗ "Export project report to PDF"
✗ "Custom dashboard with drag-and-drop"

Saved as `verifiedFeatures`. Ready to run `estimate-unmatched-feature`.
```

## Troubleshooting

- **All features unmatched**: check that `rag-search` ran successfully and candidates are populated.
- **Borderline similarity (0.75–0.88)**: when in doubt, prefer unmatched — `estimate-unmatched-feature` will produce a reasoned estimate.
