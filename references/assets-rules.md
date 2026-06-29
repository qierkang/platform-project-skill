# Assets Rules

## Principle

Use one root-level `assets/` directory as the visual asset source of truth. Do not create duplicated `assets/` directories inside each subproject unless the existing project already requires that layout.

## Required Image Types for New Platform Projects

- Platform architecture image
- Platform design baseline image
- Front UI design draft
- Front dashboard concept
- Mobile UI design draft
- Mobile home concept
- Server architecture or API topology image

## Bilingual Asset Contract (HARD RULE)

Generate every required image type in both locales:

- `zh-CN`: Simplified Chinese labels for the default root `README.md` and Chinese subproject README files.
- `en`: English labels for `docs/README_en.md`.

Store the locale as the final directory segment before the filename:

```text
assets/platform/architecture/zh-CN/<slug>-overview.png
assets/platform/architecture/en/<slug>-overview.png
assets/<base>-front/design/zh-CN/front-ui-design-draft.png
assets/<base>-front/design/en/front-ui-design-draft.png
```

Keep both versions equivalent in image type, information hierarchy, dimensions, and visual style. Do not place English text in the `zh-CN` version except for code identifiers; do not place Chinese text in the `en` version.

## Image Generation Gate (HARD RULE)

1. Generate final images with `image_gen`, once per required image type and locale.
2. **每张图落盘后立即** 调用 `scripts/register-asset.sh <project> <image-rel-path> [prompt]` 写入 `assets/asset-manifest.json`。
3. Do not use Mermaid, SVG, HTML, screenshots, Graphviz, or local image scripts as substitutes for final visual images unless the user explicitly asks for editable diagrams or code-generated diagrams.
4. 派生项目的图片 sha256 不允许与 `governance/template-image-hashes.json` 中任一条目相同（即"占位图复用"）—— 一旦命中，`verify-assets.sh` 直接 FAIL。
5. 每张登记的图必须被至少一个 README 引用，否则视为"孤儿图"（warn）；未在 manifest 登记却被 README 引用，视为 FAIL。

## Prompt Assets

Use locale-aware prompt templates under `assets/prompts/`:

- `architecture-image-prompt-zh-CN.md`
- `architecture-image-prompt-en.md`
- `ui-design-image-prompt.md`
- `project-baseline-image-prompt.md`

## README References

After generating images:

1. Save them under `assets/`.
2. Update `assets/README.md`.
3. Update the default Chinese root README with `zh-CN` paths.
4. Update `docs/README_en.md` with `en` paths.
5. Update subproject README files when the images are subproject-specific.
6. Ensure image Markdown is not placed in fenced code blocks.
