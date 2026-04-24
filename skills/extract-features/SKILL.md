---
name: extract-features
description: Extract a structured feature list from a client's requirements. Use when given a docx, Excel, PDF, text paste, or any unstructured requirements document and asked to "extract features", "list features", "parse requirements", or "prepare for estimation".
---

# Extract Features

Reads client requirement documents or pasted text and produces a clean JSON array of atomic feature strings, one entry per deliverable capability.

## How It Works

1. Read all provided files or pasted text in full.
2. Identify each distinct user-facing capability described.
3. Normalize each capability into a concise English phrase (5–12 words).
4. Deduplicate and remove purely non-functional entries (e.g. "the app must be fast").
5. Output a JSON array assigned to a variable named `extractedFeatures.json`.

## Rules

- Each entry must describe **one atomic feature**.
- Do not group multiple capabilities into a single entry.
- Preserve the client's original terminology where possible.
- Exclude generic infrastructure concerns (hosting, CI/CD, monitoring) unless explicitly scoped in the requirements.
- If the input language is not English, translate each feature to English.

## Output

```json
[
   "Sign up with email and password",
   "Log in with Google",
   "View chat history",
   "Export project report to PDF",
   "Invite team member by email"
]
```

Assign to: `extractedFeatures.json`

## Present Results to User

```
Extracted N features from [source]:

1. Sign up with email and password
2. Log in with Google
...

Saved as `extractedFeatures.json`. Ready to run `rag-search`.
```

## Troubleshooting

- **Duplicate / near-duplicate entries**: merge them into one representative phrase.
- **Ambiguous features**: extract the narrowest concrete reading; note ambiguity in a comment block after the array.
