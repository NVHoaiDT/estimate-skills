# Estimation Skills

A collection of [Agent Skills](https://agentskills.io/) for AI coding agents that automate project estimation using DSV-RE. Given a requirements document, these skills extract features, search a historical estimation database, fill gaps with AI reasoning, and export a ready-to-share Excel workbook.

## Pipeline Overview

The skills form an end-to-end estimation pipeline. Each step produces an artifact consumed by the next:

```
[1] extract-features            → extractedFeatures
         ↓
[2] rag-search                  → ragSearchResults
         ↓
[3] verify-feature              → verifiedFeatures
         ↓
[4] estimate-unmatched-feature  → verifiedFeatures (updated)
         ↓
[5] adjust-feature-by-platform  → processedFeatures
         ↓
[6] build-re-features           → reFeatures
         ↓
[7] build-re-phases             → rePhases
         ↓
[8] export-excel                → DSV-Project-Estimation.xlsx
```

You can run the full pipeline with `run-estimation-pipeline`, or invoke each skill individually.

## Available Skills

### run-estimation-pipeline

Orchestrates all skills below in sequence, from raw requirements to a downloadable Excel workbook. Pauses for user confirmation after feature extraction, before platform adjustment, and before export.

### extract-features

Reads client requirement documents (docx, Excel, PDF, or pasted text) and produces a clean JSON array of atomic feature strings. Each entry describes one user-facing capability in a concise English phrase.

### rag-search

Sends extracted features to the DSV AI Service vector store and retrieves up to 5 historical estimation candidates per feature. Requires `DSV_AI_SERVICE_URL` and `DSV_AUTH_TOKEN` environment variables.

### verify-feature

Evaluates each feature's candidate list and selects the best database match (similarity >= 0.75 with semantic fit) or marks the feature as unmatched for AI estimation.

### estimate-unmatched-feature

For features with no database match, produces reasoned hour estimates across 10 disciplines (BE, FE Web, FE Mobile, Design, BA, QC, etc.) by calibrating against matched features.

### adjust-feature-by-platform

Zeros out estimation fields that do not apply to the project's target platform (`web-only`, `mobile-only`, or `cross-platform`).

### build-re-features

Groups processed features into semantically coherent RE-level feature buckets (e.g. "Authentication", "Dashboard", "Reporting") for the estimation sheet.

### build-re-phases

Distributes RE-level feature groups across delivery phases (Core, Extended, Advanced) based on dependency order and business priority.

### export-excel

Sends the final phase structure to the DSV AI Service and downloads a `.xlsx` estimation workbook with per-discipline hour breakdowns and timeline projections. Requires `DSV_AI_SERVICE_URL` and `DSV_AUTH_TOKEN`.

## Installation

Install all skills into your project:

```bash
npx @anthropic-ai/skills install NVHoaiDT/estimate-skills
```

Or install a single skill:

```bash
npx @anthropic-ai/skills install NVHoaiDT/estimate-skills/extract-features
```

## Prerequisites

Two environment variables are required for skills that call the DSV AI Service (`rag-search` and `export-excel`):

```bash
export DSV_AI_SERVICE_URL="https://your-ai-service.com"   # no trailing slash
export DSV_AUTH_TOKEN="your-jwt-token"
```

The remaining skills run locally with no external dependencies.

## Usage

Skills are automatically available once installed. Your AI coding agent will activate them when it detects a relevant task. Common trigger phrases:

| Phrase | Skill activated |
| --- | --- |
| "Estimate this project" | `run-estimation-pipeline` |
| "Extract features from this doc" | `extract-features` |
| "Search the estimation database" | `rag-search` |
| "Verify features" / "Pick best matches" | `verify-feature` |
| "Estimate unmatched features" | `estimate-unmatched-feature` |
| "Adjust for web-only" | `adjust-feature-by-platform` |
| "Group features" / "Build RE features" | `build-re-features` |
| "Organize into phases" | `build-re-phases` |
| "Export to Excel" / "Download the estimate" | `export-excel` |

### Running the full pipeline

Provide your requirements document and ask the agent to estimate:

```
Estimate this project based on requirements.pdf
```

The agent will run all 8 steps, pausing for your input at key checkpoints:

1. After feature extraction -- confirm the feature list is complete.
2. Before platform adjustment -- confirm the target platform.
3. After phase building -- review phases before exporting.

### Running individual skills

You can also run any skill in isolation. For example, to re-estimate unmatched features after manual adjustments:

```
Re-run estimate-unmatched-feature with the current verifiedFeatures
```

## License

This project is proprietary to DSV.
