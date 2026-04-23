---
name: rag-search
description: Search the DSV estimation database for matching features. Use when you have an `extractedFeatures` list and need to find historical estimates, or when asked to "search estimation database", "find matching features", or "run RAG search".
---

# RAG Search

Sends the extracted feature list to the DSV AI Service vector store and retrieves up to 5 estimation candidates per feature, all in a single parallel request.

## Prerequisites

Set these environment variables before running:

```bash
export DSV_AI_SERVICE_URL="https://your-ai-service.com"   # no trailing slash
export DSV_AUTH_TOKEN="your-jwt-token"
```

## How It Works

1. Read `extractedFeatures` (output of `extract-features`).
2. Build the request payload: assign a stable `feat_NNN` id to each feature.
3. Run `scripts/rag-search.sh` with the payload.
4. Parse the JSON response.
5. Save the result as `ragSearchResults`.

## Arguments

- `features` — JSON array of strings from `extract-features` (required)

## Examples

```bash
# Run directly with inline JSON
DSV_AI_SERVICE_URL=http://localhost:3000 \
DSV_AUTH_TOKEN=eyJ... \
./scripts/rag-search.sh '[
  {"id":"feat_001","clientFeature":"Sign up with email and password"},
  {"id":"feat_002","clientFeature":"View chat history"}
]'
```

## Output

```json
[
   {
      "id": "feat_001",
      "clientFeature": "Sign up with email and password",
      "candidates": [
         {
            "clientFeature": "",
            "module": "Authentication",
            "feature": "Sign-up",
            "subFeature": "With Email",
            "similarity": 0.9076,
            "beEstimate": 30,
            "feWebEstimate": 10,
            "feMobileEstimate": 5,
            "feResponsiveEstimate": 2,
            "designWebEstimate": 8,
            "designMobileEstimate": 3,
            "designResponsiveEstimate": 4,
            "baEstimate": 2,
            "qcWebEstimate": 16,
            "qcMobileEstimate": 13
         }
      ]
   }
]
```

Saved as `ragSearchResults`. Pass directly to `verify-feature`.

## Present Results to User

```
RAG search complete. N features searched, results returned:

- feat_001 "Sign up with email and password" → 3 candidates (top similarity: 0.91)
- feat_002 "View chat history" → 5 candidates (top similarity: 0.88)
- feat_003 "Export report to PDF" → 1 candidate (top similarity: 0.63)

Saved as `ragSearchResults`. Ready to run `verify-feature`.
```

## Troubleshooting

- **401 Unauthorized**: `DSV_AUTH_TOKEN` is missing or expired — re-authenticate and update the variable.
- **Connection refused**: `DSV_AI_SERVICE_URL` is wrong or the service is down.
- **Empty candidates array**: the feature is novel and has no close database match — `verify-feature` will mark it as unmatched and `estimate-unmatched-feature` will handle it.
- **curl not found**: install curl via your system package manager.
