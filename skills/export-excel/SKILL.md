---
name: export-excel
description: Generate and download the DSV estimation Excel file. Use after `build-re-phases` when asked to "export to Excel", "download the estimate", "generate the spreadsheet", or "export estimation".
---

# Export Excel

Sends `rePhases` to the DSV AI Service and downloads the generated `.xlsx` estimation workbook.

## Prerequisites

```bash
export DSV_AI_SERVICE_URL="https://your-ai-service.com"   # no trailing slash
export DSV_AUTH_TOKEN="your-jwt-token"
```

## How It Works

1. Read `rePhases` (output of `build-re-phases`).
2. Run `scripts/export-excel.sh` with the `rePhases` JSON.
3. The script saves the file as `DSV-Project-Estimation.xlsx` in the current directory.
4. Report the download path to the user.

## Arguments

- `rePhases` — JSON array of `RePhaseType` from `build-re-phases` (required)
- `output` — output filename (optional, defaults to `DSV-Project-Estimation.xlsx`)

## Examples

```bash
DSV_AI_SERVICE_URL=http://localhost:3000 \
DSV_AUTH_TOKEN=eyJ... \
./scripts/export-excel.sh "$rePhases"
```

```bash
# Custom output filename
DSV_AI_SERVICE_URL=http://localhost:3000 \
DSV_AUTH_TOKEN=eyJ... \
./scripts/export-excel.sh "$rePhases" "ClientName-Estimate-2026.xlsx"
```

## Output

```
DSV-Project-Estimation.xlsx saved to ./DSV-Project-Estimation.xlsx
```

The workbook contains:

- Summary block (total features, match rate, AI estimate rate)
- Phase-based breakdown with feature groups
- Hour totals per discipline (BE, FE Web, FE Mobile, Design, BA, QC)
- Rough timeline projection (months)

## Present Results to User

```
Excel estimation exported successfully.

File: ./DSV-Project-Estimation.xlsx

Summary:
- Total features: N
- Matched from database: X (Y%)
- AI estimated: Z (W%)

You can now open the file, fill in feature descriptions, and share with the client.
```

## Troubleshooting

- **401 Unauthorized**: `DSV_AUTH_TOKEN` is expired — re-authenticate.
- **File is 0 bytes**: the server returned an error body instead of binary — check `DSV_AI_SERVICE_URL` and token validity.
- **Cannot open .xlsx**: ensure you have Excel, LibreOffice, or Google Sheets available.
