# Agent 维护指南

## 项目概况

这是一个非官方中国科学技术大学风格的中文 Typst 简历模板，准备供 GitHub 用户直接使用。
项目优先保持简单：只有两个 Typst 文件，用户修改 `content.typ` 就能填写内容和调整外观。
默认示例使用虚构资料、通用头像、思源黑体和 standard 密度。

## 文件职责

| 文件或目录 | 用途 |
| --- | --- |
| `content.typ` | 唯一编译入口；依次定义简历数据 `resume`、用户参数 `settings`，最后调用 `ustc-resume(resume, settings)` |
| `theme.typ` | 导出 `ustc-resume`；实现字体选择、参数校验、个人信息、章节、条目、分页和页眉页脚 |
| `fonts/` | 官方思源黑体/宋体 Regular、Bold，完整 OFL 许可和来源哈希 |
| `icons/` | 单色 SVG 图标及许可，编译时按主题色着色 |
| `images/` | 科大页眉页脚、校标、水印、通用头像和 README 的四种公开预览 |
| `README.md` | 面向用户的简短说明和编译命令 |

不要新增入口、配置、组件等 Typst 文件，也不要向模板中添加构建脚本或测试工程。

## 如何选择修改位置

- 改信息或经历：修改 `content.typ` 前半部分的 `resume`。
- 改字体、字号、密度、颜色、页边距或某一节的间距：修改同文件后半部分的 `settings`。
- 改布局逻辑、增加字段支持或修复换行分页：才修改 `theme.typ`。
- 新增用户可调参数时，将默认值和中文说明放进 `content.typ`，在 `theme.typ` 中读取使用。

保持“简历内容在前、参数在后、生成调用在最后”的顺序。参数注释应说明用途、单位或可选值。
用户可能已经编辑了示例内容；只修改任务涉及的部分，不用旧版本覆盖整份文件。

## 常用参数速查

| 需求 | `settings` 中的位置 |
| --- | --- |
| 黑体 / 宋体 | `font`：`sans` / `serif` |
| 整体松紧 | `style`：`compact` / `standard` / `relaxed` |
| 描述正文字号 | `font-size`，当前默认 10pt |
| 论文、项目、比赛名称字号 | `entry-title-size`，当前默认 11pt，加粗显示 |
| 章节标题字号，如“论文成果” | `section-size`，不要与条目标题混淆 |
| 姓名和身份介绍字号 | `name-size`、`tagline-size` |
| 强调色 | `accent`；文字、横线和图标跟随，页眉页脚图片不重新着色 |
| 页边距、页数限制 | `margins`、`max-pages`；0 不限页数，正整数为页数上限 |
| 照片与信息区 | `photo-width`、`photo-gap`、`info-row-gap`、`info-column-gap` |
| 校徽背景 | `show-watermark`、`watermark-width` |
| 章节顺序、隐藏或改名 | `sections`、`section-titles` |

个人照片在 `resume.photo` 指定，设为 `none` 则不显示。
其他可选个人字段可省略或设为 `none`，空章节自动隐藏；`resume.details` 可以自定义信息表。
章节标识固定为 `education`、`papers`、`projects`、`awards`、`summary`。

## 间距调整

先选择合适的 `style`，再按需局部微调。覆盖优先级从低到高为：

`density-presets` → `global-spacing` → `section-spacing` → 单条目的 `spacing`。

- `density-presets`：三种密度的完整数值；修改某一档的整体设计时使用。
- `global-spacing`：覆盖所有章节的指定参数。
- `section-spacing.papers` / `.projects` / `.awards` 等：只调整指定章节。
- `resume` 中某个论文、项目、比赛条目的 `spacing`：只调整该条目。
- `(:)` 表示没有覆盖值，继续继承上层设置。

| 参数 | 含义 |
| --- | --- |
| `line-height` | 正文基线行高，不能小于 `font-size` |
| `paragraph-gap` | 同一条目内段落之间的空白 |
| `entry-gap` | 当前条目前的额外空白；章节首条由章节间距控制 |
| `header-gap` | 条目标题、状态和正文之间的空白 |
| `section-above` | 章节标题前的空白 |
| `section-below` | 章节横线与正文之间的空白 |
| `section-after` | 整个章节结束后的额外空白 |

间距使用非负长度，通常用 pt。单条目只支持前四个参数。
保留三档预设及各自七个参数，不通过缩小字号或强制换行代替合理的间距调整。
密度不自动填满一页，内容增多时允许自然分页；有单页要求时用 `max-pages: 1` 检查。

## 编译与检查

需要 Typst 0.15.1 或更高版本。在项目根目录执行：

```sh
typst compile --ignore-system-fonts --font-path fonts content.typ resume.pdf
```

需要 PNG 预览时执行：

```sh
typst compile --ignore-system-fonts --font-path fonts --format png --ppi 154 content.typ 'resume-{p}.png'
```

修改内容、参数或排版实现后，检查实际 PDF/PNG：标题层级、长标题换行、日期对齐、条目分隔、分页及页脚遮挡。
标题应跟随正文起始，超长正文仍可跨页。保持原生文字和语义化章节标题。
影响字体、密度或分页时，再验证相关字体/密度组合或长内容场景；临时验证文件放在项目外。
仅改说明文档时，核对说明与实际代码一致即可。

公开预览统一保存在 `images/`，不使用 `docs/` 目录。README 展示以下四种组合：

- `preview-standard-sans.png`：standard + 思源黑体。
- `preview-standard-serif.png`：standard + 思源宋体。
- `preview-relaxed-sans.png`：relaxed + 思源黑体。
- `preview-relaxed-serif.png`：relaxed + 思源宋体。

更新时使用同一份当前虚构示例，以 154 ppi 导出四种组合。可在项目外临时副本中更改 `font`、`style`，避免覆盖用户在 `content.typ` 中选择的默认参数。检查四张图片后同步更新 README 引用。
PDF 和临时渲染结果不进入 Git；生成文件的忽略规则见 `.gitignore`。

## 公开素材与许可

公开示例和预览只使用虚构资料，不从相邻目录导入真实简历、照片、联系方式、私人路径或历史输出。
保持代码 MIT 署名、字体完整 OFL、图标许可及素材来源；字体和图标不因代码的 MIT 许可而改变授权。
