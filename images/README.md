# 图像素材

- `header.png`、`footer.png`、`ustc-icon.png` 来自上游科大 LaTeX 模板，使用固定品牌配色。
- `watermark.svg` 包含一份科大校徽 PNG 的 base64 数据，整体透明度为 5%，没有重复保存源 PNG。
- `avatar-placeholder.svg` 是用圆形与路径组成的通用头像占位图，不来自人物照片。可以在自己的副本中将 `content.typ` 的 `photo` 字段改为个人照片路径。

水印 SVG 的原始图像尺寸为 1250 × 1248，`<image>` 使用 `opacity="0.05"`，保留原图 alpha。
调整正文主题色不会重新着色这些固定配色位图；章节 SVG 图标会跟随主题色。
