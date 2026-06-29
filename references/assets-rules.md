# Assets Rules

## Principle

Use one root-level `assets/` directory as the visual asset source of truth. Do not create duplicated `assets/` directories inside each subproject unless the existing project already requires that layout.

## Required Image Types for New Platform Projects

- Platform architecture image
- Platform design baseline image
- Front UI design draft
- Mobile UI design draft
- Server architecture or API topology image when useful

## Image Generation Gate (HARD RULE)

1. Generate final images with `image_gen`.
2. **每张图落盘后立即** 调用 `scripts/register-asset.sh <project> <image-rel-path> [prompt]` 写入 `assets/asset-manifest.json`。
3. Do not use Mermaid, SVG, HTML, screenshots, Graphviz, or local image scripts as substitutes for final visual images unless the user explicitly asks for editable diagrams or code-generated diagrams.
4. 派生项目的图片 sha256 不允许与 `governance/template-image-hashes.json` 中任一条目相同（即"占位图复用"）—— 一旦命中，`verify-assets.sh` 直接 FAIL。
5. 每张登记的图必须被至少一个 README 引用，否则视为"孤儿图"（warn）；未在 manifest 登记却被 README 引用，视为 FAIL。

## Prompt Assets

Use prompt templates under `assets/prompts/`:

- `architecture-image-prompt.md`
- `ui-design-image-prompt.md`
- `project-baseline-image-prompt.md`

## README References

After generating images:

1. Save them under `assets/`.
2. Update `assets/README.md`.
3. Update root README.
4. Update subproject README files when the images are subproject-specific.
5. Ensure image Markdown is not placed in fenced code blocks.

