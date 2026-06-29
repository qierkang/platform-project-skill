# Platform Project Rules

## Naming

- Prefer `<name>-platform` for platform projects.
- Prefer subprojects:
  - `<base-name>-front`
  - `<base-name>-mobile`
  - `<base-name>-server`
- Use lowercase kebab-case for directory names.

## Required Root Files

- `README.md`
- `AGENTS.md`
- `CLAUDE.md`
- `START-HERE.md`
- `assets/`
- `docs/`
- `docker-compose.yml` when deployment is part of the project

## Required Assets Layout

```text
assets/
├── platform/
│   ├── architecture/
│   ├── design/
│   └── flow/
├── <base-name>-front/
│   ├── screenshots/
│   └── design/
├── <base-name>-mobile/
│   ├── screenshots/
│   └── design/
└── <base-name>-server/
    ├── architecture/
    └── api/
```

## Required Docs Layout

```text
docs/
├── requirements/
├── design/
├── architecture/
├── testing/
├── deployment/
├── api/
├── documents/
├── scripts/
└── pages/
```

## AI Token Saving Rules

- Read `AGENTS.md`, `START-HERE.md`, `README.md`, and `docs/INDEX.md` first.
- Do not read all docs by default.
- Do not inspect `node_modules`, `dist`, `tmp`, screenshots, or generated caches unless needed.
- For architecture questions, read `graphify-out/GRAPH_REPORT.md` first when it exists.

## Author Rule

Project-level README files must include:

- `xyqierkang@gmail.com`
- `https://github.com/qierkang`
