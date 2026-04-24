---
name: build-re-phases
description: Organize RE-level features into delivery phases for the estimation sheet. Use after `build-re-features` when asked to "organize into phases", "build phases", "create project phases", or "phase the estimate".
---

# Build RE Phases

Distributes `reFeatures.json` across logical delivery phases, producing the final `rePhases.json` structure that drives the Excel export.

## How It Works

1. Read `reFeatures.json` (output of `build-re-features`).
2. Assign each RE-level feature to a delivery phase based on dependency order and business priority.
3. Name each phase clearly (e.g. "Phase 1 — Core", "Phase 2 — Advanced").
4. Output `rePhases.json` — every RE-level feature must appear in exactly one phase.

## Output Shape

```typescript
type RePhaseType = {
   phaseName: string; // e.g. "Phase 1 — Core"
   reFeatures: REFeatureType[];
};
```

Assign to: `rePhases.json`

## Phasing Guidelines

- **Phase 1 — Core**: features required for an MVP (authentication, main CRUD, core user flows).
- **Phase 2 — Extended**: secondary features that depend on Phase 1 (notifications, search, dashboards).
- **Phase 3 — Advanced** (optional): nice-to-haves, integrations, reporting, admin tools.
- Use fewer phases when the project is small (< 15 features → 1–2 phases is fine).
- If the client has explicitly described phases or priorities in the requirements, follow those instead.

## Example

Input (`reFeatures.json`):

```json
[
  { "reLevelFeatureName": "Authentication", "coreFeatures": [...] },
  { "reLevelFeatureName": "Dashboard", "coreFeatures": [...] },
  { "reLevelFeatureName": "Reporting", "coreFeatures": [...] },
  { "reLevelFeatureName": "Admin Panel", "coreFeatures": [...] }
]
```

Output:

```json
[
  {
    "phaseName": "Phase 1 — Core",
    "reFeatures": [
      { "reLevelFeatureName": "Authentication", "coreFeatures": [...] },
      { "reLevelFeatureName": "Dashboard", "coreFeatures": [...] }
    ]
  },
  {
    "phaseName": "Phase 2 — Advanced",
    "reFeatures": [
      { "reLevelFeatureName": "Reporting", "coreFeatures": [...] },
      { "reLevelFeatureName": "Admin Panel", "coreFeatures": [...] }
    ]
  }
]
```

## Present Results to User

```
Built N phases from M RE-level features:

Phase 1 — Core (3 RE-features, 12 core features)
  - Authentication, Dashboard, User Profile

Phase 2 — Advanced (2 RE-features, 7 core features)
  - Reporting, Admin Panel

Saved as `rePhases.json`. Ready to run `export-excel`.
```

## Troubleshooting

- **Only one logical phase**: a single-phase `rePhases.json` is valid — do not force artificial splits.
- **Client-defined phases**: if the requirements explicitly state phases, use those names and groupings verbatim.
