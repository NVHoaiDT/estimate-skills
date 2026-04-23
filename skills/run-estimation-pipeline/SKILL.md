---
name: run-estimation-pipeline
description: Run the full DSV estimation pipeline end-to-end. Use when asked to "run estimation", "estimate this project", "generate estimate from requirements", or "start the estimation pipeline". Orchestrates all individual estimation skills in order.
---

# Run Estimation Pipeline

Runs all estimation skills in sequence, from raw requirements to a downloadable Excel workbook. Each step produces an artifact that the next step consumes.

## Prerequisites

```bash
export DSV_AI_SERVICE_URL="https://your-ai-service.com"
export DSV_AUTH_TOKEN="your-jwt-token"
```

Both variables are required for steps that call the AI service (rag-search, export-excel).

## Pipeline Steps

```
[1] extract-features          → extractedFeatures
         ↓
[2] rag-search                → ragSearchResults
         ↓
[3] verify-feature            → verifiedFeatures
         ↓
[4] estimate-unmatched-feature → verifiedFeatures  (updated in-place)
         ↓
[5] adjust-feature-by-platform → processedFeatures
         ↓
[6] build-re-features          → reFeatures
         ↓
[7] build-re-phases            → rePhases
         ↓
[8] export-excel               → DSV-Project-Estimation.xlsx
```

## Step Details

### Step 1 — extract-features

Read the provided requirements (files or pasted text). Extract a JSON array of atomic feature strings.
→ See `skills/extract-features/SKILL.md`

### Step 2 — rag-search

Assign `feat_NNN` ids and call the AI service in one batch. Each feature gets up to 5 candidates.
→ See `skills/rag-search/SKILL.md`

### Step 3 — verify-feature

For each feature, pick the best candidate (similarity ≥ 0.75 + semantic fit) or mark as unmatched.
→ See `skills/verify-feature/SKILL.md`

### Step 4 — estimate-unmatched-feature

Use matched features as a calibration reference to estimate hours for unmatched ones.
→ See `skills/estimate-unmatched-feature/SKILL.md`

### Step 5 — adjust-feature-by-platform

Confirm `projectPlatform` with the user if unknown, then zero irrelevant estimate fields.
→ See `skills/adjust-feature-by-platform/SKILL.md`

### Step 6 — build-re-features

Cluster processed features into named RE-level feature groups.
→ See `skills/build-re-features/SKILL.md`

### Step 7 — build-re-phases

Distribute RE-level features across delivery phases.
→ See `skills/build-re-phases/SKILL.md`

### Step 8 — export-excel

POST `rePhases` to the AI service and download `DSV-Project-Estimation.xlsx`.
→ See `skills/export-excel/SKILL.md`

## Pausing for Input

Pause and ask the user before continuing when:

- **After step 1**: confirm the extracted feature list is complete and accurate.
- **Before step 5**: confirm `projectPlatform` (`web-only` / `mobile-only` / `cross-platform`).
- **After step 7**: show the phase breakdown and ask if the user wants to adjust anything before export.

## Present Results to User

After each step, briefly report the artifact produced:

```
[1/8] Extracted 24 features from requirements.pdf
[2/8] RAG search complete — 24 features searched.
[3/8] Verified: 18 matched, 6 unmatched.
[4/8] AI-estimated 6 unmatched features.
[5/8] Adjusted estimates for platform: web-only.
[6/8] Built 7 RE-level feature groups.
[7/8] Organized into 2 phases.
[8/8] Exported: DSV-Project-Estimation.xlsx

Estimation complete. Open DSV-Project-Estimation.xlsx to review and fill in descriptions.
```

## Troubleshooting

- **Step 2 fails (auth error)**: check `DSV_AUTH_TOKEN` is set and not expired.
- **Step 2 fails (connection)**: check `DSV_AI_SERVICE_URL` is reachable.
- **User wants to re-run a single step**: run the individual skill directly; all artifacts are mutable variables.
- **Large feature lists (50+)**: steps 1–4 may produce verbose output — ask the user if they want a summary view or full JSON at each checkpoint.
