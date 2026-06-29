# Existing Project Upgrade Workflow

Use this workflow when the target directory already contains a project.

## Goal

Add an AI collaboration and handoff layer without changing the existing project shape.

## Required First Reads

- `references/non-invasive-upgrade.md`
- `references/readme-rules.md`
- `references/assets-rules.md`
- `references/graphify-rules.md`

## Steps

1. Inspect the target project with `scripts/inspect-project.sh <project-path>`.
2. Determine project shape:
   - single repository
   - front/back split
   - monorepo
   - multi-service family
   - existing template-derived project
3. Identify existing files:
   - README
   - AGENTS
   - CLAUDE
   - assets
   - docs
   - graphify-out
   - Docker or deployment entry
4. Build an upgrade plan before editing. Prefer additions over rewrites.
5. Add missing AI handoff files:
   - `AGENTS.md`
   - `CLAUDE.md`
   - `START-HERE.md`
   - `docs/ai-upgrade/report-老项目AI能力升级.md`
6. Enhance README only when safe:
   - If README is missing, create a complete README.
   - If README exists, preserve existing business content and append missing sections.
   - If a full rewrite is needed, ask or create a backup first.
7. Add assets:
   - `assets/platform/architecture/`
   - `assets/platform/design/`
   - `assets/platform/flow/`
   - project-specific subfolders when needed
8. Generate final visual assets with `image_gen` and reference them from README.
9. Generate or refresh graphify only when it helps codebase understanding.
10. Run the baseline checker and README gate.
    - Use `scripts/check-project-baseline.sh --existing <project-path>` for existing projects.
    - Treat existing `node_modules`, `dist`, or `.DS_Store` as cleanup recommendations, not automatic deletion targets.

## Output Contract

Existing project upgrades should produce:

- A concise upgrade report
- Missing AI handoff files
- Renderable README images when visual assets are added
- A clear list of intentionally unchanged areas
- A risk list for future work

## Stop Conditions

Stop and ask before:

- Moving or renaming source directories
- Replacing framework/build/deployment systems
- Formatting the entire repository
- Deleting existing documentation or scripts
- Overwriting an existing README without backup
