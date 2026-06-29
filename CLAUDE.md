# Platform Project Skill Claude Rules

This skill supports two workflows:

- Create new platform projects from the bundled `omni-platform` template.
- Upgrade existing projects with README, AGENTS, CLAUDE, assets, docs, and graphify handoff layers without changing the original project shape.

Follow `SKILL.md` first, then load only the route-specific files from `references/`.

For old projects, never move source code, rename business folders, replace the tech stack, or format the whole repository unless the user explicitly asks.

For project images, use `image_gen` for final visual assets. Keep README images renderable by writing `![label](path)` directly.

