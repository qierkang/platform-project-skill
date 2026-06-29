# Name Replacement Rules

Use these rules when deriving a new project from `omni-platform`.

## Required Inputs

- Old slug: `omni-platform`
- New slug: `<base>-platform`
- New base slug: `<base>`
- Old display name: `Omni Platform`
- New display name: generated from the new slug or user-provided project name
- Old Chinese name: `通用平台项目初始化模板`
- New Chinese name: user-provided or inferred

## Replace Text

Replace visible identity in:

- README files
- AGENTS.md
- CLAUDE.md
- START-HERE.md
- package.json files
- docker-compose.yml
- Docker service names
- docs and assets README files
- image prompt notes

## Rename Directories

Rename:

- `omni-platform-front` to `<base>-front`
- `omni-platform-mobile` to `<base>-mobile`
- `omni-platform-server` to `<base>-server`

## Do Not Replace Blindly

Avoid binary files:

- `.png`
- `.jpg`
- `.jpeg`
- `.webp`
- `.pdf`
- `.zip`
- lock files when replacement is not necessary

## Residue Check

After replacement, run:

```bash
rg -n "omni-platform|Omni Platform|通用平台项目初始化模板" <project-path>
```

Remaining hits must be intentional, such as a migration note or template provenance.
