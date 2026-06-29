# Platform Project Skill Agents Rules

## Role

Use this skill to initialize platform projects or upgrade existing projects with an AI handoff layer.

## Mandatory Rules

1. Classify the target as new project, existing project, or base-derived project before editing.
2. For new projects, prefer the bundled `assets/templates/omni-platform/` template.
3. For existing projects, apply `references/non-invasive-upgrade.md` before writing files.
4. Do not alter existing source structure, build tools, business names, or technology stack during old project upgrades.
5. Generate final visual assets with `image_gen`; do not fake final images with Mermaid, SVG, HTML, screenshots, or local scripts.
6. README display images must use direct Markdown image syntax, not fenced code blocks.
7. Run `scripts/check-project-baseline.sh` before completion.

## Reading Order

1. `SKILL.md`
2. Route-specific workflow under `references/`
3. Rule references needed for the task
4. Scripts only when executing or patching automation

## Output Boundaries

- New project output belongs in the target project directory.
- Existing project upgrade output belongs inside the existing project directory.
- Skill maintenance output belongs inside this skill directory.

## Author

- `xyqierkang@gmail.com`
- `https://github.com/qierkang`

