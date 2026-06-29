# Graphify Rules

## Purpose

Use graphify to help future AI agents understand code structure, god nodes, and module communities.

## When to Generate

Generate or refresh graphify when:

- The project is an existing codebase with meaningful source files.
- The user asks for architecture analysis or code map refresh.
- A new project has enough code to make graphify useful.
- A lifecycle checkpoint requires structure evidence.

Skip graphify when:

- The project is empty or only a documentation template.
- The task is purely documentation cleanup.
- The generated graph would be noise.

## Expected Output

Prefer:

```text
graphify-out/GRAPH_REPORT.md
```

If graphify uses a public output directory or symlink pattern, record the actual path in `AGENTS.md` and `START-HERE.md`.

## Reading Rule

For architecture or codebase questions, read `graphify-out/GRAPH_REPORT.md` before scanning raw files.

